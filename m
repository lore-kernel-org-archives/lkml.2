Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab1KMQG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 11:06:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab1KMQG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 11:06:27 -0500
Date: Sun, 13 Nov 2011 18:06:05 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf: do not set task_ctx pointer in cpuctx if there is
 no events in the context
Message-ID: <20111113160605.GW3225@redhat.com>
References: <20111023171033.GI17571@redhat.com>
 <20111103074104.GG14726@redhat.com>
 <1320670811.18053.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320670811.18053.33.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:00:11PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 09:41 +0200, Gleb Natapov wrote:
> > Ingo, Peter can you look into this please.
> 
> queued it and the jump_label thing.
I see jump_label thing in tip/perf/core but not this one yet. This is
good because this one needs amendment :) See below.

---

Do not set task_ctx pointer during sched_in if there is no
events associated with the context.  Otherwise if during task
execution total number of events in the system will become zero
perf_event_context_sched_out() will not be called and cpuctx->task_ctx
will be left with a stale value. Also perf_event_sched_in() shouldn't try
to schedule task events in this case otherwise cpuctx->task_ctx->is_active
will not be cleared during sched_out and will become incorrect.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d1a1bee..7210657 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2171,9 +2171,10 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	perf_event_sched_in(cpuctx, ctx, task);
+	if (ctx->nr_events)
+		cpuctx->task_ctx = ctx;
 
-	cpuctx->task_ctx = ctx;
+	perf_event_sched_in(cpuctx, cpuctx->task_ctx, task);
 
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
--
			Gleb.
