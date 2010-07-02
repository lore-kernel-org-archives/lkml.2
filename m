Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0GBIGv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:06:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42907 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab0GBIGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:06:46 -0400
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <1278025942-6750-1-git-send-email-venki@google.com>
References: <1278025942-6750-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 02 Jul 2010 10:05:44 +0200
Message-ID: <1278057944.32034.15085.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 16:12 -0700, Venkatesh Pallipadi wrote:
> commit 871e35b moved update_group_power() call in update_sg_lb_stats(),
> resulting in it being called for each group, even though it only updates
> the power of local group. As a result we have frequent redundant
> update_group_power() calls.
> 
> Move it back under "if (local_group)" condition.
> 
> This reduces the number of calls to update_group_power by a factor of 4
> on my 4 core in 4 NUMA nodes test system.

Hrm,.. so Gautham removed that because for things like the NO_HZ
balancer the initial balance_cpu == this_cpu constraint doesn't hold.

Not I don't think the local_group constraint holds for that either, so
the below would again break that..

Should we perhaps have a conditional on this_rq->nohz_balance_kick or
so?

> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -2359,8 +2359,11 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>  	unsigned int balance_cpu = -1, first_idle_cpu = 0;
>  	unsigned long avg_load_per_task = 0;
>  
> -	if (local_group)
> +	if (local_group) {
>  		balance_cpu = group_first_cpu(group);
> +		update_group_power(sd, this_cpu);
> +	}
> +
>  
>  	/* Tally up the load of all CPUs in the group */
>  	max_cpu_load = 0;

