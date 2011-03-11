Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab1CKJqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:46:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:45967 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1CKJqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:46:18 -0500
Date: Fri, 11 Mar 2011 09:45:53 GMT
From: tip-bot for David Sharp <dhsharp@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dhsharp@google.com, tglx@linutronix.de
In-Reply-To: <1291844807-15481-1-git-send-email-dhsharp@google.com>
References: <1291844807-15481-1-git-send-email-dhsharp@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Add an 'overwrite' trace_option.
Message-ID: <tip-750912fa366312e9c5bc83eab352898a26750401@git.kernel.org>
Git-Commit-ID: 750912fa366312e9c5bc83eab352898a26750401
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:45:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  750912fa366312e9c5bc83eab352898a26750401
Gitweb:     http://git.kernel.org/tip/750912fa366312e9c5bc83eab352898a26750401
Author:     David Sharp <dhsharp@google.com>
AuthorDate: Wed, 8 Dec 2010 13:46:47 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 9 Mar 2011 13:52:27 -0500

tracing: Add an 'overwrite' trace_option.

Add an "overwrite" trace_option for ftrace to control whether the buffer should
be overwritten on overflow or not. The default remains to overwrite old events
when the buffer is full. This patch adds the option to instead discard newest
events when the buffer is full. This is useful to get a snapshot of traces just
after enabling traces. Dropping the current event is also a simpler code path.

Signed-off-by: David Sharp <dhsharp@google.com>
LKML-Reference: <1291844807-15481-1-git-send-email-dhsharp@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 Documentation/trace/ftrace.txt |    5 +++++
 include/linux/ring_buffer.h    |    2 ++
 kernel/trace/ring_buffer.c     |   11 +++++++++++
 kernel/trace/trace.c           |   17 +++++++++++------
 kernel/trace/trace.h           |    1 +
 5 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 67f1cc4..1ebc24c 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -454,6 +454,11 @@ x494] <- /root/a.out[+0x4a8] <- /lib/libc-2.7.so[+0x1e1a6]
                    latencies, as described in "Latency
                    trace format".
 
+  overwrite - This controls what happens when the trace buffer is
+              full. If "1" (default), the oldest events are
+              discarded and overwritten. If "0", then the newest
+              events are discarded.
+
 ftrace_enabled
 --------------
 
diff --git a/include/linux/ring_buffer.h b/include/linux/ring_buffer.h
index 8d3a248..ab38ac8 100644
--- a/include/linux/ring_buffer.h
+++ b/include/linux/ring_buffer.h
@@ -100,6 +100,8 @@ void ring_buffer_free(struct ring_buffer *buffer);
 
 int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size);
 
+void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val);
+
 struct ring_buffer_event *ring_buffer_lock_reserve(struct ring_buffer *buffer,
 						   unsigned long length);
 int ring_buffer_unlock_commit(struct ring_buffer *buffer,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index bd1c35a..269db80 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1429,6 +1429,17 @@ int ring_buffer_resize(struct ring_buffer *buffer, unsigned long size)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_resize);
 
+void ring_buffer_change_overwrite(struct ring_buffer *buffer, int val)
+{
+	mutex_lock(&buffer->mutex);
+	if (val)
+		buffer->flags |= RB_FL_OVERWRITE;
+	else
+		buffer->flags &= ~RB_FL_OVERWRITE;
+	mutex_unlock(&buffer->mutex);
+}
+EXPORT_SYMBOL_GPL(ring_buffer_change_overwrite);
+
 static inline void *
 __rb_data_page_index(struct buffer_data_page *bpage, unsigned index)
 {
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8dc8da6..85e3ee1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -41,8 +41,6 @@
 #include "trace.h"
 #include "trace_output.h"
 
-#define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
-
 /*
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
@@ -340,7 +338,7 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD;
+	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE;
 
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
@@ -425,6 +423,7 @@ static const char *trace_options[] = {
 	"sleep-time",
 	"graph-time",
 	"record-cmd",
+	"overwrite",
 	NULL
 };
 
@@ -2529,6 +2528,9 @@ static void set_tracer_flags(unsigned int mask, int enabled)
 
 	if (mask == TRACE_ITER_RECORD_CMD)
 		trace_event_enable_cmd_record(enabled);
+
+	if (mask == TRACE_ITER_OVERWRITE)
+		ring_buffer_change_overwrite(global_trace.buffer, enabled);
 }
 
 static ssize_t
@@ -4555,9 +4557,11 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 __init static int tracer_alloc_buffers(void)
 {
 	int ring_buf_size;
+	enum ring_buffer_flags rb_flags;
 	int i;
 	int ret = -ENOMEM;
 
+
 	if (!alloc_cpumask_var(&tracing_buffer_mask, GFP_KERNEL))
 		goto out;
 
@@ -4570,12 +4574,13 @@ __init static int tracer_alloc_buffers(void)
 	else
 		ring_buf_size = 1;
 
+	rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
+
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
 	cpumask_copy(tracing_cpumask, cpu_all_mask);
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
-	global_trace.buffer = ring_buffer_alloc(ring_buf_size,
-						   TRACE_BUFFER_FLAGS);
+	global_trace.buffer = ring_buffer_alloc(ring_buf_size, rb_flags);
 	if (!global_trace.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
@@ -4585,7 +4590,7 @@ __init static int tracer_alloc_buffers(void)
 
 
 #ifdef CONFIG_TRACER_MAX_TRACE
-	max_tr.buffer = ring_buffer_alloc(1, TRACE_BUFFER_FLAGS);
+	max_tr.buffer = ring_buffer_alloc(1, rb_flags);
 	if (!max_tr.buffer) {
 		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 856e73c..951d0b7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -606,6 +606,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_SLEEP_TIME		= 0x40000,
 	TRACE_ITER_GRAPH_TIME		= 0x80000,
 	TRACE_ITER_RECORD_CMD		= 0x100000,
+	TRACE_ITER_OVERWRITE		= 0x200000,
 };
 
 /*
