Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1AGPdv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:33:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:40689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1AGPdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:33:49 -0500
Date: Fri, 7 Jan 2011 15:33:18 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4d22059c.122ae30a.5e0e.ffff8b8b@mx.google.com>
References: <4d22059c.122ae30a.5e0e.ffff8b8b@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_events: Add perf_event_time()
Message-ID: <tip-4158755d3136f4cb05c1a8a260e9c06f93baeb48@git.kernel.org>
Git-Commit-ID: 4158755d3136f4cb05c1a8a260e9c06f93baeb48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:33:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4158755d3136f4cb05c1a8a260e9c06f93baeb48
Gitweb:     http://git.kernel.org/tip/4158755d3136f4cb05c1a8a260e9c06f93baeb48
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 3 Jan 2011 18:20:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Jan 2011 15:08:51 +0100

perf_events: Add perf_event_time()

Adds perf_event_time() to try and centralize access to event
timing and in particular ctx->time. Prepares for cgroup support.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4d22059c.122ae30a.5e0e.ffff8b8b@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

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
 
