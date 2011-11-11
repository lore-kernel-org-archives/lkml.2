Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1KKLWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 06:22:39 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19003 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1KKLWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 06:22:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Nov 2011 03:22:30 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH v4 03/10] arm/tegra: prepare clock code for multiple tegra variants
Date: Fri, 11 Nov 2011 13:22:09 +0200
Message-ID: <1321010541-31337-4-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
In-Reply-To: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
References: <1321010541-31337-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the tegra20 clock code to support multiple tegra variants :

 * remove tegra2_periph_reset_assert/tegra2_periph_reset_deassert. This
   functionality should be in clock.c.
 * compile tegra_sdmmc_tap_delay only on tegra20 as this feature will not
   be available in future variants.
 * don't export clk_measure_input_freq as its functionality is also available
   using clk_get_rate().

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/mach-tegra/clock.c         |   14 +++++++++-----
 arch/arm/mach-tegra/clock.h         |    3 ---
 arch/arm/mach-tegra/tegra2_clocks.c |   14 +-------------
 arch/arm/mach-tegra/timer.c         |   12 ++++++++----
 4 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index f8d41ff..47f6366 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -387,13 +387,15 @@ EXPORT_SYMBOL(tegra_clk_init_from_table);
 
 void tegra_periph_reset_deassert(struct clk *c)
 {
-	tegra2_periph_reset_deassert(c);
+	BUG_ON(!c->ops->reset);
+	c->ops->reset(c, false);
 }
 EXPORT_SYMBOL(tegra_periph_reset_deassert);
 
 void tegra_periph_reset_assert(struct clk *c)
 {
-	tegra2_periph_reset_assert(c);
+	BUG_ON(!c->ops->reset);
+	c->ops->reset(c, true);
 }
 EXPORT_SYMBOL(tegra_periph_reset_assert);
 
@@ -403,10 +405,11 @@ void __init tegra_init_clock(void)
 }
 
 /*
- * The SDMMC controllers have extra bits in the clock source register that
- * adjust the delay between the clock and data to compenstate for delays
- * on the PCB.
+ * The SDMMC controllers on tegra20 have extra bits in the clock source
+ * register that adjust the delay between the clock and data to compenstate
+ * for delays on the PCB.
  */
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
 void tegra_sdmmc_tap_delay(struct clk *c, int delay)
 {
 	unsigned long flags;
@@ -415,6 +418,7 @@ void tegra_sdmmc_tap_delay(struct clk *c, int delay)
 	tegra2_sdmmc_tap_delay(c, delay);
 	spin_unlock_irqrestore(&c->spinlock, flags);
 }
+#endif
 
 #ifdef CONFIG_DEBUG_FS
 
diff --git a/arch/arm/mach-tegra/clock.h b/arch/arm/mach-tegra/clock.h
index 688316a..18df129 100644
--- a/arch/arm/mach-tegra/clock.h
+++ b/arch/arm/mach-tegra/clock.h
@@ -146,11 +146,8 @@ struct tegra_clk_init_table {
 };
 
 void tegra2_init_clocks(void);
-void tegra2_periph_reset_deassert(struct clk *c);
-void tegra2_periph_reset_assert(struct clk *c);
 void clk_init(struct clk *clk);
 struct clk *tegra_get_clock_by_name(const char *name);
-unsigned long clk_measure_input_freq(void);
 int clk_reparent(struct clk *c, struct clk *parent);
 void tegra_clk_init_from_table(struct tegra_clk_init_table *table);
 unsigned long clk_get_rate_locked(struct clk *c);
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index 371869d..2ab18f6 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -174,7 +174,7 @@ static int tegra_periph_clk_enable_refcount[3 * 32];
 #define pmc_readl(reg) \
 	__raw_readl(reg_pmc_base + (reg))
 
-unsigned long clk_measure_input_freq(void)
+static unsigned long clk_measure_input_freq(void)
 {
 	u32 clock_autodetect;
 	clk_writel(OSC_FREQ_DET_TRIG | 1, OSC_FREQ_DET);
@@ -278,18 +278,6 @@ static struct clk_ops tegra_clk_m_ops = {
 	.disable	= tegra2_clk_m_disable,
 };
 
-void tegra2_periph_reset_assert(struct clk *c)
-{
-	BUG_ON(!c->ops->reset);
-	c->ops->reset(c, true);
-}
-
-void tegra2_periph_reset_deassert(struct clk *c)
-{
-	BUG_ON(!c->ops->reset);
-	c->ops->reset(c, false);
-}
-
 /* super clock functions */
 /* "super clocks" on tegra have two-stage muxes and a clock skipping
  * super divider.  We will ignore the clock skipping divider, since we
diff --git a/arch/arm/mach-tegra/timer.c b/arch/arm/mach-tegra/timer.c
index 2f1df47..6366654 100644
--- a/arch/arm/mach-tegra/timer.c
+++ b/arch/arm/mach-tegra/timer.c
@@ -182,14 +182,18 @@ static struct irqaction tegra_timer_irq = {
 static void __init tegra_init_timer(void)
 {
 	struct clk *clk;
-	unsigned long rate = clk_measure_input_freq();
+	unsigned long rate;
 	int ret;
 
 	clk = clk_get_sys("timer", NULL);
-	if (IS_ERR(clk))
-		pr_warn("Unable to get timer clock\n");
-	else
+	if (IS_ERR(clk)) {
+		pr_warn("Unable to get timer clock."
+			" Assuming 12Mhz input clock.\n");
+		rate = 12000000;
+	} else {
 		clk_enable(clk);
+		rate = clk_get_rate(clk);
+	}
 
 	/*
 	 * rtc registers are used by read_persistent_clock, keep the rtc clock
-- 
1.7.7.rc0.72.g4b5ea.dirty

