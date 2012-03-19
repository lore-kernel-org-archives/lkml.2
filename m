Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab2CSAKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 20:10:24 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44079 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab2CSAKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 20:10:22 -0400
Date: Sun, 18 Mar 2012 17:10:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sivanich@sgi.com
Subject: Re: [PATCH RFC] rcu: Permit limiting of force_quiescent_state()
 latency
Message-ID: <20120319001014.GD2393@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120316160328.GA7207@linux.vnet.ibm.com>
 <1332003451.8147.77.camel@marge.simpson.net>
 <1332082821.7291.27.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332082821.7291.27.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031900-1780-0000-0000-000004114AB1
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000258; HX=3.00000186; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00123218; UDB=6.00029574; UTC=2012-03-19
 00:10:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 04:00:21PM +0100, Mike Galbraith wrote:
> On Sat, 2012-03-17 at 17:57 +0100, Mike Galbraith wrote: 
> 
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1316,47 +1316,72 @@ void rcu_check_callbacks(int cpu, int us
> >   * have not yet encountered a quiescent state, using the function specified.
> >   * Also initiate boosting for any threads blocked on the root rcu_node.
> >   *
> > + * Returns 0 if the scan could not be completed, 1 otherwise.
> >   * The caller must have suppressed start of new grace periods.
> >   */
> > -static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
> > +static int force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
> >  {
> >  	unsigned long bit;
> >  	int cpu;
> > +	int cpusvisited = 0, done = 1;
> >  	unsigned long flags;
> >  	unsigned long mask;
> >  	struct rcu_node *rnp;
> >  
> >  	rcu_for_each_leaf_node(rsp, rnp) {
> > +		if (rnp->grphi < rsp->fqs_next_cpu)
> > +			continue;
> > +		if (rnp->grplo > rcu_get_max_cpu())
> > +			continue;
> 
> ...
> 
> > 		if (mask != 0) {
> >  
> >  			/* rcu_report_qs_rnp() releases rnp->lock. */
> >  			rcu_report_qs_rnp(mask, rsp, rnp, flags);
> > -			continue;
> > +			if (cpusvisited < FQS_MAX_CPU_VISIT)    deadlock: if no continue..
> > +				continue;
> >  		}
> >  		raw_spin_unlock_irqrestore(&rnp->lock, flags);  _thoroughly_ unlock it.
> 
> 
> Boots/runs.  Altered to not bail mid-group.
> 
> I tried a synchronized jitter test on 45 cores, patches made diddly spit
> difference.  There's too much other noise.  Also applied both patches to
> RT, and tested on 60 cores, which also made little if any difference,
> but then jitter is single digit (usecs) running this test with the RT
> kernel already.  With NOPREEMPT kernel, jitter is low triple digit worst
> case with or without patches.

Thank you very much for your efforts on this!!!

Given that you were seeing about 200-microsecond latency spikes on
grace-period initialization, I would expect that you would need about
200 dyntick-idle CPUs for force_quiescent_state() to give you a
ten-microsecond spike, so I am not surprised that you could not see
the difference on 60 CPUs, which probably have given you something
like 3 microseconds..

I will take a closer look at your patch (thank you for posting it!) --
but I still have not given up hope on the CPU-by-CPU approach.

							Thanx, Paul

> ---
>  arch/x86/Kconfig |    4 ++++
>  kernel/rcutree.c |   49 ++++++++++++++++++++++++++++++++++++-------------
>  kernel/rcutree.h |   16 ++++++++++++++++
>  3 files changed, 56 insertions(+), 13 deletions(-)
> 
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -254,6 +254,10 @@ config ARCH_CPU_PROBE_RELEASE
>  	def_bool y
>  	depends on HOTPLUG_CPU && !XEN
> 
> +config ARCH_RCU_FQS_LIMIT
> +	int
> +	default 16
> +
>  source "init/Kconfig"
>  source "kernel/Kconfig.freezer"
> 
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1316,47 +1316,65 @@ void rcu_check_callbacks(int cpu, int us
>   * have not yet encountered a quiescent state, using the function specified.
>   * Also initiate boosting for any threads blocked on the root rcu_node.
>   *
> + * Returns 0 if the scan could not be completed, 1 otherwise.
>   * The caller must have suppressed start of new grace periods.
>   */
> -static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
> +static int force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
>  {
>  	unsigned long bit;
>  	int cpu;
> +	int cpusvisited = 0, done = 1;
>  	unsigned long flags;
>  	unsigned long mask;
>  	struct rcu_node *rnp;
> 
>  	rcu_for_each_leaf_node(rsp, rnp) {
> +		if (rnp->grphi < rsp->fqs_next_cpu)
> +			continue;
> +		if (rnp->grplo > rcu_get_max_cpu())
> +			continue;
>  		mask = 0;
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
>  		if (!rcu_gp_in_progress(rsp)) {
>  			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -			return;
> +			return done;
>  		}
>  		if (rnp->qsmask == 0) {
>  			rcu_initiate_boost(rnp, flags); /* releases rnp->lock */
>  			continue;
>  		}
> -		cpu = rnp->grplo;
>  		bit = 1;
> -		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
> -			if ((rnp->qsmask & bit) != 0 &&
> -			    f(per_cpu_ptr(rsp->rda, cpu)))
> +		rsp->fqs_next_cpu = rnp->grphi + 1;
> +		cpusvisited += rnp->grphi - rnp->grplo;
> +		for (cpu = rnp->grplo; cpu <= rnp->grphi; cpu++, bit <<= 1) {
> +			if ((rnp->qsmask & bit) == 0)
> +				continue;
> +			if (f(per_cpu_ptr(rsp->rda, cpu)))
>  				mask |= bit;
>  		}
> -		if (mask != 0) {
> 
> +		if (mask != 0) {
>  			/* rcu_report_qs_rnp() releases rnp->lock. */
>  			rcu_report_qs_rnp(mask, rsp, rnp, flags);
> -			continue;
> +		} else
> +			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +
> +		if (cpusvisited >= FQS_MAX_CPU_VISIT) {
> +			if (FQS_MAX_CPU_VISIT != NR_CPUS)
> +				done = 0;
> +			break;
>  		}
> -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  	}
>  	rnp = rcu_get_root(rsp);
>  	if (rnp->qsmask == 0) {
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
>  		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
>  	}
> +
> +	if (done)
> +		rsp->fqs_next_cpu = 0;
> +
> +	return done;
>  }
> 
>  /*
> @@ -1366,6 +1384,7 @@ static void force_qs_rnp(struct rcu_stat
>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
>  {
>  	unsigned long flags;
> +	int retval;
>  	struct rcu_node *rnp = rcu_get_root(rsp);
> 
>  	if (!rcu_gp_in_progress(rsp))
> @@ -1398,21 +1417,25 @@ static void force_quiescent_state(struct
>  		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
> 
>  		/* Record dyntick-idle state. */
> -		force_qs_rnp(rsp, dyntick_save_progress_counter);
> +		retval = force_qs_rnp(rsp, dyntick_save_progress_counter);
>  		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
> -		if (rcu_gp_in_progress(rsp))
> +		if (rcu_gp_in_progress(rsp) && retval) {
>  			rsp->signaled = RCU_FORCE_QS;
> +			rsp->fqs_next_cpu = 0;
> +		} else if (rcu_gp_in_progress(rsp))
> +			rsp->jiffies_force_qs = jiffies - 1;
>  		break;
> 
>  	case RCU_FORCE_QS:
> 
>  		/* Check dyntick-idle state, send IPI to laggarts. */
>  		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
> -		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
> +		retval = force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
> 
>  		/* Leave state in case more forcing is required. */
> -
>  		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
> +		if (rcu_gp_in_progress(rsp) && !retval)
> +			rsp->jiffies_force_qs = jiffies - 1;
>  		break;
>  	}
>  	rsp->fqs_active = 0;
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -354,6 +354,21 @@ do {									\
>  } while (0)
> 
>  /*
> + * Large latency-sensitive configurations can limit force_quiescent_state()
> + * latencies by defining an CONFIG_ARCH_RCU_FQS_LIMIT.  This should be
> + * sized based on that architecture's cache-miss latency and the maximum
> + * desired force_quiescent_state latency.  For example, if the cache-miss
> + * latency was 100 nanoseconds, and the maximum force_quiescent_state()
> + * latency contribution was 5 microseconds, then that architecture should
> + * define CONFIG_ARCH_RCU_FQS_LIMIT to be 50.
> + */
> +#ifdef CONFIG_ARCH_RCU_FQS_LIMIT
> +#define FQS_MAX_CPU_VISIT CONFIG_ARCH_RCU_FQS_LIMIT
> +#else /* #ifdef CONFIG_ARCH_RCU_FQS_LIMIT */
> +#define FQS_MAX_CPU_VISIT NR_CPUS
> +#endif /* #else #ifdef CONFIG_ARCH_RCU_FQS_LIMIT */
> +
> +/*
>   * RCU global state, including node hierarchy.  This hierarchy is
>   * represented in "heap" form in a dense array.  The root (first level)
>   * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
> @@ -391,6 +406,7 @@ struct rcu_state {
>  						/*  starting new GP. */
>  	raw_spinlock_t fqslock;			/* Only one task forcing */
>  						/*  quiescent states. */
> +	int fqs_next_cpu;			/* Next CPU for fqs to scan. */
>  	unsigned long jiffies_force_qs;		/* Time at which to invoke */
>  						/*  force_quiescent_state(). */
>  	unsigned long n_force_qs;		/* Number of calls to */
> 
> 

