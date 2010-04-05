Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0DEUYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:24:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38783 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab0DEUYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:24:37 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Darren Hart <dvhltc@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/6] futex: Add FUTEX_LOCK with optional adaptive spinning
Date: Mon,  5 Apr 2010 13:23:57 -0700
Message-Id: <1270499039-23728-5-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a non-pi TID value based futex locking mechanism. This enables the
use of adaptive spinning which was problematic with the basic FUTEX_WAIT
operation.

V4: Remove update_futex_waiters() and perform all waiter clearing in
    userspace. Turns out to be generally better to do an O(1) operation in
    userspace that forces one extra syscall than to do an O(N) operation during
    every syscall. Go figure :).
    Cleanup timeout when exiting adaptive loop.
    Perform adaptive spinning after retry:
    General cleanups.
V3: Fix some locking bugs
    Use cmpxchg directly in the adaptive loop
    Move the adaptive loop into its own function
    Use FUTEX_WAIT instead of FUTEX_UNLOCK
    Add update_futex_waiters()
V2: Fix preempt-count breakage

This patch is a forward port of the following patch from Peter Zijlstra
with some bug fixes and a reworking of the futex op codes.

> futex: Implement kernel-side adaptive spinning for futexes
>
> This is implemented as a new futex op: FUTEX_WAIT_ADAPTIVE, because it
> requires the futex lock field to contain a TID and regular futexes do
> not have that restriction.
>
> FUTEX_WAIT_ADAPTIVE will spin while the lock owner is running (on a
> different cpu) or until the task gets preempted. After that it behaves
> like FUTEX_WAIT.
>
> The spin loop tries to acquire the lock by cmpxchg(lock, 0, tid) == tid
> on the lower 30 bits (TID_MASK) of the lock field -- leaving the
> WAITERS and OWNER_DIED flags in tact.
>
> NOTE: we could fold mutex_spin_on_owner() and futex_spin_on_owner() by
> adding a lock_owner function argument.
>
>   void lock_spin_on_owner(struct thread_info *(*lock_owner)(void *lock),
>                           void *lock, struct thread_info *owner);
>
> Peter Zijlstra's original patch forward ported by Darren Hart.
>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 include/linux/futex.h |    6 +
 include/linux/sched.h |    1 +
 kernel/futex.c        |  282 +++++++++++++++++++++++++++++++++++++++++++------
 kernel/sched.c        |   59 ++++++++++
 4 files changed, 314 insertions(+), 34 deletions(-)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 1e5a26d..3ca93d1 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -20,6 +20,8 @@
 #define FUTEX_WAKE_BITSET	10
 #define FUTEX_WAIT_REQUEUE_PI	11
 #define FUTEX_CMP_REQUEUE_PI	12
+#define FUTEX_LOCK		13
+#define FUTEX_LOCK_ADAPTIVE	14
 
 #define FUTEX_PRIVATE_FLAG	128
 #define FUTEX_CLOCK_REALTIME	256
@@ -39,6 +41,9 @@
 					 FUTEX_PRIVATE_FLAG)
 #define FUTEX_CMP_REQUEUE_PI_PRIVATE	(FUTEX_CMP_REQUEUE_PI | \
 					 FUTEX_PRIVATE_FLAG)
+#define FUTEX_LOCK_PRIVATE		(FUTEX_LOCK | FUTEX_PRIVATE_FLAG)
+#define FUTEX_LOCK_ADAPTIVE_PRIVATE	(FUTEX_LOCK_ADAPTIVE | \
+					 FUTEX_PRIVATE_FLAG)
 
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
@@ -177,6 +182,7 @@ union futex_key {
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
 extern int futex_cmpxchg_enabled;
+extern struct thread_info *futex_owner(u32 __user *uaddr);
 #else
 static inline void exit_robust_list(struct task_struct *curr)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dad7f66..885d659 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -362,6 +362,7 @@ extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
 asmlinkage void schedule(void);
 extern int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner);
+extern int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner);
 
 struct nsproxy;
 struct user_namespace;
diff --git a/kernel/futex.c b/kernel/futex.c
index 8c1bb16..c33ac2a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -75,6 +75,7 @@ int __read_mostly futex_cmpxchg_enabled;
 #define FLAGS_SHARED		0x01
 #define FLAGS_CLOCKRT		0x02
 #define FLAGS_HAS_TIMEOUT	0x04
+#define FLAGS_ADAPTIVE		0x08
 
 /*
  * Priority Inheritance state:
@@ -368,6 +369,35 @@ static int get_futex_value_locked(u32 *dest, u32 __user *from)
 	return ret ? -EFAULT : 0;
 }
 
+#ifdef CONFIG_SMP
+struct thread_info *futex_owner(u32 __user *uaddr)
+{
+	struct thread_info *ti = NULL;
+	struct task_struct *p;
+	pid_t pid;
+	u32 uval;
+
+	if (get_futex_value_locked(&uval, uaddr))
+		return NULL;
+
+	pid = uval & FUTEX_TID_MASK;
+	rcu_read_lock();
+	p = find_task_by_vpid(pid);
+	if (p) {
+		const struct cred *cred, *pcred;
+
+		cred = current_cred();
+		pcred = __task_cred(p);
+		if (cred->euid == pcred->euid ||
+		    cred->euid == pcred->uid)
+			ti = task_thread_info(p);
+	}
+	rcu_read_unlock();
+
+	return ti;
+}
+#endif
+
 
 /*
  * PI code:
@@ -717,7 +747,7 @@ retry:
  * @hb:			the pi futex hash bucket
  * @key:		the futex key associated with uaddr and hb
  * @ps:			the pi_state pointer where we store the result of the
- *			lookup
+ *			lookup. If non-NULL, hb and key must also be non-NULL.
  * @task:		the task to perform the atomic lock work for.  This will
  *			be "current" except in the case of requeue pi.
  * @set_waiters:	force setting the FUTEX_WAITERS bit (1) or not (0)
@@ -727,7 +757,8 @@ retry:
  *  1 - acquired the lock
  * <0 - error
  *
- * The hb->lock and futex_key refs shall be held by the caller.
+ * The hb->lock and futex_key refs shall be held by the caller if the pi_state
+ * pointer is non-NULL.
  */
 static int lock_pi_futex_atomic(u32 __user *uaddr, struct futex_hash_bucket *hb,
 				union futex_key *key,
@@ -741,37 +772,32 @@ retry:
 	ret = lock_futex_atomic(uaddr, task, set_waiters);
 	if (ret)
 		return ret;
-
-	/*
-	 * We dont have the lock. Look up the PI state (or create it if
-	 * we are the first waiter):
+ 	/*
+	 * We don't have the lock.
+	 * Look up the PI state (or create it if we are the first waiter).
+	 * futex_lock_atomic() calls us with ps==NULL for non-pi atomic futex
+	 * acquisition.
 	 */
-	if (get_futex_value_locked(&uval, uaddr))
-		return -EFAULT;
-	ret = lookup_pi_state(uval, hb, key, ps);
+	if (ps)
+		ret = lookup_pi_state(uval, hb, key, ps);
 
-	if (unlikely(ret)) {
-		switch (ret) {
-		case -ESRCH:
-			/*
-			 * No owner found for this futex. Check if the
-			 * OWNER_DIED bit is set to figure out whether
-			 * this is a robust futex or not.
-			 */
-			if (get_futex_value_locked(&uval, uaddr))
-				return -EFAULT;
+	if (!ps || unlikely(ret) == -ESRCH) {
+		/*
+		 * No owner found for this futex. Check if the
+		 * OWNER_DIED bit is set to figure out whether
+		 * this is a robust futex or not.
+		 */
+		if (get_futex_value_locked(&uval, uaddr))
+			return -EFAULT;
 
-			/*
-			 * We simply start over in case of a robust
-			 * futex. The code above will take the futex
-			 * and return happy.
-			 */
-			if (uval & FUTEX_OWNER_DIED)
-				goto retry;
-		default:
-			break;
-		}
-	}
+		/*
+		 * We simply start over in case of a robust
+		 * futex. The code above will take the futex
+		 * and return happy.
+		 */
+		if (uval & FUTEX_OWNER_DIED)
+			goto retry;
+  	}
 
 	return ret;
 }
@@ -874,13 +900,13 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 	return 0;
 }
 
-static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
+static int unlock_futex(u32 __user *uaddr, u32 uval)
 {
 	u32 oldval;
 
 	/*
 	 * There is no waiter, so we unlock the futex. The owner died
-	 * bit has not to be preserved here. We are the owner:
+	 * bit does not need to be preserved here. We are the owner:
 	 */
 	oldval = cmpxchg_futex_value_locked(uaddr, uval, 0);
 
@@ -2112,7 +2138,7 @@ retry:
 	 * No waiters - kernel unlocks the futex:
 	 */
 	if (!(uval & FUTEX_OWNER_DIED)) {
-		ret = unlock_futex_pi(uaddr, uval);
+		ret = unlock_futex(uaddr, uval);
 		if (ret == -EFAULT)
 			goto pi_faulted;
 	}
@@ -2356,6 +2382,187 @@ out:
 	return ret;
 }
 
+/**
+ * trylock_futex_adaptive() - Try to acquire the futex lock in a busy loop
+ * @uaddr: the futex user address
+ *
+ * Try to acquire a futex lock in a loop until the owner changes or the owner
+ * is descheduled. To lock the futex, set the value to the current TID.
+ *
+ * Returns:
+ *  0 - Gave up, lock not acquired
+ *  1 - Futex lock acquired
+ * <0 - On error
+ */
+static int trylock_futex_adaptive(u32 __user *uaddr)
+{
+	int ret = 0;
+	u32 curval;
+
+	for (;;) {
+		struct thread_info *owner;
+
+		owner = futex_owner(uaddr);
+		if (owner && futex_spin_on_owner(uaddr, owner))
+			break;
+
+		/*
+		 * Try to acquire the lock. If we acquire it or error out,
+		 * break to enable preemption and handle ret outside the loop.
+		 */
+		curval = cmpxchg_futex_value_locked(uaddr, 0,
+		                                    task_pid_vnr(current));
+
+		if (curval == 0) {
+			ret = 1;
+			break;
+		}
+
+		if (unlikely(curval == -EFAULT)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		/*
+		 * Futex locks manage the owner atomically. We are not in
+		 * danger of deadlock by preempting a pending owner. Abort the
+		 * loop if our time slice has expired.  RT Threads can spin
+		 * until they preempt the owner, at which point they will break
+		 * out of the loop anyway.
+		 */
+		if (need_resched())
+			break;
+
+		cpu_relax();
+	}
+	return ret;
+}
+
+/**
+ * futex_lock() - Acquire the lock and set the futex value
+ * @uaddr:  the futex user address
+ * @flags:  futex flags (FLAGS_SHARED, FLAGS_CLOCKRT, FLAGS_ADAPTIVE, etc.)
+ * @detect: detect deadlock (1) or not (0)
+ * @time:   absolute timeout
+ *
+ * futex_(un)lock() define a futex value policy and implement a full mutex. The
+ * futex value stores the owner's TID or'd with FUTEX_WAITERS and/or
+ * FUTEX_OWNER_DIED as appropriate.
+ *
+ * Userspace tried a 0 -> TID atomic transition of the futex value and failed.
+ * Try to acquire the lock in the kernel, blocking if necessary. Return to
+ * userspace with the lock held and the futex value set accordingly (or after a
+ * timeout).
+ *
+ * Returns:
+ *  0 - On success
+ * <0 - On error
+ */
+static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time)
+{
+	struct hrtimer_sleeper timeout, *to = NULL;
+	struct futex_hash_bucket *hb;
+	struct futex_q q = FUTEX_Q_INIT;
+	int ret = 0;
+
+	if (refill_pi_state_cache())
+		return -ENOMEM;
+
+	if (time) {
+		to = &timeout;
+		hrtimer_init_on_stack(&to->timer, CLOCK_REALTIME,
+				      HRTIMER_MODE_ABS);
+		hrtimer_init_sleeper(to, current);
+		hrtimer_set_expires(&to->timer, *time);
+	}
+
+retry:
+#ifdef CONFIG_SMP
+	if (flags & FLAGS_ADAPTIVE) {
+		preempt_disable();
+		ret = trylock_futex_adaptive(uaddr);
+		preempt_enable();
+
+		/* We got the lock. */
+		if (ret == 1) {
+			ret = 0;
+			goto out;
+		}
+
+		/* We encountered an error, -EFAULT most likely. */
+		if (ret)
+			goto out;
+	}
+#endif
+	q.key = FUTEX_KEY_INIT;
+	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
+	if (unlikely(ret != 0))
+		goto out;
+
+	hb = queue_lock(&q);
+
+	ret = lock_futex_atomic(uaddr, current, 0);
+	if (unlikely(ret)) {
+		switch (ret) {
+		case 1:
+			/* We got the lock. */
+			ret = 0;
+			goto out_unlock_put_key;
+		case -EFAULT:
+			goto uaddr_faulted;
+		default:
+			goto out_unlock_put_key;
+		}
+	}
+	/*
+	 * Only actually queue now that the atomic ops are done:
+	 */
+	futex_wait_queue_me(hb, &q, to);
+
+	ret = unqueue_me(&q);
+
+	/* If we were woken by the owner, try and acquire the lock. */
+	if (!ret)
+		goto retry;
+
+	ret = -ETIMEDOUT;
+	if (to && !to->task)
+		goto out_put_key;
+
+	/*
+	 * We expect signal_pending(current), but we might be the
+	 * victim of a spurious wakeup as well.
+         */
+	ret = -ERESTARTNOINTR;
+	if (!signal_pending(current)) {
+		put_futex_key(&q.key);
+		goto retry;
+	}
+
+	goto out_put_key;
+
+out_unlock_put_key:
+	queue_unlock(&q, hb);
+
+out_put_key:
+	put_futex_key(&q.key);
+out:
+	if (to)
+		destroy_hrtimer_on_stack(&to->timer);
+	return ret != -EINTR ? ret : -ERESTARTNOINTR;
+
+uaddr_faulted:
+	queue_unlock(&q, hb);
+
+	ret = fault_in_user_writeable(uaddr);
+	if (ret)
+		goto out_put_key;
+
+	put_futex_key(&q.key);
+	goto retry;
+}
+
+
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.
@@ -2623,6 +2830,12 @@ long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	case FUTEX_CMP_REQUEUE_PI:
 		ret = futex_requeue(uaddr, flags, uaddr2, val, val2, &val3, 1);
 		break;
+	case FUTEX_LOCK_ADAPTIVE:
+		flags |= FLAGS_ADAPTIVE;
+	case FUTEX_LOCK:
+		if (futex_cmpxchg_enabled)
+			ret = futex_lock(uaddr, flags, val, timeout);
+		break;
 	default:
 		ret = -ENOSYS;
 	}
@@ -2641,7 +2854,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 
 	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
 		      cmd == FUTEX_WAIT_BITSET ||
-		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
+		      cmd == FUTEX_WAIT_REQUEUE_PI ||
+		      cmd == FUTEX_LOCK || cmd == FUTEX_LOCK_ADAPTIVE)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
diff --git a/kernel/sched.c b/kernel/sched.c
index 9ab3cd7..a2dbb5b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3818,6 +3818,65 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
 out:
 	return 1;
 }
+
+#ifdef CONFIG_FUTEX
+#include <linux/futex.h>
+
+int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner)
+{
+	unsigned int cpu;
+	struct rq *rq;
+
+	if (!sched_feat(OWNER_SPIN))
+		return 0;
+
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/*
+	 * Need to access the cpu field knowing that
+	 * DEBUG_PAGEALLOC could have unmapped it if
+	 * the mutex owner just released it and exited.
+	 */
+	if (probe_kernel_address(&owner->cpu, cpu))
+		goto out;
+#else
+	cpu = owner->cpu;
+#endif
+
+	/*
+	 * Even if the access succeeded (likely case),
+	 * the cpu field may no longer be valid.
+	 */
+	if (cpu >= nr_cpumask_bits)
+		goto out;
+
+	/*
+	 * We need to validate that we can do a
+	 * get_cpu() and that we have the percpu area.
+	 */
+	if (!cpu_online(cpu))
+		goto out;
+
+	rq = cpu_rq(cpu);
+
+	for (;;) {
+		/*
+		 * Owner changed, break to re-assess state.
+		 */
+		if (futex_owner(uaddr) != owner)
+			break;
+
+		/*
+		 * Is that owner really running on that cpu?
+		 */
+		if (task_thread_info(rq->curr) != owner || need_resched())
+			return 0;
+
+		cpu_relax();
+	}
+out:
+	return 1;
+}
+#endif
 #endif
 
 #ifdef CONFIG_PREEMPT
-- 
1.6.3.3

