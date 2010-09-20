Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab0ITReJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:34:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:17296 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0ITReH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:34:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WeSqyBxJ0jHIzU/4OHIBfXB0ALXx4lNDx+qNANfv8d38SnUxi7FqFcrlFeHE/R8F2K
         SvXk0KbVrQm74L6bKCYQ==
MIME-Version: 1.0
In-Reply-To: <1284895730.2275.625.camel@laptop>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	<1284688596-6731-5-git-send-email-venki@google.com>
	<1284895730.2275.625.camel@laptop>
Date: Mon, 20 Sep 2010 10:33:52 -0700
Message-ID: <AANLkTimgQf=SO0rRotuzNsvN9xYrc2jJ5eDVZb2FxJRK@mail.gmail.com>
Subject: Re: [PATCH 4/6] sched: Do not account irq time to current task
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 19, 2010 at 4:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>
> This patch makes my head hurt.

This is what I meant when I said the code turned out to be "messy" here :-)
- http://lkml.indiana.edu/hypermail//linux/kernel/1008.3/00784.html

<snip> as all the comments were related..

>
>> +#else
>> +
>> +#define update_irq_time(cpu, crq)              do { } while (0)
>> +
>> +static void save_rq_irq_time(int cpu, struct rq *rq) { }
>> +
>> +static unsigned long unaccount_irq_delta_fair(unsigned long delta_exec,
>> +               int cpu, struct cfs_rq *cfs_rq)
>> +{
>> +       return delta_exec;
>> +}
>> +
>> +static u64 unaccount_irq_delta_rt(u64 delta_exec, int cpu, struct rt_rq *rt_rq)
>> +{
>> +       return delta_exec;
>> +}
>> +
>>  #endif
>>
>>  #include "sched_idletask.c"
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index a171138..a64fdaf 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -521,6 +521,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
>>         struct sched_entity *curr = cfs_rq->curr;
>>         u64 now = rq_of(cfs_rq)->clock;
>
>  u64 now = rq_of(cfs_rq)->clock_task;
>
>>         unsigned long delta_exec;
>> +       int cpu = cpu_of(rq_of(cfs_rq));
>>
>>         if (unlikely(!curr))
>>                 return;
>> @@ -531,11 +532,13 @@ static void update_curr(struct cfs_rq *cfs_rq)
>>          * overflow on 32 bits):
>>          */
>>         delta_exec = (unsigned long)(now - curr->exec_start);
>> +       curr->exec_start = now;
>> +       delta_exec = unaccount_irq_delta_fair(delta_exec, cpu, cfs_rq);
>> +
>>         if (!delta_exec)
>>                 return;
>>
>>         __update_curr(cfs_rq, curr, delta_exec);
>> -       curr->exec_start = now;
>>
>>         if (entity_is_task(curr)) {
>>                 struct task_struct *curtask = task_of(curr);
>> @@ -603,6 +606,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
>>          * We are starting a new run period:
>>          */
>>         se->exec_start = rq_of(cfs_rq)->clock;
>> +       update_irq_time(cpu_of(rq_of(cfs_rq)), cfs_rq);
>>  }
>>
>>  /**************************************************
>
> se->exec_start = rq_of(cfs_rq)->clock_task;
>
> And you don't need anything else, hmm?
>
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index d10c80e..000d402 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -605,6 +605,7 @@ static void update_curr_rt(struct rq *rq)
>>         struct sched_rt_entity *rt_se = &curr->rt;
>>         struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
>>         u64 delta_exec;
>> +       int cpu = cpu_of(rq);
>>
>>         if (!task_has_rt_policy(curr))
>>                 return;
>> @@ -613,6 +614,14 @@ static void update_curr_rt(struct rq *rq)
>>         if (unlikely((s64)delta_exec < 0))
>>                 delta_exec = 0;
>>
>> +       /*
>> +        * rt_avg_update before removing irq_delta, to keep up with
>> +        * current behavior.
>> +        */
>> +       sched_rt_avg_update(rq, delta_exec);
>> +
>> +       delta_exec = unaccount_irq_delta_rt(delta_exec, cpu, rt_rq);
>> +
>>         schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
>>
>>         curr->se.sum_exec_runtime += delta_exec;
>> @@ -621,8 +630,6 @@ static void update_curr_rt(struct rq *rq)
>>         curr->se.exec_start = rq->clock;
>>         cpuacct_charge(curr, delta_exec);
>>
>> -       sched_rt_avg_update(rq, delta_exec);
>> -
>>         if (!rt_bandwidth_enabled())
>>                 return;
>
> I think it would all greatly simplify if you would compute delta_exec
> from rq->clock_task and add IRQ time to sched_rt_avg_update()
> separately.
>

Yes. I like your idea of having separate rq->clock and rq->clock_task.
That will clean up this code a bit.
We will still need to keep track of "last accounted irq time" at the
task or rq level to account sched_rt_avg_update correctly. But, I dont
have to play with cfs_rq and rt_rq as in this patch though.

Thanks,
Venki
