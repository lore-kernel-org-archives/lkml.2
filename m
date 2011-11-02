Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1KBPif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:38:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13531 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab1KBPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:38:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 02 Nov 2011 08:38:20 -0700
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "Stephen Warren" <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm/tegra: add support for tegra30 interrupts
Date: Wed, 2 Nov 2011 17:38:11 +0200
Message-ID: <1320248292-22736-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra30 has 1 extra legacy interrupt controller. Use the GIC ITLinesNumber
field to determine how many interrupt controllers we have and initialize
appropriately. Also make room for the extra tegra30 interrupts by moving
the GPIO IRQ base. This shouldn't affect existing code as it determines the
correct IRQ number for GPIOs using TEGRA_GPIO_TO_IRQ()

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/iomap.h |    3 +++
 arch/arm/mach-tegra/include/mach/irqs.h  |   14 +++++++-------
 arch/arm/mach-tegra/irq.c                |   15 ++++++++++-----
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/iomap.h b/arch/arm/mach-tegra/include/mach/iomap.h
index 19dec3a..67644c9 100644
--- a/arch/arm/mach-tegra/include/mach/iomap.h
+++ b/arch/arm/mach-tegra/include/mach/iomap.h
@@ -74,6 +74,9 @@
 #define TEGRA_QUATERNARY_ICTLR_BASE	0x60004300
 #define TEGRA_QUATERNARY_ICTLR_SIZE	SZ_64
 
+#define TEGRA_QUINARY_ICTLR_BASE	0x60004400
+#define TEGRA_QUINARY_ICTLR_SIZE	SZ_64
+
 #define TEGRA_TMR1_BASE			0x60005000
 #define TEGRA_TMR1_SIZE			SZ_8
 
diff --git a/arch/arm/mach-tegra/include/mach/irqs.h b/arch/arm/mach-tegra/include/mach/irqs.h
index 73265af..b6ebb8e 100644
--- a/arch/arm/mach-tegra/include/mach/irqs.h
+++ b/arch/arm/mach-tegra/include/mach/irqs.h
@@ -25,7 +25,8 @@
 
 #define IRQ_LOCALTIMER                  29
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
+/* We only list the Tegra20 interrupts here as Tegra30 will always use FDT */
+
 /* Primary Interrupt Controller */
 #define INT_PRI_BASE			(INT_GIC_BASE + 32)
 #define INT_TMR1			(INT_PRI_BASE + 0)
@@ -166,18 +167,17 @@
 #define INT_QUAD_RES_30			(INT_QUAD_BASE + 30)
 #define INT_QUAD_RES_31			(INT_QUAD_BASE + 31)
 
-#define INT_MAIN_NR			(INT_QUAD_BASE + 32 - INT_PRI_BASE)
-
+/* Tegra30 has 5 banks of 32 IRQs */
+#define INT_MAIN_NR			(32 * 5)
 #define INT_GPIO_BASE			(INT_PRI_BASE + INT_MAIN_NR)
 
-#define INT_GPIO_NR			(28 * 8)
+/* Tegra30 has 8 banks of 32 GPIOs */
+#define INT_GPIO_NR			(32 * 8)
 
 #define TEGRA_NR_IRQS			(INT_GPIO_BASE + INT_GPIO_NR)
 
 #define INT_BOARD_BASE			TEGRA_NR_IRQS
 #define NR_BOARD_IRQS			32
-
-#define NR_IRQS				(INT_BOARD_BASE + NR_BOARD_IRQS)
-#endif
+#define NR_IRQS                         (INT_BOARD_BASE + NR_BOARD_IRQS)
 
 #endif
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 8ad82af..aad335b 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -43,14 +43,16 @@
 #define ICTLR_COP_IER_CLR	0x38
 #define ICTLR_COP_IEP_CLASS	0x3c
 
-#define NUM_ICTLRS 4
 #define FIRST_LEGACY_IRQ 32
 
+static int num_ictlrs;
+
 static void __iomem *ictlr_reg_base[] = {
 	IO_ADDRESS(TEGRA_PRIMARY_ICTLR_BASE),
 	IO_ADDRESS(TEGRA_SECONDARY_ICTLR_BASE),
 	IO_ADDRESS(TEGRA_TERTIARY_ICTLR_BASE),
 	IO_ADDRESS(TEGRA_QUATERNARY_ICTLR_BASE),
+	IO_ADDRESS(TEGRA_QUINARY_ICTLR_BASE),
 };
 
 static inline void tegra_irq_write_mask(unsigned int irq, unsigned long reg)
@@ -59,7 +61,7 @@ static inline void tegra_irq_write_mask(unsigned int irq, unsigned long reg)
 	u32 mask;
 
 	BUG_ON(irq < FIRST_LEGACY_IRQ ||
-		irq >= FIRST_LEGACY_IRQ + NUM_ICTLRS * 32);
+		irq >= FIRST_LEGACY_IRQ + num_ictlrs * 32);
 
 	base = ictlr_reg_base[(irq - FIRST_LEGACY_IRQ) / 32];
 	mask = BIT((irq - FIRST_LEGACY_IRQ) % 32);
@@ -112,8 +114,12 @@ static int tegra_retrigger(struct irq_data *d)
 void __init tegra_init_irq(void)
 {
 	int i;
+	void __iomem *distbase;
+
+	distbase = IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE);
+	num_ictlrs = readl_relaxed(distbase + GIC_DIST_CTR) & 0x1f;
 
-	for (i = 0; i < NUM_ICTLRS; i++) {
+	for (i = 0; i < num_ictlrs; i++) {
 		void __iomem *ictlr = ictlr_reg_base[i];
 		writel(~0, ictlr + ICTLR_CPU_IER_CLR);
 		writel(0, ictlr + ICTLR_CPU_IEP_CLASS);
@@ -125,6 +131,5 @@ void __init tegra_init_irq(void)
 	gic_arch_extn.irq_unmask = tegra_unmask;
 	gic_arch_extn.irq_retrigger = tegra_retrigger;
 
-	gic_init(0, 29, IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE),
-		 IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
+	gic_init(0, 29, distbase, IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

