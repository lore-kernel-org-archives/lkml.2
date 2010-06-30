Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0F3DHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 23:07:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44326 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0F3DHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 23:07:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] tracing: shrink max latency ringbuffer if unnecessary
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100630120419.391D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 12:06:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/trace/ftrace.txt says

  buffer_size_kb:

        This sets or displays the number of kilobytes each CPU
        buffer can hold. The tracer buffers are the same size
        for each CPU. The displayed number is the size of the
        CPU buffer and not total size of all buffers. The
        trace buffers are allocated in pages (blocks of memory
        that the kernel uses for allocation, usually 4 KB in size).
        If the last page allocated has room for more bytes
        than requested, the rest of the page will be used,
        making the actual allocation bigger than requested.
        ( Note, the size may not be a multiple of the page size
          due to buffer management overhead. )

        This can only be updated when the current_tracer
        is set to "nop".

But it's incorrect. currently total memory consumption is
'buffer_size_kb x CPUs x 2'.

Why two times difference is there? because ftrace implicitly allocate
the buffer for max latency too.

That makes sad result when admin want to use large buffer. (If admin
want full logging and makes detail analysis). example, If admin
have 24 CPUs machine and write 200MB to buffer_size_kb, the system
consume ~10GB memory (200MB x 24 x 2). umm.. 5GB memory waste is
usually unacceptable.

Fortunatelly, almost all users don't use max latency feature.
The max latency buffer can be disabled easily.

This patch shrink buffer size of the max latency buffer if
unnecessary.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/trace/trace.c              |   22 +++++++++++++---------
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |    9 +++++++++
 kernel/trace/trace_sched_wakeup.c |    9 +++++++++
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8683dec..ab2c061 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2782,7 +2782,7 @@ int tracer_init(struct tracer *t, struct trace_array *tr)
 	return t->init(tr);
 }
 
-static int tracing_resize_ring_buffer(unsigned long size)
+int tracing_resize_ring_buffer(unsigned long size, int need_max_tr)
 {
 	int ret;
 
@@ -2797,6 +2797,11 @@ static int tracing_resize_ring_buffer(unsigned long size)
 	if (ret < 0)
 		return ret;
 
+	if (!need_max_tr) {
+		ring_buffer_resize(max_tr.buffer, 1);
+		goto out;
+	}
+
 	ret = ring_buffer_resize(max_tr.buffer, size);
 	if (ret < 0) {
 		int r;
@@ -2824,7 +2829,9 @@ static int tracing_resize_ring_buffer(unsigned long size)
 		return ret;
 	}
 
+ out:
 	global_trace.entries = size;
+	max_tr.entries = need_max_tr ? size : 1;
 
 	return ret;
 }
@@ -2845,7 +2852,7 @@ int tracing_update_buffers(void)
 
 	mutex_lock(&trace_types_lock);
 	if (!ring_buffer_expanded)
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = tracing_resize_ring_buffer(trace_buf_size, 0);
 	mutex_unlock(&trace_types_lock);
 
 	return ret;
@@ -2869,7 +2876,7 @@ static int tracing_set_tracer(const char *buf)
 	mutex_lock(&trace_types_lock);
 
 	if (!ring_buffer_expanded) {
-		ret = tracing_resize_ring_buffer(trace_buf_size);
+		ret = tracing_resize_ring_buffer(trace_buf_size, 0);
 		if (ret < 0)
 			goto out;
 		ret = 0;
@@ -3455,7 +3462,7 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	val <<= 10;
 
 	if (val != global_trace.entries) {
-		ret = tracing_resize_ring_buffer(val);
+		ret = tracing_resize_ring_buffer(val, max_tr.entries!=1);
 		if (ret < 0) {
 			cnt = ret;
 			goto out;
@@ -3476,7 +3483,6 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	}
 
 	tracing_start();
-	max_tr.entries = global_trace.entries;
 	mutex_unlock(&trace_types_lock);
 
 	return cnt;
@@ -4574,16 +4580,14 @@ __init static int tracer_alloc_buffers(void)
 
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	max_tr.buffer = ring_buffer_alloc(ring_buf_size,
-					     TRACE_BUFFER_FLAGS);
+	max_tr.buffer = ring_buffer_alloc(1, TRACE_BUFFER_FLAGS);
 	if (!max_tr.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
 		ring_buffer_free(global_trace.buffer);
 		goto out_free_cpumask;
 	}
-	max_tr.entries = ring_buffer_size(max_tr.buffer);
-	WARN_ON(max_tr.entries != global_trace.entries);
+	max_tr.entries = 1;
 #endif
 
 	/* Allocate the first page for all buffers */
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 01ce088..78309e2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -284,6 +284,7 @@ struct tracer {
 #define TRACE_PIPE_ALL_CPU	-1
 
 int tracer_init(struct tracer *t, struct trace_array *tr);
+int tracing_resize_ring_buffer(unsigned long size, int need_max_tr);
 int tracing_is_enabled(void);
 void trace_wake_up(void);
 void tracing_reset(struct trace_array *tr, int cpu);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 6fd486e..a3668ca 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -612,6 +612,9 @@ static void irqsoff_tracer_reset(struct trace_array *tr)
 
 	if (!save_lat_flag)
 		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+
+	/* shrink max_tr buffer */
+	tracing_resize_ring_buffer(tr->entries, 0);
 }
 
 static void irqsoff_tracer_start(struct trace_array *tr)
@@ -692,6 +695,12 @@ static struct tracer preemptoff_tracer __read_mostly =
 
 static int preemptirqsoff_tracer_init(struct trace_array *tr)
 {
+	int ret;
+
+	ret = tracing_resize_ring_buffer(tr->entries, 1);
+	if (ret <0)
+		return ret;
+
 	trace_type = TRACER_IRQS_OFF | TRACER_PREEMPT_OFF;
 
 	__irqsoff_tracer_init(tr);
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index c9fd5bd..c8f0d1d 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -329,6 +329,12 @@ static void stop_wakeup_tracer(struct trace_array *tr)
 
 static int __wakeup_tracer_init(struct trace_array *tr)
 {
+	int ret;
+
+	ret = tracing_resize_ring_buffer(tr->entries, 1);
+	if (ret <0)
+		return ret;
+
 	save_lat_flag = trace_flags & TRACE_ITER_LATENCY_FMT;
 	trace_flags |= TRACE_ITER_LATENCY_FMT;
 
@@ -358,6 +364,9 @@ static void wakeup_tracer_reset(struct trace_array *tr)
 
 	if (!save_lat_flag)
 		trace_flags &= ~TRACE_ITER_LATENCY_FMT;
+
+	/* shrink max_tr buffer */
+	tracing_resize_ring_buffer(tr->entries, 0);
 }
 
 static void wakeup_tracer_start(struct trace_array *tr)
-- 
1.6.5.2



