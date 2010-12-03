Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab0LCS1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 13:27:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab0LCS1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 13:27:47 -0500
Message-ID: <4CF9368C.8030309@redhat.com>
Date: Fri, 03 Dec 2010 13:27:24 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 2/3] sched: add yield_to function
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144423.3ad1908d@annuminas.surriel.com> <20101203005008.GU10050@sequoia.sous-sol.org>
In-Reply-To: <20101203005008.GU10050@sequoia.sous-sol.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2010 07:50 PM, Chris Wright wrote:

>> +void requeue_task(struct rq *rq, struct task_struct *p)
>> +{
>> +	assert_spin_locked(&rq->lock);
>> +
>> +	if (!p->se.on_rq || task_running(rq, p) || task_has_rt_policy(p))
>> +		return;
>
> already checked task_running(rq, p) || task_has_rt_policy(p) w/ rq lock
> held.

OK, I removed the duplicate checks.

>> +
>> +	dequeue_task(rq, p, 0);
>> +	enqueue_task(rq, p, 0);
>
> seems like you could condense to save an update_rq_clock() call at least,
> don't know if the info_queued, info_dequeued need to be updated

Or I can do the whole operation with the task not queued.
Not sure yet what approach I'll take...

>> +#ifdef CONFIG_SCHED_HRTICK
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
>> +	cfs_rq = cfs_rq_of(se);
>> +	se->vruntime -= remain;
>> +	if (se->vruntime<  cfs_rq->min_vruntime)
>> +		se->vruntime = cfs_rq->min_vruntime;
>
> Should these details all be in sched_fair?  Seems like the wrong layer
> here.  And would that condition go the other way?  If new vruntime is
> smaller than min, then it becomes new cfs_rq->min_vruntime?

That would be nice.  Unfortunately, EXPORT_SYMBOL() does
not seem to work right from sched_fair.c, which is included
from sched.c instead of being built from the makefile!

>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index 5119b08..2a0a595 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -974,6 +974,25 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>>    */
>>
>>   #ifdef CONFIG_SCHED_HRTICK
>> +u64 slice_remain(struct task_struct *p)
>> +{
>> +	unsigned long flags;
>> +	struct sched_entity *se =&p->se;
>> +	struct cfs_rq *cfs_rq;
>> +	struct rq *rq;
>> +	u64 slice, ran;
>> +	s64 delta;
>> +
>> +	rq = task_rq_lock(p,&flags);
>> +	cfs_rq = cfs_rq_of(se);
>> +	slice = sched_slice(cfs_rq, se);
>> +	ran = se->sum_exec_runtime - se->prev_sum_exec_runtime;
>> +	delta = slice - ran;
>> +	task_rq_unlock(rq,&flags);
>> +
>> +	return max(delta, 0LL);
>
> Can delta go negative?

Good question.  I don't know.

-- 
All rights reversed
