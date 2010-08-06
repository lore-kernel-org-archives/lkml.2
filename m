Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888Ab0HFSgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:36:06 -0400
Received: from kroah.org ([198.145.64.141]:48650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964909Ab0HFSfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:51 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.739289205@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [19/38] ath9k: fix retry count for A-MPDU rate control status reports
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 78c4653a2274479547e259e1f416d2b3d04c42a8 upstream.

The 'bf_retries' field of the ath_buf structure was used for both
software retries (AMPDU subframes) and hardware retries (legacy
frames). This led to a wrong retry count being reported for the A-MPDU
rate control stats.
This patch changes the code to no longer use bf_retries for reporting
retry counts, but instead always using the real on-chip retry count
from the ath_tx_status.
Additionally, if the first subframe of an A-MPDU was not acked, the tx
status report is submitted along with the first acked subframe, which
may not contain the correct rates in the tx info.
This is easily corrected by saving the tx rate info before looping over
subframes, and then copying it back once the A-MPDU status report is
submitted.
In my tests this change improves throughput visibly.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -328,6 +328,7 @@ static void ath_tx_complete_aggr(struct
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
+	struct ieee80211_tx_rate rates[4];
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -335,6 +336,8 @@ static void ath_tx_complete_aggr(struct
 	tx_info = IEEE80211_SKB_CB(skb);
 	hw = bf->aphy->hw;
 
+	memcpy(rates, tx_info->control.rates, sizeof(rates));
+
 	rcu_read_lock();
 
 	/* XXX: use ieee80211_find_sta! */
@@ -375,6 +378,9 @@ static void ath_tx_complete_aggr(struct
 		txfail = txpending = 0;
 		bf_next = bf->bf_next;
 
+		skb = bf->bf_mpdu;
+		tx_info = IEEE80211_SKB_CB(skb);
+
 		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, bf->bf_seqno))) {
 			/* transmit completion, subframe is
 			 * acked by block ack */
@@ -428,6 +434,7 @@ static void ath_tx_complete_aggr(struct
 			spin_unlock_bh(&txq->axq_lock);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
+				memcpy(tx_info->control.rates, rates, sizeof(rates));
 				ath_tx_rc_status(bf, ts, nbad, txok, true);
 				rc_update = false;
 			} else {
@@ -2050,7 +2057,7 @@ static void ath_tx_rc_status(struct ath_
 		tx_info->status.rates[i].idx = -1;
 	}
 
-	tx_info->status.rates[tx_rateindex].count = bf->bf_retries + 1;
+	tx_info->status.rates[tx_rateindex].count = ts->ts_longretry + 1;
 }
 
 static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
@@ -2161,7 +2168,6 @@ static void ath_tx_processq(struct ath_s
 			 * This frame is sent out as a single frame.
 			 * Use hardware retry status for this frame.
 			 */
-			bf->bf_retries = ts.ts_longretry;
 			if (ts.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
 			ath_tx_rc_status(bf, &ts, 0, txok, true);
@@ -2280,7 +2286,6 @@ void ath_tx_edma_tasklet(struct ath_soft
 		txok = !(txs.ts_status & ATH9K_TXERR_MASK);
 
 		if (!bf_isampdu(bf)) {
-			bf->bf_retries = txs.ts_longretry;
 			if (txs.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
 			ath_tx_rc_status(bf, &txs, 0, txok, true);


