Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab2ICJmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:42:55 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50527 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2ICJmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:42:54 -0400
X-Originating-IP: 217.70.178.150
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:42:46 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 20/23] rcu: Remove callback acceleration
 from grace-period initialization
Message-ID: <20120903094246.GI5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-20-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-20-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:35AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Before grace-period initialization was moved to a kthread, the CPU
> invoking this code would have at least one callback that needed
> a grace period, often a newly registered callback.  However, moving
> grace-period initialization means that the CPU with the callback
> that was requesting a grace period is not necessarily the CPU that
> is initializing the grace period, so this acceleration is less
> valuable.  Because it also adds to the complexity of reasoning about
> correctness, this commit removes it.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c |   19 -------------------
>  1 files changed, 0 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 86903df..44609c3 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1055,25 +1055,6 @@ static int rcu_gp_init(struct rcu_state *rsp)
>  	rsp->gpnum++;
>  	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
>  	record_gp_stall_check_time(rsp);
> -
> -	/*
> -	 * Because this CPU just now started the new grace period, we
> -	 * know that all of its callbacks will be covered by this upcoming
> -	 * grace period, even the ones that were registered arbitrarily
> -	 * recently.    Therefore, advance all RCU_NEXT_TAIL callbacks
> -	 * to RCU_NEXT_READY_TAIL.  When the CPU later recognizes the
> -	 * start of the new grace period, it will advance all callbacks
> -	 * one position, which will cause all of its current outstanding
> -	 * callbacks to be handled by the newly started grace period.
> -	 *
> -	 * Other CPUs cannot be sure exactly when the grace period started.
> -	 * Therefore, their recently registered callbacks must pass through
> -	 * an additional RCU_NEXT_READY stage, so that they will be handled
> -	 * by the next RCU grace period.
> -	 */
> -	rdp = __this_cpu_ptr(rsp->rda);
> -	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
> -
>  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  
>  	/* Exclude any concurrent CPU-hotplug operations. */
> -- 
> 1.7.8
> 
