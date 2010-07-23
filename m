Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab0GWMKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:10:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:43030 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569Ab0GWMKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:10:39 -0400
Date: Fri, 23 Jul 2010 12:10:23 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4C078350.7090106@cn.fujitsu.com>
References: <4C078350.7090106@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Reduce latency and remove percpu trace_seq
Message-ID: <tip-bc289ae98b75d93228d24f521ef02a076e506e94@git.kernel.org>
Git-Commit-ID: bc289ae98b75d93228d24f521ef02a076e506e94
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 12:10:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc289ae98b75d93228d24f521ef02a076e506e94
Gitweb:     http://git.kernel.org/tip/bc289ae98b75d93228d24f521ef02a076e506e94
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Thu, 3 Jun 2010 18:26:24 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 20 Jul 2010 22:05:34 -0400

tracing: Reduce latency and remove percpu trace_seq

__print_flags() and __print_symbolic() use percpu trace_seq:

1) Its memory is allocated at compile time, it wastes memory if we don't use tracing.
2) It is percpu data and it wastes more memory for multi-cpus system.
3) It disables preemption when it executes its core routine
   "trace_seq_printf(s, "%s: ", #call);" and introduces latency.

So we move this trace_seq to struct trace_iterator.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4C078350.7090106@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    5 +++--
 include/trace/ftrace.h       |   12 +++---------
 kernel/trace/trace_output.c  |    3 ---
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 2b7b139..02b8b24 100644
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
index 55c1fd1..fb783d9 100644
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
