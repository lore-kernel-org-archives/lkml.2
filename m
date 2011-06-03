Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1FCO7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab1FCO7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:59:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 4/5] tracing, function_graph: Remove lock-depth from latency trace
Date: Fri,  3 Jun 2011 16:58:50 +0200
Message-Id: <1307113131-10045-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1307113131-10045-1-git-send-email-jolsa@redhat.com>
References: <1307111215.3667.53.camel@gandalf.stny.rr.com>
 <1307113131-10045-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lock_depth was removed in commit
e6e1e25 tracing: Remove lock_depth from event entry

Removing the lock_depth info from function_graph latency header.


With following commands:
	# echo function_graph > ./current_tracer
	# echo 1 > options/latency-format
	# cat trace

This is what it looked like before:
# tracer: function_graph
#
# function_graph latency trace v1.1.5 on 3.0.0-rc1-tip+
# --------------------------------------------------------------------
# latency: 0 us, #59756/311298, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
#    -----------------
#    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#
#      _-----=> irqs-off        
#     / _----=> need-resched    
#    | / _---=> hardirq/softirq 
#    || / _--=> preempt-depth   
#    ||| / _-=> lock-depth      
#    |||| /                     
# CPU|||||  DURATION                  FUNCTION CALLS
# |  |||||   |   |                     |   |   |   |
 0)  ....  0.068 us    |    } /* __rcu_read_unlock */
...

This is what it looks like now:
# tracer: function_graph
#
# function_graph latency trace v1.1.5 on 3.0.0-rc1-tip+
# --------------------------------------------------------------------
# latency: 0 us, #59747/1744610, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
#    -----------------
#    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
#    -----------------
#
#      _-----=> irqs-off        
#     / _----=> need-resched    
#    | / _---=> hardirq/softirq 
#    || / _--=> preempt-depth   
#    ||| /                      
# CPU||||  DURATION                  FUNCTION CALLS
# |  ||||   |   |                     |   |   |   |
 0)  ..s.  1.641 us    |  } /* __rcu_process_callbacks */
...


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_functions_graph.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 44b955f..1da5b97 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1298,8 +1298,7 @@ static void print_lat_header(struct seq_file *s, u32 flags)
 	seq_printf(s, "#%.*s / _----=> need-resched    \n", size, spaces);
 	seq_printf(s, "#%.*s| / _---=> hardirq/softirq \n", size, spaces);
 	seq_printf(s, "#%.*s|| / _--=> preempt-depth   \n", size, spaces);
-	seq_printf(s, "#%.*s||| / _-=> lock-depth      \n", size, spaces);
-	seq_printf(s, "#%.*s|||| /                     \n", size, spaces);
+	seq_printf(s, "#%.*s||| /                      \n", size, spaces);
 }
 
 static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
@@ -1318,7 +1317,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "  TASK/PID       ");
 	if (lat)
-		seq_printf(s, "|||||");
+		seq_printf(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "  DURATION   ");
 	seq_printf(s, "               FUNCTION CALLS\n");
@@ -1332,7 +1331,7 @@ static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
 	if (flags & TRACE_GRAPH_PRINT_PROC)
 		seq_printf(s, "   |    |        ");
 	if (lat)
-		seq_printf(s, "|||||");
+		seq_printf(s, "||||");
 	if (flags & TRACE_GRAPH_PRINT_DURATION)
 		seq_printf(s, "   |   |      ");
 	seq_printf(s, "               |   |   |   |\n");
-- 
1.7.1

