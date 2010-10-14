Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab0JNXmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:42:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:12643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab0JNXmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:42:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,333,1283756400"; 
   d="scan'208";a="564048809"
Subject: Re: [PATCH 3/4] sched: drop group_capacity to 1 only if local
 group has extra capacity
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Venkatesh Pallipadi <venki@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1287035281-25579-1-git-send-email-ncrao@google.com>
References: <1286996978-7007-4-git-send-email-ncrao@google.com>
	 <1287035281-25579-1-git-send-email-ncrao@google.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 14 Oct 2010 16:42:38 -0700
Message-Id: <1287099758.2692.10.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 22:48 -0700, Nikhil Rao wrote:
> Resending this patch since the original patch was munged. Thanks to Mike
> Galbraith for pointing this out.
> 
> When SD_PREFER_SIBLING is set on a sched domain, drop group_capacity to 1
> only if the local group has extra capacity. For niced task balancing, we pull
> low weight tasks away from a sched group as long as there is capacity in other
> groups. When all other groups are saturated, we do not drop capacity of the
> niced group down to 1. This prevents active balance from kicking out the low
> weight threads and which hurts system utilization.
> 
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> ---
>  kernel/sched_fair.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 0dd1021..da0c688 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2030,6 +2030,7 @@ struct sd_lb_stats {
>  	unsigned long this_load;
>  	unsigned long this_load_per_task;
>  	unsigned long this_nr_running;
> +	unsigned long this_group_capacity;
>  
>  	/* Statistics of the busiest group */
>  	unsigned long max_load;
> @@ -2546,15 +2547,18 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>  		/*
>  		 * In case the child domain prefers tasks go to siblings
>  		 * first, lower the sg capacity to one so that we'll try
> -		 * and move all the excess tasks away.
> +		 * and move all the excess tasks away. We lower capacity only
> +		 * if the local group can handle the extra capacity.
>  		 */
> -		if (prefer_sibling)
> +		if (prefer_sibling && !local_group &&
> +		    sds->this_nr_running < sds->this_group_capacity)
>  			sgs.group_capacity = min(sgs.group_capacity, 1UL);

Yes Nikhil. This should solve my earlier concern of SMT/MC idle
balancing case.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

>  
>  		if (local_group) {
>  			sds->this_load = sgs.avg_load;
>  			sds->this = sg;
>  			sds->this_nr_running = sgs.sum_nr_running;
> +			sds->this_group_capacity = sgs.group_capacity;
>  			sds->this_load_per_task = sgs.sum_weighted_load;
>  		} else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
>  			sds->max_load = sgs.avg_load;

