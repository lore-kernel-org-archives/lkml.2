Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2HaXkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:40:32 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46474 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab2HaXkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:40:31 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 16:40:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 03/26] rcu: Make RCU_FAST_NO_HZ handle
 adaptive ticks
Message-ID: <20120831234022.GA11771@jtriplet-mobl1>
References: <20120830210520.GA2824@linux.vnet.ibm.com>
 <1346360743-3628-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346360743-3628-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346360743-3628-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 02:05:20PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The current implementation of RCU_FAST_NO_HZ tries reasonably hard to rid
> the current CPU of RCU callbacks.  This is appropriate when the CPU is
> entering idle, where it doesn't have much useful to do anyway, but is most
> definitely not what you want when transitioning to user-mode execution.
> This commit therefore detects the adaptive-tick case, and refrains from
> burning CPU time getting rid of RCU callbacks in that case.

With the OOM handler from your other patch series, I don't know that it
makes as much sense in the idle case, either; perhaps it would make more
sense to wait and batch up more callbacks as long as you have memory,
and then run them in one big burst.

> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree_plugin.h |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 7f3244c..b0f09d6 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -1997,6 +1997,26 @@ static void rcu_prepare_for_idle(int cpu)
>  	if (!tne)
>  		return;
>  
> +	/* Adaptive-tick mode, where usermode execution is idle to RCU. */
> +	if (!is_idle_task(current)) {
> +		rdtp->dyntick_holdoff = jiffies - 1;
> +		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
> +			trace_rcu_prep_idle("User dyntick with callbacks");
> +			rdtp->idle_gp_timer_expires =
> +				round_up(jiffies + RCU_IDLE_GP_DELAY,
> +					 RCU_IDLE_GP_DELAY);
> +		} else if (rcu_cpu_has_callbacks(cpu)) {
> +			rdtp->idle_gp_timer_expires =
> +				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
> +			trace_rcu_prep_idle("User dyntick with lazy callbacks");
> +		} else {
> +			return;
> +		}
> +		tp = &rdtp->idle_gp_timer;
> +		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
> +		return;
> +	}
> +
>  	/*
>  	 * If this is an idle re-entry, for example, due to use of
>  	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
> -- 
> 1.7.8
> 
