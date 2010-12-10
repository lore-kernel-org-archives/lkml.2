Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab0LJW7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 17:59:00 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55199 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab0LJW67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 17:58:59 -0500
Date: Fri, 10 Dec 2010 14:58:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>, laijs@cn.fujitsu.com
Subject: Re: [PATCH 1/2] rcu: Stop chasing QS if another CPU did it for us
Message-ID: <20101210225855.GJ2125@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292015471-19227-1-git-send-email-fweisbec@gmail.com>
 <1292015471-19227-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292015471-19227-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 10:11:10PM +0100, Frederic Weisbecker wrote:
> When a CPU is idle and others CPUs handled its extended
> quiescent state to complete grace periods on its behalf,
> it will catch up with completed grace periods numbers
> when it wakes up.
> 
> But at this point there might be no more grace period to
> complete, but still the woken CPU always keeps its stale
> qs_pending value and will then continue to chase quiescent
> states even if its not needed anymore.
> 
> This results in clusters of spurious softirqs until a new
> real grace period is started. Because if we continue to
> chase quiescent states but we have completed every grace
> periods, rcu_report_qs_rdp() is puzzled and makes that
> state run into infinite loops.
> 
> As suggested by Lai Jiangshan, just reset qs_pending if
> someone completed every grace periods on our behalf.

Nice!!!

I have queued this patch, and followed it up with a patch that changes
the condition to "rnp->qsmask & rdp->grpmask", which indicates that RCU
needs a quiescent state from the CPU, and is valid regardless of how
messed up the CPU is about which grace period is which.

I am making a similar change to the check in __note_new_gpnum().

Seem reasonable?

							Thanx, Paul

> Suggested-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/rcutree.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ccdc04c..8c4ed60 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -681,6 +681,14 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
> 
>  		/* Remember that we saw this grace-period completion. */
>  		rdp->completed = rnp->completed;
> +
> +		/*
> +		 * If another CPU handled our extended quiescent states and
> +		 * we have no more grace period to complete yet, then stop
> +		 * chasing quiescent states.
> +		 */
> +		if (rdp->completed == rnp->gpnum)
> +			rdp->qs_pending = 0;
>  	}
>  }
> 
> -- 
> 1.7.3.2
> 
