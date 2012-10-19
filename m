Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030309Ab2JSMSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 08:18:14 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52191 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030253Ab2JSMSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 08:18:12 -0400
MIME-Version: 1.0
In-Reply-To: <20120823141507.356715836@google.com>
References: <20120823141422.444396696@google.com>
	<20120823141507.356715836@google.com>
Date: Fri, 19 Oct 2012 14:18:12 +0200
Message-ID: <CAKfTPtDjzvNXKi_yNZJR6T9jix2ZyUYu=fGqmNufAK01anam5A@mail.gmail.com>
Subject: Re: [patch 15/16] sched: implement usage tracking
From: Vincent Guittot <vincent.guittot@linaro.org>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I think that you have forgot to reset .usage_avg_sum in the
__sched_fork as it's already done for .runnable_avg_sum and
.usage_avg_sum

And it seems that this reset is not corrected in the latest version in
your git repo:
http://git.kernel.org/?p=linux/kernel/git/pjt/sched.git;a=blob;f=kernel/sched/core.c;h=df55e2ecdd2398648c7d01e318070d06b845a5b0;hb=refs/heads/load_tracking#l1535

Regards,
Vincent

On 23 August 2012 16:14,  <pjt@google.com> wrote:
> From: Paul Turner <pjt@google.com>
>
> With the frame-work for runnable tracking now fully in place.  Per-entity usage
> tracking is a simple and low-overhead addition.
>
> Signed-off-by: Paul Turner <pjt@google.com>
> Reviewed-by: Ben Segall <bsegall@google.com>
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/debug.c  |    3 +++
>  kernel/sched/fair.c   |   33 ++++++++++++++++++++++++++++-----
>  kernel/sched/sched.h  |    4 ++--
>  4 files changed, 34 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 93e27c0..2a4be1f 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1150,6 +1150,7 @@ struct sched_avg {
>         u64 last_runnable_update;
>         s64 decay_count;
>         unsigned long load_avg_contrib;
> +       u32 usage_avg_sum;
>  };
>
>  #ifdef CONFIG_SCHEDSTATS
> diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
> index 2cd3c1b..b9d54d0 100644
> --- a/kernel/sched/debug.c
> +++ b/kernel/sched/debug.c
> @@ -94,6 +94,7 @@ static void print_cfs_group_stats(struct seq_file *m, int cpu, struct task_group
>  #ifdef CONFIG_SMP
>         P(se->avg.runnable_avg_sum);
>         P(se->avg.runnable_avg_period);
> +       P(se->avg.usage_avg_sum);
>         P(se->avg.load_avg_contrib);
>         P(se->avg.decay_count);
>  #endif
> @@ -230,6 +231,8 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
>                         cfs_rq->tg_runnable_contrib);
>         SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
>                         atomic_read(&cfs_rq->tg->runnable_avg));
> +       SEQ_printf(m, "  .%-30s: %d\n", "tg->usage_avg",
> +                       atomic_read(&cfs_rq->tg->usage_avg));
>  #endif
>
>         print_cfs_group_stats(m, cpu, cfs_rq->tg);
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index b249371..44a9a11 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -994,7 +994,8 @@ static u32 __compute_runnable_contrib(u64 n)
>   */
>  static __always_inline int __update_entity_runnable_avg(u64 now,
>                                                         struct sched_avg *sa,
> -                                                       int runnable)
> +                                                       int runnable,
> +                                                       int running)
>  {
>         u64 delta, periods;
>         u32 runnable_contrib;
> @@ -1033,6 +1034,8 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>                 delta_w = 1024 - delta_w;
>                 if (runnable)
>                         sa->runnable_avg_sum += delta_w;
> +               if (running)
> +                       sa->usage_avg_sum += delta_w;
>                 sa->runnable_avg_period += delta_w;
>
>                 delta -= delta_w;
> @@ -1045,17 +1048,22 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>                                                   periods + 1);
>                 sa->runnable_avg_period = decay_load(sa->runnable_avg_period,
>                                                      periods + 1);
> +               sa->usage_avg_sum = decay_load(sa->usage_avg_sum, periods + 1);
>
>                 /* Efficiently calculate \sum (1..n_period) 1024*y^i */
>                 runnable_contrib = __compute_runnable_contrib(periods);
>                 if (runnable)
>                         sa->runnable_avg_sum += runnable_contrib;
> +               if (running)
> +                       sa->usage_avg_sum += runnable_contrib;
>                 sa->runnable_avg_period += runnable_contrib;
>         }
>
>         /* Remainder of delta accrued against u_0` */
>         if (runnable)
>                 sa->runnable_avg_sum += delta;
> +       if (running)
> +               sa->usage_avg_sum += delta;
>         sa->runnable_avg_period += delta;
>
>         return decayed;
> @@ -1101,16 +1109,28 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
>                                                   struct cfs_rq *cfs_rq)
>  {
>         struct task_group *tg = cfs_rq->tg;
> -       long contrib;
> +       long contrib, usage_contrib;
>
>         /* The fraction of a cpu used by this cfs_rq */
>         contrib = div_u64(sa->runnable_avg_sum << NICE_0_SHIFT,
>                           sa->runnable_avg_period + 1);
>         contrib -= cfs_rq->tg_runnable_contrib;
>
> -       if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
> +       usage_contrib = div_u64(sa->usage_avg_sum << NICE_0_SHIFT,
> +                               sa->runnable_avg_period + 1);
> +       usage_contrib -= cfs_rq->tg_usage_contrib;
> +
> +       /*
> +        * contrib/usage at this point represent deltas, only update if they
> +        * are substantive.
> +        */
> +       if ((abs(contrib) > cfs_rq->tg_runnable_contrib / 64) ||
> +           (abs(usage_contrib) > cfs_rq->tg_usage_contrib / 64)) {
>                 atomic_add(contrib, &tg->runnable_avg);
>                 cfs_rq->tg_runnable_contrib += contrib;
> +
> +               atomic_add(usage_contrib, &tg->usage_avg);
> +               cfs_rq->tg_usage_contrib += usage_contrib;
>         }
>  }
>
> @@ -1216,7 +1236,8 @@ static inline void update_entity_load_avg(struct sched_entity *se,
>         else
>                 now = cfs_rq_clock_task(group_cfs_rq(se));
>
> -       if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq))
> +       if (!__update_entity_runnable_avg(now, &se->avg, se->on_rq,
> +                                         cfs_rq->curr == se))
>                 return;
>
>         contrib_delta = __update_entity_load_avg_contrib(se);
> @@ -1261,7 +1282,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>
>  static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>  {
> -       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable);
> +       __update_entity_runnable_avg(rq->clock_task, &rq->avg, runnable,
> +                                    runnable);
>         __update_tg_runnable_avg(&rq->avg, &rq->cfs);
>  }
>
> @@ -1629,6 +1651,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>                  */
>                 update_stats_wait_end(cfs_rq, se);
>                 __dequeue_entity(cfs_rq, se);
> +               update_entity_load_avg(se, 1);
>         }
>
>         update_stats_curr_start(cfs_rq, se);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 89a0e38..e14601e 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -113,7 +113,7 @@ struct task_group {
>
>         atomic_t load_weight;
>         atomic64_t load_avg;
> -       atomic_t runnable_avg;
> +       atomic_t runnable_avg, usage_avg;
>  #endif
>
>  #ifdef CONFIG_RT_GROUP_SCHED
> @@ -236,7 +236,7 @@ struct cfs_rq {
>         u64 last_decay;
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -       u32 tg_runnable_contrib;
> +       u32 tg_runnable_contrib, tg_usage_contrib;
>         u64 tg_load_contrib;
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>
>
>
