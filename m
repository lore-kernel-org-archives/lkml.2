Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab2J0MBh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:01:37 -0400
Received: from forward4.mail.yandex.net ([77.88.46.9]:34356 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2J0MBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:01:35 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1256291351334215@web9f.yandex.ru>
References: <1256291351334215@web9f.yandex.ru>
Subject: Re: [PATCH][sched] Ignore RT throttling if rq->rt tasks are the only running tasks in the rq
MIME-Version: 1.0
Message-Id: <1309341351339290@web20d.yandex.ru>
Date: Sat, 27 Oct 2012 16:01:30 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I need a little rework of this patch. I'll send it later.

Sorry for the noise.

Kirill

27.10.2012, 14:36, "Kirill Tkhai" <tkhai@yandex.ru>:
> The current throttling logic always skips RT class if rq->rt is throttled.
> It doesn't handle the special case when RT tasks are the only running tasks
> in the rq. So it's possible CPU picks idle task up when RTs are available.
>
> This patch aims to avoid the above situation. The modified
> _pick_next_task_rt() looks at the number of total rq->rt tasks(with the sum
> of all child rt_rq's) and compares it with the number of all running tasks
> of the rq. If they are equal then scheduler picks the highest rq->rt task
> (children are considered too).
>
> Later, the first unthrottled rq_rt will replace this task. The case
> of appearance of fair task is handled in check_preempt_curr() function.
>
> The patch changes the logic of pick_rt_task() and pick_next_highest_task_rt().
> Now the negative cpu always makes task "picked". But there are no another
> users of this posibility and nobody is touched by this change.
>
> Signed-off-by: Kirill V Tkhai <tkhai@yandex.ru>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
>
> ---
> škernel/sched/core.c š| ššš6 +++-
> škernel/sched/rt.c ššš| šš97 ++++++++++++++++++++++++++++++++------------------
> škernel/sched/sched.h | ššš3 +-
> š3 files changed, 69 insertions(+), 37 deletions(-)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index bf41f82..ecc9833 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -901,7 +901,9 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
> š{
> šššššššššconst struct sched_class *class;
>
> - if (p->sched_class == rq->curr->sched_class) {
> + if (rq->curr->sched_class == rq->extended_class) {
> + resched_task(rq->curr);
> + } else if (p->sched_class == rq->curr->sched_class) {
> šššššššššššššššššrq->curr->sched_class->check_preempt_curr(rq, p, flags);
> ššššššššš} else {
> šššššššššššššššššfor_each_class(class) {
> @@ -2771,6 +2773,7 @@ static void put_prev_task(struct rq *rq, struct task_struct *prev)
> šššššššššif (prev->on_rq || rq->skip_clock_update < 0)
> šššššššššššššššššupdate_rq_clock(rq);
> šššššššššprev->sched_class->put_prev_task(rq, prev);
> + rq->extended_class = NULL;
> š}
>
> š/*
> @@ -6892,6 +6895,7 @@ void __init sched_init(void)
> šššššššššššššššššrq->calc_load_update = jiffies + LOAD_FREQ;
> šššššššššššššššššinit_cfs_rq(&rq->cfs);
> šššššššššššššššššinit_rt_rq(&rq->rt, rq);
> + rq->extended_class = NULL;
> š#ifdef CONFIG_FAIR_GROUP_SCHED
> šššššššššššššššššroot_task_group.shares = ROOT_TASK_GROUP_LOAD;
> šššššššššššššššššINIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 418feb0..6f6da20 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -274,15 +274,8 @@ static void update_rt_migration(struct rt_rq *rt_rq)
>
> šstatic void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> š{
> - struct task_struct *p;
> -
> - if (!rt_entity_is_task(rt_se))
> - return;
> -
> - p = rt_task_of(rt_se);
> - rt_rq = &rq_of_rt_rq(rt_rq)->rt;
> + struct task_struct *p = rt_task_of(rt_se);
>
> - rt_rq->rt_nr_total++;
> šššššššššif (p->nr_cpus_allowed > 1)
> šššššššššššššššššrt_rq->rt_nr_migratory++;
>
> @@ -291,15 +284,8 @@ static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>
> šstatic void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> š{
> - struct task_struct *p;
> -
> - if (!rt_entity_is_task(rt_se))
> - return;
> -
> - p = rt_task_of(rt_se);
> - rt_rq = &rq_of_rt_rq(rt_rq)->rt;
> + struct task_struct *p = rt_task_of(rt_se);
>
> - rt_rq->rt_nr_total--;
> šššššššššif (p->nr_cpus_allowed > 1)
> šššššššššššššššššrt_rq->rt_nr_migratory--;
>
> @@ -467,6 +453,16 @@ static int rt_se_boosted(struct sched_rt_entity *rt_se)
> šššššššššreturn p->prio != p->normal_prio;
> š}
>
> +static void extended_rt_unthrottles(struct rq *rq, struct rt_rq *rt_rq)
> +{
> + struct task_struct *curr = rq->curr;
> +
> + if (rt_rq_of_se(&curr->rt) == rt_rq)
> + rq->extended_class = NULL;
> + else
> + resched_task(curr);
> +}
> +
> š#ifdef CONFIG_SMP
> šstatic inline const struct cpumask *sched_rt_period_mask(void)
> š{
> @@ -826,6 +822,9 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
> šššššššššššššššššššššššššššššššššš*/
> šššššššššššššššššššššššššššššššššif (rt_rq->rt_nr_running && rq->curr == rq->idle)
> šššššššššššššššššššššššššššššššššššššššššrq->skip_clock_update = -1;
> +
> + if (rq->extended_class == &rt_sched_class)
> + extended_rt_unthrottles(rq, rt_rq);
> ššššššššššššššššššššššššš}
> šššššššššššššššššššššššššif (rt_rq->rt_time || rt_rq->rt_nr_running)
> šššššššššššššššššššššššššššššššššidle = 0;
> @@ -1071,8 +1070,14 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> šššššššššWARN_ON(!rt_prio(prio));
> šššššššššrt_rq->rt_nr_running++;
>
> + if (rt_entity_is_task(rt_se)) {
> + struct rt_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
> +
> + rt->rt_nr_total++;
> + inc_rt_migration(rt_se, rt);
> + }
> +
> šššššššššinc_rt_prio(rt_rq, prio);
> - inc_rt_migration(rt_se, rt_rq);
> šššššššššinc_rt_group(rt_se, rt_rq);
> š}
>
> @@ -1083,8 +1088,15 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> šššššššššWARN_ON(!rt_rq->rt_nr_running);
> šššššššššrt_rq->rt_nr_running--;
>
> + if (rt_entity_is_task(rt_se)) {
> + struct rt_rq *rt = &rq_of_rt_rq(rt_rq)->rt;
> +
> + WARN_ON(!rt->rt_nr_total);
> + rt->rt_nr_total--;
> + dec_rt_migration(rt_se, rt);
> + }
> +
> šššššššššdec_rt_prio(rt_rq, rt_se_prio(rt_se));
> - dec_rt_migration(rt_se, rt_rq);
> šššššššššdec_rt_group(rt_se, rt_rq);
> š}
>
> @@ -1362,28 +1374,41 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
> šššššššššreturn next;
> š}
>
> +static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
> +
> šstatic struct task_struct *_pick_next_task_rt(struct rq *rq)
> š{
> - struct sched_rt_entity *rt_se;
> - struct task_struct *p;
> šššššššššstruct rt_rq *rt_rq;
> + struct task_struct *p;
> + int running, rt_total;
>
> šššššššššrt_rq = &rq->rt;
> + running = rt_rq->rt_nr_running;
>
> - if (!rt_rq->rt_nr_running)
> - return NULL;
> + /* If rq->rt is suitable to get tasks */
> + if (running && !rt_rq_throttled(rt_rq)) {
> + struct sched_rt_entity *rt_se;
>
> - if (rt_rq_throttled(rt_rq))
> + do {
> + rt_se = pick_next_rt_entity(rq, rt_rq);
> + BUG_ON(!rt_se);
> + rt_rq = group_rt_rq(rt_se);
> + } while (rt_rq);
> +
> + return rt_task_of(rt_se);
> + }
> +
> + rt_total = rt_rq->rt_nr_total;
> +
> + /* If rq has no-RT tasks OR rt_rq and its children are empty */
> + if (rt_total != rq->nr_running || !rt_total)
> šššššššššššššššššreturn NULL;
>
> - do {
> - rt_se = pick_next_rt_entity(rq, rt_rq);
> - BUG_ON(!rt_se);
> - rt_rq = group_rt_rq(rt_se);
> - } while (rt_rq);
> + /* All running tasks are RT. Let's avoid idle wasting CPU time */
> + p = pick_next_highest_task_rt(rq, -1);
> + rq->extended_class = &rt_sched_class;
>
> - p = rt_task_of(rt_se);
> - p->se.exec_start = rq->clock_task;
> + WARN_ON(!p || rq->cfs.h_nr_running);
>
> šššššššššreturn p;
> š}
> @@ -1392,9 +1417,11 @@ static struct task_struct *pick_next_task_rt(struct rq *rq)
> š{
> šššššššššstruct task_struct *p = _pick_next_task_rt(rq);
>
> - /* The running task is never eligible for pushing */
> - if (p)
> + if (p) {
> + /* The running task is never eligible for pushing */
> šššššššššššššššššdequeue_pushable_task(rq, p);
> + p->se.exec_start = rq->clock_task;
> + }
>
> š#ifdef CONFIG_SMP
> ššššššššš/*
> @@ -1426,9 +1453,9 @@ static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
>
> šstatic int pick_rt_task(struct rq *rq, struct task_struct *p, int cpu)
> š{
> - if (!task_running(rq, p) &&
> - ššš(cpu < 0 || cpumask_test_cpu(cpu, tsk_cpus_allowed(p))) &&
> - ššš(p->nr_cpus_allowed > 1))
> + if (cpu < 0 || (!task_running(rq, p)
> + && (cpumask_test_cpu(cpu, tsk_cpus_allowed(p))
> + && p->nr_cpus_allowed > 1)))
> šššššššššššššššššreturn 1;
> šššššššššreturn 0;
> š}
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 508e77e..9fdacef 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -294,6 +294,7 @@ static inline int rt_bandwidth_enabled(void)
> šstruct rt_rq {
> šššššššššstruct rt_prio_array active;
> šššššššššunsigned int rt_nr_running;
> + unsigned long rt_nr_total;
> š#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
> šššššššššstruct {
> šššššššššššššššššint curr; /* highest queued rt task prio */
> @@ -304,7 +305,6 @@ struct rt_rq {
> š#endif
> š#ifdef CONFIG_SMP
> šššššššššunsigned long rt_nr_migratory;
> - unsigned long rt_nr_total;
> šššššššššint overloaded;
> šššššššššstruct plist_head pushable_tasks;
> š#endif
> @@ -396,6 +396,7 @@ struct rq {
> š#ifdef CONFIG_RT_GROUP_SCHED
> šššššššššstruct list_head leaf_rt_rq_list;
> š#endif
> + const struct sched_class *extended_class;
>
> ššššššššš/*
> šššššššššš* This is part of a global counter where only the total sum
