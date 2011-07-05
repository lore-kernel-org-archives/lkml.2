Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab1GEMwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:52:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:58380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1GEMwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:52:15 -0400
Date: Tue, 5 Jul 2011 12:52:07 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-ffeb80fc30acbf6bd51cb47a1815f621a9d017dc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1307113131-10045-3-git-send-email-jolsa@redhat.com>
References: <1307113131-10045-3-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing, function_graph: Merge overhead and duration display functions
Git-Commit-ID: ffeb80fc30acbf6bd51cb47a1815f621a9d017dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:52:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffeb80fc30acbf6bd51cb47a1815f621a9d017dc
Gitweb:     http://git.kernel.org/tip/ffeb80fc30acbf6bd51cb47a1815f621a9d017dc
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 3 Jun 2011 16:58:48 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:47 -0400

tracing, function_graph: Merge overhead and duration display functions

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
