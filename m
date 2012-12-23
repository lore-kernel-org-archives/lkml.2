Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab2LWLIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:08:38 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19811 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2LWLIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:08:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 23 Dec 2012 03:06:33 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 10/11] arm: tegra: Migrate to new clock code
Date: Sun, 23 Dec 2012 16:35:50 +0530
Message-ID: <1356260751-3667-11-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356260751-3667-1-git-send-email-pgaikwad@nvidia.com>
References: <1356260751-3667-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate tegra clock support to drivers/clk/tegra, this involves
moving
1. definition of tegra_cpu_car_ops to clk.c
2. definition of reset functions to clk-peripheral.c
3. change parent of cpu clock.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/mach-tegra/board-dt-tegra20.c |   18 --------------
 arch/arm/mach-tegra/board-dt-tegra30.c |   18 --------------
 arch/arm/mach-tegra/clock.c            |   19 ---------------
 arch/arm/mach-tegra/common.c           |   39 +------------------------------
 arch/arm/mach-tegra/cpu-tegra.c        |    5 +---
 arch/arm/mach-tegra/include/mach/clk.h |    3 --
 arch/arm/mach-tegra/pcie.c             |    2 +-
 arch/arm/mach-tegra/platsmp.c          |    1 -
 arch/arm/mach-tegra/powergate.c        |    2 +-
 drivers/clk/tegra/clk-periph.c         |   38 +++++++++++++++++++++++++++++++
 drivers/clk/tegra/clk.c                |    5 ++++
 drivers/crypto/tegra-aes.c             |    2 -
 drivers/dma/tegra20-apb-dma.c          |    2 +-
 drivers/i2c/busses/i2c-tegra.c         |    3 +-
 drivers/input/keyboard/tegra-kbc.c     |    2 +-
 drivers/staging/nvec/nvec.c            |    2 +-
 include/linux/clk/tegra.h              |    4 +++
 sound/soc/tegra/tegra30_ahub.c         |    2 +-
 18 files changed, 57 insertions(+), 110 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index aa5325c..2445900 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -44,7 +44,6 @@
 #include <mach/irqs.h>
 
 #include "board.h"
-#include "clock.h"
 #include "common.h"
 
 struct tegra_ehci_platform_data tegra_ehci1_pdata = {
@@ -94,25 +93,8 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 	{}
 };
 
-static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
-	/* name		parent		rate		enabled */
-	{ "uarta",	"pll_p",	216000000,	true },
-	{ "uartd",	"pll_p",	216000000,	true },
-	{ "usbd",	"clk_m",	12000000,	false },
-	{ "usb2",	"clk_m",	12000000,	false },
-	{ "usb3",	"clk_m",	12000000,	false },
-	{ "pll_a",      "pll_p_out1",   56448000,       true },
-	{ "pll_a_out0", "pll_a",        11289600,       true },
-	{ "cdev1",      NULL,           0,              true },
-	{ "i2s1",       "pll_a_out0",   11289600,       false},
-	{ "i2s2",       "pll_a_out0",   11289600,       false},
-	{ NULL,		NULL,		0,		0},
-};
-
 static void __init tegra_dt_init(void)
 {
-	tegra_clk_init_from_table(tegra_dt_clk_init_table);
-
 	/*
 	 * Finished with the static registrations now; fill in the missing
 	 * devices
diff --git a/arch/arm/mach-tegra/board-dt-tegra30.c b/arch/arm/mach-tegra/board-dt-tegra30.c
index 5e92a81..321cd41 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -36,7 +36,6 @@
 #include <mach/iomap.h>
 
 #include "board.h"
-#include "clock.h"
 #include "common.h"
 
 struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
@@ -55,25 +54,8 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	{}
 };
 
-static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
-	/* name		parent		rate		enabled */
-	{ "uarta",	"pll_p",	408000000,	true },
-	{ "pll_a",	"pll_p_out1",	564480000,	true },
-	{ "pll_a_out0",	"pll_a",	11289600,	true },
-	{ "extern1",	"pll_a_out0",	0,		true },
-	{ "clk_out_1",	"extern1",	0,		true },
-	{ "i2s0",	"pll_a_out0",	11289600,	false},
-	{ "i2s1",	"pll_a_out0",	11289600,	false},
-	{ "i2s2",	"pll_a_out0",	11289600,	false},
-	{ "i2s3",	"pll_a_out0",	11289600,	false},
-	{ "i2s4",	"pll_a_out0",	11289600,	false},
-	{ NULL,		NULL,		0,		0},
-};
-
 static void __init tegra30_dt_init(void)
 {
-	tegra_clk_init_from_table(tegra_dt_clk_init_table);
-
 	of_platform_populate(NULL, of_default_bus_match_table,
 				tegra30_auxdata_lookup, NULL);
 }
diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 59f25d2..a5eeb18 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -33,9 +33,6 @@
 #include "board.h"
 #include "clock.h"
 
-/* Global data of Tegra CPU CAR ops */
-struct tegra_cpu_car_ops *tegra_cpu_car_ops;
-
 /*
  * Locking:
  *
@@ -133,22 +130,6 @@ void tegra_clk_init_from_table(struct tegra_clk_init_table *table)
 		tegra_clk_init_one_from_table(table);
 }
 
-void tegra_periph_reset_deassert(struct clk *c)
-{
-	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
-	BUG_ON(!clk->reset);
-	clk->reset(__clk_get_hw(c), false);
-}
-EXPORT_SYMBOL(tegra_periph_reset_deassert);
-
-void tegra_periph_reset_assert(struct clk *c)
-{
-	struct clk_tegra *clk = to_clk_tegra(__clk_get_hw(c));
-	BUG_ON(!clk->reset);
-	clk->reset(__clk_get_hw(c), true);
-}
-EXPORT_SYMBOL(tegra_periph_reset_assert);
-
 /* Several extended clock configuration bits (e.g., clock routing, clock
  * phase control) are included in PLL and peripheral clock source
  * registers. */
diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 988549a..1f71d0f 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/of_irq.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/hardware/gic.h>
@@ -30,7 +31,6 @@
 #include <mach/powergate.h>
 
 #include "board.h"
-#include "clock.h"
 #include "common.h"
 #include "fuse.h"
 #include "pmc.h"
@@ -62,6 +62,7 @@ static const struct of_device_id tegra_dt_irq_match[] __initconst = {
 
 void __init tegra_dt_init_irq(void)
 {
+	tegra_dt_init_clk();
 	tegra_init_irq();
 	of_irq_init(tegra_dt_irq_match);
 }
@@ -77,38 +78,6 @@ void tegra_assert_system_reset(char mode, const char *cmd)
 	writel_relaxed(reg, reset);
 }
 
-#ifdef CONFIG_ARCH_TEGRA_2x_SOC
-static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
-	/* name		parent		rate		enabled */
-	{ "clk_m",	NULL,		0,		true },
-	{ "pll_p",	"clk_m",	216000000,	true },
-	{ "pll_p_out1",	"pll_p",	28800000,	true },
-	{ "pll_p_out2",	"pll_p",	48000000,	true },
-	{ "pll_p_out3",	"pll_p",	72000000,	true },
-	{ "pll_p_out4",	"pll_p",	24000000,	true },
-	{ "pll_c",	"clk_m",	600000000,	true },
-	{ "pll_c_out1",	"pll_c",	120000000,	true },
-	{ "sclk",	"pll_c_out1",	120000000,	true },
-	{ "hclk",	"sclk",		120000000,	true },
-	{ "pclk",	"hclk",		60000000,	true },
-	{ "csite",	NULL,		0,		true },
-	{ "emc",	NULL,		0,		true },
-	{ "cpu",	NULL,		0,		true },
-	{ NULL,		NULL,		0,		0},
-};
-#endif
-
-#ifdef CONFIG_ARCH_TEGRA_3x_SOC
-static __initdata struct tegra_clk_init_table tegra30_clk_init_table[] = {
-	/* name		parent		rate		enabled */
-	{ "clk_m",	NULL,		0,		true },
-	{ "pll_p",	"pll_ref",	408000000,	true },
-	{ "pll_p_out1",	"pll_p",	9600000,	true },
-	{ NULL,		NULL,		0,		0},
-};
-#endif
-
-
 static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
 {
 #ifdef CONFIG_CACHE_L2X0
@@ -132,8 +101,6 @@ void __init tegra20_init_early(void)
 {
 	tegra_apb_io_init();
 	tegra_init_fuse();
-	tegra2_init_clocks();
-	tegra_clk_init_from_table(tegra20_clk_init_table);
 	tegra_init_cache(0x331, 0x441);
 	tegra_pmc_init();
 	tegra_powergate_init();
@@ -145,8 +112,6 @@ void __init tegra30_init_early(void)
 {
 	tegra_apb_io_init();
 	tegra_init_fuse();
-	tegra30_init_clocks();
-	tegra_clk_init_from_table(tegra30_clk_init_table);
 	tegra_init_cache(0x441, 0x551);
 	tegra_pmc_init();
 	tegra_powergate_init();
diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index 627bf0f..07555f6 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -30,9 +30,6 @@
 #include <linux/io.h>
 #include <linux/suspend.h>
 
-
-#include <mach/clk.h>
-
 /* Frequency table index must be sequential starting at 0 */
 static struct cpufreq_frequency_table freq_table[] = {
 	{ 0, 216000 },
@@ -225,7 +222,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	if (IS_ERR(pll_x_clk))
 		return PTR_ERR(pll_x_clk);
 
-	pll_p_clk = clk_get_sys(NULL, "pll_p");
+	pll_p_clk = clk_get_sys(NULL, "pll_p_cclk");
 	if (IS_ERR(pll_p_clk))
 		return PTR_ERR(pll_p_clk);
 
diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
index 95f3a54..85bbf10 100644
--- a/arch/arm/mach-tegra/include/mach/clk.h
+++ b/arch/arm/mach-tegra/include/mach/clk.h
@@ -31,9 +31,6 @@ enum tegra_clk_ex_param {
 	TEGRA_CLK_PLLD_MIPI_MUX_SEL,
 };
 
-void tegra_periph_reset_deassert(struct clk *c);
-void tegra_periph_reset_assert(struct clk *c);
-
 #ifndef CONFIG_COMMON_CLK
 unsigned long clk_get_rate_all_locked(struct clk *c);
 #endif
diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
index a8dba64..f5a64fd 100644
--- a/arch/arm/mach-tegra/pcie.c
+++ b/arch/arm/mach-tegra/pcie.c
@@ -33,12 +33,12 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/export.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/sizes.h>
 #include <asm/mach/pci.h>
 
 #include <mach/iomap.h>
-#include <mach/clk.h>
 #include <mach/powergate.h>
 
 #include "board.h"
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 00a4124..6457f1d 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -25,7 +25,6 @@
 #include <asm/mach-types.h>
 #include <asm/smp_scu.h>
 
-#include <mach/clk.h>
 #include <mach/iomap.h>
 #include <mach/powergate.h>
 
diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index de0662d..b4bbdaf 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -26,8 +26,8 @@
 #include <linux/io.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/clk/tegra.h>
 
-#include <mach/clk.h>
 #include <mach/iomap.h>
 #include <mach/powergate.h>
 
diff --git a/drivers/clk/tegra/clk-periph.c b/drivers/clk/tegra/clk-periph.c
index 21fa881..06235f4 100644
--- a/drivers/clk/tegra/clk-periph.c
+++ b/drivers/clk/tegra/clk-periph.c
@@ -112,6 +112,44 @@ static void clk_periph_disable(struct clk_hw *hw)
 	gate_ops->disable(gate_hw);
 }
 
+void tegra_periph_reset_deassert(struct clk *c)
+{
+	struct clk_hw *hw = __clk_get_hw(c);
+	struct tegra_clk_periph *periph = to_clk_periph(hw);
+	struct tegra_clk_periph_gate *gate;
+
+	if (periph->magic != TEGRA_CLK_PERIPH_MAGIC) {
+		gate = container_of(hw, struct tegra_clk_periph_gate, hw);
+		if (gate->magic != TEGRA_CLK_PERIPH_GATE_MAGIC) {
+			WARN_ON(1);
+			return;
+		}
+	} else {
+		gate = &periph->gate;
+	}
+
+	tegra_periph_reset(gate, 0);
+}
+
+void tegra_periph_reset_assert(struct clk *c)
+{
+	struct clk_hw *hw = __clk_get_hw(c);
+	struct tegra_clk_periph *periph = to_clk_periph(hw);
+	struct tegra_clk_periph_gate *gate;
+
+	if (periph->magic != TEGRA_CLK_PERIPH_MAGIC) {
+		gate = container_of(hw, struct tegra_clk_periph_gate, hw);
+		if (gate->magic != TEGRA_CLK_PERIPH_GATE_MAGIC) {
+			WARN_ON(1);
+			return;
+		}
+	} else {
+		gate = &periph->gate;
+	}
+
+	tegra_periph_reset(gate, 1);
+}
+
 const struct clk_ops tegra_clk_periph_ops = {
 	.get_parent = clk_periph_get_parent,
 	.set_parent = clk_periph_set_parent,
diff --git a/drivers/clk/tegra/clk.c b/drivers/clk/tegra/clk.c
index 314d5bd..9bb7463 100644
--- a/drivers/clk/tegra/clk.c
+++ b/drivers/clk/tegra/clk.c
@@ -16,9 +16,14 @@
 
 #include <linux/clk.h>
 #include <linux/clk-provider.h>
+#include <linux/of.h>
+#include <linux/clk/tegra.h>
 
 #include "clk.h"
 
+/* Global data of Tegra CPU CAR ops */
+struct tegra_cpu_car_ops *tegra_cpu_car_ops;
+
 void __init tegra_init_dup_clks(struct tegra_clk_duplicate *dup_list,
 				struct clk *clks[], int clk_max)
 {
diff --git a/drivers/crypto/tegra-aes.c b/drivers/crypto/tegra-aes.c
index 37185e6..e69f3bc 100644
--- a/drivers/crypto/tegra-aes.c
+++ b/drivers/crypto/tegra-aes.c
@@ -41,8 +41,6 @@
 #include <linux/completion.h>
 #include <linux/workqueue.h>
 
-#include <mach/clk.h>
-
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
 #include <crypto/internal/rng.h>
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 528c62d..49b27b2 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -31,8 +31,8 @@
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
+#include <linux/clk/tegra.h>
 
-#include <mach/clk.h>
 #include "dmaengine.h"
 
 #define TEGRA_APBDMA_GENERAL			0x0
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index dcea77b..c048c98 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -29,11 +29,10 @@
 #include <linux/of_i2c.h>
 #include <linux/of_device.h>
 #include <linux/module.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/unaligned.h>
 
-#include <mach/clk.h>
-
 #define TEGRA_I2C_TIMEOUT (msecs_to_jiffies(1000))
 #define BYTES_PER_FIFO_WORD 4
 
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index 5faaf25..60b8563 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -30,7 +30,7 @@
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/input/tegra_kbc.h>
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #define KBC_MAX_DEBOUNCE_CNT	0x3ffu
 
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 094fdc3..1fad2a2 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -37,8 +37,8 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
+#include <linux/clk/tegra.h>
 
-#include <mach/clk.h>
 #include <mach/iomap.h>
 
 #include "nvec.h"
diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index 93a38b6..51c3806 100644
--- a/include/linux/clk/tegra.h
+++ b/include/linux/clk/tegra.h
@@ -17,6 +17,8 @@
 #ifndef __LINUX_CLK_TEGRA_H_
 #define __LINUX_CLK_TEGRA_H_
 
+#include <linux/clk.h>
+
 /*
  * Tegra CPU clock and reset control ops
  *
@@ -84,5 +86,7 @@ static inline void tegra_disable_cpu_clock(u32 cpu)
 void tegra_dt_init_clk(void);
 void tegra20_cpu_car_ops_init(void);
 void tegra30_cpu_car_ops_init(void);
+void tegra_periph_reset_deassert(struct clk *c);
+void tegra_periph_reset_assert(struct clk *c);
 
 #endif /* __LINUX_CLK_TEGRA_H_ */
diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index bf56101..aab61d8 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -25,7 +25,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 #include <mach/dma.h>
 #include <sound/soc.h>
 #include "tegra30_ahub.h"
-- 
1.7.4.1

