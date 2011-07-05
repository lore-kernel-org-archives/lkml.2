Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab1GEMxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:53:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:58409 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab1GEMxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:53:00 -0400
Date: Tue, 5 Jul 2011 12:52:54 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-199abfab40389963b397c2982222e68ea782b2cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1307113131-10045-5-git-send-email-jolsa@redhat.com>
References: <1307113131-10045-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing, function_graph: Remove lock-depth from latency trace
Git-Commit-ID: 199abfab40389963b397c2982222e68ea782b2cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 05 Jul 2011 12:52:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  199abfab40389963b397c2982222e68ea782b2cf
Gitweb:     http://git.kernel.org/tip/199abfab40389963b397c2982222e68ea782b2cf
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 3 Jun 2011 16:58:50 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 14 Jun 2011 22:48:49 -0400

tracing, function_graph: Remove lock-depth from latency trace

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
