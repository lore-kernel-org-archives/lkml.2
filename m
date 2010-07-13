Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0GMLwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 07:52:47 -0400
Received: from www.tglx.de ([62.245.132.106]:42779 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab0GMLwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 07:52:45 -0400
Date: Tue, 13 Jul 2010 13:52:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH][RT] futex: protect against pi_blocked_on corruption during
 requeue PI -V2
In-Reply-To: <alpine.LFD.2.00.1007131222430.3321@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1007131348180.3321@localhost.localdomain>
References: <1278478019.10245.77.camel@marge.simson.net> <alpine.LFD.2.00.1007071356480.2604@localhost.localdomain> <4C3C1DCF.9090509@us.ibm.com> <alpine.LFD.2.00.1007131041230.3321@localhost.localdomain>
 <alpine.LFD.2.00.1007131222430.3321@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Thomas Gleixner wrote:
> 
> This code causes braindamage. I really wonder whether we need to
> remove it according to the "United Nations Convention against Torture
> and Other Cruel, Inhuman or Degrading Treatment or Punishment".
> 

Ok, finally managed to twist my brain around it. Mike, can you give it
a test ride ?

Thanks,

	tglx

-------->
Subject: futex: Protect against pi_blocked_on corruption during requeue PI
From: Darren Hart <dvhltc@us.ibm.com>
Date: Fri, 9 Jul 2010 17:50:23 -0400

The requeue_pi mechanism introduced proxy locking of the rtmutex. This
creates a scenario where a task can wakeup, not knowing it has been
enqueued on an rtmutex. Blocking on an hb->lock() can overwrite a
valid value in current->pi_blocked_on, leading to an inconsistent
state.

Prevent overwriting pi_blocked_on by serializing on the waiter's
pi_lock and using the new PI_WAKEUP_INPROGRESS state flag to indicate
a waiter that has been woken by a timeout or signal. This prevents the
rtmutex code from adding the waiter to the rtmutex wait list,
returning EAGAIN to futex_requeue(), which will in turn ignore the
waiter during a requeue. Care is taken to allow current to block on
locks even if PI_WAKEUP_INPROGRESS is set.

During normal wakeup, this results in one less hb->lock protected
section. In the pre-requeue-timeout-or-signal wakeup, this removes the
"greedy locking" behavior, no attempt will be made to acquire the
lock.

[ tglx: take pi_lock with lock_irq(), removed paranoid warning,
  	plugged pi_state and pi_blocked_on leak, adjusted some
  	comments ]

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <4C3C1DCF.9090509@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/futex.c          |   50 +++++++++++++++++++++++++++++++++-------------
 kernel/rtmutex.c        |   45 ++++++++++++++++++++++++++++++++++-------
 kernel/rtmutex_common.h |    1 +
 kernel/sched.c          |    5 +++-
 4 files changed, 78 insertions(+), 23 deletions(-)

Index: linux-2.6-tip/kernel/futex.c
===================================================================
--- linux-2.6-tip.orig/kernel/futex.c
+++ linux-2.6-tip/kernel/futex.c
@@ -1336,6 +1336,16 @@ retry_private:
 				requeue_pi_wake_futex(this, &key2, hb2);
 				drop_count++;
 				continue;
+			} else if (ret == -EAGAIN) {
+				/*
+				 * Waiter was woken by timeout or
+				 * signal and has set pi_blocked_on to
+				 * PI_WAKEUP_INPROGRESS before we
+				 * tried to enqueue it on the rtmutex.
+				 */
+				this->pi_state = NULL;
+				free_pi_state(pi_state);
+				continue;
 			} else if (ret) {
 				/* -EDEADLK */
 				this->pi_state = NULL;
@@ -2211,9 +2221,9 @@ static int futex_wait_requeue_pi(u32 __u
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
@@ -2255,18 +2265,51 @@ static int futex_wait_requeue_pi(u32 __u
 	/* Queue the futex_q, drop the hb lock, wait for wakeup. */
 	futex_wait_queue_me(hb, &q, to);
 
-	spin_lock(&hb->lock);
-	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
-	spin_unlock(&hb->lock);
-	if (ret)
-		goto out_put_keys;
+	/*
+	 * Avoid races with requeue and trying to block on two mutexes
+	 * (hb->lock and uaddr2's rtmutex) by serializing access to
+	 * pi_blocked_on with pi_lock.
+	 */
+	raw_spin_lock_irq(&current->pi_lock);
+	if (current->pi_blocked_on) {
+		/* Requeue happened already */
+		raw_spin_unlock_irq(&current->pi_lock);
+	} else {
+		/*
+		 * Setting pi_blocked_on to PI_WAKEUP_INPROGRESS
+		 * prevents a concurrent requeue from enqueuein us on
+		 * the uaddr2 rtmutex. After that we can safely
+		 * acquire (and possibly block on) hb->lock.
+		 */
+		current->pi_blocked_on = PI_WAKEUP_INPROGRESS;
+		raw_spin_unlock_irq(&current->pi_lock);
+
+		spin_lock(&hb->lock);
+
+		/*
+		 * Clean up pi_blocked_on. We might leak it otherwise
+		 * when we succeeded with the hb->lock in the fast
+		 * path.
+		 */
+		raw_spin_lock_irq(&current->pi_lock);
+		current->pi_blocked_on = NULL;
+		raw_spin_unlock_irq(&current->pi_lock);
+
+		ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
+		spin_unlock(&hb->lock);
+		if (ret)
+			goto out_put_keys;
+	}
 
 	/*
-	 * In order for us to be here, we know our q.key == key2, and since
-	 * we took the hb->lock above, we also know that futex_requeue() has
-	 * completed and we no longer have to concern ourselves with a wakeup
-	 * race with the atomic proxy lock acquition by the requeue code.
+	 * In order to be here, we have either been requeued, are in
+	 * the process of being requeued, or requeue successfully
+	 * acquired uaddr2 on our behalf.  If pi_blocked_on was
+	 * non-null above, we may be racing with a requeue.  Do not
+	 * rely on q->lock_ptr to be hb2->lock until after blocking on
+	 * hb->lock or hb2->lock.
 	 */
+	hb2 = hash_futex(&key2);
 
 	/* Check if the requeue code acquired the second futex for us. */
 	if (!q.rt_waiter) {
@@ -2275,10 +2318,12 @@ static int futex_wait_requeue_pi(u32 __u
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
@@ -2291,7 +2336,9 @@ static int futex_wait_requeue_pi(u32 __u
 		ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
 		debug_rt_mutex_free_waiter(&rt_waiter);
 
-		spin_lock(q.lock_ptr);
+		spin_lock(&hb2->lock);
+		BUG_ON(&hb2->lock != q.lock_ptr);
+
 		/*
 		 * Fixup the pi_state owner and possibly acquire the lock if we
 		 * haven't already.
Index: linux-2.6-tip/kernel/rtmutex.c
===================================================================
--- linux-2.6-tip.orig/kernel/rtmutex.c
+++ linux-2.6-tip/kernel/rtmutex.c
@@ -82,6 +82,11 @@ static void fixup_rt_mutex_waiters(struc
 		clear_rt_mutex_waiters(lock);
 }
 
+static inline int rt_mutex_real_waiter(struct rt_mutex_waiter *waiter)
+{
+	return waiter && waiter != PI_WAKEUP_INPROGRESS;
+}
+
 /*
  * We can speed up the acquire/release, if the architecture
  * supports cmpxchg and if there's no debugging state to be set up
@@ -227,7 +232,7 @@ static int rt_mutex_adjust_prio_chain(st
 	 * reached or the state of the chain has changed while we
 	 * dropped the locks.
 	 */
-	if (!waiter || !waiter->task)
+	if (!rt_mutex_real_waiter(waiter) || !waiter->task)
 		goto out_unlock_pi;
 
 	/*
@@ -448,6 +453,23 @@ static int task_blocks_on_rt_mutex(struc
 	int chain_walk = 0, res;
 
 	raw_spin_lock(&task->pi_lock);
+
+	/*
+	 * In the case of futex requeue PI, this will be a proxy
+	 * lock. The task will wake unaware that it is enqueueed on
+	 * this lock. Avoid blocking on two locks and corrupting
+	 * pi_blocked_on via the PI_WAKEUP_INPROGRESS
+	 * flag. futex_wait_requeue_pi() sets this when it wakes up
+	 * before requeue (due to a signal or timeout). Do not enqueue
+	 * the task if PI_WAKEUP_INPROGRESS is set.
+	 */
+	if (task != current && task->pi_blocked_on == PI_WAKEUP_INPROGRESS) {
+		raw_spin_unlock(&task->pi_lock);
+		return -EAGAIN;
+	}
+
+	BUG_ON(rt_mutex_real_waiter(task->pi_blocked_on));
+
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
@@ -469,7 +491,7 @@ static int task_blocks_on_rt_mutex(struc
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
 		__rt_mutex_adjust_prio(owner);
-		if (owner->pi_blocked_on)
+		if (rt_mutex_real_waiter(owner->pi_blocked_on))
 			chain_walk = 1;
 		raw_spin_unlock(&owner->pi_lock);
 	}
@@ -624,7 +646,7 @@ static void remove_waiter(struct rt_mute
 		}
 		__rt_mutex_adjust_prio(owner);
 
-		if (owner->pi_blocked_on)
+		if (rt_mutex_real_waiter(owner->pi_blocked_on))
 			chain_walk = 1;
 
 		raw_spin_unlock(&owner->pi_lock);
@@ -658,7 +680,8 @@ void rt_mutex_adjust_pi(struct task_stru
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
-	if (!waiter || waiter->list_entry.prio == task->prio) {
+	if (!rt_mutex_real_waiter(waiter) ||
+	    waiter->list_entry.prio == task->prio) {
 		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
@@ -1527,7 +1550,7 @@ int rt_mutex_start_proxy_lock(struct rt_
 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock,
 				      flags);
 
-	if (ret && !waiter->task) {
+	if (ret == -EDEADLK && !waiter->task) {
 		/*
 		 * Reset the return value. We might have
 		 * returned with -EDEADLK and the owner
Index: linux-2.6-tip/kernel/rtmutex_common.h
===================================================================
--- linux-2.6-tip.orig/kernel/rtmutex_common.h
+++ linux-2.6-tip/kernel/rtmutex_common.h
@@ -115,6 +115,9 @@ static inline unsigned long rt_mutex_own
 /*
  * PI-futex support (proxy locking functions, etc.):
  */
+
+#define PI_WAKEUP_INPROGRESS	((struct rt_mutex_waiter *) 1)
+
 extern struct task_struct *rt_mutex_next_owner(struct rt_mutex *lock);
 extern void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
 				       struct task_struct *proxy_owner);
