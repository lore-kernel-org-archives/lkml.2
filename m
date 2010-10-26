Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab0JZOKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:10:25 -0400
Received: from smtp-out.google.com ([74.125.121.35]:24297 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0JZOKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:10:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=f7vCo/4eqD2MQZp7p8ARk1aqZ2/4L6TXCkNJOg6Z5sLEIjEM05weQg9hrN6mGg51zD
         i4hJm4KJIVLDHTJCr7SA==
Message-ID: <4cc6e14b.1e07e30a.256e.5190@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 26 Oct 2010 16:08:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH] perf_events: fix time tracking in samples (v2)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects time tracking in samples. Without this patch
both time_enabled and time_running are bogus when user asks for
PERF_SAMPLE_READ.

One uses PERF_SAMPLE_READ to sample the values of other counters
in each sample. Because of multiplexing, it is necessary to know
both time_enabled, time_running to be able to scale counts correctly.

In this second version of the patch, we maintain a shadow
copy of ctx->time which allows us to compute ctx->time without
calling update_context_time() from NMI context. We avoid the
issue that update_context_time() must always be called with
ctx->lock held.

We do not keep shadow copies of the other event timings
because if the lead event is overflowing then it is active
and thus it's been scheduled in via event_sched_in() in
which case neither tstamp_stopped, tstamp_running can be modified.

This timing logic only applies to samples when PERF_SAMPLE_READ
is used.

Note that this patch does not address timing issues related
to sampling inheritance between tasks. This will be addressed
in a future patch.

With this patch, the libpfm4 example task_smpl now reports
correct counts (shown on 2.4GHz Core 2):

$ task_smpl -p 2400000000 -e unhalted_core_cycles:u,instructions_retired:u,baclears  noploop 5
noploop for 5 seconds
IIP:0x000000004006d6 PID:5596 TID:5596 TIME:466,210,211,430 STREAM_ID:33 PERIOD:2,400,000,000 ENA=1,010,157,814 RUN=1,010,157,814 NR=3
	2,400,000,254 unhalted_core_cycles:u (33)
	2,399,273,744 instructions_retired:u (34)
	53,340 baclears (35)

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..40150f3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -747,6 +747,16 @@ struct perf_event {
 	u64				tstamp_running;
 	u64				tstamp_stopped;
 
+	/*
+	 * timestamp shadows the actual context timing but it can
+	 * be safely used in NMI interrupt context. It reflects the
+	 * context time as it was when the event was last scheduled in.
+	 *
+	 * ctx_time already accounts for ctx->timestamp. Therefore to
+	 * compute ctx_time for a sample, simply add perf_clock().
+	 */
+	u64				shadow_ctx_time;
+
 	struct perf_event_attr		attr;
 	struct hw_perf_event		hw;
 
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 517d827..cb6c0d2 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -674,6 +674,8 @@ event_sched_in(struct perf_event *event,
 
 	event->tstamp_running += ctx->time - event->tstamp_stopped;
 
+	event->shadow_ctx_time = ctx->time - ctx->timestamp;
+
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
@@ -3396,7 +3398,8 @@ static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
 }
 
 static void perf_output_read_one(struct perf_output_handle *handle,
-				 struct perf_event *event)
+				 struct perf_event *event,
+				 u64 enabled, u64 running)
 {
 	u64 read_format = event->attr.read_format;
 	u64 values[4];
@@ -3404,11 +3407,11 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 
 	values[n++] = perf_event_count(event);
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
-		values[n++] = event->total_time_enabled +
+		values[n++] = enabled +
 			atomic64_read(&event->child_total_time_enabled);
 	}
 	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
-		values[n++] = event->total_time_running +
+		values[n++] = running +
 			atomic64_read(&event->child_total_time_running);
 	}
 	if (read_format & PERF_FORMAT_ID)
@@ -3421,7 +3424,8 @@ static void perf_output_read_one(struct perf_output_handle *handle,
  * XXX PERF_FORMAT_GROUP vs inherited events seems difficult.
  */
 static void perf_output_read_group(struct perf_output_handle *handle,
-			    struct perf_event *event)
+			    struct perf_event *event,
+			    u64 enabled, u64 running)
 {
 	struct perf_event *leader = event->group_leader, *sub;
 	u64 read_format = event->attr.read_format;
@@ -3431,10 +3435,10 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	values[n++] = 1 + leader->nr_siblings;
 
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
-		values[n++] = leader->total_time_enabled;
+		values[n++] = enabled;
 
 	if (read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
-		values[n++] = leader->total_time_running;
+		values[n++] = running;
 
 	if (leader != event)
 		leader->pmu->read(leader);
@@ -3459,13 +3463,35 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	}
 }
 
+#define PERF_FORMAT_TOTAL_TIMES (PERF_FORMAT_TOTAL_TIME_ENABLED|\
+				 PERF_FORMAT_TOTAL_TIME_RUNNING)
+
 static void perf_output_read(struct perf_output_handle *handle,
 			     struct perf_event *event)
 {
+	u64 enabled = 0, running = 0, now, ctx_time;
+	u64 read_format = event->attr.read_format;
+
+	/*
+	 * compute total_time_enabled, total_time_running
+	 * based on snapshot values taken when the event
+	 * was last scheduled in.
+	 *
+	 * we cannot simply called update_context_time()
+	 * because of locking issue as we are called in
+	 * NMI context
+	 */
+	if (read_format & PERF_FORMAT_TOTAL_TIMES) {
+		now = perf_clock();
+		ctx_time = event->shadow_ctx_time + now;
+		enabled = ctx_time - event->tstamp_enabled;
+		running = ctx_time - event->tstamp_running;
+	}
+
 	if (event->attr.read_format & PERF_FORMAT_GROUP)
-		perf_output_read_group(handle, event);
+		perf_output_read_group(handle, event, enabled, running);
 	else
-		perf_output_read_one(handle, event);
+		perf_output_read_one(handle, event, enabled, running);
 }
 
 void perf_output_sample(struct perf_output_handle *handle,
