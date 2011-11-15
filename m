Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1KOLem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:34:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1KOLel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:34:41 -0500
Date: Tue, 15 Nov 2011 13:34:14 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH RFC] perf, core: disable pmu while context rotation only if
 needed
Message-ID: <20111115113414.GD3225@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently pmu is disabled and re-enabled on each timer interrupt even
when no rotation or frequency adjustment is needed. On Intel CPU this
results in two writes into PERF_GLOBAL_CTRL MSR per tick. On bare metal
it does not cause significant slowdown, but when running perf in a virtual
machine it leads to 20% slowdown on my machine.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bdcd413..83c87d8 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2317,7 +2317,7 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	}
 }
 
-static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
+static bool perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period, bool pmu_disabled)
 {
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
@@ -2347,6 +2347,11 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
+		if (!pmu_disabled) {
+			perf_pmu_disable(ctx->pmu);
+			pmu_disabled = true;
+		}
+
 		event->pmu->read(event);
 		now = local64_read(&event->count);
 		delta = now - hwc->freq_count_stamp;
@@ -2355,6 +2360,8 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (delta > 0)
 			perf_adjust_period(event, period, delta);
 	}
+
+	return pmu_disabled;
 }
 
 /*
@@ -2380,6 +2387,7 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	u64 interval = (u64)cpuctx->jiffies_interval * TICK_NSEC;
 	struct perf_event_context *ctx = NULL;
 	int rotate = 0, remove = 1;
+	bool pmu_disabled = false;
 
 	if (cpuctx->ctx.nr_events) {
 		remove = 0;
@@ -2395,10 +2403,9 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 	}
 
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
-	perf_pmu_disable(cpuctx->ctx.pmu);
-	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
+	pmu_disabled = perf_ctx_adjust_freq(&cpuctx->ctx, interval, pmu_disabled);
 	if (ctx)
-		perf_ctx_adjust_freq(ctx, interval);
+		pmu_disabled = perf_ctx_adjust_freq(ctx, interval, pmu_disabled);
 
 	if (!rotate)
 		goto done;
@@ -2417,7 +2424,8 @@ done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
 
-	perf_pmu_enable(cpuctx->ctx.pmu);
+	if (pmu_disabled)
+		perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
--
			Gleb.
