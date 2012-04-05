Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2DEJbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:31:36 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59481 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab2DEJbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:31:35 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: <davinci-linux-open-source@linux.davincidsp.com>
CC: <nsekhar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: [PATCH v2] arm: da850: change ASYNC/PLL0_SYSCLK3 clock rate with DVFS
Date: Thu, 5 Apr 2012 14:43:52 +0530
Message-ID: <1333617232-27967-1-git-send-email-prakash.pm@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clock for EMIF is derived from ASYNC clock domain(PLL0_SYSCLK3) and was
configured with fixed divider as there was no significant performance
degradation with existing NAND/NOR EMIF devices if it is not
reconfigured accordingly at different OPPs.

On systems where devices other than NAND/NOR are interfaced through
EMIF, such performance degradation may not be desirable. So change the
PLL0_SYSCLK3 output frequency for different OPPs by re-configuring
the divider value.

Also add Kconfig option to support platforms requiring fixed EMIF clock
rate.

Configured values are as per rates specified in OMAP-L138 Data sheet
(http://www.ti.com/lit/ds/symlink/omap-l138.pdf, Table 5-5).

Patch addresses concerns raised in below thread of Linux-DaVinci-community:
http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg22535.html

Signed-off-by: Manjunathappa, Prakash <prakash.pm@ti.com>
---
Since v1:
Have option to configure fixed EMIF clock rate via Kconfig option.

 arch/arm/mach-davinci/Kconfig                |    9 ++++++
 arch/arm/mach-davinci/board-da850-evm.c      |   22 ++++++++++++++++
 arch/arm/mach-davinci/cpufreq.c              |    2 +-
 arch/arm/mach-davinci/da850.c                |   36 ++++++++++++++++++++++++-
 arch/arm/mach-davinci/include/mach/cpufreq.h |    1 +
 5 files changed, 67 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index 32d837d..0a2fb6c 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -192,6 +192,15 @@ config DA850_UI_RMII
 
 endchoice
 
+config DA850_FIX_PLL0_SYSCLK3RATE
+	int "PLL0_SYSCLK3 rate"
+	depends on ARCH_DAVINCI_DA850
+	range 0 148000000
+	default 0
+	help
+	  Set this value with desired EMIF clock rate, Otherwise EMIF clock
+          rate is decided based on OPP value.
+
 config DA850_WL12XX
 	bool "AM18x wl1271 daughter board"
 	depends on MACH_DAVINCI_DA850_EVM
diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index a70de24..1fb3050 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -13,6 +13,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/console.h>
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
@@ -1253,6 +1254,17 @@ static __init int da850_wl12xx_init(void)
 
 #endif /* CONFIG_DA850_WL12XX */
 
+static __init int da850_set_emif_clk_rate(void)
+{
+	struct clk *emif_clk;
+
+	emif_clk = clk_get(NULL, "pll0_sysclk3");
+	if (WARN(IS_ERR(emif_clk), "Unable to get emif clock\n"))
+		return PTR_ERR(emif_clk);
+
+	return clk_set_rate(emif_clk, CONFIG_DA850_FIX_PLL0_SYSCLK3RATE);
+}
+
 #define DA850EVM_SATA_REFCLKPN_RATE	(100 * 1000 * 1000)
 
 static __init void da850_evm_init(void)
@@ -1264,6 +1276,16 @@ static __init void da850_evm_init(void)
 		pr_warning("da850_evm_init: TPS65070 PMIC init failed: %d\n",
 				ret);
 
+	/*
+	 * Though bootloader takes care to set emif clock at allowed
+	 * possible rate. Kernel needs to reconfigure this rate to
+	 * support platforms requiring fixed emif clock rate.
+	 */
+	ret = da850_set_emif_clk_rate();
+	if (ret)
+		pr_warning("da850_evm_init: Failed to set rate of pll0_sysclk3/emif clock: %d\n",
+				ret);
+
 	ret = da850_register_edma(da850_edma_rsv);
 	if (ret)
 		pr_warning("da850_evm_init: edma registration failed: %d\n",
diff --git a/arch/arm/mach-davinci/cpufreq.c b/arch/arm/mach-davinci/cpufreq.c
index 031048f..1f14cbe 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/arch/arm/mach-davinci/cpufreq.c
@@ -216,7 +216,7 @@ static int __init davinci_cpufreq_probe(struct platform_device *pdev)
 	asyncclk = clk_get(cpufreq.dev, "async");
 	if (!IS_ERR(asyncclk)) {
 		cpufreq.asyncclk = asyncclk;
-		cpufreq.asyncrate = clk_get_rate(asyncclk);
+		cpufreq.asyncrate = pdata->emif_rate;
 	}
 
 	return cpufreq_register_driver(&davinci_driver);
diff --git a/arch/arm/mach-davinci/da850.c b/arch/arm/mach-davinci/da850.c
index b44dc84..692203c 100644
--- a/arch/arm/mach-davinci/da850.c
+++ b/arch/arm/mach-davinci/da850.c
@@ -49,6 +49,7 @@
 static int da850_set_armrate(struct clk *clk, unsigned long rate);
 static int da850_round_armrate(struct clk *clk, unsigned long rate);
 static int da850_set_pll0rate(struct clk *clk, unsigned long armrate);
+static int da850_set_pll0sysclk3_rate(struct clk *clk, unsigned long rate);
 
 static struct pll_data pll0_data = {
 	.num		= 1,
@@ -88,8 +89,8 @@ static struct clk pll0_sysclk3 = {
 	.parent		= &pll0_clk,
 	.flags		= CLK_PLL,
 	.div_reg	= PLLDIV3,
-	.set_rate	= davinci_set_sysclk_rate,
-	.maxrate	= 100000000,
+	.set_rate	= da850_set_pll0sysclk3_rate,
+	.maxrate	= 148000000,
 };
 
 static struct clk pll0_sysclk4 = {
@@ -799,6 +800,36 @@ static void da850_set_async3_src(int pllnum)
 	__raw_writel(v, DA8XX_SYSCFG0_VIRT(DA8XX_CFGCHIP3_REG));
 }
 
+static int da850_set_pll0sysclk3_rate(struct clk *clk, unsigned long rate)
+{
+	struct clk *arm_clk;
+	unsigned long sys_clk3_rate = 148000000;
+	int ret;
+
+	arm_clk = clk_get(NULL, "arm");
+	if (WARN(IS_ERR(arm_clk), "Unable to get ARM clock\n"))
+		return PTR_ERR(arm_clk);
+
+	/* Set EMIF clock based on OPPs */
+	switch (clk_get_rate(arm_clk)) {
+	case 200000000:
+		sys_clk3_rate = 75000000;
+		break;
+	case 96000000:
+		sys_clk3_rate = 50000000;
+		break;
+	}
+
+	if (rate)
+		sys_clk3_rate = min(sys_clk3_rate, rate);
+
+	ret = davinci_set_sysclk_rate(clk, sys_clk3_rate);
+	if (WARN_ON(ret))
+		return ret;
+
+	return 0;
+}
+
 #ifdef CONFIG_CPU_FREQ
 /*
  * Notes:
@@ -900,6 +931,7 @@ static struct davinci_cpufreq_config cpufreq_info = {
 	.init = da850_regulator_init,
 	.set_voltage = da850_set_voltage,
 #endif
+	.emif_rate = CONFIG_DA850_FIX_PLL0_SYSCLK3RATE,
 };
 
 #ifdef CONFIG_REGULATOR
diff --git a/arch/arm/mach-davinci/include/mach/cpufreq.h b/arch/arm/mach-davinci/include/mach/cpufreq.h
index 3c089cf..3f58b71 100644
--- a/arch/arm/mach-davinci/include/mach/cpufreq.h
+++ b/arch/arm/mach-davinci/include/mach/cpufreq.h
@@ -21,6 +21,7 @@ struct davinci_cpufreq_config {
 	struct cpufreq_frequency_table *freq_table;
 	int (*set_voltage) (unsigned int index);
 	int (*init) (void);
+	unsigned int emif_rate;
 };
 
 #endif
-- 
1.7.1

