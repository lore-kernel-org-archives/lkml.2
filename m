Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1ACRVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:21:34 -0500
Received: from smtp-out.google.com ([74.125.121.67]:8755 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab1ACRVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:21:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=ZBrEXCdPa/h2bkoQodRlyOAGG7sPpI+7IjThjCo35LhULKr+zrUeB9h5UkVypWycPq
         GI7cPe2otOoWgEmrqCOQ==
Message-ID: <4d220593.2308e30a.48c5.ffff8ae9@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 3 Jan 2011 18:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com,
        lizf@cn.fujitsu.com
Subject: [PATCH 2/5] perf_events: generalize use of event_filter_match() (v7)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all occurrences of:
	event->cpu != -1 && event->cpu == smp_processor_id()
by a call to:
	event_filter_match(event)

This makes the code more consistent and will make the cgroup
patch smaller.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2c14e3a..dcdb19e 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -949,7 +949,7 @@ static void __perf_install_in_context(void *info)
 
 	add_event_to_ctx(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		goto unlock;
 
 	/*
@@ -1094,7 +1094,7 @@ static void __perf_event_enable(void *info)
 		goto unlock;
 	__perf_event_mark_enabled(event, ctx);
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		goto unlock;
 
 	/*
@@ -1441,7 +1441,7 @@ ctx_pinned_sched_in(struct perf_event_context *ctx,
 	list_for_each_entry(event, &ctx->pinned_groups, group_entry) {
 		if (event->state <= PERF_EVENT_STATE_OFF)
 			continue;
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, 1))
@@ -1473,7 +1473,7 @@ ctx_flexible_sched_in(struct perf_event_context *ctx,
 		 * Listen to the 'cpu' scheduling filter constraint
 		 * of events:
 		 */
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		if (group_can_go_on(event, cpuctx, can_add_hw)) {
@@ -1700,7 +1700,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
 
-		if (event->cpu != -1 && event->cpu != smp_processor_id())
+		if (!event_filter_match(event))
 			continue;
 
 		hwc = &event->hw;
@@ -3899,7 +3899,7 @@ static int perf_event_task_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if (event->attr.comm || event->attr.mmap ||
@@ -4036,7 +4036,7 @@ static int perf_event_comm_match(struct perf_event *event)
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if (event->attr.comm)
@@ -4184,7 +4184,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return 0;
 
-	if (event->cpu != -1 && event->cpu != smp_processor_id())
+	if (!event_filter_match(event))
 		return 0;
 
 	if ((!executable && event->attr.mmap_data) ||
