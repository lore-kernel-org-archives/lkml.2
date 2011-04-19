Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1DSIow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:44:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:45880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1DSIos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:44:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,238,1301900400"; 
   d="scan'208";a="630877732"
Subject: [PATCH 1/2]block: optimize non-queueable flush request drive
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 16:44:46 +0800
Message-ID: <1303202686.3981.216.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In some drives, flush requests are non-queueable. This means when a flush request
is running, normal read/write requests are not. In such drive, when running flush
requests finish, we can make pending flush requests finish. Since normal write
requests are not running, pending flush requests also flush required drive cache
out. This reduces some flush requests running and improve performance.

This patch allows block core utilizes the optimization. Next patch will enable it
for SATA.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-flush.c      |   15 +++++++++++++--
 include/linux/blkdev.h |   11 +++++++++++
 2 files changed, 24 insertions(+), 2 deletions(-)

Index: linux/block/blk-flush.c
===================================================================
--- linux.orig/block/blk-flush.c	2011-04-19 09:21:47.000000000 +0800
+++ linux/block/blk-flush.c	2011-04-19 16:38:22.000000000 +0800
@@ -193,18 +193,29 @@ static bool blk_flush_complete_seq(struc
 static void flush_end_io(struct request *flush_rq, int error)
 {
 	struct request_queue *q = flush_rq->q;
-	struct list_head *running = &q->flush_queue[q->flush_running_idx];
+	LIST_HEAD(proceed_list);
 	bool queued = false;
 	struct request *rq, *n;
 
 	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
 
+	list_splice_init(&q->flush_queue[q->flush_running_idx], &proceed_list);
+	/*
+	 * If queue doesn't support queueable flush request, we can push the
+	 * pending requests to the next stage too. For such queue, there are no
+	 * normal requests running when flush request is running, so this still
+	 * guarantees the correctness.
+	 */
+	if (!blk_queue_flush_queueable(q))
+		list_splice_tail_init(&q->flush_queue[q->flush_pending_idx],
+			&proceed_list);
+
 	/* account completion of the flush request */
 	q->flush_running_idx ^= 1;
 	elv_completed_request(q, flush_rq);
 
 	/* and push the waiting requests to the next stage */
-	list_for_each_entry_safe(rq, n, running, flush.list) {
+	list_for_each_entry_safe(rq, n, &proceed_list, flush.list) {
 		unsigned int seq = blk_flush_cur_seq(rq);
 
 		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-04-19 09:15:15.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-04-19 10:04:46.000000000 +0800
@@ -366,6 +366,7 @@ struct request_queue
 	 * for flush operations
 	 */
 	unsigned int		flush_flags;
+	unsigned int		flush_not_queueable:1;
 	unsigned int		flush_pending_idx:1;
 	unsigned int		flush_running_idx:1;
 	unsigned long		flush_pending_since;
@@ -552,6 +553,16 @@ static inline void blk_clear_queue_full(
 		queue_flag_clear(QUEUE_FLAG_ASYNCFULL, q);
 }
 
+static inline void blk_set_queue_flush_queueable(struct request_queue *q,
+	bool queueable)
+{
+	q->flush_not_queueable = !queueable;
+}
+
+static inline bool blk_queue_flush_queueable(struct request_queue *q)
+{
+	return !q->flush_not_queueable;
+}
 
 /*
  * mergeable request must not have _NOMERGE or _BARRIER bit set, nor may


