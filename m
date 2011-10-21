Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1JUSNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 14:13:46 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60618 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab1JUSNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 14:13:45 -0400
Date: Fri, 21 Oct 2011 11:13:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, jgarzik@pobox.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 2/6] block: allow blk_execute_rq_nowait() to be called
 form IRQ context
Message-ID: <20111021181339.GA28670@google.com>
References: <1319169400-15706-1-git-send-email-tj@kernel.org>
 <1319169400-15706-3-git-send-email-tj@kernel.org>
 <20111021092016.GA14388@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111021092016.GA14388@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 21, 2011 at 05:20:16AM -0400, Christoph Hellwig wrote:
> On Thu, Oct 20, 2011 at 08:56:36PM -0700, Tejun Heo wrote:
> > Currently blk_execute_rq_nowait() directly calls __blk_run_queue() and
> > thus can't be called from IRQ context.  This patch updates it to use
> > blk_run_queue_async() instead.  This will be used to unexport
> > elv_add_request().
> > 
> > This changes how queue is kicked after blk_execute_rq_nowait() but
> > it's hardly a hot path and the effect shouldn't be noticeable.
> 
> It actually very much is a fasthpath for many of it's users, e.g. the
> SCSI tape drivers, the OSD layer and the target scsi passthrough
> backend.
> 
> I don't think blindly adding a context switch here without benchmarking
> is doable.  Just add variants that do the workqueue dance or not.

Hmm... I'd really like to keep that detail inside block layer.  How
about something like the following?

Thanks.

>From b6954535fe7a585a97e2ce3955569981b833e4db Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 21 Oct 2011 11:07:58 -0700
Subject: [PATCH 2/6] block: allow blk_execute_rq_nowait() to be called form IRQ context

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

