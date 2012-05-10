Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2EJHnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:43:15 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17822 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891Ab2EJHnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:43:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 10 May 2012 00:42:57 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benoit Cousson <b-cousson@ti.com>, Aneesh V <aneesh@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/4] ARM: tegra20: Add Tegra Memory Controller(MC) driver
Date: Thu, 10 May 2012 10:42:30 +0300
Message-ID: <1336635764-30597-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra Memory Controller(MC) driver for Tegra20
Added to support MC General interrupts, mainly for IOMMU(GART).

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 .../bindings/arm/tegra/nvidia,tegra20-mc.txt       |   16 ++
 arch/arm/mach-tegra/Kconfig                        |    2 +
 drivers/memory/Kconfig                             |    4 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/tegra20-mc.c                        |  262 ++++++++++++++++++++
 5 files changed, 285 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-mc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-mc.txt
new file mode 100644
index 0000000..c25a0a5
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-mc.txt
@@ -0,0 +1,16 @@
+NVIDIA Tegra20 MC(Memory Controller)
+
+Required properties:
+- compatible : "nvidia,tegra20-mc"
+- reg : Should contain 2 register ranges(address and length); see the
+  example below. Note that the MC registers are interleaved with the
+  GART registers, and hence must be represented as multiple ranges.
+- interrupts : Should contain MC General interrupt.
+
+Example:
+	mc {
+		compatible = "nvidia,tegra20-mc";
+		reg = <0x7000f000 0x024
+		       0x7000f03c 0x3c4>;
+		interrupts = <0 77 0x04>;
+	};
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 6a113a9..abaf5d0 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -20,6 +20,8 @@ config ARCH_TEGRA_2x_SOC
 	select PL310_ERRATA_727915 if CACHE_L2X0
 	select PL310_ERRATA_769419 if CACHE_L2X0
 	select CPU_FREQ_TABLE if CPU_FREQ
+	select MEMORY
+	select TEGRA20_MC
 	help
 	  Support for NVIDIA Tegra AP20 and T20 processors, based on the
 	  ARM CortexA9MP CPU and the ARM PL310 L2 cache controller
diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index e0b3156..ebade16 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -20,4 +20,8 @@ config TI_EMIF
 	  parameters and other settings during frequency, voltage and
 	  temperature changes
 
+config TEGRA20_MC
+	bool
+	depends on ARCH_TEGRA_2x_SOC
+
 endif
diff --git a/drivers/memory/Makefile b/drivers/memory/Makefile
index e27f80b..1f58518 100644
--- a/drivers/memory/Makefile
+++ b/drivers/memory/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_TI_EMIF)		+= emif.o
+obj-$(CONFIG_TEGRA20_MC)	+= tegra20-mc.o
diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
new file mode 100644
index 0000000..c0bfffa
--- /dev/null
+++ b/drivers/memory/tegra20-mc.c
@@ -0,0 +1,262 @@
+/*
+ * Tegra20 Memory Controller
+ *
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
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
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/ratelimit.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#define DRV_NAME "tegra20-mc"
+
+#define MC_INTSTATUS			0x0
+#define MC_INTMASK			0x4
+
+#define MC_INT_ERR_SHIFT		6
+#define MC_INT_ERR_MASK			(0x1f << MC_INT_ERR_SHIFT)
+#define MC_INT_DECERR_EMEM		BIT(MC_INT_ERR_SHIFT)
+#define MC_INT_INVALID_GART_PAGE	BIT(MC_INT_ERR_SHIFT + 1)
+#define MC_INT_SECURITY_VIOLATION	BIT(MC_INT_ERR_SHIFT + 2)
+#define MC_INT_ARBITRATION_EMEM		BIT(MC_INT_ERR_SHIFT + 3)
+
+#define MC_GART_ERROR_REQ		0x30
+#define MC_DECERR_EMEM_OTHERS_STATUS	0x58
+#define MC_SECURITY_VIOLATION_STATUS	0x74
+
+#define SECURITY_VIOLATION_TYPE		BIT(30)	/* 0=TRUSTZONE, 1=CARVEOUT */
+
+#define MC_CLIENT_ID_MASK		0x3f
+
+#define NUM_MC_REG_BANKS		2
+
+struct tegra20_mc {
+	void __iomem *regs[NUM_MC_REG_BANKS];
+	struct device *dev;
+};
+
+static inline u32 mc_readl(struct tegra20_mc *mc, u32 offs)
+{
+	if (offs < 0x24)
+		return readl(mc->regs[0] + offs);
+	BUG_ON(offs < 0x3c);
+	if (offs < 0x400)
+		return readl(mc->regs[1] + offs - 0x3c);
+	BUG();
+}
+
+static inline void mc_writel(struct tegra20_mc *mc, u32 val, u32 offs)
+{
+	if (offs < 0x24) {
+		writel(val, mc->regs[0] + offs);
+		return;
+	}
+	BUG_ON(offs < 0x3c);
+	if (offs < 0x400) {
+		writel(val, mc->regs[1] + offs - 0x3c);
+		return;
+	}
+	BUG();
+}
+
+static const char * const tegra20_mc_client[] = {
+	"cbr_display0a",
+	"cbr_display0ab",
+	"cbr_display0b",
+	"cbr_display0bb",
+	"cbr_display0c",
+	"cbr_display0cb",
+	"cbr_display1b",
+	"cbr_display1bb",
+	"cbr_eppup",
+	"cbr_g2pr",
+	"cbr_g2sr",
+	"cbr_mpeunifbr",
+	"cbr_viruv",
+	"csr_avpcarm7r",
+	"csr_displayhc",
+	"csr_displayhcb",
+	"csr_fdcdrd",
+	"csr_g2dr",
+	"csr_host1xdmar",
+	"csr_host1xr",
+	"csr_idxsrd",
+	"csr_mpcorer",
+	"csr_mpe_ipred",
+	"csr_mpeamemrd",
+	"csr_mpecsrd",
+	"csr_ppcsahbdmar",
+	"csr_ppcsahbslvr",
+	"csr_texsrd",
+	"csr_vdebsevr",
+	"csr_vdember",
+	"csr_vdemcer",
+	"csr_vdetper",
+	"cbw_eppu",
+	"cbw_eppv",
+	"cbw_eppy",
+	"cbw_mpeunifbw",
+	"cbw_viwsb",
+	"cbw_viwu",
+	"cbw_viwv",
+	"cbw_viwy",
+	"ccw_g2dw",
+	"csw_avpcarm7w",
+	"csw_fdcdwr",
+	"csw_host1xw",
+	"csw_ispw",
+	"csw_mpcorew",
+	"csw_mpecswr",
+	"csw_ppcsahbdmaw",
+	"csw_ppcsahbslvw",
+	"csw_vdebsevw",
+	"csw_vdembew",
+	"csw_vdetpmw",
+};
+
+static void tegra20_mc_decode(struct tegra20_mc *mc, int n)
+{
+	u32 addr, req;
+	const char *client = "Unknown";
+	int idx, cid;
+	const struct reg_info {
+		u32 offset;
+		u32 write_bit;	/* 0=READ, 1=WRITE */
+		int cid_shift;
+		char *message;
+	} reg[] = {
+		{
+			.offset = MC_DECERR_EMEM_OTHERS_STATUS,
+			.write_bit = 31,
+			.message = "MC_DECERR",
+		},
+		{
+			.offset	= MC_GART_ERROR_REQ,
+			.cid_shift = 1,
+			.message = "MC_GART_ERR",
+
+		},
+		{
+			.offset = MC_SECURITY_VIOLATION_STATUS,
+			.write_bit = 31,
+			.message = "MC_SECURITY_ERR",
+		},
+	};
+
+	idx = n - MC_INT_ERR_SHIFT;
+	if ((idx < 0) || (idx >= ARRAY_SIZE(reg))) {
+		pr_err_ratelimited("Unknown interrupt status %08lx\n", BIT(n));
+		return;
+	}
+
+	req = mc_readl(mc, reg[idx].offset);
+	cid = (req >> reg[idx].cid_shift) & MC_CLIENT_ID_MASK;
+	if (cid < ARRAY_SIZE(tegra20_mc_client))
+		client = tegra20_mc_client[cid];
+
+	addr = mc_readl(mc, reg[idx].offset + sizeof(u32));
+
+	pr_err_ratelimited("%s (0x%08x): 0x%08x %s (%s %s)\n",
+			   reg[idx].message, req, addr, client,
+			   (req & BIT(reg[idx].write_bit)) ? "write" : "read",
+			   (reg[idx].offset == MC_SECURITY_VIOLATION_STATUS) ?
+			   ((req & SECURITY_VIOLATION_TYPE) ?
+			    "carveout" : "trustzone") : "");
+}
+
+static const struct of_device_id tegra20_mc_of_match[] __devinitconst = {
+	{ .compatible = "nvidia,tegra20-mc", },
+	{},
+};
+
+static irqreturn_t tegra20_mc_isr(int irq, void *data)
+{
+	u32 stat, mask, bit;
+	struct tegra20_mc *mc = data;
+
+	stat = mc_readl(mc, MC_INTSTATUS);
+	mask = mc_readl(mc, MC_INTMASK);
+	mask &= stat;
+	if (!mask)
+		return IRQ_NONE;
+	while ((bit = ffs(mask)) != 0)
+		tegra20_mc_decode(mc, bit - 1);
+	mc_writel(mc, stat, MC_INTSTATUS);
+	return IRQ_HANDLED;
+}
+
+static int __devinit tegra20_mc_probe(struct platform_device *pdev)
+{
+	struct resource *irq;
+	struct tegra20_mc *mc;
+	int i, err;
+	u32 intmask;
+
+	mc = devm_kzalloc(&pdev->dev, sizeof(*mc), GFP_KERNEL);
+	if (!mc)
+		return -ENOMEM;
+	mc->dev = &pdev->dev;
+
+	for (i = 0; i < ARRAY_SIZE(mc->regs); i++) {
+		struct resource *res;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res)
+			return -ENODEV;
+		mc->regs[i] = devm_request_and_ioremap(&pdev->dev, res);
+		if (!mc->regs[i])
+			return -EBUSY;
+	}
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!irq)
+		return -ENODEV;
+	err = devm_request_irq(&pdev->dev, irq->start, tegra20_mc_isr,
+			       IRQF_SHARED, dev_name(&pdev->dev), mc);
+	if (err)
+		return -ENODEV;
+
+	platform_set_drvdata(pdev, mc);
+
+	intmask = MC_INT_INVALID_GART_PAGE |
+		MC_INT_DECERR_EMEM | MC_INT_SECURITY_VIOLATION;
+	mc_writel(mc, intmask, MC_INTMASK);
+	return 0;
+}
+
+static int __devexit tegra20_mc_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver tegra20_mc_driver = {
+	.probe = tegra20_mc_probe,
+	.remove = __devexit_p(tegra20_mc_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = tegra20_mc_of_match,
+	},
+};
+module_platform_driver(tegra20_mc_driver);
+
+MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
+MODULE_DESCRIPTION("Tegra20 MC driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.5.4

