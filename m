Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946084Ab2ERNyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:54:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35741 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761163Ab2ERNyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBBu8G12NP6d-Q7NCEsU0RN0JVf41pUKqEa3JzOPgtfF4A@mail.gmail.com>
References: <CAJd=RBBu8G12NP6d-Q7NCEsU0RN0JVf41pUKqEa3JzOPgtfF4A@mail.gmail.com>
Date: Fri, 18 May 2012 21:54:12 +0800
Message-ID: <CAJd=RBCYghZkaGwXL2633_tELnNRhhgAcJe_9Q-q8xkEwjFJ-w@mail.gmail.com>
Subject: Re: BFS 420: fix ttwu stat
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 9:20 PM, Hillf Danton <dhillf@gmail.com> wrote:
> Due to monolithic runqueue used by BFS, the ttwu stat is bogus as we could not
> tell/predict on which CPU a woken task will run after it is activated. And we
> have to delay updating ttwu stat until the stage when task is taken off run
> queue. To achieve that, a field, wakeup_cpu, is added in the task struct, and is
> inited to be invalid CPU number for each new task.
>
> When updating ttwu stat, now it is simply to mark the delayed operation; and
> when taking task off runqueue, the stat is updated.
>
>
> --- a/include/linux/sched.h     Fri May 18 20:51:06 2012
> +++ b/include/linux/sched.h     Fri May 18 20:32:20 2012
> @@ -1255,6 +1255,11 @@ struct task_struct {
>        struct list_head run_list;
>        u64 last_ran;
>        u64 sched_time; /* sched_clock time spent running */
> +#ifdef CONFIG_SCHEDSTATS
> +#ifdef CONFIG_SMP
> +       int wakeup_cpu; //for ttwu stat
> +#endif
> +#endif
>  #ifdef CONFIG_SMP
>        bool sticky; /* Soft affined flag */
>  #endif
> --- a/kernel/sched/bfs.c        Mon May 14 20:50:38 2012
> +++ b/kernel/sched/bfs.c        Fri May 18 20:46:22 2012
> @@ -1145,6 +1145,30 @@ static inline void unstick_task(struct r
>  */
>  static inline void take_task(int cpu, struct task_struct *p)
>  {
> +#ifdef CONFIG_SCHEDSTATS
> +#ifdef CONFIG_SMP
> +       if (p->wakeup_cpu == -1)
> +               goto skip;
> +
> +       if (cpu == p->wakeup_cpu) {
> +               schedstat_inc(cpu_rq(cpu), ttwu_local);
> +       }
> +       else if (cpu_online(p->wakeup_cpu)) {
> +               struct sched_domain *sd;
> +
> +               rcu_read_lock();
> +               for_each_domain(p->wakeup_cpu, sd) {
> +                       if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
> +                               schedstat_inc(sd, ttwu_wake_remote);
> +                               break;
> +                       }
> +               }
> +               rcu_read_unlock();
> +       }
> +       p->wakeup_cpu = -1;
> +skip:
> +#endif
> +#endif
>        set_task_cpu(p, cpu);
>        dequeue_task(p);
>        clear_sticky(p);
> @@ -1485,30 +1509,13 @@ static void try_preempt(struct task_stru
>  }
>  #endif /* CONFIG_SMP */
>
> -static void
> -ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
> +static void ttwu_stat(struct task_struct *p, int cpu, int wake_flags)
>  {
>  #ifdef CONFIG_SCHEDSTATS
>        struct rq *rq = this_rq();
>
>  #ifdef CONFIG_SMP
> -       int this_cpu = smp_processor_id();
> -
> -       if (cpu == this_cpu)
> -               schedstat_inc(rq, ttwu_local);
> -       else {
> -               struct sched_domain *sd;
> -
> -               rcu_read_lock();
> -               for_each_domain(this_cpu, sd) {
> -                       if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
> -                               schedstat_inc(sd, ttwu_wake_remote);
> -                               break;
> -                       }
> -               }
> -               rcu_read_unlock();
> -       }
> -
> +       p->wakeup_cpu = smp_processor_id();
>  #endif /* CONFIG_SMP */
>
>        schedstat_inc(rq, ttwu_count);
> @@ -1717,6 +1724,12 @@ void sched_fork(struct task_struct *p)
>  #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
>        if (unlikely(sched_info_on()))
>                memset(&p->sched_info, 0, sizeof(p->sched_info));
> +#endif
> +
> +#ifdef CONFIG_SCHEDSTATS
> +#ifdef CONFIG_SMP
> +       p->wakeup_cpu = -1;
> +#endif
>  #endif
>
>        p->on_cpu = false;
> --
