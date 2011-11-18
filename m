Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010Ab1KRXP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:15:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53028 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab1KRXPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:15:22 -0500
Date: Fri, 18 Nov 2011 15:14:58 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-7e9a49ef542610609144d1afcd516dc3fafac4d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <20111107150849.GE1807@m.brq.redhat.com>
References: <20111107150849.GE1807@m.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing/latency: Fix header output for latency tracers
Git-Commit-ID: 7e9a49ef542610609144d1afcd516dc3fafac4d6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:15:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e9a49ef542610609144d1afcd516dc3fafac4d6
Gitweb:     http://git.kernel.org/tip/7e9a49ef542610609144d1afcd516dc3fafac4d6
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 7 Nov 2011 16:08:49 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Nov 2011 13:48:35 -0500

tracing/latency: Fix header output for latency tracers

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
    <idle>-0       0d.h5    1us+:      0:120:R   + [000]     7:  0:R watchdog/0
    <idle>-0       0d.h5    3us+: ttwu_do_activate.clone.1 <-try_to_wake_up
    ...

* The fixed output is:

  # tracer: wakeup
  #
  # wakeup latency trace v1.1.5 on 3.1.0-tip+
  # --------------------------------------------------------------------
  # latency: 55 us, #4/4, CPU#0 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
  #    -----------------
  #    | task: migration/0-6 (uid:0 nice:0 policy:1 rt_prio:99)
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
       cat-1129    0d..4    1us :   1129:120:R   + [000]     6:  0:R migration/0
       cat-1129    0d..4    2us+: ttwu_do_activate.clone.1 <-try_to_wake_up

* The current output (for wakeup tracer) with only function
  tracer enabled is:

  # tracer: wakeup
  #
       cat-1140    0d..4    1us+:   1140:120:R   + [000]     6:  0:R migration/0
       cat-1140    0d..4    2us : ttwu_do_activate.clone.1 <-try_to_wake_up

* The fixed output is:
  # tracer: wakeup
  #
  # wakeup latency trace v1.1.5 on 3.1.0-tip+
  # --------------------------------------------------------------------
  # latency: 207 us, #109/109, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:2)
  #    -----------------
  #    | task: watchdog/1-12 (uid:0 nice:0 policy:1 rt_prio:99)
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
    <idle>-0       1d.h5    1us+:      0:120:R   + [001]    12:  0:R watchdog/1
    <idle>-0       1d.h5    3us : ttwu_do_activate.clone.1 <-try_to_wake_up

Link: http://lkml.kernel.org/r/20111107150849.GE1807@m.brq.redhat.com

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c              |   15 +++++++++++++++
 kernel/trace/trace.h              |    1 +
 kernel/trace/trace_irqsoff.c      |   13 ++++++++++++-
 kernel/trace/trace_sched_wakeup.c |   13 ++++++++++++-
 4 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b24a72d..b296186 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2140,6 +2140,21 @@ enum print_line_t print_trace_line(struct trace_iterator *iter)
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
+
+	if (!(trace_flags & TRACE_ITER_VERBOSE))
+		print_lat_help_header(m);
+}
+
 void trace_default_header(struct seq_file *m)
 {
 	struct trace_iterator *iter = m->private;
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 092e1f8..f8ec229 100644
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
index a1a3359..a248c68 100644
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
