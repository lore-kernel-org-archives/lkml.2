Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab2IKRmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:42:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45947 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab2IKRjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:39:48 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v3 14/17] ARM: LPAE: accomodate >32-bit addresses for page table base
Date: Tue, 11 Sep 2012 13:39:12 -0400
Message-ID: <1347385155-11643-15-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347385155-11643-1-git-send-email-cyril@ti.com>
References: <1347385155-11643-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch redefines the early boot time use of the R4 register to steal a few
low order bits (ARCH_PGD_SHIFT bits) on LPAE systems.  This allows for up to
38-bit physical addresses.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/memory.h |   15 +++++++++++++++
 arch/arm/kernel/head.S        |   10 ++++------
 arch/arm/kernel/smp.c         |   11 +++++++++--
 arch/arm/mm/proc-v7-3level.S  |    8 ++++++++
 4 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 73caaeb..edf540b 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/sizes.h>
 
+#include <asm/cache.h>
 #include <asm/runtime-patch.h>
 
 #ifdef CONFIG_NEED_MACH_MEMORY_H
@@ -143,6 +144,20 @@
 #define page_to_phys(page)	(__pfn_to_phys(page_to_pfn(page)))
 #define phys_to_page(phys)	(pfn_to_page(__phys_to_pfn(phys)))
 
+/*
+ * Minimum guaranted alignment in pgd_alloc().  The page table pointers passed
+ * around in head.S and proc-*.S are shifted by this amount, in order to
+ * leave spare high bits for systems with physical address extension.  This
+ * does not fully accomodate the 40-bit addressing capability of ARM LPAE, but
+ * gives us about 38-bits or so.
+ */
+#ifdef CONFIG_ARM_LPAE
+#define ARCH_PGD_SHIFT		L1_CACHE_SHIFT
+#else
+#define ARCH_PGD_SHIFT		0
+#endif
+#define ARCH_PGD_MASK		((1 << ARCH_PGD_SHIFT) - 1)
+
 #ifndef __ASSEMBLY__
 
 /*
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 61fb8df..9664db0 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -152,7 +152,7 @@ ENDPROC(stext)
  *
  * Returns:
  *  r0, r3, r5-r7 corrupted
- *  r4 = physical page table address
+ *  r4 = page table (see ARCH_PGD_SHIFT in asm/memory.h)
  */
 __create_page_tables:
 	pgtbl	r4, r8				@ page table address
@@ -306,6 +306,7 @@ __create_page_tables:
 #endif
 #ifdef CONFIG_ARM_LPAE
 	sub	r4, r4, #0x1000		@ point to the PGD table
+	mov	r4, r4, lsr #ARCH_PGD_SHIFT
 #endif
 	mov	pc, lr
 ENDPROC(__create_page_tables)
@@ -379,7 +380,7 @@ __secondary_data:
  *  r0  = cp#15 control register
  *  r1  = machine ID
  *  r2  = atags or dtb pointer
- *  r4  = page table pointer
+ *  r4  = page table (see ARCH_PGD_SHIFT in asm/memory.h)
  *  r9  = processor ID
  *  r13 = *virtual* address to jump to upon completion
  */
@@ -398,10 +399,7 @@ __enable_mmu:
 #ifdef CONFIG_CPU_ICACHE_DISABLE
 	bic	r0, r0, #CR_I
 #endif
-#ifdef CONFIG_ARM_LPAE
-	mov	r5, #0
-	mcrr	p15, 0, r4, r5, c2		@ load TTBR0
-#else
+#ifndef CONFIG_ARM_LPAE
 	mov	r5, #(domain_val(DOMAIN_USER, DOMAIN_MANAGER) | \
 		      domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \
 		      domain_val(DOMAIN_TABLE, DOMAIN_MANAGER) | \
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8e03567..349fdf3 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -61,6 +61,13 @@ enum ipi_msg_type {
 
 static DECLARE_COMPLETION(cpu_running);
 
+static unsigned long get_arch_pgd(pgd_t *pgd)
+{
+	phys_addr_t pgdir = virt_to_phys(pgd);
+	BUG_ON(pgdir & ARCH_PGD_MASK);
+	return pgdir >> ARCH_PGD_SHIFT;
+}
+
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
@@ -70,8 +77,8 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 	 * its stack and the page tables.
 	 */
 	secondary_data.stack = task_stack_page(idle) + THREAD_START_SP;
-	secondary_data.pgdir = virt_to_phys(idmap_pgd);
-	secondary_data.swapper_pg_dir = virt_to_phys(swapper_pg_dir);
+	secondary_data.pgdir = get_arch_pgd(idmap_pgd);
+	secondary_data.swapper_pg_dir = get_arch_pgd(swapper_pg_dir);
 	__cpuc_flush_dcache_area(&secondary_data, sizeof(secondary_data));
 	outer_clean_range(__pa(&secondary_data), __pa(&secondary_data + 1));
 
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 5d93f00..e920763 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -111,6 +111,7 @@ ENDPROC(cpu_v7_set_pte_ext)
 	 */
 	.macro	v7_ttb_setup, zero, ttbr0, ttbr1, tmp
 	ldr	\tmp, =swapper_pg_dir		@ swapper_pg_dir virtual address
+	mov	\tmp, \tmp, lsr #ARCH_PGD_SHIFT
 	cmp	\ttbr1, \tmp			@ PHYS_OFFSET > PAGE_OFFSET? (branch below)
 	mrc	p15, 0, \tmp, c2, c0, 2		@ TTB control register
 	orr	\tmp, \tmp, #TTB_EAE
@@ -130,8 +131,15 @@ ENDPROC(cpu_v7_set_pte_ext)
 	 */
 	orrls	\tmp, \tmp, #TTBR1_SIZE				@ TTBCR.T1SZ
 	mcr	p15, 0, \tmp, c2, c0, 2				@ TTBCR
+	mov	\tmp, \ttbr1, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
+	mov	\ttbr1, \ttbr1, lsl #ARCH_PGD_SHIFT		@ lower bits
 	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
 	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
+	mov	\tmp, \ttbr0, lsr #(32 - ARCH_PGD_SHIFT)	@ upper bits
+	mov	\ttbr0, \ttbr0, lsl #ARCH_PGD_SHIFT		@ lower bits
+	mcrr	p15, 0, \ttbr0, \zero, c2			@ load TTBR0
+	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
+	mcrr	p15, 0, \ttbr0, \zero, c2			@ load TTBR0
 	.endm
 
 	__CPUINIT
-- 
1.7.9.5

