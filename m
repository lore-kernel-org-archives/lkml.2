Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2ATRnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 12:43:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56842 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab2ATRmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 12:42:45 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will.deacon@arm.com>, Russell King <linux@arm.linux.org.uk>,
        Frank Rowand <frank.rowand@am.sony.com>
Subject: [PATCH v3 2/6] ARM: Use TTBR1 instead of reserved context ID
Date: Fri, 20 Jan 2012 17:42:28 +0000
Message-Id: <1327081352-13178-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.rc1.3.gb6310
In-Reply-To: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
References: <1327081352-13178-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 20 Jan 2012 17:42:38.0193 (UTC) FILETIME=[E6ACEE10:01CCD79A]
X-MC-Unique: 112012017424207201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q0KHhxUN006988

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

Reviewed-by: Frank Rowand <frank.rowand@am.sony.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/context.c        |   45 +++++++++++++++++++++++++----------------
 arch/arm/mm/proc-v7-2level.S |   10 +++-----
 2 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index ee9bb36..97842a0 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -23,25 +23,37 @@ DEFINE_PER_CPU(struct mm_struct *, current_mm);
 #endif
 
 #ifdef CONFIG_ARM_LPAE
-#define cpu_set_asid(asid) {						\
-	unsigned long ttbl, ttbh;					\
-	asm volatile(							\
-	"	mrrc	p15, 0, %0, %1, c2		@ read TTBR0\n"	\
-	"	mov	%1, %2, lsl #(48 - 32)		@ set ASID\n"	\
-	"	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"	\
-	: "=&r" (ttbl), "=&r" (ttbh)					\
-	: "r" (asid & ~ASID_MASK));					\
+static void cpu_set_reserved_ttbr0(void)
+{
+	unsigned long ttbl = __pa(swapper_pg_dir);
+	unsigned long ttbh = 0;
+
+	/*
+	 * Set TTBR0 to swapper_pg_dir. Note that swapper_pg_dir only contains
+	 * global entries so the ASID value is not relevant.
+	 */
+	asm volatile(
+	"	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"
+	:
+	: "r" (ttbl), "r" (ttbh));
+	isb();
 }
 #else
-#define cpu_set_asid(asid) \
-	asm("	mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (asid))
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
 #endif
 
 /*
  * We fork()ed a process, and we need a new context for the child
- * to run in.  We reserve version 0 for initial tasks so we will
- * always allocate an ASID. The ASID 0 is reserved for the TTBR
- * register changing sequence.
+ * to run in.
  */
 void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 {
@@ -51,9 +63,7 @@ void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 static void flush_context(void)
 {
-	/* set the reserved ASID before flushing the TLB */
-	cpu_set_asid(0);
-	isb();
+	cpu_set_reserved_ttbr0();
 	local_flush_tlb_all();
 	if (icache_is_vivt_asid_tagged()) {
 		__flush_icache_all();
@@ -114,8 +124,7 @@ static void reset_context(void *info)
 	set_mm_context(mm, asid);
 
 	/* set the new ASID */
-	cpu_set_asid(mm->context.id);
-	isb();
+	cpu_switch_mm(mm->pgd, mm);
 }
 
 #else
diff --git a/arch/arm/mm/proc-v7-2level.S b/arch/arm/mm/proc-v7-2level.S
index 3a4b3e7..7227048 100644
--- a/arch/arm/mm/proc-v7-2level.S
+++ b/arch/arm/mm/proc-v7-2level.S
@@ -46,18 +46,16 @@ ENTRY(cpu_v7_switch_mm)
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

