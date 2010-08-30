Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab0H3Pt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:49:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:44901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0H3Pt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:49:26 -0400
Date: Mon, 30 Aug 2010 15:48:46 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        eranian@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, eranian@gmail.com, mingo@elte.hu
In-Reply-To: <4c76802d.aae9d80a.115d.70fe@mx.google.com>
References: <4c76802d.aae9d80a.115d.70fe@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix time tracking for events with pid != -1 and cpu != -1
Message-ID: <tip-fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1@git.kernel.org>
Git-Commit-ID: fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 15:48:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1
Gitweb:     http://git.kernel.org/tip/fa66f07aa1f0950e1dc78b7ab39728b3f8aa77a1
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 26 Aug 2010 16:40:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 30 Aug 2010 12:16:55 +0200

perf_events: Fix time tracking for events with pid != -1 and cpu != -1

Per-thread events with a cpu filter, i.e., cpu != -1, were not
reporting correct timings when the thread never ran on the
monitored cpu. The time enabled was reported as a negative
value.

This patch fixes the problem by updating tstamp_stopped,
tstamp_running in event_sched_out() for events with filters and
which are marked as INACTIVE.

The function group_sched_out() is modified to systematically
call into event_sched_out() to avoid duplicating the timing
adjustment code twice.

With the patch, I now get:

$ task_cpu -i -e unhalted_core_cycles,unhalted_core_cycles
noploop 2 noploop for 2 seconds
CPU0 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)
CPU0 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)

CPU1 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)
CPU1 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)

CPU2 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)
CPU2 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)

CPU3 4,747,990,931 unhalted_core_cycles (ena=1,991,136,594, run=1,991,136,594)
CPU3 4,747,990,931 unhalted_core_cycles (ena=1,991,136,594, run=1,991,136,594)

Signed-off-by: Stephane Eranian <eranian@gmail.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus@samba.org
Cc: davem@davemloft.net
Cc: fweisbec@gmail.com
Cc: perfmon2-devel@lists.sf.net
Cc: eranian@google.com
LKML-Reference: <4c76802d.aae9d80a.115d.70fe@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 403d180..657555a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -402,11 +402,31 @@ static void perf_group_detach(struct perf_event *event)
 	}
 }
 
+static inline int
+event_filter_match(struct perf_event *event)
+{
+	return event->cpu == -1 || event->cpu == smp_processor_id();
+}
+
 static void
 event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
+	u64 delta;
+	/*
+	 * An event which could not be activated because of
+	 * filter mismatch still needs to have its timings
+	 * maintained, otherwise bogus information is return
+	 * via read() for time_enabled, time_running:
+	 */
+	if (event->state == PERF_EVENT_STATE_INACTIVE
+	    && !event_filter_match(event)) {
+		delta = ctx->time - event->tstamp_stopped;
+		event->tstamp_running += delta;
+		event->tstamp_stopped = ctx->time;
+	}
+
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
 		return;
 
@@ -432,9 +452,7 @@ group_sched_out(struct perf_event *group_event,
 		struct perf_event_context *ctx)
 {
 	struct perf_event *event;
-
-	if (group_event->state != PERF_EVENT_STATE_ACTIVE)
-		return;
+	int state = group_event->state;
 
 	event_sched_out(group_event, cpuctx, ctx);
 
@@ -444,7 +462,7 @@ group_sched_out(struct perf_event *group_event,
 	list_for_each_entry(event, &group_event->sibling_list, group_entry)
 		event_sched_out(event, cpuctx, ctx);
 
-	if (group_event->attr.exclusive)
+	if (state == PERF_EVENT_STATE_ACTIVE && group_event->attr.exclusive)
 		cpuctx->exclusive = 0;
 }
 
