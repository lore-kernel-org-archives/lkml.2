Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab1FFW3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab1FFW3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:29:08 -0400
Date: Tue, 7 Jun 2011 00:28:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        oleg@redhat.com
Subject: Re: [PATCH] perf, core: Fix initial task_ctx/event installation
Message-ID: <20110606222856.GA2280@jolsa.Belkin>
References: <1307371095-10141-1-git-send-email-jolsa@redhat.com>
 <1307382026.2322.226.camel@twins>
 <1307384837.2497.738.camel@laptop>
 <1307399008.2497.971.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307399008.2497.971.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 12:23:28AM +0200, Peter Zijlstra wrote:
> This works for me..
> 
> ---
>  kernel/events/core.c |   28 +++++++++++++++++-----------
>  1 files changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ba89f40..5e8c7b1 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1505,25 +1505,31 @@ static int  __perf_install_in_context(void *info)
>  	struct perf_event_context *task_ctx = cpuctx->task_ctx;
>  	struct task_struct *task = current;
>  
> -	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +	perf_ctx_lock(cpuctx, task_ctx);
>  	perf_pmu_disable(cpuctx->ctx.pmu);
>  
>  	/*
>  	 * If there was an active task_ctx schedule it out.
>  	 */
> -	if (task_ctx) {
> +	if (task_ctx)
>  		task_ctx_sched_out(task_ctx);
> -		/*
> -		 * If the context we're installing events in is not the
> -		 * active task_ctx, flip them.
> -		 */
> -		if (ctx->task && task_ctx != ctx) {
> -			raw_spin_unlock(&cpuctx->ctx.lock);
> -			raw_spin_lock(&ctx->lock);
> -			cpuctx->task_ctx = task_ctx = ctx;
> -		}
> +
> +	/*
> +	 * If the context we're installing events in is not the
> +	 * active task_ctx, flip them.
> +	 */
> +	if (ctx->task && task_ctx != ctx) {
> +		if (task_ctx)
> +			raw_spin_unlock(&task_ctx->lock);
> +		raw_spin_lock(&ctx->lock);
> +		task_ctx = ctx;
> +	}
> +
> +	if (task_ctx) {
> +		cpuctx->task_ctx = task_ctx;
>  		task = task_ctx->task;
>  	}
> +
>  	cpu_ctx_sched_out(cpuctx, EVENT_ALL);
>  
>  	update_context_time(ctx);
> 
> 

just came back :) seems ok.. I'll test tomorow and let you know

thanks,
jirka
