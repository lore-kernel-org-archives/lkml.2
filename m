Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2CPRwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 13:52:33 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39145 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab2CPRwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 13:52:30 -0400
Date: Fri, 16 Mar 2012 10:51:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] rcu: Limit GP initialization to CPUs that have been
 online
Message-ID: <20120316175142.GG2408@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120314130801.GA11722@sgi.com>
 <20120314151717.GA2435@linux.vnet.ibm.com>
 <20120314165657.GA19117@linux.vnet.ibm.com>
 <1331779343.14263.6.camel@marge.simpson.net>
 <1331780831.14263.15.camel@marge.simpson.net>
 <20120315175933.GB8705@sgi.com>
 <1331882861.11010.13.camel@marge.simpson.net>
 <1331885384.11010.15.camel@marge.simpson.net>
 <1331887535.11010.18.camel@marge.simpson.net>
 <20120316172850.GC31290@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120316172850.GC31290@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031617-4242-0000-0000-000001121F5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:28:50PM -0500, Dimitri Sivanich wrote:
> On Fri, Mar 16, 2012 at 09:45:35AM +0100, Mike Galbraith wrote:
> > On Fri, 2012-03-16 at 09:09 +0100, Mike Galbraith wrote: 
> > > On Fri, 2012-03-16 at 08:27 +0100, Mike Galbraith wrote: 
> > > > On Thu, 2012-03-15 at 12:59 -0500, Dimitri Sivanich wrote: 
> > 
> > > > > Could I try your 3.0 enterprise patch?
> > > > 
> > > > Sure, v3 below.
> > > 
> > > Erm, a bit of that went missing.  I'll put it back.
> > 
> > OK, box finally finished rebuild/boot.
> > 
> 
> This patch also shows great improvement in the two
> rcu_for_each_node_breadth_first() (nothing over 20 usec and most less than
> 10 in initial testing).
> 
> However, there are spinlock holdoffs at the following tracebacks (my nmi
> handler does work on the 3.0 kernel):
> 
> [  584.157019]  [<ffffffff8144c5a0>] nmi+0x20/0x30
> [  584.157023]  [<ffffffff8144bc8a>] _raw_spin_lock_irqsave+0x1a/0x30
> [  584.157026]  [<ffffffff810c5f18>] force_qs_rnp+0x58/0x170

This is a holdoff, not a deadlock hang, correct?

If so...

Presumably this is the last raw_spin_lock_irqsave() in force_qs_rnp(),
the one right before the call to rcu_initiate_boost().  Could you please
verify for me?

If so, someone is holding the root rcu_node structure's lock for longer
than is good.  Or that there is significant contention on that lock,
which there might well be on large configurations.  Any info on who
is holding or contending for this lock would be very helpful!

Are you running TREE_RCU or TREE_PREEMPT_RCU?

							Thanx, Paul

> [  584.157030]  [<ffffffff810c6192>] force_quiescent_state+0x162/0x1d0
> [  584.157033]  [<ffffffff810c6c95>] __rcu_process_callbacks+0x165/0x200
> [  584.157037]  [<ffffffff810c6d4d>] rcu_process_callbacks+0x1d/0x80
> [  584.157041]  [<ffffffff81061eaf>] __do_softirq+0xef/0x220
> [  584.157044]  [<ffffffff81454cbc>] call_softirq+0x1c/0x30
> [  584.157048]  [<ffffffff810043a5>] do_softirq+0x65/0xa0
> [  584.157051]  [<ffffffff81061c85>] irq_exit+0xb5/0xe0
> [  584.157054]  [<ffffffff810212c8>] smp_apic_timer_interrupt+0x68/0xa0
> [  584.157057]  [<ffffffff81454473>] apic_timer_interrupt+0x13/0x20
> [  584.157061]  [<ffffffff8102b352>] native_safe_halt+0x2/0x10
> [  584.157064]  [<ffffffff8100adf5>] default_idle+0x145/0x150
> [  584.157067]  [<ffffffff810020c6>] cpu_idle+0x66/0xc0
> 
> > 
> > rcu: Limit GP initialization to CPUs that have been online
> > 
> > The current grace-period initialization initializes all leaf rcu_node
> > structures, even those corresponding to CPUs that have never been online.
> > This is harmless in many configurations, but results in 200-microsecond
> > latency spikes for kernels built with NR_CPUS=4096.
> > 
> > This commit therefore keeps track of the largest-numbered CPU that has
> > ever been online, and limits grace-period initialization to rcu_node
> > structures corresponding to that CPU and to smaller-numbered CPUs.
> > 
> > Reported-by: Dimitri Sivanich <sivanich@sgi.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Acked-by: Mike Galbraith <mgalbraith@suse.de>
> > 
> > ---
> >  kernel/rcutree.c |   36 ++++++++++++++++++++++++++++++++----
> >  kernel/rcutree.h |   16 ++++++++++++++--
> >  2 files changed, 46 insertions(+), 6 deletions(-)
> > 
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -84,6 +84,8 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_d
> >  
> >  static struct rcu_state *rcu_state;
> >  
> > +int rcu_max_cpu __read_mostly;	/* Largest # CPU that has ever been online. */
> > +
> >  /*
> >   * The rcu_scheduler_active variable transitions from zero to one just
> >   * before the first task is spawned.  So when this variable is zero, RCU
> > @@ -827,25 +829,31 @@ rcu_start_gp(struct rcu_state *rsp, unsi
> >  	struct rcu_node *rnp = rcu_get_root(rsp);
> >  
> >  	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
> > +		struct rcu_node *rnp_root = rnp;
> > +
> >  		if (cpu_needs_another_gp(rsp, rdp))
> >  			rsp->fqs_need_gp = 1;
> >  		if (rnp->completed == rsp->completed) {
> > -			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +			raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
> >  			return;
> >  		}
> > -		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
> >  
> >  		/*
> >  		 * Propagate new ->completed value to rcu_node structures
> >  		 * so that other CPUs don't have to wait until the start
> >  		 * of the next grace period to process their callbacks.
> > +		 * We must hold the root rcu_node structure's ->lock
> > +		 * across rcu_for_each_node_breadth_first() in order to
> > +		 * synchronize with CPUs coming online for the first time.
> >  		 */
> >  		rcu_for_each_node_breadth_first(rsp, rnp) {
> > +			raw_spin_unlock(&rnp_root->lock); /* remain disabled. */
> >  			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
> >  			rnp->completed = rsp->completed;
> >  			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
> > +			raw_spin_lock(&rnp_root->lock); /* already disabled. */
> >  		}
> > -		local_irq_restore(flags);
> > +		raw_spin_unlock_irqrestore(&rnp_root->lock, flags);
> >  		return;
> >  	}
> >  
> > @@ -935,7 +943,7 @@ static void rcu_report_qs_rsp(struct rcu
> >  		rsp->gp_max = gp_duration;
> >  	rsp->completed = rsp->gpnum;
> >  	rsp->signaled = RCU_GP_IDLE;
> > -	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
> > +	rcu_start_gp(rsp, flags);  /* releases root node's ->lock. */
> >  }
> >  
> >  /*
> > @@ -1862,6 +1870,7 @@ rcu_init_percpu_data(int cpu, struct rcu
> >  	unsigned long mask;
> >  	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
> >  	struct rcu_node *rnp = rcu_get_root(rsp);
> > +	struct rcu_node *rnp_init;
> >  
> >  	/* Set up local state, ensuring consistent view of global state. */
> >  	raw_spin_lock_irqsave(&rnp->lock, flags);
> > @@ -1882,6 +1891,20 @@ rcu_init_percpu_data(int cpu, struct rcu
> >  	/* Exclude any attempts to start a new GP on large systems. */
> >  	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
> >  
> > +	/*
> > +	 * Initialize any rcu_node structures that will see their first use.
> > +	 * Note that rcu_max_cpu cannot change out from under us because the
> > +	 * hotplug locks are held.
> > +	 */
> > +	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
> > +	for (rnp_init = per_cpu_ptr(rsp->rda, rcu_max_cpu)->mynode + 1;
> > +	     rnp_init <= rdp->mynode;
> > +	     rnp_init++) {
> > +		rnp_init->gpnum = rsp->gpnum;
> > +		rnp_init->completed = rsp->completed;
> > +	}
> > +	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
> > +
> >  	/* Add CPU to rcu_node bitmasks. */
> >  	rnp = rdp->mynode;
> >  	mask = rdp->grpmask;
> > @@ -1907,6 +1930,11 @@ static void __cpuinit rcu_prepare_cpu(in
> >  	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
> >  	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
> >  	rcu_preempt_init_percpu_data(cpu);
> > +	if (cpu > rcu_max_cpu) {
> > +		smp_mb(); /* Initialization before rcu_max_cpu assignment. */
> > +		rcu_max_cpu = cpu;
> > +		smp_mb(); /* rcu_max_cpu assignment before later uses. */
> > +	}
> >  }
> >  
> >  /*
> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -191,11 +191,23 @@ struct rcu_node {
> >  
> >  /*
> >   * Do a full breadth-first scan of the rcu_node structures for the
> > - * specified rcu_state structure.
> > + * specified rcu_state structure.  The caller must hold either the
> > + * ->onofflock or the root rcu_node structure's ->lock.
> >   */
> > +extern int rcu_max_cpu;
> > +static inline int rcu_get_max_cpu(void)
> > +{
> > +	int ret;
> > +
> > +	smp_mb();  /* Pairs with barriers in rcu_prepare_cpu(). */
> > +	ret = rcu_max_cpu;
> > +	smp_mb();  /* Pairs with barriers in rcu_prepare_cpu(). */
> > +	return ret;
> > +}
> >  #define rcu_for_each_node_breadth_first(rsp, rnp) \
> >  	for ((rnp) = &(rsp)->node[0]; \
> > -	     (rnp) < &(rsp)->node[NUM_RCU_NODES]; (rnp)++)
> > +	     (rnp) <= per_cpu_ptr((rsp)->rda, rcu_get_max_cpu())->mynode; \
> > +	     (rnp)++)
> >  
> >  /*
> >   * Do a breadth-first scan of the non-leaf rcu_node structures for the
> > 
> 

