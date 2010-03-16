Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938078Ab0CPRq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 13:46:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938068Ab0CPRq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 13:46:57 -0400
Date: Tue, 16 Mar 2010 13:46:36 -0400
From: Jason Baron <jbaron@redhat.com>
To: fweisbec@gmail.com, mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       hpa@zytor.com, tglx@linutronix.de, mhiramat@redhat.com,
       heiko.carstens@de.ibm.com, benh@kernel.crashing.org,
       davem@davemloft.net, lethal@linux-sh.org, schwidefsky@de.ibm.com,
       brueckner@linux.vnet.ibm.com, tony.luck@intel.com
Message-Id: <a75e730f4fc49c3657d6e407fb16a3508ec321a9.1268749695.git.jbaron@redhat.com>
In-Reply-To: <cover.1268749695.git.jbaron@redhat.com>
References: <cover.1268749695.git.jbaron@redhat.com>
Subject: [PATCH 06/14] tracing: add tracing support for compat syscalls
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add core support to event tracing for compat syscalls. The basic idea is that we
check if we have a compat task via 'is_compat_task()'. If so, we lookup in the
new compat_syscalls_metadata table, the corresponding struct syscall_metadata, to
check syscall arguments and whether or not we are enabled.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/compat.h        |    2 +
 include/trace/syscall.h       |    4 ++
 kernel/trace/trace.h          |    2 +
 kernel/trace/trace_syscalls.c |   86 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 86 insertions(+), 8 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 2fca741..5f2600f 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -355,6 +355,8 @@ asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
 
 #else /* CONFIG_COMPAT */
 
+#define NR_syscalls_compat 0
+
 static inline int is_compat_task(void)
 {
 	return 0;
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 8f5ac38..1cc1d1e 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -22,6 +22,7 @@
 struct syscall_metadata {
 	const char	*name;
 	int		syscall_nr;
+	int		compat_syscall_nr;
 	int		nb_args;
 	const char	**types;
 	const char	**args;
@@ -36,6 +37,9 @@ struct syscall_metadata {
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 extern unsigned long arch_syscall_addr(int nr);
+#ifdef CONFIG_COMPAT
+extern unsigned long arch_compat_syscall_addr(int nr);
+#endif
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
 extern int syscall_enter_define_fields(struct ftrace_event_call *call);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index fd05bca..2992ee1 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -94,12 +94,14 @@ extern struct tracer boot_tracer;
 struct syscall_trace_enter {
 	struct trace_entry	ent;
 	int			nr;
+	int			compat;
 	unsigned long		args[];
 };
 
 struct syscall_trace_exit {
 	struct trace_entry	ent;
 	int			nr;
+	int			compat;
 	long			ret;
 };
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 9cb814b..3f88b8e 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -3,6 +3,7 @@
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
+#include <linux/compat.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
@@ -16,6 +17,7 @@ extern unsigned long __start_syscalls_metadata[];
 extern unsigned long __stop_syscalls_metadata[];
 
 static struct syscall_metadata **syscalls_metadata;
+static struct syscall_metadata **compat_syscalls_metadata;
 
 static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 {
@@ -41,8 +43,14 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 	return NULL;
 }
 
-static struct syscall_metadata *syscall_nr_to_meta(int nr)
+static struct syscall_metadata *syscall_nr_to_meta(int nr, int compat)
 {
+	if (compat) {
+		if (!compat_syscalls_metadata || nr >= NR_syscalls_compat ||
+									nr < 0)
+			return NULL;
+		return compat_syscalls_metadata[nr];
+	}
 	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
 
@@ -60,7 +68,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags)
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	entry = syscall_nr_to_meta(syscall, trace->compat);
 
 	if (!entry)
 		goto end;
@@ -113,7 +121,7 @@ print_syscall_exit(struct trace_iterator *iter, int flags)
 
 	trace = (typeof(trace))ent;
 	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	entry = syscall_nr_to_meta(syscall, trace->compat);
 
 	if (!entry) {
 		trace_seq_printf(s, "\n");
@@ -248,12 +256,16 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 	struct ring_buffer *buffer;
 	int size;
 	int syscall_nr;
+	int compat = 0;
 
 	syscall_nr = syscall_get_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (is_compat_task())
+		compat = 1;
+
+	sys_data = syscall_nr_to_meta(syscall_nr, compat);
 	if (!sys_data)
 		return;
 
@@ -269,6 +281,7 @@ void ftrace_syscall_enter(struct pt_regs *regs, long id)
 
 	entry = ring_buffer_event_data(event);
 	entry->nr = syscall_nr;
+	entry->compat = compat;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args, entry->args);
 
 	if (!filter_current_check_discard(buffer, sys_data->enter_event,
@@ -283,12 +296,16 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
 	int syscall_nr;
+	int compat = 0;
 
 	syscall_nr = syscall_get_nr(current, regs);
 	if (syscall_nr < 0)
 		return;
 
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (is_compat_task())
+		compat = 1;
+
+	sys_data = syscall_nr_to_meta(syscall_nr, compat);
 	if (!sys_data)
 		return;
 
@@ -302,6 +319,7 @@ void ftrace_syscall_exit(struct pt_regs *regs, long ret)
 
 	entry = ring_buffer_event_data(event);
 	entry->nr = syscall_nr;
+	entry->compat = compat;
 	entry->ret = syscall_get_return_value(current, regs);
 
 	if (!filter_current_check_discard(buffer, sys_data->exit_event,
@@ -421,7 +439,49 @@ int __init init_ftrace_syscalls(void)
 		meta->syscall_nr = i;
 		syscalls_metadata[i] = meta;
 	}
-
+#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
+	if (NR_syscalls_compat) {
+		int match;
+		struct ftrace_event_call *ftrace_event;
+
+		compat_syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
+						NR_syscalls_compat, GFP_KERNEL);
+		if (!compat_syscalls_metadata) {
+			WARN_ON(1);
+			kfree(syscalls_metadata);
+			return -ENOMEM;
+		}
+		for (i = 0; i < NR_syscalls_compat; i++) {
+			addr = arch_compat_syscall_addr(i);
+			meta = find_syscall_meta(addr);
+			if (!meta)
+				continue;
+
+			meta->compat_syscall_nr = i;
+			compat_syscalls_metadata[i] = meta;
+		}
+		/* now check if any compat_syscalls are not referenced */
+		for (ftrace_event = __start_ftrace_events;
+			(unsigned long)ftrace_event <
+			(unsigned long)__stop_ftrace_events; ftrace_event++) {
+
+			match = 0;
+			if (!ftrace_event->name)
+				continue;
+			if (strcmp(ftrace_event->system, "compat_syscalls"))
+				continue;
+			for (i = 0; i < NR_syscalls_compat; i++) {
+				if (ftrace_event->data ==
+						compat_syscalls_metadata[i]) {
+					match = 1;
+					break;
+				}
+			}
+			if (!match)
+				ftrace_event->name = NULL;
+		}
+	}
+#endif
 	return 0;
 }
 core_initcall(init_ftrace_syscalls);
@@ -439,9 +499,13 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 	int syscall_nr;
 	int rctx;
 	int size;
+	int compat = 0;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (is_compat_task())
+		compat = 1;
+
+	sys_data = syscall_nr_to_meta(syscall_nr, compat);
 	if (!sys_data)
 		return;
 
@@ -463,6 +527,7 @@ static void prof_syscall_enter(struct pt_regs *regs, long id)
 		return;
 
 	rec->nr = syscall_nr;
+	rec->compat = compat;
 	syscall_get_arguments(current, regs, 0, sys_data->nb_args,
 			       (unsigned long *)&rec->args);
 	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
@@ -511,9 +576,13 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 	int syscall_nr;
 	int rctx;
 	int size;
+	int compat = 0;
 
 	syscall_nr = syscall_get_nr(current, regs);
-	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (is_compat_task())
+		compat = 1;
+
+	sys_data = syscall_nr_to_meta(syscall_nr, compat);
 	if (!sys_data)
 		return;
 
@@ -538,6 +607,7 @@ static void prof_syscall_exit(struct pt_regs *regs, long ret)
 		return;
 
 	rec->nr = syscall_nr;
+	rec->compat = compat;
 	rec->ret = syscall_get_return_value(current, regs);
 
 	ftrace_perf_buf_submit(rec, size, rctx, 0, 1, flags);
-- 
1.6.5.1

