Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab1DITXJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 15:23:09 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34452 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab1DITWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 15:22:47 -0400
Message-Id: <20110409192141.930282378@chello.nl>
User-Agent: quilt/0.48-1
Date: Sat, 09 Apr 2011 21:17:45 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 6/9] perf: Change ctx::is_active semantics
References: <20110409191739.813727025@chello.nl>
Content-Disposition: inline; filename=perf-is_active.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of tracking if a context is active or not, track which events
of the context are active. By making it a bitmask of
EVENT_PINNED|EVENT_FLEXIBLE we can simplify some of the scheduling
routines since it can avoid adding events that are already active.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |   99 +++++++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 51 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1780,8 +1775,9 @@ static void ctx_sched_out(struct perf_ev
 			  enum event_type_t event_type)
 {
 	struct perf_event *event;
+	int is_active = ctx->is_active;
 
-	ctx->is_active = 0;
+	ctx->is_active &= ~event_type;
 	if (likely(!ctx->nr_events))
 		return;
 
@@ -1791,12 +1787,12 @@ static void ctx_sched_out(struct perf_ev
 		return;
 
 	perf_pmu_disable(ctx->pmu);
-	if (event_type & EVENT_PINNED) {
+	if ((is_active & EVENT_PINNED) && (event_type & EVENT_PINNED)) {
 		list_for_each_entry(event, &ctx->pinned_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
 
-	if (event_type & EVENT_FLEXIBLE) {
+	if ((is_active & EVENT_FLEXIBLE) && (event_type & EVENT_FLEXIBLE)) {
 		list_for_each_entry(event, &ctx->flexible_groups, group_entry)
 			group_sched_out(event, cpuctx, ctx);
 	}
@@ -2075,8 +2071,9 @@ ctx_sched_in(struct perf_event_context *
 	     struct task_struct *task)
 {
 	u64 now;
+	int is_active = ctx->is_active;
 
-	ctx->is_active = 1;
+	ctx->is_active |= event_type;
 	if (likely(!ctx->nr_events))
 		return;
 
@@ -2087,11 +2084,11 @@ ctx_sched_in(struct perf_event_context *
 	 * First go through the list and put on any pinned groups
 	 * in order to give them the best chance of going on.
 	 */
-	if (event_type & EVENT_PINNED)
+	if (!(is_active & EVENT_PINNED) && (event_type & EVENT_PINNED))
 		ctx_pinned_sched_in(ctx, cpuctx);
 
 	/* Then walk through the lower prio flexible groups */
-	if (event_type & EVENT_FLEXIBLE)
+	if (!(is_active & EVENT_FLEXIBLE) && (event_type & EVENT_FLEXIBLE))
 		ctx_flexible_sched_in(ctx, cpuctx);
 }
 


