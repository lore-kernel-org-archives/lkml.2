Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab1FUXqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:46:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:47905 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab1FUXql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:46:41 -0400
Message-Id: <20110621233648.914681513@chello.nl>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 01:34:47 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [RFC][PATCH 3/3] block: Break long IRQ disabled region
References: <20110621233444.094372367@chello.nl>
Content-Disposition: inline; filename=tglx3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keeping IRQs disabled for long is not a feature.

Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 block/blk-core.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -2661,7 +2661,7 @@ static void queue_unplugged(struct reque
 	trace_block_unplug(q, depth, true);
 
 	__blk_run_queue(q);
-	spin_unlock(q->queue_lock);
+	spin_unlock_irq(q->queue_lock);
 }
 
 static void flush_plug_callbacks(struct blk_plug *plug)
@@ -2706,11 +2706,6 @@ void blk_flush_plug_list(struct blk_plug
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
@@ -2723,7 +2718,7 @@ void blk_flush_plug_list(struct blk_plug
 				queue_unplugged(q, depth);
 			q = rq->q;
 			depth = 0;
-			spin_lock(q->queue_lock);
+			spin_lock_irq(q->queue_lock);
 		}
 		/*
 		 * rq is already accounted, so use raw insert
@@ -2741,8 +2736,6 @@ void blk_flush_plug_list(struct blk_plug
 	 */
 	if (q)
 		queue_unplugged(q, depth);
-
-	local_irq_restore(flags);
 }
 
 void blk_finish_plug(struct blk_plug *plug)


