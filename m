Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0GHRqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:46:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:14499 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709Ab0GHRqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,559,1272870000"; 
   d="scan'208";a="297998397"
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>,
       LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1278598336.1900.150.camel@laptop>
References: <1278088816.1917.279.camel@laptop>
	 <1278089799-11949-1-git-send-email-venki@google.com>
	 <1278598336.1900.150.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 08 Jul 2010 10:45:33 -0700
Message-Id: <1278611133.2834.10.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-08 at 07:12 -0700, Peter Zijlstra wrote:
> Sorry for the delay, I got side-tracked :/
> 
> On Fri, 2010-07-02 at 09:56 -0700, Venkatesh Pallipadi wrote:
> > My fault. I completely missed that code path, assuming this_cpu in
> > load_balance means this_cpu :(
> 
> Right, but local_group is still valid because that's
> cpumask_test_cpu(this_cpu, sched_group_cpus(group));
> 
> So in that regard your initial patch was still correct. However, since
> there can be multiple CPUs in the local group, we want to only have one
> do the actual balancing, which is what the !*balance logic is about, so
> by keeping the call site where it is gains that.
> 
> The below proposal avoids calling update_groups_power() too often for:
>  - !local_groups,
>  - multiple cpus in the same group.
> 
> Does this look correct?
> 
> Related to this, Mikey was looking at avoiding the for_each_cpu_and()
> loops by converting update_sg_lb_stats into something similar to
> update_group_power() and have 1 cpu in the group update the statistics
> and propagate upwards by summing groups instead of individual cpus.
> 
> ---
>  kernel/sched_fair.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 9910e1b..62f34a0 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2433,7 +2433,8 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>  		return;
>  	}
>  
> -	update_group_power(sd, this_cpu);
> +	if (local_group)
> +		update_group_power(sd, this_cpu);

if IDLE == CPU_NEWLY_IDLE, then all the cpu's in the local group will do
this. Also update_group_power() can be done on only on the local cpu,
i.e., when this_cpu == smp_processor_id() right?

So it should be something like?

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a878b53..2d8a74e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2406,8 +2406,6 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
 		return;
 	}
 
-	update_group_power(sd, this_cpu);
-
 	/* Adjust by relative CPU power of the group */
 	sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) / group->cpu_power;
 
@@ -2456,6 +2454,9 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
 	init_sd_power_savings_stats(sd, sds, idle);
 	load_idx = get_sd_load_idx(sd, idle);
 
+	if (this_cpu == smp_processor_id())
+		update_group_power(sd, this_cpu);
+
 	do {
 		int local_group;
 


