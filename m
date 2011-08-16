Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab1HPUUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 16:20:16 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59638 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab1HPUUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 16:20:14 -0400
Date: Tue, 16 Aug 2011 13:20:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 22/32] rcu: Restart tick if we enqueue a callback in a
 nohz/cpuset CPU
Message-ID: <20110816202005.GH2404@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-23-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313423549-27093-23-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 05:52:19PM +0200, Frederic Weisbecker wrote:
> If we enqueue an rcu callback, we need the CPU tick to stay
> alive until we take care of those by completing the appropriate
> grace period.
> 
> Thus, when we call_rcu(), send a self IPI that checks rcu_needs_cpu()
> so that we restore a periodic tick behaviour that can take care of
> everything.

One question below.

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Anton Blanchard <anton@au1.ibm.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Menage <menage@google.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d496c70..b5643ce2 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -51,6 +51,7 @@
>  #include <linux/kthread.h>
>  #include <linux/prefetch.h>
>  #include <linux/cpuset.h>
> +#include <linux/tick.h>
> 
>  #include "rcutree.h"
> 
> @@ -1546,6 +1547,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
>  	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
>  	rdp->qlen++;
> 
> +	/* Restart the timer if needed to handle the callbacks */
> +	if (tick_nohz_adaptive_mode()) {
> +		/* Make updates on nxtlist visible to self IPI */
> +		barrier();
> +		smp_cpuset_update_nohz(smp_processor_id());
> +	}
> +

But this must be happening in a system call or interrupt handler, right?
If so, won't we get a chance to check things on exit from the system call
or interrupt?  Or are you hooking only into syscall entry?

>  	/* If interrupts were disabled, don't dive into RCU core. */
>  	if (irqs_disabled_flags(flags)) {
>  		local_irq_restore(flags);
> -- 
> 1.7.5.4
> 
