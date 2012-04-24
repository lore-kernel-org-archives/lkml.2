Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2DXMFh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:05:37 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3590 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2DXMFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:05:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 24 Apr 2012 05:05:29 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2 1/3] ARM: tegra: Add AHB driver
Date: Tue, 24 Apr 2012 15:05:14 +0300
Message-Id: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AHB Bus conforms to the AMBA Specification (Rev 2.0) Advanced
High-performance Bus (AHB) architecture.

The AHB Arbiter controls AHB bus master arbitration. This effectively
forms a second level of arbitration for access to the memory
controller through the AHB Slave Memory device. The AHB pre-fetch
logic can be configured to enhance performance for devices doing
sequential access. Each AHB master is assigned to either the high or
low priority bin. Both Tegra20/30 have this AHB bus.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
Update:
- Use platform_device to get info from dt dynamically.(Felipe/Arnd)
---
 arch/arm/mach-tegra/Makefile    |    1 +
 arch/arm/mach-tegra/tegra-ahb.c |  285 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 286 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 2eb4445..f6c8237 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -1,3 +1,4 @@
+obj-y                                   += tegra-ahb.o
 obj-y                                   += board-pinmux.o
 obj-y                                   += common.o
 obj-y                                   += devices.o
diff --git a/arch/arm/mach-tegra/tegra-ahb.c b/arch/arm/mach-tegra/tegra-ahb.c
new file mode 100644
index 0000000..71b5950
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra-ahb.c
@@ -0,0 +1,285 @@
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
+#include <mach/iomap.h>
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
+struct __tegra_ahb {
+	void __iomem	*regs;
+	struct device	*dev;
+};
+
+static struct __tegra_ahb *tegra_ahb;
+
+static inline unsigned long gizmo_readl(unsigned long offset)
+{
+	return readl(tegra_ahb->regs + offset);
+}
+
+static inline void gizmo_writel(unsigned long value, unsigned long offset)
+{
+	writel(value, tegra_ahb->regs + offset);
+}
+
+struct __ahb_gizmo {
+	unsigned long offset;
+	unsigned long data;
+};
+
+static struct __ahb_gizmo ahb_gizmo[] = {
+	{ .offset = AHB_ARBITRATION_DISABLE, },
+	{ .offset = AHB_ARBITRATION_PRIORITY_CTRL, },
+	{ .offset = AHB_GIZMO_AHB_MEM, },
+	{ .offset = AHB_GIZMO_APB_DMA, },
+	{ .offset = AHB_GIZMO_IDE, },
+	{ .offset = AHB_GIZMO_USB, },
+	{ .offset = AHB_GIZMO_AHB_XBAR_BRIDGE, },
+	{ .offset = AHB_GIZMO_CPU_AHB_BRIDGE, },
+	{ .offset = AHB_GIZMO_COP_AHB_BRIDGE, },
+	{ .offset = AHB_GIZMO_XBAR_APB_CTLR, },
+	{ .offset = AHB_GIZMO_VCP_AHB_BRIDGE, },
+	{ .offset = AHB_GIZMO_NAND, },
+	{ .offset = AHB_GIZMO_SDMMC4, },
+	{ .offset = AHB_GIZMO_XIO, },
+	{ .offset = AHB_GIZMO_BSEV, },
+	{ .offset = AHB_GIZMO_BSEA, },
+	{ .offset = AHB_GIZMO_NOR, },
+	{ .offset = AHB_GIZMO_USB2, },
+	{ .offset = AHB_GIZMO_USB3, },
+	{ .offset = AHB_GIZMO_SDMMC1, },
+	{ .offset = AHB_GIZMO_SDMMC2, },
+	{ .offset = AHB_GIZMO_SDMMC3, },
+	{ .offset = AHB_MEM_PREFETCH_CFG_X, },
+	{ .offset = AHB_ARBITRATION_XBAR_CTRL, },
+	{ .offset = AHB_MEM_PREFETCH_CFG3, },
+	{ .offset = AHB_MEM_PREFETCH_CFG4, },
+	{ .offset = AHB_MEM_PREFETCH_CFG1, },
+	{ .offset = AHB_MEM_PREFETCH_CFG2, },
+	{ .offset = AHB_ARBITRATION_AHB_MEM_WRQUE_MST_ID, },
+};
+
+static int tegra_ahb_suspend(struct device *dev)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(ahb_gizmo); i++)
+		ahb_gizmo[i].data = gizmo_readl(ahb_gizmo[i].offset);
+	return 0;
+}
+
+static int tegra_ahb_resume(struct device *dev)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(ahb_gizmo); i++)
+		gizmo_writel(ahb_gizmo[i].data, ahb_gizmo[i].offset);
+	return 0;
+}
+
+static void tegra_ahb_gizmo_init(void)
+{
+	unsigned long val;
+
+	val = gizmo_readl(AHB_GIZMO_AHB_MEM);
+	val |= ENB_FAST_REARBITRATE | IMMEDIATE | DONT_SPLIT_AHB_WR;
+	gizmo_writel(val, AHB_GIZMO_AHB_MEM);
+
+	val = gizmo_readl(AHB_GIZMO_USB);
+	val |= IMMEDIATE;
+	gizmo_writel(val, AHB_GIZMO_USB);
+
+	val = gizmo_readl(AHB_GIZMO_USB2);
+	val |= IMMEDIATE;
+	gizmo_writel(val, AHB_GIZMO_USB2);
+
+	val = gizmo_readl(AHB_GIZMO_USB3);
+	val |= IMMEDIATE;
+	gizmo_writel(val, AHB_GIZMO_USB3);
+
+	val = gizmo_readl(AHB_ARBITRATION_PRIORITY_CTRL);
+	val |= PRIORITY_SELECT_USB |
+		PRIORITY_SELECT_USB2 |
+		PRIORITY_SELECT_USB3 |
+		AHB_PRIORITY_WEIGHT(7);
+	gizmo_writel(val, AHB_ARBITRATION_PRIORITY_CTRL);
+
+	val = gizmo_readl(AHB_MEM_PREFETCH_CFG1);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		AHBDMA_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(val, AHB_MEM_PREFETCH_CFG1);
+
+	val = gizmo_readl(AHB_MEM_PREFETCH_CFG2);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		USB_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(val, AHB_MEM_PREFETCH_CFG2);
+
+	val = gizmo_readl(AHB_MEM_PREFETCH_CFG3);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		USB3_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(val, AHB_MEM_PREFETCH_CFG3);
+
+	val = gizmo_readl(AHB_MEM_PREFETCH_CFG4);
+	val &= ~MST_ID(~0);
+	val |= PREFETCH_ENB |
+		USB2_MST_ID |
+		ADDR_BNDRY(0xc) |
+		INACTIVITY_TIMEOUT(0x1000);
+	gizmo_writel(val, AHB_MEM_PREFETCH_CFG4);
+}
+
+static int __devinit tegra_ahb_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+
+	if (tegra_ahb)
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	res = devm_request_mem_region(&pdev->dev, res->start,
+				      resource_size(res), dev_name(&pdev->dev));
+	if (!res)
+		return -EBUSY;
+
+	tegra_ahb = devm_kzalloc(&pdev->dev, sizeof(*tegra_ahb), GFP_KERNEL);
+	if (!tegra_ahb)
+		return -ENOMEM;
+	tegra_ahb->dev = &pdev->dev;
+	tegra_ahb->regs = devm_ioremap(&pdev->dev,
+				       res->start, resource_size(res));
+	if (!tegra_ahb->regs) {
+		tegra_ahb = NULL;
+		return -ENOMEM;
+	}
+	platform_set_drvdata(pdev, tegra_ahb);
+	tegra_ahb_gizmo_init();
+	return 0;
+}
+
+static int __devexit tegra_ahb_remove(struct platform_device *pdev)
+{
+	platform_set_drvdata(pdev, NULL);
+	tegra_ahb = NULL;
+	return 0;
+}
+
+static const struct of_device_id tegra_ahb_of_match[] __devinitconst = {
+	{ .compatible = "nvidia,tegra30-ahb", },
+	{ .compatible = "nvidia,tegra20-ahb", },
+	{},
+};
+
+static const struct dev_pm_ops tegra_ahb_pm_ops __devinitconst = {
+	SET_RUNTIME_PM_OPS(tegra_ahb_suspend, tegra_ahb_resume, NULL)
+};
+
+static struct platform_driver tegra_ahb_driver = {
+	.probe = tegra_ahb_probe,
+	.remove = __devexit_p(tegra_ahb_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_ahb_of_match,
+		.pm = &tegra_ahb_pm_ops,
+	},
+};
+
+static int __init tegra_ahb_init(void)
+{
+	return platform_driver_register(&tegra_ahb_driver);
+}
+postcore_initcall(tegra_ahb_init);
+
+static void __exit tegra_ahb_exit(void)
+{
+	platform_driver_unregister(&tegra_ahb_driver);
+}
+module_exit(tegra_ahb_exit);
+
+MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
+MODULE_DESCRIPTION("Tegra AHB driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.5.4

