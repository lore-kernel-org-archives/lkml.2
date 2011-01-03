Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab1ACRVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:21:40 -0500
Received: from smtp-out.google.com ([74.125.121.67]:8803 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab1ACRVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=KIpOZuet2KK0XEl4czl/rZgULJDG5owrlVyK8jWgc6y3GoIfxacn5bjLc5LSVECaHX
         CFgwwD17CRSbfXbHj9Vw==
Message-ID: <4d22059c.122ae30a.5e0e.ffff8b8b@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 3 Jan 2011 18:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 3/5] perf_events: add perf_event_time() (v7)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds perf_event_time() to try and centralize access to event
timing and in particular ctx->time. Prepares for cgroup support.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index dcdb19e..b782b7a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -268,6 +268,12 @@ static void update_context_time(struct perf_event_context *ctx)
 	ctx->timestamp = now;
 }
 
+static u64 perf_event_time(struct perf_event *event)
+{
+	struct perf_event_context *ctx = event->ctx;
+	return ctx ? ctx->time : 0;
+}
+
 /*
  * Update the total_time_enabled and total_time_running fields for a event.
  */
@@ -281,7 +287,7 @@ static void update_event_times(struct perf_event *event)
 		return;
 
 	if (ctx->is_active)
-		run_end = ctx->time;
+		run_end = perf_event_time(event);
 	else
 		run_end = event->tstamp_stopped;
 
@@ -290,7 +296,7 @@ static void update_event_times(struct perf_event *event)
 	if (event->state == PERF_EVENT_STATE_INACTIVE)
 		run_end = event->tstamp_stopped;
 	else
-		run_end = ctx->time;
+		run_end = perf_event_time(event);
 
 	event->total_time_running = run_end - event->tstamp_running;
 }
@@ -546,6 +552,7 @@ event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
 		  struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
 	u64 delta;
 	/*
 	 * An event which could not be activated because of
@@ -557,7 +564,7 @@ event_sched_out(struct perf_event *event,
 	    && !event_filter_match(event)) {
 		delta = ctx->time - event->tstamp_stopped;
 		event->tstamp_running += delta;
-		event->tstamp_stopped = ctx->time;
+		event->tstamp_stopped = tstamp;
 	}
 
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -568,7 +575,7 @@ event_sched_out(struct perf_event *event,
 		event->pending_disable = 0;
 		event->state = PERF_EVENT_STATE_OFF;
 	}
-	event->tstamp_stopped = ctx->time;
+	event->tstamp_stopped = tstamp;
 	event->pmu->del(event, 0);
 	event->oncpu = -1;
 
@@ -780,6 +787,8 @@ event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
 		 struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
+
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
 
@@ -796,9 +805,9 @@ event_sched_in(struct perf_event *event,
 		return -EAGAIN;
 	}
 
-	event->tstamp_running += ctx->time - event->tstamp_stopped;
+	event->tstamp_running += tstamp - event->tstamp_stopped;
 
-	event->shadow_ctx_time = ctx->time - ctx->timestamp;
+	event->shadow_ctx_time = tstamp - ctx->timestamp;
 
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
@@ -910,11 +919,13 @@ static int group_can_go_on(struct perf_event *event,
 static void add_event_to_ctx(struct perf_event *event,
 			       struct perf_event_context *ctx)
 {
+	u64 tstamp = perf_event_time(event);
+
 	list_add_event(event, ctx);
 	perf_group_attach(event);
-	event->tstamp_enabled = ctx->time;
-	event->tstamp_running = ctx->time;
-	event->tstamp_stopped = ctx->time;
+	event->tstamp_enabled = tstamp;
+	event->tstamp_running = tstamp;
+	event->tstamp_stopped = tstamp;
 }
 
 /*
@@ -1054,14 +1065,13 @@ static void __perf_event_mark_enabled(struct perf_event *event,
 					struct perf_event_context *ctx)
 {
 	struct perf_event *sub;
+	u64 tstamp = perf_event_time(event);
 
 	event->state = PERF_EVENT_STATE_INACTIVE;
-	event->tstamp_enabled = ctx->time - event->total_time_enabled;
+	event->tstamp_enabled = tstamp - event->total_time_enabled;
 	list_for_each_entry(sub, &event->sibling_list, group_entry) {
-		if (sub->state >= PERF_EVENT_STATE_INACTIVE) {
-			sub->tstamp_enabled =
-				ctx->time - sub->total_time_enabled;
-		}
+		if (sub->state >= PERF_EVENT_STATE_INACTIVE)
+			sub->tstamp_enabled = tstamp - sub->total_time_enabled;
 	}
 }
 
