Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2G0QlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 12:41:18 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37013 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2G0QlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 12:41:17 -0400
Date: Fri, 27 Jul 2012 09:40:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] user_hooks: New user hooks subsystem
Message-ID: <20120727164054.GJ2442@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1343403634-31555-1-git-send-email-fweisbec@gmail.com>
 <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343403634-31555-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072716-2398-0000-0000-000008E531F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 05:40:30PM +0200, Frederic Weisbecker wrote:
> Create a new subsystem that handles the hooks on kernel/user
> boundaries currently used by RCU for its userspace extended
> quiescent state.
> 
> We need to pull this up from RCU into this new level of indirection
> because these hooks are also going to be used to implement an "on
> demand" generic virtual cputime accounting. A necessary step to
> shutdown the tick while still accounting the cputime.

So this eliminates the case where the architecture might enter an
RCU extended quiescent state multiple times, but exit it only once?
(I am hoping that it does...)

							Thanx, Paul

[ . . . ]

> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 318d00e..f6a24cb 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -212,9 +212,6 @@ EXPORT_SYMBOL_GPL(rcu_note_context_switch);
>  DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
>  	.dynticks_nesting = DYNTICK_TASK_EXIT_IDLE,
>  	.dynticks = ATOMIC_INIT(1),
> -#if defined(CONFIG_RCU_USER_QS) && !defined(CONFIG_RCU_USER_QS_FORCE)
> -	.ignore_user_qs = true,
> -#endif
>  };
> 
>  static int blimit = 10;		/* Maximum callbacks per rcu_do_batch. */
> @@ -448,18 +445,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
>   */
>  void rcu_user_enter(void)
>  {
> -	unsigned long flags;
> -	struct rcu_dynticks *rdtp;
> -
> -	WARN_ON_ONCE(!current->mm);
> -
> -	local_irq_save(flags);
> -	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (!rdtp->ignore_user_qs && !rdtp->in_user) {
> -		rdtp->in_user = true;
> -		rcu_eqs_enter(1);
> -	}
> -	local_irq_restore(flags);
> +	rcu_eqs_enter(1);
>  }
>  EXPORT_SYMBOL_GPL(rcu_user_enter);
> 
> @@ -597,16 +583,7 @@ EXPORT_SYMBOL_GPL(rcu_idle_exit);
>   */
>  void rcu_user_exit(void)
>  {
> -	unsigned long flags;
> -	struct rcu_dynticks *rdtp;
> -
> -	local_irq_save(flags);
> -	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (rdtp->in_user) {
> -		rdtp->in_user = false;
> -		rcu_eqs_exit(1);
> -	}
> -	local_irq_restore(flags);
> +	rcu_eqs_exit(1);
>  }
>  EXPORT_SYMBOL_GPL(rcu_user_exit);
> 
> @@ -730,21 +707,6 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
> 
> -#ifdef CONFIG_RCU_USER_QS
> -void rcu_user_hooks_switch(struct task_struct *prev,
> -			   struct task_struct *next)
> -{
> -	struct rcu_dynticks *rdtp;
> -
> -	/* Interrupts are disabled in context switch */
> -	rdtp = &__get_cpu_var(rcu_dynticks);
> -	if (!rdtp->ignore_user_qs) {
> -		clear_tsk_thread_flag(prev, TIF_NOHZ);
> -		set_tsk_thread_flag(next, TIF_NOHZ);
> -	}
> -}
> -#endif /* #ifdef CONFIG_RCU_USER_QS */
> -
>  #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
> 
>  /*

[ . . . ]

