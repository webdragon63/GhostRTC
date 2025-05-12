#!/bin/bash

# WebRTC leak check via browserleaks.com
VERMILION='\033[1;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[1;36m'
WHITE='\033[0;37m'

echo -e "${GREEN}🔍 Checking for WebRTC leaks..."

# Check if curl is installed
if ! command -v curl &> /dev/null; then
  echo "❌ curl not installed. Install it with: sudo apt install curl"
  exit 1
fi

# Fetch HTML content from browserleaks.com/webrtc
LEAK_RESULT=$(curl -s https://browserleaks.com/webrtc)

# Extract IP-like patterns (IPv4)
LEAKED_IPS=$(echo "$LEAK_RESULT" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq)

# Optionally filter known Tor/VirtualBox ranges if desired
if [[ -z "$LEAKED_IPS" ]]; then
  echo -e "${GREEN}✅ No WebRTC IPs detected in HTML content."
else
  echo -e "${VERMILION}⚠️ Possible WebRTC IPs detected:"
  echo -e "${VERMILION}⚠️ Your WebRTC IP is ➡️ ${WHITE}$LEAKED_IPS"
  echo -e "${VERMILION}➡️  Your browser may be leaking your local or public IP!"
  echo -e "${CYAN}🔧 Disable WebRTC in your browser settings for better anonymity."
  echo -e "${CYAN}🔧 To Disable WebRTC in your browser settings for better anonymity:"
  echo -e "   └──╼ 1. Open ${WHITE}about:config ${CYAN}in the address bar of your firefox browser"
  echo -e "   └──╼ 2. Search: ${WHITE}media.peerconnection.enabled${CYAN}"
  echo -e "   └──╼ 3. Set it to ${WHITE}false"
fi
