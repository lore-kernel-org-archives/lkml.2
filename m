Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab2IGQf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:35:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34288 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2IGQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:53 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 08/31] arm64: CPU support
Date: Fri,  7 Sep 2012 17:26:43 +0100
Message-Id: <1347035226-18649-9-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:50.0550 (UTC) FILETIME=[B9413360:01CD8D15]
X-MC-Unique: 112090717275106501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87Ga1Iw008471

This patch adds AArch64 CPU specific functionality. It assumes that the
implementation is generic to AArch64 and does not require specific
identification. Different CPU implementations may require the setting of
various ACTLR_EL1 bits but such information is not currently available
and it should ideally be pushed to firmware.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm64/include/asm/cputable.h  |   30 ++++++
 arch/arm64/include/asm/cputype.h   |   49 ++++++++++
 arch/arm64/include/asm/proc-fns.h  |   51 ++++++++++
 arch/arm64/include/asm/processor.h |  175 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cputable.c       |   33 +++++++
 arch/arm64/mm/proc.S               |  181 ++++++++++++++++++++++++++++++++++++
 6 files changed, 519 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/cputable.h
 create mode 100644 arch/arm64/include/asm/cputype.h
 create mode 100644 arch/arm64/include/asm/proc-fns.h
 create mode 100644 arch/arm64/include/asm/processor.h
 create mode 100644 arch/arm64/kernel/cputable.c
 create mode 100644 arch/arm64/mm/proc.S

diff --git a/arch/arm64/include/asm/cputable.h b/arch/arm64/include/asm/cputable.h
new file mode 100644
index 0000000..e3bd983
--- /dev/null
+++ b/arch/arm64/include/asm/cputable.h
@@ -0,0 +1,30 @@
+/*
+ * arch/arm64/include/asm/cputable.h
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_CPUTABLE_H
+#define __ASM_CPUTABLE_H
+
+struct cpu_info {
+	unsigned int	cpu_id_val;
+	unsigned int	cpu_id_mask;
+	const char	*cpu_name;
+	unsigned long	(*cpu_setup)(void);
+};
+
+extern struct cpu_info *lookup_processor_type(unsigned int);
+
+#endif
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
new file mode 100644
index 0000000..ef54125
--- /dev/null
+++ b/arch/arm64/include/asm/cputype.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2012 ARM Ltd.
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_CPUTYPE_H
+#define __ASM_CPUTYPE_H
+
+#define ID_MIDR_EL1		"midr_el1"
+#define ID_CTR_EL0		"ctr_el0"
+
+#define ID_AA64PFR0_EL1		"id_aa64pfr0_el1"
+#define ID_AA64DFR0_EL1		"id_aa64dfr0_el1"
+#define ID_AA64AFR0_EL1		"id_aa64afr0_el1"
+#define ID_AA64ISAR0_EL1	"id_aa64isar0_el1"
+#define ID_AA64MMFR0_EL1	"id_aa64mmfr0_el1"
+
+#define read_cpuid(reg) ({						\
+	u64 __val;							\
+	asm("mrs	%0, " reg : "=r" (__val));			\
+	__val;								\
+})
+
+/*
+ * The CPU ID never changes at run time, so we might as well tell the
+ * compiler that it's constant.  Use this function to read the CPU ID
+ * rather than directly reading processor_id or read_cpuid() directly.
+ */
+static inline u32 __attribute_const__ read_cpuid_id(void)
+{
+	return read_cpuid(ID_MIDR_EL1);
+}
+
+static inline u32 __attribute_const__ read_cpuid_cachetype(void)
+{
+	return read_cpuid(ID_CTR_EL0);
+}
+
+#endif
diff --git a/arch/arm64/include/asm/proc-fns.h b/arch/arm64/include/asm/proc-fns.h
new file mode 100644
index 0000000..520331b
--- /dev/null
+++ b/arch/arm64/include/asm/proc-fns.h
@@ -0,0 +1,51 @@
+/*
+ * Based on arch/arm/include/asm/proc-fns.h
+ *
+ * Copyright (C) 1997-1999 Russell King
+ * Copyright (C) 2000 Deep Blue Solutions Ltd
+ * Copyright (C) 2012 ARM Ltd.
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PROCFNS_H
+#define __ASM_PROCFNS_H
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+
+#include <asm/page.h>
+
+struct mm_struct;
+
+extern void cpu_proc_init(void);
+extern void cpu_proc_fin(void);
+extern void cpu_do_idle(void);
+extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+extern void cpu_reset(unsigned long addr) __attribute__((noreturn));
+
+#include <asm/memory.h>
+
+#define cpu_switch_mm(pgd,mm) cpu_do_switch_mm(virt_to_phys(pgd),mm)
+
+#define cpu_get_pgd()					\
+({							\
+	unsigned long pg;				\
+	asm("mrs	%0, ttbr0_el1\n"		\
+	    : "=r" (pg));				\
+	pg &= ~0xffff000000003ffful;			\
+	(pgd_t *)phys_to_virt(pg);			\
+})
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif /* __ASM_PROCFNS_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
new file mode 100644
index 0000000..39a208a
--- /dev/null
+++ b/arch/arm64/include/asm/processor.h
@@ -0,0 +1,175 @@
+/*
+ * Based on arch/arm/include/asm/processor.h
+ *
+ * Copyright (C) 1995-1999 Russell King
+ * Copyright (C) 2012 ARM Ltd.
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PROCESSOR_H
+#define __ASM_PROCESSOR_H
+
+/*
+ * Default implementation of macro that returns current
+ * instruction pointer ("program counter").
+ */
+#define current_text_addr() ({ __label__ _l; _l: &&_l;})
+
+#ifdef __KERNEL__
+
+#include <linux/string.h>
+
+#include <asm/fpsimd.h>
+#include <asm/hw_breakpoint.h>
+#include <asm/ptrace.h>
+#include <asm/types.h>
+
+#ifdef __KERNEL__
+#define STACK_TOP_MAX		TASK_SIZE_64
+#ifdef CONFIG_COMPAT
+#define AARCH32_VECTORS_BASE	0xffff0000
+#define STACK_TOP		(test_thread_flag(TIF_32BIT) ? \
+				AARCH32_VECTORS_BASE : STACK_TOP_MAX)
+#else
+#define STACK_TOP		STACK_TOP_MAX
+#endif /* CONFIG_COMPAT */
+#endif /* __KERNEL__ */
+
+struct debug_info {
+	/* Have we suspended stepping by a debugger? */
+	int			suspended_step;
+	/* Allow breakpoints and watchpoints to be disabled for this thread. */
+	int			bps_disabled;
+	int			wps_disabled;
+	/* Hardware breakpoints pinned to this task. */
+	struct perf_event	*hbp_break[ARM_MAX_BRP];
+	struct perf_event	*hbp_watch[ARM_MAX_WRP];
+};
+
+struct cpu_context {
+	unsigned long x19;
+	unsigned long x20;
+	unsigned long x21;
+	unsigned long x22;
+	unsigned long x23;
+	unsigned long x24;
+	unsigned long x25;
+	unsigned long x26;
+	unsigned long x27;
+	unsigned long x28;
+	unsigned long fp;
+	unsigned long sp;
+	unsigned long pc;
+};
+
+struct thread_struct {
+	struct cpu_context	cpu_context;	/* cpu context */
+	unsigned long		tp_value;
+	struct fpsimd_state	fpsimd_state;
+	unsigned long		fault_address;	/* fault info */
+	struct debug_info	debug;		/* debugging */
+};
+
+#define INIT_THREAD  {	}
+
+static inline void start_thread_common(struct pt_regs *regs, unsigned long pc)
+{
+	memset(regs, 0, sizeof(*regs));
+	regs->syscallno = ~0UL;
+	regs->pc = pc;
+}
+
+static inline void start_thread(struct pt_regs *regs, unsigned long pc,
+				unsigned long sp)
+{
+	unsigned long *stack = (unsigned long *)sp;
+
+	start_thread_common(regs, pc);
+	regs->pstate = PSR_MODE_EL0t;
+	regs->sp = sp;
+	regs->regs[2] = stack[2];	/* x2 (envp) */
+	regs->regs[1] = stack[1];	/* x1 (argv) */
+	regs->regs[0] = stack[0];	/* x0 (argc) */
+}
+
+#ifdef CONFIG_COMPAT
+static inline void compat_start_thread(struct pt_regs *regs, unsigned long pc,
+				       unsigned long sp)
+{
+	unsigned int *stack = (unsigned int *)sp;
+
+	start_thread_common(regs, pc);
+	regs->pstate = COMPAT_PSR_MODE_USR;
+	if (pc & 1)
+		regs->pstate |= COMPAT_PSR_T_BIT;
+	regs->compat_sp = sp;
+	regs->regs[2] = stack[2];	/* x2 (envp) */
+	regs->regs[1] = stack[1];	/* x1 (argv) */
+	regs->regs[0] = stack[0];	/* x0 (argc) */
+}
+#endif
+
+/* Forward declaration, a strange C thing */
+struct task_struct;
+
+/* Free all resources held by a thread. */
+extern void release_thread(struct task_struct *);
+
+/* Prepare to copy thread state - unlazy all lazy status */
+#define prepare_to_copy(tsk)	do { } while (0)
+
+unsigned long get_wchan(struct task_struct *p);
+
+#define cpu_relax()			barrier()
+
+/* Thread switching */
+extern struct task_struct *cpu_switch_to(struct task_struct *prev,
+					 struct task_struct *next);
+
+/*
+ * Create a new kernel thread
+ */
+extern int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
+
+#define task_pt_regs(p) \
+	((struct pt_regs *)(THREAD_START_SP + task_stack_page(p)) - 1)
+
+#define KSTK_EIP(tsk)	task_pt_regs(tsk)->pc
+#define KSTK_ESP(tsk)	task_pt_regs(tsk)->sp
+
+/*
+ * Prefetching support
+ */
+#define ARCH_HAS_PREFETCH
+static inline void prefetch(const void *ptr)
+{
+	asm volatile("prfm pldl1keep, %a0\n" : : "p" (ptr));
+}
+
+#define ARCH_HAS_PREFETCHW
+static inline void prefetchw(const void *ptr)
+{
+	asm volatile("prfm pstl1keep, %a0\n" : : "p" (ptr));
+}
+
+#define ARCH_HAS_SPINLOCK_PREFETCH
+static inline void spin_lock_prefetch(const void *x)
+{
+	prefetchw(x);
+}
+
+#define HAVE_ARCH_PICK_MMAP_LAYOUT
+
+#endif
+
+#endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/kernel/cputable.c b/arch/arm64/kernel/cputable.c
new file mode 100644
index 0000000..63cfc4a
--- /dev/null
+++ b/arch/arm64/kernel/cputable.c
@@ -0,0 +1,33 @@
+/*
+ * arch/arm64/kernel/cputable.c
+ *
+ * Copyright (C) 2012 ARM Ltd.
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/init.h>
+
+#include <asm/cputable.h>
+
+extern unsigned long __cpu_setup(void);
+
+struct cpu_info __initdata cpu_table[] = {
+	{
+		.cpu_id_val	= 0x000f0000,
+		.cpu_id_mask	= 0x000f0000,
+		.cpu_name	= "AArch64 Processor",
+		.cpu_setup	= __cpu_setup,
+	},
+	{ /* Empty */ },
+};
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
new file mode 100644
index 0000000..674cd74
--- /dev/null
+++ b/arch/arm64/mm/proc.S
@@ -0,0 +1,181 @@
+/*
+ * Based on arch/arm/mm/proc.S
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ * Copyright (C) 2012 ARM Ltd.
+ * Author: Catalin Marinas <catalin.marinas@arm.com>
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/asm-offsets.h>
+#include <asm/hwcap.h>
+#include <asm/pgtable-hwdef.h>
+#include <asm/pgtable.h>
+
+#include "proc-macros.S"
+
+#ifndef CONFIG_SMP
+/* PTWs cacheable, inner/outer WBWA not shareable */
+#define TCR_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA
+#else
+/* PTWs cacheable, inner/outer WBWA shareable */
+#define TCR_FLAGS	TCR_IRGN_WBWA | TCR_ORGN_WBWA | TCR_SHARED
+#endif
+
+#define MAIR(attr, mt)	((attr) << ((mt) * 8))
+
+ENTRY(cpu_proc_init)
+	ret
+ENDPROC(cpu_proc_init)
+
+ENTRY(cpu_proc_fin)
+	ret
+ENDPROC(cpu_proc_fin)
+
+/*
+ *	cpu_reset(loc)
+ *
+ *	Perform a soft reset of the system.  Put the CPU into the same state
+ *	as it would be if it had been reset, and branch to what would be the
+ *	reset vector. It must be executed with the flat identity mapping.
+ *
+ *	- loc   - location to jump to for soft reset
+ */
+	.align	5
+ENTRY(cpu_reset)
+	mrs	x1, sctlr_el1
+	bic	x1, x1, #1
+	msr	sctlr_el1, x1			// disable the MMU
+	isb
+	ret	x0
+ENDPROC(cpu_reset)
+
+/*
+ *	cpu_do_idle()
+ *
+ *	Idle the processor (wait for interrupt).
+ */
+ENTRY(cpu_do_idle)
+	dsb	sy				// WFI may enter a low-power mode
+	wfi
+	ret
+ENDPROC(cpu_do_idle)
+
+/*
+ *	cpu_switch_mm(pgd_phys, tsk)
+ *
+ *	Set the translation table base pointer to be pgd_phys.
+ *
+ *	- pgd_phys - physical address of new TTB
+ */
+ENTRY(cpu_do_switch_mm)
+	mmid	w1, x1				// get mm->context.id
+	bfi	x0, x1, #48, #16		// set the ASID
+	msr	ttbr0_el1, x0			// set TTBR0
+	isb
+	ret
+ENDPROC(cpu_do_switch_mm)
+
+cpu_name:
+	.ascii	"AArch64 Processor"
+	.align
+
+	.section ".text.init", #alloc, #execinstr
+
+/*
+ *	__cpu_setup
+ *
+ *	Initialise the processor for turning the MMU on.  Return in x0 the
+ *	value of the SCTLR_EL1 register.
+ */
+ENTRY(__cpu_setup)
+#ifdef CONFIG_SMP
+	/* TODO: only do this for certain CPUs */
+	/*
+	 * Enable SMP/nAMP mode.
+	 */
+	mrs	x0, actlr_el1
+	tbnz	x0, #6, 1f			// already enabled?
+	orr	x0, x0, #1 << 6
+	msr	actlr_el1, x0
+1:
+#endif
+	/*
+	 * Preserve the link register across the function call.
+	 */
+	mov	x28, lr
+	bl	__flush_dcache_all
+	mov	lr, x28
+	ic	iallu				// I+BTB cache invalidate
+	dsb	sy
+
+	mov	x0, #3 << 20
+	msr	cpacr_el1, x0			// Enable FP/ASIMD
+	mov	x0, #1
+	msr	oslar_el1, x0			// Set the debug OS lock
+	tlbi	vmalle1is			// invalidate I + D TLBs
+	/*
+	 * Memory region attributes for LPAE:
+	 *
+	 *   n = AttrIndx[2:0]
+	 *			n	MAIR
+	 *   DEVICE_nGnRnE	000	00000000
+	 *   DEVICE_nGnRE	001	00000100
+	 *   DEVICE_GRE		010	00001100
+	 *   NORMAL_NC		011	01000100
+	 *   NORMAL		100	11111111
+	 */
+	ldr	x5, =MAIR(0x00, MT_DEVICE_nGnRnE) | \
+		     MAIR(0x04, MT_DEVICE_nGnRE) | \
+		     MAIR(0x0c, MT_DEVICE_GRE) | \
+		     MAIR(0x44, MT_NORMAL_NC) | \
+		     MAIR(0xff, MT_NORMAL)
+	msr	mair_el1, x5
+	/*
+	 * Prepare SCTLR
+	 */
+	adr	x5, crval
+	ldp	w5, w6, [x5]
+	mrs	x0, sctlr_el1
+	bic	x0, x0, x5			// clear bits
+	orr	x0, x0, x6			// set bits
+	/*
+	 * Set/prepare TCR and TTBR. We use 512GB (39-bit) address range for
+	 * both user and kernel.
+	 */
+	ldr	x10, =TCR_TxSZ(VA_BITS) | TCR_FLAGS | TCR_IPS_40BIT | \
+		      TCR_ASID16 | (1 << 31)
+#ifdef CONFIG_ARM64_64K_PAGES
+	orr	x10, x10, TCR_TG0_64K
+	orr	x10, x10, TCR_TG1_64K
+#endif
+	msr	tcr_el1, x10
+	ret					// return to head.S
+ENDPROC(__cpu_setup)
+
+	/*
+	 *                 n n            T
+	 *       U E      WT T UD     US IHBS
+	 *       CE0      XWHW CZ     ME TEEA S
+	 * .... .IEE .... NEAI TE.I ..AD DEN0 ACAM
+	 * 0011 0... 1101 ..0. ..0. 10.. .... .... < hardware reserved
+	 * .... .100 .... 01.1 11.1 ..01 0001 1101 < software settings
+	 */
+	.type	crval, #object
+crval:
+	.word	0x030802e2			// clear
+	.word	0x0405d11d			// set

