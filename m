Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab1KRPhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:37:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:44455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab1KRPhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:37:10 -0500
Subject: Re: [patch 3/6] sched: use rq->avg_event to resurrect nohz
 ratelimiting
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Date: Fri, 18 Nov 2011 16:36:59 +0100
In-Reply-To: <1321629562.7080.17.camel@marge.simson.net>
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
	 <1321629562.7080.17.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321630619.2197.16.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 16:19 +0100, Mike Galbraith wrote:
> Entering nohz at high frequency eats cycles, ratelimit it
> just as we do idle_balance(), and for the same reason.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>

Arjan, can we do something smart with the idle governor which already
guestimates the idle duration for us?

> ---
>  include/linux/sched.h    |    2 ++
>  kernel/sched.c           |    7 +++++++
>  kernel/time/tick-sched.c |    2 +-
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> Index: linux-3.2.git/include/linux/sched.h
> ===================================================================
> --- linux-3.2.git.orig/include/linux/sched.h
> +++ linux-3.2.git/include/linux/sched.h
> @@ -1979,8 +1979,10 @@ static inline void idle_task_exit(void)
>  
>  #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
>  extern void wake_up_idle_cpu(int cpu);
> +extern int sched_needs_cpu(int cpu);
>  #else
>  static inline void wake_up_idle_cpu(int cpu) { }
> +static inline void sched_needs_cpu(int cpu) { }
>  #endif
>  
>  extern unsigned int sysctl_sched_latency;
> Index: linux-3.2.git/kernel/sched.c
> ===================================================================
> --- linux-3.2.git.orig/kernel/sched.c
> +++ linux-3.2.git/kernel/sched.c
> @@ -1419,6 +1419,13 @@ static inline bool got_nohz_idle_kick(vo
>  	return idle_cpu(smp_processor_id()) && this_rq()->nohz_balance_kick;
>  }
>  
> +#ifdef CONFIG_SMP
> +int sched_needs_cpu(int cpu)
> +{
> +	return cpu_rq(cpu)->avg_event < sysctl_sched_migration_cost;
> +}
> +#endif
> +
>  #else /* CONFIG_NO_HZ */
>  
>  static inline bool got_nohz_idle_kick(void)
> Index: linux-3.2.git/kernel/time/tick-sched.c
> ===================================================================
> --- linux-3.2.git.orig/kernel/time/tick-sched.c
> +++ linux-3.2.git/kernel/time/tick-sched.c
> @@ -352,7 +352,7 @@ void tick_nohz_stop_sched_tick(int inidl
>  	} while (read_seqretry(&xtime_lock, seq));
>  
>  	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
> -	    arch_needs_cpu(cpu)) {
> +	    arch_needs_cpu(cpu) || sched_needs_cpu(cpu)) {
>  		next_jiffies = last_jiffies + 1;
>  		delta_jiffies = 1;
>  	} else {
> 
> 

