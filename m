Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2FOVCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:02:33 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53646 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab2FOVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:02:31 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 14:02:18 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 11/14] rcu: Make __call_rcu() handle
 invocation from idle
Message-ID: <20120615210218.GO31184@leaf>
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339791195-26389-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:13:12PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Although __call_rcu() is handled correctly when called from a momentary
> non-idle period, if it is called on a CPU that RCU believes to be idle
> on RCU_FAST_NO_HZ kernels, the callback might be indefinitely postponed.
> This commit therefore ensures that RCU is aware of the new callback and
> has a chance to force the CPU out of dyntick-idle mode when a new callback
> is posted.
> 
> Reported-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  include/linux/rcupdate.h |   11 ++---------
>  kernel/rcutree.c         |   15 +++++++++------
>  2 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index 4874d26..a987595 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -257,6 +257,8 @@ static inline void destroy_rcu_head_on_stack(struct rcu_head *head)
>  }
>  #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
>  
> +extern int rcu_is_cpu_idle(void);
> +
>  #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU)
>  bool rcu_lockdep_current_cpu_online(void);
>  #else /* #if defined(CONFIG_HOTPLUG_CPU) && defined(CONFIG_PROVE_RCU) */
> @@ -268,15 +270,6 @@ static inline bool rcu_lockdep_current_cpu_online(void)
>  
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  
> -#ifdef CONFIG_PROVE_RCU
> -extern int rcu_is_cpu_idle(void);
> -#else /* !CONFIG_PROVE_RCU */
> -static inline int rcu_is_cpu_idle(void)
> -{
> -	return 0;
> -}
> -#endif /* else !CONFIG_PROVE_RCU */
> -
>  static inline void rcu_lock_acquire(struct lockdep_map *map)
>  {
>  	lock_acquire(map, 0, 0, 2, 1, NULL, _THIS_IP_);
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index cdc101e..7720177 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -584,8 +584,6 @@ void rcu_nmi_exit(void)
>  	WARN_ON_ONCE(atomic_read(&rdtp->dynticks) & 0x1);
>  }
>  
> -#ifdef CONFIG_PROVE_RCU
> -
>  /**
>   * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
>   *
> @@ -603,7 +601,7 @@ int rcu_is_cpu_idle(void)
>  }
>  EXPORT_SYMBOL(rcu_is_cpu_idle);
>  
> -#ifdef CONFIG_HOTPLUG_CPU
> +#if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU)
>  
>  /*
>   * Is the current CPU online?  Disable preemption to avoid false positives
> @@ -644,9 +642,7 @@ bool rcu_lockdep_current_cpu_online(void)
>  }
>  EXPORT_SYMBOL_GPL(rcu_lockdep_current_cpu_online);
>  
> -#endif /* #ifdef CONFIG_HOTPLUG_CPU */
> -
> -#endif /* #ifdef CONFIG_PROVE_RCU */
> +#endif /* #if defined(CONFIG_PROVE_RCU) && defined(CONFIG_HOTPLUG_CPU) */
>  
>  /**
>   * rcu_is_cpu_rrupt_from_idle - see if idle or immediately interrupted from idle
> @@ -1901,6 +1897,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
>  	else
>  		trace_rcu_callback(rsp->name, head, rdp->qlen_lazy, rdp->qlen);
>  
> +	/*
> +	 * If called from an extended quiescent state, invoke the RCU
> +	 * core in order to force a re-evaluation of RCU's idleness.
> +	 */
> +	if (rcu_is_cpu_idle())
> +		invoke_rcu_core();
> +
>  	/* If interrupts were disabled, don't dive into RCU core. */
>  	if (irqs_disabled_flags(flags)) {
>  		local_irq_restore(flags);
> -- 
> 1.7.8
> 
