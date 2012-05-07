Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab2EGGoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:44:18 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15772 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab2EGGoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:44:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 06 May 2012 23:43:40 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: swarren@wwwdotorg.org
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hiroshi DOYU <hdoyu@nvidia.com>, Felipe Balbi <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv5 1/3] ARM: tegra: Add Tegra AHB driver
Date: Mon,  7 May 2012 09:43:45 +0300
Message-Id: <1336373032-16881-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
High-performance Bus (AHB) architecture.

The AHB Arbiter controls AHB bus master arbitration. This effectively
forms a second level of arbitration for access to the memory
controller through the AHB Slave Memory device. The AHB pre-fetch
logic can be configured to enhance performance for devices doing
sequential access. Each AHB master is assigned to either the high or
low priority bin. Both Tegra20/30 have this AHB bus.

Some of configuration params could be passed from DT too if needed.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 .../bindings/arm/tegra/nvidia,tegra20-ahb.txt      |   11 +
 arch/arm/mach-tegra/Kconfig                        |    8 +
 drivers/Makefile                                   |    2 +-
 drivers/amba/Makefile                              |    4 +-
 drivers/amba/tegra-ahb.c                           |  261 ++++++++++++++++++++
 5 files changed, 283 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt
new file mode 100644
index 0000000..234406d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-ahb.txt
@@ -0,0 +1,11 @@
+NVIDIA Tegra AHB
+
+Required properties:
+- compatible : "nvidia,tegra20-ahb" or "nvidia,tegra30-ahb"
+- reg : Should contain 1 register ranges(address and length)
+
+Example:
+	ahb: ahb@6000c004 {
+		compatible = "nvidia,tegra20-ahb";
+		reg = <0x6000c004 0x10c>; /* AHB Arbitration + Gizmo Controller */
+	};
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 204d3d4..6a113a9 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -50,6 +50,14 @@ config TEGRA_PCI
 	depends on ARCH_TEGRA_2x_SOC
 	select PCI
 
+config TEGRA_AHB
+	bool "Enable AHB driver for NVIDIA Tegra SoCs"
+	default y
+	help
+	  Adds AHB configuration functionality for NVIDIA Tegra SoCs,
+	  which controls AHB bus master arbitration and some
+	  perfomance parameters(priority, prefech size).
+
 comment "Tegra board type"
 
 config MACH_HARMONY
diff --git a/drivers/Makefile b/drivers/Makefile
index 5870322..d97e2e2 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_SFI)		+= sfi/
 # PnP must come after ACPI since it will eventually need to check if acpi
 # was used and do nothing if so
 obj-$(CONFIG_PNP)		+= pnp/
-obj-$(CONFIG_ARM_AMBA)		+= amba/
+obj-$(CONFIG_ARM)		+= amba/
 # Many drivers will want to use DMA so this has to be made available
 # really early.
 obj-$(CONFIG_DMA_ENGINE)	+= dma/
diff --git a/drivers/amba/Makefile b/drivers/amba/Makefile
index 40fe740..66e81c2 100644
--- a/drivers/amba/Makefile
+++ b/drivers/amba/Makefile
@@ -1,2 +1,2 @@
-obj-y		+= bus.o
-
+obj-$(CONFIG_ARM_AMBA)		+= bus.o
+obj-$(CONFIG_TEGRA_AHB)		+= tegra-ahb.o
diff --git a/drivers/amba/tegra-ahb.c b/drivers/amba/tegra-ahb.c
new file mode 100644
index 0000000..106a780
--- /dev/null
+++ b/drivers/amba/tegra-ahb.c
@@ -0,0 +1,261 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Author:
+ *	Jay Cheng <jacheng@nvidia.com>
+ *	James Wylder <james.wylder@motorola.com>
+ *	Benoit Goby <benoit@android.com>
+ *	Colin Cross <ccross@android.com>
+ *	Hiroshi DOYU <hdoyu@nvidia.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#define DRV_NAME "tegra-ahb"
+
+#define AHB_ARBITRATION_DISABLE		0x00
+#define AHB_ARBITRATION_PRIORITY_CTRL	0x04
+#define   AHB_PRIORITY_WEIGHT(x)	(((x) & 0x7) << 29)
+#define   PRIORITY_SELECT_USB BIT(6)
+#define   PRIORITY_SELECT_USB2 BIT(18)
+#define   PRIORITY_SELECT_USB3 BIT(17)
+
+#define AHB_GIZMO_AHB_MEM		0x0c
+#define   ENB_FAST_REARBITRATE BIT(2)
+#define   DONT_SPLIT_AHB_WR     BIT(7)
+
+#define AHB_GIZMO_APB_DMA		0x10
+#define AHB_GIZMO_IDE			0x18
+#define AHB_GIZMO_USB			0x1c
+#define AHB_GIZMO_AHB_XBAR_BRIDGE	0x20
+#define AHB_GIZMO_CPU_AHB_BRIDGE	0x24
+#define AHB_GIZMO_COP_AHB_BRIDGE	0x28
+#define AHB_GIZMO_XBAR_APB_CTLR		0x2c
+#define AHB_GIZMO_VCP_AHB_BRIDGE	0x30
+#define AHB_GIZMO_NAND			0x3c
+#define AHB_GIZMO_SDMMC4		0x44
+#define AHB_GIZMO_XIO			0x48
+#define AHB_GIZMO_BSEV			0x60
+#define AHB_GIZMO_BSEA			0x70
+#define AHB_GIZMO_NOR			0x74
+#define AHB_GIZMO_USB2			0x78
+#define AHB_GIZMO_USB3			0x7c
+#define   IMMEDIATE	BIT(18)
+
+#define AHB_GIZMO_SDMMC1		0x80
+#define AHB_GIZMO_SDMMC2		0x84
+#define AHB_GIZMO_SDMMC3		0x88
+#define AHB_MEM_PREFETCH_CFG_X		0xd8
+#define AHB_ARBITRATION_XBAR_CTRL	0xdc
+#define AHB_MEM_PREFETCH_CFG3		0xe0
+#define AHB_MEM_PREFETCH_CFG4		0xe4
+#define AHB_MEM_PREFETCH_CFG1		0xec
+#define AHB_MEM_PREFETCH_CFG2		0xf0
+#define   PREFETCH_ENB	BIT(31)
+#define   MST_ID(x)	(((x) & 0x1f) << 26)
+#define   AHBDMA_MST_ID	MST_ID(5)
+#define   USB_MST_ID	MST_ID(6)
+#define   USB2_MST_ID	MST_ID(18)
+#define   USB3_MST_ID	MST_ID(17)
+#define   ADDR_BNDRY(x)	(((x) & 0xf) << 21)
+#define   INACTIVITY_TIMEOUT(x)	(((x) & 0xffff) << 0)
+
+#define AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID	0xf8
+
+static const u32 tegra_ahb_gizmo[] = {
+	AHB_ARBITRATION_DISABLE,
+	AHB_ARBITRATION_PRIORITY_CTRL,
+	AHB_GIZMO_AHB_MEM,
+	AHB_GIZMO_APB_DMA,
+	AHB_GIZMO_IDE,
+	AHB_GIZMO_USB,
+	AHB_GIZMO_AHB_XBAR_BRIDGE,
+	AHB_GIZMO_CPU_AHB_BRIDGE,
+	AHB_GIZMO_COP_AHB_BRIDGE,
+	AHB_GIZMO_XBAR_APB_CTLR,
+	AHB_GIZMO_VCP_AHB_BRIDGE,
+	AHB_GIZMO_NAND,
+	AHB_GIZMO_SDMMC4,
+	AHB_GIZMO_XIO,
+	AHB_GIZMO_BSEV,
+	AHB_GIZMO_BSEA,
+	AHB_GIZMO_NOR,
+	AHB_GIZMO_USB2,
+	AHB_GIZMO_USB3,
+	AHB_GIZMO_SDMMC1,
+	AHB_GIZMO_SDMMC2,
+	AHB_GIZMO_SDMMC3,
+	AHB_MEM_PREFETCH_CFG_X,
+	AHB_ARBITRATION_XBAR_CTRL,
+	AHB_MEM_PREFETCH_CFG3,
+	AHB_MEM_PREFETCH_CFG4,
+	AHB_MEM_PREFETCH_CFG1,
+	AHB_MEM_PREFETCH_CFG2,
+	AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID,
+};
+
+struct tegra_ahb {
+	void __iomem	*regs;
+	struct device	*dev;
+	u32		ctx[0];
+};
+
+static inline u32 gizmo_readl(struct tegra_ahb *ahb, u32 offset)
+{
+	return readl(ahb->regs + offset);
+}
+
+static inline void gizmo_writel(struct tegra_ahb *ahb, u32 value, u32 offset)
+{
+	writel(value, ahb->regs + offset);
+}
+
+static int tegra_ahb_suspend(struct device *dev)
+{
+	int i;
+	struct tegra_ahb *ahb = dev_get_drvdata(dev);
+
+	for (i = 0; i < ARRAY_SIZE(tegra_ahb_gizmo); i++)
+		ahb->ctx[i] = gizmo_readl(ahb, tegra_ahb_gizmo[i]);
+	return 0;
+}
+
+static int tegra_ahb_resume(struct device *dev)
+{
+	int i;
+	struct tegra_ahb *ahb = dev_get_drvdata(dev);
+
+	for (i = 0; i < ARRAY_SIZE(tegra_ahb_gizmo); i++)
+		gizmo_writel(ahb, ahb->ctx[i], tegra_ahb_gizmo[i]);
+	return 0;
+}
+
+static UNIVERSAL_DEV_PM_OPS(tegra_ahb_pm,
+			    tegra_ahb_suspend,
+			    tegra_ahb_resume, NULL);
+
+static void tegra_ahb_gizmo_init(struct tegra_ahb *ahb)
+{
+	u32 val;
+
+	val = gizmo_readl(ahb, AHB_GIZMO_AHB_MEM);
+	val |= ENB_FAST_REARBITRATE | IMMEDIATE | DONT_SPLIT_AHB_WR;
+	gizmo_writel(ahb, val, AHB_GIZMO_AHB_MEM);
+
+	val = gizmo_readl(ahb, AHB_GIZMO_USB);
+	val |= IMMEDIATE;
+	gizmo_writel(ahb, val, AHB_GIZMO_USB);
+
+	val = gizmo_readl(ahb, AHB_GIZMO_USB2);
+	val |= IMMEDIATE;
+	gizmo_writel(ahb, val, AHB_GIZMO_USB2);
+
+	val = gizmo_readl(ahb, AHB_GIZMO_USB3);
+	val |= IMMEDIATE;
+	gizmo_writel(ahb, val, AHB_GIZMO_USB3);
+
+	val = gizmo_readl(ahb, AHB_ARBITRATION_PRIORITY_CTRL);
+	val |= PRIORITY_SELECT_USB |
+		PRIORITY_SELECT_USB2 |
+		PRIORITY_SELECT_USB3 |
+		AHB_PRIORITY_WEIGHT(7);
+	gizmo_writel(ahb, val, AHB_ARBITRATION_PRIORITY_CTRL);
+
+	val = gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG1);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		AHBDMA_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG1);
+
+	val = gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG2);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		USB_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG2);
+
+	val = gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG3);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		USB3_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG3);
+
+	val = gizmo_readl(ahb, AHB_MEM_PREFETCH_CFG4);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		USB2_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(ahb, val, AHB_MEM_PREFETCH_CFG4);
+}
+
+static int __devinit tegra_ahb_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct tegra_ahb *ahb;
+	size_t bytes;
+
+	bytes = sizeof(*ahb) + sizeof(u32) * ARRAY_SIZE(tegra_ahb_gizmo);
+	ahb = devm_kzalloc(&pdev->dev, bytes, GFP_KERNEL);
+	if (!ahb)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	ahb->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (!ahb->regs)
+		return -EBUSY;
+
+	ahb->dev = &pdev->dev;
+	platform_set_drvdata(pdev, ahb);
+	tegra_ahb_gizmo_init(ahb);
+	return 0;
+}
+
+static int __devexit tegra_ahb_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id tegra_ahb_of_match[] __devinitconst = {
+	{ .compatible = "nvidia,tegra30-ahb", },
+	{ .compatible = "nvidia,tegra20-ahb", },
+	{},
+};
+
+static struct platform_driver tegra_ahb_driver = {
+	.probe = tegra_ahb_probe,
+	.remove = __devexit_p(tegra_ahb_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_ahb_of_match,
+		.pm = &tegra_ahb_pm,
+	},
+};
+module_platform_driver(tegra_ahb_driver);
+
+MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
+MODULE_DESCRIPTION("Tegra AHB driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.5.4

