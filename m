Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab2FOWTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:19:32 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35168 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119Ab2FOWTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:19:31 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 15:19:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 05/15] rcu: Move _rcu_barrier()'s rcu_head
 structures to rcu_data structures
Message-ID: <20120615221915.GY31184@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:06:00PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> In order for multiple flavors of RCU to each concurrently run one
> rcu_barrier(), each flavor needs its own per-CPU set of rcu_head
> structures.  This commit therefore moves _rcu_barrier()'s set of
> per-CPU rcu_head structures from per-CPU variables to the existing
> per-CPU and per-RCU-flavor rcu_data structures.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    6 ++----
>  kernel/rcutree.h |    3 +++
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 8b3ab4e..2cfbdb8 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -157,7 +157,6 @@ unsigned long rcutorture_vernum;
>  
>  /* State information for rcu_barrier() and friends. */
>  
> -static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
>  static atomic_t rcu_barrier_cpu_count;
>  static DEFINE_MUTEX(rcu_barrier_mutex);
>  static struct completion rcu_barrier_completion;
> @@ -2279,12 +2278,11 @@ static void rcu_barrier_callback(struct rcu_head *notused)
>   */
>  static void rcu_barrier_func(void *type)
>  {
> -	int cpu = smp_processor_id();
> -	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
>  	struct rcu_state *rsp = type;
> +	struct rcu_data *rdp = __this_cpu_ptr(rsp->rda);
>  
>  	atomic_inc(&rcu_barrier_cpu_count);
> -	rsp->call(head, rcu_barrier_callback);
> +	rsp->call(&rdp->barrier_head, rcu_barrier_callback);
>  }
>  
>  /*
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 15837d7..1783eae 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -300,6 +300,9 @@ struct rcu_data {
>  	unsigned long n_rp_need_fqs;
>  	unsigned long n_rp_need_nothing;
>  
> +	/* 6) _rcu_barrier() callback. */
> +	struct rcu_head barrier_head;
> +
>  	int cpu;
>  	struct rcu_state *rsp;
>  };
> -- 
> 1.7.8
> 
