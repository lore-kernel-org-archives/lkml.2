Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1JUD44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 23:56:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61184 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753306Ab1JUD4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 23:56:55 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] block: add missing blk_queue_dead() checks
Date: Thu, 20 Oct 2011 20:56:40 -0700
Message-Id: <1319169400-15706-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319169400-15706-1-git-send-email-tj@kernel.org>
References: <1319169400-15706-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_insert_cloned_request(), blk_execute_rq_nowait() and
blk_flush_plug_list() either didn't check whether the queue was dead
or did it without holding queue_lock.  Update them so that dead state
is checked while holding queue_lock.

AFAICS, this plugs all holes (requeue doesn't matter as the request is
transitioning atomically from in_flight to queued).

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c |   21 +++++++++++++++++++++
 block/blk-exec.c |    5 ++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 53e36c6..c195298 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1724,6 +1724,10 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 		return -EIO;
 
 	spin_lock_irqsave(q->queue_lock, flags);
+	if (unlikely(blk_queue_dead(q))) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		return -ENODEV;
+	}
 
 	/*
 	 * Submitting request must be dequeued before calling this function
@@ -2696,6 +2700,14 @@ static void queue_unplugged(struct request_queue *q, unsigned int depth,
 	trace_block_unplug(q, depth, !from_schedule);
 
 	/*
+	 * Don't mess with dead queue.
+	 */
+	if (unlikely(blk_queue_dead(q))) {
+		spin_unlock(q->queue_lock);
+		return;
+	}
+
+	/*
 	 * If we are punting this to kblockd, then we can safely drop
 	 * the queue_lock before waking kblockd (which needs to take
 	 * this lock).
@@ -2771,6 +2783,15 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 			depth = 0;
 			spin_lock(q->queue_lock);
 		}
+
+		/*
+		 * Short-circuit if @q is dead
+		 */
+		if (unlikely(blk_queue_dead(q))) {
+			__blk_end_request_all(rq, -ENODEV);
+			continue;
+		}
+
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
diff --git a/block/blk-exec.c b/block/blk-exec.c
index d11c0b8..727abb1 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -51,7 +51,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	int where = at_head ? ELEVATOR_INSERT_FRONT : ELEVATOR_INSERT_BACK;
 	unsigned long flags;
 
+	spin_lock_irqsave(q->queue_lock, flags);
+
 	if (unlikely(blk_queue_dead(q))) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
@@ -60,12 +63,12 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
-	spin_lock_irqsave(q->queue_lock, flags);
 	elv_add_request(q, rq, where);
 	blk_run_queue_async(q);
 	/* the queue is stopped so it won't be run */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
 		q->request_fn(q);
+
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
-- 
1.7.3.1

