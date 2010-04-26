Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0DZSCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:02:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60766 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab0DZSCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:02:09 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] ftrace: print sample std dev when function profiling
Date: Mon, 26 Apr 2010 14:02:05 -0400
Message-Id: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When combined with function graph tracing the ftrace function profiler
also prints the average run time of functions. While this gives us some
good information, it doesn't tell us anything about the variance of the
run times of the function. This change prints out the s^2 sample
standard deviation alongside the average.

This change adds one entry to the profile record structure. This
increases the memory footprint of the function profiler by 1/3 on a
32-bit system, and by 1/5 on a 64-bit system when function graphing is
enabled, though the memory is only allocated when the profiler is turned
on. During the profiling, one extra line of code adds the squared
calltime to the new record entry, so this should not adversly affect
performance.

Note that the square of the sample standard deviation is printed because
there is no sqrt implementation for unsigned long long in the kernel.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 kernel/trace/ftrace.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 0cccb6c..07deba1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -253,6 +253,7 @@ struct ftrace_profile {
 	unsigned long			counter;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	unsigned long long		time;
+	unsigned long long		time_squared;
 #endif
 };
 
@@ -355,9 +356,9 @@ static int function_stat_headers(struct seq_file *m)
 {
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	seq_printf(m, "  Function                               "
-		   "Hit    Time            Avg\n"
+		   "Hit    Time            Avg             s^2\n"
 		      "  --------                               "
-		   "---    ----            ---\n");
+		   "---    ----            ---             ---\n");
 #else
 	seq_printf(m, "  Function                               Hit\n"
 		      "  --------                               ---\n");
@@ -373,6 +374,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	static DEFINE_MUTEX(mutex);
 	static struct trace_seq s;
 	unsigned long long avg;
+	unsigned long long stddev;
 #endif
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
@@ -383,11 +385,21 @@ static int function_stat_show(struct seq_file *m, void *v)
 	avg = rec->time;
 	do_div(avg, rec->counter);
 
+	/* Sample standard deviation (s^2) */
+	if (rec->counter <= 1)
+		stddev = 0;
+	else {
+		stddev = rec->time_squared - rec->counter * avg * avg;
+		do_div(stddev, (rec->counter - 1) * 1000); /* ns^2 -> us^2 */
+	}
+
 	mutex_lock(&mutex);
 	trace_seq_init(&s);
 	trace_print_graph_duration(rec->time, &s);
 	trace_seq_puts(&s, "    ");
 	trace_print_graph_duration(avg, &s);
+	trace_seq_puts(&s, "    ");
+	trace_print_graph_duration(stddev, &s);
 	trace_print_seq(m, &s);
 	mutex_unlock(&mutex);
 #endif
@@ -657,8 +669,10 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
 	}
 
 	rec = ftrace_find_profiled_func(stat, trace->func);
-	if (rec)
+	if (rec) {
 		rec->time += calltime;
+		rec->time_squared += calltime * calltime;
+	}
 
  out:
 	local_irq_restore(flags);
-- 
1.7.0.4

