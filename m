Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab2EJLx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 07:53:56 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40670 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2EJLxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 07:53:54 -0400
X-AuditID: b753bd60-9658fba000007b1b-56-4fabac4f25d8
X-AuditID: b753bd60-9658fba000007b1b-56-4fabac4f25d8
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC PATCH -tip ] x86/kprobes: kprobes call optimization
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Thu, 10 May 2012 20:54:01 +0900
Message-ID: <20120510115401.18125.93504.stgit@localhost.localdomain>
In-Reply-To: <4FAA32B3.3070806@hitachi.com>
References: <4FAA32B3.3070806@hitachi.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this code is still under development, but it will
be useful for the discussion to show this.

Use relative call instead of relative jump for optimizing
kprobes. This reduces x86-depend magic code and runtime
memory size.

Current jump-based optimization copies below regions
into an out-of-line buffer and add some portions to make
a detour path for each optimized probe.

ffffffff815f7009 T optprobe_template_entry
ffffffff815f7029 T optprobe_template_val
ffffffff815f7033 T optprobe_template_call
ffffffff815f7068 T optprobe_template_end

This actually consumes 0x5f == 95 bytes + copied
instructions(20bytes) + jump back (5bytes).

Since call-based optimization can share above templates
of trampoline code, it just requires 25bytes for each
optimized probe.

Steven, I saw your ftrace-based optimization code. And
this will do similar thing but a different way. I'd like
to reuse this code for getting pt_regs in both i386/x86-64.
So, that will be done as follows;

- ftrace-call calls mcount
- mcount calls ftrace handlers
- mcount checks if there is a kprobe
  if so, it jumps into trampoline code
- trampoline code does same way if it is called from
  probe point directly. But if it is called from mcount,
  it directly returns into the ftrace-caller site.

Thank you,

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 Documentation/kprobes.txt        |   39 +++++---
 arch/x86/include/asm/kprobes.h   |   15 +--
 arch/x86/kernel/kprobes-common.h |   31 ++++--
 arch/x86/kernel/kprobes-opt.c    |  191 ++++++++++++++++----------------------
 arch/x86/kernel/kprobes.c        |    4 -
 kernel/kprobes.c                 |    6 -
 6 files changed, 131 insertions(+), 155 deletions(-)

diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
index 0cfb00f..316d5d2 100644
--- a/Documentation/kprobes.txt
+++ b/Documentation/kprobes.txt
@@ -45,7 +45,7 @@ can speed up unregistration process when you have to unregister
 a lot of probes at once.
 
 The next four subsections explain how the different types of
-probes work and how jump optimization works.  They explain certain
+probes work and how call optimization works.  They explain certain
 things that you'll need to know in order to make the best use of
 Kprobes -- e.g., the difference between a pre_handler and
 a post_handler, and how to use the maxactive and nmissed fields of
@@ -163,12 +163,12 @@ In case probed function is entered but there is no kretprobe_instance
 object available, then in addition to incrementing the nmissed count,
 the user entry_handler invocation is also skipped.
 
-1.4 How Does Jump Optimization Work?
+1.4 How Does Call Optimization Work?
 
 If your kernel is built with CONFIG_OPTPROBES=y (currently this flag
 is automatically set 'y' on x86/x86-64, non-preemptive kernel) and
 the "debug.kprobes_optimization" kernel parameter is set to 1 (see
-sysctl(8)), Kprobes tries to reduce probe-hit overhead by using a jump
+sysctl(8)), Kprobes tries to reduce probe-hit overhead by using a call
 instruction instead of a breakpoint instruction at each probepoint.
 
 1.4.1 Init a Kprobe
@@ -182,9 +182,9 @@ probepoint, there'll be a probe there.
 
 Before optimizing a probe, Kprobes performs the following safety checks:
 
-- Kprobes verifies that the region that will be replaced by the jump
+- Kprobes verifies that the region that will be replaced by the call
 instruction (the "optimized region") lies entirely within one function.
-(A jump instruction is multiple bytes, and so may overlay multiple
+(A call instruction is multiple bytes, and so may overlay multiple
 instructions.)
 
 - Kprobes analyzes the entire function and verifies that there is no
@@ -204,9 +204,6 @@ the instruction can be executed out of line.
 
 Next, Kprobes prepares a "detour" buffer, which contains the following
 instruction sequence:
-- code to push the CPU's registers (emulating a breakpoint trap)
-- a call to the trampoline code which calls user's probe handlers.
-- code to restore registers
 - the instructions from the optimized region
 - a jump back to the original execution path.
 
@@ -231,7 +228,7 @@ the CPU's instruction pointer to the copied code in the detour buffer
 
 1.4.5 Optimization
 
-The Kprobe-optimizer doesn't insert the jump instruction immediately;
+The Kprobe-optimizer doesn't insert the call instruction immediately;
 rather, it calls synchronize_sched() for safety first, because it's
 possible for a CPU to be interrupted in the middle of executing the
 optimized region(*).  As you know, synchronize_sched() can ensure
@@ -240,10 +237,20 @@ was called are done, but only if CONFIG_PREEMPT=n.  So, this version
 of kprobe optimization supports only kernels with CONFIG_PREEMPT=n.(**)
 
 After that, the Kprobe-optimizer calls stop_machine() to replace
-the optimized region with a jump instruction to the detour buffer,
-using text_poke_smp().
+the optimized region with a call instruction to the trampoline code,
+by using text_poke_smp().
 
-1.4.6 Unoptimization
+1.4.6 Trampoline code
+
+The trampoline code doing as follows;
+- save all registers (to make pt_regs on stack)
+- pass call-address (which was on the top of original stack)
+  and pt_regs to optprobe_callback
+- optprobe callback finding kprobes on the call address and
+  returns the address of detour buffer
+- restore all registers and return to the address
+
+1.4.7 Unoptimization
 
 When an optimized kprobe is unregistered, disabled, or blocked by
 another kprobe, it will be unoptimized.  If this happens before
@@ -571,7 +578,7 @@ reason, Kprobes doesn't support return probes (or kprobes or jprobes)
 on the x86_64 version of __switch_to(); the registration functions
 return -EINVAL.
 
-On x86/x86-64, since the Jump Optimization of Kprobes modifies
+On x86/x86-64, since the Call Optimization of Kprobes modifies
 instructions widely, there are some limitations to optimization. To
 explain it, we introduce some terminology. Imagine a 3-instruction
 sequence consisting of a two 2-byte instructions and one 3-byte
@@ -593,7 +600,7 @@ DCR: Detoured Code Region
 
 The instructions in DCR are copied to the out-of-line buffer
 of the kprobe, because the bytes in DCR are replaced by
-a 5-byte jump instruction. So there are several limitations.
+a 5-byte call instruction. So there are several limitations.
 
 a) The instructions in DCR must be relocatable.
 b) The instructions in DCR must not include a call instruction.
@@ -704,8 +711,8 @@ Appendix B: The kprobes sysctl interface
 /proc/sys/debug/kprobes-optimization: Turn kprobes optimization ON/OFF.
 
 When CONFIG_OPTPROBES=y, this sysctl interface appears and it provides
-a knob to globally and forcibly turn jump optimization (see section
-1.4) ON or OFF. By default, jump optimization is allowed (ON).
+a knob to globally and forcibly turn the call optimization (see section
+1.4) ON or OFF. By default, call optimization is allowed (ON).
 If you echo "0" to this file or set "debug.kprobes_optimization" to
 0 via sysctl, all optimized probes will be unoptimized, and any new
 probes registered after that will not be optimized.  Note that this
diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
index 5478825..c6e0dec 100644
--- a/arch/x86/include/asm/kprobes.h
+++ b/arch/x86/include/asm/kprobes.h
@@ -36,6 +36,7 @@ typedef u8 kprobe_opcode_t;
 #define RELATIVEJUMP_OPCODE 0xe9
 #define RELATIVEJUMP_SIZE 5
 #define RELATIVECALL_OPCODE 0xe8
+#define RELATIVECALL_SIZE 5
 #define RELATIVE_ADDR_SIZE 4
 #define MAX_STACK_SIZE 64
 #define MIN_STACK_SIZE(ADDR)					       \
@@ -47,16 +48,10 @@ typedef u8 kprobe_opcode_t;
 
 #define flush_insn_slot(p)	do { } while (0)
 
-/* optinsn template addresses */
-extern kprobe_opcode_t optprobe_template_entry;
-extern kprobe_opcode_t optprobe_template_val;
-extern kprobe_opcode_t optprobe_template_call;
-extern kprobe_opcode_t optprobe_template_end;
-#define MAX_OPTIMIZED_LENGTH (MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
-#define MAX_OPTINSN_SIZE 				\
-	(((unsigned long)&optprobe_template_end -	\
-	  (unsigned long)&optprobe_template_entry) +	\
-	 MAX_OPTIMIZED_LENGTH + RELATIVEJUMP_SIZE)
+/* optprobe trampoline addresses */
+void optprobe_trampoline(void);
+#define MAX_OPTIMIZED_LENGTH	(MAX_INSN_SIZE + RELATIVE_ADDR_SIZE)
+#define MAX_OPTINSN_SIZE	(MAX_OPTIMIZED_LENGTH + RELATIVEJUMP_SIZE)
 
 extern const int kretprobe_blacklist_size;
 
diff --git a/arch/x86/kernel/kprobes-common.h b/arch/x86/kernel/kprobes-common.h
index 3230b68..fedc8a3 100644
--- a/arch/x86/kernel/kprobes-common.h
+++ b/arch/x86/kernel/kprobes-common.h
@@ -4,9 +4,8 @@
 /* Kprobes and Optprobes common header */
 
 #ifdef CONFIG_X86_64
-#define SAVE_REGS_STRING			\
-	/* Skip cs, ip, orig_ax. */		\
-	"	subq $24, %rsp\n"		\
+#define SAVE_REGS_STRING_OFF(offs)		\
+	"	subq $" #offs ", %rsp\n"	\
 	"	pushq %rdi\n"			\
 	"	pushq %rsi\n"			\
 	"	pushq %rdx\n"			\
@@ -22,7 +21,7 @@
 	"	pushq %r13\n"			\
 	"	pushq %r14\n"			\
 	"	pushq %r15\n"
-#define RESTORE_REGS_STRING			\
+#define RESTORE_REGS_STRING_OFF(offs)		\
 	"	popq %r15\n"			\
 	"	popq %r14\n"			\
 	"	popq %r13\n"			\
@@ -38,12 +37,15 @@
 	"	popq %rdx\n"			\
 	"	popq %rsi\n"			\
 	"	popq %rdi\n"			\
-	/* Skip orig_ax, ip, cs */		\
-	"	addq $24, %rsp\n"
+	"	addq $" #offs ", %rsp\n"
+
+/* skip cs, ip, orig_ax */
+#define SAVE_REGS_STRING SAVE_REGS_STRING_OFF(24)
+#define RESTORE_REGS_STRING RESTORE_REGS_STRING_OFF(24)
+
 #else
-#define SAVE_REGS_STRING			\
-	/* Skip cs, ip, orig_ax and gs. */	\
-	"	subl $16, %esp\n"		\
+#define SAVE_REGS_STRING_OFF(offs)		\
+	"	subl $" #offs ", %esp\n"	\
 	"	pushl %fs\n"			\
 	"	pushl %es\n"			\
 	"	pushl %ds\n"			\
@@ -54,7 +56,7 @@
 	"	pushl %edx\n"			\
 	"	pushl %ecx\n"			\
 	"	pushl %ebx\n"
-#define RESTORE_REGS_STRING			\
+#define RESTORE_REGS_STRING_OFF(offs)		\
 	"	popl %ebx\n"			\
 	"	popl %ecx\n"			\
 	"	popl %edx\n"			\
@@ -62,8 +64,13 @@
 	"	popl %edi\n"			\
 	"	popl %ebp\n"			\
 	"	popl %eax\n"			\
-	/* Skip ds, es, fs, gs, orig_ax, and ip. Note: don't pop cs here*/\
-	"	addl $24, %esp\n"
+	"	addl $" #offs ", %esp\n"
+
+/* skip cs, ip, orig_ax and gs. */
+#define SAVE_REGS_STRING SAVE_REGS_STRING_OFF(16)
+/* skip ds, es, fs, gs, orig_ax, and ip. Note: don't pop cs here*/
+#define RESTORE_REGS_STRING RESTORE_REGS_STRING_OFF(24)
+
 #endif
 
 /* Ensure if the instruction can be boostable */
diff --git a/arch/x86/kernel/kprobes-opt.c b/arch/x86/kernel/kprobes-opt.c
index c5e410e..0b0a382 100644
--- a/arch/x86/kernel/kprobes-opt.c
+++ b/arch/x86/kernel/kprobes-opt.c
@@ -1,5 +1,5 @@
 /*
- *  Kernel Probes Jump Optimization (Optprobes)
+ *  Kernel Probes Call Optimization (Optprobes)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -46,9 +46,9 @@ unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
 	long offs;
 	int i;
 
-	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
+	for (i = 0; i < RELATIVECALL_SIZE; i++) {
 		kp = get_kprobe((void *)addr - i);
-		/* This function only handles jump-optimized kprobe */
+		/* This function only handles call-optimized kprobe */
 		if (kp && kprobe_optimized(kp)) {
 			op = container_of(kp, struct optimized_kprobe, kp);
 			/* If op->list is not empty, op is under optimizing */
@@ -61,7 +61,7 @@ unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
 found:
 	/*
 	 * If the kprobe can be optimized, original bytes which can be
-	 * overwritten by jump destination address. In this case, original
+	 * overwritten by call destination address. In this case, original
 	 * bytes must be recovered from op->optinsn.copied_insn buffer.
 	 */
 	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
@@ -76,83 +76,69 @@ found:
 	return (unsigned long)buf;
 }
 
-/* Insert a move instruction which sets a pointer to eax/rdi (1st arg). */
-static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
-{
-#ifdef CONFIG_X86_64
-	*addr++ = 0x48;
-	*addr++ = 0xbf;
-#else
-	*addr++ = 0xb8;
-#endif
-	*(unsigned long *)addr = val;
-}
-
-static void __used __kprobes kprobes_optinsn_template_holder(void)
+static void __used __kprobes optprobe_trampoline_holder(void)
 {
 	asm volatile (
-			".global optprobe_template_entry\n"
-			"optprobe_template_entry:\n"
+			".global optprobe_trampoline\n"
+			"optprobe_trampoline:\n"
+			/* When call to here, the stack has call address+5 */
 #ifdef CONFIG_X86_64
 			/* We don't bother saving the ss register */
 			"	pushq %rsp\n"
 			"	pushfq\n"
 			SAVE_REGS_STRING
-			"	movq %rsp, %rsi\n"
-			".global optprobe_template_val\n"
-			"optprobe_template_val:\n"
-			ASM_NOP5
-			ASM_NOP5
-			".global optprobe_template_call\n"
-			"optprobe_template_call:\n"
-			ASM_NOP5
-			/* Move flags to rsp */
-			"	movq 144(%rsp), %rdx\n"
-			"	movq %rdx, 152(%rsp)\n"
+			"	movq %rsp, %rsi\n"	/* pt_regs */
+			"	movq 160(%rsp), %rdi\n"	/* call address */
+			"	call optimized_callback\n"
+			/* Replace call address with stub address */
+			"       movq %rax, 160(%rsp)\n"
 			RESTORE_REGS_STRING
-			/* Skip flags entry */
-			"	addq $8, %rsp\n"
 			"	popfq\n"
+			/* Skip rsp entry */
+			"	addq $8, %rsp\n"
 #else /* CONFIG_X86_32 */
 			"	pushf\n"
-			SAVE_REGS_STRING
-			"	movl %esp, %edx\n"
-			".global optprobe_template_val\n"
-			"optprobe_template_val:\n"
-			ASM_NOP5
-			".global optprobe_template_call\n"
-			"optprobe_template_call:\n"
-			ASM_NOP5
+			/* skip only ip, orig_ax, and gs (flags saved on cs) */
+			SAVE_REGS_STRING_OFF(12)
+			"	movl 56(%esp), %eax\n"	/* call address */
+			/* recover flags from cs */
+			"	movl 52(%esp), %edx\n"
+			"	movl %edx, 56(%esp)\n"
+			"	movl %esp, %edx\n"	/* pt_regs */
+			"	call optimized_callback\n"
+			/* Move flags to cs */
+			"       movl 56(%esp), %edx\n"
+			"       movl %edx, 52(%esp)\n"
+			/* Replace flags with stub address */
+			"       movl %eax, 56(%esp)\n"
 			RESTORE_REGS_STRING
-			"	addl $4, %esp\n"	/* skip cs */
 			"	popf\n"
 #endif
-			".global optprobe_template_end\n"
-			"optprobe_template_end:\n");
+			"	ret\n");
 }
 
-#define TMPL_MOVE_IDX \
-	((long)&optprobe_template_val - (long)&optprobe_template_entry)
-#define TMPL_CALL_IDX \
-	((long)&optprobe_template_call - (long)&optprobe_template_entry)
-#define TMPL_END_IDX \
-	((long)&optprobe_template_end - (long)&optprobe_template_entry)
-
 #define INT3_SIZE sizeof(kprobe_opcode_t)
 
 /* Optimized kprobe call back function: called from optinsn */
-static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
+static __used __kprobes kprobe_opcode_t *optimized_callback(kprobe_opcode_t *addr, struct pt_regs *regs)
 {
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	struct optimized_kprobe *op;
+	struct kprobe_ctlblk *kcb;
 	unsigned long flags;
+	struct kprobe *p;
+
+	local_irq_save(flags);
+
+	kcb = get_kprobe_ctlblk();
+	p = get_kprobe(addr - RELATIVECALL_SIZE);
+	BUG_ON(!p);
 
 	/* This is possible if op is under delayed unoptimizing */
-	if (kprobe_disabled(&op->kp))
-		return;
+	if (kprobe_disabled(p))
+		goto end;
 
-	local_irq_save(flags);
 	if (kprobe_running()) {
-		kprobes_inc_nmissed_count(&op->kp);
+		kprobes_inc_nmissed_count(p);
 	} else {
 		/* Save skipped registers */
 #ifdef CONFIG_X86_64
@@ -161,22 +147,26 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_
 		regs->cs = __KERNEL_CS | get_kernel_rpl();
 		regs->gs = 0;
 #endif
-		regs->ip = (unsigned long)op->kp.addr + INT3_SIZE;
+		regs->ip = (unsigned long)p->addr + INT3_SIZE;
 		regs->orig_ax = ~0UL;
 
-		__this_cpu_write(current_kprobe, &op->kp);
+		__this_cpu_write(current_kprobe, p);
 		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-		opt_pre_handler(&op->kp, regs);
+		opt_pre_handler(p, regs);
 		__this_cpu_write(current_kprobe, NULL);
 	}
+end:
+	op = container_of(p, struct optimized_kprobe, kp);
+	addr = (kprobe_opcode_t *)(op->optinsn.insn);
 	local_irq_restore(flags);
+	return addr;
 }
 
 static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
 {
 	int len = 0, ret;
 
-	while (len < RELATIVEJUMP_SIZE) {
+	while (len < RELATIVECALL_SIZE) {
 		ret = __copy_instruction(dest + len, src + len);
 		if (!ret || !can_boost(dest + len))
 			return -EINVAL;
@@ -245,8 +235,8 @@ static int __kprobes can_optimize(unsigned long paddr)
 	    (paddr <  (unsigned long)__entry_text_end))
 		return 0;
 
-	/* Check there is enough space for a relative jump. */
-	if (size - offset < RELATIVEJUMP_SIZE)
+	/* Check there is enough space for a relative call. */
+	if (size - offset < RELATIVECALL_SIZE)
 		return 0;
 
 	/* Decode instructions */
@@ -325,7 +315,6 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 {
 	u8 *buf;
 	int ret;
-	long rel;
 
 	if (!can_optimize((unsigned long)op->kp.addr))
 		return -EILSEQ;
@@ -334,70 +323,52 @@ int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
 	if (!op->optinsn.insn)
 		return -ENOMEM;
 
-	/*
-	 * Verify if the address gap is in 2GB range, because this uses
-	 * a relative jump.
-	 */
-	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
-	if (abs(rel) > 0x7fffffff)
-		return -ERANGE;
-
 	buf = (u8 *)op->optinsn.insn;
 
 	/* Copy instructions into the out-of-line buffer */
-	ret = copy_optimized_instructions(buf + TMPL_END_IDX, op->kp.addr);
+	ret = copy_optimized_instructions(buf, op->kp.addr);
 	if (ret < 0) {
 		__arch_remove_optimized_kprobe(op, 0);
 		return ret;
 	}
 	op->optinsn.size = ret;
 
-	/* Copy arch-dep-instance from template */
-	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
-
-	/* Set probe information */
-	synthesize_set_arg1(buf + TMPL_MOVE_IDX, (unsigned long)op);
-
-	/* Set probe function call */
-	synthesize_relcall(buf + TMPL_CALL_IDX, optimized_callback);
-
 	/* Set returning jmp instruction at the tail of out-of-line buffer */
-	synthesize_reljump(buf + TMPL_END_IDX + op->optinsn.size,
+	synthesize_reljump(buf + op->optinsn.size,
 			   (u8 *)op->kp.addr + op->optinsn.size);
 
-	flush_icache_range((unsigned long) buf,
-			   (unsigned long) buf + TMPL_END_IDX +
+	flush_icache_range((unsigned long) buf, (unsigned long) buf +
 			   op->optinsn.size + RELATIVEJUMP_SIZE);
 	return 0;
 }
 
 #define MAX_OPTIMIZE_PROBES 256
-static struct text_poke_param *jump_poke_params;
-static struct jump_poke_buffer {
-	u8 buf[RELATIVEJUMP_SIZE];
-} *jump_poke_bufs;
+static struct text_poke_param *call_poke_params;
+static struct call_poke_buffer {
+	u8 buf[RELATIVECALL_SIZE];
+} *call_poke_bufs;
 
 static void __kprobes setup_optimize_kprobe(struct text_poke_param *tprm,
 					    u8 *insn_buf,
 					    struct optimized_kprobe *op)
 {
-	s32 rel = (s32)((long)op->optinsn.insn -
-			((long)op->kp.addr + RELATIVEJUMP_SIZE));
+	s32 rel = (s32)((long)&optprobe_trampoline -
+			((long)op->kp.addr + RELATIVECALL_SIZE));
 
 	/* Backup instructions which will be replaced by jump address */
 	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
 	       RELATIVE_ADDR_SIZE);
 
-	insn_buf[0] = RELATIVEJUMP_OPCODE;
+	insn_buf[0] = RELATIVECALL_OPCODE;
 	*(s32 *)(&insn_buf[1]) = rel;
 
 	tprm->addr = op->kp.addr;
 	tprm->opcode = insn_buf;
-	tprm->len = RELATIVEJUMP_SIZE;
+	tprm->len = RELATIVECALL_SIZE;
 }
 
 /*
- * Replace breakpoints (int3) with relative jumps.
+ * Replace breakpoints (int3) with relative calls.
  * Caller must call with locking kprobe_mutex and text_mutex.
  */
 void __kprobes arch_optimize_kprobes(struct list_head *oplist)
@@ -408,8 +379,8 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 	list_for_each_entry_safe(op, tmp, oplist, list) {
 		WARN_ON(kprobe_disabled(&op->kp));
 		/* Setup param */
-		setup_optimize_kprobe(&jump_poke_params[c],
-				      jump_poke_bufs[c].buf, op);
+		setup_optimize_kprobe(&call_poke_params[c],
+				      call_poke_bufs[c].buf, op);
 		list_del_init(&op->list);
 		if (++c >= MAX_OPTIMIZE_PROBES)
 			break;
@@ -420,7 +391,7 @@ void __kprobes arch_optimize_kprobes(struct list_head *oplist)
 	 * However, since kprobes itself also doesn't support NMI/MCE
 	 * code probing, it's not a problem.
 	 */
-	text_poke_smp_batch(jump_poke_params, c);
+	text_poke_smp_batch(call_poke_params, c);
 }
 
 static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
@@ -433,11 +404,11 @@ static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
 
 	tprm->addr = op->kp.addr;
 	tprm->opcode = insn_buf;
-	tprm->len = RELATIVEJUMP_SIZE;
+	tprm->len = RELATIVECALL_SIZE;
 }
 
 /*
- * Recover original instructions and breakpoints from relative jumps.
+ * Recover original instructions and breakpoints from relative calls.
  * Caller must call with locking kprobe_mutex.
  */
 extern void arch_unoptimize_kprobes(struct list_head *oplist,
@@ -448,8 +419,8 @@ extern void arch_unoptimize_kprobes(struct list_head *oplist,
 
 	list_for_each_entry_safe(op, tmp, oplist, list) {
 		/* Setup param */
-		setup_unoptimize_kprobe(&jump_poke_params[c],
-					jump_poke_bufs[c].buf, op);
+		setup_unoptimize_kprobe(&call_poke_params[c],
+					call_poke_bufs[c].buf, op);
 		list_move(&op->list, done_list);
 		if (++c >= MAX_OPTIMIZE_PROBES)
 			break;
@@ -460,18 +431,18 @@ extern void arch_unoptimize_kprobes(struct list_head *oplist,
 	 * However, since kprobes itself also doesn't support NMI/MCE
 	 * code probing, it's not a problem.
 	 */
-	text_poke_smp_batch(jump_poke_params, c);
+	text_poke_smp_batch(call_poke_params, c);
 }
 
 /* Replace a relative jump with a breakpoint (int3).  */
 void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 {
-	u8 buf[RELATIVEJUMP_SIZE];
+	u8 buf[RELATIVECALL_SIZE];
 
 	/* Set int3 to first byte for kprobes */
 	buf[0] = BREAKPOINT_INSTRUCTION;
 	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
+	text_poke_smp(op->kp.addr, buf, RELATIVECALL_SIZE);
 }
 
 int  __kprobes
@@ -483,7 +454,7 @@ setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 		/* This kprobe is really able to run optimized path. */
 		op = container_of(p, struct optimized_kprobe, kp);
 		/* Detour through copied instructions */
-		regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
+		regs->ip = (unsigned long)op->optinsn.insn;
 		if (!reenter)
 			reset_current_kprobe();
 		preempt_enable_no_resched();
@@ -495,16 +466,16 @@ setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
 int __kprobes arch_init_optprobes(void)
 {
 	/* Allocate code buffer and parameter array */
-	jump_poke_bufs = kmalloc(sizeof(struct jump_poke_buffer) *
+	call_poke_bufs = kmalloc(sizeof(struct call_poke_buffer) *
 				 MAX_OPTIMIZE_PROBES, GFP_KERNEL);
-	if (!jump_poke_bufs)
+	if (!call_poke_bufs)
 		return -ENOMEM;
 
-	jump_poke_params = kmalloc(sizeof(struct text_poke_param) *
+	call_poke_params = kmalloc(sizeof(struct text_poke_param) *
 				   MAX_OPTIMIZE_PROBES, GFP_KERNEL);
-	if (!jump_poke_params) {
-		kfree(jump_poke_bufs);
-		jump_poke_bufs = NULL;
+	if (!call_poke_params) {
+		kfree(call_poke_bufs);
+		call_poke_bufs = NULL;
 		return -ENOMEM;
 	}
 
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index e2f751e..2fe982c 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -276,8 +276,8 @@ static int __kprobes can_probe(unsigned long paddr)
 		 * Check if the instruction has been modified by another
 		 * kprobe, in which case we replace the breakpoint by the
 		 * original instruction in our buffer.
-		 * Also, jump optimization will change the breakpoint to
-		 * relative-jump. Since the relative-jump itself is
+		 * Also, call optimization will change the breakpoint to
+		 * relative-call. Since the relative-call itself is
 		 * normally used, we just go through if there is no kprobe.
 		 */
 		__addr = recover_probed_instruction(buf, addr);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c62b854..b1552dd 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -290,7 +290,7 @@ void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
 static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
 static struct kprobe_insn_cache kprobe_optinsn_slots = {
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
-	/* .insn_size is initialized later */
+	.insn_size = MAX_OPTINSN_SIZE,
 	.nr_garbage = 0,
 };
 /* Get a slot for optimized_kprobe buffer */
@@ -2002,10 +2002,6 @@ static int __init init_kprobes(void)
 	}
 
 #if defined(CONFIG_OPTPROBES)
-#if defined(__ARCH_WANT_KPROBES_INSN_SLOT)
-	/* Init kprobe_optinsn_slots */
-	kprobe_optinsn_slots.insn_size = MAX_OPTINSN_SIZE;
-#endif
 	/* By default, kprobes can be optimized */
 	kprobes_allow_optimization = true;
 #endif

