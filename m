Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab1KQPF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:05:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757783Ab1KQPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:05:25 -0500
X-Authority-Analysis: v=2.0 cv=NJxXCjGg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=EknHH5in4_8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=6qQLt6stNJpYIDOI3y4A:9 a=r7Zi7Lxi0aBXC6OwZ2MA:7 a=QEXdDO2ut3YA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [RFC][PATCH] tracing: Add irq, preempt-count and need resched info
 to default trace output
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 10:05:22 -0500
Message-ID: <1321542322.3533.6.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Instead of making latency format default, I decided to add the irq
information to the  default format. As both you and Peter have said that
traces are useless without it, why not just include it. I personally
prefer the default layout, but I do agree having the irq info is
important. I added an option that lets you disable it and make the
output like the old way, but by default the information is available.

What do you think of this?

I also plan on making another patch that adds some of the useful
information of the latency header to the default header as well. That
will be the # of events in buff compared to the # of events written
(counting dropped events too), and perhaps even the # of CPUS.

-- Steve

---
>From 77271ce4b2c0df0a76ad1cbb6a95b07e1f88c1ea Mon Sep 17 00:00:00 2001
From: Steven Rostedt <srostedt@redhat.com>
Date: Thu, 17 Nov 2011 09:34:33 -0500
Subject: [PATCH] tracing: Add irq, preempt-count and need resched info to default trace output

People keep asking how to get the preempt count, irq, and need resched info
and we keep telling them to enable the latency format. Some developers think
that traces without this info is completely useless, and for a lot of tasks
it is useless.

The first option was to enable the latency trace as the default format, but
the header for the latency format is pretty useless for most tracers and
it also does the timestamp in straight microseconds from the time the trace
started. This is sometimes more difficult to read as the default trace is
seconds from the start of boot up.

Latency format:

 # tracer: nop
 #
 # nop latency trace v1.1.5 on 3.2.0-rc1-test+
 # --------------------------------------------------------------------
 # latency: 0 us, #159771/64234230, CPU#1 | (M:preempt VP:0, KP:0, SP:0 HP:0 #P:4)
 #    -----------------
 #    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
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
 migratio-6       0...2 41778231us+: rcu_note_context_switch <-__schedule
 migratio-6       0...2 41778233us : trace_rcu_utilization <-rcu_note_context_switch
 migratio-6       0...2 41778235us+: rcu_sched_qs <-rcu_note_context_switch
 migratio-6       0d..2 41778236us+: rcu_preempt_qs <-rcu_note_context_switch
 migratio-6       0...2 41778238us : trace_rcu_utilization <-rcu_note_context_switch
 migratio-6       0...2 41778239us+: debug_lockdep_rcu_enabled <-__schedule

default format:

 # tracer: nop
 #
 #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
 #              | |       |          |         |
      migration/0-6     [000]    50.025810: rcu_note_context_switch <-__schedule
      migration/0-6     [000]    50.025812: trace_rcu_utilization <-rcu_note_context_switch
      migration/0-6     [000]    50.025813: rcu_sched_qs <-rcu_note_context_switch
      migration/0-6     [000]    50.025815: rcu_preempt_qs <-rcu_note_context_switch
      migration/0-6     [000]    50.025817: trace_rcu_utilization <-rcu_note_context_switch
      migration/0-6     [000]    50.025818: debug_lockdep_rcu_enabled <-__schedule
      migration/0-6     [000]    50.025820: debug_lockdep_rcu_enabled <-__schedule

The latency format header has latency information that is pretty meaningless
for most tracers. Although some of the header is useful, and we can add that
later to the default format as well.

What is really useful with the latency format is the irqs-off, need-resched
hard/softirq context and the preempt count.

This commit adds the option irq-info which is on by default that adds this
information:

 # tracer: nop
 #
 #                              _-----=> irqs-off
 #                             / _----=> need-resched
 #                            | / _---=> hardirq/softirq
 #                            || / _--=> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
           <idle>-0     [000] d..2    49.309305: cpuidle_get_driver <-cpuidle_idle_call
           <idle>-0     [000] d..2    49.309307: mwait_idle <-cpu_idle
           <idle>-0     [000] d..2    49.309309: need_resched <-mwait_idle
           <idle>-0     [000] d..2    49.309310: test_ti_thread_flag <-need_resched
           <idle>-0     [000] d..2    49.309312: trace_power_start.constprop.13 <-mwait_idle
           <idle>-0     [000] d..2    49.309313: trace_cpu_idle <-mwait_idle
           <idle>-0     [000] d..2    49.309315: need_resched <-mwait_idle

If a user wants the old format, they can disable the 'irq-info' option:

 # tracer: nop
 #
 #           TASK-PID   CPU#      TIMESTAMP  FUNCTION
 #              | |       |          |         |
           <idle>-0     [000]     49.309305: cpuidle_get_driver <-cpuidle_idle_call
           <idle>-0     [000]     49.309307: mwait_idle <-cpu_idle
           <idle>-0     [000]     49.309309: need_resched <-mwait_idle
           <idle>-0     [000]     49.309310: test_ti_thread_flag <-need_resched
           <idle>-0     [000]     49.309312: trace_power_start.constprop.13 <-mwait_idle
           <idle>-0     [000]     49.309313: trace_cpu_idle <-mwait_idle
           <idle>-0     [000]     49.309315: need_resched <-mwait_idle

Requested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c        |   24 ++++++++++++++++++++----
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_output.c |   16 ++++++++++++++--
 3 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9e158cc..fa5cee6 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -338,7 +338,8 @@ static DECLARE_WAIT_QUEUE_HEAD(trace_wait);
 /* trace_flags holds trace_options default values */
 unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
 	TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
-	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE;
+	TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
+	TRACE_ITER_IRQ_INFO;
 
 static int trace_stop_count;
 static DEFINE_RAW_SPINLOCK(tracing_start_lock);
@@ -426,6 +427,7 @@ static const char *trace_options[] = {
 	"record-cmd",
 	"overwrite",
 	"disable_on_free",
+	"irq-info",
 	NULL
 };
 
@@ -1857,10 +1859,20 @@ static void print_lat_help_header(struct seq_file *m)
 
 static void print_func_help_header(struct seq_file *m)
 {
-	seq_puts(m, "#           TASK-PID    CPU#    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
 	seq_puts(m, "#              | |       |          |         |\n");
 }
 
+static void print_func_help_header_irq(struct seq_file *m)
+{
+	seq_puts(m, "#                              _-----=> irqs-off\n");
+	seq_puts(m, "#                             / _----=> need-resched\n");
+	seq_puts(m, "#                            | / _---=> hardirq/softirq\n");
+	seq_puts(m, "#                            || / _--=> preempt-depth\n");
+	seq_puts(m, "#                            ||| /     delay\n");
+	seq_puts(m, "#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION\n");
+	seq_puts(m, "#              | |       |   ||||       |         |\n");
+}
 
 void
 print_trace_header(struct seq_file *m, struct trace_iterator *iter)
@@ -2170,8 +2182,12 @@ void trace_default_header(struct seq_file *m)
 		if (!(trace_flags & TRACE_ITER_VERBOSE))
 			print_lat_help_header(m);
 	} else {
-		if (!(trace_flags & TRACE_ITER_VERBOSE))
-			print_func_help_header(m);
+		if (!(trace_flags & TRACE_ITER_VERBOSE)) {
+			if (trace_flags & TRACE_ITER_IRQ_INFO)
+				print_func_help_header_irq(m);
+			else
+				print_func_help_header(m);
+		}
 	}
 }
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f8ec229..2c26574 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -655,6 +655,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_RECORD_CMD		= 0x100000,
 	TRACE_ITER_OVERWRITE		= 0x200000,
 	TRACE_ITER_STOP_ON_FREE		= 0x400000,
+	TRACE_ITER_IRQ_INFO		= 0x800000,
 };
 
 /*
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 5199930..0d6ff355 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -627,11 +627,23 @@ int trace_print_context(struct trace_iterator *iter)
 	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
 	unsigned long secs = (unsigned long)t;
 	char comm[TASK_COMM_LEN];
+	int ret;
 
 	trace_find_cmdline(entry->pid, comm);
 
-	return trace_seq_printf(s, "%16s-%-5d [%03d] %5lu.%06lu: ",
-				comm, entry->pid, iter->cpu, secs, usec_rem);
+	ret = trace_seq_printf(s, "%16s-%-5d [%03d] ",
+			       comm, entry->pid, iter->cpu);
+	if (!ret)
+		return 0;
+
+	if (trace_flags & TRACE_ITER_IRQ_INFO) {
+		ret = trace_print_lat_fmt(s, entry);
+		if (!ret)
+			return 0;
+	}
+
+	return trace_seq_printf(s, " %5lu.%06lu: ",
+				secs, usec_rem);
 }
 
 int trace_print_lat_context(struct trace_iterator *iter)
-- 
1.7.3.4



