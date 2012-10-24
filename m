Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab2JXLae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:30:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43157 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361Ab2JXLaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:30:30 -0400
X-AuditID: 9c930179-b7c8bae000003559-27-5087d154e9a4
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH v2] uprobes tracer: Add stack/memory/retval access support
Date: Wed, 24 Oct 2012 20:29:42 +0900
Message-Id: <1351078182-31000-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Event arguments except @SYM are supported for uprobes tracer. They
are @ADDR, $stack, $stackN, $retval, and off(arguments).

uprobes tracer and kprobes tracer have their own fetch type information
tables and fetch type functions. But they share printing type functions
and some fetch type functions for register, retval, and memory dereference.
Common functions are defined in trace_probe.c.

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
---
 v2 - separate fetch type functions for uprobes and kprobes tracer

 kernel/trace/trace_kprobe.c |  147 +++++++++++++++++++++-
 kernel/trace/trace_probe.c  |  292 ++++++++++++-------------------------------
 kernel/trace/trace_probe.h  |   79 +++++++++++-
 kernel/trace/trace_uprobe.c |  158 ++++++++++++++++++++++-
 4 files changed, 460 insertions(+), 216 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1a21170..a912946 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -24,10 +24,152 @@
 
 #define KPROBE_EVENT_SYSTEM "kprobes"
 
+/*
+ * Define macro for basic types - we don't need to define s* types, because
+ * we have to care only about bitwidth at recording time.
+ */
+#define DEFINE_BASIC_FETCH_FUNCS(method)	\
+	DEFINE_FETCH_##method(u8)		\
+	DEFINE_FETCH_##method(u16)		\
+	DEFINE_FETCH_##method(u32)		\
+	DEFINE_FETCH_##method(u64)
+
+/* Stack fetch function */
+#define DEFINE_FETCH_stack(type)					\
+static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
+				(unsigned int)((unsigned long)offset));	\
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+#define fetch_stack_string	NULL
+#define fetch_stack_string_size	NULL
+
+/* Memory fetch function */
+#define DEFINE_FETCH_memory(type)					\
+static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
+						void *addr, void *dest)	\
+{									\
+	type retval;							\
+	if (probe_kernel_address(addr, retval))				\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *)dest = retval;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+
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
+
+	if (!maxlen)
+		return;
+
+	/*
+	 * Try to get string again, since the string can be changed while
+	 * probing.
+	 */
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+
+	do
+		ret = __copy_from_user_inatomic(dst++, src++, 1);
+	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
+
+	dst[-1] = '\0';
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0) {	/* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
+	} else {
+		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
+					      get_rloc_offs(*(u32 *)dest));
+	}
+}
+
+/* Return the length of string -- including null terminal byte */
+static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+							void *addr, void *dest)
+{
+	mm_segment_t old_fs;
+	int ret, len = 0;
+	u8 c;
+
+	old_fs = get_fs();
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+
+	do {
+		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+
+	pagefault_enable();
+	set_fs(old_fs);
+
+	if (ret < 0)	/* Failed to check the length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
+
+#define ASSIGN_FETCH_FUNC(method, type)	\
+	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
+
+#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
+	{.name = _name,					\
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
+ASSIGN_FETCH_FUNC(bitfield, ftype),			\
+	  }						\
+	}
+
+#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
+	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
+
+/* Fetch type information table */
+static const struct fetch_type fetch_type_table[NUM_FETCH_TYPES] = {
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
 /**
  * Kprobe event core functions
  */
-
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -525,7 +667,8 @@ static int create_trace_probe(int argc, char **argv)
 
 		/* Parse fetch argument */
 		ret = traceprobe_parse_probe_arg(arg, &tp->size, &tp->args[i],
-						is_return, true);
+						is_return, true,
+						fetch_type_table);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index daa9980..354b286 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -35,19 +35,15 @@ const char *reserved_field_names[] = {
 	FIELD_STRING_FUNC,
 };
 
-/* Printing function type */
-#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
-#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
-
 /* Printing  in basic type function template */
 #define DEFINE_BASIC_PRINT_TYPE_FUNC(type, fmt, cast)			\
-static __kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,	\
+__kprobes int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s,		\
 						const char *name,	\
-						void *data, void *ent)\
+						void *data, void *ent)	\
 {									\
 	return trace_seq_printf(s, " %s=" fmt, name, (cast)*(type *)data);\
 }									\
-static const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
+const char PRINT_TYPE_FMT_NAME(type)[] = fmt;
 
 DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
 DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
@@ -58,23 +54,8 @@ DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
 DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
 
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
-/* For defining macros, define string/string_size types */
-typedef u32 string;
-typedef u32 string_size;
-
 /* Print type function for string type */
-static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
+__kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 						  const char *name,
 						  void *data, void *ent)
 {
@@ -87,9 +68,8 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 					(const char *)get_loc_data(data, ent));
 }
 
-static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
+const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
-#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
 /*
  * Define macro for basic types - we don't need to define s* types, because
  * we have to care only about bitwidth at recording time.
@@ -111,116 +91,22 @@ DEFINE_FETCH_##method(u64)
 
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
-static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
+__kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,		\
 					void *offset, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
 }
 DEFINE_BASIC_FETCH_FUNCS(reg)
-/* No string on the register */
-#define fetch_reg_string	NULL
-#define fetch_reg_string_size	NULL
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
-#define fetch_stack_string	NULL
-#define fetch_stack_string_size	NULL
 
 #define DEFINE_FETCH_retval(type)					\
-static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
 					  void *dummy, void *dest)	\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
 }
 DEFINE_BASIC_FETCH_FUNCS(retval)
-/* No string on the retval */
-#define fetch_retval_string		NULL
-#define fetch_retval_string_size	NULL
 
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
-
-	if (!maxlen)
-		return;
-
-	/*
-	 * Try to get string again, since the string can be changed while
-	 * probing.
-	 */
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-
-	do
-		ret = __copy_from_user_inatomic(dst++, src++, 1);
-	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
-
-	dst[-1] = '\0';
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0) {	/* Failed to fetch string */
-		((u8 *)get_rloc_data(dest))[0] = '\0';
-		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
-	} else {
-		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
-					      get_rloc_offs(*(u32 *)dest));
-	}
-}
-
-/* Return the length of string -- including null terminal byte */
-static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-							void *addr, void *dest)
-{
-	mm_segment_t old_fs;
-	int ret, len = 0;
-	u8 c;
-
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-
-	do {
-		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
-		len++;
-	} while (c && ret == 0 && len < MAX_STRING_SIZE);
-
-	pagefault_enable();
-	set_fs(old_fs);
-
-	if (ret < 0)	/* Failed to check the length */
-		*(u32 *)dest = 0;
-	else
-		*(u32 *)dest = len;
-}
 
 /* Memory fetching by symbol */
 struct symbol_cache {
@@ -229,51 +115,58 @@ struct symbol_cache {
 	unsigned long	addr;
 };
 
-static unsigned long update_symbol_cache(struct symbol_cache *sc)
+struct symbol_fetch_param {
+	struct symbol_cache sc;
+	fetch_func_t fn;
+};
+
+static unsigned long update_symbol_fetch_param(struct symbol_fetch_param *data)
 {
-	sc->addr = (unsigned long)kallsyms_lookup_name(sc->symbol);
+	data->sc.addr = (unsigned long)kallsyms_lookup_name(data->sc.symbol);
 
-	if (sc->addr)
-		sc->addr += sc->offset;
+	if (data->sc.addr)
+		data->sc.addr += data->sc.offset;
 
-	return sc->addr;
+	return data->sc.addr;
 }
 
-static void free_symbol_cache(struct symbol_cache *sc)
+static void free_symbol_fetch_param(struct symbol_fetch_param *data)
 {
-	kfree(sc->symbol);
-	kfree(sc);
+	kfree(data->sc.symbol);
+	kfree(data);
 }
 
-static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
+static struct symbol_fetch_param *alloc_symbol_fetch_param(const char *sym,
+					long offset, fetch_func_t fn)
 {
-	struct symbol_cache *sc;
+	struct symbol_fetch_param *data;
 
 	if (!sym || strlen(sym) == 0)
 		return NULL;
 
-	sc = kzalloc(sizeof(struct symbol_cache), GFP_KERNEL);
-	if (!sc)
+	data = kzalloc(sizeof(struct symbol_fetch_param), GFP_KERNEL);
+	if (!data)
 		return NULL;
 
-	sc->symbol = kstrdup(sym, GFP_KERNEL);
-	if (!sc->symbol) {
-		kfree(sc);
+	data->fn = fn;
+	data->sc.symbol = kstrdup(sym, GFP_KERNEL);
+	if (!data->sc.symbol) {
+		kfree(data);
 		return NULL;
 	}
-	sc->offset = offset;
-	update_symbol_cache(sc);
+	data->sc.offset = offset;
+	update_symbol_fetch_param(data);
 
-	return sc;
+	return data;
 }
 
 #define DEFINE_FETCH_symbol(type)					\
-static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,	\
 					  void *data, void *dest)	\
 {									\
-	struct symbol_cache *sc = data;					\
-	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+	struct symbol_fetch_param *sdpm  = data;			\
+	if (sdpm->sc.addr)						\
+		sdpm->fn(regs, (void *)sdpm->sc.addr, dest);	\
 	else								\
 		*(type *)dest = 0;					\
 }
@@ -285,10 +178,11 @@ DEFINE_FETCH_symbol(string_size)
 struct deref_fetch_param {
 	struct fetch_param	orig;
 	long			offset;
+	fetch_func_t		fn;
 };
 
 #define DEFINE_FETCH_deref(type)					\
-static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 					    void *data, void *dest)	\
 {									\
 	struct deref_fetch_param *dprm = data;				\
@@ -296,7 +190,7 @@ static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 	call_fetch(&dprm->orig, regs, &addr);				\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		fetch_memory_##type(regs, (void *)addr, dest);		\
+		dprm->fn(regs, (void *)addr, dest);		\
 	} else								\
 		*(type *)dest = 0;					\
 }
@@ -309,7 +203,7 @@ static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		update_deref_fetch_param(data->orig.data);
 	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		update_symbol_cache(data->orig.data);
+		update_symbol_fetch_param(data->orig.data);
 }
 
 static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
@@ -317,7 +211,7 @@ static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		free_deref_fetch_param(data->orig.data);
 	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		free_symbol_cache(data->orig.data);
+		free_symbol_fetch_param(data->orig.data);
 	kfree(data);
 }
 
@@ -329,7 +223,7 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
 					    void *data, void *dest)	\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
@@ -343,8 +237,6 @@ static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
 }
 
 DEFINE_BASIC_FETCH_FUNCS(bitfield)
-#define fetch_bitfield_string		NULL
-#define fetch_bitfield_string_size	NULL
 
 static __kprobes void
 update_bitfield_fetch_param(struct bitfield_fetch_param *data)
@@ -356,7 +248,7 @@ update_bitfield_fetch_param(struct bitfield_fetch_param *data)
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		update_deref_fetch_param(data->orig.data);
 	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		update_symbol_cache(data->orig.data);
+		update_symbol_fetch_param(data->orig.data);
 }
 
 static __kprobes void
@@ -369,7 +261,7 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
 		free_deref_fetch_param(data->orig.data);
 	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		free_symbol_cache(data->orig.data);
+		free_symbol_fetch_param(data->orig.data);
 
 	kfree(data);
 }
@@ -380,33 +272,7 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
 #define DEFAULT_FETCH_TYPE _DEFAULT_FETCH_TYPE(BITS_PER_LONG)
 #define DEFAULT_FETCH_TYPE_STR __stringify(DEFAULT_FETCH_TYPE)
 
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
-ASSIGN_FETCH_FUNC(bitfield, ftype),			\
-	  }						\
-	}
-
-#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
-	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
-
-#define FETCH_TYPE_STRING	0
-#define FETCH_TYPE_STRSIZE	1
-
+#if 0
 /* Fetch type information table */
 static const struct fetch_type fetch_type_table[] = {
 	/* Special types */
@@ -424,8 +290,10 @@ static const struct fetch_type fetch_type_table[] = {
 	ASSIGN_FETCH_TYPE(s32, u32, 1),
 	ASSIGN_FETCH_TYPE(s64, u64, 1),
 };
+#endif
 
-static const struct fetch_type *find_fetch_type(const char *type)
+static const struct fetch_type *find_fetch_type(const struct fetch_type ttbl[],
+						const char *type)
 {
 	int i;
 
@@ -446,21 +314,21 @@ static const struct fetch_type *find_fetch_type(const char *type)
 
 		switch (bs) {
 		case 8:
-			return find_fetch_type("u8");
+			return find_fetch_type(ttbl, "u8");
 		case 16:
-			return find_fetch_type("u16");
+			return find_fetch_type(ttbl, "u16");
 		case 32:
-			return find_fetch_type("u32");
+			return find_fetch_type(ttbl, "u32");
 		case 64:
-			return find_fetch_type("u64");
+			return find_fetch_type(ttbl, "u64");
 		default:
 			goto fail;
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(fetch_type_table); i++)
-		if (strcmp(type, fetch_type_table[i].name) == 0)
-			return &fetch_type_table[i];
+	for (i = 0; i < NUM_FETCH_TYPES; i++)
+		if (strcmp(type, ttbl[i].name) == 0)
+			return &ttbl[i];
 
 fail:
 	return NULL;
@@ -473,17 +341,17 @@ static __kprobes void fetch_stack_address(struct pt_regs *regs,
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
 
-static fetch_func_t get_fetch_size_function(const struct fetch_type *type,
-					fetch_func_t orig_fn)
+static fetch_func_t get_fetch_size_function(const struct fetch_type ttbl[],
+		const struct fetch_type *type, fetch_func_t orig_fn)
 {
 	int i;
 
-	if (type != &fetch_type_table[FETCH_TYPE_STRING])
+	if (type != &ttbl[FETCH_TYPE_STRING])
 		return NULL;	/* Only string type needs size function */
 
 	for (i = 0; i < FETCH_MTD_END; i++)
 		if (type->fetch[i] == orig_fn)
-			return fetch_type_table[FETCH_TYPE_STRSIZE].fetch[i];
+			return ttbl[FETCH_TYPE_STRSIZE].fetch[i];
 
 	WARN_ON(1);	/* This should not happen */
 
@@ -516,7 +384,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
 static int parse_probe_vars(char *arg, const struct fetch_type *t,
-			    struct fetch_param *f, bool is_return)
+			    struct fetch_param *f, bool is_return,
+			    bool is_kprobe)
 {
 	int ret = 0;
 	unsigned long param;
@@ -534,7 +403,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 				ret = -EINVAL;
 		} else if (isdigit(arg[5])) {
 			ret = strict_strtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
+			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
 				ret = -EINVAL;
 			else {
 				f->fn = t->fetch[FETCH_MTD_stack];
@@ -550,7 +419,8 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 
 /* Recursive argument parser */
 static int parse_probe_arg(char *arg, const struct fetch_type *t,
-		     struct fetch_param *f, bool is_return, bool is_kprobe)
+		     struct fetch_param *f, bool is_return, bool is_kprobe,
+		     const struct fetch_type ttbl[])
 {
 	unsigned long param;
 	long offset;
@@ -559,13 +429,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
 	ret = 0;
 
-	/* Until uprobe_events supports only reg arguments */
-	if (!is_kprobe && arg[0] != '%')
-		return -EINVAL;
-
 	switch (arg[0]) {
 	case '$':
-		ret = parse_probe_vars(arg + 1, t, f, is_return);
+		ret = parse_probe_vars(arg + 1, t, f, is_return, is_kprobe);
 		break;
 
 	case '%':	/* named register */
@@ -586,11 +452,16 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
 		} else {
+			/* uprobe_events doesn't support symbol arguments */
+			if (!is_kprobe)
+				return -EINVAL;
+
 			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
 
-			f->data = alloc_symbol_cache(arg + 1, offset);
+			f->data = alloc_symbol_fetch_param(arg + 1, offset,
+						t->fetch[FETCH_MTD_memory]);
 			if (f->data)
 				f->fn = t->fetch[FETCH_MTD_symbol];
 		}
@@ -616,7 +487,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			struct deref_fetch_param	*dprm;
 			const struct fetch_type		*t2;
 
-			t2 = find_fetch_type(NULL);
+			t2 = find_fetch_type(ttbl, NULL);
 			*tmp = '\0';
 			dprm = kzalloc(sizeof(struct deref_fetch_param), GFP_KERNEL);
 
@@ -624,8 +495,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 				return -ENOMEM;
 
 			dprm->offset = offset;
+			dprm->fn = t->fetch[FETCH_MTD_memory];
 			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
-							is_kprobe);
+					      is_kprobe, ttbl);
 			if (ret)
 				kfree(dprm);
 			else {
@@ -683,7 +555,8 @@ static int __parse_bitfield_probe_arg(const char *bf,
 
 /* String length checking wrapper */
 int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
-		struct probe_arg *parg, bool is_return, bool is_kprobe)
+		struct probe_arg *parg, bool is_return, bool is_kprobe,
+		const struct fetch_type ttbl[])
 {
 	const char *t;
 	int ret;
@@ -702,21 +575,22 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
 		arg[t - parg->comm] = '\0';
 		t++;
 	}
-	parg->type = find_fetch_type(t);
+	parg->type = find_fetch_type(ttbl, t);
 	if (!parg->type) {
 		pr_info("Unsupported type: %s\n", t);
 		return -EINVAL;
 	}
 	parg->offset = *size;
 	*size += parg->type->size;
-	ret = parse_probe_arg(arg, parg->type, &parg->fetch, is_return, is_kprobe);
+	ret = parse_probe_arg(arg, parg->type, &parg->fetch, is_return,
+			      is_kprobe, ttbl);
 
 	if (ret >= 0 && t != NULL)
 		ret = __parse_bitfield_probe_arg(t, parg->type, &parg->fetch);
 
 	if (ret >= 0) {
-		parg->fetch_size.fn = get_fetch_size_function(parg->type,
-							      parg->fetch.fn);
+		parg->fetch_size.fn = get_fetch_size_function(ttbl,
+						parg->type, parg->fetch.fn);
 		parg->fetch_size.data = parg->fetch.data;
 	}
 
@@ -747,7 +621,7 @@ void traceprobe_update_arg(struct probe_arg *arg)
 	else if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
 		update_deref_fetch_param(arg->fetch.data);
 	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
-		update_symbol_cache(arg->fetch.data);
+		update_symbol_fetch_param(arg->fetch.data);
 }
 
 void traceprobe_free_probe_arg(struct probe_arg *arg)
@@ -757,7 +631,7 @@ void traceprobe_free_probe_arg(struct probe_arg *arg)
 	else if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
 		free_deref_fetch_param(arg->fetch.data);
 	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
-		free_symbol_cache(arg->fetch.data);
+		free_symbol_fetch_param(arg->fetch.data);
 
 	kfree(arg->name);
 	kfree(arg->comm);
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 9337086..69c39c3 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -82,11 +82,73 @@
  */
 #define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
 
-/* Data fetch function type */
-typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
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
 /* Printing function type */
 typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *, void *);
 
+#define PRINT_TYPE_FUNC_NAME(type)	print_type_##type
+#define PRINT_TYPE_FMT_NAME(type)	print_type_format_##type
+
+#define DECLARE_PRINT_TYPE_FUNC(type)					   \
+	extern int PRINT_TYPE_FUNC_NAME(type)(				   \
+			struct trace_seq *, const char *, void *, void *); \
+	extern const char PRINT_TYPE_FMT_NAME(type)[]
+
+DECLARE_PRINT_TYPE_FUNC(u8);
+DECLARE_PRINT_TYPE_FUNC(u16);
+DECLARE_PRINT_TYPE_FUNC(u32);
+DECLARE_PRINT_TYPE_FUNC(u64);
+DECLARE_PRINT_TYPE_FUNC(s8);
+DECLARE_PRINT_TYPE_FUNC(s16);
+DECLARE_PRINT_TYPE_FUNC(s32);
+DECLARE_PRINT_TYPE_FUNC(s64);
+DECLARE_PRINT_TYPE_FUNC(string);
+
+/* Data fetch function type */
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+
+#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
+
+#define DECLARE_FETCH_FUNC(method, type)				\
+	extern void FETCH_FUNC_NAME(method, type)(struct pt_regs *,	\
+						  void *, void *)
+#define DECLARE_FETCH_FUNCS(method)		\
+	DECLARE_FETCH_FUNC(method, u8);		\
+	DECLARE_FETCH_FUNC(method, u16);	\
+	DECLARE_FETCH_FUNC(method, u32);	\
+	DECLARE_FETCH_FUNC(method, u64)
+
+/* Common data fetch function type */
+DECLARE_FETCH_FUNCS(reg);
+#define fetch_reg_string	NULL
+#define fetch_reg_string_size	NULL
+
+DECLARE_FETCH_FUNCS(retval);
+#define fetch_retval_string		NULL
+#define fetch_retval_string_size	NULL
+
+DECLARE_FETCH_FUNCS(symbol);
+DECLARE_FETCH_FUNC(symbol, string);
+DECLARE_FETCH_FUNC(symbol, string_size);
+
+DECLARE_FETCH_FUNCS(deref);
+DECLARE_FETCH_FUNC(deref, string);
+DECLARE_FETCH_FUNC(deref, string_size);
+
+DECLARE_FETCH_FUNCS(bitfield);
+#define fetch_bitfield_string		NULL
+#define fetch_bitfield_string_size	NULL
+
 /* Fetch types */
 enum {
 	FETCH_MTD_reg = 0,
@@ -99,7 +161,15 @@ enum {
 	FETCH_MTD_END,
 };
 
-/* Fetch type information table */
+/* For fetch type information table, define macros */
+#define NUM_FETCH_TYPES		10
+#define FETCH_TYPE_STRING	0
+#define FETCH_TYPE_STRSIZE	1
+
+/* For defining macros, define string/string_size types */
+typedef u32 string;
+typedef u32 string_size;
+
 struct fetch_type {
 	const char		*name;		/* Name of type */
 	size_t			size;		/* Byte size of type */
@@ -144,7 +214,8 @@ static inline int is_good_name(const char *name)
 }
 
 extern int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
-		   struct probe_arg *parg, bool is_return, bool is_kprobe);
+		   struct probe_arg *parg, bool is_return, bool is_kprobe,
+		   const struct fetch_type ttbl[]);
 
 extern int traceprobe_conflict_field_name(const char *name,
 			       struct probe_arg *args, int narg);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..293843c 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -28,6 +28,161 @@
 #define UPROBE_EVENT_SYSTEM	"uprobes"
 
 /*
+ * Define macro for basic types - we don't need to define s* types, because
+ * we have to care only about bitwidth at recording time.
+ */
+#define DEFINE_BASIC_FETCH_FUNCS(method) \
+	DEFINE_FETCH_##method(u8)		\
+	DEFINE_FETCH_##method(u16)		\
+	DEFINE_FETCH_##method(u32)		\
+	DEFINE_FETCH_##method(u64)
+
+/* Stack fetch function */
+#ifdef CONFIG_STACK_GROWSUP
+#define	WITHIN_USER_STACK(vma, addr, n)				\
+		(						\
+			addr -= n,				\
+			(vma)->vm_start <= (unsigned long)(addr)\
+		)
+#else
+#define	WITHIN_USER_STACK(vma, addr, n)				\
+		(						\
+			addr += n,				\
+			(vma)->vm_end >= (unsigned long)(addr)	\
+		)
+#endif
+
+static unsigned long regs_get_user_stack_nth(struct pt_regs *regs,
+					     unsigned int n)
+{
+	struct vm_area_struct *vma;
+	unsigned long *addr = (unsigned long *)kernel_stack_pointer(regs);
+	bool valid = false;
+	unsigned long ret = 0;
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, (unsigned long)addr);
+	if (vma && vma->vm_start <= (unsigned long)addr) {
+		if (WITHIN_USER_STACK(vma, addr, n))
+			valid = true;
+	}
+	up_read(&current->mm->mmap_sem);
+
+	if (valid && copy_from_user(&ret, addr, sizeof(unsigned long)) == 0)
+		return ret;
+	return 0;
+}
+
+#define DEFINE_FETCH_stack(type)					\
+static void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,		\
+					  void *offset, void *dest)	\
+{									\
+	*(type *)dest = (type)regs_get_user_stack_nth(regs,		\
+			(unsigned int)((unsigned long)offset));		\
+}
+DEFINE_BASIC_FETCH_FUNCS(stack)
+#define fetch_stack_string	NULL
+#define fetch_stack_string_size	NULL
+
+/* Memory access function */
+#define DEFINE_FETCH_memory(type)					\
+static void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,		\
+						void *addr, void *dest)	\
+{									\
+	type retval;							\
+	if (copy_from_user(&retval, addr, sizeof(type)))		\
+		*(type *)dest = 0;					\
+	else								\
+		*(type *)dest = retval;					\
+}
+DEFINE_BASIC_FETCH_FUNCS(memory)
+
+static void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
+						      void *addr, void *dest)
+{
+	long ret;
+	int maxlen = get_rloc_len(*(u32 *)dest);
+	u8 *dst = get_rloc_data(dest);
+	u8 *src = addr;
+
+	if (!maxlen)
+		return;
+
+	do {
+		ret = get_user(*dst, src);
+		dst++;
+		src++;
+	} while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
+
+	if (ret < 0) {	/* Failed to fetch string */
+		((u8 *)get_rloc_data(dest))[0] = '\0';
+		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
+	} else {
+		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
+					      get_rloc_offs(*(u32 *)dest));
+	}
+}
+
+/* Return the length of string -- including null terminal byte */
+static void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
+						 void *addr, void *dest)
+{
+	int ret, len = 0;
+	u8 c;
+
+	do {
+		ret = get_user(c, (u8 *)addr + len);
+		len++;
+	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+
+	if (ret < 0)	/* Failed to check the length */
+		*(u32 *)dest = 0;
+	else
+		*(u32 *)dest = len;
+}
+
+#define ASSIGN_FETCH_FUNC(method, type)	\
+	[FETCH_MTD_##method] = FETCH_FUNC_NAME(method, type)
+
+#define __ASSIGN_FETCH_TYPE(_name, ptype, ftype, _size, sign, _fmttype)	\
+	{.name = _name,					\
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
+ASSIGN_FETCH_FUNC(bitfield, ftype),			\
+	  }						\
+	}
+
+#define ASSIGN_FETCH_TYPE(ptype, ftype, sign)			\
+	__ASSIGN_FETCH_TYPE(#ptype, ptype, ftype, sizeof(ftype), sign, #ptype)
+
+/* Fetch type information table */
+static const struct fetch_type fetch_type_table[NUM_FETCH_TYPES] = {
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
+/*
  * uprobe event core functions
  */
 struct trace_uprobe;
@@ -336,7 +491,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tu->size, &tu->args[i], false, false);
+		ret = traceprobe_parse_probe_arg(arg, &tu->size, &tu->args[i],
+				false, false, fetch_type_table);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
-- 
1.7.10.4

