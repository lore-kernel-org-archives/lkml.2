Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1JWRK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:10:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab1JWRK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:10:56 -0400
Date: Sun, 23 Oct 2011 19:10:33 +0200
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf: do not set task_ctx pointer in cpuctx if there is no
 events in the context
Message-ID: <20111023171033.GI17571@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not set task_ctx pointer during sched_in if there is no
events associated with the context.  Otherwise if during task
execution total number of events in the system will become zero
perf_event_context_sched_out() will not be called and cpuctx->task_ctx
will be left with a stale value.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0f85778..68b13ee 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2172,7 +2172,8 @@ static void perf_event_context_sched_in(struct perf_event_context *ctx,
 
 	perf_event_sched_in(cpuctx, ctx, task);
 
-	cpuctx->task_ctx = ctx;
+	if (ctx->nr_events)
+		cpuctx->task_ctx = ctx;
 
 	perf_pmu_enable(ctx->pmu);
 	perf_ctx_unlock(cpuctx, ctx);
--
			Gleb.
