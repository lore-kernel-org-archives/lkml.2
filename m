Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab1CQSxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 14:53:02 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:51717 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab1CQSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 14:53:01 -0400
X-Greylist: delayed 925 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Mar 2011 14:53:00 EDT
Message-Id: <201103171837.p2HIbHx6007482@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 17 Mar 2011 14:32:06 -0400
Subject: [PATCH] arch/tile: support newer binutils assembler shift semantics
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
X-OriginalArrivalTime: 17 Mar 2011 18:37:23.0999 (UTC) FILETIME=[5B8662F0:01CBE4D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change supports building the kernel with newer binutils where
a shift of greater than the word size is no longer interpreted
silently as modulo the word size, but instead generates a warning.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/arch/interrupts_32.h |    9 ++++++---
 arch/tile/include/asm/irqflags.h       |   18 ++++++++++++++++--
 arch/tile/kernel/head_32.S             |   11 +++++++----
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/tile/include/arch/interrupts_32.h b/arch/tile/include/arch/interrupts_32.h
index 9d0bfa7..96b5710 100644
--- a/arch/tile/include/arch/interrupts_32.h
+++ b/arch/tile/include/arch/interrupts_32.h
@@ -16,10 +16,11 @@
 #define __ARCH_INTERRUPTS_H__
 
 /** Mask for an interrupt. */
-#ifdef __ASSEMBLER__
 /* Note: must handle breaking interrupts into high and low words manually. */
-#define INT_MASK(intno) (1 << (intno))
-#else
+#define INT_MASK_LO(intno) (1 << (intno))
+#define INT_MASK_HI(intno) (1 << ((intno) - 32))
+
+#ifndef __ASSEMBLER__
 #define INT_MASK(intno) (1ULL << (intno))
 #endif
 
@@ -89,6 +90,7 @@
 
 #define NUM_INTERRUPTS 49
 
+#ifndef __ASSEMBLER__
 #define QUEUED_INTERRUPTS ( \
     INT_MASK(INT_MEM_ERROR) | \
     INT_MASK(INT_DMATLB_MISS) | \
@@ -301,4 +303,5 @@
     INT_MASK(INT_DOUBLE_FAULT) | \
     INT_MASK(INT_AUX_PERF_COUNT) | \
     0)
+#endif /* !__ASSEMBLER__ */
 #endif /* !__ARCH_INTERRUPTS_H__ */
diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index 641e4ff..5db0ce5 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -18,6 +18,8 @@
 #include <arch/interrupts.h>
 #include <arch/chip.h>
 
+#if !defined(__tilegx__) && defined(__ASSEMBLY__)
+
 /*
  * The set of interrupts we want to allow when interrupts are nominally
  * disabled.  The remainder are effectively "NMI" interrupts from
@@ -25,6 +27,16 @@
  * interrupts (aka "non-queued") are not blocked by the mask in any case.
  */
 #if CHIP_HAS_AUX_PERF_COUNTERS()
+#define LINUX_MASKABLE_INTERRUPTS_HI \
+       (~(INT_MASK_HI(INT_PERF_COUNT) | INT_MASK_HI(INT_AUX_PERF_COUNT)))
+#else
+#define LINUX_MASKABLE_INTERRUPTS_HI \
+       (~(INT_MASK_HI(INT_PERF_COUNT)))
+#endif
+
+#else
+
+#if CHIP_HAS_AUX_PERF_COUNTERS()
 #define LINUX_MASKABLE_INTERRUPTS \
 	(~(INT_MASK(INT_PERF_COUNT) | INT_MASK(INT_AUX_PERF_COUNT)))
 #else
@@ -32,6 +44,8 @@
 	(~(INT_MASK(INT_PERF_COUNT)))
 #endif
 
+#endif
+
 #ifndef __ASSEMBLY__
 
 /* NOTE: we can't include <linux/percpu.h> due to #include dependencies. */
@@ -224,11 +238,11 @@ DECLARE_PER_CPU(unsigned long long, interrupts_enabled_mask);
 #define IRQ_DISABLE(tmp0, tmp1)					\
 	{							\
 	 movei  tmp0, -1;					\
-	 moveli tmp1, lo16(LINUX_MASKABLE_INTERRUPTS)		\
+	 moveli tmp1, lo16(LINUX_MASKABLE_INTERRUPTS_HI)	\
 	};							\
 	{							\
 	 mtspr  SPR_INTERRUPT_MASK_SET_K_0, tmp0;		\
-	 auli   tmp1, tmp1, ha16(LINUX_MASKABLE_INTERRUPTS)	\
+	 auli   tmp1, tmp1, ha16(LINUX_MASKABLE_INTERRUPTS_HI)	\
 	};							\
 	mtspr   SPR_INTERRUPT_MASK_SET_K_1, tmp1
 
diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
index 05b5f4d..1a39b7c 100644
--- a/arch/tile/kernel/head_32.S
+++ b/arch/tile/kernel/head_32.S
@@ -145,7 +145,7 @@ ENTRY(empty_zero_page)
 	.endif
 	.word HV_PTE_PAGE | HV_PTE_DIRTY | HV_PTE_PRESENT | HV_PTE_ACCESSED | \
 	      (HV_PTE_MODE_CACHE_NO_L3 << HV_PTE_INDEX_MODE)
-	.word (\bits1) | (HV_CPA_TO_PFN(\cpa) << HV_PTE_INDEX_PFN)
+	.word (\bits1) | (HV_CPA_TO_PFN(\cpa) << (HV_PTE_INDEX_PFN - 32))
 	.endm
 
 __PAGE_ALIGNED_DATA
@@ -158,12 +158,14 @@ ENTRY(swapper_pg_dir)
 	 */
 	.set addr, 0
 	.rept (MEM_USER_INTRPT - PAGE_OFFSET) >> PGDIR_SHIFT
-	PTE addr + PAGE_OFFSET, addr, HV_PTE_READABLE | HV_PTE_WRITABLE
+	PTE addr + PAGE_OFFSET, addr, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
+				      (1 << (HV_PTE_INDEX_WRITABLE - 32))
 	.set addr, addr + PGDIR_SIZE
 	.endr
 
 	/* The true text VAs are mapped as VA = PA + MEM_SV_INTRPT */
-	PTE MEM_SV_INTRPT, 0, HV_PTE_READABLE | HV_PTE_EXECUTABLE
+	PTE MEM_SV_INTRPT, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
+			      (1 << (HV_PTE_INDEX_EXECUTABLE - 32))
 	.org swapper_pg_dir + HV_L1_SIZE
 	END(swapper_pg_dir)
 
@@ -176,6 +178,7 @@ ENTRY(swapper_pg_dir)
 	__INITDATA
 	.align CHIP_L2_LINE_SIZE()
 ENTRY(swapper_pgprot)
-	PTE	0, 0, HV_PTE_READABLE | HV_PTE_WRITABLE, 1
+	PTE	0, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
+		      (1 << (HV_PTE_INDEX_WRITABLE - 32)), 1
 	.align CHIP_L2_LINE_SIZE()
 	END(swapper_pgprot)
-- 
1.6.5.2

