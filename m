Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab1JRSU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:20:58 -0400
Received: from peace.netnation.com ([204.174.223.2]:37082 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1JRSU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:20:57 -0400
Date: Tue, 18 Oct 2011 11:20:46 -0700
From: Simon Kirby <sim@hostway.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
Message-ID: <20111018182046.GF1309@hostway.ca>
References: <20111013232521.GA5654@hostway.ca> <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com> <1318847658.6594.40.camel@twins> <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com> <1318874090.4172.84.camel@twins> <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com> <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos> <alpine.LFD.2.02.1110181037120.3240@ionos> <1318928713.21167.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318928713.21167.4.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 11:05:13AM +0200, Peter Zijlstra wrote:

> Subject: cputimer: Cure lock inversion
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Oct 17 11:50:30 CEST 2011
> 
> There's a lock inversion between the cputimer->lock and rq->lock; notably
> the two callchains involved are:
> 
>  update_rlimit_cpu()
>    sighand->siglock
>    set_process_cpu_timer()
>      cpu_timer_sample_group()
>        thread_group_cputimer()
>          cputimer->lock
>          thread_group_cputime()
>            task_sched_runtime()
>              ->pi_lock
>              rq->lock
> 
>  scheduler_tick()
>    rq->lock
>    task_tick_fair()
>      update_curr()
>        account_group_exec()
>          cputimer->lock
> 
> Where the first one is enabling a CLOCK_PROCESS_CPUTIME_ID timer, and
> the second one is keeping up-to-date.
> 
> This problem was introduced by e8abccb7193 ("posix-cpu-timers: Cure
> SMP accounting oddities").
> 
> Cure the problem by removing the cputimer->lock and rq->lock nesting,
> this leaves concurrent enablers doing duplicate work, but the time
> wasted should be on the same order otherwise wasted spinning on the
> lock and the greater-than assignment filter should ensure we preserve
> monotonicity.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Reported-by: Simon Kirby <sim@hostway.ca>
> Cc: stable@kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/posix-cpu-timers.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> Index: linux-2.6/kernel/posix-cpu-timers.c
> ===================================================================
> --- linux-2.6.orig/kernel/posix-cpu-timers.c
> +++ linux-2.6/kernel/posix-cpu-timers.c
> @@ -274,9 +274,7 @@ void thread_group_cputimer(struct task_s
>  	struct task_cputime sum;
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&cputimer->lock, flags);
>  	if (!cputimer->running) {
> -		cputimer->running = 1;
>  		/*
>  		 * The POSIX timer interface allows for absolute time expiry
>  		 * values through the TIMER_ABSTIME flag, therefore we have
> @@ -284,8 +282,11 @@ void thread_group_cputimer(struct task_s
>  		 * it.
>  		 */
>  		thread_group_cputime(tsk, &sum);
> +		spin_lock_irqsave(&cputimer->lock, flags);
> +		cputimer->running = 1;
>  		update_gt_cputime(&cputimer->cputime, &sum);
> -	}
> +	} else
> +		spin_lock_irqsave(&cputimer->lock, flags);
>  	*times = cputimer->cputime;
>  	spin_unlock_irqrestore(&cputimer->lock, flags);
>  }
> 

Tested-by: Simon Kirby <sim@hostway.ca>

Looks good running on three boxes since this morning (unpatched kernel
hangs in ~15 minutes).

While I have your eyes, does this hang trace make any sense (which
happened a couple of times with your previous patch applied)?

http://0x.ca/sim/ref/3.1-rc9/3.1-rc9-tcp-lockup.log

I don't see how all CPUs could be spinning on the same lock without
reentry, and I don't see the any in the backtraces.

Simon-
