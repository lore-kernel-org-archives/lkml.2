Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090Ab1LFJoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:44:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34793 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab1LFJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:43:58 -0500
Date: Tue, 6 Dec 2011 01:43:32 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-515yhoatehd3gza7we9fapaa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Avoid a useless pmu_disable() in the perf-tick
Git-Commit-ID: 0f5a2601284237e2ba089389fd75d67f77626cef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:43:37 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0f5a2601284237e2ba089389fd75d67f77626cef
Gitweb:     http://git.kernel.org/tip/0f5a2601284237e2ba089389fd75d67f77626cef
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 16 Nov 2011 14:38:16 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:33:52 +0100

perf: Avoid a useless pmu_disable() in the perf-tick

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
Link: http://lkml.kernel.org/n/tip-515yhoatehd3gza7we9fapaa@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 kernel/events/core.c       |   48 +++++++++++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index b1f8912..cb44c9e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -890,6 +890,7 @@ struct perf_event_context {
 	int				nr_active;
 	int				is_active;
 	int				nr_stat;
+	int				nr_freq;
 	int				rotate_disable;
 	atomic_t			refcount;
 	struct task_struct		*task;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a355ffb..b3fed52 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1130,6 +1130,8 @@ event_sched_out(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
 	ctx->nr_active--;
+	if (event->attr.freq && event->attr.sample_freq)
+		ctx->nr_freq--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
 }
@@ -1407,6 +1409,8 @@ event_sched_in(struct perf_event *event,
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
+	if (event->attr.freq && event->attr.sample_freq)
+		ctx->nr_freq++;
 
 	if (event->attr.exclusive)
 		cpuctx->exclusive = 1;
@@ -2329,6 +2333,9 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 	u64 interrupts, now;
 	s64 delta;
 
+	if (!ctx->nr_freq)
+		return;
+
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2384,12 +2391,14 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
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
@@ -2397,33 +2406,40 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
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
 
-	if (!rotate)
-		goto done;
+	if (freq) {
+		perf_ctx_adjust_freq(&cpuctx->ctx, interval);
+		if (ctx)
+			perf_ctx_adjust_freq(ctx, interval);
+	}
 
-	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
-	if (ctx)
-		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
+	if (rotate) {
+		cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+		if (ctx)
+			ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
 
-	rotate_ctx(&cpuctx->ctx);
-	if (ctx)
-		rotate_ctx(ctx);
+		rotate_ctx(&cpuctx->ctx);
+		if (ctx)
+			rotate_ctx(ctx);
+
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
