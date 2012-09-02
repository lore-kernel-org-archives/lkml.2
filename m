Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2IBBgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 21:36:40 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52826 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab2IBBgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 21:36:39 -0400
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.46.74
Date: Sat, 1 Sep 2012 18:36:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 04/23] rcu: Allow RCU grace-period cleanup
 to be preempted
Message-ID: <20120902013631.GD5713@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:19AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> RCU grace-period cleanup is currently carried out with interrupts
> disabled, which can result in excessive latency spikes on large systems
> (many hundreds or thousands of CPUs).  This patch therefore makes the
> RCU grace-period cleanup be preemptible, including voluntary preemption
> points, which should eliminate those latency spikes.  Similar spikes from
> forcing of quiescent states will be dealt with similarly by later patches.
> 
> Reported-by: Mike Galbraith <mgalbraith@suse.de>
> Reported-by: Dimitri Sivanich <sivanich@sgi.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 9fad21c..300aba6 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1170,7 +1170,7 @@ static int rcu_gp_kthread(void *arg)
>  		 * completed.
>  		 */
>  		if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
> -			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
> +			raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  
>  			/*
>  			 * Propagate new ->completed value to rcu_node
> @@ -1179,14 +1179,13 @@ static int rcu_gp_kthread(void *arg)
>  			 * to process their callbacks.
>  			 */
>  			rcu_for_each_node_breadth_first(rsp, rnp) {
> -				/* irqs already disabled. */
> -				raw_spin_lock(&rnp->lock);
> +				raw_spin_lock_irqsave(&rnp->lock, flags);
>  				rnp->completed = rsp->gpnum;
> -				/* irqs remain disabled. */
> -				raw_spin_unlock(&rnp->lock);
> +				raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +				cond_resched();
>  			}
>  			rnp = rcu_get_root(rsp);
> -			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
> +			raw_spin_lock_irqsave(&rnp->lock, flags);
>  		}
>  
>  		rsp->completed = rsp->gpnum; /* Declare grace period done. */
> -- 
> 1.7.8
> 
