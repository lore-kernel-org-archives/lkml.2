Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab0LHB6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:58:39 -0500
Received: from kroah.org ([198.145.64.141]:48470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756853Ab0LHA7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:25 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:24 2010
Message-Id: <20101208005724.401851335@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:56:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [030/289] ath9k: fix tx aggregation flush on AR9003
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit e609e2ea2cdb3448e7849703179cd792a28dcc55 upstream.

Completing aggregate frames can lead to new buffers being pushed into
the tid queues due to software retransmission.
When the tx queues are being drained, all pending aggregates must be
completed before the tid queues get drained, otherwise buffers might be
leaked.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1101,15 +1101,6 @@ void ath_draintxq(struct ath_softc *sc,
 	txq->axq_tx_inprogress = false;
 	spin_unlock_bh(&txq->axq_lock);
 
-	/* flush any pending frames if aggregation is enabled */
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		if (!retry_tx) {
-			spin_lock_bh(&txq->axq_lock);
-			ath_txq_drain_pending_buffers(sc, txq);
-			spin_unlock_bh(&txq->axq_lock);
-		}
-	}
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 		spin_lock_bh(&txq->axq_lock);
 		while (!list_empty(&txq->txq_fifo_pending)) {
@@ -1130,6 +1121,15 @@ void ath_draintxq(struct ath_softc *sc,
 		}
 		spin_unlock_bh(&txq->axq_lock);
 	}
+
+	/* flush any pending frames if aggregation is enabled */
+	if (sc->sc_flags & SC_OP_TXAGGR) {
+		if (!retry_tx) {
+			spin_lock_bh(&txq->axq_lock);
+			ath_txq_drain_pending_buffers(sc, txq);
+			spin_unlock_bh(&txq->axq_lock);
+		}
+	}
 }
 
 void ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)


