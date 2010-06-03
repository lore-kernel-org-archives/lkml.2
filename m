Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab0FCK0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 06:26:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59527 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933486Ab0FCK0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 06:26:14 -0400
Message-ID: <4C078350.7090106@cn.fujitsu.com>
Date: Thu, 03 Jun 2010 18:26:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing: reduce latency and remove percpu trace_seq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__print_flags() and __print_symbolic() use percpu trace_seq:

1) Its memory is allocated at compile time, it wastes memory if we don't use tracing.
2) It is percpu data and it wastes more memory for multi-cpus system.
3) It disables preemption when it executes its core routine
   "trace_seq_printf(s, "%s: ", #call);" and introduces latency.

So we move this trace_seq to struct trace_iterator.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/ftrace_event.h |    5 +++--
 include/trace/ftrace.h       |   12 +++---------
 kernel/trace/trace_output.c  |    3 ---
 3 files changed, 6 insertions(+), 14 deletions(-)
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 3167f2d..25e264d 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -11,8 +11,6 @@ struct trace_array;
 struct tracer;
 struct dentry;
 
-DECLARE_PER_CPU(struct trace_seq, ftrace_event_seq);
-
 struct trace_print_flags {
 	unsigned long		mask;
 	const char		*name;
@@ -58,6 +56,9 @@ struct trace_iterator {
 	struct ring_buffer_iter	*buffer_iter[NR_CPUS];
 	unsigned long		iter_flags;
 
+	/* trace_seq for __print_flags() and __print_symbolic() etc. */
+	struct trace_seq	tmp_seq;
+
 	/* The below is zeroed out in pipe_read */
 	struct trace_seq	seq;
 	struct trace_entry	*ent;
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 5a64905..19369db 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -145,7 +145,7 @@
  *	struct trace_seq *s = &iter->seq;
  *	struct ftrace_raw_<call> *field; <-- defined in stage 1
  *	struct trace_entry *entry;
- *	struct trace_seq *p;
+ *	struct trace_seq *p = &iter->tmp_seq;
  *	int ret;
  *
  *	entry = iter->ent;
@@ -157,12 +157,10 @@
  *
  *	field = (typeof(field))entry;
  *
- *	p = &get_cpu_var(ftrace_event_seq);
  *	trace_seq_init(p);
  *	ret = trace_seq_printf(s, "%s: ", <call>);
  *	if (ret)
  *		ret = trace_seq_printf(s, <TP_printk> "\n");
- *	put_cpu();
  *	if (!ret)
  *		return TRACE_TYPE_PARTIAL_LINE;
  *
@@ -216,7 +214,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##call *field;				\
 	struct trace_entry *entry;					\
-	struct trace_seq *p;						\
+	struct trace_seq *p = &iter->tmp_seq;				\
 	int ret;							\
 									\
 	event = container_of(trace_event, struct ftrace_event_call,	\
@@ -231,12 +229,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 									\
 	field = (typeof(field))entry;					\
 									\
-	p = &get_cpu_var(ftrace_event_seq);				\
 	trace_seq_init(p);						\
 	ret = trace_seq_printf(s, "%s: ", event->name);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
-	put_cpu();							\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
@@ -255,7 +251,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 	struct trace_seq *s = &iter->seq;				\
 	struct ftrace_raw_##template *field;				\
 	struct trace_entry *entry;					\
-	struct trace_seq *p;						\
+	struct trace_seq *p = &iter->tmp_seq;				\
 	int ret;							\
 									\
 	entry = iter->ent;						\
@@ -267,12 +263,10 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags,	\
 									\
 	field = (typeof(field))entry;					\
 									\
-	p = &get_cpu_var(ftrace_event_seq);				\
 	trace_seq_init(p);						\
 	ret = trace_seq_printf(s, "%s: ", #call);			\
 	if (ret)							\
 		ret = trace_seq_printf(s, print);			\
-	put_cpu();							\
 	if (!ret)							\
 		return TRACE_TYPE_PARTIAL_LINE;				\
 									\
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 57c1b45..1ba64d3 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -16,9 +16,6 @@
 
 DECLARE_RWSEM(trace_event_mutex);
 
-DEFINE_PER_CPU(struct trace_seq, ftrace_event_seq);
-EXPORT_PER_CPU_SYMBOL(ftrace_event_seq);
-
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
 
 static int next_event_type = __TRACE_LAST_TYPE + 1;

