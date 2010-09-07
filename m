Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab0IGQ4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:56:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:60097 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab0IGQ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:40 -0400
Message-Id: <20100907165012.279252800@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:52 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
        Robert Richter <robert.richter@amd.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Yanmin <yanmin_zhang@linux.intel.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 19/19] perf: Optimize context ops
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-more-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assuming we don't mix events of different pmus onto a single context
(with the exeption of software events inside a hardware group) we can
now assume that all events on a particular context belong to the same
pmu, hence we can disable the pmu for the entire context operations.

This reduces the amount of hardware writes.

The exception for swevents comes from the fact that the sw pmu disable
is a nop.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1046,6 +1046,7 @@ static void ctx_sched_out(struct perf_ev
 	struct perf_event *event;
 
 	raw_spin_lock(&ctx->lock);
+	perf_pmu_disable(ctx->pmu);
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_events))
 		goto out;
@@ -1064,6 +1065,7 @@ static void ctx_sched_out(struct perf_ev
 			group_sched_out(event, cpuctx, ctx);
 	}
 out:
+	perf_pmu_enable(ctx->pmu);
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1386,6 +1388,7 @@ void perf_event_context_sched_in(struct 
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_pmu_disable(ctx->pmu);
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -1398,6 +1401,7 @@ void perf_event_context_sched_in(struct 
 	ctx_sched_in(ctx, cpuctx, EVENT_FLEXIBLE);
 
 	cpuctx->task_ctx = ctx;
+	perf_pmu_enable(ctx->pmu);
 }
 
 /*
@@ -1602,6 +1606,7 @@ static enum hrtimer_restart perf_event_c
 			rotate = 1;
 	}
 
+	perf_pmu_disable(cpuctx->ctx.pmu);
 	perf_ctx_adjust_freq(&cpuctx->ctx, cpuctx->timer_interval);
 	if (ctx)
 		perf_ctx_adjust_freq(ctx, cpuctx->timer_interval);
@@ -1622,6 +1627,7 @@ static enum hrtimer_restart perf_event_c
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
 done:
+	perf_pmu_enable(cpuctx->ctx.pmu);
 	hrtimer_forward_now(timer, ns_to_ktime(cpuctx->timer_interval));
 
 	return restart;


