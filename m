Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab3AHEGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:06:36 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:43111 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3AHEGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:06:35 -0500
Date: Mon, 7 Jan 2013 20:06:26 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 26/33] rcu: Don't keep the tick for RCU while in userspace
Message-ID: <20130108040625.GH2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
 <1357610913-1080-27-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357610913-1080-27-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010804-5518-0000-0000-00000A8C7AE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:08:26AM +0100, Frederic Weisbecker wrote:
> If we are interrupting userspace, we don't need to keep
> the tick for RCU: quiescent states don't need to be reported
> because we soon run in userspace and local callbacks are handled
> by the nocb threads.
> 
> CHECKME: Do the nocb threads actually handle the global
> grace period completion for local callbacks?

First answering this for the nocb stuff in mainline:  In this case,
the grace-period startup is handled by the CPU that is not a nocb
CPU, and there has to be at least one.  The grace-period completion
is handled by the grace-period kthreads.  The nocbs CPU need do
nothing, at least assuming that it gets back into dyntick-idle
(or adaptive tickless) state reasonably quickly.

Second for the version in -rcu: In this case, the nocb kthreads
register the need for a grace period using a new mechanism that
pushes the need up the rcu_node tree.  The grace-period completion
is again handled by the grace-period kthreads.  This allows all
CPUs to be nocbs CPUs.

So, in either case, yes, the below code should be safe as long as
the CPU gets into an RCU-idle state quickly (as in within a few
milliseconds or so).

						Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
> Cc: Namhyung Kim <namhyung.kim@lge.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/time/tick-sched.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 1cd93a9..ecba8b7 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -22,6 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/irq_work.h>
>  #include <linux/posix-timers.h>
> +#include <linux/context_tracking.h>
> 
>  #include <asm/irq_regs.h>
> 
> @@ -604,10 +605,9 @@ static bool can_stop_full_tick(int cpu)
> 
>  	/*
>  	 * Keep the tick if we are asked to report a quiescent state.
> -	 * This must be further optimized (avoid checks for local callbacks,
> -	 * ignore RCU in userspace, etc...
> +	 * This must be further optimized (avoid checks for local callbacks)
>  	 */
> -	if (rcu_pending(cpu)) {
> +	if (!context_tracking_in_user() && rcu_pending(cpu)) {
>  		trace_printk("Can't stop: RCU pending\n");
>  		return false;
>  	}
> -- 
> 1.7.5.4
> 

