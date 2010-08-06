Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663Ab0HFT2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:28:36 -0400
Received: from kroah.org ([198.145.64.141]:43530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965116Ab0HFT2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:28:02 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:15 2010
Message-Id: <20100806192115.848091818@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:19:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [16/36] ath9k: fix a potential buffer leak in the STA teardown path
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 2b40994cabd2f545d5c11d3a65dcee6f6f9155f8 upstream.

It looks like it might be possible for a TID to be paused, while still
holding some queued buffers, however ath_tx_node_cleanup currently only
iterates over active TIDs.
Fix this by always checking every allocated TID for the STA that is being
cleaned up.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |   56 +++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 28 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2230,37 +2230,37 @@ void ath_tx_node_init(struct ath_softc *
 
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
-	int i;
-	struct ath_atx_ac *ac, *ac_tmp;
-	struct ath_atx_tid *tid, *tid_tmp;
+	struct ath_atx_ac *ac;
+	struct ath_atx_tid *tid;
 	struct ath_txq *txq;
+	int i, tidno;
 
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->tx.txq[i];
-
-			spin_lock_bh(&txq->axq_lock);
-
-			list_for_each_entry_safe(ac,
-					ac_tmp, &txq->axq_acq, list) {
-				tid = list_first_entry(&ac->tid_q,
-						struct ath_atx_tid, list);
-				if (tid && tid->an != an)
-					continue;
-				list_del(&ac->list);
-				ac->sched = false;
-
-				list_for_each_entry_safe(tid,
-						tid_tmp, &ac->tid_q, list) {
-					list_del(&tid->list);
-					tid->sched = false;
-					ath_tid_drain(sc, txq, tid);
-					tid->state &= ~AGGR_ADDBA_COMPLETE;
-					tid->state &= ~AGGR_CLEANUP;
-				}
-			}
+	for (tidno = 0, tid = &an->tid[tidno];
+	     tidno < WME_NUM_TID; tidno++, tid++) {
+		i = tid->ac->qnum;
 
-			spin_unlock_bh(&txq->axq_lock);
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+
+		txq = &sc->tx.txq[i];
+		ac = tid->ac;
+
+		spin_lock_bh(&txq->axq_lock);
+
+		if (tid->sched) {
+			list_del(&tid->list);
+			tid->sched = false;
 		}
+
+		if (ac->sched) {
+			list_del(&ac->list);
+			tid->ac->sched = false;
+		}
+
+		ath_tid_drain(sc, txq, tid);
+		tid->state &= ~AGGR_ADDBA_COMPLETE;
+		tid->state &= ~AGGR_CLEANUP;
+
+		spin_unlock_bh(&txq->axq_lock);
 	}
 }


