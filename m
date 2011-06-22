Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394Ab1FVRwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 13:52:19 -0400
Received: from www.linutronix.de ([62.245.132.108]:50487 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab1FVRwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 13:52:15 -0400
Message-Id: <20110622174918.813258321@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 22 Jun 2011 17:52:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch 1/4] sched: Separate the scheduler entry for preemption
References: <20110622174659.496793734@linutronix.de>
Content-Disposition: inline; filename=sched-split-out-regular-schedule.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Block-IO and workqueues call into notifier functions from the
scheduler core code with interrupts and preemption disabled. These
calls should be made before entering the scheduler core.

To simplify this, separate the scheduler core code into
__schedule(). __schedule() is directly called from the places which
set PREEMPT_ACTIVE and from schedule(). This allows us to add the work
checks into schedule(), so they are only called when a task voluntary
goes to sleep.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4210,9 +4210,9 @@ pick_next_task(struct rq *rq)
 }
 
 /*
- * schedule() is the main scheduler function.
+ * __schedule() is the main scheduler function.
  */
-asmlinkage void __sched schedule(void)
+static void __sched __schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
@@ -4300,6 +4300,11 @@ need_resched:
 	if (need_resched())
 		goto need_resched;
 }
+
+asmlinkage void schedule(void)
+{
+	__schedule();
+}
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
@@ -4373,7 +4378,7 @@ asmlinkage void __sched notrace preempt_
 
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
-		schedule();
+		__schedule();
 		sub_preempt_count_notrace(PREEMPT_ACTIVE);
 
 		/*
@@ -4401,7 +4406,7 @@ asmlinkage void __sched preempt_schedule
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
 		local_irq_enable();
-		schedule();
+		__schedule();
 		local_irq_disable();
 		sub_preempt_count(PREEMPT_ACTIVE);
 
@@ -5526,7 +5531,7 @@ static inline int should_resched(void)
 static void __cond_resched(void)
 {
 	add_preempt_count(PREEMPT_ACTIVE);
-	schedule();
+	__schedule();
 	sub_preempt_count(PREEMPT_ACTIVE);
 }
 


