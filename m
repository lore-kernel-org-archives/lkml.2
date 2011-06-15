Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab1FONyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 09:54:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1FONwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 09:52:39 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=vhdKIqpQuCYA:10 a=auwo50b8grAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=gFsKVfyXFMZeCUwOvYIA:9 a=FHZ9NOhI2H2TR9YXYJ0A:7 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110615135235.221378875@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 15 Jun 2011 09:48:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/16 v2] tracing, function_graph: Remove lock-depth from latency trace
References: <20110615134841.767565350@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-function_graph-Remove-lock-depth-from-latenc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
Link: http://lkml.kernel.org/r/1307113131-10045-5-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.7.4.4


