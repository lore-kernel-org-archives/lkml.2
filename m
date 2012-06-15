Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2FOWzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:55:32 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59355 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab2FOWzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:55:31 -0400
X-Originating-IP: 217.70.178.129
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 15:55:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 08/15] rcu: Move rcu_barrier_mutex to
 rcu_state structure
Message-ID: <20120615225516.GD5226@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-8-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-8-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:06:03PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> In order to allow each RCU flavor to concurrently execute its
> rcu_barrier() function, it is necessary to move the relevant
> state to the rcu_state structure.  This commit therefore moves the
> rcu_barrier_mutex global variable to a new ->barrier_mutex field
> in the rcu_state structure.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |   11 +++--------
>  kernel/rcutree.h |    1 +
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index a946437..93358d4 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -71,9 +71,8 @@ static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
>  	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.onofflock), \
>  	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
>  	.orphan_donetail = &sname##_state.orphan_donelist, \
> +	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
>  	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.fqslock), \
> -	.n_force_qs = 0, \
> -	.n_force_qs_ngp = 0, \

The removal of these two fields seems unrelated to the rest of this
commit.

I assume you've removed them because the use of "static" makes
initializations to 0 unnecessary?

The rest of this commit seems fine to me.

>  	.name = #sname, \
>  }
>  
> @@ -155,10 +154,6 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
>  unsigned long rcutorture_testseq;
>  unsigned long rcutorture_vernum;
>  
> -/* State information for rcu_barrier() and friends. */
> -
> -static DEFINE_MUTEX(rcu_barrier_mutex);
> -
>  /*
>   * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
>   * permit this function to be invoked without holding the root rcu_node
> @@ -2300,7 +2295,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	init_rcu_head_on_stack(&rd.barrier_head);
>  
>  	/* Take mutex to serialize concurrent rcu_barrier() requests. */
> -	mutex_lock(&rcu_barrier_mutex);
> +	mutex_lock(&rsp->barrier_mutex);
>  
>  	smp_mb();  /* Prevent any prior operations from leaking in. */
>  
> @@ -2377,7 +2372,7 @@ static void _rcu_barrier(struct rcu_state *rsp)
>  	wait_for_completion(&rsp->barrier_completion);
>  
>  	/* Other rcu_barrier() invocations can now safely proceed. */
> -	mutex_unlock(&rcu_barrier_mutex);
> +	mutex_unlock(&rsp->barrier_mutex);
>  
>  	destroy_rcu_head_on_stack(&rd.barrier_head);
>  }
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 56fb8d4..d9ac82f 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -386,6 +386,7 @@ struct rcu_state {
>  	struct task_struct *rcu_barrier_in_progress;
>  						/* Task doing rcu_barrier(), */
>  						/*  or NULL if no barrier. */
> +	struct mutex barrier_mutex;		/* Guards barrier fields. */
>  	atomic_t barrier_cpu_count;		/* # CPUs waiting on. */
>  	struct completion barrier_completion;	/* Wake at barrier end. */
>  	raw_spinlock_t fqslock;			/* Only one task forcing */
> -- 
> 1.7.8
> 
