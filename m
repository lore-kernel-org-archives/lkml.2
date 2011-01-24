Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab1AXSQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:16:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab1AXSQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:16:49 -0500
Message-ID: <4D3DC1F8.3040601@redhat.com>
Date: Mon, 24 Jan 2011 13:16:24 -0500
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
Subject: Re: [RFC -v6 PATCH 3/8] sched: use a buddy to implement yield_task_fair
References: <20110120163127.2568f4fe@annuminas.surriel.com>	 <20110120163355.4059c53e@annuminas.surriel.com> <1295892283.28776.455.camel@laptop>
In-Reply-To: <1295892283.28776.455.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 01:04 PM, Peter Zijlstra wrote:

>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index dc91a4d..e4e57ff 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -327,7 +327,7 @@ struct cfs_rq {
>>   	 * 'curr' points to currently running entity on this cfs_rq.
>>   	 * It is set to NULL otherwise (i.e when none are currently running).
>>   	 */
>> -	struct sched_entity *curr, *next, *last;
>> +	struct sched_entity *curr, *next, *last, *yield;
>
> I'd prefer it be called: skip or somesuch..

I could do that.  Do any of the other scheduler people have
a preference?

>> +static struct sched_entity *__pick_second_entity(struct cfs_rq *cfs_rq)
>> +{
>> +	struct rb_node *left = cfs_rq->rb_leftmost;
>> +	struct rb_node *second;
>> +
>> +	if (!left)
>> +		return NULL;
>> +
>> +	second = rb_next(left);
>> +
>> +	if (!second)
>> +		second = left;
>> +
>> +	return rb_entry(second, struct sched_entity, run_node);
>> +}
>
> So this works because you only ever skip the leftmost, should we perhaps
> write this as something like the below?

Well, pick_next_entity only ever *picks* the leftmost entity,
so there's no reason to skip others.

>> @@ -813,6 +840,9 @@ static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>>
>>   	if (cfs_rq->next == se)
>>   		__clear_buddies_next(se);
>> +
>> +	if (cfs_rq->yield == se)
>> +		__clear_buddies_yield(se);
>>   }
>
> The 3rd hierarchy iteration.. :/

Except it won't actually walk up the tree above the level
where the buddy actually points at the se.  I suspect the
new code will do less tree walking than the old code.

>> +	/*
>> +	 * Someone really wants this to run. If it's not unfair, run it.
>> +	 */
>> +	if (cfs_rq->next&&  wakeup_preempt_entity(cfs_rq->next, left)<  1)
>> +		se = cfs_rq->next;
>> +
>>   	clear_buddies(cfs_rq, se);
>>
>>   	return se;
>
> This seems to assume ->yield cannot be ->next nor ->last, but I'm not
> quite sure that will actually be true.

On the contrary, I specifically want ->next to be able to
override ->yield, for the reason that the _tasks_ that
have ->next and ->yield set could be inside the same _group_.

What I am assuming is that ->yield and ->last are not the
same task.  This is achieved by yield_task_fair calling
clear_buddies.

>> +/*
>> + * sched_yield() is very simple
>> + *
>> + * The magic of dealing with the ->yield buddy is in pick_next_entity.
>> + */
>> +static void yield_task_fair(struct rq *rq)
>> +{
>> +	struct task_struct *curr = rq->curr;
>> +	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
>> +	struct sched_entity *se =&curr->se;
>> +
>> +	/*
>> +	 * Are we the only task in the tree?
>> +	 */
>> +	if (unlikely(rq->nr_running == 1))
>> +		return;
>> +
>> +	clear_buddies(cfs_rq, se);
>> +
>> +	if (curr->policy != SCHED_BATCH) {
>> +		update_rq_clock(rq);
>> +		/*
>> +		 * Update run-time statistics of the 'current'.
>> +		 */
>> +		update_curr(cfs_rq);
>> +	}
>> +
>> +	set_yield_buddy(se);
>> +}
>
> You just lost sysctl_sched_compat_yield, someone might be upset (I
> really can't be bothered much with people using sys_yield :-), but if
> you're going down that road you want a hunk in kernel/sysctl.c as well I
> think.

I lost sysctl_sched_compat_yield, because with my code
yield is no longer a noop.

I'd be glad to remove the sysctl.c bits if you want :)
