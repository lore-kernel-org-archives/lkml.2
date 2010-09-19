Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab0ISL3E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 07:29:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:46331 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab0ISL3B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 07:29:01 -0400
Subject: Re: [PATCH 4/6] sched: Do not account irq time to current task
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
In-Reply-To: <1284688596-6731-5-git-send-email-venki@google.com>
References: <1284688596-6731-1-git-send-email-venki@google.com>
	 <1284688596-6731-5-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 19 Sep 2010 13:28:50 +0200
Message-ID: <1284895730.2275.625.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 18:56 -0700, Venkatesh Pallipadi wrote:
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>

This patch makes my head hurt.

> ---
>  kernel/sched.c      |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/sched_fair.c |    6 +++-
>  kernel/sched_rt.c   |   16 +++++++--
>  3 files changed, 108 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 912d2de..f36697b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -370,6 +370,10 @@ struct cfs_rq {
>         unsigned long rq_weight;
>  #endif
>  #endif
> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
> +       u64 saved_irq_time;
> +#endif
> +
>  };
>  
>  /* Real-Time classes' related field in a runqueue: */
> @@ -403,6 +407,10 @@ struct rt_rq {
>         struct list_head leaf_rt_rq_list;
>         struct task_group *tg;
>  #endif
> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
> +       u64 saved_irq_time;
> +#endif
> +
>  };
>  
>  #ifdef CONFIG_SMP

Why do we care about irq_time for groups like this?

> @@ -532,6 +540,10 @@ struct rq {
>         struct hrtimer hrtick_timer;
>  #endif
>  
> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
> +       u64 total_irq_time;
> +#endif
> +
>  #ifdef CONFIG_SCHEDSTATS
>         /* latency stats */
>         struct sched_info rq_sched_info;

Why do we track that here, we've got that information in the percpu
variables already, right?

> @@ -643,10 +655,14 @@ static inline struct task_group *task_group(struct task_struct *p)
>  
>  #endif /* CONFIG_CGROUP_SCHED */
>  
> +static void save_rq_irq_time(int cpu, struct rq *rq);
> +
>  inline void update_rq_clock(struct rq *rq)
>  {
> -       if (!rq->skip_clock_update)
> +       if (!rq->skip_clock_update) {
>                 rq->clock = sched_clock_cpu(cpu_of(rq));
> +               save_rq_irq_time(cpu_of(rq), rq);
> +       }
>  }
>  
>  /*

Something like: rq->clock_task = rq->clock - irq_time(cpu_of(rq)), would
make more sense -- that way the virt people can add a steal-time factor
and all would just work out for them too.

> @@ -1919,6 +1935,17 @@ static void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
>  
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
>  
> +/*
> + * There are no locks covering percpu hardirq/softirq time.
> + * They are only modified in account_system_vtime, on corresponding CPU
> + * with interrupts disabled. So, writes are safe.
> + * They are read and saved off onto rq->total_irq_time in update_rq_clock().
> + * This may result in other CPU reading this CPU's irq time and can
> + * race with irq/account_system_vtime on this CPU. We would either get old
> + * or new value with a side effect of accounting a slice of irq time to wrong
> + * task when irq is in progress while we read rq->clock. That is a worthy
> + * compromise in place of having locks on each irq in account_system_time.
> + */

Except for 32bit systems, which can read half an updated u64.

>  static DEFINE_PER_CPU(u64, cpu_hardirq_time);
>  static DEFINE_PER_CPU(u64, cpu_softirq_time);
>  
> @@ -1930,6 +1957,13 @@ void enable_sched_clock_irqtime(void)
>         sched_clock_irqtime = 1;
>  }
>  
> +static void save_rq_irq_time(int cpu, struct rq *rq)
> +{
> +       if (sched_clock_irqtime)
> +               rq->total_irq_time = per_cpu(cpu_softirq_time, cpu) +
> +                                       per_cpu(cpu_hardirq_time, cpu);
> +}
> +
>  void account_system_vtime(struct task_struct *tsk)
>  {
>         unsigned long flags;
> @@ -1953,6 +1987,61 @@ void account_system_vtime(struct task_struct *tsk)
>         local_irq_restore(flags);
>  }
>  
> +/*
> + * saved_irq_time in cfs_rq, rt_rq caches the accounted irqtime and
> + * it is updated from update_curr while doing entity accouting and
> + * in update_irq_time while the task is first scheduled in.
> + */
> +static void __update_irq_time(int cpu, u64 *saved_irq_time)
> +{
> +       if (sched_clock_irqtime)
> +               *saved_irq_time = cpu_rq(cpu)->total_irq_time;
> +}
> +
> +#define update_irq_time(cpu, crq) __update_irq_time(cpu, &(crq)->saved_irq_time)
> +
> +static u64 unaccount_irq_delta(u64 delta, int cpu, u64 *saved_irq_time)
> +{
> +       u64 curr_irq_time;
> +
> +       if (!sched_clock_irqtime)
> +               return delta;
> +
> +       curr_irq_time = cpu_rq(cpu)->total_irq_time - *saved_irq_time;
> +       *saved_irq_time = cpu_rq(cpu)->total_irq_time;
> +
> +       if (likely(delta > curr_irq_time))
> +               delta -= curr_irq_time;
> +       else
> +               delta = 0;
> +
> +       return delta;
> +}



> +#define unaccount_irq_delta_fair(delta, cpu, class_rq)          \
> +               (unsigned long)unaccount_irq_delta((u64)delta,   \
> +                                       cpu, &(class_rq)->saved_irq_time)
> +
> +#define unaccount_irq_delta_rt(delta, cpu, class_rq)            \
> +               unaccount_irq_delta(delta, cpu, &(class_rq)->saved_irq_time)

This is a consequence of sticking stuff in {cfs,rt}_rq, which afaikt is
not needed at all.

> +#else
> +
> +#define update_irq_time(cpu, crq)              do { } while (0)
> +
> +static void save_rq_irq_time(int cpu, struct rq *rq) { }
> +
> +static unsigned long unaccount_irq_delta_fair(unsigned long delta_exec,
> +               int cpu, struct cfs_rq *cfs_rq)
> +{
> +       return delta_exec;
> +}
> +
> +static u64 unaccount_irq_delta_rt(u64 delta_exec, int cpu, struct rt_rq *rt_rq)
> +{
> +       return delta_exec;
> +}
> +
>  #endif
>  
>  #include "sched_idletask.c"
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index a171138..a64fdaf 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -521,6 +521,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
>         struct sched_entity *curr = cfs_rq->curr;
>         u64 now = rq_of(cfs_rq)->clock;

  u64 now = rq_of(cfs_rq)->clock_task;

>         unsigned long delta_exec;
> +       int cpu = cpu_of(rq_of(cfs_rq));
>  
>         if (unlikely(!curr))
>                 return;
> @@ -531,11 +532,13 @@ static void update_curr(struct cfs_rq *cfs_rq)
>          * overflow on 32 bits):
>          */
>         delta_exec = (unsigned long)(now - curr->exec_start);
> +       curr->exec_start = now;
> +       delta_exec = unaccount_irq_delta_fair(delta_exec, cpu, cfs_rq);
> +
>         if (!delta_exec)
>                 return;
>  
>         __update_curr(cfs_rq, curr, delta_exec);
> -       curr->exec_start = now;
>  
>         if (entity_is_task(curr)) {
>                 struct task_struct *curtask = task_of(curr);
> @@ -603,6 +606,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
>          * We are starting a new run period:
>          */
>         se->exec_start = rq_of(cfs_rq)->clock;
> +       update_irq_time(cpu_of(rq_of(cfs_rq)), cfs_rq);
>  }
>  
>  /**************************************************

se->exec_start = rq_of(cfs_rq)->clock_task;

And you don't need anything else, hmm?

> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index d10c80e..000d402 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -605,6 +605,7 @@ static void update_curr_rt(struct rq *rq)
>         struct sched_rt_entity *rt_se = &curr->rt;
>         struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
>         u64 delta_exec;
> +       int cpu = cpu_of(rq);
>  
>         if (!task_has_rt_policy(curr))
>                 return;
> @@ -613,6 +614,14 @@ static void update_curr_rt(struct rq *rq)
>         if (unlikely((s64)delta_exec < 0))
>                 delta_exec = 0;
>  
> +       /*
> +        * rt_avg_update before removing irq_delta, to keep up with
> +        * current behavior.
> +        */
> +       sched_rt_avg_update(rq, delta_exec);
> +
> +       delta_exec = unaccount_irq_delta_rt(delta_exec, cpu, rt_rq);
> +
>         schedstat_set(curr->se.statistics.exec_max, max(curr->se.statistics.exec_max, delta_exec));
>  
>         curr->se.sum_exec_runtime += delta_exec;
> @@ -621,8 +630,6 @@ static void update_curr_rt(struct rq *rq)
>         curr->se.exec_start = rq->clock;
>         cpuacct_charge(curr, delta_exec);
>  
> -       sched_rt_avg_update(rq, delta_exec);
> -
>         if (!rt_bandwidth_enabled())
>                 return;

I think it would all greatly simplify if you would compute delta_exec
from rq->clock_task and add IRQ time to sched_rt_avg_update()
separately.
 

