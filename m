Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2GaXFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:05:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32837 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970Ab2GaXFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:05:33 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH 09/22] ARM: LPAE: use 64-bit pgd physical address in switch_mm()
Date: Tue, 31 Jul 2012 19:04:45 -0400
Message-ID: <1343775898-28345-10-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343775898-28345-1-git-send-email-cyril@ti.com>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the switch_mm() processor functions to use 64-bit
addresses.  We use u64 instead of phys_addr_t, in order to avoid having config
dependent register usage when calling into switch_mm assembly code.

The changes in this patch are primarily adjustments for registers used for
arguments to switch_mm.  The few processor definitions that did use the second
argument have been modified accordingly.

Arguments and calling conventions aside, this patch should be a no-op on v6
and non-LPAE v7 processors.  On LPAE systems, we now honor the upper 32-bits
of the physical address that is being passed in.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/proc-fns.h |    4 ++--
 arch/arm/mm/proc-v6.S           |    2 +-
 arch/arm/mm/proc-v7-2level.S    |    2 +-
 arch/arm/mm/proc-v7-3level.S    |    5 +++--
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index f3628fb..fa6554e 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -60,7 +60,7 @@ extern struct processor {
 	/*
 	 * Set the page table
 	 */
-	void (*switch_mm)(unsigned long pgd_phys, struct mm_struct *mm);
+	void (*switch_mm)(u64 pgd_phys, struct mm_struct *mm);
 	/*
 	 * Set a possibly extended PTE.  Non-extended PTEs should
 	 * ignore 'ext'.
@@ -82,7 +82,7 @@ extern void cpu_proc_init(void);
 extern void cpu_proc_fin(void);
 extern int cpu_do_idle(void);
 extern void cpu_dcache_clean_area(void *, int);
-extern void cpu_do_switch_mm(unsigned long pgd_phys, struct mm_struct *mm);
+extern void cpu_do_switch_mm(u64 pgd_phys, struct mm_struct *mm);
 #ifdef CONFIG_ARM_LPAE
 extern void cpu_set_pte_ext(pte_t *ptep, pte_t pte);
 #else
diff --git a/arch/arm/mm/proc-v6.S b/arch/arm/mm/proc-v6.S
index 5900cd5..566c658 100644
--- a/arch/arm/mm/proc-v6.S
+++ b/arch/arm/mm/proc-v6.S
@@ -100,8 +100,8 @@ ENTRY(cpu_v6_dcache_clean_area)
  */
 ENTRY(cpu_v6_switch_mm)
 #ifdef CONFIG_MMU
+	ldr	r1, [r2, #MM_CONTEXT_ID]	@ get mm->context.id
 	mov	r2, #0
-	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
 	ALT_SMP(orr	r0, r0, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r0, r0, #TTB_FLAGS_UP)
 	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index 42ac069..3397803 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -39,8 +39,8 @@
  */
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
+	ldr	r1, [r2, #MM_CONTEXT_ID]	@ get mm->context.id
 	mov	r2, #0
-	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
 	ALT_SMP(orr	r0, r0, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r0, r0, #TTB_FLAGS_UP)
 #ifdef CONFIG_ARM_ERRATA_430973
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index 8de0f1d..0001581 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -47,9 +47,10 @@
  */
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
-	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
-	and	r3, r1, #0xff
+	ldr	r2, [r2, #MM_CONTEXT_ID]	@ get mm->context.id
+	and	r3, r2, #0xff
 	mov	r3, r3, lsl #(48 - 32)		@ ASID
+	orr	r3, r3, r1			@ upper 32-bits of pgd phys
 	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
 	isb
 #endif
-- 
1.7.9.5

