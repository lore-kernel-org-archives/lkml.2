Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2CMQ55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:57:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52496 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2CMQ5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	<20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
Date: Tue, 13 Mar 2012 17:57:52 +0100
Message-ID: <CAKfTPtAFT-GH2SzE1--XQVaay+bwATcLOqxFpH_z=byo=ix=uw@mail.gmail.com>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 2 February 2012 02:38, Paul Turner <pjt@google.com> wrote:
> With the frame-work for runnable tracking now fully in place.  Per-entity usage
> tracking is a simple and low-overhead addition.
>
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Ben Segall <bsegall@google.com>
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/debug.c  |    3 +++
>  kernel/sched/fair.c   |   29 +++++++++++++++++++++++------
>  kernel/sched/sched.h  |    4 ++--
>  4 files changed, 29 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 09b8c45..209185f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1159,6 +1159,7 @@ struct load_weight {
>  struct sched_avg {
>        u64 runnable_avg_sum, runnable_avg_period;
>        u64 last_runnable_update, decay_count;
> +       u32 usage_avg_sum;

Why usage_avg_sum is 32bits whereas runnable_avg_sum and
runnable_avg_period are 64bits long ? You are doing the same
computation on these 3 variables. Only the computation need to be done
in 64bits but the result could be saved in 32bits ?

Regards,
Vincent

>        unsigned long load_avg_contrib;
>
>        int contributes_blocked_load;
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 0911ec6..4d39069 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -93,6 +93,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>        P(se->load.weight);
>        P(se->avg.runnable_avg_sum);
>        P(se->avg.runnable_avg_period);
> +       P(se->avg.usage_avg_sum);
>        P(se->avg.load_avg_contrib);
>        P(se->avg.decay_count);
>  #undef PN
> @@ -228,6 +229,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>                        cfs_rq->tg_runnable_contrib);
>        SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
>                        atomic_read(&cfs_rq->tg->runnable_avg));
> +       SEQ_printf(m, "  .%-30s: %d\n", "tg->usage_avg",
> +                       atomic_read(&cfs_rq->tg->usage_avg));
>  #endif
>
>        print_cfs_group_stats(m, cpu, cfs_rq->tg);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index ad524bb..222c2c9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -997,7 +997,8 @@ static u32 __compute_runnable_contrib(int n)
>  */
>  static __always_inline int __update_entity_runnable_avg(u64 now,
>                                                        struct sched_avg *sa,
> -                                                       int runnable)
> +                                                       int runnable,
> +                                                       int running)
>  {
>        u64 delta;
>        u32 periods, runnable_contrib;
> @@ -1026,6 +1027,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>                delta_w = 1024 - delta_w;
>                if (runnable)
>                        sa->runnable_avg_sum += delta_w;
> +               if (running)
> +                       sa->usage_avg_sum += delta_w;
>                sa->runnable_avg_period += delta_w;
>
>                delta -= delta_w;
> @@ -1036,15 +1039,20 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>                                                  periods + 1);
>                sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
>                                                  periods + 1);
> +               sa->usage_avg_sum = decay_load(sa->usage_avg_sum, periods + 1);
>
>                runnable_contrib = __compute_runnable_contrib(periods);
>                if (runnable)
>                        sa->runnable_avg_sum += runnable_contrib;
> +               if (running)
> +                       sa->usage_avg_sum += runnable_contrib;
>                sa->runnable_avg_period += runnable_contrib;
>        }
>
>        if (runnable)
>                sa->runnable_avg_sum += delta;
> +       if (running)
> +               sa->usage_avg_sum += delta;
>        sa->runnable_avg_period += delta;
>
>        return decayed;
> @@ -1081,14 +1089,21 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
>                                                  struct cfs_rq *cfs_rq)
>  {
>        struct task_group *tg = cfs_rq->tg;
> -       long contrib;
> +       long contrib, usage_contrib;
>
>        contrib = (sa->runnable_avg_sum << 12) / (sa->runnable_avg_period + 1);
>        contrib -= cfs_rq->tg_runnable_contrib;
>
> -       if (abs(contrib) > cfs_rq->tg_runnable_contrib/64) {
> +       usage_contrib = (sa->usage_avg_sum << 12) / (sa->runnable_avg_period + 1);
> +       usage_contrib -= cfs_rq->tg_usage_contrib;
> +
> +       if ((abs(contrib) > cfs_rq->tg_runnable_contrib/64) ||
> +           (abs(usage_contrib) > cfs_rq->tg_usage_contrib/64)) {
>                atomic_add(contrib, &tg->runnable_avg);
>                cfs_rq->tg_runnable_contrib += contrib;
> +
> +               atomic_add(usage_contrib, &tg->usage_avg);
> +               cfs_rq->tg_usage_contrib += usage_contrib;
>        }
>  }
>
> @@ -1164,8 +1179,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
>        struct cfs_rq *cfs_rq = cfs_rq_of(se);
>        long contrib_delta;
>
> -       if(!__update_entity_runnable_avg(rq_of(cfs_rq)->clock_task, &se->avg,
> -                                       se->on_rq))
> +       if(!__update_entity_runnable_avg(cfs_rq_clock_task(cfs_rq), &se->avg,
> +                                        se->on_rq, cfs_rq->curr == se))
>                return;
>
>        contrib_delta = __update_entity_load_avg_contrib(se);
> @@ -1210,7 +1225,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>
>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>  {
> -       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
> +       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable,
> +                                    runnable);
>        __update_tg_runnable_avg(&rq->avg, &rq->cfs);
>  }
>
> @@ -1590,6 +1606,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>                 */
>                update_stats_wait_end(cfs_rq, se);
>                __dequeue_entity(cfs_rq, se);
> +               update_entity_load_avg(se, 1);
>        }
>
>        update_stats_curr_start(cfs_rq, se);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 77f3297..9602a47 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -117,7 +117,7 @@ struct task_group {
>
>        atomic_t load_weight;
>        atomic64_t load_avg;
> -       atomic_t runnable_avg;
> +       atomic_t runnable_avg, usage_avg;
>  #endif
>
>  #ifdef CONFIG_RT_GROUP_SCHED
> @@ -260,7 +260,7 @@ struct cfs_rq {
>         */
>        unsigned long h_load;
>
> -       u32 tg_runnable_contrib;
> +       u32 tg_runnable_contrib, tg_usage_contrib;
>        u64 runnable_load_avg, blocked_load_avg;
>        u64 tg_load_contrib;
>        atomic64_t decay_counter, removed_load;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
