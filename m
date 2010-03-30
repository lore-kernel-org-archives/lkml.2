Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0C3Qam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:30:42 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:37862 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0C3Qal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:30:41 -0400
Date: Tue, 30 Mar 2010 09:30:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: only raise softirq when need
Message-ID: <20100330163036.GC2513@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB1CE6B.6030207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB1CE6B.6030207@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 06:11:55PM +0800, Lai Jiangshan wrote:
> 
> I found something RCU_SOFTIRQ are called without do any thing.
> (use function_graph to find it:
>  1)               |  rcu_process_callbacks() {
>  1)               |    __rcu_process_callbacks() {
>  1)   0.634 us    |      rcu_process_gp_end();
>  1)   0.487 us    |      check_for_new_grace_period();
>  1)   2.672 us    |    }
>  1)               |    __rcu_process_callbacks() {
>  1)   0.633 us    |      rcu_process_gp_end();
>  1)   0.491 us    |      check_for_new_grace_period();
>  1)   2.672 us    |    }
> )
> 
> This patch make RCU_SOFTIRQ raised when need.

So this seems to have two effects:

1.	Avoid checking for a quiescent state if RCU doesn't need one
	from this CPU.

2.	Avoid RCU_SOFTIRQ if RCU did need a quiescent state from
	this CPU, and if rcu_check_callbacks() saw a quiescent state.

Except that if rcu_check_callbacks() did see a quiescent state, then we
-need- RCU_SOFTIRQ to propagate this up the tree.  So I don't see how
this patch helps, and unless I am missing something, it can result in
grace-period hangs.  (This CPU is the last one to pass through a
quiescent state, and this call to rcu_check_callbacks() finds one,
and we fail to report it up the tree.)

Please note that there are other possible causes for empty calls to
rcu_process_callbacks():

1.	RCU needs a call to force_quiescent_state(), but some other
	CPU beats us to it.  We raise RCU_SOFTIRQ, but by the time
	we get there, our work is done.

2.	RCU needs to check for CPU stalls, but some other CPU beats
	us to it.

3.	RCU is idle, and this CPU needs another grace period, but
	some other CPU starts up a new grace period before our
	softirq gets started.

So I do not believe that this patch is worthwhile even if it does turn
out to be safe.

Please let me know if I am missing something.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 1947c4e..06a1780 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -133,6 +133,7 @@ module_param(qlowmark, int, 0);
> 
>  static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
>  static int rcu_pending(int cpu);
> +static int rcu_qs_pending(int cpu);
> 
>  /*
>   * Return the number of RCU-sched batches processed thus far for debug & stats.
> @@ -1125,8 +1126,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>   */
>  void rcu_check_callbacks(int cpu, int user)
>  {
> -	if (!rcu_pending(cpu))
> -		return; /* if nothing for RCU to do. */
> +	if (!rcu_qs_pending(cpu))
> +		goto check_rcu_softirq_work;
> +
>  	if (user ||
>  	    (idle_cpu(cpu) && rcu_scheduler_active &&
>  	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
> @@ -1158,7 +1160,10 @@ void rcu_check_callbacks(int cpu, int user)
>  		rcu_bh_qs(cpu);
>  	}
>  	rcu_preempt_check_callbacks(cpu);
> -	raise_softirq(RCU_SOFTIRQ);
> +
> +check_rcu_softirq_work:
> +	if (rcu_pending(cpu))
> +		raise_softirq(RCU_SOFTIRQ);
>  }
> 
>  #ifdef CONFIG_SMP
> @@ -1497,9 +1502,9 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
>  	/* Check for CPU stalls, if enabled. */
>  	check_cpu_stall(rsp, rdp);
> 
> -	/* Is the RCU core waiting for a quiescent state from this CPU? */
> -	if (rdp->qs_pending) {
> -		rdp->n_rp_qs_pending++;
> +	/* Does this RCU need to report quiescent state? */
> +	if (rdp->qs_pending && rdp->passed_quiesc) {
> +		rdp->n_rp_report_qs++;
>  		return 1;
>  	}
> 
> @@ -1551,6 +1556,24 @@ static int rcu_pending(int cpu)
>  	       rcu_preempt_pending(cpu);
>  }
> 
> +/* Is the RCU core waiting for a quiescent state from this CPU? */
> +static int __rcu_qs_pending(struct rcu_data *rdp)
> +{
> +	if (rdp->qs_pending) {
> +		rdp->n_rp_qs_pending++;
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int rcu_qs_pending(int cpu)
> +{
> +	return __rcu_qs_pending(&per_cpu(rcu_sched_data, cpu)) ||
> +	       __rcu_qs_pending(&per_cpu(rcu_bh_data, cpu)) ||
> +	       rcu_preempt_qs_pending(cpu);
> +}
> +
>  /*
>   * Check to see if any future RCU-related work will need to be done
>   * by the current CPU, even if none need be done immediately, returning
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 4a525a3..c0f312e 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -223,6 +223,7 @@ struct rcu_data {
>  	/* 5) __rcu_pending() statistics. */
>  	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
>  	unsigned long n_rp_qs_pending;
> +	unsigned long n_rp_report_qs;
>  	unsigned long n_rp_cb_ready;
>  	unsigned long n_rp_cpu_needs_gp;
>  	unsigned long n_rp_gp_completed;
> @@ -378,6 +379,7 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu));
>  static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
>  #endif /* #if defined(CONFIG_HOTPLUG_CPU) || defined(CONFIG_TREE_PREEMPT_RCU) */
>  static int rcu_preempt_pending(int cpu);
> +static int rcu_preempt_qs_pending(int cpu);
>  static int rcu_preempt_needs_cpu(int cpu);
>  static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
>  static void rcu_preempt_send_cbs_to_orphanage(void);
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 79b53bd..4befb64 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -689,6 +689,11 @@ static int rcu_preempt_pending(int cpu)
>  			     &per_cpu(rcu_preempt_data, cpu));
>  }
> 
> +static int rcu_preempt_qs_pending(int cpu)
> +{
> +	return __rcu_qs_pending(&per_cpu(rcu_preempt_data, cpu));
> +}
> +
>  /*
>   * Does preemptable RCU need the CPU to stay out of dynticks mode?
>   */
> @@ -914,6 +919,11 @@ static int rcu_preempt_pending(int cpu)
>  	return 0;
>  }
> 
> +static int rcu_preempt_qs_pending(int cpu)
> +{
> +	return 0;
> +}
> +
>  /*
>   * Because preemptable RCU does not exist, it never needs any CPU.
>   */
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
