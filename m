Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab2GFQ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:29:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52295 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab2GFQ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:29:40 -0400
Date: Fri, 6 Jul 2012 09:27:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/6] rcu: Allow rcu_user_enter()/exit() to nest
Message-ID: <20120706162708.GU2522@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1341576018-10721-1-git-send-email-fweisbec@gmail.com>
 <1341576018-10721-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341576018-10721-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070616-6148-0000-0000-000007693C2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 02:00:14PM +0200, Frederic Weisbecker wrote:
> Allow calls to rcu_user_enter() even if we are already
> in userspace (as seen by RCU) and allow calls to rcu_user_exit()
> even if we are already in the kernel.
> 
> This makes the APIs more flexible to be called from architectures.
> Exception entries for example won't need to know if they come from
> userspace before calling rcu_user_exit().

You lost me on this one.  As long as the nesting level stays below
a few tens, rcu_user_enter() and rcu_user_exit() already can nest.

Or are you saying that you need to deal with duplicate rcu_user_enter()
calls that must be matched by a single rcu_user_exit() call?

						Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Alessio Igor Bogani <abogani@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Geoff Levand <geoff@infradead.org>
> Cc: Gilad Ben Yossef <gilad@benyossef.com>
> Cc: Hakan Akkan <hakanakkan@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephen Hemminger <shemminger@vyatta.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/rcutree.c |   38 ++++++++++++++++++++++++++++++--------
>  1 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 64fc2cd..81a86ec 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -344,6 +344,10 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
>  	return 0;
>  }
> 
> +#ifdef CONFIG_RCU_USER_QS
> +static DEFINE_PER_CPU(bool, in_user);
> +#endif
> +
>  /*
>   * rcu_eqs_enter_common - current CPU is moving towards extended quiescent state
>   *
> @@ -389,11 +393,9 @@ static void rcu_eqs_enter_common(struct rcu_dynticks *rdtp, long long oldval,
>   */
>  static void rcu_eqs_enter(bool user)
>  {
> -	unsigned long flags;
>  	long long oldval;
>  	struct rcu_dynticks *rdtp;
> 
> -	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	oldval = rdtp->dynticks_nesting;
>  	WARN_ON_ONCE((oldval & DYNTICK_TASK_NEST_MASK) == 0);
> @@ -402,7 +404,6 @@ static void rcu_eqs_enter(bool user)
>  	else
>  		rdtp->dynticks_nesting -= DYNTICK_TASK_NEST_VALUE;
>  	rcu_eqs_enter_common(rdtp, oldval, user);
> -	local_irq_restore(flags);
>  }
> 
>  /**
> @@ -419,7 +420,11 @@ static void rcu_eqs_enter(bool user)
>   */
>  void rcu_idle_enter(void)
>  {
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>  	rcu_eqs_enter(0);
> +	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_enter);
> 
> @@ -434,7 +439,16 @@ EXPORT_SYMBOL_GPL(rcu_idle_enter);
>   */
>  void rcu_user_enter(void)
>  {
> -	rcu_eqs_enter(1);
> +	unsigned long flags;
> +
> +	WARN_ON_ONCE(!current->mm);
> +
> +	local_irq_save(flags);
> +	if (!this_cpu_read(in_user)) {
> +		this_cpu_write(in_user, true);
> +		rcu_eqs_enter(1);
> +	}
> +	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_user_enter);
>  #endif
> @@ -530,11 +544,9 @@ static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
>   */
>  static void rcu_eqs_exit(bool user)
>  {
> -	unsigned long flags;
>  	struct rcu_dynticks *rdtp;
>  	long long oldval;
> 
> -	local_irq_save(flags);
>  	rdtp = &__get_cpu_var(rcu_dynticks);
>  	oldval = rdtp->dynticks_nesting;
>  	WARN_ON_ONCE(oldval < 0);
> @@ -543,7 +555,6 @@ static void rcu_eqs_exit(bool user)
>  	else
>  		rdtp->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
>  	rcu_eqs_exit_common(rdtp, oldval, user);
> -	local_irq_restore(flags);
>  }
> 
>  /**
> @@ -559,7 +570,11 @@ static void rcu_eqs_exit(bool user)
>   */
>  void rcu_idle_exit(void)
>  {
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
>  	rcu_eqs_exit(0);
> +	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_idle_exit);
> 
> @@ -572,7 +587,14 @@ EXPORT_SYMBOL_GPL(rcu_idle_exit);
>   */
>  void rcu_user_exit(void)
>  {
> -	rcu_eqs_exit(1);
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	if (this_cpu_read(in_user)) {
> +		this_cpu_write(in_user, false);
> +		rcu_eqs_exit(1);
> +	}
> +	local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL_GPL(rcu_user_exit);
>  #endif
> -- 
> 1.7.5.4
> 

