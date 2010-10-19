Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab0JSI3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:29:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:47452 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108Ab0JSI3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:29:16 -0400
Subject: Re: [PATCH] perf, powerpc: Fix power_pmu_event_init to not use
 event->ctx
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Alexey Kardashevskiy <aik@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20101019055535.GA10398@drongo>
References: <20101019055535.GA10398@drongo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 10:28:52 +0200
Message-ID: <1287476932.29097.1617.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 16:55 +1100, Paul Mackerras wrote:
> Commit c3f00c70 ("perf: Separate find_get_context() from event
> initialization") changed the generic perf_event code to call
> perf_event_alloc, which calls the arch-specific event_init code,
> before looking up the context for the new event.  Unfortunately,
> power_pmu_event_init uses event->ctx->task to see whether the new
> event is a per-task event or a system-wide event, and thus crashes
> since event->ctx is NULL at the point where power_pmu_event_init gets
> called.
> 
> (The reason it needs to know whether it is a per-task event is because
> there are some hardware events on Power systems which only count when
> the processor is not idle, and there are some fixed-function counters
> which count such events.  For example, the "run cycles" event counts
> cycles when the processor is not idle.  If the user asks to count
> cycles, we can use "run cycles" if this is a per-task event, since the
> processor is running when the task is running, by definition.  We
> can't use "run cycles" if the user asks for "cycles" on a system-wide
> counter.)
> 
> Fortunately the information we need is in the event->attach_state
> field, so we just use that instead.

Ah, sorry for the breakage.

> Signed-off-by: Paul Mackerras <paulus@samba.org>
> Reported-by: Alexey Kardashevskiy <aik@au1.ibm.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  arch/powerpc/kernel/perf_event.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
> index 9cb4924..3129c85 100644
> --- a/arch/powerpc/kernel/perf_event.c
> +++ b/arch/powerpc/kernel/perf_event.c
> @@ -1092,7 +1092,7 @@ static int power_pmu_event_init(struct perf_event *event)
>  	 * XXX we should check if the task is an idle task.
>  	 */
>  	flags = 0;
> -	if (event->ctx->task)
> +	if (event->attach_state & PERF_ATTACH_TASK)
>  		flags |= PPMU_ONLY_COUNT_RUN;
>  
>  	/*

