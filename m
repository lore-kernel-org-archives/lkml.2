Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab1K2MWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:22:54 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52253 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1K2MWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:22:45 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [RFC PATCH 2/6] ARM: Use TTBR1 instead of reserved context ID
Date: Tue, 29 Nov 2011 12:22:28 +0000
Message-Id: <1322569352-23584-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
References: <1322569352-23584-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 29 Nov 2011 12:22:38.0941 (UTC) FILETIME=[958C90D0:01CCAE91]
X-MC-Unique: 111112912224200401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pATCNBho007574

From: Will Deacon <will.deacon@arm.com>

On ARMv7 CPUs that cache first level page table entries (like the
Cortex-A15), using a reserved ASID while changing the TTBR or flushing
the TLB is unsafe.

This is because the CPU may cache the first level entry as the result of
a speculative memory access while the reserved ASID is assigned. After
the process owning the page tables dies, the memory will be reallocated
and may be written with junk values which can be interpreted as global,
valid PTEs by the processor. This will result in the TLB being populated
with bogus global entries.

This patch avoids the use of a reserved context ID in the v7 switch_mm
and ASID rollover code by temporarily using the swapper_pg_dir pointed
at by TTBR1, which contains only global entries that are not tagged
with ASIDs.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/mm/context.c |   22 ++++++++++++++--------
 arch/arm/mm/proc-v7.S |   10 ++++------
 2 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index 93aac06..a062230 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -22,11 +22,20 @@ unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 DEFINE_PER_CPU(struct mm_struct *, current_mm);
 #endif
 
+static void cpu_set_reserved_ttbr0(void)
+{
+	u32 ttb;
+	/* Copy TTBR1 into TTBR0 */
+	asm volatile(
+	"	mrc	p15, 0, %0, c2, c0, 1		@ read TTBR1\n"
+	"	mcr	p15, 0, %0, c2, c0, 0		@ set TTBR0\n"
+	: "=r" (ttb));
+	isb();
+}
+
 /*
  * We fork()ed a process, and we need a new context for the child
- * to run in.  We reserve version 0 for initial tasks so we will
- * always allocate an ASID. The ASID 0 is reserved for the TTBR
- * register changing sequence.
+ * to run in.
  */
 void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
@@ -36,9 +45,7 @@ void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 static void flush_context(void)
 {
-	/* set the reserved ASID before flushing the TLB */
-	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (0));
-	isb();
+	cpu_set_reserved_ttbr0();
 	local_flush_tlb_all();
 	if (icache_is_vivt_asid_tagged()) {
 		__flush_icache_all();
@@ -99,8 +106,7 @@ static void reset_context(void *info)
 	set_mm_context(mm, asid);
 
 	/* set the new ASID */
-	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (mm->context.id));
-	isb();
+	cpu_switch_mm(mm->pgd, mm);
 }
 
 #else
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 2c559ac..2faff3b 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -116,18 +116,16 @@ ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_ARM_ERRATA_430973
 	mcr	p15, 0, r2, c7, c5, 6		@ flush BTAC/BTB
 #endif
-#ifdef CONFIG_ARM_ERRATA_754322
-	dsb
-#endif
-	mcr	p15, 0, r2, c13, c0, 1		@ set reserved context ID
-	isb
-1:	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
+	mrc	p15, 0, r2, c2, c0, 1		@ load TTB 1
+	mcr	p15, 0, r2, c2, c0, 0		@ into TTB 0
 	isb
 #ifdef CONFIG_ARM_ERRATA_754322
 	dsb
 #endif
 	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
 	isb
+	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
+	isb
 #endif
 	mov	pc, lr
 ENDPROC(cpu_v7_switch_mm)

