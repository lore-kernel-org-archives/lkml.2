Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab3ADHBh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 02:01:37 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10648 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3ADHBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 02:01:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 03 Jan 2013 23:01:22 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <mturquette@linaro.org>, <swarren@nvidia.com>, <grant.likely@secretlab.ca>,
        <linus.walleij@linaro.org>, <rob.herring@calxeda.com>,
        <maxime.ripard@free-electrons.com>, <linux@prisktech.co.nz>,
        <josh.cartwright@ni.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 2/7] clk: tegra: Use common of_clk_init() function
Date: Fri, 4 Jan 2013 12:30:53 +0530
Message-ID: <1357282858-2112-2-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
References: <1357282858-2112-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common of_clk_init() function for clocks initialization.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/mach-tegra/common.c    |    4 ++--
 drivers/clk/tegra/clk-tegra20.c |    3 ++-
 drivers/clk/tegra/clk-tegra30.c |    3 ++-
 drivers/clk/tegra/clk.c         |   11 -----------
 drivers/clk/tegra/clk.h         |   12 ------------
 include/linux/clk/tegra.h       |    1 -
 6 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 3a7280d..4fde6a9 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -22,7 +22,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/of_irq.h>
-#include <linux/clk/tegra.h>
+#include <linux/clk-provider.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/hardware/gic.h>
@@ -64,7 +64,7 @@ static const struct of_device_id tegra_dt_irq_match[] __initconst = {
 
 void __init tegra_dt_init_irq(void)
 {
-	tegra_clocks_init();
+	of_clk_init(NULL);
 	tegra_init_irq();
 	of_irq_init(tegra_dt_irq_match);
 }
diff --git a/drivers/clk/tegra/clk-tegra20.c b/drivers/clk/tegra/clk-tegra20.c
index 32a3d81..3436ad9 100644
--- a/drivers/clk/tegra/clk-tegra20.c
+++ b/drivers/clk/tegra/clk-tegra20.c
@@ -1193,7 +1193,7 @@ static const struct of_device_id apb_match[] __initconst = {
 	{},
 };
 
-void __init tegra20_clock_init(struct device_node *np)
+static void __init tegra20_clock_init(struct device_node *np)
 {
 	int i;
 	struct device_node *node;
@@ -1253,3 +1253,4 @@ void __init tegra20_clock_init(struct device_node *np)
 
 	tegra_cpu_car_ops = &tegra20_cpu_car_ops;
 }
+CLK_OF_DECLARE(tegra20, "nvidia,tegra20-car", tegra20_clock_init);
diff --git a/drivers/clk/tegra/clk-tegra30.c b/drivers/clk/tegra/clk-tegra30.c
index 30fb743..f17e857 100644
--- a/drivers/clk/tegra/clk-tegra30.c
+++ b/drivers/clk/tegra/clk-tegra30.c
@@ -1971,7 +1971,7 @@ static const struct of_device_id apb_match[] __initconst = {
 	{},
 };
 
-void __init tegra30_clock_init(struct device_node *np)
+static void __init tegra30_clock_init(struct device_node *np)
 {
 	struct device_node *node;
 	int i;
@@ -2031,3 +2031,4 @@ void __init tegra30_clock_init(struct device_node *np)
 
 	tegra_cpu_car_ops = &tegra30_cpu_car_ops;
 }
+CLK_OF_DECLARE(tegra30, "nvidia,tegra30-car", tegra30_clock_init);
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index a603b9a..ce4441a 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -72,14 +72,3 @@ void __init tegra_init_from_table(struct tegra_clk_init_table *tbl,
 			}
 	}
 }
-
-static const struct of_device_id tegra_dt_clk_match[] = {
-	{ .compatible = "nvidia,tegra20-car", .data = tegra20_clock_init },
-	{ .compatible = "nvidia,tegra30-car", .data = tegra30_clock_init },
-	{ }
-};
-
-void __init tegra_clocks_init(void)
-{
-	of_clk_init(tegra_dt_clk_match);
-}
diff --git a/drivers/clk/tegra/clk.h b/drivers/clk/tegra/clk.h
index f1ed1d0..7fdf8e6 100644
--- a/drivers/clk/tegra/clk.h
+++ b/drivers/clk/tegra/clk.h
@@ -476,16 +476,4 @@ void tegra_init_from_table(struct tegra_clk_init_table *tbl,
 void tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 				struct clk *clks[], int clk_max);
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
-void tegra20_clock_init(struct device_node *np);
-#else
-static inline void tegra20_clock_init(struct device_node *np) {}
-#endif /* CONFIG_ARCH_TEGRA_2x_SOC */
-
-#ifdef CONFIG_ARCH_TEGRA_3x_SOC
-void tegra30_clock_init(struct device_node *np);
-#else
-static inline void tegra30_clock_init(struct device_node *np) {}
-#endif /* CONFIG_ARCH_TEGRA_3x_SOC */
-
 #endif /* TEGRA_CLK_H */
diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index 404d6f9..2e8b399 100644
--- a/include/linux/clk/tegra.h
+++ b/include/linux/clk/tegra.h
@@ -122,6 +122,5 @@ static inline void tegra_cpu_clock_resume(void)
 
 void tegra_periph_reset_deassert(struct clk *c);
 void tegra_periph_reset_assert(struct clk *c);
-void tegra_clocks_init(void);
 
 #endif /* __LINUX_CLK_TEGRA_H_ */
-- 
1.7.4.1

