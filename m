Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1AKD6I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 22:58:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42215 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab1AKD5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 22:57:25 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=CtiQZArBl4gA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=ikXhpi3zCCg6qiByWTgA:9 a=lg7yyP2V4WSmX8MNsCMA:7 a=R64GKU9DMGS84a5c-YB9XFr51asA:4 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110111035720.844876916@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Jan 2011 22:54:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5/5][RT] rtmutex: Ensure only the top waiter or higher priority task can take the lock
References: <20110111035355.643480133@goodmis.org>
Content-Disposition: inline; filename=0005-rtmutex-Ensure-only-the-top-waiter-or-higher-priorit.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

In current rtmutex, the pending owner may be boosted by the tasks
in the rtmutex's waitlist when the pending owner is deboosted
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
owns the rtmutex. We should give C a chance to beat B and
win the rtmutex.

This is the motivation of this patch. This patch *ensures*
only the top waiter or higher priority task can take the lock.

How?
1) we don't dequeue the top waiter when unlock, if the top waiter
   is changed, the old top waiter will fail and go to sleep again.
2) when requiring lock, it will get the lock when the lock is not taken and:
   there is no waiter OR higher priority than waiters OR it is top waiter.
3) In any time, the top waiter is changed, the top waiter will be woken up.

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

[ Ported to the -rt patch set by Steven Rostedt ]

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D130D23.1040309@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/futex.c          |   13 +-
 kernel/rt.c             |   10 +-
 kernel/rtmutex-debug.c  |    1 -
 kernel/rtmutex.c        |  434 +++++++++++++++++++----------------------------
 kernel/rtmutex_common.h |   18 +--
 5 files changed, 188 insertions(+), 288 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index b9abcfd..1ff5e02 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -774,6 +774,7 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
 		return -EINVAL;
 
 	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
+	/* set new owner to the highest priority waiter (top waiter). */
 	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
 
 	/*
@@ -1514,10 +1515,10 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
 
 	/*
 	 * We are here either because we stole the rtmutex from the
-	 * pending owner or we are the pending owner which failed to
-	 * get the rtmutex. We have to replace the pending owner TID
-	 * in the user space variable. This must be atomic as we have
-	 * to preserve the owner died bit here.
+	 * previous highest priority waiter or we are the highest priority
+	 * waiter but failed to get the rtmutex the first time.
+	 * We have to replace the newowner TID in the user space variable.
+	 * This must be atomic as we have to preserve the owner died bit here.
 	 *
 	 * Note: We write the user space value _before_ changing the pi_state
 	 * because we can fault here. Imagine swapped out pages or a fork
@@ -1566,8 +1567,8 @@ retry:
 
 	/*
 	 * To handle the page fault we need to drop the hash bucket
-	 * lock here. That gives the other task (either the pending
-	 * owner itself or the task which stole the rtmutex) the
+	 * lock here. That gives the other task (either the highest priority
+	 * waiter itself or the task which stole the rtmutex) the
 	 * chance to try the fixup of the pi_state. So once we are
 	 * back from handling the fault we need to check the pi_state
 	 * after reacquiring the hash bucket lock and before trying to
diff --git a/kernel/rt.c b/kernel/rt.c
index ccbf20f..5ace817 100644
--- a/kernel/rt.c
+++ b/kernel/rt.c
@@ -208,7 +208,7 @@ int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 	 * but not when read_depth == 0 which means that the lock is
 	 * write locked.
 	 */
-	if (rt_mutex_real_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current)
 		ret = rt_mutex_trylock(lock);
 	else if (!rwlock->read_depth)
 		ret = 0;
@@ -238,7 +238,7 @@ void __lockfunc rt_read_lock(rwlock_t *rwlock)
 	/*
 	 * recursive read locks succeed when current owns the lock
 	 */
-	if (rt_mutex_real_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current)
 		__rt_spin_lock(lock);
 	rwlock->read_depth++;
 }
@@ -318,7 +318,7 @@ EXPORT_SYMBOL(rt_up_read);
  */
 void  rt_downgrade_write(struct rw_semaphore *rwsem)
 {
-	BUG_ON(rt_mutex_real_owner(&rwsem->lock) != current);
+	BUG_ON(rt_mutex_owner(&rwsem->lock) != current);
 	rwsem->read_depth = 1;
 }
 EXPORT_SYMBOL(rt_downgrade_write);
@@ -357,7 +357,7 @@ int  rt_down_read_trylock(struct rw_semaphore *rwsem)
 	 * but not when read_depth == 0 which means that the rwsem is
 	 * write locked.
 	 */
-	if (rt_mutex_real_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current)
 		ret = rt_mutex_trylock(&rwsem->lock);
 	else if (!rwsem->read_depth)
 		ret = 0;
@@ -376,7 +376,7 @@ static void __rt_down_read(struct rw_semaphore *rwsem, int subclass)
 
 	rwsem_acquire_read(&rwsem->dep_map, subclass, 0, _RET_IP_);
 
-	if (rt_mutex_real_owner(lock) != current)
+	if (rt_mutex_owner(lock) != current)
 		rt_mutex_lock(&rwsem->lock);
 	rwsem->read_depth++;
 }
diff --git a/kernel/rtmutex-debug.c b/kernel/rtmutex-debug.c
index e7e6314..7b87c81 100644
--- a/kernel/rtmutex-debug.c
+++ b/kernel/rtmutex-debug.c
@@ -161,7 +161,6 @@ void debug_rt_mutex_free_waiter(struct rt_mutex_waiter *waiter)
 	put_pid(waiter->deadlock_task_pid);
 	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->list_entry));
 	DEBUG_LOCKS_WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
-	DEBUG_LOCKS_WARN_ON(waiter->task);
 	memset(waiter, 0x22, sizeof(*waiter));
 }
 
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index e218873..824c81c 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -28,41 +28,34 @@
 /*
  * lock->owner state tracking:
  *
- * lock->owner holds the task_struct pointer of the owner. Bit 0 and 1
- * are used to keep track of the "owner is pending" and "lock has
- * waiters" state.
+ * lock->owner holds the task_struct pointer of the owner. Bit 0
+ * is used to keep track of the "lock has waiters" state.
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
+ * taskpointer	1	lock is held and has waiters**
  *
  * The fast atomic compare exchange based acquire and release is only
- * possible when bit 0 and 1 of lock->owner are 0.
+ * possible when bit 0 of lock->owner is 0.
+ *
+ * (*) It also can be a transitional state when grabbing the lock
+ * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
+ * we need to set the bit0 before looking at the lock, and the owner may be
+ * NULL in this small time, hence this can be a transitional state.
  *
- * (*) There's a small time where the owner can be NULL and the
- * "lock has waiters" bit is set.  This can happen when grabbing the lock.
- * To prevent a cmpxchg of the owner releasing the lock, we need to set this
- * bit before looking at the lock, hence the reason this is a transitional
- * state.
+ * (**) There is a small time when bit 0 is set but there are no
+ * waiters. This can happen when grabbing the lock in the slow path.
+ * To prevent a cmpxchg of the owner releasing the lock, we need to
+ * set this bit before looking at the lock.
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
@@ -232,15 +225,14 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * reached or the state of the chain has changed while we
 	 * dropped the locks.
 	 */
-	if (!rt_mutex_real_waiter(waiter) || !waiter->task)
+	if (!rt_mutex_real_waiter(waiter))
 		goto out_unlock_pi;
 
 	/*
 	 * Check the orig_waiter state. After we dropped the locks,
-	 * the previous owner of the lock might have released the lock
-	 * and made us the pending owner:
+	 * the previous owner of the lock might have released the lock.
 	 */
-	if (orig_waiter && !orig_waiter->task)
+	if (orig_waiter && !rt_mutex_owner(orig_lock))
 		goto out_unlock_pi;
 
 	/*
@@ -283,6 +275,22 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 	/* Release the task */
 	raw_spin_unlock(&task->pi_lock);
+	if (!rt_mutex_owner(lock)) {
+		struct rt_mutex_waiter *lock_top_waiter;
+		/*
+		 * If the requeue above changed the top waiter, then we need
+		 * to wake the new top waiter up to try to get the lock.
+		 */
+		lock_top_waiter = rt_mutex_top_waiter(lock);
+		if (top_waiter != lock_top_waiter) {
+			if (lock_top_waiter->savestate)
+				wake_up_process_mutex(lock_top_waiter->task);
+			else
+				wake_up_process(lock_top_waiter->task);
+		}
+		raw_spin_unlock(&lock->wait_lock);
+		goto out_put_task;
+	}
 	put_task_struct(task);
 
 	/* Grab the next task */
@@ -325,77 +333,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 }
 
 /*
- * Optimization: check if we can steal the lock from the
- * assigned pending owner [which might not have taken the
- * lock yet]:
- */
-static inline int try_to_steal_lock(struct rt_mutex *lock,
-				    struct task_struct *task, int mode)
-{
-	struct task_struct *pendowner = rt_mutex_owner(lock);
-	struct rt_mutex_waiter *next;
-
-	if (!rt_mutex_owner_pending(lock))
-		return 0;
-
-	if (pendowner == task)
-		return 1;
-
-	raw_spin_lock(&pendowner->pi_lock);
-	if (!lock_is_stealable(task, pendowner, mode)) {
-		raw_spin_unlock(&pendowner->pi_lock);
-		return 0;
-	}
-
-	/*
-	 * Check if a waiter is enqueued on the pending owners
-	 * pi_waiters list. Remove it and readjust pending owners
-	 * priority.
-	 */
-	if (likely(!rt_mutex_has_waiters(lock))) {
-		raw_spin_unlock(&pendowner->pi_lock);
-		return 1;
-	}
-
-	/* No chain handling, pending owner is not blocked on anything: */
-	next = rt_mutex_top_waiter(lock);
-	plist_del(&next->pi_list_entry, &pendowner->pi_waiters);
-	__rt_mutex_adjust_prio(pendowner);
-	raw_spin_unlock(&pendowner->pi_lock);
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
-		raw_spin_lock(&task->pi_lock);
-		plist_add(&next->pi_list_entry, &task->pi_waiters);
-		__rt_mutex_adjust_prio(task);
-		raw_spin_unlock(&task->pi_lock);
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
+ * @lock:   the lock to be acquired.
+ * @task:   the task which wants to acquire the lock
+ * @waiter: the waiter that is queued to the lock's wait list. (could be NULL)
  */
-static int do_try_to_take_rt_mutex(struct rt_mutex *lock, int mode)
+static int do_try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
+				   struct rt_mutex_waiter *waiter, int mode)
 {
 	/*
 	 * We have to be careful here if the atomic speedups are
@@ -418,22 +365,61 @@ static int do_try_to_take_rt_mutex(struct rt_mutex *lock, int mode)
 	 */
 	mark_rt_mutex_waiters(lock);
 
-	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current, mode))
+	if (rt_mutex_owner(lock))
 		return 0;
 
+	/*
+	 * It will get the lock because of one of these conditions:
+	 * 1) there is no waiter
+	 * 2) higher priority than waiters
+	 * 3) it is top waiter
+	 */
+	if (rt_mutex_has_waiters(lock)) {
+		struct task_struct *pendowner = rt_mutex_top_waiter(lock)->task;
+		if (task != pendowner && !lock_is_stealable(task, pendowner, mode))
+			return 0;
+	}
+
 	/* We got the lock. */
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
+		 * We have to enqueue the top waiter(if it exists) into
+		 * task->pi_waiters list.
+		 */
+		if (rt_mutex_has_waiters(lock)) {
+			top = rt_mutex_top_waiter(lock);
+			top->pi_list_entry.prio = top->list_entry.prio;
+			plist_add(&top->pi_list_entry, &task->pi_waiters);
+		}
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	}
+
 	debug_rt_mutex_lock(lock);
 
-	rt_mutex_set_owner(lock, current, 0);
+	rt_mutex_set_owner(lock, task);
 
-	rt_mutex_deadlock_account_lock(lock, current);
+	rt_mutex_deadlock_account_lock(lock, task);
 
 	return 1;
 }
 
-static inline int try_to_take_rt_mutex(struct rt_mutex *lock)
+static inline int
+try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
+		     struct rt_mutex_waiter *waiter)
 {
-	return do_try_to_take_rt_mutex(lock, STEAL_NORMAL);
+	return do_try_to_take_rt_mutex(lock, task, waiter, STEAL_NORMAL);
 }
 
 /*
@@ -446,7 +432,8 @@ static inline int try_to_take_rt_mutex(struct rt_mutex *lock)
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
 				   struct task_struct *task,
-				   int detect_deadlock, unsigned long flags)
+				   int detect_deadlock, unsigned long flags,
+				   int savestate)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
@@ -473,6 +460,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
+	waiter->savestate = savestate;
 	plist_node_init(&waiter->list_entry, task->prio);
 	plist_node_init(&waiter->pi_list_entry, task->prio);
 
@@ -485,6 +473,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	raw_spin_unlock(&task->pi_lock);
 
+	if (!owner)
+		return 0;
+
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		raw_spin_lock(&owner->pi_lock);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
@@ -521,21 +512,17 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 /*
  * Wake up the next waiter on the lock.
  *
- * Remove the top waiter from the current tasks waiter list and from
- * the lock waiter list. Set it as pending owner. Then wake it up.
+ * Remove the top waiter from the current tasks waiter list and wake it up.
  *
  * Called with lock->wait_lock held.
  */
 static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 {
 	struct rt_mutex_waiter *waiter;
-	struct task_struct *pendowner;
-	struct rt_mutex_waiter *next;
-
-	raw_spin_lock(&current->pi_lock);
+	struct task_struct *top_task;
 
 	waiter = rt_mutex_top_waiter(lock);
-	plist_del(&waiter->list_entry, &lock->wait_list);
+	top_task = waiter->task;
 
 	/*
 	 * Remove it from current->pi_waiters. We do not adjust a
@@ -543,49 +530,20 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 	 * boosted mode and go back to normal after releasing
 	 * lock->wait_lock.
 	 */
+	raw_spin_lock(&current->pi_lock);
 	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
-	pendowner = waiter->task;
-	waiter->task = NULL;
-
-	/*
-	 * Do the wakeup before the ownership change to give any spinning
-	 * waiter grantees a headstart over the other threads that will
-	 * trigger once owner changes.
-	 */
-	if (!savestate)
-		wake_up_process(pendowner);
-	else
-		wake_up_process_mutex(pendowner);
-
-	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
-
 	raw_spin_unlock(&current->pi_lock);
 
-	/*
-	 * Clear the pi_blocked_on variable and enqueue a possible
-	 * waiter into the pi_waiters list of the pending owner. This
-	 * prevents that in case the pending owner gets unboosted a
-	 * waiter with higher priority than pending-owner->normal_prio
-	 * is blocked on the unboosted (pending) owner.
-	 */
+	rt_mutex_set_owner(lock, NULL);
 
-	if (rt_mutex_has_waiters(lock))
-		next = rt_mutex_top_waiter(lock);
+	if (!savestate)
+		wake_up_process(top_task);
 	else
-		next = NULL;
-
-	raw_spin_lock(&pendowner->pi_lock);
-
-	WARN_ON(!pendowner->pi_blocked_on);
-	WARN_ON(pendowner->pi_blocked_on != waiter);
-	WARN_ON(pendowner->pi_blocked_on->lock != lock);
-
-	pendowner->pi_blocked_on = NULL;
-
-	if (next)
-		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
+		wake_up_process_mutex(top_task);
 
-	raw_spin_unlock(&pendowner->pi_lock);
+	WARN_ON(!top_task->pi_blocked_on);
+	WARN_ON(top_task->pi_blocked_on != waiter);
+	WARN_ON(top_task->pi_blocked_on->lock != lock);
 }
 
 /*
@@ -603,11 +561,15 @@ static void remove_waiter(struct rt_mutex *lock,
 
 	raw_spin_lock(&current->pi_lock);
 	plist_del(&waiter->list_entry, &lock->wait_list);
-	waiter->task = NULL;
 	current->pi_blocked_on = NULL;
 	raw_spin_unlock(&current->pi_lock);
 
-	if (first && owner != current) {
+	if (!owner) {
+		BUG_ON(first);
+		return;
+	}
+
+	if (first) {
 
 		raw_spin_lock(&owner->pi_lock);
 
@@ -712,10 +674,6 @@ static int adaptive_wait(struct rt_mutex_waiter *waiter,
 {
 	for (;;) {
 
-		/* we are the owner? */
-		if (!waiter->task)
-			return 0;
-
 		/* Owner changed? Then lets update the original */
 		if (orig_owner != rt_mutex_owner(waiter->lock))
 			return 0;
@@ -795,8 +753,11 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter waiter;
 	unsigned long saved_state, flags;
-	struct task_struct *orig_owner;
+	/* orig_owner is only set if next_waiter is set */
+	struct task_struct *uninitialized_var(orig_owner);
+	int next_waiter;
 	int saved_lock_depth;
+	int ret;
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -804,7 +765,7 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	init_lists(lock);
 
-	if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL)) {
+	if (do_try_to_take_rt_mutex(lock, current, NULL, STEAL_LATERAL)) {
 		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return;
 	}
@@ -831,38 +792,33 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	saved_lock_depth = current->lock_depth;
 	current->lock_depth = -1;
 
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current, 0, flags, 1);
+	BUG_ON(ret);
+
 	for (;;) {
+		int sleep = 1;
 
-		/* Try to acquire the lock */
-		if (do_try_to_take_rt_mutex(lock, STEAL_LATERAL))
+		/* Try to acquire the lock again. */
+		if (do_try_to_take_rt_mutex(lock, current, &waiter, STEAL_LATERAL))
 			break;
 
-		/*
-		 * waiter.task is NULL the first time we come here and
-		 * when we have been woken up by the previous owner
-		 * but the lock got stolen by an higher prio task.
-		 */
-		if (!waiter.task) {
-			task_blocks_on_rt_mutex(lock, &waiter, current, 0,
-						flags);
-			/* Wakeup during boost ? */
-			if (unlikely(!waiter.task))
-				continue;
+		next_waiter = &waiter == rt_mutex_top_waiter(lock);
+		if (next_waiter) {
+			orig_owner = rt_mutex_owner(lock);
+			if (orig_owner)
+				get_task_struct(orig_owner);
 		}
-
-		orig_owner = rt_mutex_owner(lock);
-		get_task_struct(orig_owner);
 		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		if (adaptive_wait(&waiter, orig_owner)) {
-			put_task_struct(orig_owner);
-
-			if (waiter.task)
-				schedule_rt_mutex(lock);
-		} else
+		if (next_waiter && orig_owner) {
+			if (!adaptive_wait(&waiter, orig_owner))
+				sleep = 0;
 			put_task_struct(orig_owner);
+		}
+		if (sleep)
+			schedule_rt_mutex(lock);
 
 		raw_spin_lock_irqsave(&lock->wait_lock, flags);
 		saved_state = rt_set_current_blocked_state(saved_state);
@@ -872,19 +828,14 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
 	rt_restore_current_state(saved_state);
 
 	/*
-	 * Extremely rare case, if we got woken up by a non-mutex wakeup,
-	 * and we managed to steal the lock despite us not being the
-	 * highest-prio waiter (due to SCHED_OTHER changing prio), then we
-	 * can end up with a non-NULL waiter.task:
-	 */
-	if (unlikely(waiter.task))
-		remove_waiter(lock, &waiter, flags);
-	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
 	 * unconditionally. We might have to fix that up:
 	 */
 	fixup_rt_mutex_waiters(lock);
 
+	BUG_ON(rt_mutex_has_waiters(lock) && &waiter == rt_mutex_top_waiter(lock));
+	BUG_ON(!plist_node_empty(&waiter.list_entry));
+
 	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	debug_rt_mutex_free_waiter(&waiter);
@@ -1056,7 +1007,6 @@ static inline void rt_reacquire_bkl(int saved_lock_depth)
  *			 or TASK_UNINTERRUPTIBLE)
  * @timeout:		 the pre-initialized and started timer, or NULL for none
  * @waiter:		 the pre-initialized rt_mutex_waiter
- * @detect_deadlock:	 passed to task_blocks_on_rt_mutex
  *
  * lock->wait_lock must be held by the caller.
  */
@@ -1064,13 +1014,13 @@ static int __sched
 __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		    struct hrtimer_sleeper *timeout,
 		    struct rt_mutex_waiter *waiter,
-		    int detect_deadlock, unsigned long flags)
+		    unsigned long flags)
 {
 	int ret = 0;
 
 	for (;;) {
 		/* Try to acquire the lock: */
-		if (try_to_take_rt_mutex(lock))
+		if (try_to_take_rt_mutex(lock, current, waiter))
 			break;
 
 		/*
@@ -1087,39 +1037,11 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 				break;
 		}
 
-		/*
-		 * waiter->task is NULL the first time we come here and
-		 * when we have been woken up by the previous owner
-		 * but the lock got stolen by a higher prio task.
-		 */
-		if (!waiter->task) {
-			ret = task_blocks_on_rt_mutex(lock, waiter, current,
-						      detect_deadlock, flags);
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
 		raw_spin_unlock_irq(&lock->wait_lock);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
-		if (waiter->task)
-			schedule_rt_mutex(lock);
+		schedule_rt_mutex(lock);
 
 		raw_spin_lock_irq(&lock->wait_lock);
 
@@ -1142,24 +1064,16 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	unsigned long flags;
 
 	debug_rt_mutex_init_waiter(&waiter);
-	waiter.task = NULL;
 
 	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 	init_lists(lock);
 
 	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock)) {
+	if (try_to_take_rt_mutex(lock, current, NULL)) {
 		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return 0;
 	}
 
-	/*
-	 * We drop the BKL here before we go into the wait loop to avoid a
-	 * possible deadlock in the scheduler.
-	 */
-	if (unlikely(current->lock_depth >= 0))
-		saved_lock_depth = rt_release_bkl(lock, flags);
-
 	set_current_state(state);
 
 	/* Setup the timer, when timeout != NULL */
@@ -1169,13 +1083,29 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 			timeout->task = NULL;
 	}
 
-	ret = __rt_mutex_slowlock(lock, state, timeout, &waiter,
-				  detect_deadlock, flags);
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock, flags, 0);
+
+	/*
+	 * We drop the BKL here before we go into the wait loop to avoid a
+	 * possible deadlock in the scheduler.
+	 *
+	 * Note: This must be done after we call task_blocks_on_rt_mutex
+	 *  because rt_release_bkl() releases the wait_lock and will
+	 *  cause a race between setting the mark waiters flag in
+	 *  the owner field and adding this task to the wait list. Those
+	 *  two must be done within the protection of the wait_lock.
+	 */
+	if (unlikely(current->lock_depth >= 0))
+		saved_lock_depth = rt_release_bkl(lock, flags);
+
+	if (likely(!ret))
+		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter, flags);
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(waiter.task))
+	if (unlikely(ret))
 		remove_waiter(lock, &waiter, flags);
+	BUG_ON(!plist_node_empty(&waiter.list_entry));
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -1189,14 +1119,6 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
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
 	/* Must we reaquire the BKL? */
 	if (unlikely(saved_lock_depth >= 0))
 		rt_reacquire_bkl(saved_lock_depth);
@@ -1221,7 +1143,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 
 		init_lists(lock);
 
-		ret = try_to_take_rt_mutex(lock);
+		ret = try_to_take_rt_mutex(lock, current, NULL);
 		/*
 		 * try_to_take_rt_mutex() sets the lock waiters
 		 * bit unconditionally. Clean this up.
@@ -1474,7 +1396,7 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 {
 	__rt_mutex_init(lock, NULL);
 	debug_rt_mutex_proxy_lock(lock, proxy_owner);
-	rt_mutex_set_owner(lock, proxy_owner, 0);
+	rt_mutex_set_owner(lock, proxy_owner);
 	rt_mutex_deadlock_account_lock(lock, proxy_owner);
 }
 
@@ -1490,7 +1412,7 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
 			   struct task_struct *proxy_owner)
 {
 	debug_rt_mutex_proxy_unlock(lock);
-	rt_mutex_set_owner(lock, NULL, 0);
+	rt_mutex_set_owner(lock, NULL);
 	rt_mutex_deadlock_account_unlock(proxy_owner);
 }
 
@@ -1517,22 +1439,15 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 
 	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
-	mark_rt_mutex_waiters(lock);
-
-	if (!rt_mutex_owner(lock) ||
-	    try_to_steal_lock(lock, task, STEAL_NORMAL)) {
-		/* We got the lock for task. */
-		debug_rt_mutex_lock(lock);
-		rt_mutex_set_owner(lock, task, 0);
+	if (try_to_take_rt_mutex(lock, task, NULL)) {
 		raw_spin_unlock(&lock->wait_lock);
-		rt_mutex_deadlock_account_lock(lock, task);
 		return 1;
 	}
 
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock,
-				      flags);
+				      flags, 0);
 
-	if (ret == -EDEADLK && !waiter->task) {
+	if (ret == -EDEADLK && !rt_mutex_owner(lock)) {
 		/*
 		 * Reset the return value. We might have
 		 * returned with -EDEADLK and the owner
@@ -1541,6 +1456,10 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 		 */
 		ret = 0;
 	}
+
+	if (unlikely(ret))
+		remove_waiter(lock, waiter, flags);
+
 	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	debug_rt_mutex_print_deadlock(waiter);
@@ -1596,12 +1515,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
-				  detect_deadlock, flags);
+	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter, flags);
 
 	set_current_state(TASK_RUNNING);
 
-	if (unlikely(waiter->task))
+	if (unlikely(ret))
 		remove_waiter(lock, waiter, flags);
 
 	/*
@@ -1612,13 +1530,5 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 
 	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
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
index 97fc68c..ee1f353 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -43,6 +43,7 @@ extern void schedule_rt_mutex_test(struct rt_mutex *lock);
  * @list_entry:		pi node to enqueue into the mutex waiters list
  * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
  * @task:		task reference to the blocked task
+ * @savestate:		should the task be woken with wake_up_process_mutex?
  */
 struct rt_mutex_waiter {
 	struct plist_node	list_entry;
@@ -54,6 +55,7 @@ struct rt_mutex_waiter {
 	struct pid		*deadlock_task_pid;
 	struct rt_mutex		*deadlock_lock;
 #endif
+	int			savestate;
 };
 
 /*
@@ -91,9 +93,8 @@ task_top_pi_waiter(struct task_struct *p)
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
@@ -101,17 +102,6 @@ static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
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
-- 
1.7.2.3


