Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab2FOWIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:08:39 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56311 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2FOWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:08:38 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 15:08:24 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 04/15] rcu: Place pointer to call_rcu() in
 rcu_data structure
Message-ID: <20120615220824.GX31184@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:05:59PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> This is a preparatory commit for increasing rcu_barrier()'s concurrency.
> It adds a pointer in the rcu_data structure to the corresponding call_rcu()
> function.  This allows a pointer to the rcu_data structure to imply the
> function pointer, which allows _rcu_barrier() state to be placed in the
> rcu_state structure.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c        |   27 ++++++++++++---------------
>  kernel/rcutree.h        |    2 ++
>  kernel/rcutree_plugin.h |    5 +++--
>  3 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 8ce1b1d..8b3ab4e 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -62,8 +62,9 @@
>  
>  static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
>  
> -#define RCU_STATE_INITIALIZER(sname) { \
> +#define RCU_STATE_INITIALIZER(sname, cr) { \
>  	.level = { &sname##_state.node[0] }, \
> +	.call = cr, \
>  	.fqs_state = RCU_GP_IDLE, \
>  	.gpnum = -300, \
>  	.completed = -300, \
> @@ -76,10 +77,11 @@ static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
>  	.name = #sname, \
>  }
>  
> -struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched);
> +struct rcu_state rcu_sched_state =
> +	RCU_STATE_INITIALIZER(rcu_sched, call_rcu_sched);
>  DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
>  
> -struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh);
> +struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, call_rcu_bh);
>  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
>  
>  static struct rcu_state *rcu_state;
> @@ -2279,21 +2281,17 @@ static void rcu_barrier_func(void *type)
>  {
>  	int cpu = smp_processor_id();
>  	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
> -	void (*call_rcu_func)(struct rcu_head *head,
> -			      void (*func)(struct rcu_head *head));
> +	struct rcu_state *rsp = type;
>  
>  	atomic_inc(&rcu_barrier_cpu_count);
> -	call_rcu_func = type;
> -	call_rcu_func(head, rcu_barrier_callback);
> +	rsp->call(head, rcu_barrier_callback);
>  }
>  
>  /*
>   * Orchestrate the specified type of RCU barrier, waiting for all
>   * RCU callbacks of the specified type to complete.
>   */
> -static void _rcu_barrier(struct rcu_state *rsp,
> -			 void (*call_rcu_func)(struct rcu_head *head,
> -					       void (*func)(struct rcu_head *head)))
> +static void _rcu_barrier(struct rcu_state *rsp)
>  {
>  	int cpu;
>  	unsigned long flags;
> @@ -2345,8 +2343,7 @@ static void _rcu_barrier(struct rcu_state *rsp,
>  			while (cpu_is_offline(cpu) && ACCESS_ONCE(rdp->qlen))
>  				schedule_timeout_interruptible(1);
>  		} else if (ACCESS_ONCE(rdp->qlen)) {
> -			smp_call_function_single(cpu, rcu_barrier_func,
> -						 (void *)call_rcu_func, 1);
> +			smp_call_function_single(cpu, rcu_barrier_func, rsp, 1);
>  			preempt_enable();
>  		} else {
>  			preempt_enable();
> @@ -2367,7 +2364,7 @@ static void _rcu_barrier(struct rcu_state *rsp,
>  	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
>  	atomic_inc(&rcu_barrier_cpu_count);
>  	smp_mb__after_atomic_inc(); /* Ensure atomic_inc() before callback. */
> -	call_rcu_func(&rh, rcu_barrier_callback);
> +	rsp->call(&rh, rcu_barrier_callback);
>  
>  	/*
>  	 * Now that we have an rcu_barrier_callback() callback on each
> @@ -2390,7 +2387,7 @@ static void _rcu_barrier(struct rcu_state *rsp,
>   */
>  void rcu_barrier_bh(void)
>  {
> -	_rcu_barrier(&rcu_bh_state, call_rcu_bh);
> +	_rcu_barrier(&rcu_bh_state);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_bh);
>  
> @@ -2399,7 +2396,7 @@ EXPORT_SYMBOL_GPL(rcu_barrier_bh);
>   */
>  void rcu_barrier_sched(void)
>  {
> -	_rcu_barrier(&rcu_sched_state, call_rcu_sched);
> +	_rcu_barrier(&rcu_sched_state);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier_sched);
>  
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index df3c2c8..15837d7 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -350,6 +350,8 @@ struct rcu_state {
>  	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
>  	u8 levelspread[RCU_NUM_LVLS];		/* kids/node in each level. */
>  	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
> +	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
> +		     void (*func)(struct rcu_head *head));
>  
>  	/* The following fields are guarded by the root rcu_node's lock. */
>  
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 7cb86ae..6888706 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -78,7 +78,8 @@ static void __init rcu_bootup_announce_oddness(void)
>  
>  #ifdef CONFIG_TREE_PREEMPT_RCU
>  
> -struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt);
> +struct rcu_state rcu_preempt_state =
> +	RCU_STATE_INITIALIZER(rcu_preempt, call_rcu);
>  DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
>  static struct rcu_state *rcu_state = &rcu_preempt_state;
>  
> @@ -944,7 +945,7 @@ static int rcu_preempt_cpu_has_callbacks(int cpu)
>   */
>  void rcu_barrier(void)
>  {
> -	_rcu_barrier(&rcu_preempt_state, call_rcu);
> +	_rcu_barrier(&rcu_preempt_state);
>  }
>  EXPORT_SYMBOL_GPL(rcu_barrier);
>  
> -- 
> 1.7.8
> 
