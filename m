Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab2HKB0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:26:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60277 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767Ab2HKBZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:25:59 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <grant.likely@secretlab.ca>,
        <nico@linaro.org>, <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH v2 10/22] ARM: LPAE: use phys_addr_t in switch_mm()
Date: Fri, 10 Aug 2012 21:24:53 -0400
Message-ID: <1344648306-15619-11-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344648306-15619-1-git-send-email-cyril@ti.com>
References: <1344648306-15619-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the switch_mm() processor functions to use phys_addr_t.
On LPAE systems, we now honor the upper 32-bits of the physical address that
is being passed in, and program these into TTBR as expected.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/proc-fns.h |    4 ++--
 arch/arm/mm/proc-v7-3level.S    |   26 ++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index f3628fb..75b5f14 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -60,7 +60,7 @@ extern struct processor {
 	/*
 	 * Set the page table
 	 */
-	void (*switch_mm)(unsigned long pgd_phys, struct mm_struct *mm);
+	void (*switch_mm)(phys_addr_t pgd_phys, struct mm_struct *mm);
 	/*
 	 * Set a possibly extended PTE.  Non-extended PTEs should
 	 * ignore 'ext'.
@@ -82,7 +82,7 @@ extern void cpu_proc_init(void);
 extern void cpu_proc_fin(void);
 extern int cpu_do_idle(void);
 extern void cpu_dcache_clean_area(void *, int);
-extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+extern void cpu_do_switch_mm(phys_addr_t pgd_phys, struct mm_struct *mm);
 #ifdef CONFIG_ARM_LPAE
 extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
 #else
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 8de0f1d..78bd88c 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -39,6 +39,22 @@
 #define TTB_FLAGS_SMP	(TTB_IRGN_WBWA|TTB_S|TTB_RGN_OC_WBWA)
 #define PMD_FLAGS_SMP	(PMD_SECT_WBWA|PMD_SECT_S)
 
+#define rzero	r3
+#ifndef CONFIG_ARM_LPAE
+#  define rpgdl	r0
+#  define rpgdh	rzero
+#  define rmm	r1
+#else
+#  define rmm	r2
+#ifndef __ARMEB__
+#  define rpgdl	r0
+#  define rpgdh	r1
+#else
+#  define rpgdl	r1
+#  define rpgdh	r0
+#endif
+#endif
+
 /*
  * cpu_v7_switch_mm(pgd_phys, tsk)
  *
@@ -47,10 +63,12 @@
  */
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
-	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
-	and	r3, r1, #0xff
-	mov	r3, r3, lsl #(48 - 32)		@ ASID
-	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
+	mov	rzero, #0
+	ldr	rmm, [rmm, #MM_CONTEXT_ID]	@ get mm->context.id
+	and	rmm, rmm, #0xff
+	mov	rmm, rmm, lsl #(48 - 32)	@ ASID
+	orr	rpgdh, rpgdh, rmm		@ upper 32-bits of pgd phys
+	mcrr	p15, 0, rpgdl, rpgdh, c2	@ set TTB 0
 	isb
 #endif
 	mov	pc, lr
-- 
1.7.9.5

