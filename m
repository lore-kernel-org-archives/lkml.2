Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab0ITRNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 13:13:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4234 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704Ab0ITRNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 13:13:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cFZo/X/xYF1Qf/tvfObS2G4SlgVMrXRAq8Dlo5qYa0WP4C6Jf23Okbt6EE9uo6oVQ6
         zNdvduqZCL/qizdqjQkA==
MIME-Version: 1.0
In-Reply-To: <1284894708.2275.607.camel@laptop>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	<1284688596-6731-3-git-send-email-venki@google.com>
	<1284894708.2275.607.camel@laptop>
Date: Mon, 20 Sep 2010 10:13:23 -0700
Message-ID: <AANLkTinu+2N7xnkuzMvhL+3V=vbRMDNT6ep-OHPrbT4y@mail.gmail.com>
Subject: Re: [PATCH 2/6] Add IRQ_TIME_ACCOUNTING, finer accounting of CPU irq time
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

On Sun, Sep 19, 2010 at 4:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
>>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>>  include/linux/hardirq.h |    2 +-
>>  include/linux/sched.h   |   11 +++++++++++
>>  kernel/sched.c          |   38 ++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 50 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
>> index ce22d09..bfafd29 100644
>> --- a/include/linux/hardirq.h
>> +++ b/include/linux/hardirq.h
>> @@ -132,7 +132,7 @@ extern void synchronize_irq(unsigned int irq);
>>
>>  struct task_struct;
>>
>> -#ifndef CONFIG_VIRT_CPU_ACCOUNTING
>> +#if !defined(CONFIG_VIRT_CPU_ACCOUNTING) && !defined(CONFIG_IRQ_TIME_ACCOUNTING)
>>  static inline void account_system_vtime(struct task_struct *tsk)
>>  {
>>  }
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 1e2a6db..dbb6808 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1826,6 +1826,17 @@ extern void sched_clock_idle_sleep_event(void);
>>  extern void sched_clock_idle_wakeup_event(u64 delta_ns);
>>  #endif
>>
>> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
>> +/*
>> + * An i/f to runtime opt-in for irq time accounting based off of sched_clock.
>> + * The reason for this explicit opt-in is not to have perf penalty with
>> + * slow sched_clocks.
>> + */
>> +extern void enable_sched_clock_irqtime(void);
>> +#else
>> +static inline void enable_sched_clock_irqtime(void) {}
>> +#endif
>> +
>>  extern unsigned long long
>>  task_sched_runtime(struct task_struct *task);
>>  extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index ed09d4f..912d2de 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -1917,6 +1917,44 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
>>         dec_nr_running(rq);
>>  }
>>
>> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
>> +
>> +static DEFINE_PER_CPU(u64, cpu_hardirq_time);
>> +static DEFINE_PER_CPU(u64, cpu_softirq_time);
>> +
>> +static DEFINE_PER_CPU(u64, irq_start_time);
>> +static int sched_clock_irqtime;
>> +
>> +void enable_sched_clock_irqtime(void)
>> +{
>> +       sched_clock_irqtime = 1;
>> +}
>> +
>> +void account_system_vtime(struct task_struct *tsk)
>> +{
>> +       unsigned long flags;
>> +       int cpu;
>> +       u64 now, delta;
>> +
>> +       if (!sched_clock_irqtime)
>> +               return;
>> +
>> +       local_irq_save(flags);
>> +
>> +       cpu = task_cpu(tsk);
>
> Can this ever be anything other can smp_processor_id() and current?
>
>> +       now = sched_clock();
>
> this should be using one of the kernel/sched_clock.c thingies, probably
> local_clock(), or sched_clock_cpu(cpu).

I don't really need task there. I can use smp_processor_id() or
task_cpu(tsk) and I think latter one would be cheaper.

You mean sched_clock() is not the right interface to use here.
sched_clock_cpu() uses either sched_clock or remote_cpu stuff which I
don't really need here and local_clock() also has irq
disable/smp_processor_id() and calls sched_clock_cpu in turn.
sched_clock() seemed to be more appropriate.

Thanks,
Venki
