Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2LMOGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:06:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44367 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab2LMOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:06:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 085/241] mac80211: call skb_dequeue/ieee80211_free_txskb instead of __skb_queue_purge
Date: Thu, 13 Dec 2012 11:57:30 -0200
Message-Id: <1355407206-17100-86-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1f98ab7fef48a2968f37f422c256c9fbd978c3f0 upstream.

Fixes more wifi status skb leaks, leading to hostapd/wpa_supplicant hangs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/sta_info.c    |    6 +++---
 net/mac80211/status.c      |    9 +++++++++
 net/mac80211/tx.c          |    9 ++++++---
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3f3cd50..98dab42 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1319,6 +1319,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
+void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
+			      struct sk_buff_head *skbs);
 
 /* HT */
 void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 343484c..6c74f1e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -738,8 +738,8 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
 		local->total_ps_buffered -= skb_queue_len(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->ps_tx_buf[ac]);
-		__skb_queue_purge(&sta->tx_filtered[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->ps_tx_buf[ac]);
+		ieee80211_purge_tx_queue(&local->hw, &sta->tx_filtered[ac]);
 	}
 
 #ifdef CONFIG_MAC80211_MESH
@@ -774,7 +774,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 		tid_tx = rcu_dereference_raw(sta->ampdu_mlme.tid_tx[i]);
 		if (!tid_tx)
 			continue;
-		__skb_queue_purge(&tid_tx->pending);
+		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
 		kfree(tid_tx);
 	}
 
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index d64dc07..1c697ef 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -666,3 +666,12 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb)
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
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index a22a1ad..d417c48 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1370,7 +1370,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 		if (tx->skb)
 			ieee80211_free_txskb(&tx->local->hw, tx->skb);
 		else
-			__skb_queue_purge(&tx->skbs);
+			ieee80211_purge_tx_queue(&tx->local->hw, &tx->skbs);
 		return -1;
 	} else if (unlikely(res == TX_QUEUED)) {
 		I802_DEBUG_INC(tx->local->tx_handlers_queued);
@@ -2147,10 +2147,13 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
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
-- 
1.7.9.5

