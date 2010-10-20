Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0JTE73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:59:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:34103 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0JTE72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:59:28 -0400
Date: Wed, 20 Oct 2010 04:59:13 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1285243253-7372-3-git-send-email-jolsa@redhat.com>
References: <1285243253-7372-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Make graph related irqs/preemptsoff functions global
Message-ID: <tip-0a772620a2e21fb55a02f70fe38d4b5c3a5fbbbf@git.kernel.org>
Git-Commit-ID: 0a772620a2e21fb55a02f70fe38d4b5c3a5fbbbf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 04:59:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0a772620a2e21fb55a02f70fe38d4b5c3a5fbbbf
Gitweb:     http://git.kernel.org/tip/0a772620a2e21fb55a02f70fe38d4b5c3a5fbbbf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 23 Sep 2010 14:00:52 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 18 Oct 2010 10:53:28 -0400

tracing: Make graph related irqs/preemptsoff functions global

Move trace_graph_function() and print_graph_headers_flags() functions
to the trace_function_graph.c to be globaly available.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1285243253-7372-3-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h                 |    4 ++
 kernel/trace/trace_functions_graph.c |   63 ++++++++++++++++++++++++++++++++--
 kernel/trace/trace_irqsoff.c         |   56 ++++--------------------------
 3 files changed, 71 insertions(+), 52 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d39b3c5..9021f8c 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -343,6 +343,10 @@ void trace_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void trace_graph_function(struct trace_array *tr,
+		    unsigned long ip,
+		    unsigned long parent_ip,
+		    unsigned long flags, int pc);
 void trace_default_header(struct seq_file *m);
 void print_trace_header(struct seq_file *m, struct trace_iterator *iter);
 int trace_empty(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 4c58ccc..6f8fe28 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -262,6 +262,35 @@ int trace_graph_thresh_entry(struct ftrace_graph_ent *trace)
 		return trace_graph_entry(trace);
 }
 
+static void
+__trace_graph_function(struct trace_array *tr,
+		unsigned long ip, unsigned long flags, int pc)
+{
+	u64 time = trace_clock_local();
+	struct ftrace_graph_ent ent = {
+		.func  = ip,
+		.depth = 0,
+	};
+	struct ftrace_graph_ret ret = {
+		.func     = ip,
+		.depth    = 0,
+		.calltime = time,
+		.rettime  = time,
+	};
+
+	__trace_graph_entry(tr, &ent, flags, pc);
+	__trace_graph_return(tr, &ret, flags, pc);
+}
+
+void
+trace_graph_function(struct trace_array *tr,
+		unsigned long ip, unsigned long parent_ip,
+		unsigned long flags, int pc)
+{
+	__trace_graph_function(tr, parent_ip, flags, pc);
+	__trace_graph_function(tr, ip, flags, pc);
+}
+
 void __trace_graph_return(struct trace_array *tr,
 				struct ftrace_graph_ret *trace,
 				unsigned long flags,
@@ -1179,7 +1208,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 
 
 enum print_line_t
-print_graph_function_flags(struct trace_iterator *iter, u32 flags)
+__print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 {
 	struct ftrace_graph_ent_entry *field;
 	struct fgraph_data *data = iter->private;
@@ -1242,7 +1271,18 @@ print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 static enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
-	return print_graph_function_flags(iter, tracer_flags.val);
+	return __print_graph_function_flags(iter, tracer_flags.val);
+}
+
+enum print_line_t print_graph_function_flags(struct trace_iterator *iter,
+					     u32 flags)
+{
+	if (trace_flags & TRACE_ITER_LATENCY_FMT)
+		flags |= TRACE_GRAPH_PRINT_DURATION;
+	else
+		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+
+	return __print_graph_function_flags(iter, flags);
 }
 
 static enum print_line_t
@@ -1274,7 +1314,7 @@ static void print_lat_header(struct seq_file *s, u32 flags)
 	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
 }
 
-void print_graph_headers_flags(struct seq_file *s, u32 flags)
+static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 {
 	int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
 
@@ -1315,6 +1355,23 @@ void print_graph_headers(struct seq_file *s)
 	print_graph_headers_flags(s, tracer_flags.val);
 }
 
+void print_graph_headers_flags(struct seq_file *s, u32 flags)
+{
+	struct trace_iterator *iter = s->private;
+
+	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
+		/* print nothing if the buffers are empty */
+		if (trace_empty(iter))
+			return;
+
+		print_trace_header(s, iter);
+		flags |= TRACE_GRAPH_PRINT_DURATION;
+	} else
+		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+
+	__print_graph_headers_flags(s, flags);
+}
+
 void graph_trace_open(struct trace_iterator *iter)
 {
 	/* pid and depth on the last trace processed */
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 73a6b06..4047e98 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -229,75 +229,33 @@ static void irqsoff_trace_close(struct trace_iterator *iter)
 
 static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
 {
-	u32 flags = GRAPH_TRACER_FLAGS;
-
-	if (trace_flags & TRACE_ITER_LATENCY_FMT)
-		flags |= TRACE_GRAPH_PRINT_DURATION;
-	else
-		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
-
 	/*
 	 * In graph mode call the graph tracer output function,
 	 * otherwise go with the TRACE_FN event handler
 	 */
 	if (is_graph())
-		return print_graph_function_flags(iter, flags);
+		return print_graph_function_flags(iter, GRAPH_TRACER_FLAGS);
 
 	return TRACE_TYPE_UNHANDLED;
 }
 
 static void irqsoff_print_header(struct seq_file *s)
 {
-	if (is_graph()) {
-		struct trace_iterator *iter = s->private;
-		u32 flags = GRAPH_TRACER_FLAGS;
-
-		if (trace_flags & TRACE_ITER_LATENCY_FMT) {
-			/* print nothing if the buffers are empty */
-			if (trace_empty(iter))
-				return;
-
-			print_trace_header(s, iter);
-			flags |= TRACE_GRAPH_PRINT_DURATION;
-		} else
-			flags |= TRACE_GRAPH_PRINT_ABS_TIME;
-
-		print_graph_headers_flags(s, flags);
-	} else
+	if (is_graph())
+		print_graph_headers_flags(s, GRAPH_TRACER_FLAGS);
+	else
 		trace_default_header(s);
 }
 
 static void
-trace_graph_function(struct trace_array *tr,
-		 unsigned long ip, unsigned long flags, int pc)
-{
-	u64 time = trace_clock_local();
-	struct ftrace_graph_ent ent = {
-		.func  = ip,
-		.depth = 0,
-	};
-	struct ftrace_graph_ret ret = {
-		.func     = ip,
-		.depth    = 0,
-		.calltime = time,
-		.rettime  = time,
-	};
-
-	__trace_graph_entry(tr, &ent, flags, pc);
-	__trace_graph_return(tr, &ret, flags, pc);
-}
-
-static void
 __trace_function(struct trace_array *tr,
 		 unsigned long ip, unsigned long parent_ip,
 		 unsigned long flags, int pc)
 {
-	if (!is_graph())
+	if (is_graph())
+		trace_graph_function(tr, ip, parent_ip, flags, pc);
+	else
 		trace_function(tr, ip, parent_ip, flags, pc);
-	else {
-		trace_graph_function(tr, parent_ip, flags, pc);
-		trace_graph_function(tr, ip, flags, pc);
-	}
 }
 
 #else
