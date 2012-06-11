Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2FKSyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:54:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:28417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab2FKSx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:53:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="151506454"
Subject: Re: [patch v3] sched: fix select_idle_sibling() induced bouncing
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        lkml <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Arjan Van De Ven <arjan@linux.intel.com>
Date: Mon, 11 Jun 2012 11:53:44 -0700
In-Reply-To: <1339437349.7358.57.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
	 <1338906621.6110.30.camel@marge.simpson.net>
	 <1339433835.7358.30.camel@marge.simpson.net>
	 <1339435331.31548.19.camel@twins>
	 <1339437349.7358.57.camel@marge.simpson.net>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339440825.28766.123.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 19:55 +0200, Mike Galbraith wrote:
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5928,6 +5928,11 @@ static void destroy_sched_domains(struct
>   * SD_SHARE_PKG_RESOURCE set (Last Level Cache Domain) for this
>   * allows us to avoid some pointer chasing select_idle_sibling().
>   *
> + * Iterate domains and sched_groups upward, assigning CPUs to be

You are actually iterating downwards (starting from the highest domain
with the SHARE_PKG_RESOURCES flag) in the patch.

> + * select_idle_sibling() hw buddy.  Cross-wiring hw makes bouncing
> + * due to random perturbation self canceling, ie sw buddies pull
> + * their counterpart to their CPU's hw counterpart.
> + *

Also it will be nice to include all the data you have observed as part
of the changelog.

thanks,
suresh

>   * Also keep a unique ID per domain (we use the first cpu number in
>   * the cpumask of the domain), this allows us to quickly tell if
>   * two cpus are in the same cache domain, see cpus_share_cache().
> @@ -5943,8 +5948,40 @@ static void update_domain_cache(int cpu)
>  	int id = cpu;
>  
>  	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
> -	if (sd)
> +	if (sd) {
> +		struct sched_domain *tmp = sd;
> +		struct sched_group *sg, *prev;
> +		bool right;
> +
> +		/*
> +		 * Traversse to first CPU in group, and count hops
> +		 * to cpu from there, switching direction on each
> +		 * hop, never ever pointing the last CPU rightward.
> +		 */
> +		do {
> +			id = cpumask_first(sched_domain_span(tmp));
> +			prev = sg = tmp->groups;
> +			right = 1;
> +
> +			while (cpumask_first(sched_group_cpus(sg)) != id)
> +				sg = sg->next;
> +
> +			while (!cpumask_test_cpu(cpu, sched_group_cpus(sg))) {
> +				prev = sg;
> +				sg = sg->next;
> +				right = !right;
> +			}
> +
> +			/* A CPU went down, never point back to domain start. */
> +			if (right && cpumask_first(sched_group_cpus(sg->next)) == id)
> +				right = false;
> +
> +			sg = right? sg->next : prev;
> +			tmp->idle_buddy = cpumask_first(sched_group_cpus(sg));
> +		} while ((tmp = tmp->child));
> +
>  		id = cpumask_first(sched_domain_span(sd));
> +	}
>  
>  	rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
>  	per_cpu(sd_llc_id, cpu) = id;
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2642,8 +2642,6 @@ static int select_idle_sibling(struct ta
>  	int cpu = smp_processor_id();
>  	int prev_cpu = task_cpu(p);
>  	struct sched_domain *sd;
> -	struct sched_group *sg;
> -	int i;
>  
>  	/*
>  	 * If the task is going to be woken-up on this cpu and if it is
> @@ -2660,29 +2658,17 @@ static int select_idle_sibling(struct ta
>  		return prev_cpu;
>  
>  	/*
> -	 * Otherwise, iterate the domains and find an elegible idle cpu.
> +	 * Otherwise, check assigned siblings to find an elegible idle cpu.
>  	 */
>  	sd = rcu_dereference(per_cpu(sd_llc, target));
> +
>  	for_each_lower_domain(sd) {
> -		sg = sd->groups;
> -		do {
> -			if (!cpumask_intersects(sched_group_cpus(sg),
> -						tsk_cpus_allowed(p)))
> -				goto next;
> -
> -			for_each_cpu(i, sched_group_cpus(sg)) {
> -				if (!idle_cpu(i))
> -					goto next;
> -			}
> -
> -			target = cpumask_first_and(sched_group_cpus(sg),
> -					tsk_cpus_allowed(p));
> -			goto done;
> -next:
> -			sg = sg->next;
> -		} while (sg != sd->groups);
> +		if (!cpumask_test_cpu(sd->idle_buddy, tsk_cpus_allowed(p)))
> +			continue;
> +		if (idle_cpu(sd->idle_buddy))
> +			return sd->idle_buddy;
>  	}
> -done:
> +
>  	return target;
>  }
>  
> 
> 


