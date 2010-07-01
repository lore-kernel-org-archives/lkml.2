Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab0GAVGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:06:11 -0400
Received: from kroah.org ([198.145.64.141]:47809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932810Ab0GAUvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:05 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:36 2010
Message-Id: <20100701173436.917115389@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [patch 120/164] wireless: report reasonable bitrate for MCS rates through wext
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John W. Linville <linville@tuxdriver.com>

commit 254416aae70ab2e6b57fd79782c8a67196234d02 upstream.

Previously, cfg80211 had reported "0" for MCS (i.e. 802.11n) bitrates
through the wireless extensions interface.  However, nl80211 was
converting MCS rates into a reasonable bitrate number.  This patch moves
the nl80211 code to cfg80211 where it is now shared between both the
nl80211 interface and the wireless extensions interface.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -378,6 +378,8 @@ int rdev_set_freq(struct cfg80211_registered_device *rdev,
 		  struct wireless_dev *for_wdev,
 		  int freq, enum nl80211_channel_type channel_type);
 
+u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a602843..7cb0d64 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1637,39 +1637,6 @@ static int parse_station_flags(struct genl_info *info,
 	return 0;
 }
 
-static u16 nl80211_calculate_bitrate(struct rate_info *rate)
-{
-	int modulation, streams, bitrate;
-
-	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
-		return rate->legacy;
-
-	/* the formula below does only work for MCS values smaller than 32 */
-	if (rate->mcs >= 32)
-		return 0;
-
-	modulation = rate->mcs & 7;
-	streams = (rate->mcs >> 3) + 1;
-
-	bitrate = (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
-			13500000 : 6500000;
-
-	if (modulation < 4)
-		bitrate *= (modulation + 1);
-	else if (modulation == 4)
-		bitrate *= (modulation + 2);
-	else
-		bitrate *= (modulation + 3);
-
-	bitrate *= streams;
-
-	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
-		bitrate = (bitrate / 9) * 10;
-
-	/* do NOT round down here */
-	return (bitrate + 50000) / 100000;
-}
-
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				u8 *mac_addr, struct station_info *sinfo)
@@ -1716,8 +1683,8 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 		if (!txrate)
 			goto nla_put_failure;
 
-		/* nl80211_calculate_bitrate will return 0 for mcs >= 32 */
-		bitrate = nl80211_calculate_bitrate(&sinfo->txrate);
+		/* cfg80211_calculate_bitrate will return 0 for mcs >= 32 */
+		bitrate = cfg80211_calculate_bitrate(&sinfo->txrate);
 		if (bitrate > 0)
 			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 59361fd..a3c841a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -720,3 +720,36 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 
 	return err;
 }
+
+u16 cfg80211_calculate_bitrate(struct rate_info *rate)
+{
+	int modulation, streams, bitrate;
+
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
+		return rate->legacy;
+
+	/* the formula below does only work for MCS values smaller than 32 */
+	if (rate->mcs >= 32)
+		return 0;
+
+	modulation = rate->mcs & 7;
+	streams = (rate->mcs >> 3) + 1;
+
+	bitrate = (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
+			13500000 : 6500000;
+
+	if (modulation < 4)
+		bitrate *= (modulation + 1);
+	else if (modulation == 4)
+		bitrate *= (modulation + 2);
+	else
+		bitrate *= (modulation + 3);
+
+	bitrate *= streams;
+
+	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
+		bitrate = (bitrate / 9) * 10;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 584eb48..2fa8de1 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1256,10 +1256,7 @@ int cfg80211_wext_giwrate(struct net_device *dev,
 	if (!(sinfo.filled & STATION_INFO_TX_BITRATE))
 		return -EOPNOTSUPP;
 
-	rate->value = 0;
-
-	if (!(sinfo.txrate.flags & RATE_INFO_FLAGS_MCS))
-		rate->value = 100000 * sinfo.txrate.legacy;
+	rate->value = 100000 * cfg80211_calculate_bitrate(&sinfo.txrate);
 
 	return 0;
 }


