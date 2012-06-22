Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2FVTw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:52:29 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47521 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2FVTw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:52:28 -0400
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.46.74
Date: Fri, 22 Jun 2012 12:52:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/urgent] rcu: Stop rcu_do_batch() from
 multiplexing the "count" variable
Message-ID: <20120622195213.GA18467@leaf>
References: <20120622153738.GA6800@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622153738.GA6800@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 08:37:38AM -0700, Paul E. McKenney wrote:
> Commit b1420f1c (Make rcu_barrier() less disruptive) rearranged the
> code in rcu_do_batch(), moving the ->qlen manipulation to follow
> the requeueing of the callbacks.  Unfortunately, this rearrangement
> clobbered the value of the "count" local variable before the value
> of rdp->qlen was adjusted, resulting in the value of rdp->qlen being
> inaccurate.  This commit therefore introduces an index variable "i",
> avoiding the inadvertent multiplexing.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 2f34d02..2001d38 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1593,7 +1593,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>  {
>  	unsigned long flags;
>  	struct rcu_head *next, *list, **tail;
> -	int bl, count, count_lazy;
> +	int bl, count, count_lazy, i;
>  
>  	/* If no callbacks are ready, just return.*/
>  	if (!cpu_has_callbacks_ready_to_invoke(rdp)) {
> @@ -1616,9 +1616,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>  	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
>  	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
>  	tail = rdp->nxttail[RCU_DONE_TAIL];
> -	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
> -		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
> -			rdp->nxttail[count] = &rdp->nxtlist;
> +	for (i = RCU_NEXT_SIZE - 1; i >= 0; i--)
> +		if (rdp->nxttail[i] == rdp->nxttail[RCU_DONE_TAIL])
> +			rdp->nxttail[i] = &rdp->nxtlist;
>  	local_irq_restore(flags);
>  
>  	/* Invoke callbacks. */
> @@ -1646,9 +1646,9 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
>  	if (list != NULL) {
>  		*tail = rdp->nxtlist;
>  		rdp->nxtlist = list;
> -		for (count = 0; count < RCU_NEXT_SIZE; count++)
> -			if (&rdp->nxtlist == rdp->nxttail[count])
> -				rdp->nxttail[count] = tail;
> +		for (i = 0; i < RCU_NEXT_SIZE; i++)
> +			if (&rdp->nxtlist == rdp->nxttail[i])
> +				rdp->nxttail[i] = tail;
>  			else
>  				break;
>  	}
> 
