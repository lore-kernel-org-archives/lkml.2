Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab0DMM3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:29:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38068 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0DMM3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:29:36 -0400
Subject: Re: [PATCH 1/5] sched: fix capacity calculations for SMT4
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100409062118.D4096CBB6C@localhost.localdomain>
References: <20100409062118.D4096CBB6C@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 14:29:26 +0200
Message-ID: <1271161766.4807.1280.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> When calculating capacity we use the following calculation:
> 
>        capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
> 
> In SMT2, power will be 1178/2 (provided we are not scaling power with
> freq say) and SCHED_LOAD_SCALE will be 1024, resulting in capacity
> being 1.
> 
> With SMT4 however, power will be 1178/4, hence capacity will end up as
> 0.
> 
> Fix this by ensuring capacity is always at least 1 after this
> calculation.
> 
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
> I'm not sure this is the correct fix but this works for me.  

Right, so I suspect this will indeed break some things.

We initially allowed 0 capacity for when a cpu is consumed by an RT task
and there simply isn't much capacity left, in that case you really want
to try and move load to your sibling cpus if possible.

However you're right that this goes awry in your case.

One thing to look at is if that 15% increase is indeed representative
for the power7 cpu, it having 4 SMT threads seems to suggest there was
significant gains, otherwise they'd not have wasted the silicon.

(The broken x86 code was meant to actually compute the SMT gain, so that
we'd not have to guess the 15%)

Now, increasing this will only marginally fix the issue, since if you
end up with 512 per thread it only takes a very tiny amount of RT
workload to drop below and end up at 0 again.

One thing we could look at is using the cpu base power to compute
capacity from. We'd have to add another field to sched_group and store
power before we do the scale_rt_power() stuff.

Thoughts?


>  kernel/sched_fair.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6-ozlabs/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/kernel/sched_fair.c
> +++ linux-2.6-ozlabs/kernel/sched_fair.c
> @@ -1482,6 +1482,7 @@ static int select_task_rq_fair(struct ta
>  			}
>  
>  			capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
> +			capacity = max(capacity, 1UL);
>  
>  			if (tmp->flags & SD_POWERSAVINGS_BALANCE)
>  				nr_running /= 2;
> @@ -2488,6 +2489,7 @@ static inline void update_sg_lb_stats(st
>  
>  	sgs->group_capacity =
>  		DIV_ROUND_CLOSEST(group->cpu_power, SCHED_LOAD_SCALE);
> +	sgs->group_capacity = max(sgs->group_capacity, 1UL);
>  }
>  
>  /**
> @@ -2795,9 +2797,11 @@ find_busiest_queue(struct sched_group *g
>  
>  	for_each_cpu(i, sched_group_cpus(group)) {
>  		unsigned long power = power_of(i);
> -		unsigned long capacity = DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
> +		unsigned long capacity;
>  		unsigned long wl;
>  
> +		capacity = max(DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE), 1UL);
> +
>  		if (!cpumask_test_cpu(i, cpus))
>  			continue;
>  

