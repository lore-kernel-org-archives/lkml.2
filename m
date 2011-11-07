Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936Ab1KGQS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:18:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50079 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab1KGQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:17:25 -0500
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 12/16] ARM: LPAE: Add context switching support
Date: Mon,  7 Nov 2011 16:16:54 +0000
Message-Id: <1320682618-1182-13-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
References: <1320682618-1182-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 07 Nov 2011 16:17:13.0263 (UTC) FILETIME=[B5692BF0:01CC9D68]
X-MC-Unique: 111110716172302101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pA7GJF4s015300

With LPAE, TTBRx registers are 64-bit. The ASID is stored in TTBR0
rather than a separate Context ID register. This patch makes the
necessary changes to handle context switching on LPAE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/context.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index 93aac06..ee9bb36 100644
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
 

