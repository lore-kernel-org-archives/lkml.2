Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349Ab0LODmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:42:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62191 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab0LODmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:42:31 -0500
Message-ID: <4D083900.1050801@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 11:41:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Young <hidave.darkstar@gmail.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] rtmutex: multiple candidate owners without unrelated
 boosting
References: <4D07330A.7020600@cn.fujitsu.com> <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012141850460.12146@localhost6.localdomain6>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 11:40:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 11:42:30,
	Serialize complete at 2010-12-15 11:42:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 04:07 AM, Thomas Gleixner wrote:
>> --- a/include/linux/rtmutex.h
>> +++ b/include/linux/rtmutex.h
>> @@ -24,11 +24,13 @@ extern int max_lock_depth; /* for sysctl */
>>   * @wait_lock:	spinlock to protect the structure
>>   * @wait_list:	pilist head to enqueue waiters in priority order
>>   * @owner:	the mutex owner
>> + * @cand_seq:	the sequence number for candidate owners
>>   */
>>  struct rt_mutex {
>>  	raw_spinlock_t		wait_lock;
>>  	struct plist_head	wait_list;
>>  	struct task_struct	*owner;
>> +	unsigned long		cand_seq; /* don't need to init it! */
> 
> I really do not like unitialized stuff. Omitting this init saves ZERO
> performance wise and it's going to confuse the hell out of someone
> who tries to debug this code.

OK, I will init it.

> 
>>  	/*
>> @@ -254,6 +245,22 @@ static int rt_mutex_adjust_prio_chain(struct task_struct *task,
>>  
>>  	/* Release the task */
>>  	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
>> +	if (!rt_mutex_owner(lock)) {
>> +		/*
>> +		 * the lock is free and has waiters, set the top waiter
>> +		 * as a new candidate owner when it is not set.
> 
> It took me a while to grok this comment. It should read:
> 
>   /*
>    * If the requeue above changed the top waiter, then we need to
>    * make it a candidate owner and possibly wake it up.
>    */
> 
> Right ?

You are right.

> 
>> +		 */
>> +		if (top_waiter != rt_mutex_top_waiter(lock)) {
> 
> Shouldn't this:
> 
>   - clear cand_owner on the previous top_waiter ?
>   - increment the cand_seq ?
> 
> If we increment cand_seq, then we can get rid of cand_owner completely
> as waiter->cand_seq == lock->cand_seq should be sufficient. And it
> would automatically prefer the new top waiter and not give the lock to
> some random on the fly task.


If we increment cand_seq, we do deprive candidate ownership from the
original one and we have only one candidate owner.

If we have just one candidate owner at most, we don't need
cand_seq either. we can save it in lock->owner, (like pending owner).

But this may lead to livelock if we do deprive candidate ownership
as I mentioned (the mail I reply to Steven)

Any random on the fly task is a reasonable task for the owner in this
patch.

A(assigned the first candidate ownership), B, C, D, E... are in the
waitlist. But before new owner really take the lock, B, D 's priority
are raised and they became the top waiter at least once,
(D is the top at the end, D, B, A, C, E....) B and D are also
candidate owners. In my patch, A, B, D have the chance to compete
the lock, they are all reasonable because they are candidate owners,
including A!

OK, let's consider the same case but without this patch.
A is assigned the pending ownership. B, C, D, E... are in the
waitlist, But before new owner really take the lock, B, D 's priority
are raised. In the end, only A can complete the lock, B and D
just do boost A and help A. only A!

Summary, the reason I will give the lock to some random on the fly task
which is one of the candidate owners:
1) avoid livelock
2) no worse than the code without this patch.

> 
>> +			top_waiter = rt_mutex_top_waiter(lock);
>> +			top_waiter->cand_seq = lock->cand_seq;
>> +			if (!top_waiter->cand_owner) {
>> +				top_waiter->cand_owner = 1;
>> +				wake_up_process(top_waiter->task);
>> +			}
>> +		}
>> +		raw_spin_unlock(&lock->wait_lock);
>> +		goto out_put_task;
> 
> If I understand correctly, then this is the equivalent to the
> original breakout based on !task->pi_blocked_on, right ?

Correct, original breakout when !pending_owner_task->pi_bocked_on,
but candidate owners are still in the waitlist and ->pi_bocked_on
still pointers to its waiter. Now we breakout when the lock
has no owner(but has candidate owner(s) on the fly, we don't boost it).

> 
>> +	}
>>  	put_task_struct(task);
> 
>>   */
>> -static int try_to_take_rt_mutex(struct rt_mutex *lock)
>> +static int try_to_take_rt_mutex(struct rt_mutex *lock, struct task_struct *task,
>> +		struct rt_mutex_waiter *waiter)
>>  {
>>  	/*
>>  	 * We have to be careful here if the atomic speedups are
>> @@ -390,15 +335,73 @@ static int try_to_take_rt_mutex(struct rt_mutex *lock)
>>  	 */
>>  	mark_rt_mutex_waiters(lock);
>>  
>> -	if (rt_mutex_owner(lock) && !try_to_steal_lock(lock, current))
>> +	if (rt_mutex_owner(lock))
>>  		return 0;
>>  
>> +	/*
>> +	 * It is a queued waiter.
>> +	 *
>> +	 * Is it a candidate owner? If it is, it will win unconditionally.
>> +	 * And it defeats the other candidate owner(s) (if any) and
>> +	 * steal lock from them.
> 
> Why ? If the boost code changes the top waiter and wakes up the new
> candidate, then this new one really should get the lock and the old on
> the fly candidate should queue itself back.

See above, all candidate owner have the chance to compete the lock.
It is required for avoiding the livelock.

If we have other way to avoiding the livelock, we will use only
one candidate owner, you, Steven and I will very happy.

> 
>> +	 */
>> +	if (waiter) {
>> +		/* candidate owner? */
>> +		if (waiter->cand_owner && waiter->cand_seq == lock->cand_seq)
>> +			goto get_lock;
>> +
>> +		/*
>> +		 * top waiter must be a candidate owner.
>> +		 * But checking it again is not a bad thing.
>> +		 */
>> +		if (waiter == rt_mutex_top_waiter(lock))
>> +			goto get_lock;
> 
> Huch ? This should never happen and therefor this should be a
> WARN_ON_ONCE(). We really do not put "checking is not a bad thing"
> code in such a fragile and complex construct. Something is very wrong
> when you ever hit this.
> 
>> +	}
>> +
>> +	/*
>> +	 * Does it defeat the candidate owner(s) and steal lock from them?
>> +	 *
>> +	 * Note: in the rare case of a task is boosted but its waiter has not
>> +	 * been requeued in the lock's wait list yet, thus it can also steal
>> +	 * the lock.
> 
> How should this happen with the new code ? The waiter remains in the
> wait list and boosting does not change that. So that comment is
> misleading.

When someone boosted current task p, but it fail to take the p->pi_block_on->lock->wait_lock,
and current task p success take it and call try_to_take_rt_mutex()
before p->pi_block_on is requeued in the waitlist.
current task should also have chance to win the lock even it is
not candidate owner/top waiter. It will win when it has the higher
priority than the top waiter.


> 
>> +	 */
>> +	if (rt_mutex_has_waiters(lock)) {
>> +		if (task->prio >= rt_mutex_top_waiter(lock)->list_entry.prio)
>> +			return 0;
>> +	}
>> +
>> +get_lock:
>> +	if (waiter || rt_mutex_has_waiters(lock)) {
>> +		unsigned long flags;
>> +		struct rt_mutex_waiter *top;
>> +
>> +		raw_spin_lock_irqsave(&task->pi_lock, flags);
>> +
>> +		/* remove the queued waiter. */
>> +		if (waiter) {
>> +			plist_del(&waiter->list_entry, &lock->wait_list);
>> +			task->pi_blocked_on = NULL;
>> +		}
>> +
>> +		/*
>> +		 * We have to enqueue the top waiter(if have) into
>> +		 * task->pi_waiters list and would get boost from it.
>> +		 */
>> +		if (rt_mutex_has_waiters(lock)) {
>> +			top = rt_mutex_top_waiter(lock);
>> +			top->pi_list_entry.prio = top->list_entry.prio;
>> +			plist_add(&top->pi_list_entry, &task->pi_waiters);
>> +			__rt_mutex_adjust_prio(task);
> 
> Why should we boost ? Because we can have several candidates on the
> fly and we don't care which one is the highest prio candidate? That
> looks wrong.

A really owner should (be boosted)/(prepare to be booted) by the waiters.
such code is also needed in original code.

> 
>> +		}
>> +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> 
>> @@ -424,6 +427,7 @@ static int task_blocks_on_rt_mutex(struct rt_mutex *lock,
>>  	__rt_mutex_adjust_prio(task);
>>  	waiter->task = task;
>>  	waiter->lock = lock;
>> +	waiter->cand_owner = 0;
> 
> This should init waiter->cand_seq to RTMUTEX_CAND_SEQ_MAX and get rid
> of cand_owner.

good! thanks.

> 
>> +	waiter->cand_seq = ++lock->cand_seq;
> 
> If we make cand_seq an indicator then we need to do
> 
>    lock->cand_seq = (lock->cand_seq + 1) & ~RTMUTEX_CAND_SEQ_MAX;
>  
>> @@ -1110,12 +1056,11 @@ int rt_mutex_finish_proxy_lock(struct rt_mutex *lock,
>>  
>>  	set_current_state(TASK_INTERRUPTIBLE);
>>  
>> -	ret = __rt_mutex_slowlock(lock, TASK_INTERRUPTIBLE, to, waiter,
>> -				  detect_deadlock);
> 
> Hmm, so we loose the deadlock detection in that case. Not sure whether
> it matters though.
> 
> All in all I like the idea and I think we should give it a try, but I
> definitely want to test a patch against -RT, as this will shake out
> all problems in no time.
> 

Thanks,
Lai
