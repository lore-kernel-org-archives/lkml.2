Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2HaQts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:49:48 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38668 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2HaQtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:49:46 -0400
X-Originating-IP: 217.70.178.147
X-Originating-IP: 50.43.46.74
Date: Fri, 31 Aug 2012 09:49:36 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 01/15] rcu: Add PROVE_RCU_DELAY to provoke
 difficult races
Message-ID: <20120831164936.GA22564@leaf>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:14AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> There have been some recent bugs that were triggered only when
> preemptible RCU's __rcu_read_unlock() was preempted just after setting
> ->rcu_read_lock_nesting to INT_MIN, which is a low-probability event.
> Therefore, reproducing those bugs (to say nothing of gaining confidence
> in alleged fixes) was quite difficult.  This commit therefore creates
> a new debug-only RCU kernel config option that forces a short delay
> in __rcu_read_unlock() to increase the probability of those sorts of
> bugs occurring.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

If you end up adding more such conditional race-provoking delays
elsewhere in the code, consider creating a prove_rcu_udelay() wrapper
to avoid multiple #ifdefs in the code.

> ---
>  kernel/rcupdate.c |    4 ++++
>  lib/Kconfig.debug |   14 ++++++++++++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 4e6a61b..29ca1c6 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -45,6 +45,7 @@
>  #include <linux/mutex.h>
>  #include <linux/export.h>
>  #include <linux/hardirq.h>
> +#include <linux/delay.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/rcu.h>
> @@ -81,6 +82,9 @@ void __rcu_read_unlock(void)
>  	} else {
>  		barrier();  /* critical section before exit code. */
>  		t->rcu_read_lock_nesting = INT_MIN;
> +#ifdef CONFIG_PROVE_RCU_DELAY
> +		udelay(10); /* Make preemption more probable. */
> +#endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
>  		barrier();  /* assign before ->rcu_read_unlock_special load */
>  		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
>  			rcu_read_unlock_special(t);
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 2403a63..dacbbe4 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -629,6 +629,20 @@ config PROVE_RCU_REPEATEDLY
>  
>  	 Say N if you are unsure.
>  
> +config PROVE_RCU_DELAY
> +	bool "RCU debugging: preemptible RCU race provocation"
> +	depends on DEBUG_KERNEL && PREEMPT_RCU
> +	default n
> +	help
> +	 There is a class of races that involve an unlikely preemption
> +	 of __rcu_read_unlock() just after ->rcu_read_lock_nesting has
> +	 been set to INT_MIN.  This feature inserts a delay at that
> +	 point to increase the probability of these races.
> +
> +	 Say Y to increase probability of preemption of __rcu_read_unlock().
> +
> +	 Say N if you are unsure.
> +
>  config SPARSE_RCU_POINTER
>  	bool "RCU debugging: sparse-based checks for pointer usage"
>  	default n
> -- 
> 1.7.8
> 
