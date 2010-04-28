Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0D1Bjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:39:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47941 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab0D1BiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:07 -0400
X-Authority-Analysis: v=1.1 cv=elpKMhBbP+pQyLZqL930WohJ6E0KICKd8OrLrcMNK78= c=1 sm=0 a=Ehoyc_K1tIsA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=vaOoHP15oWe29E69m6UA:9 a=QUJVIdLfWL_I4U_UBaMA:7 a=myCqUWJjZxpVa8eyDNgDaXMIw8EA:4 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428013805.549286587@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/8] tracing: Add ftrace events for graph tracer
References: <20100428012723.119106602@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Add-ftrace-events-for-graph-tracer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Add ftrace events for graph tracer, so the graph output could be shared
with other tracers.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1270227683-14631-2-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_functions_graph.c |   28 +++++++++++++++++++++++++++-
 1 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 669b9c3..db9e06b 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -40,7 +40,7 @@ struct fgraph_data {
 #define TRACE_GRAPH_PRINT_OVERHEAD	0x4
 #define TRACE_GRAPH_PRINT_PROC		0x8
 #define TRACE_GRAPH_PRINT_DURATION	0x10
-#define TRACE_GRAPH_PRINT_ABS_TIME	0X20
+#define TRACE_GRAPH_PRINT_ABS_TIME	0x20
 
 static struct tracer_opt trace_opts[] = {
 	/* Display overruns? (for self-debug purpose) */
@@ -1096,6 +1096,12 @@ print_graph_function(struct trace_iterator *iter)
 	return TRACE_TYPE_HANDLED;
 }
 
+static enum print_line_t
+print_graph_function_event(struct trace_iterator *iter, int flags)
+{
+	return print_graph_function(iter);
+}
+
 static void print_lat_header(struct seq_file *s)
 {
 	static const char spaces[] = "                "	/* 16 spaces */
@@ -1199,6 +1205,16 @@ static void graph_trace_close(struct trace_iterator *iter)
 	}
 }
 
+static struct trace_event graph_trace_entry_event = {
+	.type		= TRACE_GRAPH_ENT,
+	.trace		= print_graph_function_event,
+};
+
+static struct trace_event graph_trace_ret_event = {
+	.type		= TRACE_GRAPH_RET,
+	.trace		= print_graph_function_event,
+};
+
 static struct tracer graph_trace __read_mostly = {
 	.name		= "function_graph",
 	.open		= graph_trace_open,
@@ -1220,6 +1236,16 @@ static __init int init_graph_trace(void)
 {
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
 
+	if (!register_ftrace_event(&graph_trace_entry_event)) {
+		pr_warning("Warning: could not register graph trace events\n");
+		return 1;
+	}
+
+	if (!register_ftrace_event(&graph_trace_ret_event)) {
+		pr_warning("Warning: could not register graph trace events\n");
+		return 1;
+	}
+
 	return register_tracer(&graph_trace);
 }
 
-- 
1.7.0


