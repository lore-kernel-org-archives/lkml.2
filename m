Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2BMOFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 09:05:42 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56304 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2BMOFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 09:05:40 -0500
MIME-Version: 1.0
In-Reply-To: <CADZ9YHhOfVm7qNj6oznmRCUuyyA4BQfmsd-M7FzrmWB9SxMgzg@mail.gmail.com>
References: <CADZ9YHhOfVm7qNj6oznmRCUuyyA4BQfmsd-M7FzrmWB9SxMgzg@mail.gmail.com>
Date: Mon, 13 Feb 2012 22:05:39 +0800
Message-ID: <CAJd=RBD+x8SHkMPqxRGwmm90wvj2b_2bAdexxo6w39_ngGgHdA@mail.gmail.com>
Subject: Re: [ANNOUNCEMENT] The Barbershop Load Distribution algorithm for
 Linux kernel scheduler.
From: Hillf Danton <dhillf@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rakib

Just nitpicks

On Mon, Feb 13, 2012 at 2:52 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
[...]
> --- /dev/null
> +++ b/kernel/sched/bld.h
> @@ -0,0 +1,112 @@
> +#ifdef CONFIG_BLD
> +
> +static DEFINE_RWLOCK(disp_list_lock);

What is the advantage of rwlock, compared with spin lock?

> +static LIST_HEAD(rq_head);
> +
> +static inline int list_is_first(const struct list_head *list,

Where is this helper used?

> +                               const struct list_head *head)
> +{
> +       return list == head->next;
> +}
> +
> +static inline int select_cpu_for_wakeup(struct task_struct *p, int
> sd_flags, int wake_flags)

Looks @sd_flags not used. Why is the arch specifics negligible?
Also looks message corrupted due to mail agent?

> +{
> +       int cpu = smp_processor_id(), prev_cpu = task_cpu(p), i;

            int this_cpu = smp_processor_id();
            int prev_cpu = task_cpu(p);
            int cpu;

> +       /*bool sync = wake_flags & WF_SYNC; */
> +       unsigned long load, min_load = ULONG_MAX;
> +       struct cpumask *mask;
> +
> +       if (wake_flags & WF_SYNC) {
> +               if (cpu == prev_cpu)
> +                       return cpu;
> +               mask = sched_group_cpus(cpu_rq(prev_cpu)->sd->groups);
> +       } else
> +               mask = sched_domain_span(cpu_rq(prev_cpu)->sd);
> +
> +       for_each_cpu(i, mask) {
> +               load = cpu_rq(i)->load.weight;
> +               if (load < min_load) {
> +                       min_load = load;
> +                       cpu = i;
> +               }
> +       }
> +       return cpu;
> +}
> +
> +static int bld_select_task_rq(struct task_struct *p, int sd_flags,
> int wake_flags)

Message corrupted?

> +{
> +       struct rq *tmp;
> +       unsigned long flag;
> +       unsigned int cpu = smp_processor_id();
> +
> +       if (&p->cpus_allowed) {
> +               struct cpumask *taskmask;
> +               unsigned long min_load = ULONG_MAX, load, i;
> +               taskmask = tsk_cpus_allowed(p);
> +               for_each_cpu(i, taskmask) {
> +                       load = cpu_rq(i)->load.weight;
> +                       if (load < min_load) {
> +                               min_load = load;
> +                               cpu = i;
> +                       }
> +               }
> +       } else  if (sd_flags & SD_BALANCE_WAKE) {
> +               cpu = select_cpu_for_wakeup(p, sd_flags, wake_flags);
> +               return cpu;
> +       } else {
> +               read_lock_irqsave(&disp_list_lock, flag);
> +               list_for_each_entry(tmp, &rq_head, disp_load_balance) {
> +                       cpu = cpu_of(tmp);
> +                       if (cpu_online(cpu))
> +                               break;
> +               }
> +               read_unlock_irqrestore(&disp_list_lock, flag);
> +       }
> +       return cpu;
> +}
> +
> +static void bld_track_load_activate(struct rq *rq)
> +{
> +       unsigned long  flag;
> +       rq->this_cpu_load = rq->load.weight;

Well ->this_cpu_load looks unnecessary?

> +
> +       if (rq->pos != 2) {     /* if rq isn't the last one */
> +               struct rq *last;
> +               write_lock_irqsave(&disp_list_lock, flag);

                    if (rq->pos != 2)
                             goto out;

> +               last = list_entry(rq_head.prev, struct rq, disp_load_balance);

Could disp_list_lock serialize updating this_cpu_load?

> +               if (rq->this_cpu_load > last->this_cpu_load) {
> +                       list_del(&rq->disp_load_balance);
> +                       list_add_tail(&rq->disp_load_balance, &rq_head);
> +                       rq->pos = 2; last->pos = 1;
> +               }

out:

> +               write_unlock_irqrestore(&disp_list_lock, flag);
> +       }
> +}
> +
> +static void bld_track_load_deactivate(struct rq *rq)
> +{
> +       unsigned long flag;
> +
> +       rq->this_cpu_load = rq->load.weight;
> +
> +       if (rq->pos != 0) { /* If rq isn't first one */
> +               struct rq *first;
> +               first = list_entry(rq_head.prev, struct rq, disp_load_balance);
> +               write_lock_irqsave(&disp_list_lock, flag);
> +               if (rq->this_cpu_load <= first->this_cpu_load) {
> +                       list_del(&rq->disp_load_balance);
> +                       list_add_tail(&rq->disp_load_balance, &rq_head);
> +                       rq->pos = 0; first->pos = 1;
> +               }
> +               write_unlock_irqrestore(&disp_list_lock, flag);
> +       }
> +}
> +#else
> +static inline void bld_track_load_activate(struct rq *rq)
> +{
> +}
> +
> +static inline void bld_track_load_deactivate(struct rq *rq)
> +{
> +}
> +#endif /* CONFIG_BLD */
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5255c9d..cff20e1 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -24,6 +24,8 @@
>  *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
>  *  2007-11-29  RT balancing improvements by Steven Rostedt, Gregory Haskins,
>  *              Thomas Gleixner, Mike Kravetz
> + *  2012-Feb   The Barbershop Load Distribution (BLD) algorithm, an alternate
> + *             load distribution algorithm by Rakib Mullick.
>  */
>
>  #include <linux/mm.h>
> @@ -81,6 +83,7 @@
>
>  #include "sched.h"
>  #include "../workqueue_sched.h"
> +#include "bld.h"
>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/sched.h>
> @@ -578,6 +581,7 @@ unlock:
>  */
>  void wake_up_idle_cpu(int cpu)
>  {
> +#ifndef CONFIG_BLD
>        struct rq *rq = cpu_rq(cpu);
>
>        if (cpu == smp_processor_id())
> @@ -604,6 +608,7 @@ void wake_up_idle_cpu(int cpu)
>        smp_mb();
>        if (!tsk_is_polling(rq->idle))
>                smp_send_reschedule(cpu);
> +#endif
>  }
>
>  static inline bool got_nohz_idle_kick(void)
> @@ -730,6 +735,7 @@ void activate_task(struct rq *rq, struct
> task_struct *p, int flags)
>                rq->nr_uninterruptible--;
>
>        enqueue_task(rq, p, flags);
> +       bld_track_load_activate(rq);

Looks better if sorting rq folded in enqueue_task()?

>  }
>
>  void deactivate_task(struct rq *rq, struct task_struct *p, int flags)
> @@ -738,6 +744,7 @@ void deactivate_task(struct rq *rq, struct
> task_struct *p, int flags)
>                rq->nr_uninterruptible++;
>
>        dequeue_task(rq, p, flags);
> +       bld_track_load_deactivate(rq);
>  }
>
>  #ifdef CONFIG_IRQ_TIME_ACCOUNTING
> @@ -1297,7 +1304,12 @@ static int select_fallback_rq(int cpu, struct
> task_struct *p)
>  static inline
>  int select_task_rq(struct task_struct *p, int sd_flags, int wake_flags)
>  {
> -       int cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
> +       int cpu;
> +#ifdef CONFIG_BLD
> +       cpu = bld_select_task_rq(p, sd_flags, wake_flags);

What if @p is RT?

> +#else
> +       cpu = p->sched_class->select_task_rq(p, sd_flags, wake_flags);
> +#endif
>
>        /*
>         * In order not to call set_task_cpu() on a blocking task we need
> @@ -1453,7 +1465,11 @@ static void sched_ttwu_pending(void)
>
>  void scheduler_ipi(void)
>  {
> +#ifndef CONFIG_BLD
>        if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
> +#else
> +       if (llist_empty(&this_rq()->wake_list))
> +#endif
>                return;
>
>        /*
> @@ -1475,10 +1491,12 @@ void scheduler_ipi(void)
>        /*
>         * Check if someone kicked us for doing the nohz idle load balance.
>         */
> +#ifndef CONFIG_BLD
>        if (unlikely(got_nohz_idle_kick() && !need_resched())) {
>                this_rq()->idle_balance = 1;
>                raise_softirq_irqoff(SCHED_SOFTIRQ);
>        }
> +#endif
>        irq_exit();
>  }
>
> @@ -1518,12 +1536,14 @@ static void ttwu_queue(struct task_struct *p, int cpu)
>        struct rq *rq = cpu_rq(cpu);
>
>  #if defined(CONFIG_SMP)
> +#ifndef CONFIG_BLD
>        if (sched_feat(TTWU_QUEUE) && !ttwu_share_cache(smp_processor_id(), cpu)) {
>                sched_clock_cpu(cpu); /* sync clocks x-cpu */
>                ttwu_queue_remote(p, cpu);
>                return;
>        }
>  #endif
> +#endif
>
>        raw_spin_lock(&rq->lock);
>        ttwu_do_activate(rq, p, 0);
> @@ -2269,6 +2289,7 @@ calc_load_n(unsigned long load, unsigned long exp,
>  */
>  static void calc_global_nohz(unsigned long ticks)
>  {
> +#ifndef CONFIG_BLD
>        long delta, active, n;
>
>        if (time_before(jiffies, calc_load_update))
> @@ -2310,6 +2331,7 @@ static void calc_global_nohz(unsigned long ticks)
>         * age us 4 cycles, and the test in calc_global_load() will
>         * pick up the final one.
>         */
> +#endif
>  }
>  #else
>  void calc_load_account_idle(struct rq *this_rq)
> @@ -3003,8 +3025,10 @@ void scheduler_tick(void)
>
>  #ifdef CONFIG_SMP
>        rq->idle_balance = idle_cpu(cpu);
> +#ifndef CONFIG_BLD
>        trigger_load_balance(rq, cpu);
>  #endif
> +#endif
>  }
>
>  notrace unsigned long get_parent_ip(unsigned long addr)
> @@ -3194,8 +3218,10 @@ need_resched:
>
>        pre_schedule(rq, prev);
>
> +#ifndef CONFIG_BLD
>        if (unlikely(!rq->nr_running))
>                idle_balance(cpu, rq);
> +#endif
>
>        put_prev_task(rq, prev);
>        next = pick_next_task(rq);
> @@ -6938,6 +6964,11 @@ void __init sched_init(void)
>  #endif
>                init_rq_hrtick(rq);
>                atomic_set(&rq->nr_iowait, 0);
> +#ifdef CONFIG_BLD
> +               INIT_LIST_HEAD(&rq->disp_load_balance);
> +               list_add_tail(&rq->disp_load_balance, &rq_head);
> +               rq->pos = 0;
> +#endif
>        }
>
>        set_load_weight(&init_task);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7c6414f..f2624ce 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5609,7 +5609,9 @@ void print_cfs_stats(struct seq_file *m, int cpu)
>  __init void init_sched_fair_class(void)
>  {
>  #ifdef CONFIG_SMP
> +#ifndef CONFIG_BLD
>        open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
> +#endif /* BLD */
>
>  #ifdef CONFIG_NO_HZ
>        zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 98c0c26..bd7e4c6 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -474,6 +474,17 @@ struct rq {
>  #ifdef CONFIG_SMP
>        struct llist_head wake_list;
>  #endif
> +#ifdef CONFIG_BLD
> +       unsigned long this_cpu_load;
> +       struct list_head disp_load_balance;
> +       /* It indicates whether, rq is first or last
> +        * or in the middle based on load from rq_head.
> +        * 0 - First rq
> +        * 1 - rq stays middle
> +        * 2 - last rq
> +        */
> +       char pos;
> +#endif
>  };
>
>  static inline int cpu_of(struct rq *rq)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
