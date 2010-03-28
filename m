Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab0C1EW5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 00:22:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60763 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab0C1EWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 00:22:55 -0400
Date: Sat, 27 Mar 2010 21:22:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: check dynticks idle cpu when start gp
Message-ID: <20100328042250.GS2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BAECDA0.6050300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAECDA0.6050300@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 11:31:44AM +0800, Lai Jiangshan wrote:
> 
> Currently, if there are/is dynticks idle CPU(s), GPs
> can not end until we force_quiescent_state().
> It means we delay our GP frequently.
> It also means we do non-fastpath work(force QS) frequently.
> 
> This patch add a _hint_ mask to struct rcu_node, and
> check dynticks idle cpu when start gp.

My concern with this one is that it requires the initialization phase
to look at a large number of rcu_data and rcu_dynticks structures, which
would give us a large latency hit.  Now we -might- take this hit later
should we need to invoke force_quiescent_state(), but if the machine is
fully busy, even that won't happen.

So I have to pass on this one, sorry!

And I do have a patch that controls the latency of force_quiescent_state(),
but the people who asked for it still haven't tested it.  :-/

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 1947c4e..a85c5c4 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -666,6 +666,62 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
>  	__note_new_gpnum(rsp, rnp, rdp);
>  }
> 
> +static void rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
> +		  struct rcu_node *rnp, unsigned long flags);
> +
> +static inline void rcu_check_recent_offcpus(struct rcu_state *rsp,
> +		struct rcu_node *rnp, unsigned long flags)
> +	__releases(rnp->lock)
> +{
> +#ifdef CONFIG_SMP
> +#if defined(CONFIG_NO_HZ) || defined(CONFIG_HOTPLUG_CPU)
> +	/*
> +	 * if it is leaf node and there are some CPU being dynticks state
> +	 * or offline-ing recently, we will check and report qs
> +	 * for these CPU when needed.
> +	 * (for nonleaf node, rnp->offmask is always 0)
> +	 */
> +	if (rnp->qsmask & rnp->offmask) {
> +		int cpu;
> +		unsigned long bit;
> +		unsigned long mask = rnp->qsmask & rnp->offmask;
> +		struct rcu_data *rdp;
> +		long curr, curr_nmi;
> +		int off;
> +
> +		cpu = rnp->grplo;
> +		bit = 1;
> +		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
> +			if (!(mask & bit))
> +				continue;
> +
> +			rdp = rsp->rda[cpu];
> +			curr = rdp->dynticks->dynticks;
> +			curr_nmi = rdp->dynticks->dynticks_nmi;
> +
> +			off = ((curr & 0x1) == 0) && ((curr_nmi & 0x1) == 0);
> +			off = off || cpu_is_offline(rdp->cpu);
> +
> +			if (!off)
> +				mask &= ~bit;
> +		}
> +
> +		rnp->offmask = mask;
> +		if (mask) {
> +			/*
> +			 * It is impossible that rcu_report_qs_rnp()
> +			 * calls rcu_report_qs_rsp() again. So we
> +			 * will not cause recursion.
> +			 */
> +			rcu_report_qs_rnp(mask, rsp, rnp, flags);
> +			return;
> +		}
> +	}
> +#endif
> +#endif
> +	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +}
> +
>  /*
>   * Start a new RCU grace period if warranted, re-initializing the hierarchy
>   * in preparation for detecting the next grace period.  The caller must hold
> @@ -717,7 +773,7 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
>  		rnp->completed = rsp->completed;
>  		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
>  		rcu_start_gp_per_cpu(rsp, rnp, rdp);
> -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		rcu_check_recent_offcpus(rsp, rnp, flags);
>  		return;
>  	}
> 
> @@ -745,14 +801,20 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
>  	 * irqs disabled.
>  	 */
>  	rcu_for_each_node_breadth_first(rsp, rnp) {
> -		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
> +		unsigned long tmp_flags;
> +
> +		/* irqs already disabled */
> +		raw_spin_lock_irqsave(&rnp->lock, tmp_flags);
> +
>  		rcu_preempt_check_blocked_tasks(rnp);
>  		rnp->qsmask = rnp->qsmaskinit;
>  		rnp->gpnum = rsp->gpnum;
>  		rnp->completed = rsp->completed;
>  		if (rnp == rdp->mynode)
>  			rcu_start_gp_per_cpu(rsp, rnp, rdp);
> -		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
> +
> +		rcu_check_recent_offcpus(rsp, rnp, tmp_flags);
> +		/* irqs remain disabled. */
>  	}
> 
>  	rnp = rcu_get_root(rsp);
> @@ -1190,8 +1252,10 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
>  		cpu = rnp->grplo;
>  		bit = 1;
>  		for (; cpu <= rnp->grphi; cpu++, bit <<= 1) {
> -			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
> +			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu])) {
>  				mask |= bit;
> +				rnp->offmask |= bit;
> +			}
>  		}
>  		if (mask != 0) {
> 
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 4a525a3..8ec96a7 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -104,6 +104,8 @@ struct rcu_node {
>  				/*  an rcu_data structure, otherwise, each */
>  				/*  bit corresponds to a child rcu_node */
>  				/*  structure. */
> +	unsigned long offmask;	/* Track CPUs which are dynticks state */
> +				/* or offline-ing recently. */
>  	unsigned long expmask;	/* Groups that have ->blocked_tasks[] */
>  				/*  elements that need to drain to allow the */
>  				/*  current expedited grace period to */
> 
> 
> 
