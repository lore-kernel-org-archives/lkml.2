Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1GSUOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:14:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56766 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403Ab1GSUOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:14:15 -0400
Date: Tue, 19 Jul 2011 13:14:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: laijs@cn.fujitsu.com, darren@dvhart.com, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] rtmutex: Permit rt_mutex_unlock() to be invoked with
 irqs disabled
Message-ID: <20110719201410.GA10553@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because rcu_read_unlock() can be invoked with interrupts disabled, it can
in turn invoke rt_mutex_unlock() with interrupts disabled.  This situation
results in lockdep splats (https://lkml.org/lkml/2011/7/7/362) because the
rt_mutex structure's ->lock_wait is acquired elsewhere without disabling
interrupts, which can result in deadlocks.

This commit therefore changes the rt_mutex structure's ->lock_wait
acquisitions to disable interrupts.

An alternative fix is to prohibit invoking rcu_read_unlock() with
interrupts disabled unless the entire preceding RCU read-side critical
section has run with interrupts disabled.  However, there is already
at least one case in mainline where this potential rule is violated,
and there might well be many more.  These would likely be found one at
a time using the lockdep-water-torture method, hence the alternative
fix in the form of this commit.

Reported-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index ab44911..598c3bf 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -232,7 +232,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	/* Deadlock detection */
 	if (lock == orig_lock || rt_mutex_owner(lock) == top_task) {
 		debug_rt_mutex_deadlock(deadlock_detect, orig_waiter, lock);
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock(&lock->wait_lock); /* irqs remain disabled. */
 		ret = deadlock_detect ? -EDEADLK : 0;
 		goto out_unlock_pi;
 	}
@@ -245,7 +245,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
 	/* Release the task */
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock); /* irqs remain disabled. */
 	if (!rt_mutex_owner(lock)) {
 		/*
 		 * If the requeue above changed the top waiter, then we need
@@ -254,7 +254,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 
 		if (top_waiter != rt_mutex_top_waiter(lock))
 			wake_up_process(rt_mutex_top_waiter(lock)->task);
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		goto out_put_task;
 	}
 	put_task_struct(task);
@@ -262,7 +262,7 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock(&task->pi_lock); /* irqs already disabled. */
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
@@ -280,10 +280,10 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
 		__rt_mutex_adjust_prio(task);
 	}
 
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock); /* irqs remain disabled. */
 
 	top_waiter = rt_mutex_top_waiter(lock);
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	if (!detect_deadlock && waiter != top_waiter)
 		goto out_put_task;
@@ -348,10 +348,9 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 	}
 
 	if (waiter || rt_mutex_has_waiters(lock)) {
-		unsigned long flags;
 		struct rt_mutex_waiter *top;
 
-		raw_spin_lock_irqsave(&task->pi_lock, flags);
+		raw_spin_lock(&task->pi_lock); /* irqs already disabled. */
 
 		/* remove the queued waiter. */
 		if (waiter) {
@@ -368,7 +367,7 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 			top->pi_list_entry.prio = top->list_entry.prio;
 			plist_add(&top->pi_list_entry, &task->pi_waiters);
 		}
-		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock(&task->pi_lock); /* irqs remain disabled. */
 	}
 
 	/* We got the lock. */
@@ -391,14 +390,14 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
 static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 				   struct rt_mutex_waiter *waiter,
 				   struct task_struct *task,
-				   int detect_deadlock)
+				   int detect_deadlock,
+				   unsigned long *flags)
 {
 	struct task_struct *owner = rt_mutex_owner(lock);
 	struct rt_mutex_waiter *top_waiter = waiter;
-	unsigned long flags;
 	int chain_walk = 0, res;
 
-	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock(&task->pi_lock); /* irqs already disabled. */
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
@@ -412,20 +411,20 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 
 	task->pi_blocked_on = waiter;
 
-	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock(&task->pi_lock); /* irqs remain disabled. */
 
 	if (!owner)
 		return 0;
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+		raw_spin_lock(&owner->pi_lock); /* irqs already disabled. */
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
 		__rt_mutex_adjust_prio(owner);
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+		raw_spin_unlock(&owner->pi_lock); /* irqs remain disabled. */
 	}
 	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
 		chain_walk = 1;
@@ -440,12 +439,12 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 	 */
 	get_task_struct(owner);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock(&lock->wait_lock); /* irqs remain disabled. */
 
 	res = rt_mutex_adjust_prio_chain(owner, detect_deadlock, lock, waiter,
 					 task);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock(&lock->wait_lock); /* irqs already disabled. */
 
 	return res;
 }
@@ -460,9 +459,8 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
 static void wakeup_next_waiter(struct rt_mutex *lock)
 {
 	struct rt_mutex_waiter *waiter;
-	unsigned long flags;
 
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock(&current->pi_lock); /* irqs already disabled. */
 
 	waiter = rt_mutex_top_waiter(lock);
 
@@ -476,7 +474,7 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
 
 	rt_mutex_set_owner(lock, NULL);
 
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock(&current->pi_lock); /* irqs remain disabled. */
 
 	wake_up_process(waiter->task);
 }
@@ -488,24 +486,24 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
  * have just failed to try_to_take_rt_mutex().
  */
 static void remove_waiter(struct rt_mutex *lock,
-			  struct rt_mutex_waiter *waiter)
+			  struct rt_mutex_waiter *waiter,
+			  unsigned long *flags)
 {
 	int first = (waiter == rt_mutex_top_waiter(lock));
 	struct task_struct *owner = rt_mutex_owner(lock);
-	unsigned long flags;
 	int chain_walk = 0;
 
-	raw_spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock_irqsave(&current->pi_lock, *flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
 	current->pi_blocked_on = NULL;
-	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&current->pi_lock, *flags);
 
 	if (!owner)
 		return;
 
 	if (first) {
 
-		raw_spin_lock_irqsave(&owner->pi_lock, flags);
+		raw_spin_lock(&owner->pi_lock); /* irqs already disabled. */
 
 		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
 
@@ -520,7 +518,7 @@ static void remove_waiter(struct rt_mutex *lock,
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
 
-		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
+		raw_spin_unlock(&owner->pi_lock); /* irqs remain disabled. */
 	}
 
 	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
@@ -531,11 +529,11 @@ static void remove_waiter(struct rt_mutex *lock,
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(owner);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, *flags);
 
 	rt_mutex_adjust_prio_chain(owner, 0, lock, NULL, current);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irqsave(&lock->wait_lock, *flags);
 }
 
 /*
@@ -576,7 +574,8 @@ void rt_mutex_adjust_pi(struct task_struct *task)
 static int __sched
 __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 		    struct hrtimer_sleeper *timeout,
-		    struct rt_mutex_waiter *waiter)
+		    struct rt_mutex_waiter *waiter,
+		    unsigned long *flags)
 {
 	int ret = 0;
 
@@ -599,13 +598,13 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
 				break;
 		}
 
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, *flags);
 
 		debug_rt_mutex_print_deadlock(waiter);
 
 		schedule_rt_mutex(lock);
 
-		raw_spin_lock(&lock->wait_lock);
+		raw_spin_lock_irqsave(&lock->wait_lock, *flags);
 		set_current_state(state);
 	}
 
@@ -622,14 +621,15 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 {
 	struct rt_mutex_waiter waiter;
 	int ret = 0;
+	unsigned long flags;
 
 	debug_rt_mutex_init_waiter(&waiter);
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	/* Try to acquire the lock again: */
 	if (try_to_take_rt_mutex(lock, current, NULL)) {
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return 0;
 	}
 
@@ -642,15 +642,17 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 			timeout->task = NULL;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, &waiter, current,
+				      detect_deadlock, &flags);
 
 	if (likely(!ret))
-		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
+		ret = __rt_mutex_slowlock(lock, state, timeout,
+					  &waiter, &flags);
 
 	set_current_state(TASK_RUNNING);
 
 	if (unlikely(ret))
-		remove_waiter(lock, &waiter);
+		remove_waiter(lock, &waiter, &flags);
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit
@@ -658,7 +660,7 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	/* Remove pending timer: */
 	if (unlikely(timeout))
@@ -675,9 +677,10 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
 static inline int
 rt_mutex_slowtrylock(struct rt_mutex *lock)
 {
+	unsigned long flags;
 	int ret = 0;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	if (likely(rt_mutex_owner(lock) != current)) {
 
@@ -689,7 +692,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 		fixup_rt_mutex_waiters(lock);
 	}
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	return ret;
 }
@@ -700,7 +703,9 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
 static void __sched
 rt_mutex_slowunlock(struct rt_mutex *lock)
 {
-	raw_spin_lock(&lock->wait_lock);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	debug_rt_mutex_unlock(lock);
 
@@ -708,13 +713,13 @@ rt_mutex_slowunlock(struct rt_mutex *lock)
 
 	if (!rt_mutex_has_waiters(lock)) {
 		lock->owner = NULL;
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return;
 	}
 
 	wakeup_next_waiter(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	/* Undo pi boosting if necessary: */
 	rt_mutex_adjust_prio(current);
@@ -949,16 +954,18 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 			      struct rt_mutex_waiter *waiter,
 			      struct task_struct *task, int detect_deadlock)
 {
+	unsigned long flags;
 	int ret;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	if (try_to_take_rt_mutex(lock, task, NULL)) {
-		raw_spin_unlock(&lock->wait_lock);
+		raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 		return 1;
 	}
 
-	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
+	ret = task_blocks_on_rt_mutex(lock, waiter, task,
+				      detect_deadlock, &flags);
 
 	if (ret && !rt_mutex_owner(lock)) {
 		/*
@@ -971,9 +978,9 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
 	}
 
 	if (unlikely(ret))
-		remove_waiter(lock, waiter);
+		remove_waiter(lock, waiter, &flags);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	debug_rt_mutex_print_deadlock(waiter);
 
@@ -1021,18 +1028,19 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 			       struct rt_mutex_waiter *waiter,
 			       int detect_deadlock)
 {
+	unsigned long flags;
 	int ret;
 
-	raw_spin_lock(&lock->wait_lock);
+	raw_spin_lock_irqsave(&lock->wait_lock, flags);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
+	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter, &flags);
 
 	set_current_state(TASK_RUNNING);
 
 	if (unlikely(ret))
-		remove_waiter(lock, waiter);
+		remove_waiter(lock, waiter, &flags);
 
 	/*
 	 * try_to_take_rt_mutex() sets the waiter bit unconditionally. We might
@@ -1040,7 +1048,7 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
 	 */
 	fixup_rt_mutex_waiters(lock);
 
-	raw_spin_unlock(&lock->wait_lock);
+	raw_spin_unlock_irqrestore(&lock->wait_lock, flags);
 
 	return ret;
 }
