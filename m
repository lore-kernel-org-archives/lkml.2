Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2KZSND (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:13:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47241 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2KZRCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:02:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 049/270] ath9k: use ieee80211_free_txskb
Date: Mon, 26 Nov 2012 14:55:39 -0200
Message-Id: <1353949160-26803-50-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 249ee72249140fe5b9adc988f97298f0aa5db2fc upstream.

Using ieee80211_free_txskb for tx frames is required, since mac80211 clones
skbs for which socket tx status is requested.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c   |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c   |   53 +++++++++++++++++--------------
 3 files changed, 31 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 11bc55e..3f9330a 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -121,7 +121,7 @@ static void ath_tx_cabq(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (ath_tx_start(hw, skb, &txctl) != 0) {
 		ath_dbg(common, XMIT, "CABQ TX failed\n");
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index dac1a27..b5fa9eb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1161,7 +1161,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	return;
 exit:
-	dev_kfree_skb_any(skb);
+	ieee80211_free_txskb(hw, skb);
 }
 
 static void ath9k_stop(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 4d57139..b78773b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -64,8 +64,7 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb,
-					   bool dequeue);
+					   struct sk_buff *skb);
 
 enum {
 	MCS_HT20,
@@ -201,7 +200,15 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
-		if (bf && fi->retries) {
+		if (!bf) {
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+			if (!bf) {
+				ieee80211_free_txskb(sc->hw, skb);
+				continue;
+			}
+		}
+
+		if (fi->retries) {
 			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
@@ -812,10 +819,13 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 		if (!fi->bf)
-			bf = ath_tx_setup_buffer(sc, txq, tid, skb, true);
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 
-		if (!bf)
+		if (!bf) {
+			__skb_unlink(skb, &tid->buf_q);
+			ieee80211_free_txskb(sc->hw, skb);
 			continue;
+		}
 
 		bf->bf_state.bf_type = BUF_AMPDU | BUF_AGGR;
 		seqno = bf->bf_state.seqno;
@@ -1717,9 +1727,11 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		return;
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
-	if (!bf)
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	if (!bf) {
+		ieee80211_free_txskb(sc->hw, skb);
 		return;
+	}
 
 	bf->bf_state.bf_type = BUF_AMPDU;
 	INIT_LIST_HEAD(&bf_head);
@@ -1743,11 +1755,6 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_buf *bf;
 
 	bf = fi->bf;
-	if (!bf)
-		bf = ath_tx_setup_buffer(sc, txq, tid, skb, false);
-
-	if (!bf)
-		return;
 
 	INIT_LIST_HEAD(&bf_head);
 	list_add_tail(&bf->list, &bf_head);
@@ -1820,8 +1827,7 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
-					   struct sk_buff *skb,
-					   bool dequeue)
+					   struct sk_buff *skb)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_frame_info *fi = get_frame_info(skb);
@@ -1833,7 +1839,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
 		ath_dbg(common, XMIT, "TX buffers are full\n");
-		goto error;
+		return NULL;
 	}
 
 	ATH_TXBUF_RESET(bf);
@@ -1862,18 +1868,12 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 		ath_err(ath9k_hw_common(sc->sc_ah),
 			"dma_mapping_error() on TX\n");
 		ath_tx_return_buffer(sc, bf);
-		goto error;
+		return NULL;
 	}
 
 	fi->bf = bf;
 
 	return bf;
-
-error:
-	if (dequeue)
-		__skb_unlink(skb, &tid->buf_q);
-	dev_kfree_skb_any(skb);
-	return NULL;
 }
 
 /* FIXME: tx power */
@@ -1902,9 +1902,14 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 		 */
 		ath_tx_send_ampdu(sc, tid, skb, txctl);
 	} else {
-		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb, false);
-		if (!bf)
+		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+		if (!bf) {
+			if (txctl->paprd)
+				dev_kfree_skb_any(skb);
+			else
+				ieee80211_free_txskb(sc->hw, skb);
 			return;
+		}
 
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
-- 
1.7.9.5

