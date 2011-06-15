Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab1FONwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:52:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857Ab1FONwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:40 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=vhdKIqpQuCYA:10 a=piYV-GeHtI0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=41rJZUIFWswt2Kl4fJIA:9 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615135235.480971241@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/16 v2] tracing, function_graph: Add context-info support for function_graph
References: <20110615134841.767565350@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-function_graph-Add-context-info-support-for-.patch
 tracer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The function_graph tracer does not follow global context-info option.
Adding TRACE_ITER_CONTEXT_INFO trace_flags check to enable it.

With following commands:
	# echo function_graph > ./current_tracer
	# echo 0 > options/context-info
	# cat trace

This is what it looked like before:
# tracer: function_graph
#
#     TIME        CPU  DURATION                  FUNCTION CALLS
#      |          |     |   |                     |   |   |   |
 1)   0.079 us    |          } /* __vma_link_rb */
 1)   0.056 us    |          copy_page_range();
 1)               |          security_vm_enough_memory() {
...

This is what it looks like now:
# tracer: function_graph
#
  } /* update_ts_time_stats */
  timekeeping_max_deferment();
...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1307113131-10045-6-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.7.4.4


