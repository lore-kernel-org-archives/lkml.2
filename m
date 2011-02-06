Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab1BFL12 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 06:27:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab1BFL11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 06:27:27 -0500
Date: Sun, 6 Feb 2011 12:27:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110206112705.GA26961@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf stat: Fix aggreate counter reading accounting

Mathieu Desnoyers (1):
      tracepoints: Fix section alignment using pointer array

Steven Rostedt (2):
      tracing: Replace trace_event struct array with pointer array
      tracing: Replace syscall_meta_data struct array with pointer array


 include/asm-generic/vmlinux.lds.h |   24 ++++++++++++------------
 include/linux/module.h            |    4 ++--
 include/linux/syscalls.h          |   28 +++++++++++++++-------------
 include/linux/tracepoint.h        |   35 ++++++++++++++++++++---------------
 include/trace/ftrace.h            |   24 +++++++++++++-----------
 kernel/module.c                   |   16 ++++++++--------
 kernel/trace/trace_events.c       |   12 ++++++------
 kernel/trace/trace_export.c       |    6 +++---
 kernel/trace/trace_syscalls.c     |   19 ++++++++++---------
 kernel/tracepoint.c               |   31 ++++++++++++++++---------------
 tools/perf/util/evsel.c           |    2 +-
 11 files changed, 106 insertions(+), 95 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 6ebb810..fe77e33 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -124,7 +124,8 @@
 #endif
 
 #ifdef CONFIG_EVENT_TRACING
-#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
+#define FTRACE_EVENTS()	. = ALIGN(8);					\
+			VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
 			*(_ftrace_events)				\
 			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
 #else
@@ -140,7 +141,8 @@
 #endif
 
 #ifdef CONFIG_FTRACE_SYSCALLS
-#define TRACE_SYSCALLS() VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
+#define TRACE_SYSCALLS() . = ALIGN(8);					\
+			 VMLINUX_SYMBOL(__start_syscalls_metadata) = .;	\
 			 *(__syscalls_metadata)				\
 			 VMLINUX_SYMBOL(__stop_syscalls_metadata) = .;
 #else
@@ -165,10 +167,8 @@
 	CPU_KEEP(exit.data)						\
 	MEM_KEEP(init.data)						\
 	MEM_KEEP(exit.data)						\
-	. = ALIGN(32);							\
-	VMLINUX_SYMBOL(__start___tracepoints) = .;			\
+	STRUCT_ALIGN();							\
 	*(__tracepoints)						\
-	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
 	/* implement dynamic printk debug */				\
 	. = ALIGN(8);							\
 	VMLINUX_SYMBOL(__start___verbose) = .;                          \
@@ -176,13 +176,7 @@
 	VMLINUX_SYMBOL(__stop___verbose) = .;				\
 	LIKELY_PROFILE()		       				\
 	BRANCH_PROFILE()						\
-	TRACE_PRINTKS()							\
-									\
-	STRUCT_ALIGN();							\
-	FTRACE_EVENTS()							\
-									\
-	STRUCT_ALIGN();							\
-	TRACE_SYSCALLS()
+	TRACE_PRINTKS()
 
 /*
  * Data section helpers
@@ -220,6 +214,10 @@
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
 		*(__vermagic)		/* Kernel version magic */	\
+		. = ALIGN(8);						\
+		VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;		\
+		*(__tracepoints_ptrs)	/* Tracepoints: pointer array */\
+		VMLINUX_SYMBOL(__stop___tracepoints_ptrs) = .;		\
 		*(__markers_strings)	/* Markers: strings */		\
 		*(__tracepoints_strings)/* Tracepoints: strings */	\
 	}								\
@@ -482,6 +480,8 @@
 	KERNEL_CTORS()							\
 	*(.init.rodata)							\
 	MCOUNT_REC()							\
+	FTRACE_EVENTS()							\
+	TRACE_SYSCALLS()						\
 	DEV_DISCARD(init.rodata)					\
 	CPU_DISCARD(init.rodata)					\
 	MEM_DISCARD(init.rodata)					\
diff --git a/include/linux/module.h b/include/linux/module.h
index e7c6385..9bdf27c 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -377,7 +377,7 @@ struct module
 	   keeping pointers to this stuff */
 	char *args;
 #ifdef CONFIG_TRACEPOINTS
-	struct tracepoint *tracepoints;
+	struct tracepoint * const *tracepoints_ptrs;
 	unsigned int num_tracepoints;
 #endif
 #ifdef HAVE_JUMP_LABEL
@@ -389,7 +389,7 @@ struct module
 	unsigned int num_trace_bprintk_fmt;
 #endif
 #ifdef CONFIG_EVENT_TRACING
-	struct ftrace_event_call *trace_events;
+	struct ftrace_event_call **trace_events;
 	unsigned int num_trace_events;
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..98664db 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -125,39 +125,37 @@ extern struct trace_event_functions enter_syscall_print_funcs;
 extern struct trace_event_functions exit_syscall_print_funcs;
 
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
-	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
-	  __attribute__((section("_ftrace_events")))			\
 	  event_enter_##sname = {					\
 		.name                   = "sys_enter"#sname,		\
 		.class			= &event_class_syscall_enter,	\
 		.event.funcs            = &enter_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	};								\
+	static struct ftrace_event_call __used				\
+	  __attribute__((section("_ftrace_events")))			\
+	 *__event_enter_##sname = &event_enter_##sname;			\
 	__TRACE_EVENT_FLAGS(enter_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
-	static struct syscall_metadata					\
-	__attribute__((__aligned__(4))) __syscall_meta_##sname;		\
+	static struct syscall_metadata __syscall_meta_##sname;		\
 	static struct ftrace_event_call __used				\
-	  __attribute__((__aligned__(4)))				\
-	  __attribute__((section("_ftrace_events")))			\
 	  event_exit_##sname = {					\
 		.name                   = "sys_exit"#sname,		\
 		.class			= &event_class_syscall_exit,	\
 		.event.funcs		= &exit_syscall_print_funcs,	\
 		.data			= (void *)&__syscall_meta_##sname,\
 	};								\
+	static struct ftrace_event_call __used				\
+	  __attribute__((section("_ftrace_events")))			\
+	*__event_exit_##sname = &event_exit_##sname;			\
 	__TRACE_EVENT_FLAGS(exit_##sname, TRACE_EVENT_FL_CAP_ANY)
 
 #define SYSCALL_METADATA(sname, nb)				\
 	SYSCALL_TRACE_ENTER_EVENT(sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
-	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta_##sname = {				\
 		.name 		= "sys"#sname,			\
 		.nb_args 	= nb,				\
@@ -166,14 +164,15 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.enter_event	= &event_enter_##sname,		\
 		.exit_event	= &event_exit_##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta_##sname.enter_fields), \
-	};
+	};							\
+	static struct syscall_metadata __used			\
+	  __attribute__((section("__syscalls_metadata")))	\
+	 *__p_syscall_meta_##sname = &__syscall_meta_##sname;
 
 #define SYSCALL_DEFINE0(sname)					\
 	SYSCALL_TRACE_ENTER_EVENT(_##sname);			\
 	SYSCALL_TRACE_EXIT_EVENT(_##sname);			\
 	static struct syscall_metadata __used			\
-	  __attribute__((__aligned__(4)))			\
-	  __attribute__((section("__syscalls_metadata")))	\
 	  __syscall_meta__##sname = {				\
 		.name 		= "sys_"#sname,			\
 		.nb_args 	= 0,				\
@@ -181,6 +180,9 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 		.exit_event	= &event_exit__##sname,		\
 		.enter_fields	= LIST_HEAD_INIT(__syscall_meta__##sname.enter_fields), \
 	};							\
+	static struct syscall_metadata __used			\
+	  __attribute__((section("__syscalls_metadata")))	\
+	 *__p_syscall_meta_##sname = &__syscall_meta__##sname;	\
 	asmlinkage long sys_##sname(void)
 #else
 #define SYSCALL_DEFINE0(name)	   asmlinkage long sys_##name(void)
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index c681461..97c84a5 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -33,12 +33,7 @@ struct tracepoint {
 	void (*regfunc)(void);
 	void (*unregfunc)(void);
 	struct tracepoint_func __rcu *funcs;
-} __attribute__((aligned(32)));		/*
-					 * Aligned on 32 bytes because it is
-					 * globally visible and gcc happily
-					 * align these on the structure size.
-					 * Keep in sync with vmlinux.lds.h.
-					 */
+};
 
 /*
  * Connect a probe to a tracepoint.
@@ -61,15 +56,15 @@ extern void tracepoint_probe_update_all(void);
 
 struct tracepoint_iter {
 	struct module *module;
-	struct tracepoint *tracepoint;
+	struct tracepoint * const *tracepoint;
 };
 
 extern void tracepoint_iter_start(struct tracepoint_iter *iter);
 extern void tracepoint_iter_next(struct tracepoint_iter *iter);
 extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
 extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
-extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
-	struct tracepoint *begin, struct tracepoint *end);
+extern int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
+	struct tracepoint * const *begin, struct tracepoint * const *end);
 
 /*
  * tracepoint_synchronize_unregister must be called between the last tracepoint
@@ -84,11 +79,13 @@ static inline void tracepoint_synchronize_unregister(void)
 #define PARAMS(args...) args
 
 #ifdef CONFIG_TRACEPOINTS
-extern void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end);
+extern
+void tracepoint_update_probe_range(struct tracepoint * const *begin,
+	struct tracepoint * const *end);
 #else
-static inline void tracepoint_update_probe_range(struct tracepoint *begin,
-	struct tracepoint *end)
+static inline
+void tracepoint_update_probe_range(struct tracepoint * const *begin,
+	struct tracepoint * const *end)
 { }
 #endif /* CONFIG_TRACEPOINTS */
 
@@ -174,12 +171,20 @@ do_trace:								\
 	{								\
 	}
 
+/*
+ * We have no guarantee that gcc and the linker won't up-align the tracepoint
+ * structures, so we create an array of pointers that will be used for iteration
+ * on the tracepoints.
+ */
 #define DEFINE_TRACE_FN(name, reg, unreg)				\
 	static const char __tpstrtab_##name[]				\
 	__attribute__((section("__tracepoints_strings"))) = #name;	\
 	struct tracepoint __tracepoint_##name				\
-	__attribute__((section("__tracepoints"), aligned(32))) =	\
-		{ __tpstrtab_##name, 0, reg, unreg, NULL }
+	__attribute__((section("__tracepoints"))) =			\
+		{ __tpstrtab_##name, 0, reg, unreg, NULL };		\
+	static struct tracepoint * const __tracepoint_ptr_##name __used	\
+	__attribute__((section("__tracepoints_ptrs"))) =		\
+		&__tracepoint_##name;
 
 #define DEFINE_TRACE(name)						\
 	DEFINE_TRACE_FN(name, NULL, NULL);
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e16610c..3e68366 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -446,14 +446,16 @@ static inline notrace int ftrace_get_offsets_##call(			\
  *	.reg			= ftrace_event_reg,
  * };
  *
- * static struct ftrace_event_call __used
- * __attribute__((__aligned__(4)))
- * __attribute__((section("_ftrace_events"))) event_<call> = {
+ * static struct ftrace_event_call event_<call> = {
  *	.name			= "<call>",
  *	.class			= event_class_<template>,
  *	.event			= &ftrace_event_type_<call>,
  *	.print_fmt		= print_fmt_<call>,
  * };
+ * // its only safe to use pointers when doing linker tricks to
+ * // create an array.
+ * static struct ftrace_event_call __used
+ * __attribute__((section("_ftrace_events"))) *__event_<call> = &event_<call>;
  *
  */
 
@@ -579,28 +581,28 @@ static struct ftrace_event_class __used event_class_##call = {		\
 #undef DEFINE_EVENT
 #define DEFINE_EVENT(template, call, proto, args)			\
 									\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
+static struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
 	.event.funcs		= &ftrace_event_type_funcs_##template,	\
 	.print_fmt		= print_fmt_##template,			\
-};
+};									\
+static struct ftrace_event_call __used					\
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, call, proto, args, print)		\
 									\
 static const char print_fmt_##call[] = print;				\
 									\
-static struct ftrace_event_call __used					\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
+static struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
 	.class			= &event_class_##template,		\
 	.event.funcs		= &ftrace_event_type_funcs_##call,	\
 	.print_fmt		= print_fmt_##call,			\
-}
+};									\
+static struct ftrace_event_call __used					\
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
diff --git a/kernel/module.c b/kernel/module.c
index 34e00b7..efa290e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2460,9 +2460,9 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
-	mod->tracepoints = section_objs(info, "__tracepoints",
-					sizeof(*mod->tracepoints),
-					&mod->num_tracepoints);
+	mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
+					     sizeof(*mod->tracepoints_ptrs),
+					     &mod->num_tracepoints);
 #endif
 #ifdef HAVE_JUMP_LABEL
 	mod->jump_entries = section_objs(info, "__jump_table",
@@ -3393,7 +3393,7 @@ void module_layout(struct module *mod,
 		   struct modversion_info *ver,
 		   struct kernel_param *kp,
 		   struct kernel_symbol *ks,
-		   struct tracepoint *tp)
+		   struct tracepoint * const *tp)
 {
 }
 EXPORT_SYMBOL(module_layout);
@@ -3407,8 +3407,8 @@ void module_update_tracepoints(void)
 	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list)
 		if (!mod->taints)
-			tracepoint_update_probe_range(mod->tracepoints,
-				mod->tracepoints + mod->num_tracepoints);
+			tracepoint_update_probe_range(mod->tracepoints_ptrs,
+				mod->tracepoints_ptrs + mod->num_tracepoints);
 	mutex_unlock(&module_mutex);
 }
 
@@ -3432,8 +3432,8 @@ int module_get_iter_tracepoints(struct tracepoint_iter *iter)
 			else if (iter_mod > iter->module)
 				iter->tracepoint = NULL;
 			found = tracepoint_get_iter_range(&iter->tracepoint,
-				iter_mod->tracepoints,
-				iter_mod->tracepoints
+				iter_mod->tracepoints_ptrs,
+				iter_mod->tracepoints_ptrs
 					+ iter_mod->num_tracepoints);
 			if (found) {
 				iter->module = iter_mod;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 35fde09..5f499e0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1284,7 +1284,7 @@ trace_create_file_ops(struct module *mod)
 static void trace_module_add_events(struct module *mod)
 {
 	struct ftrace_module_file_ops *file_ops = NULL;
-	struct ftrace_event_call *call, *start, *end;
+	struct ftrace_event_call **call, **start, **end;
 
 	start = mod->trace_events;
 	end = mod->trace_events + mod->num_trace_events;
@@ -1297,7 +1297,7 @@ static void trace_module_add_events(struct module *mod)
 		return;
 
 	for_each_event(call, start, end) {
-		__trace_add_event_call(call, mod,
+		__trace_add_event_call(*call, mod,
 				       &file_ops->id, &file_ops->enable,
 				       &file_ops->filter, &file_ops->format);
 	}
@@ -1367,8 +1367,8 @@ static struct notifier_block trace_module_nb = {
 	.priority = 0,
 };
 
-extern struct ftrace_event_call __start_ftrace_events[];
-extern struct ftrace_event_call __stop_ftrace_events[];
+extern struct ftrace_event_call *__start_ftrace_events[];
+extern struct ftrace_event_call *__stop_ftrace_events[];
 
 static char bootup_event_buf[COMMAND_LINE_SIZE] __initdata;
 
@@ -1384,7 +1384,7 @@ __setup("trace_event=", setup_trace_event);
 
 static __init int event_trace_init(void)
 {
-	struct ftrace_event_call *call;
+	struct ftrace_event_call **call;
 	struct dentry *d_tracer;
 	struct dentry *entry;
 	struct dentry *d_events;
@@ -1430,7 +1430,7 @@ static __init int event_trace_init(void)
 		pr_warning("tracing: Failed to allocate common fields");
 
 	for_each_event(call, __start_ftrace_events, __stop_ftrace_events) {
-		__trace_add_event_call(call, NULL, &ftrace_event_id_fops,
+		__trace_add_event_call(*call, NULL, &ftrace_event_id_fops,
 				       &ftrace_enable_fops,
 				       &ftrace_event_filter_fops,
 				       &ftrace_event_format_fops);
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index 4b74d71..bbeec31 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -161,13 +161,13 @@ struct ftrace_event_class event_class_ftrace_##call = {			\
 	.fields			= LIST_HEAD_INIT(event_class_ftrace_##call.fields),\
 };									\
 									\
-struct ftrace_event_call __used						\
-__attribute__((__aligned__(4)))						\
-__attribute__((section("_ftrace_events"))) event_##call = {		\
+struct ftrace_event_call __used event_##call = {			\
 	.name			= #call,				\
 	.event.type		= etype,				\
 	.class			= &event_class_ftrace_##call,		\
 	.print_fmt		= print,				\
 };									\
+struct ftrace_event_call __used						\
+__attribute__((section("_ftrace_events"))) *__event_##call = &event_##call;
 
 #include "trace_entries.h"
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index b706529..5c9fe08 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -55,20 +55,21 @@ struct ftrace_event_class event_class_syscall_exit = {
 	.raw_init	= init_syscall_trace,
 };
 
-extern unsigned long __start_syscalls_metadata[];
-extern unsigned long __stop_syscalls_metadata[];
+extern struct syscall_metadata *__start_syscalls_metadata[];
+extern struct syscall_metadata *__stop_syscalls_metadata[];
 
 static struct syscall_metadata **syscalls_metadata;
 
-static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
+static __init struct syscall_metadata *
+find_syscall_meta(unsigned long syscall)
 {
-	struct syscall_metadata *start;
-	struct syscall_metadata *stop;
+	struct syscall_metadata **start;
+	struct syscall_metadata **stop;
 	char str[KSYM_SYMBOL_LEN];
 
 
-	start = (struct syscall_metadata *)__start_syscalls_metadata;
-	stop = (struct syscall_metadata *)__stop_syscalls_metadata;
+	start = __start_syscalls_metadata;
+	stop = __stop_syscalls_metadata;
 	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
 
 	for ( ; start < stop; start++) {
@@ -78,8 +79,8 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
 		 * with "SyS" instead of "sys", leading to an unwanted
 		 * mismatch.
 		 */
-		if (start->name && !strcmp(start->name + 3, str + 3))
-			return start;
+		if ((*start)->name && !strcmp((*start)->name + 3, str + 3))
+			return *start;
 	}
 	return NULL;
 }
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index e95ee7f..68187af 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -27,8 +27,8 @@
 #include <linux/sched.h>
 #include <linux/jump_label.h>
 
-extern struct tracepoint __start___tracepoints[];
-extern struct tracepoint __stop___tracepoints[];
+extern struct tracepoint * const __start___tracepoints_ptrs[];
+extern struct tracepoint * const __stop___tracepoints_ptrs[];
 
 /* Set to 1 to enable tracepoint debug output */
 static const int tracepoint_debug;
@@ -298,10 +298,10 @@ static void disable_tracepoint(struct tracepoint *elem)
  *
  * Updates the probe callback corresponding to a range of tracepoints.
  */
-void
-tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
+void tracepoint_update_probe_range(struct tracepoint * const *begin,
+				   struct tracepoint * const *end)
 {
-	struct tracepoint *iter;
+	struct tracepoint * const *iter;
 	struct tracepoint_entry *mark_entry;
 
 	if (!begin)
@@ -309,12 +309,12 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 
 	mutex_lock(&tracepoints_mutex);
 	for (iter = begin; iter < end; iter++) {
-		mark_entry = get_tracepoint(iter->name);
+		mark_entry = get_tracepoint((*iter)->name);
 		if (mark_entry) {
-			set_tracepoint(&mark_entry, iter,
+			set_tracepoint(&mark_entry, *iter,
 					!!mark_entry->refcount);
 		} else {
-			disable_tracepoint(iter);
+			disable_tracepoint(*iter);
 		}
 	}
 	mutex_unlock(&tracepoints_mutex);
@@ -326,8 +326,8 @@ tracepoint_update_probe_range(struct tracepoint *begin, struct tracepoint *end)
 static void tracepoint_update_probes(void)
 {
 	/* Core kernel tracepoints */
-	tracepoint_update_probe_range(__start___tracepoints,
-		__stop___tracepoints);
+	tracepoint_update_probe_range(__start___tracepoints_ptrs,
+		__stop___tracepoints_ptrs);
 	/* tracepoints in modules. */
 	module_update_tracepoints();
 }
@@ -514,8 +514,8 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_update_all);
  * Will return the first tracepoint in the range if the input tracepoint is
  * NULL.
  */
-int tracepoint_get_iter_range(struct tracepoint **tracepoint,
-	struct tracepoint *begin, struct tracepoint *end)
+int tracepoint_get_iter_range(struct tracepoint * const **tracepoint,
+	struct tracepoint * const *begin, struct tracepoint * const *end)
 {
 	if (!*tracepoint && begin != end) {
 		*tracepoint = begin;
@@ -534,7 +534,8 @@ static void tracepoint_get_iter(struct tracepoint_iter *iter)
 	/* Core kernel tracepoints */
 	if (!iter->module) {
 		found = tracepoint_get_iter_range(&iter->tracepoint,
-				__start___tracepoints, __stop___tracepoints);
+				__start___tracepoints_ptrs,
+				__stop___tracepoints_ptrs);
 		if (found)
 			goto end;
 	}
@@ -585,8 +586,8 @@ int tracepoint_module_notify(struct notifier_block *self,
 	switch (val) {
 	case MODULE_STATE_COMING:
 	case MODULE_STATE_GOING:
-		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
+		tracepoint_update_probe_range(mod->tracepoints_ptrs,
+			mod->tracepoints_ptrs + mod->num_tracepoints);
 		break;
 	}
 	return 0;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f5cfed6..d8575d3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -90,7 +90,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	int cpu, thread;
 	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
 
-	aggr->val = 0;
+	aggr->val = aggr->ena = aggr->run = 0;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
 		for (thread = 0; thread < nthreads; thread++) {
