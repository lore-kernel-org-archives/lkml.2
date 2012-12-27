Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab2L0Os7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:48:59 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9155 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025Ab2L0Osw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:48:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 27 Dec 2012 06:48:39 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v2 10/11] arm: tegra: Migrate to new clock code
Date: Thu, 27 Dec 2012 20:17:23 +0530
Message-ID: <1356619644-18565-11-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
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
 arch/arm/mach-tegra/board-dt-tegra20.c |   30 ---------------------
 arch/arm/mach-tegra/board-dt-tegra30.c |   31 ----------------------
 arch/arm/mach-tegra/clock.c            |   19 -------------
 arch/arm/mach-tegra/common.c           |   44 +------------------------------
 arch/arm/mach-tegra/cpu-tegra.c        |    2 +-
 arch/arm/mach-tegra/include/mach/clk.h |    3 --
 arch/arm/mach-tegra/pcie.c             |    2 +-
 arch/arm/mach-tegra/powergate.c        |    2 +-
 drivers/clk/tegra/clk-periph.c         |   38 +++++++++++++++++++++++++++
 drivers/clk/tegra/clk.c                |    5 +++
 drivers/dma/tegra20-apb-dma.c          |    2 +-
 drivers/gpu/drm/tegra/dc.c             |    3 +-
 drivers/gpu/drm/tegra/drm.c            |    1 -
 drivers/gpu/drm/tegra/hdmi.c           |    3 +-
 drivers/i2c/busses/i2c-tegra.c         |    3 +-
 drivers/input/keyboard/tegra-kbc.c     |    2 +-
 drivers/spi/spi-tegra20-sflash.c       |    2 +-
 drivers/spi/spi-tegra20-slink.c        |    2 +-
 drivers/staging/nvec/nvec.c            |    3 +-
 include/linux/clk/tegra.h              |    4 +++
 sound/soc/tegra/tegra30_ahub.c         |    2 +-
 21 files changed, 61 insertions(+), 142 deletions(-)

diff --git a/arch/arm/mach-tegra/board-dt-tegra20.c b/arch/arm/mach-tegra/board-dt-tegra20.c
index 734d9cc..1267ce0 100644
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@ -41,7 +41,6 @@
 #include <asm/setup.h>
 
 #include "board.h"
-#include "clock.h"
 #include "common.h"
 #include "iomap.h"
 
@@ -103,37 +102,8 @@ struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
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
-	{ "blink",      "clk_32k",      32768,          true },
-	{ "i2s1",       "pll_a_out0",   11289600,       false},
-	{ "i2s2",       "pll_a_out0",   11289600,       false},
-	{ "sdmmc1",	"pll_p",	48000000,	false},
-	{ "sdmmc3",	"pll_p",	48000000,	false},
-	{ "sdmmc4",	"pll_p",	48000000,	false},
-	{ "spi",	"pll_p",	20000000,	false },
-	{ "sbc1",	"pll_p",	100000000,	false },
-	{ "sbc2",	"pll_p",	100000000,	false },
-	{ "sbc3",	"pll_p",	100000000,	false },
-	{ "sbc4",	"pll_p",	100000000,	false },
-	{ "host1x",	"pll_c",	150000000,	false },
-	{ "disp1",	"pll_p",	600000000,	false },
-	{ "disp2",	"pll_p",	600000000,	false },
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
index 6497d12..b65262c 100644
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@ -34,7 +34,6 @@
 #include <asm/hardware/gic.h>
 
 #include "board.h"
-#include "clock.h"
 #include "common.h"
 #include "iomap.h"
 
@@ -66,38 +65,8 @@ struct of_dev_auxdata tegra30_auxdata_lookup[] __initdata = {
 	{}
 };
 
-static __initdata struct tegra_clk_init_table tegra_dt_clk_init_table[] = {
-	/* name		parent		rate		enabled */
-	{ "uarta",	"pll_p",	408000000,	true },
-	{ "pll_a",	"pll_p_out1",	564480000,	true },
-	{ "pll_a_out0",	"pll_a",	11289600,	true },
-	{ "extern1",	"pll_a_out0",	0,		true },
-	{ "clk_out_1",	"extern1",	0,		true },
-	{ "blink",	"clk_32k",	32768,		true },
-	{ "i2s0",	"pll_a_out0",	11289600,	false},
-	{ "i2s1",	"pll_a_out0",	11289600,	false},
-	{ "i2s2",	"pll_a_out0",	11289600,	false},
-	{ "i2s3",	"pll_a_out0",	11289600,	false},
-	{ "i2s4",	"pll_a_out0",	11289600,	false},
-	{ "sdmmc1",	"pll_p",	48000000,	false},
-	{ "sdmmc3",	"pll_p",	48000000,	false},
-	{ "sdmmc4",	"pll_p",	48000000,	false},
-	{ "sbc1",	"pll_p",	100000000,	false},
-	{ "sbc2",	"pll_p",	100000000,	false},
-	{ "sbc3",	"pll_p",	100000000,	false},
-	{ "sbc4",	"pll_p",	100000000,	false},
-	{ "sbc5",	"pll_p",	100000000,	false},
-	{ "sbc6",	"pll_p",	100000000,	false},
-	{ "host1x",	"pll_c",	150000000,	false},
-	{ "disp1",	"pll_p",	600000000,	false},
-	{ "disp2",	"pll_p",	600000000,	false},
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
index 8c0ff06..baa0c5b 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -31,9 +31,6 @@
 #include "board.h"
 #include "clock.h"
 
-/* Global data of Tegra CPU CAR ops */
-struct tegra_cpu_car_ops *tegra_cpu_car_ops;
-
 /*
  * Locking:
  *
@@ -131,22 +128,6 @@ void tegra_clk_init_from_table(struct tegra_clk_init_table *table)
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
index d54cfc5..898fce4 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -22,6 +22,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/of_irq.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/hardware/gic.h>
@@ -29,7 +30,6 @@
 #include <mach/powergate.h>
 
 #include "board.h"
-#include "clock.h"
 #include "common.h"
 #include "fuse.h"
 #include "iomap.h"
@@ -64,6 +64,7 @@ static const struct of_device_id tegra_dt_irq_match[] __initconst = {
 
 void __init tegra_dt_init_irq(void)
 {
+	tegra_dt_init_clk();
 	tegra_init_irq();
 	of_irq_init(tegra_dt_irq_match);
 }
@@ -79,43 +80,6 @@ void tegra_assert_system_reset(char mode, const char *cmd)
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
-	{ "pll_p_out4",	"pll_p",	102000000,	true },
-	{ "sclk",	"pll_p_out4",	102000000,	true },
-	{ "hclk",	"sclk",		102000000,	true },
-	{ "pclk",	"hclk",		51000000,	true },
-	{ "csite",	NULL,		0,		true },
-	{ NULL,		NULL,		0,		0},
-};
-#endif
-
-
 static void __init tegra_init_cache(void)
 {
 #ifdef CONFIG_CACHE_L2X0
@@ -139,8 +103,6 @@ void __init tegra20_init_early(void)
 {
 	tegra_apb_io_init();
 	tegra_init_fuse();
-	tegra2_init_clocks();
-	tegra_clk_init_from_table(tegra20_clk_init_table);
 	tegra_init_cache();
 	tegra_pmc_init();
 	tegra_powergate_init();
@@ -152,8 +114,6 @@ void __init tegra30_init_early(void)
 {
 	tegra_apb_io_init();
 	tegra_init_fuse();
-	tegra30_init_clocks();
-	tegra_clk_init_from_table(tegra30_clk_init_table);
 	tegra_init_cache();
 	tegra_pmc_init();
 	tegra_powergate_init();
diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index a74d3c7..07555f6 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -222,7 +222,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
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
index bffcd64..b60165f 100644
--- a/arch/arm/mach-tegra/pcie.c
+++ b/arch/arm/mach-tegra/pcie.c
@@ -33,11 +33,11 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/export.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/sizes.h>
 #include <asm/mach/pci.h>
 
-#include <mach/clk.h>
 #include <mach/powergate.h>
 
 #include "board.h"
diff --git a/arch/arm/mach-tegra/powergate.c b/arch/arm/mach-tegra/powergate.c
index 2cc1185..c6bc8f8 100644
--- a/arch/arm/mach-tegra/powergate.c
+++ b/arch/arm/mach-tegra/powergate.c
@@ -26,8 +26,8 @@
 #include <linux/io.h>
 #include <linux/seq_file.h>
 #include <linux/spinlock.h>
+#include <linux/clk/tegra.h>
 
-#include <mach/clk.h>
 #include <mach/powergate.h>
 
 #include "fuse.h"
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
diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index c39e61b..afc9b89 100644
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
diff --git a/drivers/gpu/drm/tegra/dc.c b/drivers/gpu/drm/tegra/dc.c
index 0744103..cd2f8fa 100644
--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -12,8 +12,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
-
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #include "drm.h"
 #include "dc.h"
diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 3a503c9..d980dc7 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -11,7 +11,6 @@
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
 
-#include <mach/clk.h>
 #include <linux/dma-mapping.h>
 #include <asm/dma-iommu.h>
 
diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index ab40164..2f39d3b 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -14,8 +14,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
-
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #include "hdmi.h"
 #include "drm.h"
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 7b38877..c7aca35 100644
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
index c76f968..54ac1dc 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -30,7 +30,7 @@
 #include <linux/clk.h>
 #include <linux/slab.h>
 #include <linux/input/tegra_kbc.h>
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #define KBC_MAX_DEBOUNCE_CNT	0x3ffu
 
diff --git a/drivers/spi/spi-tegra20-sflash.c b/drivers/spi/spi-tegra20-sflash.c
index 448a8cc..02feaa5 100644
--- a/drivers/spi/spi-tegra20-sflash.c
+++ b/drivers/spi/spi-tegra20-sflash.c
@@ -34,7 +34,7 @@
 #include <linux/of_device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi-tegra.h>
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #define SPI_COMMAND				0x000
 #define SPI_GO					BIT(30)
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index 651167f..fa208a5 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -35,7 +35,7 @@
 #include <linux/of_device.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/spi-tegra.h>
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #define SLINK_COMMAND			0x000
 #define SLINK_BIT_LENGTH(x)		(((x) & 0x1f) << 0)
diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
index 2830946..d51615b 100644
--- a/drivers/staging/nvec/nvec.c
+++ b/drivers/staging/nvec/nvec.c
@@ -37,8 +37,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
-
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 
 #include "nvec.h"
 
diff --git a/include/linux/clk/tegra.h b/include/linux/clk/tegra.h
index a97e241..722a972 100644
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
@@ -121,5 +123,7 @@ static inline void tegra_cpu_clock_resume(void)
 void tegra_dt_init_clk(void);
 void tegra20_cpu_car_ops_init(void);
 void tegra30_cpu_car_ops_init(void);
+void tegra_periph_reset_deassert(struct clk *c);
+void tegra_periph_reset_assert(struct clk *c);
 
 #endif /* __LINUX_CLK_TEGRA_H_ */
diff --git a/sound/soc/tegra/tegra30_ahub.c b/sound/soc/tegra/tegra30_ahub.c
index f354dc3..bb31c41 100644
--- a/sound/soc/tegra/tegra30_ahub.c
+++ b/sound/soc/tegra/tegra30_ahub.c
@@ -25,7 +25,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
-#include <mach/clk.h>
+#include <linux/clk/tegra.h>
 #include <sound/soc.h>
 #include "tegra30_ahub.h"
 
-- 
1.7.4.1

