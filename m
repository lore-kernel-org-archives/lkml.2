Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab1DNIdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:33:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:47129 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757746Ab1DNIdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:33:15 -0400
Date: Thu, 14 Apr 2011 08:32:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-c6eb3dda25892f1f974f5420f63e6721aab02f6f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        frank.rowand@am.sony.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110405152728.826338173@chello.nl>
References: <20110405152728.826338173@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/locking] mutex: Use p->on_cpu for the adaptive spin
Git-Commit-ID: c6eb3dda25892f1f974f5420f63e6721aab02f6f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Apr 2011 08:32:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c6eb3dda25892f1f974f5420f63e6721aab02f6f
Gitweb:     http://git.kernel.org/tip/c6eb3dda25892f1f974f5420f63e6721aab02f6f
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 5 Apr 2011 17:23:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Apr 2011 08:52:33 +0200

mutex: Use p->on_cpu for the adaptive spin

Since we now have p->on_cpu unconditionally available, use it to
re-implement mutex_spin_on_owner.

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110405152728.826338173@chello.nl
---
 include/linux/mutex.h |    2 +-
 include/linux/sched.h |    2 +-
 kernel/mutex-debug.c  |    2 +-
 kernel/mutex-debug.h  |    2 +-
 kernel/mutex.c        |    2 +-
 kernel/mutex.h        |    2 +-
 kernel/sched.c        |   83 +++++++++++++++++++-----------------------------
 7 files changed, 39 insertions(+), 56 deletions(-)

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 94b48bd..c75471d 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -51,7 +51,7 @@ struct mutex {
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #if defined(CONFIG_DEBUG_MUTEXES) || defined(CONFIG_SMP)
-	struct thread_info	*owner;
+	struct task_struct	*owner;
 #endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	const char 		*name;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3435837..1738504 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -360,7 +360,7 @@ extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
-extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index ec815a9..73da83a 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -75,7 +75,7 @@ void debug_mutex_unlock(struct mutex *lock)
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	DEBUG_LOCKS_WARN_ON(lock->owner != current);
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 }
diff --git a/kernel/mutex-debug.h b/kernel/mutex-debug.h
index 57d527a..0799fd3 100644
--- a/kernel/mutex-debug.h
+++ b/kernel/mutex-debug.h
@@ -29,7 +29,7 @@ extern void debug_mutex_init(struct mutex *lock, const char *name,
 
 static inline void mutex_set_owner(struct mutex *lock)
 {
-	lock->owner = current_thread_info();
+	lock->owner = current;
 }
 
 static inline void mutex_clear_owner(struct mutex *lock)
diff --git a/kernel/mutex.c b/kernel/mutex.c
index c4195fa..fe4706c 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -160,7 +160,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	 */
 
 	for (;;) {
-		struct thread_info *owner;
+		struct task_struct *owner;
 
 		/*
 		 * If we own the BKL, then don't spin. The owner of
diff --git a/kernel/mutex.h b/kernel/mutex.h
index 67578ca..4115fbf 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -19,7 +19,7 @@
 #ifdef CONFIG_SMP
 static inline void mutex_set_owner(struct mutex *lock)
 {
-	lock->owner = current_thread_info();
+	lock->owner = current;
 }
 
 static inline void mutex_clear_owner(struct mutex *lock)
diff --git a/kernel/sched.c b/kernel/sched.c
index cd2593e..55cc503 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4173,70 +4173,53 @@ need_resched:
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
