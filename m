Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188Ab1JGWru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 18:47:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52362 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab1JGWrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 18:47:48 -0400
Date: Fri, 7 Oct 2011 15:47:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 02/11] rcu: Inform the user about extended quiescent
 state on PROVE_RCU warning
Message-ID: <20111007224744.GH2696@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1318004530-705-1-git-send-email-fweisbec@gmail.com>
 <1318004530-705-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318004530-705-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 06:22:01PM +0200, Frederic Weisbecker wrote:
> Inform the user if an RCU usage error is detected by lockdep while in
> an extended quiescent state (in this case, the RCU-free window in idle).
> This is accomplished by adding a line to the RCU lockdep splat indicating
> whether or not the splat occurred in extended quiescent state.
> 
> Uses of RCU from within extended quiescent state mode are totally ignored
> by RCU, hence the importance of this diagnostic.

Looks good!

At some point, we may need to add an additional argument to
lockdep_rcu_suspicious() to suppress this new message, but let's
worry about that when and if we come to it.

(An example would be an rcu_dereference_protected() that checks for
a lock being held, and thus can be legally called from an extended
quiescent state.  But the message would print only if the lock was
not held, so this could not be a false positive, only a possible
source of confusion.  Not worth worrying about yet.)

							Thanx, Paul

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/lockdep.c |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 1e48f1c..8873f6e 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -4026,6 +4026,28 @@ void lockdep_rcu_suspicious(const char *file, const int line, const char *s)
>  	printk("%s:%d %s!\n", file, line, s);
>  	printk("\nother info that might help us debug this:\n\n");
>  	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
> +
> +	/*
> +	 * If a CPU is in the RCU-free window in idle (ie: in the section
> +	 * between rcu_idle_enter() and rcu_idle_exit(), then RCU
> +	 * considers that CPU to be in an "extended quiescent state",
> +	 * which means that RCU will be completely ignoring that CPU.
> +	 * Therefore, rcu_read_lock() and friends have absolutely no
> +	 * effect on a CPU running in that state. In other words, even if
> +	 * such an RCU-idle CPU has called rcu_read_lock(), RCU might well
> +	 * delete data structures out from under it.  RCU really has no
> +	 * choice here: we need to keep an RCU-free window in idle where
> +	 * the CPU may possibly enter into low power mode. This way we can
> +	 * notice an extended quiescent state to other CPUs that started a grace
> +	 * period. Otherwise we would delay any grace period as long as we run
> +	 * in the idle task.
> +	 *
> +	 * So complain bitterly if someone does call rcu_read_lock(),
> +	 * rcu_read_lock_bh() and so on from extended quiescent states.
> +	 */
> +	if (rcu_is_cpu_idle())
> +		printk("RCU used illegally from extended quiescent state!\n");
> +
>  	lockdep_print_held_locks(curr);
>  	printk("\nstack backtrace:\n");
>  	dump_stack();
> -- 
> 1.7.5.4
> 
