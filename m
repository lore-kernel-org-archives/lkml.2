Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab2CVUYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:24:24 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40190 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755954Ab2CVUYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:24:21 -0400
Date: Thu, 22 Mar 2012 15:24:18 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Mike Galbraith <efault@gmx.de>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have
 been online
Message-ID: <20120322202418.GA8569@sgi.com>
References: <20120314151717.GA2435@linux.vnet.ibm.com>
 <20120314165657.GA19117@linux.vnet.ibm.com>
 <1331779343.14263.6.camel@marge.simpson.net>
 <1331780831.14263.15.camel@marge.simpson.net>
 <20120315175933.GB8705@sgi.com>
 <1331882861.11010.13.camel@marge.simpson.net>
 <1331885384.11010.15.camel@marge.simpson.net>
 <1331887535.11010.18.camel@marge.simpson.net>
 <20120316172850.GC31290@sgi.com>
 <1332430533.11517.75.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332430533.11517.75.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 04:35:33PM +0100, Mike Galbraith wrote:
> On Fri, 2012-03-16 at 12:28 -0500, Dimitri Sivanich wrote: 
> > On Fri, Mar 16, 2012 at 09:45:35AM +0100, Mike Galbraith wrote:
> > > On Fri, 2012-03-16 at 09:09 +0100, Mike Galbraith wrote: 
> > > > On Fri, 2012-03-16 at 08:27 +0100, Mike Galbraith wrote: 
> > > > > On Thu, 2012-03-15 at 12:59 -0500, Dimitri Sivanich wrote: 
> > > 
> > > > > > Could I try your 3.0 enterprise patch?
> > > > > 
> > > > > Sure, v3 below.
> > > > 
> > > > Erm, a bit of that went missing.  I'll put it back.
> > > 
> > > OK, box finally finished rebuild/boot.
> > > 
> > 
> > This patch also shows great improvement in the two
> > rcu_for_each_node_breadth_first() (nothing over 20 usec and most less than
> > 10 in initial testing).
> > 
> > However, there are spinlock holdoffs at the following tracebacks (my nmi
> > handler does work on the 3.0 kernel):
> > 
> > [  584.157019]  [<ffffffff8144c5a0>] nmi+0x20/0x30
> > [  584.157023]  [<ffffffff8144bc8a>] _raw_spin_lock_irqsave+0x1a/0x30
> > [  584.157026]  [<ffffffff810c5f18>] force_qs_rnp+0x58/0x170
> > [  584.157030]  [<ffffffff810c6192>] force_quiescent_state+0x162/0x1d0
> > [  584.157033]  [<ffffffff810c6c95>] __rcu_process_callbacks+0x165/0x200
> > [  584.157037]  [<ffffffff810c6d4d>] rcu_process_callbacks+0x1d/0x80
> > [  584.157041]  [<ffffffff81061eaf>] __do_softirq+0xef/0x220
> > [  584.157044]  [<ffffffff81454cbc>] call_softirq+0x1c/0x30
> > [  584.157048]  [<ffffffff810043a5>] do_softirq+0x65/0xa0
> > [  584.157051]  [<ffffffff81061c85>] irq_exit+0xb5/0xe0
> > [  584.157054]  [<ffffffff810212c8>] smp_apic_timer_interrupt+0x68/0xa0
> > [  584.157057]  [<ffffffff81454473>] apic_timer_interrupt+0x13/0x20
> > [  584.157061]  [<ffffffff8102b352>] native_safe_halt+0x2/0x10
> > [  584.157064]  [<ffffffff8100adf5>] default_idle+0x145/0x150
> > [  584.157067]  [<ffffffff810020c6>] cpu_idle+0x66/0xc0
> 
> Care to try this?  There's likely a better way to defeat ->qsmask == 0
> take/release all locks thingy, however, if Paul can safely bail in
> force_qs_rnp() in tweakable latency for big boxen patch, I should be
> able to safely (and shamelessly) steal that, and should someone hotplug
> a CPU, and we race, do the same thing bail for small boxen.

Tested on a 48 cpu UV system with an interrupt latency test on isolated
cpus and a moderate to heavy load on the rest of the system.

This patch appears to take care of all excessive (> 35 usec) RCU-based
latency in the 3.0 kernel on this particular system for this particular
setup.  Without the patch, I see many latencies on this system > 150 usec
(and some > 200 usec).

> 
> (RCU Sherrif Paul may foil that dastardly deed...)
> 
> I decided I should sit on the rmp_root lock in the first loop as well. 
> 
> ---
>  kernel/rcutree.c |   78 +++++++++++++++++++++++++++++++++++++++++++------------
>  kernel/rcutree.h |   16 +++++++++--
>  2 files changed, 76 insertions(+), 18 deletions(-)
> 
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -84,6 +84,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_d
>  
>  static struct rcu_state *rcu_state;
>  
> +int rcu_max_cpu __read_mostly;	/* Largest # CPU that has ever been online. */
> +
>  /*
>   * The rcu_scheduler_active variable transitions from zero to one just
>   * before the first task is spawned.  So when this variable is zero, RCU
> @@ -827,25 +829,33 @@ rcu_start_gp(struct rcu_state *rsp, unsi
>  	struct rcu_node *rnp = rcu_get_root(rsp);
>  
>  	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
> +		struct rcu_node *rnp_root = rnp;
> +
>  		if (cpu_needs_another_gp(rsp, rdp))
>  			rsp->fqs_need_gp = 1;
>  		if (rnp->completed == rsp->completed) {
> -			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +			raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
>  			return;
>  		}
> -		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
>  
>  		/*
>  		 * Propagate new ->completed value to rcu_node structures
>  		 * so that other CPUs don't have to wait until the start
>  		 * of the next grace period to process their callbacks.
> +		 * We must hold the root rcu_node structure's ->lock
> +		 * across rcu_for_each_node_breadth_first() in order to
> +		 * synchronize with CPUs coming online for the first time.
>  		 */
>  		rcu_for_each_node_breadth_first(rsp, rnp) {
> +			if (rnp == rnp_root) {
> +				rnp->completed = rsp->completed;
> +				continue;
> +			}
>  			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
>  			rnp->completed = rsp->completed;
>  			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
>  		}
> -		local_irq_restore(flags);
> +		raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
>  		return;
>  	}
>  
> @@ -935,7 +945,7 @@ static void rcu_report_qs_rsp(struct rcu
>  		rsp->gp_max = gp_duration;
>  	rsp->completed = rsp->gpnum;
>  	rsp->signaled = RCU_GP_IDLE;
> -	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
> +	rcu_start_gp(rsp, flags);  /* releases root node's ->lock. */
>  }
>  
>  /*
> @@ -1310,45 +1320,57 @@ void rcu_check_callbacks(int cpu, int us
>   *
>   * The caller must have suppressed start of new grace periods.
>   */
> -static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
> +static int force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
>  {
>  	unsigned long bit;
> -	int cpu;
> +	int cpu = 0, max_cpu = rcu_max_cpu, done;
>  	unsigned long flags;
>  	unsigned long mask;
>  	struct rcu_node *rnp;
>  
>  	rcu_for_each_leaf_node(rsp, rnp) {
> -		mask = 0;
> +		if (cpu > max_cpu)
> +			break;
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
>  		if (!rcu_gp_in_progress(rsp)) {
>  			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -			return;
> +			return 1;
>  		}
>  		if (rnp->qsmask == 0) {
>  			rcu_initiate_boost(rnp, flags); /* releases rnp->lock */
>  			continue;
>  		}
> +
>  		cpu = rnp->grplo;
>  		bit = 1;
> +		mask = 0;
>  		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
> +			if (cpu > max_cpu)
> +				break;
>  			if ((rnp->qsmask & bit) != 0 &&
>  			    f(per_cpu_ptr(rsp->rda, cpu)))
>  				mask |= bit;
>  		}
>  		if (mask != 0) {
> -
>  			/* rcu_report_qs_rnp() releases rnp->lock. */
>  			rcu_report_qs_rnp(mask, rsp, rnp, flags);
>  			continue;
>  		}
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  	}
> +
>  	rnp = rcu_get_root(rsp);
> -	if (rnp->qsmask == 0) {
> -		raw_spin_lock_irqsave(&rnp->lock, flags);
> +	raw_spin_lock_irqsave(&rnp->lock, flags);
> +
> +	/* If we raced with hotplug, ask for a repeat. */
> +	done = max_cpu == rcu_get_max_cpu();
> +
> +	if (rnp->qsmask == 0)
>  		rcu_initiate_boost(rnp, flags); /* releases rnp->lock. */
> -	}
> +	else
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +
> +	return done;
>  }
>  
>  /*
> @@ -1359,6 +1381,7 @@ static void force_quiescent_state(struct
>  {
>  	unsigned long flags;
>  	struct rcu_node *rnp = rcu_get_root(rsp);
> +	int retval;
>  
>  	if (!rcu_gp_in_progress(rsp))
>  		return;  /* No grace period in progress, nothing to force. */
> @@ -1390,21 +1413,24 @@ static void force_quiescent_state(struct
>  		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
>  
>  		/* Record dyntick-idle state. */
> -		force_qs_rnp(rsp, dyntick_save_progress_counter);
> +		retval = force_qs_rnp(rsp, dyntick_save_progress_counter);
>  		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
> -		if (rcu_gp_in_progress(rsp))
> +		if (rcu_gp_in_progress(rsp) && retval)
>  			rsp->signaled = RCU_FORCE_QS;
> +		else if (rcu_gp_in_progress(rsp))
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
> @@ -1862,6 +1888,7 @@ rcu_init_percpu_data(int cpu, struct rcu
>  	unsigned long mask;
>  	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
>  	struct rcu_node *rnp = rcu_get_root(rsp);
> +	struct rcu_node *rnp_init;
>  
>  	/* Set up local state, ensuring consistent view of global state. */
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
> @@ -1882,6 +1909,20 @@ rcu_init_percpu_data(int cpu, struct rcu
>  	/* Exclude any attempts to start a new GP on large systems. */
>  	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
>  
> +	/*
> +	 * Initialize any rcu_node structures that will see their first use.
> +	 * Note that rcu_max_cpu cannot change out from under us because the
> +	 * hotplug locks are held.
> +	 */
> +	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
> +	for (rnp_init = per_cpu_ptr(rsp->rda, rcu_max_cpu)->mynode + 1;
> +	     rnp_init <= rdp->mynode;
> +	     rnp_init++) {
> +		rnp_init->gpnum = rsp->gpnum;
> +		rnp_init->completed = rsp->completed;
> +	}
> +	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
> +
>  	/* Add CPU to rcu_node bitmasks. */
>  	rnp = rdp->mynode;
>  	mask = rdp->grpmask;
> @@ -1907,6 +1948,11 @@ static void __cpuinit rcu_prepare_cpu(in
>  	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
>  	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
>  	rcu_preempt_init_percpu_data(cpu);
> +	if (cpu > rcu_max_cpu) {
> +		smp_mb(); /* Initialization before rcu_max_cpu assignment. */
> +		rcu_max_cpu = cpu;
> +		smp_mb(); /* rcu_max_cpu assignment before later uses. */
> +	}
>  }
>  
>  /*
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -191,11 +191,23 @@ struct rcu_node {
>  
>  /*
>   * Do a full breadth-first scan of the rcu_node structures for the
> - * specified rcu_state structure.
> + * specified rcu_state structure.  The caller must hold either the
> + * ->onofflock or the root rcu_node structure's ->lock.
>   */
> +extern int rcu_max_cpu;
> +static inline int rcu_get_max_cpu(void)
> +{
> +	int ret;
> +
> +	smp_mb();  /* Pairs with barriers in rcu_prepare_cpu(). */
> +	ret = rcu_max_cpu;
> +	smp_mb();  /* Pairs with barriers in rcu_prepare_cpu(). */
> +	return ret;
> +}
>  #define rcu_for_each_node_breadth_first(rsp, rnp) \
>  	for ((rnp) = &(rsp)->node[0]; \
> -	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
> +	     (rnp) <= per_cpu_ptr((rsp)->rda, rcu_get_max_cpu())->mynode; \
> +	     (rnp)++)
>  
>  /*
>   * Do a breadth-first scan of the non-leaf rcu_node structures for the
> 
