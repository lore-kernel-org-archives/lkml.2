Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2IUQBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:01:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39397 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab2IUP5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:57:22 -0400
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
Subject: [PATCH v3 RESEND 13/17] ARM: LPAE: factor out T1SZ and TTBR1 computations
Date: Fri, 21 Sep 2012 11:56:11 -0400
Message-ID: <1348242975-19184-14-git-send-email-cyril@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348242975-19184-1-git-send-email-cyril@ti.com>
References: <1348242975-19184-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the TTBR1 offset calculation and the T1SZ calculation out
of the TTB setup assembly code.  This should not affect functionality in
any way, but improves code readability as well as readability of subsequent
patches in this series.

Signed-off-by: Cyril Chemparathy <cyril@ti.com>
Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
---
 arch/arm/include/asm/pgtable-3level-hwdef.h |   10 ++++++++++
 arch/arm/mm/proc-v7-3level.S                |   16 ++++------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-3level-hwdef.h b/arch/arm/include/asm/pgtable-3level-hwdef.h
index d795282..b501650 100644
--- a/arch/arm/include/asm/pgtable-3level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-3level-hwdef.h
@@ -74,4 +74,14 @@
 #define PHYS_MASK_SHIFT		(40)
 #define PHYS_MASK		((1ULL << PHYS_MASK_SHIFT) - 1)
 
+#if defined CONFIG_VMSPLIT_2G
+#define TTBR1_OFFSET	(1 << 4)		/* skip two L1 entries */
+#elif defined CONFIG_VMSPLIT_3G
+#define TTBR1_OFFSET	(4096 * (1 + 3))	/* only L2, skip pgd + 3*pmd */
+#else
+#define TTBR1_OFFSET	0
+#endif
+
+#define TTBR1_SIZE	(((PAGE_OFFSET >> 30) - 1) << 16)
+
 #endif
diff --git a/arch/arm/mm/proc-v7-3level.S b/arch/arm/mm/proc-v7-3level.S
index c4f4251..5d93f00 100644
--- a/arch/arm/mm/proc-v7-3level.S
+++ b/arch/arm/mm/proc-v7-3level.S
@@ -128,18 +128,10 @@ ENDPROC(cpu_v7_set_pte_ext)
 	 * booting secondary CPUs would end up using TTBR1 for the identity
 	 * mapping set up in TTBR0.
 	 */
-	bhi	9001f				@ PHYS_OFFSET > PAGE_OFFSET?
-	orr	\tmp, \tmp, #(((PAGE_OFFSET >> 30) - 1) << 16) @ TTBCR.T1SZ
-#if defined CONFIG_VMSPLIT_2G
-	/* PAGE_OFFSET == 0x80000000, T1SZ == 1 */
-	add	\ttbr1, \ttbr1, #1 << 4		@ skip two L1 entries
-#elif defined CONFIG_VMSPLIT_3G
-	/* PAGE_OFFSET == 0xc0000000, T1SZ == 2 */
-	add	\ttbr1, \ttbr1, #4096 * (1 + 3)	@ only L2 used, skip pgd+3*pmd
-#endif
-	/* CONFIG_VMSPLIT_1G does not need TTBR1 adjustment */
-9001:	mcr	p15, 0, \tmp, c2, c0, 2		@ TTB control register
-	mcrr	p15, 1, \ttbr1, \zero, c2	@ load TTBR1
+	orrls	\tmp, \tmp, #TTBR1_SIZE				@ TTBCR.T1SZ
+	mcr	p15, 0, \tmp, c2, c0, 2				@ TTBCR
+	addls	\ttbr1, \ttbr1, #TTBR1_OFFSET
+	mcrr	p15, 1, \ttbr1, \zero, c2			@ load TTBR1
 	.endm
 
 	__CPUINIT
-- 
1.7.9.5

