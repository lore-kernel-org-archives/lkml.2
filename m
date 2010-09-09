Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0IITwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:52:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:33245 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108Ab0IITwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:52:41 -0400
Date: Thu, 9 Sep 2010 19:52:14 GMT
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
Subject: [tip:perf/core] perf: Move some code around
Message-ID: <tip-97dee4f3206622f31396dede2b5ddb8670458f56@git.kernel.org>
Git-Commit-ID: 97dee4f3206622f31396dede2b5ddb8670458f56
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Sep 2010 19:52:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97dee4f3206622f31396dede2b5ddb8670458f56
Gitweb:     http://git.kernel.org/tip/97dee4f3206622f31396dede2b5ddb8670458f56
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 7 Sep 2010 15:35:33 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Sep 2010 20:46:33 +0200

perf: Move some code around

Move all inherit code near each other.

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
 kernel/perf_event.c |  200 +++++++++++++++++++++++++-------------------------
 1 files changed, 100 insertions(+), 100 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8ca6e69..dae0e2f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5556,106 +5556,6 @@ err:
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
@@ -5844,6 +5744,106 @@ again:
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
