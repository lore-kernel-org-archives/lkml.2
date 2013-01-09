Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab3AIUiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:08 -0500
Received: from mail.kernel.org ([198.145.19.201]:41897 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173Ab3AIUiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 14/80] b43: fix tx path skb leaks
Date: Wed,  9 Jan 2013 12:35:06 -0800
Message-Id: <20130109201502.212799346@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 78f18df4b323d2ac14d6c82e2fc3c8dc4556bccc upstream.

ieee80211_free_txskb() needs to be used instead of dev_kfree_skb_any for
tx packets passed to the driver from mac80211

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43/dma.c  |    7 +++++--
 drivers/net/wireless/b43/main.c |   12 ++++++++----
 drivers/net/wireless/b43/pio.c  |    4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -409,7 +409,10 @@ static inline
 				struct b43_dmadesc_meta *meta)
 {
 	if (meta->skb) {
-		dev_kfree_skb_any(meta->skb);
+		if (ring->tx)
+			ieee80211_free_txskb(ring->dev->wl->hw, meta->skb);
+		else
+			dev_kfree_skb_any(meta->skb);
 		meta->skb = NULL;
 	}
 }
@@ -1454,7 +1457,7 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(dev->wl->hw, skb);
 		err = 0;
 		goto out;
 	}
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3393,7 +3393,7 @@ static void b43_tx_work(struct work_stru
 				break;
 			}
 			if (unlikely(err))
-				dev_kfree_skb(skb); /* Drop it */
+				ieee80211_free_txskb(wl->hw, skb);
 			err = 0;
 		}
 
@@ -3414,7 +3414,7 @@ static void b43_op_tx(struct ieee80211_h
 
 	if (unlikely(skb->len < 2 + 2 + 6)) {
 		/* Too short, this can't be a valid frame. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
@@ -4210,8 +4210,12 @@ redo:
 
 	/* Drain all TX queues. */
 	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
-		while (skb_queue_len(&wl->tx_queue[queue_num]))
-			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
+		while (skb_queue_len(&wl->tx_queue[queue_num])) {
+			struct sk_buff *skb;
+
+			skb = skb_dequeue(&wl->tx_queue[queue_num]);
+			ieee80211_free_txskb(wl->hw, skb);
+		}
 	}
 
 	b43_mac_suspend(dev);
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -196,7 +196,7 @@ static void b43_pio_cancel_tx_packets(st
 	for (i = 0; i < ARRAY_SIZE(q->packets); i++) {
 		pack = &(q->packets[i]);
 		if (pack->skb) {
-			dev_kfree_skb_any(pack->skb);
+			ieee80211_free_txskb(q->dev->wl->hw, pack->skb);
 			pack->skb = NULL;
 		}
 	}
@@ -552,7 +552,7 @@ int b43_pio_tx(struct b43_wldev *dev, st
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(dev->wl->hw, skb);
 		err = 0;
 		goto out;
 	}


