Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2GaXFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:05:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42728 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab2GaXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:05:40 -0400
From: Cyril Chemparathy <cyril@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <catalin.marinas@arm.com>, <nico@linaro.org>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        Cyril Chemparathy <cyril@ti.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: [PATCH 10/22] ARM: LPAE: use 64-bit accessors for TTBR registers
Date: Tue, 31 Jul 2012 19:04:46 -0400
Message-ID: <1343775898-28345-11-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343775898-28345-1-git-send-email-cyril@ti.com>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds TTBR accessor macros, and modifies cpu_get_pgd() and
the LPAE version of cpu_set_reserved_ttbr0() to use these instead.

In the process, we also fix these functions to correctly handle cases
where the physical address lies beyond the 4G limit of 32-bit addressing.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
---
 arch/arm/include/asm/proc-fns.h |   24 +++++++++++++++++++-----
 arch/arm/mm/context.c           |   13 ++-----------
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arch/arm/include/asm/proc-fns.h b/arch/arm/include/asm/proc-fns.h
index fa6554e..918b4f9 100644
--- a/arch/arm/include/asm/proc-fns.h
+++ b/arch/arm/include/asm/proc-fns.h
@@ -116,13 +116,27 @@ extern void cpu_resume(void);
 #define cpu_switch_mm(pgd,mm) cpu_do_switch_mm(virt_to_phys(pgd),mm)
 
 #ifdef CONFIG_ARM_LPAE
+
+#define cpu_get_ttbr(nr)					\
+	({							\
+		u64 ttbr;					\
+		__asm__("mrrc	p15, " #nr ", %Q0, %R0, c2"	\
+			: "=r" (ttbr)				\
+			: : "cc");				\
+		ttbr;						\
+	})
+
+#define cpu_set_ttbr(nr, val)					\
+	do {							\
+		u64 ttbr = val;					\
+		__asm__("mcrr	p15, " #nr ", %Q0, %R0, c2"	\
+			: : "r" (ttbr)				\
+			: "cc");				\
+	} while (0)
+
 #define cpu_get_pgd()	\
 	({						\
-		unsigned long pg, pg2;			\
-		__asm__("mrrc	p15, 0, %0, %1, c2"	\
-			: "=r" (pg), "=r" (pg2)		\
-			:				\
-			: "cc");			\
+		u64 pg = cpu_get_ttbr(0);		\
 		pg &= ~(PTRS_PER_PGD*sizeof(pgd_t)-1);	\
 		(pgd_t *)phys_to_virt(pg);		\
 	})
diff --git a/arch/arm/mm/context.c b/arch/arm/mm/context.c
index 806cc4f..ad70bd8 100644
--- a/arch/arm/mm/context.c
+++ b/arch/arm/mm/context.c
@@ -15,6 +15,7 @@
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
+#include <asm/proc-fns.h>
 
 static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
 unsigned int cpu_last_asid = ASID_FIRST_VERSION;
@@ -22,17 +23,7 @@ unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 #ifdef CONFIG_ARM_LPAE
 void cpu_set_reserved_ttbr0(void)
 {
-	unsigned long ttbl = __pa(swapper_pg_dir);
-	unsigned long ttbh = 0;
-
-	/*
-	 * Set TTBR0 to swapper_pg_dir which contains only global entries. The
-	 * ASID is set to 0.
-	 */
-	asm volatile(
-	"	mcrr	p15, 0, %0, %1, c2		@ set TTBR0\n"
-	:
-	: "r" (ttbl), "r" (ttbh));
+	cpu_set_ttbr(0, __pa(swapper_pg_dir));
 	isb();
 }
 #else
-- 
1.7.9.5

