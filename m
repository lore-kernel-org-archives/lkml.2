Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1ADPMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:12:06 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54757 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1ADPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:04 -0500
Message-Id: <20110104150102.359234524@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:30 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 01/18] sched: Always provide p->on_cpu
References: <20110104145929.772813816@chello.nl>
Content-Disposition: inline; filename=sched-on_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always provide p->on_cpu so that we can determine if its on a cpu
without having to lock the rq.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/sched.h |    4 +---
 kernel/sched.c        |   46 +++++++++++++++++++++++++++++-----------------
 2 files changed, 30 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -845,18 +845,39 @@ static inline int task_current(struct rq
 	return rq->curr == p;
 }
 
-#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline int task_running(struct rq *rq, struct task_struct *p)
 {
+#ifdef CONFIG_SMP
+	return p->on_cpu;
+#else
 	return task_current(rq, p);
+#endif
 }
 
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
+#ifdef CONFIG_SMP
+	/*
+	 * We can optimise this out completely for !SMP, because the
+	 * SMP rebalancing from interrupt is the only thing that cares
+	 * here.
+	 */
+	next->on_cpu = 1;
+#endif
 }
 
 static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 {
+#ifdef CONFIG_SMP
+	/*
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
+	 * We must ensure this doesn't happen until the switch is completely
+	 * finished.
+	 */
+	smp_wmb();
+	prev->on_cpu = 0;
+#endif
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
 	rq->lock.owner = current;
@@ -872,15 +893,6 @@ static inline void finish_lock_switch(st
 }
 
 #else /* __ARCH_WANT_UNLOCKED_CTXSW */
-static inline int task_running(struct rq *rq, struct task_struct *p)
-{
-#ifdef CONFIG_SMP
-	return p->oncpu;
-#else
-	return task_current(rq, p);
-#endif
-}
-
 static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 {
 #ifdef CONFIG_SMP
@@ -889,7 +901,7 @@ static inline void prepare_lock_switch(s
 	 * SMP rebalancing from interrupt is the only thing that cares
 	 * here.
 	 */
-	next->oncpu = 1;
+	next->on_cpu = 1;
 #endif
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	raw_spin_unlock_irq(&rq->lock);
@@ -902,12 +914,12 @@ static inline void finish_lock_switch(st
 {
 #ifdef CONFIG_SMP
 	/*
-	 * After ->oncpu is cleared, the task can be moved to a different CPU.
+	 * After ->on_cpu is cleared, the task can be moved to a different CPU.
 	 * We must ensure this doesn't happen until the switch is completely
 	 * finished.
 	 */
 	smp_wmb();
-	prev->oncpu = 0;
+	prev->on_cpu = 0;
 #endif
 #ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	local_irq_enable();
@@ -2645,8 +2657,8 @@ void sched_fork(struct task_struct *p, i
 	if (likely(sched_info_on()))
 		memset(&p->sched_info, 0, sizeof(p->sched_info));
 #endif
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
-	p->oncpu = 0;
+#if defined(CONFIG_SMP)
+	p->on_cpu = 0;
 #endif
 #ifdef CONFIG_PREEMPT
 	/* Want to start with kernel preemption disabled. */
@@ -5557,8 +5569,8 @@ void __cpuinit init_idle(struct task_str
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
-	idle->oncpu = 1;
+#if defined(CONFIG_SMP)
+	idle->on_cpu = 1;
 #endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1198,9 +1198,7 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
-	int oncpu;
-#endif
+	int on_cpu;
 #endif
 
 	int prio, static_prio, normal_prio;


