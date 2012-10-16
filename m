Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2JPJDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 05:03:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48603 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab2JPJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:02:59 -0400
X-AuditID: 9c930179-b7ca6ae000000e33-f7-507d22c0ef2d
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH] uprobes tracer: Add stack/memory/retval access support
Date: Tue, 16 Oct 2012 18:02:15 +0900
Message-Id: <1350378135-18919-1-git-send-email-hyc.lee@gmail.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Event arguments except @SYM are supported. They are @ADDR,
$stack, $stackN, $retval, and offs(arguments).

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
---
 kernel/trace/trace_kprobe.c |    6 +-
 kernel/trace/trace_probe.c  |  162 ++++++++++++++++++++++++++++++-------------
 kernel/trace/trace_probe.h  |    6 +-
 kernel/trace/trace_uprobe.c |    6 +-
 4 files changed, 124 insertions(+), 56 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 1a21170..60046d3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -683,7 +683,7 @@ static __kprobes int __get_data_size(struct trace_probe *tp,
 
 	for (i = 0; i < tp->nr_args; i++)
 		if (unlikely(tp->args[i].fetch_size.fn)) {
-			call_fetch(&tp->args[i].fetch_size, regs, &len);
+			call_fetch(&tp->args[i].fetch_size, regs, &len, true);
 			ret += len;
 		}
 
@@ -708,7 +708,7 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 			dl = (u32 *)(data + tp->args[i].offset);
 			*dl = make_data_rloc(maxlen, end - tp->args[i].offset);
 			/* Then try to fetch string or dynamic array data */
-			call_fetch(&tp->args[i].fetch, regs, dl);
+			call_fetch(&tp->args[i].fetch, regs, dl, true);
 			/* Reduce maximum length */
 			end += get_rloc_len(*dl);
 			maxlen -= get_rloc_len(*dl);
@@ -718,7 +718,7 @@ static __kprobes void store_trace_args(int ent_size, struct trace_probe *tp,
 		} else
 			/* Just fetching data normally */
 			call_fetch(&tp->args[i].fetch, regs,
-				   data + tp->args[i].offset);
+				   data + tp->args[i].offset, true);
 	}
 }
 
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index daa9980..955c3fa 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -112,7 +112,8 @@ DEFINE_FETCH_##method(u64)
 /* Data fetch function templates */
 #define DEFINE_FETCH_reg(type)						\
 static __kprobes void FETCH_FUNC_NAME(reg, type)(struct pt_regs *regs,	\
-					void *offset, void *dest)	\
+					void *offset, void *dest,	\
+					bool kprobe)			\
 {									\
 	*(type *)dest = (type)regs_get_register(regs,			\
 				(unsigned int)((unsigned long)offset));	\
@@ -122,12 +123,49 @@ DEFINE_BASIC_FETCH_FUNCS(reg)
 #define fetch_reg_string	NULL
 #define fetch_reg_string_size	NULL
 
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
+	unsigned long ret = 0;
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, (unsigned long)addr);
+	if (vma && vma->vm_start <= (unsigned long)addr) {
+		if (WITHIN_USER_STACK(vma, addr, n))
+			if (get_user(ret, addr) != 0)
+				ret = 0;
+	}
+	up_read(&current->mm->mmap_sem);
+	return ret;
+}
+
 #define DEFINE_FETCH_stack(type)					\
 static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
-					  void *offset, void *dest)	\
+					  void *offset, void *dest,	\
+					  bool kprobe)			\
 {									\
-	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
+	if (kprobe)							\
+		*(type *)dest = (type)regs_get_kernel_stack_nth(regs,	\
 				(unsigned int)((unsigned long)offset));	\
+	else								\
+		*(type *)dest = (type)regs_get_user_stack_nth(regs,	\
+				(unsigned int)((unsigned long)offset)); \
 }
 DEFINE_BASIC_FETCH_FUNCS(stack)
 /* No string on the stack entry */
@@ -136,7 +174,8 @@ DEFINE_BASIC_FETCH_FUNCS(stack)
 
 #define DEFINE_FETCH_retval(type)					\
 static __kprobes void FETCH_FUNC_NAME(retval, type)(struct pt_regs *regs,\
-					  void *dummy, void *dest)	\
+					  void *dummy, void *dest,	\
+					  bool kprobe)			\
 {									\
 	*(type *)dest = (type)regs_return_value(regs);			\
 }
@@ -147,13 +186,20 @@ DEFINE_BASIC_FETCH_FUNCS(retval)
 
 #define DEFINE_FETCH_memory(type)					\
 static __kprobes void FETCH_FUNC_NAME(memory, type)(struct pt_regs *regs,\
-					  void *addr, void *dest)	\
+					  void *addr, void *dest,	\
+					  bool kprobe)			\
 {									\
 	type retval;							\
-	if (probe_kernel_address(addr, retval))				\
-		*(type *)dest = 0;					\
+	if (kprobe)							\
+		if (probe_kernel_address(addr, retval))			\
+			*(type *)dest = 0;				\
+		else							\
+			*(type *)dest = retval;				\
 	else								\
-		*(type *)dest = retval;					\
+		if (get_user(retval, (type *)addr))			\
+			*(type *)dest = 0;				\
+		else							\
+			*(type *)dest = retval;				\
 }
 DEFINE_BASIC_FETCH_FUNCS(memory)
 /*
@@ -161,13 +207,13 @@ DEFINE_BASIC_FETCH_FUNCS(memory)
  * length and relative data location.
  */
 static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
-						      void *addr, void *dest)
+						      void *addr, void *dest,
+						      bool kprobe)
 {
 	long ret;
 	int maxlen = get_rloc_len(*(u32 *)dest);
 	u8 *dst = get_rloc_data(dest);
 	u8 *src = addr;
-	mm_segment_t old_fs = get_fs();
 
 	if (!maxlen)
 		return;
@@ -176,16 +222,23 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 	 * Try to get string again, since the string can be changed while
 	 * probing.
 	 */
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
+	if (kprobe) {
+		mm_segment_t old_fs = get_fs();
+		set_fs(KERNEL_DS);
+		pagefault_disable();
+
+		do
+			ret = __copy_from_user_inatomic(dst++, src++, 1);
+		while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
+
+		dst[-1] = '\0';
+		pagefault_enable();
+		set_fs(old_fs);
+	} else {
+		do
+			ret = get_user(*dst++, src++);
+		while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
+	}
 
 	if (ret < 0) {	/* Failed to fetch string */
 		((u8 *)get_rloc_data(dest))[0] = '\0';
@@ -198,23 +251,31 @@ static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
 
 /* Return the length of string -- including null terminal byte */
 static __kprobes void FETCH_FUNC_NAME(memory, string_size)(struct pt_regs *regs,
-							void *addr, void *dest)
+							void *addr, void *dest,
+							bool kprobe)
 {
-	mm_segment_t old_fs;
 	int ret, len = 0;
 	u8 c;
 
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-	pagefault_disable();
+	if (kprobe) {
+		mm_segment_t old_fs = get_fs();
+		set_fs(KERNEL_DS);
+		pagefault_disable();
 
-	do {
-		ret = __copy_from_user_inatomic(&c, (u8 *)addr + len, 1);
-		len++;
-	} while (c && ret == 0 && len < MAX_STRING_SIZE);
+		do {
+			ret = __copy_from_user_inatomic(&c, (u8 *)addr + len,
+							1);
+			len++;
+		} while (c && ret == 0 && len < MAX_STRING_SIZE);
 
-	pagefault_enable();
-	set_fs(old_fs);
+		pagefault_enable();
+		set_fs(old_fs);
+	} else {
+		do {
+			ret = get_user(c, (u8 *)addr + len);
+			len++;
+		} while (c && ret == 0 && len < MAX_STRING_SIZE);
+	}
 
 	if (ret < 0)	/* Failed to check the length */
 		*(u32 *)dest = 0;
@@ -269,11 +330,13 @@ static struct symbol_cache *alloc_symbol_cache(const char *sym, long offset)
 
 #define DEFINE_FETCH_symbol(type)					\
 static __kprobes void FETCH_FUNC_NAME(symbol, type)(struct pt_regs *regs,\
-					  void *data, void *dest)	\
+					  void *data, void *dest,	\
+					  bool kprobe)			\
 {									\
 	struct symbol_cache *sc = data;					\
-	if (sc->addr)							\
-		fetch_memory_##type(regs, (void *)sc->addr, dest);	\
+	if (kprobe && sc->addr)						\
+		fetch_memory_##type(regs, (void *)sc->addr, dest,	\
+				    kprobe);				\
 	else								\
 		*(type *)dest = 0;					\
 }
@@ -289,14 +352,15 @@ struct deref_fetch_param {
 
 #define DEFINE_FETCH_deref(type)					\
 static __kprobes void FETCH_FUNC_NAME(deref, type)(struct pt_regs *regs,\
-					    void *data, void *dest)	\
+					    void *data, void *dest,	\
+					    bool kprobe)		\
 {									\
 	struct deref_fetch_param *dprm = data;				\
 	unsigned long addr;						\
-	call_fetch(&dprm->orig, regs, &addr);				\
+	call_fetch(&dprm->orig, regs, &addr, kprobe);			\
 	if (addr) {							\
 		addr += dprm->offset;					\
-		fetch_memory_##type(regs, (void *)addr, dest);		\
+		fetch_memory_##type(regs, (void *)addr, dest, kprobe);	\
 	} else								\
 		*(type *)dest = 0;					\
 }
@@ -330,11 +394,12 @@ struct bitfield_fetch_param {
 
 #define DEFINE_FETCH_bitfield(type)					\
 static __kprobes void FETCH_FUNC_NAME(bitfield, type)(struct pt_regs *regs,\
-					    void *data, void *dest)	\
+					    void *data, void *dest,	\
+					    bool kprobe)		\
 {									\
 	struct bitfield_fetch_param *bprm = data;			\
 	type buf = 0;							\
-	call_fetch(&bprm->orig, regs, &buf);				\
+	call_fetch(&bprm->orig, regs, &buf, kprobe);			\
 	if (buf) {							\
 		buf <<= bprm->hi_shift;					\
 		buf >>= bprm->low_shift;				\
@@ -467,8 +532,8 @@ fail:
 }
 
 /* Special function : only accept unsigned long */
-static __kprobes void fetch_stack_address(struct pt_regs *regs,
-					void *dummy, void *dest)
+static __kprobes void fetch_stack_address(struct pt_regs *regs, void *dummy,
+					  void *dest, bool kprobe)
 {
 	*(unsigned long *)dest = kernel_stack_pointer(regs);
 }
@@ -516,7 +581,8 @@ int traceprobe_split_symbol_offset(char *symbol, unsigned long *offset)
 #define PARAM_MAX_STACK (THREAD_SIZE / sizeof(unsigned long))
 
 static int parse_probe_vars(char *arg, const struct fetch_type *t,
-			    struct fetch_param *f, bool is_return)
+			    struct fetch_param *f, bool is_return,
+			    bool is_kprobe)
 {
 	int ret = 0;
 	unsigned long param;
@@ -534,7 +600,7 @@ static int parse_probe_vars(char *arg, const struct fetch_type *t,
 				ret = -EINVAL;
 		} else if (isdigit(arg[5])) {
 			ret = strict_strtoul(arg + 5, 10, &param);
-			if (ret || param > PARAM_MAX_STACK)
+			if (ret || (is_kprobe && param > PARAM_MAX_STACK))
 				ret = -EINVAL;
 			else {
 				f->fn = t->fetch[FETCH_MTD_stack];
@@ -559,13 +625,9 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 
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
@@ -586,6 +648,10 @@ static int parse_probe_arg(char *arg, const struct fetch_type *t,
 			f->fn = t->fetch[FETCH_MTD_memory];
 			f->data = (void *)param;
 		} else {
+			/* uprobe_events doesn't support symbol argments */
+			if (!is_kprobe)
+				return -EINVAL;
+
 			ret = traceprobe_split_symbol_offset(arg + 1, &offset);
 			if (ret)
 				break;
diff --git a/kernel/trace/trace_probe.h b/kernel/trace/trace_probe.h
index 9337086..e11738c 100644
--- a/kernel/trace/trace_probe.h
+++ b/kernel/trace/trace_probe.h
@@ -83,7 +83,7 @@
 #define convert_rloc_to_loc(dl, offs)	((u32)(dl) + (offs))
 
 /* Data fetch function type */
-typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *);
+typedef	void (*fetch_func_t)(struct pt_regs *, void *, void *, bool);
 /* Printing function type */
 typedef int (*print_type_func_t)(struct trace_seq *, const char *, void *, void *);
 
@@ -126,9 +126,9 @@ struct probe_arg {
 };
 
 static inline __kprobes void call_fetch(struct fetch_param *fprm,
-				 struct pt_regs *regs, void *dest)
+				 struct pt_regs *regs, void *dest, bool kprobe)
 {
-	return fprm->fn(regs, fprm->data, dest);
+	return fprm->fn(regs, fprm->data, dest, kprobe);
 }
 
 /* Check the name is good for event/group/fields */
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 03003cd..b01758c 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -491,7 +491,8 @@ static void uprobe_trace_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	entry->ip = uprobe_get_swbp_addr(task_pt_regs(current));
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+		call_fetch(&tu->args[i].fetch, regs,
+			   data + tu->args[i].offset, false);
 
 	if (!filter_current_check_discard(buffer, call, entry, event))
 		trace_buffer_unlock_commit(buffer, event, irq_flags, pc);
@@ -667,7 +668,8 @@ static void uprobe_perf_func(struct trace_uprobe *tu, struct pt_regs *regs)
 	entry->ip = uprobe_get_swbp_addr(task_pt_regs(current));
 	data = (u8 *)&entry[1];
 	for (i = 0; i < tu->nr_args; i++)
-		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset);
+		call_fetch(&tu->args[i].fetch, regs, data + tu->args[i].offset,
+			   false);
 
 	head = this_cpu_ptr(call->perf_events);
 	perf_trace_buf_submit(entry, size, rctx, entry->ip, 1, regs, head, NULL);
-- 
1.7.10.4

