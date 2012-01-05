Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2AENc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 08:32:26 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6313 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2AENcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 08:32:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 05 Jan 2012 05:32:12 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "Stephen Warren" <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Gary King <gking@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] arm/tegra: add support for tegra30 interrupts
Date: Thu, 5 Jan 2012 15:31:45 +0200
Message-ID: <1325770305-21637-1-git-send-email-pdeschrijver@nvidia.com>
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
correct IRQ number for GPIOs using TEGRA_GPIO_TO_IRQ().

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Colin Cross <ccross@android.com>

---
This patch is against
git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git for-3.3/soc
commit 6cc04a4420391c3f034afe8ea6e28d75912a70a3

On top of this the following patches are needed:

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7240/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7244/1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7241/1
---
 arch/arm/mach-tegra/include/mach/iomap.h |    3 +++
 arch/arm/mach-tegra/include/mach/irqs.h  |    7 ++++---
 arch/arm/mach-tegra/irq.c                |   20 ++++++++++++++++----
 3 files changed, 23 insertions(+), 7 deletions(-)

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
index a2146cd..aad1a2c 100644
--- a/arch/arm/mach-tegra/include/mach/irqs.h
+++ b/arch/arm/mach-tegra/include/mach/irqs.h
@@ -165,11 +165,12 @@
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
 
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 004b0fd..6ad5255 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -48,14 +48,16 @@
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
@@ -64,7 +66,7 @@ static inline void tegra_irq_write_mask(unsigned int irq, unsigned long reg)
 	u32 mask;
 
 	BUG_ON(irq < FIRST_LEGACY_IRQ ||
-		irq >= FIRST_LEGACY_IRQ + NUM_ICTLRS * 32);
+		irq >= FIRST_LEGACY_IRQ + num_ictlrs * 32);
 
 	base = ictlr_reg_base[(irq - FIRST_LEGACY_IRQ) / 32];
 	mask = BIT((irq - FIRST_LEGACY_IRQ) % 32);
@@ -117,8 +119,18 @@ static int tegra_retrigger(struct irq_data *d)
 void __init tegra_init_irq(void)
 {
 	int i;
+	void __iomem *distbase;
+
+	distbase = IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE);
+	num_ictlrs = readl_relaxed(distbase + GIC_DIST_CTR) & 0x1f;
+
+	if (num_ictlrs > ARRAY_SIZE(ictlr_reg_base)) {
+		WARN(1, "Too many (%d) interrupt controllers found. Maximum is %d.",
+			num_ictlrs, ARRAY_SIZE(ictlr_reg_base));
+		num_ictlrs = ARRAY_SIZE(ictlr_reg_base);
+	}
 
-	for (i = 0; i < NUM_ICTLRS; i++) {
+	for (i = 0; i < num_ictlrs; i++) {
 		void __iomem *ictlr = ictlr_reg_base[i];
 		writel(~0, ictlr + ICTLR_CPU_IER_CLR);
 		writel(0, ictlr + ICTLR_CPU_IEP_CLASS);
@@ -135,6 +147,6 @@ void __init tegra_init_irq(void)
 	 * initialized elsewhere under DT.
 	 */
 	if (!of_have_populated_dt())
-		gic_init(0, 29, IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE),
+		gic_init(0, 29, distbase,
 			IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

