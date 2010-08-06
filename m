Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935561Ab0HFSkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 14:40:07 -0400
Received: from kroah.org ([198.145.64.141]:48681 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931Ab0HFSf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 14:35:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:32:02 2010
Message-Id: <20100806183202.082530736@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:30:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [23/38] ath9k: fix yet another buffer leak in the tx aggregation code
In-Reply-To: <20100806183250.GA23019@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4cee78614cfa046a26c4fbf313d5bbacb3ad8efc upstream.

When an aggregation session is being cleaned up, while the tx status
for some frames is being processed, the TID is flushed and its buffers
are sent out.

Unfortunately that left the pending un-acked frames unprocessed, thus
leaking buffers. Fix this by reordering the code so that those frames
are processed first, before the TID is flushed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -510,6 +510,14 @@ static void ath_tx_complete_aggr(struct
 		bf = bf_next;
 	}
 
+	/* prepend un-acked frames to the beginning of the pending frame queue */
+	if (!list_empty(&bf_pending)) {
+		spin_lock_bh(&txq->axq_lock);
+		list_splice(&bf_pending, &tid->buf_q);
+		ath_tx_queue_tid(txq, tid);
+		spin_unlock_bh(&txq->axq_lock);
+	}
+
 	if (tid->state & AGGR_CLEANUP) {
 		if (tid->baw_head == tid->baw_tail) {
 			tid->state &= ~AGGR_ADDBA_COMPLETE;
@@ -522,14 +530,6 @@ static void ath_tx_complete_aggr(struct
 		return;
 	}
 
-	/* prepend un-acked frames to the beginning of the pending frame queue */
-	if (!list_empty(&bf_pending)) {
-		spin_lock_bh(&txq->axq_lock);
-		list_splice(&bf_pending, &tid->buf_q);
-		ath_tx_queue_tid(txq, tid);
-		spin_unlock_bh(&txq->axq_lock);
-	}
-
 	rcu_read_unlock();
 
 	if (needreset)


