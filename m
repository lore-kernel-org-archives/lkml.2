Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab0FIXDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:03:41 -0400
Received: from ozlabs.org ([203.10.76.45]:54183 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0FIXDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:03:40 -0400
From: Michael Neuling <mikey@neuling.org>
To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       arjan@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Fix capacity calculations for SMT4
In-reply-to: <tip-9d5efe05eb0c904545a28b19c18b949f23334de0@git.kernel.org>
References: <20100608045702.21D03CC895@localhost.localdomain> <tip-9d5efe05eb0c904545a28b19c18b949f23334de0@git.kernel.org>
Comments: In-reply-to tip-bot for Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
   message dated "Wed, 09 Jun 2010 10:14:15 +0000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Thu, 10 Jun 2010 09:03:37 +1000
Message-ID: <12629.1276124617@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

It looks like when this was pushed to Ingo, some of the logic was
changed.  rt_freq_influence() became fix_small_capacity() but the return
values for these two functions are opposite (return 1 => return 0 and
visa versa]]).

This was changed in the sibling test (return 1 => return 0), but the
check for the change in cpu power due to freq and rt was not.

So either the return values need to be changed at the end of
fix_small_capacity() or the cpu_power test needs to be the other way
around.  Below changes the cpu_power test as it brings it more inline
with the comment above it.

Without this the asymmetric packing doesn't work.

Mikey
---
Subject: sched: fix the CPU power test for fix_small_capacity

The CPU power test is the wrong way around in fix_small_capacity.

This was due to a small changes made in the posted patch on lkml to what
was was taken upstream.

This patch fixes asymmetric packing for POWER7.

Signed-off-by: Michael Neuling <mikey@neuling.org>

Index: linux-2.6-ozlabs/kernel/sched_fair.c
===================================================================
--- linux-2.6-ozlabs.orig/kernel/sched_fair.c
+++ linux-2.6-ozlabs/kernel/sched_fair.c
@@ -2354,7 +2354,7 @@ fix_small_capacity(struct sched_domain *
 	/*
 	 * If ~90% of the cpu_power is still there, we're good.
 	 */
-	if (group->cpu_power * 32 < group->cpu_power_orig * 29)
+	if (group->cpu_power * 32 > group->cpu_power_orig * 29)
 		return 1;
 
 	return 0;


In message <tip-9d5efe05eb0c904545a28b19c18b949f23334de0@git.kernel.org> you wr
ote:
> Commit-ID:  9d5efe05eb0c904545a28b19c18b949f23334de0
> Gitweb:     http://git.kernel.org/tip/9d5efe05eb0c904545a28b19c18b949f23334de
0
> Author:     Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> AuthorDate: Tue, 8 Jun 2010 14:57:02 +1000
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 9 Jun 2010 10:34:54 +0200
> 
> sched: Fix capacity calculations for SMT4
> 
> Handle cpu capacity being reported as 0 on cores with more number of
> hardware threads. For example on a Power7 core with 4 hardware
> threads, core power is 1177 and thus power of each hardware thread is
> 1177/4 = 294. This low power can lead to capacity for each hardware
> thread being calculated as 0, which leads to tasks bouncing within the
> core madly!
> 
> Fix this by reporting capacity for hardware threads as 1, provided
> their power is not scaled down significantly because of frequency
> scaling or real-time tasks usage of cpu.
> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> LKML-Reference: <20100608045702.21D03CC895@localhost.localdomain>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/sched.h |    2 +-
>  kernel/sched_fair.c   |   53 +++++++++++++++++++++++++++++++++++++++--------
-
>  2 files changed, 44 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index a3e5b1c..c731296 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -857,7 +857,7 @@ struct sched_group {
>  	 * CPU power of this group, SCHED_LOAD_SCALE being max power for a
>  	 * single CPU.
>  	 */
> -	unsigned int cpu_power;
> +	unsigned int cpu_power, cpu_power_orig;
>  
>  	/*
>  	 * The CPUs this group covers.
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 6ee2e0a..b9b3462 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2285,13 +2285,6 @@ static void update_cpu_power(struct sched_domain *sd, 
int cpu)
>  	unsigned long power = SCHED_LOAD_SCALE;
>  	struct sched_group *sdg = sd->groups;
>  
> -	if (sched_feat(ARCH_POWER))
> -		power *= arch_scale_freq_power(sd, cpu);
> -	else
> -		power *= default_scale_freq_power(sd, cpu);
> -
> -	power >>= SCHED_LOAD_SHIFT;
> -
>  	if ((sd->flags & SD_SHARE_CPUPOWER) && weight > 1) {
>  		if (sched_feat(ARCH_POWER))
>  			power *= arch_scale_smt_power(sd, cpu);
> @@ -2301,6 +2294,15 @@ static void update_cpu_power(struct sched_domain *sd, 
int cpu)
>  		power >>= SCHED_LOAD_SHIFT;
>  	}
>  
> +	sdg->cpu_power_orig = power;
> +
> +	if (sched_feat(ARCH_POWER))
> +		power *= arch_scale_freq_power(sd, cpu);
> +	else
> +		power *= default_scale_freq_power(sd, cpu);
> +
> +	power >>= SCHED_LOAD_SHIFT;
> +
>  	power *= scale_rt_power(cpu);
>  	power >>= SCHED_LOAD_SHIFT;
>  
> @@ -2333,6 +2335,31 @@ static void update_group_power(struct sched_domain *sd
, int cpu)
>  	sdg->cpu_power = power;
>  }
>  
> +/*
> + * Try and fix up capacity for tiny siblings, this is needed when
> + * things like SD_ASYM_PACKING need f_b_g to select another sibling
> + * which on its own isn't powerful enough.
> + *
> + * See update_sd_pick_busiest() and check_asym_packing().
> + */
> +static inline int
> +fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
> +{
> +	/*
> +	 * Only siblings can have significantly less than SCHED_LOAD_SCALE
> +	 */
> +	if (sd->level != SD_LV_SIBLING)
> +		return 0;
> +
> +	/*
> +	 * If ~90% of the cpu_power is still there, we're good.
> +	 */
> +	if (group->cpu_power * 32 < group->cpu_power_orig * 29)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  /**
>   * update_sg_lb_stats - Update sched_group's statistics for load balancing.
>   * @sd: The sched_domain whose statistics are to be updated.
> @@ -2426,6 +2453,8 @@ static inline void update_sg_lb_stats(struct sched_doma
in *sd,
>  
>  	sgs->group_capacity =
>  		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
> +	if (!sgs->group_capacity)
> +		sgs->group_capacity = fix_small_capacity(sd, group);
>  }
>  
>  /**
> @@ -2724,8 +2753,9 @@ ret:
>   * find_busiest_queue - find the busiest runqueue among the cpus in group.
>   */
>  static struct rq *
> -find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
> -		   unsigned long imbalance, const struct cpumask *cpus)
> +find_busiest_queue(struct sched_domain *sd, struct sched_group *group,
> +		   enum cpu_idle_type idle, unsigned long imbalance,
> +		   const struct cpumask *cpus)
>  {
>  	struct rq *busiest = NULL, *rq;
>  	unsigned long max_load = 0;
> @@ -2736,6 +2766,9 @@ find_busiest_queue(struct sched_group *group, enum cpu_
idle_type idle,
>  		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SC
ALE);
>  		unsigned long wl;
>  
> +		if (!capacity)
> +			capacity = fix_small_capacity(sd, group);
> +
>  		if (!cpumask_test_cpu(i, cpus))
>  			continue;
>  
> @@ -2852,7 +2885,7 @@ redo:
>  		goto out_balanced;
>  	}
>  
> -	busiest = find_busiest_queue(group, idle, imbalance, cpus);
> +	busiest = find_busiest_queue(sd, group, idle, imbalance, cpus);
>  	if (!busiest) {
>  		schedstat_inc(sd, lb_nobusyq[idle]);
>  		goto out_balanced;
> 
