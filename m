Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab1FIRbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 13:31:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1FIR3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 13:29:15 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=9JnmS17Y4WAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Mtx7430EFADTQ8tIKooA:9 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110609172912.155081236@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 09 Jun 2011 13:27:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/15] tracing, function_graph: Merge overhead and duration display
References: <20110609172744.333794089@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-function_graph-Merge-overhead-and-duration-d.patch
 functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Functions print_graph_overhead() and print_graph_duration() displays
data for one field - DURATION.

I merged them into single function print_graph_duration(),
and added a way to display the empty parts of the field.

This way the print_graph_irq() function can use this column to display
the IRQ signs if needed and the DURATION field details stays inside
the print_graph_duration() function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1307113131-10045-3-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |  148 +++++++++++++++++-----------------
 1 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 352652e..44b955f 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -74,6 +74,20 @@ static struct tracer_flags tracer_flags = {
 
 static struct trace_array *graph_array;
 
+/*
+ * DURATION column is being also used to display IRQ signs,
+ * following values are used by print_graph_irq and others
+ * to fill in space into DURATION column.
+ */
+enum {
+	DURATION_FILL_FULL  = -1,
+	DURATION_FILL_START = -2,
+	DURATION_FILL_END   = -3,
+};
+
+static enum print_line_t
+print_graph_duration(unsigned long long duration, struct trace_seq *s,
+		     u32 flags);
 
 /* Add a function return address to the trace stack on thread info.*/
 int
@@ -577,32 +591,6 @@ get_return_for_leaf(struct trace_iterator *iter,
 	return next;
 }
 
-/* Signal a overhead of time execution to the output */
-static int
-print_graph_overhead(unsigned long long duration, struct trace_seq *s,
-		     u32 flags)
-{
-	/* If duration disappear, we don't need anything */
-	if (!(flags & TRACE_GRAPH_PRINT_DURATION))
-		return 1;
-
-	/* Non nested entry or return */
-	if (duration == -1)
-		return trace_seq_printf(s, "  ");
-
-	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
-		/* Duration exceeded 100 msecs */
-		if (duration > 100000ULL)
-			return trace_seq_printf(s, "! ");
-
-		/* Duration exceeded 10 msecs */
-		if (duration > 10000ULL)
-			return trace_seq_printf(s, "+ ");
-	}
-
-	return trace_seq_printf(s, "  ");
-}
-
 static int print_graph_abs_time(u64 t, struct trace_seq *s)
 {
 	unsigned long usecs_rem;
@@ -650,9 +638,9 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	}
 
 	/* No overhead */
-	ret = print_graph_overhead(-1, s, flags);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
+	ret = print_graph_duration(DURATION_FILL_START, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
 
 	if (type == TRACE_GRAPH_ENT)
 		ret = trace_seq_printf(s, "==========>");
@@ -662,9 +650,10 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Don't close the duration column if haven't one */
-	if (flags & TRACE_GRAPH_PRINT_DURATION)
-		trace_seq_printf(s, " |");
+	ret = print_graph_duration(DURATION_FILL_END, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
+
 	ret = trace_seq_printf(s, "\n");
 
 	if (!ret)
@@ -716,9 +705,48 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 }
 
 static enum print_line_t
-print_graph_duration(unsigned long long duration, struct trace_seq *s)
+print_graph_duration(unsigned long long duration, struct trace_seq *s,
+		     u32 flags)
 {
-	int ret;
+	int ret = -1;
+
+	if (!(flags & TRACE_GRAPH_PRINT_DURATION))
+		return TRACE_TYPE_HANDLED;
+
+	/* No real adata, just filling the column with spaces */
+	switch (duration) {
+	case DURATION_FILL_FULL:
+		ret = trace_seq_printf(s, "              |  ");
+		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	case DURATION_FILL_START:
+		ret = trace_seq_printf(s, "  ");
+		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	case DURATION_FILL_END:
+		ret = trace_seq_printf(s, " |");
+		return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+	}
+
+	/* Signal a overhead of time execution to the output */
+	if (flags & TRACE_GRAPH_PRINT_OVERHEAD) {
+		/* Duration exceeded 100 msecs */
+		if (duration > 100000ULL)
+			ret = trace_seq_printf(s, "! ");
+		/* Duration exceeded 10 msecs */
+		else if (duration > 10000ULL)
+			ret = trace_seq_printf(s, "+ ");
+	}
+
+	/*
+	 * The -1 means we either did not exceed the duration tresholds
+	 * or we dont want to print out the overhead. Either way we need
+	 * to fill out the space.
+	 */
+	if (ret == -1)
+		ret = trace_seq_printf(s, "  ");
+
+	/* Catching here any failure happenned above */
+	if (!ret)
+		return TRACE_TYPE_PARTIAL_LINE;
 
 	ret = trace_print_graph_duration(duration, s);
 	if (ret != TRACE_TYPE_HANDLED)
@@ -767,18 +795,11 @@ print_graph_entry_leaf(struct trace_iterator *iter,
 			cpu_data->enter_funcs[call->depth] = 0;
 	}
 
-	/* Overhead */
-	ret = print_graph_overhead(duration, s, flags);
-	if (!ret)
+	/* Overhead and duration */
+	ret = print_graph_duration(duration, s, flags);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Duration */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = print_graph_duration(duration, s);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
 		ret = trace_seq_printf(s, " ");
@@ -815,17 +836,10 @@ print_graph_entry_nested(struct trace_iterator *iter,
 			cpu_data->enter_funcs[call->depth] = call->func;
 	}
 
-	/* No overhead */
-	ret = print_graph_overhead(-1, s, flags);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	/* No time */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = trace_seq_printf(s, "            |  ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
 
 	/* Function */
 	for (i = 0; i < call->depth * TRACE_GRAPH_INDENT; i++) {
@@ -1078,18 +1092,11 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Overhead */
-	ret = print_graph_overhead(duration, s, flags);
-	if (!ret)
+	/* Overhead and duration */
+	ret = print_graph_duration(duration, s, flags);
+	if (ret == TRACE_TYPE_PARTIAL_LINE)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* Duration */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = print_graph_duration(duration, s);
-		if (ret == TRACE_TYPE_PARTIAL_LINE)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
-
 	/* Closing brace */
 	for (i = 0; i < trace->depth * TRACE_GRAPH_INDENT; i++) {
 		ret = trace_seq_printf(s, " ");
@@ -1146,17 +1153,10 @@ print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
 	if (print_graph_prologue(iter, s, 0, 0, flags))
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	/* No overhead */
-	ret = print_graph_overhead(-1, s, flags);
-	if (!ret)
-		return TRACE_TYPE_PARTIAL_LINE;
-
 	/* No time */
-	if (flags & TRACE_GRAPH_PRINT_DURATION) {
-		ret = trace_seq_printf(s, "            |  ");
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-	}
+	ret = print_graph_duration(DURATION_FILL_FULL, s, flags);
+	if (ret != TRACE_TYPE_HANDLED)
+		return ret;
 
 	/* Indentation */
 	if (depth > 0)
-- 
1.7.4.4


