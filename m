Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab2JaXNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:13:36 -0400
Received: from mailserver5.natinst.com ([130.164.80.5]:57376 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760983Ab2JaXM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:12:58 -0400
Message-Id: <94af5ee92c2d68f245eb902de74909aadf159be1.1351721190.git.josh.cartwright@ni.com>
In-Reply-To: <cover.1351721190.git.josh.cartwright@ni.com>
References: <cover.1351721190.git.josh.cartwright@ni.com>
From: Josh Cartwright <josh.cartwright@ni.com>
Date: Wed, 31 Oct 2012 12:58:52 -0600
Subject: [PATCH 5/8] ARM: zynq: add COMMON_CLK support
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:27 PM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 10/31/2012 06:12:27 PM,
	Serialize complete at 10/31/2012 06:12:27 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-10-31_03:2012-10-31,2012-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for COMMON_CLK, and provide simplified models for the
necessary clocks on the zynq-7000.  Currently, the PLLs, the CPU clock
network, and the basic peripheral clock networks (for SDIO, SMC, SPI,
QSPI, UART) are modelled.

Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
---
 .../devicetree/bindings/clock/zynq-7000.txt        |  55 ++++
 arch/arm/Kconfig                                   |   1 +
 arch/arm/boot/dts/zynq-7000.dtsi                   |  56 ++++
 arch/arm/boot/dts/zynq-zc702.dts                   |   4 +
 arch/arm/mach-zynq/common.c                        |  11 +
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-zynq.c                             | 355 +++++++++++++++++++++
 include/linux/clk/zynq.h                           |  24 ++
 8 files changed, 507 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/zynq-7000.txt
 create mode 100644 drivers/clk/clk-zynq.c
 create mode 100644 include/linux/clk/zynq.h

diff --git a/Documentation/devicetree/bindings/clock/zynq-7000.txt b/Documentation/devicetree/bindings/clock/zynq-7000.txt
new file mode 100644
index 0000000..2e21fc1
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/zynq-7000.txt
@@ -0,0 +1,55 @@
+Device Tree Clock bindings for the Zynq 7000 EPP
+
+The Zynq EPP has several different clk providers, each with there own bindings.
+The purpose of this document is to document their usage.
+
+See clock_bindings.txt for more information on the generic clock bindings.
+See Chapter 25 of Zynq TRM for more information about Zynq clocks.
+
+== PLLs ==
+
+Used to describe the ARM_PLL, DDR_PLL, and IO_PLL.
+
+Required properties:
+- #clock-cells : shall be 0 (only one clock is output from this node)
+- compatible : "xlnx,zynq-pll"
+- reg : pair of u32 values, which are the address offsets within the SLCR
+        of the relevant PLL_CTRL register and PLL_CFG register respectively
+- clocks : phandle for parent clock.  should be the phandle for ps_clk
+
+Optional properties:
+- clock-output-names : name of the output clock
+
+Example:
+	armpll: armpll {
+		#clock-cells = <0>;
+		compatible = "xlnx,zynq-pll";
+		clocks = <&ps_clk>;
+		reg = <0x100 0x110>;
+		clock-output-names = "armpll";
+	};
+
+== Peripheral clocks ==
+
+Describes clock node for the SDIO, SMC, SPI, QSPI, and UART clocks.
+
+Required properties:
+- #clock-cells : shall be 1
+- compatible : "xlnx,zynq-periph-clock"
+- reg : a single u32 value, describing the offset within the SLCR where
+        the CLK_CTRL register is found for this peripheral
+- clocks : phandle for parent clocks.  should hold phandles for
+           the IO_PLL, ARM_PLL, and DDR_PLL in order
+
+Optional properties:
+- clock-output-names : name of the output clock
+
+Example:
+	uart_clk: uart_clk {
+		#clock-cells = <1>;
+		compatible = "xlnx,zynq-periph-clock";
+		clocks = <&iopll &armpll &ddrpll>;
+		reg = <0x154>;
+		clock-output-names = "uart0_ref_clk",
+				     "uart1_ref_clk";
+	};
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 21ed87b..ccfe0ab 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -959,6 +959,7 @@ config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform"
 	select ARM_AMBA
 	select ARM_GIC
+	select COMMON_CLK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select ICST
diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index 8b30e59..bb3085c 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -53,5 +53,61 @@
 			interrupts = <0 50 4>;
 			clock = <50000000>;
 		};
+
+		slcr: slcr@f8000000 {
+			compatible = "xlnx,zynq-slcr";
+			reg = <0xF8000000 0x1000>;
+
+			clocks {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				ps_clk: ps_clk {
+					#clock-cells = <0>;
+					compatible = "fixed-clock";
+					/* clock-frequency set in board-specific file */
+					clock-output-names = "ps_clk";
+				};
+				armpll: armpll {
+					#clock-cells = <0>;
+					compatible = "xlnx,zynq-pll";
+					clocks = <&ps_clk>;
+					reg = <0x100 0x110>;
+					clock-output-names = "armpll";
+				};
+				ddrpll: ddrpll {
+					#clock-cells = <0>;
+					compatible = "xlnx,zynq-pll";
+					clocks = <&ps_clk>;
+					reg = <0x104 0x114>;
+					clock-output-names = "ddrpll";
+				};
+				iopll: iopll {
+					#clock-cells = <0>;
+					compatible = "xlnx,zynq-pll";
+					clocks = <&ps_clk>;
+					reg = <0x108 0x118>;
+					clock-output-names = "iopll";
+				};
+				uart_clk: uart_clk {
+					#clock-cells = <1>;
+					compatible = "xlnx,zynq-periph-clock";
+					clocks = <&iopll &armpll &ddrpll>;
+					reg = <0x154>;
+					clock-output-names = "uart0_ref_clk",
+							     "uart1_ref_clk";
+				};
+				cpu_clk: cpu_clk {
+					#clock-cells = <1>;
+					compatible = "xlnx,zynq-cpu-clock";
+					clocks = <&iopll &armpll &ddrpll>;
+					reg = <0x120 0x1C4>;
+					clock-output-names = "cpu_6x4x",
+							     "cpu_3x2x",
+							     "cpu_2x",
+							     "cpu_1x";
+				};
+			};
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index e25a307..86f44d5 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -28,3 +28,7 @@
 	};
 
 };
+
+&ps_clk {
+	clock-frequency = <33333330>;
+};
diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 447904b..f0cb3e4 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -19,6 +19,8 @@
 #include <linux/cpumask.h>
 #include <linux/platform_device.h>
 #include <linux/clk.h>
+#include <linux/clk/zynq.h>
+#include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/of.h>
@@ -96,6 +98,15 @@ static struct map_desc io_desc[] __initdata = {
 
 static void __init xilinx_zynq_timer_init(void)
 {
+	struct device_node *np;
+	void __iomem *slcr;
+
+	np = of_find_compatible_node(NULL, NULL, "xlnx,zynq-slcr");
+	slcr = of_iomap(np, 0);
+	WARN_ON(!slcr);
+
+	xilinx_zynq_clocks_init(slcr);
+
 	xttcpss_timer_init();
 }
 
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 71a25b9..d35a34c 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -19,6 +19,7 @@ endif
 obj-$(CONFIG_MACH_LOONGSON1)	+= clk-ls1x.o
 obj-$(CONFIG_ARCH_U8500)	+= ux500/
 obj-$(CONFIG_ARCH_VT8500)	+= clk-vt8500.o
+obj-$(CONFIG_ARCH_ZYNQ)		+= clk-zynq.o
 
 # Chip specific
 obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
diff --git a/drivers/clk/clk-zynq.c b/drivers/clk/clk-zynq.c
new file mode 100644
index 0000000..2afa84d
--- /dev/null
+++ b/drivers/clk/clk-zynq.c
@@ -0,0 +1,355 @@
+/*
+ * Copyright (c) 2012 National Instruments
+ *
+ * Josh Cartwright <josh.cartwright@ni.com>
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
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/clk-provider.h>
+
+static void __iomem *slcr_base;
+
+struct zynq_pll_clk {
+	struct clk_hw	hw;
+	void __iomem	*pll_ctrl;
+	void __iomem	*pll_cfg;
+};
+
+#define to_zynq_pll_clk(hw)	container_of(hw, struct zynq_pll_clk, hw)
+
+#define CTRL_PLL_FDIV(x)	((x)>>12)
+
+static unsigned long zynq_pll_recalc_rate(struct clk_hw *hw,
+					  unsigned long parent_rate)
+{
+	struct zynq_pll_clk *pll = to_zynq_pll_clk(hw);
+	return parent_rate * CTRL_PLL_FDIV(ioread32(pll->pll_ctrl));
+}
+
+static const struct clk_ops zynq_pll_clk_ops = {
+	.recalc_rate	= zynq_pll_recalc_rate,
+};
+
+static void __init zynq_pll_clk_setup(struct device_node *np)
+{
+	struct clk_init_data init;
+	struct zynq_pll_clk *pll;
+	const char *parent_name;
+	struct clk *clk;
+	u32 regs[2];
+	int ret;
+
+	ret = of_property_read_u32_array(np, "reg", regs, ARRAY_SIZE(regs));
+	WARN_ON(ret);
+
+	pll = kzalloc(sizeof(*pll), GFP_KERNEL);
+	WARN_ON(!pll);
+
+	pll->pll_ctrl = slcr_base + regs[0];
+	pll->pll_cfg  = slcr_base + regs[1];
+
+	of_property_read_string(np, "clock-output-names", &init.name);
+
+	init.ops = &zynq_pll_clk_ops;
+	parent_name = of_clk_get_parent_name(np, 0);
+	init.parent_names = &parent_name;
+	init.num_parents = 1;
+
+	pll->hw.init = &init;
+
+	clk = clk_register(NULL, &pll->hw);
+	WARN_ON(IS_ERR(clk));
+
+	ret = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	WARN_ON(ret);
+}
+
+struct zynq_periph_clk {
+	struct clk_hw		hw;
+	struct clk_onecell_data	onecell_data;
+	struct clk		*gates[2];
+	void __iomem		*clk_ctrl;
+	spinlock_t		clkact_lock;
+};
+
+#define to_zynq_periph_clk(hw)	container_of(hw, struct zynq_periph_clk, hw)
+
+static const u8 periph_clk_parent_map[] = {
+	0, 0, 1, 2
+};
+#define PERIPH_CLK_CTRL_SRC(x)	(periph_clk_parent_map[((x)&3)>>4])
+#define PERIPH_CLK_CTRL_DIV(x)	(((x)&0x3F00)>>8)
+
+static unsigned long zynq_periph_recalc_rate(struct clk_hw *hw,
+					     unsigned long parent_rate)
+{
+	struct zynq_periph_clk *periph = to_zynq_periph_clk(hw);
+	return parent_rate / PERIPH_CLK_CTRL_DIV(ioread32(periph->clk_ctrl));
+}
+
+static u8 zynq_periph_get_parent(struct clk_hw *hw)
+{
+	struct zynq_periph_clk *periph = to_zynq_periph_clk(hw);
+	return PERIPH_CLK_CTRL_SRC(ioread32(periph->clk_ctrl));
+}
+
+static const struct clk_ops zynq_periph_clk_ops = {
+	.recalc_rate	= zynq_periph_recalc_rate,
+	.get_parent	= zynq_periph_get_parent,
+};
+
+static void __init zynq_periph_clk_setup(struct device_node *np)
+{
+	struct zynq_periph_clk *periph;
+	const char *parent_names[3];
+	struct clk_init_data init;
+	struct clk *clk;
+	int err;
+	u32 reg;
+	int i;
+
+	err = of_property_read_u32(np, "reg", &reg);
+	WARN_ON(err);
+
+	periph = kzalloc(sizeof(*periph), GFP_KERNEL);
+	WARN_ON(!periph);
+
+	periph->clk_ctrl = slcr_base + reg;
+	spin_lock_init(&periph->clkact_lock);
+
+	init.name = np->name;
+	init.ops = &zynq_periph_clk_ops;
+	for (i = 0; i < ARRAY_SIZE(parent_names); i++)
+		parent_names[i] = of_clk_get_parent_name(np, i);
+	init.parent_names = parent_names;
+	init.num_parents = ARRAY_SIZE(parent_names);
+
+	periph->hw.init = &init;
+
+	clk = clk_register(NULL, &periph->hw);
+	WARN_ON(IS_ERR(clk));
+
+	err = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	WARN_ON(err);
+
+	for (i = 0; i < 2; i++) {
+		const char *name;
+
+		err = of_property_read_string_index(np, "clock-output-names", i,
+						    &name);
+		WARN_ON(err);
+
+		periph->gates[i] = clk_register_gate(NULL, name, np->name, 0,
+						     periph->clk_ctrl, i, 0,
+						     &periph->clkact_lock);
+		WARN_ON(IS_ERR(periph->gates[i]));
+	}
+
+	periph->onecell_data.clks = periph->gates;
+	periph->onecell_data.clk_num = i;
+
+	err = of_clk_add_provider(np, of_clk_src_onecell_get,
+				  &periph->onecell_data);
+	WARN_ON(err);
+}
+
+/* CPU Clock domain is modelled as a mux with 4 children subclks, whose
+ * derivative rates depend on CLK_621_TRUE
+ */
+
+struct zynq_cpu_clk {
+	struct clk_hw		hw;
+	struct clk_onecell_data	onecell_data;
+	struct clk		*subclks[4];
+	void __iomem		*clk_ctrl;
+	spinlock_t		clkact_lock;
+};
+
+#define to_zynq_cpu_clk(hw)	container_of(hw, struct zynq_cpu_clk, hw)
+
+static const u8 zynq_cpu_clk_parent_map[] = {
+	1, 1, 2, 0
+};
+#define CPU_CLK_SRCSEL(x)	(zynq_cpu_clk_parent_map[(((x)&0x30)>>4)])
+#define CPU_CLK_CTRL_DIV(x)	(((x)&0x3F00)>>8)
+
+static u8 zynq_cpu_clk_get_parent(struct clk_hw *hw)
+{
+	struct zynq_cpu_clk *cpuclk = to_zynq_cpu_clk(hw);
+	return CPU_CLK_SRCSEL(ioread32(cpuclk->clk_ctrl));
+}
+
+static unsigned long zynq_cpu_clk_recalc_rate(struct clk_hw *hw,
+					      unsigned long parent_rate)
+{
+	struct zynq_cpu_clk *cpuclk = to_zynq_cpu_clk(hw);
+	return parent_rate / CPU_CLK_CTRL_DIV(ioread32(cpuclk->clk_ctrl));
+}
+
+static const struct clk_ops zynq_cpu_clk_ops = {
+	.get_parent	= zynq_cpu_clk_get_parent,
+	.recalc_rate	= zynq_cpu_clk_recalc_rate,
+};
+
+struct zynq_cpu_subclk {
+	struct clk_hw	hw;
+	void __iomem	*clk_621;
+	enum {
+		CPU_SUBCLK_6X4X,
+		CPU_SUBCLK_3X2X,
+		CPU_SUBCLK_2X,
+		CPU_SUBCLK_1X,
+	} which;
+};
+
+#define CLK_621_TRUE(x)	((x)&1)
+
+#define to_zynq_cpu_subclk(hw)	container_of(hw, struct zynq_cpu_subclk, hw);
+
+static unsigned long zynq_cpu_subclk_recalc_rate(struct clk_hw *hw,
+						 unsigned long parent_rate)
+{
+	unsigned long uninitialized_var(rate);
+	struct zynq_cpu_subclk *subclk;
+	bool is_621;
+
+	subclk = to_zynq_cpu_subclk(hw)
+	is_621 = CLK_621_TRUE(ioread32(subclk->clk_621));
+
+	switch (subclk->which) {
+	case CPU_SUBCLK_6X4X:
+		rate = parent_rate;
+		break;
+	case CPU_SUBCLK_3X2X:
+		rate = parent_rate / 2;
+		break;
+	case CPU_SUBCLK_2X:
+		rate = parent_rate / (is_621 ? 3 : 2);
+		break;
+	case CPU_SUBCLK_1X:
+		rate = parent_rate / (is_621 ? 6 : 4);
+		break;
+	};
+
+	return rate;
+}
+
+static const struct clk_ops zynq_cpu_subclk_ops = {
+	.recalc_rate	= zynq_cpu_subclk_recalc_rate,
+};
+
+static struct clk *zynq_cpu_subclk_setup(struct device_node *np, u8 which,
+					 void __iomem *clk_621)
+{
+	struct zynq_cpu_subclk *subclk;
+	struct clk_init_data init;
+	struct clk *clk;
+	int err;
+
+	err = of_property_read_string_index(np, "clock-output-names",
+					    which, &init.name);
+	if (WARN_ON(err))
+		goto err_read_output_name;
+
+	subclk = kzalloc(sizeof(*subclk), GFP_KERNEL);
+	if (!subclk)
+		goto err_subclk_alloc;
+
+	subclk->clk_621 = clk_621;
+	subclk->which = which;
+
+	init.ops = &zynq_cpu_subclk_ops;
+	init.parent_names = &np->name;
+	init.num_parents = 1;
+
+	subclk->hw.init = &init;
+
+	clk = clk_register(NULL, &subclk->hw);
+	if (WARN_ON(IS_ERR(clk)))
+		goto err_clk_register;
+
+	return clk;
+
+err_clk_register:
+err_subclk_alloc:
+err_read_output_name:
+	return NULL;
+}
+
+static void __init zynq_cpu_clk_setup(struct device_node *np)
+{
+	struct zynq_cpu_clk *cpuclk;
+	const char *parent_names[3];
+	struct clk_init_data init;
+	void __iomem *clk_621;
+	struct clk *clk;
+	u32 reg[2];
+	int err;
+	int i;
+
+	err = of_property_read_u32_array(np, "reg", reg, ARRAY_SIZE(reg));
+	WARN_ON(err);
+
+	cpuclk = kzalloc(sizeof(*cpuclk), GFP_KERNEL);
+	WARN_ON(!cpuclk);
+
+	cpuclk->clk_ctrl = slcr_base + reg[0];
+	clk_621 = slcr_base + reg[1];
+	spin_lock_init(&cpuclk->clkact_lock);
+
+	init.name = np->name;
+	init.ops = &zynq_cpu_clk_ops;
+	for (i = 0; i < ARRAY_SIZE(parent_names); i++)
+		parent_names[i] = of_clk_get_parent_name(np, i);
+	init.parent_names = parent_names;
+	init.num_parents = ARRAY_SIZE(parent_names);
+
+	cpuclk->hw.init = &init;
+
+	clk = clk_register(NULL, &cpuclk->hw);
+	WARN_ON(IS_ERR(clk));
+
+	err = of_clk_add_provider(np, of_clk_src_simple_get, clk);
+	WARN_ON(err);
+
+	for (i = 0; i < 4; i++) {
+		cpuclk->subclks[i] = zynq_cpu_subclk_setup(np, i, clk_621);
+		WARN_ON(IS_ERR(cpuclk->subclks[i]));
+	}
+
+	cpuclk->onecell_data.clks = cpuclk->subclks;
+	cpuclk->onecell_data.clk_num = i;
+
+	err = of_clk_add_provider(np, of_clk_src_onecell_get,
+				  &cpuclk->onecell_data);
+	WARN_ON(err);
+}
+
+static const __initconst struct of_device_id zynq_clk_match[] = {
+	{ .compatible = "fixed-clock", .data = of_fixed_clk_setup, },
+	{ .compatible = "xlnx,zynq-pll", .data = zynq_pll_clk_setup, },
+	{ .compatible = "xlnx,zynq-periph-clock",
+		.data = zynq_periph_clk_setup, },
+	{ .compatible = "xlnx,zynq-cpu-clock", .data = zynq_cpu_clk_setup, },
+	{}
+};
+
+void __init xilinx_zynq_clocks_init(void __iomem *slcr)
+{
+	slcr_base = slcr;
+	of_clk_init(zynq_clk_match);
+}
diff --git a/include/linux/clk/zynq.h b/include/linux/clk/zynq.h
new file mode 100644
index 0000000..56be7cd
--- /dev/null
+++ b/include/linux/clk/zynq.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2012 National Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __LINUX_CLK_ZYNQ_H_
+#define __LINUX_CLK_ZYNQ_H_
+
+void __init xilinx_zynq_clocks_init(void __iomem *slcr);
+
+#endif
-- 
1.8.0


