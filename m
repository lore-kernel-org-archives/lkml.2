Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0GAFem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:34:42 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33867 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab0GAFel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:34:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: rostedt@goodmis.org
Subject: [PATCH v2] tracing: shrink max latency ringbuffer if unnecessary
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1277948436.25782.5.camel@gandalf.stny.rr.com>
References: <20100630120419.391D.A69D9226@jp.fujitsu.com> <1277948436.25782.5.camel@gandalf.stny.rr.com>
Message-Id: <20100701104554.DA2D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  1 Jul 2010 14:34:35 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Kosaki,
> 
> FYI, could you send emails to my goodmis account. I can easily miss
> emails sent to my RH account since it is usually flooded with RH
> Bugzilla reports.

Ahh sorry. yes, I had hear the same thing. I did forgot it.
I've fixed my adress book ;)

> 
> (more below)
> 
> On Wed, 2010-06-30 at 12:06 +0900, KOSAKI Motohiro wrote:
> > Documentation/trace/ftrace.txt says
> > 
> >   buffer_size_kb:
> > 
> >         This sets or displays the number of kilobytes each CPU
> >         buffer can hold. The tracer buffers are the same size
> >         for each CPU. The displayed number is the size of the
> >         CPU buffer and not total size of all buffers. The
> >         trace buffers are allocated in pages (blocks of memory
> >         that the kernel uses for allocation, usually 4 KB in size).
> >         If the last page allocated has room for more bytes
> >         than requested, the rest of the page will be used,
> >         making the actual allocation bigger than requested.
> >         ( Note, the size may not be a multiple of the page size
> >           due to buffer management overhead. )
> > 
> >         This can only be updated when the current_tracer
> >         is set to "nop".
> > 
> > But it's incorrect. currently total memory consumption is
> > 'buffer_size_kb x CPUs x 2'.
> > 
> > Why two times difference is there? because ftrace implicitly allocate
> > the buffer for max latency too.
> > 
> > That makes sad result when admin want to use large buffer. (If admin
> > want full logging and makes detail analysis). example, If admin
> > have 24 CPUs machine and write 200MB to buffer_size_kb, the system
> > consume ~10GB memory (200MB x 24 x 2). umm.. 5GB memory waste is
> > usually unacceptable.
> > 
> > Fortunatelly, almost all users don't use max latency feature.
> > The max latency buffer can be disabled easily.
> > 
> > This patch shrink buffer size of the max latency buffer if
> > unnecessary.
> 
> Actually, what would be better is to add a "use_max_tr" field to the
> struct tracer in trace.h.  Then the latency tracers (irqsoff,
> preemptoff, preemptirqsoff, wakeup, and wakeup_rt) can have this field
> set.

Ah, Cool!


> 
> Then, we can resize or even remove the max ring buffer when the
> "use_max_tr" is not set (and on bootup). On enabling a latency tracer,
> we can allocate the buffer. When we enable another tracer (or nop) if
> the use_max_tr is not set, then we can remove the buffer.
> 
> Would you be able to do something like that?


How about this? 



>From d17bef4652a00c124940cb8c28ff7fcf584c9008 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 1 Jul 2010 13:06:57 +0900
Subject: [PATCH 1/2] tracing: shrink max latency ringbuffer if unnecessary

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
 kernel/trace/trace.c              |   39 ++++++++++++++++++++++++++++++------
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |    3 ++
 kernel/trace/trace_sched_wakeup.c |    2 +
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8683dec..9027f98 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -659,6 +659,10 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
+	if (!current_trace->use_max_tr) {
+		WARN_ON_ONCE(1);
+		return;
+	}
 	arch_spin_lock(&ftrace_max_lock);
 
 	tr->buffer = max_tr.buffer;
@@ -685,6 +689,11 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 		return;
 
 	WARN_ON_ONCE(!irqs_disabled());
+	if (!current_trace->use_max_tr) {
+		WARN_ON_ONCE(1);
+		return;
+	}
+
 	arch_spin_lock(&ftrace_max_lock);
 
 	ftrace_disable_cpu();
@@ -2797,6 +2806,9 @@ static int tracing_resize_ring_buffer(unsigned long size)
 	if (ret < 0)
 		return ret;
 
+	if (!current_trace->use_max_tr)
+		goto out;
+
 	ret = ring_buffer_resize(max_tr.buffer, size);
 	if (ret < 0) {
 		int r;
@@ -2824,11 +2836,14 @@ static int tracing_resize_ring_buffer(unsigned long size)
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
@@ -2889,12 +2904,26 @@ static int tracing_set_tracer(const char *buf)
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
@@ -3476,7 +3505,6 @@ tracing_entries_write(struct file *filp, const char __user *ubuf,
 	}
 
 	tracing_start();
-	max_tr.entries = global_trace.entries;
 	mutex_unlock(&trace_types_lock);
 
 	return cnt;
@@ -4572,18 +4600,15 @@ __init static int tracer_alloc_buffers(void)
 	}
 	global_trace.entries = ring_buffer_size(global_trace.buffer);
 
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
index 01ce088..7f67247 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -278,6 +278,7 @@ struct tracer {
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
1.6.5.2



