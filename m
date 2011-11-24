Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1KXDuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:50:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab1KXDuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:50:22 -0500
Subject: Re: [patch 3/7] sched: set skip_clock_update in yield_task_fair()
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1322059696.14799.68.camel@twins>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
	 <1321971445.6855.14.camel@marge.simson.net>
	 <1321971686.6855.18.camel@marge.simson.net>
	 <1322059696.14799.68.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 04:50:15 +0100
Message-ID: <1322106615.6222.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 15:48 +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-22 at 15:21 +0100, Mike Galbraith wrote:
> > This is another case where we are on our way to schedule(),
> > so can save a useless clock update and resulting microscopic
> > vruntime update.
> > 
> 
> Everytime I see one of these skip_clock_update thingies I get the idea
> we should do something smarter, because its most fragile and getting it
> wrong results in a subtle trainwreck..
> 
> Would something like the below help in validating this stuff?

No, because switch itself is irrelevant to fair-beans counting.

> ---
> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -113,12 +113,27 @@ void update_rq_clock(struct rq *rq)
>  {
>  	s64 delta;
>  
> -	if (rq->skip_clock_update > 0)
> +	if (rq->skip_clock_update > 0) {
> +		/*
> +		 * We skipped an update even though we had a full context
> +		 * switch in between, badness.
> +		 */
> +		if (rq->clock_update_stamp != rq->sched_switch)
> +			trace_printk("lost an update!!\n");
>  		return;
> +	}
> +
> +	/*
> +	 * We're updating the clock even though we didn't switch yet.
> +	 */
> +	if (rq->clock_update_stamp == rq->sched_switch)
> +		trace_printk("too many updates!!\n");
>  
>  	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
>  	rq->clock += delta;
>  	update_rq_clock_task(rq, delta);
> +
> +	rq->clock_update_stamp = rq->sched_switch
>  }
>  
>  /*
> @@ -1922,6 +1937,9 @@ static void finish_task_switch(struct rq
>  #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
>  	local_irq_enable();
>  #endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
> +#ifdef CONFIG_SCHED_DEBUG
> +	schedstat_inc(rq, sched_switch);
> +#endif
>  	finish_lock_switch(rq, prev);
>  
>  	fire_sched_in_preempt_notifiers(current);
> Index: linux-2.6/kernel/sched/sched.h
> ===================================================================
> --- linux-2.6.orig/kernel/sched/sched.h
> +++ linux-2.6/kernel/sched/sched.h
> @@ -374,6 +374,8 @@ struct rq {
>  	unsigned char nohz_balance_kick;
>  #endif
>  	int skip_clock_update;
> +	unsigned int clock_update_stamp;
> +
>  
>  	/* capture load from *all* tasks on this cpu: */
>  	struct load_weight load;
> 


