Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab1IIBQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:16:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50881 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1IIBLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116864696"
Message-Id: <20110909010915.732504298@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:08:58 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 11/36] Hexagon: Add hypervisor interface
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=hypervisor.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port of Linux for Hexagon runs on top of a hypervisor layer,
which presents an interface for memory management, events, hardware
control, etc.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/include/asm/hexagon_vm.h  |  281 ++++++++++++++++++++
 arch/hexagon/include/asm/vm_mmu.h      |  111 ++++++++
 arch/hexagon/kernel/vm_entry.S         |  269 ++++++++++++++++++++
 arch/hexagon/kernel/vm_events.c        |  101 +++++++
 arch/hexagon/kernel/vm_init_segtable.S |  442 +++++++++++++++++++++++++++++++++
 arch/hexagon/kernel/vm_ops.S           |  102 +++++++
 arch/hexagon/kernel/vm_switch.S        |   95 +++++++
 arch/hexagon/kernel/vm_vectors.S       |   50 +++
 8 files changed, 1451 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/hexagon_vm.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/hexagon_vm.h	2011-09-08 19:25:43.090921680 -0500
@@ -0,0 +1,281 @@
+/*
+ * Declarations for to Hexagon Virtal Machine.
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef ASM_HEXAGON_VM_H
+#define ASM_HEXAGON_VM_H
+
+/*
+ * In principle, a Linux kernel for the VM could
+ * selectively define the virtual instructions
+ * as inline assembler macros, but for a first pass,
+ * we'll use subroutines for both the VM and the native
+ * kernels.  It's costing a subroutine call/return,
+ * but it makes for a single set of entry points
+ * for tracing/debugging.
+ */
+
+/*
+ * Lets make this stuff visible only if configured,
+ * so we can unconditionally include the file.
+ */
+
+#ifndef __ASSEMBLY__
+
+enum VM_CACHE_OPS {
+	ickill,
+	dckill,
+	l2kill,
+	dccleaninva,
+	icinva,
+	idsync,
+	fetch_cfg
+};
+
+enum VM_INT_OPS {
+	nop,
+	globen,
+	globdis,
+	locen,
+	locdis,
+	affinity,
+	get,
+	peek,
+	status,
+	post,
+	clear
+};
+
+extern void _K_VM_event_vector(void);
+
+void __vmrte(void);
+long __vmsetvec(void *);
+long __vmsetie(long);
+long __vmgetie(void);
+long __vmintop(enum VM_INT_OPS, long, long, long, long);
+long __vmclrmap(void *, unsigned long);
+long __vmnewmap(void *);
+long __vmcache(enum VM_CACHE_OPS op, unsigned long addr, unsigned long len);
+unsigned long long __vmgettime(void);
+long __vmsettime(unsigned long long);
+long __vmstart(void *, void *);
+void __vmstop(void);
+long __vmwait(void);
+void __vmyield(void);
+long __vmvpid(void);
+
+static inline long __vmcache_ickill(void)
+{
+	return __vmcache(ickill, 0, 0);
+}
+
+static inline long __vmcache_dckill(void)
+{
+	return __vmcache(dckill, 0, 0);
+}
+
+static inline long __vmcache_l2kill(void)
+{
+	return __vmcache(l2kill, 0, 0);
+}
+
+static inline long __vmcache_dccleaninva(unsigned long addr, unsigned long len)
+{
+	return __vmcache(dccleaninva, addr, len);
+}
+
+static inline long __vmcache_icinva(unsigned long addr, unsigned long len)
+{
+	return __vmcache(icinva, addr, len);
+}
+
+static inline long __vmcache_idsync(unsigned long addr,
+					   unsigned long len)
+{
+	return __vmcache(idsync, addr, len);
+}
+
+static inline long __vmcache_fetch_cfg(unsigned long val)
+{
+	return __vmcache(fetch_cfg, val, 0);
+}
+
+/* interrupt operations  */
+
+static inline long __vmintop_nop(void)
+{
+	return __vmintop(nop, 0, 0, 0, 0);
+}
+
+static inline long __vmintop_globen(long i)
+{
+	return __vmintop(globen, i, 0, 0, 0);
+}
+
+static inline long __vmintop_globdis(long i)
+{
+	return __vmintop(globdis, i, 0, 0, 0);
+}
+
+static inline long __vmintop_locen(long i)
+{
+	return __vmintop(locen, i, 0, 0, 0);
+}
+
+static inline long __vmintop_locdis(long i)
+{
+	return __vmintop(locdis, i, 0, 0, 0);
+}
+
+static inline long __vmintop_affinity(long i, long cpu)
+{
+	return __vmintop(locdis, i, cpu, 0, 0);
+}
+
+static inline long __vmintop_get(void)
+{
+	return __vmintop(get, 0, 0, 0, 0);
+}
+
+static inline long __vmintop_peek(void)
+{
+	return __vmintop(peek, 0, 0, 0, 0);
+}
+
+static inline long __vmintop_status(long i)
+{
+	return __vmintop(status, i, 0, 0, 0);
+}
+
+static inline long __vmintop_post(long i)
+{
+	return __vmintop(post, i, 0, 0, 0);
+}
+
+static inline long __vmintop_clear(long i)
+{
+	return __vmintop(clear, i, 0, 0, 0);
+}
+
+#else /* Only assembly code should reference these */
+
+#define HVM_TRAP1_VMRTE			1
+#define HVM_TRAP1_VMSETVEC		2
+#define HVM_TRAP1_VMSETIE		3
+#define HVM_TRAP1_VMGETIE		4
+#define HVM_TRAP1_VMINTOP		5
+#define HVM_TRAP1_VMCLRMAP		10
+#define HVM_TRAP1_VMNEWMAP		11
+#define HVM_TRAP1_FORMERLY_VMWIRE	12
+#define HVM_TRAP1_VMCACHE		13
+#define HVM_TRAP1_VMGETTIME		14
+#define HVM_TRAP1_VMSETTIME		15
+#define HVM_TRAP1_VMWAIT		16
+#define HVM_TRAP1_VMYIELD		17
+#define HVM_TRAP1_VMSTART		18
+#define HVM_TRAP1_VMSTOP		19
+#define HVM_TRAP1_VMVPID		20
+#define HVM_TRAP1_VMSETREGS		21
+#define HVM_TRAP1_VMGETREGS		22
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * Constants for virtual instruction parameters and return values
+ */
+
+/* vmsetie arguments */
+
+#define VM_INT_DISABLE	0
+#define VM_INT_ENABLE	1
+
+/* vmsetimask arguments */
+
+#define VM_INT_UNMASK	0
+#define VM_INT_MASK	1
+
+#define VM_NEWMAP_TYPE_LINEAR	0
+#define VM_NEWMAP_TYPE_PGTABLES	1
+
+
+/*
+ * Event Record definitions useful to both C and Assembler
+ */
+
+/* VMEST Layout */
+
+#define HVM_VMEST_UM_SFT	31
+#define HVM_VMEST_UM_MSK	1
+#define HVM_VMEST_IE_SFT	30
+#define HVM_VMEST_IE_MSK	1
+#define HVM_VMEST_EVENTNUM_SFT	16
+#define HVM_VMEST_EVENTNUM_MSK	0xff
+#define HVM_VMEST_CAUSE_SFT	0
+#define HVM_VMEST_CAUSE_MSK	0xffff
+
+/*
+ * The initial program gets to find a system environment descriptor
+ * on its stack when it begins exection. The first word is a version
+ * code to indicate what is there.  Zero means nothing more.
+ */
+
+#define HEXAGON_VM_SED_NULL	0
+
+/*
+ * Event numbers for vector binding
+ */
+
+#define HVM_EV_RESET		0
+#define HVM_EV_MACHCHECK	1
+#define HVM_EV_GENEX		2
+#define HVM_EV_TRAP		8
+#define HVM_EV_INTR		15
+/* These shoud be nuked as soon as we know the VM is up to spec v0.1.1 */
+#define HVM_EV_INTR_0		16
+#define HVM_MAX_INTR		240
+
+/*
+ * Cause values for General Exception
+ */
+
+#define HVM_GE_C_BUS	0x01
+#define HVM_GE_C_XPROT	0x11
+#define HVM_GE_C_XUSER	0x14
+#define HVM_GE_C_INVI	0x15
+#define HVM_GE_C_PRIVI	0x1B
+#define HVM_GE_C_XMAL	0x1C
+#define HVM_GE_C_RMAL	0x20
+#define HVM_GE_C_WMAL	0x21
+#define HVM_GE_C_RPROT	0x22
+#define HVM_GE_C_WPROT	0x23
+#define HVM_GE_C_RUSER	0x24
+#define HVM_GE_C_WUSER	0x25
+#define HVM_GE_C_CACHE	0x28
+
+/*
+ * Cause codes for Machine Check
+ */
+
+#define	HVM_MCHK_C_DOWN		0x00
+#define	HVM_MCHK_C_BADSP	0x01
+#define	HVM_MCHK_C_BADEX	0x02
+#define	HVM_MCHK_C_BADPT	0x03
+#define	HVM_MCHK_C_REGWR	0x29
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/vm_mmu.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/vm_mmu.h	2011-09-08 19:22:01.120238955 -0500
@@ -0,0 +1,111 @@
+/*
+ * Hexagon VM page table entry definitions
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_VM_MMU_H
+#define _ASM_VM_MMU_H
+
+/*
+ * Shift, mask, and other constants for the Hexagon Virtual Machine
+ * page tables.
+ *
+ * Virtual machine MMU allows first-level entries to either be
+ * single-level lookup PTEs for very large pages, or PDEs pointing
+ * to second-level PTEs for smaller pages. If PTE is single-level,
+ * the least significant bits cannot be used as software bits to encode
+ * virtual memory subsystem information about the page, and that state
+ * must be maintained in some parallel data structure.
+ */
+
+/* S or Page Size field in PDE */
+#define	__HVM_PDE_S		(0x7 << 0)
+#define __HVM_PDE_S_4KB		0
+#define __HVM_PDE_S_16KB	1
+#define __HVM_PDE_S_64KB	2
+#define __HVM_PDE_S_256KB	3
+#define __HVM_PDE_S_1MB		4
+#define __HVM_PDE_S_4MB		5
+#define __HVM_PDE_S_16MB	6
+#define __HVM_PDE_S_INVALID	7
+
+/* Masks for L2 page table pointer, as function of page size */
+#define __HVM_PDE_PTMASK_4KB	0xfffff000
+#define __HVM_PDE_PTMASK_16KB	0xfffffc00
+#define __HVM_PDE_PTMASK_64KB	0xffffff00
+#define __HVM_PDE_PTMASK_256KB	0xffffffc0
+#define __HVM_PDE_PTMASK_1MB	0xfffffff0
+
+/*
+ * Virtual Machine PTE Bits/Fields
+ */
+#define __HVM_PTE_T		(1<<4)
+#define __HVM_PTE_U		(1<<5)
+#define	__HVM_PTE_C		(0x7<<6)
+#define __HVM_PTE_CVAL(pte)	(((pte) & __HVM_PTE_C) >> 6)
+#define __HVM_PTE_R		(1<<9)
+#define __HVM_PTE_W		(1<<10)
+#define __HVM_PTE_X		(1<<11)
+
+/*
+ * Cache Attributes, to be shifted as necessary for virtual/physical PTEs
+ */
+
+#define __HEXAGON_C_WB		0x0	/* Write-back, no L2 */
+#define	__HEXAGON_C_WT		0x1	/* Write-through, no L2 */
+#define	__HEXAGON_C_DEV		0x4	/* Device register space */
+#define	__HEXAGON_C_WT_L2	0x5	/* Write-through, with L2 */
+/* this really should be #if CONFIG_HEXAGON_ARCH = 2 but that's not defined */
+#if defined(CONFIG_HEXAGON_COMET) || defined(CONFIG_QDSP6_ST1)
+#define __HEXAGON_C_UNC		__HEXAGON_C_DEV
+#else
+#define	__HEXAGON_C_UNC		0x6	/* Uncached memory */
+#endif
+#define	__HEXAGON_C_WB_L2	0x7	/* Write-back, with L2 */
+
+/*
+ * This can be overriden, but we're defaulting to the most aggressive
+ * cache policy, the better to find bugs sooner.
+ */
+
+#define	CACHE_DEFAULT	__HEXAGON_C_WB_L2
+
+/* Masks for physical page address, as a function of page size */
+
+#define __HVM_PTE_PGMASK_4KB	0xfffff000
+#define __HVM_PTE_PGMASK_16KB	0xffffc000
+#define __HVM_PTE_PGMASK_64KB	0xffff0000
+#define __HVM_PTE_PGMASK_256KB	0xfffc0000
+#define __HVM_PTE_PGMASK_1MB	0xfff00000
+
+/* Masks for single-level large page lookups */
+
+#define __HVM_PTE_PGMASK_4MB	0xffc00000
+#define __HVM_PTE_PGMASK_16MB	0xff000000
+
+/*
+ * "Big kernel page mappings" (see vm_init_segtable.S)
+ * are currently 16MB
+ */
+
+#define BIG_KERNEL_PAGE_SHIFT 24
+#define BIG_KERNEL_PAGE_SIZE (1 << BIG_KERNEL_PAGE_SHIFT)
+
+
+
+#endif /* _ASM_VM_MMU_H */
Index: linux-hexagon-kernel/arch/hexagon/kernel/vm_entry.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/vm_entry.S	2011-09-08 19:22:01.120238955 -0500
@@ -0,0 +1,269 @@
+/*
+ * Event entry/exit for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <asm/asm-offsets.h>  /*  assembly-safer versions of C defines */
+#include <asm/mem-layout.h>   /*  sigh, except for page_offset  */
+#include <asm/hexagon_vm.h>
+#include <asm/thread_info.h>
+
+/*
+ * Entry into guest-mode Linux under Hexagon Virtual Machine.
+ * Stack pointer points to event record - build pt_regs on top of it,
+ * set up a plausible C stack frame, and dispatch to the C handler.
+ * On return, do vmrte virtual instruction with SP where we started.
+ *
+ * VM Spec 0.5 uses a trap to fetch HVM record now.
+ */
+
+/*
+ * Save full register state, while setting up thread_info struct
+ * pointer derived from kernel stack pointer in THREADINFO_REG
+ * register, putting prior thread_info.regs pointer in a callee-save
+ * register (R24, which had better not ever be assigned to THREADINFO_REG),
+ * and updating thread_info.regs to point to current stack frame,
+ * so as to support nested events in kernel mode.
+ *
+ * As this is common code, we set the pt_regs system call number
+ * to -1 for all events.  It will be replaced with the system call
+ * number in the case where we decode a system call (trap0(#1)).
+ */
+
+#define save_pt_regs()\
+	memd(R0 + #_PT_R3130) = R31:30; \
+	{ memw(R0 + #_PT_R2928) = R28; \
+	  R31 = memw(R0 + #_PT_ER_VMPSP); }\
+	{ memw(R0 + #(_PT_R2928 + 4)) = R31; \
+	  R31 = ugp; } \
+	{ memd(R0 + #_PT_R2726) = R27:26; \
+	  R30 = gp ; } \
+	memd(R0 + #_PT_R2524) = R25:24; \
+	memd(R0 + #_PT_R2322) = R23:22; \
+	memd(R0 + #_PT_R2120) = R21:20; \
+	memd(R0 + #_PT_R1918) = R19:18; \
+	memd(R0 + #_PT_R1716) = R17:16; \
+	memd(R0 + #_PT_R1514) = R15:14; \
+	memd(R0 + #_PT_R1312) = R13:12; \
+	{ memd(R0 + #_PT_R1110) = R11:10; \
+	  R15 = lc0; } \
+	{ memd(R0 + #_PT_R0908) = R9:8; \
+	  R14 = sa0; } \
+	{ memd(R0 + #_PT_R0706) = R7:6; \
+	  R13 = lc1; } \
+	{ memd(R0 + #_PT_R0504) = R5:4; \
+	  R12 = sa1; } \
+	{ memd(R0 + #_PT_UGPGP) = R31:30; \
+	  R11 = m1; \
+	  R2.H = #HI(_THREAD_SIZE); } \
+	{ memd(R0 + #_PT_LC0SA0) = R15:14; \
+	  R10 = m0; \
+	  R2.L = #LO(_THREAD_SIZE); } \
+	{ memd(R0 + #_PT_LC1SA1) = R13:12; \
+	  R15 = p3:0; \
+	  R2 = neg(R2); } \
+	{ memd(R0 + #_PT_M1M0) = R11:10; \
+	  R14  = usr; \
+	  R2 = and(R0,R2); } \
+	{ memd(R0 + #_PT_PREDSUSR) =  R15:14; \
+	  THREADINFO_REG = R2; } \
+	{ r24 = memw(THREADINFO_REG + #_THREAD_INFO_PT_REGS); \
+	  memw(THREADINFO_REG + #_THREAD_INFO_PT_REGS) = R0; \
+	  R2 = #-1; } \
+	{ memw(R0 + #_PT_SYSCALL_NR) = R2; \
+	  R30 = #0; }
+
+/*
+ * Restore registers and thread_info.regs state. THREADINFO_REG
+ * is assumed to still be sane, and R24 to have been correctly
+ * preserved. Don't restore R29 (SP) until later.
+ */
+
+#define restore_pt_regs() \
+	{ memw(THREADINFO_REG + #_THREAD_INFO_PT_REGS) = R24; \
+	  R15:14 = memd(R0 + #_PT_PREDSUSR); } \
+	{ R11:10 = memd(R0 + #_PT_M1M0); \
+	  p3:0 = R15; } \
+	{ R13:12 = memd(R0 + #_PT_LC1SA1); \
+	  usr = R14; } \
+	{ R15:14 = memd(R0 + #_PT_LC0SA0); \
+	  m1 = R11; } \
+	{ R3:2 = memd(R0 + #_PT_R0302); \
+	  m0 = R10; } \
+	{ R5:4 = memd(R0 + #_PT_R0504); \
+	  lc1 = R13; } \
+	{ R7:6 = memd(R0 + #_PT_R0706); \
+	  sa1 = R12; } \
+	{ R9:8 = memd(R0 + #_PT_R0908); \
+	  lc0 = R15; } \
+	{ R11:10 = memd(R0 + #_PT_R1110); \
+	  sa0 = R14; } \
+	{ R13:12 = memd(R0 + #_PT_R1312); \
+	  R15:14 = memd(R0 + #_PT_R1514); } \
+	{ R17:16 = memd(R0 + #_PT_R1716); \
+	  R19:18 = memd(R0 + #_PT_R1918); } \
+	{ R21:20 = memd(R0 + #_PT_R2120); \
+	  R23:22 = memd(R0 + #_PT_R2322); } \
+	{ R25:24 = memd(R0 + #_PT_R2524); \
+	  R27:26 = memd(R0 + #_PT_R2726); } \
+	R31:30 = memd(R0 + #_PT_UGPGP); \
+	{ R28 = memw(R0 + #_PT_R2928); \
+	  ugp = R31; } \
+	{ R31:30 = memd(R0 + #_PT_R3130); \
+	  gp = R30; }
+
+	/*
+	 * Clears off enough space for the rest of pt_regs; evrec is a part
+	 * of pt_regs in HVM mode.  Save R0/R1, set handler's address in R1.
+	 * R0 is the address of pt_regs and is the parameter to save_pt_regs.
+	 */
+
+/*
+ * Since the HVM isn't automagically pushing the EVREC onto the stack anymore,
+ * we'll subract the entire size out and then fill it in ourselves.
+ * Need to save off R0, R1, R2, R3 immediately.
+ */
+
+#define	vm_event_entry(CHandler) \
+	{ \
+		R29 = add(R29, #-(_PT_REGS_SIZE)); \
+		memd(R29 + #(_PT_R0100 + -_PT_REGS_SIZE)) = R1:0; \
+	} \
+	{ \
+		memd(R29 +#_PT_R0302) = R3:2; \
+	} \
+	trap1(#HVM_TRAP1_VMGETREGS); \
+	{ \
+		memd(R29 + #_PT_ER_VMEL) = R1:0; \
+		R0 = R29; \
+		R1.L = #LO(CHandler); \
+	} \
+	{ \
+		memd(R29 + #_PT_ER_VMPSP) = R3:2; \
+		R1.H = #HI(CHandler); \
+		jump event_dispatch; \
+	}
+
+.text
+	/*
+	 * Do bulk save/restore in one place.
+	 * Adds a jump to dispatch latency, but
+	 * saves hundreds of bytes.
+	 */
+
+event_dispatch:
+	save_pt_regs()
+	callr	r1
+
+	/*
+	 * If we were in kernel mode, we don't need to check scheduler
+	 * or signals if CONFIG_PREEMPT is not set.  If set, then it has
+	 * to jump to a need_resched kind of block.
+	 * BTW, CONFIG_PREEMPT is not supported yet.
+	 */
+
+#ifdef CONFIG_PREEMPT
+	R0 = #VM_INT_DISABLE
+	trap1(#HVM_TRAP1_VMSETIE)
+#endif
+
+	/*  "Nested control path" -- if the previous mode was kernel  */
+	R0 = memw(R29 + #_PT_ER_VMEST);
+	P0 = tstbit(R0, #HVM_VMEST_UM_SFT);
+	if !P0 jump restore_all;
+	/*
+	 * Returning from system call, normally coming back from user mode
+	 */
+return_from_syscall:
+	/*  Disable interrupts while checking TIF  */
+	R0 = #VM_INT_DISABLE
+	trap1(#HVM_TRAP1_VMSETIE)
+
+	/*
+	 * Coming back from the C-world, our thread info pointer
+	 * should be in the designated register (usually R19)
+	 */
+	R1.L = #LO(_TIF_ALLWORK_MASK)
+	{
+		R1.H = #HI(_TIF_ALLWORK_MASK);
+		R0 = memw(THREADINFO_REG + #_THREAD_INFO_FLAGS);
+	}
+
+	/*
+	 * Compare against the "return to userspace" _TIF_WORK_MASK
+	 */
+	R1 = and(R1,R0);
+	{ P0 = cmp.eq(R1,#0); if (!P0.new) jump:t work_pending;}
+	jump restore_all;  /*  we're outta here!  */
+
+work_pending:
+	{
+		P0 = tstbit(R1, #TIF_NEED_RESCHED);
+		if (!P0.new) jump:nt work_notifysig;
+	}
+	call schedule
+	jump return_from_syscall;  /*  check for more work  */
+
+work_notifysig:
+	/*  this is the part that's kind of fuzzy.  */
+	R1 = and(R0, #(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME));
+	P0 = cmp.eq(R1, #0);
+	if P0 jump restore_all
+	R1 = R0; 	/* unsigned long thread_info_flags */
+	R0 = R29;	/* regs should still be at top of stack  */
+	call do_notify_resume
+
+restore_all:
+	/* Disable interrupts, if they weren't already, before reg restore.  */
+	R0 = #VM_INT_DISABLE
+	trap1(#HVM_TRAP1_VMSETIE)
+
+	/*  do the setregs here for VM 0.5  */
+	/*  R29 here should already be pointing at pt_regs  */
+	R1:0 = memd(R29 + #_PT_ER_VMEL);
+	R3:2 = memd(R29 + #_PT_ER_VMPSP);
+	trap1(#HVM_TRAP1_VMSETREGS);
+
+	R0 = R29
+	restore_pt_regs()
+	R1:0 = memd(R29 + #_PT_R0100);
+	R29 = add(R29, #_PT_REGS_SIZE);
+	trap1(#HVM_TRAP1_VMRTE)
+	/* Notreached */
+
+	.globl _K_enter_genex
+_K_enter_genex:
+	vm_event_entry(do_genex)
+
+	.globl _K_enter_interrupt
+_K_enter_interrupt:
+	vm_event_entry(arch_do_IRQ)
+
+	.globl _K_enter_trap0
+_K_enter_trap0:
+	vm_event_entry(do_trap0)
+
+	.globl _K_enter_machcheck
+_K_enter_machcheck:
+	vm_event_entry(do_machcheck)
+
+
+	.globl ret_from_fork
+ret_from_fork:
+	call schedule_tail
+	jump return_from_syscall
Index: linux-hexagon-kernel/arch/hexagon/kernel/vm_events.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/vm_events.c	2011-09-08 19:22:01.120238955 -0500
@@ -0,0 +1,101 @@
+/*
+ * Mostly IRQ support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/kernel.h>
+#include <asm/registers.h>
+#include <linux/irq.h>
+#include <linux/hardirq.h>
+#include <asm/system.h>
+
+/*
+ * show_regs - print pt_regs structure
+ * @regs: pointer to pt_regs
+ *
+ * To-do:  add all the accessor definitions to registers.h
+ *
+ * Will make this routine a lot easier to write.
+ */
+void show_regs(struct pt_regs *regs)
+{
+	printk(KERN_EMERG "restart_r0: \t0x%08lx   syscall_nr: %ld\n",
+	       regs->restart_r0, regs->syscall_nr);
+	printk(KERN_EMERG "preds: \t\t0x%08lx\n", regs->preds);
+	printk(KERN_EMERG "lc0: \t0x%08lx   sa0: 0x%08lx   m0:  0x%08lx\n",
+	       regs->lc0, regs->sa0, regs->m0);
+	printk(KERN_EMERG "lc1: \t0x%08lx   sa1: 0x%08lx   m1:  0x%08lx\n",
+	       regs->lc1, regs->sa1, regs->m1);
+	printk(KERN_EMERG "gp: \t0x%08lx   ugp: 0x%08lx   usr: 0x%08lx\n",
+	       regs->gp, regs->ugp, regs->usr);
+	printk(KERN_EMERG "r0: \t0x%08lx %08lx %08lx %08lx\n", regs->r00,
+		regs->r01,
+		regs->r02,
+		regs->r03);
+	printk(KERN_EMERG "r4:  \t0x%08lx %08lx %08lx %08lx\n", regs->r04,
+		regs->r05,
+		regs->r06,
+		regs->r07);
+	printk(KERN_EMERG "r8:  \t0x%08lx %08lx %08lx %08lx\n", regs->r08,
+		regs->r09,
+		regs->r10,
+		regs->r11);
+	printk(KERN_EMERG "r12: \t0x%08lx %08lx %08lx %08lx\n", regs->r12,
+		regs->r13,
+		regs->r14,
+		regs->r15);
+	printk(KERN_EMERG "r16: \t0x%08lx %08lx %08lx %08lx\n", regs->r16,
+		regs->r17,
+		regs->r18,
+		regs->r19);
+	printk(KERN_EMERG "r20: \t0x%08lx %08lx %08lx %08lx\n", regs->r20,
+		regs->r21,
+		regs->r22,
+		regs->r23);
+	printk(KERN_EMERG "r24: \t0x%08lx %08lx %08lx %08lx\n", regs->r24,
+		regs->r25,
+		regs->r26,
+		regs->r27);
+	printk(KERN_EMERG "r28: \t0x%08lx %08lx %08lx %08lx\n", regs->r28,
+		regs->r29,
+		regs->r30,
+		regs->r31);
+
+	printk(KERN_EMERG "elr: \t0x%08lx   cause: 0x%08lx   user_mode: %d\n",
+		pt_elr(regs), pt_cause(regs), user_mode(regs));
+	printk(KERN_EMERG "psp: \t0x%08lx   badva: 0x%08lx   int_enabled: %d\n",
+		pt_psp(regs), pt_badva(regs), ints_enabled(regs));
+}
+
+void dummy_handler(struct pt_regs *regs)
+{
+	unsigned int elr = pt_elr(regs);
+	printk(KERN_ERR "Unimplemented handler; ELR=0x%08x\n", elr);
+}
+
+
+void arch_do_IRQ(struct pt_regs *regs)
+{
+	int irq = pt_cause(regs);
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+	generic_handle_irq(irq);
+	irq_exit();
+	set_irq_regs(old_regs);
+}
Index: linux-hexagon-kernel/arch/hexagon/kernel/vm_init_segtable.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/vm_init_segtable.S	2011-09-08 19:22:01.120238955 -0500
@@ -0,0 +1,442 @@
+/*
+ * Initial page table for Linux kernel under Hexagon VM,
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*
+ * These tables are pre-computed and linked into kernel.
+ */
+
+#include <asm/vm_mmu.h>
+/*  #include <asm/iomap.h>  */
+
+/*
+ * Start with mapping PA=0 to both VA=0x0 and VA=0xc000000 as 16MB large pages.
+ * No user mode access, RWX, write-back cache.  The entry needs
+ * to be replicated for all 4 virtual segments mapping to the page.
+ */
+
+/* "Big Kernel Page"  */
+#define BKP(pa) (((pa) & __HVM_PTE_PGMASK_4MB)		\
+		| __HVM_PTE_R | __HVM_PTE_W | __HVM_PTE_X	\
+		| __HEXAGON_C_WB_L2 << 6			\
+		| __HVM_PDE_S_16MB)
+
+/*  No cache version  */
+
+#define BKPG_IO(pa) (((pa) & __HVM_PTE_PGMASK_16MB) \
+			| __HVM_PTE_R | __HVM_PTE_W | __HVM_PTE_X \
+			| __HVM_PDE_S_16MB | __HEXAGON_C_DEV << 6 )
+
+#define FOURK_IO(pa) (((pa) & __HVM_PTE_PGMASK_4KB) \
+			| __HVM_PTE_R | __HVM_PTE_W | __HVM_PTE_X \
+			| __HEXAGON_C_DEV << 6 )
+
+#define L2_PTR(pa) (((pa) & __HVM_PTE_PGMASK_4KB) \
+			| __HVM_PDE_S_4KB  )
+
+#define X __HVM_PDE_S_INVALID
+
+	.p2align 12
+	.globl swapper_pg_dir
+	.globl _K_init_segtable
+swapper_pg_dir:
+/* VA 0x00000000 */
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+/* VA 0x40000000 */
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+/* VA 0x80000000 */
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+/*0xa8*/.word X,X,X,X
+#ifdef CONFIG_COMET_EARLY_UART_DEBUG
+UART_PTE_ENTRY:
+/*0xa9*/.word BKPG_IO(0xa9000000),BKPG_IO(0xa9000000),BKPG_IO(0xa9000000),BKPG_IO(0xa9000000)
+#else
+/*0xa9*/.word X,X,X,X
+#endif
+/*0xaa*/.word X,X,X,X
+/*0xab*/.word X,X,X,X
+/*0xac*/.word X,X,X,X
+/*0xad*/.word X,X,X,X
+/*0xae*/.word X,X,X,X
+/*0xaf*/.word X,X,X,X
+/*0xb0*/.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+	.word X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X,X
+_K_init_segtable:
+/* VA 0xC0000000 */
+	.word BKP(0x00000000), BKP(0x00400000), BKP(0x00800000), BKP(0x00c00000)
+	.word BKP(0x01000000), BKP(0x01400000), BKP(0x01800000), BKP(0x01c00000)
+	.word BKP(0x02000000), BKP(0x02400000), BKP(0x02800000), BKP(0x02c00000)
+	.word BKP(0x03000000), BKP(0x03400000), BKP(0x03800000), BKP(0x03c00000)
+	.word BKP(0x04000000), BKP(0x04400000), BKP(0x04800000), BKP(0x04c00000)
+	.word BKP(0x05000000), BKP(0x05400000), BKP(0x05800000), BKP(0x05c00000)
+	.word BKP(0x06000000), BKP(0x06400000), BKP(0x06800000), BKP(0x06c00000)
+	.word BKP(0x07000000), BKP(0x07400000), BKP(0x07800000), BKP(0x07c00000)
+
+	.word BKP(0x08000000), BKP(0x08400000), BKP(0x08800000), BKP(0x08c00000)
+	.word BKP(0x09000000), BKP(0x09400000), BKP(0x09800000), BKP(0x09c00000)
+	.word BKP(0x0a000000), BKP(0x0a400000), BKP(0x0a800000), BKP(0x0ac00000)
+	.word BKP(0x0b000000), BKP(0x0b400000), BKP(0x0b800000), BKP(0x0bc00000)
+	.word BKP(0x0c000000), BKP(0x0c400000), BKP(0x0c800000), BKP(0x0cc00000)
+	.word BKP(0x0d000000), BKP(0x0d400000), BKP(0x0d800000), BKP(0x0dc00000)
+	.word BKP(0x0e000000), BKP(0x0e400000), BKP(0x0e800000), BKP(0x0ec00000)
+	.word BKP(0x0f000000), BKP(0x0f400000), BKP(0x0f800000), BKP(0x0fc00000)
+
+	.word BKP(0x10000000), BKP(0x10400000), BKP(0x10800000), BKP(0x10c00000)
+	.word BKP(0x11000000), BKP(0x11400000), BKP(0x11800000), BKP(0x11c00000)
+	.word BKP(0x12000000), BKP(0x12400000), BKP(0x12800000), BKP(0x12c00000)
+	.word BKP(0x13000000), BKP(0x13400000), BKP(0x13800000), BKP(0x13c00000)
+	.word BKP(0x14000000), BKP(0x14400000), BKP(0x14800000), BKP(0x14c00000)
+	.word BKP(0x15000000), BKP(0x15400000), BKP(0x15800000), BKP(0x15c00000)
+	.word BKP(0x16000000), BKP(0x16400000), BKP(0x16800000), BKP(0x16c00000)
+	.word BKP(0x17000000), BKP(0x17400000), BKP(0x17800000), BKP(0x17c00000)
+
+	.word BKP(0x18000000), BKP(0x18400000), BKP(0x18800000), BKP(0x18c00000)
+	.word BKP(0x19000000), BKP(0x19400000), BKP(0x19800000), BKP(0x19c00000)
+	.word BKP(0x1a000000), BKP(0x1a400000), BKP(0x1a800000), BKP(0x1ac00000)
+	.word BKP(0x1b000000), BKP(0x1b400000), BKP(0x1b800000), BKP(0x1bc00000)
+	.word BKP(0x1c000000), BKP(0x1c400000), BKP(0x1c800000), BKP(0x1cc00000)
+	.word BKP(0x1d000000), BKP(0x1d400000), BKP(0x1d800000), BKP(0x1dc00000)
+	.word BKP(0x1e000000), BKP(0x1e400000), BKP(0x1e800000), BKP(0x1ec00000)
+	.word BKP(0x1f000000), BKP(0x1f400000), BKP(0x1f800000), BKP(0x1fc00000)
+
+	.word BKP(0x20000000), BKP(0x20400000), BKP(0x20800000), BKP(0x20c00000)
+	.word BKP(0x21000000), BKP(0x21400000), BKP(0x21800000), BKP(0x21c00000)
+	.word BKP(0x22000000), BKP(0x22400000), BKP(0x22800000), BKP(0x22c00000)
+	.word BKP(0x23000000), BKP(0x23400000), BKP(0x23800000), BKP(0x23c00000)
+	.word BKP(0x24000000), BKP(0x24400000), BKP(0x24800000), BKP(0x24c00000)
+	.word BKP(0x25000000), BKP(0x25400000), BKP(0x25800000), BKP(0x25c00000)
+	.word BKP(0x26000000), BKP(0x26400000), BKP(0x26800000), BKP(0x26c00000)
+	.word BKP(0x27000000), BKP(0x27400000), BKP(0x27800000), BKP(0x27c00000)
+
+	.word BKP(0x28000000), BKP(0x28400000), BKP(0x28800000), BKP(0x28c00000)
+	.word BKP(0x29000000), BKP(0x29400000), BKP(0x29800000), BKP(0x29c00000)
+	.word BKP(0x2a000000), BKP(0x2a400000), BKP(0x2a800000), BKP(0x2ac00000)
+	.word BKP(0x2b000000), BKP(0x2b400000), BKP(0x2b800000), BKP(0x2bc00000)
+	.word BKP(0x2c000000), BKP(0x2c400000), BKP(0x2c800000), BKP(0x2cc00000)
+	.word BKP(0x2d000000), BKP(0x2d400000), BKP(0x2d800000), BKP(0x2dc00000)
+	.word BKP(0x2e000000), BKP(0x2e400000), BKP(0x2e800000), BKP(0x2ec00000)
+	.word BKP(0x2f000000), BKP(0x2f400000), BKP(0x2f800000), BKP(0x2fc00000)
+
+	.word BKP(0x30000000), BKP(0x30400000), BKP(0x30800000), BKP(0x30c00000)
+	.word BKP(0x31000000), BKP(0x31400000), BKP(0x31800000), BKP(0x31c00000)
+	.word BKP(0x32000000), BKP(0x32400000), BKP(0x32800000), BKP(0x32c00000)
+	.word BKP(0x33000000), BKP(0x33400000), BKP(0x33800000), BKP(0x33c00000)
+	.word BKP(0x34000000), BKP(0x34400000), BKP(0x34800000), BKP(0x34c00000)
+	.word BKP(0x35000000), BKP(0x35400000), BKP(0x35800000), BKP(0x35c00000)
+	.word BKP(0x36000000), BKP(0x36400000), BKP(0x36800000), BKP(0x36c00000)
+	.word BKP(0x37000000), BKP(0x37400000), BKP(0x37800000), BKP(0x37c00000)
+
+	.word BKP(0x38000000), BKP(0x38400000), BKP(0x38800000), BKP(0x38c00000)
+	.word BKP(0x39000000), BKP(0x39400000), BKP(0x39800000), BKP(0x39c00000)
+	.word BKP(0x3a000000), BKP(0x3a400000), BKP(0x3a800000), BKP(0x3ac00000)
+	.word BKP(0x3b000000), BKP(0x3b400000), BKP(0x3b800000), BKP(0x3bc00000)
+	.word BKP(0x3c000000), BKP(0x3c400000), BKP(0x3c800000), BKP(0x3cc00000)
+	.word BKP(0x3d000000), BKP(0x3d400000), BKP(0x3d800000), BKP(0x3dc00000)
+_K_io_map:
+	.word X,X,X,X /* 0x3e000000 - device IO early remap */
+	.word X,X,X,X /* 0x3f000000 - hypervisor space*/
+
+#if 0
+/*
+ * This is in here as an example for devices which need to be mapped really
+ * early.
+ */
+	.p2align 12
+	.globl _K_io_kmap
+	.globl _K_init_devicetable
+_K_init_devicetable:  /*  Should be 4MB worth of entries  */
+	.word FOURK_IO(MSM_GPIO1_PHYS),FOURK_IO(MSM_GPIO2_PHYS),FOURK_IO(MSM_SIRC_PHYS),X
+	.word FOURK_IO(TLMM_GPIO1_PHYS),X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+	.word X,X,X,X
+#endif
Index: linux-hexagon-kernel/arch/hexagon/kernel/vm_ops.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/vm_ops.S	2011-09-08 19:22:01.120238955 -0500
@@ -0,0 +1,102 @@
+/*
+ * Hexagon VM instruction support
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/linkage.h>
+#include <asm/hexagon_vm.h>
+
+/*
+ * C wrappers for virtual machine "instructions".  These
+ * could be, and perhaps some day will be, handled as in-line
+ * macros, but for tracing/debugging it's handy to have
+ * a single point of invocation for each of them.
+ * Conveniently, they take paramters and return values
+ * consistent with the ABI calling convention.
+ */
+
+ENTRY(__vmrte)
+	trap1(#HVM_TRAP1_VMRTE);
+	jumpr	R31;
+
+ENTRY(__vmsetvec)
+	trap1(#HVM_TRAP1_VMSETVEC);
+	jumpr	R31;
+
+ENTRY(__vmsetie)
+	trap1(#HVM_TRAP1_VMSETIE);
+	jumpr	R31;
+
+ENTRY(__vmgetie)
+	trap1(#HVM_TRAP1_VMGETIE);
+	jumpr	R31;
+
+ENTRY(__vmintop)
+	trap1(#HVM_TRAP1_VMINTOP);
+	jumpr	R31;
+
+ENTRY(__vmclrmap)
+	trap1(#HVM_TRAP1_VMCLRMAP);
+	jumpr	R31;
+
+ENTRY(__vmnewmap)
+	r1 = #VM_NEWMAP_TYPE_PGTABLES;
+	trap1(#HVM_TRAP1_VMNEWMAP);
+	jumpr	R31;
+
+ENTRY(__vmcache)
+	trap1(#HVM_TRAP1_VMCACHE);
+	jumpr	R31;
+
+ENTRY(__vmgettime)
+	trap1(#HVM_TRAP1_VMGETTIME);
+	jumpr	R31;
+
+ENTRY(__vmsettime)
+	trap1(#HVM_TRAP1_VMSETTIME);
+	jumpr	R31;
+
+ENTRY(__vmwait)
+	trap1(#HVM_TRAP1_VMWAIT);
+	jumpr	R31;
+
+ENTRY(__vmyield)
+	trap1(#HVM_TRAP1_VMYIELD);
+	jumpr	R31;
+
+ENTRY(__vmstart)
+	trap1(#HVM_TRAP1_VMSTART);
+	jumpr	R31;
+
+ENTRY(__vmstop)
+	trap1(#HVM_TRAP1_VMSTOP);
+	jumpr	R31;
+
+ENTRY(__vmvpid)
+	trap1(#HVM_TRAP1_VMVPID);
+	jumpr	R31;
+
+/*  Probably not actually going to use these; see vm_entry.S  */
+
+ENTRY(__vmsetregs)
+	trap1(#HVM_TRAP1_VMSETREGS);
+	jumpr	R31;
+
+ENTRY(__vmgetregs)
+	trap1(#HVM_TRAP1_VMGETREGS);
+	jumpr	R31;
Index: linux-hexagon-kernel/arch/hexagon/kernel/vm_switch.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/vm_switch.S	2011-09-08 19:22:01.120238955 -0500
@@ -0,0 +1,95 @@
+/*
+ * Context switch support for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <asm/asm-offsets.h>
+
+.text
+
+/*
+ * The register used as a fast-path thread information pointer
+ * is determined as a kernel configuration option.  If it happens
+ * to be a callee-save register, we're going to be saving and
+ * restoring it twice here.
+ *
+ * This code anticipates a revised ABI where R20-23 are added
+ * to the set of callee-save registers, but this should be
+ * backward compatible to legacy tools.
+ */
+
+
+/*
+ *	void switch_to(struct task_struct *prev,
+ *		struct task_struct *next, struct task_struct *last);
+ */
+	.p2align 2
+	.globl __switch_to
+	.type	__switch_to, @function
+
+/*
+ * When we exit the wormhole, we need to store the previous task
+ * in the new R0's pointer.  Technically it should be R2, but they should
+ * be the same; seems like a legacy thing.  In short, don't butcher
+ * R0, let it go back out unmolested.
+ */
+
+__switch_to:
+	/*
+	 * Push callee-saves onto "prev" stack.
+	 * Here, we're sneaky because the LR and FP
+	 * storage of the thread_stack structure
+	 * is automagically allocated by allocframe,
+	 * so we pass struct size less 8.
+	 */
+	allocframe(#(_SWITCH_STACK_SIZE - 8));
+	memd(R29+#(_SWITCH_R2726))=R27:26;
+	memd(R29+#(_SWITCH_R2524))=R25:24;
+	memd(R29+#(_SWITCH_R2322))=R23:22;
+	memd(R29+#(_SWITCH_R2120))=R21:20;
+	memd(R29+#(_SWITCH_R1918))=R19:18;
+	memd(R29+#(_SWITCH_R1716))=R17:16;
+	/* Stash thread_info pointer in task_struct */
+	memw(R0+#_TASK_THREAD_INFO) = THREADINFO_REG;
+	memw(R0 +#(_TASK_STRUCT_THREAD + _THREAD_STRUCT_SWITCH_SP)) = R29;
+	/* Switch to "next" stack and restore callee saves from there */
+	R29 = memw(R1 + #(_TASK_STRUCT_THREAD + _THREAD_STRUCT_SWITCH_SP));
+	{
+	    R27:26 = memd(R29+#(_SWITCH_R2726));
+	    R25:24 = memd(R29+#(_SWITCH_R2524));
+	}
+	{
+	    R23:22 = memd(R29+#(_SWITCH_R2322));
+	    R21:20 = memd(R29+#(_SWITCH_R2120));
+	}
+	{
+	    R19:18 = memd(R29+#(_SWITCH_R1918));
+	    R17:16 = memd(R29+#(_SWITCH_R1716));
+	}
+	{
+	    /* THREADINFO_REG is currently one of the callee-saved regs
+	     * above, and so be sure to re-load it last.
+	     */
+	    THREADINFO_REG = memw(R1 + #_TASK_THREAD_INFO);
+	    R31:30 = memd(R29+#_SWITCH_FP);
+	}
+	{
+	    R29 = add(R29,#_SWITCH_STACK_SIZE);
+	    jumpr R31;
+	}
+	.size	__switch_to, .-__switch_to
Index: linux-hexagon-kernel/arch/hexagon/kernel/vm_vectors.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/vm_vectors.S	2011-09-08 19:22:01.120238955 -0500
@@ -0,0 +1,50 @@
+/*
+ * Event jump tables
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <asm/hexagon_vm.h>
+
+.text
+
+/*  This is registered early on to allow angel  */
+.global _K_provisional_vec
+_K_provisional_vec:
+	jump 1f;
+	jump 1f;
+	jump 1f;
+	jump 1f;
+	jump 1f;
+	trap1(#HVM_TRAP1_VMRTE)
+	jump 1f;
+	jump 1f;
+
+
+.global _K_VM_event_vector
+_K_VM_event_vector:
+1:
+	jump 1b;  /*  Reset  */
+	jump _K_enter_machcheck;
+	jump _K_enter_genex;
+	jump 1b;  /*  3 Rsvd  */
+	jump 1b;  /*  4 Rsvd  */
+	jump _K_enter_trap0;
+	jump 1b;  /*  6 Rsvd  */
+	jump _K_enter_interrupt;
+
+

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

