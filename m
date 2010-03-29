Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab0C2Ubd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:31:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0C2Uba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:31:30 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 4/7] trace/kprobes: Support basic types
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 29 Mar 2010 16:38:17 -0400
Message-ID: <20100329203817.2577.88822.stgit@localhost6.localdomain6>
In-Reply-To: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
References: <20100329203736.2577.56018.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support basic types of integer (u8, u16, u32, u64, s8, s16, s32, s64) in
kprobe tracer. With this patch, users can specify above basic types on
each arguments after ':'. If omitted, the argument type is set as
unsigned long (u32 or u64, arch-dependent).

 e.g.
  echo 'p account_system_time+0 hardirq_offset=%si:s32' > kprobe_events

  adds a probe recording hardirq_offset in signed-32bits value on the
  entry of account_system_time.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 Documentation/trace/kprobetrace.txt |    4 
 kernel/trace/trace.h                |   16 -
 kernel/trace/trace_kprobe.c         |  535 ++++++++++++++++++++++-------------
 3 files changed, 334 insertions(+), 221 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index a9100b2..ec94748 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -40,7 +40,9 @@ Synopsis of kprobe_events
   $stack	: Fetch stack address.
   $retval	: Fetch return value.(*)
   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(**)
-  NAME=FETCHARG: Set NAME as the argument name of FETCHARG.
+  NAME=FETCHARG : Set NAME as the argument name of FETCHARG.
+  FETCHARG:TYPE : Set TYPE as the type of FETCHARG. Currently, basic types
+		  (u8/u16/u32/u64/s8/s16/s32/s64) are supported.
 
   (*) only for return probe.
   (**) this is useful for fetching a field of data structures.
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index bec2c97..3ebdb6b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -102,29 +102,17 @@ struct syscall_trace_exit {
 	long			ret;
 };
 
-struct kprobe_trace_entry {
+struct kprobe_trace_entry_head {
 	struct trace_entry	ent;
 	unsigned long		ip;
-	int			nargs;
-	unsigned long		args[];
 };
 
-#define SIZEOF_KPROBE_TRACE_ENTRY(n)			\
-	(offsetof(struct kprobe_trace_entry, args) +	\
-	(sizeof(unsigned long) * (n)))
-
-struct kretprobe_trace_entry {
+struct kretprobe_trace_entry_head {
 	struct trace_entry	ent;
 	unsigned long		func;
 	unsigned long		ret_ip;
-	int			nargs;
-	unsigned long		args[];
 };
 
-#define SIZEOF_KRETPROBE_TRACE_ENTRY(n)			\
-	(offsetof(struct kretprobe_trace_entry, args) +	\
-	(sizeof(unsigned long) * (n)))
-
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1251e36..a751432 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -29,6 +29,8 @@
 #include <linux/ctype.h>
 #include <linux/ptrace.h>
 #include <linux/perf_event.h>
+#include <linux/stringify.h>
+#include <asm/bitsperlong.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -40,7 +42,6 @@
 
 /* Reserved field names */
 #define FIELD_STRING_IP "__probe_ip"
-#define FIELD_STRING_NARGS "__probe_nargs"
 #define FIELD_STRING_RETIP "__probe_ret_ip"
 #define FIELD_STRING_FUNC "__probe_func"
 
@@ -52,56 +53,102 @@ const char *reserved_field_names[] = {
 	"common_tgid",
 	"common_lock_depth",
 	FIELD_STRING_IP,
-	FIELD_STRING_NARGS,
 	FIELD_STRING_RETIP,
 	FIELD_STRING_FUNC,
 };
 
-struct fetch_func {
-	unsigned long (*func)(struct pt_regs *, void *);
+/* Printing function type */
+typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *);
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
+/* Data fetch function type */
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+
+struct fetch_param {
+	fetch_func_t	fn;
 	void *data;
 };
 
-static __kprobes unsigned long call_fetch(struct fetch_func *f,
-					  struct pt_regs *regs)
+static __kprobes void call_fetch(struct fetch_param *fprm,
+				 struct pt_regs *regs, void *dest)
 {
-	return f->func(regs, f->data);
+	return fprm->fn(regs, fprm->data, dest);
 }
 
-/* fetch handlers */
-static __kprobes unsigned long fetch_register(struct pt_regs *regs,
-					      void *offset)
-{
-	return regs_get_register(regs, (unsigned int)((unsigned long)offset));
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
 }
-
-static __kprobes unsigned long fetch_stack(struct pt_regs *regs,
-					   void *num)
-{
-	return regs_get_kernel_stack_nth(regs,
-					 (unsigned int)((unsigned long)num));
+DEFINE_BASIC_FETCH_FUNCS(reg)
+
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
+				(unsigned int)((unsigned long)offset));	\
 }
+DEFINE_BASIC_FETCH_FUNCS(stack)
 
-static __kprobes unsigned long fetch_memory(struct pt_regs *regs, void *addr)
-{
-	unsigned long retval;
-
-	if (probe_kernel_address(addr, retval))
-		return 0;
-	return retval;
+#define DEFINE_FETCH_retval(type)					\
+static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+					  void *dummy, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_return_value(regs);			\
 }
-
-static __kprobes unsigned long fetch_retvalue(struct pt_regs *regs,
-					      void *dummy)
-{
-	return regs_return_value(regs);
-}
-
-static __kprobes unsigned long fetch_stack_address(struct pt_regs *regs,
-						   void *dummy)
-{
-	return kernel_stack_pointer(regs);
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
 }
+DEFINE_BASIC_FETCH_FUNCS(memory)
 
 /* Memory fetching by symbol */
 struct symbol_cache {
@@ -145,51 +192,126 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 	return sc;
 }
 
-static __kprobes unsigned long fetch_symbol(struct pt_regs *regs, void *data)
-{
-	struct symbol_cache *sc = data;
-
-	if (sc->addr)
-		return fetch_memory(regs, (void *)sc->addr);
-	else
-		return 0;
+#define DEFINE_FETCH_symbol(type)					\
+static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
+					  void *data, void *dest)	\
+{									\
+	struct symbol_cache *sc = data;					\
+	if (sc->addr)							\
+		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+	else								\
+		*(type *)dest = 0;					\
 }
+DEFINE_BASIC_FETCH_FUNCS(symbol)
 
-/* Special indirect memory access interface */
-struct indirect_fetch_data {
-	struct fetch_func orig;
+/* Dereference memory access function */
+struct deref_fetch_param {
+	struct fetch_param orig;
 	long offset;
 };
 
-static __kprobes unsigned long fetch_indirect(struct pt_regs *regs, void *data)
-{
-	struct indirect_fetch_data *ind = data;
-	unsigned long addr;
-
-	addr = call_fetch(&ind->orig, regs);
-	if (addr) {
-		addr += ind->offset;
-		return fetch_memory(regs, (void *)addr);
-	} else
-		return 0;
+#define DEFINE_FETCH_deref(type)					\
+static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+					    void *data, void *dest)	\
+{									\
+	struct deref_fetch_param *dprm = data;				\
+	unsigned long addr;						\
+	call_fetch(&dprm->orig, regs, &addr);				\
+	if (addr) {							\
+		addr += dprm->offset;					\
+		fetch_memory_##type(regs, (void *)addr, dest);		\
+	} else								\
+		*(type *)dest = 0;					\
 }
+DEFINE_BASIC_FETCH_FUNCS(deref)
 
-static __kprobes void free_indirect_fetch_data(struct indirect_fetch_data *data)
+static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 {
-	if (data->orig.func == fetch_indirect)
-		free_indirect_fetch_data(data->orig.data);
-	else if (data->orig.func == fetch_symbol)
+	if (CHECK_BASIC_FETCH_FUNCS(deref, data->orig.fn))
+		free_deref_fetch_param(data->orig.data);
+	else if (CHECK_BASIC_FETCH_FUNCS(symbol, data->orig.fn))
 		free_symbol_cache(data->orig.data);
 	kfree(data);
 }
 
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
+static const struct fetch_type {
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
+} fetch_type_table[] = {
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
 /**
  * Kprobe event core functions
  */
 
 struct probe_arg {
-	struct fetch_func	fetch;
-	const char		*name;
+	struct fetch_param	fetch;
+	unsigned int		offset;	/* Offset from argument entry */
+	const char		*name;	/* Name of this argument */
+	const char		*comm;	/* Command of this argument */
+	const struct fetch_type	*type;	/* Type of this argument */
 };
 
 /* Flags for trace_probe */
@@ -204,6 +326,7 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_call	call;
 	struct trace_event		event;
+	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];
 };
@@ -212,6 +335,7 @@ struct trace_probe {
 	(offsetof(struct trace_probe, args) +	\
 	(sizeof(struct probe_arg) * (n)))
 
+
 static __kprobes int probe_is_return(struct trace_probe *tp)
 {
 	return tp->rp.handler != NULL;
@@ -222,49 +346,6 @@ static __kprobes const char *probe_symbol(struct trace_probe *tp)
 	return tp->symbol ? tp->symbol : "unknown";
 }
 
-static int probe_arg_string(char *buf, size_t n, struct fetch_func *ff)
-{
-	int ret = -EINVAL;
-
-	if (ff->func == fetch_register) {
-		const char *name;
-		name = regs_query_register_name((unsigned int)((long)ff->data));
-		ret = snprintf(buf, n, "%%%s", name);
-	} else if (ff->func == fetch_stack)
-		ret = snprintf(buf, n, "$stack%lu", (unsigned long)ff->data);
-	else if (ff->func == fetch_memory)
-		ret = snprintf(buf, n, "@0x%p", ff->data);
-	else if (ff->func == fetch_symbol) {
-		struct symbol_cache *sc = ff->data;
-		if (sc->offset)
-			ret = snprintf(buf, n, "@%s%+ld", sc->symbol,
-					sc->offset);
-		else
-			ret = snprintf(buf, n, "@%s", sc->symbol);
-	} else if (ff->func == fetch_retvalue)
-		ret = snprintf(buf, n, "$retval");
-	else if (ff->func == fetch_stack_address)
-		ret = snprintf(buf, n, "$stack");
-	else if (ff->func == fetch_indirect) {
-		struct indirect_fetch_data *id = ff->data;
-		size_t l = 0;
-		ret = snprintf(buf, n, "%+ld(", id->offset);
-		if (ret >= n)
-			goto end;
-		l += ret;
-		ret = probe_arg_string(buf + l, n - l, &id->orig);
-		if (ret < 0)
-			goto end;
-		l += ret;
-		ret = snprintf(buf + l, n - l, ")");
-		ret += l;
-	}
-end:
-	if (ret >= n)
-		return -ENOSPC;
-	return ret;
-}
-
 static int register_probe_event(struct trace_probe *tp);
 static void unregister_probe_event(struct trace_probe *tp);
 
@@ -347,11 +428,12 @@ error:
 
 static void free_probe_arg(struct probe_arg *arg)
 {
-	if (arg->fetch.func == fetch_symbol)
+	if (CHECK_BASIC_FETCH_FUNCS(deref, arg->fetch.fn))
+		free_deref_fetch_param(arg->fetch.data);
+	else if (CHECK_BASIC_FETCH_FUNCS(symbol, arg->fetch.fn))
 		free_symbol_cache(arg->fetch.data);
-	else if (arg->fetch.func == fetch_indirect)
-		free_indirect_fetch_data(arg->fetch.data);
 	kfree(arg->name);
+	kfree(arg->comm);
 }
 
 static void free_trace_probe(struct trace_probe *tp)
@@ -457,28 +539,30 @@ static int split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_ARGS 16
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
-static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
+static int parse_probe_vars(char *arg, const struct fetch_type *t,
+			    struct fetch_param *f, int is_return)
 {
 	int ret = 0;
 	unsigned long param;
 
 	if (strcmp(arg, "retval") == 0) {
-		if (is_return) {
-			ff->func = fetch_retvalue;
-			ff->data = NULL;
-		} else
+		if (is_return)
+			f->fn = t->retval;
+		else
 			ret = -EINVAL;
 	} else if (strncmp(arg, "stack", 5) == 0) {
 		if (arg[5] == '\0') {
-			ff->func = fetch_stack_address;
-			ff->data = NULL;
+			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
+				f->fn = fetch_stack_address;
+			else
+				ret = -EINVAL;
 		} else if (isdigit(arg[5])) {
 			ret = strict_strtoul(arg + 5, 10, &param);
 			if (ret || param > PARAM_MAX_STACK)
 				ret = -EINVAL;
 			else {
-				ff->func = fetch_stack;
-				ff->data = (void *)param;
+				f->fn = t->stack;
+				f->data = (void *)param;
 			}
 		} else
 			ret = -EINVAL;
@@ -488,7 +572,8 @@ static int parse_probe_vars(char *arg, struct fetch_func *ff, int is_return)
 }
 
 /* Recursive argument parser */
-static int __parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
+static int __parse_probe_arg(char *arg, const struct fetch_type *t,
+			     struct fetch_param *f, int is_return)
 {
 	int ret = 0;
 	unsigned long param;
@@ -497,13 +582,13 @@ static int __parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 
 	switch (arg[0]) {
 	case '$':
-		ret = parse_probe_vars(arg + 1, ff, is_return);
+		ret = parse_probe_vars(arg + 1, t, f, is_return);
 		break;
 	case '%':	/* named register */
 		ret = regs_query_register_offset(arg + 1);
 		if (ret >= 0) {
-			ff->func = fetch_register;
-			ff->data = (void *)(unsigned long)ret;
+			f->fn = t->reg;
+			f->data = (void *)(unsigned long)ret;
 			ret = 0;
 		}
 		break;
@@ -512,26 +597,22 @@ static int __parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 			ret = strict_strtoul(arg + 1, 0, &param);
 			if (ret)
 				break;
-			ff->func = fetch_memory;
-			ff->data = (void *)param;
+			f->fn = t->memory;
+			f->data = (void *)param;
 		} else {
 			ret = split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
-			ff->data = alloc_symbol_cache(arg + 1, offset);
-			if (ff->data)
-				ff->func = fetch_symbol;
-			else
-				ret = -EINVAL;
+			f->data = alloc_symbol_cache(arg + 1, offset);
+			if (f->data)
+				f->fn = t->symbol;
 		}
 		break;
-	case '+':	/* indirect memory */
+	case '+':	/* deref memory */
 	case '-':
 		tmp = strchr(arg, '(');
-		if (!tmp) {
-			ret = -EINVAL;
+		if (!tmp)
 			break;
-		}
 		*tmp = '\0';
 		ret = strict_strtol(arg + 1, 0, &offset);
 		if (ret)
@@ -541,38 +622,58 @@ static int __parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 		arg = tmp + 1;
 		tmp = strrchr(arg, ')');
 		if (tmp) {
-			struct indirect_fetch_data *id;
+			struct deref_fetch_param *dprm;
+			const struct fetch_type *t2 = find_fetch_type(NULL);
 			*tmp = '\0';
-			id = kzalloc(sizeof(struct indirect_fetch_data),
-				     GFP_KERNEL);
-			if (!id)
+			dprm = kzalloc(sizeof(struct deref_fetch_param),
+				       GFP_KERNEL);
+			if (!dprm)
 				return -ENOMEM;
-			id->offset = offset;
-			ret = __parse_probe_arg(arg, &id->orig, is_return);
+			dprm->offset = offset;
+			ret = __parse_probe_arg(arg, t2, &dprm->orig,
+						is_return);
 			if (ret)
-				kfree(id);
+				kfree(dprm);
 			else {
-				ff->func = fetch_indirect;
-				ff->data = (void *)id;
+				f->fn = t->deref;
+				f->data = (void *)dprm;
 			}
-		} else
-			ret = -EINVAL;
+		}
 		break;
-	default:
-		/* TODO: support custom handler */
-		ret = -EINVAL;
 	}
+	if (!ret && !f->fn)
+		ret = -EINVAL;
 	return ret;
 }
 
 /* String length checking wrapper */
-static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
+static int parse_probe_arg(char *arg, struct trace_probe *tp,
+			   struct probe_arg *parg, int is_return)
 {
+	const char *t;
+
 	if (strlen(arg) > MAX_ARGSTR_LEN) {
 		pr_info("Argument is too long.: %s\n",  arg);
 		return -ENOSPC;
 	}
-	return __parse_probe_arg(arg, ff, is_return);
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
+	parg->offset = tp->size;
+	tp->size += parg->type->size;
+	return __parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
 }
 
 /* Return 1 if name is reserved or already used by another argument */
@@ -602,15 +703,18 @@ static int create_trace_probe(int argc, char **argv)
 	 *  @ADDR	: fetch memory at ADDR (ADDR should be in kernel)
 	 *  @SYM[+|-offs] : fetch memory at SYM +|- offs (SYM is a data symbol)
 	 *  %REG	: fetch register REG
-	 * Indirect memory fetch:
+	 * Dereferencing memory fetch:
 	 *  +|-offs(ARG) : fetch memory at ARG +|- offs address.
 	 * Alias name of args:
 	 *  NAME=FETCHARG : set NAME as alias of FETCHARG.
+	 * Type of args:
+	 *  FETCHARG:TYPE : use TYPE instead of unsigned long.
 	 */
 	struct trace_probe *tp;
 	int i, ret = 0;
 	int is_return = 0, is_delete = 0;
-	char *symbol = NULL, *event = NULL, *arg = NULL, *group = NULL;
+	char *symbol = NULL, *event = NULL, *group = NULL;
+	char *arg, *tmp;
 	unsigned long offset = 0;
 	void *addr = NULL;
 	char buf[MAX_EVENT_NAME_LEN];
@@ -723,13 +827,6 @@ static int create_trace_probe(int argc, char **argv)
 		else
 			arg = argv[i];
 
-		if (conflict_field_name(argv[i], tp->args, i)) {
-			pr_info("Argument%d name '%s' conflicts with "
-				"another field.\n", i, argv[i]);
-			ret = -EINVAL;
-			goto error;
-		}
-
 		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
 		if (!tp->args[i].name) {
 			pr_info("Failed to allocate argument%d name '%s'.\n",
@@ -737,9 +834,19 @@ static int create_trace_probe(int argc, char **argv)
 			ret = -ENOMEM;
 			goto error;
 		}
+		tmp = strchr(tp->args[i].name, ':');
+		if (tmp)
+			*tmp = '_';	/* convert : to _ */
+
+		if (conflict_field_name(tp->args[i].name, tp->args, i)) {
+			pr_info("Argument%d name '%s' conflicts with "
+				"another field.\n", i, argv[i]);
+			ret = -EINVAL;
+			goto error;
+		}
 
 		/* Parse fetch argument */
-		ret = parse_probe_arg(arg, &tp->args[i].fetch, is_return);
+		ret = parse_probe_arg(arg, tp, &tp->args[i], is_return);
 		if (ret) {
 			pr_info("Parse error at argument%d. (%d)\n", i, ret);
 			kfree(tp->args[i].name);
@@ -794,8 +901,7 @@ static void probes_seq_stop(struct seq_file *m, void *v)
 static int probes_seq_show(struct seq_file *m, void *v)
 {
 	struct trace_probe *tp = v;
-	int i, ret;
-	char buf[MAX_ARGSTR_LEN + 1];
+	int i;
 
 	seq_printf(m, "%c", probe_is_return(tp) ? 'r' : 'p');
 	seq_printf(m, ":%s/%s", tp->call.system, tp->call.name);
@@ -807,15 +913,10 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	else
 		seq_printf(m, " %s", probe_symbol(tp));
 
-	for (i = 0; i < tp->nr_args; i++) {
-		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i].fetch);
-		if (ret < 0) {
-			pr_warning("Argument%d decoding error(%d).\n", i, ret);
-			return ret;
-		}
-		seq_printf(m, " %s=%s", tp->args[i].name, buf);
-	}
+	for (i = 0; i < tp->nr_args; i++)
+		seq_printf(m, " %s=%s", tp->args[i].name, tp->args[i].comm);
 	seq_printf(m, "\n");
+
 	return 0;
 }
 
@@ -945,9 +1046,10 @@ static const struct file_operations kprobe_profile_ops = {
 static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
-	struct kprobe_trace_entry *entry;
+	struct kprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	u8 *data;
 	int size, i, pc;
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
@@ -957,7 +1059,7 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
+	size = sizeof(*entry) + tp->size;
 
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
@@ -965,10 +1067,10 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->nargs = tp->nr_args;
 	entry->ip = (unsigned long)kp->addr;
+	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
@@ -979,9 +1081,10 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 					  struct pt_regs *regs)
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
-	struct kretprobe_trace_entry *entry;
+	struct kretprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
+	u8 *data;
 	int size, i, pc;
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
@@ -989,7 +1092,7 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
+	size = sizeof(*entry) + tp->size;
 
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
@@ -997,11 +1100,11 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 		return;
 
 	entry = ring_buffer_event_data(event);
-	entry->nargs = tp->nr_args;
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
+	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
@@ -1011,13 +1114,14 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 enum print_line_t
 print_kprobe_event(struct trace_iterator *iter, int flags)
 {
-	struct kprobe_trace_entry *field;
+	struct kprobe_trace_entry_head *field;
 	struct trace_seq *s = &iter->seq;
 	struct trace_event *event;
 	struct trace_probe *tp;
+	u8 *data;
 	int i;
 
-	field = (struct kprobe_trace_entry *)iter->ent;
+	field = (struct kprobe_trace_entry_head *)iter->ent;
 	event = ftrace_find_event(field->ent.type);
 	tp = container_of(event, struct trace_probe, event);
 
@@ -1030,9 +1134,10 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
 	if (!trace_seq_puts(s, ")"))
 		goto partial;
 
-	for (i = 0; i < field->nargs; i++)
-		if (!trace_seq_printf(s, " %s=%lx",
-				      tp->args[i].name, field->args[i]))
+	data = (u8 *)&field[1];
+	for (i = 0; i < tp->nr_args; i++)
+		if (!tp->args[i].type->print(s, tp->args[i].name,
+					     data + tp->args[i].offset))
 			goto partial;
 
 	if (!trace_seq_puts(s, "\n"))
@@ -1046,13 +1151,14 @@ partial:
 enum print_line_t
 print_kretprobe_event(struct trace_iterator *iter, int flags)
 {
-	struct kretprobe_trace_entry *field;
+	struct kretprobe_trace_entry_head *field;
 	struct trace_seq *s = &iter->seq;
 	struct trace_event *event;
 	struct trace_probe *tp;
+	u8 *data;
 	int i;
 
-	field = (struct kretprobe_trace_entry *)iter->ent;
+	field = (struct kretprobe_trace_entry_head *)iter->ent;
 	event = ftrace_find_event(field->ent.type);
 	tp = container_of(event, struct trace_probe, event);
 
@@ -1071,9 +1177,10 @@ print_kretprobe_event(struct trace_iterator *iter, int flags)
 	if (!trace_seq_puts(s, ")"))
 		goto partial;
 
-	for (i = 0; i < field->nargs; i++)
-		if (!trace_seq_printf(s, " %s=%lx",
-				      tp->args[i].name, field->args[i]))
+	data = (u8 *)&field[1];
+	for (i = 0; i < tp->nr_args; i++)
+		if (!tp->args[i].type->print(s, tp->args[i].name,
+					     data + tp->args[i].offset))
 			goto partial;
 
 	if (!trace_seq_puts(s, "\n"))
@@ -1129,29 +1236,43 @@ static int probe_event_raw_init(struct ftrace_event_call *event_call)
 static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
-	struct kprobe_trace_entry field;
+	struct kprobe_trace_entry_head field;
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
-	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
 	/* Set argument names as fields */
-	for (i = 0; i < tp->nr_args; i++)
-		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
+	for (i = 0; i < tp->nr_args; i++) {
+		ret = trace_define_field(event_call, tp->args[i].type->name,
+					 tp->args[i].name,
+					 sizeof(field) + tp->args[i].offset,
+					 tp->args[i].type->size,
+					 tp->args[i].type->is_signed,
+					 FILTER_OTHER);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
 static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 {
 	int ret, i;
-	struct kretprobe_trace_entry field;
+	struct kretprobe_trace_entry_head field;
 	struct trace_probe *tp = (struct trace_probe *)event_call->data;
 
 	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
 	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
-	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
 	/* Set argument names as fields */
-	for (i = 0; i < tp->nr_args; i++)
-		DEFINE_FIELD(unsigned long, args[i], tp->args[i].name, 0);
+	for (i = 0; i < tp->nr_args; i++) {
+		ret = trace_define_field(event_call, tp->args[i].type->name,
+					 tp->args[i].name,
+					 sizeof(field) + tp->args[i].offset,
+					 tp->args[i].type->size,
+					 tp->args[i].type->is_signed,
+					 FILTER_OTHER);
+		if (ret)
+			return ret;
+	}
 	return 0;
 }
 
@@ -1176,8 +1297,8 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\"%s", fmt);
 
 	for (i = 0; i < tp->nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%%lx",
-				tp->args[i].name);
+		pos += snprintf(buf + pos, LEN_OR_ZERO, " %s=%s",
+				tp->args[i].name, tp->args[i].type->fmt);
 	}
 
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
@@ -1219,12 +1340,13 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 {
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
-	struct kprobe_trace_entry *entry;
+	struct kprobe_trace_entry_head *entry;
+	u8 *data;
 	int size, __size, i;
 	unsigned long irq_flags;
 	int rctx;
 
-	__size = SIZEOF_KPROBE_TRACE_ENTRY(tp->nr_args);
+	__size = sizeof(*entry) + tp->size;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
@@ -1235,10 +1357,10 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	if (!entry)
 		return;
 
-	entry->nargs = tp->nr_args;
 	entry->ip = (unsigned long)kp->addr;
+	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
 	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs);
 }
@@ -1249,12 +1371,13 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 {
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
-	struct kretprobe_trace_entry *entry;
+	struct kretprobe_trace_entry_head *entry;
+	u8 *data;
 	int size, __size, i;
 	unsigned long irq_flags;
 	int rctx;
 
-	__size = SIZEOF_KRETPROBE_TRACE_ENTRY(tp->nr_args);
+	__size = sizeof(*entry) + tp->size;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
@@ -1265,11 +1388,11 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	if (!entry)
 		return;
 
-	entry->nargs = tp->nr_args;
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
+	data = (u8 *)&entry[1];
 	for (i = 0; i < tp->nr_args; i++)
-		entry->args[i] = call_fetch(&tp->args[i].fetch, regs);
+		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
 
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
 			       irq_flags, regs);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
