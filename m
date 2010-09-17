Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0IQJe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:34:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0IQJeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:34:08 -0400
Message-Id: <20100917093009.461794357@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 17 Sep 2010 11:28:49 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/6] perf: Fix perf_event_exit_cpu_context()
References: <20100917092844.651383640@chello.nl>
Content-Disposition: inline; filename=perf-fix-unplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the right cpu-context.. spotted by preempt warning on hot-unplug

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -6259,14 +6259,13 @@ static void perf_event_exit_cpu_context(
 
 	idx = srcu_read_lock(&pmus_srcu);
 	list_for_each_entry_rcu(pmu, &pmus, entry) {
-		ctx = &this_cpu_ptr(pmu->pmu_cpu_context)->ctx;
+		ctx = &per_cpu_ptr(pmu->pmu_cpu_context, cpu)->ctx;
 
 		mutex_lock(&ctx->mutex);
 		smp_call_function_single(cpu, __perf_event_exit_context, ctx, 1);
 		mutex_unlock(&ctx->mutex);
 	}
 	srcu_read_unlock(&pmus_srcu, idx);
-
 }
 
 static void perf_event_exit_cpu(int cpu)


