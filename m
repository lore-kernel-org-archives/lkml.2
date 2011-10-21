Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1JUD5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:57:47 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:37297 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab1JUD4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:56:47 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] block: allow blk_execute_rq_nowait() to be called form IRQ context
Date: Thu, 20 Oct 2011 20:56:36 -0700
Message-Id: <1319169400-15706-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319169400-15706-1-git-send-email-tj@kernel.org>
References: <1319169400-15706-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently blk_execute_rq_nowait() directly calls __blk_run_queue() and
thus can't be called from IRQ context.  This patch updates it to use
blk_run_queue_async() instead.  This will be used to unexport
elv_add_request().

This changes how queue is kicked after blk_execute_rq_nowait() but
it's hardly a hot path and the effect shouldn't be noticeable.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-exec.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index a1ebceb..056f097 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -49,6 +49,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 			   rq_end_io_fn *done)
 {
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
+	unsigned long flags;
 
 	if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
 		rq->errors = -ENXIO;
@@ -59,14 +60,13 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
-	WARN_ON(irqs_disabled());
-	spin_lock_irq(q->queue_lock);
+	spin_lock_irqsave(q->queue_lock, flags);
 	__elv_add_request(q, rq, where);
-	__blk_run_queue(q);
+	blk_run_queue_async(q);
 	/* the queue is stopped so it won't be run */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
 		q->request_fn(q);
-	spin_unlock_irq(q->queue_lock);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
 
-- 
1.7.3.1

