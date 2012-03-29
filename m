Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936679Ab2C3WzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:55:01 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934734Ab2C3VFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:55 -0400
Message-Id: <201203302105.q2UL563i006297@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 29 Mar 2012 15:48:23 -0400
Subject: [PATCH] arch/tile: support kexec() for tilegx
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Perches <joe@perches.com>, Ralf Baechle <ralf@linux-mips.org>,
        linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:06.0710 (UTC) FILETIME=[C8AC0360:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/kexec.h         |   12 ++
 arch/tile/kernel/Makefile             |    2 +-
 arch/tile/kernel/machine_kexec.c      |   35 +++-
 arch/tile/kernel/relocate_kernel.S    |  280 ---------------------------------
 arch/tile/kernel/relocate_kernel_32.S |  280 +++++++++++++++++++++++++++++++++
 arch/tile/kernel/relocate_kernel_64.S |  260 ++++++++++++++++++++++++++++++
 6 files changed, 580 insertions(+), 289 deletions(-)
 delete mode 100644 arch/tile/kernel/relocate_kernel.S
 create mode 100644 arch/tile/kernel/relocate_kernel_32.S
 create mode 100644 arch/tile/kernel/relocate_kernel_64.S

diff --git a/arch/tile/include/asm/kexec.h b/arch/tile/include/asm/kexec.h
index c11a6cc..fc98ccf 100644
--- a/arch/tile/include/asm/kexec.h
+++ b/arch/tile/include/asm/kexec.h
@@ -19,12 +19,24 @@
 
 #include <asm/page.h>
 
+#ifndef __tilegx__
 /* Maximum physical address we can use pages from. */
 #define KEXEC_SOURCE_MEMORY_LIMIT TASK_SIZE
 /* Maximum address we can reach in physical address mode. */
 #define KEXEC_DESTINATION_MEMORY_LIMIT TASK_SIZE
 /* Maximum address we can use for the control code buffer. */
 #define KEXEC_CONTROL_MEMORY_LIMIT TASK_SIZE
+#else
+/* We need to limit the memory below PGDIR_SIZE since
+ * we only setup page table for [0, PGDIR_SIZE) before final kexec.
+ */
+/* Maximum physical address we can use pages from. */
+#define KEXEC_SOURCE_MEMORY_LIMIT PGDIR_SIZE
+/* Maximum address we can reach in physical address mode. */
+#define KEXEC_DESTINATION_MEMORY_LIMIT PGDIR_SIZE
+/* Maximum address we can use for the control code buffer. */
+#define KEXEC_CONTROL_MEMORY_LIMIT PGDIR_SIZE
+#endif
 
 #define KEXEC_CONTROL_PAGE_SIZE	PAGE_SIZE
 
diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
index d6261e4..f19116d 100644
--- a/arch/tile/kernel/Makefile
+++ b/arch/tile/kernel/Makefile
@@ -13,5 +13,5 @@ obj-$(CONFIG_COMPAT)		+= compat.o compat_signal.o
 obj-$(CONFIG_SMP)		+= smpboot.o smp.o tlb.o
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel_$(BITS).o
 obj-$(CONFIG_PCI)		+= pci.o
diff --git a/arch/tile/kernel/machine_kexec.c b/arch/tile/kernel/machine_kexec.c
index b0fa37c..f0b54a9 100644
--- a/arch/tile/kernel/machine_kexec.c
+++ b/arch/tile/kernel/machine_kexec.c
@@ -31,6 +31,8 @@
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/checksum.h>
+#include <asm/tlbflush.h>
+#include <asm/homecache.h>
 #include <hv/hypervisor.h>
 
 
@@ -222,11 +224,22 @@ struct page *kimage_alloc_pages_arch(gfp_t gfp_mask, unsigned int order)
 	return alloc_pages_node(0, gfp_mask, order);
 }
 
+/*
+ * Address range in which pa=va mapping is set in setup_quasi_va_is_pa().
+ * For tilepro, PAGE_OFFSET is used since this is the largest possbile value
+ * for tilepro, while for tilegx, we limit it to entire middle level page
+ * table which we assume has been allocated and is undoubtedly large enough.
+ */
+#ifndef __tilegx__
+#define	QUASI_VA_IS_PA_ADDR_RANGE PAGE_OFFSET
+#else
+#define	QUASI_VA_IS_PA_ADDR_RANGE PGDIR_SIZE
+#endif
+
 static void setup_quasi_va_is_pa(void)
 {
-	HV_PTE *pgtable;
 	HV_PTE pte;
-	int i;
+	unsigned long i;
 
 	/*
 	 * Flush our TLB to prevent conflicts between the previous contents
@@ -234,16 +247,22 @@ static void setup_quasi_va_is_pa(void)
 	 */
 	local_flush_tlb_all();
 
-	/* setup VA is PA, at least up to PAGE_OFFSET */
-
-	pgtable = (HV_PTE *)current->mm->pgd;
+	/*
+	 * setup VA is PA, at least up to QUASI_VA_IS_PA_ADDR_RANGE.
+	 * Note here we assume that level-1 page table is defined by
+	 * HPAGE_SIZE.
+	 */
 	pte = hv_pte(_PAGE_KERNEL | _PAGE_HUGE_PAGE);
 	pte = hv_pte_set_mode(pte, HV_PTE_MODE_CACHE_NO_L3);
-
-	for (i = 0; i < pgd_index(PAGE_OFFSET); i++) {
+	for (i = 0; i < (QUASI_VA_IS_PA_ADDR_RANGE >> HPAGE_SHIFT); i++) {
+		unsigned long vaddr = i << HPAGE_SHIFT;
+		pgd_t *pgd = pgd_offset(current->mm, vaddr);
+		pud_t *pud = pud_offset(pgd, vaddr);
+		pte_t *ptep = (pte_t *) pmd_offset(pud, vaddr);
 		unsigned long pfn = i << (HPAGE_SHIFT - PAGE_SHIFT);
+
 		if (pfn_valid(pfn))
-			__set_pte(&pgtable[i], pfn_pte(pfn, pte));
+			__set_pte(ptep, pfn_pte(pfn, pte));
 	}
 }
 
diff --git a/arch/tile/kernel/relocate_kernel.S b/arch/tile/kernel/relocate_kernel.S
deleted file mode 100644
index 010b418..0000000
--- a/arch/tile/kernel/relocate_kernel.S
+++ /dev/null
@@ -1,280 +0,0 @@
-/*
- * Copyright 2010 Tilera Corporation. All Rights Reserved.
- *
- *   This program is free software; you can redistribute it and/or
- *   modify it under the terms of the GNU General Public License
- *   as published by the Free Software Foundation, version 2.
- *
- *   This program is distributed in the hope that it will be useful, but
- *   WITHOUT ANY WARRANTY; without even the implied warranty of
- *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
- *   NON INFRINGEMENT.  See the GNU General Public License for
- *   more details.
- *
- * copy new kernel into place and then call hv_reexec
- *
- */
-
-#include <linux/linkage.h>
-#include <arch/chip.h>
-#include <asm/page.h>
-#include <hv/hypervisor.h>
-
-#define ___hvb	MEM_SV_INTRPT + HV_GLUE_START_CPA
-
-#define ___hv_dispatch(f) (___hvb + (HV_DISPATCH_ENTRY_SIZE * f))
-
-#define ___hv_console_putc ___hv_dispatch(HV_DISPATCH_CONSOLE_PUTC)
-#define ___hv_halt         ___hv_dispatch(HV_DISPATCH_HALT)
-#define ___hv_reexec       ___hv_dispatch(HV_DISPATCH_REEXEC)
-#define ___hv_flush_remote ___hv_dispatch(HV_DISPATCH_FLUSH_REMOTE)
-
-#undef RELOCATE_NEW_KERNEL_VERBOSE
-
-STD_ENTRY(relocate_new_kernel)
-
-	move	r30, r0		/* page list */
-	move	r31, r1		/* address of page we are on */
-	move	r32, r2		/* start address of new kernel */
-
-	shri	r1, r1, PAGE_SHIFT
-	addi	r1, r1, 1
-	shli	sp, r1, PAGE_SHIFT
-	addi	sp, sp, -8
-	/* we now have a stack (whether we need one or not) */
-
-	moveli	r40, lo16(___hv_console_putc)
-	auli	r40, r40, ha16(___hv_console_putc)
-
-#ifdef RELOCATE_NEW_KERNEL_VERBOSE
-	moveli	r0, 'r'
-	jalr	r40
-
-	moveli	r0, '_'
-	jalr	r40
-
-	moveli	r0, 'n'
-	jalr	r40
-
-	moveli	r0, '_'
-	jalr	r40
-
-	moveli	r0, 'k'
-	jalr	r40
-
-	moveli	r0, '\n'
-	jalr	r40
-#endif
-
-	/*
-	 * Throughout this code r30 is pointer to the element of page
-	 * list we are working on.
-	 *
-	 * Normally we get to the next element of the page list by
-	 * incrementing r30 by four.  The exception is if the element
-	 * on the page list is an IND_INDIRECTION in which case we use
-	 * the element with the low bits masked off as the new value
-	 * of r30.
-	 *
-	 * To get this started, we need the value passed to us (which
-	 * will always be an IND_INDIRECTION) in memory somewhere with
-	 * r30 pointing at it.  To do that, we push the value passed
-	 * to us on the stack and make r30 point to it.
-	 */
-
-	sw	sp, r30
-	move	r30, sp
-	addi	sp, sp, -8
-
-#if CHIP_HAS_CBOX_HOME_MAP()
-	/*
-	 * On TILEPro, we need to flush all tiles' caches, since we may
-	 * have been doing hash-for-home caching there.  Note that we
-	 * must do this _after_ we're completely done modifying any memory
-	 * other than our output buffer (which we know is locally cached).
-	 * We want the caches to be fully clean when we do the reexec,
-	 * because the hypervisor is going to do this flush again at that
-	 * point, and we don't want that second flush to overwrite any memory.
-	 */
-	{
-	 move	r0, zero	 /* cache_pa */
-	 move	r1, zero
-	}
-	{
-	 auli	r2, zero, ha16(HV_FLUSH_EVICT_L2) /* cache_control */
-	 movei	r3, -1		 /* cache_cpumask; -1 means all client tiles */
-	}
-	{
-	 move	r4, zero	 /* tlb_va */
-	 move	r5, zero	 /* tlb_length */
-	}
-	{
-	 move	r6, zero	 /* tlb_pgsize */
-	 move	r7, zero	 /* tlb_cpumask */
-	}
-	{
-	 move	r8, zero	 /* asids */
-	 moveli	r20, lo16(___hv_flush_remote)
-	}
-	{
-	 move	r9, zero	 /* asidcount */
-	 auli	r20, r20, ha16(___hv_flush_remote)
-	}
-
-	jalr	r20
-#endif
-
-	/* r33 is destination pointer, default to zero */
-
-	moveli	r33, 0
-
-.Lloop:	lw	r10, r30
-
-	andi	r9, r10, 0xf	/* low 4 bits tell us what type it is */
-	xor	r10, r10, r9	/* r10 is now value with low 4 bits stripped */
-
-	seqi	r0, r9, 0x1	/* IND_DESTINATION */
-	bzt	r0, .Ltry2
-
-	move	r33, r10
-
-#ifdef RELOCATE_NEW_KERNEL_VERBOSE
-	moveli	r0, 'd'
-	jalr	r40
-#endif
-
-	addi	r30, r30, 4
-	j	.Lloop
-
-.Ltry2:
-	seqi	r0, r9, 0x2	/* IND_INDIRECTION */
-	bzt	r0, .Ltry4
-
-	move	r30, r10
-
-#ifdef RELOCATE_NEW_KERNEL_VERBOSE
-	moveli	r0, 'i'
-	jalr	r40
-#endif
-
-	j	.Lloop
-
-.Ltry4:
-	seqi	r0, r9, 0x4	/* IND_DONE */
-	bzt	r0, .Ltry8
-
-	mf
-
-#ifdef RELOCATE_NEW_KERNEL_VERBOSE
-	moveli	r0, 'D'
-	jalr	r40
-	moveli	r0, '\n'
-	jalr	r40
-#endif
-
-	move	r0, r32
-	moveli	r1, 0		/* arg to hv_reexec is 64 bits */
-
-	moveli	r41, lo16(___hv_reexec)
-	auli	r41, r41, ha16(___hv_reexec)
-
-	jalr	r41
-
-	/* we should not get here */
-
-	moveli	r0, '?'
-	jalr	r40
-	moveli	r0, '\n'
-	jalr	r40
-
-	j	.Lhalt
-
-.Ltry8:	seqi	r0, r9, 0x8	/* IND_SOURCE */
-	bz	r0, .Lerr	/* unknown type */
-
-	/* copy page at r10 to page at r33 */
-
-	move	r11, r33
-
-	moveli	r0, lo16(PAGE_SIZE)
-	auli	r0, r0, ha16(PAGE_SIZE)
-	add	r33, r33, r0
-
-	/* copy word at r10 to word at r11 until r11 equals r33 */
-
-	/* We know page size must be multiple of 16, so we can unroll
-	 * 16 times safely without any edge case checking.
-	 *
-	 * Issue a flush of the destination every 16 words to avoid
-	 * incoherence when starting the new kernel.  (Now this is
-	 * just good paranoia because the hv_reexec call will also
-	 * take care of this.)
-	 */
-
-1:
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0; addi	r11, r11, 4 }
-	{ lw	r0, r10; addi	r10, r10, 4 }
-	{ sw	r11, r0 }
-	{ flush r11    ; addi	r11, r11, 4 }
-
-	seq	r0, r33, r11
-	bzt	r0, 1b
-
-#ifdef RELOCATE_NEW_KERNEL_VERBOSE
-	moveli	r0, 's'
-	jalr	r40
-#endif
-
-	addi	r30, r30, 4
-	j	.Lloop
-
-
-.Lerr:	moveli	r0, 'e'
-	jalr	r40
-	moveli	r0, 'r'
-	jalr	r40
-	moveli	r0, 'r'
-	jalr	r40
-	moveli	r0, '\n'
-	jalr	r40
-.Lhalt:
-	moveli	r41, lo16(___hv_halt)
-	auli	r41, r41, ha16(___hv_halt)
-
-	jalr	r41
-	STD_ENDPROC(relocate_new_kernel)
-
-	.section .rodata,"a"
-
-	.globl relocate_new_kernel_size
-relocate_new_kernel_size:
-	.long .Lend_relocate_new_kernel - relocate_new_kernel
diff --git a/arch/tile/kernel/relocate_kernel_32.S b/arch/tile/kernel/relocate_kernel_32.S
new file mode 100644
index 0000000..010b418
--- /dev/null
+++ b/arch/tile/kernel/relocate_kernel_32.S
@@ -0,0 +1,280 @@
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * copy new kernel into place and then call hv_reexec
+ *
+ */
+
+#include <linux/linkage.h>
+#include <arch/chip.h>
+#include <asm/page.h>
+#include <hv/hypervisor.h>
+
+#define ___hvb	MEM_SV_INTRPT + HV_GLUE_START_CPA
+
+#define ___hv_dispatch(f) (___hvb + (HV_DISPATCH_ENTRY_SIZE * f))
+
+#define ___hv_console_putc ___hv_dispatch(HV_DISPATCH_CONSOLE_PUTC)
+#define ___hv_halt         ___hv_dispatch(HV_DISPATCH_HALT)
+#define ___hv_reexec       ___hv_dispatch(HV_DISPATCH_REEXEC)
+#define ___hv_flush_remote ___hv_dispatch(HV_DISPATCH_FLUSH_REMOTE)
+
+#undef RELOCATE_NEW_KERNEL_VERBOSE
+
+STD_ENTRY(relocate_new_kernel)
+
+	move	r30, r0		/* page list */
+	move	r31, r1		/* address of page we are on */
+	move	r32, r2		/* start address of new kernel */
+
+	shri	r1, r1, PAGE_SHIFT
+	addi	r1, r1, 1
+	shli	sp, r1, PAGE_SHIFT
+	addi	sp, sp, -8
+	/* we now have a stack (whether we need one or not) */
+
+	moveli	r40, lo16(___hv_console_putc)
+	auli	r40, r40, ha16(___hv_console_putc)
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'r'
+	jalr	r40
+
+	moveli	r0, '_'
+	jalr	r40
+
+	moveli	r0, 'n'
+	jalr	r40
+
+	moveli	r0, '_'
+	jalr	r40
+
+	moveli	r0, 'k'
+	jalr	r40
+
+	moveli	r0, '\n'
+	jalr	r40
+#endif
+
+	/*
+	 * Throughout this code r30 is pointer to the element of page
+	 * list we are working on.
+	 *
+	 * Normally we get to the next element of the page list by
+	 * incrementing r30 by four.  The exception is if the element
+	 * on the page list is an IND_INDIRECTION in which case we use
+	 * the element with the low bits masked off as the new value
+	 * of r30.
+	 *
+	 * To get this started, we need the value passed to us (which
+	 * will always be an IND_INDIRECTION) in memory somewhere with
+	 * r30 pointing at it.  To do that, we push the value passed
+	 * to us on the stack and make r30 point to it.
+	 */
+
+	sw	sp, r30
+	move	r30, sp
+	addi	sp, sp, -8
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	/*
+	 * On TILEPro, we need to flush all tiles' caches, since we may
+	 * have been doing hash-for-home caching there.  Note that we
+	 * must do this _after_ we're completely done modifying any memory
+	 * other than our output buffer (which we know is locally cached).
+	 * We want the caches to be fully clean when we do the reexec,
+	 * because the hypervisor is going to do this flush again at that
+	 * point, and we don't want that second flush to overwrite any memory.
+	 */
+	{
+	 move	r0, zero	 /* cache_pa */
+	 move	r1, zero
+	}
+	{
+	 auli	r2, zero, ha16(HV_FLUSH_EVICT_L2) /* cache_control */
+	 movei	r3, -1		 /* cache_cpumask; -1 means all client tiles */
+	}
+	{
+	 move	r4, zero	 /* tlb_va */
+	 move	r5, zero	 /* tlb_length */
+	}
+	{
+	 move	r6, zero	 /* tlb_pgsize */
+	 move	r7, zero	 /* tlb_cpumask */
+	}
+	{
+	 move	r8, zero	 /* asids */
+	 moveli	r20, lo16(___hv_flush_remote)
+	}
+	{
+	 move	r9, zero	 /* asidcount */
+	 auli	r20, r20, ha16(___hv_flush_remote)
+	}
+
+	jalr	r20
+#endif
+
+	/* r33 is destination pointer, default to zero */
+
+	moveli	r33, 0
+
+.Lloop:	lw	r10, r30
+
+	andi	r9, r10, 0xf	/* low 4 bits tell us what type it is */
+	xor	r10, r10, r9	/* r10 is now value with low 4 bits stripped */
+
+	seqi	r0, r9, 0x1	/* IND_DESTINATION */
+	bzt	r0, .Ltry2
+
+	move	r33, r10
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'd'
+	jalr	r40
+#endif
+
+	addi	r30, r30, 4
+	j	.Lloop
+
+.Ltry2:
+	seqi	r0, r9, 0x2	/* IND_INDIRECTION */
+	bzt	r0, .Ltry4
+
+	move	r30, r10
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'i'
+	jalr	r40
+#endif
+
+	j	.Lloop
+
+.Ltry4:
+	seqi	r0, r9, 0x4	/* IND_DONE */
+	bzt	r0, .Ltry8
+
+	mf
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'D'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+#endif
+
+	move	r0, r32
+	moveli	r1, 0		/* arg to hv_reexec is 64 bits */
+
+	moveli	r41, lo16(___hv_reexec)
+	auli	r41, r41, ha16(___hv_reexec)
+
+	jalr	r41
+
+	/* we should not get here */
+
+	moveli	r0, '?'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+
+	j	.Lhalt
+
+.Ltry8:	seqi	r0, r9, 0x8	/* IND_SOURCE */
+	bz	r0, .Lerr	/* unknown type */
+
+	/* copy page at r10 to page at r33 */
+
+	move	r11, r33
+
+	moveli	r0, lo16(PAGE_SIZE)
+	auli	r0, r0, ha16(PAGE_SIZE)
+	add	r33, r33, r0
+
+	/* copy word at r10 to word at r11 until r11 equals r33 */
+
+	/* We know page size must be multiple of 16, so we can unroll
+	 * 16 times safely without any edge case checking.
+	 *
+	 * Issue a flush of the destination every 16 words to avoid
+	 * incoherence when starting the new kernel.  (Now this is
+	 * just good paranoia because the hv_reexec call will also
+	 * take care of this.)
+	 */
+
+1:
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0; addi	r11, r11, 4 }
+	{ lw	r0, r10; addi	r10, r10, 4 }
+	{ sw	r11, r0 }
+	{ flush r11    ; addi	r11, r11, 4 }
+
+	seq	r0, r33, r11
+	bzt	r0, 1b
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 's'
+	jalr	r40
+#endif
+
+	addi	r30, r30, 4
+	j	.Lloop
+
+
+.Lerr:	moveli	r0, 'e'
+	jalr	r40
+	moveli	r0, 'r'
+	jalr	r40
+	moveli	r0, 'r'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+.Lhalt:
+	moveli	r41, lo16(___hv_halt)
+	auli	r41, r41, ha16(___hv_halt)
+
+	jalr	r41
+	STD_ENDPROC(relocate_new_kernel)
+
+	.section .rodata,"a"
+
+	.globl relocate_new_kernel_size
+relocate_new_kernel_size:
+	.long .Lend_relocate_new_kernel - relocate_new_kernel
diff --git a/arch/tile/kernel/relocate_kernel_64.S b/arch/tile/kernel/relocate_kernel_64.S
new file mode 100644
index 0000000..1c09a4f
--- /dev/null
+++ b/arch/tile/kernel/relocate_kernel_64.S
@@ -0,0 +1,260 @@
+/*
+ * Copyright 2011 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ *
+ * copy new kernel into place and then call hv_reexec
+ *
+ */
+
+#include <linux/linkage.h>
+#include <arch/chip.h>
+#include <asm/page.h>
+#include <hv/hypervisor.h>
+
+#undef RELOCATE_NEW_KERNEL_VERBOSE
+
+STD_ENTRY(relocate_new_kernel)
+
+	move	r30, r0		/* page list */
+	move	r31, r1		/* address of page we are on */
+	move	r32, r2		/* start address of new kernel */
+
+	shrui	r1, r1, PAGE_SHIFT
+	addi	r1, r1, 1
+	shli	sp, r1, PAGE_SHIFT
+	addi	sp, sp, -8
+	/* we now have a stack (whether we need one or not) */
+
+	moveli	r40, hw2_last(hv_console_putc)
+	shl16insli r40, r40, hw1(hv_console_putc)
+	shl16insli r40, r40, hw0(hv_console_putc)
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'r'
+	jalr	r40
+
+	moveli	r0, '_'
+	jalr	r40
+
+	moveli	r0, 'n'
+	jalr	r40
+
+	moveli	r0, '_'
+	jalr	r40
+
+	moveli	r0, 'k'
+	jalr	r40
+
+	moveli	r0, '\n'
+	jalr	r40
+#endif
+
+	/*
+	 * Throughout this code r30 is pointer to the element of page
+	 * list we are working on.
+	 *
+	 * Normally we get to the next element of the page list by
+	 * incrementing r30 by eight.  The exception is if the element
+	 * on the page list is an IND_INDIRECTION in which case we use
+	 * the element with the low bits masked off as the new value
+	 * of r30.
+	 *
+	 * To get this started, we need the value passed to us (which
+	 * will always be an IND_INDIRECTION) in memory somewhere with
+	 * r30 pointing at it.  To do that, we push the value passed
+	 * to us on the stack and make r30 point to it.
+	 */
+
+	st	sp, r30
+	move	r30, sp
+	addi	sp, sp, -16
+
+#if CHIP_HAS_CBOX_HOME_MAP()
+	/*
+	 * On TILE-GX, we need to flush all tiles' caches, since we may
+	 * have been doing hash-for-home caching there.  Note that we
+	 * must do this _after_ we're completely done modifying any memory
+	 * other than our output buffer (which we know is locally cached).
+	 * We want the caches to be fully clean when we do the reexec,
+	 * because the hypervisor is going to do this flush again at that
+	 * point, and we don't want that second flush to overwrite any memory.
+	 */
+	{
+	 move	r0, zero	 /* cache_pa */
+	 moveli	r1, hw2_last(HV_FLUSH_EVICT_L2)
+	}
+	{
+	 shl16insli	r1, r1, hw1(HV_FLUSH_EVICT_L2)
+	 movei	r2, -1		 /* cache_cpumask; -1 means all client tiles */
+	}
+	{
+	 shl16insli	r1, r1, hw0(HV_FLUSH_EVICT_L2)  /* cache_control */
+	 move	r3, zero	 /* tlb_va */
+	}
+	{
+	 move	r4, zero	 /* tlb_length */
+	 move	r5, zero	 /* tlb_pgsize */
+	}
+	{
+	 move	r6, zero	 /* tlb_cpumask */
+	 move	r7, zero	 /* asids */
+	}
+	{
+	 moveli	r20, hw2_last(hv_flush_remote)
+	 move	r8, zero	 /* asidcount */
+	}
+	shl16insli	r20, r20, hw1(hv_flush_remote)
+	shl16insli	r20, r20, hw0(hv_flush_remote)
+
+	jalr	r20
+#endif
+
+	/* r33 is destination pointer, default to zero */
+
+	moveli	r33, 0
+
+.Lloop:	ld	r10, r30
+
+	andi	r9, r10, 0xf	/* low 4 bits tell us what type it is */
+	xor	r10, r10, r9	/* r10 is now value with low 4 bits stripped */
+
+	cmpeqi	r0, r9, 0x1	/* IND_DESTINATION */
+	beqzt	r0, .Ltry2
+
+	move	r33, r10
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'd'
+	jalr	r40
+#endif
+
+	addi	r30, r30, 8
+	j	.Lloop
+
+.Ltry2:
+	cmpeqi	r0, r9, 0x2	/* IND_INDIRECTION */
+	beqzt	r0, .Ltry4
+
+	move	r30, r10
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'i'
+	jalr	r40
+#endif
+
+	j	.Lloop
+
+.Ltry4:
+	cmpeqi	r0, r9, 0x4	/* IND_DONE */
+	beqzt	r0, .Ltry8
+
+	mf
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 'D'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+#endif
+
+	move	r0, r32
+
+	moveli	r41, hw2_last(hv_reexec)
+	shl16insli	r41, r41, hw1(hv_reexec)
+	shl16insli	r41, r41, hw0(hv_reexec)
+
+	jalr	r41
+
+	/* we should not get here */
+
+	moveli	r0, '?'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+
+	j	.Lhalt
+
+.Ltry8:	cmpeqi	r0, r9, 0x8	/* IND_SOURCE */
+	beqz	r0, .Lerr	/* unknown type */
+
+	/* copy page at r10 to page at r33 */
+
+	move	r11, r33
+
+	moveli	r0, hw2_last(PAGE_SIZE)
+	shl16insli	r0, r0, hw1(PAGE_SIZE)
+	shl16insli	r0, r0, hw0(PAGE_SIZE)
+	add	r33, r33, r0
+
+	/* copy word at r10 to word at r11 until r11 equals r33 */
+
+	/* We know page size must be multiple of 8, so we can unroll
+	 * 8 times safely without any edge case checking.
+	 *
+	 * Issue a flush of the destination every 8 words to avoid
+	 * incoherence when starting the new kernel.  (Now this is
+	 * just good paranoia because the hv_reexec call will also
+	 * take care of this.)
+	 */
+
+1:
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0; addi	r11, r11, 8 }
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0; addi	r11, r11, 8 }
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0; addi	r11, r11, 8 }
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0; addi	r11, r11, 8 }
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0; addi	r11, r11, 8 }
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0; addi	r11, r11, 8 }
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0; addi	r11, r11, 8 }
+	{ ld	r0, r10; addi	r10, r10, 8 }
+	{ st	r11, r0 }
+	{ flush r11    ; addi	r11, r11, 8 }
+
+	cmpeq	r0, r33, r11
+	beqzt	r0, 1b
+
+#ifdef RELOCATE_NEW_KERNEL_VERBOSE
+	moveli	r0, 's'
+	jalr	r40
+#endif
+
+	addi	r30, r30, 8
+	j	.Lloop
+
+
+.Lerr:	moveli	r0, 'e'
+	jalr	r40
+	moveli	r0, 'r'
+	jalr	r40
+	moveli	r0, 'r'
+	jalr	r40
+	moveli	r0, '\n'
+	jalr	r40
+.Lhalt:
+	moveli r41, hw2_last(hv_halt)
+	shl16insli r41, r41, hw1(hv_halt)
+	shl16insli r41, r41, hw0(hv_halt)
+
+	jalr	r41
+	STD_ENDPROC(relocate_new_kernel)
+
+	.section .rodata,"a"
+
+	.globl relocate_new_kernel_size
+relocate_new_kernel_size:
+	.long .Lend_relocate_new_kernel - relocate_new_kernel
-- 
1.6.5.2

