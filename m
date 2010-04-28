Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab0D1BjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 21:39:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:34990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab0D1BiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 21:38:08 -0400
X-Authority-Analysis: v=1.1 cv=m27xf9DC4olkrNDaWzGlhfWN1WyLlD0+t5Z5YaFh7bA= c=1 sm=0 a=2-hINBMSB2YA:10 a=GzHTLUccyWwA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=DfNHnWVPAAAA:8 a=meVymXHHAAAA:8 a=ZOs_XStiAc2VpAllHOkA:9 a=ePpaKeEgX15n1XGI8ycA:7 a=i96jaToFPmpfIlqGBKHCRvirJAEA:4 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100428013807.250593960@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Apr 2010 21:27:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chase Douglas <chase.douglas@canonical.com>
Subject: [PATCH 7/8] tracing: Show sample std dev in function profiling
References: <20100428012723.119106602@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Show-sample-std-dev-in-function-profiling.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chase Douglas <chase.douglas@canonical.com>

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
LKML-Reference: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>

[ fixed comment about ns^2 -> us^2 conversion ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |   24 +++++++++++++++++++++---
 1 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2404b59..3bcb340 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -264,6 +264,7 @@ struct ftrace_profile {
 	unsigned long			counter;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	unsigned long long		time;
+	unsigned long long		time_squared;
 #endif
 };
 
@@ -366,9 +367,9 @@ static int function_stat_headers(struct seq_file *m)
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
@@ -384,6 +385,7 @@ static int function_stat_show(struct seq_file *m, void *v)
 	static DEFINE_MUTEX(mutex);
 	static struct trace_seq s;
 	unsigned long long avg;
+	unsigned long long stddev;
 #endif
 
 	kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
@@ -394,11 +396,25 @@ static int function_stat_show(struct seq_file *m, void *v)
 	avg = rec->time;
 	do_div(avg, rec->counter);
 
+	/* Sample standard deviation (s^2) */
+	if (rec->counter <= 1)
+		stddev = 0;
+	else {
+		stddev = rec->time_squared - rec->counter * avg * avg;
+		/*
+		 * Divide only 1000 for ns^2 -> us^2 conversion.
+		 * trace_print_graph_duration will divide 1000 again.
+		 */
+		do_div(stddev, (rec->counter - 1) * 1000);
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
@@ -668,8 +684,10 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
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
1.7.0


