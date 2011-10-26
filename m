Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1JZBDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:03:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52210 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1JZBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:02:17 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] block: allow blk_execute_rq_nowait() to be called from IRQ context
Date: Tue, 25 Oct 2011 18:02:03 -0700
Message-Id: <1319590927-15791-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319590927-15791-1-git-send-email-tj@kernel.org>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently blk_execute_rq_nowait() directly calls __blk_run_queue() and
thus must be called from sleepable context.  This patch updates the
function such that it can be called from non-sleepable context and
schedules async execution in such cases.  This will be used to
unexport elv_add_request().

While at it, add FIXME comment for REQ_TYPE_PM_RESUME special case.

-v2: hch pointed out that blk_execute_rq_nowait() can be hot path for
     some drivers.  Retained direct execution from sleepable context.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
---
 block/blk-exec.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index a1ebceb..b686f2b 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -49,6 +49,8 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	bool may_sleep = !preempt_count() && !irqs_disabled();
+	unsigned long flags;
 
 	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
 		rq->errors = -ENXIO;
@@ -59,14 +61,27 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
-	WARN_ON(irqs_disabled());
-	spin_lock_irq(q->queue_lock);
+
+	spin_lock_irqsave(q->queue_lock, flags);
 	__elv_add_request(q, rq, where);
-	__blk_run_queue(q);
-	/* the queue is stopped so it won't be run */
-	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
-		q->request_fn(q);
-	spin_unlock_irq(q->queue_lock);
+
+	/*
+	 * Some drivers beat this path pretty hard.  As an optimization, if
+	 * we're being called from sleepable context, run @q directly.
+	 */
+	if (may_sleep) {
+		__blk_run_queue(q);
+		/*
+		 * The queue is stopped so it won't be run.
+		 * FIXME: Please kill me along with REQ_TYPE_PM_RESUME.
+		 */
+		if (rq->cmd_type == REQ_TYPE_PM_RESUME)
+			q->request_fn(q);
+	} else {
+		blk_run_queue_async(q);
+	}
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
-- 
1.7.3.1

