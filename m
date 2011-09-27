Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab1I0RBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:01:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51294 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab1I0RBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:01:44 -0400
MIME-Version: 1.0
In-Reply-To: <1316816432-9237-4-git-send-email-glommer@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	<1316816432-9237-4-git-send-email-glommer@parallels.com>
Date: Tue, 27 Sep 2011 22:31:42 +0530
Message-ID: <CAKTCnz=5wLq2OAKLfCOh5bX+t2T1exhhCdHUMkQchPzHNyU5Hw@mail.gmail.com>
Subject: Re: [RFD 3/9] Display /proc/stat information per cgroup
From: Balbir Singh <bsingharora@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, a.p.zijlstra@chello.nl,
        jbottomley@parallels.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 3:50 AM, Glauber Costa <glommer@parallels.com> wrote:
> Each cgroup has its own file, cpu.proc.stat that will
> display the exact same format as /proc/stat. Users
> that want to have access to a per-cgroup version of
> this information, can query it for that purpose.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
...

> +static inline void task_cgroup_account_field(struct task_struct *p,
> +                                            cputime64_t tmp, int index)
> +{
> +       struct kernel_stat *kstat;
> +       struct task_group *tg = task_group(p);
> +
> +       do {
> +               kstat = this_cpu_ptr(tg->cpustat);
> +               kstat->cpustat[index] = cputime64_add(kstat->cpustat[index],
> +                                                     tmp);
> +               tg = tg->parent;
> +       } while (tg);
> +}

What protects the walk (tg = tg->parent)? Could you please document it

> +
>  /*
>  * Account user cpu time to a process.
>  * @p: the process that the cpu time gets accounted to
> @@ -3763,9 +3777,8 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
>  * @cputime_scaled: cputime scaled by cpu frequency
>  */
>  void account_user_time(struct task_struct *p, cputime_t cputime,
> -                      cputime_t cputime_scaled)
> +               cputime_t cputime_scaled)
>  {
> -       cputime64_t *cpustat = kstat_this_cpu->cpustat;
>        cputime64_t tmp;
>
>        /* Add user time to process. */
> @@ -3775,10 +3788,11 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
>
>        /* Add user time to cpustat. */
>        tmp = cputime_to_cputime64(cputime);
> +
>        if (TASK_NICE(p) > 0)
> -               cpustat[NICE] = cputime64_add(cpustat[NICE], tmp);
> +               task_cgroup_account_field(p, tmp, NICE);
>        else
> -               cpustat[USER] = cputime64_add(cpustat[USER], tmp);
> +               task_cgroup_account_field(p, tmp, USER);
>
>        cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
>        /* Account for user time used */
> @@ -3824,7 +3838,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
>  */
>  static inline
>  void __account_system_time(struct task_struct *p, cputime_t cputime,
> -                       cputime_t cputime_scaled, cputime64_t *target_cputime64)
> +                       cputime_t cputime_scaled, int index)
>  {
>        cputime64_t tmp = cputime_to_cputime64(cputime);
>
> @@ -3834,7 +3848,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
>        account_group_system_time(p, cputime);
>
>        /* Add system time to cpustat. */
> -       *target_cputime64 = cputime64_add(*target_cputime64, tmp);
> +       task_cgroup_account_field(p, tmp, index);
>        cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
>
>        /* Account for system time used */
> @@ -3851,8 +3865,7 @@ void __account_system_time(struct task_struct *p, cputime_t cputime,
>  void account_system_time(struct task_struct *p, int hardirq_offset,
>                         cputime_t cputime, cputime_t cputime_scaled)
>  {
> -       cputime64_t *cpustat = kstat_this_cpu->cpustat;
> -       cputime64_t *target_cputime64;
> +       int index;
>
>        if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
>                account_guest_time(p, cputime, cputime_scaled);
> @@ -3860,13 +3873,13 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
>        }
>
>        if (hardirq_count() - hardirq_offset)
> -               target_cputime64 = &cpustat[IRQ];
> +               index = IRQ;
>        else if (in_serving_softirq())
> -               target_cputime64 = &cpustat[SOFTIRQ];
> +               index = SOFTIRQ;
>        else
> -               target_cputime64 = &cpustat[SYSTEM];
> +               index = SYSTEM;
>
> -       __account_system_time(p, cputime, cputime_scaled, target_cputime64);
> +       __account_system_time(p, cputime, cputime_scaled, index);
>  }
>
>  /*
> @@ -3941,27 +3954,29 @@ static __always_inline bool steal_account_process_tick(void)
>  * softirq as those do not count in task exec_runtime any more.
>  */
>  static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
> -                                               struct rq *rq)
> +                                        struct rq *rq)
>  {
>        cputime_t one_jiffy_scaled = cputime_to_scaled(cputime_one_jiffy);
>        cputime64_t tmp = cputime_to_cputime64(cputime_one_jiffy);
> -       cputime64_t *cpustat = kstat_this_cpu->cpustat;
> +       struct task_group *tg;
>
>        if (steal_account_process_tick())
>                return;
>
> +       tg = task_group(p);
> +
>        if (irqtime_account_hi_update()) {
> -               cpustat[IRQ] = cputime64_add(cpustat[IRQ], tmp);
> +               task_cgroup_account_field(p, tmp, IRQ);
>        } else if (irqtime_account_si_update()) {
> -               cpustat[SOFTIRQ] = cputime64_add(cpustat[SOFTIRQ], tmp);
> +               task_cgroup_account_field(p, tmp, SOFTIRQ);
>        } else if (this_cpu_ksoftirqd() == p) {
>                /*
>                 * ksoftirqd time do not get accounted in cpu_softirq_time.
>                 * So, we have to handle it separately here.
>                 * Also, p->stime needs to be updated for ksoftirqd.
>                 */
> -               __account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
> -                                       &cpustat[SOFTIRQ]);
> +               __account_system_time(p, cputime_one_jiffy,
> +                                     one_jiffy_scaled, SOFTIRQ);
>        } else if (user_tick) {
>                account_user_time(p, cputime_one_jiffy, one_jiffy_scaled);
>        } else if (p == rq->idle) {
> @@ -3969,8 +3984,8 @@ static void irqtime_account_process_tick(struct task_struct *p, int user_tick,
>        } else if (p->flags & PF_VCPU) { /* System time or guest time */
>                account_guest_time(p, cputime_one_jiffy, one_jiffy_scaled);
>        } else {
> -               __account_system_time(p, cputime_one_jiffy, one_jiffy_scaled,
> -                                       &cpustat[SYSTEM]);
> +               __account_system_time(p, cputime_one_jiffy,
> +                                     one_jiffy_scaled, SYSTEM);
>        }
>  }
>
> @@ -8038,6 +8053,7 @@ void __init sched_init(void)
>  {
>        int i, j;
>        unsigned long alloc_size = 0, ptr;
> +       struct kernel_stat *kstat;
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>        alloc_size += 2 * nr_cpu_ids * sizeof(void **);
> @@ -8092,6 +8108,18 @@ void __init sched_init(void)
>        INIT_LIST_HEAD(&root_task_group.children);
>        INIT_LIST_HEAD(&root_task_group.siblings);
>        autogroup_init(&init_task);
> +
> +       root_task_group.cpustat = alloc_percpu(struct kernel_stat);
> +       /* Failing that early an allocation means we're screwed anyway */
> +       BUG_ON(!root_task_group.cpustat);
> +       for_each_possible_cpu(i) {

for_each_possible_cpu might be an overkill, no?

> +               kstat = per_cpu_ptr(root_task_group.cpustat, i);
> +               kstat->cpustat[IDLE] = 0;
> +               kstat->cpustat[IDLE_BASE] = 0;
> +               kstat->cpustat[IOWAIT_BASE] = 0;
> +               kstat->cpustat[IOWAIT] = 0;
> +       }
> +
>  #endif /* CONFIG_CGROUP_SCHED */
>
>        for_each_possible_cpu(i) {
> @@ -8526,6 +8554,7 @@ static void free_sched_group(struct task_group *tg)
>        free_fair_sched_group(tg);
>        free_rt_sched_group(tg);
>        autogroup_free(tg);
> +       free_percpu(tg->cpustat);
>        kfree(tg);
>  }
>
> @@ -8534,6 +8563,7 @@ struct task_group *sched_create_group(struct task_group *parent)
>  {
>        struct task_group *tg;
>        unsigned long flags;
> +       int i;
>
>        tg = kzalloc(sizeof(*tg), GFP_KERNEL);
>        if (!tg)
> @@ -8545,6 +8575,19 @@ struct task_group *sched_create_group(struct task_group *parent)
>        if (!alloc_rt_sched_group(tg, parent))
>                goto err;
>
> +       tg->cpustat = alloc_percpu(struct kernel_stat);
> +       if (!tg->cpustat)
> +               goto err;
> +
> +       for_each_possible_cpu(i) {
> +               struct kernel_stat *kstat, *root_kstat;
> +
> +               kstat = per_cpu_ptr(tg->cpustat, i);
> +               root_kstat = per_cpu_ptr(root_task_group.cpustat, i);
> +               kstat->cpustat[IDLE_BASE]  = root_kstat->cpustat[IDLE];
> +               kstat->cpustat[IOWAIT_BASE] = root_kstat->cpustat[IOWAIT];
> +       }
> +
>        spin_lock_irqsave(&task_group_lock, flags);
>        list_add_rcu(&tg->list, &task_groups);
>
> @@ -9092,7 +9135,9 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
>                system = cputime64_add(system, kstat->cpustat[SYSTEM]);
>                idle = cputime64_add(idle, root_kstat->cpustat[IDLE]);
>                idle = cputime64_add(idle, arch_idle_time(i));
> +               idle = cputime64_sub(idle, kstat->cpustat[IDLE_BASE]);
>                iowait = cputime64_add(iowait, root_kstat->cpustat[IOWAIT]);
> +               iowait = cputime64_sub(iowait, kstat->cpustat[IOWAIT_BASE]);
>                irq = cputime64_add(irq, kstat->cpustat[IRQ]);
>                softirq = cputime64_add(softirq, kstat->cpustat[SOFTIRQ]);
>                steal = cputime64_add(steal, kstat->cpustat[STEAL]);
> @@ -9134,7 +9179,9 @@ int cpu_cgroup_proc_stat(struct cgroup *cgrp, struct cftype *cft, struct seq_fil
>                system = kstat->cpustat[SYSTEM];
>                idle = root_kstat->cpustat[IDLE];
>                idle = cputime64_add(idle, arch_idle_time(i));
> +               idle = cputime64_sub(idle, kstat->cpustat[IDLE_BASE]);
>                iowait = root_kstat->cpustat[IOWAIT];
> +               iowait = cputime64_sub(iowait, kstat->cpustat[IOWAIT_BASE]);
>                irq = kstat->cpustat[IRQ];
>                softirq = kstat->cpustat[SOFTIRQ];
>                steal = kstat->cpustat[STEAL];
> @@ -9205,6 +9252,10 @@ static struct cftype cpu_files[] = {
>                .write_u64 = cpu_rt_period_write_uint,
>        },
>  #endif
> +       {
> +               .name = "proc.stat",
> +               .read_seq_string = cpu_cgroup_proc_stat,

Looks fine to me

Balbir Singh
