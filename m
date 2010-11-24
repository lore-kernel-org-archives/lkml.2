Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab0KXA60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 19:58:26 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50952 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab0KXA6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 19:58:24 -0500
Date: Tue, 23 Nov 2010 16:58:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/2] rcu: Don't chase unnecessary quiescent states
 after extended grace periods
Message-ID: <20101124005820.GH8056@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1290558673-23580-1-git-send-crap-fweisbec@gmail.com>
 <1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290558673-23580-2-git-send-crap-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 01:31:12AM +0100, Frederic Weisbecker wrote:
> When a cpu is in an extended quiescent state, which includes idle
> nohz or CPU offline, others CPUs will take care of the grace periods
> on its behalf.
> 
> When this CPU exits its extended quiescent state, it will catch up
> with the last started grace period and start chasing its own
> quiescent states to end the current grace period.
> 
> However in this case we always start to track quiescent states if the
> grace period number has changed since we started our extended
> quiescent state. And we do this because we always assume that the last
> grace period is not finished and needs us to complete it, which is
> sometimes wrong.
> 
> This patch verifies if the last grace period has been completed and
> if so, start hunting local quiescent states like we always did.
> Otherwise don't do anything, this economizes us some work and
> an unnecessary softirq.

Interesting approach!  I can see how this helps in the case where the
CPU just came online, but I don't see it in the nohz case, because the
nohz case does not update the rdp->completed variable.  In contrast,
the online path calls rcu_init_percpu_data() which sets up this variable.

So, what am I missing here?

							Thanx, Paul

PS.  It might well be worthwhile for the online case alone, but
     the commit message does need to be accurate.

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/rcutree.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ccdc04c..5f038a1 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -620,8 +620,17 @@ static void __init check_cpu_stall_init(void)
>  static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_data *rdp)
>  {
>  	if (rdp->gpnum != rnp->gpnum) {
> -		rdp->qs_pending = 1;
> -		rdp->passed_quiesc = 0;
> +		/*
> +		 * Another CPU might have taken take of this new grace period
> +		 * while we were idle and handled us as in an extended quiescent
> +		 * state. In that case, we don't need to chase a local quiescent
> +		 * state, otherwise:
> +		 */
> +		if (rdp->completed != rnp->gpnum) {
> +			rdp->qs_pending = 1;
> +			rdp->passed_quiesc = 0;
> +		}
> +
>  		rdp->gpnum = rnp->gpnum;
>  	}
>  }
> -- 
> 1.7.1
> 
