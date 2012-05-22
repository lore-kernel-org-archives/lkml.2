Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab2EVSf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:35:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46992 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2EVSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:35:25 -0400
Date: Tue, 22 May 2012 11:33:52 -0700
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
Subject: Re: [PATCH 38/41] rcu: New rcu_user_enter_irq() and
 rcu_user_exit_irq() APIs
Message-ID: <20120522183352.GE8087@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-39-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335830115-14335-39-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052218-2398-0000-0000-000006DA6A47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2012 at 01:55:12AM +0200, Frederic Weisbecker wrote:
> A CPU running in adaptive tickless mode wants to enter into
> RCU extended quiescent state while running in userspace. This
> way we can shut down the tick that is usually needed on each
> CPU for the needs of RCU.
> 
> Typically, RCU enters the extended quiescent state when we resume
> to userspace through a syscall or exception exit, this is done
> using rcu_user_enter(). Then RCU exit this state by calling
> rcu_user_exit() from syscall or exception entry.
> 
> However there are two other points where we may want to enter
> or exit this state. Some remote CPU may require a tickless CPU
> to restart its tick for any reason and send it an IPI for
> this purpose. As we restart the tick, we don't want to resume
> from the IPI in RCU extended quiescent state anymore.
> Similarly we may stop the tick from an interrupt in userspace and
> we need to be able to enter RCU extended quiescent state when we
> resume from this interrupt to userspace.
> 
> To these ends, we provide two new APIs:
> 
> - rcu_user_enter_irq(). This must be called from a non-nesting
> interrupt betwenn rcu_irq_enter() and rcu_irq_exit().
> After the irq calls rcu_irq_exit(), we'll run into RCU extended
> quiescent state.
> 
> - rcu_user_exit_irq(). This must be called from a non-nesting
> interrupt, interrupting an RCU extended quiescent state, and
> between rcu_irq_enter() and rcu_irq_exit(). After the irq calls
> rcu_irq_exit(), we'll prevent from resuming the RCU extended
> quiescent.

In both cases, the IRQ handler must correspond to an interrupt from
task/thread/process/whatever level, so that it is illegal to call
these from an interrupt handler that was invoked from within another
interrupt.  Right?

A couple more questions and comments below.

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
>  include/linux/rcupdate.h |    2 ++
>  kernel/rcutree.c         |   24 ++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 6539290..3cf1d51 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -194,6 +194,8 @@ extern void rcu_irq_exit(void);
>  #ifdef CONFIG_CPUSETS_NO_HZ
>  void rcu_user_enter(void);
>  void rcu_user_exit(void);
> +void rcu_user_enter_irq(void);
> +void rcu_user_exit_irq(void);
>  #endif
> 
>  /*
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index cba1332..2adc5a0 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -429,6 +429,18 @@ void rcu_user_enter(void)
>  	__rcu_idle_enter();
>  }
> 
> +void rcu_user_enter_irq(void)

It took me a bit to correctly parse the name, which goes something
like RCU adaptive-tick user enter while in an IRQ handler.  A header
comment would help.  (I can supply one when it is time for this to
go into -rcu.)

> +{
> +	unsigned long flags;
> +	struct rcu_dynticks *rdtp;
> +
> +	local_irq_save(flags);
> +	rdtp = &__get_cpu_var(rcu_dynticks);
> +	WARN_ON_ONCE(rdtp->dynticks_nesting == 1);
> +	rdtp->dynticks_nesting = 1;
> +	local_irq_restore(flags);
> +}
> +
>  /**
>   * rcu_irq_exit - inform RCU that current CPU is exiting irq towards idle
>   *
> @@ -543,6 +555,18 @@ void rcu_user_exit(void)
>  	local_irq_restore(flags);
>  }
> 
> +void rcu_user_exit_irq(void)
> +{
> +	unsigned long flags;
> +	struct rcu_dynticks *rdtp;
> +
> +	local_irq_save(flags);
> +	rdtp = &__get_cpu_var(rcu_dynticks);
> +	WARN_ON_ONCE(rdtp->dynticks_nesting == 0);

For symmetry, wouldn't this be as follows?

	WARN_ON_ONCE(rdtp->dynticks_nesting >= LLONG_MAX / 4);

In other words, complain if the task is trying to exit RCU-idle state when
it has already exited from RCU-idle state?

Of course, it had better not be zero as well.  Or negative, for that
matter.

> +	rdtp->dynticks_nesting = (LLONG_MAX / 2) + 1;
> +	local_irq_restore(flags);
> +}
> +
>  /**
>   * rcu_irq_enter - inform RCU that current CPU is entering irq away from idle
>   *
> -- 
> 1.7.5.4
> 

