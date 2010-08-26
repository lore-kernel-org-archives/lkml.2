Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0HZOym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:54:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12593 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab0HZOyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:54:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=OL5WBojAp+zEke82sku3ABYU/e3cKeYkNnAYdfclPeKty/uChlLK+7AfoDXxtrjVh
	7+d214W9fNHvnn3vZRT8g==
Message-ID: <4c76802d.aae9d80a.115d.70fe@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 26 Aug 2010 16:40:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com
Subject: [PATCH] perf_events: fixing time tracking for event with pid != -1 and cpu != -1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-thread events with a cpu filter, i.e., cpu != -1, were not reporting
correct timings when the thread never ran on the monitored cpu. The time
enabled was reported as a negative value.

This patch fixes the problem by updating tstamp_stopped, tstamp_running
in event_sched_out() for events with filters and which are marked as
INACTIVE.

The function group_sched_out() is modified to systematically call into
event_sched_out() to avoid duplicating the timing adjustment code twice.

With the patch, I now get:

$ task_cpu -i -e unhalted_core_cycles,unhalted_core_cycles noploop 2
noploop for 2 seconds
CPU0 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)
CPU0 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)

CPU1 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)
CPU1 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)

CPU2 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)
CPU2 0		   unhalted_core_cycles (ena=1,991,136,594, run=0)

CPU3 4,747,990,931 unhalted_core_cycles (ena=1,991,136,594, run=1,991,136,594)
CPU3 4,747,990,931 unhalted_core_cycles (ena=1,991,136,594, run=1,991,136,594)

Signed-off-by: Stephane Eranian <eranian@gmail.com>

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 0d38f27..d196412 100644
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
+	 * an event which could not be activated because of
+	 * filter mismatch still needs to have its timings
+	 * maintained, otherwise bogus information is return
+	 * via read() for time_enabled, time_running
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
 
