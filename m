Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0JOOzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:55:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0JOOzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=OHBxMwNepgTgdmhjS34cKKWOR7KVp4zSUJvkeAWrBuIc1mmSTNOfmO8fAgsnTS1YJW
         zrddE8ypWwFXXN7OESxA==
Message-ID: <4cb86b4c.41e9d80a.44e9.3e19@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Fri, 15 Oct 2010 16:54:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix transaction recovery in group_sched_in()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The group_sched_in() function uses a transactional approach to schedule
a group of events. In a group, either all events can be scheduled or
none are. To schedule each event in, the function calls event_sched_in().
In case of error, event_sched_out() is called on each event in the group.

The problem is that event_sched_out() does not completely cancel the
effects of event_sched_in(). Furthermore event_sched_out() changes the
state of the event as if it had run which is not true is this particular
case.

Those inconsistencies impact time tracking fields and may lead to events
in a group not all reporting the same time_enabled and time_running values.
This is demonstrated with the example below:

$ task -eunhalted_core_cycles,baclears,baclears -e unhalted_core_cycles,baclears,baclears sleep 5
1946101 unhalted_core_cycles (32.85% scaling, ena=829181, run=556827)
  11423 baclears (32.85% scaling, ena=829181, run=556827)
   7671 baclears (0.00% scaling, ena=556827, run=556827)

2250443 unhalted_core_cycles (57.83% scaling, ena=962822, run=405995)
  11705 baclears (57.83% scaling, ena=962822, run=405995)
  11705 baclears (57.83% scaling, ena=962822, run=405995)

Notice that in the first group, the last baclears event does not
report the same timings as its siblings.

This issue comes from the fact that tstamp_stopped is updated
by event_sched_out() as if the event had actually run.

To solve the issue, we must ensure that, in case of error, there is
no change in the event state whatsoever. That means timings must
remain as they were when entering group_sched_in().

To do this we defer updating tstamp_running until we know the
transaction succeeded. Therefore, we have split event_sched_in()
in two parts separating the update to tstamp_running.

Similarly, in case of error, we do not want to update tstamp_stopped.
Therefore, we have split event_sched_out() in two parts separating
the update to tstamp_stopped. 

With this patch, we now get the following output:

$ task -eunhalted_core_cycles,baclears,baclears -e unhalted_core_cycles,baclears,baclears sleep 5
2492050 unhalted_core_cycles (71.75% scaling, ena=1093330, run=308841)
  11243 baclears (71.75% scaling, ena=1093330, run=308841)
  11243 baclears (71.75% scaling, ena=1093330, run=308841)

1852746 unhalted_core_cycles (0.00% scaling, ena=784489, run=784489)
   9253 baclears (0.00% scaling, ena=784489, run=784489)
   9253 baclears (0.00% scaling, ena=784489, run=784489)

Note that the uneven timing between groups is a side effect of
the process spending most of its time sleeping, i.e., not enough
event rotations (but that's a separate issue).

Signed-off-by: Stephane Eranian <eranian@google.com>

---
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index b6fd9ec..62e583f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -407,8 +407,8 @@ event_filter_match(struct perf_event *event)
 	return event->cpu == -1 || event->cpu == smp_processor_id();
 }
 
-static void
-event_sched_out(struct perf_event *event,
+static int
+__event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
@@ -427,14 +427,13 @@ event_sched_out(struct perf_event *event,
 	}
 
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
-		return;
+		return 0;
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	if (event->pending_disable) {
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-	event->tstamp_stopped = ctx->time;
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
@@ -443,6 +442,19 @@ event_sched_out(struct perf_event *event,
 	ctx->nr_active--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
+	return 1;
+}
+
+static void
+event_sched_out(struct perf_event *event,
+		  struct perf_cpu_context *cpuctx,
+		  struct perf_event_context *ctx)
+{
+	int ret;
+
+	ret = __event_sched_out(event, cpuctx, ctx);
+	if (ret)
+		event->tstamp_stopped = ctx->time;
 }
 
 static void
@@ -642,7 +654,7 @@ retry:
 }
 
 static int
-event_sched_in(struct perf_event *event,
+__event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
 		 struct perf_event_context *ctx)
 {
@@ -662,8 +674,6 @@ event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
-	event->tstamp_running += ctx->time - event->tstamp_stopped;
-
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
@@ -674,6 +684,35 @@ event_sched_in(struct perf_event *event,
 	return 0;
 }
 
+static inline int
+event_sched_in(struct perf_event *event,
+		 struct perf_cpu_context *cpuctx,
+		 struct perf_event_context *ctx)
+{
+	int ret = __event_sched_in(event, cpuctx, ctx);
+	if (ret)
+		return ret;
+	event->tstamp_running += ctx->time - event->tstamp_stopped;
+	return 0;
+}
+
+static void
+group_commit_event_sched_in(struct perf_event *group_event,
+	       struct perf_cpu_context *cpuctx,
+	       struct perf_event_context *ctx)
+{
+	struct perf_event *event;
+	u64 now = ctx->time;
+
+	group_event->tstamp_running += now - group_event->tstamp_stopped;
+	/*
+	 * Schedule in siblings as one group (if any):
+	 */
+	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
+		event->tstamp_running += now - event->tstamp_stopped;
+	}
+}
+
 static int
 group_sched_in(struct perf_event *group_event,
 	       struct perf_cpu_context *cpuctx,
@@ -687,7 +726,13 @@ group_sched_in(struct perf_event *group_event,
 
 	pmu->start_txn(pmu);
 
-	if (event_sched_in(group_event, cpuctx, ctx)) {
+	/*
+	 * use __event_sched_in() to delay updating tstamp_running
+	 * until the transaction is committed. In case of failure
+	 * we will keep an unmodified tstamp_running which is a
+	 * requirement to get correct timing information
+	 */
+	if (__event_sched_in(group_event, cpuctx, ctx)) {
 		pmu->cancel_txn(pmu);
 		return -EAGAIN;
 	}
@@ -696,26 +741,31 @@ group_sched_in(struct perf_event *group_event,
 	 * Schedule in siblings as one group (if any):
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
-		if (event_sched_in(event, cpuctx, ctx)) {
+		if (__event_sched_in(event, cpuctx, ctx)) {
 			partial_group = event;
 			goto group_error;
 		}
 	}
 
-	if (!pmu->commit_txn(pmu))
+	if (!pmu->commit_txn(pmu)) {
+		/* commit tstamp_running */
+		group_commit_event_sched_in(group_event, cpuctx, ctx);
 		return 0;
-
+	}
 group_error:
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
+	 *
+	 * use __event_sched_out() to avoid updating tstamp_stopped
+	 * because the event never actually ran
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
 		if (event == partial_group)
 			break;
-		event_sched_out(event, cpuctx, ctx);
+		__event_sched_out(event, cpuctx, ctx);
 	}
-	event_sched_out(group_event, cpuctx, ctx);
+	__event_sched_out(group_event, cpuctx, ctx);
 
 	pmu->cancel_txn(pmu);
 
