Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0DMMaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 08:30:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:47017 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0DMM3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:29:49 -0400
Subject: Re: [PATCH 4/5] sched: Mark the balance type for use in
 need_active_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Neuling <mikey@neuling.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100409062119.040B0CBB6F@localhost.localdomain>
References: <20100409062119.040B0CBB6F@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 13 Apr 2010 14:29:28 +0200
Message-ID: <1271161768.4807.1282.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> need_active_balance() gates the asymmetric packing based due to power
> save logic, but for packing we don't care.

This explanation lacks a how/why.

So the problem is that need_active_balance() ends up returning false and
prevents the active balance from pulling a task to a lower available SMT
sibling?

> This marks the type of balanace we are attempting to do perform from
> f_b_g() and stops need_active_balance() power save logic gating a
> balance in the asymmetric packing case.

At the very least this wants more comments in the code. I'm not really
charmed by having to add yet another variable to pass around that mess,
but I can't seem to come up with something cleaner either.

> Signed-off-by: Michael Neuling <mikey@neuling.org>
> 
> ---
> 
>  kernel/sched_fair.c |   24 +++++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6-ozlabs/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6-ozlabs.orig/kernel/sched_fair.c
> +++ linux-2.6-ozlabs/kernel/sched_fair.c
> @@ -91,6 +91,13 @@ const_debug unsigned int sysctl_sched_mi
>  
>  static const struct sched_class fair_sched_class;
>  
> +enum balance_type {
> +	BALANCE_NONE = 0,
> +	BALANCE_LOAD,
> +	BALANCE_POWER,
> +	BALANCE_PACKING
> +};
> +
>  /**************************************************************
>   * CFS operations on generic schedulable entities:
>   */
> @@ -2783,7 +2790,8 @@ static inline void calculate_imbalance(s
>  static struct sched_group *
>  find_busiest_group(struct sched_domain *sd, int this_cpu,
>  		   unsigned long *imbalance, enum cpu_idle_type idle,
> -		   int *sd_idle, const struct cpumask *cpus, int *balance)
> +		   int *sd_idle, const struct cpumask *cpus, int *balance,
> +		   enum balance_type *bt)
>  {
>  	struct sd_lb_stats sds;
>  
> @@ -2808,6 +2816,7 @@ find_busiest_group(struct sched_domain *
>  	if (!(*balance))
>  		goto ret;
>  
> +	*bt = BALANCE_PACKING;
>  	if ((idle == CPU_IDLE || idle == CPU_NEWLY_IDLE) &&
>  	    check_asym_packing(sd, &sds, this_cpu, imbalance))
>  		return sds.busiest;
> @@ -2828,6 +2837,7 @@ find_busiest_group(struct sched_domain *
>  
>  	/* Looks like there is an imbalance. Compute it */
>  	calculate_imbalance(&sds, this_cpu, imbalance);
> +	*bt = BALANCE_LOAD;
>  	return sds.busiest;
>  
>  out_balanced:
> @@ -2835,10 +2845,12 @@ out_balanced:
>  	 * There is no obvious imbalance. But check if we can do some balancing
>  	 * to save power.
>  	 */
> +	*bt = BALANCE_POWER;
>  	if (check_power_save_busiest_group(&sds, this_cpu, imbalance))
>  		return sds.busiest;
>  ret:
>  	*imbalance = 0;
> +	*bt = BALANCE_NONE;
>  	return NULL;
>  }
>  
> @@ -2899,9 +2911,10 @@ find_busiest_queue(struct sched_group *g
>  /* Working cpumask for load_balance and load_balance_newidle. */
>  static DEFINE_PER_CPU(cpumask_var_t, load_balance_tmpmask);
>  
> -static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle)
> +static int need_active_balance(struct sched_domain *sd, int sd_idle, int idle,
> +			       enum balance_type *bt)
>  {
> -	if (idle == CPU_NEWLY_IDLE) {
> +	if (idle == CPU_NEWLY_IDLE && *bt != BALANCE_PACKING) {
>  		/*
>  		 * The only task running in a non-idle cpu can be moved to this
>  		 * cpu in an attempt to completely freeup the other CPU
> @@ -2946,6 +2959,7 @@ static int load_balance(int this_cpu, st
>  	struct rq *busiest;
>  	unsigned long flags;
>  	struct cpumask *cpus = __get_cpu_var(load_balance_tmpmask);
> +	enum balance_type bt;
>  
>  	cpumask_copy(cpus, cpu_active_mask);
>  
> @@ -2964,7 +2978,7 @@ static int load_balance(int this_cpu, st
>  redo:
>  	update_shares(sd);
>  	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
> -				   cpus, balance);
> +				   cpus, balance, &bt);
>  
>  	if (*balance == 0)
>  		goto out_balanced;
> @@ -3018,7 +3032,7 @@ redo:
>  		schedstat_inc(sd, lb_failed[idle]);
>  		sd->nr_balance_failed++;
>  
> -		if (need_active_balance(sd, sd_idle, idle)) {
> +		if (need_active_balance(sd, sd_idle, idle, &bt)) {
>  			raw_spin_lock_irqsave(&busiest->lock, flags);
>  
>  			/* don't kick the migration_thread, if the curr

