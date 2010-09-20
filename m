Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0ITRj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:39:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab0ITRjZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QZxabm2phZnzD4j+aw7/4hiaTs/dM1Mja+qYsG4Q8oHrUyBb+Crr3wR03XwAt6ShWD
         zVBz7s8dIQdBDOrk9WZg==
MIME-Version: 1.0
In-Reply-To: <1284895893.2275.627.camel@laptop>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	<1284688596-6731-6-git-send-email-venki@google.com>
	<1284895893.2275.627.camel@laptop>
Date: Mon, 20 Sep 2010 10:38:59 -0700
Message-ID: <AANLkTi=Hxaz9+x-Fw7p2=4G+zw52chPuUgkaTcCqhQDy@mail.gmail.com>
Subject: Re: [PATCH 5/6] sched: Remove irq time from available CPU power
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

On Sun, Sep 19, 2010 at 4:31 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
>> +++ b/kernel/sched.c
>> @@ -2025,6 +2025,18 @@ static u64 unaccount_irq_delta(u64 delta, int cpu, u64 *saved_irq_time)
>>  #define unaccount_irq_delta_rt(delta, cpu, class_rq)            \
>>                 unaccount_irq_delta(delta, cpu, &(class_rq)->saved_irq_time)
>>
>> +static void sched_irq_power_update_fair(int cpu, struct cfs_rq *cfs_rq,
>> +                       struct rq* rq)
>> +{
>> +       if (!sched_clock_irqtime)
>> +               return;
>> +
>> +       if (likely(rq->total_irq_time > cfs_rq->saved_irq_time)) {
>> +               sched_rt_avg_update(rq,
>> +                               rq->total_irq_time - cfs_rq->saved_irq_time);
>> +       }
>> +}
>> +
>>  #else
>>
>>  #define update_irq_time(cpu, crq)              do { } while (0)
>> @@ -2042,6 +2054,8 @@ static u64 unaccount_irq_delta_rt(u64 delta_exec, int cpu, struct rt_rq *rt_rq)
>>         return delta_exec;
>>  }
>>
>> +#define sched_irq_power_update_fair(cpu, crq, rq)      do { } while (0)
>> +
>>  #endif
>>
>>  #include "sched_idletask.c"
>> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> index a64fdaf..937fded 100644
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -526,6 +526,9 @@ static void update_curr(struct cfs_rq *cfs_rq)
>>         if (unlikely(!curr))
>>                 return;
>>
>> +       if (sched_feat(NONIRQ_POWER) && entity_is_task(curr))
>> +               sched_irq_power_update_fair(cpu, cfs_rq, rq_of(cfs_rq));
>> +
>>         /*
>>          * Get the amount of time the current task was running
>>          * since the last time we changed load (this cannot
>
> This all looks very confusing to me,.. How about we simply fold the
> delta between rq->clock and rq->clock_task into sched_rt_avg_update()
> and be done with it?
>

rq->clock and rq->clock_task: As I understood, you mean having both
being continuous counters since boot. So, we will still need some
"rt_avg_accounted irq_time" that will be updated when
sched_rt_avg_update() is done. Or am I missing something?

Thanks.
Venki
