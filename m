Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab2C1VMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:12:10 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35175 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2C1VMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:12:08 -0400
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: David Sharp <dhsharp@google.com>, Justin Teravest <teravest@google.com>,
        Laurent Chavey <chavey@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Michael Davidson <md@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 2/6] trace: add support for 32 bit compat syscalls on x86_64
Date: Wed, 28 Mar 2012 14:11:50 -0700
Message-Id: <1332969110-12262-1-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAL26m8JfVekNQC75dSmH+JDFwATdGYjyV-GBx+KrbCSeW-6V2Q@mail.gmail.com>
References: <CAL26m8JfVekNQC75dSmH+JDFwATdGYjyV-GBx+KrbCSeW-6V2Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Davidson <md@google.com>

Add support for a set of events to trace 32 bit compat system calls
in addition to the native 64 bit system calls.

Events for compat system calls have event names of the form:
  syscalls:sys_enter_compat_<name>
  syscalls:sys_exit_compat_<name>

The ascii formatted version of trace events that can be read from
the tracing/trace file reports compat system calls as:
  compat_<name>(...)

- add CONFIG_FTRACE_COMPAT_SYSCALLS

- add a "compat" flag to the syscall_metadata struct so that we can
  distinguish between "native" and "compat" metadata at init time
  when building the system call # to metadata mapping tables

- add a COMPAT_SYSCALL_METADATAx() macro to define system call
  metadata for compat system calls

- modify syscall_nr_to_meta() to know about compat system calls
  and return a pointer to the correct metadata

- modify print_syscall_{enter|exit}() to find the system call metadata
  by looking in the containing ftrace_event_call struct

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
Changelog:
* Remove unmaintainable list of syscalls and use SYSCALL_DEFINEx macro
  to define the metadata for equivalent compat syscall

 arch/x86/ia32/Makefile                |    2 +
 arch/x86/ia32/ia32_syscall_metadata.c |   84 +++++++++++++++++++++++++++++++++
 include/linux/syscalls.h              |   17 ++++++-
 include/trace/syscall.h               |   23 ++++++++-
 kernel/trace/Kconfig                  |    6 ++
 kernel/trace/trace_syscalls.c         |   20 ++++++--
 6 files changed, 142 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/ia32/ia32_syscall_metadata.c

diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 455646e..ba6d3c8 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -12,3 +12,5 @@ obj-$(CONFIG_IA32_AOUT) += ia32_aout.o
 
 audit-class-$(CONFIG_AUDIT) := audit.o
 obj-$(CONFIG_IA32_EMULATION) += $(audit-class-y)
+
+obj-$(CONFIG_FTRACE_COMPAT_SYSCALLS) += ia32_syscall_metadata.o
diff --git a/arch/x86/ia32/ia32_syscall_metadata.c b/arch/x86/ia32/ia32_syscall_metadata.c
new file mode 100644
index 0000000..f3f554a
--- /dev/null
+++ b/arch/x86/ia32/ia32_syscall_metadata.c
@@ -0,0 +1,84 @@
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/module.h>
+#include <asm/asm-offsets.h>
+
+extern long ia32_sys_call_table[];
+
+int nr_compat_syscalls;
+struct syscall_metadata **compat_syscalls_metadata;
+
+static const char *prefixes[] = { "sys32", "stub32", "compat_sys",
+					"sys", NULL };
+
+/*
+ * For each entry in the 32 bit system call table:
+ *	Look up the address in the kernel symbol table
+ *	Strip off any "sys32|stub32|sys|compat" prefix
+ *	Search through all of the compat metadata entries for a matching name
+ */
+static struct syscall_metadata __init *
+find_compat_syscall_meta(unsigned long addr)
+{
+	struct syscall_metadata **start;
+	struct syscall_metadata **stop;
+	char str[KSYM_SYMBOL_LEN];
+	const char *name;
+	const char **p;
+	extern struct syscall_metadata *__start_syscalls_metadata[];
+	extern struct syscall_metadata *__stop_syscalls_metadata[];
+
+	start = __start_syscalls_metadata;
+	stop = __stop_syscalls_metadata;
+	kallsyms_lookup(addr, NULL, NULL, NULL, str);
+
+	/*
+	 * If there is a {sys|compat|sys32|stub32} prefix strip it off
+	 */
+	for (p = prefixes, name = str; *p; p++) {
+		int len = strlen(*p);
+		if (strncmp(name, *p, len) == 0) {
+			name += len;
+			break;
+		}
+	}
+
+	for ( ; start < stop; start++) {
+		if (!(*start)->compat)
+			continue;
+
+		/*
+		 * ignore the "compat_" prefix on the metadata name
+		 * when doing the comparison
+		 */
+		if ((*start)->name && !strcmp((*start)->name + 6, name))
+			return *start;
+	}
+	return NULL;
+}
+
+static int __init init_compat_syscall_metadata(void)
+{
+	struct syscall_metadata *meta;
+	int	i;
+
+	nr_compat_syscalls = __NR_ia32_syscall_max;
+	compat_syscalls_metadata = kzalloc(sizeof(*compat_syscalls_metadata) *
+					nr_compat_syscalls, GFP_KERNEL);
+	if (!compat_syscalls_metadata) {
+		nr_compat_syscalls = -1;
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_compat_syscalls; i++) {
+		if ((meta = find_compat_syscall_meta(ia32_sys_call_table[i]))) {
+			meta->syscall_nr = i;
+			compat_syscalls_metadata[i] = meta;
+		}
+	}
+
+	return 0;
+}
+
+core_initcall(init_compat_syscall_metadata);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ed0003c..f2e4106 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -159,7 +159,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	  __attribute__((section("_ftrace_events")))			\
 	*__event_exit_##sname = &event_exit_##sname;
 
-#define SYSCALL_METADATAx(x, sname, ...)			\
+#define _SYSCALL_METADATAx(x, mname, sname, _compat, ...)	\
 	static const char *types_##sname[] = {			\
 		__SC_STR_TDECL##x(__VA_ARGS__)			\
 	};							\
@@ -170,11 +170,12 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
 	  __syscall_meta_##sname = {				\
-		.name 		= "sys"#sname,			\
+		.name 		= mname,			\
 		.syscall_nr	= -1,	/* Filled in at boot */	\
 		.nb_args 	= x,				\
 		.types		= types_##sname,		\
 		.args		= args_##sname,			\
+		.compat		= _compat,			\
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
@@ -182,10 +183,21 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	static struct syscall_metadata __used			\
 	  __attribute__((section("__syscalls_metadata")))	\
 	 *__p_syscall_meta_##sname = &__syscall_meta_##sname;
+
+#define SYSCALL_METADATAx(x, sname, ...)		\
+	_SYSCALL_METADATAx(x, "sys"#sname, sname, 0, __VA_ARGS__)
+
 #else
 #define SYSCALL_METADATAx(x, name, ...)
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
+#if defined(CONFIG_FTRACE_COMPAT_SYSCALLS)
+#define COMPAT_SYSCALL_METADATAx(x, sname, ...)			\
+	_SYSCALL_METADATAx(x, "compat_"#sname, compat_##sname, 1, __VA_ARGS__)
+#else
+#define COMPAT_SYSCALL_METADATAx(x, sname, ...)
+#endif /* CONFIG_FTRACE_COMPAT_SYSCALLS */
+
 #define SYSCALL_DEFINE0(name, ...) SYSCALL_DEFINEx(0, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
 #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
@@ -210,6 +222,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_DEFINEx(x, sname, ...)				\
 	SYSCALL_METADATAx(x, sname, __VA_ARGS__)			\
+	COMPAT_SYSCALL_METADATAx(x, sname, __VA_ARGS__)			\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 31966a4..29169e6 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -21,8 +21,9 @@
  */
 struct syscall_metadata {
 	const char	*name;
-	int		syscall_nr;
-	int		nb_args;
+	u16		syscall_nr;
+	u8		nb_args;
+	u8		compat;
 	const char	**types;
 	const char	**args;
 	struct list_head enter_fields;
@@ -32,6 +33,24 @@ struct syscall_metadata {
 };
 
 #ifdef CONFIG_FTRACE_SYSCALLS
+
+#ifdef CONFIG_FTRACE_COMPAT_SYSCALLS
+
+extern int nr_compat_syscalls;
+extern struct syscall_metadata **compat_syscalls_metadata;
+
+static inline struct syscall_metadata *compat_syscall_nr_to_meta(int nr)
+{
+	return (nr < nr_compat_syscalls) ? compat_syscalls_metadata[nr]
+						  : NULL;
+}
+#else
+static inline struct syscall_metadata *compat_syscall_nr_to_meta(int nr)
+{
+	return NULL;
+}
+#endif /* CONFIG_FTRACE_COMPAT_SYSCALLS */
+
 extern unsigned long arch_syscall_addr(int nr);
 extern int init_syscall_trace(struct ftrace_event_call *call);
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cd31345..cd0954b 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -240,6 +240,12 @@ config FTRACE_SYSCALLS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
+config FTRACE_COMPAT_SYSCALLS
+	bool "Trace 32 bit compat syscalls"
+	depends on FTRACE_SYSCALLS
+	help
+	  Trace syscall entry and exit events for 32 bit compat syscalls.
+
 config TRACE_BRANCH_PROFILING
 	bool
 	select GENERIC_TRACER
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cb65454..8bc89c5 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>	/* for MODULE_NAME_LEN via KSYM_SYMBOL_LEN */
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
+#include <linux/compat.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
@@ -90,6 +91,8 @@ find_syscall_meta(unsigned long syscall)
 		return NULL;
 
 	for ( ; start < stop; start++) {
+		if ((*start)->compat)	/* skip compat syscalls */
+			continue;
 		if ((*start)->name && arch_syscall_match_sym_name(str, (*start)->name))
 			return *start;
 	}
@@ -98,6 +101,8 @@ find_syscall_meta(unsigned long syscall)
 
 static struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
+	if (is_compat_task())
+		return compat_syscall_nr_to_meta(nr);
 	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;
 
@@ -112,11 +117,13 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 	struct trace_entry *ent = iter->ent;
 	struct syscall_trace_enter *trace;
 	struct syscall_metadata *entry;
-	int i, ret, syscall;
+	int i, ret;
+	struct ftrace_event_call *call;
 
 	trace = (typeof(trace))ent;
-	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	event = ftrace_find_event(ent->type);
+	call = container_of(event, struct ftrace_event_call, event);
+	entry = call->data;
 
 	if (!entry)
 		goto end;
@@ -164,13 +171,14 @@ print_syscall_exit(struct trace_iterator *iter, int flags,
 	struct trace_seq *s = &iter->seq;
 	struct trace_entry *ent = iter->ent;
 	struct syscall_trace_exit *trace;
-	int syscall;
 	struct syscall_metadata *entry;
 	int ret;
+	struct ftrace_event_call *call;
 
 	trace = (typeof(trace))ent;
-	syscall = trace->nr;
-	entry = syscall_nr_to_meta(syscall);
+	event = ftrace_find_event(ent->type);
+	call = container_of(event, struct ftrace_event_call, event);
+	entry = call->data;
 
 	if (!entry) {
 		trace_seq_printf(s, "\n");
-- 
1.7.7.3

