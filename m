Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0IITyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:54:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:54431 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab0IITyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:54:10 -0400
Date: Thu, 9 Sep 2010 19:53:39 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, eranian@googlemail.com, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com, robert.richter@amd.com,
        fweisbec@gmail.com, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, eranian@googlemail.com,
        a.p.zijlstra@chello.nl, yanmin_zhang@linux.intel.com,
        fweisbec@gmail.com, robert.richter@amd.com, ming.m.lin@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize context ops
Message-ID: <tip-1b9a644fece117cfa5474a2388d6b89d1baf8ddf@git.kernel.org>
Git-Commit-ID: 1b9a644fece117cfa5474a2388d6b89d1baf8ddf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:53:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b9a644fece117cfa5474a2388d6b89d1baf8ddf
Gitweb:     http://git.kernel.org/tip/1b9a644fece117cfa5474a2388d6b89d1baf8ddf
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 7 Sep 2010 18:32:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:34 +0200

perf: Optimize context ops

Assuming we don't mix events of different pmus onto a single context
(with the exeption of software events inside a hardware group) we can
now assume that all events on a particular context belong to the same
pmu, hence we can disable the pmu for the entire context operations.

This reduces the amount of hardware writes.

The exception for swevents comes from the fact that the sw pmu disable
is a nop.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Yanmin <yanmin_zhang@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 357ee8d..9819a69 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1065,6 +1065,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 	struct perf_event *event;
 
 	raw_spin_lock(&ctx->lock);
+	perf_pmu_disable(ctx->pmu);
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_events))
 		goto out;
@@ -1083,6 +1084,7 @@ static void ctx_sched_out(struct perf_event_context *ctx,
 			group_sched_out(event, cpuctx, ctx);
 	}
 out:
+	perf_pmu_enable(ctx->pmu);
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -1400,6 +1402,7 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
 	if (cpuctx->task_ctx == ctx)
 		return;
 
+	perf_pmu_disable(ctx->pmu);
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -1418,6 +1421,7 @@ void perf_event_context_sched_in(struct perf_event_context *ctx)
 	 * cpu-context we got scheduled on is actually rotating.
 	 */
 	perf_pmu_rotate_start(ctx->pmu);
+	perf_pmu_enable(ctx->pmu);
 }
 
 /*
@@ -1629,6 +1633,7 @@ static enum hrtimer_restart perf_event_context_tick(struct hrtimer *timer)
 			rotate = 1;
 	}
 
+	perf_pmu_disable(cpuctx->ctx.pmu);
 	perf_ctx_adjust_freq(&cpuctx->ctx, cpuctx->timer_interval);
 	if (ctx)
 		perf_ctx_adjust_freq(ctx, cpuctx->timer_interval);
@@ -1649,6 +1654,7 @@ static enum hrtimer_restart perf_event_context_tick(struct hrtimer *timer)
 		task_ctx_sched_in(ctx, EVENT_FLEXIBLE);
 
 done:
+	perf_pmu_enable(cpuctx->ctx.pmu);
 	hrtimer_forward_now(timer, ns_to_ktime(cpuctx->timer_interval));
 
 	return restart;
