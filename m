Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2IBBJo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 21:09:44 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60985 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2IBBJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 21:09:43 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 18:09:35 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 02/23] rcu: Allow RCU grace-period
 initialization to be preempted
Message-ID: <20120902010935.GB5713@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:17AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> RCU grace-period initialization is currently carried out with interrupts
> disabled, which can result in 200-microsecond latency spikes on systems
> on which RCU has been configured for 4096 CPUs.  This patch therefore
> makes the RCU grace-period initialization be preemptible, which should
> eliminate those latency spikes.  Similar spikes from grace-period cleanup
> and the forcing of quiescent states will be dealt with similarly by later
> patches.
> 
> Reported-by: Mike Galbraith <mgalbraith@suse.de>
> Reported-by: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Does it make sense to have cond_resched() right before the continues,
which lead right back up to the wait_event_interruptible at the top of
the loop?  Or do you expect to usually find that event already
signalled?

In any case:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e1c5868..ef56aa3 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1069,6 +1069,7 @@ static int rcu_gp_kthread(void *arg)
>  			 * don't start another one.
>  			 */
>  			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +			cond_resched();
>  			continue;
>  		}
>  
> @@ -1079,6 +1080,7 @@ static int rcu_gp_kthread(void *arg)
>  			 */
>  			rsp->fqs_need_gp = 1;
>  			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +			cond_resched();
>  			continue;
>  		}
>  
> @@ -1089,10 +1091,10 @@ static int rcu_gp_kthread(void *arg)
>  		rsp->fqs_state = RCU_GP_INIT; /* Stop force_quiescent_state. */
>  		rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
>  		record_gp_stall_check_time(rsp);
> -		raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  
>  		/* Exclude any concurrent CPU-hotplug operations. */
> -		raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
> +		get_online_cpus();
>  
>  		/*
>  		 * Set the quiescent-state-needed bits in all the rcu_node
> @@ -1112,7 +1114,7 @@ static int rcu_gp_kthread(void *arg)
>  		 * due to the fact that we have irqs disabled.
>  		 */
>  		rcu_for_each_node_breadth_first(rsp, rnp) {
> -			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
> +			raw_spin_lock_irqsave(&rnp->lock, flags);
>  			rcu_preempt_check_blocked_tasks(rnp);
>  			rnp->qsmask = rnp->qsmaskinit;
>  			rnp->gpnum = rsp->gpnum;
> @@ -1123,15 +1125,16 @@ static int rcu_gp_kthread(void *arg)
>  			trace_rcu_grace_period_init(rsp->name, rnp->gpnum,
>  						    rnp->level, rnp->grplo,
>  						    rnp->grphi, rnp->qsmask);
> -			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
> +			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +			cond_resched();
>  		}
>  
>  		rnp = rcu_get_root(rsp);
> -		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
> +		raw_spin_lock_irqsave(&rnp->lock, flags);
>  		/* force_quiescent_state() now OK. */
>  		rsp->fqs_state = RCU_SIGNAL_INIT;
> -		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
> -		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		put_online_cpus();
>  	}
>  	return 0;
>  }
> -- 
> 1.7.8
> 
