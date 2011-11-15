Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab1KOMHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:07:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:50686 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1KOMHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:07:38 -0500
Subject: Re: [PATCH RFC] perf, core: disable pmu while context rotation only
 if needed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Date: Tue, 15 Nov 2011 13:07:13 +0100
In-Reply-To: <20111115113414.GD3225@redhat.com>
References: <20111115113414.GD3225@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321358833.1421.62.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-15 at 13:34 +0200, Gleb Natapov wrote:
> 
> Currently pmu is disabled and re-enabled on each timer interrupt even
> when no rotation or frequency adjustment is needed. On Intel CPU this
> results in two writes into PERF_GLOBAL_CTRL MSR per tick. On bare metal
> it does not cause significant slowdown, but when running perf in a virtual
> machine it leads to 20% slowdown on my machine.


I detest asymmetric locking like that, does something like the below
also work for you?

---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |   30 +++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1e9ebe5..92773aa 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -889,6 +889,7 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
+	int				nr_freq;
 	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7f693e9..d8f2f38 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1127,6 +1127,8 @@ event_sched_out(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
 	ctx->nr_active--;
+	if (event->attr.freq && event->attr.sample_freq)
+		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
 }
@@ -1403,6 +1405,8 @@ event_sched_in(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
+	if (event->attr.freq && event->attr.sample_freq)
+		ctx->nr_freq++;
 
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
@@ -2324,6 +2328,9 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 	u64 interrupts, now;
 	s64 delta;
 
+	if (!ctx->nr_freq)
+		return;
+
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2379,12 +2386,14 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
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
@@ -2392,16 +2401,26 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
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
+
+	if (!freq)
+		goto rotate;
+
 	perf_ctx_adjust_freq(&cpuctx->ctx, interval);
 	if (ctx)
 		perf_ctx_adjust_freq(ctx, interval);
 
+rotate:
 	if (!rotate)
-		goto done;
+		goto unlock;
 
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 	if (ctx)
@@ -2413,12 +2432,13 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 
 	perf_event_sched_in(cpuctx, ctx, current);
 
+unlock:
+	perf_pmu_enable(cpuctx->ctx.pmu);
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
-
-	perf_pmu_enable(cpuctx->ctx.pmu);
-	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
 void perf_event_task_tick(void)

