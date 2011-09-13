Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab1IMODl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 10:03:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1IMODk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 10:03:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] tracing/latency: Fix header output for latency tracers
Date: Tue, 13 Sep 2011 16:03:34 +0200
Message-Id: <1315922614-6390-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the the graph tracer (CONFIG_FUNCTION_GRAPH_TRACER) or even the
function tracer (CONFIG_FUNCTION_TRACER) are not set, the latency tracers
do not display proper latency header.

The involved/fixed latency tracers are:
        wakeup_rt
        wakeup
        preemptirqsoff
        preemptoff
        irqsoff

The patch adds proper handling of tracer configuration options for latency
tracers, and displaying correct header info accordingly.

* The current output (for wakeup tracer) with both graph and function
  tracers disabled is:

  # tracer: wakeup
  #
     cat-1163    0d..4    1us :   1163:120:R   + [000]     6:  0:R migration/0
     cat-1163    0d..4    2us+: ttwu_do_activate.clone.1 <-try_to_wake_up
     cat-1163    0d..3    4us : __schedule <-preempt_schedule
     cat-1163    0d..3    4us :   1163:120:R ==> [000]     6:  0:R migration/0


* The fixed output is:

  # tracer: wakeup
  #
  # wakeup latency trace v1.1.5 on 3.1.0-rc4-tip+
  # --------------------------------------------------------------------
  # latency: 91 us, #4/4, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
  #    -----------------
  #    | task: watchdog/0-7 (uid:0 nice:0 policy:1 rt_prio:99)
  #    -----------------
  #
    <idle>-0       0d.h5    1us :      0:120:R   + [000]     7:  0:R watchdog/0
    <idle>-0       0d.h5    2us+: ttwu_do_activate.clone.1 <-try_to_wake_up
    <idle>-0       0d..3   17us : __schedule <-schedule
    <idle>-0       0d..3   17us :      0:120:R ==> [000]     7:  0:R watchdog/0


* There's slightly different output (for wakeup_rt tracer) when function
  tracer is enabled, currently:

  # tracer: wakeup_rt
  #
     cat-1168    1d..4    0us :   1168:120:R   + [001]     8:  0:R migration/1
     cat-1168    1d..4    1us : ttwu_do_activate.clone.1 <-try_to_wake_up
     cat-1168    1d..3    1us : check_preempt_curr <-ttwu_do_wakeup
     ...


* After the fix:

  # tracer: wakeup_rt
  #
  # wakeup_rt latency trace v1.1.5 on 3.1.0-rc4-tip+
  # --------------------------------------------------------------------
  # latency: 209 us, #113/113, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
  #    -----------------
  #    | task: watchdog/0-7 (uid:0 nice:0 policy:1 rt_prio:99)
  #    -----------------
  #
  #                  _------=> CPU#            
  #                 / _-----=> irqs-off        
  #                | / _----=> need-resched    
  #                || / _---=> hardirq/softirq 
  #                ||| / _--=> preempt-depth   
  #                |||| /     delay             
  #  cmd     pid   ||||| time  |   caller      
  #     \   /      |||||  \    |   /           
     cat-1168    1d..4    0us :   1168:120:R   + [001]     8:  0:R migration/1
     cat-1168    1d..4    1us : ttwu_do_activate.clone.1 <-try_to_wake_up
     cat-1168    1d..3    1us : check_preempt_curr <-ttwu_do_wakeup
     ...


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace.c              |   12 ++++++++++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |   13 ++++++++++++-
 kernel/trace/trace_sched_wakeup.c |   13 ++++++++++++-
 4 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..7086345 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2139,6 +2139,18 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
 	return print_trace_fmt(iter);
 }
 
+void trace_latency_header(struct seq_file *m)
+{
+	struct trace_iterator *iter = m->private;
+
+	/* print nothing if the buffers are empty */
+	if (trace_empty(iter))
+		return;
+
+	if (iter->iter_flags & TRACE_FILE_LAT_FMT)
+		print_trace_header(m, iter);
+}
+
 void trace_default_header(struct seq_file *m)
 {
 	struct trace_iterator *iter = m->private;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 616846b..db40865 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -370,6 +370,7 @@ void trace_graph_function(struct trace_array *tr,
 		    unsigned long ip,
 		    unsigned long parent_ip,
 		    unsigned long flags, int pc);
+void trace_latency_header(struct seq_file *m);
 void trace_default_header(struct seq_file *m);
 void print_trace_header(struct seq_file *m, struct trace_iterator *iter);
 int trace_empty(struct trace_iterator *iter);
diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
index 667aa8c..2a0aee6 100644
--- a/kernel/trace/trace_irqsoff.c
+++ b/kernel/trace/trace_irqsoff.c
@@ -280,9 +280,20 @@ static enum print_line_t irqsoff_print_line(struct trace_iterator *iter)
 }
 
 static void irqsoff_graph_return(struct ftrace_graph_ret *trace) { }
-static void irqsoff_print_header(struct seq_file *s) { }
 static void irqsoff_trace_open(struct trace_iterator *iter) { }
 static void irqsoff_trace_close(struct trace_iterator *iter) { }
+
+#ifdef CONFIG_FUNCTION_TRACER
+static void irqsoff_print_header(struct seq_file *s)
+{
+	trace_default_header(s);
+}
+#else
+static void irqsoff_print_header(struct seq_file *s)
+{
+	trace_latency_header(s);
+}
+#endif /* CONFIG_FUNCTION_TRACER */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 /*
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index e4a70c0..ff791ea 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -280,9 +280,20 @@ static enum print_line_t wakeup_print_line(struct trace_iterator *iter)
 }
 
 static void wakeup_graph_return(struct ftrace_graph_ret *trace) { }
-static void wakeup_print_header(struct seq_file *s) { }
 static void wakeup_trace_open(struct trace_iterator *iter) { }
 static void wakeup_trace_close(struct trace_iterator *iter) { }
+
+#ifdef CONFIG_FUNCTION_TRACER
+static void wakeup_print_header(struct seq_file *s)
+{
+	trace_default_header(s);
+}
+#else
+static void wakeup_print_header(struct seq_file *s)
+{
+	trace_latency_header(s);
+}
+#endif /* CONFIG_FUNCTION_TRACER */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 /*
-- 
1.7.1

