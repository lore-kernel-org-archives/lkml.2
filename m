Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1KNKvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 05:51:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1KNKvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 05:51:22 -0500
Subject: Re: [PATCH] perf: do not set task_ctx pointer in cpuctx if there is
 no events in the context
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 14 Nov 2011 11:50:54 +0100
In-Reply-To: <20111113160605.GW3225@redhat.com>
References: <20111023171033.GI17571@redhat.com>
	 <20111103074104.GG14726@redhat.com> <1320670811.18053.33.camel@twins>
	 <20111113160605.GW3225@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321267854.1421.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-11-13 at 18:06 +0200, Gleb Natapov wrote:
> On Mon, Nov 07, 2011 at 02:00:11PM +0100, Peter Zijlstra wrote:
> > On Thu, 2011-11-03 at 09:41 +0200, Gleb Natapov wrote:
> > > Ingo, Peter can you look into this please.
> > 
> > queued it and the jump_label thing.
> I see jump_label thing in tip/perf/core but not this one yet. This is
> good because this one needs amendment :) See below.

Weird ass stuff, because my copy still applies to tip/master. Ingo, wtf
is up?

> ---
> 
> Do not set task_ctx pointer during sched_in if there is no
> events associated with the context.  Otherwise if during task
> execution total number of events in the system will become zero
> perf_event_context_sched_out() will not be called and cpuctx->task_ctx
> will be left with a stale value. Also perf_event_sched_in() shouldn't try
> to schedule task events in this case otherwise cpuctx->task_ctx->is_active
> will not be cleared during sched_out and will become incorrect.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>

--- missing right there

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d1a1bee..7210657 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -2171,9 +2171,10 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
>  	 */
>  	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
>  
> -	perf_event_sched_in(cpuctx, ctx, task);
> +	if (ctx->nr_events)
> +		cpuctx->task_ctx = ctx;
>  
> -	cpuctx->task_ctx = ctx;
> +	perf_event_sched_in(cpuctx, cpuctx->task_ctx, task);
>  
>  	perf_pmu_enable(ctx->pmu);
>  	perf_ctx_unlock(cpuctx, ctx);
> --
> 			Gleb.

