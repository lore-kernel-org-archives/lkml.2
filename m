Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab0LOII6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 03:08:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57117 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0LOII5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 03:08:57 -0500
Message-ID: <4D0877D2.10000@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 16:09:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] rtmutex: ensure only the top waiter or higher priority task
 can take the lock and reduce unrelated boosting
References: <4D07330A.7020600@cn.fujitsu.com>	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>	 <4D083900.1050801@cn.fujitsu.com> <1292386606.5015.1862.camel@gandalf.stny.rr.com>
In-Reply-To: <1292386606.5015.1862.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 16:08:52,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 16:08:53,
	Serialize complete at 2010-12-15 16:08:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In current rtmutex, the pending owner may be boosted by the tasks
in the rtmutex waitlist when the pending owner is deboosted
or a task in the waitlist is boosted. This boosting is unrelated,
because the pending owner does not really take the rtmutex.
It is not reasonable.

Example.

time1:
A(high prio) onwers the rtmutex.
B(mid prio) and C (low prio) in the waitlist.

time2
A release the lock, B becomes the pending owner
A(or other high prio task) continues to run. B's prio is lower
than A, so B is just queued at the runqueue.

time3
A or other high prio task sleeps, but we have passed some time
The B and C's prio are changed in the period (time2 ~ time3)
due to boosting or deboosting. Now C has the priority higher
than B. ***Is it reasonable that C has to boost B and help B to
get the rtmutex?

NO!! I think, it is unrelated/unneed boosting before B really
owns the rtmutex. We should give C a change to beat B and
win the rtmutex.

This is the motivation of this patch. This patch ensures
only the top waiter or higher priority task can take the lock.

How?
1) we don't dequeue the top waiter when unlock, if the top waiter
   is changed, the old top waiter will fail and go to sleep.
2) when requiring lock, it will get the lock when it is not locked and:
   there is no waiter OR higher priority than waiters OR it is top waiter.
3) In any time, the top waiter is changed, the top waiter will be wokenup.

The algorithm is much simpler than before, no pending owner, no
boosting for pending owner.

Other advantage of this patch:
1) The states of a rtmutex are reduced a half, easier to read the code.
2) the codes become shorter.
3) top waiter is not dequeued until it really take the lock:
   they will retain FIFO when it is stolen.

Not advantage nor disadvantage
1) Even we may wakeup multiple waiters(any time when top waiter changed),
   we hardly cause "thundering herd",
   the number of wokenup task is likely 1 or very little.
2) two APIs are changed.
   rt_mutex_owner() will not return pending owner, it will return NULL when
                    the top waiter is going to take the lock.
   rt_mutex_next_owner() always return the top waiter.
	                 will not return NULL if we have waiters
                         because the top waiter is not dequeued.

   I have fixed the code that use these APIs.

need updated after this patch is accepted
1) Document/*
2) the testcase scripts/rt-tester/t4-l2-pi-deboost.tst

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/futex.c          |   26 +---
 kernel/rtmutex.c        |  306 ++++++++++++++++--------------------------------
 kernel/rtmutex_common.h |   16 --
 3 files changed, 116 insertions(+), 232 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6c683b3..5f4ea5f 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -775,18 +775,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 		return -EINVAL;
 
 	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
+	/* set new owner to the most possible owner(top waiter). */
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
-	 * This happens when we have stolen the lock and the original
-	 * pending owner did not enqueue itself back on the rt_mutex.
-	 * Thats not a tragedy. We know that way, that a lock waiter
-	 * is on the fly. We make the futex_q waiter the pending owner.
-	 */
-	if (!new_owner)
-		new_owner = this->task;
-
-	/*
 	 * We pass it to the next owner. (The WAITERS bit is always
 	 * kept enabled while there is PI state around. We must also
 	 * preserve the owner died bit.)
@@ -1508,8 +1500,8 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 
 	/*
 	 * We are here either because we stole the rtmutex from the
-	 * pending owner or we are the pending owner which failed to
-	 * get the rtmutex. We have to replace the pending owner TID
+	 * most possible owner or we are the most possible owner which
+	 * failed to get the rtmutex. We have to replace the newowner TID
 	 * in the user space variable. This must be atomic as we have
 	 * to preserve the owner died bit here.
 	 *
@@ -1560,7 +1552,7 @@ retry:
 
 	/*
 	 * To handle the page fault we need to drop the hash bucket
-	 * lock here. That gives the other task (either the pending
+	 * lock here. That gives the other task (either the most possible
 	 * owner itself or the task which stole the rtmutex) the
 	 * chance to try the fixup of the pi_state. So once we are
 	 * back from handling the fault we need to check the pi_state
@@ -1647,18 +1639,20 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
 		/*
 		 * pi_state is incorrect, some other task did a lock steal and
 		 * we returned due to timeout or signal without taking the
-		 * rt_mutex. Too late. We can access the rt_mutex_owner without
-		 * locking, as the other task is now blocked on the hash bucket
-		 * lock. Fix the state up.
+		 * rt_mutex. Too late.
 		 */
+		raw_spin_lock(&q->pi_state->pi_mutex.wait_lock);
 		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
+		if (!owner)
+			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
+		raw_spin_unlock(&q->pi_state->pi_mutex.wait_lock);
 		ret = fixup_pi_state_owner(uaddr, q, owner, fshared);
 		goto out;
 	}
 
 	/*
 	 * Paranoia check. If we did not take the lock, then we should not be
-	 * the owner, nor the pending owner, of the rt_mutex.
+	 * the owner of the rt_mutex.
 	 */
 	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
 		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a960481..53b9b49 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -20,41 +20,29 @@
 /*
  * lock->owner state tracking:
  *
- * lock->owner holds the task_struct pointer of the owner. Bit 0 and 1
- * are used to keep track of the "owner is pending" and "lock has
- * waiters" state.
+ * lock->owner holds the task_struct pointer of the owner. Bit 0
+ * are used to keep track of the "lock has waiters" state.
  *
- * owner	bit1	bit0
- * NULL		0	0	lock is free (fast acquire possible)
- * NULL		0	1	invalid state
- * NULL		1	0	Transitional State*
- * NULL		1	1	invalid state
- * taskpointer	0	0	lock is held (fast release possible)
- * taskpointer	0	1	task is pending owner
- * taskpointer	1	0	lock is held and has waiters
- * taskpointer	1	1	task is pending owner and lock has more waiters
- *
- * Pending ownership is assigned to the top (highest priority)
- * waiter of the lock, when the lock is released. The thread is woken
- * up and can now take the lock. Until the lock is taken (bit 0
- * cleared) a competing higher priority thread can steal the lock
- * which puts the woken up thread back on the waiters list.
+ * owner	bit0
+ * NULL		0	lock is free (fast acquire possible)
+ * NULL		1	lock is free and has waiters and the top waiter
+ *				is going to take the lock*
+ * taskpointer	0	lock is held (fast release possible)
+ * taskpointer	1	lock is held and has waiters
  *
  * The fast atomic compare exchange based acquire and release is only
- * possible when bit 0 and 1 of lock->owner are 0.
+ * possible when bit 0 of lock->owner are 0.
  *
- * (*) There's a small time where the owner can be NULL and the
- * "lock has waiters" bit is set.  This can happen when grabbing the lock.
- * To prevent a cmpxchg of the owner releasing the lock, we need to set this
- * bit before looking at the lock, hence the reason this is a transitional
- * state.
+ * (*) It also can be a transitional state when grabbing the lock
+ * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
+ * we need to set the bit0 before looking at the lock, and the owner may be
+ * NULL in this small time, hence this can be a transitional state.
  */
 
 static void
-rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner,
-		   unsigned long mask)
+rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner)
 {
-	unsigned long val = (unsigned long)owner | mask;
+	unsigned long val = (unsigned long)owner;
 
 	if (rt_mutex_has_waiters(lock))
 		val |= RT_MUTEX_HAS_WAITERS;
@@ -203,15 +191,14 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * reached or the state of the chain has changed while we
 	 * dropped the locks.
 	 */
-	if (!waiter || !waiter->task)
+	if (!waiter)
 		goto out_unlock_pi;
 
 	/*
 	 * Check the orig_waiter state. After we dropped the locks,
 	 * the previous owner of the lock might have released the lock
-	 * and made us the pending owner:
 	 */
-	if (orig_waiter && !orig_waiter->task)
+	if (orig_waiter && !rt_mutex_owner(orig_lock))
 		goto out_unlock_pi;
 
 	/*
@@ -254,6 +241,17 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 	/* Release the task */
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	if (!rt_mutex_owner(lock)) {
+		/*
+		 * If the requeue above changed the top waiter, then we need
+		 * to wake the new top waiter up to try to get the lock.
+		 */
+
+		if (top_waiter != rt_mutex_top_waiter(lock))
+			wake_up_process(rt_mutex_top_waiter(lock)->task);
+		raw_spin_unlock(&lock->wait_lock);
+		goto out_put_task;
+	}
 	put_task_struct(task);
 
 	/* Grab the next task */
@@ -296,78 +294,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 }
 
 /*
- * Optimization: check if we can steal the lock from the
- * assigned pending owner [which might not have taken the
- * lock yet]:
- */
-static inline int try_to_steal_lock(struct rt_mutex *lock,
-				    struct task_struct *task)
-{
-	struct task_struct *pendowner = rt_mutex_owner(lock);
-	struct rt_mutex_waiter *next;
-	unsigned long flags;
-
-	if (!rt_mutex_owner_pending(lock))
-		return 0;
-
-	if (pendowner == task)
-		return 1;
-
-	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
-	if (task->prio >= pendowner->prio) {
-		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-		return 0;
-	}
-
-	/*
-	 * Check if a waiter is enqueued on the pending owners
-	 * pi_waiters list. Remove it and readjust pending owners
-	 * priority.
-	 */
-	if (likely(!rt_mutex_has_waiters(lock))) {
-		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-		return 1;
-	}
-
-	/* No chain handling, pending owner is not blocked on anything: */
-	next = rt_mutex_top_waiter(lock);
-	plist_del(&next->pi_list_entry, &pendowner->pi_waiters);
-	__rt_mutex_adjust_prio(pendowner);
-	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-
-	/*
-	 * We are going to steal the lock and a waiter was
-	 * enqueued on the pending owners pi_waiters queue. So
-	 * we have to enqueue this waiter into
-	 * task->pi_waiters list. This covers the case,
-	 * where task is boosted because it holds another
-	 * lock and gets unboosted because the booster is
-	 * interrupted, so we would delay a waiter with higher
-	 * priority as task->normal_prio.
-	 *
-	 * Note: in the rare case of a SCHED_OTHER task changing
-	 * its priority and thus stealing the lock, next->task
-	 * might be task:
-	 */
-	if (likely(next->task != task)) {
-		raw_spin_lock_irqsave(&task->pi_lock, flags);
-		plist_add(&next->pi_list_entry, &task->pi_waiters);
-		__rt_mutex_adjust_prio(task);
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
-	}
-	return 1;
-}
-
-/*
  * Try to take an rt-mutex
  *
- * This fails
- * - when the lock has a real owner
- * - when a different pending owner exists and has higher priority than current
- *
  * Must be called with lock->wait_lock held.
+ *
+ * @lock:	the lock to be acquired.
+ * @task:	the task which want to acquire the lock
+ * @waiter:	the waiter queued to the lock's wait list. (could be NULL)
  */
-static int try_to_take_rt_mutex(struct rt_mutex *lock)
+static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
+		struct rt_mutex_waiter *waiter)
 {
 	/*
 	 * We have to be careful here if the atomic speedups are
@@ -390,15 +326,52 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
 	 */
 	mark_rt_mutex_waiters(lock);
 
-	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
+	if (rt_mutex_owner(lock))
 		return 0;
 
+	/*
+	 * It will get the lock because at least one of these conditions:
+	 * 1) there is no waiter
+	 * 2) higher priority than waiters
+	 * 3) it is top waiter
+	 */
+	if (rt_mutex_has_waiters(lock)) {
+		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio) {
+			if (!waiter || waiter != rt_mutex_top_waiter(lock))
+				return 0;
+		}
+	}
+
+	if (waiter || rt_mutex_has_waiters(lock)) {
+		unsigned long flags;
+		struct rt_mutex_waiter *top;
+
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
+
+		/* remove the queued waiter. */
+		if (waiter) {
+			plist_del(&waiter->list_entry, &lock->wait_list);
+			task->pi_blocked_on = NULL;
+		}
+
+		/*
+		 * We have to enqueue the top waiter(if have) into
+		 * task->pi_waiters list and would get boost from it.
+		 */
+		if (rt_mutex_has_waiters(lock)) {
+			top = rt_mutex_top_waiter(lock);
+			top->pi_list_entry.prio = top->list_entry.prio;
+			plist_add(&top->pi_list_entry, &task->pi_waiters);
+		}
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	}
+
 	/* We got the lock. */
 	debug_rt_mutex_lock(lock);
 
-	rt_mutex_set_owner(lock, current, 0);
+	rt_mutex_set_owner(lock, task);
 
-	rt_mutex_deadlock_account_lock(lock, current);
+	rt_mutex_deadlock_account_lock(lock, task);
 
 	return 1;
 }
@@ -436,6 +409,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
+	if (!owner)
+		return 0;
+
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
@@ -472,21 +448,18 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 /*
  * Wake up the next waiter on the lock.
  *
- * Remove the top waiter from the current tasks waiter list and from
- * the lock waiter list. Set it as pending owner. Then wake it up.
+ * Remove the top waiter from the current tasks waiter list and wake it up.
  *
  * Called with lock->wait_lock held.
  */
 static void wakeup_next_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *waiter;
-	struct task_struct *pendowner;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 
 	waiter = rt_mutex_top_waiter(lock);
-	plist_del(&waiter->list_entry, &lock->wait_list);
 
 	/*
 	 * Remove it from current->pi_waiters. We do not adjust a
@@ -495,37 +468,12 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 	 * lock->wait_lock.
 	 */
 	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
-	pendowner = waiter->task;
-	waiter->task = NULL;
 
-	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
+	rt_mutex_set_owner(lock, NULL);
 
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	/*
-	 * Clear the pi_blocked_on variable and enqueue a possible
-	 * waiter into the pi_waiters list of the pending owner. This
-	 * prevents that in case the pending owner gets unboosted a
-	 * waiter with higher priority than pending-owner->normal_prio
-	 * is blocked on the unboosted (pending) owner.
-	 */
-	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
-
-	WARN_ON(!pendowner->pi_blocked_on);
-	WARN_ON(pendowner->pi_blocked_on != waiter);
-	WARN_ON(pendowner->pi_blocked_on->lock != lock);
-
-	pendowner->pi_blocked_on = NULL;
-
-	if (rt_mutex_has_waiters(lock)) {
-		struct rt_mutex_waiter *next;
-
-		next = rt_mutex_top_waiter(lock);
-		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
-	}
-	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
-
-	wake_up_process(pendowner);
+	wake_up_process(waiter->task);
 }
 
 /*
@@ -543,11 +491,13 @@ static void remove_waiter(struct rt_mutex *lock,
 
 	raw_spin_lock_irqsave(&current->pi_lock, flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->task = NULL;
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
-	if (first && owner != current) {
+	if (!owner)
+		return;
+
+	if (first) {
 
 		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
@@ -614,21 +564,19 @@ void rt_mutex_adjust_pi(struct task_struct *task)
  * 			 or TASK_UNINTERRUPTIBLE)
  * @timeout:		 the pre-initialized and started timer, or NULL for none
  * @waiter:		 the pre-initialized rt_mutex_waiter
- * @detect_deadlock:	 passed to task_blocks_on_rt_mutex
  *
  * lock->wait_lock must be held by the caller.
  */
 static int __sched
 __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		    struct hrtimer_sleeper *timeout,
-		    struct rt_mutex_waiter *waiter,
-		    int detect_deadlock)
+		    struct rt_mutex_waiter *waiter)
 {
 	int ret = 0;
 
 	for (;;) {
 		/* Try to acquire the lock: */
-		if (try_to_take_rt_mutex(lock))
+		if (try_to_take_rt_mutex(lock, current, waiter))
 			break;
 
 		/*
@@ -645,39 +593,11 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 				break;
 		}
 
-		/*
-		 * waiter->task is NULL the first time we come here and
-		 * when we have been woken up by the previous owner
-		 * but the lock got stolen by a higher prio task.
-		 */
-		if (!waiter->task) {
-			ret = task_blocks_on_rt_mutex(lock, waiter, current,
-						      detect_deadlock);
-			/*
-			 * If we got woken up by the owner then start loop
-			 * all over without going into schedule to try
-			 * to get the lock now:
-			 */
-			if (unlikely(!waiter->task)) {
-				/*
-				 * Reset the return value. We might
-				 * have returned with -EDEADLK and the
-				 * owner released the lock while we
-				 * were walking the pi chain.
-				 */
-				ret = 0;
-				continue;
-			}
-			if (unlikely(ret))
-				break;
-		}
-
 		raw_spin_unlock(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
-		if (waiter->task)
-			schedule_rt_mutex(lock);
+		schedule_rt_mutex(lock);
 
 		raw_spin_lock(&lock->wait_lock);
 		set_current_state(state);
@@ -698,12 +618,11 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	int ret = 0;
 
 	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
 
 	raw_spin_lock(&lock->wait_lock);
 
 	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock)) {
+	if (try_to_take_rt_mutex(lock, current, NULL)) {
 		raw_spin_unlock(&lock->wait_lock);
 		return 0;
 	}
@@ -717,12 +636,14 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 			timeout->task = NULL;
 	}
 
-	ret = __rt_mutex_slowlock(lock, state, timeout, &waiter,
-				  detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
+
+	if (likely(!ret))
+		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(waiter.task))
+	if (unlikely(ret))
 		remove_waiter(lock, &waiter);
 
 	/*
@@ -737,14 +658,6 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	if (unlikely(timeout))
 		hrtimer_cancel(&timeout->timer);
 
-	/*
-	 * Readjust priority, when we did not get the lock. We might
-	 * have been the pending owner and boosted. Since we did not
-	 * take the lock, the PI boost has to go.
-	 */
-	if (unlikely(ret))
-		rt_mutex_adjust_prio(current);
-
 	debug_rt_mutex_free_waiter(&waiter);
 
 	return ret;
@@ -762,7 +675,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 
 	if (likely(rt_mutex_owner(lock) != current)) {
 
-		ret = try_to_take_rt_mutex(lock);
+		ret = try_to_take_rt_mutex(lock, current, NULL);
 		/*
 		 * try_to_take_rt_mutex() sets the lock waiters
 		 * bit unconditionally. Clean this up.
@@ -992,7 +905,7 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 {
 	__rt_mutex_init(lock, NULL);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
-	rt_mutex_set_owner(lock, proxy_owner, 0);
+	rt_mutex_set_owner(lock, proxy_owner);
 	rt_mutex_deadlock_account_lock(lock, proxy_owner);
 }
 
@@ -1008,7 +921,7 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 			   struct task_struct *proxy_owner)
 {
 	debug_rt_mutex_proxy_unlock(lock);
-	rt_mutex_set_owner(lock, NULL, 0);
+	rt_mutex_set_owner(lock, NULL);
 	rt_mutex_deadlock_account_unlock(proxy_owner);
 }
 
@@ -1034,20 +947,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 
 	raw_spin_lock(&lock->wait_lock);
 
-	mark_rt_mutex_waiters(lock);
-
-	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
-		/* We got the lock for task. */
-		debug_rt_mutex_lock(lock);
-		rt_mutex_set_owner(lock, task, 0);
+	if (try_to_take_rt_mutex(lock, task, NULL)) {
 		raw_spin_unlock(&lock->wait_lock);
-		rt_mutex_deadlock_account_lock(lock, task);
 		return 1;
 	}
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
 
-	if (ret && !waiter->task) {
+	if (ret && !rt_mutex_owner(lock)) {
 		/*
 		 * Reset the return value. We might have
 		 * returned with -EDEADLK and the owner
@@ -1056,6 +963,10 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		 */
 		ret = 0;
 	}
+
+	if (unlikely(ret))
+		remove_waiter(lock, waiter);
+
 	raw_spin_unlock(&lock->wait_lock);
 
 	debug_rt_mutex_print_deadlock(waiter);
@@ -1110,12 +1021,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
-				  detect_deadlock);
+	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(waiter->task))
+	if (unlikely(ret))
 		remove_waiter(lock, waiter);
 
 	/*
@@ -1126,13 +1036,5 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 
 	raw_spin_unlock(&lock->wait_lock);
 
-	/*
-	 * Readjust priority, when we did not get the lock. We might have been
-	 * the pending owner and boosted. Since we did not take the lock, the
-	 * PI boost has to go.
-	 */
-	if (unlikely(ret))
-		rt_mutex_adjust_prio(current);
-
 	return ret;
 }
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index 97a2f81..53a66c8 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -91,9 +91,8 @@ task_top_pi_waiter(struct task_struct *p)
 /*
  * lock->owner state tracking:
  */
-#define RT_MUTEX_OWNER_PENDING	1UL
-#define RT_MUTEX_HAS_WAITERS	2UL
-#define RT_MUTEX_OWNER_MASKALL	3UL
+#define RT_MUTEX_HAS_WAITERS	1UL
+#define RT_MUTEX_OWNER_MASKALL	1UL
 
 static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
 {
@@ -101,17 +100,6 @@ static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
 		((unsigned long)lock->owner & ~RT_MUTEX_OWNER_MASKALL);
 }
 
-static inline struct task_struct *rt_mutex_real_owner(struct rt_mutex *lock)
-{
-	return (struct task_struct *)
-		((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
-}
-
-static inline unsigned long rt_mutex_owner_pending(struct rt_mutex *lock)
-{
-	return (unsigned long)lock->owner & RT_MUTEX_OWNER_PENDING;
-}
-
 /*
  * PI-futex support (proxy locking functions, etc.):
  */
diff --git a/scripts/rt-tester/check-all.sh b/scripts/rt-tester/check-all.sh
old mode 100644
new mode 100755
diff --git a/scripts/rt-tester/rt-tester.py b/scripts/rt-tester/rt-tester.py
old mode 100644
new mode 100755
