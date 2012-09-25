Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2IYW3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:29:45 -0400
Received: from mail-fa0-f74.google.com ([209.85.161.74]:65494 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2IYW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:29:41 -0400
From: David Sharp <dhsharp@google.com>
To: linux-kernel@vger.kernel.org
Cc: David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH v4 3/3] tracing: format non-nanosec times from tsc clock without a decimal point.
Date: Tue, 25 Sep 2012 15:29:34 -0700
Message-Id: <1348612174-19881-1-git-send-email-dhsharp@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAJL_ekvRFSDkFMmTyKD1-RTE2J=ajTdhb0s5TKmbVVKLRzakmw@mail.gmail.com>
References: <CAJL_ekvRFSDkFMmTyKD1-RTE2J=ajTdhb0s5TKmbVVKLRzakmw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of the "tsc" clock, formatting timestamps to look like
fractional seconds is misleading. Mark clocks as either in nanoseconds or
not, and format non-nanosecond timestamps as decimal integers.

Tested:
$ cd /sys/kernel/debug/tracing/
$ cat trace_clock
[local] global tsc
$ echo sched_switch > set_event
$ echo 1 > tracing_enabled ; sleep 0.0005 ; echo 0 > tracing_enabled
$ cat trace
          <idle>-0     [000]  6330.555552: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=bash next_pid=29964 next_prio=120
           sleep-29964 [000]  6330.555628: sched_switch: prev_comm=bash prev_pid=29964 prev_prio=120 prev_state=S ==> next_comm=swapper next_pid=0 next_prio=120
  ...
$ echo 1 > options/latency-format
$ cat trace
  <idle>-0       0 4104553247us+: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=bash next_pid=29964 next_prio=120
   sleep-29964   0 4104553322us+: sched_switch: prev_comm=bash prev_pid=29964 prev_prio=120 prev_state=S ==> next_comm=swapper next_pid=0 next_prio=120
  ...
$ echo tsc > trace_clock
$ cat trace
$ echo 1 > tracing_enabled ; sleep 0.0005 ; echo 0 > tracing_enabled
$ echo 0 > options/latency-format
$ cat trace
          <idle>-0     [000] 16490053398357: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=bash next_pid=31128 next_prio=120
           sleep-31128 [000] 16490053588518: sched_switch: prev_comm=bash prev_pid=31128 prev_prio=120 prev_state=S ==> next_comm=swapper next_pid=0 next_prio=120
  ...
echo 1 > options/latency-format
$ cat trace
  <idle>-0       0 91557653238+: sched_switch: prev_comm=swapper prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=bash next_pid=31128 next_prio=120
   sleep-31128   0 91557843399+: sched_switch: prev_comm=bash prev_pid=31128 prev_prio=120 prev_state=S ==> next_comm=swapper next_pid=0 next_prio=120
  ...

v2:
Move arch-specific bits out of generic code.
v4:
Fix x86_32 build due to 64-bit division.

Google-Bug-Id: 6980623
Signed-off-by: David Sharp <dhsharp@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 arch/x86/include/asm/trace_clock.h |    2 +-
 include/linux/ftrace_event.h       |    6 +++
 kernel/trace/trace.c               |   15 +++++-
 kernel/trace/trace.h               |    4 --
 kernel/trace/trace_output.c        |   84 +++++++++++++++++++++++++-----------
 5 files changed, 78 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/trace_clock.h b/arch/x86/include/asm/trace_clock.h
index 7ee0d8c..45e17f5 100644
--- a/arch/x86/include/asm/trace_clock.h
+++ b/arch/x86/include/asm/trace_clock.h
@@ -9,7 +9,7 @@
 extern u64 notrace trace_clock_x86_tsc(void);
 
 # define ARCH_TRACE_CLOCKS \
-	{ trace_clock_x86_tsc,	"x86-tsc" },
+	{ trace_clock_x86_tsc,	"x86-tsc",	.in_ns = 0 },
 
 #endif
 
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 642928c..c760670 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -86,6 +86,12 @@ struct trace_iterator {
 	cpumask_var_t		started;
 };
 
+enum trace_iter_flags {
+	TRACE_FILE_LAT_FMT	= 1,
+	TRACE_FILE_ANNOTATE	= 2,
+	TRACE_FILE_TIME_IN_NS	= 4,
+};
+
 
 struct trace_event;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4e26df3..cff3427 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -476,10 +476,11 @@ static const char *trace_options[] = {
 static struct {
 	u64 (*func)(void);
 	const char *name;
+	int in_ns;		/* is this clock in nanoseconds? */
 } trace_clocks[] = {
-	{ trace_clock_local,	"local" },
-	{ trace_clock_global,	"global" },
-	{ trace_clock_counter,	"counter" },
+	{ trace_clock_local,	"local",	1 },
+	{ trace_clock_global,	"global",	1 },
+	{ trace_clock_counter,	"counter",	0 },
 	ARCH_TRACE_CLOCKS
 };
 
@@ -2425,6 +2426,10 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (ring_buffer_overruns(iter->tr->buffer))
 		iter->iter_flags |= TRACE_FILE_ANNOTATE;
 
+	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
+	if (trace_clocks[trace_clock_id].in_ns)
+		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
+
 	/* stop the trace while dumping */
 	tracing_stop();
 
@@ -3324,6 +3329,10 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 	if (trace_flags & TRACE_ITER_LATENCY_FMT)
 		iter->iter_flags |= TRACE_FILE_LAT_FMT;
 
+	/* Output in nanoseconds only if we are using a clock in nanoseconds. */
+	if (trace_clocks[trace_clock_id].in_ns)
+		iter->iter_flags |= TRACE_FILE_TIME_IN_NS;
+
 	iter->cpu_file = cpu_file;
 	iter->tr = &global_trace;
 	mutex_init(&iter->mutex);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 55e1f7f..84fefed 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -409,10 +409,6 @@ void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
-enum trace_file_type {
-	TRACE_FILE_LAT_FMT	= 1,
-	TRACE_FILE_ANNOTATE	= 2,
-};
 
 extern cpumask_var_t __read_mostly tracing_buffer_mask;
 
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 123b189..a759896 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -610,24 +610,60 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 	return trace_print_lat_fmt(s, entry);
 }
 
-static unsigned long preempt_mark_thresh = 100;
+static unsigned long preempt_mark_thresh_us = 100;
+/* roughly the same at 2.0GHz: */
+static unsigned long preempt_mark_thresh_cycles = 200000;
 
 static int
-lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
-		    unsigned long rel_usecs)
+lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
 {
-	return trace_seq_printf(s, " %4lldus%c: ", abs_usecs,
-				rel_usecs > preempt_mark_thresh ? '!' :
-				  rel_usecs > 1 ? '+' : ' ');
+	unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
+	unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
+	unsigned long long abs_ts = iter->ts - iter->tr->time_start;
+	unsigned long long rel_ts = next_ts - iter->ts;
+	struct trace_seq *s = &iter->seq;
+	unsigned long mark_thresh;
+	int ret;
+
+	if (in_ns) {
+		abs_ts = ns2usecs(abs_ts);
+		rel_ts = ns2usecs(rel_ts);
+		mark_thresh = preempt_mark_thresh_us;
+	} else
+		mark_thresh = preempt_mark_thresh_cycles;
+
+	if (verbose && in_ns) {
+		unsigned long abs_msec = abs_ts;
+		unsigned long abs_usec = do_div(abs_msec, USEC_PER_MSEC);
+		unsigned long rel_msec = rel_ts;
+		unsigned long rel_usec = do_div(rel_msec, USEC_PER_MSEC);
+
+		ret = trace_seq_printf(
+				s, "[%08llx] %ld.%03ldms (+%ld.%03ldms): ",
+				ns2usecs(iter->ts),
+				abs_msec, abs_usec,
+				rel_msec, rel_usec);
+	} else if (verbose && !in_ns) {
+		ret = trace_seq_printf(
+				s, "[%016llx] %lld (+%lld): ",
+				iter->ts, abs_ts, rel_ts);
+	} else { /* !verbose */
+		ret = trace_seq_printf(
+				s, " %4lld%s%c: ",
+				abs_ts,
+				in_ns ? "us" : "",
+				rel_ts > mark_thresh ? '!' :
+				  rel_ts > 1 ? '+' : ' ');
+	}
+	return ret;
 }
 
 int trace_print_context(struct trace_iterator *iter)
 {
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *entry = iter->ent;
-	unsigned long long t = ns2usecs(iter->ts);
-	unsigned long usec_rem = do_div(t, USEC_PER_SEC);
-	unsigned long secs = (unsigned long)t;
+	unsigned long long t;
+	unsigned long secs, usec_rem;
 	char comm[TASK_COMM_LEN];
 	int ret;
 
@@ -644,8 +680,13 @@ int trace_print_context(struct trace_iterator *iter)
 			return 0;
 	}
 
-	return trace_seq_printf(s, " %5lu.%06lu: ",
-				secs, usec_rem);
+	if (iter->iter_flags & TRACE_FILE_TIME_IN_NS) {
+		t = ns2usecs(iter->ts);
+		usec_rem = do_div(t, USEC_PER_SEC);
+		secs = (unsigned long)t;
+		return trace_seq_printf(s, "%5lu.%06lu: ", secs, usec_rem);
+	} else
+		return trace_seq_printf(s, "%12llu: ", iter->ts);
 }
 
 int trace_print_lat_context(struct trace_iterator *iter)
@@ -659,36 +700,29 @@ int trace_print_lat_context(struct trace_iterator *iter)
 			   *next_entry = trace_find_next_entry(iter, NULL,
 							       &next_ts);
 	unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
-	unsigned long abs_usecs = ns2usecs(iter->ts - iter->tr->time_start);
-	unsigned long rel_usecs;
 
 	/* Restore the original ent_size */
 	iter->ent_size = ent_size;
 
 	if (!next_entry)
 		next_ts = iter->ts;
-	rel_usecs = ns2usecs(next_ts - iter->ts);
 
 	if (verbose) {
 		char comm[TASK_COMM_LEN];
 
 		trace_find_cmdline(entry->pid, comm);
 
-		ret = trace_seq_printf(s, "%16s %5d %3d %d %08x %08lx [%08llx]"
-				       " %ld.%03ldms (+%ld.%03ldms): ", comm,
-				       entry->pid, iter->cpu, entry->flags,
-				       entry->preempt_count, iter->idx,
-				       ns2usecs(iter->ts),
-				       abs_usecs / USEC_PER_MSEC,
-				       abs_usecs % USEC_PER_MSEC,
-				       rel_usecs / USEC_PER_MSEC,
-				       rel_usecs % USEC_PER_MSEC);
+		ret = trace_seq_printf(
+				s, "%16s %5d %3d %d %08x %08lx ",
+				comm, entry->pid, iter->cpu, entry->flags,
+				entry->preempt_count, iter->idx);
 	} else {
 		ret = lat_print_generic(s, entry, iter->cpu);
-		if (ret)
-			ret = lat_print_timestamp(s, abs_usecs, rel_usecs);
 	}
 
+	if (ret)
+		ret = lat_print_timestamp(iter, next_ts);
+
 	return ret;
 }
 
-- 
1.7.7.3

