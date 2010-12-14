Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab0LNUIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:08:46 -0500
Received: from www.tglx.de ([62.245.132.106]:35992 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab0LNUIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:08:45 -0500
Date: Tue, 14 Dec 2010 21:07:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
In-Reply-To: <4D07330A.7020600@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
References: <4D07330A.7020600@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Tue, 14 Dec 2010, Lai Jiangshan wrote:
> Not advantage nor disadvantage
> 1) Even we support multiple candidate owners, we hardly cause "thundering herd"
>    the number of candidate owners is likely 1.

I'm not convinced about that function, see comments below

> 2) two APIs are changed.
>    rt_mutex_owner() will not return pending owner
>    rt_mutex_next_owner() always return the top owner, it is a candidate owner.
> 	will not return NULL if we only have a pending owner.
>    I have fixed the code that use these APIs.

I think we want a separate function which can be used by futex code,
but that's a detail.
 
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

I really do not like unitialized stuff. Omitting this init saves ZERO
performance wise and it's going to confuse the hell out of someone
who tries to debug this code.

>  	/*
> @@ -254,6 +245,22 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>  
>  	/* Release the task */
>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +	if (!rt_mutex_owner(lock)) {
> +		/*
> +		 * the lock is free and has waiters, set the top waiter
> +		 * as a new candidate owner when it is not set.

It took me a while to grok this comment. It should read:

  /*
   * If the requeue above changed the top waiter, then we need to
   * make it a candidate owner and possibly wake it up.
   */

Right ?

> +		 */
> +		if (top_waiter != rt_mutex_top_waiter(lock)) {

Shouldn't this:

  - clear cand_owner on the previous top_waiter ?
  - increment the cand_seq ?

If we increment cand_seq, then we can get rid of cand_owner completely
as waiter->cand_seq == lock->cand_seq should be sufficient. And it
would automatically prefer the new top waiter and not give the lock to
some random on the fly task.

> +			top_waiter = rt_mutex_top_waiter(lock);
> +			top_waiter->cand_seq = lock->cand_seq;
> +			if (!top_waiter->cand_owner) {
> +				top_waiter->cand_owner = 1;
> +				wake_up_process(top_waiter->task);
> +			}
> +		}
> +		raw_spin_unlock(&lock->wait_lock);
> +		goto out_put_task;

If I understand correctly, then this is the equivalent to the
original breakout based on !task->pi_blocked_on, right ?

> +	}
>  	put_task_struct(task);

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

Why ? If the boost code changes the top waiter and wakes up the new
candidate, then this new one really should get the lock and the old on
the fly candidate should queue itself back.

> +	 */
> +	if (waiter) {
> +		/* candidate owner? */
> +		if (waiter->cand_owner && waiter->cand_seq == lock->cand_seq)
> +			goto get_lock;
> +
> +		/*
> +		 * top waiter must be a candidate owner.
> +		 * But checking it again is not a bad thing.
> +		 */
> +		if (waiter == rt_mutex_top_waiter(lock))
> +			goto get_lock;

Huch ? This should never happen and therefor this should be a
WARN_ON_ONCE(). We really do not put "checking is not a bad thing"
code in such a fragile and complex construct. Something is very wrong
when you ever hit this.

> +	}
> +
> +	/*
> +	 * Does it defeat the candidate owner(s) and steal lock from them?
> +	 *
> +	 * Note: in the rare case of a task is boosted but its waiter has not
> +	 * been requeued in the lock's wait list yet, thus it can also steal
> +	 * the lock.

How should this happen with the new code ? The waiter remains in the
wait list and boosting does not change that. So that comment is
misleading.

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

Why should we boost ? Because we can have several candidates on the
fly and we don't care which one is the highest prio candidate? That
looks wrong.

> +		}
> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);

> @@ -424,6 +427,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>  	__rt_mutex_adjust_prio(task);
>  	waiter->task = task;
>  	waiter->lock = lock;
> +	waiter->cand_owner = 0;

This should init waiter->cand_seq to RTMUTEX_CAND_SEQ_MAX and get rid
of cand_owner.

> +	waiter->cand_seq = ++lock->cand_seq;

If we make cand_seq an indicator then we need to do

   lock->cand_seq = (lock->cand_seq + 1) & ~RTMUTEX_CAND_SEQ_MAX;
 
> @@ -1110,12 +1056,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
>  
>  	set_current_state(TASK_INTERRUPTIBLE);
>  
> -	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
> -				  detect_deadlock);

Hmm, so we loose the deadlock detection in that case. Not sure whether
it matters though.

All in all I like the idea and I think we should give it a try, but I
definitely want to test a patch against -RT, as this will shake out
all problems in no time.

Thanks,

	tglx
