Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab2KVSij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:38:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:49343 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460Ab2KVSi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 005/171] mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge
Date: Wed, 21 Nov 2012 16:39:11 -0800
Message-Id: <20121122004033.851942485@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1297,6 +1297,8 @@ netdev_tx_t ieee80211_monitor_start_xmit
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs);
 
 /* HT */
 bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata);
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -738,8 +738,8 @@ int __must_check __sta_info_destroy(stru
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->tx_filtered[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->ps_tx_buf[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->tx_filtered[ac]);
 	}
 
 #ifdef CONFIG_MAC80211_MESH
@@ -774,7 +774,7 @@ int __must_check __sta_info_destroy(stru
 		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
 		if (!tid_tx)
 			continue;
-		__skb_queue_purge(&tid_tx->pending);
+		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
 		kfree(tid_tx);
 	}
 
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -660,3 +660,12 @@ void ieee80211_free_txskb(struct ieee802
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
@@ -1357,7 +1357,7 @@ static int invoke_tx_handlers(struct iee
 		if (tx->skb)
 			dev_kfree_skb(tx->skb);
 		else
-			__skb_queue_purge(&tx->skbs);
+			ieee80211_purge_tx_queue(&tx->local->hw, &tx->skbs);
 		return -1;
 	} else if (unlikely(res == TX_QUEUED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_queued);
@@ -2126,10 +2126,13 @@ netdev_tx_t ieee80211_subif_start_xmit(s
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


