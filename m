Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab0KLSBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:01:10 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50915 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932311Ab0KLSBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:01:08 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/20] ARM: LPAE: Add context switching support
Date: Fri, 12 Nov 2010 18:00:32 +0000
Message-Id: <1289584840-18097-13-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.3.2.164.g6f10c
In-Reply-To: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 12 Nov 2010 18:00:52.0032 (UTC) FILETIME=[8B600400:01CB8293]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With LPAE, TTBRx registers are 64-bit. The ASID is stored in TTBR0
rather than a separate Context ID register. This patch makes the
necessary changes to handle context switching on LPAE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/context.c |   18 ++++++++++++++++--
 arch/arm/mm/proc-v7.S |    8 +++++++-
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index b0ee9ba..d40d3fa 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -22,6 +22,20 @@ unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 DEFINE_PER_CPU(struct mm_struct *, current_mm);
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+#define cpu_set_asid(asid) {						\
+	unsigned long ttbl, ttbh;					\
+	asm("	mrrc	p15, 0, %0, %1, c2		@ read TTBR0\n"	\
+	    "	mov	%1, %1, lsl #(48 - 32)		@ set ASID\n"	\
+	    "	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"	\
+	    : "=r" (ttbl), "=r" (ttbh)					\
+	    : "r" (asid & ~ASID_MASK));					\
+}
+#else
+#define cpu_set_asid(asid) \
+	asm("	mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (asid))
+#endif
+
 /*
  * We fork()ed a process, and we need a new context for the child
  * to run in.  We reserve version 0 for initial tasks so we will
@@ -37,7 +51,7 @@ void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 static void flush_context(void)
 {
 	/* set the reserved ASID before flushing the TLB */
-	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (0));
+	cpu_set_asid(0);
 	isb();
 	local_flush_tlb_all();
 	if (icache_is_vivt_asid_tagged()) {
@@ -99,7 +113,7 @@ static void reset_context(void *info)
 	set_mm_context(mm, asid);
 
 	/* set the new ASID */
-	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (mm->context.id));
+	cpu_set_asid(mm->context.id);
 	isb();
 }
 
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 33a8c82..b0932c1 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -117,6 +117,11 @@ ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
 	mov	r2, #0
 	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
+#ifdef CONFIG_ARM_LPAE
+	and	r3, r1, #0xff
+	mov	r3, r3, lsl #(48 - 32)		@ ASID
+	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
+#else	/* !CONFIG_ARM_LPAE */
 	ALT_SMP(orr	r0, r0, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r0, r0, #TTB_FLAGS_UP)
 #ifdef CONFIG_ARM_ERRATA_430973
@@ -124,9 +129,10 @@ ENTRY(cpu_v7_switch_mm)
 #endif
 	mcr	p15, 0, r2, c13, c0, 1		@ set reserved context ID
 	isb
-1:	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
+	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
 	isb
 	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
+#endif	/* CONFIG_ARM_LPAE */
 	isb
 #endif
 	mov	pc, lr
