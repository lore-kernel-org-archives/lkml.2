Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab0FUQnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 12:43:17 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33009 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab0FUQnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:43:14 -0400
Date: Mon, 21 Jun 2010 09:43:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcutorture: add random preemption
Message-ID: <20100621164306.GC2354@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C1F2986.7080006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1F2986.7080006@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 04:57:42PM +0800, Lai Jiangshan wrote:
> Add random preemption to help we to torture the preemptable rcu.
> 
> srcu_read_delay() also calls rcu_read_delay() for shorter delays.

I do like the change to srcu_read_delay(), good to fall back to the
normal rcu_read_delay() behavior when a long delay is not selected.
The change to rcu_read_delay() looks promising as well, but please see
below for some comments on the other change.

And the big question: did you find any failures when testing with this
change?  ;-)

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 2e2726d..7c81d07 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -303,6 +303,10 @@ static void rcu_read_delay(struct rcu_random_state *rrsp)
>  		mdelay(longdelay_ms);
>  	if (!(rcu_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
>  		udelay(shortdelay_us);
> +#ifdef CONFIG_PREEMPT
> +	if (!preempt_count() && !(rcu_random(rrsp) % (nrealreaders * 20000)))
> +		preempt_schedule();
> +#endif

This one scared me for a bit -- then I realized that preempt_schedule()
won't actually schedule if preemption is in any way disabled.  So the
above really is OK, because Classic RCU and RCU-bh disable preemption.

So, should we have a comment to this effect, or is my hypersensitivity to
RCU semantics unique to me?

>  }
> 
>  static void rcu_torture_read_unlock(int idx) __releases(RCU)
> @@ -536,6 +540,8 @@ static void srcu_read_delay(struct rcu_random_state *rrsp)
>  	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay * uspertick);
>  	if (!delay)
>  		schedule_timeout_interruptible(longdelay);
> +	else
> +		rcu_read_delay(rrsp);
>  }
> 
>  static void srcu_torture_read_unlock(int idx) __releases(&srcu_ctl)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
