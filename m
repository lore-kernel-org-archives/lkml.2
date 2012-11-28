Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab2K1NUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:20:46 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:61055 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab2K1NUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:20:44 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 6/8] staging/rtl8187se: Use netdev_ printks in ieee80211/ieee80211_rx.c
Date: Wed, 28 Nov 2012 22:20:40 +0900
Message-Id: <1354108840-17728-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
References: <1354108550-17553-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c |   23 ++++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 43e344a..f14901d 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -308,9 +308,9 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 	if (ieee->tkip_countermeasures &&
 	    strcmp(crypt->ops->name, "TKIP") == 0) {
 		if (net_ratelimit()) {
-			printk(KERN_DEBUG "%s: TKIP countermeasures: dropped "
-			       "received packet from %pM\n",
-			       ieee->dev->name, hdr->addr2);
+			netdev_dbg(ieee->dev,
+				   "TKIP countermeasures: dropped received packet from %pM\n",
+				   ieee->dev->name, hdr->addr2);
 		}
 		return -1;
 	}
@@ -353,9 +353,9 @@ ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device *ieee, struct sk_buff *s
 	res = crypt->ops->decrypt_msdu(skb, keyidx, hdrlen, crypt->priv);
 	atomic_dec(&crypt->refcnt);
 	if (res < 0) {
-		printk(KERN_DEBUG "%s: MSDU decryption/MIC verification failed"
-		       " (SA=%pM keyidx=%d)\n",
-		       ieee->dev->name, hdr->addr2, keyidx);
+		netdev_dbg(ieee->dev,
+			   "MSDU decryption/MIC verification failed (SA=%pM keyidx=%d)\n",
+			   hdr->addr2, keyidx);
 		return -1;
 	}
 
@@ -409,7 +409,8 @@ static int is_duplicate_packet(struct ieee80211_device *ieee,
 		if (p == &ieee->ibss_mac_hash[index]) {
 			entry = kmalloc(sizeof(struct ieee_ibss_seq), GFP_ATOMIC);
 			if (!entry) {
-				printk(KERN_WARNING "Cannot malloc new mac entry\n");
+				netdev_warn(ieee->dev,
+					    "Cannot malloc new mac entry\n");
 				return 0;
 			}
 			memcpy(entry->mac, mac, ETH_ALEN);
@@ -491,8 +492,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	stats = &ieee->stats;
 
 	if (skb->len < 10) {
-		printk(KERN_INFO "%s: SKB length < 10\n",
-		       dev->name);
+		netdev_info(ieee->dev, "SKB length < 10\n");
 		goto rx_dropped;
 	}
 
@@ -646,9 +646,8 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 			flen -= hdrlen;
 
 		if (frag_skb->tail + flen > frag_skb->end) {
-			printk(KERN_WARNING "%s: host decrypted and "
-			       "reassembled frame did not fit skb\n",
-			       dev->name);
+			netdev_warn(ieee->dev,
+				    "host decrypted and reassembled frame did not fit skb\n");
 			ieee80211_frag_cache_invalidate(ieee, hdr);
 			goto rx_dropped;
 		}
-- 
1.7.9.5

