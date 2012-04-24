Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2DXOAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:00:40 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39974 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab2DXOAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:00:39 -0400
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: Release struct returned by cfg80211_inform_bss to avoid potential memory leak.
Date: Tue, 24 Apr 2012 15:00:34 +0100
Message-Id: <1335276034-12735-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function cfg80211_inform_bss returns a pointer to a referenced struct cfg80211_bss
but no information is needed from this struct in function prism2_scan and therefore
we release it by calling cfg80211_put_bss.

Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
---
 drivers/staging/wlan-ng/cfg80211.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index 4cd3ba5..8bc562b 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -332,6 +332,7 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 	wlandevice_t *wlandev = dev->ml_priv;
 	struct p80211msg_dot11req_scan msg1;
 	struct p80211msg_dot11req_scan_results msg2;
+	struct cfg80211_bss *bss;
 	int result;
 	int err = 0;
 	int numbss = 0;
@@ -401,7 +402,7 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 		ie_buf[1] = msg2.ssid.data.len;
 		ie_len = ie_buf[1] + 2;
 		memcpy(&ie_buf[2], &(msg2.ssid.data.data), msg2.ssid.data.len);
-		cfg80211_inform_bss(wiphy,
+		bss = cfg80211_inform_bss(wiphy,
 			ieee80211_get_channel(wiphy, ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
 			(const u8 *) &(msg2.bssid.data.data),
 			msg2.timestamp.data, msg2.capinfo.data,
@@ -411,6 +412,13 @@ int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
 			(msg2.signal.data - 65536) * 100, /* Conversion to signed type */
 			GFP_KERNEL
 		);
+
+		if (!bss) {
+			err = -ENOMEM;
+			goto exit;
+		}
+
+		cfg80211_put_bss(bss);
 	}
 
 	if (result)
-- 
1.7.2.5

