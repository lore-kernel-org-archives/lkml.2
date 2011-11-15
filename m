Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1KOMim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:38:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542Ab1KOMik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:38:40 -0500
Date: Tue, 15 Nov 2011 14:38:14 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH RFC] perf, core: disable pmu while context rotation only
 if needed
Message-ID: <20111115123814.GE3225@redhat.com>
References: <20111115113414.GD3225@redhat.com>
 <1321358833.1421.62.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321358833.1421.62.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 01:07:13PM +0100, Peter Zijlstra wrote:
> On Tue, 2011-11-15 at 13:34 +0200, Gleb Natapov wrote:
> > 
> > Currently pmu is disabled and re-enabled on each timer interrupt even
> > when no rotation or frequency adjustment is needed. On Intel CPU this
> > results in two writes into PERF_GLOBAL_CTRL MSR per tick. On bare metal
> > it does not cause significant slowdown, but when running perf in a virtual
> > machine it leads to 20% slowdown on my machine.
> 
> 
> I detest asymmetric locking like that, does something like the below
> also work for you?
> 
It does.

>  
> +	if (!rotate && !freq)
> +		goto done;
> +
>  	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>  	perf_pmu_disable(cpuctx->ctx.pmu);
> +
> +	if (!freq)
> +		goto rotate;
> +
Why goto, why not

	if (freq) {
>  	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
>  	if (ctx)
>  		perf_ctx_adjust_freq(ctx, interval);
        }

And the same with next goto.

>  
> +rotate:
>  	if (!rotate)
> -		goto done;
> +		goto unlock;
>  
>  	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
>  	if (ctx)
> @@ -2413,12 +2432,13 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
>  
>  	perf_event_sched_in(cpuctx, ctx, current);
>  
> +unlock:
> +	perf_pmu_enable(cpuctx->ctx.pmu);
> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +
>  done:
>  	if (remove)
>  		list_del_init(&cpuctx->rotation_list);
> -
> -	perf_pmu_enable(cpuctx->ctx.pmu);
> -	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>  }
>  
>  void perf_event_task_tick(void)

--
			Gleb.
