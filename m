Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab2FJSHJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 14:07:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41917 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab2FJSHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 14:07:07 -0400
Date: Sun, 10 Jun 2012 11:06:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] rcu: Allow calls to rcu_exit_user_irq from nesting irqs
Message-ID: <20120610180659.GD2425@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
 <20120604181313.GL2490@linux.vnet.ibm.com>
 <CAFTL4hzqa1z4icSBwEqZXLjCrVsG+axm2TaGSaaMXkjazT0Qfw@mail.gmail.com>
 <20120604210709.GO2490@linux.vnet.ibm.com>
 <20120605103055.GA4553@somewhere.redhat.com>
 <20120605234640.GY2388@linux.vnet.ibm.com>
 <20120609225550.GB31957@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120609225550.GB31957@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061018-7606-0000-0000-000001021CE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 10, 2012 at 12:55:54AM +0200, Frederic Weisbecker wrote:
> On Tue, Jun 05, 2012 at 04:46:40PM -0700, Paul E. McKenney wrote:
> > Here you go:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/idle
> 
> So I've rebased my nohz cpusets patchset and applied these patches.
> During testing I found a bug and realized I need to make rcu_exit_user_irq()
> callable from any irq nesting level.

OK.  ;-)

> Here is a fix:
> 
> ---
> >From c30610d5ed2c292a87f7e32216c3419cdc12dff0 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Sat, 9 Jun 2012 14:06:30 +0200
> Subject: [PATCH] rcu: Allow calls to rcu_exit_user_irq from nesting irqs
> 
> rcu_exit_user_irq() which exits RCU idle mode after the current
> irq returns has been designed to be called from non nesting irqs
> only.
> 
> However the IPI that restarts the tick and exits RCU user-idle mode
> in nohz cpusets can happen anytime. For example it can be a nesting
> irq by interrupting a softirq. In this case the stack of RCU API
> calls becomes:
> 
> ==> IRQ
>     rcu_irq_enter()
>     ....
>     do_softirq {
> ===== > IRQ (restart tick IPI)
>         rcu_irq_enter()
>         rcu_exit_user_irq()
>         rcu_irq_exit()
> <=====
>     }
>     rcu_irq_exit();
> 
> Hence we need to make rcu_exit_user_irq() callable from any nesting
> level of interrupt.
> 
> rcu_enter_user_irq() is only called from non nesting irqs though. But
> to stay consistant with the new change we also allow it to be called
> from any irq nesting level.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/rcutree.c |   36 +++++++++++++++---------------------
>  1 files changed, 15 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 1b0dca2..3e84c4c 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -465,11 +465,11 @@ void rcu_user_enter(void)
> 
>  /**
>   * rcu_user_enter_irq - inform RCU that we are going to resume userspace
> - * after the current irq returns.
> + * after the current non-nesting irq returns.
>   *
> - * This is similar to rcu_user_enter() but in the context of a non
> - * nesting irq. After this call, RCU enters into idle mode when the
> - * interrupt returns.
> + * This is similar to rcu_user_enter() but in the context of an
> + * irq. After this call, RCU enters into idle mode when the
> + * current non-nesting interrupt returns.
>   */
>  void rcu_user_enter_irq(void)
>  {
> @@ -478,12 +478,9 @@ void rcu_user_enter_irq(void)
> 
>  	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
> -	/*
> -	 * Ensure this irq is a non nesting one interrupting
> -	 * a non-idle RCU state.
> -	 */
> -	WARN_ON_ONCE(rdtp->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE + 1);
> -	rdtp->dynticks_nesting = 1;
> +	/* Ensure we are interrupting a non-idle RCU state */
> +	WARN_ON_ONCE(!(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK));
> +	rdtp->dynticks_nesting -= DYNTICK_TASK_EXIT_IDLE;

This will be broken on architectures that can fail to return from interrupts
and exceptions and vice versa.  The resulting value of rdtp->dynticks_nesting
might well go negative, or might fail to reach zero when the outermost
interrupt returns.

One workaround would be to add up the relevant fields of preempt_count()
and assign the result to rdtp->dynticks_nesting.

>  	local_irq_restore(flags);
>  }
> 
> @@ -619,12 +616,12 @@ void rcu_user_exit(void)
> 
>  /**
>   * rcu_user_exit_irq - inform RCU that we won't resume to userspace
> - * idle mode after the current irq returns.
> + * idle mode after the current non-nesting irq returns.
>   *
> - * This is similar to rcu_user_exit() but in the context of a non
> - * nesting irq. This is called when the irq has interrupted a userspace
> - * RCU idle mode context. When the interrupt returns after this call,
> - * the CPU won't restore the RCU idle mode.
> + * This is similar to rcu_user_exit() but in the context of an
> + * irq. This is called when the irq has interrupted a userspace
> + * RCU idle mode context. When the current non-nesting interrupt
> + * returns after this call, the CPU won't restore the RCU idle mode.
>   */
>  void rcu_user_exit_irq(void)
>  {
> @@ -633,12 +630,9 @@ void rcu_user_exit_irq(void)
> 
>  	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
> -	/*
> -	 * Ensure this irq is a non-nesting one interrupting
> -	 * an RCU idle mode.
> -	 */
> -	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
> -	rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE + 1;
> +	/* Ensure we are interrupting an RCU idle mode. */
> +	WARN_ON_ONCE(rdtp->dynticks_nesting & DYNTICK_TASK_NEST_MASK);
> +	rdtp->dynticks_nesting += DYNTICK_TASK_EXIT_IDLE;

This one works because all of the interrupt misnesting events that I
know of happen from system-call context, not from idle or from user-mode
execution.

							Thanx, Paul

>  	local_irq_restore(flags);
>  }
> 
> -- 
> 1.7.0.4
> 
> 

