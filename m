Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab2EVRVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:21:55 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:58562 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab2EVRVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:21:54 -0400
Date: Tue, 22 May 2012 10:20:50 -0700
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
Subject: Re: [PATCH 16/41] rcu: Restart the tick on non-responding adaptive
 nohz CPUs
Message-ID: <20120522172050.GB8087@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-17-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335830115-14335-17-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052217-5518-0000-0000-0000049761CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:54:50AM +0200, Frederic Weisbecker wrote:
> When a CPU in adaptive nohz mode doesn't respond to complete
> a grace period, issue it a specific IPI so that it restarts
> the tick and chases a quiescent state.

Hello, Frederic,

I don't understand the need for this patch.  If the CPU is in
adaptive-tick mode, RCU should see it as being in dyntick-idle mode,
right?  If so, shouldn't RCU have already recognized the CPU as being
in an extended quiescent state?

Or is this a belt-and-suspenders situation?

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
>  kernel/rcutree.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index e141c7e..3fffc26 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -50,6 +50,7 @@
>  #include <linux/wait.h>
>  #include <linux/kthread.h>
>  #include <linux/prefetch.h>
> +#include <linux/cpuset.h>
> 
>  #include "rcutree.h"
>  #include <trace/events/rcu.h>
> @@ -302,6 +303,20 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
> 
>  #ifdef CONFIG_SMP
> 
> +static void cpuset_update_rcu_cpu(int cpu)
> +{
> +#ifdef CONFIG_CPUSETS_NO_HZ
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +
> +	if (cpuset_cpu_adaptive_nohz(cpu))
> +		smp_cpuset_update_nohz(cpu);
> +
> +	local_irq_restore(flags);
> +#endif
> +}
> +
>  /*
>   * If the specified CPU is offline, tell the caller that it is in
>   * a quiescent state.  Otherwise, whack it with a reschedule IPI.
> @@ -325,6 +340,8 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
>  		return 1;
>  	}
> 
> +	cpuset_update_rcu_cpu(rdp->cpu);
> +
>  	/*
>  	 * The CPU is online, so send it a reschedule IPI.  This forces
>  	 * it through the scheduler, and (inefficiently) also handles cases
> -- 
> 1.7.5.4
> 

