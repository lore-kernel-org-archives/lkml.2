Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2FLOmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:42:18 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54900 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2FLOmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:42:15 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@secretlab.ca>, mturquette@linaro.org,
        sboyd@codeaurora.org, skannan@codeaurora.org, shawn.guo@linaro.org,
        s.hauer@pengutronix.de, Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH v3 4/4] clk: add highbank clock support
Date: Tue, 12 Jun 2012 09:41:51 -0500
Message-Id: <1339512111-11172-5-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
References: <1339512111-11172-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adds real clock support to Calxeda Highbank SOC using the common
clock infrastructure.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 .../devicetree/bindings/clock/calxeda.txt          |   17 +
 arch/arm/Kconfig                                   |    1 +
 arch/arm/boot/dts/highbank.dts                     |   91 +++++-
 arch/arm/mach-highbank/Makefile                    |    2 +-
 arch/arm/mach-highbank/clock.c                     |   62 ----
 arch/arm/mach-highbank/highbank.c                  |    7 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-highbank.c                         |  345 ++++++++++++++++++++
 8 files changed, 462 insertions(+), 64 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/calxeda.txt
 delete mode 100644 arch/arm/mach-highbank/clock.c
 create mode 100644 drivers/clk/clk-highbank.c

diff --git a/Documentation/devicetree/bindings/clock/calxeda.txt b/Documentation/devicetree/bindings/clock/calxeda.txt
new file mode 100644
index 0000000..0a6ac1b
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/calxeda.txt
@@ -0,0 +1,17 @@
+Device Tree Clock bindings for Calxeda highbank platform
+
+This binding uses the common clock binding[1].
+
+[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : shall be one of the following:
+	"calxeda,hb-pll-clock" - for a PLL clock
+	"calxeda,hb-a9periph-clock" - The A9 peripheral clock divided from the
+		A9 clock.
+	"calxeda,hb-a9bus-clock" - The A9 bus clock divided from the A9 clock.
+	"calxeda,hb-emmc-clock" - Divided clock for MMC/SD controller.
+- reg : shall be the control register offset from SYSREGs base for the clock.
+- clocks : shall be the input parent clock phandle for the clock. This is
+	either an oscillator or a pll output.
+- #clock-cells : from common clock binding; shall be set to 0.
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 84449dd..00ce396 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -348,6 +348,7 @@ config ARCH_HIGHBANK
 	select ARM_TIMER_SP804
 	select CACHE_L2X0
 	select CLKDEV_LOOKUP
+	select COMMON_CLK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU
diff --git a/arch/arm/boot/dts/highbank.dts b/arch/arm/boot/dts/highbank.dts
index 83e7229..2e1cfa0 100644
--- a/arch/arm/boot/dts/highbank.dts
+++ b/arch/arm/boot/dts/highbank.dts
@@ -1,5 +1,5 @@
 /*
- * Copyright 2011 Calxeda, Inc.
+ * Copyright 2011-2012 Calxeda, Inc.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -24,6 +24,7 @@
 	compatible = "calxeda,highbank";
 	#address-cells = <1>;
 	#size-cells = <1>;
+	clock-ranges;
 
 	cpus {
 		#address-cells = <1>;
@@ -33,24 +34,32 @@
 			compatible = "arm,cortex-a9";
 			reg = <0>;
 			next-level-cache = <&L2>;
+			clocks = <&a9pll>;
+			clock-names = "cpu";
 		};
 
 		cpu@1 {
 			compatible = "arm,cortex-a9";
 			reg = <1>;
 			next-level-cache = <&L2>;
+			clocks = <&a9pll>;
+			clock-names = "cpu";
 		};
 
 		cpu@2 {
 			compatible = "arm,cortex-a9";
 			reg = <2>;
 			next-level-cache = <&L2>;
+			clocks = <&a9pll>;
+			clock-names = "cpu";
 		};
 
 		cpu@3 {
 			compatible = "arm,cortex-a9";
 			reg = <3>;
 			next-level-cache = <&L2>;
+			clocks = <&a9pll>;
+			clock-names = "cpu";
 		};
 	};
 
@@ -75,12 +84,14 @@
 			compatible = "arm,cortex-a9-twd-timer";
 			reg = <0xfff10600 0x20>;
 			interrupts = <1 13 0xf01>;
+			clocks = <&a9periphclk>;
 		};
 
 		watchdog@fff10620 {
 			compatible = "arm,cortex-a9-twd-wdt";
 			reg = <0xfff10620 0x20>;
 			interrupts = <1 14 0xf01>;
+			clocks = <&a9periphclk>;
 		};
 
 		intc: interrupt-controller@fff11000 {
@@ -116,12 +127,15 @@
 			compatible = "calxeda,hb-sdhci";
 			reg = <0xffe0e000 0x1000>;
 			interrupts = <0 90 4>;
+			clocks = <&eclk>;
 		};
 
 		ipc@fff20000 {
 			compatible = "arm,pl320", "arm,primecell";
 			reg = <0xfff20000 0x1000>;
 			interrupts = <0 7 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		gpioe: gpio@fff30000 {
@@ -130,6 +144,8 @@
 			gpio-controller;
 			reg = <0xfff30000 0x1000>;
 			interrupts = <0 14 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		gpiof: gpio@fff31000 {
@@ -138,6 +154,8 @@
 			gpio-controller;
 			reg = <0xfff31000 0x1000>;
 			interrupts = <0 15 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		gpiog: gpio@fff32000 {
@@ -146,6 +164,8 @@
 			gpio-controller;
 			reg = <0xfff32000 0x1000>;
 			interrupts = <0 16 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		gpioh: gpio@fff33000 {
@@ -154,24 +174,32 @@
 			gpio-controller;
 			reg = <0xfff33000 0x1000>;
 			interrupts = <0 17 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		timer {
 			compatible = "arm,sp804", "arm,primecell";
 			reg = <0xfff34000 0x1000>;
 			interrupts = <0 18 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		rtc@fff35000 {
 			compatible = "arm,pl031", "arm,primecell";
 			reg = <0xfff35000 0x1000>;
 			interrupts = <0 19 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		serial@fff36000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0xfff36000 0x1000>;
 			interrupts = <0 20 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		smic@fff3a000 {
@@ -186,12 +214,73 @@
 		sregs@fff3c000 {
 			compatible = "calxeda,hb-sregs";
 			reg = <0xfff3c000 0x1000>;
+
+			clocks {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				osc: oscillator {
+					#clock-cells = <0>;
+					compatible = "fixed-clock";
+					clock-frequency = <33333000>;
+				};
+
+				ddrpll: ddrpll {
+					#clock-cells = <0>;
+					compatible = "calxeda,hb-pll-clock";
+					clocks = <&osc>;
+					reg = <0x108>;
+				};
+
+				a9pll: a9pll {
+					#clock-cells = <0>;
+					compatible = "calxeda,hb-pll-clock";
+					clocks = <&osc>;
+					reg = <0x100>;
+				};
+
+				a9periphclk: a9periphclk {
+					#clock-cells = <0>;
+					compatible = "calxeda,hb-a9periph-clock";
+					clocks = <&a9pll>;
+					reg = <0x104>;
+				};
+
+				a9bclk: a9bclk {
+					#clock-cells = <0>;
+					compatible = "calxeda,hb-a9bus-clock";
+					clocks = <&a9pll>;
+					reg = <0x104>;
+				};
+
+				emmcpll: emmcpll {
+					#clock-cells = <0>;
+					compatible = "calxeda,hb-pll-clock";
+					clocks = <&osc>;
+					reg = <0x10C>;
+				};
+
+				eclk: eclk {
+					#clock-cells = <0>;
+					compatible = "calxeda,hb-emmc-clock";
+					clocks = <&emmcpll>;
+					reg = <0x114>;
+				};
+
+				pclk: pclk {
+					#clock-cells = <0>;
+					compatible = "fixed-clock";
+					clock-frequency = <150000000>;
+				};
+			};
 		};
 
 		dma@fff3d000 {
 			compatible = "arm,pl330", "arm,primecell";
 			reg = <0xfff3d000 0x1000>;
 			interrupts = <0 92 4>;
+			clocks = <&pclk>;
+			clock-names = "apb_pclk";
 		};
 
 		ethernet@fff50000 {
diff --git a/arch/arm/mach-highbank/Makefile b/arch/arm/mach-highbank/Makefile
index f8437dd..6ca6afa 100644
--- a/arch/arm/mach-highbank/Makefile
+++ b/arch/arm/mach-highbank/Makefile
@@ -1,4 +1,4 @@
-obj-y					:= clock.o highbank.o system.o
+obj-y					:= highbank.o system.o
 obj-$(CONFIG_DEBUG_HIGHBANK_UART)	+= lluart.o
 obj-$(CONFIG_SMP)			+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= hotplug.o
diff --git a/arch/arm/mach-highbank/clock.c b/arch/arm/mach-highbank/clock.c
deleted file mode 100644
index c25a2ae..0000000
--- a/arch/arm/mach-highbank/clock.c
+++ /dev/null
@@ -1,62 +0,0 @@
-/*
- * Copyright 2011 Calxeda, Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/clk.h>
-#include <linux/clkdev.h>
-
-struct clk {
-	unsigned long rate;
-};
-
-int clk_enable(struct clk *clk)
-{
-	return 0;
-}
-
-void clk_disable(struct clk *clk)
-{}
-
-unsigned long clk_get_rate(struct clk *clk)
-{
-	return clk->rate;
-}
-
-long clk_round_rate(struct clk *clk, unsigned long rate)
-{
-	return clk->rate;
-}
-
-int clk_set_rate(struct clk *clk, unsigned long rate)
-{
-	return 0;
-}
-
-static struct clk eclk = { .rate = 200000000 };
-static struct clk pclk = { .rate = 150000000 };
-
-static struct clk_lookup lookups[] = {
-	{ .clk = &pclk, .con_id = "apb_pclk", },
-	{ .clk = &pclk, .dev_id = "sp804", },
-	{ .clk = &eclk, .dev_id = "ffe0e000.sdhci", },
-	{ .clk = &pclk, .dev_id = "fff36000.serial", },
-};
-
-void __init highbank_clocks_init(void)
-{
-	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
-}
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 410a112..ce72d78 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -91,6 +91,11 @@ static void __init highbank_init_irq(void)
 	l2x0_of_init(0, ~0UL);
 }
 
+static struct clk_lookup lookup = {
+	.dev_id = "sp804",
+	.con_id = NULL,
+};
+
 static void __init highbank_timer_init(void)
 {
 	int irq;
@@ -108,6 +113,8 @@ static void __init highbank_timer_init(void)
 	irq = irq_of_parse_and_map(np, 0);
 
 	highbank_clocks_init();
+	lookup.clk = of_clk_get(np, 0);
+	clkdev_add(&lookup);
 
 	sp804_clocksource_and_sched_clock_init(timer_base + 0x20, "timer1");
 	sp804_clockevents_init(timer_base, irq, "timer0");
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index b9a5158..ce384f3 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -3,5 +3,6 @@ obj-$(CONFIG_CLKDEV_LOOKUP)	+= clkdev.o
 obj-$(CONFIG_COMMON_CLK)	+= clk.o clk-fixed-rate.o clk-gate.o \
 				   clk-mux.o clk-divider.o clk-fixed-factor.o
 # SoCs specific
+obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
 obj-$(CONFIG_ARCH_MXS)		+= mxs/
 obj-$(CONFIG_PLAT_SPEAR)	+= spear/
diff --git a/drivers/clk/clk-highbank.c b/drivers/clk/clk-highbank.c
new file mode 100644
index 0000000..2f61065
--- /dev/null
+++ b/drivers/clk/clk-highbank.c
@@ -0,0 +1,345 @@
+/*
+ * Copyright 2011-2012 Calxeda, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/clk-provider.h>
+#include <linux/io.h>
+#include <linux/of.h>
+
+extern void __iomem *sregs_base;
+
+#define HB_PLL_LOCK_500		0x20000000
+#define HB_PLL_LOCK		0x10000000
+#define HB_PLL_DIVF_SHIFT	20
+#define HB_PLL_DIVF_MASK	0x0ff00000
+#define HB_PLL_DIVQ_SHIFT	16
+#define HB_PLL_DIVQ_MASK	0x00070000
+#define HB_PLL_DIVR_SHIFT	8
+#define HB_PLL_DIVR_MASK	0x00001f00
+#define HB_PLL_RANGE_SHIFT	4
+#define HB_PLL_RANGE_MASK	0x00000070
+#define HB_PLL_BYPASS		0x00000008
+#define HB_PLL_RESET		0x00000004
+#define HB_PLL_EXT_BYPASS	0x00000002
+#define HB_PLL_EXT_ENA		0x00000001
+
+#define HB_PLL_VCO_MIN_FREQ	2133000000
+#define HB_PLL_MAX_FREQ		HB_PLL_VCO_MIN_FREQ
+#define HB_PLL_MIN_FREQ		(HB_PLL_VCO_MIN_FREQ / 64)
+
+#define HB_A9_BCLK_DIV_MASK	0x00000006
+#define HB_A9_BCLK_DIV_SHIFT	1
+#define HB_A9_PCLK_DIV		0x00000001
+
+struct hb_clk {
+        struct clk_hw	hw;
+	void __iomem	*reg;
+	char *parent_name;
+};
+#define to_hb_clk(p) container_of(p, struct hb_clk, hw)
+
+static int clk_pll_prepare(struct clk_hw *hwclk)
+	{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 reg;
+
+	reg = readl(hbclk->reg);
+	reg &= ~HB_PLL_RESET;
+	writel(reg, hbclk->reg);
+
+	while ((readl(hbclk->reg) & HB_PLL_LOCK) == 0)
+		;
+	while ((readl(hbclk->reg) & HB_PLL_LOCK_500) == 0)
+		;
+
+	return 0;
+}
+
+static void clk_pll_unprepare(struct clk_hw *hwclk)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 reg;
+
+	reg = readl(hbclk->reg);
+	reg |= HB_PLL_RESET;
+	writel(reg, hbclk->reg);
+}
+
+static int clk_pll_enable(struct clk_hw *hwclk)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 reg;
+
+	reg = readl(hbclk->reg);
+	reg |= HB_PLL_EXT_ENA;
+	writel(reg, hbclk->reg);
+
+	return 0;
+}
+
+static void clk_pll_disable(struct clk_hw *hwclk)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 reg;
+
+	reg = readl(hbclk->reg);
+	reg &= ~HB_PLL_EXT_ENA;
+	writel(reg, hbclk->reg);
+}
+
+static unsigned long clk_pll_recalc_rate(struct clk_hw *hwclk,
+					 unsigned long parent_rate)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	unsigned long divf, divq, vco_freq, reg;
+
+	reg = readl(hbclk->reg);
+	if (reg & HB_PLL_EXT_BYPASS)
+		return parent_rate;
+
+	divf = (reg & HB_PLL_DIVF_MASK) >> HB_PLL_DIVF_SHIFT;
+	divq = (reg & HB_PLL_DIVQ_MASK) >> HB_PLL_DIVQ_SHIFT;
+	vco_freq = parent_rate * (divf + 1);
+
+	return vco_freq / (1 << divq);
+}
+
+static void clk_pll_calc(unsigned long rate, unsigned long ref_freq,
+			u32 *pdivq, u32 *pdivf)
+{
+	u32 divq, divf;
+	unsigned long vco_freq;
+
+	if (rate < HB_PLL_MIN_FREQ)
+		rate = HB_PLL_MIN_FREQ;
+	if (rate > HB_PLL_MAX_FREQ)
+		rate = HB_PLL_MAX_FREQ;
+
+	for (divq = 1; divq <= 6; divq++) {
+		if ((rate * (1 << divq)) >= HB_PLL_VCO_MIN_FREQ)
+			break;
+	}
+
+	vco_freq = rate * (1 << divq);
+	divf = (vco_freq + (ref_freq / 2)) / ref_freq;
+	divf--;
+
+	*pdivq = divq;
+	*pdivf = divf;
+}
+
+static long clk_pll_round_rate(struct clk_hw *hwclk, unsigned long rate,
+			       unsigned long *parent_rate)
+{
+	u32 divq, divf;
+	unsigned long ref_freq = *parent_rate;
+
+	clk_pll_calc(rate, ref_freq, &divq, &divf);
+
+	return (ref_freq * (divf + 1)) / (1 << divq);
+}
+
+static int clk_pll_set_rate(struct clk_hw *hwclk, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 divq, divf;
+	u32 reg;
+
+	clk_pll_calc(rate, parent_rate, &divq, &divf);
+
+	reg = readl(hbclk->reg);
+	if (divf != ((reg & HB_PLL_DIVF_MASK) >> HB_PLL_DIVF_SHIFT)) {
+		/* Need to re-lock PLL, so put it into bypass mode */
+		reg |= HB_PLL_EXT_BYPASS;
+		writel(reg | HB_PLL_EXT_BYPASS, hbclk->reg);
+
+		writel(reg | HB_PLL_RESET, hbclk->reg);
+		reg &= ~(HB_PLL_DIVF_MASK | HB_PLL_DIVQ_MASK);
+		reg |= (divf << HB_PLL_DIVF_SHIFT) | (divq << HB_PLL_DIVQ_SHIFT);
+		writel(reg | HB_PLL_RESET, hbclk->reg);
+		writel(reg, hbclk->reg);
+
+		while ((readl(hbclk->reg) & HB_PLL_LOCK) == 0)
+			;
+		while ((readl(hbclk->reg) & HB_PLL_LOCK_500) == 0)
+			;
+		reg |= HB_PLL_EXT_ENA;
+		reg &= ~HB_PLL_EXT_BYPASS;
+	} else {
+		reg &= ~HB_PLL_DIVQ_MASK;
+		reg |= divq << HB_PLL_DIVQ_SHIFT;
+	}
+	writel(reg, hbclk->reg);
+
+	return 0;
+}
+
+static const struct clk_ops clk_pll_ops = {
+	.prepare = clk_pll_prepare,
+	.unprepare = clk_pll_unprepare,
+	.enable = clk_pll_enable,
+	.disable = clk_pll_disable,
+	.recalc_rate = clk_pll_recalc_rate,
+	.round_rate = clk_pll_round_rate,
+	.set_rate = clk_pll_set_rate,
+};
+
+static unsigned long clk_cpu_periphclk_recalc_rate(struct clk_hw *hwclk,
+						   unsigned long parent_rate)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 div = (readl(hbclk->reg) & HB_A9_PCLK_DIV) ? 8 : 4;
+	return parent_rate / div;
+}
+
+static const struct clk_ops a9periphclk_ops = {
+	.recalc_rate = clk_cpu_periphclk_recalc_rate,
+};
+
+static unsigned long clk_cpu_a9bclk_recalc_rate(struct clk_hw *hwclk,
+						unsigned long parent_rate)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 div = (readl(hbclk->reg) & HB_A9_BCLK_DIV_MASK) >> HB_A9_BCLK_DIV_SHIFT;
+
+	return parent_rate / (div + 2);
+}
+
+static const struct clk_ops a9bclk_ops = {
+	.recalc_rate = clk_cpu_a9bclk_recalc_rate,
+};
+
+static unsigned long clk_periclk_recalc_rate(struct clk_hw *hwclk,
+					     unsigned long parent_rate)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 div;
+
+	div = readl(hbclk->reg) & 0x1f;
+	div++;
+	div *= 2;
+
+	return parent_rate / div;
+}
+
+static long clk_periclk_round_rate(struct clk_hw *hwclk, unsigned long rate,
+				   unsigned long *parent_rate)
+{
+	u32 div;
+
+	div = *parent_rate / rate;
+	div++;
+	div &= ~0x1;
+
+	return *parent_rate / div;
+}
+
+static int clk_periclk_set_rate(struct clk_hw *hwclk, unsigned long rate,
+				unsigned long parent_rate)
+{
+	struct hb_clk *hbclk = to_hb_clk(hwclk);
+	u32 div;
+
+	div = parent_rate / rate;
+	if (div & 0x1)
+		return -EINVAL;
+
+	writel(div >> 1, hbclk->reg);
+	return 0;
+}
+
+static const struct clk_ops periclk_ops = {
+	.recalc_rate = clk_periclk_recalc_rate,
+	.round_rate = clk_periclk_round_rate,
+	.set_rate = clk_periclk_set_rate,
+};
+
+static __init struct clk *hb_clk_init(struct device_node *node, const struct clk_ops *ops)
+{
+	u32 reg;
+	struct clk *clk;
+	struct hb_clk *hb_clk;
+	const char *clk_name = node->name;
+	const char *parent_name;
+	struct clk_init_data init_data;
+	int rc;
+
+	rc = of_property_read_u32(node, "reg", &reg);
+	if (WARN_ON(rc))
+		return NULL;
+
+	hb_clk = kzalloc(sizeof(*hb_clk), GFP_KERNEL);
+	if (WARN_ON(!hb_clk))
+		return NULL;
+
+	hb_clk->reg = sregs_base + reg;
+
+	of_property_read_string(node, "clock-output-names", &clk_name);
+
+	hb_clk->hw.init = &init_data;
+	hb_clk->hw.init->name = clk_name;
+	hb_clk->hw.init->num_parents = 1;
+	parent_name = of_clk_get_parent_name(node, 0);
+	hb_clk->hw.init->parent_names = &parent_name;
+	hb_clk->hw.init->ops = ops;
+	hb_clk->hw.init->flags = 0;
+
+	clk = clk_register(NULL, &hb_clk->hw);
+	if (WARN_ON(IS_ERR(clk))) {
+		kfree(hb_clk);
+		return NULL;
+	}
+	rc = of_clk_add_provider(node, of_clk_src_simple_get, clk);
+	return clk;
+}
+
+static void __init hb_pll_init(struct device_node *node)
+{
+	hb_clk_init(node, &clk_pll_ops);
+}
+
+static void __init hb_a9periph_init(struct device_node *node)
+{
+	hb_clk_init(node, &a9periphclk_ops);
+}
+
+static void __init hb_a9bus_init(struct device_node *node)
+{
+	struct clk *clk = hb_clk_init(node, &a9bclk_ops);
+	clk_prepare_enable(clk);
+}
+
+static void __init hb_emmc_init(struct device_node *node)
+{
+	hb_clk_init(node, &periclk_ops);
+}
+
+static const __initconst struct of_device_id clk_match[] = {
+	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
+	{ .compatible = "calxeda,hb-pll-clock", .data = hb_pll_init, },
+	{ .compatible = "calxeda,hb-a9periph-clock", .data = hb_a9periph_init, },
+	{ .compatible = "calxeda,hb-a9bus-clock", .data = hb_a9bus_init, },
+	{ .compatible = "calxeda,hb-emmc-clock", .data = hb_emmc_init, },
+	{}
+};
+
+void __init highbank_clocks_init(void)
+{
+	of_clk_init(clk_match);
+}
-- 
1.7.9.5

