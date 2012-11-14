Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab2KNHN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:13:58 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55893 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2KNHN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:13:56 -0500
X-AuditID: 9c930179-b7c9dae000000e53-b0-50a344ae0129
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] uprobes tracer: Add support for @ADDR, @stackN, dereference, bitfield arguments
Date: Wed, 14 Nov 2012 16:13:42 +0900
Message-Id: <1352877222-23797-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for @ADDR, @stackN, dereference, bitfield arguments. Uprobes
tracer supported only register argument. @SYMBOL, $retval, $stack are not
supported. because a symbol address and whether function starts at a given
address can't be known.

Uprobes tracer and kprobes tracer have their own fetch type information
tables and fetch type functions. But they share printing type functions
and some fetch type functions for register, dereference, and bitfield.
The common functions are defined in trace_probe.c.

Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
v2 - separate fetch type functions for uprobes and kprobes tracer
v3 - define macro for fetch type table definition and fix 
CHECK_FETCH_FUNCS and string dereference bugs
---
 kernel/trace/trace_kprobe.c |   97 +++++++++-
 kernel/trace/trace_probe.c  |  434 ++++++++++++++++---------------------------
 kernel/trace/trace_probe.h  |  140 +++++++++++++-
 kernel/trace/trace_uprobe.c |  166 ++++++++++++++++-
 4 files changed, 546 insertions(+), 291 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1a21170..676f514 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -24,10 +24,102 @@
 
 #define KPROBE_EVENT_SYSTEM "kprobes"
 
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
+static DEFINE_FETCH_TYPE_TABLE(fetch_type_table);
+
 /**
  * Kprobe event core functions
  */
-
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -525,7 +617,8 @@ static int create_trace_probe(int argc, char **argv)
 
 		/* Parse fetch argument */
 		ret = traceprobe_parse_probe_arg(arg, &tp->size, &tp->args[i],
-						is_return, true);
+						is_return, true,
+						fetch_type_table);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index daa9980..db263d9 100644
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
@@ -87,140 +68,30 @@ static __kprobes int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s,
 					(const char *)get_loc_data(data, ent));
 }
 
-static const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
+const char PRINT_TYPE_FMT_NAME(string)[] = "\\\"%s\\\"";
 
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
+#define CHECK_FETCH_FUNCS(t, method, fn)			\
+	 (((t)->fetch[FETCH_MTD_##method] == fn)			\
 	 && (fn != NULL))
 
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
@@ -229,66 +100,92 @@ struct symbol_cache {
 	unsigned long	addr;
 };
 
-static unsigned long update_symbol_cache(struct symbol_cache *sc)
+struct symbol_fetch_param {
+	struct symbol_cache sc;
+	fetch_func_t fetch;
+	fetch_func_t fetch_size;
+};
+
+static unsigned long update_symbol_fetch_param(struct symbol_fetch_param *data,
+					       const struct fetch_type *t)
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
+static void free_symbol_fetch_param(struct symbol_fetch_param *data,
+				    const struct fetch_type *t)
 {
-	kfree(sc->symbol);
-	kfree(sc);
+	kfree(data->sc.symbol);
+	kfree(data);
 }
 
-static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
+static fetch_func_t get_fetch_size_function(const struct fetch_type [],
+		const struct fetch_type *, fetch_func_t);
+
+static struct symbol_fetch_param *alloc_symbol_fetch_param(const char *sym,
+					long offset, fetch_func_t fetch,
+					fetch_func_t fetch_size)
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
+	data->fetch = fetch;
+	data->fetch_size = fetch_size;
+	data->sc.symbol = kstrdup(sym, GFP_KERNEL);
+	if (!data->sc.symbol) {
+		kfree(data);
 		return NULL;
 	}
-	sc->offset = offset;
-	update_symbol_cache(sc);
+	data->sc.offset = offset;
+	update_symbol_fetch_param(data, NULL);
 
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
+		sdpm->fetch(regs, (void *)sdpm->sc.addr, dest);		\
 	else								\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(symbol)
 DEFINE_FETCH_symbol(string)
-DEFINE_FETCH_symbol(string_size)
+
+__kprobes void FETCH_FUNC_NAME(symbol, string_size)(struct pt_regs *regs,
+					  void *data, void *dest)
+{
+	struct symbol_fetch_param *sdpm  = data;
+	if (sdpm->sc.addr && sdpm->fetch_size)
+		sdpm->fetch_size(regs, (void *)sdpm->sc.addr, dest);
+	else
+		*(string_size *)dest = 0;
+}
 
 /* Dereference memory access function */
 struct deref_fetch_param {
 	struct fetch_param	orig;
 	long			offset;
+	fetch_func_t		fetch;
+	fetch_func_t		fetch_size;
 };
 
 #define DEFINE_FETCH_deref(type)					\
-static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 					    void *data, void *dest)	\
 {									\
 	struct deref_fetch_param *dprm = data;				\
@@ -296,28 +193,43 @@ static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
 	call_fetch(&dprm->orig, regs, &addr);				\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		fetch_memory_##type(regs, (void *)addr, dest);		\
+		dprm->fetch(regs, (void *)addr, dest);		\
 	} else								\
 		*(type *)dest = 0;					\
 }
 DEFINE_BASIC_FETCH_FUNCS(deref)
 DEFINE_FETCH_deref(string)
-DEFINE_FETCH_deref(string_size)
 
-static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data)
+__kprobes void FETCH_FUNC_NAME(deref, string_size)(struct pt_regs *regs,
+						   void *data, void *dest)
 {
-	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
-		update_deref_fetch_param(data->orig.data);
-	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		update_symbol_cache(data->orig.data);
+	struct deref_fetch_param *dprm = data;
+	unsigned long addr;
+
+	call_fetch(&dprm->orig, regs, &addr);
+	if (addr && dprm->fetch_size) {
+		addr += dprm->offset;
+		dprm->fetch_size(regs, (void *)addr, dest);
+	} else
+		*(string_size *)dest = 0;
 }
 
-static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data)
+static __kprobes void update_deref_fetch_param(struct deref_fetch_param *data,
+					       const struct fetch_type *t)
 {
-	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
-		free_deref_fetch_param(data->orig.data);
-	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		free_symbol_cache(data->orig.data);
+	if (CHECK_FETCH_FUNCS(t, deref, data->orig.fn))
+		update_deref_fetch_param(data->orig.data, t);
+	else if (CHECK_FETCH_FUNCS(t, symbol, data->orig.fn))
+		update_symbol_fetch_param(data->orig.data, t);
+}
+
+static __kprobes void free_deref_fetch_param(struct deref_fetch_param *data,
+					     const struct fetch_type *t)
+{
+	if (CHECK_FETCH_FUNCS(t, deref, data->orig.fn))
+		free_deref_fetch_param(data->orig.data, t);
+	else if (CHECK_FETCH_FUNCS(t, symbol, data->orig.fn))
+		free_symbol_fetch_param(data->orig.data, t);
 	kfree(data);
 }
 
@@ -329,7 +241,7 @@ struct bitfield_fetch_param {
 };
 
 #define DEFINE_FETCH_bitfield(type)					\
-static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
+__kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
 					    void *data, void *dest)	\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
@@ -343,33 +255,33 @@ static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
 }
 
 DEFINE_BASIC_FETCH_FUNCS(bitfield)
-#define fetch_bitfield_string		NULL
-#define fetch_bitfield_string_size	NULL
 
 static __kprobes void
-update_bitfield_fetch_param(struct bitfield_fetch_param *data)
+update_bitfield_fetch_param(struct bitfield_fetch_param *data,
+			    const struct fetch_type *t)
 {
 	/*
 	 * Don't check the bitfield itself, because this must be the
 	 * last fetch function.
 	 */
-	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
-		update_deref_fetch_param(data->orig.data);
-	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		update_symbol_cache(data->orig.data);
+	if (CHECK_FETCH_FUNCS(t, deref, data->orig.fn))
+		update_deref_fetch_param(data->orig.data, t);
+	else if (CHECK_FETCH_FUNCS(t, symbol, data->orig.fn))
+		update_symbol_fetch_param(data->orig.data, t);
 }
 
 static __kprobes void
-free_bitfield_fetch_param(struct bitfield_fetch_param *data)
+free_bitfield_fetch_param(struct bitfield_fetch_param *data,
+			  const struct fetch_type *t)
 {
 	/*
 	 * Don't check the bitfield itself, because this must be the
 	 * last fetch function.
 	 */
-	if (CHECK_FETCH_FUNCS(deref, data->orig.fn))
-		free_deref_fetch_param(data->orig.data);
-	else if (CHECK_FETCH_FUNCS(symbol, data->orig.fn))
-		free_symbol_cache(data->orig.data);
+	if (CHECK_FETCH_FUNCS(t, deref, data->orig.fn))
+		free_deref_fetch_param(data->orig.data, t);
+	else if (CHECK_FETCH_FUNCS(t, symbol, data->orig.fn))
+		free_symbol_fetch_param(data->orig.data, t);
 
 	kfree(data);
 }
@@ -380,52 +292,8 @@ free_bitfield_fetch_param(struct bitfield_fetch_param *data)
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
-/* Fetch type information table */
-static const struct fetch_type fetch_type_table[] = {
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
+static const struct fetch_type *find_fetch_type(const struct fetch_type ttbl[],
+						const char *type)
 {
 	int i;
 
@@ -446,44 +314,44 @@ static const struct fetch_type *find_fetch_type(const char *type)
 
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
 }
 
 /* Special function : only accept unsigned long */
-static __kprobes void fetch_stack_address(struct pt_regs *regs,
+static __kprobes void fetch_kernel_stack_address(struct pt_regs *regs,
 					void *dummy, void *dest)
 {
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
@@ -528,13 +397,14 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 			ret = -EINVAL;
 	} else if (strncmp(arg, "stack", 5) == 0) {
 		if (arg[5] == '\0') {
-			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0)
-				f->fn = fetch_stack_address;
-			else
+			if (strcmp(t->name, DEFAULT_FETCH_TYPE_STR) == 0 &&
+			    is_kprobe) {
+				f->fn = fetch_kernel_stack_address;
+			} else
 				ret = -EINVAL;
 		} else if (isdigit(arg[5])) {
 			ret = strict_strtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
+			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
 				ret = -EINVAL;
 			else {
 				f->fn = t->fetch[FETCH_MTD_stack];
@@ -550,7 +420,8 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 
 /* Recursive argument parser */
 static int parse_probe_arg(char *arg, const struct fetch_type *t,
-		     struct fetch_param *f, bool is_return, bool is_kprobe)
+		     struct fetch_param *f, bool is_return, bool is_kprobe,
+		     const struct fetch_type ttbl[])
 {
 	unsigned long param;
 	long offset;
@@ -559,13 +430,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
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
@@ -586,11 +453,21 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
 		} else {
+			fetch_func_t fn;
+
+			/* uprobe_events doesn't support symbol arguments */
+			if (!is_kprobe)
+				return -EINVAL;
+
 			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
 
-			f->data = alloc_symbol_cache(arg + 1, offset);
+			fn = get_fetch_size_function(ttbl, t,
+					t->fetch[FETCH_MTD_memory]);
+			f->data = alloc_symbol_fetch_param(arg + 1, offset,
+					t->fetch[FETCH_MTD_memory], fn);
+
 			if (f->data)
 				f->fn = t->fetch[FETCH_MTD_symbol];
 		}
@@ -616,7 +493,7 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			struct deref_fetch_param	*dprm;
 			const struct fetch_type		*t2;
 
-			t2 = find_fetch_type(NULL);
+			t2 = find_fetch_type(ttbl, NULL);
 			*tmp = '\0';
 			dprm = kzalloc(sizeof(struct deref_fetch_param), GFP_KERNEL);
 
@@ -624,8 +501,11 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 				return -ENOMEM;
 
 			dprm->offset = offset;
+			dprm->fetch = t->fetch[FETCH_MTD_memory];
+			dprm->fetch_size = get_fetch_size_function(ttbl,
+						t, dprm->fetch);
 			ret = parse_probe_arg(arg, t2, &dprm->orig, is_return,
-							is_kprobe);
+					      is_kprobe, ttbl);
 			if (ret)
 				kfree(dprm);
 			else {
@@ -683,7 +563,8 @@ static int __parse_bitfield_probe_arg(const char *bf,
 
 /* String length checking wrapper */
 int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
-		struct probe_arg *parg, bool is_return, bool is_kprobe)
+		struct probe_arg *parg, bool is_return, bool is_kprobe,
+		const struct fetch_type ttbl[])
 {
 	const char *t;
 	int ret;
@@ -702,21 +583,22 @@ int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
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
 
@@ -742,22 +624,22 @@ int traceprobe_conflict_field_name(const char *name,
 
 void traceprobe_update_arg(struct probe_arg *arg)
 {
-	if (CHECK_FETCH_FUNCS(bitfield, arg->fetch.fn))
-		update_bitfield_fetch_param(arg->fetch.data);
-	else if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
-		update_deref_fetch_param(arg->fetch.data);
-	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
-		update_symbol_cache(arg->fetch.data);
+	if (CHECK_FETCH_FUNCS(arg->type, bitfield, arg->fetch.fn))
+		update_bitfield_fetch_param(arg->fetch.data, arg->type);
+	else if (CHECK_FETCH_FUNCS(arg->type, deref, arg->fetch.fn))
+		update_deref_fetch_param(arg->fetch.data, arg->type);
+	else if (CHECK_FETCH_FUNCS(arg->type, symbol, arg->fetch.fn))
+		update_symbol_fetch_param(arg->fetch.data, arg->type);
 }
 
 void traceprobe_free_probe_arg(struct probe_arg *arg)
 {
-	if (CHECK_FETCH_FUNCS(bitfield, arg->fetch.fn))
-		free_bitfield_fetch_param(arg->fetch.data);
-	else if (CHECK_FETCH_FUNCS(deref, arg->fetch.fn))
-		free_deref_fetch_param(arg->fetch.data);
-	else if (CHECK_FETCH_FUNCS(symbol, arg->fetch.fn))
-		free_symbol_cache(arg->fetch.data);
+	if (CHECK_FETCH_FUNCS(arg->type, bitfield, arg->fetch.fn))
+		free_bitfield_fetch_param(arg->fetch.data, arg->type);
+	else if (CHECK_FETCH_FUNCS(arg->type, deref, arg->fetch.fn))
+		free_deref_fetch_param(arg->fetch.data, arg->type);
+	else if (CHECK_FETCH_FUNCS(arg->type, symbol, arg->fetch.fn))
+		free_symbol_fetch_param(arg->fetch.data, arg->type);
 
 	kfree(arg->name);
 	kfree(arg->comm);
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 9337086..dfbb203 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -61,14 +61,12 @@
 			return ret;					\
 	} while (0)
 
-
 /* Flags for trace_probe */
 #define TP_FLAG_TRACE		1
 #define TP_FLAG_PROFILE		2
 #define TP_FLAG_REGISTERED	4
 #define TP_FLAG_UPROBE		8
 
-
 /* data_rloc: data relative location, compatible with u32 */
 #define make_data_rloc(len, roffs)	\
 	(((u32)(len) << 16) | ((u32)(roffs) & 0xffff))
@@ -82,11 +80,23 @@
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
 
+/* Data fetch function type */
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+
 /* Fetch types */
 enum {
 	FETCH_MTD_reg = 0,
@@ -99,7 +109,10 @@ enum {
 	FETCH_MTD_END,
 };
 
-/* Fetch type information table */
+/* For defining macros, define string/string_size types */
+typedef u32 string;
+typedef u32 string_size;
+
 struct fetch_type {
 	const char		*name;		/* Name of type */
 	size_t			size;		/* Byte size of type */
@@ -125,6 +138,120 @@ struct probe_arg {
 	const struct fetch_type	*type;	/* Type of this argument */
 };
 
+/* For Fetch type table */
+#define NUM_FETCH_TYPES		10
+#define FETCH_TYPE_STRING	0
+#define FETCH_TYPE_STRSIZE	1
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
+/* Fetch type table template */
+#define DEFINE_FETCH_TYPE_TABLE(_name) \
+const struct fetch_type _name[NUM_FETCH_TYPES] = {		\
+	/* Special types */						\
+	[FETCH_TYPE_STRING] = __ASSIGN_FETCH_TYPE("string", string, string,  \
+					sizeof(u32), 1, "__data_loc char[]"),\
+	[FETCH_TYPE_STRSIZE] = __ASSIGN_FETCH_TYPE("string_size", u32,	     \
+					string_size, sizeof(u32), 0, "u32"), \
+	/* Basic types */						\
+	ASSIGN_FETCH_TYPE(u8,  u8,  0),					\
+	ASSIGN_FETCH_TYPE(u16, u16, 0),					\
+	ASSIGN_FETCH_TYPE(u32, u32, 0),					\
+	ASSIGN_FETCH_TYPE(u64, u64, 0),					\
+	ASSIGN_FETCH_TYPE(s8,  u8,  1),					\
+	ASSIGN_FETCH_TYPE(s16, u16, 1),					\
+	ASSIGN_FETCH_TYPE(s32, u32, 1),					\
+	ASSIGN_FETCH_TYPE(s64, u64, 1),					\
+}
+
+/* Declare printing functions */
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
+/*
+ * Macro for basic type fetch function definition
+ * we don't need to define s* types,
+ * because we have to care only about bitwidth at recording time.
+ */
+#define FETCH_FUNC_NAME(method, type)	fetch_##method##_##type
+
+#define DEFINE_BASIC_FETCH_FUNCS(method) \
+	DEFINE_FETCH_##method(u8)		\
+	DEFINE_FETCH_##method(u16)		\
+	DEFINE_FETCH_##method(u32)		\
+	DEFINE_FETCH_##method(u64)
+
+/* For fetch function declaration */
+#define DECLARE_FETCH_FUNC(method, type)				\
+	extern void FETCH_FUNC_NAME(method, type)(struct pt_regs *,	\
+						  void *, void *)
+#define DECLARE_FETCH_FUNCS(method)		\
+	DECLARE_FETCH_FUNC(method, u8);		\
+	DECLARE_FETCH_FUNC(method, u16);	\
+	DECLARE_FETCH_FUNC(method, u32);	\
+	DECLARE_FETCH_FUNC(method, u64)
+
+/* Declare register fetch functions */
+DECLARE_FETCH_FUNCS(reg);
+#define fetch_reg_string	NULL
+#define fetch_reg_string_size	NULL
+
+/* Declare return vaule fetch functions */
+DECLARE_FETCH_FUNCS(retval);
+#define fetch_retval_string		NULL
+#define fetch_retval_string_size	NULL
+
+/* Declare memory fetch by symbol functions */
+DECLARE_FETCH_FUNCS(symbol);
+DECLARE_FETCH_FUNC(symbol, string);
+DECLARE_FETCH_FUNC(symbol, string_size);
+
+DECLARE_FETCH_FUNCS(deref);
+DECLARE_FETCH_FUNC(deref, string);
+DECLARE_FETCH_FUNC(deref, string_size);
+
+/* Declare bitfield fetch functions */
+DECLARE_FETCH_FUNCS(bitfield);
+#define fetch_bitfield_string		NULL
+#define fetch_bitfield_string_size	NULL
+
 static inline __kprobes void call_fetch(struct fetch_param *fprm,
 				 struct pt_regs *regs, void *dest)
 {
@@ -144,7 +271,8 @@ static inline int is_good_name(const char *name)
 }
 
 extern int traceprobe_parse_probe_arg(char *arg, ssize_t *size,
-		   struct probe_arg *parg, bool is_return, bool is_kprobe);
+		   struct probe_arg *parg, bool is_return, bool is_kprobe,
+		   const struct fetch_type ttbl[]);
 
 extern int traceprobe_conflict_field_name(const char *name,
 			       struct probe_arg *args, int narg);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..4c018fe 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -27,6 +27,112 @@
 
 #define UPROBE_EVENT_SYSTEM	"uprobes"
 
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
+static unsigned long get_user_stack_nth(struct pt_regs *regs,
+					     unsigned int n)
+{
+	struct vm_area_struct *vma;
+	unsigned long *addr = (unsigned long *)GET_USP(regs);
+	bool valid = false;
+	unsigned long ret = 0;
+
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
+	*(type *)dest = (type)get_user_stack_nth(regs,		\
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
+static DEFINE_FETCH_TYPE_TABLE(fetch_type_table);
+
 /*
  * uprobe event core functions
  */
@@ -336,7 +442,8 @@ static int create_trace_uprobe(int argc, char **argv)
 		}
 
 		/* Parse fetch argument */
-		ret = traceprobe_parse_probe_arg(arg, &tu->size, &tu->args[i], false, false);
+		ret = traceprobe_parse_probe_arg(arg, &tu->size, &tu->args[i],
+				false, false, fetch_type_table);
 		if (ret) {
 			pr_info("Parse error at argument[%d]. (%d)\n", i, ret);
 			goto error;
@@ -464,14 +571,59 @@ static const struct file_operations uprobe_profile_ops = {
 	.release	= seq_release,
 };
 
+static void store_trace_args(int ent_size, struct trace_uprobe *tp,
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
+static int __get_data_size(struct trace_uprobe *tp,
+		    struct pt_regs *regs)
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
 /* uprobe handler */
 static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 {
 	struct uprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
 	struct ring_buffer *buffer;
-	u8 *data;
-	int size, i, pc;
+	int size, dsize, pc;
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tu->call;
 
@@ -480,7 +632,8 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
-	size = sizeof(*entry) + tu->size;
+	dsize = __get_data_size(tu, regs);
+	size = sizeof(*entry) + dsize + tu->size;
 
 	event = trace_current_buffer_lock_reserve(&buffer, call->event.type,
 						  size, irq_flags, pc);
@@ -489,9 +642,8 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 
 	entry = ring_buffer_event_data(event);
 	entry->ip = uprobe_get_swbp_addr(task_pt_regs(current));
-	data = (u8 *)&entry[1];
-	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+
+	store_trace_args(sizeof(*entry), tu, regs, (u8 *)&entry[1], dsize);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
-- 
1.7.10.4

