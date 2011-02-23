Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab1BWNcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:32:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52495 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818Ab1BWNcv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:32:51 -0500
Subject: Re: [CFS Bandwidth Control v4 6/7] sched: hierarchical task
 accounting for SCHED_OTHER
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <20110216031841.352204682@google.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.352204682@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 14:32:11 +0100
Message-ID: <1298467931.2217.762.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:

> @@ -1846,6 +1846,11 @@ static const struct sched_class rt_sched
>  
>  #include "sched_stats.h"
>  
> +static void mod_nr_running(struct rq *rq, long delta)
> +{
> +	rq->nr_running += delta;
> +}

I personally don't see much use in such trivial wrappers.. if you're
going to rework all the nr_running stuff you might as well remove all of
that.

> Index: tip/kernel/sched_fair.c
> ===================================================================
> --- tip.orig/kernel/sched_fair.c
> +++ tip/kernel/sched_fair.c
> @@ -81,6 +81,8 @@ unsigned int normalized_sysctl_sched_wak
>  
>  const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
>  
> +static void account_hier_tasks(struct sched_entity *se, int delta);
> +
>  /*
>   * The exponential sliding  window over which load is averaged for shares
>   * distribution.
> @@ -933,6 +935,40 @@ static inline void update_entity_shares_
>  }
>  #endif /* CONFIG_FAIR_GROUP_SCHED */
>  
> +#ifdef CONFIG_CFS_BANDWIDTH
> +/* maintain hierarchal task counts on group entities */
> +static void account_hier_tasks(struct sched_entity *se, int delta)
> +{
> +	struct rq *rq = rq_of(cfs_rq_of(se));
> +	struct cfs_rq *cfs_rq;
> +
> +	for_each_sched_entity(se) {
> +		/* a throttled entity cannot affect its parent hierarchy */
> +		if (group_cfs_rq(se) && cfs_rq_throttled(group_cfs_rq(se)))
> +			break;
> +
> +		/* we affect our queuing entity */
> +		cfs_rq = cfs_rq_of(se);
> +		cfs_rq->h_nr_tasks += delta;
> +	}
> +
> +	/* account for global nr_running delta to hierarchy change */
> +	if (!se)
> +		mod_nr_running(rq, delta);
> +}
> +#else
> +/*
> + * In the absence of group throttling, all operations are guaranteed to be
> + * globally visible at the root rq level.
> + */
> +static void account_hier_tasks(struct sched_entity *se, int delta)
> +{
> +	struct rq *rq = rq_of(cfs_rq_of(se));
> +
> +	mod_nr_running(rq, delta);
> +}
> +#endif

While Balbir suggested expanding the _hier_ thing, I'd suggest to simply
drop it altogether, way too much typing ;-), but that is if you cannot
get rid of the extra hierarchy iteration, see below.

> +
>  static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
>  #ifdef CONFIG_SCHEDSTATS
> @@ -1428,6 +1464,7 @@ enqueue_task_fair(struct rq *rq, struct 
>  		update_cfs_shares(cfs_rq);
>  	}
>  
> +	account_hier_tasks(&p->se, 1);
>  	hrtick_update(rq);
>  }
>  
> @@ -1461,6 +1498,7 @@ static void dequeue_task_fair(struct rq 
>  		update_cfs_shares(cfs_rq);
>  	}
>  
> +	account_hier_tasks(&p->se, -1);
>  	hrtick_update(rq);
>  }
>  
> @@ -1488,6 +1526,8 @@ static u64 tg_request_cfs_quota(struct t
>  	return delta;
>  }
>  
> +static void account_hier_tasks(struct sched_entity *se, int delta);
> +
>  static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
>  {
>  	struct sched_entity *se;
> @@ -1507,6 +1547,7 @@ static void throttle_cfs_rq(struct cfs_r
>  	if (!se->on_rq)
>  		goto out_throttled;
>  
> +	account_hier_tasks(se, -cfs_rq->h_nr_tasks);
>  	for_each_sched_entity(se) {
>  		struct cfs_rq *cfs_rq = cfs_rq_of(se);
>  
> @@ -1541,6 +1582,7 @@ static void unthrottle_cfs_rq(struct cfs
>  	cfs_rq->load_stamp = cfs_rq->load_last = rq->clock_task;
>  
>  	cfs_rq->throttled = 0;
> +	account_hier_tasks(se, cfs_rq->h_nr_tasks);
>  	for_each_sched_entity(se) {
>  		if (se->on_rq)
>  			break;

All call-sites are right next to a for_each_sched_entity() iteration, is
there really no way to fold those loops?

> Index: tip/kernel/sched_rt.c
> ===================================================================
> --- tip.orig/kernel/sched_rt.c
> +++ tip/kernel/sched_rt.c
> @@ -906,6 +906,8 @@ enqueue_task_rt(struct rq *rq, struct ta
>  
>  	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
>  		enqueue_pushable_task(rq, p);
> +
> +	inc_nr_running(rq);
>  }
>  
>  static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
> @@ -916,6 +918,8 @@ static void dequeue_task_rt(struct rq *r
>  	dequeue_rt_entity(rt_se);
>  
>  	dequeue_pushable_task(rq, p);
> +
> +	dec_nr_running(rq);
>  }
>  
>  /*
> @@ -1783,4 +1787,3 @@ static void print_rt_stats(struct seq_fi
>  	rcu_read_unlock();
>  }
>  #endif /* CONFIG_SCHED_DEBUG */


You mentioned something about -rt having the same problem, yet you don't
fix it.. tskkk :-)

