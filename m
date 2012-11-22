Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab2KVVfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:35:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:49645 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2KVSkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 06/83] mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge
Date: Wed, 21 Nov 2012 16:41:28 -0800
Message-Id: <20121122004213.112705458@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1f98ab7fef48a2968f37f422c256c9fbd978c3f0 upstream.

Fixes more wifi status skb leaks, leading to hostapd/wpa_supplicant hangs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/sta_info.c    |    6 +++---
 net/mac80211/status.c      |    9 +++++++++
 net/mac80211/tx.c          |    9 ++++++---
 4 files changed, 20 insertions(+), 6 deletions(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1304,6 +1304,8 @@ netdev_tx_t ieee80211_monitor_start_xmit
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -730,8 +730,8 @@ int __must_check __sta_info_destroy(stru
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->tx_filtered[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->ps_tx_buf[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->tx_filtered[ac]);
 	}
 
 #ifdef CONFIG_MAC80211_MESH
@@ -765,7 +765,7 @@ int __must_check __sta_info_destroy(stru
 		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
 		if (!tid_tx)
 			continue;
-		__skb_queue_purge(&tid_tx->pending);
+		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
 		kfree(tid_tx);
 	}
 
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -648,3 +648,12 @@ void ieee80211_free_txskb(struct ieee802
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL(ieee80211_free_txskb);
+
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(skbs)))
+		ieee80211_free_txskb(hw, skb);
+}
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1358,7 +1358,7 @@ static int invoke_tx_handlers(struct iee
 		if (tx->skb)
 			ieee80211_free_txskb(&tx->local->hw, tx->skb);
 		else
-			__skb_queue_purge(&tx->skbs);
+			ieee80211_purge_tx_queue(&tx->local->hw, &tx->skbs);
 		return -1;
 	} else if (unlikely(res == TX_QUEUED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_queued);
@@ -2132,10 +2132,13 @@ netdev_tx_t ieee80211_subif_start_xmit(s
  */
 void ieee80211_clear_tx_pending(struct ieee80211_local *local)
 {
+	struct sk_buff *skb;
 	int i;
 
-	for (i = 0; i < local->hw.queues; i++)
-		skb_queue_purge(&local->pending[i]);
+	for (i = 0; i < local->hw.queues; i++) {
+		while ((skb = skb_dequeue(&local->pending[i])) != NULL)
+			ieee80211_free_txskb(&local->hw, skb);
+	}
 }
 
 /*


