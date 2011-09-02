Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab1IBITn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:19:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:53321 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab1IBITj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:19:39 -0400
Date: Fri, 2 Sep 2011 10:19:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
In-Reply-To: <20110823195628.GB4533@sgi.com>
Message-ID: <alpine.LFD.2.02.1109021015290.2723@ionos>
References: <20110817160759.GA3482@sgi.com> <alpine.LFD.2.02.1108171819120.2807@ionos> <20110823195628.GB4533@sgi.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Dimitri Sivanich wrote:
> On Wed, Aug 17, 2011 at 06:47:43PM +0200, Thomas Gleixner wrote:
> > On Wed, 17 Aug 2011, Dimitri Sivanich wrote:
> While not necessarily harmful, doing jiffies updates on an application cpu
> does cause some extra overhead that HPC benchmarking people notice.  They
> prefer to have OS activity isolated to certain cpus.  They like reproducibility
> of results, and having jiffies updates bouncing around introduces variability.
> 
> Maybe this is useful for other folks as well?  It does give an indication
> of which cpu is currently doing jiffies updates.
> 
> The patch below puts the file in /proc/sys/kernel, but if you think it should be in
> /sys, please let me know where you'd like to see it.

/sys/devices/system/timekeeping/timekeeping0/....
 
Please

> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> ---
>  include/linux/tick.h        |    5 +++++
>  kernel/sysctl.c             |    9 +++++++++
>  kernel/time/tick-internal.h |    1 -
>  kernel/time/tick-sched.c    |   23 +++++++++++++++++++++++
>  4 files changed, 37 insertions(+), 1 deletion(-)
> 
> Index: linux/kernel/sysctl.c
> ===================================================================
> --- linux.orig/kernel/sysctl.c
> +++ linux/kernel/sysctl.c
> @@ -57,6 +57,7 @@
>  #include <linux/pipe_fs_i.h>
>  #include <linux/oom.h>
>  #include <linux/kmod.h>
> +#include <linux/tick.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/processor.h>
> @@ -368,6 +369,14 @@ static struct ctl_table kern_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= sched_rt_handler,
>  	},
> +	{
> +		.procname	= "sched_jiffies_cpu",
> +		.data		= &tick_do_timer_cpu,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= tick_do_timer_cpu_handler,
> +		.extra1		= &zero,
> +	},
>  #ifdef CONFIG_SCHED_AUTOGROUP
>  	{
>  		.procname	= "sched_autogroup_enabled",
> Index: linux/include/linux/tick.h
> ===================================================================
> --- linux.orig/include/linux/tick.h
> +++ linux/include/linux/tick.h
> @@ -72,6 +72,11 @@ struct tick_sched {
>  extern void __init tick_init(void);
>  extern int tick_is_oneshot_available(void);
>  extern struct tick_device *tick_get_device(int cpu);
> +extern int tick_do_timer_cpu_handler(struct ctl_table *table, int write,
> +				 void __user *buffer, size_t *lenp,
> +				 loff_t *ppos);
> +
> +extern int tick_do_timer_cpu __read_mostly;
>  
>  # ifdef CONFIG_HIGH_RES_TIMERS
>  extern int tick_init_highres(void);
> Index: linux/kernel/time/tick-sched.c
> ===================================================================
> --- linux.orig/kernel/time/tick-sched.c
> +++ linux/kernel/time/tick-sched.c
> @@ -815,6 +815,29 @@ void tick_cancel_sched_timer(int cpu)
>  }
>  #endif
>  
> +int tick_do_timer_cpu_handler(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	int ret, old_val;
> +
> +#ifdef CONFIG_NO_HZ
> +	/* nohz mode not supported */
> +	if (write && tick_nohz_enabled)
> +		return -EINVAL;
> +#endif
> +
> +	old_val = tick_do_timer_cpu;
> +
> +	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +
> +	if (!ret && write && !cpu_online(tick_do_timer_cpu)) {
> +		tick_do_timer_cpu = old_val;
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
>  /**
>   * Async notification about clocksource changes
>   */
> Index: linux/kernel/time/tick-internal.h
> ===================================================================
> --- linux.orig/kernel/time/tick-internal.h
> +++ linux/kernel/time/tick-internal.h
> @@ -12,7 +12,6 @@
>  DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
>  extern ktime_t tick_next_period;
>  extern ktime_t tick_period;
> -extern int tick_do_timer_cpu __read_mostly;
>  
>  extern void tick_setup_periodic(struct clock_event_device *dev, int broadcast);
>  extern void tick_handle_periodic(struct clock_event_device *dev);
> 
