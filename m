Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1BMJoA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:44:00 -0500
Received: from smtp-out.google.com ([74.125.121.67]:58586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1BMJnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:06 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 19/21] ARM: tegra: clock: Add function to set SDMMC tap delay
Date: Sun, 13 Feb 2011 01:40:31 -0800
Message-Id: <1297590033-15035-20-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SDMMC controllers have extra bits in the clock source
register that adjust the delay between the clock and data
to compenstate for delays on the PCB.  The values need to
be set from the clock code so the clock can be locked
during the read-modify-write on the clock source register.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/clock.c            |   12 ++++++++++++
 arch/arm/mach-tegra/clock.h            |    1 +
 arch/arm/mach-tegra/include/mach/clk.h |    2 ++
 arch/arm/mach-tegra/tegra2_clocks.c    |   19 +++++++++++++++++++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 4865bb4..2bca01c 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -434,6 +434,18 @@ int __init tegra_disable_boot_clocks(void)
 late_initcall(tegra_disable_boot_clocks);
 #endif
 
+/* The SDMMC controllers have extra bits in the clock source register that
+ * adjust the delay between the clock and data to compenstate for delays
+ * on the PCB. */
+void tegra_sdmmc_tap_delay(struct clk *c, int delay)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&c->spinlock, flags);
+	tegra2_sdmmc_tap_delay(c, delay);
+	spin_unlock_irqrestore(&c->spinlock, flags);
+}
+
 #ifdef CONFIG_DEBUG_FS
 
 static int __clk_lock_all_spinlocks(void)
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index ba8e64f..2aac9a2 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -154,5 +154,6 @@ unsigned long clk_measure_input_freq(void);
 int clk_reparent(struct clk *c, struct clk *parent);
 void tegra_clk_init_from_table(struct tegra_clk_init_table *table);
 unsigned long clk_get_rate_locked(struct clk *c);
+void tegra2_sdmmc_tap_delay(struct clk *c, int delay);
 
 #endif
diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index fa7f9ca..c8baf8f 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -26,4 +26,6 @@ void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
 
 unsigned long clk_get_rate_all_locked(struct clk *c);
+void tegra_sdmmc_tap_delay(struct clk *c, int delay);
+
 #endif
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index f4173ec..bfc9792 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -74,6 +74,10 @@
 #define PERIPH_CLK_SOURCE_DIVU16_MASK	0xFFFF
 #define PERIPH_CLK_SOURCE_DIV_SHIFT	0
 
+#define SDMMC_CLK_INT_FB_SEL		(1 << 23)
+#define SDMMC_CLK_INT_FB_DLY_SHIFT	16
+#define SDMMC_CLK_INT_FB_DLY_MASK	(0xF << SDMMC_CLK_INT_FB_DLY_SHIFT)
+
 #define PLL_BASE			0x0
 #define PLL_BASE_BYPASS			(1<<31)
 #define PLL_BASE_ENABLE			(1<<30)
@@ -1079,6 +1083,21 @@ static struct clk_ops tegra_periph_clk_ops = {
 	.reset			= &tegra2_periph_clk_reset,
 };
 
+/* The SDMMC controllers have extra bits in the clock source register that
+ * adjust the delay between the clock and data to compenstate for delays
+ * on the PCB. */
+void tegra2_sdmmc_tap_delay(struct clk *c, int delay)
+{
+	u32 reg;
+
+	delay = clamp(delay, 0, 15);
+	reg = clk_readl(c->reg);
+	reg &= ~SDMMC_CLK_INT_FB_DLY_MASK;
+	reg |= SDMMC_CLK_INT_FB_SEL;
+	reg |= delay << SDMMC_CLK_INT_FB_DLY_SHIFT;
+	clk_writel(reg, c->reg);
+}
+
 /* External memory controller clock ops */
 static void tegra2_emc_clk_init(struct clk *c)
 {
-- 
1.7.3.1

