Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab1DNRpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:45:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:37435 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab1DNRph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 001/209] ath9k: fix retry count for A-MPDU rate control status reports
Date: Thu, 14 Apr 2011 13:40:31 -0400
Message-Id: <1302803039-9400-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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

[PG: 34 doesnt have ts as an alias for ds->ds_txstat, so change accordingly]

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0b2ade3..5111c7d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -302,6 +302,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
+	struct ieee80211_tx_rate rates[4];
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -309,6 +310,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	tx_info = IEEE80211_SKB_CB(skb);
 	hw = bf->aphy->hw;
 
+	memcpy(rates, tx_info->control.rates, sizeof(rates));
+
 	rcu_read_lock();
 
 	/* XXX: use ieee80211_find_sta! */
@@ -350,6 +353,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		txfail = txpending = 0;
 		bf_next = bf->bf_next;
 
+		skb = bf->bf_mpdu;
+		tx_info = IEEE80211_SKB_CB(skb);
+
 		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, bf->bf_seqno))) {
 			/* transmit completion, subframe is
 			 * acked by block ack */
@@ -402,6 +408,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			spin_unlock_bh(&txq->axq_lock);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
+				memcpy(tx_info->control.rates, rates, sizeof(rates));
 				ath_tx_rc_status(bf, ds, nbad, txok, true);
 				rc_update = false;
 			} else {
@@ -1952,7 +1959,7 @@ static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
 		tx_info->status.rates[i].idx = -1;
 	}
 
-	tx_info->status.rates[tx_rateindex].count = bf->bf_retries + 1;
+	tx_info->status.rates[tx_rateindex].count = ds->ds_txstat.ts_longretry + 1;
 }
 
 static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
@@ -2062,7 +2069,6 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			 * This frame is sent out as a single frame.
 			 * Use hardware retry status for this frame.
 			 */
-			bf->bf_retries = ds->ds_txstat.ts_longretry;
 			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
 			ath_tx_rc_status(bf, ds, 0, txok, true);
-- 
1.7.4.4

