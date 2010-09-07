Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab0IGQ4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:56:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211Ab0IGQ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:56:40 -0400
Message-Id: <20100907165012.049565075@chello.nl>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 18:46:48 +0200
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
Subject: [RFC][PATCH 15/19] perf: Move some code around
References: <20100907164633.879932949@chello.nl>
Content-Disposition: inline; filename=perf-pmu-context-7.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all inherit code near each other.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_event.c |  200 ++++++++++++++++++++++++++--------------------------
 1 file changed, 100 insertions(+), 100 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -5537,106 +5537,6 @@ perf_event_create_kernel_counter(struct 
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
-/*
- * inherit a event from parent task to child task:
- */
-static struct perf_event *
-inherit_event(struct perf_event *parent_event,
-	      struct task_struct *parent,
-	      struct perf_event_context *parent_ctx,
-	      struct task_struct *child,
-	      struct perf_event *group_leader,
-	      struct perf_event_context *child_ctx)
-{
-	struct perf_event *child_event;
-
-	/*
-	 * Instead of creating recursive hierarchies of events,
-	 * we link inherited events back to the original parent,
-	 * which has a filp for sure, which we use as the reference
-	 * count:
-	 */
-	if (parent_event->parent)
-		parent_event = parent_event->parent;
-
-	child_event = perf_event_alloc(&parent_event->attr,
-					   parent_event->cpu,
-					   group_leader, parent_event,
-					   NULL);
-	if (IS_ERR(child_event))
-		return child_event;
-	get_ctx(child_ctx);
-
-	/*
-	 * Make the child state follow the state of the parent event,
-	 * not its attr.disabled bit.  We hold the parent's mutex,
-	 * so we won't race with perf_event_{en, dis}able_family.
-	 */
-	if (parent_event->state >= PERF_EVENT_STATE_INACTIVE)
-		child_event->state = PERF_EVENT_STATE_INACTIVE;
-	else
-		child_event->state = PERF_EVENT_STATE_OFF;
-
-	if (parent_event->attr.freq) {
-		u64 sample_period = parent_event->hw.sample_period;
-		struct hw_perf_event *hwc = &child_event->hw;
-
-		hwc->sample_period = sample_period;
-		hwc->last_period   = sample_period;
-
-		local64_set(&hwc->period_left, sample_period);
-	}
-
-	child_event->ctx = child_ctx;
-	child_event->overflow_handler = parent_event->overflow_handler;
-
-	/*
-	 * Link it up in the child's context:
-	 */
-	add_event_to_ctx(child_event, child_ctx);
-
-	/*
-	 * Get a reference to the parent filp - we will fput it
-	 * when the child event exits. This is safe to do because
-	 * we are in the parent and we know that the filp still
-	 * exists and has a nonzero count:
-	 */
-	atomic_long_inc(&parent_event->filp->f_count);
-
-	/*
-	 * Link this into the parent event's child list
-	 */
-	WARN_ON_ONCE(parent_event->ctx->parent_ctx);
-	mutex_lock(&parent_event->child_mutex);
-	list_add_tail(&child_event->child_list, &parent_event->child_list);
-	mutex_unlock(&parent_event->child_mutex);
-
-	return child_event;
-}
-
-static int inherit_group(struct perf_event *parent_event,
-	      struct task_struct *parent,
-	      struct perf_event_context *parent_ctx,
-	      struct task_struct *child,
-	      struct perf_event_context *child_ctx)
-{
-	struct perf_event *leader;
-	struct perf_event *sub;
-	struct perf_event *child_ctr;
-
-	leader = inherit_event(parent_event, parent, parent_ctx,
-				 child, NULL, child_ctx);
-	if (IS_ERR(leader))
-		return PTR_ERR(leader);
-	list_for_each_entry(sub, &parent_event->sibling_list, group_entry) {
-		child_ctr = inherit_event(sub, parent, parent_ctx,
-					    child, leader, child_ctx);
-		if (IS_ERR(child_ctr))
-			return PTR_ERR(child_ctr);
-	}
-	return 0;
-}
-
 static void sync_child_event(struct perf_event *child_event,
 			       struct task_struct *child)
 {
@@ -5825,6 +5725,106 @@ void perf_event_free_task(struct task_st
 	put_ctx(ctx);
 }
 
+/*
+ * inherit a event from parent task to child task:
+ */
+static struct perf_event *
+inherit_event(struct perf_event *parent_event,
+	      struct task_struct *parent,
+	      struct perf_event_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_event *group_leader,
+	      struct perf_event_context *child_ctx)
+{
+	struct perf_event *child_event;
+
+	/*
+	 * Instead of creating recursive hierarchies of events,
+	 * we link inherited events back to the original parent,
+	 * which has a filp for sure, which we use as the reference
+	 * count:
+	 */
+	if (parent_event->parent)
+		parent_event = parent_event->parent;
+
+	child_event = perf_event_alloc(&parent_event->attr,
+					   parent_event->cpu,
+					   group_leader, parent_event,
+					   NULL);
+	if (IS_ERR(child_event))
+		return child_event;
+	get_ctx(child_ctx);
+
+	/*
+	 * Make the child state follow the state of the parent event,
+	 * not its attr.disabled bit.  We hold the parent's mutex,
+	 * so we won't race with perf_event_{en, dis}able_family.
+	 */
+	if (parent_event->state >= PERF_EVENT_STATE_INACTIVE)
+		child_event->state = PERF_EVENT_STATE_INACTIVE;
+	else
+		child_event->state = PERF_EVENT_STATE_OFF;
+
+	if (parent_event->attr.freq) {
+		u64 sample_period = parent_event->hw.sample_period;
+		struct hw_perf_event *hwc = &child_event->hw;
+
+		hwc->sample_period = sample_period;
+		hwc->last_period   = sample_period;
+
+		local64_set(&hwc->period_left, sample_period);
+	}
+
+	child_event->ctx = child_ctx;
+	child_event->overflow_handler = parent_event->overflow_handler;
+
+	/*
+	 * Link it up in the child's context:
+	 */
+	add_event_to_ctx(child_event, child_ctx);
+
+	/*
+	 * Get a reference to the parent filp - we will fput it
+	 * when the child event exits. This is safe to do because
+	 * we are in the parent and we know that the filp still
+	 * exists and has a nonzero count:
+	 */
+	atomic_long_inc(&parent_event->filp->f_count);
+
+	/*
+	 * Link this into the parent event's child list
+	 */
+	WARN_ON_ONCE(parent_event->ctx->parent_ctx);
+	mutex_lock(&parent_event->child_mutex);
+	list_add_tail(&child_event->child_list, &parent_event->child_list);
+	mutex_unlock(&parent_event->child_mutex);
+
+	return child_event;
+}
+
+static int inherit_group(struct perf_event *parent_event,
+	      struct task_struct *parent,
+	      struct perf_event_context *parent_ctx,
+	      struct task_struct *child,
+	      struct perf_event_context *child_ctx)
+{
+	struct perf_event *leader;
+	struct perf_event *sub;
+	struct perf_event *child_ctr;
+
+	leader = inherit_event(parent_event, parent, parent_ctx,
+				 child, NULL, child_ctx);
+	if (IS_ERR(leader))
+		return PTR_ERR(leader);
+	list_for_each_entry(sub, &parent_event->sibling_list, group_entry) {
+		child_ctr = inherit_event(sub, parent, parent_ctx,
+					    child, leader, child_ctx);
+		if (IS_ERR(child_ctr))
+			return PTR_ERR(child_ctr);
+	}
+	return 0;
+}
+
 static int
 inherit_task_group(struct perf_event *event, struct task_struct *parent,
 		   struct perf_event_context *parent_ctx,


