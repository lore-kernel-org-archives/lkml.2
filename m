Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0LOPE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:04:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64174 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab0LOPEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:04:25 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=heD8I4ohhdAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=omOdbC7AAAAA:8 a=TWu30gcQSbSP7d-HtdUA:9 a=Eww-SdpcNQ0EDsIi1gAA:7 a=vgGoAnDHzz2TymZQHVaOu5ypnGwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] rtmutex: ensure only the top waiter or higher priority
 task can take the lock and reduce unrelated boosting
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4D0877D2.10000@cn.fujitsu.com>
References: <4D07330A.7020600@cn.fujitsu.com>
	 <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
	 <4D083900.1050801@cn.fujitsu.com>
	 <1292386606.5015.1862.camel@gandalf.stny.rr.com>
	 <4D0877D2.10000@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 15 Dec 2010 10:04:22 -0500
Message-ID: <1292425462.5015.1895.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 16:09 +0800, Lai Jiangshan wrote:

Some English updates.

> 
> Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/futex.c          |   26 +---
>  kernel/rtmutex.c        |  306 ++++++++++++++++--------------------------------
>  kernel/rtmutex_common.h |   16 --
>  3 files changed, 116 insertions(+), 232 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6c683b3..5f4ea5f 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -775,18 +775,10 @@ static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
>  		return -EINVAL;
>  
>  	raw_spin_lock(&pi_state->pi_mutex.wait_lock);
> +	/* set new owner to the most possible owner(top waiter). */

"most possible owner" sounds very strange. Lets say what it actually is.

	/* set new owner to the highest prio waiter (top waiter) */


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
> @@ -1508,8 +1500,8 @@ static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
>  
>  	/*
>  	 * We are here either because we stole the rtmutex from the
> -	 * pending owner or we are the pending owner which failed to
> -	 * get the rtmutex. We have to replace the pending owner TID
> +	 * most possible owner or we are the most possible owner which
> +	 * failed to get the rtmutex. We have to replace the newowner TID
>  	 * in the user space variable. This must be atomic as we have
>  	 * to preserve the owner died bit here.


	/*
	 * We are here either because we stole the rtmutex from the
	 * previous highest prio waiter or we are the highest prio
	 * waiter but failed to get the rtmutex the first time.
	 * We have to replace ...


>  	 *
> @@ -1560,7 +1552,7 @@ retry:
>  
>  	/*
>  	 * To handle the page fault we need to drop the hash bucket
> -	 * lock here. That gives the other task (either the pending
> +	 * lock here. That gives the other task (either the most possible
>  	 * owner itself or the task which stole the rtmutex) the

	 * ... That gives the other task (either the highest prio waiter
	 * itself or the ...

>  	 * chance to try the fixup of the pi_state. So once we are
>  	 * back from handling the fault we need to check the pi_state
> @@ -1647,18 +1639,20 @@ static int fixup_owner(u32 __user *uaddr, int fshared, struct futex_q *q,
>  		/*
>  		 * pi_state is incorrect, some other task did a lock steal and
>  		 * we returned due to timeout or signal without taking the
> -		 * rt_mutex. Too late. We can access the rt_mutex_owner without
> -		 * locking, as the other task is now blocked on the hash bucket
> -		 * lock. Fix the state up.
> +		 * rt_mutex. Too late.

You cut off the entire "We can access the rt_mutex_owner..." but I don't
see how this change is in the code.


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
> index a960481..53b9b49 100644
> --- a/kernel/rtmutex.c
> +++ b/kernel/rtmutex.c
> @@ -20,41 +20,29 @@
>  /*
>   * lock->owner state tracking:
>   *
> - * lock->owner holds the task_struct pointer of the owner. Bit 0 and 1
> - * are used to keep track of the "owner is pending" and "lock has
> - * waiters" state.
> + * lock->owner holds the task_struct pointer of the owner. Bit 0
> + * are used to keep track of the "lock has waiters" state.

s/are/is/

	 "Bit 0 is used to ..."

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
> - *
> - * Pending ownership is assigned to the top (highest priority)
> - * waiter of the lock, when the lock is released. The thread is woken
> - * up and can now take the lock. Until the lock is taken (bit 0
> - * cleared) a competing higher priority thread can steal the lock
> - * which puts the woken up thread back on the waiters list.
> + * owner	bit0
> + * NULL		0	lock is free (fast acquire possible)
> + * NULL		1	lock is free and has waiters and the top waiter
> + *				is going to take the lock*
> + * taskpointer	0	lock is held (fast release possible)
> + * taskpointer	1	lock is held and has waiters

  * taskpointer 1        lock is held and has waiters*


>   *
>   * The fast atomic compare exchange based acquire and release is only
> - * possible when bit 0 and 1 of lock->owner are 0.
> + * possible when bit 0 of lock->owner are 0.

	s/are/is/

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


 * (*) There is a small time when bit 0 is set but there are no
 * waiters. This can happen when grabbing the lock in the slow path.
 * To prevent a cmpxchg of the owner releasing the lock, we need to
 * set this bit before looking at the lock.


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
> @@ -203,15 +191,14 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
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

	s/lock/lock./

> -	 * and made us the pending owner:
>  	 */
> -	if (orig_waiter && !orig_waiter->task)
> +	if (orig_waiter && !rt_mutex_owner(orig_lock))
>  		goto out_unlock_pi;
>  
>  	/*
> @@ -254,6 +241,17 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	if (!rt_mutex_owner(lock)) {
> +		/*
> +		 * If the requeue above changed the top waiter, then we need
> +		 * to wake the new top waiter up to try to get the lock.
> +		 */
> +
> +		if (top_waiter != rt_mutex_top_waiter(lock))
> +			wake_up_process(rt_mutex_top_waiter(lock)->task);
> +		raw_spin_unlock(&lock->wait_lock);
> +		goto out_put_task;
> +	}
>  	put_task_struct(task);
>  
>  	/* Grab the next task */
> @@ -296,78 +294,16 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
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

	"the task which wants to acquire the lock"

> + * @waiter:	the waiter queued to the lock's wait list. (could be NULL)

	"the waiter that is queued to the ..."

Is this always current's waiter?

>   */
> -static int try_to_take_rt_mutex(struct rt_mutex *lock)
> +static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
> +		struct rt_mutex_waiter *waiter)
>  {
>  	/*
>  	 * We have to be careful here if the atomic speedups are
> @@ -390,15 +326,52 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
>  	 */
>  	mark_rt_mutex_waiters(lock);
>  
> -	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
> +	if (rt_mutex_owner(lock))
>  		return 0;
>  
> +	/*
> +	 * It will get the lock because at least one of these conditions:

	* It will get the lock because of one of these conditions:

> +	 * 1) there is no waiter
> +	 * 2) higher priority than waiters
> +	 * 3) it is top waiter
> +	 */
> +	if (rt_mutex_has_waiters(lock)) {
> +		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio) {
> +			if (!waiter || waiter != rt_mutex_top_waiter(lock))
> +				return 0;
> +		}
> +	}
> +
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

	... top waiter (if it exists) ...


> +		 * task->pi_waiters list and would get boost from it.

	s/ and would get boost from it//

-- Steve

> +		 */
> +		if (rt_mutex_has_waiters(lock)) {
> +			top = rt_mutex_top_waiter(lock);
> +			top->pi_list_entry.prio = top->list_entry.prio;
> +			plist_add(&top->pi_list_entry, &task->pi_waiters);
> +		}
> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	}
> +
>  	/* We got the lock. */
>  	debug_rt_mutex_lock(lock);


