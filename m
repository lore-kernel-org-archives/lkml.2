Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab0GASc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:32:58 -0400
Received: from kroah.org ([198.145.64.141]:40740 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758098Ab0GASYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:24:10 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:16 2010
Message-Id: <20100701173216.508802713@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: [patch 115/149] iwlwifi: check for aggregation frame and queue
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

commit 45d427001b5eec03cecaacddb53c73af46bb263e upstream.

Error checking for aggregation frames should go into aggregation queue,
if aggregation queue not available, use legacy queue instead.
Also make sure the aggregation queue is available to activate,
if driver and mac80211 is out-of-sync, try to disable the queue and
sync-up with mac80211.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   15 ++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   18 ++++++++++++------
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -402,10 +402,23 @@ static void rs_tl_turn_on_agg_for_tid(st
 				      struct iwl_lq_sta *lq_data, u8 tid,
 				      struct ieee80211_sta *sta)
 {
+	int ret;
+
 	if (rs_tl_get_load(lq_data, tid) > IWL_AGG_LOAD_THRESHOLD) {
 		IWL_DEBUG_HT(priv, "Starting Tx agg: STA: %pM tid: %d\n",
 				sta->addr, tid);
-		ieee80211_start_tx_ba_session(priv->hw, sta->addr, tid);
+		ret = ieee80211_start_tx_ba_session(priv->hw, sta->addr, tid);
+		if (ret == -EAGAIN) {
+			/*
+			 * driver and mac80211 is out of sync
+			 * this might be cause by reloading firmware
+			 * stop the tx ba session here
+			 */
+			IWL_DEBUG_HT(priv, "Fail start Tx agg on tid: %d\n",
+				tid);
+			ret = ieee80211_stop_tx_ba_session(priv->hw, sta->addr, tid,
+						WLAN_BACK_INITIATOR);
+		}
 	}
 }
 
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -791,8 +791,10 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (info->flags & IEEE80211_TX_CTL_AMPDU &&
+		    priv->stations[sta_id].tid[tid].agg.state == IWL_AGG_ON) {
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
+		}
 	}
 
 	txq = &priv->txq[txq_id];
@@ -1273,7 +1275,7 @@ int iwl_tx_agg_stop(struct iwl_priv *pri
 {
 	int tx_fifo_id, txq_id, sta_id, ssn = -1;
 	struct iwl_tid_data *tid_data;
-	int ret, write_ptr, read_ptr;
+	int write_ptr, read_ptr;
 	unsigned long flags;
 
 	if (!ra) {
@@ -1325,13 +1327,17 @@ int iwl_tx_agg_stop(struct iwl_priv *pri
 	priv->stations[sta_id].tid[tid].agg.state = IWL_AGG_OFF;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	ret = priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
+	/*
+	 * the only reason this call can fail is queue number out of range,
+	 * which can happen if uCode is reloaded and all the station
+	 * information are lost. if it is outside the range, there is no need
+	 * to deactivate the uCode queue, just return "success" to allow
+	 *  mac80211 to clean up it own data.
+	 */
+	priv->cfg->ops->lib->txq_agg_disable(priv, txq_id, ssn,
 						   tx_fifo_id);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret)
-		return ret;
-
 	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
 
 	return 0;


