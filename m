Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab0D3RBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:01:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab0D3RAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:00:52 -0400
Date: Fri, 30 Apr 2010 08:45:36 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1270227683-14631-2-git-send-email-jolsa@redhat.com>
References: <1270227683-14631-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Add ftrace events for graph tracer
Message-ID: <tip-9106b69382912ddc403a307b69bf894a6f3004e4@git.kernel.org>
Git-Commit-ID: 9106b69382912ddc403a307b69bf894a6f3004e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 08:45:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9106b69382912ddc403a307b69bf894a6f3004e4
Gitweb:     http://git.kernel.org/tip/9106b69382912ddc403a307b69bf894a6f3004e4
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 2 Apr 2010 19:01:20 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 26 Apr 2010 16:55:08 -0400

tracing: Add ftrace events for graph tracer

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
 
