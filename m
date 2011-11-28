Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab1K1Vxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:53:33 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51277 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1K1Vxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:53:32 -0500
X-Originating-IP: 217.70.178.143
X-Originating-IP: 50.43.15.19
Date: Mon, 28 Nov 2011 13:53:23 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4 RFC] rcu: New rcu_user_enter_irq() and
 rcu_user_exit_irq() APIs
Message-ID: <20111128215323.GF30852@leaf>
References: <1322515487-18690-1-git-send-email-fweisbec@gmail.com>
 <1322515487-18690-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322515487-18690-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 10:24:47PM +0100, Frederic Weisbecker wrote:
> A CPU running in adaptive tickless mode wants to enter into
> RCU extended quiescent state while running in userspace. This
> way we can shut down the tick that is usually needed on each
> CPU for the needs of RCU.

Very awesome.  I've wanted to see this change for a long time.  Thanks!

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

It would help to see the corresponding patches making use of this new
API.

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> ---
>  kernel/rcutree.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 00a9fba..a7906c9 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -402,6 +402,18 @@ void rcu_user_enter(void)
>  	__rcu_idle_enter();
>  }
>  
> +void rcu_user_enter_irq(void)
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
> @@ -503,6 +515,18 @@ void rcu_user_exit(void)
>  	__rcu_idle_exit();
>  }
>  
> +void rcu_user_exit_irq(void)
> +{
> +	unsigned long flags;
> +	struct rcu_dynticks *rdtp;
> +
> +	local_irq_save(flags);
> +	rdtp = &__get_cpu_var(rcu_dynticks);
> +	WARN_ON_ONCE(rdtp->dynticks_nesting != 1);
> +	rdtp->dynticks_nesting = (LLONG_MAX / 2) + 1;
> +	local_irq_restore(flags);
> +}
> +

Any chance that either of these two needs a memory barrier of some kind,
to prevent leakage of operations from between them?  Or can you count on
no RCU-protected operations occurring during (or leaking into) the
extended quiescent state?

- Josh Triplett
