Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1KVOIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:08:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab1KVOId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:08:33 -0500
Date: Tue, 22 Nov 2011 16:08:21 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf,core: do no try to schedule task events if there are
 none.
Message-ID: <20111122140821.GF2557@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_event_sched_in() shouldn't try to schedule task events if there
are none otherwise task's ctx->is_active will be set and will not be
cleared during sched_out. This will prevent newly added events from
being scheduled into the task context.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---

The patch is against tip/perf/urgent since it depends on commit
1d5f003f5a9 there.  I've sent updated version of above commit earlier but
unfortunately old version was applied and I do not see amended version
in Peter's queue either. So here is incremental fix.

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0c1186..920314e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2171,11 +2171,11 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 	 */
 	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
 
-	perf_event_sched_in(cpuctx, ctx, task);
-
 	if (ctx->nr_events)
 		cpuctx->task_ctx = ctx;
 
+	perf_event_sched_in(cpuctx, cpuctx->task_ctx, task);
+
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
 
--
			Gleb.
