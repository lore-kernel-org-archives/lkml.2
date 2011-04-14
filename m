Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757693Ab1DNIdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:33:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:47117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757398Ab1DNIdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:33:02 -0400
Date: Thu, 14 Apr 2011 08:31:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-3ca7a440da394808571dad32d33d3bc0389982e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152728.785452014@chello.nl>
References: <20110405152728.785452014@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] sched: Always provide p->on_cpu
Git-Commit-ID: 3ca7a440da394808571dad32d33d3bc0389982e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:31:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ca7a440da394808571dad32d33d3bc0389982e6
Gitweb:     http://git.kernel.org/tip/3ca7a440da394808571dad32d33d3bc0389982e6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:40 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:32 +0200

sched: Always provide p->on_cpu

Always provide p->on_cpu so that we can determine if its on a cpu
without having to lock the rq.

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110405152728.785452014@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    4 +---
 kernel/sched.c        |   46 +++++++++++++++++++++++++++++-----------------
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 758e27a..3435837 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1200,9 +1200,7 @@ struct task_struct {
 	int lock_depth;		/* BKL lock depth */
 
 #ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
-	int oncpu;
-#endif
+	int on_cpu;
 #endif
 
 	int prio, static_prio, normal_prio;
diff --git a/kernel/sched.c b/kernel/sched.c
index a187c3f..cd2593e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -838,18 +838,39 @@ static inline int task_current(struct rq *rq, struct task_struct *p)
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
@@ -865,15 +886,6 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
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
@@ -882,7 +894,7 @@ static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
 	 * SMP rebalancing from interrupt is the only thing that cares
 	 * here.
 	 */
-	next->oncpu = 1;
+	next->on_cpu = 1;
 #endif
 #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
 	raw_spin_unlock_irq(&rq->lock);
@@ -895,12 +907,12 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
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
@@ -2686,8 +2698,8 @@ void sched_fork(struct task_struct *p, int clone_flags)
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
@@ -5776,8 +5788,8 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	rcu_read_unlock();
 
 	rq->curr = rq->idle = idle;
-#if defined(CONFIG_SMP) && defined(__ARCH_WANT_UNLOCKED_CTXSW)
-	idle->oncpu = 1;
+#if defined(CONFIG_SMP)
+	idle->on_cpu = 1;
 #endif
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 
