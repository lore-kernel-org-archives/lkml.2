Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab2FOWpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:45:04 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50011 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab2FOWpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:45:03 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 15:44:45 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 06/15] rcu: Move rcu_barrier_cpu_count to
 rcu_state structure
Message-ID: <20120615224445.GB5226@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-6-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-6-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:06:01PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> In order to allow each RCU flavor to concurrently execute its rcu_barrier()
> function, it is necessary to move the relevant state to the rcu_state
> structure.  This commit therefore moves the rcu_barrier_cpu_count global
> variable to a new ->barrier_cpu_count field in the rcu_state structure.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |   25 ++++++++++++++-----------
>  kernel/rcutree.h |    1 +
>  2 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 2cfbdb8..d363416 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -157,7 +157,6 @@ unsigned long rcutorture_vernum;
>  
>  /* State information for rcu_barrier() and friends. */
>  
> -static atomic_t rcu_barrier_cpu_count;
>  static DEFINE_MUTEX(rcu_barrier_mutex);
>  static struct completion rcu_barrier_completion;
>  
> @@ -2267,9 +2266,12 @@ static int rcu_cpu_has_callbacks(int cpu)
>   * RCU callback function for _rcu_barrier().  If we are last, wake
>   * up the task executing _rcu_barrier().
>   */
> -static void rcu_barrier_callback(struct rcu_head *notused)
> +static void rcu_barrier_callback(struct rcu_head *rhp)
>  {
> -	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
> +	struct rcu_data *rdp = container_of(rhp, struct rcu_data, barrier_head);
> +	struct rcu_state *rsp = rdp->rsp;
> +
> +	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
>  		complete(&rcu_barrier_completion);
>  }
>  
> @@ -2281,7 +2283,7 @@ static void rcu_barrier_func(void *type)
>  	struct rcu_state *rsp = type;
>  	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
>  
> -	atomic_inc(&rcu_barrier_cpu_count);
> +	atomic_inc(&rsp->barrier_cpu_count);
>  	rsp->call(&rdp->barrier_head, rcu_barrier_callback);
>  }
>  
> @@ -2294,9 +2296,9 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	int cpu;
>  	unsigned long flags;
>  	struct rcu_data *rdp;
> -	struct rcu_head rh;
> +	struct rcu_data rd;
>  
> -	init_rcu_head_on_stack(&rh);
> +	init_rcu_head_on_stack(&rd.barrier_head);
>  
>  	/* Take mutex to serialize concurrent rcu_barrier() requests. */
>  	mutex_lock(&rcu_barrier_mutex);
> @@ -2321,7 +2323,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	 *	us -- but before CPU 1's orphaned callbacks are invoked!!!
>  	 */
>  	init_completion(&rcu_barrier_completion);
> -	atomic_set(&rcu_barrier_cpu_count, 1);
> +	atomic_set(&rsp->barrier_cpu_count, 1);
>  	raw_spin_lock_irqsave(&rsp->onofflock, flags);
>  	rsp->rcu_barrier_in_progress = current;
>  	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
> @@ -2360,15 +2362,16 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	rcu_adopt_orphan_cbs(rsp);
>  	rsp->rcu_barrier_in_progress = NULL;
>  	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
> -	atomic_inc(&rcu_barrier_cpu_count);
> +	atomic_inc(&rsp->barrier_cpu_count);
>  	smp_mb__after_atomic_inc(); /* Ensure atomic_inc() before callback. */
> -	rsp->call(&rh, rcu_barrier_callback);
> +	rd.rsp = rsp;
> +	rsp->call(&rd.barrier_head, rcu_barrier_callback);
>  
>  	/*
>  	 * Now that we have an rcu_barrier_callback() callback on each
>  	 * CPU, and thus each counted, remove the initial count.
>  	 */
> -	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
> +	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
>  		complete(&rcu_barrier_completion);
>  
>  	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
> @@ -2377,7 +2380,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	/* Other rcu_barrier() invocations can now safely proceed. */
>  	mutex_unlock(&rcu_barrier_mutex);
>  
> -	destroy_rcu_head_on_stack(&rh);
> +	destroy_rcu_head_on_stack(&rd.barrier_head);
>  }
>  
>  /**
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 1783eae..e7d29b7 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -386,6 +386,7 @@ struct rcu_state {
>  	struct task_struct *rcu_barrier_in_progress;
>  						/* Task doing rcu_barrier(), */
>  						/*  or NULL if no barrier. */
> +	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
>  	raw_spinlock_t fqslock;			/* Only one task forcing */
>  						/*  quiescent states. */
>  	unsigned long jiffies_force_qs;		/* Time at which to invoke */
> -- 
> 1.7.8
> 
