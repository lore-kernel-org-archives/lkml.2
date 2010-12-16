Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab0LPPPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:15:08 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59356 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab0LPPPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:15:06 -0500
Message-Id: <20101216150920.814666573@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 16 Dec 2010 15:56:04 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/5] mutex: Use p->oncpu for the adaptive spin
References: <20101216145602.899838254@chello.nl>
Content-Disposition: inline; filename=sched-on_cpu-use.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now have p->oncpu unconditionally available, use it to spin
on.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/mutex.h |    2 -
 include/linux/sched.h |    2 -
 kernel/mutex-debug.c  |    2 -
 kernel/mutex-debug.h  |    2 -
 kernel/mutex.c        |    2 -
 kernel/mutex.h        |    2 -
 kernel/sched.c        |   52 +++++++++++++-------------------------------------
 7 files changed, 20 insertions(+), 44 deletions(-)

Index: linux-2.6/include/linux/mutex.h
===================================================================
--- linux-2.6.orig/include/linux/mutex.h
+++ linux-2.6/include/linux/mutex.h
@@ -51,7 +51,7 @@ struct mutex {
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
-	struct thread_info	*owner;
+	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
Index: linux-2.6/kernel/mutex-debug.c
===================================================================
--- linux-2.6.orig/kernel/mutex-debug.c
+++ linux-2.6/kernel/mutex-debug.c
@@ -75,7 +75,7 @@ void debug_mutex_unlock(struct mutex *lo
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	DEBUG_LOCKS_WARN_ON(lock->owner != current);
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 }
Index: linux-2.6/kernel/mutex-debug.h
===================================================================
--- linux-2.6.orig/kernel/mutex-debug.h
+++ linux-2.6/kernel/mutex-debug.h
@@ -29,7 +29,7 @@ extern void debug_mutex_init(struct mute
 
 static inline void mutex_set_owner(struct mutex *lock)
 {
-	lock->owner = current_thread_info();
+	lock->owner = current;
 }
 
 static inline void mutex_clear_owner(struct mutex *lock)
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -160,7 +160,7 @@ __mutex_lock_common(struct mutex *lock,
 	 */
 
 	for (;;) {
-		struct thread_info *owner;
+		struct task_struct *owner;
 
 		/*
 		 * If we own the BKL, then don't spin. The owner of
Index: linux-2.6/kernel/mutex.h
===================================================================
--- linux-2.6.orig/kernel/mutex.h
+++ linux-2.6/kernel/mutex.h
@@ -19,7 +19,7 @@
 #ifdef CONFIG_SMP
 static inline void mutex_set_owner(struct mutex *lock)
 {
-	lock->owner = current_thread_info();
+	lock->owner = current;
 }
 
 static inline void mutex_clear_owner(struct mutex *lock)
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -3853,10 +3853,9 @@ EXPORT_SYMBOL(schedule);
  * Look out! "owner" is an entirely speculative pointer
  * access and not reliable.
  */
-int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
+int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 {
-	unsigned int cpu;
-	struct rq *rq;
+	int oncpu;
 
 	if (!sched_feat(OWNER_SPIN))
 		return 0;
@@ -3867,52 +3866,29 @@ int mutex_spin_on_owner(struct mutex *lo
 	 * DEBUG_PAGEALLOC could have unmapped it if
 	 * the mutex owner just released it and exited.
 	 */
-	if (probe_kernel_address(&owner->cpu, cpu))
+	if (probe_kernel_address(&owner->oncpu, oncpu))
 		return 0;
 #else
-	cpu = owner->cpu;
+	oncpu = owner->oncpu;
 #endif
 
-	/*
-	 * Even if the access succeeded (likely case),
-	 * the cpu field may no longer be valid.
-	 */
-	if (cpu >= nr_cpumask_bits)
-		return 0;
-
-	/*
-	 * We need to validate that we can do a
-	 * get_cpu() and that we have the percpu area.
-	 */
-	if (!cpu_online(cpu))
+	if (!oncpu)
 		return 0;
 
-	rq = cpu_rq(cpu);
-
-	for (;;) {
-		/*
-		 * Owner changed, break to re-assess state.
-		 */
-		if (lock->owner != owner) {
-			/*
-			 * If the lock has switched to a different owner,
-			 * we likely have heavy contention. Return 0 to quit
-			 * optimistic spinning and not contend further:
-			 */
-			if (lock->owner)
-				return 0;
-			break;
-		}
-
-		/*
-		 * Is that owner really running on that cpu?
-		 */
-		if (task_thread_info(rq->curr) != owner || need_resched())
+	while (lock->owner == owner && owner->oncpu) {
+		if (need_resched())
 			return 0;
 
 		arch_mutex_cpu_relax();
 	}
 
+	/*
+	 * If the owner changed to another task there is likely
+	 * heavy contention, stop spinning.
+	 */
+	if (lock->owner)
+		return 0;
+
 	return 1;
 }
 #endif
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -360,7 +360,7 @@ extern signed long schedule_timeout_inte
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 
 struct nsproxy;
 struct user_namespace;


