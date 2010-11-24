Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0KXBDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:03:32 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35007 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab0KXBDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:03:31 -0500
Date: Tue, 23 Nov 2010 17:03:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] rcu: Stop checking quiescent states after grace
 period completion from remote
Message-ID: <20101124010301.GJ8056@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
 <1290558673-23580-3-git-send-crap-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290558673-23580-3-git-send-crap-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 01:31:13AM +0100, Frederic Weisbecker wrote:
> After a CPU starts to chase its quiescent states by setting
> rdp->qs_pending to 1, it can still enter into an extended
> quiescent state and then another CPU will take care of this
> and complete the grace period if necessary.
> 
> rcu_report_qs_rdp() currently doesn't handle well this case
> and considers it must try later to notify its quiescent state.
> 
> However if the last grace period has been completed there is
> nothing left to do for the current CPU.
> 
> It means that until a next grace period starts, the CPU that
> runs into that case will keep chasing its own quiescent states
> by raising a softirq on every tick for no good reason.
> 
> This can take a while before a new grace period starts and
> this time slice is covered by spurious softirqs and other
> kinds of rcu checks.
> 
> Fix this by resetting rdp->qs_pending if the last grace
> period has been completed by a remote CPU while we were
> in an extended quiescent state.

This one looks very good, at least at first glance!!!  Queued.

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/rcutree.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 5f038a1..f287eaa 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -937,6 +937,15 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
>  		 * race occurred.
>  		 */
>  		rdp->passed_quiesc = 0;	/* try again later! */
> +
> +		/*
> +		 * Another CPU may have taken care of us if we were in an
> +		 * extended quiescent state, in which case we don't need
> +		 * to continue to track anything.
> +		 */
> +		if (rnp->gpnum == rnp->completed)
> +			rdp->qs_pending = 0;
> +
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  		return;
>  	}
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
