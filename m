Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724Ab0HEOjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:39:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:41220 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676Ab0HEOix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:53 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 11/17] ftrace,kdb: Extend kdb to be able to dump the ftrace buffer
Date: Thu,  5 Aug 2010 09:37:52 -0500
Message-Id: <1281019078-6636-12-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-11-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-11-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:20.0027 (UTC) FILETIME=[D951F4B0:01CB34AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in a helper function to allow the kdb shell to dump the ftrace
buffer.

Modify trace.c to expose the capability to iterate over the ftrace
buffer in a read only capacity.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/Makefile    |    3 +
 kernel/trace/trace.c     |   43 +++++++++--------
 kernel/trace/trace.h     |   19 +++++++
 kernel/trace/trace_kdb.c |  119 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 163 insertions(+), 21 deletions(-)
 create mode 100644 kernel/trace/trace_kdb.c

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index ffb1a5b..4215530 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -57,5 +57,8 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+ifeq ($(CONFIG_TRACING),y)
+obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
+endif
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 086d363..d6736b9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -101,10 +101,7 @@ static inline void ftrace_enable_cpu(void)
 	preempt_enable();
 }
 
-static cpumask_var_t __read_mostly	tracing_buffer_mask;
-
-#define for_each_tracing_cpu(cpu)	\
-	for_each_cpu(cpu, tracing_buffer_mask)
+cpumask_var_t __read_mostly	tracing_buffer_mask;
 
 /*
  * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
@@ -1539,11 +1536,6 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
-enum trace_file_type {
-	TRACE_FILE_LAT_FMT	= 1,
-	TRACE_FILE_ANNOTATE	= 2,
-};
-
 static void trace_iterator_increment(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
@@ -1641,7 +1633,7 @@ struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
-static void *find_next_entry_inc(struct trace_iterator *iter)
+void *trace_find_next_entry_inc(struct trace_iterator *iter)
 {
 	iter->ent = __find_next_entry(iter, &iter->cpu,
 				      &iter->lost_events, &iter->ts);
@@ -1676,19 +1668,19 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 		return NULL;
 
 	if (iter->idx < 0)
-		ent = find_next_entry_inc(iter);
+		ent = trace_find_next_entry_inc(iter);
 	else
 		ent = iter;
 
 	while (ent && iter->idx < i)
-		ent = find_next_entry_inc(iter);
+		ent = trace_find_next_entry_inc(iter);
 
 	iter->pos = *pos;
 
 	return ent;
 }
 
-static void tracing_iter_reset(struct trace_iterator *iter, int cpu)
+void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 {
 	struct trace_array *tr = iter->tr;
 	struct ring_buffer_event *event;
@@ -2049,7 +2041,7 @@ int trace_empty(struct trace_iterator *iter)
 }
 
 /*  Called with trace_event_read_lock() held. */
-static enum print_line_t print_trace_line(struct trace_iterator *iter)
+enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
@@ -3211,7 +3203,7 @@ waitagain:
 
 	trace_event_read_lock();
 	trace_access_lock(iter->cpu_file);
-	while (find_next_entry_inc(iter) != NULL) {
+	while (trace_find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
 
@@ -3294,7 +3286,7 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 		rem -= count;
-		if (!find_next_entry_inc(iter))	{
+		if (!trace_find_next_entry_inc(iter))	{
 			rem = 0;
 			iter->ent = NULL;
 			break;
@@ -3350,7 +3342,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 	if (ret <= 0)
 		goto out_err;
 
-	if (!iter->ent && !find_next_entry_inc(iter)) {
+	if (!iter->ent && !trace_find_next_entry_inc(iter)) {
 		ret = -EFAULT;
 		goto out_err;
 	}
@@ -4414,7 +4406,7 @@ static struct notifier_block trace_die_notifier = {
  */
 #define KERN_TRACE		KERN_EMERG
 
-static void
+void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
@@ -4429,6 +4421,13 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_init(s);
 }
 
+void trace_init_global_iter(struct trace_iterator *iter)
+{
+	iter->tr = &global_trace;
+	iter->trace = current_trace;
+	iter->cpu_file = TRACE_PIPE_ALL_CPU;
+}
+
 static void
 __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 {
@@ -4454,8 +4453,10 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 	if (disable_tracing)
 		ftrace_kill();
 
+	trace_init_global_iter(&iter);
+
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&global_trace.data[cpu]->disabled);
+		atomic_inc(&iter.tr->data[cpu]->disabled);
 	}
 
 	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
@@ -4504,7 +4505,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		iter.iter_flags |= TRACE_FILE_LAT_FMT;
 		iter.pos = -1;
 
-		if (find_next_entry_inc(&iter) != NULL) {
+		if (trace_find_next_entry_inc(&iter) != NULL) {
 			int ret;
 
 			ret = print_trace_line(&iter);
@@ -4526,7 +4527,7 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		trace_flags |= old_userobj;
 
 		for_each_tracing_cpu(cpu) {
-			atomic_dec(&global_trace.data[cpu]->disabled);
+			atomic_dec(&iter.tr->data[cpu]->disabled);
 		}
 		tracing_on();
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2cd9639..0605fc0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -338,6 +338,14 @@ struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts);
 
+int trace_empty(struct trace_iterator *iter);
+
+void *trace_find_next_entry_inc(struct trace_iterator *iter);
+
+void trace_init_global_iter(struct trace_iterator *iter);
+
+void tracing_iter_reset(struct trace_iterator *iter, int cpu);
+
 void default_wait_pipe(struct trace_iterator *iter);
 void poll_wait_pipe(struct trace_iterator *iter);
 
@@ -380,6 +388,15 @@ void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
+enum trace_file_type {
+	TRACE_FILE_LAT_FMT	= 1,
+	TRACE_FILE_ANNOTATE	= 2,
+};
+
+extern cpumask_var_t __read_mostly tracing_buffer_mask;
+
+#define for_each_tracing_cpu(cpu)	\
+	for_each_cpu(cpu, tracing_buffer_mask)
 
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
@@ -471,6 +488,8 @@ trace_array_vprintk(struct trace_array *tr,
 		    unsigned long ip, const char *fmt, va_list args);
 int trace_array_printk(struct trace_array *tr,
 		       unsigned long ip, const char *fmt, ...);
+void trace_printk_seq(struct trace_seq *s);
+enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
new file mode 100644
index 0000000..44cbda2
--- /dev/null
+++ b/kernel/trace/trace_kdb.c
@@ -0,0 +1,119 @@
+/*
+ * kdb helper for dumping the ftrace buffer
+ *
+ * Copyright (C) 2010 Jason Wessel <jason.wessel@windriver.com>
+ *
+ * ftrace_dump_buf based on ftrace_dump:
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
+ *
+ */
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/kdb.h>
+#include <linux/ftrace.h>
+
+#include "../debug/kdb/kdb_private.h"
+#include "trace.h"
+#include "trace_output.h"
+
+static void ftrace_dump_buf(int skip_lines)
+{
+	/* use static because iter can be a bit big for the stack */
+	static struct trace_iterator iter;
+	unsigned int old_userobj;
+	int cnt = 0, cpu;
+
+	trace_init_global_iter(&iter);
+
+	for_each_tracing_cpu(cpu) {
+		atomic_inc(&iter.tr->data[cpu]->disabled);
+	}
+
+	old_userobj = trace_flags;
+
+	/* don't look at user memory in panic mode */
+	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+
+	kdb_printf("Dumping ftrace buffer:\n");
+
+	/* reset all but tr, trace, and overruns */
+	memset(&iter.seq, 0,
+		   sizeof(struct trace_iterator) -
+		   offsetof(struct trace_iterator, seq));
+	iter.iter_flags |= TRACE_FILE_LAT_FMT;
+	iter.pos = -1;
+
+	for_each_tracing_cpu(cpu) {
+		iter.buffer_iter[cpu] =
+			ring_buffer_read_prepare(iter.tr->buffer, cpu);
+		ring_buffer_read_start(iter.buffer_iter[cpu]);
+		tracing_iter_reset(&iter, cpu);
+	}
+
+	if (!trace_empty(&iter))
+		trace_find_next_entry_inc(&iter);
+	while (!trace_empty(&iter)) {
+		if (!cnt)
+			kdb_printf("---------------------------------\n");
+		cnt++;
+
+		if (trace_find_next_entry_inc(&iter) != NULL && !skip_lines)
+			print_trace_line(&iter);
+		if (!skip_lines)
+			trace_printk_seq(&iter.seq);
+		else
+			skip_lines--;
+		if (KDB_FLAG(CMD_INTERRUPT))
+			goto out;
+	}
+
+	if (!cnt)
+		kdb_printf("   (ftrace buffer empty)\n");
+	else
+		kdb_printf("---------------------------------\n");
+
+out:
+	trace_flags = old_userobj;
+
+	for_each_tracing_cpu(cpu) {
+		atomic_dec(&iter.tr->data[cpu]->disabled);
+	}
+
+	for_each_tracing_cpu(cpu)
+		if (iter.buffer_iter[cpu])
+			ring_buffer_read_finish(iter.buffer_iter[cpu]);
+}
+
+/*
+ * kdb_ftdump - Dump the ftrace log buffer
+ */
+static int kdb_ftdump(int argc, const char **argv)
+{
+	int skip_lines = 0;
+	char *cp;
+
+	if (argc > 1)
+		return KDB_ARGCOUNT;
+
+	if (argc) {
+		skip_lines = simple_strtol(argv[1], &cp, 0);
+		if (*cp)
+			skip_lines = 0;
+	}
+
+	kdb_trap_printk++;
+	ftrace_dump_buf(skip_lines);
+	kdb_trap_printk--;
+
+	return 0;
+}
+
+static __init int kdb_ftrace_register(void)
+{
+	kdb_register_repeat("ftdump", kdb_ftdump, "", "Dump ftrace log",
+			    0, KDB_REPEAT_NONE);
+	return 0;
+}
+
+late_initcall(kdb_ftrace_register);
-- 
1.6.3.3

