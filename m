Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1CNIr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 04:47:27 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54724 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1CNIrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 04:47:25 -0400
Date: Mon, 14 Mar 2011 01:47:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] jrcu: fix broken rcu_barrier
Message-ID: <20110314084718.GH2167@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110314035044.GA12990@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314035044.GA12990@tsunami.ccur.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 13, 2011 at 11:50:44PM -0400, Joe Korty wrote:
> jrcu: fix bug in rcu_barrier.
> 
> It is not equivalent to synchronize_rcu.  But it
> can be implemented by a pair of synchronize_rcu's,
> so do so.
> 
> Thanks go to Paul E McKenney for finding this.
> 
> Signed-off-by: Joe Korty <joe.korty@ccur.com>
> 
> Index: b/kernel/jrcu.c
> ===================================================================
> --- a/kernel/jrcu.c
> +++ b/kernel/jrcu.c
> @@ -183,7 +183,7 @@ void rcu_note_might_resched(void)
>  }
>  EXPORT_SYMBOL(rcu_note_might_resched);
> 
> -void rcu_barrier(void)
> +void synchronize_sched(void)
>  {
>  	struct rcu_synchronize rcu;
> 
> @@ -196,6 +196,13 @@ void rcu_barrier(void)
>  	atomic_inc(&rcu_stats.nbarriers);
> 
>  }
> +EXPORT_SYMBOL_GPL(synchronize_sched);
> +
> +void rcu_barrier(void)
> +{
> +	synchronize_sched();
> +	synchronize_sched();
> +}

This is still broken.  You need to wait until all pre-existing RCU
callbacks on all CPUs have been invoked.  Although this does guarantee
that all callbacks on the current CPU have been invoked, if one of the
other CPUs is busy, it might not yet have processed the callbacks from
earlier grace periods.  The usual way to take care of this is to post
a callback on each CPU, then wait for them all to be invoked.

							Thanx, Paul

>  EXPORT_SYMBOL_GPL(rcu_barrier);
> 
>  void rcu_force_quiescent_state(void)
> Index: b/include/linux/jrcu.h
> ===================================================================
> --- a/include/linux/jrcu.h
> +++ b/include/linux/jrcu.h
> @@ -39,12 +39,13 @@ extern void rcu_barrier(void);
>  #define rcu_barrier_sched			rcu_barrier
>  #define rcu_barrier_bh				rcu_barrier
> 
> -#define synchronize_rcu				rcu_barrier
> -#define synchronize_sched			rcu_barrier
> -#define synchronize_sched_expedited		rcu_barrier
> -#define synchronize_rcu_bh			rcu_barrier
> -#define synchronize_rcu_expedited		rcu_barrier
> -#define synchronize_rcu_bh_expedited		rcu_barrier
> +extern void synchronize_sched(void);
> +
> +#define synchronize_rcu				synchronize_sched
> +#define synchronize_sched_expedited		synchronize_sched
> +#define synchronize_rcu_bh			synchronize_sched
> +#define synchronize_rcu_expedited		synchronize_sched
> +#define synchronize_rcu_bh_expedited		synchronize_sched
> 
>  #define rcu_init(cpu)				do { } while (0)
>  #define rcu_init_sched()			do { } while (0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
