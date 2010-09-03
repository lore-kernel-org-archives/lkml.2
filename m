Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0ICBx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:53:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:63328 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0ICBx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:53:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p5PPcS+MCYdh3+Kx7H06x9sgWwfIEbIaSblm30JnArEHCnEdYyoZOxfI2EgJ9UHA+S
         mq1eGfPiJLhpf76BiQmA==
MIME-Version: 1.0
In-Reply-To: <20100828223547.082406153@chello.nl>
References: <20100828223025.054328145@chello.nl> <20100828223547.082406153@chello.nl>
From: Paul Turner <pjt@google.com>
Date: Fri, 3 Sep 2010 02:52:54 +0100
Message-ID: <AANLkTi=w8MUhf3_=ADzPX1gPycYrQkGywQSAm6cLeidE@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] sched: On-demand tg_shares_up()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 11:30 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Make tg_shares_up() use the active cgroup list, this means we cannot
> do a strict bottom-up walk of the hierarchy, but assuming its a very
> wide tree with a small number of active groups it should be a win.
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/sched.c      |   67 ----------------------------------------------------
>  kernel/sched_fair.c |   59 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 67 deletions(-)
>
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -281,13 +281,6 @@ static DEFINE_SPINLOCK(task_group_lock);
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>
> -#ifdef CONFIG_SMP
> -static int root_task_group_empty(void)
> -{
> -       return list_empty(&root_task_group.children);
> -}
> -#endif
> -
>  # define INIT_TASK_GROUP_LOAD  NICE_0_LOAD
>
>  /*
> @@ -1530,48 +1523,6 @@ static unsigned long cpu_avg_load_per_ta
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>
> -static void update_cfs_load(struct cfs_rq *cfs_rq, int lb);
> -static void update_cfs_shares(struct cfs_rq *cfs_rq);
> -
> -/*
> - * update tg->load_weight by folding this cpu's load_avg
> - */
> -static int tg_shares_up(struct task_group *tg, void *data)
> -{
> -       unsigned long load_avg;
> -       struct cfs_rq *cfs_rq;
> -       unsigned long flags;
> -       int cpu = (long)data;
> -       struct rq *rq;
> -
> -       if (!tg->se[cpu])
> -               return 0;
> -
> -       rq = cpu_rq(cpu);
> -       cfs_rq = tg->cfs_rq[cpu];
> -
> -       raw_spin_lock_irqsave(&rq->lock, flags);
> -
> -       update_rq_clock(rq);
> -       update_cfs_load(cfs_rq, 1);
> -
> -       load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
> -       load_avg -= cfs_rq->load_contribution;
> -
> -       atomic_add(load_avg, &tg->load_weight);
> -       cfs_rq->load_contribution += load_avg;
> -
> -       /*
> -        * We need to update shares after updating tg->load_weight in
> -        * order to adjust the weight of groups with long running tasks.
> -        */
> -       update_cfs_shares(cfs_rq);
> -
> -       raw_spin_unlock_irqrestore(&rq->lock, flags);
> -
> -       return 0;
> -}
> -
>  /*
>  * Compute the cpu's hierarchical load factor for each task group.
>  * This needs to be done in a top-down fashion because the load of a child
> @@ -1595,29 +1546,11 @@ static int tg_load_down(struct task_grou
>        return 0;
>  }
>
> -static void update_shares(long cpu)
> -{
> -       if (root_task_group_empty())
> -               return;
> -
> -       /*
> -        * XXX: replace with an on-demand list
> -        */
> -
> -       walk_tg_tree(tg_nop, tg_shares_up, (void *)cpu);
> -}
> -
>  static void update_h_load(long cpu)
>  {
>        walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
>  }
>
> -#else
> -
> -static inline void update_shares(int cpu)
> -{
> -}
> -
>  #endif
>
>  #ifdef CONFIG_PREEMPT
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -2002,6 +2002,61 @@ out:
>  }
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> +/*
> + * update tg->load_weight by folding this cpu's load_avg
> + */
> +static int tg_shares_up(struct task_group *tg, int cpu)
> +{
> +       unsigned long load_avg;
> +       struct cfs_rq *cfs_rq;
> +       unsigned long flags;
> +       struct rq *rq;
> +
> +       if (!tg->se[cpu])
> +               return 0;
> +
> +       rq = cpu_rq(cpu);
> +       cfs_rq = tg->cfs_rq[cpu];
> +
> +       raw_spin_lock_irqsave(&rq->lock, flags);
> +
> +       update_rq_clock(rq);
> +       update_cfs_load(cfs_rq, 1);
> +
> +       load_avg = div64_u64(cfs_rq->load_avg, cfs_rq->load_period+1);
> +       load_avg -= cfs_rq->load_contribution;
> +
> +       atomic_add(load_avg, &tg->load_weight);
> +       cfs_rq->load_contribution += load_avg;
> +
> +       /*
> +        * We need to update shares after updating tg->load_weight in
> +        * order to adjust the weight of groups with long running tasks.
> +        */
> +       update_cfs_shares(cfs_rq);
> +
> +       raw_spin_unlock_irqrestore(&rq->lock, flags);
> +
> +       return 0;
> +}
> +
> +static void update_shares(int cpu)
> +{
> +       struct cfs_rq *cfs_rq;
> +       struct rq *rq = cpu_rq(cpu);
> +
> +       rcu_read_lock();
> +       for_each_leaf_cfs_rq(rq, cfs_rq) {
> +               struct task_group *tg = cfs_rq->tg;
> +
> +               do {
> +                       tg_shares_up(tg, cpu);
> +                       tg = tg->parent;
> +               } while (tg);
> +       }

This will multiply visit taskgroups:

In the case of a-b-task, both {a} and {b} will be on the leaf cfs_rq
list.  Resulting in a being visited both as b's parent and as a leaf
entity.

Rather than juggling to avoid this, it seems easier to maintain an
ordering on rq->leaf_cfs_rq_list.

That is:

When an entity is added:
a) If it has a parent, insert it immediately before the parent in the list.
b) Otherwise it is attached to the root, attach it to the tail of
rq->leaf_cfs_rq_list

This can actually be simplified to: if no parent insert at the tail,
otherwise insert at the head, since we know the parent will always
have been processed prior to the child.

Traversing the list in order should then ensure that all child
entities have been processed for the 'next' entity at any given time
and that its update is coherent.

> +       rcu_read_unlock();
> +}
> +
>  static unsigned long
>  load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
>                  unsigned long max_load_move,
> @@ -2049,6 +2104,10 @@ load_balance_fair(struct rq *this_rq, in
>        return max_load_move - rem_load_move;
>  }
>  #else
> +static inline void update_shares(int cpu)
> +{
> +}
> +
>  static unsigned long
>  load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
>                  unsigned long max_load_move,
>
>
>
