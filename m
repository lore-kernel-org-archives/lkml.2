Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab1FCOUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:20:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab1FCOUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:20:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/5] tracing, function_graph: Add context-info support for function_graph tracer
Date: Fri,  3 Jun 2011 16:20:03 +0200
Message-Id: <1307110803-9476-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
References: <1307110803-9476-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function_graph tracer does not follow global context-info option.
Adding TRACE_ITER_CONTEXT_INFO trace_flags check to enable it.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_functions_graph.c |   53 ++++++++++++++++++++--------------
 1 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 1da5b97..e8d6bb5 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -613,28 +613,30 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 		addr >= (unsigned long)__irqentry_text_end)
 		return TRACE_TYPE_UNHANDLED;
 
-	/* Absolute time */
-	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
-		ret = print_graph_abs_time(iter->ts, s);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
+		/* Absolute time */
+		if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
+			ret = print_graph_abs_time(iter->ts, s);
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
 
-	/* Cpu */
-	if (flags & TRACE_GRAPH_PRINT_CPU) {
-		ret = print_graph_cpu(s, cpu);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+		/* Cpu */
+		if (flags & TRACE_GRAPH_PRINT_CPU) {
+			ret = print_graph_cpu(s, cpu);
+			if (ret == TRACE_TYPE_PARTIAL_LINE)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
 
-	/* Proc */
-	if (flags & TRACE_GRAPH_PRINT_PROC) {
-		ret = print_graph_proc(s, pid);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-		ret = trace_seq_printf(s, " | ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
+		/* Proc */
+		if (flags & TRACE_GRAPH_PRINT_PROC) {
+			ret = print_graph_proc(s, pid);
+			if (ret == TRACE_TYPE_PARTIAL_LINE)
+				return TRACE_TYPE_PARTIAL_LINE;
+			ret = trace_seq_printf(s, " | ");
+			if (!ret)
+				return TRACE_TYPE_PARTIAL_LINE;
+		}
 	}
 
 	/* No overhead */
@@ -710,8 +712,9 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
 {
 	int ret = -1;
 
-	if (!(flags & TRACE_GRAPH_PRINT_DURATION))
-		return TRACE_TYPE_HANDLED;
+	if (!(flags & TRACE_GRAPH_PRINT_DURATION) ||
+	    !(trace_flags & TRACE_ITER_CONTEXT_INFO))
+			return TRACE_TYPE_HANDLED;
 
 	/* No real adata, just filling the column with spaces */
 	switch (duration) {
@@ -879,6 +882,9 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
 			return TRACE_TYPE_PARTIAL_LINE;
 	}
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return 0;
+
 	/* Absolute time */
 	if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
 		ret = print_graph_abs_time(iter->ts, s);
@@ -1346,6 +1352,9 @@ void print_graph_headers_flags(struct seq_file *s, u32 flags)
 {
 	struct trace_iterator *iter = s->private;
 
+	if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
+		return;
+
 	if (trace_flags & TRACE_ITER_LATENCY_FMT) {
 		/* print nothing if the buffers are empty */
 		if (trace_empty(iter))
-- 
1.7.1

