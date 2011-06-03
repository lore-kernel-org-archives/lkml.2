Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1FCOVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:21:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647Ab1FCOUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:20:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/5] tracing, function_graph: Remove dependency of abstime and duration fields on latency
Date: Fri,  3 Jun 2011 16:19:59 +0200
Message-Id: <1307110803-9476-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
References: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The display of absolute time and duration fields is based on the
latency field. This was added during the irqsoff/wakeup tracers
graph support changes.

It's causing confusion in what fields will be displayed for the
function_graph tracer itself. So I'm removing this depency, and
adding absolute time and duration fields to the irqsoff/wakeup
tracers.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   19 +++----------------
 kernel/trace/trace_irqsoff.c         |    4 +++-
 kernel/trace/trace_sched_wakeup.c    |    4 +++-
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 962cdb2..352652e 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1207,7 +1207,7 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 
 
 enum print_line_t
-__print_graph_function_flags(struct trace_iterator *iter, u32 flags)
+print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 {
 	struct ftrace_graph_ent_entry *field;
 	struct fgraph_data *data = iter->private;
@@ -1270,18 +1270,7 @@ __print_graph_function_flags(struct trace_iterator *iter, u32 flags)
 static enum print_line_t
 print_graph_function(struct trace_iterator *iter)
 {
-	return __print_graph_function_flags(iter, tracer_flags.val);
-}
-
-enum print_line_t print_graph_function_flags(struct trace_iterator *iter,
-					     u32 flags)
-{
-	if (trace_flags & TRACE_ITER_LATENCY_FMT)
-		flags |= TRACE_GRAPH_PRINT_DURATION;
-	else
-		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
-
-	return __print_graph_function_flags(iter, flags);
+	return print_graph_function_flags(iter, tracer_flags.val);
 }
 
 static enum print_line_t
@@ -1364,9 +1353,7 @@ void print_graph_headers_flags(struct seq_file *s, u32 flags)
 			return;
 
 		print_trace_header(s, iter);
-		flags |= TRACE_GRAPH_PRINT_DURATION;
-	} else
-		flags |= TRACE_GRAPH_PRINT_ABS_TIME;
+	}
 
 	__print_graph_headers_flags(s, flags);
 }
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index c77424b..667aa8c 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -226,7 +226,9 @@ static void irqsoff_trace_close(struct trace_iterator *iter)
 }
 
 #define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_CPU | \
-			    TRACE_GRAPH_PRINT_PROC)
+			    TRACE_GRAPH_PRINT_PROC | \
+			    TRACE_GRAPH_PRINT_ABS_TIME | \
+			    TRACE_GRAPH_PRINT_DURATION)
 
 static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
 {
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index f029dd4..e4a70c0 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -227,7 +227,9 @@ static void wakeup_trace_close(struct trace_iterator *iter)
 		graph_trace_close(iter);
 }
 
-#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_PROC)
+#define GRAPH_TRACER_FLAGS (TRACE_GRAPH_PRINT_PROC | \
+			    TRACE_GRAPH_PRINT_ABS_TIME | \
+			    TRACE_GRAPH_PRINT_DURATION)
 
 static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
 {
-- 
1.7.1

