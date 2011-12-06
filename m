Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab1LFJnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:43:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:46704 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab1LFJnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:43:07 -0500
Message-ID: <1323164549.32012.50.camel@twins>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arun Sharma <asharma@fb.com>
Cc: Stephane Eranian <eranian@google.com>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>, Vince Weaver <vince@deater.net>,
        linux-kernel@vger.kernel.org
Date: Tue, 06 Dec 2011 10:42:29 +0100
In-Reply-To: <4EDD50F5.30300@fb.com>
References: <20111121145114.049265181@chello.nl> <4ED9267F.10106@fb.com>
	 <CABPqkBRpYA-StOTDFwyFhFtBPynbn-FLUzqZvaQn3oM3SJpCWg@mail.gmail.com>
	 <4EDD26B9.8070007@fb.com> <4EDD50F5.30300@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-05 at 15:17 -0800, Arun Sharma wrote:
> 
> I suspect that some optimizations are possible in perf_rotate_context 
> that don't involve enabling/disabling the PMU via an IPI for simple 
> cases that involve one or two hardware events (eg: fixed counters). 

I've got a patch queued that does exactly that.

---
Subject: perf: Avoid a useless pmu_disable() in the perf-tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Nov 16 14:38:16 CET 2011

Gleb writes:
> Currently pmu is disabled and re-enabled on each timer interrupt even
> when no rotation or frequency adjustment is needed. On Intel CPU this
> results in two writes into PERF_GLOBAL_CTRL MSR per tick. On bare metal
> it does not cause significant slowdown, but when running perf in a virtual
> machine it leads to 20% slowdown on my machine.

Cure this by keeping a perf_event_context::nr_freq counter that counts the
number of active events that require frequency adjustments and use this in a
similar fashion to the already existing nr_events != nr_active test in
perf_rotate_context().

By being able to exclude both rotation and frequency adjustments a-priory for
the common case we can avoid the otherwise superfluous PMU disable.

Suggested-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    1 
 kernel/events/core.c       |   50 +++++++++++++++++++++++++++++----------------
 2 files changed, 34 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -889,6 +889,7 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
+	int				nr_freq;
 	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
Index: linux-2.6/kernel/events/core.c
===================================================================
--- linux-2.6.orig/kernel/events/core.c
+++ linux-2.6/kernel/events/core.c
@@ -1127,6 +1127,8 @@ event_sched_out(struct perf_event *event
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
 	ctx->nr_active--;
+	if (event->attr.freq && event->attr.sample_freq)
+		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
 }
@@ -1404,6 +1406,8 @@ event_sched_in(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
+	if (event->attr.freq && event->attr.sample_freq)
+		ctx->nr_freq++;
 
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
@@ -2326,6 +2330,9 @@ static void perf_ctx_adjust_freq(struct
 	u64 interrupts, now;
 	s64 delta;
 
+	if (!ctx->nr_freq)
+		return;
+
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2381,12 +2388,14 @@ static void perf_rotate_context(struct p
 {
 	u64 interval = (u64)cpuctx->jiffies_interval * TICK_NSEC;
 	struct perf_event_context *ctx = NULL;
-	int rotate = 0, remove = 1;
+	int rotate = 0, remove = 1, freq = 0;
 
 	if (cpuctx->ctx.nr_events) {
 		remove = 0;
 		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
 			rotate = 1;
+		if (cpuctx->ctx.nr_freq)
+			freq = 1;
 	}
 
 	ctx = cpuctx->task_ctx;
@@ -2394,33 +2403,40 @@ static void perf_rotate_context(struct p
 		remove = 0;
 		if (ctx->nr_events != ctx->nr_active)
 			rotate = 1;
+		if (ctx->nr_freq)
+			freq = 1;
 	}
 
+	if (!rotate && !freq)
+		goto done;
+
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
-	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
-	if (ctx)
-		perf_ctx_adjust_freq(ctx, interval);
-
-	if (!rotate)
-		goto done;
 
-	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
-	if (ctx)
-		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
+	if (freq) {
+		perf_ctx_adjust_freq(&cpuctx->ctx, interval);
+		if (ctx)
+			perf_ctx_adjust_freq(ctx, interval);
+	}
+
+	if (rotate) {
+		cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+		if (ctx)
+			ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
+
+		rotate_ctx(&cpuctx->ctx);
+		if (ctx)
+			rotate_ctx(ctx);
 
-	rotate_ctx(&cpuctx->ctx);
-	if (ctx)
-		rotate_ctx(ctx);
+		perf_event_sched_in(cpuctx, ctx, current);
+	}
 
-	perf_event_sched_in(cpuctx, ctx, current);
+	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
-
-	perf_pmu_enable(cpuctx->ctx.pmu);
-	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
 void perf_event_task_tick(void)

