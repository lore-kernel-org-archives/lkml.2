Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab2ICJkN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:40:13 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59336 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2ICJkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:40:11 -0400
X-Originating-IP: 217.70.178.151
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:39:57 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 17/23] rcu: Fix day-zero grace-period
 initialization/cleanup race
Message-ID: <20120903093957.GF5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-17-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-17-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:32AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The current approach to grace-period initialization is vulnerable to
> extremely low-probabity races.  These races stem fro the fact that the
> old grace period is marked completed on the same traversal through the
> rcu_node structure that is marking the start of the new grace period.
> These races can result in too-short grace periods, as shown in the
> following scenario:
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
> 	can become aware that the prior grace period has completed, but
> 	CPUs corresponding to the other rcu_node structures will see
> 	this same prior grace period as still being in progress.
> 
> 2.	CPU 1 passes through a quiescent state, and therefore informs
> 	the RCU core.  Because its leaf rcu_node structure has already
> 	been initialized, this CPU's quiescent state is applied to the
> 	new (and only partially initialized) grace period.
> 
> 3.	CPU 1 enters an RCU read-side critical section and acquires
> 	a reference to data item A.  Note that this critical section
> 	started after the beginning of the new grace period, and
> 	therefore will not block this new grace period.
> 
> 4.	CPU 16 exits dyntick-idle mode.  Because it was in dyntick-idle
> 	mode, other CPUs informed the RCU core of its extended quiescent
> 	state for the past several grace periods.  This means that CPU
> 	16 is not yet aware that these past grace periods have ended.
> 	Assume that CPU 16 corresponds to the second leaf rcu_node
> 	structure.
> 
> 5.	CPU 16 removes data item A from its enclosing data structure
> 	and passes it to call_rcu(), which queues a callback in the
> 	RCU_NEXT_TAIL segment of the callback queue.
> 
> 6.	CPU 16 enters the RCU core, possibly because it has taken a
> 	scheduling-clock interrupt, or alternatively because it has more
> 	than 10,000 callbacks queued.  It notes that the second most
> 	recent grace period has completed (recall that it cannot yet
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
> 	the RCU_WAIT_TAIL segment of the callback queue.
> 
> 9.	All CPUs other than CPU 1 pass through quiescent states.  Because
> 	CPU 1 already passed through its quiescent state, the new grace
> 	period completes.  Note that CPU 1 is still in its RCU read-side
> 	critical section, still referencing data item A.
> 
> 10.	Suppose that CPU 2 wais the last CPU to pass through a quiescent
> 	state for the new grace period, and suppose further that CPU 2
> 	did not have any callbacks queued, therefore not needing an
> 	additional grace period.  CPU 2 therefore traverses all of the
> 	rcu_node structures, marking the new grace period as completed,
> 	but does not initialize a new grace period.
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
> This scenario represents a day-zero bug for TREE_RCU.  This commit
> therefore ensures that the old grace period is marked completed in
> all leaf rcu_node structures before a new grace period is marked
> started in any of them.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |   36 +++++++++++++-----------------------
>  1 files changed, 13 insertions(+), 23 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d435009..4cfe488 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1161,33 +1161,23 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
>  	 * they can do to advance the grace period.  It is therefore
>  	 * safe for us to drop the lock in order to mark the grace
>  	 * period as completed in all of the rcu_node structures.
> -	 *
> -	 * But if this CPU needs another grace period, it will take
> -	 * care of this while initializing the next grace period.
> -	 * We use RCU_WAIT_TAIL instead of the usual RCU_DONE_TAIL
> -	 * because the callbacks have not yet been advanced: Those
> -	 * callbacks are waiting on the grace period that just now
> -	 * completed.
>  	 */
> -	rdp = this_cpu_ptr(rsp->rda);
> -	if (*rdp->nxttail[RCU_WAIT_TAIL] == NULL) {
> -		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  
> -		/*
> -		 * Propagate new ->completed value to rcu_node
> -		 * structures so that other CPUs don't have to
> -		 * wait until the start of the next grace period
> -		 * to process their callbacks.
> -		 */
> -		rcu_for_each_node_breadth_first(rsp, rnp) {
> -			raw_spin_lock_irqsave(&rnp->lock, flags);
> -			rnp->completed = rsp->gpnum;
> -			raw_spin_unlock_irqrestore(&rnp->lock, flags);
> -			cond_resched();
> -		}
> -		rnp = rcu_get_root(rsp);
> +	/*
> +	 * Propagate new ->completed value to rcu_node structures so
> +	 * that other CPUs don't have to wait until the start of the next
> +	 * grace period to process their callbacks.  This also avoids
> +	 * some nasty RCU grace-period initialization races.
> +	 */
> +	rcu_for_each_node_breadth_first(rsp, rnp) {
>  		raw_spin_lock_irqsave(&rnp->lock, flags);
> +		rnp->completed = rsp->gpnum;
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		cond_resched();
>  	}
> +	rnp = rcu_get_root(rsp);
> +	raw_spin_lock_irqsave(&rnp->lock, flags);
>  
>  	rsp->completed = rsp->gpnum; /* Declare grace period done. */
>  	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
> -- 
> 1.7.8
> 
