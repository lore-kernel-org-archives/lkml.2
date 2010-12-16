Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab0LPT3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:29:17 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36157 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab0LPT3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:29:16 -0500
Subject: Re: [RFC][PATCH 2/5] mutex: Use p->oncpu for the adaptive spin
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101216173430.GA12841@redhat.com>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.814666573@chello.nl>  <20101216173430.GA12841@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 20:29:03 +0100
Message-ID: <1292527743.2708.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 18:34 +0100, Oleg Nesterov wrote:
> On 12/16, Peter Zijlstra wrote:
> >
> > @@ -3867,52 +3866,29 @@ int mutex_spin_on_owner(struct mutex *lo
> >  	 * DEBUG_PAGEALLOC could have unmapped it if
> >  	 * the mutex owner just released it and exited.
> >  	 */
> > +	if (probe_kernel_address(&owner->oncpu, oncpu))
> >  		return 0;
> >  #else
> > +	oncpu = owner->oncpu;
> >  #endif
> >
> > +	if (!oncpu)
> >  		return 0;
> >
> > +	while (lock->owner == owner && owner->oncpu) {
> 
> It seems, this owner->oncpu dereference needs probe_kernel_address() too.
> Of course, only in theory.
> 
> OTOH, I do not understand why we need the first "if (!oncpu)" check
> (and "int oncpu" at all).

Probably because I got my head in a twist.. I wanted to keep the
probe_kernel_address() stuff there so that we wouldn't dereference a
dead owner pointer, however..

I then later figured that the: lock->owner == owner, test is already
sufficient for that, if owner died and went away, it would have released
the mutex already (unless something really bad happened, in which case
this wouldn't be the first explosion).

So yea, I think we can simplify all this even further, but we do need a
smp_rmb() in between those two checks, hmm, and RCU.

How about this?


---
Subject: mutex: Use p->oncpu for the adaptive spin
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Dec 15 18:37:21 CET 2010

Since we no have p->oncpu unconditionally available, use it to spin
on.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/mutex.h |    2 -
 include/linux/sched.h |    2 -
 kernel/mutex-debug.c  |    2 -
 kernel/mutex-debug.h  |    2 -
 kernel/mutex.c        |    2 -
 kernel/mutex.h        |    2 -
 kernel/sched.c        |   87 +++++++++++++++++++++-----------------------------
 7 files changed, 43 insertions(+), 56 deletions(-)

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
@@ -3979,70 +3979,57 @@ asmlinkage void __sched schedule(void)
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
+	 * Ensure we've finished the lock->owner load before dereferencing
+	 * owner. Matches the smp_wmb() in finish_lock_switch().
+	 *
+	 * If the previous branch fails, dereferencing owner is not safe
+	 * anymore because it could have exited and freed the task_struct.
+	 *
+	 * If it was true, the task ref is still valid because of us holding
+	 * the rcu_read_lock().
 	 */
-	if (cpu >= nr_cpumask_bits)
-		return 0;
+	smp_rmb();
 
-	/*
-	 * We need to validate that we can do a
-	 * get_cpu() and that we have the percpu area.
-	 */
-	if (!cpu_online(cpu))
-		return 0;
+	ret = owner->oncpu;
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

