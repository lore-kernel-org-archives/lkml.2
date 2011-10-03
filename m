Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab1JCThi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 15:37:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab1JCThb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 15:37:31 -0400
Subject: Re: [patch 1/2] sched: use resched IPI to kick off the nohz idle
 balance
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        Prarit Bhargava <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Date: Mon, 03 Oct 2011 21:36:30 +0200
In-Reply-To: <20110929223242.837017656@sbsiddha-desk.sc.intel.com>
References: <20110929223242.837017656@sbsiddha-desk.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317670590.20367.38.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 15:30 -0700, Suresh Siddha wrote:

> ---
>  kernel/sched.c      |   14 +++++++++++---
>  kernel/sched_fair.c |   27 +++++++--------------------
>  2 files changed, 18 insertions(+), 23 deletions(-)
> 
> Index: linux-2.6-tip/kernel/sched.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/sched.c
> +++ linux-2.6-tip/kernel/sched.c
> @@ -2733,7 +2733,7 @@ void scheduler_ipi(void)
>  	struct rq *rq = this_rq();
>  	struct task_struct *list = xchg(&rq->wake_list, NULL);
>  
> -	if (!list)
> +	if (!list && !idle_cpu(cpu_of(rq)))
>  		return;

Why not make that !rq->nohz_balance_kick? (wrapped in a helper for !
CONFIG_NO_HZ)

>  	/*
> @@ -2750,7 +2750,16 @@ void scheduler_ipi(void)
>  	 * somewhat pessimize the simple resched case.
>  	 */
>  	irq_enter();
> -	sched_ttwu_do_pending(list);
> +
> +	if (list)
> +		sched_ttwu_do_pending(list);
> +
> +	/*
> + 	 * Check if someone kicked us for doing the nohz idle load balance.
> + 	 */
> +	if (unlikely((rq->idle == current) && rq->nohz_balance_kick &&
> +		     !need_resched()))
> +		raise_softirq_irqoff(SCHED_SOFTIRQ);

And make that: idle_cpu() && rq->nohz_balance_kick && !need_resched()

All wrapped in #ifdef CONFIG_NO_HZ goo?
> tself as idle load_balancer, while
> @@ -4450,11 +4434,14 @@ static void nohz_balancer_kick(int cpu)
>  	}
>  
>  	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
> -		struct call_single_data *cp;
> -
>  		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
> -		cp = &per_cpu(remote_sched_softirq_cb, cpu);
> -		__smp_call_function_single(ilb_cpu, cp, 0);
> +		/*
> +		 * Use kick_process instead of resched_cpu.
> +		 * This way we generate a sched IPI on the target cpu which
> +		 * is idle. And the softirq performing nohz idle load balance
> +		 * will be run before returning from the IPI.
> +		 */

Shouldn't we have a memory barrier of sorts before sending the IPI?

> +		kick_process(idle_task(ilb_cpu));
>  	}
>  	return;
>  }
> 
> 

