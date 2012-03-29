Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab2C2V5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:57:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:49404 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2C2V5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:57:34 -0400
Date: Thu, 29 Mar 2012 14:56:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove the context test in rcu_read_unlock_special()
Message-ID: <20120329215613.GX2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F741B98.2070709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F741B98.2070709@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032921-1780-0000-0000-0000045E2E71
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000264; HX=3.00000186; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00126329; UDB=6.00030098; UTC=2012-03-29
 21:57:31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 04:21:44PM +0800, Lai Jiangshan wrote:
> Because of commit#26861f and #10f39bb1b2, the context test in
> rcu_read_unlock_special() are not needed.
> 
> commit#26861f and #10f39bb1b2 ensure ->rcu_read_unlock_special is zero
> after rcu_read_unlock(), which implies:
> 
> if ->rcu_read_unlock_special is non-zero, the out-most RCU C.S. can
> be interrupted or can be preempted, such context is safe to
> call rcu_read_unlock_special().

In theory, I am very much in favor of this, but in practice we need to
put a WARN_ON_ONCE() in the "if" statement to be removed for a few years
first.  If there are never any warnings (or, more likely, once such
warnings have been fixed for some time), then this patch below would be
eminently sensible.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> index 22ecea0..22e2ef1 100644
> --- a/kernel/rcutiny_plugin.h
> +++ b/kernel/rcutiny_plugin.h
> @@ -571,12 +571,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
>  	if (special & RCU_READ_UNLOCK_NEED_QS)
>  		rcu_preempt_cpu_qs();
> 
> -	/* Hardware IRQ handlers cannot block. */
> -	if (in_irq() || in_serving_softirq()) {
> -		local_irq_restore(flags);
> -		return;
> -	}
> -
>  	/* Clean up if blocked during RCU read-side critical section. */
>  	if (special & RCU_READ_UNLOCK_BLOCKED) {
>  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index c023464..2bd3689 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -338,12 +338,6 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
>  		rcu_preempt_qs(smp_processor_id());
>  	}
> 
> -	/* Hardware IRQ handlers cannot block. */
> -	if (in_irq() || in_serving_softirq()) {
> -		local_irq_restore(flags);
> -		return;
> -	}
> -
>  	/* Clean up if blocked during RCU read-side critical section. */
>  	if (special & RCU_READ_UNLOCK_BLOCKED) {
>  		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 671f959..7074f97 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -318,12 +318,8 @@ static inline void invoke_softirq(void)
>  #else
>  		do_softirq();
>  #endif
> -	} else {
> -		__local_bh_disable((unsigned long)__builtin_return_address(0),
> -				SOFTIRQ_OFFSET);
> +	} else
>  		wakeup_softirqd();
> -		__local_bh_enable(SOFTIRQ_OFFSET);
> -	}
>  }
> 
>  /*
> 

