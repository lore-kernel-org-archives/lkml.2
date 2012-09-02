Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2IBCLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 22:11:32 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56517 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2IBCLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 22:11:31 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 19:11:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 06/23] rcu: Break up rcu_gp_kthread() into
 subfunctions
Message-ID: <20120902021121.GF5713@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:21AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Then rcu_gp_kthread() function is too large and furthermore needs to
> have the force_quiescent_state() code pulled in.  This commit therefore
> breaks up rcu_gp_kthread() into rcu_gp_init() and rcu_gp_cleanup().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |  260 +++++++++++++++++++++++++++++-------------------------
>  1 files changed, 138 insertions(+), 122 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 84a6f55..c2c036f 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1040,160 +1040,176 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
>  }
>  
>  /*
> - * Body of kthread that handles grace periods.
> + * Initialize a new grace period.
>   */
> -static int rcu_gp_kthread(void *arg)
> +static int rcu_gp_init(struct rcu_state *rsp)
>  {
>  	unsigned long flags;
> -	unsigned long gp_duration;
>  	struct rcu_data *rdp;
> -	struct rcu_node *rnp;
> -	struct rcu_state *rsp = arg;
> +	struct rcu_node *rnp = rcu_get_root(rsp);
>  
> -	for (;;) {
> +	raw_spin_lock_irqsave(&rnp->lock, flags);
> +	rsp->gp_flags = 0;
>  
> -		/* Handle grace-period start. */
> -		rnp = rcu_get_root(rsp);
> -		for (;;) {
> -			wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
> -			if (rsp->gp_flags)
> -				break;
> -			flush_signals(current);
> -		}
> +	if (rcu_gp_in_progress(rsp)) {
> +		/* Grace period already in progress, don't start another. */
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		return 0;
> +	}
> +
> +	if (rsp->fqs_active) {
> +		/*
> +		 * We need a grace period, but force_quiescent_state()
> +		 * is running.  Tell it to start one on our behalf.
> +		 */
> +		rsp->fqs_need_gp = 1;
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		return 0;
> +	}
> +
> +	/* Advance to a new grace period and initialize state. */
> +	rsp->gpnum++;
> +	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
> +	WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
> +	rsp->fqs_state = RCU_GP_INIT; /* Stop force_quiescent_state. */
> +	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
> +	record_gp_stall_check_time(rsp);
> +	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +
> +	/* Exclude any concurrent CPU-hotplug operations. */
> +	get_online_cpus();
> +
> +	/*
> +	 * Set the quiescent-state-needed bits in all the rcu_node
> +	 * structures for all currently online CPUs in breadth-first order,
> +	 * starting from the root rcu_node structure, relying on the layout
> +	 * of the tree within the rsp->node[] array.  Note that other CPUs
> +	 * access only the leaves of the hierarchy, thus seeing that no
> +	 * grace period is in progress, at least until the corresponding
> +	 * leaf node has been initialized.  In addition, we have excluded
> +	 * CPU-hotplug operations.
> +	 *
> +	 * The grace period cannot complete until the initialization
> +	 * process finishes, because this kthread handles both.
> +	 */
> +	rcu_for_each_node_breadth_first(rsp, rnp) {
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
> -		rsp->gp_flags = 0;
>  		rdp = this_cpu_ptr(rsp->rda);
> +		rcu_preempt_check_blocked_tasks(rnp);
> +		rnp->qsmask = rnp->qsmaskinit;
> +		rnp->gpnum = rsp->gpnum;
> +		rnp->completed = rsp->completed;
> +		if (rnp == rdp->mynode)
> +			rcu_start_gp_per_cpu(rsp, rnp, rdp);
> +		rcu_preempt_boost_start_gp(rnp);
> +		trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
> +					    rnp->level, rnp->grplo,
> +					    rnp->grphi, rnp->qsmask);
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		cond_resched();
> +	}
>  
> -		if (rcu_gp_in_progress(rsp)) {
> -			/*
> -			 * A grace period is already in progress, so
> -			 * don't start another one.
> -			 */
> -			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -			cond_resched();
> -			continue;
> -		}
> +	rnp = rcu_get_root(rsp);
> +	raw_spin_lock_irqsave(&rnp->lock, flags);
> +	/* force_quiescent_state() now OK. */
> +	rsp->fqs_state = RCU_SIGNAL_INIT;
> +	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	put_online_cpus();
>  
> -		if (rsp->fqs_active) {
> -			/*
> -			 * We need a grace period, but force_quiescent_state()
> -			 * is running.  Tell it to start one on our behalf.
> -			 */
> -			rsp->fqs_need_gp = 1;
> -			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -			cond_resched();
> -			continue;
> -		}
> +	return 1;
> +}
>  
> -		/* Advance to a new grace period and initialize state. */
> -		rsp->gpnum++;
> -		trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
> -		WARN_ON_ONCE(rsp->fqs_state == RCU_GP_INIT);
> -		rsp->fqs_state = RCU_GP_INIT; /* Stop force_quiescent_state. */
> -		rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
> -		record_gp_stall_check_time(rsp);
> -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +/*
> + * Clean up after the old grace period.
> + */
> +static int rcu_gp_cleanup(struct rcu_state *rsp)
> +{
> +	unsigned long flags;
> +	unsigned long gp_duration;
> +	struct rcu_data *rdp;
> +	struct rcu_node *rnp = rcu_get_root(rsp);
>  
> -		/* Exclude any concurrent CPU-hotplug operations. */
> -		get_online_cpus();
> +	raw_spin_lock_irqsave(&rnp->lock, flags);
> +	gp_duration = jiffies - rsp->gp_start;
> +	if (gp_duration > rsp->gp_max)
> +		rsp->gp_max = gp_duration;
> +
> +	/*
> +	 * We know the grace period is complete, but to everyone else
> +	 * it appears to still be ongoing.  But it is also the case
> +	 * that to everyone else it looks like there is nothing that
> +	 * they can do to advance the grace period.  It is therefore
> +	 * safe for us to drop the lock in order to mark the grace
> +	 * period as completed in all of the rcu_node structures.
> +	 *
> +	 * But if this CPU needs another grace period, it will take
> +	 * care of this while initializing the next grace period.
> +	 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
> +	 * because the callbacks have not yet been advanced: Those
> +	 * callbacks are waiting on the grace period that just now
> +	 * completed.
> +	 */
> +	rdp = this_cpu_ptr(rsp->rda);
> +	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  
>  		/*
> -		 * Set the quiescent-state-needed bits in all the rcu_node
> -		 * structures for all currently online CPUs in breadth-first
> -		 * order, starting from the root rcu_node structure.
> -		 * This operation relies on the layout of the hierarchy
> -		 * within the rsp->node[] array.  Note that other CPUs will
> -		 * access only the leaves of the hierarchy, which still
> -		 * indicate that no grace period is in progress, at least
> -		 * until the corresponding leaf node has been initialized.
> -		 * In addition, we have excluded CPU-hotplug operations.
> -		 *
> -		 * Note that the grace period cannot complete until
> -		 * we finish the initialization process, as there will
> -		 * be at least one qsmask bit set in the root node until
> -		 * that time, namely the one corresponding to this CPU,
> -		 * due to the fact that we have irqs disabled.
> +		 * Propagate new ->completed value to rcu_node
> +		 * structures so that other CPUs don't have to
> +		 * wait until the start of the next grace period
> +		 * to process their callbacks.
>  		 */
>  		rcu_for_each_node_breadth_first(rsp, rnp) {
>  			raw_spin_lock_irqsave(&rnp->lock, flags);
> -			rcu_preempt_check_blocked_tasks(rnp);
> -			rnp->qsmask = rnp->qsmaskinit;
> -			rnp->gpnum = rsp->gpnum;
> -			rnp->completed = rsp->completed;
> -			if (rnp == rdp->mynode)
> -				rcu_start_gp_per_cpu(rsp, rnp, rdp);
> -			rcu_preempt_boost_start_gp(rnp);
> -			trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
> -						    rnp->level, rnp->grplo,
> -						    rnp->grphi, rnp->qsmask);
> +			rnp->completed = rsp->gpnum;
>  			raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  			cond_resched();
>  		}
> -
>  		rnp = rcu_get_root(rsp);
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
> -		/* force_quiescent_state() now OK. */
> -		rsp->fqs_state = RCU_SIGNAL_INIT;
> -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -		put_online_cpus();
> +	}
> +
> +	rsp->completed = rsp->gpnum; /* Declare grace period done. */
> +	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
> +	rsp->fqs_state = RCU_GP_IDLE;
> +	rdp = this_cpu_ptr(rsp->rda);
> +	if (cpu_needs_another_gp(rsp, rdp))
> +		rsp->gp_flags = 1;
> +	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	return 1;
> +}
> +
> +/*
> + * Body of kthread that handles grace periods.
> + */
> +static int rcu_gp_kthread(void *arg)
> +{
> +	struct rcu_state *rsp = arg;
> +	struct rcu_node *rnp = rcu_get_root(rsp);
> +
> +	for (;;) {
> +
> +		/* Handle grace-period start. */
> +		for (;;) {
> +			wait_event_interruptible(rsp->gp_wq, rsp->gp_flags);
> +			if (rsp->gp_flags && rcu_gp_init(rsp))
> +				break;
> +			cond_resched();
> +			flush_signals(current);
> +		}
>  
>  		/* Handle grace-period end. */
> -		rnp = rcu_get_root(rsp);
>  		for (;;) {
>  			wait_event_interruptible(rsp->gp_wq,
>  						 !ACCESS_ONCE(rnp->qsmask) &&
>  						 !rcu_preempt_blocked_readers_cgp(rnp));
>  			if (!ACCESS_ONCE(rnp->qsmask) &&
> -			    !rcu_preempt_blocked_readers_cgp(rnp))
> +			    !rcu_preempt_blocked_readers_cgp(rnp) &&
> +			    rcu_gp_cleanup(rsp))
>  				break;
> +			cond_resched();
>  			flush_signals(current);
>  		}
> -
> -		raw_spin_lock_irqsave(&rnp->lock, flags);
> -		gp_duration = jiffies - rsp->gp_start;
> -		if (gp_duration > rsp->gp_max)
> -			rsp->gp_max = gp_duration;
> -
> -		/*
> -		 * We know the grace period is complete, but to everyone else
> -		 * it appears to still be ongoing.  But it is also the case
> -		 * that to everyone else it looks like there is nothing that
> -		 * they can do to advance the grace period.  It is therefore
> -		 * safe for us to drop the lock in order to mark the grace
> -		 * period as completed in all of the rcu_node structures.
> -		 *
> -		 * But if this CPU needs another grace period, it will take
> -		 * care of this while initializing the next grace period.
> -		 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
> -		 * because the callbacks have not yet been advanced: Those
> -		 * callbacks are waiting on the grace period that just now
> -		 * completed.
> -		 */
> -		if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
> -			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -
> -			/*
> -			 * Propagate new ->completed value to rcu_node
> -			 * structures so that other CPUs don't have to
> -			 * wait until the start of the next grace period
> -			 * to process their callbacks.
> -			 */
> -			rcu_for_each_node_breadth_first(rsp, rnp) {
> -				raw_spin_lock_irqsave(&rnp->lock, flags);
> -				rnp->completed = rsp->gpnum;
> -				raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -				cond_resched();
> -			}
> -			rnp = rcu_get_root(rsp);
> -			raw_spin_lock_irqsave(&rnp->lock, flags);
> -		}
> -
> -		rsp->completed = rsp->gpnum; /* Declare grace period done. */
> -		trace_rcu_grace_period(rsp->name, rsp->completed, "end");
> -		rsp->fqs_state = RCU_GP_IDLE;
> -		if (cpu_needs_another_gp(rsp, rdp))
> -			rsp->gp_flags = 1;
> -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  	}
>  	return 0;
>  }
> -- 
> 1.7.8
> 
