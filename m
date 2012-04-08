Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2DHUUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 16:20:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56666 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2DHUUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 16:20:08 -0400
Message-ID: <4F81F2F1.8010105@gmail.com>
Date: Sun, 08 Apr 2012 22:20:01 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, Fabio Checconi <fchecconi@gmail.com>,
        Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>,
        Dhaval Giani <dhaval.giani@gmail.com>, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, Dario Faggioli <raistlin@linux.it>,
        Insop Song <insop.song@ericsson.com>, liming.wang@windriver.com
Subject: Re: [PATCH 06/16] sched: SCHED_DEADLINE push and pull logic
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com> <1333696481-3433-7-git-send-email-juri.lelli@gmail.com> <CAJd=RBBm8yDBrZFj48tP_5WsG=z0Rsv_=j=kArV1Mj6yJvQjVA@mail.gmail.com> <4F7F285A.1010703@gmail.com> <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
In-Reply-To: <CAJd=RBC13JUuX0gtQidpNc=T+pnPgtKVQwRsP-mPQeiyfd9fPA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 04:32 AM, Hillf Danton wrote:
> On Sat, Apr 7, 2012 at 1:31 AM, Juri Lelli<juri.lelli@gmail.com>  wrote:
>>>>
>>>>   kernel/sched_dl.c |  912
>>>>   kernel/sched_rt.c |    2 +-
>
> You are working on 2.6.3x, x<= 8 ?
> If so, what is the reason(just curious)?
> Already planned to add in 3.3 and above?
>

Dario answered on this :-).
   
>>>> +               if (!dl_entity_preempt(&entry->dl,&p->dl))
>>>
>>>                 if (dl_entity_preempt(&p->dl,&entry->dl))
>>>
>>
>> Any specific reason to reverse the condition?
>>
> Just for easing readers.
>

Ok, reasonable. Here and below.

>>>> +select_task_rq_dl(struct task_struct *p, int sd_flag, int flags)
>>>> +{
>>>> +       struct task_struct *curr;
>>>> +       struct rq *rq;
>>>> +       int cpu;
>>>> +
>>>> +       if (sd_flag != SD_BALANCE_WAKE)
>>>
>>>                 why is task_cpu(p) not eligible?
>>>
>>
>> Right, I'll change this.
>>
> No, you will first IMO sort out clear answer to the question.
>

task_cpu(p) is eligible and will be returned if sd_flag != SD_BALANCE_WAKE
&& sd_flag != SD_BALANCE_FORK as in sched_rt. I changed the code accordingly.

>>>> +           (rq->curr->dl.nr_cpus_allowed<    2 ||
>>>> +            dl_entity_preempt(&rq->curr->dl,&p->dl))&&
>>>
>>>                 !dl_entity_preempt(&p->dl,&rq->curr->dl))&&
>>
>> As above?
>>
> Just for easing reader.
>
>>>> +#ifdef CONFIG_SMP
>>>> +       /*
>>>> +        * In the unlikely case current and p have the same deadline
>>>> +        * let us try to decide what's the best thing to do...
>>>> +        */
>>>> +       if ((s64)(p->dl.deadline - rq->curr->dl.deadline) == 0&&
>>>> +           !need_resched())
>>>
>>> please recheck !need_resched(), say rq->curr need reschedule?
>>
>> Sorry, I don't get this..
>>
> Perhaps smp_processor_id() != rq->cpu
>

need_resched is actually checked...

>>>
>>>         if (task_running(rq, p))
>>>                 return 0;
>>>         return cpumask_test_cpu(cpu,&p->cpus_allowed);
>>
>> We use this inside pull_dl_task. Since we are searching for a task to
>> pull, you must be sure that the found task can actually migrate checking
>> nr_cpus_allowed>  1.
>>
> If cpu is certainly allowed for task to run, but nr_cpus_allowed is no more
> than one, which is corrupted?
>
>>
>> Well, ok with this and above. Anyway this code is completely removed in
>> 15/16.
>>
> Yup, another reason for monolith.
>

Monolithic is below. Anyway, please check the github repo for bug
fixes/new features. ;-)

>>>> +
>>>> +static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask_dl);
>>>> +
>>>> +static int find_later_rq(struct task_struct *task)
>>>> +{
>>>> +       struct sched_domain *sd;
>>>> +       struct cpumask *later_mask = __get_cpu_var(local_cpu_mask_dl);
>>>
>>>         please check is local_cpu_mask_dl valid
>>>
>>
>> Could you explain more why should I check for validity?
>>
> Only for the case that something comes in before it is initialized,
> IIRC encountered by Steven.
>

Do you mean at kernel_init time?
Could you be more precise about the problem Steven encountered?

>>
>> Ok, I'll prepare the monolithic patch and probably store it somewhere so
>> that it can be downloaded also by others.
>>
> Info Hillf once it is ready, thanks.
>

Here we go:
https://github.com/downloads/jlelli/sched-deadline/sched-dl-V4.patch

I noticed that the Cc list is changed... something went wrong?
Anyway, I restored it to the original one. :-)

Thanks and Regards,

- Juri
