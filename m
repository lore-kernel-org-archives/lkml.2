Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab0GVU0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:26:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab0GVUYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:24:55 -0400
X-Authority-Analysis: v=1.1 cv=nxp4sGnGskpld68D65f6QeagdS7Y+3TTkvBhhEd/T4I= c=1 sm=0 a=ybbhsP_MqwIA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=omOdbC7AAAAA:8 a=meVymXHHAAAA:8 a=QrFd70mTdKO-YOatBroA:9 a=9NC1xKUsKFtdy1uUFgAA:7 a=FtcidkBDUR-oc_yr7opqb6YvV60A:4 a=jeBq3FmKZ4MA:10 a=AWeKdIrdlVU68RQp:21 a=aNmT37IuhKJoTbDU:21 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100722202453.027894028@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Jul 2010 16:24:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/7] tracing: Shrink max latency ringbuffer if unnecessary
References: <20100722202411.920807480@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-Shrink-max-latency-ringbuffer-if-unnecessary.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

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
LKML-Reference: <20100701104554.DA2D.A69D9226@jp.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |   38 +++++++++++++++++++++++++++++++-----
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |    3 ++
 kernel/trace/trace_sched_wakeup.c |    2 +
 4 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index af90429..f7488f4 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -660,6 +660,10 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
+	if (!current_trace->use_max_tr) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 	arch_spin_lock(&ftrace_max_lock);
 
 	tr->buffer = max_tr.buffer;
@@ -686,6 +690,11 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
+	if (!current_trace->use_max_tr) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	arch_spin_lock(&ftrace_max_lock);
 
 	ftrace_disable_cpu();
@@ -2801,6 +2810,9 @@ static int tracing_resize_ring_buffer(unsigned long size)
 	if (ret < 0)
 		return ret;
 
+	if (!current_trace->use_max_tr)
+		goto out;
+
 	ret = ring_buffer_resize(max_tr.buffer, size);
 	if (ret < 0) {
 		int r;
@@ -2828,11 +2840,14 @@ static int tracing_resize_ring_buffer(unsigned long size)
 		return ret;
 	}
 
+	max_tr.entries = size;
+ out:
 	global_trace.entries = size;
 
 	return ret;
 }
 
+
 /**
  * tracing_update_buffers - used by tracing facility to expand ring buffers
  *
@@ -2893,12 +2908,26 @@ static int tracing_set_tracer(const char *buf)
 	trace_branch_disable();
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
-
+	if (current_trace && current_trace->use_max_tr) {
+		/*
+		 * We don't free the ring buffer. instead, resize it because
+		 * The max_tr ring buffer has some state (e.g. ring->clock) and
+		 * we want preserve it.
+		 */
+		ring_buffer_resize(max_tr.buffer, 1);
+		max_tr.entries = 1;
+	}
 	destroy_trace_option_files(topts);
 
 	current_trace = t;
 
 	topts = create_trace_option_files(current_trace);
+	if (current_trace->use_max_tr) {
+		ret = ring_buffer_resize(max_tr.buffer, global_trace.entries);
+		if (ret < 0)
+			goto out;
+		max_tr.entries = global_trace.entries;
+	}
 
 	if (t->init) {
 		ret = tracer_init(t, tr);
@@ -3480,7 +3509,6 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	}
 
 	tracing_start();
-	max_tr.entries = global_trace.entries;
 	mutex_unlock(&trace_types_lock);
 
 	return cnt;
@@ -4578,16 +4606,14 @@ __init static int tracer_alloc_buffers(void)
 
 
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
index 7778f06..cb629b3 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -276,6 +276,7 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags	*flags;
+	int			use_max_tr;
 };
 
 
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 6fd486e..73a6b06 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -649,6 +649,7 @@ static struct tracer irqsoff_tracer __read_mostly =
 #endif
 	.open           = irqsoff_trace_open,
 	.close          = irqsoff_trace_close,
+	.use_max_tr	= 1,
 };
 # define register_irqsoff(trace) register_tracer(&trace)
 #else
@@ -681,6 +682,7 @@ static struct tracer preemptoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
+	.use_max_tr	= 1,
 };
 # define register_preemptoff(trace) register_tracer(&trace)
 #else
@@ -715,6 +717,7 @@ static struct tracer preemptirqsoff_tracer __read_mostly =
 #endif
 	.open		= irqsoff_trace_open,
 	.close		= irqsoff_trace_close,
+	.use_max_tr	= 1,
 };
 
 # define register_preemptirqsoff(trace) register_tracer(&trace)
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index c9fd5bd..4086eae 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -382,6 +382,7 @@ static struct tracer wakeup_tracer __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
+	.use_max_tr	= 1,
 };
 
 static struct tracer wakeup_rt_tracer __read_mostly =
@@ -396,6 +397,7 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
+	.use_max_tr	= 1,
 };
 
 __init static int init_wakeup_tracer(void)
-- 
1.7.1


