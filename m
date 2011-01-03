Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1ACLuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:50:10 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:45745 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1ACLuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:50:07 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 3/8] unicore32 additional architecture files: ptrace
Date: Mon, 3 Jan 2011 19:50:06 +0800
Message-ID: <012901cbab3c$5d850fe0$188f2fa0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcurPFT3OqCIuYIVTYeilBG0roQwww==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 3 adds ptrace support.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/ptrace.h |  184 +++++++++++
 arch/unicore32/kernel/ptrace.c      |  600 +++++++++++++++++++++++++++++++++++
 arch/unicore32/kernel/ptrace.h      |   53 +++
 3 files changed, 837 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/ptrace.h b/arch/unicore32/include/asm/ptrace.h
new file mode 100644
index 0000000..57badd1
--- /dev/null
+++ b/arch/unicore32/include/asm/ptrace.h
@@ -0,0 +1,184 @@
+/*
+ * linux/arch/unicore32/include/asm/ptrace.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_PTRACE_H__
+#define __UNICORE_PTRACE_H__
+
+#include <asm/hwcap.h>
+
+#define PTRACE_GET_THREAD_AREA	22
+
+/*
+ * PSR bits
+ */
+#define USER_MODE	0x00000010
+#define REAL_MODE	0x00000011
+#define INTR_MODE	0x00000012
+#define PRIV_MODE	0x00000013
+#define ABRT_MODE	0x00000017
+#define EXTN_MODE	0x0000001b
+#define SUSR_MODE	0x0000001f
+#define MODE_MASK	0x0000001f
+#define PSR_R_BIT	0x00000040
+#define PSR_I_BIT	0x00000080
+#define PSR_V_BIT	0x10000000
+#define PSR_C_BIT	0x20000000
+#define PSR_Z_BIT	0x40000000
+#define PSR_S_BIT	0x80000000
+
+/*
+ * Groups of PSR bits
+ */
+#define PSR_f		0xff000000	/* Flags		*/
+#define PSR_c		0x000000ff	/* Control		*/
+
+#ifndef __ASSEMBLY__
+
+/*
+ * This struct defines the way the registers are stored on the
+ * stack during a system call.  Note that sizeof(struct pt_regs)
+ * has to be a multiple of 8.
+ */
+#ifndef __KERNEL__
+struct pt_regs {
+	long uregs[34];
+};
+#else /* __KERNEL__ */
+struct pt_regs {
+	unsigned long uregs[34];
+};
+#endif /* __KERNEL__ */
+
+#define UCreg_asr		uregs[32]
+#define UCreg_pc		uregs[31]
+#define UCreg_lr		uregs[30]
+#define UCreg_sp		uregs[29]
+#define UCreg_ip		uregs[28]
+#define UCreg_fp		uregs[27]
+#define UCreg_26		uregs[26]
+#define UCreg_25		uregs[25]
+#define UCreg_24		uregs[24]
+#define UCreg_23		uregs[23]
+#define UCreg_22		uregs[22]
+#define UCreg_21		uregs[21]
+#define UCreg_20		uregs[20]
+#define UCreg_19		uregs[19]
+#define UCreg_18		uregs[18]
+#define UCreg_17		uregs[17]
+#define UCreg_16		uregs[16]
+#define UCreg_15		uregs[15]
+#define UCreg_14		uregs[14]
+#define UCreg_13		uregs[13]
+#define UCreg_12		uregs[12]
+#define UCreg_11		uregs[11]
+#define UCreg_10		uregs[10]
+#define UCreg_09		uregs[9]
+#define UCreg_08		uregs[8]
+#define UCreg_07		uregs[7]
+#define UCreg_06		uregs[6]
+#define UCreg_05		uregs[5]
+#define UCreg_04		uregs[4]
+#define UCreg_03		uregs[3]
+#define UCreg_02		uregs[2]
+#define UCreg_01		uregs[1]
+#define UCreg_00		uregs[0]
+#define UCreg_ORIG_00		uregs[33]
+
+#ifdef __KERNEL__
+
+#define arch_has_single_step()	(1)
+
+#define user_mode(regs)	\
+	(processor_mode(regs) == USER_MODE)
+
+#define processor_mode(regs) \
+	((regs)->UCreg_asr & MODE_MASK)
+
+#define interrupts_enabled(regs) \
+	(!((regs)->UCreg_asr & PSR_I_BIT))
+
+#define fast_interrupts_enabled(regs) \
+	(!((regs)->UCreg_asr & PSR_R_BIT))
+
+/* Are the current registers suitable for user mode?
+ * (used to maintain security in signal handlers)
+ */
+static inline int valid_user_regs(struct pt_regs *regs)
+{
+	unsigned long mode = regs->UCreg_asr & MODE_MASK;
+
+	/*
+	 * Always clear the R (REAL) bits
+	 */
+	regs->UCreg_asr &= ~(PSR_R_BIT);
+
+	if ((regs->UCreg_asr & PSR_I_BIT) == 0) {
+		if (mode == USER_MODE)
+			return 1;
+	}
+
+	/*
+	 * Force ASR to something logical...
+	 */
+	regs->UCreg_asr &= PSR_f | USER_MODE;
+
+	return 0;
+}
+
+#define instruction_pointer(regs)	((regs)->UCreg_pc)
+
+#define profile_pc(regs) instruction_pointer(regs)
+
+#define predicate(x)		((x) & 0xf0000000)
+#define PREDICATE_ALWAYS	0xe0000000
+
+/*
+ * kprobe-based event tracer support
+ */
+#include <linux/stddef.h>
+#include <linux/types.h>
+#define MAX_REG_OFFSET (offsetof(struct pt_regs, UCreg_ORIG_00))
+
+extern int regs_query_register_offset(const char *name);
+extern const char *regs_query_register_name(unsigned int offset);
+extern bool regs_within_kernel_stack(struct pt_regs *regs, unsigned long addr);
+extern unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
+					       unsigned int n);
+
+/**
+ * regs_get_register() - get register value from its offset
+ * @regs:	   pt_regs from which register value is gotten
+ * @offset:    offset number of the register.
+ *
+ * regs_get_register returns the value of a register whose offset from @regs.
+ * The @offset is the offset of the register in struct pt_regs.
+ * If @offset is bigger than MAX_REG_OFFSET, this returns 0.
+ */
+static inline unsigned long regs_get_register(struct pt_regs *regs,
+					      unsigned int offset)
+{
+	if (unlikely(offset > MAX_REG_OFFSET))
+		return 0;
+	return *(unsigned long *)((unsigned long)regs + offset);
+}
+
+/* Valid only for Kernel mode traps. */
+static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
+{
+	return regs->UCreg_sp;
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* __ASSEMBLY__ */
+
+#endif
+
diff --git a/arch/unicore32/kernel/ptrace.c b/arch/unicore32/kernel/ptrace.c
new file mode 100644
index 0000000..53a9b63
--- /dev/null
+++ b/arch/unicore32/kernel/ptrace.c
@@ -0,0 +1,600 @@
+/*
+ * linux/arch/unicore32/kernel/ptrace.c
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
+#include <linux/ptrace.h>
+#include <linux/security.h>
+#include <linux/init.h>
+#include <linux/signal.h>
+#include <linux/uaccess.h>
+
+#include <asm/pgtable.h>
+#include <asm/system.h>
+#include <asm/traps.h>
+
+#include "ptrace.h"
+
+#define REG_PC	31
+#define REG_PSR	32
+/*
+ * does not yet catch signals sent when the child dies.
+ * in exit.c or in signal.c.
+ */
+
+#if 0
+/*
+ * Breakpoint SWI instruction: SWI &9F0001
+ */
+#define BREAKINST_UNICORE	0xff9f0001
+#else
+/*
+ * New breakpoints - use an extended instruction.  The UniCore architecture
+ * reference manual guarantees that the following instruction space
+ * will produce an extended instruction exception on all CPUs:
+ *
+ *   100x xxxx xxxx xxxx xxxx xxx1 xxxx xxxx
+ */
+#define BREAKINST_UNICORE	0x800001f1
+#endif
+
+/*
+ * this routine will get a word off of the processes privileged stack.
+ * the offset is how far from the base addr as stored in the THREAD.
+ * this routine assumes that all the privileged stacks are in our
+ * data space.
+ */
+static inline long get_user_reg(struct task_struct *task, int offset)
+{
+	return task_pt_regs(task)->uregs[offset];
+}
+
+/*
+ * this routine will put a word on the processes privileged stack.
+ * the offset is how far from the base addr as stored in the THREAD.
+ * this routine assumes that all the privileged stacks are in our
+ * data space.
+ */
+static inline int
+put_user_reg(struct task_struct *task, int offset, long data)
+{
+	struct pt_regs newregs, *regs = task_pt_regs(task);
+	int ret = -EINVAL;
+
+	newregs = *regs;
+	newregs.uregs[offset] = data;
+
+	if (valid_user_regs(&newregs)) {
+		regs->uregs[offset] = data;
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static inline int
+read_u32(struct task_struct *task, unsigned long addr, u32 *res)
+{
+	int ret;
+
+	ret = access_process_vm(task, addr, res, sizeof(*res), 0);
+
+	return ret == sizeof(*res) ? 0 : -EIO;
+}
+
+static inline int
+read_instr(struct task_struct *task, unsigned long addr, u32 *res)
+{
+	int ret;
+
+	if (addr & 1) {
+		u16 val;
+		ret = access_process_vm(task, addr & ~1, &val, sizeof(val), 0);
+		ret = ret == sizeof(val) ? 0 : -EIO;
+		*res = val;
+	} else {
+		u32 val;
+		ret = access_process_vm(task, addr & ~3, &val, sizeof(val), 0);
+		ret = ret == sizeof(val) ? 0 : -EIO;
+		*res = val;
+	}
+	return ret;
+}
+
+/*
+ * Get value of register `rn' (in the instruction)
+ */
+static unsigned long
+ptrace_getrn(struct task_struct *child, unsigned long insn)
+{
+	unsigned int reg = (insn >> 16) & 15;
+	unsigned long val;
+
+	val = get_user_reg(child, reg);
+	if (reg == 15)
+		val += 8;
+
+	return val;
+}
+
+/*
+ * Get value of operand 2 (in an ALU instruction)
+ */
+static unsigned long
+ptrace_getaluop2(struct task_struct *child, unsigned long insn)
+{
+	unsigned long val;
+	int shift;
+	int type;
+
+	if (insn & 1 << 25) {
+		val = insn & 255;
+		shift = (insn >> 8) & 15;
+		type = 3;
+	} else {
+		val = get_user_reg(child, insn & 15);
+
+		if (insn & (1 << 4))
+			shift = (int)get_user_reg(child, (insn >> 8) & 15);
+		else
+			shift = (insn >> 7) & 31;
+
+		type = (insn >> 5) & 3;
+	}
+
+	switch (type) {
+	case 0:
+		val <<= shift;
+		break;
+	case 1:
+		val >>= shift;
+		break;
+	case 2:
+		val = (((signed long)val) >> shift);
+		break;
+	case 3:
+		val = (val >> shift) | (val << (32 - shift));
+		break;
+	}
+	return val;
+}
+
+/*
+ * Get value of operand 2 (in a LDR instruction)
+ */
+static unsigned long
+ptrace_getldrop2(struct task_struct *child, unsigned long insn)
+{
+	unsigned long val;
+	int shift;
+	int type;
+
+	val = get_user_reg(child, insn & 15);
+	shift = (insn >> 7) & 31;
+	type = (insn >> 5) & 3;
+
+	switch (type) {
+	case 0:
+		val <<= shift;
+		break;
+	case 1:
+		val >>= shift;
+		break;
+	case 2:
+		val = (((signed long)val) >> shift);
+		break;
+	case 3:
+		val = (val >> shift) | (val << (32 - shift));
+		break;
+	}
+	return val;
+}
+
+#define OP_MASK	0x01e00000
+#define OP_AND	0x00000000
+#define OP_EOR	0x00200000
+#define OP_SUB	0x00400000
+#define OP_RSB	0x00600000
+#define OP_ADD	0x00800000
+#define OP_ADC	0x00a00000
+#define OP_SBC	0x00c00000
+#define OP_RSC	0x00e00000
+#define OP_ORR	0x01800000
+#define OP_MOV	0x01a00000
+#define OP_BIC	0x01c00000
+#define OP_MVN	0x01e00000
+
+static unsigned long
+get_branch_address(struct task_struct *child,
+		unsigned long pc, unsigned long insn)
+{
+	u32 alt = 0;
+
+	switch (insn & 0x0e000000) {
+	case 0x00000000:
+	case 0x02000000: {
+		/*
+		 * data processing
+		 */
+		long aluop1, aluop2, ccbit;
+
+		if ((insn & 0x0fffffd0) == 0x012fff10) {
+			/*
+			 * bx or blx
+			 */
+			alt = get_user_reg(child, insn & 15);
+			break;
+		}
+
+
+		if ((insn & 0xf000) != 0xf000)
+			break;
+
+		aluop1 = ptrace_getrn(child, insn);
+		aluop2 = ptrace_getaluop2(child, insn);
+		ccbit  = get_user_reg(child, REG_PSR) & PSR_C_BIT ? 1 : 0;
+
+		switch (insn & OP_MASK) {
+		case OP_AND:
+			alt = aluop1 & aluop2;
+			break;
+		case OP_EOR:
+			alt = aluop1 ^ aluop2;
+			break;
+		case OP_SUB:
+			alt = aluop1 - aluop2;
+			break;
+		case OP_RSB:
+			alt = aluop2 - aluop1;
+			break;
+		case OP_ADD:
+			alt = aluop1 + aluop2;
+			break;
+		case OP_ADC:
+			alt = aluop1 + aluop2 + ccbit;
+			break;
+		case OP_SBC:
+			alt = aluop1 - aluop2 + ccbit;
+			break;
+		case OP_RSC:
+			alt = aluop2 - aluop1 + ccbit;
+			break;
+		case OP_ORR:
+			alt = aluop1 | aluop2;
+			break;
+		case OP_MOV:
+			alt = aluop2;
+			break;
+		case OP_BIC:
+			alt = aluop1 & ~aluop2;
+			break;
+		case OP_MVN:
+			alt = ~aluop2;
+			break;
+		}
+		break;
+	}
+
+	case 0x04000000:
+	case 0x06000000:
+		/*
+		 * ldr
+		 */
+		if ((insn & 0x0010f000) == 0x0010f000) {
+			unsigned long base;
+
+			base = ptrace_getrn(child, insn);
+			if (insn & 1 << 24) {
+				long aluop2;
+
+				if (insn & 0x02000000)
+					aluop2 = ptrace_getldrop2(child, insn);
+				else
+					aluop2 = insn & 0xfff;
+
+				if (insn & 1 << 23)
+					base += aluop2;
+				else
+					base -= aluop2;
+			}
+			read_u32(child, base, &alt);
+		}
+		break;
+
+	case 0x08000000:
+		/*
+		 * ldm
+		 */
+		if ((insn & 0x00108000) == 0x00108000) {
+			unsigned long base;
+			unsigned int nr_regs;
+
+			if (insn & (1 << 23)) {
+				nr_regs = hweight16(insn & 65535) << 2;
+
+				if (!(insn & (1 << 24)))
+					nr_regs -= 4;
+			} else {
+				if (insn & (1 << 24))
+					nr_regs = -4;
+				else
+					nr_regs = 0;
+			}
+
+			base = ptrace_getrn(child, insn);
+
+			read_u32(child, base + nr_regs, &alt);
+			break;
+		}
+		break;
+
+	case 0x0a000000: {
+		/*
+		 * bl or b
+		 */
+		signed long displ;
+		/* It's a branch/branch link: instead of trying to
+		 * figure out whether the branch will be taken or not,
+		 * we'll put a breakpoint at both locations.  This is
+		 * simpler, more reliable, and probably not a whole lot
+		 * slower than the alternative approach of emulating the
+		 * branch.
+		 */
+		displ = (insn & 0x00ffffff) << 8;
+		displ = (displ >> 6) + 8;
+		if (displ != 0 && displ != 4)
+			alt = pc + displ;
+	    }
+	    break;
+	}
+
+	return alt;
+}
+
+static int
+swap_insn(struct task_struct *task, unsigned long addr,
+	  void *old_insn, void *new_insn, int size)
+{
+	int ret;
+
+	ret = access_process_vm(task, addr, old_insn, size, 0);
+	if (ret == size)
+		ret = access_process_vm(task, addr, new_insn, size, 1);
+	return ret;
+}
+
+static void
+add_breakpoint(struct task_struct *task,
+		struct debug_info *dbg, unsigned long addr)
+{
+	int nr = dbg->nsaved;
+
+	if (nr < 2) {
+		u32 new_insn = BREAKINST_UNICORE;
+		int res;
+
+		res = swap_insn(task, addr, &dbg->bp[nr].insn, &new_insn, 4);
+
+		if (res == 4) {
+			dbg->bp[nr].address = addr;
+			dbg->nsaved += 1;
+		}
+	} else
+		printk(KERN_ERR "ptrace: too many breakpoints\n");
+}
+
+/*
+ * Clear one breakpoint in the user program.
+ */
+static void clear_breakpoint(struct task_struct *task, struct debug_entry *bp)
+{
+	unsigned long addr = bp->address;
+	u32 old_insn;
+	int ret;
+
+	ret = swap_insn(task, addr & ~3, &old_insn,
+			&bp->insn, 4);
+
+	if (ret != 4 || old_insn != BREAKINST_UNICORE)
+		printk(KERN_ERR "%s:%d: corrupted UniCore breakpoint at "
+			"0x%08lx (0x%08x)\n", task->comm,
+			task_pid_nr(task), addr, old_insn);
+}
+
+void ptrace_set_bpt(struct task_struct *child)
+{
+	struct pt_regs *regs;
+	unsigned long pc;
+	u32 insn;
+	int res;
+
+	regs = task_pt_regs(child);
+	pc = instruction_pointer(regs);
+
+	res = read_instr(child, pc, &insn);
+	if (!res) {
+		struct debug_info *dbg = &child->thread.debug;
+		unsigned long alt;
+
+		dbg->nsaved = 0;
+
+		alt = get_branch_address(child, pc, insn);
+		if (alt)
+			add_breakpoint(child, dbg, alt);
+
+		/*
+		 * Note that we ignore the result of setting the above
+		 * breakpoint since it may fail.  When it does, this is
+		 * not so much an error, but a forewarning that we may
+		 * be receiving a prefetch abort shortly.
+		 *
+		 * If we don't set this breakpoint here, then we can
+		 * lose control of the thread during single stepping.
+		 */
+		if (!alt || predicate(insn) != PREDICATE_ALWAYS)
+			add_breakpoint(child, dbg, pc + 4);
+	}
+}
+
+/*
+ * Ensure no single-step breakpoint is pending.  Returns non-zero
+ * value if child was being single-stepped.
+ */
+void ptrace_cancel_bpt(struct task_struct *child)
+{
+	int i, nsaved = child->thread.debug.nsaved;
+
+	child->thread.debug.nsaved = 0;
+
+	if (nsaved > 2) {
+		printk("ptrace_cancel_bpt: bogus nsaved: %d!\n", nsaved);
+		nsaved = 2;
+	}
+
+	for (i = 0; i < nsaved; i++)
+		clear_breakpoint(child, &child->thread.debug.bp[i]);
+}
+
+void user_disable_single_step(struct task_struct *task)
+{
+	task->ptrace &= ~PT_SINGLESTEP;
+	ptrace_cancel_bpt(task);
+}
+
+void user_enable_single_step(struct task_struct *task)
+{
+	task->ptrace |= PT_SINGLESTEP;
+}
+
+/*
+ * Called by kernel/ptrace.c when detaching..
+ */
+void ptrace_disable(struct task_struct *child)
+{
+	user_disable_single_step(child);
+}
+
+/*
+ * Handle hitting a breakpoint.
+ */
+void ptrace_break(struct task_struct *tsk, struct pt_regs *regs)
+{
+	siginfo_t info;
+
+	ptrace_cancel_bpt(tsk);
+
+	info.si_signo = SIGTRAP;
+	info.si_errno = 0;
+	info.si_code  = TRAP_BRKPT;
+	info.si_addr  = (void __user *)instruction_pointer(regs);
+
+	force_sig_info(SIGTRAP, &info, tsk);
+}
+
+static int __init ptrace_break_init(void)
+{
+	return 0;
+}
+
+core_initcall(ptrace_break_init);
+
+/*
+ * We actually access the pt_regs stored on the kernel stack.
+ */
+static int ptrace_read_user(struct task_struct *tsk, unsigned long off,
+			    unsigned long __user *ret)
+{
+	unsigned long tmp;
+
+	tmp = 0;
+	if (off < sizeof(struct pt_regs))
+		tmp = get_user_reg(tsk, off >> 2);
+
+	return put_user(tmp, ret);
+}
+
+/*
+ * We actually access the pt_regs stored on the kernel stack.
+ */
+static int ptrace_write_user(struct task_struct *tsk, unsigned long off,
+			     unsigned long val)
+{
+	if (off >= sizeof(struct pt_regs))
+		return 0;
+
+	return put_user_reg(tsk, off >> 2, val);
+}
+
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
+{
+	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
+
+	switch (request) {
+	case PTRACE_PEEKUSR:
+		ret = ptrace_read_user(child, addr, datap);
+		break;
+
+	case PTRACE_POKEUSR:
+		ret = ptrace_write_user(child, addr, data);
+		break;
+
+	case PTRACE_GET_THREAD_AREA:
+		ret = put_user(task_pt_regs(child)->UCreg_16,
+			       datap);
+		break;
+
+	default:
+		ret = ptrace_request(child, request, addr, data);
+		break;
+	}
+
+	return ret;
+}
+
+asmlinkage int syscall_trace(int why, struct pt_regs *regs, int scno)
+{
+	unsigned long ip;
+
+	if (!test_thread_flag(TIF_SYSCALL_TRACE))
+		return scno;
+	if (!(current->ptrace & PT_PTRACED))
+		return scno;
+
+	/*
+	 * Save IP.  IP is used to denote syscall entry/exit:
+	 *  IP = 0 -> entry, = 1 -> exit
+	 */
+	ip = regs->UCreg_ip;
+	regs->UCreg_ip = why;
+
+	current_thread_info()->syscall = scno;
+
+	/* the 0x80 provides a way for the tracing parent to distinguish
+	   between a syscall stop and SIGTRAP delivery */
+	ptrace_notify(SIGTRAP | ((current->ptrace & PT_TRACESYSGOOD)
+				 ? 0x80 : 0));
+	/*
+	 * this isn't the same as continuing with a signal, but it will do
+	 * for normal use.  strace only continues with a signal if the
+	 * stopping signal is not SIGTRAP.  -brl
+	 */
+	if (current->exit_code) {
+		send_sig(current->exit_code, current, 1);
+		current->exit_code = 0;
+	}
+	regs->UCreg_ip = ip;
+
+	return current_thread_info()->syscall;
+}
diff --git a/arch/unicore32/kernel/ptrace.h b/arch/unicore32/kernel/ptrace.h
new file mode 100644
index 0000000..bfea983
--- /dev/null
+++ b/arch/unicore32/kernel/ptrace.h
@@ -0,0 +1,53 @@
+/*
+ * linux/arch/unicore32/kernel/ptrace.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/ptrace.h>
+
+extern void ptrace_cancel_bpt(struct task_struct *);
+extern void ptrace_set_bpt(struct task_struct *);
+extern void ptrace_break(struct task_struct *, struct pt_regs *);
+
+/*
+ * make sure single-step breakpoint is gone.
+ */
+static inline void single_step_disable(struct task_struct *task)
+{
+	task->ptrace &= ~PT_SINGLESTEP;
+	ptrace_cancel_bpt(task);
+}
+
+static inline void single_step_enable(struct task_struct *task)
+{
+	task->ptrace |= PT_SINGLESTEP;
+}
+
+/*
+ * Send SIGTRAP if we're single-stepping
+ */
+static inline void single_step_trap(struct task_struct *task)
+{
+	if (task->ptrace & PT_SINGLESTEP) {
+		ptrace_cancel_bpt(task);
+		send_sig(SIGTRAP, task, 1);
+	}
+}
+
+static inline void single_step_clear(struct task_struct *task)
+{
+	if (task->ptrace & PT_SINGLESTEP)
+		ptrace_cancel_bpt(task);
+}
+
+static inline void single_step_set(struct task_struct *task)
+{
+	if (task->ptrace & PT_SINGLESTEP)
+		ptrace_set_bpt(task);
+}

