Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab1JZBC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:02:29 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65206 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab1JZBC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:02:26 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        hch@infradead.org
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] block: add missing blk_queue_dead() checks
Date: Tue, 25 Oct 2011 18:02:07 -0700
Message-Id: <1319590927-15791-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1319590927-15791-1-git-send-email-tj@kernel.org>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
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
 block/blk-exec.c |    5 +++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4224e0a..8267409 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1722,6 +1722,10 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
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
index 8716557..660a722 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -52,7 +52,10 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	bool may_sleep = !preempt_count() && !irqs_disabled();
 	unsigned long flags;
 
+	spin_lock_irqsave(q->queue_lock, flags);
+
 	if (unlikely(blk_queue_dead(q))) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
 		rq->errors = -ENXIO;
 		if (rq->end_io)
 			rq->end_io(rq, rq->errors);
@@ -61,8 +64,6 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 
 	rq->rq_disk = bd_disk;
 	rq->end_io = done;
-
-	spin_lock_irqsave(q->queue_lock, flags);
 	elv_add_request(q, rq, where);
 
 	/*
-- 
1.7.3.1

