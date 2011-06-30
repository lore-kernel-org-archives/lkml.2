Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1F3Mzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:55:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55131 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab1F3Mz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:55:29 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=hSGkvnjVqWsA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7k9qpevRiHmZAb1ouxkA:9 a=92EjhzOJeTSoLCjVR-cA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC] sched: check RT runqueue overloaded in tick timer
From: Steven Rostedt <rostedt@goodmis.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <BANLkTikH9cdO+bwNN4kGgisP6RCy2Xo-3g@mail.gmail.com>
References: <BANLkTikH9cdO+bwNN4kGgisP6RCy2Xo-3g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 30 Jun 2011 08:55:26 -0400
Message-ID: <1309438526.26417.65.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-30 at 20:47 +0800, Hillf Danton wrote:
> Hi Steven
> 
> When tick timer runs, runqueue overload is checked. If overloaded and other
> CPUs available at the moment, reschedule is fired to allow push logic to move
> the pushable tasks somewhere else.

Why?

This would be a waste of overhead. We check when a task is queued and
dequeue, and when a cpu lowers its priority (for a pull). There's no
need to randomly check if we need to push or pull based on timers.
That's just going to slow things down.

-- Steve

> 
> Thanks
> 
> Hillf
> ---
>  kernel/sched_rt.c |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index b03cd89..afd29a3 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1767,10 +1767,10 @@ static void task_tick_rt(struct rq *rq, struct
> task_struct *p, int queued)
>  	 * FIFO tasks have no timeslices.
>  	 */
>  	if (p->policy != SCHED_RR)
> -		return;
> +		goto check_overload;
> 
>  	if (--p->rt.time_slice)
> -		return;
> +		goto check_overload;
> 
>  	p->rt.time_slice = DEF_TIMESLICE;
> 
> @@ -1782,6 +1782,23 @@ static void task_tick_rt(struct rq *rq, struct
> task_struct *p, int queued)
>  		requeue_task_rt(rq, p, 0);
>  		set_tsk_need_resched(p);
>  	}
> +
> +check_overload:
> +#ifdef CONFIG_SMP
> +	if (!test_tsk_need_resched(p)) {
> +		struct task_struct *t = pick_next_pushable_task(rq);
> +		/*
> +		 * If @rq overloaded and other CPUs available, reschedule
> +		 * @p to allow the push logic to move the pushable tasks
> +		 * somewhere else.
> +		 *
> +		 * It is a pseudo schedule, since @p, without accident, will
> +		 * be picked again. If not, fine:)
> +		 */
> +		if (t && cpupri_find(&rq->rd->cpupri, t, NULL))
> +			set_tsk_need_resched(p);
> +	}
> +#endif
>  }
> 
>  static void set_curr_task_rt(struct rq *rq)


