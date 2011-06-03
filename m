Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1FCO67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:58:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1FCO64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:58:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 1/5] tracing, function_graph: Remove dependency of abstime and duration fields on latency
Date: Fri,  3 Jun 2011 16:58:47 +0200
Message-Id: <1307113131-10045-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1307113131-10045-1-git-send-email-jolsa@redhat.com>
References: <1307111215.3667.53.camel@gandalf.stny.rr.com>
 <1307113131-10045-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The display of absolute time and duration fields is based on the
latency field. This was added during the irqsoff/wakeup tracers
graph support changes.

It's causing confusion in what fields will be displayed for the
function_graph tracer itself. So I'm removing this depency, and
adding absolute time and duration fields to the preemptirqsoff
preemptoff irqsoff wakeup tracers.


With following commands:
	# echo function_graph > ./current_tracer
	# cat trace

This is what it looked like before:
# tracer: function_graph
#
#     TIME        CPU  DURATION                  FUNCTION CALLS
#      |          |     |   |                     |   |   |   |
 0)   0.068 us    |          } /* page_add_file_rmap */
 0)               |          _raw_spin_unlock() {
...

This is what it looks like now:
# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |
 0)   0.068 us    |                } /* add_preempt_count */
 0)   0.993 us    |              } /* vfsmount_lock_local_lock */
...


For preemptirqsoff preemptoff irqsoff wakeup tracers,
this is what it looked like before:
SNIP
#                       _-----=> irqs-off        
#                      / _----=> need-resched    
#                     | / _---=> hardirq/softirq 
#                     || / _--=> preempt-depth   
#                     ||| / _-=> lock-depth      
#                     |||| /                     
# CPU  TASK/PID       |||||  DURATION                  FUNCTION CALLS
# |     |    |        |||||   |   |                     |   |   |   |
 1)    <idle>-0    |  d..1  0.000 us    |  acpi_idle_enter_simple();
...

This is what it looks like now:
SNIP
#
#                                       _-----=> irqs-off        
#                                      / _----=> need-resched    
#                                     | / _---=> hardirq/softirq 
#                                     || / _--=> preempt-depth   
#                                     ||| /                      
#     TIME        CPU  TASK/PID       ||||  DURATION                  FUNCTION CALLS
#      |          |     |    |        ||||   |   |                     |   |   |   |
   19.847735 |   1)    <idle>-0    |  d..1  0.000 us    |  acpi_idle_enter_simple();
...


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

