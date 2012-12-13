Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2LMOBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:01:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2LMOBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Stewart <pstew@chromium.org>, Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 005/241] mac80211: use blacklist for duplicate IE check
Date: Thu, 13 Dec 2012 11:56:10 -0200
Message-Id: <1355407206-17100-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

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
[ herton: dropped WLAN_EID_VHT_CAPABILITY and WLAN_EID_VHT_OPERATION
  choices, not present in 3.5 ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/util.c |   40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 92d84f5..9ff0a85 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -628,13 +628,39 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
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
-- 
1.7.9.5

