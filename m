Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1HJPEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:04:13 -0400
Received: from service87.mimecast.com ([94.185.240.25]:42061 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753356Ab1HJPEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:04:10 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v7 12/16] ARM: LPAE: Add context switching support
Date: Wed, 10 Aug 2011 16:03:35 +0100
Message-Id: <1312988619-16804-13-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 10 Aug 2011 15:03:54.0413 (UTC) FILETIME=[B8BA2DD0:01CC576E]
X-MC-Unique: 111081016040702901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p7AF5IW5003934

With LPAE, TTBRx registers are 64-bit. The ASID is stored in TTBR0
rather than a separate Context ID register. This patch makes the
necessary changes to handle context switching on LPAE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/context.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

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
 

