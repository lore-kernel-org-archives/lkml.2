Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2JZJza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:55:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:33373 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab2JZJz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:55:27 -0400
Date: Fri, 26 Oct 2012 11:55:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "he, bo" <bo.he@intel.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, yanmin_zhang@linux.intel.com,
        yanmin.zhang@intel.com
Subject: Re: [PATCH] hrtimer:__run_hrtimer races with enqueue_hrtimer
In-Reply-To: <1351219917.28400.6.camel@hebo>
Message-ID: <alpine.LFD.2.02.1210261147000.2756@ionos>
References: <1351219917.28400.6.camel@hebo>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2012, he, bo wrote:
> From: Yanmin Zhang <yanmin.zhang@intel.com>
> 
> We hit a kernel panic at __run_hrtimer=>BUG_ON(timer->state != HRTIMER_STATE_CALLBACK).
> <2>[   10.226053, 3] kernel BUG at /home/android/xiaobing/ymz/r4/hardware/intel/linux-2.6/kernel/hrtimer.c:1228!
> 
> Basically, __run_hrtimer has a race with enqueue_hrtimer. When
> __run_hrtimer calls the timer callback fn, another thread might call
> enqueue_hrtimer or hrtimer_start to requeue it, and the timer->state
> is equal to HRTIMER_STATE_CALLBACK|HRTIMER_STATE_ENQUEUED, which
> causes the BUG_ON(timer->state != HRTIMER_STATE_CALLBACK) checking
> fails.
>
> The patch fixes it by checking only bit HRTIMER_STATE_CALLBACK.

This does not fix it. It makes it worse.
 
> Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
> Reviewed-by: He, Bo <bo.he@intel.com>
> ---
>  kernel/hrtimer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 6db7a5e..6280184 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1235,7 +1235,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>  	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
>  	 */
>  	if (restart != HRTIMER_NORESTART) {
> -		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
> +		BUG_ON(!(timer->state & HRTIMER_STATE_CALLBACK));
>  		enqueue_hrtimer(timer, base);
>  	}

What you are allowing here is enqueueing an already enqueued timer
again. I don't know why this does not explode elsewhere, but that's
probably pure luck. It's not allowed to double enqueue a timer.

So no, this is not a solution. The problem is not in the core timer
code, the problem is in the code which uses that timer.

Your code is returning HRTIMER_RESTART from the timer callback and at
the same time it starts the timer from some other context. That's what
needs to be fixed.

Thanks,

	tglx






