Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab1G0QKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:10:40 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56249 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753298Ab1G0QKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:10:39 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+g4cIWQOSgbbcY7pkOaESmZsAeT8aAticB+jzoOg
	sGcerJOsrr9uT3
Subject: Re: [patch] sched: fix broken SCHED_RESET_ON_FORK handling
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1311779695.8691.2.camel@marge.simson.net>
References: <1311779695.8691.2.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 18:10:35 +0200
Message-ID: <1311783035.10246.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I knew that thing had been moved before.. see f83f9ac2.

On Wed, 2011-07-27 at 17:14 +0200, Mike Galbraith wrote:
> sched: fix broken SCHED_RESET_ON_FORK handling
> 
> Setting child->prio = current->normal_prio _after_ SCHED_RESET_ON_FORK has
> been handled for an RT parent gives birth to a deranged mutant child with
> non-RT policy, but RT prio and sched_class.
> 
> Move PI leakage protection up, always set priorities and weight, and if the
> child is leaving RT class, reset rt_priority to the proper value.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Cc: <stable@kernel.org>
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 0281f84..a3e65a0 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2804,19 +2804,23 @@ void sched_fork(struct task_struct *p)
>  	p->state = TASK_RUNNING;
>  
>  	/*
> +	 * Make sure we do not leak PI boosting priority to the child.
> +	 */
> +	p->prio = current->normal_prio;
> +
> +	/*
>  	 * Revert to default priority/policy on fork if requested.
>  	 */
>  	if (unlikely(p->sched_reset_on_fork)) {
> -		if (p->policy == SCHED_FIFO || p->policy == SCHED_RR) {
> +		if (task_has_rt_policy(p)) {
>  			p->policy = SCHED_NORMAL;
> -			p->normal_prio = p->static_prio;
> -		}
> -
> -		if (PRIO_TO_NICE(p->static_prio) < 0) {
>  			p->static_prio = NICE_TO_PRIO(0);
> -			p->normal_prio = p->static_prio;
> -			set_load_weight(p);
> -		}
> +			p->rt_priority = 0;
> +		} else if (PRIO_TO_NICE(p->static_prio) < 0)
> +			p->static_prio = NICE_TO_PRIO(0);
> +
> +		p->prio = p->normal_prio = __normal_prio(p);
> +		set_load_weight(p);
>  
>  		/*
>  		 * We don't need the reset flag anymore after the fork. It has
> @@ -2825,11 +2829,6 @@ void sched_fork(struct task_struct *p)
>  		p->sched_reset_on_fork = 0;
>  	}
>  
> -	/*
> -	 * Make sure we do not leak PI boosting priority to the child.
> -	 */
> -	p->prio = current->normal_prio;
> -
>  	if (!rt_prio(p->prio))
>  		p->sched_class = &fair_sched_class;
>  
> 
> 


