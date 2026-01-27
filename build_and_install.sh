#!/bin/bash
set -e

# Add common Go paths to PATH just in case
export PATH=$HOME/Android/Sdk/build-tools/36.1.0:$HOME/sdk/go/bin:$PATH:/usr/local/go/bin:$HOME/go/bin

echo "Checking for Go..."
if ! command -v go &> /dev/null; then
    echo "Error: 'go' command not found. Please ensure Go is installed and in your PATH."
    exit 1
fi

echo "Generating assets..."
go generate ./app

echo "Building patched APK..."
# Assuming the input APK is downloaded by go generate to app/Lithium_0.24.5.apk
if [ ! -f "app/Lithium_0.24.5.apk" ]; then
    echo "Input APK not found. Trying to download manually via go generate..."
    # go generate should have done it.
fi

go run . app/Lithium_0.24.5.apk

echo "Installing to device..."
OUTPUT_APK="app/Lithium_0.24.5.patched.resigned.apk"

if [ ! -f "$OUTPUT_APK" ]; then
    echo "Error: Output APK $OUTPUT_APK not found."
    exit 1
fi

adb install -r "$OUTPUT_APK"
echo "Success! App installed."
