Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab1KGQUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:20:03 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49744 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932737Ab1KGQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:20 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 05/16] ARM: LPAE: Factor out classic-MMU specific code into proc-v7-2level.S
Date: Mon,  7 Nov 2011 16:16:47 +0000
Message-Id: <1320682618-1182-6-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:11.0341 (UTC) FILETIME=[B443E5D0:01CC9D68]
X-MC-Unique: 111110716171704401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GKNKN015322

This patch modifies the proc-v7.S file so that it only contains code
shared between classic MMU and LPAE. The non-common code is factored out
into a separate file.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/proc-v7-2level.S |  171 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S        |  152 +------------------------------------
 2 files changed, 174 insertions(+), 149 deletions(-)
 create mode 100644 arch/arm/mm/proc-v7-2level.S

diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
new file mode 100644
index 0000000..3a4b3e7
--- /dev/null
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -0,0 +1,171 @@
+/*
+ * arch/arm/mm/proc-v7-2level.S
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define TTB_S		(1 << 1)
+#define TTB_RGN_NC	(0 << 3)
+#define TTB_RGN_OC_WBWA	(1 << 3)
+#define TTB_RGN_OC_WT	(2 << 3)
+#define TTB_RGN_OC_WB	(3 << 3)
+#define TTB_NOS		(1 << 5)
+#define TTB_IRGN_NC	((0 << 0) | (0 << 6))
+#define TTB_IRGN_WBWA	((0 << 0) | (1 << 6))
+#define TTB_IRGN_WT	((1 << 0) | (0 << 6))
+#define TTB_IRGN_WB	((1 << 0) | (1 << 6))
+
+/* PTWs cacheable, inner WB not shareable, outer WB not shareable */
+#define TTB_FLAGS_UP	TTB_IRGN_WB|TTB_RGN_OC_WB
+#define PMD_FLAGS_UP	PMD_SECT_WB
+
+/* PTWs cacheable, inner WBWA shareable, outer WBWA not shareable */
+#define TTB_FLAGS_SMP	TTB_IRGN_WBWA|TTB_S|TTB_NOS|TTB_RGN_OC_WBWA
+#define PMD_FLAGS_SMP	PMD_SECT_WBWA|PMD_SECT_S
+
+/*
+ *	cpu_v7_switch_mm(pgd_phys, tsk)
+ *
+ *	Set the translation table base pointer to be pgd_phys
+ *
+ *	- pgd_phys - physical address of new TTB
+ *
+ *	It is assumed that:
+ *	- we are not using split page tables
+ */
+ENTRY(cpu_v7_switch_mm)
+#ifdef CONFIG_MMU
+	mov	r2, #0
+	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
+	ALT_SMP(orr	r0, r0, #TTB_FLAGS_SMP)
+	ALT_UP(orr	r0, r0, #TTB_FLAGS_UP)
+#ifdef CONFIG_ARM_ERRATA_430973
+	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
+#endif
+#ifdef CONFIG_ARM_ERRATA_754322
+	dsb
+#endif
+	mcr	p15, 0, r2, c13, c0, 1		@ set reserved context ID
+	isb
+1:	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
+	isb
+#ifdef CONFIG_ARM_ERRATA_754322
+	dsb
+#endif
+	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
+	isb
+#endif
+	mov	pc, lr
+ENDPROC(cpu_v7_switch_mm)
+
+/*
+ *	cpu_v7_set_pte_ext(ptep, pte)
+ *
+ *	Set a level 2 translation table entry.
+ *
+ *	- ptep  - pointer to level 2 translation table entry
+ *		  (hardware version is stored at +2048 bytes)
+ *	- pte   - PTE value to store
+ *	- ext	- value for extended PTE bits
+ */
+ENTRY(cpu_v7_set_pte_ext)
+#ifdef CONFIG_MMU
+	str	r1, [r0]			@ linux version
+
+	bic	r3, r1, #0x000003f0
+	bic	r3, r3, #PTE_TYPE_MASK
+	orr	r3, r3, r2
+	orr	r3, r3, #PTE_EXT_AP0 | 2
+
+	tst	r1, #1 << 4
+	orrne	r3, r3, #PTE_EXT_TEX(1)
+
+	eor	r1, r1, #L_PTE_DIRTY
+	tst	r1, #L_PTE_RDONLY | L_PTE_DIRTY
+	orrne	r3, r3, #PTE_EXT_APX
+
+	tst	r1, #L_PTE_USER
+	orrne	r3, r3, #PTE_EXT_AP1
+#ifdef CONFIG_CPU_USE_DOMAINS
+	@ allow kernel read/write access to read-only user pages
+	tstne	r3, #PTE_EXT_APX
+	bicne	r3, r3, #PTE_EXT_APX | PTE_EXT_AP0
+#endif
+
+	tst	r1, #L_PTE_XN
+	orrne	r3, r3, #PTE_EXT_XN
+
+	tst	r1, #L_PTE_YOUNG
+	tstne	r1, #L_PTE_PRESENT
+	moveq	r3, #0
+
+ ARM(	str	r3, [r0, #2048]! )
+ THUMB(	add	r0, r0, #2048 )
+ THUMB(	str	r3, [r0] )
+	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
+#endif
+	mov	pc, lr
+ENDPROC(cpu_v7_set_pte_ext)
+
+	/*
+	 * Memory region attributes with SCTLR.TRE=1
+	 *
+	 *   n = TEX[0],C,B
+	 *   TR = PRRR[2n+1:2n]		- memory type
+	 *   IR = NMRR[2n+1:2n]		- inner cacheable property
+	 *   OR = NMRR[2n+17:2n+16]	- outer cacheable property
+	 *
+	 *			n	TR	IR	OR
+	 *   UNCACHED		000	00
+	 *   BUFFERABLE		001	10	00	00
+	 *   WRITETHROUGH	010	10	10	10
+	 *   WRITEBACK		011	10	11	11
+	 *   reserved		110
+	 *   WRITEALLOC		111	10	01	01
+	 *   DEV_SHARED		100	01
+	 *   DEV_NONSHARED	100	01
+	 *   DEV_WC		001	10
+	 *   DEV_CACHED		011	10
+	 *
+	 * Other attributes:
+	 *
+	 *   DS0 = PRRR[16] = 0		- device shareable property
+	 *   DS1 = PRRR[17] = 1		- device shareable property
+	 *   NS0 = PRRR[18] = 0		- normal shareable property
+	 *   NS1 = PRRR[19] = 1		- normal shareable property
+	 *   NOS = PRRR[24+n] = 1	- not outer shareable
+	 */
+.equ	PRRR,	0xff0a81a8
+.equ	NMRR,	0x40e040e0
+
+	/*
+	 * Macro for setting up the TTBRx and TTBCR registers.
+	 * - \ttb0 and \ttb1 updated with the corresponding flags.
+	 */
+	.macro	v7_ttb_setup, zero, ttbr0, ttbr1, tmp
+	mcr	p15, 0, \zero, c2, c0, 2	@ TTB control register
+	ALT_SMP(orr	\ttbr0, \ttbr0, #TTB_FLAGS_SMP)
+	ALT_UP(orr	\ttbr0, \ttbr0, #TTB_FLAGS_UP)
+	ALT_SMP(orr	\ttbr1, \ttbr1, #TTB_FLAGS_SMP)
+	ALT_UP(orr	\ttbr1, \ttbr1, #TTB_FLAGS_UP)
+	mcr	p15, 0, \ttbr1, c2, c0, 1	@ load TTB1
+	.endm
+
+	__CPUINIT
+
+	/*   AT
+	 *  TFR   EV X F   I D LR    S
+	 * .EEE ..EE PUI. .T.T 4RVI ZWRS BLDP WCAM
+	 * rxxx rrxx xxx0 0101 xxxx xxxx x111 xxxx < forced
+	 *    1    0 110       0011 1100 .111 1101 < we want
+	 */
+	.align	2
+	.type	v7_crval, #object
+v7_crval:
+	crval	clear=0x0120c302, mmuset=0x10c03c7d, ucset=0x00c01c7c
+
+	.previous
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 2c559ac..8debdba 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -19,24 +19,7 @@
 
 #include "proc-macros.S"
 
-#define TTB_S		(1 << 1)
-#define TTB_RGN_NC	(0 << 3)
-#define TTB_RGN_OC_WBWA	(1 << 3)
-#define TTB_RGN_OC_WT	(2 << 3)
-#define TTB_RGN_OC_WB	(3 << 3)
-#define TTB_NOS		(1 << 5)
-#define TTB_IRGN_NC	((0 << 0) | (0 << 6))
-#define TTB_IRGN_WBWA	((0 << 0) | (1 << 6))
-#define TTB_IRGN_WT	((1 << 0) | (0 << 6))
-#define TTB_IRGN_WB	((1 << 0) | (1 << 6))
-
-/* PTWs cacheable, inner WB not shareable, outer WB not shareable */
-#define TTB_FLAGS_UP	TTB_IRGN_WB|TTB_RGN_OC_WB
-#define PMD_FLAGS_UP	PMD_SECT_WB
-
-/* PTWs cacheable, inner WBWA shareable, outer WBWA not shareable */
-#define TTB_FLAGS_SMP	TTB_IRGN_WBWA|TTB_S|TTB_NOS|TTB_RGN_OC_WBWA
-#define PMD_FLAGS_SMP	PMD_SECT_WBWA|PMD_SECT_S
+#include "proc-v7-2level.S"
 
 ENTRY(cpu_v7_proc_init)
 	mov	pc, lr
@@ -97,124 +80,9 @@ ENTRY(cpu_v7_dcache_clean_area)
 	mov	pc, lr
 ENDPROC(cpu_v7_dcache_clean_area)
 
-/*
- *	cpu_v7_switch_mm(pgd_phys, tsk)
- *
- *	Set the translation table base pointer to be pgd_phys
- *
- *	- pgd_phys - physical address of new TTB
- *
- *	It is assumed that:
- *	- we are not using split page tables
- */
-ENTRY(cpu_v7_switch_mm)
-#ifdef CONFIG_MMU
-	mov	r2, #0
-	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
-	ALT_SMP(orr	r0, r0, #TTB_FLAGS_SMP)
-	ALT_UP(orr	r0, r0, #TTB_FLAGS_UP)
-#ifdef CONFIG_ARM_ERRATA_430973
-	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
-#endif
-#ifdef CONFIG_ARM_ERRATA_754322
-	dsb
-#endif
-	mcr	p15, 0, r2, c13, c0, 1		@ set reserved context ID
-	isb
-1:	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
-	isb
-#ifdef CONFIG_ARM_ERRATA_754322
-	dsb
-#endif
-	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
-	isb
-#endif
-	mov	pc, lr
-ENDPROC(cpu_v7_switch_mm)
-
-/*
- *	cpu_v7_set_pte_ext(ptep, pte)
- *
- *	Set a level 2 translation table entry.
- *
- *	- ptep  - pointer to level 2 translation table entry
- *		  (hardware version is stored at +2048 bytes)
- *	- pte   - PTE value to store
- *	- ext	- value for extended PTE bits
- */
-ENTRY(cpu_v7_set_pte_ext)
-#ifdef CONFIG_MMU
-	str	r1, [r0]			@ linux version
-
-	bic	r3, r1, #0x000003f0
-	bic	r3, r3, #PTE_TYPE_MASK
-	orr	r3, r3, r2
-	orr	r3, r3, #PTE_EXT_AP0 | 2
-
-	tst	r1, #1 << 4
-	orrne	r3, r3, #PTE_EXT_TEX(1)
-
-	eor	r1, r1, #L_PTE_DIRTY
-	tst	r1, #L_PTE_RDONLY | L_PTE_DIRTY
-	orrne	r3, r3, #PTE_EXT_APX
-
-	tst	r1, #L_PTE_USER
-	orrne	r3, r3, #PTE_EXT_AP1
-#ifdef CONFIG_CPU_USE_DOMAINS
-	@ allow kernel read/write access to read-only user pages
-	tstne	r3, #PTE_EXT_APX
-	bicne	r3, r3, #PTE_EXT_APX | PTE_EXT_AP0
-#endif
-
-	tst	r1, #L_PTE_XN
-	orrne	r3, r3, #PTE_EXT_XN
-
-	tst	r1, #L_PTE_YOUNG
-	tstne	r1, #L_PTE_PRESENT
-	moveq	r3, #0
-
- ARM(	str	r3, [r0, #2048]! )
- THUMB(	add	r0, r0, #2048 )
- THUMB(	str	r3, [r0] )
-	mcr	p15, 0, r0, c7, c10, 1		@ flush_pte
-#endif
-	mov	pc, lr
-ENDPROC(cpu_v7_set_pte_ext)
-
 	string	cpu_v7_name, "ARMv7 Processor"
 	.align
 
-	/*
-	 * Memory region attributes with SCTLR.TRE=1
-	 *
-	 *   n = TEX[0],C,B
-	 *   TR = PRRR[2n+1:2n]		- memory type
-	 *   IR = NMRR[2n+1:2n]		- inner cacheable property
-	 *   OR = NMRR[2n+17:2n+16]	- outer cacheable property
-	 *
-	 *			n	TR	IR	OR
-	 *   UNCACHED		000	00
-	 *   BUFFERABLE		001	10	00	00
-	 *   WRITETHROUGH	010	10	10	10
-	 *   WRITEBACK		011	10	11	11
-	 *   reserved		110
-	 *   WRITEALLOC		111	10	01	01
-	 *   DEV_SHARED		100	01
-	 *   DEV_NONSHARED	100	01
-	 *   DEV_WC		001	10
-	 *   DEV_CACHED		011	10
-	 *
-	 * Other attributes:
-	 *
-	 *   DS0 = PRRR[16] = 0		- device shareable property
-	 *   DS1 = PRRR[17] = 1		- device shareable property
-	 *   NS0 = PRRR[18] = 0		- normal shareable property
-	 *   NS1 = PRRR[19] = 1		- normal shareable property
-	 *   NOS = PRRR[24+n] = 1	- not outer shareable
-	 */
-.equ	PRRR,	0xff0a81a8
-.equ	NMRR,	0x40e040e0
-
 /* Suspend/resume support: derived from arch/arm/mach-s5pv210/sleep.S */
 .globl	cpu_v7_suspend_size
 .equ	cpu_v7_suspend_size, 4 * 7
@@ -377,12 +245,7 @@ __v7_setup:
 	dsb
 #ifdef CONFIG_MMU
 	mcr	p15, 0, r10, c8, c7, 0		@ invalidate I + D TLBs
-	mcr	p15, 0, r10, c2, c0, 2		@ TTB control register
-	ALT_SMP(orr	r4, r4, #TTB_FLAGS_SMP)
-	ALT_UP(orr	r4, r4, #TTB_FLAGS_UP)
-	ALT_SMP(orr	r8, r8, #TTB_FLAGS_SMP)
-	ALT_UP(orr	r8, r8, #TTB_FLAGS_UP)
-	mcr	p15, 0, r8, c2, c0, 1		@ load TTB1
+	v7_ttb_setup r10, r4, r8, r5		@ TTBCR, TTBRx setup
 	ldr	r5, =PRRR			@ PRRR
 	ldr	r6, =NMRR			@ NMRR
 	mcr	p15, 0, r5, c10, c2, 0		@ write PRRR
@@ -404,16 +267,7 @@ __v7_setup:
 	mov	pc, lr				@ return to head.S:__ret
 ENDPROC(__v7_setup)
 
-	/*   AT
-	 *  TFR   EV X F   I D LR    S
-	 * .EEE ..EE PUI. .T.T 4RVI ZWRS BLDP WCAM
-	 * rxxx rrxx xxx0 0101 xxxx xxxx x111 xxxx < forced
-	 *    1    0 110       0011 1100 .111 1101 < we want
-	 */
-	.type	v7_crval, #object
-v7_crval:
-	crval	clear=0x0120c302, mmuset=0x10c03c7d, ucset=0x00c01c7c
-
+	.align	2
 __v7_setup_stack:
 	.space	4 * 11				@ 11 registers
 

