Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935599Ab0HFSkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:40:35 -0400
Received: from kroah.org ([198.145.64.141]:48670 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964922Ab0HFSf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:01 2010
Message-Id: <20100806183201.908485166@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [21/38] ath9k: another fix for the A-MPDU buffer leak
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 31e79a5954b78fbed15de2c8974d5a2b6019199a upstream.

The patch 'ath9k: fix a buffer leak in A-MPDU completion' addressed the
issue of running out of buffers/descriptors in the tx path if a STA is
deleted while tx status feedback is still pending.
The remaining issue is that the skbs of the buffers are not reclaimed,
leaving a memory leak.
This patch fixes this issue by running the buffers through
ath_tx_complete_buf(), ensuring that the pending frames counter is also
updated.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -329,7 +329,6 @@ static void ath_tx_complete_aggr(struct
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
 	struct ieee80211_tx_rate rates[4];
-	unsigned long flags;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -346,9 +345,21 @@ static void ath_tx_complete_aggr(struct
 	if (!sta) {
 		rcu_read_unlock();
 
-		spin_lock_irqsave(&sc->tx.txbuflock, flags);
-		list_splice_tail_init(bf_q, &sc->tx.txbuf);
-		spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
+		INIT_LIST_HEAD(&bf_head);
+		while (bf) {
+			bf_next = bf->bf_next;
+
+			bf->bf_state.bf_type |= BUF_XRETRY;
+			if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) ||
+			    !bf->bf_stale || bf_next != NULL)
+				list_move_tail(&bf->list, &bf_head);
+
+			ath_tx_rc_status(bf, ts, 0, 0, false);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
+				0, 0);
+
+			bf = bf_next;
+		}
 		return;
 	}
 


