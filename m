Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497Ab2GFVHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:07:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60930 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2GFVGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:06:39 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: [PATCH 07/36] AArch64: Assembly macros and definitions
Date: Fri,  6 Jul 2012 22:05:48 +0100
Message-Id: <1341608777-12982-8-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:31.0218 (UTC) FILETIME=[5B49AF20:01CD5BBB]
X-MC-Unique: 112070622063803401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66L7b3u005325

This patch introduces several assembly macros and definitions used in
the .S files across arch/aarch64/ like IRQ disabling/enabling, together
with asm-offsets.c.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/aarch64/include/asm/asm-offsets.h |    1 +
 arch/aarch64/include/asm/assembler.h   |  143 ++++++++++++++++++++++++++++++++
 arch/aarch64/kernel/asm-offsets.c      |  109 ++++++++++++++++++++++++
 arch/aarch64/mm/proc-macros.S          |   56 +++++++++++++
 4 files changed, 309 insertions(+), 0 deletions(-)
 create mode 100644 arch/aarch64/include/asm/asm-offsets.h
 create mode 100644 arch/aarch64/include/asm/assembler.h
 create mode 100644 arch/aarch64/kernel/asm-offsets.c
 create mode 100644 arch/aarch64/mm/proc-macros.S

diff --git a/arch/aarch64/include/asm/asm-offsets.h b/arch/aarch64/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/aarch64/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/aarch64/include/asm/assembler.h b/arch/aarch64/include/asm/assembler.h
new file mode 100644
index 0000000..c6ac3cf
--- /dev/null
+++ b/arch/aarch64/include/asm/assembler.h
@@ -0,0 +1,143 @@
+/*
+ * Based on arch/arm/include/asm/assembler.h
+ *
+ * Copyright (C) 1996-2000 Russell King
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#ifndef __ASSEMBLY__
+#error "Only include this from assembly code"
+#endif
+
+#include <asm/ptrace.h>
+
+/*
+ * Stack pushing/popping (register pairs only). Equivalent to store decrement
+ * before, load increment after.
+ */
+	.macro	push, xreg1, xreg2
+	stp	\xreg1, \xreg2, [sp, #-16]!
+	.endm
+
+	.macro	pop, xreg1, xreg2
+	ldp	\xreg1, \xreg2, [sp], #16
+	.endm
+
+/*
+ * Enable and disable interrupts.
+ */
+	.macro	disable_irq
+	msr	daifset, #2
+	.endm
+
+	.macro	enable_irq
+	msr	daifclr, #2
+	.endm
+
+/*
+ * Save/disable and restore interrupts.
+ */
+	.macro	save_and_disable_irqs, olddaif
+	mrs	\olddaif, daif
+	disable_irq
+	.endm
+
+	.macro	restore_irqs, olddaif
+	msr	daif, \olddaif
+	.endm
+
+/*
+ * Enable and disable debug exceptions.
+ */
+	.macro	disable_dbg
+	msr	daifset, #8
+	.endm
+
+	.macro	enable_dbg
+	msr	daifclr, #8
+	.endm
+
+	.macro	disable_step, tmp
+	mrs	\tmp, mdscr_el1
+	bic	\tmp, \tmp, #1
+	msr	mdscr_el1, \tmp
+	.endm
+
+	.macro	enable_step, tmp
+	mrs	\tmp, mdscr_el1
+	orr	\tmp, \tmp, #1
+	msr	mdscr_el1, \tmp
+	.endm
+
+	.macro	enable_dbg_if_not_stepping, tmp
+	mrs	\tmp, mdscr_el1
+	tbnz	\tmp, #1, 9990f
+	enable_dbg
+9990:
+	.endm
+
+/*
+ * SMP data memory barrier
+ */
+	.macro	smp_dmb, opt
+#ifdef CONFIG_SMP
+	dmb	\opt
+#endif
+	.endm
+
+#define USER(x...)				\
+9999:	x;					\
+	.section __ex_table,"a";		\
+	.align	3;				\
+	.quad	9999b,9001f;			\
+	.previous
+
+/*
+ * User access macros.
+ */
+	.macro	usracc, instr, reg, reg2, ptr, inc, rept, abort
+	.rept	\rept
+9999:
+	.if	\inc == 1
+	\instr\()b \reg, [\ptr], #\inc
+	.elseif	\inc == 4
+	\instr\() \reg, [\ptr], #\inc
+	.elseif	\inc == 8
+	\instr\() \reg, [\ptr], #\inc
+	.elseif \inc == 16
+	\instr\() \reg, \reg2, [\ptr], #\inc
+	.else
+	.error	"Unsupported inc macro argument"
+	.endif
+
+	.section __ex_table,"a"
+	.align	3
+	.quad	9999b, \abort
+	.previous
+	.endr
+	.endm
+
+	.macro	ldrusr, reg, ptr, inc, rept=1, abort=9001f
+	 usracc	ldr, \reg, \reg, \ptr, \inc, \rept, \abort
+	.endm
+
+	.macro	ldrpusr, reg, reg2, ptr, rept=1, abort=9001f
+	 usracc	ldp, \reg, \reg2, \ptr, 16, \rept, \abort
+	.endm
+
+/*
+ * Register aliases.
+ */
+lr	.req	x30		// link register
diff --git a/arch/aarch64/kernel/asm-offsets.c b/arch/aarch64/kernel/asm-offsets.c
new file mode 100644
index 0000000..9374e22
--- /dev/null
+++ b/arch/aarch64/kernel/asm-offsets.c
@@ -0,0 +1,109 @@
+/*
+ * Based on arch/arm/kernel/asm-offsets.c
+ *
+ * Copyright (C) 1995-2003 Russell King
+ *               2001-2002 Keith Owens
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <asm/thread_info.h>
+#include <asm/memory.h>
+#include <asm/procinfo.h>
+#include <asm/vdso_datapage.h>
+#include <linux/kbuild.h>
+
+int main(void)
+{
+  DEFINE(TSK_ACTIVE_MM,		offsetof(struct task_struct, active_mm));
+  BLANK();
+  DEFINE(TI_FLAGS,		offsetof(struct thread_info, flags));
+  DEFINE(TI_PREEMPT,		offsetof(struct thread_info, preempt_count));
+  DEFINE(TI_ADDR_LIMIT,		offsetof(struct thread_info, addr_limit));
+  DEFINE(TI_TASK,		offsetof(struct thread_info, task));
+  DEFINE(TI_EXEC_DOMAIN,	offsetof(struct thread_info, exec_domain));
+  DEFINE(TI_CPU,		offsetof(struct thread_info, cpu));
+  BLANK();
+  DEFINE(THREAD_CPU_CONTEXT,	offsetof(struct task_struct, thread.cpu_context));
+  BLANK();
+  DEFINE(S_X0,			offsetof(struct pt_regs, regs[0]));
+  DEFINE(S_X1,			offsetof(struct pt_regs, regs[1]));
+  DEFINE(S_X2,			offsetof(struct pt_regs, regs[2]));
+  DEFINE(S_X3,			offsetof(struct pt_regs, regs[3]));
+  DEFINE(S_X4,			offsetof(struct pt_regs, regs[4]));
+  DEFINE(S_X5,			offsetof(struct pt_regs, regs[5]));
+  DEFINE(S_X6,			offsetof(struct pt_regs, regs[6]));
+  DEFINE(S_X7,			offsetof(struct pt_regs, regs[7]));
+  DEFINE(S_LR,			offsetof(struct pt_regs, regs[30]));
+  DEFINE(S_SP,			offsetof(struct pt_regs, sp));
+#ifdef CONFIG_AARCH32_EMULATION
+  DEFINE(S_COMPAT_SP,		offsetof(struct pt_regs, compat_sp));
+#endif
+  DEFINE(S_PSTATE,		offsetof(struct pt_regs, pstate));
+  DEFINE(S_PC,			offsetof(struct pt_regs, pc));
+  DEFINE(S_ORIG_X0,		offsetof(struct pt_regs, orig_x0));
+  DEFINE(S_SYSCALLNO,		offsetof(struct pt_regs, syscallno));
+  DEFINE(S_FRAME_SIZE,		sizeof(struct pt_regs));
+  BLANK();
+  DEFINE(MM_CONTEXT_ID,		offsetof(struct mm_struct, context.id));
+  BLANK();
+  DEFINE(VMA_VM_MM,		offsetof(struct vm_area_struct, vm_mm));
+  DEFINE(VMA_VM_FLAGS,		offsetof(struct vm_area_struct, vm_flags));
+  BLANK();
+  DEFINE(VM_EXEC,	       	VM_EXEC);
+  BLANK();
+  DEFINE(PAGE_SZ,	       	PAGE_SIZE);
+  BLANK();
+  DEFINE(PROC_INFO_SZ,		sizeof(struct proc_info_list));
+  DEFINE(PROCINFO_INITFUNC,	offsetof(struct proc_info_list, __cpu_flush));
+  BLANK();
+  DEFINE(DMA_BIDIRECTIONAL,	DMA_BIDIRECTIONAL);
+  DEFINE(DMA_TO_DEVICE,		DMA_TO_DEVICE);
+  DEFINE(DMA_FROM_DEVICE,	DMA_FROM_DEVICE);
+  BLANK();
+  DEFINE(CLOCK_REALTIME,	CLOCK_REALTIME);
+  DEFINE(CLOCK_MONOTONIC,	CLOCK_MONOTONIC);
+  DEFINE(CLOCK_REALTIME_RES,	MONOTONIC_RES_NSEC);
+  DEFINE(CLOCK_REALTIME_COARSE,	CLOCK_REALTIME_COARSE);
+  DEFINE(CLOCK_MONOTONIC_COARSE,CLOCK_MONOTONIC_COARSE);
+  DEFINE(CLOCK_COARSE_RES,	LOW_RES_NSEC);
+  DEFINE(NSEC_PER_SEC,		NSEC_PER_SEC);
+  BLANK();
+  DEFINE(VDSO_CS_CYCLE_LAST,	offsetof(struct vdso_data, cs_cycle_last));
+  DEFINE(VDSO_XTIME_CLK_SEC,	offsetof(struct vdso_data, xtime_clock_sec));
+  DEFINE(VDSO_XTIME_CLK_NSEC,	offsetof(struct vdso_data, xtime_clock_nsec));
+  DEFINE(VDSO_XTIME_CRS_SEC,	offsetof(struct vdso_data, xtime_coarse_sec));
+  DEFINE(VDSO_XTIME_CRS_NSEC,	offsetof(struct vdso_data, xtime_coarse_nsec));
+  DEFINE(VDSO_WTM_CLK_SEC,	offsetof(struct vdso_data, wtm_clock_sec));
+  DEFINE(VDSO_WTM_CLK_NSEC,	offsetof(struct vdso_data, wtm_clock_nsec));
+  DEFINE(VDSO_TB_SEQ_COUNT,	offsetof(struct vdso_data, tb_seq_count));
+  DEFINE(VDSO_CS_MULT,		offsetof(struct vdso_data, cs_mult));
+  DEFINE(VDSO_CS_SHIFT,		offsetof(struct vdso_data, cs_shift));
+  DEFINE(VDSO_TZ_MINWEST,	offsetof(struct vdso_data, tz_minuteswest));
+  DEFINE(VDSO_TZ_DSTTIME,	offsetof(struct vdso_data, tz_dsttime));
+  DEFINE(VDSO_USE_SYSCALL,	offsetof(struct vdso_data, use_syscall));
+  BLANK();
+  DEFINE(TVAL_TV_SEC,		offsetof(struct timeval, tv_sec));
+  DEFINE(TVAL_TV_USEC,		offsetof(struct timeval, tv_usec));
+  DEFINE(TSPEC_TV_SEC,		offsetof(struct timespec, tv_sec));
+  DEFINE(TSPEC_TV_NSEC,		offsetof(struct timespec, tv_nsec));
+  BLANK();
+  DEFINE(TZ_MINWEST,		offsetof(struct timezone, tz_minuteswest));
+  DEFINE(TZ_DSTTIME,		offsetof(struct timezone, tz_dsttime));
+  return 0;
+}
diff --git a/arch/aarch64/mm/proc-macros.S b/arch/aarch64/mm/proc-macros.S
new file mode 100644
index 0000000..715b8ab
--- /dev/null
+++ b/arch/aarch64/mm/proc-macros.S
@@ -0,0 +1,56 @@
+/*
+ * Based on arch/arm/mm/proc-macros.S
+ *
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
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <asm/asm-offsets.h>
+#include <asm/thread_info.h>
+
+/*
+ * vma_vm_mm - get mm pointer from vma pointer (vma->vm_mm)
+ */
+	.macro	vma_vm_mm, rd, rn
+	ldr	\rd, [\rn, #VMA_VM_MM]
+	.endm
+
+/*
+ * mmid - get context id from mm pointer (mm->context.id)
+ */
+	.macro	mmid, rd, rn
+	ldr	\rd, [\rn, #MM_CONTEXT_ID]
+	.endm
+
+/*
+ * dcache_line_size - get the minimum D-cache line size from the CTR register.
+ */
+	.macro	dcache_line_size, reg, tmp
+	mrs	\tmp, ctr_el0			// read CTR
+	lsr	\tmp, \tmp, #16
+	and	\tmp, \tmp, #0xf		// cache line size encoding
+	mov	\reg, #4			// bytes per word
+	lsl	\reg, \reg, \tmp		// actual cache line size
+	.endm
+
+/*
+ * icache_line_size - get the minimum I-cache line size from the CTR register.
+ */
+	.macro	icache_line_size, reg, tmp
+	mrs	\tmp, ctr_el0			// read CTR
+	and	\tmp, \tmp, #0xf		// cache line size encoding
+	mov	\reg, #4			// bytes per word
+	lsl	\reg, \reg, \tmp		// actual cache line size
+	.endm

