Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab2JOMTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:19:14 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47677 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2JOMSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:18:46 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Li Li <li.li@canonical.com>,
        Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 1/3] clk: mvebu: add armada-370-xp specific clocks
Date: Mon, 15 Oct 2012 14:18:17 +0200
Message-Id: <1350303499-30868-2-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com>
References: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Armada 370/XP specific clocks: core clocks and CPU clocks.

The CPU clocks are only for Armada XP for the SMP mode.

The core clocks are clocks which have their rate set during reset. The
code was written with the other SoCs of the mvebu family in
mind. Adding them should be pretty straight forward. For a new
SoC, only 3 binding have to be added:
- one to provide the tclk frequency
- one to provde the pclk frequency
- and one to provide the ratio between the pclk and the children
  clocks

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 .../devicetree/bindings/clock/mvebu-core-clock.txt |   40 +++
 .../devicetree/bindings/clock/mvebu-cpu-clock.txt  |   21 ++
 drivers/clk/Makefile                               |    1 +
 drivers/clk/mvebu/Makefile                         |    2 +
 drivers/clk/mvebu/clk-core.c                       |  312 ++++++++++++++++++++
 drivers/clk/mvebu/clk-core.h                       |   19 ++
 drivers/clk/mvebu/clk-cpu.c                        |  155 ++++++++++
 drivers/clk/mvebu/clk-cpu.h                        |   19 ++
 drivers/clk/mvebu/clk.c                            |   36 +++
 9 files changed, 605 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/mvebu-cpu-clock.txt
 create mode 100644 drivers/clk/mvebu/Makefile
 create mode 100644 drivers/clk/mvebu/clk-core.c
 create mode 100644 drivers/clk/mvebu/clk-core.h
 create mode 100644 drivers/clk/mvebu/clk-cpu.c
 create mode 100644 drivers/clk/mvebu/clk-cpu.h
 create mode 100644 drivers/clk/mvebu/clk.c

diff --git a/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
new file mode 100644
index 0000000..d2e0965
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mvebu-core-clock.txt
@@ -0,0 +1,40 @@
+Device Tree Clock bindings for core clock of Marvell EBU platforms
+
+This is the binding for the "core" clock of the mvebu SoCs, the rate
+of this clocks are fixed during reset. Their value or ratio are taken
+from the Sample at Reset(SAR) register.
+
+Required properties:
+- compatible : shall be one of the following:
+	"marvell,armada-370-core-clockctrl" - core clock for Armada 370
+	"marvell,armada-xp-core-clockctrl" - core clock for Armada XP
+- reg : Address and length of the SAR register set
+- #clock-cells : should be set to 1.
+- clock-output-names: A list of clock output names that mvebu core
+  clocks provides.  The full list of all valid clock names, IDs and
+  description are below.
+	Name	    ID	    Description
+	tclk	    0	    Peripheral clock
+	pclk	    1	    CPU clock
+	nbclk	    2	    L2 clock
+	hclk	    3	    DRAM control clock
+	dramclk	    4	    DDR clock
+
+coreclk: mvebu-sar@d0018230 {
+	#clock-cells = <1>;
+	reg = <0xd0018230 0x08>;
+	compatible = "marvell,armada-370-core-clockctrl";
+	clock-output-names =
+		"tclk",	    /* 0 */
+		"pclk",	    /* 1 */
+		"nbclk",    /* 2 */
+		"hclk",	    /* 3 */
+		"dramclk",  /* 4 */
+};
+
+timer@d0020300 {
+	       compatible = "marvell,armada-370-xp-timer";
+	       reg = <0xd0020300 0x30>;
+	       interrupts = <37>, <38>, <39>, <40>;
+		   clocks = <&coreclk 0>;
+};
diff --git a/Documentation/devicetree/bindings/clock/mvebu-cpu-clock.txt b/Documentation/devicetree/bindings/clock/mvebu-cpu-clock.txt
new file mode 100644
index 0000000..c524618
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/mvebu-cpu-clock.txt
@@ -0,0 +1,21 @@
+Device Tree Clock bindings for cpu clock of Marvell EBU platforms
+
+Required properties:
+- compatible : shall be one of the following:
+	"marvell,armada-xp-cpu-clockctrl" - cpu clocks for Armada XP
+- reg : Address and length of the clock complex register set
+- #clock-cells : should be set to 1.
+- clocks : shall be the input parent clock phandle for the clock.
+
+cpuclk: clock-complex@d0018700 {
+	#clock-cells = <1>;
+	compatible = "marvell,armada-xp-cpu-clockctrl";
+	reg = <0xd0018700 0xA0>;
+	clocks = <&coreclk 1>;
+}
+
+cpu@0 {
+   	compatible = "marvell,sheeva-v7";
+	reg = <0>;
+	clocks = <&cpuclk 0>;
+};
diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
index 71a25b9..9c91d6c 100644
--- a/drivers/clk/Makefile
+++ b/drivers/clk/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_PLAT_SPEAR)	+= spear/
 obj-$(CONFIG_ARCH_U300)		+= clk-u300.o
 obj-$(CONFIG_COMMON_CLK_VERSATILE) += versatile/
 obj-$(CONFIG_ARCH_PRIMA2)	+= clk-prima2.o
+obj-$(CONFIG_ARCH_MVEBU)	+= mvebu/
 ifeq ($(CONFIG_COMMON_CLK), y)
 obj-$(CONFIG_ARCH_MMP)		+= mmp/
 endif
diff --git a/drivers/clk/mvebu/Makefile b/drivers/clk/mvebu/Makefile
new file mode 100644
index 0000000..de94a87
--- /dev/null
+++ b/drivers/clk/mvebu/Makefile
@@ -0,0 +1,2 @@
+obj-y += clk.o clk-core.o
+obj-$(CONFIG_MVEBU_CLK_CPU) += clk-cpu.o
diff --git a/drivers/clk/mvebu/clk-core.c b/drivers/clk/mvebu/clk-core.c
new file mode 100644
index 0000000..155f493
--- /dev/null
+++ b/drivers/clk/mvebu/clk-core.c
@@ -0,0 +1,312 @@
+/*
+ * Marvell EBU clock core handling defined at reset
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+#include <linux/of.h>
+
+/* Sample At Reset is a 64 bit bitfiled split in two register of 32
+ * bits*/
+
+#define SARL				    0	/* Low part [0:31] */
+#define	    SARL_AXP_PCLK_FREQ_OPT	    21
+#define	    SARL_AXP_PCLK_FREQ_OPT_MASK	    0x7
+#define	    SARL_A370_PCLK_FREQ_OPT	    11
+#define	    SARL_A370_PCLK_FREQ_OPT_MASK    0xF
+#define	    SARL_AXP_FAB_FREQ_OPT	    24
+#define	    SARL_AXP_FAB_FREQ_OPT_MASK	    0xF
+#define	    SARL_A370_FAB_FREQ_OPT	    15
+#define	    SARL_A370_FAB_FREQ_OPT_MASK	    0x1F
+#define	    SARL_A370_TCLK_FREQ_OPT	    20
+#define	    SARL_A370_TCLK_FREQ_OPT_MASK    0x1
+#define SARH				    4	/* High part [32:63] */
+#define	    SARH_AXP_PCLK_FREQ_OPT	    (52-32)
+#define	    SARH_AXP_PCLK_FREQ_OPT_MASK	    0x1
+#define	    SARH_AXP_PCLK_FREQ_OPT_SHIFT    3
+#define	    SARH_AXP_FAB_FREQ_OPT	    (51-32)
+#define	    SARH_AXP_FAB_FREQ_OPT_MASK	    0x1
+#define	    SARH_AXP_FAB_FREQ_OPT_SHIFT	    4
+
+u32 *sar_reg;
+int sar_reg_size;
+
+enum core_clk {
+	tclk, pclk, nbclk, hclk, dramclk, clk_max
+};
+
+struct core_clk_fn {
+	u32(*get_tclk_freq) (void);
+	u32(*get_pck_freq) (void);
+	const int *(*get_fab_freq_opt) (void);
+};
+
+/* Ratio between VCO and each of the member in the following order:
+   CPU clock, L2 clock, DRAM controler clock, DDR clcok */
+static const int reset_core_ratio[32][4] = {
+	[0x01] = {1, 2, 2, 2},
+	[0x02] = {2, 2, 6, 3},
+	[0x03] = {2, 2, 3, 3},
+	[0x04] = {1, 2, 3, 3},
+	[0x05] = {1, 2, 4, 2},
+	[0x06] = {1, 1, 2, 2},
+	[0x07] = {2, 3, 6, 6},
+	[0x09] = {1, 2, 6, 3},
+	[0x0A] = {2, 4, 10, 5},
+	[0x0C] = {1, 2, 4, 4},
+	[0x0F] = {2, 2, 5, 5},
+	[0x13] = {1, 1, 2, 1},
+	[0x14] = {2, 3, 6, 3},
+	[0x1B] = {1, 1, 1, 1},
+};
+
+static struct clk *clks[clk_max];
+
+static struct clk_onecell_data clk_data;
+
+/* Frequency in MHz*/
+static u32 armada_370_pclk[] = { 400, 533, 667, 800, 1000, 1067, 1200 };
+
+static u32 armada_xp_pclk[] = { 1000, 1066, 1200, 1333, 1500, 1666,
+	1800, 2000, 667, 0, 800, 1600
+};
+
+static u32 armada_370_tclk[] = { 166, 200 };
+
+static const int *__init armada_370_get_fab_freq_opt(void)
+{
+	u8 fab_freq_opt = 0;
+
+	fab_freq_opt = ((sar_reg[0] >> SARL_A370_FAB_FREQ_OPT) &
+			SARL_A370_FAB_FREQ_OPT_MASK);
+
+	if (reset_core_ratio[fab_freq_opt][0] == 0)
+		return NULL;
+	else
+		return reset_core_ratio[fab_freq_opt];
+}
+
+static u32 __init armada_370_get_pck_freq(void)
+{
+	u32 cpu_freq;
+	u8 cpu_freq_select = 0;
+
+	cpu_freq_select = ((sar_reg[0] >> SARL_A370_PCLK_FREQ_OPT) &
+			   SARL_A370_PCLK_FREQ_OPT_MASK);
+	if (cpu_freq_select > ARRAY_SIZE(armada_370_pclk)) {
+		pr_err("CPU freq select unsuported %d\n", cpu_freq_select);
+		cpu_freq = 0;
+	} else
+		cpu_freq = armada_370_pclk[cpu_freq_select];
+
+	return cpu_freq * 1000 * 1000;
+}
+
+static u32 __init armada_370_get_tclk_freq(void)
+{
+	u32 tclk_freq;
+	u8 tclk_freq_select = 0;
+
+	tclk_freq_select = ((sar_reg[0] >> SARL_A370_TCLK_FREQ_OPT) &
+			    SARL_A370_TCLK_FREQ_OPT_MASK);
+	if (tclk_freq_select > ARRAY_SIZE(armada_370_tclk)) {
+		pr_err("TCLK freq select unsuported %d\n", tclk_freq_select);
+		tclk_freq = 0;
+	} else
+		tclk_freq = armada_370_tclk[tclk_freq_select];
+
+	return tclk_freq * 1000 * 1000;
+}
+
+static const int *__init armada_xp_get_fab_freq_opt(void)
+{
+	u8 fab_freq_opt = 0;
+
+	fab_freq_opt = ((sar_reg[0] >> SARL_AXP_FAB_FREQ_OPT) &
+			SARL_AXP_FAB_FREQ_OPT_MASK);
+	/* The upper bit is not contiguous to the other ones
+	 * and located in the high part of the SAR
+	 * registers */
+	fab_freq_opt |= (((sar_reg[1] >> SARH_AXP_FAB_FREQ_OPT) &
+			  SARH_AXP_FAB_FREQ_OPT_MASK)
+			 << SARH_AXP_FAB_FREQ_OPT_SHIFT);
+
+	if (reset_core_ratio[fab_freq_opt][0] == 0)
+		return NULL;
+	else
+		return reset_core_ratio[fab_freq_opt];
+}
+
+static u32 __init armada_xp_get_pck_freq(void)
+{
+	u32 cpu_freq;
+	u8 cpu_freq_select = 0;
+
+	cpu_freq_select = ((sar_reg[0] >> SARL_AXP_PCLK_FREQ_OPT) &
+			   SARL_AXP_PCLK_FREQ_OPT_MASK);
+	/* The upper bit is not contiguous to the other ones
+	 * and located in the high part of the SAR
+	 * registers */
+	cpu_freq_select |= (((sar_reg[1] >> SARH_AXP_PCLK_FREQ_OPT) &
+			     SARH_AXP_PCLK_FREQ_OPT_MASK)
+			    << SARH_AXP_PCLK_FREQ_OPT_SHIFT);
+	if (cpu_freq_select > ARRAY_SIZE(armada_xp_pclk)) {
+		pr_err("CPU freq select unsuported: %d\n", cpu_freq_select);
+		cpu_freq = 0;
+	} else
+		cpu_freq = armada_xp_pclk[cpu_freq_select];
+
+	return cpu_freq * 1000 * 1000;
+}
+
+/* For Armada XP TCLK frequency is fix: 250MHz */
+static u32 __init armada_xp_get_tclk_freq(void)
+{
+	return 250 * 1000 * 1000;
+}
+
+void __init of_core_clk_setup(struct device_node *node,
+			      struct core_clk_fn clk_fn)
+{
+	struct clk *clk;
+	unsigned long rate;
+	const char *clk_name;
+	int i;
+
+	/* clock 0 is tclk */
+	of_property_read_string_index(node, "clock-output-names", tclk,
+				      &clk_name);
+	rate = clk_fn.get_tclk_freq();
+	if (rate != 0)
+		clk = clk_register_fixed_rate(NULL, clk_name, NULL,
+					      CLK_IS_ROOT, rate);
+	else {
+		pr_err("Invalid freq for %s\n", clk_name);
+		return;
+	}
+
+	if (WARN_ON(IS_ERR(clk)))
+		return;
+	clks[tclk] = clk;
+
+	/* clock 1 is pclk */
+	of_property_read_string_index(node, "clock-output-names", pclk,
+				      &clk_name);
+	rate = clk_fn.get_pck_freq();
+	if (rate != 0)
+		clk = clk_register_fixed_rate(NULL, clk_name, NULL,
+					      CLK_IS_ROOT, rate);
+	else {
+		pr_err("Invalid freq for %s\n", clk_name);
+		return;
+	}
+	if (WARN_ON(IS_ERR(clk)))
+		return;
+	clks[pclk] = clk;
+
+	/* the clocks 2 to 4 are nbclk, hclk and dramclk and are all
+	 * derivated from the clock 1: pclk */
+
+	for (i = nbclk; i <= dramclk; i++) {
+		const int *ratio = clk_fn.get_fab_freq_opt();
+		const char *parent_clk_name;
+
+		of_property_read_string_index(node, "clock-output-names",
+					      i, &clk_name);
+		of_property_read_string_index(node, "clock-output-names",
+					      pclk, &parent_clk_name);
+
+		if (ratio != NULL)
+			clk = clk_register_fixed_factor(NULL, clk_name,
+							parent_clk_name, 0,
+							ratio[0],
+							ratio[i - nbclk + 1]);
+		else {
+			pr_err("Invalid clk ratio for %s\n", clk_name);
+			return;
+		}
+
+		if (WARN_ON(IS_ERR(clk)))
+			return;
+		clks[i] = clk;
+	}
+	clk_data.clk_num = ARRAY_SIZE(clks);
+	clk_data.clks = clks;
+	of_clk_add_provider(node, of_clk_src_onecell_get, &clk_data);
+}
+
+static struct core_clk_fn armada_370_clk_fn = {
+	.get_tclk_freq = armada_370_get_tclk_freq,
+	.get_pck_freq = armada_370_get_pck_freq,
+	.get_fab_freq_opt = armada_370_get_fab_freq_opt,
+};
+
+static struct core_clk_fn armada_xp_clk_fn = {
+	.get_tclk_freq = armada_xp_get_tclk_freq,
+	.get_pck_freq = armada_xp_get_pck_freq,
+	.get_fab_freq_opt = armada_xp_get_fab_freq_opt,
+};
+
+static const __initconst struct of_device_id clk_match[] = {
+	{
+	 .compatible = "marvell,armada-370-core-clockctrl",
+	 .data = &armada_370_clk_fn,
+	 },
+
+	{
+	 .compatible = "marvell,armada-xp-core-clockctrl",
+	 .data = &armada_xp_clk_fn,
+	 },
+	{
+	 /* sentinel */
+	 }
+};
+
+void __init mvebu_core_clocks_init(void)
+{
+	struct device_node *np;
+	struct resource res;
+	void __iomem *sar_base;
+	int i;
+
+	np = of_find_node_by_name(NULL, "mvebu-sar");
+
+	if (!np)
+		goto err;
+
+	if (of_address_to_resource(np, 0, &res))
+		goto err;
+
+	sar_reg_size = resource_size(&res);
+	sar_reg = kmalloc(sar_reg_size, GFP_KERNEL);
+
+	sar_base = ioremap(res.start, sar_reg_size);
+	if (sar_base == NULL)
+		goto err;
+	for (i = 0; i < sar_reg_size; i += sizeof(*sar_reg))
+		sar_reg[i] = readl(sar_base + i);
+
+	iounmap(sar_base);
+
+	for_each_matching_node(np, clk_match) {
+		const struct of_device_id *match = of_match_node(clk_match, np);
+		struct core_clk_fn *clk_fn = (struct core_clk_fn *)match->data;
+		of_core_clk_setup(np, *clk_fn);
+	}
+
+	return;
+err:
+	pr_err("%s:SAR base adresse not set in DT\n", __func__);
+	return;
+}
diff --git a/drivers/clk/mvebu/clk-core.h b/drivers/clk/mvebu/clk-core.h
new file mode 100644
index 0000000..a04f80b
--- /dev/null
+++ b/drivers/clk/mvebu/clk-core.h
@@ -0,0 +1,19 @@
+/*
+ *  * Marvell EBU clock core handling defined at reset
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __MVEBU_CLK_CORE_H
+#define __MVEBU_CLK_CORE_H
+
+void __init of_core_clk_setup(struct device_node *node);
+void __init mvebu_core_clocks_init(void);
+
+#endif
diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
new file mode 100644
index 0000000..6b5c841
--- /dev/null
+++ b/drivers/clk/mvebu/clk-cpu.c
@@ -0,0 +1,155 @@
+/*
+ * Marvell MVEBU CPU clock handling.
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/of_address.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/delay.h>
+
+#define SYS_CTRL_CLK_DIVIDER_CTRL_OFFSET    0x0
+#define SYS_CTRL_CLK_DIVIDER_VALUE_OFFSET   0xC
+#define SYS_CTRL_CLK_DIVIDER_MASK	    0x3F
+
+#define MAX_CPU	    4
+struct cpu_clk {
+	struct clk_hw hw;
+	int cpu;
+	const char *clk_name;
+	const char *parent_name;
+	void __iomem *reg_base;
+};
+
+static struct clk **clks;
+
+static struct clk_onecell_data clk_data;
+
+#define to_cpu_clk(p) container_of(p, struct cpu_clk, hw)
+
+static unsigned long clk_cpu_recalc_rate(struct clk_hw *hwclk,
+					 unsigned long parent_rate)
+{
+	struct cpu_clk *cpuclk = to_cpu_clk(hwclk);
+	u32 reg, div;
+
+	reg = readl(cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_VALUE_OFFSET);
+	div = (reg >> (cpuclk->cpu * 8)) & SYS_CTRL_CLK_DIVIDER_MASK;
+	return parent_rate / div;
+}
+
+static long clk_cpu_round_rate(struct clk_hw *hwclk, unsigned long rate,
+			       unsigned long *parent_rate)
+{
+	/* Valid ratio are 1:1, 1:2 and 1:3 */
+	u32 div;
+
+	div = *parent_rate / rate;
+	if (div == 0)
+		div = 1;
+	else if (div > 3)
+		div = 3;
+
+	return *parent_rate / div;
+}
+
+static int clk_cpu_set_rate(struct clk_hw *hwclk, unsigned long rate,
+			    unsigned long parent_rate)
+{
+	struct cpu_clk *cpuclk = to_cpu_clk(hwclk);
+	u32 reg, div;
+	u32 reload_mask;
+
+	div = parent_rate / rate;
+	reg = (readl(cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_VALUE_OFFSET)
+		& (~(SYS_CTRL_CLK_DIVIDER_MASK << (cpuclk->cpu * 8))))
+		| (div << (cpuclk->cpu * 8));
+	writel(reg, cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_VALUE_OFFSET);
+	/* Set clock divider reload smooth bit mask */
+	reload_mask = 1 << (20 + cpuclk->cpu);
+
+	reg = readl(cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_CTRL_OFFSET)
+	    | reload_mask;
+	writel(reg, cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_CTRL_OFFSET);
+
+	/* Now trigger the clock update */
+	reg = readl(cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_CTRL_OFFSET)
+	    | 1 << 24;
+	writel(reg, cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_CTRL_OFFSET);
+
+	/* Wait for clocks to settle down then clear reload request */
+	udelay(1000);
+	reg &= ~(reload_mask | 1 << 24);
+	writel(reg, cpuclk->reg_base + SYS_CTRL_CLK_DIVIDER_CTRL_OFFSET);
+	udelay(1000);
+
+	return 0;
+}
+
+static const struct clk_ops cpu_ops = {
+	.recalc_rate = clk_cpu_recalc_rate,
+	.round_rate = clk_cpu_round_rate,
+	.set_rate = clk_cpu_set_rate,
+};
+
+void __init of_cpu_clk_setup(struct device_node *node)
+{
+	struct cpu_clk *cpuclk;
+	void __iomem *clock_complex_base = of_iomap(node, 0);
+	int cpu;
+	if (clock_complex_base == NULL) {
+		pr_err("%s: clock-complex base register not set\n",
+			__func__);
+		return;
+	}
+
+	cpuclk = kzalloc(MAX_CPU * sizeof(*cpuclk), GFP_KERNEL);
+	clks = kzalloc(MAX_CPU * sizeof(*clks), GFP_KERNEL);
+
+	if (WARN_ON(!cpuclk))
+		return;
+	for (cpu = 0; cpu < MAX_CPU; cpu++) {
+		struct clk_init_data init;
+		struct clk *clk;
+		struct clk *parent_clk;
+		char *clk_name = kzalloc(5, GFP_KERNEL);
+
+		sprintf(clk_name, "cpu%d", cpu);
+		parent_clk = of_clk_get(node, 0);
+
+		cpuclk[cpu].parent_name = __clk_get_name(parent_clk);
+		cpuclk[cpu].clk_name = clk_name;
+		cpuclk[cpu].cpu = cpu;
+		cpuclk[cpu].reg_base = clock_complex_base;
+		cpuclk[cpu].hw.init = &init;
+
+		init.name = cpuclk[cpu].clk_name;
+		init.ops = &cpu_ops;
+		init.flags = 0;
+		init.parent_names = &cpuclk[cpu].parent_name;
+		init.num_parents = 1;
+
+		clk = clk_register(NULL, &cpuclk[cpu].hw);
+		if (WARN_ON(IS_ERR(clk)))
+			goto bail_out;
+		clks[cpu] = clk;
+	}
+	clk_data.clk_num = MAX_CPU;
+	clk_data.clks = clks;
+	of_clk_add_provider(node, of_clk_src_onecell_get, &clk_data);
+
+	return;
+bail_out:
+	kfree(clks);
+	kfree(cpuclk);
+}
diff --git a/drivers/clk/mvebu/clk-cpu.h b/drivers/clk/mvebu/clk-cpu.h
new file mode 100644
index 0000000..5d28356
--- /dev/null
+++ b/drivers/clk/mvebu/clk-cpu.h
@@ -0,0 +1,19 @@
+/*
+ * Marvell MVEBU CPU clock handling.
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __MVEBU_CLK_CPU_H
+#define __MVEBU_CLK_CPU_H
+
+void __init of_cpu_clk_setup(struct device_node *node);
+void __init mvebu_cpu_clocks_init(void);
+
+#endif
diff --git a/drivers/clk/mvebu/clk.c b/drivers/clk/mvebu/clk.c
new file mode 100644
index 0000000..0864df7
--- /dev/null
+++ b/drivers/clk/mvebu/clk.c
@@ -0,0 +1,36 @@
+/*
+ * Marvell EBU SoC clock handling.
+ *
+ * Copyright (C) 2012 Marvell
+ *
+ * Gregory CLEMENT <gregory.clement@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/clk-provider.h>
+#include <linux/of_address.h>
+#include <linux/of.h>
+#include "clk-cpu.h"
+#include "clk-core.h"
+
+static const __initconst struct of_device_id clk_match[] = {
+#ifdef CONFIG_MVEBU_CLK_CPU
+	{
+		.compatible = "marvell,armada-xp-cpu-clockctrl",
+		.data = of_cpu_clk_setup,
+	},
+#endif
+	{
+		/* sentinel */
+	}
+};
+
+void __init mvebu_clocks_init(void)
+{
+	mvebu_core_clocks_init();
+	of_clk_init(clk_match);
+}
-- 
1.7.9.5

