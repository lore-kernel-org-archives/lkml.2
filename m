Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1GBJw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 05:52:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:55314 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab1GBJw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 05:52:26 -0400
Subject: Re: [PATCH] sched: Check nr_running before calling pick_next_task
 in schedule().
From: Peter Zijlstra <peterz@infradead.org>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
In-Reply-To: <1309545711.4303.2.camel@localhost.localdomain>
References: <1309545711.4303.2.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Jul 2011 11:51:00 +0200
Message-ID: <1309600260.10073.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-02 at 00:41 +0600, Rakib Mullick wrote:
> Currently at schedule(), when we call pick_next_task we don't check
> whether current rq is empty or not. Since idle_balance can fail,
> its nice to check whether we really have any task on rq or not. If
> not, we can call idle_sched_class.pick_next_task straight.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 5925275..a4f4f58 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -4273,7 +4273,14 @@ need_resched:
>  		idle_balance(cpu, rq);
>  
>  	put_prev_task(rq, prev);
> -	next = pick_next_task(rq);
> +	/*  Since idle_balance can fail, its better to check rq->nr_running.
> +	 *  Otherwise we can call idle_sched_class.pick_next_task straight,
> +	 *  cause we need to do some accounting.
> +	 */
> +	if (likely(rq->nr_running))
> +		next = pick_next_task(rq);
> +	else
> +		next = idle_sched_class.pick_next_task(rq);
>  	clear_tsk_need_resched(prev);
>  	rq->skip_clock_update = 0;

Why!?

You're making the fast path -- picking a task -- slower by adding a
branch, and making the slow path -- going into idle -- faster. That
seems backwards at best.

You've completely failed to provide any sort of rationale for the patch
nor did you provide a use-case with performance numbers. This just isn't
making much sense at all.
