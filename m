Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0LJWKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:10:03 -0500
Received: from smtp-out.google.com ([74.125.121.35]:17943 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0LJWKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:10:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C3k4AQIp+oE/4stImiBC7O3Lon/IU310oZFhU7Iddaf/zF2pV1lXS88+5phvpZFueV
         cpIovxhEbE6SiyVOcBbA==
MIME-Version: 1.0
In-Reply-To: <1292013506.13513.78.camel@laptop>
References: <1292013506.13513.78.camel@laptop>
Date: Fri, 10 Dec 2010 14:09:56 -0800
Message-ID: <AANLkTi=vUvNET2peva7uzWbzk5eK5EsKUrEQQSwLkNwM@mail.gmail.com>
Subject: Re: [PATCH] sched: Fix the irqtime code to deal with u64 wraps
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <johnstul@us.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 12:38 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> OK, so here's the latest version, using fancy __this_cpu thingies.
>
> I started a new thread since the old one was quite unwieldy.
>
> Now, admittedly this patch is a tad large, esp for -rc5. So either we
> need lots of Reviewed-by and such or I need to shrink this patch
> somehow.
>

- Needs prototype declaration for
static void update_rq_clock_task(struct rq *rq, s64 delta)
before first use.
- I guess irq_time_cpu() function can be eliminated making the patch a
bit smaller.
- May be split into two patches, first to handle 64 bit overflow and
second to handle the 32 bit access of these u64 variables?

Otherwise, change looks good and works OK with my quick tests.

Reviewed-by: Venkatesh Pallipadi <venki@google.com>

>
> ---
> Subject: sched: Fix the irqtime code to deal with u64 wraps
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Thu Dec 09 14:15:34 CET 2010
>
> ARM systems have a 32bit sched_clock() [ which needs to be fixed ],
> but this exposed a bug in the irq_time code as well, it doesn't deal
> with wraps at all.
>
> Fix the irq_time code to deal with u64 wraps by re-writing the code to
> only use delta increments, which avoids the whole issue.
>
> Furthermore, solve the problem of 32bit arches reading partial updates
> of the u64 time values.
>
> Cc: Venkatesh Pallipadi <venki@google.com>
> Reported-by: Mikael Pettersson <mikpe@it.uu.se>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c |  176 +++++++++++++++++++++++++++++++++++++++------------------
>  1 file changed, 121 insertions(+), 55 deletions(-)
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -636,22 +636,16 @@ static inline struct task_group *task_gr
>
>  #endif /* CONFIG_CGROUP_SCHED */
>
> -static u64 irq_time_cpu(int cpu);
> -static void sched_irq_time_avg_update(struct rq *rq, u64 irq_time);
> -
> -inline void update_rq_clock(struct rq *rq)
> +static void update_rq_clock(struct rq *rq)
>  {
> -       if (!rq->skip_clock_update) {
> -               int cpu = cpu_of(rq);
> -               u64 irq_time;
> +       s64 delta;
>
> -               rq->clock = sched_clock_cpu(cpu);
> -               irq_time = irq_time_cpu(cpu);
> -               if (rq->clock - irq_time > rq->clock_task)
> -                       rq->clock_task = rq->clock - irq_time;
> +       if (rq->skip_clock_update)
> +               return;
>
> -               sched_irq_time_avg_update(rq, irq_time);
> -       }
> +       delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> +       rq->clock += delta;
> +       update_rq_clock_task(rq, delta);
>  }
>
>  /*
> @@ -1918,90 +1912,162 @@ static void deactivate_task(struct rq *r
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>
>  /*
> - * There are no locks covering percpu hardirq/softirq time.
> - * They are only modified in account_system_vtime, on corresponding CPU
> - * with interrupts disabled. So, writes are safe.
> + * There are no locks covering percpu hardirq/softirq time. They are only
> + * modified in account_system_vtime, on corresponding CPU with interrupts
> + * disabled. So, writes are safe.
> + *
>  * They are read and saved off onto struct rq in update_rq_clock().
> - * This may result in other CPU reading this CPU's irq time and can
> - * race with irq/account_system_vtime on this CPU. We would either get old
> - * or new value (or semi updated value on 32 bit) with a side effect of
> - * accounting a slice of irq time to wrong task when irq is in progress
> - * while we read rq->clock. That is a worthy compromise in place of having
> - * locks on each irq in account_system_time.
> + *
> + * This may result in other CPU reading this CPU's irq time and can race with
> + * irq/account_system_vtime on this CPU. We would either get old or new value
> + * with a side effect of accounting a slice of irq time to wrong task when irq
> + * is in progress while we read rq->clock. That is a worthy compromise in place
> + * of having locks on each irq in account_system_time.
>  */
>  static DEFINE_PER_CPU(u64, cpu_hardirq_time);
>  static DEFINE_PER_CPU(u64, cpu_softirq_time);
> -
>  static DEFINE_PER_CPU(u64, irq_start_time);
> -static int sched_clock_irqtime;
>
> -void enable_sched_clock_irqtime(void)
> +#ifndef CONFIG_64BIT
> +static DEFINE_PER_CPU(seqcount_t, irq_time_seq);
> +
> +static inline void irq_time_write_begin(void)
>  {
> -       sched_clock_irqtime = 1;
> +       __this_cpu_inc(irq_time_seq.sequence);
> +       smp_wmb();
>  }
>
> -void disable_sched_clock_irqtime(void)
> +static inline void irq_time_write_end(void)
>  {
> -       sched_clock_irqtime = 0;
> +       smp_wmb();
> +       __this_cpu_inc(irq_time_seq.sequence);
>  }
>
> -static u64 irq_time_cpu(int cpu)
> +static inline u64 irq_time_read(int cpu)
>  {
> -       if (!sched_clock_irqtime)
> -               return 0;
> +       u64 irq_time;
> +       unsigned seq;
> +
> +       do {
> +               seq = read_seqcount_begin(&per_cpu(irq_time_seq, cpu));
> +               irq_time = per_cpu(cpu_softirq_time, cpu) +
> +                          per_cpu(cpu_hardirq_time, cpu);
> +       } while (read_seqcount_retry(&per_cpu(irq_time_seq, cpu), seq));
> +
> +       return irq_time;
> +}
> +#else /* CONFIG_64BIT */
> +static inline void irq_time_write_begin(void)
> +{
> +}
>
> +static inline void irq_time_write_end(void)
> +{
> +}
> +
> +static inline u64 irq_time_read(int cpu)
> +{
>        return per_cpu(cpu_softirq_time, cpu) + per_cpu(cpu_hardirq_time, cpu);
>  }
> +#endif /* CONFIG_64BIT */
> +
> +static int sched_clock_irqtime;
> +
> +void enable_sched_clock_irqtime(void)
> +{
> +       sched_clock_irqtime = 1;
> +}
> +
> +void disable_sched_clock_irqtime(void)
> +{
> +       sched_clock_irqtime = 0;
> +}
>
> +/*
> + * Called before incrementing preempt_count on {soft,}irq_enter
> + * and before decrementing preempt_count on {soft,}irq_exit.
> + */
>  void account_system_vtime(struct task_struct *curr)
>  {
>        unsigned long flags;
> +       s64 delta;
>        int cpu;
> -       u64 now, delta;
>
>        if (!sched_clock_irqtime)
>                return;
>
>        local_irq_save(flags);
> -
>        cpu = smp_processor_id();
> -       now = sched_clock_cpu(cpu);
> -       delta = now - per_cpu(irq_start_time, cpu);
> -       per_cpu(irq_start_time, cpu) = now;
> +       delta = sched_clock_cpu(cpu) - __this_cpu_read(irq_start_time);
> +       __this_cpu_add(irq_start_time, delta);
> +
> +       irq_time_write_begin();
> +
> +       if (hardirq_count())
> +               __this_cpu_add(cpu_hardirq_time, delta);
>        /*
> -        * We do not account for softirq time from ksoftirqd here.
> -        * We want to continue accounting softirq time to ksoftirqd thread
> -        * in that case, so as not to confuse scheduler with a special task
> -        * that do not consume any time, but still wants to run.
> +        * We do not account for softirq time from ksoftirqd here. We want to
> +        * continue accounting softirq time to ksoftirqd thread in that case,
> +        * so as not to confuse scheduler with a special task that do not
> +        * consume any time, but still wants to run.
>         */
> -       if (hardirq_count())
> -               per_cpu(cpu_hardirq_time, cpu) += delta;
>        else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
> -               per_cpu(cpu_softirq_time, cpu) += delta;
> +               __this_cpu_add(cpu_softirq_time, delta);
>
> +       irq_time_write_end();
>        local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(account_system_vtime);
>
> -static void sched_irq_time_avg_update(struct rq *rq, u64 curr_irq_time)
> +static u64 irq_time_cpu(struct rq *rq)
>  {
> -       if (sched_clock_irqtime && sched_feat(NONIRQ_POWER)) {
> -               u64 delta_irq = curr_irq_time - rq->prev_irq_time;
> -               rq->prev_irq_time = curr_irq_time;
> -               sched_rt_avg_update(rq, delta_irq);
> -       }
> +       /*
> +        * See the comment in update_rq_clock_task(), ideally we'd update
> +        * the *irq_time values using rq->clock here.
> +        */
> +       return irq_time_read(cpu_of(rq));
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
> +       irq_delta = irq_time_cpu(rq) - rq->prev_irq_time;
> +
> +       /*
> +        * Since irq_time is only updated on {soft,}irq_exit, we might run into
> +        * this case when a previous update_rq_clock() happened inside a
> +        * {soft,}irq region.
> +        *
> +        * When this happens, we stop ->clock_task and only update the
> +        * prev_irq_time stamp to account for the part that fit, so that a next
> +        * update will consume the rest. This ensures ->clock_task is
> +        * monotonic.
> +        *
> +        * It does however cause some slight miss-attribution of {soft,}irq
> +        * time, a more accurate solution would be to update the irq_time using
> +        * the current rq->clock timestamp, except that would require using
> +        * atomic ops.
> +        */
> +       if (irq_delta > delta)
> +               irq_delta = delta;
> +
> +       rq->prev_irq_time += irq_delta;
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
> +static void update_rq_clock_task(struct rq *rq, s64 delta)
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
