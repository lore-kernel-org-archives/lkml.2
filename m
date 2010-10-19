Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0JSVqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:46:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12126 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758004Ab0JSVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:45:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=Bju0PnPpYWIjLjsDTSYwz/zhj12KzxK7aumJNfz73GUCjHFX+CjiPYpm1iEeuS4l2U
         DlU5oqGFBdVnz6StZ8vg==
Message-ID: <4cbe1191.8709d80a.1d10.ffff9970@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 19 Oct 2010 23:45:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix the fix for transaction recovery in group_sched_in()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the group_sched_in() fix added by commit 8e5fc1a.
Although the patch solved the issue with time_running, time_enabled
for all events in a group, it had one flaw in case the group could
never be scheduled. It would cause time_enabled to get negative.
The issue was that tstamp_stopped was never updated, even though
tstamp_enabled was.

This new version is much simpler and ensures that in case of
error in group_sched_in() during event_sched_in(), the events up
to the failed event go through regular event_sched_out(). But the
failed event and the remaining events in the group have their timings
adjusted as if they had also gone through event_sched_in() and
event_sched_out(). This ensures timing uniformity across all
events in a group. This also takes care of the tstamp_stopped problem
in case the group could never be scheduled. The tstamp_stopped is
updated as if the event had actually run.

With this patch, the following now reports correct time_enabled,
in case the NMI watchdog is active:

$ task -e unhalted_core_cycles,instructions_retired,baclears,baclears  noploop 1
noploop for 1 seconds

0 unhalted_core_cycles (100.00% scaling, ena=997,552,872, run=0)
0 instructions_retired (100.00% scaling, ena=997,552,872, run=0)
0 baclears (100.00% scaling, ena=997,552,872, run=0)
0 baclears (100.00% scaling, ena=997,552,872, run=0)

And the older test case also works:

$ task -einstructions_retired,baclears,baclears -e unhalted_core_cycles,baclears,baclears sleep 5

1680885 instructions_retired (69.39% scaling, ena=950756, run=291006)
  10735 baclears (69.39% scaling, ena=950756, run=291006)
  10735 baclears (69.39% scaling, ena=950756, run=291006)

      0 unhalted_core_cycles (100.00% scaling, ena=817932, run=0)
      0 baclears (100.00% scaling, ena=817932, run=0)
      0 baclears (100.00% scaling, ena=817932, run=0)

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f309e80..8e5841d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -418,7 +418,7 @@ event_filter_match(struct perf_event *event)
 }
 
 static int
-__event_sched_out(struct perf_event *event,
+event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
@@ -447,6 +447,8 @@ __event_sched_out(struct perf_event *event,
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
+	event->tstamp_stopped = ctx->time;
+
 	if (!is_software_event(event))
 		cpuctx->active_oncpu--;
 	ctx->nr_active--;
@@ -456,18 +458,6 @@ __event_sched_out(struct perf_event *event,
 }
 
 static void
-event_sched_out(struct perf_event *event,
-		  struct perf_cpu_context *cpuctx,
-		  struct perf_event_context *ctx)
-{
-	int ret;
-
-	ret = __event_sched_out(event, cpuctx, ctx);
-	if (ret)
-		event->tstamp_stopped = ctx->time;
-}
-
-static void
 group_sched_out(struct perf_event *group_event,
 		struct perf_cpu_context *cpuctx,
 		struct perf_event_context *ctx)
@@ -664,7 +654,7 @@ retry:
 }
 
 static int
-__event_sched_in(struct perf_event *event,
+event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
 		 struct perf_event_context *ctx)
 {
@@ -684,6 +674,8 @@ __event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
+	event->tstamp_running += ctx->time - event->tstamp_stopped;
+
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
@@ -694,35 +686,6 @@ __event_sched_in(struct perf_event *event,
 	return 0;
 }
 
-static inline int
-event_sched_in(struct perf_event *event,
-		 struct perf_cpu_context *cpuctx,
-		 struct perf_event_context *ctx)
-{
-	int ret = __event_sched_in(event, cpuctx, ctx);
-	if (ret)
-		return ret;
-	event->tstamp_running += ctx->time - event->tstamp_stopped;
-	return 0;
-}
-
-static void
-group_commit_event_sched_in(struct perf_event *group_event,
-	       struct perf_cpu_context *cpuctx,
-	       struct perf_event_context *ctx)
-{
-	struct perf_event *event;
-	u64 now = ctx->time;
-
-	group_event->tstamp_running += now - group_event->tstamp_stopped;
-	/*
-	 * Schedule in siblings as one group (if any):
-	 */
-	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
-		event->tstamp_running += now - event->tstamp_stopped;
-	}
-}
-
 static int
 group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
@@ -730,19 +693,15 @@ group_sched_in(struct perf_event *group_event,
 {
 	struct perf_event *event, *partial_group = NULL;
 	struct pmu *pmu = group_event->pmu;
+	bool simulate = false;
+	u64 now = ctx->time;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
 
 	pmu->start_txn(pmu);
 
-	/*
-	 * use __event_sched_in() to delay updating tstamp_running
-	 * until the transaction is committed. In case of failure
-	 * we will keep an unmodified tstamp_running which is a
-	 * requirement to get correct timing information
-	 */
-	if (__event_sched_in(group_event, cpuctx, ctx)) {
+	if (event_sched_in(group_event, cpuctx, ctx)) {
 		pmu->cancel_txn(pmu);
 		return -EAGAIN;
 	}
@@ -751,31 +710,43 @@ group_sched_in(struct perf_event *group_event,
 	 * Schedule in siblings as one group (if any):
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
-		if (__event_sched_in(event, cpuctx, ctx)) {
+		if (event_sched_in(event, cpuctx, ctx)) {
 			partial_group = event;
 			goto group_error;
 		}
 	}
 
-	if (!pmu->commit_txn(pmu)) {
-		/* commit tstamp_running */
-		group_commit_event_sched_in(group_event, cpuctx, ctx);
+	if (!pmu->commit_txn(pmu))
 		return 0;
-	}
 group_error:
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
 	 *
-	 * use __event_sched_out() to avoid updating tstamp_stopped
-	 * because the event never actually ran
+	 * The events up to the failed event are scheduled out normally,
+	 * tstamp_stopped will be updated.
+	 *
+	 * The failed events and the remaining siblings need to have
+	 * their timings updated as if they had gone thru event_sched_in()
+	 * and event_sched_out(). This is required to get consistent timings
+	 * across the group. This also takes care of the case where the group
+	 * could never be scheduled by ensuring tstamp_stopped is set to mark
+	 * the time the event was actually stopped, such that time delta
+	 * calculation in update_event_times() is correct.
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
+
 		if (event == partial_group)
-			break;
-		__event_sched_out(event, cpuctx, ctx);
+			simulate = true;
+
+		if (simulate) {
+			event->tstamp_running += now - event->tstamp_stopped;
+			event->tstamp_stopped = now;
+		} else {
+			event_sched_out(event, cpuctx, ctx);
+		}
 	}
-	__event_sched_out(group_event, cpuctx, ctx);
+	event_sched_out(group_event, cpuctx, ctx);
 
 	pmu->cancel_txn(pmu);
 
