Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1DITXU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34450 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab1DITWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:44 -0400
Message-Id: <20110409192141.665385503@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:40 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 1/9] perf: Optimize ctx_sched_out
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-cleanup-ctx_sched_out.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg noted that ctx_sched_out() disables the PMU even though it might
not actually do something, avoid needless PMU-disabling.

Reported-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1767,7 +1767,6 @@ static void ctx_sched_out(struct perf_ev
 	struct perf_event *event;
 
 	raw_spin_lock(&ctx->lock);
-	perf_pmu_disable(ctx->pmu);
 	ctx->is_active = 0;
 	if (likely(!ctx->nr_events))
 		goto out;
@@ -1777,6 +1776,7 @@ static void ctx_sched_out(struct perf_ev
 	if (!ctx->nr_active)
 		goto out;
 
+	perf_pmu_disable(ctx->pmu);
 	if (event_type & EVENT_PINNED) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
@@ -1786,8 +1786,8 @@ static void ctx_sched_out(struct perf_ev
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
-out:
 	perf_pmu_enable(ctx->pmu);
+out:
 	raw_spin_unlock(&ctx->lock);
 }
 


