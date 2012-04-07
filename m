Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2DGCcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 22:32:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41402 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2DGCcP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 22:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <4F7F285A.1010703@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	<1333696481-3433-7-git-send-email-juri.lelli@gmail.com>
	<CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com>
	<4F7F285A.1010703@gmail.com>
Date: Sat, 7 Apr 2012 10:32:14 +0800
Message-ID: <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
From: Hillf Danton <dhillf@gmail.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fcheccon@jasper.es
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 1:31 AM, Juri Lelli <juri.lelli@gmail.com> wrote:
>>>
>>>  kernel/sched_dl.c |  912
>>>  kernel/sched_rt.c |    2 +-

You are working on 2.6.3x, x <= 8 ?
If so, what is the reason(just curious)?
Already planned to add in 3.3 and above?

>>> +               if (!dl_entity_preempt(&entry->dl,&p->dl))
>>
>>                if (dl_entity_preempt(&p->dl,&entry->dl))
>>
>
> Any specific reason to reverse the condition?
>
Just for easing readers.

>>> +select_task_rq_dl(struct task_struct *p, int sd_flag, int flags)
>>> +{
>>> +       struct task_struct *curr;
>>> +       struct rq *rq;
>>> +       int cpu;
>>> +
>>> +       if (sd_flag != SD_BALANCE_WAKE)
>>
>>                why is task_cpu(p) not eligible?
>>
>
> Right, I'll change this.
>
No, you will first IMO sort out clear answer to the question.

>>> +           (rq->curr->dl.nr_cpus_allowed<  2 ||
>>> +            dl_entity_preempt(&rq->curr->dl,&p->dl))&&
>>
>>                !dl_entity_preempt(&p->dl,&rq->curr->dl))&&
>
> As above?
>
Just for easing reader.

>>> +#ifdef CONFIG_SMP
>>> +       /*
>>> +        * In the unlikely case current and p have the same deadline
>>> +        * let us try to decide what's the best thing to do...
>>> +        */
>>> +       if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0&&
>>> +           !need_resched())
>>
>> please recheck !need_resched(), say rq->curr need reschedule?
>
> Sorry, I don't get this..
>
Perhaps smp_processor_id() != rq->cpu

>>
>>        if (task_running(rq, p))
>>                return 0;
>>        return cpumask_test_cpu(cpu, &p->cpus_allowed);
>
> We use this inside pull_dl_task. Since we are searching for a task to
> pull, you must be sure that the found task can actually migrate checking
> nr_cpus_allowed > 1.
>
If cpu is certainly allowed for task to run, but nr_cpus_allowed is no more
than one, which is corrupted?

>
> Well, ok with this and above. Anyway this code is completely removed in
> 15/16.
>
Yup, another reason for monolith.

>>> +
>>> +static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
>>> +
>>> +static int find_later_rq(struct task_struct *task)
>>> +{
>>> +       struct sched_domain *sd;
>>> +       struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
>>
>>        please check is local_cpu_mask_dl valid
>>
>
> Could you explain more why should I check for validity?
>
Only for the case that something comes in before it is initialized,
IIRC encountered by Steven.

>
> Ok, I'll prepare the monolithic patch and probably store it somewhere so
> that it can be downloaded also by others.
>
Info Hillf once it is ready, thanks.

Good Weekend
-hd
