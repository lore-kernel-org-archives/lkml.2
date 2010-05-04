Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab0EDNOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:14:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758534Ab0EDNOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:14:35 -0400
Subject: Re: [RFC PATCH v2] nohz/sched: disable ilb on !mc_capable()
From: Peter Zijlstra <peterz@infradead.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       "suresh.b.siddha" <suresh.b.siddha@intel.com>
In-Reply-To: <20100426203136.GA1539@comet.dominikbrodowski.net>
References: <20100426203136.GA1539@comet.dominikbrodowski.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 04 May 2010 15:14:24 +0200
Message-ID: <1272978864.5605.193.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-26 at 22:31 +0200, Dominik Brodowski wrote:
> From: Dominik Brodowski <linux@dominikbrodowski.net>
> Date: Thu, 8 Apr 2010 21:51:18 +0200
> Subject: [PATCH] nohz/sched: disable ilb on !mc_capable()
> 
> On my dual-core, !mc_capbale() CPU, the idle load balancer (ilb) is one
> of the main reasons ticks are not stopped: Under moderate load (~98 % idle),
> upt o half of the calls to tick_nohz_top_sched_tick() are aborted due
> to calls to select_nohz_load_balancer(1).
> 
> I suspect this is caused by the following phenomenon:
> 
>     CPU0				CPU1
>     <active>				<active>
>     tick_nohz_stop_sched_tick(1)
>     select_nohz_load_balancer(1)
>      => CPU0 becomes ilb owner,		<CPU1 becomes idle a bit later>
>         tick is not stopped,		tick_nohz_stop_sched_tick(1)
>         CPU0 goes to sleep for		 => CPU1 isn't the ilb owner,
>         exactly 1 tick.			    tick is stopped.
>     <short sleep>			<long sleep>
>     ---> scheduler_tick()
>     tick_nohz_stop_sched_tick(0)
>     tick_nohz_stop_sched_tick(1)
>      => is ilb owner, all CPUs are
>         idle, CPU0 may go to sleep.
> 
> If all CPU cores have hardly anything to do, letting the active CPU do
> idle load balancing allows us to enter deep sleep states earlier, and for
> longer periods of time. Furthermore, on !mc_capable() systems, it seems that
> the ilb algorithm isn't needed at all. Let's show this for a 2-core system:
> 
> - if both cores are active, ilb is deactivated
> - if no core is active, ilb is deactivated
> - if only one core is active, it attempts to balance its load off to other
>   CPUs on each tick anyway. ilb wouldn't act quicker.
> 
> This patch decreases the amount of wakeups on my completely idle notebook by
> about two thirds.

Right, so I think the !mc_capable() check is buggy, at the very least on
sparc64 which is 'creative' with its sched_domain maps.

I'm also not sure what a single socket AMD Magny-Cours will do.

On a single socket Nehalem we will have a non trivial sched_domain
because we also have the threads included.

I think we can only do your optimization for machines that end up having
a single sched_domain that covers the entire machine.

> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index 5a5ea2c..8ad8a03 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -3290,6 +3290,9 @@ int select_nohz_load_balancer(int stop_tick)
>  	if (stop_tick) {
>  		cpu_rq(cpu)->in_nohz_recently = 1;
>  
> +		if (!mc_capable())
> +			return 0;
> +
>  		if (!cpu_active(cpu)) {
>  			if (atomic_read(&nohz.load_balancer) != cpu)
>  				return 0;
> @@ -3339,6 +3342,9 @@ int select_nohz_load_balancer(int stop_tick)
>  		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
>  			return 0;
>  
> +		if (!mc_capable())
> +			return 0;
> +
>  		cpumask_clear_cpu(cpu, nohz.cpu_mask);
>  
>  		if (atomic_read(&nohz.load_balancer) == cpu)

