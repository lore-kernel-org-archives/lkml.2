Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab1FVRwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:52:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:50488 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324Ab1FVRwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:52:15 -0400
Message-Id: <20110622174918.917236198@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 17:52:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 2/4] sched: Move blk_schedule_flush_plug() out of __schedule()
References: <20110622174659.496793734@linutronix.de>
Content-Disposition: inline;
 filename=sched-move-block-plug-out-of-scheduler-guts.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no real reason to run blk_schedule_flush_plug() with
interrupts and preemption disabled.

Move it into schedule() and call it when the task is going voluntarily
to sleep. There might be false positives when the task is woken
between that call and actually scheduling, but that's not really
different from being woken immediately after switching away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4253,16 +4253,6 @@ need_resched:
 				if (to_wakeup)
 					try_to_wake_up_local(to_wakeup);
 			}
-
-			/*
-			 * If we are going to sleep and we have plugged IO
-			 * queued, make sure to submit it to avoid deadlocks.
-			 */
-			if (blk_needs_flush_plug(prev)) {
-				raw_spin_unlock(&rq->lock);
-				blk_schedule_flush_plug(prev);
-				raw_spin_lock(&rq->lock);
-			}
 		}
 		switch_count = &prev->nvcsw;
 	}
@@ -4301,8 +4291,23 @@ need_resched:
 		goto need_resched;
 }
 
+static inline void sched_submit_work(struct task_struct *tsk)
+{
+	if (!tsk->state)
+		return;
+	/*
+	 * If we are going to sleep and we have plugged IO queued,
+	 * make sure to submit it to avoid deadlocks.
+	 */
+	if (blk_needs_flush_plug(tsk))
+		blk_schedule_flush_plug(tsk);
+}
+
 asmlinkage void schedule(void)
 {
+	struct task_struct *tsk = current;
+
+	sched_submit_work(tsk);
 	__schedule();
 }
 EXPORT_SYMBOL(schedule);


