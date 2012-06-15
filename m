Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab2FOWvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:51:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57513 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478Ab2FOWvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:51:51 -0400
X-Originating-IP: 217.70.178.145
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 15:51:30 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 07/15] rcu: Move rcu_barrier_completion to
 rcu_state structure
Message-ID: <20120615225130.GC5226@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-7-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-7-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:06:02PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> In order to allow each RCU flavor to concurrently execute its
> rcu_barrier() function, it is necessary to move the relevant
> state to the rcu_state structure.  This commit therefore moves the
> rcu_barrier_completion global variable to a new ->barrier_completion
> field in the rcu_state structure.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    9 ++++-----
>  kernel/rcutree.h |    1 +
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d363416..a946437 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -158,7 +158,6 @@ unsigned long rcutorture_vernum;
>  /* State information for rcu_barrier() and friends. */
>  
>  static DEFINE_MUTEX(rcu_barrier_mutex);
> -static struct completion rcu_barrier_completion;
>  
>  /*
>   * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
> @@ -2272,7 +2271,7 @@ static void rcu_barrier_callback(struct rcu_head *rhp)
>  	struct rcu_state *rsp = rdp->rsp;
>  
>  	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
> -		complete(&rcu_barrier_completion);
> +		complete(&rsp->barrier_completion);
>  }
>  
>  /*
> @@ -2322,7 +2321,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	 * 6.	Both rcu_barrier_callback() callbacks are invoked, awakening
>  	 *	us -- but before CPU 1's orphaned callbacks are invoked!!!
>  	 */
> -	init_completion(&rcu_barrier_completion);
> +	init_completion(&rsp->barrier_completion);
>  	atomic_set(&rsp->barrier_cpu_count, 1);
>  	raw_spin_lock_irqsave(&rsp->onofflock, flags);
>  	rsp->rcu_barrier_in_progress = current;
> @@ -2372,10 +2371,10 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	 * CPU, and thus each counted, remove the initial count.
>  	 */
>  	if (atomic_dec_and_test(&rsp->barrier_cpu_count))
> -		complete(&rcu_barrier_completion);
> +		complete(&rsp->barrier_completion);
>  
>  	/* Wait for all rcu_barrier_callback() callbacks to be invoked. */
> -	wait_for_completion(&rcu_barrier_completion);
> +	wait_for_completion(&rsp->barrier_completion);
>  
>  	/* Other rcu_barrier() invocations can now safely proceed. */
>  	mutex_unlock(&rcu_barrier_mutex);
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index e7d29b7..56fb8d4 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -387,6 +387,7 @@ struct rcu_state {
>  						/* Task doing rcu_barrier(), */
>  						/*  or NULL if no barrier. */
>  	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
> +	struct completion barrier_completion;	/* Wake at barrier end. */
>  	raw_spinlock_t fqslock;			/* Only one task forcing */
>  						/*  quiescent states. */
>  	unsigned long jiffies_force_qs;		/* Time at which to invoke */
> -- 
> 1.7.8
> 
