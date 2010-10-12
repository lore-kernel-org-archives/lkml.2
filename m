Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069Ab0JLIuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:50:16 -0400
Received: from www.tglx.de ([62.245.132.106]:57664 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756888Ab0JLIuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:50:15 -0400
Date: Tue, 12 Oct 2010 10:49:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Salman Qazi <sqazi@google.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix a complex race in hrtimer code.
In-Reply-To: <20101012000159.7091.84336.stgit@dungbeetle.mtv.corp.google.com>
Message-ID: <alpine.LFD.2.00.1010121046060.2909@localhost6.localdomain6>
References: <20101012000159.7091.84336.stgit@dungbeetle.mtv.corp.google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Oct 2010, Salman Qazi wrote:

> The race is described as follows:
> 
> CPU X                                 CPU Y
> remove_hrtimer
> // state & QUEUED == 0
> timer->state = CALLBACK
> unlock timer base
> timer->f(n) //very long
>                                   hrtimer_start
>                                     lock timer base
>                                     remove_hrtimer // no effect
>                                     hrtimer_enqueue
>                                     timer->state = CALLBACK |
>                                                    QUEUED
>                                     unlock timer base
>                                   hrtimer_start
>                                     lock timer base
>                                     remove_hrtimer
>                                         mode = INACTIVE
>                                         // CALLBACK bit lost!
>                                     switch_hrtimer_base
>                                             CALLBACK bit not set:
>                                                     timer->base
>                                                     changes to a
>                                                     different CPU.
> lock this CPU's timer base

Good catch.
 
> Bug reproducible and fix testable using a kernel module that hrtimer_start()s
> a timer with a very long running callback from multiple CPUs:
> 
> MODULE_LICENSE("GPL");
> 
> static long timer_func_time = 1000;
> module_param(timer_func_time, long, 0600);
> static long timer_starts = 2500;
> module_param(timer_starts, long, 0600);
> static long timer_expire = 1000;
> module_param(timer_expire, long, 0600);
> 
> DEFINE_PER_CPU(struct task_struct *, hrtimer_thread);
> 
> /* There are other issues, like deadlocks between multiple hrtimer_start observed
>  * calls, at least in 2.6.34 that this lock works around.  Will look into
>  * those later.

Well, we don't have to work around callsites not serializing themself
in the core code, right ?

> ---
>  kernel/hrtimer.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 1decafb..57846d5 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -944,8 +944,8 @@ remove_hrtimer(struct hrtimer *timer, struct hrtimer_clock_base *base)
>  		debug_deactivate(timer);
>  		timer_stats_hrtimer_clear_start_info(timer);
>  		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
> -		__remove_hrtimer(timer, base, HRTIMER_STATE_INACTIVE,
> -				 reprogram);
> +		__remove_hrtimer(timer, base,
> +				 (timer->state & HRTIMER_STATE_CALLBACK), reprogram);
>  		return 1;
>  	}
>  	return 0;
> @@ -1231,6 +1231,9 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>  		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
>  		enqueue_hrtimer(timer, base);
>  	}
> +
> +	WARN_ON_ONCE(!(timer->state & HRTIMER_STATE_CALLBACK));
> +
>  	timer->state &= ~HRTIMER_STATE_CALLBACK;
>  }

Can I please get your Signed-off-by so this can be queued ?

Thanks,

	tglx
 
