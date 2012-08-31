Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2HaSek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:34:40 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51736 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab2HaSej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:34:39 -0400
X-Originating-IP: 217.70.178.143
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:34:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 13/15] rcu: Move TINY_PREEMPT_RCU away from
 raw_local_irq_save()
Message-ID: <20120831183431.GK4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-13-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-13-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:26AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The use of raw_local_irq_save() is unnecessary, given that local_irq_save()
> really does disable interrupts.  Also, it appears to interfere with lockdep.
> Therefore, this commit moves to local_irq_save().

It looks like the non-raw versions also include tracing, which typically
has recursive dependency problems with RCU.  Can all of these call sites
safely call into tracing without recursing back into RCU?

- Josh Triplett

> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  kernel/rcutiny_plugin.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index 918fd1e..3d01902 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -278,7 +278,7 @@ static int rcu_boost(void)
>  	    rcu_preempt_ctrlblk.exp_tasks == NULL)
>  		return 0;  /* Nothing to boost. */
>  
> -	raw_local_irq_save(flags);
> +	local_irq_save(flags);
>  
>  	/*
>  	 * Recheck with irqs disabled: all tasks in need of boosting
> @@ -287,7 +287,7 @@ static int rcu_boost(void)
>  	 */
>  	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
>  	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
> -		raw_local_irq_restore(flags);
> +		local_irq_restore(flags);
>  		return 0;
>  	}
>  
> @@ -317,7 +317,7 @@ static int rcu_boost(void)
>  	t = container_of(tb, struct task_struct, rcu_node_entry);
>  	rt_mutex_init_proxy_locked(&mtx, t);
>  	t->rcu_boost_mutex = &mtx;
> -	raw_local_irq_restore(flags);
> +	local_irq_restore(flags);
>  	rt_mutex_lock(&mtx);
>  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
>  
> @@ -991,9 +991,9 @@ static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
>  {
>  	unsigned long flags;
>  
> -	raw_local_irq_save(flags);
> +	local_irq_save(flags);
>  	rcp->qlen -= n;
> -	raw_local_irq_restore(flags);
> +	local_irq_restore(flags);
>  }
>  
>  /*
> -- 
> 1.7.8
> 
