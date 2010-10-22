Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804Ab0JVNFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:05:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:41825 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab0JVNFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:05:47 -0400
Date: Fri, 22 Oct 2010 13:05:15 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4cbeeeb7.0aefd80a.6e40.0e2f@mx.google.com>
References: <4cbeeeb7.0aefd80a.6e40.0e2f@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Revert: Fix transaction recovery in group_sched_in()
Message-ID: <tip-9ffcfa6f1f63eeac15555b745c292eb9f59130f6@git.kernel.org>
Git-Commit-ID: 9ffcfa6f1f63eeac15555b745c292eb9f59130f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:05:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ffcfa6f1f63eeac15555b745c292eb9f59130f6
Gitweb:     http://git.kernel.org/tip/9ffcfa6f1f63eeac15555b745c292eb9f59130f6
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 20 Oct 2010 15:25:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:27 +0200

perf_events: Revert: Fix transaction recovery in group_sched_in()

This patch reverts commit 8e5fc1a (perf_events: Fix transaction
recovery in group_sched_in()) because it had one flaw in case the
group could never be scheduled. It would cause time_enabled to get
negative.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4cbeeeb7.0aefd80a.6e40.0e2f@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   76 +++++++++------------------------------------------
 1 files changed, 13 insertions(+), 63 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f309e80..39afdb0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -417,8 +417,8 @@ event_filter_match(struct perf_event *event)
 	return event->cpu == -1 || event->cpu == smp_processor_id();
 }
 
-static int
-__event_sched_out(struct perf_event *event,
+static void
+event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
@@ -437,13 +437,14 @@ __event_sched_out(struct perf_event *event,
 	}
 
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
-		return 0;
+		return;
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
 	if (event->pending_disable) {
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
+	event->tstamp_stopped = ctx->time;
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
@@ -452,19 +453,6 @@ __event_sched_out(struct perf_event *event,
 	ctx->nr_active--;
 	if (event->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
-	return 1;
-}
-
-static void
-event_sched_out(struct perf_event *event,
-		  struct perf_cpu_context *cpuctx,
-		  struct perf_event_context *ctx)
-{
-	int ret;
-
-	ret = __event_sched_out(event, cpuctx, ctx);
-	if (ret)
-		event->tstamp_stopped = ctx->time;
 }
 
 static void
@@ -664,7 +652,7 @@ retry:
 }
 
 static int
-__event_sched_in(struct perf_event *event,
+event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
 		 struct perf_event_context *ctx)
 {
@@ -684,6 +672,8 @@ __event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
+	event->tstamp_running += ctx->time - event->tstamp_stopped;
+
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
@@ -694,35 +684,6 @@ __event_sched_in(struct perf_event *event,
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
@@ -736,13 +697,7 @@ group_sched_in(struct perf_event *group_event,
 
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
@@ -751,31 +706,26 @@ group_sched_in(struct perf_event *group_event,
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
+
 group_error:
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
-	 *
-	 * use __event_sched_out() to avoid updating tstamp_stopped
-	 * because the event never actually ran
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
 		if (event == partial_group)
 			break;
-		__event_sched_out(event, cpuctx, ctx);
+		event_sched_out(event, cpuctx, ctx);
 	}
-	__event_sched_out(group_event, cpuctx, ctx);
+	event_sched_out(group_event, cpuctx, ctx);
 
 	pmu->cancel_txn(pmu);
 
