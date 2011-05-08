Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1EHMxr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 08:53:47 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42935 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753623Ab1EHMwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 08:52:03 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v5 13/19] ARM: LPAE: Add context switching support
Date: Sun,  8 May 2011 13:51:32 +0100
Message-Id: <1304859098-10760-14-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
References: <1304859098-10760-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 08 May 2011 12:51:52.0335 (UTC) FILETIME=[B3F881F0:01CC0D7E]
X-MC-Unique: 111050813520101101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p48CsAXo020083

With LPAE, TTBRx registers are 64-bit. The ASID is stored in TTBR0
rather than a separate Context ID register. This patch makes the
necessary changes to handle context switching on LPAE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/context.c |   19 +++++++++++++++++--
 arch/arm/mm/proc-v7.S |   10 ++++++++--
 2 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index b0ee9ba..fcdb101 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -22,6 +22,21 @@ unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 DEFINE_PER_CPU(struct mm_struct *, current_mm);
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+#define cpu_set_asid(asid) {						\
+	unsigned long ttbl, ttbh;					\
+	asm volatile(							\
+	"	mrrc	p15, 0, %0, %1, c2		@ read TTBR0\n"	\
+	"	mov	%1, %2, lsl #(48 - 32)		@ set ASID\n"	\
+	"	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"	\
+	: "=&r" (ttbl), "=&r" (ttbh)					\
+	: "r" (asid & ~ASID_MASK));					\
+}
+#else
+#define cpu_set_asid(asid) \
+	asm("	mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (asid))
+#endif
+
 /*
  * We fork()ed a process, and we need a new context for the child
  * to run in.  We reserve version 0 for initial tasks so we will
@@ -37,7 +52,7 @@ void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 static void flush_context(void)
 {
 	/* set the reserved ASID before flushing the TLB */
-	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (0));
+	cpu_set_asid(0);
 	isb();
 	local_flush_tlb_all();
 	if (icache_is_vivt_asid_tagged()) {
@@ -99,7 +114,7 @@ static void reset_context(void *info)
 	set_mm_context(mm, asid);
 
 	/* set the new ASID */
-	asm("mcr	p15, 0, %0, c13, c0, 1\n" : : "r" (mm->context.id));
+	cpu_set_asid(mm->context.id);
 	isb();
 }
 
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index 0996713..ad22628 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -115,8 +115,13 @@ ENDPROC(cpu_v7_dcache_clean_area)
  */
 ENTRY(cpu_v7_switch_mm)
 #ifdef CONFIG_MMU
-	mov	r2, #0
 	ldr	r1, [r1, #MM_CONTEXT_ID]	@ get mm->context.id
+	mov	r2, #0
+#ifdef CONFIG_ARM_LPAE
+	and	r3, r1, #0xff
+	mov	r3, r3, lsl #(48 - 32)		@ ASID
+	mcrr	p15, 0, r0, r3, c2		@ set TTB 0
+#else	/* !CONFIG_ARM_LPAE */
 	ALT_SMP(orr	r0, r0, #TTB_FLAGS_SMP)
 	ALT_UP(orr	r0, r0, #TTB_FLAGS_UP)
 #ifdef CONFIG_ARM_ERRATA_430973
@@ -127,12 +132,13 @@ ENTRY(cpu_v7_switch_mm)
 #endif
 	mcr	p15, 0, r2, c13, c0, 1		@ set reserved context ID
 	isb
-1:	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
+	mcr	p15, 0, r0, c2, c0, 0		@ set TTB 0
 	isb
 #ifdef CONFIG_ARM_ERRATA_754322
 	dsb
 #endif
 	mcr	p15, 0, r1, c13, c0, 1		@ set context ID
+#endif	/* CONFIG_ARM_LPAE */
 	isb
 #endif
 	mov	pc, lr

