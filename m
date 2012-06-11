Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822Ab2FKNkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:40:17 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57386 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab2FKNkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:40:15 -0400
Date: Mon, 11 Jun 2012 06:39:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <mgalbraith@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: endless stalls
Message-ID: <20120611133953.GI2425@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1339409176.7350.26.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339409176.7350.26.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061113-7606-0000-0000-0000010652BA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 12:06:16PM +0200, Mike Galbraith wrote:
> Greetings,
> 
> I received a report of a 48 core UV box hitting a gripe, taking longer
> than timeout to emit same, so box griped endlessly, forcing reboot.

So it took minutes to print an RCU CPU stall warning?  On only 48 CPUs?

If so, yow!!!

My guess is that rcu_cpu_stall_suppress must be manipulated atomically
for this to work reliably, for example, using xchg().

							Thanx, Paul

> The below might prevent that.. and bust other stuff for free :)
> 
> rcu: one gripe at a time please
> 
> Not-compiled-by:
> Not-signed-off-by:
> Not-etc-by:
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 0da7b88..6462056d6 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -818,10 +818,25 @@ static void print_cpu_stall(struct rcu_state *rsp)
>  	set_need_resched();  /* kick ourselves to get things going. */
>  }
> 
> +/**
> + * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
> + *
> + * Set the stall-warning timeout way off into the future, thus preventing
> + * any RCU CPU stall-warning messages from appearing in the current set of
> + * RCU grace periods.
> + *
> + * The caller must disable hard irqs.
> + */
> +void rcu_cpu_stall_reset(void)
> +{
> +	rcu_sched_state.jiffies_stall = jiffies + ULONG_MAX / 2;
> +	rcu_bh_state.jiffies_stall = jiffies + ULONG_MAX / 2;
> +	rcu_preempt_stall_reset();
> +}
> +
>  static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
>  {
> -	unsigned long j;
> -	unsigned long js;
> +	unsigned long j, js, flags;
>  	struct rcu_node *rnp;
> 
>  	if (rcu_cpu_stall_suppress)
> @@ -832,13 +847,23 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
>  	if ((ACCESS_ONCE(rnp->qsmask) & rdp->grpmask) && ULONG_CMP_GE(j, js)) {
> 
>  		/* We haven't checked in, so go dump stack. */
> +		rcu_cpu_stall_suppress = 1;
>  		print_cpu_stall(rsp);
> +		local_irq_save(flags);
> +		rcu_cpu_stall_reset();
> +		local_irq_restore(flags);
> +		rcu_cpu_stall_suppress = 0;
> 
>  	} else if (rcu_gp_in_progress(rsp) &&
>  		   ULONG_CMP_GE(j, js + RCU_STALL_RAT_DELAY)) {
> 
>  		/* They had a few time units to dump stack, so complain. */
> +		rcu_cpu_stall_suppress = 1;
>  		print_other_cpu_stall(rsp);
> +		local_irq_save(flags);
> +		rcu_cpu_stall_reset();
> +		local_irq_restore(flags);
> +		rcu_cpu_stall_suppress = 0;
>  	}
>  }
> 
> @@ -848,22 +873,6 @@ static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
>  	return NOTIFY_DONE;
>  }
> 
> -/**
> - * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
> - *
> - * Set the stall-warning timeout way off into the future, thus preventing
> - * any RCU CPU stall-warning messages from appearing in the current set of
> - * RCU grace periods.
> - *
> - * The caller must disable hard irqs.
> - */
> -void rcu_cpu_stall_reset(void)
> -{
> -	rcu_sched_state.jiffies_stall = jiffies + ULONG_MAX / 2;
> -	rcu_bh_state.jiffies_stall = jiffies + ULONG_MAX / 2;
> -	rcu_preempt_stall_reset();
> -}
> -
>  static struct notifier_block rcu_panic_block = {
>  	.notifier_call = rcu_panic,
>  };
> 
> 

