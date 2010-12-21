Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab0LUT0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 14:26:51 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53869 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab0LUT0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 14:26:48 -0500
Date: Tue, 21 Dec 2010 11:26:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 09/15] rcu: Make rcu_enter,exit_nohz() callable
 from irq
Message-ID: <20101221192635.GO2143@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-10-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292858662-5650-10-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 04:24:16PM +0100, Frederic Weisbecker wrote:
> In order to be able to enter/exit into rcu extended quiescent
> state from interrupt, we need to make rcu_enter_nohz() and
> rcu_exit_nohz() callable from interrupts.
> 
> So, this proposes a new implementation of the rcu nohz fast path
> related helpers, where rcu_enter_nohz() or rcu_exit_nohz() can
> be called between rcu_enter_irq() and rcu_exit_irq() while keeping
> the existing semantics.
> 
> We maintain three per cpu fields:
> 
> - nohz indicates we entered into extended quiescent state mode,
> we may or not be in an interrupt even if that state is set though.
> 
> - irq_nest indicates we are in an irq. This number is incremented on
> irq entry and decreased on irq exit. This includes NMIs
> 
> - qs_seq is increased everytime we see a true extended quiescent
> state:
> 	* When we call rcu_enter_nohz() and we are not in an irq.
> 	* When we exit the outer most nesting irq and we are in
> 	  nohz mode (rcu_enter_nohz() was called without a pairing
> 	  rcu_exit_nohz() yet).
> 
> >From that three-part we can deduce the extended grace periods like
> we did before on top of snapshots and comparisons.
> 
> If nohz == 1 and irq_nest == 0, we are in a quiescent state. qs_seq
> is used to keep track of elapsed extended quiescent states, useful
> to compare snapshots of rcu nohz state.
> 
> This is experimental and does not take care of barriers yet.

Indeed!!!

I will likely be reworking the dyntick interface soon anyway, so will
try to make sure that your requirements are met.

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Anton Blanchard <anton@au1.ibm.com>
> Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> ---
>  kernel/rcutree.c |  103 ++++++++++++++++++++++-------------------------------
>  kernel/rcutree.h |   12 +++----
>  2 files changed, 48 insertions(+), 67 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ed6aba3..1ac1a61 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -129,10 +129,7 @@ void rcu_note_context_switch(int cpu)
>  }
> 
>  #ifdef CONFIG_NO_HZ
> -DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
> -	.dynticks_nesting = 1,
> -	.dynticks = 1,
> -};
> +DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks);
>  #endif /* #ifdef CONFIG_NO_HZ */
> 
>  static int blimit = 10;		/* Maximum callbacks per softirq. */
> @@ -272,16 +269,15 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
>   */
>  void rcu_enter_nohz(void)
>  {
> -	unsigned long flags;
>  	struct rcu_dynticks *rdtp;
> 
> -	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> -	local_irq_save(flags);
> +	preempt_disable();
>  	rdtp = &__get_cpu_var(rcu_dynticks);
> -	rdtp->dynticks++;
> -	rdtp->dynticks_nesting--;
> -	WARN_ON_ONCE(rdtp->dynticks & 0x1);
> -	local_irq_restore(flags);
> +	WARN_ON_ONCE(rdtp->nohz);
> +	rdtp->nohz = 1;
> +	if (!rdtp->irq_nest)
> +		local_inc(&rdtp->qs_seq);
> +	preempt_enable();
>  }
> 
>  /*
> @@ -292,16 +288,13 @@ void rcu_enter_nohz(void)
>   */
>  void rcu_exit_nohz(void)
>  {
> -	unsigned long flags;
>  	struct rcu_dynticks *rdtp;
> 
> -	local_irq_save(flags);
> +	preempt_disable();
>  	rdtp = &__get_cpu_var(rcu_dynticks);
> -	rdtp->dynticks++;
> -	rdtp->dynticks_nesting++;
> -	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
> -	local_irq_restore(flags);
> -	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> +	WARN_ON_ONCE(!rdtp->nohz);
> +	rdtp->nohz = 0;
> +	preempt_enable();
>  }
> 
>  /**
> @@ -313,13 +306,7 @@ void rcu_exit_nohz(void)
>   */
>  void rcu_nmi_enter(void)
>  {
> -	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> -
> -	if (rdtp->dynticks & 0x1)
> -		return;
> -	rdtp->dynticks_nmi++;
> -	WARN_ON_ONCE(!(rdtp->dynticks_nmi & 0x1));
> -	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> +	rcu_irq_enter();
>  }
> 
>  /**
> @@ -331,13 +318,7 @@ void rcu_nmi_enter(void)
>   */
>  void rcu_nmi_exit(void)
>  {
> -	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> -
> -	if (rdtp->dynticks & 0x1)
> -		return;
> -	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> -	rdtp->dynticks_nmi++;
> -	WARN_ON_ONCE(rdtp->dynticks_nmi & 0x1);
> +	rcu_irq_exit();
>  }
> 
>  /**
> @@ -350,11 +331,7 @@ void rcu_irq_enter(void)
>  {
>  	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> 
> -	if (rdtp->dynticks_nesting++)
> -		return;
> -	rdtp->dynticks++;
> -	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
> -	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> +	rdtp->irq_nest++;
>  }
> 
>  /**
> @@ -368,11 +345,11 @@ void rcu_irq_exit(void)
>  {
>  	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
> 
> -	if (--rdtp->dynticks_nesting)
> +	if (--rdtp->irq_nest)
>  		return;
> -	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> -	rdtp->dynticks++;
> -	WARN_ON_ONCE(rdtp->dynticks & 0x1);
> +
> +	if (rdtp->nohz)
> +		local_inc(&rdtp->qs_seq);
> 
>  	/* If the interrupt queued a callback, get out of dyntick mode. */
>  	if (__get_cpu_var(rcu_sched_data).nxtlist ||
> @@ -390,15 +367,19 @@ void rcu_irq_exit(void)
>  static int dyntick_save_progress_counter(struct rcu_data *rdp)
>  {
>  	int ret;
> -	int snap;
> -	int snap_nmi;
> +	int snap_nohz;
> +	int snap_irq_nest;
> +	long snap_qs_seq;
> 
> -	snap = rdp->dynticks->dynticks;
> -	snap_nmi = rdp->dynticks->dynticks_nmi;
> +	snap_nohz = rdp->dynticks->nohz;
> +	snap_irq_nest = rdp->dynticks->irq_nest;
> +	snap_qs_seq = local_read(&rdp->dynticks->qs_seq);
>  	smp_mb();	/* Order sampling of snap with end of grace period. */
> -	rdp->dynticks_snap = snap;
> -	rdp->dynticks_nmi_snap = snap_nmi;
> -	ret = ((snap & 0x1) == 0) && ((snap_nmi & 0x1) == 0);
> +	rdp->dynticks_snap.nohz = snap_nohz;
> +	rdp->dynticks_snap.irq_nest = snap_irq_nest;
> +	local_set(&rdp->dynticks_snap.qs_seq, snap_qs_seq);
> +
> +	ret = (snap_nohz && !snap_irq_nest);
>  	if (ret)
>  		rdp->dynticks_fqs++;
>  	return ret;
> @@ -412,15 +393,10 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
>   */
>  static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
>  {
> -	long curr;
> -	long curr_nmi;
> -	long snap;
> -	long snap_nmi;
> +	struct rcu_dynticks curr, snap;
> 
> -	curr = rdp->dynticks->dynticks;
> +	curr = *rdp->dynticks;
>  	snap = rdp->dynticks_snap;
> -	curr_nmi = rdp->dynticks->dynticks_nmi;
> -	snap_nmi = rdp->dynticks_nmi_snap;
>  	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
> 
>  	/*
> @@ -431,14 +407,21 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
>  	 * read-side critical section that started before the beginning
>  	 * of the current RCU grace period.
>  	 */
> -	if ((curr != snap || (curr & 0x1) == 0) &&
> -	    (curr_nmi != snap_nmi || (curr_nmi & 0x1) == 0)) {
> -		rdp->dynticks_fqs++;
> -		return 1;
> -	}
> +	if (curr.nohz && !curr.irq_nest)
> +		goto dynticks_qs;
> +
> +	if (snap.nohz && !snap.irq_nest)
> +		goto dynticks_qs;
> +
> +	if (local_read(&curr.qs_seq) != local_read(&snap.qs_seq))
> +		goto dynticks_qs;
> 
>  	/* Go check for the CPU being offline. */
>  	return rcu_implicit_offline_qs(rdp);
> +
> +dynticks_qs:
> +	rdp->dynticks_fqs++;
> +	return 1;
>  }
> 
>  #endif /* #ifdef CONFIG_SMP */
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 91d4170..215e431 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -27,6 +27,7 @@
>  #include <linux/threads.h>
>  #include <linux/cpumask.h>
>  #include <linux/seqlock.h>
> +#include <asm/local.h>
> 
>  /*
>   * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
> @@ -79,11 +80,9 @@
>   * Dynticks per-CPU state.
>   */
>  struct rcu_dynticks {
> -	int dynticks_nesting;	/* Track nesting level, sort of. */
> -	int dynticks;		/* Even value for dynticks-idle, else odd. */
> -	int dynticks_nmi;	/* Even value for either dynticks-idle or */
> -				/*  not in nmi handler, else odd.  So this */
> -				/*  remains even for nmi from irq handler. */
> +	int nohz;
> +	local_t qs_seq;
> +	int irq_nest;
>  };
> 
>  /*
> @@ -212,8 +211,7 @@ struct rcu_data {
>  #ifdef CONFIG_NO_HZ
>  	/* 3) dynticks interface. */
>  	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
> -	int dynticks_snap;		/* Per-GP tracking for dynticks. */
> -	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
> +	struct rcu_dynticks dynticks_snap;
>  #endif /* #ifdef CONFIG_NO_HZ */
> 
>  	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
> -- 
> 1.7.3.2
> 
