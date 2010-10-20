Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab0JTE76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:59:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:34116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab0JTE74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:59:56 -0400
Date: Wed, 20 Oct 2010 04:59:38 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1285243253-7372-4-git-send-email-jolsa@redhat.com>
References: <1285243253-7372-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Graph support for wakeup tracer
Message-ID: <tip-7495a5beaa22f190f4888aa8cbe4827c16575d0a@git.kernel.org>
Git-Commit-ID: 7495a5beaa22f190f4888aa8cbe4827c16575d0a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 04:59:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7495a5beaa22f190f4888aa8cbe4827c16575d0a
Gitweb:     http://git.kernel.org/tip/7495a5beaa22f190f4888aa8cbe4827c16575d0a
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 23 Sep 2010 14:00:53 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 18 Oct 2010 10:53:30 -0400

tracing: Graph support for wakeup tracer

Add function graph support for wakeup latency tracer.
The graph output is enabled by setting the 'display-graph'
trace option.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1285243253-7372-4-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_sched_wakeup.c |  231 +++++++++++++++++++++++++++++++++++--
 1 files changed, 221 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 4086eae..033510d 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -31,13 +31,33 @@ static int			wakeup_rt;
 static arch_spinlock_t wakeup_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
+static void wakeup_reset(struct trace_array *tr);
 static void __wakeup_reset(struct trace_array *tr);
+static int wakeup_graph_entry(struct ftrace_graph_ent *trace);
+static void wakeup_graph_return(struct ftrace_graph_ret *trace);
 
 static int save_lat_flag;
 
+#define TRACE_DISPLAY_GRAPH     1
+
+static struct tracer_opt trace_opts[] = {
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	/* display latency trace as call graph */
+	{ TRACER_OPT(display-graph, TRACE_DISPLAY_GRAPH) },
+#endif
+	{ } /* Empty entry */
+};
+
+static struct tracer_flags tracer_flags = {
+	.val  = 0,
+	.opts = trace_opts,
+};
+
+#define is_graph() (tracer_flags.val & TRACE_DISPLAY_GRAPH)
+
 #ifdef CONFIG_FUNCTION_TRACER
 /*
- * irqsoff uses its own tracer function to keep the overhead down:
+ * wakeup uses its own tracer function to keep the overhead down:
  */
 static void
 wakeup_tracer_call(unsigned long ip, unsigned long parent_ip)
@@ -80,8 +100,191 @@ static struct ftrace_ops trace_ops __read_mostly =
 {
 	.func = wakeup_tracer_call,
 };
+
+static int start_func_tracer(int graph)
+{
+	int ret;
+
+	if (!graph)
+		ret = register_ftrace_function(&trace_ops);
+	else
+		ret = register_ftrace_graph(&wakeup_graph_return,
+					    &wakeup_graph_entry);
+
+	if (!ret && tracing_is_enabled())
+		tracer_enabled = 1;
+	else
+		tracer_enabled = 0;
+
+	return ret;
+}
+
+static void stop_func_tracer(int graph)
+{
+	tracer_enabled = 0;
+
+	if (!graph)
+		unregister_ftrace_function(&trace_ops);
+	else
+		unregister_ftrace_graph();
+}
+
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+{
+
+	if (!(bit & TRACE_DISPLAY_GRAPH))
+		return -EINVAL;
+
+	if (!(is_graph() ^ set))
+		return 0;
+
+	stop_func_tracer(!set);
+
+	wakeup_reset(wakeup_trace);
+	tracing_max_latency = 0;
+
+	return start_func_tracer(set);
+}
+
+static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
+{
+	struct trace_array *tr = wakeup_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu, pc, ret = 0;
+
+	if (likely(!wakeup_task))
+		return 0;
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+	if (cpu != wakeup_current_cpu)
+		goto out_enable;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	local_save_flags(flags);
+	ret = __trace_graph_entry(tr, trace, flags, pc);
+
+out:
+	atomic_dec(&data->disabled);
+
+out_enable:
+	preempt_enable_notrace();
+	return ret;
+}
+
+static void wakeup_graph_return(struct ftrace_graph_ret *trace)
+{
+	struct trace_array *tr = wakeup_trace;
+	struct trace_array_cpu *data;
+	unsigned long flags;
+	long disabled;
+	int cpu, pc;
+
+	if (likely(!wakeup_task))
+		return;
+
+	pc = preempt_count();
+	preempt_disable_notrace();
+
+	cpu = raw_smp_processor_id();
+	if (cpu != wakeup_current_cpu)
+		goto out_enable;
+
+	data = tr->data[cpu];
+	disabled = atomic_inc_return(&data->disabled);
+	if (unlikely(disabled != 1))
+		goto out;
+
+	local_save_flags(flags);
+	__trace_graph_return(tr, trace, flags, pc);
+
+out:
+	atomic_dec(&data->disabled);
+
+out_enable:
+	preempt_enable_notrace();
+	return;
+}
+
+static void wakeup_trace_open(struct trace_iterator *iter)
+{
+	if (is_graph())
+		graph_trace_open(iter);
+}
+
+static void wakeup_trace_close(struct trace_iterator *iter)
+{
+	if (iter->private)
+		graph_trace_close(iter);
+}
+
+#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_PROC)
+
+static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
+{
+	/*
+	 * In graph mode call the graph tracer output function,
+	 * otherwise go with the TRACE_FN event handler
+	 */
+	if (is_graph())
+		return print_graph_function_flags(iter, GRAPH_TRACER_FLAGS);
+
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void wakeup_print_header(struct seq_file *s)
+{
+	if (is_graph())
+		print_graph_headers_flags(s, GRAPH_TRACER_FLAGS);
+	else
+		trace_default_header(s);
+}
+
+static void
+__trace_function(struct trace_array *tr,
+		 unsigned long ip, unsigned long parent_ip,
+		 unsigned long flags, int pc)
+{
+	if (is_graph())
+		trace_graph_function(tr, ip, parent_ip, flags, pc);
+	else
+		trace_function(tr, ip, parent_ip, flags, pc);
+}
+#else
+#define __trace_function trace_function
+
+static int wakeup_set_flag(u32 old_flags, u32 bit, int set)
+{
+	return -EINVAL;
+}
+
+static int wakeup_graph_entry(struct ftrace_graph_ent *trace)
+{
+	return -1;
+}
+
+static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
+{
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static void wakeup_graph_return(struct ftrace_graph_ret *trace) { }
+static void wakeup_print_header(struct seq_file *s) { }
+static void wakeup_trace_open(struct trace_iterator *iter) { }
+static void wakeup_trace_close(struct trace_iterator *iter) { }
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 /*
  * Should this new latency be reported/recorded?
  */
@@ -152,7 +355,7 @@ probe_wakeup_sched_switch(void *ignore,
 	/* The task we are waiting for is waking up */
 	data = wakeup_trace->data[wakeup_cpu];
 
-	trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
+	__trace_function(wakeup_trace, CALLER_ADDR0, CALLER_ADDR1, flags, pc);
 	tracing_sched_switch_trace(wakeup_trace, prev, next, flags, pc);
 
 	T0 = data->preempt_timestamp;
@@ -252,7 +455,7 @@ probe_wakeup(void *ignore, struct task_struct *p, int success)
 	 * is not called by an assembly function  (where as schedule is)
 	 * it should be safe to use it here.
 	 */
-	trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
+	__trace_function(wakeup_trace, CALLER_ADDR1, CALLER_ADDR2, flags, pc);
 
 out_locked:
 	arch_spin_unlock(&wakeup_lock);
@@ -303,12 +506,8 @@ static void start_wakeup_tracer(struct trace_array *tr)
 	 */
 	smp_wmb();
 
-	register_ftrace_function(&trace_ops);
-
-	if (tracing_is_enabled())
-		tracer_enabled = 1;
-	else
-		tracer_enabled = 0;
+	if (start_func_tracer(is_graph()))
+		printk(KERN_ERR "failed to start wakeup tracer\n");
 
 	return;
 fail_deprobe_wake_new:
@@ -320,7 +519,7 @@ fail_deprobe:
 static void stop_wakeup_tracer(struct trace_array *tr)
 {
 	tracer_enabled = 0;
-	unregister_ftrace_function(&trace_ops);
+	stop_func_tracer(is_graph());
 	unregister_trace_sched_switch(probe_wakeup_sched_switch, NULL);
 	unregister_trace_sched_wakeup_new(probe_wakeup, NULL);
 	unregister_trace_sched_wakeup(probe_wakeup, NULL);
@@ -379,9 +578,15 @@ static struct tracer wakeup_tracer __read_mostly =
 	.start		= wakeup_tracer_start,
 	.stop		= wakeup_tracer_stop,
 	.print_max	= 1,
+	.print_header	= wakeup_print_header,
+	.print_line	= wakeup_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= wakeup_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
+	.open		= wakeup_trace_open,
+	.close		= wakeup_trace_close,
 	.use_max_tr	= 1,
 };
 
@@ -394,9 +599,15 @@ static struct tracer wakeup_rt_tracer __read_mostly =
 	.stop		= wakeup_tracer_stop,
 	.wait_pipe	= poll_wait_pipe,
 	.print_max	= 1,
+	.print_header	= wakeup_print_header,
+	.print_line	= wakeup_print_line,
+	.flags		= &tracer_flags,
+	.set_flag	= wakeup_set_flag,
 #ifdef CONFIG_FTRACE_SELFTEST
 	.selftest    = trace_selftest_startup_wakeup,
 #endif
+	.open		= wakeup_trace_open,
+	.close		= wakeup_trace_close,
 	.use_max_tr	= 1,
 };
 
