Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0F1GEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 02:04:30 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:37981 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0F1GEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 02:04:23 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 28 Jun 2010 11:29:21 +0530
Message-Id: <20100628055921.6869.48368.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
References: <20100628055740.6869.77397.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv6 2.6.35-rc3-tip 8/12]  trace: Extract out common code for kprobes/uprobes traceevents.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


trace: Extract out common code for kprobes/uprobes traceevents.

Changelog from v5: Addressed comments from Masami Hiramatsu
	and Steven Rostedt. Also shared lot more code from kprobes
        traceevents.

Move common parts of trace_kprobe.c and trace_uprobe.c
Adjust kernel/trace/trace_kprobe.c after moving common code to
kernel/trace/trace_probe.h and kernel/trace/trace_probe.c.

TODO: Merge both events to a single probe event.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 kernel/trace/Kconfig        |    4 
 kernel/trace/Makefile       |    1 
 kernel/trace/trace_kprobe.c |  600 ++-----------------------------------------
 kernel/trace/trace_probe.c  |  521 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |  124 +++++++++
 5 files changed, 671 insertions(+), 579 deletions(-)
 create mode 100644 kernel/trace/trace_probe.c
 create mode 100644 kernel/trace/trace_probe.h


diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index f669092..ab62d9a 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -395,6 +395,7 @@ config KPROBE_EVENT
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
 	bool "Enable kprobes-based dynamic events"
 	select TRACING
+	select PROBE_EVENTS
 	default y
 	help
 	  This allows the user to add tracing events (similar to tracepoints)
@@ -407,6 +408,9 @@ config KPROBE_EVENT
 	  This option is also required by perf-probe subcommand of perf tools.
 	  If you want to use perf tools, this option is strongly recommended.
 
+config PROBE_EVENTS
+	def_bool n
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 469a1c7..5a45910 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -55,5 +55,6 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_PROBE_EVENTS) +=trace_probe.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index f52b5f5..7cfea01 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -19,305 +19,15 @@
 
 #include <linux/module.h>
 #include <linux/uaccess.h>
-#include <linux/kprobes.h>
-#include <linux/seq_file.h>
-#include <linux/slab.h>
-#include <linux/smp.h>
-#include <linux/debugfs.h>
-#include <linux/types.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#include <linux/ptrace.h>
-#include <linux/perf_event.h>
-#include <linux/stringify.h>
-#include <asm/bitsperlong.h>
-
-#include "trace.h"
-#include "trace_output.h"
-
-#define MAX_TRACE_ARGS 128
-#define MAX_ARGSTR_LEN 63
-#define MAX_EVENT_NAME_LEN 64
-#define KPROBE_EVENT_SYSTEM "kprobes"
-
-/* Reserved field names */
-#define FIELD_STRING_IP "__probe_ip"
-#define FIELD_STRING_RETIP "__probe_ret_ip"
-#define FIELD_STRING_FUNC "__probe_func"
-
-const char *reserved_field_names[] = {
-	"common_type",
-	"common_flags",
-	"common_preempt_count",
-	"common_pid",
-	"common_tgid",
-	"common_lock_depth",
-	FIELD_STRING_IP,
-	FIELD_STRING_RETIP,
-	FIELD_STRING_FUNC,
-};
-
-/* Printing function type */
-typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *);
-#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
-#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
-
-/* Printing  in basic type function template */
-#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
-						const char *name, void *data)\
-{									\
-	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
-}									\
-static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
-
-DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
-DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
-
-/* Data fetch function type */
-typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
-
-struct fetch_param {
-	fetch_func_t	fn;
-	void *data;
-};
-
-static __kprobes void call_fetch(struct fetch_param *fprm,
-				 struct pt_regs *regs, void *dest)
-{
-	return fprm->fn(regs, fprm->data, dest);
-}
-
-#define FETCH_FUNC_NAME(kind, type)	fetch_##kind##_##type
-/*
- * Define macro for basic types - we don't need to define s* types, because
- * we have to care only about bitwidth at recording time.
- */
-#define DEFINE_BASIC_FETCH_FUNCS(kind)  \
-DEFINE_FETCH_##kind(u8)			\
-DEFINE_FETCH_##kind(u16)		\
-DEFINE_FETCH_##kind(u32)		\
-DEFINE_FETCH_##kind(u64)
-
-#define CHECK_BASIC_FETCH_FUNCS(kind, fn)	\
-	((FETCH_FUNC_NAME(kind, u8) == fn) ||	\
-	 (FETCH_FUNC_NAME(kind, u16) == fn) ||	\
-	 (FETCH_FUNC_NAME(kind, u32) == fn) ||	\
-	 (FETCH_FUNC_NAME(kind, u64) == fn))
-
-/* Data fetch function templates */
-#define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
-					  void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_register(regs,			\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(reg)
-
-#define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(stack)
-
-#define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
-					  void *dummy, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_return_value(regs);			\
-}
-DEFINE_BASIC_FETCH_FUNCS(retval)
-
-#define DEFINE_FETCH_memory(type)					\
-static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-					  void *addr, void *dest)	\
-{									\
-	type retval;							\
-	if (probe_kernel_address(addr, retval))				\
-		*(type *)dest = 0;					\
-	else								\
-		*(type *)dest = retval;					\
-}
-DEFINE_BASIC_FETCH_FUNCS(memory)
-
-/* Memory fetching by symbol */
-struct symbol_cache {
-	char *symbol;
-	long offset;
-	unsigned long addr;
-};
-
-static unsigned long update_symbol_cache(struct symbol_cache *sc)
-{
-	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
-	if (sc->addr)
-		sc->addr += sc->offset;
-	return sc->addr;
-}
-
-static void free_symbol_cache(struct symbol_cache *sc)
-{
-	kfree(sc->symbol);
-	kfree(sc);
-}
-
-static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
-{
-	struct symbol_cache *sc;
-
-	if (!sym || strlen(sym) == 0)
-		return NULL;
-	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
-	if (!sc)
-		return NULL;
-
-	sc->symbol = kstrdup(sym, GFP_KERNEL);
-	if (!sc->symbol) {
-		kfree(sc);
-		return NULL;
-	}
-	sc->offset = offset;
-
-	update_symbol_cache(sc);
-	return sc;
-}
-
-#define DEFINE_FETCH_symbol(type)					\
-static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
-					  void *data, void *dest)	\
-{									\
-	struct symbol_cache *sc = data;					\
-	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
-	else								\
-		*(type *)dest = 0;					\
-}
-DEFINE_BASIC_FETCH_FUNCS(symbol)
-
-/* Dereference memory access function */
-struct deref_fetch_param {
-	struct fetch_param orig;
-	long offset;
-};
-
-#define DEFINE_FETCH_deref(type)					\
-static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
-					    void *data, void *dest)	\
-{									\
-	struct deref_fetch_param *dprm = data;				\
-	unsigned long addr;						\
-	call_fetch(&dprm->orig, regs, &addr);				\
-	if (addr) {							\
-		addr += dprm->offset;					\
-		fetch_memory_##type(regs, (void *)addr, dest);		\
-	} else								\
-		*(type *)dest = 0;					\
-}
-DEFINE_BASIC_FETCH_FUNCS(deref)
 
-static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
-{
-	if (CHECK_BASIC_FETCH_FUNCS(deref, data->orig.fn))
-		free_deref_fetch_param(data->orig.data);
-	else if (CHECK_BASIC_FETCH_FUNCS(symbol, data->orig.fn))
-		free_symbol_cache(data->orig.data);
-	kfree(data);
-}
-
-/* Default (unsigned long) fetch type */
-#define __DEFAULT_FETCH_TYPE(t) u##t
-#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
-#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
-#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
-
-#define ASSIGN_FETCH_FUNC(kind, type)	\
-	.kind = FETCH_FUNC_NAME(kind, type)
-
-#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)	\
-	{.name = #ptype,			\
-	 .size = sizeof(ftype),			\
-	 .is_signed = sign,			\
-	 .print = PRINT_TYPE_FUNC_NAME(ptype),	\
-	 .fmt = PRINT_TYPE_FMT_NAME(ptype),	\
-ASSIGN_FETCH_FUNC(reg, ftype),			\
-ASSIGN_FETCH_FUNC(stack, ftype),		\
-ASSIGN_FETCH_FUNC(retval, ftype),		\
-ASSIGN_FETCH_FUNC(memory, ftype),		\
-ASSIGN_FETCH_FUNC(symbol, ftype),		\
-ASSIGN_FETCH_FUNC(deref, ftype),		\
-	}
-
-/* Fetch type information table */
-static const struct fetch_type {
-	const char	*name;		/* Name of type */
-	size_t		size;		/* Byte size of type */
-	int		is_signed;	/* Signed flag */
-	print_type_func_t	print;	/* Print functions */
-	const char	*fmt;		/* Fromat string */
-	/* Fetch functions */
-	fetch_func_t	reg;
-	fetch_func_t	stack;
-	fetch_func_t	retval;
-	fetch_func_t	memory;
-	fetch_func_t	symbol;
-	fetch_func_t	deref;
-} fetch_type_table[] = {
-	ASSIGN_FETCH_TYPE(u8,  u8,  0),
-	ASSIGN_FETCH_TYPE(u16, u16, 0),
-	ASSIGN_FETCH_TYPE(u32, u32, 0),
-	ASSIGN_FETCH_TYPE(u64, u64, 0),
-	ASSIGN_FETCH_TYPE(s8,  u8,  1),
-	ASSIGN_FETCH_TYPE(s16, u16, 1),
-	ASSIGN_FETCH_TYPE(s32, u32, 1),
-	ASSIGN_FETCH_TYPE(s64, u64, 1),
-};
-
-static const struct fetch_type *find_fetch_type(const char *type)
-{
-	int i;
+#include "trace_probe.h"
 
-	if (!type)
-		type = DEFAULT_FETCH_TYPE_STR;
-
-	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
-		if (strcmp(type, fetch_type_table[i].name) == 0)
-			return &fetch_type_table[i];
-	return NULL;
-}
-
-/* Special function : only accept unsigned long */
-static __kprobes void fetch_stack_address(struct pt_regs *regs,
-					  void *dummy, void *dest)
-{
-	*(unsigned long *)dest = kernel_stack_pointer(regs);
-}
+#define KPROBE_EVENT_SYSTEM "kprobes"
 
 /**
  * Kprobe event core functions
  */
 
-struct probe_arg {
-	struct fetch_param	fetch;
-	unsigned int		offset;	/* Offset from argument entry */
-	const char		*name;	/* Name of this argument */
-	const char		*comm;	/* Command of this argument */
-	const struct fetch_type	*type;	/* Type of this argument */
-};
-
-/* Flags for trace_probe */
-#define TP_FLAG_TRACE	1
-#define TP_FLAG_PROFILE	2
-
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -355,19 +65,6 @@ static LIST_HEAD(probe_list);
 static int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs);
 static int kretprobe_dispatcher(struct kretprobe_instance *ri,
 				struct pt_regs *regs);
-
-/* Check the name is good for event/group */
-static int check_event_name(const char *name)
-{
-	if (!isalpha(*name) && *name != '_')
-		return 0;
-	while (*++name != '\0') {
-		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
-			return 0;
-	}
-	return 1;
-}
-
 /*
  * Allocate new trace_probe and initialize it (including kprobes).
  */
@@ -399,7 +96,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	else
 		tp->rp.kp.pre_handler = kprobe_dispatcher;
 
-	if (!event || !check_event_name(event)) {
+	if (!event || !tp_check_event_name(event)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -409,7 +106,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 	if (!tp->call.name)
 		goto error;
 
-	if (!group || !check_event_name(group)) {
+	if (!group || !tp_check_event_name(group)) {
 		ret = -EINVAL;
 		goto error;
 	}
@@ -427,22 +124,12 @@ error:
 	return ERR_PTR(ret);
 }
 
-static void free_probe_arg(struct probe_arg *arg)
-{
-	if (CHECK_BASIC_FETCH_FUNCS(deref, arg->fetch.fn))
-		free_deref_fetch_param(arg->fetch.data);
-	else if (CHECK_BASIC_FETCH_FUNCS(symbol, arg->fetch.fn))
-		free_symbol_cache(arg->fetch.data);
-	kfree(arg->name);
-	kfree(arg->comm);
-}
-
 static void free_trace_probe(struct trace_probe *tp)
 {
 	int i;
 
 	for (i = 0; i < tp->nr_args; i++)
-		free_probe_arg(&tp->args[i]);
+		tp_free_probe_arg(&tp->args[i]);
 
 	kfree(tp->call.class->system);
 	kfree(tp->call.name);
@@ -516,181 +203,6 @@ end:
 	return ret;
 }
 
-/* Split symbol and offset. */
-static int split_symbol_offset(char *symbol, unsigned long *offset)
-{
-	char *tmp;
-	int ret;
-
-	if (!offset)
-		return -EINVAL;
-
-	tmp = strchr(symbol, '+');
-	if (tmp) {
-		/* skip sign because strict_strtol doesn't accept '+' */
-		ret = strict_strtoul(tmp + 1, 0, offset);
-		if (ret)
-			return ret;
-		*tmp = '\0';
-	} else
-		*offset = 0;
-	return 0;
-}
-
-#define PARAM_MAX_ARGS 16
-#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
-
-static int parse_probe_vars(char *arg, const struct fetch_type *t,
-			    struct fetch_param *f, int is_return)
-{
-	int ret = 0;
-	unsigned long param;
-
-	if (strcmp(arg, "retval") == 0) {
-		if (is_return)
-			f->fn = t->retval;
-		else
-			ret = -EINVAL;
-	} else if (strncmp(arg, "stack", 5) == 0) {
-		if (arg[5] == '\0') {
-			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
-				f->fn = fetch_stack_address;
-			else
-				ret = -EINVAL;
-		} else if (isdigit(arg[5])) {
-			ret = strict_strtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
-				ret = -EINVAL;
-			else {
-				f->fn = t->stack;
-				f->data = (void *)param;
-			}
-		} else
-			ret = -EINVAL;
-	} else
-		ret = -EINVAL;
-	return ret;
-}
-
-/* Recursive argument parser */
-static int __parse_probe_arg(char *arg, const struct fetch_type *t,
-			     struct fetch_param *f, int is_return)
-{
-	int ret = 0;
-	unsigned long param;
-	long offset;
-	char *tmp;
-
-	switch (arg[0]) {
-	case '$':
-		ret = parse_probe_vars(arg + 1, t, f, is_return);
-		break;
-	case '%':	/* named register */
-		ret = regs_query_register_offset(arg + 1);
-		if (ret >= 0) {
-			f->fn = t->reg;
-			f->data = (void *)(unsigned long)ret;
-			ret = 0;
-		}
-		break;
-	case '@':	/* memory or symbol */
-		if (isdigit(arg[1])) {
-			ret = strict_strtoul(arg + 1, 0, &param);
-			if (ret)
-				break;
-			f->fn = t->memory;
-			f->data = (void *)param;
-		} else {
-			ret = split_symbol_offset(arg + 1, &offset);
-			if (ret)
-				break;
-			f->data = alloc_symbol_cache(arg + 1, offset);
-			if (f->data)
-				f->fn = t->symbol;
-		}
-		break;
-	case '+':	/* deref memory */
-	case '-':
-		tmp = strchr(arg, '(');
-		if (!tmp)
-			break;
-		*tmp = '\0';
-		ret = strict_strtol(arg + 1, 0, &offset);
-		if (ret)
-			break;
-		if (arg[0] == '-')
-			offset = -offset;
-		arg = tmp + 1;
-		tmp = strrchr(arg, ')');
-		if (tmp) {
-			struct deref_fetch_param *dprm;
-			const struct fetch_type *t2 = find_fetch_type(NULL);
-			*tmp = '\0';
-			dprm = kzalloc(sizeof(struct deref_fetch_param),
-				       GFP_KERNEL);
-			if (!dprm)
-				return -ENOMEM;
-			dprm->offset = offset;
-			ret = __parse_probe_arg(arg, t2, &dprm->orig,
-						is_return);
-			if (ret)
-				kfree(dprm);
-			else {
-				f->fn = t->deref;
-				f->data = (void *)dprm;
-			}
-		}
-		break;
-	}
-	if (!ret && !f->fn)
-		ret = -EINVAL;
-	return ret;
-}
-
-/* String length checking wrapper */
-static int parse_probe_arg(char *arg, struct trace_probe *tp,
-			   struct probe_arg *parg, int is_return)
-{
-	const char *t;
-
-	if (strlen(arg) > MAX_ARGSTR_LEN) {
-		pr_info("Argument is too long.: %s\n",  arg);
-		return -ENOSPC;
-	}
-	parg->comm = kstrdup(arg, GFP_KERNEL);
-	if (!parg->comm) {
-		pr_info("Failed to allocate memory for command '%s'.\n", arg);
-		return -ENOMEM;
-	}
-	t = strchr(parg->comm, ':');
-	if (t) {
-		arg[t - parg->comm] = '\0';
-		t++;
-	}
-	parg->type = find_fetch_type(t);
-	if (!parg->type) {
-		pr_info("Unsupported type: %s\n", t);
-		return -EINVAL;
-	}
-	parg->offset = tp->size;
-	tp->size += parg->type->size;
-	return __parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
-}
-
-/* Return 1 if name is reserved or already used by another argument */
-static int conflict_field_name(const char *name,
-			       struct probe_arg *args, int narg)
-{
-	int i;
-	for (i = 0; i < ARRAY_SIZE(reserved_field_names); i++)
-		if (strcmp(reserved_field_names[i], name) == 0)
-			return 1;
-	for (i = 0; i < narg; i++)
-		if (strcmp(args[i].name, name) == 0)
-			return 1;
-	return 0;
-}
-
 static int create_trace_probe(int argc, char **argv)
 {
 	/*
@@ -787,7 +299,7 @@ static int create_trace_probe(int argc, char **argv)
 		/* a symbol specified */
 		symbol = argv[1];
 		/* TODO: support .init module functions */
-		ret = split_symbol_offset(symbol, &offset);
+		ret = tp_split_symbol_offset(symbol, &offset);
 		if (ret) {
 			pr_info("Failed to parse symbol.\n");
 			return ret;
@@ -839,7 +351,7 @@ static int create_trace_probe(int argc, char **argv)
 		if (tmp)
 			*tmp = '_';	/* convert : to _ */
 
-		if (conflict_field_name(tp->args[i].name, tp->args, i)) {
+		if (tp_conflict_field_name(tp->args[i].name, tp->args, i)) {
 			pr_info("Argument%d name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
@@ -847,7 +359,8 @@ static int create_trace_probe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = parse_probe_arg(arg, tp, &tp->args[i], is_return);
+		ret = tp_parse_probe_arg(arg, &tp->size, &tp->args[i],
+							is_return, true);
 		if (ret) {
 			pr_info("Parse error at argument%d. (%d)\n", i, ret);
 			kfree(tp->args[i].name);
@@ -937,70 +450,11 @@ static int probes_open(struct inode *inode, struct file *file)
 	return seq_open(file, &probes_seq_op);
 }
 
-static int command_trace_probe(const char *buf)
-{
-	char **argv;
-	int argc = 0, ret = 0;
-
-	argv = argv_split(GFP_KERNEL, buf, &argc);
-	if (!argv)
-		return -ENOMEM;
-
-	if (argc)
-		ret = create_trace_probe(argc, argv);
-
-	argv_free(argv);
-	return ret;
-}
-
-#define WRITE_BUFSIZE 128
-
 static ssize_t probes_write(struct file *file, const char __user *buffer,
 			    size_t count, loff_t *ppos)
 {
-	char *kbuf, *tmp;
-	int ret;
-	size_t done;
-	size_t size;
-
-	kbuf = kmalloc(WRITE_BUFSIZE, GFP_KERNEL);
-	if (!kbuf)
-		return -ENOMEM;
-
-	ret = done = 0;
-	while (done < count) {
-		size = count - done;
-		if (size >= WRITE_BUFSIZE)
-			size = WRITE_BUFSIZE - 1;
-		if (copy_from_user(kbuf, buffer + done, size)) {
-			ret = -EFAULT;
-			goto out;
-		}
-		kbuf[size] = '\0';
-		tmp = strchr(kbuf, '\n');
-		if (tmp) {
-			*tmp = '\0';
-			size = tmp - kbuf + 1;
-		} else if (done + size < count) {
-			pr_warning("Line length is too long: "
-				   "Should be less than %d.", WRITE_BUFSIZE);
-			ret = -EINVAL;
-			goto out;
-		}
-		done += size;
-		/* Remove comments */
-		tmp = strchr(kbuf, '#');
-		if (tmp)
-			*tmp = '\0';
-
-		ret = command_trace_probe(kbuf);
-		if (ret)
-			goto out;
-	}
-	ret = done;
-out:
-	kfree(kbuf);
-	return ret;
+	return tp_probes_write(file, buffer, count, ppos,
+			create_trace_probe);
 }
 
 static const struct file_operations kprobe_events_ops = {
@@ -1071,7 +525,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	entry->ip = (unsigned long)kp->addr;
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+		tp_call_fetch(&tp->args[i].fetch, regs,
+						data + tp->args[i].offset);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
@@ -1105,7 +560,8 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+		tp_call_fetch(&tp->args[i].fetch, regs,
+						data + tp->args[i].offset);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
@@ -1214,22 +670,6 @@ static void probe_event_disable(struct ftrace_event_call *call)
 	}
 }
 
-static int probe_event_raw_init(struct ftrace_event_call *event_call)
-{
-	return 0;
-}
-
-#undef DEFINE_FIELD
-#define DEFINE_FIELD(type, item, name, is_signed)			\
-	do {								\
-		ret = trace_define_field(event_call, #type, name,	\
-					 offsetof(typeof(field), item),	\
-					 sizeof(field.item), is_signed, \
-					 FILTER_OTHER);			\
-		if (ret)						\
-			return ret;					\
-	} while (0)
-
 static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
@@ -1357,7 +797,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	entry->ip = (unsigned long)kp->addr;
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+		tp_call_fetch(&tp->args[i].fetch, regs,
+						data + tp->args[i].offset);
 
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head);
@@ -1390,7 +831,8 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	entry->ret_ip = (unsigned long)ri->ret_addr;
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+		tp_call_fetch(&tp->args[i].fetch, regs,
+						data + tp->args[i].offset);
 
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1, regs, head);
@@ -1489,12 +931,12 @@ static int register_probe_event(struct trace_probe *tp)
 	if (probe_is_return(tp)) {
 		INIT_LIST_HEAD(&call->class->fields);
 		call->event.funcs = &kretprobe_funcs;
-		call->class->raw_init = probe_event_raw_init;
+		call->class->raw_init = tp_event_raw_init;
 		call->class->define_fields = kretprobe_event_define_fields;
 	} else {
 		INIT_LIST_HEAD(&call->class->fields);
 		call->event.funcs = &kprobe_funcs;
-		call->class->raw_init = probe_event_raw_init;
+		call->class->raw_init = tp_event_raw_init;
 		call->class->define_fields = kprobe_event_define_fields;
 	}
 	if (set_print_fmt(tp) < 0)
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
new file mode 100644
index 0000000..91056d8
--- /dev/null
+++ b/kernel/trace/trace_probe.c
@@ -0,0 +1,521 @@
+/*
+ * Common code for probe-based Dynamic events.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Copyright (C) IBM Corporation, 2010
+ * Author:     Srikar Dronamraju
+ *
+ * Derived from kernel/trace/trace_kprobe.c written by
+ * Masami Hiramatsu <mhiramat@redhat.com>
+ */
+
+#include "trace_probe.h"
+
+const char *reserved_field_names[] = {
+	"common_type",
+	"common_flags",
+	"common_preempt_count",
+	"common_pid",
+	"common_tgid",
+	"common_lock_depth",
+	FIELD_STRING_IP,
+	FIELD_STRING_RETIP,
+	FIELD_STRING_FUNC,
+};
+
+/* Printing function type */
+#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
+#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
+
+/* Printing  in basic type function template */
+#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
+static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
+						const char *name, void *data)\
+{									\
+	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
+}									\
+static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
+
+DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
+DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
+
+__kprobes void tp_call_fetch(struct fetch_param *fprm,
+				 struct pt_regs *regs, void *dest)
+{
+	return fprm->fn(regs, fprm->data, dest);
+}
+
+#define FETCH_FUNC_NAME(kind, type)	fetch_##kind##_##type
+/*
+ * Define macro for basic types - we don't need to define s* types, because
+ * we have to care only about bitwidth at recording time.
+ */
+#define DEFINE_BASIC_FETCH_FUNCS(kind)  \
+DEFINE_FETCH_##kind(u8)			\
+DEFINE_FETCH_##kind(u16)		\
+DEFINE_FETCH_##kind(u32)		\
+DEFINE_FETCH_##kind(u64)
+
+#define CHECK_BASIC_FETCH_FUNCS(kind, fn)	\
+	((FETCH_FUNC_NAME(kind, u8) == fn) ||	\
+	 (FETCH_FUNC_NAME(kind, u16) == fn) ||	\
+	 (FETCH_FUNC_NAME(kind, u32) == fn) ||	\
+	 (FETCH_FUNC_NAME(kind, u64) == fn))
+
+/* Data fetch function templates */
+#define DEFINE_FETCH_reg(type)						\
+static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_register(regs,			\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(reg)
+
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+
+#define DEFINE_FETCH_retval(type)					\
+static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+					  void *dummy, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_return_value(regs);			\
+}
+DEFINE_BASIC_FETCH_FUNCS(retval)
+
+#define DEFINE_FETCH_memory(type)					\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+					  void *addr, void *dest)	\
+{									\
+	type retval;							\
+	if (probe_kernel_address(addr, retval))				\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *)dest = retval;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+
+/* Memory fetching by symbol */
+struct symbol_cache {
+	char *symbol;
+	long offset;
+	unsigned long addr;
+};
+
+static unsigned long update_symbol_cache(struct symbol_cache *sc)
+{
+	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
+	if (sc->addr)
+		sc->addr += sc->offset;
+	return sc->addr;
+}
+
+static void free_symbol_cache(struct symbol_cache *sc)
+{
+	kfree(sc->symbol);
+	kfree(sc);
+}
+
+static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
+{
+	struct symbol_cache *sc;
+
+	if (!sym || strlen(sym) == 0)
+		return NULL;
+	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
+	if (!sc)
+		return NULL;
+
+	sc->symbol = kstrdup(sym, GFP_KERNEL);
+	if (!sc->symbol) {
+		kfree(sc);
+		return NULL;
+	}
+	sc->offset = offset;
+
+	update_symbol_cache(sc);
+	return sc;
+}
+
+#define DEFINE_FETCH_symbol(type)					\
+static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
+					  void *data, void *dest)	\
+{									\
+	struct symbol_cache *sc = data;					\
+	if (sc->addr)							\
+		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+	else								\
+		*(type *)dest = 0;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(symbol)
+
+/* Dereference memory access function */
+struct deref_fetch_param {
+	struct fetch_param orig;
+	long offset;
+};
+
+#define DEFINE_FETCH_deref(type)					\
+static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+					    void *data, void *dest)	\
+{									\
+	struct deref_fetch_param *dprm = data;				\
+	unsigned long addr;						\
+	tp_call_fetch(&dprm->orig, regs, &addr);			\
+	if (addr) {							\
+		addr += dprm->offset;					\
+		fetch_memory_##type(regs, (void *)addr, dest);		\
+	} else								\
+		*(type *)dest = 0;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(deref)
+
+static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
+{
+	if (CHECK_BASIC_FETCH_FUNCS(deref, data->orig.fn))
+		free_deref_fetch_param(data->orig.data);
+	else if (CHECK_BASIC_FETCH_FUNCS(symbol, data->orig.fn))
+		free_symbol_cache(data->orig.data);
+	kfree(data);
+}
+
+/* Default (unsigned long) fetch type */
+#define __DEFAULT_FETCH_TYPE(t) u##t
+#define _DEFAULT_FETCH_TYPE(t) __DEFAULT_FETCH_TYPE(t)
+#define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
+#define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
+
+#define ASSIGN_FETCH_FUNC(kind, type)	\
+	.kind = FETCH_FUNC_NAME(kind, type)
+
+#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)	\
+	{.name = #ptype,			\
+	 .size = sizeof(ftype),			\
+	 .is_signed = sign,			\
+	 .print = PRINT_TYPE_FUNC_NAME(ptype),	\
+	 .fmt = PRINT_TYPE_FMT_NAME(ptype),	\
+ASSIGN_FETCH_FUNC(reg, ftype),			\
+ASSIGN_FETCH_FUNC(stack, ftype),		\
+ASSIGN_FETCH_FUNC(retval, ftype),		\
+ASSIGN_FETCH_FUNC(memory, ftype),		\
+ASSIGN_FETCH_FUNC(symbol, ftype),		\
+ASSIGN_FETCH_FUNC(deref, ftype),		\
+	}
+
+/* Fetch type information table */
+static const struct fetch_type fetch_type_table[] = {
+	ASSIGN_FETCH_TYPE(u8,  u8,  0),
+	ASSIGN_FETCH_TYPE(u16, u16, 0),
+	ASSIGN_FETCH_TYPE(u32, u32, 0),
+	ASSIGN_FETCH_TYPE(u64, u64, 0),
+	ASSIGN_FETCH_TYPE(s8,  u8,  1),
+	ASSIGN_FETCH_TYPE(s16, u16, 1),
+	ASSIGN_FETCH_TYPE(s32, u32, 1),
+	ASSIGN_FETCH_TYPE(s64, u64, 1),
+};
+
+static const struct fetch_type *find_fetch_type(const char *type)
+{
+	int i;
+
+	if (!type)
+		type = DEFAULT_FETCH_TYPE_STR;
+
+	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
+		if (strcmp(type, fetch_type_table[i].name) == 0)
+			return &fetch_type_table[i];
+	return NULL;
+}
+
+/* Special function : only accept unsigned long */
+static __kprobes void fetch_stack_address(struct pt_regs *regs,
+					  void *dummy, void *dest)
+{
+	*(unsigned long *)dest = kernel_stack_pointer(regs);
+}
+
+/* Split symbol and offset. */
+int tp_split_symbol_offset(char *symbol, unsigned long *offset)
+{
+	char *tmp;
+	int ret;
+
+	if (!offset)
+		return -EINVAL;
+
+	tmp = strchr(symbol, '+');
+	if (tmp) {
+		/* skip sign because strict_strtol doesn't accept '+' */
+		ret = strict_strtoul(tmp + 1, 0, offset);
+		if (ret)
+			return ret;
+		*tmp = '\0';
+	} else
+		*offset = 0;
+	return 0;
+}
+
+
+#define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
+
+static int parse_probe_vars(char *arg, const struct fetch_type *t,
+			    struct fetch_param *f, int is_return)
+{
+	int ret = 0;
+	unsigned long param;
+
+	if (strcmp(arg, "retval") == 0) {
+		if (is_return)
+			f->fn = t->retval;
+		else
+			ret = -EINVAL;
+	} else if (strncmp(arg, "stack", 5) == 0) {
+		if (arg[5] == '\0') {
+			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
+				f->fn = fetch_stack_address;
+			else
+				ret = -EINVAL;
+		} else if (isdigit(arg[5])) {
+			ret = strict_strtoul(arg + 5, 10, &param);
+			if (ret || param > PARAM_MAX_STACK)
+				ret = -EINVAL;
+			else {
+				f->fn = t->stack;
+				f->data = (void *)param;
+			}
+		} else
+			ret = -EINVAL;
+	} else
+		ret = -EINVAL;
+	return ret;
+}
+
+/* Recursive argument parser */
+static int __tp_parse_probe_arg(char *arg, const struct fetch_type *t,
+		     struct fetch_param *f, int is_return, bool is_kprobe)
+{
+	int ret = 0;
+	unsigned long param;
+	long offset;
+	char *tmp;
+
+	/* Until uprobe_events supports only reg arguments */
+	if (!is_kprobe && arg[0] != '%')
+		return -EINVAL;
+
+	switch (arg[0]) {
+	case '$':
+		ret = parse_probe_vars(arg + 1, t, f, is_return);
+		break;
+	case '%':	/* named register */
+		ret = regs_query_register_offset(arg + 1);
+		if (ret >= 0) {
+			f->fn = t->reg;
+			f->data = (void *)(unsigned long)ret;
+			ret = 0;
+		}
+		break;
+	case '@':	/* memory or symbol */
+		if (isdigit(arg[1])) {
+			ret = strict_strtoul(arg + 1, 0, &param);
+			if (ret)
+				break;
+			f->fn = t->memory;
+			f->data = (void *)param;
+		} else {
+			ret = tp_split_symbol_offset(arg + 1, &offset);
+			if (ret)
+				break;
+			f->data = alloc_symbol_cache(arg + 1, offset);
+			if (f->data)
+				f->fn = t->symbol;
+		}
+		break;
+	case '+':	/* deref memory */
+	case '-':
+		tmp = strchr(arg, '(');
+		if (!tmp)
+			break;
+		*tmp = '\0';
+		ret = strict_strtol(arg + 1, 0, &offset);
+		if (ret)
+			break;
+		if (arg[0] == '-')
+			offset = -offset;
+		arg = tmp + 1;
+		tmp = strrchr(arg, ')');
+		if (tmp) {
+			struct deref_fetch_param *dprm;
+			const struct fetch_type *t2 = find_fetch_type(NULL);
+			*tmp = '\0';
+			dprm = kzalloc(sizeof(struct deref_fetch_param),
+				       GFP_KERNEL);
+			if (!dprm)
+				return -ENOMEM;
+			dprm->offset = offset;
+			ret = __tp_parse_probe_arg(arg, t2, &dprm->orig,
+						is_return, is_kprobe);
+			if (ret)
+				kfree(dprm);
+			else {
+				f->fn = t->deref;
+				f->data = (void *)dprm;
+			}
+		}
+		break;
+	}
+	if (!ret && !f->fn)
+		ret = -EINVAL;
+	return ret;
+}
+
+/* String length checking wrapper */
+int tp_parse_probe_arg(char *arg, ssize_t *size, struct probe_arg *parg,
+					int is_return, bool is_kprobe)
+{
+	const char *t;
+
+	if (strlen(arg) > MAX_ARGSTR_LEN) {
+		pr_info("Argument is too long.: %s\n",  arg);
+		return -ENOSPC;
+	}
+	parg->comm = kstrdup(arg, GFP_KERNEL);
+	if (!parg->comm) {
+		pr_info("Failed to allocate memory for command '%s'.\n", arg);
+		return -ENOMEM;
+	}
+	t = strchr(parg->comm, ':');
+	if (t) {
+		arg[t - parg->comm] = '\0';
+		t++;
+	}
+	parg->type = find_fetch_type(t);
+	if (!parg->type) {
+		pr_info("Unsupported type: %s\n", t);
+		return -EINVAL;
+	}
+	parg->offset = *size;
+	*size += parg->type->size;
+	return __tp_parse_probe_arg(arg, parg->type, &parg->fetch,
+						is_return, is_kprobe);
+}
+
+/* Return 1 if name is reserved or already used by another argument */
+int tp_conflict_field_name(const char *name,
+			       struct probe_arg *args, int narg)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(reserved_field_names); i++)
+		if (strcmp(reserved_field_names[i], name) == 0)
+			return 1;
+	for (i = 0; i < narg; i++)
+		if (strcmp(args[i].name, name) == 0)
+			return 1;
+	return 0;
+}
+
+void tp_free_probe_arg(struct probe_arg *arg)
+{
+	if (CHECK_BASIC_FETCH_FUNCS(deref, arg->fetch.fn))
+		free_deref_fetch_param(arg->fetch.data);
+	else if (CHECK_BASIC_FETCH_FUNCS(symbol, arg->fetch.fn))
+		free_symbol_cache(arg->fetch.data);
+	kfree(arg->name);
+	kfree(arg->comm);
+}
+
+int tp_event_raw_init(struct ftrace_event_call *event_call)
+{
+	return 0;
+}
+
+static int command_trace_probe(const char *buf,
+			int (*createfn)(int, char**))
+{
+	char **argv;
+	int argc = 0, ret = 0;
+
+	argv = argv_split(GFP_KERNEL, buf, &argc);
+	if (!argv)
+		return -ENOMEM;
+
+	if (argc)
+		ret = createfn(argc, argv);
+
+	argv_free(argv);
+	return ret;
+}
+
+#define WRITE_BUFSIZE 128
+
+ssize_t tp_probes_write(struct file *file, const char __user *buffer,
+	    size_t count, loff_t *ppos, int (*createfn)(int, char**))
+{
+	char *kbuf, *tmp;
+	int ret = 0;
+	size_t done = 0;
+	size_t size;
+
+	kbuf = kmalloc(WRITE_BUFSIZE, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	while (done < count) {
+		size = count - done;
+		if (size >= WRITE_BUFSIZE)
+			size = WRITE_BUFSIZE - 1;
+		if (copy_from_user(kbuf, buffer + done, size)) {
+			ret = -EFAULT;
+			goto out;
+		}
+		kbuf[size] = '\0';
+		tmp = strchr(kbuf, '\n');
+		if (tmp) {
+			*tmp = '\0';
+			size = tmp - kbuf + 1;
+		} else if (done + size < count) {
+			pr_warning("Line length is too long: "
+				   "Should be less than %d.", WRITE_BUFSIZE);
+			ret = -EINVAL;
+			goto out;
+		}
+		done += size;
+		/* Remove comments */
+		tmp = strchr(kbuf, '#');
+		if (tmp)
+			*tmp = '\0';
+
+		ret = command_trace_probe(kbuf, createfn);
+		if (ret)
+			goto out;
+	}
+	ret = done;
+out:
+	kfree(kbuf);
+	return ret;
+}
+
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
new file mode 100644
index 0000000..cbee43a
--- /dev/null
+++ b/kernel/trace/trace_probe.h
@@ -0,0 +1,124 @@
+/*
+ * Common header file for probe-based Dynamic events.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * Copyright (C) IBM Corporation, 2010
+ * Author:     Srikar Dronamraju
+ *
+ * Derived from kernel/trace/trace_kprobe.c written by
+ * Masami Hiramatsu <mhiramat@redhat.com>
+ */
+
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/smp.h>
+#include <linux/debugfs.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/ptrace.h>
+#include <linux/perf_event.h>
+#include <linux/kprobes.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+#define MAX_TRACE_ARGS 128
+#define MAX_ARGSTR_LEN 63
+#define MAX_EVENT_NAME_LEN 64
+
+/* Reserved field names */
+#define FIELD_STRING_IP "__probe_ip"
+#define FIELD_STRING_RETIP "__probe_ret_ip"
+#define FIELD_STRING_FUNC "__probe_func"
+
+#undef DEFINE_FIELD
+#define DEFINE_FIELD(type, item, name, is_signed)			\
+	do {								\
+		ret = trace_define_field(event_call, #type, name,	\
+					 offsetof(typeof(field), item),	\
+					 sizeof(field.item), is_signed, \
+					 FILTER_OTHER);			\
+		if (ret)						\
+			return ret;					\
+	} while (0)
+
+
+/* Flags for trace_probe */
+#define TP_FLAG_TRACE	1
+#define TP_FLAG_PROFILE	2
+
+/* Data fetch function type */
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *);
+
+/* Fetch type information table */
+struct fetch_type {
+	const char	*name;		/* Name of type */
+	size_t		size;		/* Byte size of type */
+	int		is_signed;	/* Signed flag */
+	print_type_func_t	print;	/* Print functions */
+	const char	*fmt;		/* Fromat string */
+	/* Fetch functions */
+	fetch_func_t	reg;
+	fetch_func_t	stack;
+	fetch_func_t	retval;
+	fetch_func_t	memory;
+	fetch_func_t	symbol;
+	fetch_func_t	deref;
+};
+
+struct fetch_param {
+	fetch_func_t	fn;
+	void *data;
+};
+
+struct probe_arg {
+	struct fetch_param	fetch;
+	unsigned int		offset;	/* Offset from argument entry */
+	const char		*name;	/* Name of this argument */
+	const char		*comm;	/* Command of this argument */
+	const struct fetch_type	*type;	/* Type of this argument */
+};
+
+/* Check the name is good for event/group */
+static inline int tp_check_event_name(const char *name)
+{
+	if (!isalpha(*name) && *name != '_')
+		return 0;
+	while (*++name != '\0') {
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+			return 0;
+	}
+	return 1;
+}
+
+extern int tp_parse_probe_arg(char *arg, ssize_t *size,
+		   struct probe_arg *parg, int is_return, bool is_kprobe);
+
+extern int tp_event_raw_init(struct ftrace_event_call *event_call);
+
+extern int tp_conflict_field_name(const char *name,
+			       struct probe_arg *args, int narg);
+
+extern void tp_free_probe_arg(struct probe_arg *arg);
+
+__kprobes void tp_call_fetch(struct fetch_param *fprm,
+				 struct pt_regs *regs, void *dest);
+
+extern int tp_split_symbol_offset(char *symbol, unsigned long *offset);
+
+extern ssize_t tp_probes_write(struct file *file, const char __user *buffer,
+	    size_t count, loff_t *ppos, int (*createfn)(int, char**));
