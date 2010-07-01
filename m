Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413Ab0GASdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:33:42 -0400
Received: from kroah.org ([198.145.64.141]:40724 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757799Ab0GASYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:07 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:16 2010
Message-Id: <20100701173216.174689046@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>,
       Ben Hutchings <ben@decadent.org.uk>
Subject: [patch 111/149] wireless: report reasonable bitrate for MCS rates through wext
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/wireless/core.h        |    2 ++
 net/wireless/nl80211.c     |   37 ++-----------------------------------
 net/wireless/util.c        |   33 +++++++++++++++++++++++++++++++++
 net/wireless/wext-compat.c |    5 +----
 4 files changed, 38 insertions(+), 39 deletions(-)

--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -385,6 +385,8 @@ int rdev_set_freq(struct cfg80211_regist
 		  struct wireless_dev *for_wdev,
 		  int freq, enum nl80211_channel_type channel_type);
 
+u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1562,39 +1562,6 @@ static int parse_station_flags(struct ge
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
@@ -1641,8 +1608,8 @@ static int nl80211_send_station(struct s
 		if (!txrate)
 			goto nla_put_failure;
 
-		/* nl80211_calculate_bitrate will return 0 for mcs >= 32 */
-		bitrate = nl80211_calculate_bitrate(&sinfo->txrate);
+		/* cfg80211_calculate_bitrate will return 0 for mcs >= 32 */
+		bitrate = cfg80211_calculate_bitrate(&sinfo->txrate);
 		if (bitrate > 0)
 			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
 
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -682,3 +682,36 @@ int cfg80211_change_iface(struct cfg8021
 
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
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1227,10 +1227,7 @@ int cfg80211_wext_giwrate(struct net_dev
 	if (!(sinfo.filled & STATION_INFO_TX_BITRATE))
 		return -EOPNOTSUPP;
 
-	rate->value = 0;
-
-	if (!(sinfo.txrate.flags & RATE_INFO_FLAGS_MCS))
-		rate->value = 100000 * sinfo.txrate.legacy;
+	rate->value = 100000 * cfg80211_calculate_bitrate(&sinfo.txrate);
 
 	return 0;
 }


