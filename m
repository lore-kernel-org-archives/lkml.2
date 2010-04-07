Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0DGR0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:26:15 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59847 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0DGR0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:26:14 -0400
Message-ID: <4BBCC02C.5090000@us.ibm.com>
Date: Wed, 07 Apr 2010 10:26:04 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/6] futex: Add FUTEX_LOCK with optional adaptive spinning
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com> <1270499039-23728-5-git-send-email-dvhltc@us.ibm.com> <alpine.LFD.2.00.1004061818250.32352@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1004061818250.32352@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 5 Apr 2010, Darren Hart wrote:
>> +#ifdef CONFIG_SMP
>> +struct thread_info *futex_owner(u32 __user *uaddr)
>> +{
>> +	struct thread_info *ti = NULL;
>> +	struct task_struct *p;
>> +	pid_t pid;
>> +	u32 uval;
>> +
>> +	if (get_futex_value_locked(&uval, uaddr))
>> +		return NULL;
>> +
>> +	pid = uval & FUTEX_TID_MASK;
>> +	rcu_read_lock();
>> +	p = find_task_by_vpid(pid);
>> +	if (p) {
>> +		const struct cred *cred, *pcred;
>> +
>> +		cred = current_cred();
>> +		pcred = __task_cred(p);
>> +		if (cred->euid == pcred->euid ||
>> +		    cred->euid == pcred->uid)
>> +			ti = task_thread_info(p);
> 
>   We want a get_task_struct() here, don't we ?


It would appear so. We access owner->cpu in futex_spin_on_owner. Done.


>> +	}
>> +	rcu_read_unlock();
>> +
>> +	return ti;
>> +}
>> +#endif
>> +
> 
>> +/**
>> + * trylock_futex_adaptive() - Try to acquire the futex lock in a busy loop
>> + * @uaddr: the futex user address
>> + *
>> + * Try to acquire a futex lock in a loop until the owner changes or the owner
>> + * is descheduled. To lock the futex, set the value to the current TID.
>> + *
>> + * Returns:
>> + *  0 - Gave up, lock not acquired
>> + *  1 - Futex lock acquired
>> + * <0 - On error
>> + */
>> +static int trylock_futex_adaptive(u32 __user *uaddr)
>> +{
>> +	int ret = 0;
>> +	u32 curval;
>> +
>> +	for (;;) {
>> +		struct thread_info *owner;
>> +
>> +		owner = futex_owner(uaddr);
>> +		if (owner && futex_spin_on_owner(uaddr, owner))
>> +			break;
>> +
>> +		/*
>> +		 * Try to acquire the lock. If we acquire it or error out,
>> +		 * break to enable preemption and handle ret outside the loop.
>> +		 */
>> +		curval = cmpxchg_futex_value_locked(uaddr, 0,
>> +		                                    task_pid_vnr(current));
>> +
>> +		if (curval == 0) {
>> +			ret = 1;
>> +			break;
>> +		}
>> +
>> +		if (unlikely(curval == -EFAULT)) {
>> +			ret = -EFAULT;
>> +			break;
>> +		}
>> +
>> +		/*
>> +		 * Futex locks manage the owner atomically. We are not in
>> +		 * danger of deadlock by preempting a pending owner. Abort the
>> +		 * loop if our time slice has expired.  RT Threads can spin
>> +		 * until they preempt the owner, at which point they will break
>> +		 * out of the loop anyway.
>> +		 */
>> +		if (need_resched())
>> +			break;
>> +
>> +		cpu_relax();
>> +	}
>> +	return ret;
>> +}
> 
> 
> Hmm. The order is weird. Why don't you do that simpler ?
> 
> Get the uval, the tid and the thread_info pointer outside of the
> loop. Also task_pid_vnr(current) just needs a one time lookup.

Eeek. Having the owner in the loop is a good way to negate the benefits
of adaptive spinning by spinning forever (unlikely, but it could
certainly spin across multiple owners). Nice catch.

As for the uval.... I'm not sure what you mean. You get curval below
inside the loop, and there is no "uval" in the my version of the code.

As for the order, I had put the initial spin prior to the cmpxchg to
avoid doing too many cmpxchg's in a row as they are rather expensive.
However, since this is (now) the first opportunity to do try and acquire
the lock atomically after entering the futex syscall, I think you're
right, it should be the first thing in the loop.

> 
> change the loop to do:
> 
>        for (;;) {
>        	   curval = cmpxchg_futex_value_locked(uaddr, 0, curtid);
>   
> 	   if (!curval)
> 	      return 1;

Single return point makes instrumentation so much easier. Unless folks
_really_ object, I'll leave it as is until we're closer to merging.

> 	   if ((curval & FUTEX_TID_MASK) != ownertid) {
> 	      ownertid = curval & FUTEX_TID_MASK;
> 	      owner = update_owner(ownertid);
> 	   }


Hrm... at this point the owner has changed... so we should break and go
to sleep, not update the owner and start spinning again. The
futex_spin_on_owner() will detect this and abort, so I'm not seeing the
purpose of the above if() block.

...

>> +static int futex_lock(u32 __user *uaddr, int flags, int detect, ktime_t *time)
>> +{
>> +	struct hrtimer_sleeper timeout, *to = NULL;
>> +	struct futex_hash_bucket *hb;
>> +	struct futex_q q = FUTEX_Q_INIT;
>> +	int ret = 0;
>> +
>> +	if (refill_pi_state_cache())
>> +		return -ENOMEM;
>> +
>> +	if (time) {
>> +		to = &timeout;
>> +		hrtimer_init_on_stack(&to->timer, CLOCK_REALTIME,
>> +				      HRTIMER_MODE_ABS);
> 
>   Please make that like the WAIT_BITSET one, which can select the
>   clock and defaults to MONOTONIC.


Done.

> 
>> +		hrtimer_init_sleeper(to, current);
>> +		hrtimer_set_expires(&to->timer, *time);
>> +	}
> 
>   Why setup all this _before_ trying the adaptive spin ?


I placed the retry: label above the adaptive spin loop. This way if we 
wake a task and the lock is "stolen" it doesn't just go right back to 
sleep. This should aid in fairness and also performance in less 
contended cases. I didn't think it was worth a "if (first_time_through 
&& time)" sort of block to be able to setup the timer after the spin loop.


>> +retry:
>> +#ifdef CONFIG_SMP
>> +	if (flags & FLAGS_ADAPTIVE) {
> 
>   Why do we want that non adaptive version at all ?


We don't. I'm using it here simply to measure the impact of adaptive 
spinning. Eventually all that will matter is how it stacks up against a 
raw futex_wait/wake mutex implementation like 
pthread_mutex_lock/unlock(). But in the early stages it's nice to be 
able eliminate all other differences other than adaptive spinning.

...

>> +	if (to)
>> +		destroy_hrtimer_on_stack(&to->timer);
>> +	return ret != -EINTR ? ret : -ERESTARTNOINTR;
> 
>   Which code sets -EINTR ?


Cruft left over from the futex_lock_pi() roots. Removed.

...

>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 9ab3cd7..a2dbb5b 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -3818,6 +3818,65 @@ int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
>>  out:
>>  	return 1;
>>  }
>> +
>> +#ifdef CONFIG_FUTEX
>> +#include <linux/futex.h>
>> +
>> +int futex_spin_on_owner(u32 __user *uaddr, struct thread_info *owner)
>> +{
>> +	unsigned int cpu;
>> +	struct rq *rq;
>> +
>> +	if (!sched_feat(OWNER_SPIN))
>> +		return 0;
>> +
>> +#ifdef CONFIG_DEBUG_PAGEALLOC
>> +	/*
>> +	 * Need to access the cpu field knowing that
>> +	 * DEBUG_PAGEALLOC could have unmapped it if
>> +	 * the mutex owner just released it and exited.
>> +	 */
>> +	if (probe_kernel_address(&owner->cpu, cpu))
>> +		goto out;
>> +#else
>> +	cpu = owner->cpu;
>> +#endif
>> +
>> +	/*
>> +	 * Even if the access succeeded (likely case),
>> +	 * the cpu field may no longer be valid.
>> +	 */
>> +	if (cpu >= nr_cpumask_bits)
>> +		goto out;
>> +
>> +	/*
>> +	 * We need to validate that we can do a
>> +	 * get_cpu() and that we have the percpu area.
>> +	 */
>> +	if (!cpu_online(cpu))
>> +		goto out;
>> +
>> +	rq = cpu_rq(cpu);
>> +
>> +	for (;;) {
>> +		/*
>> +		 * Owner changed, break to re-assess state.
>> +		 */
>> +		if (futex_owner(uaddr) != owner)
>> +			break;
> 
>   Uurg. It's enough to check whether the TID value changed. No need to
>   look up the full thing in every iteration.


OK, we can skip the euid, uid credentials checking by doing a get_user() 
instead.


> 
>> +		/*
>> +		 * Is that owner really running on that cpu?
>> +		 */
>> +		if (task_thread_info(rq->curr) != owner || need_resched())
>> +			return 0;
>> +
>> +		cpu_relax();
>> +	}
>> +out:
>> +	return 1;
>> +}
>> +#endif
>>  #endif
> 
> Do we really need all this code ? A simple owner->on_cpu (owner needs
> to be the task_struct then) would be sufficient to figure that out,
> wouldn't it?

As Peter pointed out in IRC, p->oncpu isn't generic. I'll go trolling 
through the mutex_spin_on_owner() discussions to see if I can determine 
why that's the case.

Thank you for the review.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

