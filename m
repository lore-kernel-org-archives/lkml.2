Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1AXSUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:20:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724Ab1AXSUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:20:07 -0500
Message-ID: <4D3DC2C2.1060905@redhat.com>
Date: Mon, 24 Jan 2011 13:19:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [RFC -v6 PATCH 4/8] sched: Add yield_to(task, preempt) functionality
References: <20110120163127.2568f4fe@annuminas.surriel.com>	 <20110120163443.762c2409@annuminas.surriel.com> <1295892748.28776.463.camel@laptop>
In-Reply-To: <1295892748.28776.463.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 01:12 PM, Peter Zijlstra wrote:
> On Thu, 2011-01-20 at 16:34 -0500, Rik van Riel wrote:
>> From: Mike Galbraith<efault@gmx.de>
>>
>> Currently only implemented for fair class tasks.
>>
>> Add a yield_to_task method() to the fair scheduling class. allowing the
>> caller of yield_to() to accelerate another thread in it's thread group,
>> task group.
>>
>> Implemented via a scheduler hint, using cfs_rq->next to encourage the
>> target being selected.  We can rely on pick_next_entity to keep things
>> fair, so noone can accelerate a thread that has already used its fair
>> share of CPU time.
>>
>> This also means callers should only call yield_to when they really
>> mean it.  Calling it too often can result in the scheduler just
>> ignoring the hint.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>> Signed-off-by: Marcelo Tosatti<mtosatti@redhat.com>
>> Signed-off-by: Mike Galbraith<efault@gmx.de>
>
> Patch 5 wants to be merged back in here I think..

Agreed, but I wanted Mike's comments first  :)


>> +/**
>> + * yield_to - yield the current processor to another thread in
>> + * your thread group, or accelerate that thread toward the
>> + * processor it's on.
>> + *
>> + * It's the caller's job to ensure that the target task struct
>> + * can't go away on us before we can do any checks.
>> + *
>> + * Returns true if we indeed boosted the target task.
>> + */
>> +bool __sched yield_to(struct task_struct *p, bool preempt)
>> +{
>> +	struct task_struct *curr = current;
>> +	struct rq *rq, *p_rq;
>> +	unsigned long flags;
>> +	bool yielded = 0;
>> +
>> +	local_irq_save(flags);
>> +	rq = this_rq();
>> +
>> +again:
>> +	p_rq = task_rq(p);
>> +	double_rq_lock(rq, p_rq);
>> +	while (task_rq(p) != p_rq) {
>> +		double_rq_unlock(rq, p_rq);
>> +		goto again;
>> +	}
>> +
>> +	if (!curr->sched_class->yield_to_task)
>> +		goto out;
>> +
>> +	if (curr->sched_class != p->sched_class)
>> +		goto out;
>> +
>> +	if (task_running(p_rq, p) || p->state)
>> +		goto out;
>> +
>> +	if (!same_thread_group(p, curr))
>> +		goto out;
>> +
>> +#ifdef CONFIG_FAIR_GROUP_SCHED
>> +	if (task_group(p) != task_group(curr))
>> +		goto out;
>> +#endif
>> +
>> +	yielded = curr->sched_class->yield_to_task(rq, p, preempt);
>> +
>> +out:
>> +	double_rq_unlock(rq, p_rq);
>> +	local_irq_restore(flags);
>> +
>> +	if (yielded)
>> +		yield();
>
> Calling yield() here is funny, you just had all the locks to actually do
> it..

This is us giving up the CPU, which requires not holding locks.

A different thing than us giving the CPU away to someone else.

>> +static bool yield_to_task_fair(struct rq *rq, struct task_struct *p, bool preempt)
>> +{
>> +	struct sched_entity *se =&p->se;
>> +
>> +	if (!se->on_rq)
>> +		return false;
>> +
>> +	/* Tell the scheduler that we'd really like pse to run next. */
>> +	set_next_buddy(se);
>> +
>> +	/* Make p's CPU reschedule; pick_next_entity takes care of fairness. */
>> +	if (preempt)
>> +		resched_task(rq->curr);
>> +
>> +	return true;
>> +}
>
> So here we set ->next, we could be ->last, and after this we'll set
> ->yield to curr by calling yield().
>
> So if you do this cyclically I can see ->yield == {->next,->last}
> happening.

That would only happen if we called yield_to with ourselves
as the argument!

There is no caller in the tree that does that - task p is
another task, not ourselves.
