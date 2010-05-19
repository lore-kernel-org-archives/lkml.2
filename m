Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0ESTw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:52:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab0ESTwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:52:25 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/4] tracing/kprobes: Support "string" type
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 19 May 2010 15:57:25 -0400
Message-ID: <20100519195724.2885.18788.stgit@localhost6.localdomain6>
In-Reply-To: <20100519195717.2885.90799.stgit@localhost6.localdomain6>
References: <20100519195717.2885.90799.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support string type tracing and printing in kprobe-tracer.
This allows user to trace string data in kernel including
__user data. Note that sometimes __user data may not be
accessed if it is paged-out (sorry, but kprobes operation
should be done in atomic, we can not wait for page-in).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 Documentation/trace/kprobetrace.txt |    2 
 kernel/trace/trace_kprobe.c         |  370 ++++++++++++++++++++++++++++-------
 2 files changed, 293 insertions(+), 79 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index ec94748..5f77d94 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -42,7 +42,7 @@ Synopsis of kprobe_events
   +|-offs(FETCHARG) : Fetch memory at FETCHARG +|- offs address.(**)
   NAME=FETCHARG : Set NAME as the argument name of FETCHARG.
   FETCHARG:TYPE : Set TYPE as the type of FETCHARG. Currently, basic types
-		  (u8/u16/u32/u64/s8/s16/s32/s64) are supported.
+		  (u8/u16/u32/u64/s8/s16/s32/s64) and string are supported.
 
   (*) only for return probe.
   (**) this is useful for fetching a field of data structures.
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 2d7bf41..10fcc4e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -30,6 +30,8 @@
 #include <linux/ptrace.h>
 #include <linux/perf_event.h>
 #include <linux/stringify.h>
+#include <linux/limits.h>
+#include <linux/uaccess.h>
 #include <asm/bitsperlong.h>
 
 #include "trace.h"
@@ -38,6 +40,7 @@
 #define MAX_TRACE_ARGS 128
 #define MAX_ARGSTR_LEN 63
 #define MAX_EVENT_NAME_LEN 64
+#define MAX_STRING_SIZE PATH_MAX
 #define KPROBE_EVENT_SYSTEM "kprobes"
 
 /* Reserved field names */
@@ -58,14 +61,16 @@ const char *reserved_field_names[] = {
 };
 
 /* Printing function type */
-typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *);
+typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *,
+				 void *);
 #define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
 #define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
 
 /* Printing  in basic type function template */
 #define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
 static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
-						const char *name, void *data)\
+						const char *name,	\
+						void *data, void *ent)\
 {									\
 	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
 }									\
@@ -80,6 +85,49 @@ DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
 
+/* data_rloc: data relative location, compatible with u32 */
+#define make_data_rloc(len, roffs)	\
+	(((u32)(len) << 16) | ((u32)(roffs) & 0xffff))
+#define get_rloc_len(dl)	((u32)(dl) >> 16)
+#define get_rloc_offs(dl)	((u32)(dl) & 0xffff)
+
+static inline void *get_rloc_data(u32 *dl)
+{
+	return (u8 *)dl + get_rloc_offs(*dl);
+}
+
+/* For data_loc conversion */
+static inline void *get_loc_data(u32 *dl, void *ent)
+{
+	return (u8 *)ent + get_rloc_offs(*dl);
+}
+
+/*
+ * Convert data_rloc to data_loc:
+ *  data_rloc stores the offset from data_rloc itself, but data_loc
+ *  stores the offset from event entry.
+ */
+#define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
+
+/* For defining macros, define string/string_size types */
+typedef u32 string;
+typedef u32 string_size;
+
+/* Print type function for string type */
+static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
+						  const char *name,
+						  void *data, void *ent)
+{
+	int len = *(u32 *)data >> 16;
+
+	if (!len)
+		return trace_seq_printf(s, " %s=(fault)", name);
+	else
+		return trace_seq_printf(s, " %s=\"%s\"", name,
+					(const char *)get_loc_data(data, ent));
+}
+static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
+
 /* Data fetch function type */
 typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
 
@@ -94,32 +142,38 @@ static __kprobes void call_fetch(struct fetch_param *fprm,
 	return fprm->fn(regs, fprm->data, dest);
 }
 
-#define FETCH_FUNC_NAME(kind, type)	fetch_##kind##_##type
+#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
 /*
  * Define macro for basic types - we don't need to define s* types, because
  * we have to care only about bitwidth at recording time.
  */
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
+#define DEFINE_BASIC_FETCH_FUNCS(method) \
+DEFINE_FETCH_##method(u8)		\
+DEFINE_FETCH_##method(u16)		\
+DEFINE_FETCH_##method(u32)		\
+DEFINE_FETCH_##method(u64)
+
+#define CHECK_FETCH_FUNCS(method, fn)			\
+	(((FETCH_FUNC_NAME(method, u8) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, u16) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, u32) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, u64) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, string) == fn) ||	\
+	  (FETCH_FUNC_NAME(method, string_size) == fn)) \
+	 && (fn != NULL))
 
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
 static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
-					  void *offset, void *dest)	\
+					void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
 }
 DEFINE_BASIC_FETCH_FUNCS(reg)
+/* No string on the register */
+#define fetch_reg_string NULL
+#define fetch_reg_string_size NULL
 
 #define DEFINE_FETCH_stack(type)					\
 static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
@@ -129,6 +183,9 @@ static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
 				(unsigned int)((unsigned long)offset));	\
 }
 DEFINE_BASIC_FETCH_FUNCS(stack)
+/* No string on the stack entry */
+#define fetch_stack_string NULL
+#define fetch_stack_string_size NULL
 
 #define DEFINE_FETCH_retval(type)					\
 static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
@@ -137,6 +194,9 @@ static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
 	*(type *)dest = (type)regs_return_value(regs);			\
 }
 DEFINE_BASIC_FETCH_FUNCS(retval)
+/* No string on the retval */
+#define fetch_retval_string NULL
+#define fetch_retval_string_size NULL
 
 #define DEFINE_FETCH_memory(type)					\
 static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
@@ -149,6 +209,62 @@ static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
 		*(type *)dest = retval;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(memory)
+/*
+ * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
+ * length and relative data location.
+ */
+static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+						      void *addr, void *dest)
+{
+	long ret;
+	int maxlen = get_rloc_len(*(u32 *)dest);
+	u8 *dst = get_rloc_data(dest);
+	u8 *src = addr;
+	mm_segment_t old_fs = get_fs();
+	if (!maxlen)
+		return;
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+	do
+		ret = __copy_from_user_inatomic(dst++, src++, 1);
+	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
+	dst[-1] = '\0';
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0) {	/* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
+	} else
+		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
+					      get_rloc_offs(*(u32 *)dest));
+}
+/* Return the length of string -- including null terminal byte */
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+							void *addr, void *dest)
+{
+	int ret, len = 0;
+	u8 c;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+	do {
+		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0)	/* Failed to check the length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
 
 /* Memory fetching by symbol */
 struct symbol_cache {
@@ -203,6 +319,8 @@ static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(symbol)
+DEFINE_FETCH_symbol(string)
+DEFINE_FETCH_symbol(string_size)
 
 /* Dereference memory access function */
 struct deref_fetch_param {
@@ -224,12 +342,14 @@ static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(deref)
+DEFINE_FETCH_deref(string)
+DEFINE_FETCH_deref(string_size)
 
 static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 {
-	if (CHECK_BASIC_FETCH_FUNCS(deref, data->orig.fn))
+	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		free_deref_fetch_param(data->orig.data);
-	else if (CHECK_BASIC_FETCH_FUNCS(symbol, data->orig.fn))
+	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
 		free_symbol_cache(data->orig.data);
 	kfree(data);
 }
@@ -240,23 +360,43 @@ static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 #define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
 #define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
 
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
+/* Fetch types */
+enum {
+	FETCH_MTD_reg = 0,
+	FETCH_MTD_stack,
+	FETCH_MTD_retval,
+	FETCH_MTD_memory,
+	FETCH_MTD_symbol,
+	FETCH_MTD_deref,
+	FETCH_MTD_END,
+};
+
+#define ASSIGN_FETCH_FUNC(method, type)	\
+	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
+
+#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
+	{.name = _name,				\
+	 .size = _size,					\
+	 .is_signed = sign,				\
+	 .print = PRINT_TYPE_FUNC_NAME(ptype),		\
+	 .fmt = PRINT_TYPE_FMT_NAME(ptype),		\
+	 .fmttype = _fmttype,				\
+	 .fetch = {					\
+ASSIGN_FETCH_FUNC(reg, ftype),				\
+ASSIGN_FETCH_FUNC(stack, ftype),			\
+ASSIGN_FETCH_FUNC(retval, ftype),			\
+ASSIGN_FETCH_FUNC(memory, ftype),			\
+ASSIGN_FETCH_FUNC(symbol, ftype),			\
+ASSIGN_FETCH_FUNC(deref, ftype),			\
+	  }						\
 	}
 
+#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
+	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
+
+#define FETCH_TYPE_STRING 0
+#define FETCH_TYPE_STRSIZE 1
+
 /* Fetch type information table */
 static const struct fetch_type {
 	const char	*name;		/* Name of type */
@@ -264,14 +404,16 @@ static const struct fetch_type {
 	int		is_signed;	/* Signed flag */
 	print_type_func_t	print;	/* Print functions */
 	const char	*fmt;		/* Fromat string */
+	const char	*fmttype;	/* Name in format file */
 	/* Fetch functions */
-	fetch_func_t	reg;
-	fetch_func_t	stack;
-	fetch_func_t	retval;
-	fetch_func_t	memory;
-	fetch_func_t	symbol;
-	fetch_func_t	deref;
+	fetch_func_t	fetch[FETCH_MTD_END];
 } fetch_type_table[] = {
+	/* Special types */
+	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
+					sizeof(u32), 1, "__data_loc char[]"),
+	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
+					string_size, sizeof(u32), 0, "u32"),
+	/* Basic types */
 	ASSIGN_FETCH_TYPE(u8,  u8,  0),
 	ASSIGN_FETCH_TYPE(u16, u16, 0),
 	ASSIGN_FETCH_TYPE(u32, u32, 0),
@@ -302,12 +444,28 @@ static __kprobes void fetch_stack_address(struct pt_regs *regs,
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
 
+static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
+					    fetch_func_t orig_fn)
+{
+	int i;
+
+	if (type != &fetch_type_table[FETCH_TYPE_STRING])
+		return NULL;	/* Only string type needs size function */
+	for (i = 0; i < FETCH_MTD_END; i++)
+		if (type->fetch[i] == orig_fn)
+			return fetch_type_table[FETCH_TYPE_STRSIZE].fetch[i];
+
+	WARN_ON(1);	/* This should not happen */
+	return NULL;
+}
+
 /**
  * Kprobe event core functions
  */
 
 struct probe_arg {
 	struct fetch_param	fetch;
+	struct fetch_param	fetch_size;
 	unsigned int		offset;	/* Offset from argument entry */
 	const char		*name;	/* Name of this argument */
 	const char		*comm;	/* Command of this argument */
@@ -428,9 +586,9 @@ error:
 
 static void free_probe_arg(struct probe_arg *arg)
 {
-	if (CHECK_BASIC_FETCH_FUNCS(deref, arg->fetch.fn))
+	if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
 		free_deref_fetch_param(arg->fetch.data);
-	else if (CHECK_BASIC_FETCH_FUNCS(symbol, arg->fetch.fn))
+	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
 		free_symbol_cache(arg->fetch.data);
 	kfree(arg->name);
 	kfree(arg->comm);
@@ -547,7 +705,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 
 	if (strcmp(arg, "retval") == 0) {
 		if (is_return)
-			f->fn = t->retval;
+			f->fn = t->fetch[FETCH_MTD_retval];
 		else
 			ret = -EINVAL;
 	} else if (strncmp(arg, "stack", 5) == 0) {
@@ -561,7 +719,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			if (ret || param > PARAM_MAX_STACK)
 				ret = -EINVAL;
 			else {
-				f->fn = t->stack;
+				f->fn = t->fetch[FETCH_MTD_stack];
 				f->data = (void *)param;
 			}
 		} else
@@ -587,7 +745,7 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 	case '%':	/* named register */
 		ret = regs_query_register_offset(arg + 1);
 		if (ret >= 0) {
-			f->fn = t->reg;
+			f->fn = t->fetch[FETCH_MTD_reg];
 			f->data = (void *)(unsigned long)ret;
 			ret = 0;
 		}
@@ -597,7 +755,7 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 			ret = strict_strtoul(arg + 1, 0, &param);
 			if (ret)
 				break;
-			f->fn = t->memory;
+			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
 		} else {
 			ret = split_symbol_offset(arg + 1, &offset);
@@ -605,7 +763,7 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 				break;
 			f->data = alloc_symbol_cache(arg + 1, offset);
 			if (f->data)
-				f->fn = t->symbol;
+				f->fn = t->fetch[FETCH_MTD_symbol];
 		}
 		break;
 	case '+':	/* deref memory */
@@ -635,14 +793,17 @@ static int __parse_probe_arg(char *arg, const struct fetch_type *t,
 			if (ret)
 				kfree(dprm);
 			else {
-				f->fn = t->deref;
+				f->fn = t->fetch[FETCH_MTD_deref];
 				f->data = (void *)dprm;
 			}
 		}
 		break;
 	}
-	if (!ret && !f->fn)
+	if (!ret && !f->fn) {	/* Parsed, but do not find fetch method */
+		pr_info("%s type has no corresponding fetch method.\n",
+			t->name);
 		ret = -EINVAL;
+	}
 	return ret;
 }
 
@@ -651,6 +812,7 @@ static int parse_probe_arg(char *arg, struct trace_probe *tp,
 			   struct probe_arg *parg, int is_return)
 {
 	const char *t;
+	int ret;
 
 	if (strlen(arg) > MAX_ARGSTR_LEN) {
 		pr_info("Argument is too long.: %s\n",  arg);
@@ -673,7 +835,13 @@ static int parse_probe_arg(char *arg, struct trace_probe *tp,
 	}
 	parg->offset = tp->size;
 	tp->size += parg->type->size;
-	return __parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
+	ret = __parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
+	if (ret >= 0) {
+		parg->fetch_size.fn = get_fetch_size_function(parg->type,
+							      parg->fetch.fn);
+		parg->fetch_size.data = parg->fetch.data;
+	}
+	return ret;
 }
 
 /* Return 1 if name is reserved or already used by another argument */
@@ -1042,6 +1210,54 @@ static const struct file_operations kprobe_profile_ops = {
 	.release        = seq_release,
 };
 
+/* Sum up total data length for dynamic arraies (strings) */
+static __kprobes int __get_data_size(struct trace_probe *tp,
+				     struct pt_regs *regs)
+{
+	int i, ret = 0;
+	u32 len;
+
+	for (i = 0; i < tp->nr_args; i++)
+		if (unlikely(tp->args[i].fetch_size.fn)) {
+			call_fetch(&tp->args[i].fetch_size, regs, &len);
+			ret += len;
+		}
+
+	return ret;
+}
+
+/* Store the value of each argument */
+static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
+				       struct pt_regs *regs,
+				       u8 *data, int maxlen)
+{
+	int i;
+	u32 end = tp->size;
+	u32 *dl;	/* Data (relative) location */
+
+	for (i = 0; i < tp->nr_args; i++) {
+		if (unlikely(tp->args[i].fetch_size.fn)) {
+			/*
+			 * First, we set the relative location and
+			 * maximum data length to *dl
+			 */
+			dl = (u32 *)(data + tp->args[i].offset);
+			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
+			/* Then try to fetch string or dynamic array data */
+			call_fetch(&tp->args[i].fetch, regs, dl);
+			/* Reduce maximum length */
+			end += get_rloc_len(*dl);
+			maxlen -= get_rloc_len(*dl);
+			/* Trick here, convert data_rloc to data_loc */
+			*dl = convert_rloc_to_loc(*dl,
+				 ent_size + tp->args[i].offset);
+		} else
+			/* Just fetching data normally */
+			call_fetch(&tp->args[i].fetch, regs,
+				   data + tp->args[i].offset);
+	}
+}
+
 /* Kprobe handler */
 static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 {
@@ -1049,8 +1265,7 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	struct kprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	u8 *data;
-	int size, i, pc;
+	int size, dsize, pc;
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
@@ -1059,7 +1274,8 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	size = sizeof(*entry) + tp->size;
+	dsize = __get_data_size(tp, regs);
+	size = sizeof(*entry) + tp->size + dsize;
 
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
@@ -1068,9 +1284,7 @@ static __kprobes void kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 
 	entry = ring_buffer_event_data(event);
 	entry->ip = (unsigned long)kp->addr;
-	data = (u8 *)&entry[1];
-	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
@@ -1084,15 +1298,15 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 	struct kretprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	u8 *data;
-	int size, i, pc;
+	int size, pc, dsize;
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	size = sizeof(*entry) + tp->size;
+	dsize = __get_data_size(tp, regs);
+	size = sizeof(*entry) + tp->size + dsize;
 
 	event = trace_current_buffer_lock_reserve(&buffer, call->id, size,
 						  irq_flags, pc);
@@ -1102,9 +1316,7 @@ static __kprobes void kretprobe_trace_func(struct kretprobe_instance *ri,
 	entry = ring_buffer_event_data(event);
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	data = (u8 *)&entry[1];
-	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_nowake_buffer_unlock_commit(buffer, event, irq_flags, pc);
@@ -1137,7 +1349,7 @@ print_kprobe_event(struct trace_iterator *iter, int flags)
 	data = (u8 *)&field[1];
 	for (i = 0; i < tp->nr_args; i++)
 		if (!tp->args[i].type->print(s, tp->args[i].name,
-					     data + tp->args[i].offset))
+					     data + tp->args[i].offset, field))
 			goto partial;
 
 	if (!trace_seq_puts(s, "\n"))
@@ -1180,7 +1392,7 @@ print_kretprobe_event(struct trace_iterator *iter, int flags)
 	data = (u8 *)&field[1];
 	for (i = 0; i < tp->nr_args; i++)
 		if (!tp->args[i].type->print(s, tp->args[i].name,
-					     data + tp->args[i].offset))
+					     data + tp->args[i].offset, field))
 			goto partial;
 
 	if (!trace_seq_puts(s, "\n"))
@@ -1242,7 +1454,7 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
 	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
 	/* Set argument names as fields */
 	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_define_field(event_call, tp->args[i].type->name,
+		ret = trace_define_field(event_call, tp->args[i].type->fmttype,
 					 tp->args[i].name,
 					 sizeof(field) + tp->args[i].offset,
 					 tp->args[i].type->size,
@@ -1264,7 +1476,7 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
 	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
 	/* Set argument names as fields */
 	for (i = 0; i < tp->nr_args; i++) {
-		ret = trace_define_field(event_call, tp->args[i].type->name,
+		ret = trace_define_field(event_call, tp->args[i].type->fmttype,
 					 tp->args[i].name,
 					 sizeof(field) + tp->args[i].offset,
 					 tp->args[i].type->size,
@@ -1304,8 +1516,13 @@ static int __set_print_fmt(struct trace_probe *tp, char *buf, int len)
 	pos += snprintf(buf + pos, LEN_OR_ZERO, "\", %s", arg);
 
 	for (i = 0; i < tp->nr_args; i++) {
-		pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
-				tp->args[i].name);
+		if (strcmp(tp->args[i].type->name, "string") == 0)
+			pos += snprintf(buf + pos, LEN_OR_ZERO,
+					", __get_str(%s)",
+					tp->args[i].name);
+		else
+			pos += snprintf(buf + pos, LEN_OR_ZERO, ", REC->%s",
+					tp->args[i].name);
 	}
 
 #undef LEN_OR_ZERO
@@ -1341,12 +1558,12 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 	struct trace_probe *tp = container_of(kp, struct trace_probe, rp.kp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kprobe_trace_entry_head *entry;
-	u8 *data;
-	int size, __size, i;
+	int size, __size, dsize;
 	unsigned long irq_flags;
 	int rctx;
 
-	__size = sizeof(*entry) + tp->size;
+	dsize = __get_data_size(tp, regs);
+	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
@@ -1358,9 +1575,8 @@ static __kprobes void kprobe_perf_func(struct kprobe *kp,
 		return;
 
 	entry->ip = (unsigned long)kp->addr;
-	data = (u8 *)&entry[1];
-	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+	memset(&entry[1], 0, dsize);
+	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, irq_flags, regs, call->perf_data);
 }
@@ -1372,12 +1588,12 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 	struct trace_probe *tp = container_of(ri->rp, struct trace_probe, rp);
 	struct ftrace_event_call *call = &tp->call;
 	struct kretprobe_trace_entry_head *entry;
-	u8 *data;
-	int size, __size, i;
+	int size, __size, dsize;
 	unsigned long irq_flags;
 	int rctx;
 
-	__size = sizeof(*entry) + tp->size;
+	dsize = __get_data_size(tp, regs);
+	__size = sizeof(*entry) + tp->size + dsize;
 	size = ALIGN(__size + sizeof(u32), sizeof(u64));
 	size -= sizeof(u32);
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
@@ -1390,9 +1606,7 @@ static __kprobes void kretprobe_perf_func(struct kretprobe_instance *ri,
 
 	entry->func = (unsigned long)tp->rp.kp.addr;
 	entry->ret_ip = (unsigned long)ri->ret_addr;
-	data = (u8 *)&entry[1];
-	for (i = 0; i < tp->nr_args; i++)
-		call_fetch(&tp->args[i].fetch, regs, data + tp->args[i].offset);
+	store_trace_args(sizeof(*entry), tp, regs, (u8 *)&entry[1], dsize);
 
 	perf_trace_buf_submit(entry, size, rctx, entry->ret_ip, 1,
 			       irq_flags, regs, call->perf_data);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
