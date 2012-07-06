Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab2GFUa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 16:30:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39848 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281Ab2GFUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:30:24 -0400
Date: Fri, 6 Jul 2012 21:30:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: smp: Fix suspicious RCU originating from cpu_die()
Message-ID: <20120706203005.GF31508@n2100.arm.linux.org.uk>
References: <1341531958-31721-1-git-send-email-sboyd@codeaurora.org> <20120706002404.GJ2522@linux.vnet.ibm.com> <4FF730CD.7050907@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF730CD.7050907@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 11:39:09AM -0700, Stephen Boyd wrote:
> On 07/05/12 17:24, Paul E. McKenney wrote:
> > On Thu, Jul 05, 2012 at 04:45:58PM -0700, Stephen Boyd wrote:
> >> @@ -179,7 +184,7 @@ void __ref cpu_die(void)
> >>  	mb();
> >>
> >>  	/* Tell __cpu_die() that this CPU is now safe to dispose of */
> >> -	complete(&cpu_died);
> >> +	__this_cpu_write(cpu_state, CPU_DEAD);
> > Or you could do something like:
> >
> > 	RCU_NONIDLE(complete(&cpu_died));
> >
> > This would tell RCU that it needed to pay attention to this CPU for
> > the duration of the "complete()" function call despite the CPU's being
> > idle.  And might allow you to dispense with the rest of the patch.
> 
> Great! I like that more since we get to keep the completion mechanism
> instead of a busy wait.
> 
> Russell, which one would you prefer? Here's the other version

I think I prefer the version below.

> 
> ----->8-----8<-----
> Subject: [PATCH] ARM: smp: Fix suspicious RCU originating from cpu_die()
> 
> While running hotplug tests I ran into this RCU splat
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.4.0 #3275 Tainted: G        W
> -------------------------------
> include/linux/rcupdate.h:729 rcu_read_lock() used illegally while idle!
> 
> other info that might help us debug this:
> 
> RCU used illegally from idle CPU!
> rcu_scheduler_active = 1, debug_locks = 0
> RCU used illegally from extended quiescent state!
> 4 locks held by swapper/2/0:
>  #0:  ((cpu_died).wait.lock){......}, at: [<c00ab128>] complete+0x1c/0x5c
>  #1:  (&p->pi_lock){-.-.-.}, at: [<c00b275c>] try_to_wake_up+0x2c/0x388
>  #2:  (&rq->lock){-.-.-.}, at: [<c00b2860>] try_to_wake_up+0x130/0x388
>  #3:  (rcu_read_lock){.+.+..}, at: [<c00abe5c>] cpuacct_charge+0x28/0x1f4
> 
> stack backtrace:
> [<c001521c>] (unwind_backtrace+0x0/0x12c) from [<c00abec8>] (cpuacct_charge+0x94/0x1f4)
> [<c00abec8>] (cpuacct_charge+0x94/0x1f4) from [<c00b395c>] (update_curr+0x24c/0x2c8)
> [<c00b395c>] (update_curr+0x24c/0x2c8) from [<c00b59c4>] (enqueue_task_fair+0x50/0x194)
> [<c00b59c4>] (enqueue_task_fair+0x50/0x194) from [<c00afea4>] (enqueue_task+0x30/0x34)
> [<c00afea4>] (enqueue_task+0x30/0x34) from [<c00b0908>] (ttwu_activate+0x14/0x38)
> [<c00b0908>] (ttwu_activate+0x14/0x38) from [<c00b28a8>] (try_to_wake_up+0x178/0x388)
> [<c00b28a8>] (try_to_wake_up+0x178/0x388) from [<c00a82a0>] (__wake_up_common+0x34/0x78)
> [<c00a82a0>] (__wake_up_common+0x34/0x78) from [<c00ab154>] (complete+0x48/0x5c)
> [<c00ab154>] (complete+0x48/0x5c) from [<c07db7cc>] (cpu_die+0x2c/0x58)
> [<c07db7cc>] (cpu_die+0x2c/0x58) from [<c000f954>] (cpu_idle+0x64/0xfc)
> [<c000f954>] (cpu_idle+0x64/0xfc) from [<80208160>] (0x80208160)
> 
> When a cpu is marked offline during its idle thread it calls
> cpu_die() during an RCU idle period. cpu_die() calls complete()
> to notify the killing process that the cpu has died. complete()
> calls into the scheduler code and eventually grabs an RCU read
> lock in cpuacct_charge().
> 
> Mark complete() as RCU_NONIDLE so that RCU pays attention to this
> CPU for the duration of the complete() function even though it's
> in idle.
> 
> Suggested-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/kernel/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 2c7217d..aea74f5 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -179,7 +179,7 @@ void __ref cpu_die(void)
>  	mb();
>  
>  	/* Tell __cpu_die() that this CPU is now safe to dispose of */
> -	complete(&cpu_died);
> +	RCU_NONIDLE(complete(&cpu_died));
>  
>  	/*
>  	 * actual CPU shutdown procedure is at least platform (if not
> 
> -- 
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
