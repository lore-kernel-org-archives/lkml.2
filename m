Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0LPTta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:49:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583Ab0LPTt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:49:26 -0500
Message-ID: <4D0A6D34.6070806@redhat.com>
Date: Thu, 16 Dec 2010 14:49:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
References: <20101213224434.7495edb2@annuminas.surriel.com>	 <20101213224657.7e141746@annuminas.surriel.com> <1292306896.7448.157.camel@marge.simson.net>
In-Reply-To: <1292306896.7448.157.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 01:08 AM, Mike Galbraith wrote:
> On Mon, 2010-12-13 at 22:46 -0500, Rik van Riel wrote:
>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index dc91a4d..6399641 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -5166,6 +5166,46 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
>>   	return ret;
>>   }
>>
>> +/*
>> + * Yield the CPU, giving the remainder of our time slice to task p.
>> + * Typically used to hand CPU time to another thread inside the same
>> + * process, eg. when p holds a resource other threads are waiting for.
>> + * Giving priority to p may help get that resource released sooner.
>> + */
>> +void yield_to(struct task_struct *p)
>> +{
>> +	unsigned long flags;
>> +	struct rq *rq, *p_rq;
>> +
>> +	local_irq_save(flags);
>> +	rq = this_rq();
>> +again:
>> +	p_rq = task_rq(p);
>> +	double_rq_lock(rq, p_rq);
>> +	if (p_rq != task_rq(p)) {
>> +		double_rq_unlock(rq, p_rq);
>> +		goto again;
>> +	}
>> +
>> +	/* We can't yield to a process that doesn't want to run. */
>> +	if (!p->se.on_rq)
>> +		goto out;
>> +
>> +	/*
>> +	 * We can only yield to a runnable task, in the same schedule class
>> +	 * as the current task, if the schedule class implements yield_to_task.
>> +	 */
>> +	if (!task_running(rq, p)&&  current->sched_class == p->sched_class&&
>> +			current->sched_class->yield_to)
>> +		current->sched_class->yield_to(rq, p);
>> +
>> +out:
>> +	double_rq_unlock(rq, p_rq);
>> +	local_irq_restore(flags);
>> +	yield();
>> +}
>> +EXPORT_SYMBOL_GPL(yield_to);
>
> That part looks ok, except for the yield cross cpu bit.  Trying to yield
> a resource you don't have doesn't make much sense to me.

The current task just donated the rest of its timeslice.

Surely that makes it a reasonable idea to call yield, and
get one of the other tasks on the current CPU running for
a bit?

> <ramble>
> slice_remain() measures the distance to your last preemption, which has
> no relationship with entitlement.  sched_slice() is not used to issue
> entitlement, it's only a ruler.
>
> You have entitlement on your current runqueue only, that entitlement
> being the instantaneous distance to min_vruntime in a closed and fluid
> system.  You can't inject some instantaneous relationship from one
> closed system into an another without making the math go kind of fuzzy,
> so you need tight constraints on how fuzzy it can get.
>
> We do that with migrations, inject fuzz.  There is no global fair-stick,
> but we invent one by injecting little bits of fuzz.  It's constrained by
> chaos and the magnitude constraints of the common engine.  The more you
> migrate, the more tightly you couple systems.  As long as we stay fairly
> well balanced, we can migrate without the fuzz getting out of hand, and
> end up with a globally ~fair system.
>
> What you're injecting isn't instantaneously irrelevant lag-fuzz, which
> distributed over time becomes relevant. you're inventing entitlement out
> of the void.  Likely not a big hairy deal unless you do it frequently,
> but you're doing something completely bogus and seemingly unconstrained.
> </ramble>

I'm open to suggestions on what to do instead.

>> +static void yield_to_fair(struct rq *rq, struct task_struct *p)
>> +{
>> +	struct sched_entity *se =&p->se;
>> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>> +	u64 remain = slice_remain(current);
>> +
>> +	dequeue_task(rq, p, 0);
>> +	se->vruntime -= remain;
>> +	if (se->vruntime<  cfs_rq->min_vruntime)
>> +		se->vruntime = cfs_rq->min_vruntime;
>
> This has an excellent chance of moving the recipient rightward.. and the
> yielding task didn't yield anything.  This may achieve the desired
> result or may just create a nasty latency spike... but it makes no
> arithmetic sense.

Good point, the current task calls yield() in the function
that calls yield_to_fair, but I seem to have lost the code
that penalizes the current task's runtime...

I'll reinstate that.

-- 
All rights reversed
