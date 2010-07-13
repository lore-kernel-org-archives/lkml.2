Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0GMIDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:03:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:46839 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab0GMIDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:03:32 -0400
Message-ID: <4C3C1DCF.9090509@us.ibm.com>
Date: Tue, 13 Jul 2010 01:03:27 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH][RT] futex: protect against pi_blocked_on corruption during
 requeue PI
References: <1278478019.10245.77.camel@marge.simson.net> <alpine.LFD.2.00.1007071356480.2604@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1007071356480.2604@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Thomas, Steven, and Mike for hashing this over me. After an
IRC discussion with Thomas, I put the following together. It resolves
the issue for me, Mike please test and let us know if it fixes it for
you. A couple of points of discussion before we commit this:

The use of the new state flag, PI_WAKEUP_INPROGRESS, is pretty ugly.
Would a new task_pi_blocked_on_valid() method be preferred (in
rtmutex.c)? 

The new WARN_ON() in task_blocks_on_rt_mutex() is complex. It didn't
exist before and we've now closed this gap, should we just drop it?

I've added a couple BUG_ON()s in futex_wait_requeue_pi() dealing with
the race with requeue and q.lock_ptr. I'd like to leave this for the
time being if nobody strongly objects.

Thanks,

Darren


>From 93fd3bb97800ebf5e5c1a6a85937bab93256dd42 Mon Sep 17 00:00:00 2001
From: Darren Hart <dvhltc@us.ibm.com>
Date: Fri, 9 Jul 2010 17:50:23 -0400
Subject: [PATCH 1/2] futex: protect against pi_blocked_on corruption during requeue PI

The requeue_pi mechanism introduced proxy locking of the rtmutex.  This creates
a scenario where a task can wakeup, not knowing it has been enqueued on an
rtmutex. Blocking on an hb->lock() can overwrite a valid value in
current->pi_blocked_on, leading to an inconsistent state.

Prevent overwriting pi_blocked_on by serializing on the waiter's pi_lock (a
raw_spinlock) and using the new PI_WAKEUP_INPROGRESS state flag to indicate a
waiter that has been woken by a timeout or signal. This prevents the rtmutex
code from adding the waiter to the rtmutex wait list, returning EAGAIN to
futex_requeue(), which will in turn ignore the waiter during a requeue. Care
is taken to allow current to block on locks even if PI_WAKEUP_INPROGRESS is
set.

During normal wakeup, this results in one less hb->lock protected section. In
the pre-requeue-timeout-or-signal wakeup, this removes the "greedy locking"
behavior, no attempt will be made to acquire the lock.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
---
 kernel/futex.c          |   50 +++++++++++++++++++++++++++++++++-------------
 kernel/rtmutex.c        |   45 ++++++++++++++++++++++++++++++++++-------
 kernel/rtmutex_common.h |    1 +
 kernel/sched.c          |    5 +++-
 4 files changed, 78 insertions(+), 23 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index a6cec32..c92978d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1336,6 +1336,9 @@ retry_private:
 				requeue_pi_wake_futex(this, &key2, hb2);
 				drop_count++;
 				continue;
+			} else if (ret == -EAGAIN) {
+				/* Waiter woken by timeout or signal. */
+				continue;
 			} else if (ret) {
 				/* -EDEADLK */
 				this->pi_state = NULL;
@@ -2211,9 +2214,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 				 int clockrt, u32 __user *uaddr2)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
+	struct futex_hash_bucket *hb, *hb2;
 	struct rt_mutex_waiter rt_waiter;
 	struct rt_mutex *pi_mutex = NULL;
-	struct futex_hash_bucket *hb;
 	union futex_key key2;
 	struct futex_q q;
 	int res, ret;
@@ -2255,18 +2258,33 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
 	futex_wait_queue_me(hb, &q, to);
 
-	spin_lock(&hb->lock);
-	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
-	spin_unlock(&hb->lock);
-	if (ret)
-		goto out_put_keys;
-
 	/*
-	 * In order for us to be here, we know our q.key == key2, and since
-	 * we took the hb->lock above, we also know that futex_requeue() has
-	 * completed and we no longer have to concern ourselves with a wakeup
-	 * race with the atomic proxy lock acquition by the requeue code.
+	 * Avoid races with requeue and trying to block on two mutexes
+	 * (hb->lock and uaddr2's rtmutex) by serializing access to
+	 * pi_blocked_on with pi_lock and setting PI_BLOCKED_ON_PENDING.
+	 */
+	raw_spin_lock(&current->pi_lock);
+	if (current->pi_blocked_on) {
+		raw_spin_unlock(&current->pi_lock);
+	} else {
+		current->pi_blocked_on = (struct rt_mutex_waiter *)PI_WAKEUP_INPROGRESS;
+		raw_spin_unlock(&current->pi_lock);
+
+		spin_lock(&hb->lock);
+		ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
+		spin_unlock(&hb->lock);
+		if (ret)
+			goto out_put_keys;
+	}
+
+	/* 
+	 * In order to be here, we have either been requeued, are in the process
+	 * of being requeued, or requeue successfully acquired uaddr2 on our
+	 * behalf.  If pi_blocked_on was non-null above, we may be racing with a
+	 * requeue.  Do not rely on q->lock_ptr to be hb2->lock until after
+	 * blocking on hb->lock or hb2->lock.
 	 */
+	hb2 = hash_futex(&key2);
 
 	/* Check if the requeue code acquired the second futex for us. */
 	if (!q.rt_waiter) {
@@ -2275,10 +2293,12 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		 * did a lock-steal - fix up the PI-state in that case.
 		 */
 		if (q.pi_state && (q.pi_state->owner != current)) {
-			spin_lock(q.lock_ptr);
+			spin_lock(&hb2->lock);
+			BUG_ON(&hb2->lock != q.lock_ptr);
+
 			ret = fixup_pi_state_owner(uaddr2, &q, current,
 						   fshared);
-			spin_unlock(q.lock_ptr);
+			spin_unlock(&hb2->lock);
 		}
 	} else {
 		/*
@@ -2291,7 +2311,9 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
-		spin_lock(q.lock_ptr);
+		spin_lock(&hb2->lock);
+		BUG_ON(&hb2->lock != q.lock_ptr);
+
 		/*
 		 * Fixup the pi_state owner and possibly acquire the lock if we
 		 * haven't already.
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index 23dd443..0399108 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -227,7 +227,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	 * reached or the state of the chain has changed while we
 	 * dropped the locks.
 	 */
-	if (!waiter || !waiter->task)
+	if (!waiter || (long)waiter == PI_WAKEUP_INPROGRESS || !waiter->task)
 		goto out_unlock_pi;
 
 	/*
@@ -448,6 +448,21 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	int chain_walk = 0, res;
 
 	raw_spin_lock(&task->pi_lock);
+
+	/*
+	 * In the case of futex requeue PI, this will be a proxy lock. The task
+	 * will wake unaware that it is enqueueed on this lock. Avoid blocking
+	 * on two locks and corrupting pi_blocked_on via the
+	 * PI_WAKEUP_INPROGRESS flag. futex_wait_requeue_pi() sets this when it
+	 * wakes up before requeue (due to a signal or timeout). Do not enqueue
+	 * the task if PI_WAKEUP_INPROGRESS is set.
+	 */
+	if (task != current &&
+	    (long)task->pi_blocked_on == PI_WAKEUP_INPROGRESS) {
+		raw_spin_unlock(&task->pi_lock);
+		return -EAGAIN;
+	}
+
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
@@ -459,6 +474,15 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 		top_waiter = rt_mutex_top_waiter(lock);
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
+	/* 
+	 * Tasks can only block on one lock at a time. In the case of futex
+	 * requeue PI, if task == current it may have set PI_WAKEUP_INPROGRESS
+	 * to prevent requeue, but it will still need to acquire locks on its
+	 * way out of futex_wait_requeue_pi().
+ 	 */
+	WARN_ON(task->pi_blocked_on != NULL &&
+	        (task != current || (long)task->pi_blocked_on != PI_WAKEUP_INPROGRESS));
+
 	task->pi_blocked_on = waiter;
 
 	raw_spin_unlock(&task->pi_lock);
@@ -469,7 +493,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
 		__rt_mutex_adjust_prio(owner);
-		if (owner->pi_blocked_on)
+		if (owner->pi_blocked_on &&
+		    (long)owner->pi_blocked_on != PI_WAKEUP_INPROGRESS)
 			chain_walk = 1;
 		raw_spin_unlock(&owner->pi_lock);
 	}
@@ -579,9 +604,11 @@ static void wakeup_next_waiter(struct rt_mutex *lock, int savestate)
 
 	raw_spin_lock(&pendowner->pi_lock);
 
-	WARN_ON(!pendowner->pi_blocked_on);
-	WARN_ON(pendowner->pi_blocked_on != waiter);
-	WARN_ON(pendowner->pi_blocked_on->lock != lock);
+ 	if (!WARN_ON(!pendowner->pi_blocked_on) &&
+ 	    !WARN_ON((long)pendowner->pi_blocked_on == PI_WAKEUP_INPROGRESS)) {
+  		WARN_ON(pendowner->pi_blocked_on != waiter);
+  		WARN_ON(pendowner->pi_blocked_on->lock != lock);
+  	}
 
 	pendowner->pi_blocked_on = NULL;
 
@@ -624,7 +651,8 @@ static void remove_waiter(struct rt_mutex *lock,
 		}
 		__rt_mutex_adjust_prio(owner);
 
-		if (owner->pi_blocked_on)
+		if (owner->pi_blocked_on &&
+		    (long)owner->pi_blocked_on != PI_WAKEUP_INPROGRESS)
 			chain_walk = 1;
 
 		raw_spin_unlock(&owner->pi_lock);
@@ -658,7 +686,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
-	if (!waiter || waiter->list_entry.prio == task->prio) {
+	if (!waiter || (long)waiter == PI_WAKEUP_INPROGRESS ||
+	    waiter->list_entry.prio == task->prio) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
@@ -1527,7 +1556,7 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock,
 				      flags);
 
-	if (ret && !waiter->task) {
+	if (ret == -EDEADLK && !waiter->task) {
 		/*
 		 * Reset the return value. We might have
 		 * returned with -EDEADLK and the owner
diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
index 4df690c..94a856f 100644
--- a/kernel/rtmutex_common.h
+++ b/kernel/rtmutex_common.h
@@ -115,6 +115,7 @@ static inline unsigned long rt_mutex_owner_pending(struct rt_mutex *lock)
 /*
  * PI-futex support (proxy locking functions, etc.):
  */
+#define PI_WAKEUP_INPROGRESS 1
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
diff --git a/kernel/sched.c b/kernel/sched.c
index aa5dced..9d4337e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -83,6 +83,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/sched.h>
 
+#include "rtmutex_common.h"
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -6377,7 +6379,8 @@ void task_setprio(struct task_struct *p, int prio)
 	 */
 	if (unlikely(p == rq->idle)) {
 		WARN_ON(p != rq->curr);
-		WARN_ON(p->pi_blocked_on);
+		WARN_ON(p->pi_blocked_on &&
+		        (long)p->pi_blocked_on != PI_WAKEUP_INPROGRESS);
 		goto out_unlock;
 	}
 
-- 
1.7.0.4

