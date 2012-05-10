Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652Ab2EJSRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:17:13 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52548 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab2EJSRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:17:11 -0400
Date: Thu, 10 May 2012 11:16:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <mgalbraith@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clockevents: Per cpu tick skew boot option
Message-ID: <20120510181607.GA14329@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1336309127.7351.13.camel@marge.simpson.net>
 <alpine.LFD.2.02.1205072115000.6271@ionos>
 <1336447221.7364.2.camel@marge.simpson.net>
 <alpine.LFD.2.02.1205081143510.6271@ionos>
 <1336472458.21924.78.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336472458.21924.78.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051018-9360-0000-0000-00000636EC03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 12:20:58PM +0200, Mike Galbraith wrote:
> On Tue, 2012-05-08 at 11:44 +0200, Thomas Gleixner wrote: 
> > On Tue, 8 May 2012, Mike Galbraith wrote:
> > 
> > > On Mon, 2012-05-07 at 21:17 +0200, Thomas Gleixner wrote: 
> > > > On Sun, 6 May 2012, Mike Galbraith wrote:
> > > > >  
> > > > > +	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
> > > > > +			xtime_lock contention on larger systems.  Note: increases
> > > > > +			power consumption, and should only be enabled if running
> > > > > +			jitter sensitive (HPC/RT) workloads.
> > > > > +
> > > > 
> > > > The "=" is wrong as skew_tick should not take parameters. It's
> > > > disabled by default. So "skew_tick" simply enables it, right ?
> > > 
> > > Unless as I have RT set up, it's turned on by default, so '=' lets the
> > > user turn it back off.
> > 
> > Then the doc should say what's the parameter after the "+" is :)
> 
> I only put anything there because boss said "Document", I was hiding it
> along with fugly but damn useful <koff> HPC/RT cpuset patch ;-)
> 
> Let the user decide whether power consumption or jitter is the
> more important consideration for their machines.
> 
> Quoting removal commit af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867
> Historically, Linux has tried to make the regular timer tick on the
> various CPUs not happen at the same time, to avoid contention on
> xtime_lock.
>     
> Nowadays, with the tickless kernel, this contention no longer happens
> since time keeping and updating are done differently. In addition,
> this skew is actually hurting power consumption in a measurable way on
> many-core systems.
> End quote
> 
> Problems:
> 
> - Contrary to the above, systems do encounter contention on both
>   xtime_lock and RCU structure locks when the tick is synchronized.
>   
> - Moderate sized RT systems suffer intolerable jitter due to the tick
>   being synchronized.
> 
> - SGI reports the same for their large systems.
> 
> - Fully utilized systems reap no power saving benefit from skew removal,
>   but do suffer from resulting induced lock contention.
> 
> - 0209f649 rcu: limit rcu_node leaf-level fanout
>   This patch was born to combat lock contention which testing showed
>   to have been _induced by_ skew removal.  Skew the tick, contention
>   disappeared virtually completely.
> 
> Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
> 
> ---
>  Documentation/kernel-parameters.txt |    9 +++++++++
>  kernel/time/tick-sched.c            |   19 +++++++++++++++++++
>  2 files changed, 28 insertions(+)
> 
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2426,6 +2426,15 @@ bytes respectively. Such letter suffixes
> 
>  	sched_debug	[KNL] Enables verbose scheduler debug messages.
> 
> +	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
> +			xtime_lock contention on larger systems, and/or RCU lock
> +			contention on all systems with CONFIG_MAXSMP set.

Suggest instead:

			contention on systems with large CONFIG_RCU_FANOUT
			values.

> +			Format: { "0" | "1" }
> +			0 -- disable. (may be 1 via CONFIG_CMDLINE="skew_tick=1"

Suggest simply:

			0 -- disable (default for typical kernel builds).

With these changes:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> +			1 -- enable.
> +			Note: increases power consumption, thus should only be
> +			enabled if running jitter sensitive (HPC/RT) workloads.
> +
>  	security=	[SECURITY] Choose a security module to enable at boot.
>  			If this boot parameter is not specified, only the first
>  			security module asking for security registration will be
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -814,6 +814,8 @@ static enum hrtimer_restart tick_sched_t
>  	return HRTIMER_RESTART;
>  }
> 
> +static int sched_skew_tick;
> +
>  /**
>   * tick_setup_sched_timer - setup the tick emulation timer
>   */
> @@ -831,6 +833,14 @@ void tick_setup_sched_timer(void)
>  	/* Get the next period (per cpu) */
>  	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
> 
> +	/* Offset the tick to avert xtime_lock contention. */
> +	if (sched_skew_tick) {
> +		u64 offset = ktime_to_ns(tick_period) >> 1;
> +		do_div(offset, num_possible_cpus());
> +		offset *= smp_processor_id();
> +		hrtimer_add_expires_ns(&ts->sched_timer, offset);
> +	}
> +
>  	for (;;) {
>  		hrtimer_forward(&ts->sched_timer, now, tick_period);
>  		hrtimer_start_expires(&ts->sched_timer,
> @@ -910,3 +920,12 @@ int tick_check_oneshot_change(int allow_
>  	tick_nohz_switch_to_nohz();
>  	return 0;
>  }
> +
> +static int __init skew_tick(char *str)
> +{
> +	get_option(&str, &sched_skew_tick);
> +
> +	return 0;
> +}
> +early_param("skew_tick", skew_tick);
> +
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

