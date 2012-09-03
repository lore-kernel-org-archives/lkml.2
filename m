Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2ICJlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:41:35 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38762 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2ICJle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:41:34 -0400
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:41:26 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 18/23] rcu: Add random PROVE_RCU_DELAY to
 grace-period initialization
Message-ID: <20120903094125.GG5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-18-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-18-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:33AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> There are some additional potential grace-period initialization races
> on systems with more than one rcu_node structure, for example:
> 
> 1.	CPU 0 completes a grace period, but needs an additional
> 	grace period, so starts initializing one, initializing all
> 	the non-leaf rcu_node strcutures and the first leaf rcu_node
> 	structure.  Because CPU 0 is both completing the old grace
> 	period and starting a new one, it marks the completion of
> 	the old grace period and the start of the new grace period
> 	in a single traversal of the rcu_node structures.
> 
> 	Therefore, CPUs corresponding to the first rcu_node structure
> 	can become aware that the prior grace period has ended, but
> 	CPUs corresponding to the other rcu_node structures cannot
> 	yet become aware of this.
> 
> 2.	CPU 1 passes through a quiescent state, and therefore informs
> 	the RCU core.  Because its leaf rcu_node structure has already
> 	been initialized, so this CPU's quiescent state is applied to
> 	the new (and only partially initialized) grace period.
> 
> 3.	CPU 1 enters an RCU read-side critical section and acquires
> 	a reference to data item A.  Note that this critical section
> 	will not block the new grace period.
> 
> 4.	CPU 16 exits dyntick-idle mode.  Because it was in dyntick-idle
> 	mode, some other CPU informed the RCU core of its extended
> 	quiescent state for the past several grace periods.  This means
> 	that CPU 16 is not yet aware that these grace periods have ended.
> 
> 5.	CPU 16 on the second leaf rcu_node structure removes data item A
> 	from its enclosing data structure and passes it to call_rcu(),
> 	which queues a callback in the RCU_NEXT_TAIL segment of the
> 	callback queue.
> 
> 6.	CPU 16 enters the RCU core, possibly because it has taken a
> 	scheduling-clock interrupt, or alternatively because it has
> 	more than 10,000 callbacks queued.  It notes that the second
> 	most recent grace period has ended (recall that it cannot yet
> 	become aware that the most recent grace period has completed),
> 	and therefore advances its callbacks.  The callback for data
> 	item A is therefore in the RCU_NEXT_READY_TAIL segment of the
> 	callback queue.
> 
> 7.	CPU 0 completes initialization of the remaining leaf rcu_node
> 	structures for the new grace period, including the structure
> 	corresponding to CPU 16.
> 
> 8.	CPU 16 again enters the RCU core, again, possibly because it has
> 	taken a scheduling-clock interrupt, or alternatively because
> 	it now has more than 10,000 callbacks queued.	It notes that
> 	the most recent grace period has ended, and therefore advances
> 	its callbacks.	The callback for data item A is therefore in
> 	the RCU_NEXT_TAIL segment of the callback queue.
> 
> 9.	All CPUs other than CPU 1 pass through quiescent states, so that
> 	the new grace period completes.  Note that CPU 1 is still in
> 	its RCU read-side critical section, still referencing data item A.
> 
> 10.	Suppose that CPU 2 is the last CPU to pass through a quiescent
> 	state for the new grace period, and suppose further that CPU 2
> 	does not have any callbacks queued.  It therefore traverses
> 	all of the rcu_node structures, marking the new grace period
> 	as completed, but does not initialize a new grace period.
> 
> 11.	CPU 16 yet again enters the RCU core, yet again possibly because
> 	it has taken a scheduling-clock interrupt, or alternatively
> 	because it now has more than 10,000 callbacks queued.	It notes
> 	that the new grace period has ended, and therefore advances
> 	its callbacks.	The callback for data item A is therefore in
> 	the RCU_DONE_TAIL segment of the callback queue.  This means
> 	that this callback is now considered ready to be invoked.
> 
> 12.	CPU 16 invokes the callback, freeing data item A while CPU 1
> 	is still referencing it.
> 
> This sort of scenario represents a day-one bug for TREE_RCU, however,
> the recent changes that permit RCU grace-period initialization to
> be preempted made it much more probable.  Still, it is sufficiently
> improbable to make validation lengthy and inconvenient, so this commit
> adds an anti-heisenbug to greatly increase the collision cross section,
> also known as the probability of occurrence.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 4cfe488..1373388 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -52,6 +52,7 @@
>  #include <linux/prefetch.h>
>  #include <linux/delay.h>
>  #include <linux/stop_machine.h>
> +#include <linux/random.h>
>  
>  #include "rcutree.h"
>  #include <trace/events/rcu.h>
> @@ -1105,6 +1106,10 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  					    rnp->level, rnp->grplo,
>  					    rnp->grphi, rnp->qsmask);
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +#ifdef CONFIG_PROVE_RCU_DELAY
> +		if ((random32() % (rcu_num_nodes * 8)) == 0)
> +			schedule_timeout_uninterruptible(2);
> +#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
>  		cond_resched();
>  	}
>  
> -- 
> 1.7.8
> 
