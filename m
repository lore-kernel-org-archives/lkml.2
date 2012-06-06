Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab2FFEDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 00:03:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7281 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2FFEAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 00:00:16 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=MUfF2jveMuwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=82uAiwSmZCM-LPcN3QoA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=IeDOQjvFyDRn5ESm:21 a=b5HLPCun5V9480Bf:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120606040014.341624260@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 05 Jun 2012 23:51:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC][PATCH 05/12] ftrace/x86: Add separate function to save regs
References: <20120606035058.108720095@goodmis.org>
Content-Disposition: inline; filename=0005-ftrace-x86-Add-separate-function-to-save-regs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Add a way to have different functions calling different trampolines.
If a ftrace_ops wants regs saved on the return, then have only the
functions with ops registered to save regs. Functions registered by
other ops would not be affected, unless the functions overlap.

If one ftrace_ops registered functions A, B and C and another ops
registered fucntions to save regs on A, and D, then only functions
A and D would be saving regs. Function B and C would work as normal.
Although A is registered by both ops: normal and saves regs; this is fine
as saving the regs is needed to satisfy one of the ops that calls it
but the regs are ignored by the other ops function.

x86_64 implements the full regs saving, and i386 just passes a NULL
for regs to satisfy the ftrace_ops passing. Where an arch must supply
both regs and ftrace_ops parameters, even if regs is just NULL.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/ftrace.h |    3 ++
 arch/x86/kernel/entry_32.S    |    2 ++
 arch/x86/kernel/entry_64.S    |   64 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/ftrace.c      |   66 ++++++++++++++++++++++++++++++++++++---
 include/linux/ftrace.h        |   55 ++++++++++++++++++++++++++++++--
 kernel/trace/ftrace.c         |   69 ++++++++++++++++++++++++++++++++++++-----
 6 files changed, 244 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index aefea5b..71eeef6 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -39,6 +39,9 @@
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
+#ifdef CONFIG_X86_64
+#define ARCH_SUPPORTS_FTRACE_SAVE_REGS
+#endif
 #endif
 
 #ifndef __ASSEMBLY__
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 189c93f..4f9895f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1102,6 +1102,7 @@ ENTRY(ftrace_caller)
 	pushl %eax
 	pushl %ecx
 	pushl %edx
+	pushl $0	/* Pass NULL as regs pointer */
 	movl 0xc(%esp), %eax
 	movl 0x4(%ebp), %edx
 	leal function_trace_op, %ecx
@@ -1111,6 +1112,7 @@ ENTRY(ftrace_caller)
 ftrace_call:
 	call ftrace_stub
 
+	addl $4,%esp	/* skip NULL pointer */
 	popl %edx
 	popl %ecx
 	popl %eax
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 08854a9..096dbe2 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -73,24 +73,50 @@ ENTRY(mcount)
 	retq
 END(mcount)
 
-ENTRY(ftrace_caller)
+/*
+ * Breakup the ftrace_caller setup into two parts.
+ *
+ * The first part tests function_trace_stop to see
+ * if function tracing is stopped. Then it saves the
+ * regs for calling a function, and loads the ftrace_ops
+ * into the rdx register (third parameter).
+ *
+ * The second part saves the pt_regs (stack) into rcx
+ * (forth parameter), and puts the ip and parent ip into
+ * rdi and rsi (first and second parameters respectively).
+ *
+ * The reason for the two part setup is to do the same thing
+ * for both the normal ftrace_caller and the ftrace_regs_caller.
+ * The difference is that the ftrace_regs_caller will also save
+ * the rest of the stack frame into pt_regs for the called
+ * function to have a full pt_regs setup.
+ */
+.macro ftrace_caller_setup1
 	cmpl $0, function_trace_stop
 	jne  ftrace_stub
 
 	MCOUNT_SAVE_FRAME
 
 	leaq function_trace_op, %rdx
+.endm
 
+.macro ftrace_caller_setup2
 	/* regs go into 4th parameter */
 	leaq (%rsp), %rcx
 
 	movq RIP(%rsp), %rdi
 	movq 8(%rbp), %rsi
 	subq $MCOUNT_INSN_SIZE, %rdi
+.endm
+
+ENTRY(ftrace_caller)
+	ftrace_caller_setup1
+	ftrace_caller_setup2
 
 GLOBAL(ftrace_call)
 	call ftrace_stub
 
+ftrace_restore:
 	MCOUNT_RESTORE_FRAME
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -102,6 +128,42 @@ GLOBAL(ftrace_stub)
 	retq
 END(ftrace_caller)
 
+ENTRY(ftrace_regs_caller)
+	ftrace_caller_setup1
+
+	/* Save the rest of pt_regs */
+	movq %r15, R15(%rsp)
+	movq %r14, R14(%rsp)
+	movq %r13, R13(%rsp)
+	movq %r12, R12(%rsp)
+	movq %r10, R10(%rsp)
+	movq %rbp, RBP(%rsp)
+	movq %rbx, RBX(%rsp)
+	/* add flags to stack */
+	pushfq
+	/* rcx gets clobbered by the finish routine anyway */
+	movq 0(%rsp), %rcx
+	addq $8, %rsp
+	movq %rcx, EFLAGS(%rsp)
+
+	ftrace_caller_setup2
+
+GLOBAL(ftrace_regs_call)
+	call ftrace_stub
+
+	/* restore the rest of pt_regs */
+	movq R15(%rsp), %r15
+	movq R14(%rsp), %r14
+	movq R13(%rsp), %r13
+	movq R12(%rsp), %r12
+	movq R10(%rsp), %r10
+	movq RBP(%rsp), %rbp
+	movq RBX(%rsp), %rbx
+
+	jmp ftrace_restore
+END(ftrace_regs_caller)
+
+
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 ENTRY(mcount)
 	cmpl $0, function_trace_stop
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index c3a7cb4..54cfc66 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -206,6 +206,22 @@ static int
 ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 		   unsigned const char *new_code);
 
+#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+/* Should never be called */
+int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
+				 unsigned long addr)
+{
+	unsigned const char *new, *old;
+	unsigned long ip = rec->ip;
+
+	return -EINVAL;
+	old = ftrace_call_replace(ip, old_addr);
+	new = ftrace_call_replace(ip, addr);
+
+	return ftrace_modify_code(rec->ip, old, new);
+}
+#endif
+
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	unsigned long ip = (unsigned long)(&ftrace_call);
@@ -220,6 +236,16 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 
 	ret = ftrace_modify_code(ip, old, new);
 
+#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+	/* Also update the regs version */
+	if (!ret) {
+		ip = (unsigned long)(&ftrace_regs_call);
+		memcpy(old, &ftrace_regs_call, MCOUNT_INSN_SIZE);
+		new = ftrace_call_replace(ip, (unsigned long)func);
+		ret = ftrace_modify_code(ip, old, new);
+	}
+#endif
+
 	atomic_dec(&modifying_ftrace_code);
 
 	return ret;
@@ -299,6 +325,22 @@ static int add_brk_on_nop(struct dyn_ftrace *rec)
 	return add_break(rec->ip, old);
 }
 
+static unsigned long get_ftrace_addr(struct dyn_ftrace *rec)
+{
+	if (rec->flags & FTRACE_FL_REGS)
+		return (unsigned long)FTRACE_REGS_ADDR;
+	else
+		return (unsigned long)FTRACE_ADDR;
+}
+
+static unsigned long get_ftrace_old_addr(struct dyn_ftrace *rec)
+{
+	if (rec->flags & FTRACE_FL_REGS_EN)
+		return (unsigned long)FTRACE_REGS_ADDR;
+	else
+		return (unsigned long)FTRACE_ADDR;
+}
+
 static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 {
 	unsigned long ftrace_addr;
@@ -306,7 +348,7 @@ static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 
 	ret = ftrace_test_record(rec, enable);
 
-	ftrace_addr = (unsigned long)FTRACE_ADDR;
+	ftrace_addr = get_ftrace_addr(rec);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
@@ -316,6 +358,10 @@ static int add_breakpoints(struct dyn_ftrace *rec, int enable)
 		/* converting nop to call */
 		return add_brk_on_nop(rec);
 
+	case FTRACE_UPDATE_MODIFY_CALL_REGS:
+	case FTRACE_UPDATE_MODIFY_CALL:
+		ftrace_addr = get_ftrace_old_addr(rec);
+		/* fall through */
 	case FTRACE_UPDATE_MAKE_NOP:
 		/* converting a call to a nop */
 		return add_brk_on_call(rec, ftrace_addr);
@@ -360,13 +406,21 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 		 * If not, don't touch the breakpoint, we make just create
 		 * a disaster.
 		 */
-		ftrace_addr = (unsigned long)FTRACE_ADDR;
+		ftrace_addr = get_ftrace_addr(rec);
+		nop = ftrace_call_replace(ip, ftrace_addr);
+
+		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) == 0)
+			goto update;
+
+		/* Check both ftrace_addr and ftrace_old_addr */
+		ftrace_addr = get_ftrace_old_addr(rec);
 		nop = ftrace_call_replace(ip, ftrace_addr);
 
 		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0)
 			return -EINVAL;
 	}
 
+ update:
 	return probe_kernel_write((void *)ip, &nop[0], 1);
 }
 
@@ -405,12 +459,14 @@ static int add_update(struct dyn_ftrace *rec, int enable)
 
 	ret = ftrace_test_record(rec, enable);
 
-	ftrace_addr = (unsigned long)FTRACE_ADDR;
+	ftrace_addr  = get_ftrace_addr(rec);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
 		return 0;
 
+	case FTRACE_UPDATE_MODIFY_CALL_REGS:
+	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
 		/* converting nop to call */
 		return add_update_call(rec, ftrace_addr);
@@ -455,12 +511,14 @@ static int finish_update(struct dyn_ftrace *rec, int enable)
 
 	ret = ftrace_update_record(rec, enable);
 
-	ftrace_addr = (unsigned long)FTRACE_ADDR;
+	ftrace_addr = get_ftrace_addr(rec);
 
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
 		return 0;
 
+	case FTRACE_UPDATE_MODIFY_CALL_REGS:
+	case FTRACE_UPDATE_MODIFY_CALL:
 	case FTRACE_UPDATE_MAKE_CALL:
 		/* converting nop to call */
 		return finish_update_call(rec, ftrace_addr);
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index e420288..67c0b73 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -77,6 +77,7 @@ enum {
 	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
 	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
 	FTRACE_OPS_FL_CONTROL		= 1 << 3,
+	FTRACE_OPS_FL_SAVE_REGS		= 1 << 4,
 };
 
 struct ftrace_ops {
@@ -255,11 +256,13 @@ extern void unregister_ftrace_function_probe_all(char *glob);
 extern int ftrace_text_reserved(void *start, void *end);
 
 enum {
-	FTRACE_FL_ENABLED	= (1 << 30),
+	FTRACE_FL_ENABLED	= (1UL << 29),
+	FTRACE_FL_REGS		= (1UL << 30),
+	FTRACE_FL_REGS_EN	= (1UL << 31)
 };
 
-#define FTRACE_FL_MASK		(0x3UL << 30)
-#define FTRACE_REF_MAX		((1 << 30) - 1)
+#define FTRACE_FL_MASK		(0x7UL << 29)
+#define FTRACE_REF_MAX		((1UL << 29) - 1)
 
 struct dyn_ftrace {
 	union {
@@ -293,6 +296,8 @@ enum {
 enum {
 	FTRACE_UPDATE_IGNORE,
 	FTRACE_UPDATE_MAKE_CALL,
+	FTRACE_UPDATE_MODIFY_CALL,
+	FTRACE_UPDATE_MODIFY_CALL_REGS,
 	FTRACE_UPDATE_MAKE_NOP,
 };
 
@@ -344,7 +349,9 @@ extern int ftrace_dyn_arch_init(void *data);
 extern void ftrace_replace_code(int enable);
 extern int ftrace_update_ftrace_func(ftrace_func_t func);
 extern void ftrace_caller(void);
+extern void ftrace_regs_caller(void);
 extern void ftrace_call(void);
+extern void ftrace_regs_call(void);
 extern void mcount_call(void);
 
 void ftrace_modify_all_code(int command);
@@ -352,6 +359,15 @@ void ftrace_modify_all_code(int command);
 #ifndef FTRACE_ADDR
 #define FTRACE_ADDR ((unsigned long)ftrace_caller)
 #endif
+
+#ifndef FTRACE_REGS_ADDR
+#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+# define FTRACE_REGS_ADDR ((unsigned long)ftrace_regs_caller)
+#else
+# define FTRACE_REGS_ADDR ((unsigned long)ftrace_caller)
+#endif
+#endif
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 extern void ftrace_graph_caller(void);
 extern int ftrace_enable_ftrace_graph_caller(void);
@@ -407,6 +423,39 @@ extern int ftrace_make_nop(struct module *mod,
  */
 extern int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr);
 
+#ifdef ARCH_SUPPORTS_FTRACE_SAVE_REGS
+/**
+ * ftrace_modify_call - convert from one addr to another (no nop)
+ * @rec: the mcount call site record
+ * @old_addr: the address expected to be currently called to
+ * @addr: the address to change to
+ *
+ * This is a very sensitive operation and great care needs
+ * to be taken by the arch.  The operation should carefully
+ * read the location, check to see if what is read is indeed
+ * what we expect it to be, and then on success of the compare,
+ * it should write to the location.
+ *
+ * The code segment at @rec->ip should be a caller to @old_addr
+ *
+ * Return must be:
+ *  0 on success
+ *  -EFAULT on error reading the location
+ *  -EINVAL on a failed compare of the contents
+ *  -EPERM  on error writing to the location
+ * Any other value will be considered a failure.
+ */
+extern int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
+			      unsigned long addr);
+#else
+/* Should never be called */
+static inline int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
+				     unsigned long addr)
+{
+	return -EINVAL;
+}
+#endif
+
 /* May be defined in arch */
 extern int ftrace_arch_read_dyn_info(char *buf, int size);
 
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index f3c4317..73fab15 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1515,6 +1515,12 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
 			rec->flags++;
 			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == FTRACE_REF_MAX))
 				return;
+			/*
+			 * If any ops wants regs saved for this function
+			 * then all ops will get saved regs.
+			 */
+			if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+				rec->flags |= FTRACE_FL_REGS;
 		} else {
 			if (FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
 				return;
@@ -1606,18 +1612,53 @@ static int ftrace_check_record(struct dyn_ftrace *rec, int enable, int update)
 	if (enable && (rec->flags & ~FTRACE_FL_MASK))
 		flag = FTRACE_FL_ENABLED;
 
+	/*
+	 * If enabling and the REGS flag does not match the REGS_EN, then
+	 * do not ignore this record. Set flags to fail the compare against
+	 * ENABLED.
+	 */
+	if (flag &&
+	    (!(rec->flags & FTRACE_FL_REGS) != !(rec->flags & FTRACE_FL_REGS_EN)))
+		flag |= FTRACE_FL_REGS;
+
 	/* If the state of this record hasn't changed, then do nothing */
 	if ((rec->flags & FTRACE_FL_ENABLED) == flag)
 		return FTRACE_UPDATE_IGNORE;
 
 	if (flag) {
-		if (update)
+		/* Save off if rec is being enabled (for return value) */
+		flag ^= rec->flags & FTRACE_FL_ENABLED;
+
+		if (update) {
 			rec->flags |= FTRACE_FL_ENABLED;
-		return FTRACE_UPDATE_MAKE_CALL;
+			if (flag & FTRACE_FL_REGS) {
+				if (rec->flags & FTRACE_FL_REGS)
+					rec->flags |= FTRACE_FL_REGS_EN;
+				else
+					rec->flags &= ~FTRACE_FL_REGS_EN;
+			}
+		}
+
+		/*
+		 * If this record is being updated from a nop, then
+		 *   return UPDATE_MAKE_CALL.
+		 * Otherwise, if the EN flag is set, then return
+		 *   UPDATE_MODIFY_CALL_REGS to tell the caller to convert
+		 *   from the non-save regs, to a save regs function.
+		 * Otherwise,
+		 *   return UPDATE_MODIFY_CALL to tell the caller to convert
+		 *   from the save regs, to a save non-regs function.
+		 */
+		if (flag & FTRACE_FL_ENABLED)
+			return FTRACE_UPDATE_MAKE_CALL;
+		else if (rec->flags & FTRACE_FL_REGS_EN)
+			return FTRACE_UPDATE_MODIFY_CALL_REGS;
+		else
+			return FTRACE_UPDATE_MODIFY_CALL;
 	}
 
 	if (update)
-		rec->flags &= ~FTRACE_FL_ENABLED;
+		rec->flags &= ~FTRACE_FL_MASK; /* Clear all flags */
 
 	return FTRACE_UPDATE_MAKE_NOP;
 }
@@ -1652,13 +1693,17 @@ int ftrace_test_record(struct dyn_ftrace *rec, int enable)
 static int
 __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 {
+	unsigned long ftrace_old_addr;
 	unsigned long ftrace_addr;
 	int ret;
 
-	ftrace_addr = (unsigned long)FTRACE_ADDR;
-
 	ret = ftrace_update_record(rec, enable);
 
+	if (rec->flags & FTRACE_FL_REGS)
+		ftrace_addr = (unsigned long)FTRACE_REGS_ADDR;
+	else
+		ftrace_addr = (unsigned long)FTRACE_ADDR;
+
 	switch (ret) {
 	case FTRACE_UPDATE_IGNORE:
 		return 0;
@@ -1668,6 +1713,15 @@ __ftrace_replace_code(struct dyn_ftrace *rec, int enable)
 
 	case FTRACE_UPDATE_MAKE_NOP:
 		return ftrace_make_nop(NULL, rec, ftrace_addr);
+
+	case FTRACE_UPDATE_MODIFY_CALL_REGS:
+	case FTRACE_UPDATE_MODIFY_CALL:
+		if (rec->flags & FTRACE_FL_REGS)
+			ftrace_old_addr = (unsigned long)FTRACE_ADDR;
+		else
+			ftrace_old_addr = (unsigned long)FTRACE_REGS_ADDR;
+
+		return ftrace_modify_call(rec, ftrace_old_addr, ftrace_addr);
 	}
 
 	return -1; /* unknow ftrace bug */
@@ -2421,8 +2475,9 @@ static int t_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "%ps", (void *)rec->ip);
 	if (iter->flags & FTRACE_ITER_ENABLED)
-		seq_printf(m, " (%ld)",
-			   rec->flags & ~FTRACE_FL_MASK);
+		seq_printf(m, " (%ld)%s",
+			   rec->flags & ~FTRACE_FL_MASK,
+			   rec->flags & FTRACE_FL_REGS ? " R" : "");
 	seq_printf(m, "\n");
 
 	return 0;
-- 
1.7.10


