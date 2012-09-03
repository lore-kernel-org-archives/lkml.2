Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2ICJny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:43:54 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:36873 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899Ab2ICJnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:43:53 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:43:45 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 21/23] rcu: Eliminate signed overflow in
 synchronize_rcu_expedited()
Message-ID: <20120903094345.GJ5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-21-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-21-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:36AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> In the C language, signed overflow is undefined.  It is true that
> twos-complement arithmetic normally comes to the rescue, but if the
> compiler can subvert this any time it has any information about the values
> being compared.  For example, given "if (a - b > 0)", if the compiler
> has enough information to realize that (for example) the value of "a"
> is positive and that of "b" is negative, the compiler is within its
> rights to optimize to a simple "if (1)", which might not be what you want.
> 
> This commit therefore converts synchronize_rcu_expedited()'s work-done
> detection counter from signed to unsigned.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree_plugin.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index befb0b2..7ed45c9 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -677,7 +677,7 @@ void synchronize_rcu(void)
>  EXPORT_SYMBOL_GPL(synchronize_rcu);
>  
>  static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
> -static long sync_rcu_preempt_exp_count;
> +static unsigned long sync_rcu_preempt_exp_count;
>  static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
>  
>  /*
> @@ -792,7 +792,7 @@ void synchronize_rcu_expedited(void)
>  	unsigned long flags;
>  	struct rcu_node *rnp;
>  	struct rcu_state *rsp = &rcu_preempt_state;
> -	long snap;
> +	unsigned long snap;
>  	int trycount = 0;
>  
>  	smp_mb(); /* Caller's modifications seen first by other CPUs. */
> @@ -811,10 +811,10 @@ void synchronize_rcu_expedited(void)
>  			synchronize_rcu();
>  			return;
>  		}
> -		if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
> +		if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count)))
>  			goto mb_ret; /* Others did our work for us. */
>  	}
> -	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
> +	if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count)))
>  		goto unlock_mb_ret; /* Others did our work for us. */
>  
>  	/* force all RCU readers onto ->blkd_tasks lists. */
> -- 
> 1.7.8
> 
