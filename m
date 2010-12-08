Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0LHRz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:55:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755117Ab0LHRz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:55:56 -0500
Message-ID: <4CFFC68D.30506@redhat.com>
Date: Wed, 08 Dec 2010 12:55:25 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com>	 <20101202144423.3ad1908d@annuminas.surriel.com> <1291382619.32004.2124.camel@laptop>
In-Reply-To: <1291382619.32004.2124.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 08:23 AM, Peter Zijlstra wrote:
> On Thu, 2010-12-02 at 14:44 -0500, Rik van Riel wrote:
> 				unsigned long clone_flags);
>> +
>> +#ifdef CONFIG_SCHED_HRTICK
>> +extern u64 slice_remain(struct task_struct *);
>> +extern void yield_to(struct task_struct *);
>> +#else
>> +static inline void yield_to(struct task_struct *p) yield()
>> +#endif
>
> That does SCHED_HRTICK have to do with any of this?

Legacy from an old prototype this patch is based on.
I'll get rid of that.

>> +/**
>> + * requeue_task - requeue a task which priority got changed by yield_to
>
> priority doesn't seem the right word, you're not actually changing
> anything related to p->*prio

True, I'll change the comment.

>> + * @rq: the tasks's runqueue
>> + * @p: the task in question
>> + * Must be called with the runqueue lock held. Will cause the CPU to
>> + * reschedule if p is now at the head of the runqueue.
>> + */
>> +void requeue_task(struct rq *rq, struct task_struct *p)
>> +{
>> +	assert_spin_locked(&rq->lock);
>> +
>> +	if (!p->se.on_rq || task_running(rq, p) || task_has_rt_policy(p))
>> +		return;
>> +
>> +	dequeue_task(rq, p, 0);
>> +	enqueue_task(rq, p, 0);
>> +
>> +	resched_task(p);
>
> I guess that wants to be something like check_preempt_curr()

Done.  Thanks for pointing that out.

>> @@ -6797,6 +6817,36 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>>   	return ret;
>>   }
>>
>> +#ifdef CONFIG_SCHED_HRTICK
>
> Still wondering what all this has to do with SCHED_HRTICK..
>
>> +/*
>> + * Yield the CPU, giving the remainder of our time slice to task p.
>> + * Typically used to hand CPU time to another thread inside the same
>> + * process, eg. when p holds a resource other threads are waiting for.
>> + * Giving priority to p may help get that resource released sooner.
>> + */
>> +void yield_to(struct task_struct *p)
>> +{
>> +	unsigned long flags;
>> +	struct sched_entity *se =&p->se;
>> +	struct rq *rq;
>> +	struct cfs_rq *cfs_rq;
>> +	u64 remain = slice_remain(current);
>> +
>> +	rq = task_rq_lock(p,&flags);
>> +	if (task_running(rq, p) || task_has_rt_policy(p))
>> +		goto out;
>
> See, this all ain't nice, slice_remain() don't make no sense to be
> called for !fair tasks.
>
> Why not write:
>
>    if (curr->sched_class == p->sched_class&&
>        curr->sched_class->yield_to)
> 	curr->sched_class->yield_to(curr, p);
>
> or something, and then implement sched_class_fair::yield_to only,
> leaving it a NOP for all other classes.

Done.

>> +	cfs_rq = cfs_rq_of(se);
>> +	se->vruntime -= remain;
>> +	if (se->vruntime<  cfs_rq->min_vruntime)
>> +		se->vruntime = cfs_rq->min_vruntime;
>
> Now here we have another problem, remain was measured in wall-time, and
> then you go change a virtual time measure using that. These things are
> related like:
>
>   vt = t/weight
>
> So you're missing a weight factor somewhere.
>
> Also, that check against min_vruntime doesn't really make much sense.

OK, how do I do this?

>> +	requeue_task(rq, p);
>
> Just makes me wonder why you added requeue task to begin with.. why not
> simply dequeue at the top of this function, and enqueue at the tail,
> like all the rest does: see rt_mutex_setprio(), set_user_nice(),
> sched_move_task().

Done.

>> + out:
>> +	task_rq_unlock(rq,&flags);
>> +	yield();
>> +}
>> +EXPORT_SYMBOL(yield_to);
>
> EXPORT_SYMBOL_GPL() pretty please, I really hate how kvm is a module and
> needs to export hooks all over the core kernel :/

Done.

> Right, so another approach might be to simply swap the vruntime between
> curr and p.

Doesn't that run into the same scale issue you described
above?

-- 
All rights reversed
