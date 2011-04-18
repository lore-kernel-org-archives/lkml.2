Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1DRHg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:36:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:65104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1DRHgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:36:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,231,1301900400"; 
   d="scan'208";a="910984240"
Subject: [RFC]block: add flush request at head
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <htejun@gmail.com>,
        "Shi, Alex" <alex.shi@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 15:36:14 +0800
Message-ID: <1303112174.3981.187.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Alex found a regression when running sysbench fileio test with an ext4
filesystem in a hard disk. The hard disk is attached to an AHCI controller.
The regression is about 15%. He bisected it to 53d63e6b0dfb95882e.
  At first glance, it's quite strange the commit can cause any difference,
since q->queue_head usually has just one entry. It looks in SATA normal request
and flush request are exclusive, which causes a lot of requests requeued. From
the log, a flush is finished and then flowed two requests, one is a normal
request and the other flush request. If we let the flush run first, we have a
flush dispatched just after a flush finishes. Assume the second flush can finish
quickly, as the disk cache is already flushed at least most part. Also this delays
normal request, so potentially we do more normal requests before a flush.
  Changing the order here should not impact the correctness, because filesystem
should already wait for required normal requests finished.
  The patch below recover the regression. we don't change the order if just
finished request isn't flush request to delay flush.

BTW, for SATA-like controller, we can do an optimization. When the running list
of q->flush_queue proceeds, we can proceeds pending list too (that is the two lists
could be merged). Because normal request and flush request are exclusive. When
a flush request is running, there should be no other normal request running.
Don't know if this is worthy, if yes, I can work on it.

Reported-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/blk-flush.c b/block/blk-flush.c
index eba4a27..78a88d7 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -89,7 +89,7 @@ enum {
 	FLUSH_PENDING_TIMEOUT	= 5 * HZ,
 };
 
-static bool blk_kick_flush(struct request_queue *q);
+static bool blk_kick_flush(struct request_queue *q, bool flush_end);
 
 static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
 {
@@ -141,7 +141,7 @@ static void blk_flush_restore_request(struct request *rq)
  * %true if requests were added to the dispatch queue, %false otherwise.
  */
 static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
-				   int error)
+				   int error, bool flush_end)
 {
 	struct request_queue *q = rq->q;
 	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
@@ -187,7 +187,7 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 		BUG();
 	}
 
-	return blk_kick_flush(q) | queued;
+	return blk_kick_flush(q, flush_end) | queued;
 }
 
 static void flush_end_io(struct request *flush_rq, int error)
@@ -208,7 +208,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 		unsigned int seq = blk_flush_cur_seq(rq);
 
 		BUG_ON(seq != REQ_FSEQ_PREFLUSH && seq != REQ_FSEQ_POSTFLUSH);
-		queued |= blk_flush_complete_seq(rq, seq, error);
+		queued |= blk_flush_complete_seq(rq, seq, error, true);
 	}
 
 	/*
@@ -234,7 +234,7 @@ static void flush_end_io(struct request *flush_rq, int error)
  * RETURNS:
  * %true if flush was issued, %false otherwise.
  */
-static bool blk_kick_flush(struct request_queue *q)
+static bool blk_kick_flush(struct request_queue *q, bool flush_end)
 {
 	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
 	struct request *first_rq =
@@ -261,7 +261,10 @@ static bool blk_kick_flush(struct request_queue *q)
 	q->flush_rq.end_io = flush_end_io;
 
 	q->flush_pending_idx ^= 1;
-	list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
+	if (flush_end)
+		list_add(&q->flush_rq.queuelist, &q->queue_head);
+	else
+		list_add_tail(&q->flush_rq.queuelist, &q->queue_head);
 	return true;
 }
 
@@ -273,7 +276,7 @@ static void flush_data_end_io(struct request *rq, int error)
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
-	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
+	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error, false))
 		__blk_run_queue(q, true);
 }
 
@@ -325,7 +328,7 @@ void blk_insert_flush(struct request *rq)
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
 	rq->end_io = flush_data_end_io;
 
-	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
+	blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0, false);
 }
 
 /**


