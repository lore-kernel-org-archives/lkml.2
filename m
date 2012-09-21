Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2IUP7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:59:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60341 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab2IUP51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:27 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <davidb@codeaurora.org>,
        <frank.rowand@am.sony.com>, <hsweeten@visionengravers.com>,
        <linus.walleij@linaro.org>, <marc.zyngier@arm.com>, <nico@linaro.org>,
        <paul.gortmaker@windriver.com>, <plagnioj@jcrosoft.com>,
        <rabin@rab.in>, <rmallon@gmail.com>, <rob.herring@calxeda.com>,
        <sboyd@codeaurora.org>, <sjg@chromium.org>, <tglx@linutronix.de>,
        <tj@kernel.org>, <vincent.guittot@linaro.org>, <vitalya@ti.com>,
        <will.deacon@arm.com>, <grant.likely@secretlab.ca>,
        Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v3 RESEND 10/17] ARM: LPAE: use phys_addr_t in switch_mm()
Date: Fri, 21 Sep 2012 11:56:08 -0400
Message-ID: <1348242975-19184-11-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348242975-19184-1-git-send-email-cyril@ti.com>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
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
 arch/arm/mm/proc-v7-3level.S    |   17 +++++++++++++----
 2 files changed, 15 insertions(+), 6 deletions(-)

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
index 8de0f1d..c4f4251 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -39,6 +39,14 @@
 #define TTB_FLAGS_SMP	(TTB_IRGN_WBWA|TTB_S|TTB_RGN_OC_WBWA)
 #define PMD_FLAGS_SMP	(PMD_SECT_WBWA|PMD_SECT_S)
 
+#ifndef __ARMEB__
+#  define rpgdl	r0
+#  define rpgdh	r1
+#else
+#  define rpgdl	r1
+#  define rpgdh	r0
+#endif
+
 /*
  * cpu_v7_switch_mm(pgd_phys, tsk)
  *
@@ -47,10 +55,11 @@
  */
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
-	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
-	and	r3, r1, #0xff
-	mov	r3, r3, lsl #(48 - 32)		@ ASID
-	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
+	ldr	r2, [r2, #MM_CONTEXT_ID]	@ get mm->context.id
+	and	r2, r2, #0xff
+	mov	r2, r2, lsl #(48 - 32)		@ ASID
+	orr	rpgdh, rpgdh, r2		@ upper 32-bits of pgd phys
+	mcrr	p15, 0, rpgdl, rpgdh, c2	@ set TTB 0
 	isb
 #endif
 	mov	pc, lr
-- 
1.7.9.5

