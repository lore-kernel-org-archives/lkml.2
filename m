Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0LIRnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:43:42 -0500
Received: from smtp-out.google.com ([74.125.121.35]:33572 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab0LIRnl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KbeuKzx0/BoEw4mWMGJbVGN9HHsfV7wbVAOYEgmbWbYQx0Ixj4Ubc9BN/zKZtOYvJ4
         uq9K9VLaLPi+05ITDYsw==
MIME-Version: 1.0
In-Reply-To: <1291899120.29292.7.camel@twins>
References: <20101208142814.GE9777@n2100.arm.linux.org.uk>
	<1291851079-27061-1-git-send-email-venki@google.com>
	<1291899120.29292.7.camel@twins>
Date: Thu, 9 Dec 2010 09:43:36 -0800
Message-ID: <AANLkTikd3X4pLs5De-LO6=XD+JqUz3-Ku7YM8+0-oK8t@mail.gmail.com>
Subject: Re: [BUG] 2.6.37-rc3 massive interactivity regression on ARM
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 4:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-12-08 at 15:31 -0800, Venkatesh Pallipadi wrote:
>
>> [PATCH] update_rq_clock() with irq_time should handle 64 bit wraparound
>>
>> update_rq_clock with IRQ_TIME_ACCOUNTING assumed 64 bit sched_clock that
>> practically will not wraparound. Change to code to handle wraparounds,
>> still preventing rq->clock_task from going backwards.
>
> All we should do is deal with the 64wrap, not filter backward motion, I
> came up with something like the below.

The original intent of this check
- if (rq->clock - irq_time > rq->clock_task)
was to filter the potential backward motion. As otherwise, downstream
users of clock_task can see
huge positive numbers from curr - prev calculations.

The same problem will be there with below code, with irq_delta >
delta, clock_task can go backwards which is not good.
+       delta -= irq_delta;
+       rq->clock_task += delta;

The reason for this is rq->clock and irqtime updates kind of happen
independently and specifically, if a rq->clock update happens while we
are in a softirq, we may have this case of going backwards on the next
update.

>
> I think for now the best solution to the early wrap problem for ARM is
> for them to select HAVE_UNSTABLE_SCHED_CLOCK, it will mostly deal with
> the short wrap by filtering out the occasional negative value.
>
> Then later we can look at cleaning/breaking-up the kernel/sched_clock.c
> code to provide smaller bits of functionality and possibly merging it
> with some of the clocksource code.
>

Yes. That should resolve the early wrap.


Thanks,
Venki

> ---
>  kernel/sched.c |   54 +++++++++++++++++++++++++-----------------------------
>  1 files changed, 25 insertions(+), 29 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 8e885c1..0fb7de8 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -642,23 +642,19 @@ static inline struct task_group *task_group(struct task_struct *p)
>
>  #endif /* CONFIG_CGROUP_SCHED */
>
> -static u64 irq_time_cpu(int cpu);
> -static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
> +static void update_rq_clock_task(struct rq *rq, s64 delta);
>
>  inline void update_rq_clock(struct rq *rq)
>  {
> -       int cpu = cpu_of(rq);
> -       u64 irq_time;
> +       s64 delta;
>
>        if (rq->skip_clock_update)
>                return;
>
> -       rq->clock = sched_clock_cpu(cpu);
> -       irq_time = irq_time_cpu(cpu);
> -       if (rq->clock - irq_time > rq->clock_task)
> -               rq->clock_task = rq->clock - irq_time;
> +       delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> +       rq->clock += delta;
> +       update_rq_clock_task(rq, delta);
>
> -       sched_irq_time_avg_update(rq, irq_time);
>  }
>
>  /*
> @@ -1817,14 +1813,6 @@ void disable_sched_clock_irqtime(void)
>        sched_clock_irqtime = 0;
>  }
>
> -static u64 irq_time_cpu(int cpu)
> -{
> -       if (!sched_clock_irqtime)
> -               return 0;
> -
> -       return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
> -}
> -
>  void account_system_vtime(struct task_struct *curr)
>  {
>        unsigned long flags;
> @@ -1855,25 +1843,33 @@ void account_system_vtime(struct task_struct *curr)
>  }
>  EXPORT_SYMBOL_GPL(account_system_vtime);
>
> -static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
> +static inline u64 irq_time_cpu(int cpu)
>  {
> -       if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
> -               u64 delta_irq = curr_irq_time - rq->prev_irq_time;
> -               rq->prev_irq_time = curr_irq_time;
> -               sched_rt_avg_update(rq, delta_irq);
> -       }
> +       return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
>  }
>
> -#else
> -
> -static u64 irq_time_cpu(int cpu)
> +static void update_rq_clock_task(struct rq *rq, s64 delta)
>  {
> -       return 0;
> +       s64 irq_delta;
> +
> +       irq_delta = irq_time_cpu(cpu_of(rq)) - rq->prev_irq_time;
> +       rq->prev_irq_time += irq_delta;
> +
> +       delta -= irq_delta;
> +       rq->clock_task += delta;
> +
> +       if (irq_delta && sched_feat(NONIRQ_POWER))
> +               sched_rt_avg_update(rq, irq_delta);
>  }
>
> -static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time) { }
> +#else /* CONFIG_IRQ_TIME_ACCOUNTING */
>
> -#endif
> +static inline void update_rq_clock_task(struct rq *rq, s64 delta)
> +{
> +       rq->clock_task += delta;
> +}
> +
> +#endif /* CONFIG_IRQ_TIME_ACCOUNTING */
>
>  #include "sched_idletask.c"
>  #include "sched_fair.c"
>
>
