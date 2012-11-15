Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993191Ab2KOEjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:39:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:48846 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992886Ab2KOELH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:11:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 15/66] mac80211: use blacklist for duplicate IE check
Date: Wed, 14 Nov 2012 20:10:20 -0800
Message-Id: <20121115040940.115121822@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040939.016421011@linuxfoundation.org>
References: <20121115040939.016421011@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 9690fb169b433a66485c808e4fc352b8a0f8d866 upstream.

Instead of the current whitelist which accepts duplicates
only for the quiet and vendor IEs, use a blacklist of all
IEs (that we currently parse) that can't be duplicated.

This avoids detecting a beacon as corrupt in the future
when new IEs are added that can be duplicated.

Signed-off-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |   42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -637,13 +637,41 @@ u32 ieee802_11_parse_elems_crc(u8 *start
 			break;
 		}
 
-		if (id != WLAN_EID_VENDOR_SPECIFIC &&
-		    id != WLAN_EID_QUIET &&
-		    test_bit(id, seen_elems)) {
-			elems->parse_error = true;
-			left -= elen;
-			pos += elen;
-			continue;
+		switch (id) {
+		case WLAN_EID_SSID:
+		case WLAN_EID_SUPP_RATES:
+		case WLAN_EID_FH_PARAMS:
+		case WLAN_EID_DS_PARAMS:
+		case WLAN_EID_CF_PARAMS:
+		case WLAN_EID_TIM:
+		case WLAN_EID_IBSS_PARAMS:
+		case WLAN_EID_CHALLENGE:
+		case WLAN_EID_RSN:
+		case WLAN_EID_ERP_INFO:
+		case WLAN_EID_EXT_SUPP_RATES:
+		case WLAN_EID_HT_CAPABILITY:
+		case WLAN_EID_HT_OPERATION:
+		case WLAN_EID_VHT_CAPABILITY:
+		case WLAN_EID_VHT_OPERATION:
+		case WLAN_EID_MESH_ID:
+		case WLAN_EID_MESH_CONFIG:
+		case WLAN_EID_PEER_MGMT:
+		case WLAN_EID_PREQ:
+		case WLAN_EID_PREP:
+		case WLAN_EID_PERR:
+		case WLAN_EID_RANN:
+		case WLAN_EID_CHANNEL_SWITCH:
+		case WLAN_EID_EXT_CHANSWITCH_ANN:
+		case WLAN_EID_COUNTRY:
+		case WLAN_EID_PWR_CONSTRAINT:
+		case WLAN_EID_TIMEOUT_INTERVAL:
+			if (test_bit(id, seen_elems)) {
+				elems->parse_error = true;
+				left -= elen;
+				pos += elen;
+				continue;
+			}
+			break;
 		}
 
 		if (calc_crc && id < 64 && (filter & (1ULL << id)))


