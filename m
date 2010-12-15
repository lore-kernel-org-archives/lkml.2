Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab0LOCSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 21:18:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51686 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab0LOCSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 21:18:39 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=wum_O5HyHpgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=DTyni9LDhRHs0KmJZU0A:9 a=GU_oed8MdnivH8QgP-cA:7 a=lDBjkZUKUhz0C62bkCKFmPayUisA:4 a=PUjeQqilurYA:10 a=HjfrCnRoKQCU_bZ0:21 a=JOADamIWDCBMi6fH:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D07330A.7020600@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 14 Dec 2010 21:18:36 -0500
Message-ID: <1292379516.5015.1837.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 17:04 +0800, Lai Jiangshan wrote:

OK, I was looking at this in a bit more detail (the coffee finally set
in) and I was at first looking to nuke the cand_owner since it is
redundant to cand_seq. But I think we can nuke the cand_seq instead and
use the top_waiter as the decider.

1) it is less racy, as I show below.
2) we don't need to add any new element to the rt_mutex struct. This is
a win, especially for -rt when that struct exists for every spinlock and
mutex in the kernel.

Maybe I'm missing something, but I wrote some comments below.

> Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  include/linux/rtmutex.h |    2 
>  kernel/futex.c          |   25 +--
>  kernel/rtmutex.c        |  339 +++++++++++++++++++-----------------------------
>  kernel/rtmutex_common.h |   20 --
>  4 files changed, 155 insertions(+), 231 deletions(-)
> diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
> index 8d522ff..155ddb3 100644
> --- a/include/linux/rtmutex.h
> +++ b/include/linux/rtmutex.h
> @@ -24,11 +24,13 @@ extern int max_lock_depth; /* for sysctl */
>   * @wait_lock:	spinlock to protect the structure
>   * @wait_list:	pilist head to enqueue waiters in priority order
>   * @owner:	the mutex owner
> + * @cand_seq:	the sequence number for candidate owners
>   */
>  struct rt_mutex {
>  	raw_spinlock_t		wait_lock;
>  	struct plist_head	wait_list;
>  	struct task_struct	*owner;
> +	unsigned long		cand_seq; /* don't need to init it! */

And this.

>  #ifdef CONFIG_DEBUG_RT_MUTEXES
>  	int			save_state;
>  	const char 		*name, *file;
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6c683b3..6db2b92 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -778,15 +778,6 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  	new_owner = rt_mutex_next_owner(&pi_state->pi_mutex);
>  
>  	/*
> -	 * This happens when we have stolen the lock and the original
> -	 * pending owner did not enqueue itself back on the rt_mutex.
> -	 * Thats not a tragedy. We know that way, that a lock waiter
> -	 * is on the fly. We make the futex_q waiter the pending owner.
> -	 */
> -	if (!new_owner)
> -		new_owner = this->task;
> -
> -	/*
>  	 * We pass it to the next owner. (The WAITERS bit is always
>  	 * kept enabled while there is PI state around. We must also
>  	 * preserve the owner died bit.)
> @@ -1508,8 +1499,8 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>  
>  	/*
>  	 * We are here either because we stole the rtmutex from the
> -	 * pending owner or we are the pending owner which failed to
> -	 * get the rtmutex. We have to replace the pending owner TID
> +	 * candidate owner or we are the candidate owner which failed to
> +	 * get the rtmutex. We have to replace the candidate owner TID
>  	 * in the user space variable. This must be atomic as we have
>  	 * to preserve the owner died bit here.
>  	 *
> @@ -1560,7 +1551,7 @@ retry:
>  
>  	/*
>  	 * To handle the page fault we need to drop the hash bucket
> -	 * lock here. That gives the other task (either the pending
> +	 * lock here. That gives the other task (either the candidate
>  	 * owner itself or the task which stole the rtmutex) the
>  	 * chance to try the fixup of the pi_state. So once we are
>  	 * back from handling the fault we need to check the pi_state
> @@ -1647,18 +1638,20 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
>  		/*
>  		 * pi_state is incorrect, some other task did a lock steal and
>  		 * we returned due to timeout or signal without taking the
> -		 * rt_mutex. Too late. We can access the rt_mutex_owner without
> -		 * locking, as the other task is now blocked on the hash bucket
> -		 * lock. Fix the state up.
> +		 * rt_mutex. Too late.
>  		 */
> +		raw_spin_lock(&q->pi_state->pi_mutex.wait_lock);
>  		owner = rt_mutex_owner(&q->pi_state->pi_mutex);
> +		if (!owner)
> +			owner = rt_mutex_next_owner(&q->pi_state->pi_mutex);
> +		raw_spin_unlock(&q->pi_state->pi_mutex.wait_lock);
>  		ret = fixup_pi_state_owner(uaddr, q, owner, fshared);
>  		goto out;
>  	}
>  
>  	/*
>  	 * Paranoia check. If we did not take the lock, then we should not be
> -	 * the owner, nor the pending owner, of the rt_mutex.
> +	 * the owner of the rt_mutex.
>  	 */
>  	if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
>  		printk(KERN_ERR "fixup_owner: ret = %d pi-mutex: %p "
> diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
> index a960481..f5c8065 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -20,41 +20,32 @@
>  /*
>   * lock->owner state tracking:
>   *
> - * lock->owner holds the task_struct pointer of the owner. Bit 0 and 1
> - * are used to keep track of the "owner is pending" and "lock has
> - * waiters" state.
> + * lock->owner holds the task_struct pointer of the owner. Bit 0
> + * are used to keep track of the "lock has waiters" state.
>   *
> - * owner	bit1	bit0
> - * NULL		0	0	lock is free (fast acquire possible)
> - * NULL		0	1	invalid state
> - * NULL		1	0	Transitional State*
> - * NULL		1	1	invalid state
> - * taskpointer	0	0	lock is held (fast release possible)
> - * taskpointer	0	1	task is pending owner
> - * taskpointer	1	0	lock is held and has waiters
> - * taskpointer	1	1	task is pending owner and lock has more waiters
> + * owner	bit0
> + * NULL		0	lock is free (fast acquire possible)
> + * NULL		1	lock is free and has waiters and candidate owners*
> + * taskpointer	0	lock is held (fast release possible)
> + * taskpointer	1	lock is held and has waiters
>   *
> - * Pending ownership is assigned to the top (highest priority)
> - * waiter of the lock, when the lock is released. The thread is woken
> - * up and can now take the lock. Until the lock is taken (bit 0
> - * cleared) a competing higher priority thread can steal the lock
> - * which puts the woken up thread back on the waiters list.
> + * Candidate ownership is assigned to the top (highest priority) waiter
> + * of the lock, when the lock is released or the top waiter of the lock
> + * is changed. The thread(s) is(are) woken up and can now take the lock.
>   *
>   * The fast atomic compare exchange based acquire and release is only
> - * possible when bit 0 and 1 of lock->owner are 0.
> + * possible when bit 0 of lock->owner are 0.
>   *
> - * (*) There's a small time where the owner can be NULL and the
> - * "lock has waiters" bit is set.  This can happen when grabbing the lock.
> - * To prevent a cmpxchg of the owner releasing the lock, we need to set this
> - * bit before looking at the lock, hence the reason this is a transitional
> - * state.
> + * (*) It also can be a transitional state when grabbing the lock
> + * with ->wait_lock is held. To prevent any fast path cmpxchg to the lock,
> + * we need to set the bit0 before looking at the lock, and the owner may be
> + * NULL in this small time, hence this can be a transitional state.
>   */
>  
>  static void
> -rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner,
> -		   unsigned long mask)
> +rt_mutex_set_owner(struct rt_mutex *lock, struct task_struct *owner)
>  {
> -	unsigned long val = (unsigned long)owner | mask;
> +	unsigned long val = (unsigned long)owner;
>  
>  	if (rt_mutex_has_waiters(lock))
>  		val |= RT_MUTEX_HAS_WAITERS;
> @@ -203,15 +194,15 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  	 * reached or the state of the chain has changed while we
>  	 * dropped the locks.
>  	 */
> -	if (!waiter || !waiter->task)
> +	if (!waiter)
>  		goto out_unlock_pi;
>  
>  	/*
>  	 * Check the orig_waiter state. After we dropped the locks,
>  	 * the previous owner of the lock might have released the lock
> -	 * and made us the pending owner:
> +	 * and made us candidate owner:
>  	 */
> -	if (orig_waiter && !orig_waiter->task)
> +	if (orig_waiter && orig_waiter->cand_owner)
>  		goto out_unlock_pi;

This is OK.

>  
>  	/*
> @@ -254,6 +245,22 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	if (!rt_mutex_owner(lock)) {
> +		/*
> +		 * the lock is free and has waiters, set the top waiter
> +		 * as a new candidate owner when it is not set.
> +		 */
> +		if (top_waiter != rt_mutex_top_waiter(lock)) {
> +			top_waiter = rt_mutex_top_waiter(lock);
> +			top_waiter->cand_seq = lock->cand_seq;

No need for the cand_seq.

> +			if (!top_waiter->cand_owner) {
> +				top_waiter->cand_owner = 1;
> +				wake_up_process(top_waiter->task);
> +			}
> +		}
> +		raw_spin_unlock(&lock->wait_lock);
> +		goto out_put_task;
> +	}
>  	put_task_struct(task);
>  
>  	/* Grab the next task */
> @@ -296,78 +303,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  }
>  
>  /*
> - * Optimization: check if we can steal the lock from the
> - * assigned pending owner [which might not have taken the
> - * lock yet]:
> - */
> -static inline int try_to_steal_lock(struct rt_mutex *lock,
> -				    struct task_struct *task)
> -{
> -	struct task_struct *pendowner = rt_mutex_owner(lock);
> -	struct rt_mutex_waiter *next;
> -	unsigned long flags;
> -
> -	if (!rt_mutex_owner_pending(lock))
> -		return 0;
> -
> -	if (pendowner == task)
> -		return 1;
> -
> -	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
> -	if (task->prio >= pendowner->prio) {
> -		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
> -		return 0;
> -	}
> -
> -	/*
> -	 * Check if a waiter is enqueued on the pending owners
> -	 * pi_waiters list. Remove it and readjust pending owners
> -	 * priority.
> -	 */
> -	if (likely(!rt_mutex_has_waiters(lock))) {
> -		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
> -		return 1;
> -	}
> -
> -	/* No chain handling, pending owner is not blocked on anything: */
> -	next = rt_mutex_top_waiter(lock);
> -	plist_del(&next->pi_list_entry, &pendowner->pi_waiters);
> -	__rt_mutex_adjust_prio(pendowner);
> -	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
> -
> -	/*
> -	 * We are going to steal the lock and a waiter was
> -	 * enqueued on the pending owners pi_waiters queue. So
> -	 * we have to enqueue this waiter into
> -	 * task->pi_waiters list. This covers the case,
> -	 * where task is boosted because it holds another
> -	 * lock and gets unboosted because the booster is
> -	 * interrupted, so we would delay a waiter with higher
> -	 * priority as task->normal_prio.
> -	 *
> -	 * Note: in the rare case of a SCHED_OTHER task changing
> -	 * its priority and thus stealing the lock, next->task
> -	 * might be task:
> -	 */
> -	if (likely(next->task != task)) {
> -		raw_spin_lock_irqsave(&task->pi_lock, flags);
> -		plist_add(&next->pi_list_entry, &task->pi_waiters);
> -		__rt_mutex_adjust_prio(task);
> -		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> -	}
> -	return 1;
> -}
> -
> -/*
>   * Try to take an rt-mutex
>   *
> - * This fails
> - * - when the lock has a real owner
> - * - when a different pending owner exists and has higher priority than current
> - *
>   * Must be called with lock->wait_lock held.
> + *
> + * @lock:	the lock to be acquired.
> + * @task:	the task which want to acquire the lock
> + * @waiter:	the waiter queued to the lock's wait list. (could be NULL)
>   */
> -static int try_to_take_rt_mutex(struct rt_mutex *lock)
> +static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
> +		struct rt_mutex_waiter *waiter)
>  {
>  	/*
>  	 * We have to be careful here if the atomic speedups are
> @@ -390,15 +335,73 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
>  	 */
>  	mark_rt_mutex_waiters(lock);
>  
> -	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
> +	if (rt_mutex_owner(lock))
>  		return 0;
>  
> +	/*
> +	 * It is a queued waiter.
> +	 *
> +	 * Is it a candidate owner? If it is, it will win unconditionally.
> +	 * And it defeats the other candidate owner(s) (if any) and
> +	 * steal lock from them.
> +	 */
> +	if (waiter) {
> +		/* candidate owner? */
> +		if (waiter->cand_owner && waiter->cand_seq == lock->cand_seq)
> +			goto get_lock;

I think the below is a better check.

> +
> +		/*
> +		 * top waiter must be a candidate owner.
> +		 * But checking it again is not a bad thing.
> +		 */
> +		if (waiter == rt_mutex_top_waiter(lock))
> +			goto get_lock;

The reason being, is that we could have the following scenario.

task A has lock, and B and C are waiting.

task A lets go of lock and gives it to B which is higher prio than C

task C is boosted and becomes the top_waiter.

before C gets the lock B get boosted too and it is now the top waiter.

Using the top_waiter to decide who gets the lock is better.


> +	}
> +
> +	/*
> +	 * Does it defeat the candidate owner(s) and steal lock from them?
> +	 *
> +	 * Note: in the rare case of a task is boosted but its waiter has not
> +	 * been requeued in the lock's wait list yet, thus it can also steal
> +	 * the lock.
> +	 */
> +	if (rt_mutex_has_waiters(lock)) {
> +		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio)
> +			return 0;
> +	}
> +
> +get_lock:
> +	if (waiter || rt_mutex_has_waiters(lock)) {
> +		unsigned long flags;
> +		struct rt_mutex_waiter *top;
> +
> +		raw_spin_lock_irqsave(&task->pi_lock, flags);
> +
> +		/* remove the queued waiter. */
> +		if (waiter) {
> +			plist_del(&waiter->list_entry, &lock->wait_list);
> +			task->pi_blocked_on = NULL;
> +		}
> +
> +		/*
> +		 * We have to enqueue the top waiter(if have) into
> +		 * task->pi_waiters list and would get boost from it.
> +		 */
> +		if (rt_mutex_has_waiters(lock)) {
> +			top = rt_mutex_top_waiter(lock);
> +			top->pi_list_entry.prio = top->list_entry.prio;
> +			plist_add(&top->pi_list_entry, &task->pi_waiters);
> +			__rt_mutex_adjust_prio(task);
> +		}
> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	}
> +
>  	/* We got the lock. */
>  	debug_rt_mutex_lock(lock);
>  
> -	rt_mutex_set_owner(lock, current, 0);
> +	rt_mutex_set_owner(lock, task);
>  
> -	rt_mutex_deadlock_account_lock(lock, current);
> +	rt_mutex_deadlock_account_lock(lock, task);
>  
>  	return 1;
>  }
> @@ -424,6 +427,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  	__rt_mutex_adjust_prio(task);
>  	waiter->task = task;
>  	waiter->lock = lock;
> +	waiter->cand_owner = 0;
>  	plist_node_init(&waiter->list_entry, task->prio);
>  	plist_node_init(&waiter->pi_list_entry, task->prio);
>  
> @@ -436,6 +440,9 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>  
> +	if (!owner)
> +		return 0;
> +
>  	if (waiter == rt_mutex_top_waiter(lock)) {
>  		raw_spin_lock_irqsave(&owner->pi_lock, flags);
>  		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
> @@ -472,21 +479,19 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  /*
>   * Wake up the next waiter on the lock.
>   *
> - * Remove the top waiter from the current tasks waiter list and from
> - * the lock waiter list. Set it as pending owner. Then wake it up.
> + * Remove the top waiter from the current tasks waiter list.
> + * Set it as a candidate owner. Then wake it up.
>   *
>   * Called with lock->wait_lock held.
>   */
>  static void wakeup_next_waiter(struct rt_mutex *lock)
>  {
>  	struct rt_mutex_waiter *waiter;
> -	struct task_struct *pendowner;
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&current->pi_lock, flags);
>  
>  	waiter = rt_mutex_top_waiter(lock);
> -	plist_del(&waiter->list_entry, &lock->wait_list);
>  
>  	/*
>  	 * Remove it from current->pi_waiters. We do not adjust a
> @@ -495,37 +500,14 @@ static void wakeup_next_waiter(struct rt_mutex *lock)
>  	 * lock->wait_lock.
>  	 */
>  	plist_del(&waiter->pi_list_entry, &current->pi_waiters);
> -	pendowner = waiter->task;
> -	waiter->task = NULL;
> +	waiter->cand_owner = 1;
> +	waiter->cand_seq = ++lock->cand_seq;

I think we can keep the cand_owner, but get rid of the cand_seq. Because
I think the cand_seq is a bit racier. The top_waiter should be one to
decide which task is the best candidate.

-- Steve

>  
> -	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
> +	rt_mutex_set_owner(lock, NULL);
>  
>  	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
>  
> -	/*
> -	 * Clear the pi_blocked_on variable and enqueue a possible
> -	 * waiter into the pi_waiters list of the pending owner. This
> -	 * prevents that in case the pending owner gets unboosted a
> -	 * waiter with higher priority than pending-owner->normal_prio
> -	 * is blocked on the unboosted (pending) owner.
> -	 */
> -	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
> -
> -	WARN_ON(!pendowner->pi_blocked_on);
> -	WARN_ON(pendowner->pi_blocked_on != waiter);
> -	WARN_ON(pendowner->pi_blocked_on->lock != lock);
> -
> -	pendowner->pi_blocked_on = NULL;
> -
> -	if (rt_mutex_has_waiters(lock)) {
> -		struct rt_mutex_waiter *next;
> -
> -		next = rt_mutex_top_waiter(lock);
> -		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
> -	}
> -	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
> -
> -	wake_up_process(pendowner);
> +	wake_up_process(waiter->task);
>  }
>  
>  /*
> @@ -543,11 +525,13 @@ static void remove_waiter(struct rt_mutex *lock,
>  
>  	raw_spin_lock_irqsave(&current->pi_lock, flags);
>  	plist_del(&waiter->list_entry, &lock->wait_list);
> -	waiter->task = NULL;
>  	current->pi_blocked_on = NULL;
>  	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
>  
> -	if (first && owner != current) {
> +	if (!owner)
> +		return;
> +
> +	if (first) {
>  
>  		raw_spin_lock_irqsave(&owner->pi_lock, flags);
>  
> @@ -614,22 +598,21 @@ void rt_mutex_adjust_pi(struct task_struct *task)
>   * 			 or TASK_UNINTERRUPTIBLE)
>   * @timeout:		 the pre-initialized and started timer, or NULL for none
>   * @waiter:		 the pre-initialized rt_mutex_waiter
> - * @detect_deadlock:	 passed to task_blocks_on_rt_mutex
>   *
>   * lock->wait_lock must be held by the caller.
>   */
>  static int __sched
>  __rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  		    struct hrtimer_sleeper *timeout,
> -		    struct rt_mutex_waiter *waiter,
> -		    int detect_deadlock)
> +		    struct rt_mutex_waiter *waiter)
>  {
>  	int ret = 0;
>  
>  	for (;;) {
>  		/* Try to acquire the lock: */
> -		if (try_to_take_rt_mutex(lock))
> +		if (try_to_take_rt_mutex(lock, current, waiter))
>  			break;
> +		waiter->cand_owner = 0;
>  
>  		/*
>  		 * TASK_INTERRUPTIBLE checks for signals and
> @@ -645,39 +628,11 @@ __rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  				break;
>  		}
>  
> -		/*
> -		 * waiter->task is NULL the first time we come here and
> -		 * when we have been woken up by the previous owner
> -		 * but the lock got stolen by a higher prio task.
> -		 */
> -		if (!waiter->task) {
> -			ret = task_blocks_on_rt_mutex(lock, waiter, current,
> -						      detect_deadlock);
> -			/*
> -			 * If we got woken up by the owner then start loop
> -			 * all over without going into schedule to try
> -			 * to get the lock now:
> -			 */
> -			if (unlikely(!waiter->task)) {
> -				/*
> -				 * Reset the return value. We might
> -				 * have returned with -EDEADLK and the
> -				 * owner released the lock while we
> -				 * were walking the pi chain.
> -				 */
> -				ret = 0;
> -				continue;
> -			}
> -			if (unlikely(ret))
> -				break;
> -		}
> -
>  		raw_spin_unlock(&lock->wait_lock);
>  
>  		debug_rt_mutex_print_deadlock(waiter);
>  
> -		if (waiter->task)
> -			schedule_rt_mutex(lock);
> +		schedule_rt_mutex(lock);
>  
>  		raw_spin_lock(&lock->wait_lock);
>  		set_current_state(state);
> @@ -698,12 +653,11 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  	int ret = 0;
>  
>  	debug_rt_mutex_init_waiter(&waiter);
> -	waiter.task = NULL;
>  
>  	raw_spin_lock(&lock->wait_lock);
>  
>  	/* Try to acquire the lock again: */
> -	if (try_to_take_rt_mutex(lock)) {
> +	if (try_to_take_rt_mutex(lock, current, NULL)) {
>  		raw_spin_unlock(&lock->wait_lock);
>  		return 0;
>  	}
> @@ -717,12 +671,14 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  			timeout->task = NULL;
>  	}
>  
> -	ret = __rt_mutex_slowlock(lock, state, timeout, &waiter,
> -				  detect_deadlock);
> +	ret = task_blocks_on_rt_mutex(lock, &waiter, current, detect_deadlock);
> +
> +	if (likely(!ret))
> +		ret = __rt_mutex_slowlock(lock, state, timeout, &waiter);
>  
>  	set_current_state(TASK_RUNNING);
>  
> -	if (unlikely(waiter.task))
> +	if (unlikely(ret))
>  		remove_waiter(lock, &waiter);
>  
>  	/*
> @@ -737,14 +693,6 @@ rt_mutex_slowlock(struct rt_mutex *lock, int state,
>  	if (unlikely(timeout))
>  		hrtimer_cancel(&timeout->timer);
>  
> -	/*
> -	 * Readjust priority, when we did not get the lock. We might
> -	 * have been the pending owner and boosted. Since we did not
> -	 * take the lock, the PI boost has to go.
> -	 */
> -	if (unlikely(ret))
> -		rt_mutex_adjust_prio(current);
> -
>  	debug_rt_mutex_free_waiter(&waiter);
>  
>  	return ret;
> @@ -762,7 +710,7 @@ rt_mutex_slowtrylock(struct rt_mutex *lock)
>  
>  	if (likely(rt_mutex_owner(lock) != current)) {
>  
> -		ret = try_to_take_rt_mutex(lock);
> +		ret = try_to_take_rt_mutex(lock, current, NULL);
>  		/*
>  		 * try_to_take_rt_mutex() sets the lock waiters
>  		 * bit unconditionally. Clean this up.
> @@ -992,7 +940,7 @@ void rt_mutex_init_proxy_locked(struct rt_mutex *lock,
>  {
>  	__rt_mutex_init(lock, NULL);
>  	debug_rt_mutex_proxy_lock(lock, proxy_owner);
> -	rt_mutex_set_owner(lock, proxy_owner, 0);
> +	rt_mutex_set_owner(lock, proxy_owner);
>  	rt_mutex_deadlock_account_lock(lock, proxy_owner);
>  }
>  
> @@ -1008,7 +956,7 @@ void rt_mutex_proxy_unlock(struct rt_mutex *lock,
>  			   struct task_struct *proxy_owner)
>  {
>  	debug_rt_mutex_proxy_unlock(lock);
> -	rt_mutex_set_owner(lock, NULL, 0);
> +	rt_mutex_set_owner(lock, NULL);
>  	rt_mutex_deadlock_account_unlock(proxy_owner);
>  }
>  
> @@ -1034,20 +982,14 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
>  
>  	raw_spin_lock(&lock->wait_lock);
>  
> -	mark_rt_mutex_waiters(lock);
> -
> -	if (!rt_mutex_owner(lock) || try_to_steal_lock(lock, task)) {
> -		/* We got the lock for task. */
> -		debug_rt_mutex_lock(lock);
> -		rt_mutex_set_owner(lock, task, 0);
> +	if (try_to_take_rt_mutex(lock, task, NULL)) {
>  		raw_spin_unlock(&lock->wait_lock);
> -		rt_mutex_deadlock_account_lock(lock, task);
>  		return 1;
>  	}
>  
>  	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
>  
> -	if (ret && !waiter->task) {
> +	if (ret && waiter->cand_owner) {
>  		/*
>  		 * Reset the return value. We might have
>  		 * returned with -EDEADLK and the owner
> @@ -1056,6 +998,10 @@ int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
>  		 */
>  		ret = 0;
>  	}
> +
> +	if (unlikely(ret))
> +		remove_waiter(lock, waiter);
> +
>  	raw_spin_unlock(&lock->wait_lock);
>  
>  	debug_rt_mutex_print_deadlock(waiter);
> @@ -1110,12 +1056,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
>  
>  	set_current_state(TASK_INTERRUPTIBLE);
>  
> -	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
> -				  detect_deadlock);
> +	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter);
>  
>  	set_current_state(TASK_RUNNING);
>  
> -	if (unlikely(waiter->task))
> +	if (unlikely(ret))
>  		remove_waiter(lock, waiter);
>  
>  	/*
> @@ -1126,13 +1071,5 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
>  
>  	raw_spin_unlock(&lock->wait_lock);
>  
> -	/*
> -	 * Readjust priority, when we did not get the lock. We might have been
> -	 * the pending owner and boosted. Since we did not take the lock, the
> -	 * PI boost has to go.
> -	 */
> -	if (unlikely(ret))
> -		rt_mutex_adjust_prio(current);
> -
>  	return ret;
>  }
> diff --git a/kernel/rtmutex_common.h b/kernel/rtmutex_common.h
> index 97a2f81..178d659 100644
> --- a/kernel/rtmutex_common.h
> +++ b/kernel/rtmutex_common.h
> @@ -43,12 +43,16 @@ extern void schedule_rt_mutex_test(struct rt_mutex *lock);
>   * @list_entry:		pi node to enqueue into the mutex waiters list
>   * @pi_list_entry:	pi node to enqueue into the mutex owner waiters list
>   * @task:		task reference to the blocked task
> + * @cand_owner:		did it became candidate owner
> + * @cand_seq:		sequence number for checking for candidate owner
>   */
>  struct rt_mutex_waiter {
>  	struct plist_node	list_entry;
>  	struct plist_node	pi_list_entry;
>  	struct task_struct	*task;
>  	struct rt_mutex		*lock;
> +	int			cand_owner;
> +	unsigned long		cand_seq;
>  #ifdef CONFIG_DEBUG_RT_MUTEXES
>  	unsigned long		ip;
>  	struct pid		*deadlock_task_pid;
> @@ -91,9 +95,8 @@ task_top_pi_waiter(struct task_struct *p)
>  /*
>   * lock->owner state tracking:
>   */
> -#define RT_MUTEX_OWNER_PENDING	1UL
> -#define RT_MUTEX_HAS_WAITERS	2UL
> -#define RT_MUTEX_OWNER_MASKALL	3UL
> +#define RT_MUTEX_HAS_WAITERS	1UL
> +#define RT_MUTEX_OWNER_MASKALL	1UL
>  
>  static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
>  {
> @@ -101,17 +104,6 @@ static inline struct task_struct *rt_mutex_owner(struct rt_mutex *lock)
>  		((unsigned long)lock->owner & ~RT_MUTEX_OWNER_MASKALL);
>  }
>  
> -static inline struct task_struct *rt_mutex_real_owner(struct rt_mutex *lock)
> -{
> -	return (struct task_struct *)
> -		((unsigned long)lock->owner & ~RT_MUTEX_HAS_WAITERS);
> -}
> -
> -static inline unsigned long rt_mutex_owner_pending(struct rt_mutex *lock)
> -{
> -	return (unsigned long)lock->owner & RT_MUTEX_OWNER_PENDING;
> -}
> -
>  /*
>   * PI-futex support (proxy locking functions, etc.):
>   */
> diff --git a/scripts/rt-tester/check-all.sh b/scripts/rt-tester/check-all.sh
> old mode 100644
> new mode 100755
> diff --git a/scripts/rt-tester/rt-tester.py b/scripts/rt-tester/rt-tester.py
> old mode 100644
> new mode 100755


