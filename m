Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2KZSMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:12:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756614Ab2KZRDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:07 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 054/270] mac80211: use ieee80211_free_txskb to fix possible skb leaks
Date: Mon, 26 Nov 2012 14:55:44 -0200
Message-Id: <1353949160-26803-55-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit c3e7724b6bc2f25e46c38dbe68f09d71fafeafb8 upstream.

A few places free skbs using dev_kfree_skb even though they're called
after ieee80211_subif_start_xmit might have cloned it for tracking tx
status. Use ieee80211_free_txskb here to prevent skb leaks.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/status.c |    4 ++--
 net/mac80211/tx.c     |   22 ++++++++++++----------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 28cfa98..d64dc07 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -34,7 +34,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 		skb_queue_len(&local->skb_queue_unreliable);
 	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
-		dev_kfree_skb_irq(skb);
+		ieee80211_free_txskb(hw, skb);
 		tmp--;
 		I802_DEBUG_INC(local->tx_status_drop);
 	}
@@ -162,7 +162,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 			    skb_queue_len(&sta->tx_filtered[ac]),
 			    !!test_sta_flag(sta, WLAN_STA_PS_STA), jiffies);
 #endif
-	dev_kfree_skb(skb);
+	ieee80211_free_txskb(&local->hw, skb);
 }
 
 static void ieee80211_check_pending_bar(struct sta_info *sta, u8 *addr, u8 tid)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 85cf32d..a22a1ad 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -358,7 +358,7 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 			total += skb_queue_len(&sta->ps_tx_buf[ac]);
 			if (skb) {
 				purged++;
-				dev_kfree_skb(skb);
+				ieee80211_free_txskb(&local->hw, skb);
 				break;
 			}
 		}
@@ -478,7 +478,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 			net_dbg_ratelimited("%s: STA %pM TX buffer for AC %d full - dropping oldest frame\n",
 					    tx->sdata->name, sta->sta.addr, ac);
 #endif
-			dev_kfree_skb(old);
+			ieee80211_free_txskb(&local->hw, old);
 		} else
 			tx->local->total_ps_buffered++;
 
@@ -1112,7 +1112,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		spin_unlock(&tx->sta->lock);
 
 		if (purge_skb)
-			dev_kfree_skb(purge_skb);
+			ieee80211_free_txskb(&tx->local->hw, purge_skb);
 	}
 
 	/* reset session timer */
@@ -1223,7 +1223,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (WARN_ON_ONCE(q >= local->hw.queues)) {
 			__skb_unlink(skb, skbs);
-			dev_kfree_skb(skb);
+			ieee80211_free_txskb(&local->hw, skb);
 			continue;
 		}
 #endif
@@ -1368,7 +1368,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	if (unlikely(res == TX_DROP)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_drop);
 		if (tx->skb)
-			dev_kfree_skb(tx->skb);
+			ieee80211_free_txskb(&tx->local->hw, tx->skb);
 		else
 			__skb_queue_purge(&tx->skbs);
 		return -1;
@@ -1405,7 +1405,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 	res_prepare = ieee80211_tx_prepare(sdata, &tx, skb);
 
 	if (unlikely(res_prepare == TX_DROP)) {
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 		goto out;
 	} else if (unlikely(res_prepare == TX_QUEUED)) {
 		goto out;
@@ -1478,7 +1478,7 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	headroom = max_t(int, 0, headroom);
 
 	if (ieee80211_skb_resize(sdata, skb, headroom, may_encrypt)) {
-		dev_kfree_skb(skb);
+		ieee80211_free_txskb(&local->hw, skb);
 		rcu_read_unlock();
 		return;
 	}
@@ -2075,8 +2075,10 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		head_need += IEEE80211_ENCRYPT_HEADROOM;
 		head_need += local->tx_headroom;
 		head_need = max_t(int, 0, head_need);
-		if (ieee80211_skb_resize(sdata, skb, head_need, true))
-			goto fail;
+		if (ieee80211_skb_resize(sdata, skb, head_need, true)) {
+			ieee80211_free_txskb(&local->hw, skb);
+			return NETDEV_TX_OK;
+		}
 	}
 
 	if (encaps_data) {
@@ -2211,7 +2213,7 @@ void ieee80211_tx_pending(unsigned long data)
 			struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 			if (WARN_ON(!info->control.vif)) {
-				kfree_skb(skb);
+				ieee80211_free_txskb(&local->hw, skb);
 				continue;
 			}
 
-- 
1.7.9.5

