Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2IGQ2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:28:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34153 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2IGQ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:27:52 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v3 01/31] arm64: Assembly macros and definitions
Date: Fri,  7 Sep 2012 17:26:36 +0100
Message-Id: <1347035226-18649-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Sep 2012 16:27:47.0722 (UTC) FILETIME=[B791AEA0:01CD8D15]
X-MC-Unique: 112090717275003701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q87GTAfE008352

This patch introduces several assembly macros and definitions used in
the .S files across arch/arm64/ like IRQ disabling/enabling, together
with asm-offsets.c.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm64/include/asm/asm-offsets.h |    1 +
 arch/arm64/include/asm/assembler.h   |  109 ++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/asm-offsets.c      |  108 +++++++++++++++++++++++++++++++++
 arch/arm64/mm/proc-macros.S          |   55 +++++++++++++++++
 4 files changed, 273 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/asm-offsets.h
 create mode 100644 arch/arm64/include/asm/assembler.h
 create mode 100644 arch/arm64/kernel/asm-offsets.c
 create mode 100644 arch/arm64/mm/proc-macros.S

diff --git a/arch/arm64/include/asm/asm-offsets.h b/arch/arm64/include/asm/asm-offsets.h
new file mode 100644
index 0000000..d370ee3
--- /dev/null
+++ b/arch/arm64/include/asm/asm-offsets.h
@@ -0,0 +1 @@
+#include <generated/asm-offsets.h>
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
new file mode 100644
index 0000000..da2a13e
--- /dev/null
+++ b/arch/arm64/include/asm/assembler.h
@@ -0,0 +1,109 @@
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
+#define USER(l, x...)				\
+9999:	x;					\
+	.section __ex_table,"a";		\
+	.align	3;				\
+	.quad	9999b,l;			\
+	.previous
+
+/*
+ * Register aliases.
+ */
+lr	.req	x30		// link register
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
new file mode 100644
index 0000000..a2a4d81
--- /dev/null
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -0,0 +1,108 @@
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/dma-mapping.h>
+#include <asm/thread_info.h>
+#include <asm/memory.h>
+#include <asm/cputable.h>
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
+#ifdef CONFIG_COMPAT
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
+  DEFINE(CPU_INFO_SZ,		sizeof(struct cpu_info));
+  DEFINE(CPU_INFO_SETUP,	offsetof(struct cpu_info, cpu_setup));
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
diff --git a/arch/arm64/mm/proc-macros.S b/arch/arm64/mm/proc-macros.S
new file mode 100644
index 0000000..8957b82
--- /dev/null
+++ b/arch/arm64/mm/proc-macros.S
@@ -0,0 +1,55 @@
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
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

