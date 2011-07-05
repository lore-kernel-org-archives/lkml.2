Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab1GEMx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:53:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:58441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab1GEMxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:53:24 -0400
Date: Tue, 5 Jul 2011 12:53:17 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-749230b06a753a22f6ed96e5dd60815d6ab12865@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1307113131-10045-6-git-send-email-jolsa@redhat.com>
References: <1307113131-10045-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing, function_graph: Add context-info support for function_graph tracer
Git-Commit-ID: 749230b06a753a22f6ed96e5dd60815d6ab12865
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:53:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  749230b06a753a22f6ed96e5dd60815d6ab12865
Gitweb:     http://git.kernel.org/tip/749230b06a753a22f6ed96e5dd60815d6ab12865
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 3 Jun 2011 16:58:51 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:49 -0400

tracing, function_graph: Add context-info support for function_graph tracer

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
