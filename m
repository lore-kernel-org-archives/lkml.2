Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab1FVRwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:52:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:50492 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329Ab1FVRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:52:16 -0400
Message-Id: <20110622174919.025446432@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 17:52:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 3/4] block: Shorten interrupt disabled regions
References: <20110622174659.496793734@linutronix.de>
Content-Disposition: inline; filename=block-fixup-irq-disabled-region.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving the blk_sched_flush_plug() call out of the interrupt/preempt
disabled region in the scheduler allows us to replace
local_irq_save/restore(flags) by local_irq_disable/enable() in
blk_flush_plug().

Now instead of doing this we disable interrupts explicitely when we
lock the request_queue and reenable them when we drop the lock. That
allows interrupts to be handled when the plug list contains requests
for more than one queue.

Aside of that this change makes the scope of the irq disabled region
more obvious. The current code confused the hell out of me when
looking at:

 local_irq_save(flags);
   spin_lock(q->queue_lock);
   ...
   queue_unplugged(q...);
     scsi_request_fn();
       spin_unlock(q->queue_lock);
       spin_lock(shost->host_lock);
       spin_unlock_irq(shost->host_lock);

-------------------^^^ ????

       spin_lock_irq(q->queue_lock);
       spin_unlock(q->lock);
 local_irq_restore(flags);

Also add a comment to __blk_run_queue() documenting that
q->request_fn() can drop q->queue_lock and reenable interrupts, but
must return with q->queue_lock held and interrupts disabled.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 block/blk-core.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -301,7 +301,11 @@ void __blk_run_queue(struct request_queu
 {
 	if (unlikely(blk_queue_stopped(q)))
 		return;
-
+	/*
+	 * q->request_fn() can drop q->queue_lock and reenable
+	 * interrupts, but must return with q->queue_lock held and
+	 * interrupts disabled.
+	 */
 	q->request_fn(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
@@ -2667,11 +2671,11 @@ static void queue_unplugged(struct reque
 	 * this lock).
 	 */
 	if (from_schedule) {
-		spin_unlock(q->queue_lock);
+		spin_unlock_irq(q->queue_lock);
 		blk_run_queue_async(q);
 	} else {
 		__blk_run_queue(q);
-		spin_unlock(q->queue_lock);
+		spin_unlock_irq(q->queue_lock);
 	}
 
 }
@@ -2697,7 +2701,6 @@ static void flush_plug_callbacks(struct 
 void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct request_queue *q;
-	unsigned long flags;
 	struct request *rq;
 	LIST_HEAD(list);
 	unsigned int depth;
@@ -2718,11 +2721,6 @@ void blk_flush_plug_list(struct blk_plug
 	q = NULL;
 	depth = 0;
 
-	/*
-	 * Save and disable interrupts here, to avoid doing it for every
-	 * queue lock we have to take.
-	 */
-	local_irq_save(flags);
 	while (!list_empty(&list)) {
 		rq = list_entry_rq(list.next);
 		list_del_init(&rq->queuelist);
@@ -2735,7 +2733,7 @@ void blk_flush_plug_list(struct blk_plug
 				queue_unplugged(q, depth, from_schedule);
 			q = rq->q;
 			depth = 0;
-			spin_lock(q->queue_lock);
+			spin_lock_irq(q->queue_lock);
 		}
 		/*
 		 * rq is already accounted, so use raw insert
@@ -2753,8 +2751,6 @@ void blk_flush_plug_list(struct blk_plug
 	 */
 	if (q)
 		queue_unplugged(q, depth, from_schedule);
-
-	local_irq_restore(flags);
 }
 
 void blk_finish_plug(struct blk_plug *plug)


