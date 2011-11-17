Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1KQQJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:09:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab1KQQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:09:29 -0500
X-Authority-Analysis: v=2.0 cv=KcRQQHkD c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pSmveRAPe0wA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=WUBaXGvqeXaJHHRtF2UA:9 a=cHAnHt2VrZ-oJL61sgIA:7 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=S2Gcq5xrgOzVAB8T:21 a=glKaSi5zWcAsKZsC:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [RFC][PATCH] tracing: Add entries in buffer and total entries to
 default output header
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Nov 2011 11:09:24 -0500
Message-ID: <1321546164.3533.10.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Knowing the number of event entries in the ring buffer compared
to the total number that were written is useful information. The
latency format gives this information and there's no reason that the
default format does not.

This information is now added to the default header, along with the
number of online CPUs:

 # tracer: nop
 #
 # entries-in-buffer/entries-written: 159836/64690869   #P:4
 #
 #                              _-----=> irqs-off
 #                             / _----=> need-resched
 #                            | / _---=> hardirq/softirq
 #                            || / _--=> preempt-depth
 #                            ||| /     delay
 #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
 #              | |       |   ||||       |         |
           <idle>-0     [000] ...2    49.442971: local_touch_nmi <-cpu_idle
           <idle>-0     [000] d..2    49.442973: enter_idle <-cpu_idle
           <idle>-0     [000] d..2    49.442974: atomic_notifier_call_chain <-enter_idle
           <idle>-0     [000] d..2    49.442976: __atomic_notifier_call_chain <-atomic_notifier

The above shows that the trace contains 159836 entries, but
64690869 were written. One could figure out that there were
64531033 entries that were dropped.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   72 ++++++++++++++++++++++++++++++++-----------------
 1 files changed, 47 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fa5cee6..98cf97b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1845,6 +1845,33 @@ static void s_stop(struct seq_file *m, void *p)
 	trace_event_read_unlock();
 }
 
+static void
+get_total_entries(struct trace_array *tr, unsigned long *total, unsigned long *entries)
+{
+	unsigned long count;
+	int cpu;
+
+	*total = 0;
+	*entries = 0;
+
+	for_each_tracing_cpu(cpu) {
+		count = ring_buffer_entries_cpu(tr->buffer, cpu);
+		/*
+		 * If this buffer has skipped entries, then we hold all
+		 * entries for the trace and we need to ignore the
+		 * ones before the time stamp.
+		 */
+		if (tr->data[cpu]->skipped_entries) {
+			count -= tr->data[cpu]->skipped_entries;
+			/* total is the same as the entries */
+			*total += count;
+		} else
+			*total += count +
+				ring_buffer_overrun_cpu(tr->buffer, cpu);
+		*entries += count;
+	}
+}
+
 static void print_lat_help_header(struct seq_file *m)
 {
 	seq_puts(m, "#                  _------=> CPU#            \n");
@@ -1857,14 +1884,27 @@ static void print_lat_help_header(struct seq_file *m)
 	seq_puts(m, "#     \\   /      |||||  \\    |   /           \n");
 }
 
-static void print_func_help_header(struct seq_file *m)
+static void print_event_info(struct trace_array *tr, struct seq_file *m)
 {
+	unsigned long total;
+	unsigned long entries;
+
+	get_total_entries(tr, &total, &entries);
+	seq_printf(m, "# entries-in-buffer/entries-writtern: %lu/%lu   #P:%d\n",
+		   entries, total, num_online_cpus());
+	seq_puts(m, "#\n");
+}
+
+static void print_func_help_header(struct trace_array *tr, struct seq_file *m)
+{
+	print_event_info(tr, m);
 	seq_puts(m, "#           TASK-PID   CPU#      TIMESTAMP  FUNCTION\n");
 	seq_puts(m, "#              | |       |          |         |\n");
 }
 
-static void print_func_help_header_irq(struct seq_file *m)
+static void print_func_help_header_irq(struct trace_array *tr, struct seq_file *m)
 {
+	print_event_info(tr, m);
 	seq_puts(m, "#                              _-----=> irqs-off\n");
 	seq_puts(m, "#                             / _----=> need-resched\n");
 	seq_puts(m, "#                            | / _---=> hardirq/softirq\n");
@@ -1881,32 +1921,14 @@ print_trace_header(struct seq_file *m, struct trace_iterator *iter)
 	struct trace_array *tr = iter->tr;
 	struct trace_array_cpu *data = tr->data[tr->cpu];
 	struct tracer *type = current_trace;
-	unsigned long entries = 0;
-	unsigned long total = 0;
-	unsigned long count;
+	unsigned long entries;
+	unsigned long total;
 	const char *name = "preemption";
-	int cpu;
 
 	if (type)
 		name = type->name;
 
-
-	for_each_tracing_cpu(cpu) {
-		count = ring_buffer_entries_cpu(tr->buffer, cpu);
-		/*
-		 * If this buffer has skipped entries, then we hold all
-		 * entries for the trace and we need to ignore the
-		 * ones before the time stamp.
-		 */
-		if (tr->data[cpu]->skipped_entries) {
-			count -= tr->data[cpu]->skipped_entries;
-			/* total is the same as the entries */
-			total += count;
-		} else
-			total += count +
-				ring_buffer_overrun_cpu(tr->buffer, cpu);
-		entries += count;
-	}
+	get_total_entries(tr, &total, &entries);
 
 	seq_printf(m, "# %s latency trace v1.1.5 on %s\n",
 		   name, UTS_RELEASE);
@@ -2184,9 +2206,9 @@ void trace_default_header(struct seq_file *m)
 	} else {
 		if (!(trace_flags & TRACE_ITER_VERBOSE)) {
 			if (trace_flags & TRACE_ITER_IRQ_INFO)
-				print_func_help_header_irq(m);
+				print_func_help_header_irq(iter->tr, m);
 			else
-				print_func_help_header(m);
+				print_func_help_header(iter->tr, m);
 		}
 	}
 }
-- 
1.7.3.4



