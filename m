Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab2EVR2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:28:33 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:39710 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2EVR2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:28:31 -0400
Date: Tue, 22 May 2012 10:27:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 17/41] rcu: Restart tick if we enqueue a callback in a
 nohz/cpuset CPU
Message-ID: <20120522172714.GC8087@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-18-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335830115-14335-18-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052217-5518-0000-0000-0000049771D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:54:51AM +0200, Frederic Weisbecker wrote:
> If we enqueue an rcu callback, we need the CPU tick to stay
> alive until we take care of those by completing the appropriate
> grace period.
> 
> Thus, when we call_rcu(), send a self IPI that checks rcu_needs_cpu()
> so that we restore a periodic tick behaviour that can take care of
> everything.

Ouch, I hadn't considered RCU callbacks being posted from within an
extended quiescent state.  I guess I need to make __call_rcu() either
complain about this or handle it correctly...  It would -usually- be
harmless, but there is getting to be quite a bit of active machinery
in the various idle loops, so just assuming that it cannot happen is
probably getting to be an obsolete assumption.

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/rcutree.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 3fffc26..b8d300c 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -1749,6 +1749,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
>  	else
>  		trace_rcu_callback(rsp->name, head, rdp->qlen);
> 
> +	/* Restart the timer if needed to handle the callbacks */
> +	if (cpuset_adaptive_nohz()) {
> +		/* Make updates on nxtlist visible to self IPI */
> +		barrier();
> +		smp_cpuset_update_nohz(smp_processor_id());
> +	}
> +
>  	/* If interrupts were disabled, don't dive into RCU core. */
>  	if (irqs_disabled_flags(flags)) {
>  		local_irq_restore(flags);
> -- 
> 1.7.5.4
> 

