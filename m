Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab0HYNrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:47:47 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:53609 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0HYNrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:47:41 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 25 Aug 2010 19:12:55 +0530
Message-Id: <20100825134255.5447.86890.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv11 2.6.36-rc2-tip 8/15]  8: tracing: Extract out common code for kprobes/uprobes traceevents.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move parts of trace_kprobe.c that can be shared with upcoming
trace_uprobe.c. Common code to kernel/trace/trace_probe.h and
kernel/trace/trace_probe.c.

TODO: Merge both events to a single probe event.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog from V10: delete references to is_kprobe and make
         is_return a bool.

Changelog from V7: Merge changes due to string support in kprobes
	traceevent.

Changelog from V5: Addressed comments from Masami Hiramatsu
	and Steven Rostedt. Also shared lot more code from kprobes
        traceevents.

 kernel/trace/Kconfig        |    4 
 kernel/trace/Makefile       |    1 
 kernel/trace/trace_kprobe.c |  752 +------------------------------------------
 kernel/trace/trace_probe.c  |  648 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_probe.h  |  155 +++++++++
 5 files changed, 822 insertions(+), 738 deletions(-)
 create mode 100644 kernel/trace/trace_probe.c
 create mode 100644 kernel/trace/trace_probe.h

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 538501c..d709697 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -353,6 +353,7 @@ config KPROBE_EVENT
 	depends on HAVE_REGS_AND_STACK_ACCESS_API
 	bool "Enable kprobes-based dynamic events"
 	select TRACING
+	select PROBE_EVENTS
 	default y
 	help
 	  This allows the user to add tracing events (similar to tracepoints)
@@ -365,6 +366,9 @@ config KPROBE_EVENT
 	  This option is also required by perf-probe subcommand of perf tools.
 	  If you want to use perf tools, this option is strongly recommended.
 
+config PROBE_EVENTS
+	def_bool n
+
 config DYNAMIC_FTRACE
 	bool "enable/disable ftrace tracepoints dynamically"
 	depends on FUNCTION_TRACER
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 53f3381..95d2043 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -56,5 +56,6 @@ obj-$(CONFIG_EVENT_TRACING) += power-traces.o
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
+obj-$(CONFIG_PROBE_EVENTS) +=trace_probe.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 8b27c98..e66450d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -19,463 +19,15 @@
 
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
-#include <linux/limits.h>
-#include <linux/uaccess.h>
-#include <asm/bitsperlong.h>
 
-#include "trace.h"
-#include "trace_output.h"
+#include "trace_probe.h"
 
-#define MAX_TRACE_ARGS 128
-#define MAX_ARGSTR_LEN 63
-#define MAX_EVENT_NAME_LEN 64
-#define MAX_STRING_SIZE PATH_MAX
 #define KPROBE_EVENT_SYSTEM "kprobes"
 
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
-typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *,
-				 void *);
-#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
-#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
-
-/* Printing  in basic type function template */
-#define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
-						const char *name,	\
-						void *data, void *ent)\
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
-/* data_rloc: data relative location, compatible with u32 */
-#define make_data_rloc(len, roffs)	\
-	(((u32)(len) << 16) | ((u32)(roffs) & 0xffff))
-#define get_rloc_len(dl)	((u32)(dl) >> 16)
-#define get_rloc_offs(dl)	((u32)(dl) & 0xffff)
-
-static inline void *get_rloc_data(u32 *dl)
-{
-	return (u8 *)dl + get_rloc_offs(*dl);
-}
-
-/* For data_loc conversion */
-static inline void *get_loc_data(u32 *dl, void *ent)
-{
-	return (u8 *)ent + get_rloc_offs(*dl);
-}
-
-/*
- * Convert data_rloc to data_loc:
- *  data_rloc stores the offset from data_rloc itself, but data_loc
- *  stores the offset from event entry.
- */
-#define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
-
-/* For defining macros, define string/string_size types */
-typedef u32 string;
-typedef u32 string_size;
-
-/* Print type function for string type */
-static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
-						  const char *name,
-						  void *data, void *ent)
-{
-	int len = *(u32 *)data >> 16;
-
-	if (!len)
-		return trace_seq_printf(s, " %s=(fault)", name);
-	else
-		return trace_seq_printf(s, " %s=\"%s\"", name,
-					(const char *)get_loc_data(data, ent));
-}
-static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
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
-#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
-/*
- * Define macro for basic types - we don't need to define s* types, because
- * we have to care only about bitwidth at recording time.
- */
-#define DEFINE_BASIC_FETCH_FUNCS(method) \
-DEFINE_FETCH_##method(u8)		\
-DEFINE_FETCH_##method(u16)		\
-DEFINE_FETCH_##method(u32)		\
-DEFINE_FETCH_##method(u64)
-
-#define CHECK_FETCH_FUNCS(method, fn)			\
-	(((FETCH_FUNC_NAME(method, u8) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, u16) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, u32) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, u64) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, string) == fn) ||	\
-	  (FETCH_FUNC_NAME(method, string_size) == fn)) \
-	 && (fn != NULL))
-
-/* Data fetch function templates */
-#define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
-					void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_register(regs,			\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(reg)
-/* No string on the register */
-#define fetch_reg_string NULL
-#define fetch_reg_string_size NULL
-
-#define DEFINE_FETCH_stack(type)					\
-static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
-				(unsigned int)((unsigned long)offset));	\
-}
-DEFINE_BASIC_FETCH_FUNCS(stack)
-/* No string on the stack entry */
-#define fetch_stack_string NULL
-#define fetch_stack_string_size NULL
-
-#define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
-					  void *dummy, void *dest)	\
-{									\
-	*(type *)dest = (type)regs_return_value(regs);			\
-}
-DEFINE_BASIC_FETCH_FUNCS(retval)
-/* No string on the retval */
-#define fetch_retval_string NULL
-#define fetch_retval_string_size NULL
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
-/*
- * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
- * length and relative data location.
- */
-static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
-{
-	long ret;
-	int maxlen = get_rloc_len(*(u32 *)dest);
-	u8 *dst = get_rloc_data(dest);
-	u8 *src = addr;
-	mm_segment_t old_fs = get_fs();
-	if (!maxlen)
-		return;
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-	do
-		ret = __copy_from_user_inatomic(dst++, src++, 1);
-	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
-	dst[-1] = '\0';
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0) {	/* Failed to fetch string */
-		((u8 *)get_rloc_data(dest))[0] = '\0';
-		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
-	} else
-		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
-					      get_rloc_offs(*(u32 *)dest));
-}
-/* Return the length of string -- including null terminal byte */
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-							void *addr, void *dest)
-{
-	int ret, len = 0;
-	u8 c;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-	do {
-		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
-		len++;
-	} while (c && ret == 0 && len < MAX_STRING_SIZE);
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0)	/* Failed to check the length */
-		*(u32 *)dest = 0;
-	else
-		*(u32 *)dest = len;
-}
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
-DEFINE_FETCH_symbol(string)
-DEFINE_FETCH_symbol(string_size)
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
-DEFINE_FETCH_deref(string)
-DEFINE_FETCH_deref(string_size)
-
-static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
-{
-	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
-		free_deref_fetch_param(data->orig.data);
-	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
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
-/* Fetch types */
-enum {
-	FETCH_MTD_reg = 0,
-	FETCH_MTD_stack,
-	FETCH_MTD_retval,
-	FETCH_MTD_memory,
-	FETCH_MTD_symbol,
-	FETCH_MTD_deref,
-	FETCH_MTD_END,
-};
-
-#define ASSIGN_FETCH_FUNC(method, type)	\
-	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
-
-#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
-	{.name = _name,				\
-	 .size = _size,					\
-	 .is_signed = sign,				\
-	 .print = PRINT_TYPE_FUNC_NAME(ptype),		\
-	 .fmt = PRINT_TYPE_FMT_NAME(ptype),		\
-	 .fmttype = _fmttype,				\
-	 .fetch = {					\
-ASSIGN_FETCH_FUNC(reg, ftype),				\
-ASSIGN_FETCH_FUNC(stack, ftype),			\
-ASSIGN_FETCH_FUNC(retval, ftype),			\
-ASSIGN_FETCH_FUNC(memory, ftype),			\
-ASSIGN_FETCH_FUNC(symbol, ftype),			\
-ASSIGN_FETCH_FUNC(deref, ftype),			\
-	  }						\
-	}
-
-#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
-	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
-
-#define FETCH_TYPE_STRING 0
-#define FETCH_TYPE_STRSIZE 1
-
-/* Fetch type information table */
-static const struct fetch_type {
-	const char	*name;		/* Name of type */
-	size_t		size;		/* Byte size of type */
-	int		is_signed;	/* Signed flag */
-	print_type_func_t	print;	/* Print functions */
-	const char	*fmt;		/* Fromat string */
-	const char	*fmttype;	/* Name in format file */
-	/* Fetch functions */
-	fetch_func_t	fetch[FETCH_MTD_END];
-} fetch_type_table[] = {
-	/* Special types */
-	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
-					sizeof(u32), 1, "__data_loc char[]"),
-	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
-					string_size, sizeof(u32), 0, "u32"),
-	/* Basic types */
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
-
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
-
-static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
-					    fetch_func_t orig_fn)
-{
-	int i;
-
-	if (type != &fetch_type_table[FETCH_TYPE_STRING])
-		return NULL;	/* Only string type needs size function */
-	for (i = 0; i < FETCH_MTD_END; i++)
-		if (type->fetch[i] == orig_fn)
-			return fetch_type_table[FETCH_TYPE_STRSIZE].fetch[i];
-
-	WARN_ON(1);	/* This should not happen */
-	return NULL;
-}
-
 /**
  * Kprobe event core functions
  */
 
-struct probe_arg {
-	struct fetch_param	fetch;
-	struct fetch_param	fetch_size;
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
@@ -513,19 +65,6 @@ static LIST_HEAD(probe_list);
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
@@ -534,7 +73,7 @@ static struct trace_probe *alloc_trace_probe(const char *group,
 					     void *addr,
 					     const char *symbol,
 					     unsigned long offs,
-					     int nargs, int is_return)
+					     int nargs, bool is_return)
 {
 	struct trace_probe *tp;
 	int ret = -ENOMEM;
@@ -585,22 +124,12 @@ error:
 	return ERR_PTR(ret);
 }
 
-static void free_probe_arg(struct probe_arg *arg)
-{
-	if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
-		free_deref_fetch_param(arg->fetch.data);
-	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
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
+		traceprobe_free_probe_arg(&tp->args[i]);
 
 	kfree(tp->call.class->system);
 	kfree(tp->call.name);
@@ -674,191 +203,6 @@ end:
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
-			f->fn = t->fetch[FETCH_MTD_retval];
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
-				f->fn = t->fetch[FETCH_MTD_stack];
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
-			f->fn = t->fetch[FETCH_MTD_reg];
-			f->data = (void *)(unsigned long)ret;
-			ret = 0;
-		}
-		break;
-	case '@':	/* memory or symbol */
-		if (isdigit(arg[1])) {
-			ret = strict_strtoul(arg + 1, 0, &param);
-			if (ret)
-				break;
-			f->fn = t->fetch[FETCH_MTD_memory];
-			f->data = (void *)param;
-		} else {
-			ret = split_symbol_offset(arg + 1, &offset);
-			if (ret)
-				break;
-			f->data = alloc_symbol_cache(arg + 1, offset);
-			if (f->data)
-				f->fn = t->fetch[FETCH_MTD_symbol];
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
-				f->fn = t->fetch[FETCH_MTD_deref];
-				f->data = (void *)dprm;
-			}
-		}
-		break;
-	}
-	if (!ret && !f->fn) {	/* Parsed, but do not find fetch method */
-		pr_info("%s type has no corresponding fetch method.\n",
-			t->name);
-		ret = -EINVAL;
-	}
-	return ret;
-}
-
-/* String length checking wrapper */
-static int parse_probe_arg(char *arg, struct trace_probe *tp,
-			   struct probe_arg *parg, int is_return)
-{
-	const char *t;
-	int ret;
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
-	ret = __parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
-	if (ret >= 0) {
-		parg->fetch_size.fn = get_fetch_size_function(parg->type,
-							      parg->fetch.fn);
-		parg->fetch_size.data = parg->fetch.data;
-	}
-	return ret;
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
@@ -881,7 +225,7 @@ static int create_trace_probe(int argc, char **argv)
 	 */
 	struct trace_probe *tp;
 	int i, ret = 0;
-	int is_return = 0, is_delete = 0;
+	bool is_return = false, is_delete = false;
 	char *symbol = NULL, *event = NULL, *group = NULL;
 	char *arg, *tmp;
 	unsigned long offset = 0;
@@ -890,11 +234,11 @@ static int create_trace_probe(int argc, char **argv)
 
 	/* argc must be >= 1 */
 	if (argv[0][0] == 'p')
-		is_return = 0;
+		is_return = false;
 	else if (argv[0][0] == 'r')
-		is_return = 1;
+		is_return = true;
 	else if (argv[0][0] == '-')
-		is_delete = 1;
+		is_delete = true;
 	else {
 		pr_info("Probe definition must be started with 'p', 'r' or"
 			" '-'.\n");
@@ -958,7 +302,7 @@ static int create_trace_probe(int argc, char **argv)
 		/* a symbol specified */
 		symbol = argv[1];
 		/* TODO: support .init module functions */
-		ret = split_symbol_offset(symbol, &offset);
+		ret = traceprobe_split_symbol_offset(symbol, &offset);
 		if (ret) {
 			pr_info("Failed to parse symbol.\n");
 			return ret;
@@ -1010,7 +354,8 @@ static int create_trace_probe(int argc, char **argv)
 		if (tmp)
 			*tmp = '_';	/* convert : to _ */
 
-		if (conflict_field_name(tp->args[i].name, tp->args, i)) {
+		if (traceprobe_conflict_field_name(tp->args[i].name,
+							tp->args, i)) {
 			pr_info("Argument%d name '%s' conflicts with "
 				"another field.\n", i, argv[i]);
 			ret = -EINVAL;
@@ -1018,7 +363,8 @@ static int create_trace_probe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = parse_probe_arg(arg, tp, &tp->args[i], is_return);
+		ret = traceprobe_parse_probe_arg(arg, &tp->size, &tp->args[i],
+								is_return);
 		if (ret) {
 			pr_info("Parse error at argument%d. (%d)\n", i, ret);
 			kfree(tp->args[i].name);
@@ -1108,70 +454,11 @@ static int probes_open(struct inode *inode, struct file *file)
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
+	return traceprobe_probes_write(file, buffer, count, ppos,
+			create_trace_probe);
 }
 
 static const struct file_operations kprobe_events_ops = {
@@ -1429,17 +716,6 @@ static void probe_event_disable(struct ftrace_event_call *call)
 	}
 }
 
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
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
new file mode 100644
index 0000000..4ca48c6
--- /dev/null
+++ b/kernel/trace/trace_probe.c
@@ -0,0 +1,648 @@
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
+ * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
+						const char *name,	\
+						void *data, void *ent)\
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
+#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
+/*
+ * Define macro for basic types - we don't need to define s* types, because
+ * we have to care only about bitwidth at recording time.
+ */
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
+
+/* Data fetch function templates */
+#define DEFINE_FETCH_reg(type)						\
+static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+					void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_register(regs,			\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(reg)
+/* No string on the register */
+#define fetch_reg_string NULL
+#define fetch_reg_string_size NULL
+
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+/* No string on the stack entry */
+#define fetch_stack_string NULL
+#define fetch_stack_string_size NULL
+
+#define DEFINE_FETCH_retval(type)					\
+static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+					  void *dummy, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_return_value(regs);			\
+}
+DEFINE_BASIC_FETCH_FUNCS(retval)
+/* No string on the retval */
+#define fetch_retval_string NULL
+#define fetch_retval_string_size NULL
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
+DEFINE_FETCH_symbol(string)
+DEFINE_FETCH_symbol(string_size)
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
+	call_fetch(&dprm->orig, regs, &addr);				\
+	if (addr) {							\
+		addr += dprm->offset;					\
+		fetch_memory_##type(regs, (void *)addr, dest);		\
+	} else								\
+		*(type *)dest = 0;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(deref)
+DEFINE_FETCH_deref(string)
+DEFINE_FETCH_deref(string_size)
+
+static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
+{
+	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
+		free_deref_fetch_param(data->orig.data);
+	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
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
+	}
+
+#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
+	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
+
+#define FETCH_TYPE_STRING 0
+#define FETCH_TYPE_STRSIZE 1
+
+/* Fetch type information table */
+static const struct fetch_type fetch_type_table[] = {
+	/* Special types */
+	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,
+					sizeof(u32), 1, "__data_loc char[]"),
+	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,
+					string_size, sizeof(u32), 0, "u32"),
+	/* Basic types */
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
+/* Split symbol and offset. */
+int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
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
+			    struct fetch_param *f, bool is_return)
+{
+	int ret = 0;
+	unsigned long param;
+
+	if (strcmp(arg, "retval") == 0) {
+		if (is_return)
+			f->fn = t->fetch[FETCH_MTD_retval];
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
+				f->fn = t->fetch[FETCH_MTD_stack];
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
+static int parse_probe_arg(char *arg, const struct fetch_type *t,
+		     struct fetch_param *f, bool is_return)
+{
+	int ret = 0;
+	unsigned long param;
+	long offset;
+	char *tmp;
+
+	switch (arg[0]) {
+	case '$':
+		ret = parse_probe_vars(arg + 1, t, f, is_return);
+		break;
+	case '%':	/* named register */
+		ret = regs_query_register_offset(arg + 1);
+		if (ret >= 0) {
+			f->fn = t->fetch[FETCH_MTD_reg];
+			f->data = (void *)(unsigned long)ret;
+			ret = 0;
+		}
+		break;
+	case '@':	/* memory or symbol */
+		if (isdigit(arg[1])) {
+			ret = strict_strtoul(arg + 1, 0, &param);
+			if (ret)
+				break;
+			f->fn = t->fetch[FETCH_MTD_memory];
+			f->data = (void *)param;
+		} else {
+			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
+			if (ret)
+				break;
+			f->data = alloc_symbol_cache(arg + 1, offset);
+			if (f->data)
+				f->fn = t->fetch[FETCH_MTD_symbol];
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
+			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return);
+			if (ret)
+				kfree(dprm);
+			else {
+				f->fn = t->fetch[FETCH_MTD_deref];
+				f->data = (void *)dprm;
+			}
+		}
+		break;
+	}
+	if (!ret && !f->fn) {	/* Parsed, but do not find fetch method */
+		pr_info("%s type has no corresponding fetch method.\n",
+			t->name);
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+/* String length checking wrapper */
+int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
+		struct probe_arg *parg, bool is_return)
+{
+	const char *t;
+	int ret;
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
+	ret = parse_probe_arg(arg, parg->type, &parg->fetch, is_return);
+
+	if (ret >= 0) {
+		parg->fetch_size.fn = get_fetch_size_function(parg->type,
+							      parg->fetch.fn);
+		parg->fetch_size.data = parg->fetch.data;
+	}
+	return ret;
+}
+
+/* Return 1 if name is reserved or already used by another argument */
+int traceprobe_conflict_field_name(const char *name,
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
+void traceprobe_free_probe_arg(struct probe_arg *arg)
+{
+	if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
+		free_deref_fetch_param(arg->fetch.data);
+	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
+		free_symbol_cache(arg->fetch.data);
+	kfree(arg->name);
+	kfree(arg->comm);
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
+ssize_t traceprobe_probes_write(struct file *file, const char __user *buffer,
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
index 0000000..74311ea
--- /dev/null
+++ b/kernel/trace/trace_probe.h
@@ -0,0 +1,155 @@
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
+ * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
+#include <linux/stringify.h>
+#include <linux/limits.h>
+#include <linux/uaccess.h>
+#include <asm/bitsperlong.h>
+
+#include "trace.h"
+#include "trace_output.h"
+
+#define MAX_TRACE_ARGS 128
+#define MAX_ARGSTR_LEN 63
+#define MAX_EVENT_NAME_LEN 64
+#define MAX_STRING_SIZE PATH_MAX
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
+
+/* data_rloc: data relative location, compatible with u32 */
+#define make_data_rloc(len, roffs)	\
+	(((u32)(len) << 16) | ((u32)(roffs) & 0xffff))
+#define get_rloc_len(dl)	((u32)(dl) >> 16)
+#define get_rloc_offs(dl)	((u32)(dl) & 0xffff)
+
+/*
+ * Convert data_rloc to data_loc:
+ *  data_rloc stores the offset from data_rloc itself, but data_loc
+ *  stores the offset from event entry.
+ */
+#define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
+
+/* Data fetch function type */
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+/* Printing function type */
+typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *,
+				 void *);
+
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
+/* Fetch type information table */
+struct fetch_type {
+	const char	*name;		/* Name of type */
+	size_t		size;		/* Byte size of type */
+	int		is_signed;	/* Signed flag */
+	print_type_func_t	print;	/* Print functions */
+	const char	*fmt;		/* Fromat string */
+	const char	*fmttype;	/* Name in format file */
+	/* Fetch functions */
+	fetch_func_t	fetch[FETCH_MTD_END];
+};
+
+struct fetch_param {
+	fetch_func_t	fn;
+	void *data;
+};
+
+struct probe_arg {
+	struct fetch_param	fetch;
+	struct fetch_param	fetch_size;
+	unsigned int		offset;	/* Offset from argument entry */
+	const char		*name;	/* Name of this argument */
+	const char		*comm;	/* Command of this argument */
+	const struct fetch_type	*type;	/* Type of this argument */
+};
+
+static inline __kprobes void call_fetch(struct fetch_param *fprm,
+				 struct pt_regs *regs, void *dest)
+{
+	return fprm->fn(regs, fprm->data, dest);
+}
+
+/* Check the name is good for event/group */
+static inline int check_event_name(const char *name)
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
+extern int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
+		   struct probe_arg *parg, bool is_return);
+
+extern int traceprobe_conflict_field_name(const char *name,
+			       struct probe_arg *args, int narg);
+
+extern void traceprobe_free_probe_arg(struct probe_arg *arg);
+
+extern int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset);
+
+extern ssize_t traceprobe_probes_write(struct file *file,
+		const char __user *buffer, size_t count, loff_t *ppos,
+		int (*createfn)(int, char**));
