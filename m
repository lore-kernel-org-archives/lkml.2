Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648Ab1EXVlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:41:19 -0400
Received: from service87.mimecast.com ([94.185.240.25]:34840 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933510Ab1EXVjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:39:49 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v6 13/18] ARM: LPAE: Add context switching support
Date: Tue, 24 May 2011 22:39:19 +0100
Message-Id: <1306273164-18217-14-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.4.2.g597a6
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 24 May 2011 21:39:48.0693 (UTC) FILETIME=[1B292850:01CC1A5B]
X-MC-Unique: 111052422394600301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id p4OLfT9s005062

With LPAE, TTBRx registers are 64-bit. The ASID is stored in TTBR0
rather than a separate Context ID register. This patch makes the
necessary changes to handle context switching on LPAE.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/mm/context.c |   34 +++++++++++++++++++++++++++++-----
 1 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index 2352395..2dff1cf 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -22,6 +22,34 @@ unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 DEFINE_PER_CPU(struct mm_struct *, current_mm);
 #endif
 
+#ifdef CONFIG_ARM_LPAE
+static void cpu_set_reserved_ttbr0(void)
+{
+	unsigned long ttbl = __pa(swapper_pg_dir);
+	unsigned long ttbh = 0;
+
+	/*
+	 * Set TTBR0 to swapper_pg_dir. Note that swapper_pg_dir only contains
+	 * global entries so the ASID value is not relevant.
+	 */
+	asm(
+	"	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"
+	:
+	: "r" (ttbl), "r" (ttbh));
+}
+#else
+static void cpu_set_reserved_ttbr0(void)
+{
+	u32 ttb;
+
+	/* Copy TTBR1 into TTBR0 */
+	asm volatile(
+	"	mrc	p15, 0, %0, c2, c0, 1		@ read TTBR1\n"
+	"	mcr	p15, 0, %0, c2, c0, 0		@ set TTBR0\n"
+	: "=r" (ttb));
+}
+#endif
+
 /*
  * We fork()ed a process, and we need a new context for the child
  * to run in.
@@ -34,11 +62,7 @@ void __init_new_context(struct task_struct *tsk, struct mm_struct *mm)
 
 static void flush_context(void)
 {
-	u32 ttb;
-	/* Copy TTBR1 into TTBR0 */
-	asm volatile("mrc	p15, 0, %0, c2, c0, 1\n"
-		     "mcr	p15, 0, %0, c2, c0, 0"
-		     : "=r" (ttb));
+	cpu_set_reserved_ttbr0();
 	isb();
 	local_flush_tlb_all();
 	if (icache_is_vivt_asid_tagged()) {

