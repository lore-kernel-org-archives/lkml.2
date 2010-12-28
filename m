Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab0L1GIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 01:08:22 -0500
Received: from mail.wdtv.com ([66.118.69.84]:33209 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab0L1GIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 01:08:21 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Mike Galbraith <mgalbraith@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
Date: Tue, 28 Dec 2010 01:08:12 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36.1-latencyfix; KDE/4.5.4; i686; ; )
References: <20101213224434.7495edb2@annuminas.surriel.com> <1292861059.15207.7.camel@marge.simson.net> <1293515683.6930.16.camel@marge.simson.net>
In-Reply-To: <1293515683.6930.16.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012280108.12807.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 28, 2010, Mike Galbraith wrote:
>On Mon, 2010-12-20 at 17:04 +0100, Mike Galbraith wrote:
>> On Mon, 2010-12-20 at 10:40 -0500, Rik van Riel wrote:
>> > On 12/17/2010 02:15 AM, Mike Galbraith wrote:
>> > > BTW, with this vruntime donation thingy, what prevents a task from
>> > > forking off accomplices who do nothing but wait for a wakeup and
>> > > yield_to(exploit)?
>> > > 
>> > > Even swapping vruntimes in the same cfs_rq is dangerous as hell,
>> > > because one party is going backward.
>> > 
>> > I just realized the answer to this question.
>> > 
>> > We only give cpu time to tasks that are runnable, but not
>> > currently running.  That ensures one task cannot block others
>> > from running by having time yielded to it constantly.
>> 
>> Hm.  Don't think that will 100% sure prevent clock stoppage, because
>> the running task doesn't necessarily advance min_vruntime.
>> 
>> What about something like the below instead?  It compiles, but may eat
>> your first born child.
>
>(either it's christmas, or nobody cares to try it.  ho ho hum:)

Mike, I'd be glad to try it, but the last kernel I was able to make the 
nvidia drivers install on was 2.6.36.1-latencyfix, which had your earier 
patches in it, and it is working _very_ well.

>> sched: implement fair class yield_to(task) using cfs_rq->next as a
>> selection hint.
>> 
>> <CHANGELOG>
>> 
>> Not-signed-off-by: Mike Galbraith <efault@gmx.de>
>> ---
>> 
>>  include/linux/sched.h |    1
>>  kernel/sched.c        |   47 +++++++++++++++++++++++++++++++++++++++++
>>  kernel/sched_fair.c   |   56
>>  ++++++++++++++++++++++++++++++++++++++++++++++++++ 3 files changed,
>>  104 insertions(+)
>> 
>> Index: linux-2.6/include/linux/sched.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/sched.h
>> +++ linux-2.6/include/linux/sched.h
>> @@ -1056,6 +1056,7 @@ struct sched_class {
>> 
>>  	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int
>>  	flags); void (*dequeue_task) (struct rq *rq, struct task_struct *p,
>>  	int flags); void (*yield_task) (struct rq *rq);
>> 
>> +	int (*yield_to_task) (struct task_struct *p, int preempt);
>> 
>>  	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, 
int
>>  	flags);
>> 
>> Index: linux-2.6/kernel/sched.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/sched.c
>> +++ linux-2.6/kernel/sched.c
>> @@ -5325,6 +5325,53 @@ void __sched yield(void)
>> 
>>  }
>>  EXPORT_SYMBOL(yield);
>> 
>> +/**
>> + * yield_to - yield the current processor to another thread in
>> + * your thread group, or accelerate that thread toward the
>> + * processor it's on.
>> + *
>> + * It's the caller's job to ensure that the target task struct
>> + * can't go away on us before we can do any checks.
>> + */
>> +void __sched yield_to(struct task_struct *p, int preempt)
>> +{
>> +	struct task_struct *curr = current;
>> +	struct rq *rq, *p_rq;
>> +	unsigned long flags;
>> +	int yield = 0;
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
>> +	if (task_running(p_rq, p) || p->state || !p->se.on_rq ||
>> +			!same_thread_group(p, curr) ||
>> +			!curr->sched_class->yield_to_task ||
>> +			curr->sched_class != p->sched_class) {
>> +		goto out;
>> +	}
>> +
>> +	yield = curr->sched_class->yield_to_task(p, preempt);
>> +
>> +out:
>> +	double_rq_unlock(rq, p_rq);
>> +	local_irq_restore(flags);
>> +
>> +	if (yield) {
>> +		set_current_state(TASK_RUNNING);
>> +		schedule();
>> +	}
>> +}
>> +EXPORT_SYMBOL(yield_to);
>> +
>> +
>> 
>>  /*
>>  
>>   * This task is about to go to sleep on IO. Increment rq->nr_iowait so
>>   * that process accounting knows that this is a task in IO wait state.
>> 
>> Index: linux-2.6/kernel/sched_fair.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/sched_fair.c
>> +++ linux-2.6/kernel/sched_fair.c
>> @@ -1320,6 +1320,61 @@ static void yield_task_fair(struct rq *r
>> 
>>  }
>>  
>>  #ifdef CONFIG_SMP
>> 
>> +static void pull_task(struct rq *src_rq, struct task_struct *p,
>> +		      struct rq *this_rq, int this_cpu);
>> +#endif
>> +
>> +static int yield_to_task_fair(struct task_struct *p, int preempt)
>> +{
>> +	struct sched_entity *se = &current->se;
>> +	struct sched_entity *pse = &p->se;
>> +	struct sched_entity *curr = &(task_rq(p)->curr)->se;
>> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
>> +	struct cfs_rq *p_cfs_rq = cfs_rq_of(pse);
>> +	int yield = this_rq() == task_rq(p);
>> +	int want_preempt = preempt;
>> +
>> +#ifdef CONFIG_FAIR_GROUP_SCHED
>> +	if (cfs_rq->tg != p_cfs_rq->tg)
>> +		return 0;
>> +
>> +	/* Preemption only allowed within the same task group. */
>> +	if (preempt && cfs_rq->tg != cfs_rq_of(curr)->tg)
>> +		preempt = 0;
>> +#endif
>> +	/* Preemption only allowed within the same thread group. */
>> +	if (preempt && !same_thread_group(current, task_of(p_cfs_rq-
>curr)))
>> +		preempt = 0;
>> +
>> +#ifdef CONFIG_SMP
>> +	/*
>> +	 * If this yield is important enough to want to preempt instead
>> +	 * of only dropping a ->next hint, we're alone, and the target
>> +	 * is not alone, pull the target to this cpu.
>> +	 */
>> +	if (want_preempt && !yield && cfs_rq->nr_running == 1 &&
>> +			cpumask_test_cpu(smp_processor_id(), &p-
>cpus_allowed)) {
>> +		pull_task(task_rq(p), p, this_rq(), smp_processor_id());
>> +		p_cfs_rq = cfs_rq_of(pse);
>> +		yield = 1;
>> +	}
>> +#endif
>> +
>> +	if (yield)
>> +		clear_buddies(cfs_rq, se);
>> +	else if (preempt)
>> +		clear_buddies(p_cfs_rq, curr);
>> +
>> +	/* Tell the scheduler that we'd really like pse to run next. */
>> +	p_cfs_rq->next = pse;
>> +
>> +	if (!yield && preempt)
>> +		resched_task(task_of(p_cfs_rq->curr));
>> +
>> +	return yield;
>> +}
>> +
>> +#ifdef CONFIG_SMP
>> 
>>  static void task_waking_fair(struct rq *rq, struct task_struct *p)
>>  {
>> 
>> @@ -4126,6 +4181,7 @@ static const struct sched_class fair_sch
>> 
>>  	.enqueue_task		= enqueue_task_fair,
>>  	.dequeue_task		= dequeue_task_fair,
>>  	.yield_task		= yield_task_fair,
>> 
>> +	.yield_to_task		= yield_to_task_fair,
>> 
>>  	.check_preempt_curr	= check_preempt_wakeup,
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
I have more humility in my little finger than you have in your whole 
____BODY!
		-- from "Cerebus" #82
