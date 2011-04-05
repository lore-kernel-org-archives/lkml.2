Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1DEPbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:31:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab1DEPbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:31:32 -0400
Message-Id: <20110405152728.826338173@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 05 Apr 2011 17:23:41 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 03/21] mutex: Use p->on_cpu for the adaptive spin
References: <20110405152338.692966333@chello.nl>
Content-Disposition: inline; filename=sched-on_cpu-use.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we now have p->on_cpu unconditionally available, use it to
re-implement mutex_spin_on_owner.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
---
 include/linux/mutex.h |    2 -
 include/linux/sched.h |    2 -
 kernel/mutex-debug.c  |    2 -
 kernel/mutex-debug.h  |    2 -
 kernel/mutex.c        |    2 -
 kernel/mutex.h        |    2 -
 kernel/sched.c        |   83 +++++++++++++++++++-------------------------------
 7 files changed, 39 insertions(+), 56 deletions(-)

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
@@ -4034,70 +4034,53 @@ asmlinkage void __sched schedule(void)
 EXPORT_SYMBOL(schedule);
 
 #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
-/*
- * Look out! "owner" is an entirely speculative pointer
- * access and not reliable.
- */
-int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
-{
-	unsigned int cpu;
-	struct rq *rq;
 
-	if (!sched_feat(OWNER_SPIN))
-		return 0;
+static inline bool owner_running(struct mutex *lock, struct task_struct *owner)
+{
+	bool ret = false;
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	/*
-	 * Need to access the cpu field knowing that
-	 * DEBUG_PAGEALLOC could have unmapped it if
-	 * the mutex owner just released it and exited.
-	 */
-	if (probe_kernel_address(&owner->cpu, cpu))
-		return 0;
-#else
-	cpu = owner->cpu;
-#endif
+	rcu_read_lock();
+	if (lock->owner != owner)
+		goto fail;
 
 	/*
-	 * Even if the access succeeded (likely case),
-	 * the cpu field may no longer be valid.
+	 * Ensure we emit the owner->on_cpu, dereference _after_ checking
+	 * lock->owner still matches owner, if that fails, owner might
+	 * point to free()d memory, if it still matches, the rcu_read_lock()
+	 * ensures the memory stays valid.
 	 */
-	if (cpu >= nr_cpumask_bits)
-		return 0;
+	barrier();
 
-	/*
-	 * We need to validate that we can do a
-	 * get_cpu() and that we have the percpu area.
-	 */
-	if (!cpu_online(cpu))
-		return 0;
+	ret = owner->on_cpu;
+fail:
+	rcu_read_unlock();
 
-	rq = cpu_rq(cpu);
+	return ret;
+}
 
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
+/*
+ * Look out! "owner" is an entirely speculative pointer
+ * access and not reliable.
+ */
+int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
+{
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
 
-		/*
-		 * Is that owner really running on that cpu?
-		 */
-		if (task_thread_info(rq->curr) != owner || need_resched())
+	while (owner_running(lock, owner)) {
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


