Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab0LHCBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:01:54 -0500
Received: from kroah.org ([198.145.64.141]:48326 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756775Ab0LHA7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:11 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:23 2010
Message-Id: <20101208005723.009952251@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [016/289] ath9k: clean up / fix aggregation session flush
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 90fa539ca3f07323da5a90f5c8f4e5cd952875e7 upstream.

The tid aggregation cleanup is a bit fragile, as it discards failed
subframes in some places, and retransmits them in others. This could
block the cleanup of an existing aggregation session, if a retransmission
for a tid is issued, yet the tid is never scheduled again because of
the cleanup state.

Fix this by getting rid of as many subframes as possible, as early
as possible, and immediately transmitting pending subframes as regular
HT frames instead of waiting for the cleanup to complete.

Drop all pending subframes while keeping track of the Block ACK window
during aggregate tx completion to prevent sending out stale subframes,
which could confuse the receiver side.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |   63 ++++++++++++++--------------------
 1 file changed, 26 insertions(+), 37 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -61,6 +61,8 @@ static int ath_tx_num_badfrms(struct ath
 			      struct ath_tx_status *ts, int txok);
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 			     int nbad, int txok, bool update_rc);
+static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
+			      int seqno);
 
 enum {
 	MCS_HT20,
@@ -143,18 +145,23 @@ static void ath_tx_flush_tid(struct ath_
 	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 	struct ath_buf *bf;
 	struct list_head bf_head;
-	INIT_LIST_HEAD(&bf_head);
+	struct ath_tx_status ts;
 
-	WARN_ON(!tid->paused);
+	INIT_LIST_HEAD(&bf_head);
 
+	memset(&ts, 0, sizeof(ts));
 	spin_lock_bh(&txq->axq_lock);
-	tid->paused = false;
 
 	while (!list_empty(&tid->buf_q)) {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
-		BUG_ON(bf_isretried(bf));
 		list_move_tail(&bf->list, &bf_head);
-		ath_tx_send_ht_normal(sc, txq, tid, &bf_head);
+
+		if (bf_isretried(bf)) {
+			ath_tx_update_baw(sc, tid, bf->bf_seqno);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
+		} else {
+			ath_tx_send_ht_normal(sc, txq, tid, &bf_head);
+		}
 	}
 
 	spin_unlock_bh(&txq->axq_lock);
@@ -433,7 +440,7 @@ static void ath_tx_complete_aggr(struct
 			list_move_tail(&bf->list, &bf_head);
 		}
 
-		if (!txpending) {
+		if (!txpending || (tid->state & AGGR_CLEANUP)) {
 			/*
 			 * complete the acked-ones/xretried ones; update
 			 * block-ack window
@@ -513,15 +520,12 @@ static void ath_tx_complete_aggr(struct
 	}
 
 	if (tid->state & AGGR_CLEANUP) {
+		ath_tx_flush_tid(sc, tid);
+
 		if (tid->baw_head == tid->baw_tail) {
 			tid->state &= ~AGGR_ADDBA_COMPLETE;
 			tid->state &= ~AGGR_CLEANUP;
-
-			/* send buffered frames as singles */
-			ath_tx_flush_tid(sc, tid);
 		}
-		rcu_read_unlock();
-		return;
 	}
 
 	rcu_read_unlock();
@@ -806,12 +810,6 @@ void ath_tx_aggr_stop(struct ath_softc *
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = &sc->tx.txq[txtid->ac->qnum];
-	struct ath_tx_status ts;
-	struct ath_buf *bf;
-	struct list_head bf_head;
-
-	memset(&ts, 0, sizeof(ts));
-	INIT_LIST_HEAD(&bf_head);
 
 	if (txtid->state & AGGR_CLEANUP)
 		return;
@@ -821,31 +819,22 @@ void ath_tx_aggr_stop(struct ath_softc *
 		return;
 	}
 
-	/* drop all software retried frames and mark this TID */
 	spin_lock_bh(&txq->axq_lock);
 	txtid->paused = true;
-	while (!list_empty(&txtid->buf_q)) {
-		bf = list_first_entry(&txtid->buf_q, struct ath_buf, list);
-		if (!bf_isretried(bf)) {
-			/*
-			 * NB: it's based on the assumption that
-			 * software retried frame will always stay
-			 * at the head of software queue.
-			 */
-			break;
-		}
-		list_move_tail(&bf->list, &bf_head);
-		ath_tx_update_baw(sc, txtid, bf->bf_seqno);
-		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
-	}
-	spin_unlock_bh(&txq->axq_lock);
 
-	if (txtid->baw_head != txtid->baw_tail) {
+	/*
+	 * If frames are still being transmitted for this TID, they will be
+	 * cleaned up during tx completion. To prevent race conditions, this
+	 * TID can only be reused after all in-progress subframes have been
+	 * completed.
+	 */
+	if (txtid->baw_head != txtid->baw_tail)
 		txtid->state |= AGGR_CLEANUP;
-	} else {
+	else
 		txtid->state &= ~AGGR_ADDBA_COMPLETE;
-		ath_tx_flush_tid(sc, txtid);
-	}
+	spin_unlock_bh(&txq->axq_lock);
+
+	ath_tx_flush_tid(sc, txtid);
 }
 
 void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)


