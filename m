Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab0HIRoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:44:19 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47011 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab0HIRoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:44:09 -0400
Date: Mon, 9 Aug 2010 10:43:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] rcu,debug_core: allow the kernel debugger to
 reset the rcu stall timer
Message-ID: <20100809174353.GH3026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com>
 <1281330732-17164-2-git-send-email-jason.wessel@windriver.com>
 <1281330732-17164-3-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281330732-17164-3-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 12:12:12AM -0500, Jason Wessel wrote:
> When returning from the kernel debugger allow a reset of the rcu
> jiffies_stall value to prevent the rcu stall detector from sending NMI
> events which stack dumps on all the cpus in the system.

Thank you for forwarding this!

A couple of questions below.

> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Dipankar Sarma <dipankar@in.ibm.com>
> CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/rcupdate.h  |    8 ++++++++
>  kernel/debug/debug_core.c |    2 ++
>  kernel/rcutree.c          |    9 +++++++++
>  3 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 9fbc54a..abd3ab6 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -599,4 +599,12 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
>  #define rcu_dereference_index_check(p, c) \
>  	__rcu_dereference_index_check((p), (c))
> 
> +#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
> +extern void rcu_cpu_stall_reset(void);
> +#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> +static inline void rcu_cpu_stall_reset(void)
> +{
> +}
> +#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> +
>  #endif /* __LINUX_RCUPDATE_H */
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index e4d6819..1600e90 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -47,6 +47,7 @@
>  #include <linux/pid.h>
>  #include <linux/smp.h>
>  #include <linux/mm.h>
> +#include <linux/rcupdate.h>
> 
>  #include <asm/cacheflush.h>
>  #include <asm/byteorder.h>
> @@ -474,6 +475,7 @@ static void dbg_touch_watchdogs(void)
>  {
>  	touch_softlockup_watchdog_sync();
>  	clocksource_touch_watchdog();
> +	rcu_cpu_stall_reset();
>  }
> 
>  static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index d5bc439..209b755 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -532,6 +532,9 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
> 
>  	if (rcu_cpu_stall_panicking)
>  		return;
> +	/* Gracefully handle a watch dog reset when jiffies_stall == 0 */
> +	if (!rsp->jiffies_stall)
> +		return;
>  	delta = jiffies - rsp->jiffies_stall;
>  	rnp = rdp->mynode;
>  	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
> @@ -561,6 +564,12 @@ static void __init check_cpu_stall_init(void)
>  	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
>  }
> 
> +void rcu_cpu_stall_reset(void)
> +{
> +	rcu_sched_state.jiffies_stall = 0;
> +	rcu_bh_state.jiffies_stall = 0;
> +}
> +

OK, so you are suppressing RCU CPU stall warnings for rcu_sched and
rcu_bh, but not for preemptible RCU.  I believe that you want all of
them covered.

I have a number of recent patches that allow RCU CPU stall warnings to
be suppressed, one of which allows them to be suppressed using sysfs.
Would that work for you, or do you need an in-kernel interface?

If you do need an in-kernel interface, I could export (and probably
rename) rcu_panic(), which is a static in 2.6.35.  This assumes that you
never want to re-enable RCU CPU stall warnings once you suppress them,
which is what your patch appears to do.

So, if I export a suppress_rcu_cpu_stall() function that permanently
disabled RCU CPU stall warnings, would that work for you?  (They could
be manually re-enabled via sysfs.)

>  #else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
> 
>  static void record_gp_stall_check_time(struct rcu_state *rsp)
> -- 
> 1.6.3.3
> 
