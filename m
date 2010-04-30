Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0D3RB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:01:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:60359 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226Ab0D3RBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:01:09 -0400
Date: Fri, 30 Apr 2010 08:47:20 GMT
From: tip-bot for Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, chase.douglas@canonical.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, chase.douglas@canonical.com
In-Reply-To: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>
References: <1272304925-2436-1-git-send-email-chase.douglas@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Show sample std dev in function profiling
Message-ID: <tip-e330b3bcd83199dd63a819d8d12e40f9edae6c77@git.kernel.org>
Git-Commit-ID: e330b3bcd83199dd63a819d8d12e40f9edae6c77
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Apr 2010 08:47:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e330b3bcd83199dd63a819d8d12e40f9edae6c77
Gitweb:     http://git.kernel.org/tip/e330b3bcd83199dd63a819d8d12e40f9edae6c77
Author:     Chase Douglas <chase.douglas@canonical.com>
AuthorDate: Mon, 26 Apr 2010 14:02:05 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 27 Apr 2010 18:23:15 -0400

tracing: Show sample std dev in function profiling

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
