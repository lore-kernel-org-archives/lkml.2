Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2CFQTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:19:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2CFQTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:34 -0500
Date: Tue, 6 Mar 2012 08:18:43 -0800
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-3f33ab1c0c741bfab2138c14ba1918a7905a1e8b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
        mingo@redhat.com, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120305133222.5982.54794.stgit@localhost.localdomain>
References: <20120305133222.5982.54794.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86/kprobes:
  Split out optprobe related code to kprobes-opt.c
Git-Commit-ID: 3f33ab1c0c741bfab2138c14ba1918a7905a1e8b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Mar 2012 08:19:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f33ab1c0c741bfab2138c14ba1918a7905a1e8b
Gitweb:     http://git.kernel.org/tip/3f33ab1c0c741bfab2138c14ba1918a7905a1e8b
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 5 Mar 2012 22:32:22 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Mar 2012 09:49:49 +0100

x86/kprobes: Split out optprobe related code to kprobes-opt.c

Split out optprobe related code to arch/x86/kernel/kprobes-opt.c
for maintenanceability.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: yrl.pp-manager.tt@hitachi.com
Cc: systemtap@sourceware.org
Cc: anderson@redhat.com
Link: http://lkml.kernel.org/r/20120305133222.5982.54794.stgit@localhost.localdomain
[ Tidied up the code a tiny bit ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/Makefile         |    1 +
 arch/x86/kernel/kprobes-common.h |  102 ++++++
 arch/x86/kernel/kprobes-opt.c    |  512 +++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes.c        |  625 ++------------------------------------
 4 files changed, 646 insertions(+), 594 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5369059..532d2e0 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
 obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
+obj-$(CONFIG_OPTPROBES)		+= kprobes-opt.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_KGDB)		+= kgdb.o
diff --git a/arch/x86/kernel/kprobes-common.h b/arch/x86/kernel/kprobes-common.h
new file mode 100644
index 0000000..3230b68
--- /dev/null
+++ b/arch/x86/kernel/kprobes-common.h
@@ -0,0 +1,102 @@
+#ifndef __X86_KERNEL_KPROBES_COMMON_H
+#define __X86_KERNEL_KPROBES_COMMON_H
+
+/* Kprobes and Optprobes common header */
+
+#ifdef CONFIG_X86_64
+#define SAVE_REGS_STRING			\
+	/* Skip cs, ip, orig_ax. */		\
+	"	subq $24, %rsp\n"		\
+	"	pushq %rdi\n"			\
+	"	pushq %rsi\n"			\
+	"	pushq %rdx\n"			\
+	"	pushq %rcx\n"			\
+	"	pushq %rax\n"			\
+	"	pushq %r8\n"			\
+	"	pushq %r9\n"			\
+	"	pushq %r10\n"			\
+	"	pushq %r11\n"			\
+	"	pushq %rbx\n"			\
+	"	pushq %rbp\n"			\
+	"	pushq %r12\n"			\
+	"	pushq %r13\n"			\
+	"	pushq %r14\n"			\
+	"	pushq %r15\n"
+#define RESTORE_REGS_STRING			\
+	"	popq %r15\n"			\
+	"	popq %r14\n"			\
+	"	popq %r13\n"			\
+	"	popq %r12\n"			\
+	"	popq %rbp\n"			\
+	"	popq %rbx\n"			\
+	"	popq %r11\n"			\
+	"	popq %r10\n"			\
+	"	popq %r9\n"			\
+	"	popq %r8\n"			\
+	"	popq %rax\n"			\
+	"	popq %rcx\n"			\
+	"	popq %rdx\n"			\
+	"	popq %rsi\n"			\
+	"	popq %rdi\n"			\
+	/* Skip orig_ax, ip, cs */		\
+	"	addq $24, %rsp\n"
+#else
+#define SAVE_REGS_STRING			\
+	/* Skip cs, ip, orig_ax and gs. */	\
+	"	subl $16, %esp\n"		\
+	"	pushl %fs\n"			\
+	"	pushl %es\n"			\
+	"	pushl %ds\n"			\
+	"	pushl %eax\n"			\
+	"	pushl %ebp\n"			\
+	"	pushl %edi\n"			\
+	"	pushl %esi\n"			\
+	"	pushl %edx\n"			\
+	"	pushl %ecx\n"			\
+	"	pushl %ebx\n"
+#define RESTORE_REGS_STRING			\
+	"	popl %ebx\n"			\
+	"	popl %ecx\n"			\
+	"	popl %edx\n"			\
+	"	popl %esi\n"			\
+	"	popl %edi\n"			\
+	"	popl %ebp\n"			\
+	"	popl %eax\n"			\
+	/* Skip ds, es, fs, gs, orig_ax, and ip. Note: don't pop cs here*/\
+	"	addl $24, %esp\n"
+#endif
+
+/* Ensure if the instruction can be boostable */
+extern int can_boost(kprobe_opcode_t *instruction);
+/* Recover instruction if given address is probed */
+extern unsigned long recover_probed_instruction(kprobe_opcode_t *buf,
+					 unsigned long addr);
+/*
+ * Copy an instruction and adjust the displacement if the instruction
+ * uses the %rip-relative addressing mode.
+ */
+extern int __copy_instruction(u8 *dest, u8 *src);
+
+/* Generate a relative-jump/call instruction */
+extern void synthesize_reljump(void *from, void *to);
+extern void synthesize_relcall(void *from, void *to);
+
+#ifdef	CONFIG_OPTPROBES
+extern int arch_init_optprobes(void);
+extern int setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter);
+extern unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr);
+#else	/* !CONFIG_OPTPROBES */
+static inline int arch_init_optprobes(void)
+{
+	return 0;
+}
+static inline int setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
+{
+	return 0;
+}
+static inline unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
+{
+	return addr;
+}
+#endif
+#endif
diff --git a/arch/x86/kernel/kprobes-opt.c b/arch/x86/kernel/kprobes-opt.c
new file mode 100644
index 0000000..c5e410e
--- /dev/null
+++ b/arch/x86/kernel/kprobes-opt.c
@@ -0,0 +1,512 @@
+/*
+ *  Kernel Probes Jump Optimization (Optprobes)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2002, 2004
+ * Copyright (C) Hitachi Ltd., 2012
+ */
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/hardirq.h>
+#include <linux/preempt.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <linux/kallsyms.h>
+#include <linux/ftrace.h>
+
+#include <asm/cacheflush.h>
+#include <asm/desc.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/alternative.h>
+#include <asm/insn.h>
+#include <asm/debugreg.h>
+
+#include "kprobes-common.h"
+
+unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
+{
+	struct optimized_kprobe *op;
+	struct kprobe *kp;
+	long offs;
+	int i;
+
+	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
+		kp = get_kprobe((void *)addr - i);
+		/* This function only handles jump-optimized kprobe */
+		if (kp && kprobe_optimized(kp)) {
+			op = container_of(kp, struct optimized_kprobe, kp);
+			/* If op->list is not empty, op is under optimizing */
+			if (list_empty(&op->list))
+				goto found;
+		}
+	}
+
+	return addr;
+found:
+	/*
+	 * If the kprobe can be optimized, original bytes which can be
+	 * overwritten by jump destination address. In this case, original
+	 * bytes must be recovered from op->optinsn.copied_insn buffer.
+	 */
+	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	if (addr == (unsigned long)kp->addr) {
+		buf[0] = kp->opcode;
+		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+	} else {
+		offs = addr - (unsigned long)kp->addr - 1;
+		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
+	}
+
+	return (unsigned long)buf;
+}
+
+/* Insert a move instruction which sets a pointer to eax/rdi (1st arg). */
+static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr, unsigned long val)
+{
+#ifdef CONFIG_X86_64
+	*addr++ = 0x48;
+	*addr++ = 0xbf;
+#else
+	*addr++ = 0xb8;
+#endif
+	*(unsigned long *)addr = val;
+}
+
+static void __used __kprobes kprobes_optinsn_template_holder(void)
+{
+	asm volatile (
+			".global optprobe_template_entry\n"
+			"optprobe_template_entry:\n"
+#ifdef CONFIG_X86_64
+			/* We don't bother saving the ss register */
+			"	pushq %rsp\n"
+			"	pushfq\n"
+			SAVE_REGS_STRING
+			"	movq %rsp, %rsi\n"
+			".global optprobe_template_val\n"
+			"optprobe_template_val:\n"
+			ASM_NOP5
+			ASM_NOP5
+			".global optprobe_template_call\n"
+			"optprobe_template_call:\n"
+			ASM_NOP5
+			/* Move flags to rsp */
+			"	movq 144(%rsp), %rdx\n"
+			"	movq %rdx, 152(%rsp)\n"
+			RESTORE_REGS_STRING
+			/* Skip flags entry */
+			"	addq $8, %rsp\n"
+			"	popfq\n"
+#else /* CONFIG_X86_32 */
+			"	pushf\n"
+			SAVE_REGS_STRING
+			"	movl %esp, %edx\n"
+			".global optprobe_template_val\n"
+			"optprobe_template_val:\n"
+			ASM_NOP5
+			".global optprobe_template_call\n"
+			"optprobe_template_call:\n"
+			ASM_NOP5
+			RESTORE_REGS_STRING
+			"	addl $4, %esp\n"	/* skip cs */
+			"	popf\n"
+#endif
+			".global optprobe_template_end\n"
+			"optprobe_template_end:\n");
+}
+
+#define TMPL_MOVE_IDX \
+	((long)&optprobe_template_val - (long)&optprobe_template_entry)
+#define TMPL_CALL_IDX \
+	((long)&optprobe_template_call - (long)&optprobe_template_entry)
+#define TMPL_END_IDX \
+	((long)&optprobe_template_end - (long)&optprobe_template_entry)
+
+#define INT3_SIZE sizeof(kprobe_opcode_t)
+
+/* Optimized kprobe call back function: called from optinsn */
+static void __kprobes optimized_callback(struct optimized_kprobe *op, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long flags;
+
+	/* This is possible if op is under delayed unoptimizing */
+	if (kprobe_disabled(&op->kp))
+		return;
+
+	local_irq_save(flags);
+	if (kprobe_running()) {
+		kprobes_inc_nmissed_count(&op->kp);
+	} else {
+		/* Save skipped registers */
+#ifdef CONFIG_X86_64
+		regs->cs = __KERNEL_CS;
+#else
+		regs->cs = __KERNEL_CS | get_kernel_rpl();
+		regs->gs = 0;
+#endif
+		regs->ip = (unsigned long)op->kp.addr + INT3_SIZE;
+		regs->orig_ax = ~0UL;
+
+		__this_cpu_write(current_kprobe, &op->kp);
+		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+		opt_pre_handler(&op->kp, regs);
+		__this_cpu_write(current_kprobe, NULL);
+	}
+	local_irq_restore(flags);
+}
+
+static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
+{
+	int len = 0, ret;
+
+	while (len < RELATIVEJUMP_SIZE) {
+		ret = __copy_instruction(dest + len, src + len);
+		if (!ret || !can_boost(dest + len))
+			return -EINVAL;
+		len += ret;
+	}
+	/* Check whether the address range is reserved */
+	if (ftrace_text_reserved(src, src + len - 1) ||
+	    alternatives_text_reserved(src, src + len - 1) ||
+	    jump_label_text_reserved(src, src + len - 1))
+		return -EBUSY;
+
+	return len;
+}
+
+/* Check whether insn is indirect jump */
+static int __kprobes insn_is_indirect_jump(struct insn *insn)
+{
+	return ((insn->opcode.bytes[0] == 0xff &&
+		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
+		insn->opcode.bytes[0] == 0xea);	/* Segment based jump */
+}
+
+/* Check whether insn jumps into specified address range */
+static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
+{
+	unsigned long target = 0;
+
+	switch (insn->opcode.bytes[0]) {
+	case 0xe0:	/* loopne */
+	case 0xe1:	/* loope */
+	case 0xe2:	/* loop */
+	case 0xe3:	/* jcxz */
+	case 0xe9:	/* near relative jump */
+	case 0xeb:	/* short relative jump */
+		break;
+	case 0x0f:
+		if ((insn->opcode.bytes[1] & 0xf0) == 0x80) /* jcc near */
+			break;
+		return 0;
+	default:
+		if ((insn->opcode.bytes[0] & 0xf0) == 0x70) /* jcc short */
+			break;
+		return 0;
+	}
+	target = (unsigned long)insn->next_byte + insn->immediate.value;
+
+	return (start <= target && target <= start + len);
+}
+
+/* Decode whole function to ensure any instructions don't jump into target */
+static int __kprobes can_optimize(unsigned long paddr)
+{
+	unsigned long addr, size = 0, offset = 0;
+	struct insn insn;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+
+	/* Lookup symbol including addr */
+	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
+		return 0;
+
+	/*
+	 * Do not optimize in the entry code due to the unstable
+	 * stack handling.
+	 */
+	if ((paddr >= (unsigned long)__entry_text_start) &&
+	    (paddr <  (unsigned long)__entry_text_end))
+		return 0;
+
+	/* Check there is enough space for a relative jump. */
+	if (size - offset < RELATIVEJUMP_SIZE)
+		return 0;
+
+	/* Decode instructions */
+	addr = paddr - offset;
+	while (addr < paddr - offset + size) { /* Decode until function end */
+		if (search_exception_tables(addr))
+			/*
+			 * Since some fixup code will jumps into this function,
+			 * we can't optimize kprobe in this function.
+			 */
+			return 0;
+		kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, addr));
+		insn_get_length(&insn);
+		/* Another subsystem puts a breakpoint */
+		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
+			return 0;
+		/* Recover address */
+		insn.kaddr = (void *)addr;
+		insn.next_byte = (void *)(addr + insn.length);
+		/* Check any instructions don't jump into target */
+		if (insn_is_indirect_jump(&insn) ||
+		    insn_jump_into_range(&insn, paddr + INT3_SIZE,
+					 RELATIVE_ADDR_SIZE))
+			return 0;
+		addr += insn.length;
+	}
+
+	return 1;
+}
+
+/* Check optimized_kprobe can actually be optimized. */
+int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
+{
+	int i;
+	struct kprobe *p;
+
+	for (i = 1; i < op->optinsn.size; i++) {
+		p = get_kprobe(op->kp.addr + i);
+		if (p && !kprobe_disabled(p))
+			return -EEXIST;
+	}
+
+	return 0;
+}
+
+/* Check the addr is within the optimized instructions. */
+int __kprobes
+arch_within_optimized_kprobe(struct optimized_kprobe *op, unsigned long addr)
+{
+	return ((unsigned long)op->kp.addr <= addr &&
+		(unsigned long)op->kp.addr + op->optinsn.size > addr);
+}
+
+/* Free optimized instruction slot */
+static __kprobes
+void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
+{
+	if (op->optinsn.insn) {
+		free_optinsn_slot(op->optinsn.insn, dirty);
+		op->optinsn.insn = NULL;
+		op->optinsn.size = 0;
+	}
+}
+
+void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
+{
+	__arch_remove_optimized_kprobe(op, 1);
+}
+
+/*
+ * Copy replacing target instructions
+ * Target instructions MUST be relocatable (checked inside)
+ * This is called when new aggr(opt)probe is allocated or reused.
+ */
+int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
+{
+	u8 *buf;
+	int ret;
+	long rel;
+
+	if (!can_optimize((unsigned long)op->kp.addr))
+		return -EILSEQ;
+
+	op->optinsn.insn = get_optinsn_slot();
+	if (!op->optinsn.insn)
+		return -ENOMEM;
+
+	/*
+	 * Verify if the address gap is in 2GB range, because this uses
+	 * a relative jump.
+	 */
+	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
+	if (abs(rel) > 0x7fffffff)
+		return -ERANGE;
+
+	buf = (u8 *)op->optinsn.insn;
+
+	/* Copy instructions into the out-of-line buffer */
+	ret = copy_optimized_instructions(buf + TMPL_END_IDX, op->kp.addr);
+	if (ret < 0) {
+		__arch_remove_optimized_kprobe(op, 0);
+		return ret;
+	}
+	op->optinsn.size = ret;
+
+	/* Copy arch-dep-instance from template */
+	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
+
+	/* Set probe information */
+	synthesize_set_arg1(buf + TMPL_MOVE_IDX, (unsigned long)op);
+
+	/* Set probe function call */
+	synthesize_relcall(buf + TMPL_CALL_IDX, optimized_callback);
+
+	/* Set returning jmp instruction at the tail of out-of-line buffer */
+	synthesize_reljump(buf + TMPL_END_IDX + op->optinsn.size,
+			   (u8 *)op->kp.addr + op->optinsn.size);
+
+	flush_icache_range((unsigned long) buf,
+			   (unsigned long) buf + TMPL_END_IDX +
+			   op->optinsn.size + RELATIVEJUMP_SIZE);
+	return 0;
+}
+
+#define MAX_OPTIMIZE_PROBES 256
+static struct text_poke_param *jump_poke_params;
+static struct jump_poke_buffer {
+	u8 buf[RELATIVEJUMP_SIZE];
+} *jump_poke_bufs;
+
+static void __kprobes setup_optimize_kprobe(struct text_poke_param *tprm,
+					    u8 *insn_buf,
+					    struct optimized_kprobe *op)
+{
+	s32 rel = (s32)((long)op->optinsn.insn -
+			((long)op->kp.addr + RELATIVEJUMP_SIZE));
+
+	/* Backup instructions which will be replaced by jump address */
+	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
+	       RELATIVE_ADDR_SIZE);
+
+	insn_buf[0] = RELATIVEJUMP_OPCODE;
+	*(s32 *)(&insn_buf[1]) = rel;
+
+	tprm->addr = op->kp.addr;
+	tprm->opcode = insn_buf;
+	tprm->len = RELATIVEJUMP_SIZE;
+}
+
+/*
+ * Replace breakpoints (int3) with relative jumps.
+ * Caller must call with locking kprobe_mutex and text_mutex.
+ */
+void __kprobes arch_optimize_kprobes(struct list_head *oplist)
+{
+	struct optimized_kprobe *op, *tmp;
+	int c = 0;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		WARN_ON(kprobe_disabled(&op->kp));
+		/* Setup param */
+		setup_optimize_kprobe(&jump_poke_params[c],
+				      jump_poke_bufs[c].buf, op);
+		list_del_init(&op->list);
+		if (++c >= MAX_OPTIMIZE_PROBES)
+			break;
+	}
+
+	/*
+	 * text_poke_smp doesn't support NMI/MCE code modifying.
+	 * However, since kprobes itself also doesn't support NMI/MCE
+	 * code probing, it's not a problem.
+	 */
+	text_poke_smp_batch(jump_poke_params, c);
+}
+
+static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
+					      u8 *insn_buf,
+					      struct optimized_kprobe *op)
+{
+	/* Set int3 to first byte for kprobes */
+	insn_buf[0] = BREAKPOINT_INSTRUCTION;
+	memcpy(insn_buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+
+	tprm->addr = op->kp.addr;
+	tprm->opcode = insn_buf;
+	tprm->len = RELATIVEJUMP_SIZE;
+}
+
+/*
+ * Recover original instructions and breakpoints from relative jumps.
+ * Caller must call with locking kprobe_mutex.
+ */
+extern void arch_unoptimize_kprobes(struct list_head *oplist,
+				    struct list_head *done_list)
+{
+	struct optimized_kprobe *op, *tmp;
+	int c = 0;
+
+	list_for_each_entry_safe(op, tmp, oplist, list) {
+		/* Setup param */
+		setup_unoptimize_kprobe(&jump_poke_params[c],
+					jump_poke_bufs[c].buf, op);
+		list_move(&op->list, done_list);
+		if (++c >= MAX_OPTIMIZE_PROBES)
+			break;
+	}
+
+	/*
+	 * text_poke_smp doesn't support NMI/MCE code modifying.
+	 * However, since kprobes itself also doesn't support NMI/MCE
+	 * code probing, it's not a problem.
+	 */
+	text_poke_smp_batch(jump_poke_params, c);
+}
+
+/* Replace a relative jump with a breakpoint (int3).  */
+void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
+{
+	u8 buf[RELATIVEJUMP_SIZE];
+
+	/* Set int3 to first byte for kprobes */
+	buf[0] = BREAKPOINT_INSTRUCTION;
+	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
+	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
+}
+
+int  __kprobes
+setup_detour_execution(struct kprobe *p, struct pt_regs *regs, int reenter)
+{
+	struct optimized_kprobe *op;
+
+	if (p->flags & KPROBE_FLAG_OPTIMIZED) {
+		/* This kprobe is really able to run optimized path. */
+		op = container_of(p, struct optimized_kprobe, kp);
+		/* Detour through copied instructions */
+		regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
+		if (!reenter)
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+
+int __kprobes arch_init_optprobes(void)
+{
+	/* Allocate code buffer and parameter array */
+	jump_poke_bufs = kmalloc(sizeof(struct jump_poke_buffer) *
+				 MAX_OPTIMIZE_PROBES, GFP_KERNEL);
+	if (!jump_poke_bufs)
+		return -ENOMEM;
+
+	jump_poke_params = kmalloc(sizeof(struct text_poke_param) *
+				   MAX_OPTIMIZE_PROBES, GFP_KERNEL);
+	if (!jump_poke_params) {
+		kfree(jump_poke_bufs);
+		jump_poke_bufs = NULL;
+		return -ENOMEM;
+	}
+
+	return 0;
+}
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index ca6d450..e213fc8 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -30,16 +30,15 @@
  *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
  *		<prasanna@in.ibm.com> added function-return probes.
  * 2005-May	Rusty Lynch <rusty.lynch@intel.com>
- * 		Added function return probes functionality
+ *		Added function return probes functionality
  * 2006-Feb	Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp> added
- * 		kprobe-booster and kretprobe-booster for i386.
+ *		kprobe-booster and kretprobe-booster for i386.
  * 2007-Dec	Masami Hiramatsu <mhiramat@redhat.com> added kprobe-booster
- * 		and kretprobe-booster for x86-64
+ *		and kretprobe-booster for x86-64
  * 2007-Dec	Masami Hiramatsu <mhiramat@redhat.com>, Arjan van de Ven
- * 		<arjan@infradead.org> and Jim Keniston <jkenisto@us.ibm.com>
- * 		unified x86 kprobes code.
+ *		<arjan@infradead.org> and Jim Keniston <jkenisto@us.ibm.com>
+ *		unified x86 kprobes code.
  */
-
 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
 #include <linux/string.h>
@@ -59,6 +58,8 @@
 #include <asm/insn.h>
 #include <asm/debugreg.h>
 
+#include "kprobes-common.h"
+
 void jprobe_return_end(void);
 
 DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
@@ -108,6 +109,7 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 			      doesn't switch kernel stack.*/
 	{NULL, NULL}	/* Terminator */
 };
+
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
 static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
@@ -123,11 +125,17 @@ static void __kprobes __synthesize_relative_insn(void *from, void *to, u8 op)
 }
 
 /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
-static void __kprobes synthesize_reljump(void *from, void *to)
+void __kprobes synthesize_reljump(void *from, void *to)
 {
 	__synthesize_relative_insn(from, to, RELATIVEJUMP_OPCODE);
 }
 
+/* Insert a call instruction at address 'from', which calls address 'to'.*/
+void __kprobes synthesize_relcall(void *from, void *to)
+{
+	__synthesize_relative_insn(from, to, RELATIVECALL_OPCODE);
+}
+
 /*
  * Skip the prefixes of the instruction.
  */
@@ -151,7 +159,7 @@ static kprobe_opcode_t *__kprobes skip_prefixes(kprobe_opcode_t *insn)
  * Returns non-zero if opcode is boostable.
  * RIP relative instructions are adjusted at copying time in 64 bits mode
  */
-static int __kprobes can_boost(kprobe_opcode_t *opcodes)
+int __kprobes can_boost(kprobe_opcode_t *opcodes)
 {
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
@@ -207,8 +215,8 @@ retry:
 	}
 }
 
-static unsigned long __recover_probed_insn(kprobe_opcode_t *buf,
-					   unsigned long addr)
+static unsigned long
+__recover_probed_insn(kprobe_opcode_t *buf, unsigned long addr)
 {
 	struct kprobe *kp;
 
@@ -235,59 +243,12 @@ static unsigned long __recover_probed_insn(kprobe_opcode_t *buf,
 	return (unsigned long)buf;
 }
 
-#ifdef CONFIG_OPTPROBES
-static unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf,
-					      unsigned long addr)
-{
-	struct optimized_kprobe *op;
-	struct kprobe *kp;
-	long offs;
-	int i;
-
-	for (i = 0; i < RELATIVEJUMP_SIZE; i++) {
-		kp = get_kprobe((void *)addr - i);
-		/* This function only handles jump-optimized kprobe */
-		if (kp && kprobe_optimized(kp)) {
-			op = container_of(kp, struct optimized_kprobe, kp);
-			/* If op->list is not empty, op is under optimizing */
-			if (list_empty(&op->list))
-				goto found;
-		}
-	}
-
-	return addr;
-found:
-	/*
-	 * If the kprobe can be optimized, original bytes which can be
-	 * overwritten by jump destination address. In this case, original
-	 * bytes must be recovered from op->optinsn.copied_insn buffer.
-	 */
-	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
-	if (addr == (unsigned long)kp->addr) {
-		buf[0] = kp->opcode;
-		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	} else {
-		offs = addr - (unsigned long)kp->addr - 1;
-		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
-	}
-
-	return (unsigned long)buf;
-}
-#else
-static inline unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf,
-						     unsigned long addr)
-{
-	return addr;
-}
-#endif
-
 /*
  * Recover the probed instruction at addr for further analysis.
  * Caller must lock kprobes by kprobe_mutex, or disable preemption
  * for preventing to release referencing kprobes.
  */
-static unsigned long recover_probed_instruction(kprobe_opcode_t *buf,
-						unsigned long addr)
+unsigned long recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
 {
 	unsigned long __addr;
 
@@ -361,7 +322,7 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
  * If not, return null.
  * Only applicable to 64-bit x86.
  */
-static int __kprobes __copy_instruction(u8 *dest, u8 *src)
+int __kprobes __copy_instruction(u8 *dest, u8 *src)
 {
 	struct insn insn;
 	kprobe_opcode_t buf[MAX_INSN_SIZE];
@@ -497,8 +458,8 @@ static void __kprobes restore_btf(void)
 	}
 }
 
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				      struct pt_regs *regs)
+void __kprobes
+arch_prepare_kretprobe(struct kretprobe_instance *ri, struct pt_regs *regs)
 {
 	unsigned long *sara = stack_addr(regs);
 
@@ -508,16 +469,8 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
-#ifdef CONFIG_OPTPROBES
-static int  __kprobes setup_detour_execution(struct kprobe *p,
-					     struct pt_regs *regs,
-					     int reenter);
-#else
-#define setup_detour_execution(p, regs, reenter) (0)
-#endif
-
-static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
-				       struct kprobe_ctlblk *kcb, int reenter)
+static void __kprobes
+setup_singlestep(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb, int reenter)
 {
 	if (setup_detour_execution(p, regs, reenter))
 		return;
@@ -559,8 +512,8 @@ static void __kprobes setup_singlestep(struct kprobe *p, struct pt_regs *regs,
  * within the handler. We save the original kprobes variables and just single
  * step on the instruction of the new probe without calling any user handlers.
  */
-static int __kprobes reenter_kprobe(struct kprobe *p, struct pt_regs *regs,
-				    struct kprobe_ctlblk *kcb)
+static int __kprobes
+reenter_kprobe(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
 	switch (kcb->kprobe_status) {
 	case KPROBE_HIT_SSDONE:
@@ -655,69 +608,6 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	return 0;
 }
 
-#ifdef CONFIG_X86_64
-#define SAVE_REGS_STRING		\
-	/* Skip cs, ip, orig_ax. */	\
-	"	subq $24, %rsp\n"	\
-	"	pushq %rdi\n"		\
-	"	pushq %rsi\n"		\
-	"	pushq %rdx\n"		\
-	"	pushq %rcx\n"		\
-	"	pushq %rax\n"		\
-	"	pushq %r8\n"		\
-	"	pushq %r9\n"		\
-	"	pushq %r10\n"		\
-	"	pushq %r11\n"		\
-	"	pushq %rbx\n"		\
-	"	pushq %rbp\n"		\
-	"	pushq %r12\n"		\
-	"	pushq %r13\n"		\
-	"	pushq %r14\n"		\
-	"	pushq %r15\n"
-#define RESTORE_REGS_STRING		\
-	"	popq %r15\n"		\
-	"	popq %r14\n"		\
-	"	popq %r13\n"		\
-	"	popq %r12\n"		\
-	"	popq %rbp\n"		\
-	"	popq %rbx\n"		\
-	"	popq %r11\n"		\
-	"	popq %r10\n"		\
-	"	popq %r9\n"		\
-	"	popq %r8\n"		\
-	"	popq %rax\n"		\
-	"	popq %rcx\n"		\
-	"	popq %rdx\n"		\
-	"	popq %rsi\n"		\
-	"	popq %rdi\n"		\
-	/* Skip orig_ax, ip, cs */	\
-	"	addq $24, %rsp\n"
-#else
-#define SAVE_REGS_STRING		\
-	/* Skip cs, ip, orig_ax and gs. */	\
-	"	subl $16, %esp\n"	\
-	"	pushl %fs\n"		\
-	"	pushl %es\n"		\
-	"	pushl %ds\n"		\
-	"	pushl %eax\n"		\
-	"	pushl %ebp\n"		\
-	"	pushl %edi\n"		\
-	"	pushl %esi\n"		\
-	"	pushl %edx\n"		\
-	"	pushl %ecx\n"		\
-	"	pushl %ebx\n"
-#define RESTORE_REGS_STRING		\
-	"	popl %ebx\n"		\
-	"	popl %ecx\n"		\
-	"	popl %edx\n"		\
-	"	popl %esi\n"		\
-	"	popl %edi\n"		\
-	"	popl %ebp\n"		\
-	"	popl %eax\n"		\
-	/* Skip ds, es, fs, gs, orig_ax, and ip. Note: don't pop cs here*/\
-	"	addl $24, %esp\n"
-#endif
-
 /*
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
@@ -871,8 +761,8 @@ static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
  * jump instruction after the copied instruction, that jumps to the next
  * instruction after the probepoint.
  */
-static void __kprobes resume_execution(struct kprobe *p,
-		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+static void __kprobes
+resume_execution(struct kprobe *p, struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
 	unsigned long *tos = stack_addr(regs);
 	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
@@ -1051,8 +941,8 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 /*
  * Wrapper routine for handling exceptions.
  */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
+int __kprobes
+kprobe_exceptions_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	struct die_args *args = data;
 	int ret = NOTIFY_DONE;
@@ -1162,462 +1052,9 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	return 0;
 }
 
-
-#ifdef CONFIG_OPTPROBES
-
-/* Insert a call instruction at address 'from', which calls address 'to'.*/
-static void __kprobes synthesize_relcall(void *from, void *to)
-{
-	__synthesize_relative_insn(from, to, RELATIVECALL_OPCODE);
-}
-
-/* Insert a move instruction which sets a pointer to eax/rdi (1st arg). */
-static void __kprobes synthesize_set_arg1(kprobe_opcode_t *addr,
-					  unsigned long val)
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
-{
-	asm volatile (
-			".global optprobe_template_entry\n"
-			"optprobe_template_entry: \n"
-#ifdef CONFIG_X86_64
-			/* We don't bother saving the ss register */
-			"	pushq %rsp\n"
-			"	pushfq\n"
-			SAVE_REGS_STRING
-			"	movq %rsp, %rsi\n"
-			".global optprobe_template_val\n"
-			"optprobe_template_val: \n"
-			ASM_NOP5
-			ASM_NOP5
-			".global optprobe_template_call\n"
-			"optprobe_template_call: \n"
-			ASM_NOP5
-			/* Move flags to rsp */
-			"	movq 144(%rsp), %rdx\n"
-			"	movq %rdx, 152(%rsp)\n"
-			RESTORE_REGS_STRING
-			/* Skip flags entry */
-			"	addq $8, %rsp\n"
-			"	popfq\n"
-#else /* CONFIG_X86_32 */
-			"	pushf\n"
-			SAVE_REGS_STRING
-			"	movl %esp, %edx\n"
-			".global optprobe_template_val\n"
-			"optprobe_template_val: \n"
-			ASM_NOP5
-			".global optprobe_template_call\n"
-			"optprobe_template_call: \n"
-			ASM_NOP5
-			RESTORE_REGS_STRING
-			"	addl $4, %esp\n"	/* skip cs */
-			"	popf\n"
-#endif
-			".global optprobe_template_end\n"
-			"optprobe_template_end: \n");
-}
-
-#define TMPL_MOVE_IDX \
-	((long)&optprobe_template_val - (long)&optprobe_template_entry)
-#define TMPL_CALL_IDX \
-	((long)&optprobe_template_call - (long)&optprobe_template_entry)
-#define TMPL_END_IDX \
-	((long)&optprobe_template_end - (long)&optprobe_template_entry)
-
-#define INT3_SIZE sizeof(kprobe_opcode_t)
-
-/* Optimized kprobe call back function: called from optinsn */
-static void __kprobes optimized_callback(struct optimized_kprobe *op,
-					 struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long flags;
-
-	/* This is possible if op is under delayed unoptimizing */
-	if (kprobe_disabled(&op->kp))
-		return;
-
-	local_irq_save(flags);
-	if (kprobe_running()) {
-		kprobes_inc_nmissed_count(&op->kp);
-	} else {
-		/* Save skipped registers */
-#ifdef CONFIG_X86_64
-		regs->cs = __KERNEL_CS;
-#else
-		regs->cs = __KERNEL_CS | get_kernel_rpl();
-		regs->gs = 0;
-#endif
-		regs->ip = (unsigned long)op->kp.addr + INT3_SIZE;
-		regs->orig_ax = ~0UL;
-
-		__this_cpu_write(current_kprobe, &op->kp);
-		kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-		opt_pre_handler(&op->kp, regs);
-		__this_cpu_write(current_kprobe, NULL);
-	}
-	local_irq_restore(flags);
-}
-
-static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
-{
-	int len = 0, ret;
-
-	while (len < RELATIVEJUMP_SIZE) {
-		ret = __copy_instruction(dest + len, src + len);
-		if (!ret || !can_boost(dest + len))
-			return -EINVAL;
-		len += ret;
-	}
-	/* Check whether the address range is reserved */
-	if (ftrace_text_reserved(src, src + len - 1) ||
-	    alternatives_text_reserved(src, src + len - 1) ||
-	    jump_label_text_reserved(src, src + len - 1))
-		return -EBUSY;
-
-	return len;
-}
-
-/* Check whether insn is indirect jump */
-static int __kprobes insn_is_indirect_jump(struct insn *insn)
-{
-	return ((insn->opcode.bytes[0] == 0xff &&
-		(X86_MODRM_REG(insn->modrm.value) & 6) == 4) || /* Jump */
-		insn->opcode.bytes[0] == 0xea);	/* Segment based jump */
-}
-
-/* Check whether insn jumps into specified address range */
-static int insn_jump_into_range(struct insn *insn, unsigned long start, int len)
-{
-	unsigned long target = 0;
-
-	switch (insn->opcode.bytes[0]) {
-	case 0xe0:	/* loopne */
-	case 0xe1:	/* loope */
-	case 0xe2:	/* loop */
-	case 0xe3:	/* jcxz */
-	case 0xe9:	/* near relative jump */
-	case 0xeb:	/* short relative jump */
-		break;
-	case 0x0f:
-		if ((insn->opcode.bytes[1] & 0xf0) == 0x80) /* jcc near */
-			break;
-		return 0;
-	default:
-		if ((insn->opcode.bytes[0] & 0xf0) == 0x70) /* jcc short */
-			break;
-		return 0;
-	}
-	target = (unsigned long)insn->next_byte + insn->immediate.value;
-
-	return (start <= target && target <= start + len);
-}
-
-/* Decode whole function to ensure any instructions don't jump into target */
-static int __kprobes can_optimize(unsigned long paddr)
-{
-	unsigned long addr, size = 0, offset = 0;
-	struct insn insn;
-	kprobe_opcode_t buf[MAX_INSN_SIZE];
-
-	/* Lookup symbol including addr */
-	if (!kallsyms_lookup_size_offset(paddr, &size, &offset))
-		return 0;
-
-	/*
-	 * Do not optimize in the entry code due to the unstable
-	 * stack handling.
-	 */
-	if ((paddr >= (unsigned long )__entry_text_start) &&
-	    (paddr <  (unsigned long )__entry_text_end))
-		return 0;
-
-	/* Check there is enough space for a relative jump. */
-	if (size - offset < RELATIVEJUMP_SIZE)
-		return 0;
-
-	/* Decode instructions */
-	addr = paddr - offset;
-	while (addr < paddr - offset + size) { /* Decode until function end */
-		if (search_exception_tables(addr))
-			/*
-			 * Since some fixup code will jumps into this function,
-			 * we can't optimize kprobe in this function.
-			 */
-			return 0;
-		kernel_insn_init(&insn, (void *)recover_probed_instruction(buf, addr));
-		insn_get_length(&insn);
-		/* Another subsystem puts a breakpoint */
-		if (insn.opcode.bytes[0] == BREAKPOINT_INSTRUCTION)
-			return 0;
-		/* Recover address */
-		insn.kaddr = (void *)addr;
-		insn.next_byte = (void *)(addr + insn.length);
-		/* Check any instructions don't jump into target */
-		if (insn_is_indirect_jump(&insn) ||
-		    insn_jump_into_range(&insn, paddr + INT3_SIZE,
-					 RELATIVE_ADDR_SIZE))
-			return 0;
-		addr += insn.length;
-	}
-
-	return 1;
-}
-
-/* Check optimized_kprobe can actually be optimized. */
-int __kprobes arch_check_optimized_kprobe(struct optimized_kprobe *op)
-{
-	int i;
-	struct kprobe *p;
-
-	for (i = 1; i < op->optinsn.size; i++) {
-		p = get_kprobe(op->kp.addr + i);
-		if (p && !kprobe_disabled(p))
-			return -EEXIST;
-	}
-
-	return 0;
-}
-
-/* Check the addr is within the optimized instructions. */
-int __kprobes arch_within_optimized_kprobe(struct optimized_kprobe *op,
-					   unsigned long addr)
-{
-	return ((unsigned long)op->kp.addr <= addr &&
-		(unsigned long)op->kp.addr + op->optinsn.size > addr);
-}
-
-/* Free optimized instruction slot */
-static __kprobes
-void __arch_remove_optimized_kprobe(struct optimized_kprobe *op, int dirty)
-{
-	if (op->optinsn.insn) {
-		free_optinsn_slot(op->optinsn.insn, dirty);
-		op->optinsn.insn = NULL;
-		op->optinsn.size = 0;
-	}
-}
-
-void __kprobes arch_remove_optimized_kprobe(struct optimized_kprobe *op)
-{
-	__arch_remove_optimized_kprobe(op, 1);
-}
-
-/*
- * Copy replacing target instructions
- * Target instructions MUST be relocatable (checked inside)
- * This is called when new aggr(opt)probe is allocated or reused.
- */
-int __kprobes arch_prepare_optimized_kprobe(struct optimized_kprobe *op)
-{
-	u8 *buf;
-	int ret;
-	long rel;
-
-	if (!can_optimize((unsigned long)op->kp.addr))
-		return -EILSEQ;
-
-	op->optinsn.insn = get_optinsn_slot();
-	if (!op->optinsn.insn)
-		return -ENOMEM;
-
-	/*
-	 * Verify if the address gap is in 2GB range, because this uses
-	 * a relative jump.
-	 */
-	rel = (long)op->optinsn.insn - (long)op->kp.addr + RELATIVEJUMP_SIZE;
-	if (abs(rel) > 0x7fffffff)
-		return -ERANGE;
-
-	buf = (u8 *)op->optinsn.insn;
-
-	/* Copy instructions into the out-of-line buffer */
-	ret = copy_optimized_instructions(buf + TMPL_END_IDX, op->kp.addr);
-	if (ret < 0) {
-		__arch_remove_optimized_kprobe(op, 0);
-		return ret;
-	}
-	op->optinsn.size = ret;
-
-	/* Copy arch-dep-instance from template */
-	memcpy(buf, &optprobe_template_entry, TMPL_END_IDX);
-
-	/* Set probe information */
-	synthesize_set_arg1(buf + TMPL_MOVE_IDX, (unsigned long)op);
-
-	/* Set probe function call */
-	synthesize_relcall(buf + TMPL_CALL_IDX, optimized_callback);
-
-	/* Set returning jmp instruction at the tail of out-of-line buffer */
-	synthesize_reljump(buf + TMPL_END_IDX + op->optinsn.size,
-			   (u8 *)op->kp.addr + op->optinsn.size);
-
-	flush_icache_range((unsigned long) buf,
-			   (unsigned long) buf + TMPL_END_IDX +
-			   op->optinsn.size + RELATIVEJUMP_SIZE);
-	return 0;
-}
-
-#define MAX_OPTIMIZE_PROBES 256
-static struct text_poke_param *jump_poke_params;
-static struct jump_poke_buffer {
-	u8 buf[RELATIVEJUMP_SIZE];
-} *jump_poke_bufs;
-
-static void __kprobes setup_optimize_kprobe(struct text_poke_param *tprm,
-					    u8 *insn_buf,
-					    struct optimized_kprobe *op)
-{
-	s32 rel = (s32)((long)op->optinsn.insn -
-			((long)op->kp.addr + RELATIVEJUMP_SIZE));
-
-	/* Backup instructions which will be replaced by jump address */
-	memcpy(op->optinsn.copied_insn, op->kp.addr + INT3_SIZE,
-	       RELATIVE_ADDR_SIZE);
-
-	insn_buf[0] = RELATIVEJUMP_OPCODE;
-	*(s32 *)(&insn_buf[1]) = rel;
-
-	tprm->addr = op->kp.addr;
-	tprm->opcode = insn_buf;
-	tprm->len = RELATIVEJUMP_SIZE;
-}
-
-/*
- * Replace breakpoints (int3) with relative jumps.
- * Caller must call with locking kprobe_mutex and text_mutex.
- */
-void __kprobes arch_optimize_kprobes(struct list_head *oplist)
-{
-	struct optimized_kprobe *op, *tmp;
-	int c = 0;
-
-	list_for_each_entry_safe(op, tmp, oplist, list) {
-		WARN_ON(kprobe_disabled(&op->kp));
-		/* Setup param */
-		setup_optimize_kprobe(&jump_poke_params[c],
-				      jump_poke_bufs[c].buf, op);
-		list_del_init(&op->list);
-		if (++c >= MAX_OPTIMIZE_PROBES)
-			break;
-	}
-
-	/*
-	 * text_poke_smp doesn't support NMI/MCE code modifying.
-	 * However, since kprobes itself also doesn't support NMI/MCE
-	 * code probing, it's not a problem.
-	 */
-	text_poke_smp_batch(jump_poke_params, c);
-}
-
-static void __kprobes setup_unoptimize_kprobe(struct text_poke_param *tprm,
-					      u8 *insn_buf,
-					      struct optimized_kprobe *op)
-{
-	/* Set int3 to first byte for kprobes */
-	insn_buf[0] = BREAKPOINT_INSTRUCTION;
-	memcpy(insn_buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-
-	tprm->addr = op->kp.addr;
-	tprm->opcode = insn_buf;
-	tprm->len = RELATIVEJUMP_SIZE;
-}
-
-/*
- * Recover original instructions and breakpoints from relative jumps.
- * Caller must call with locking kprobe_mutex.
- */
-extern void arch_unoptimize_kprobes(struct list_head *oplist,
-				    struct list_head *done_list)
-{
-	struct optimized_kprobe *op, *tmp;
-	int c = 0;
-
-	list_for_each_entry_safe(op, tmp, oplist, list) {
-		/* Setup param */
-		setup_unoptimize_kprobe(&jump_poke_params[c],
-					jump_poke_bufs[c].buf, op);
-		list_move(&op->list, done_list);
-		if (++c >= MAX_OPTIMIZE_PROBES)
-			break;
-	}
-
-	/*
-	 * text_poke_smp doesn't support NMI/MCE code modifying.
-	 * However, since kprobes itself also doesn't support NMI/MCE
-	 * code probing, it's not a problem.
-	 */
-	text_poke_smp_batch(jump_poke_params, c);
-}
-
-/* Replace a relative jump with a breakpoint (int3).  */
-void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
-{
-	u8 buf[RELATIVEJUMP_SIZE];
-
-	/* Set int3 to first byte for kprobes */
-	buf[0] = BREAKPOINT_INSTRUCTION;
-	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
-}
-
-static int  __kprobes setup_detour_execution(struct kprobe *p,
-					     struct pt_regs *regs,
-					     int reenter)
-{
-	struct optimized_kprobe *op;
-
-	if (p->flags & KPROBE_FLAG_OPTIMIZED) {
-		/* This kprobe is really able to run optimized path. */
-		op = container_of(p, struct optimized_kprobe, kp);
-		/* Detour through copied instructions */
-		regs->ip = (unsigned long)op->optinsn.insn + TMPL_END_IDX;
-		if (!reenter)
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		return 1;
-	}
-	return 0;
-}
-
-static int __kprobes init_poke_params(void)
-{
-	/* Allocate code buffer and parameter array */
-	jump_poke_bufs = kmalloc(sizeof(struct jump_poke_buffer) *
-				 MAX_OPTIMIZE_PROBES, GFP_KERNEL);
-	if (!jump_poke_bufs)
-		return -ENOMEM;
-
-	jump_poke_params = kmalloc(sizeof(struct text_poke_param) *
-				   MAX_OPTIMIZE_PROBES, GFP_KERNEL);
-	if (!jump_poke_params) {
-		kfree(jump_poke_bufs);
-		jump_poke_bufs = NULL;
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-#else	/* !CONFIG_OPTPROBES */
-static int __kprobes init_poke_params(void)
-{
-	return 0;
-}
-#endif
-
 int __init arch_init_kprobes(void)
 {
-	return init_poke_params();
+	return arch_init_optprobes();
 }
 
 int __kprobes arch_trampoline_kprobe(struct kprobe *p)
