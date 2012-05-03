Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2ECQwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:52:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6456 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2ECQwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:52:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 May 2012 09:51:40 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/1] ARM: tegra: Add Tegra Memory Controller(MC) driver
Date: Thu,  3 May 2012 19:51:37 +0300
Message-Id: <1336063897-12083-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra Memory Controller(MC) driver for Tegra20/30.
Added to support MC General interrupts, mainly for IOMMU.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
The location of a file may not be suitable because of xxx_driver under arch/arm/mach-*.
---
diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 2eb4445..4001cc8 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -1,3 +1,4 @@
+obj-y                                   += tegra-mc.o
 obj-y                                   += board-pinmux.o
 obj-y                                   += common.o
 obj-y                                   += devices.o
diff --git a/arch/arm/mach-tegra/tegra-mc.c b/arch/arm/mach-tegra/tegra-mc.c
new file mode 100644
index 0000000..7af2a99
--- /dev/null
+++ b/arch/arm/mach-tegra/tegra-mc.c
@@ -0,0 +1,502 @@
+/*
+ * Tegra Memory Controller
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
+#include <linux/of.h>
+#include <linux/of_device.h>
+
+#define DRV_NAME "tegra-mc"
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
+#define MC_INT_INVALID_SMMU_PAGE	BIT(MC_INT_ERR_SHIFT + 4)
+
+#define MC_ERR_STATUS			0x8
+#define MC_ERR_ADR			0xc
+
+#define MC_ERR_TYPE_SHIFT		28
+#define MC_ERR_TYPE_MASK		(7 << MC_ERR_TYPE_SHIFT)
+#define MC_ERR_TYPE_DECERR_EMEM		2
+#define MC_ERR_TYPE_SECURITY_TRUSTZONE	3
+#define MC_ERR_TYPE_SECURITY_CARVEOUT	4
+#define MC_ERR_TYPE_INVALID_SMMU_PAGE	6
+
+#define MC_ERR_INVALID_SMMU_PAGE_SHIFT	25
+#define MC_ERR_INVALID_SMMU_PAGE_MASK	(7 << MC_ERR_INVALID_SMMU_PAGE_SHIFT)
+#define MC_ERR_RW_SHIFT			16
+#define MC_ERR_RW			BIT(MC_ERR_RW_SHIFT)
+#define MC_ERR_SECURITY			BIT(MC_ERR_RW_SHIFT + 1)
+
+#define MC_GART_ERROR_REQ		0x30
+#define MC_GART_ERROR_ADDR		0x34
+
+#define MC_DECERR_EMEM_OTHERS_STATUS	0x58
+#define MC_DECERR_EMEM_OTHERS_ADR	0x5c
+
+#define MC_SECURITY_VIOLATION_STATUS	0x74
+#define MC_SECURITY_VIOLATION_ADR	0x78
+
+#define SECURITY_VIOLATION_TYPE		BIT(30)	/* 0=TRUSTZONE, 1=CARVEOUT */
+
+#define MC_EMEM_ARB_CFG			0x90
+#define MC_EMEM_ARB_OUTSTANDING_REQ	0x94
+#define MC_EMEM_ARB_TIMING_RCD		0x98
+#define MC_EMEM_ARB_TIMING_RP		0x9c
+#define MC_EMEM_ARB_TIMING_RC		0xa0
+#define MC_EMEM_ARB_TIMING_RAS		0xa4
+#define MC_EMEM_ARB_TIMING_FAW		0xa8
+#define MC_EMEM_ARB_TIMING_RRD		0xac
+#define MC_EMEM_ARB_TIMING_RAP2PRE	0xb0
+#define MC_EMEM_ARB_TIMING_WAP2PRE	0xb4
+#define MC_EMEM_ARB_TIMING_R2R		0xb8
+#define MC_EMEM_ARB_TIMING_W2W		0xbc
+#define MC_EMEM_ARB_TIMING_R2W		0xc0
+#define MC_EMEM_ARB_TIMING_W2R		0xc4
+
+#define MC_EMEM_ARB_DA_TURNS		0xd0
+#define MC_EMEM_ARB_DA_COVERS		0xd4
+#define MC_EMEM_ARB_MISC0		0xd8
+#define MC_EMEM_ARB_MISC1		0xdc
+
+#define MC_EMEM_ARB_RING3_THROTTLE	0xe4
+#define MC_EMEM_ARB_OVERRIDE		0xe8
+
+#define MC_TIMING_CONTROL		0xfc
+
+static const char * const mc_int_err[] = {
+	"MC_DECERR",
+	"MC_GART_ERR",
+	"MC_SECURITY_ERR",
+	"MC_ARBITRATION_EMEM",
+	"MC_SMMU_ERR",
+};
+
+struct tegra_mc;
+
+struct tegra_mc_info {
+	u32 intmask;
+	void (*decode)(struct tegra_mc *mc, u32 stat);
+	const char * const *client;
+	int num_client;
+	u32 id_mask;
+};
+
+struct tegra_mc {
+	void __iomem *regs;
+	struct device *dev;
+	struct tegra_mc_info *info;
+	u32 ctx[0];
+};
+
+static inline u32 mc_readl(struct tegra_mc *mc, u32 offset)
+{
+	return readl(mc->regs + offset);
+}
+
+static inline void mc_writel(struct tegra_mc *mc, u32 value, u32 offset)
+{
+	writel(value, mc->regs + offset);
+}
+
+#ifdef CONFIG_ARCH_TEGRA_2x_SOC
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
+static void tegra20_mc_decode(struct tegra_mc *mc, u32 stat)
+{
+	u32 addr, req;
+	const char *client = "Unknown";
+	int idx, cid;
+	struct reg_info {
+		u32 offset;
+		u32 write_bit;	/* 0=READ, 1=WRITE */
+		int cid_shift;
+	} reg[] = {
+		{
+			.offset = MC_DECERR_EMEM_OTHERS_STATUS,
+			.write_bit = 31,
+		},
+		{
+			.offset	= MC_GART_ERROR_REQ,
+			.cid_shift = 1,
+		},
+		{
+			.offset = MC_SECURITY_VIOLATION_STATUS,
+			.write_bit = 31,
+		},
+	};
+
+	idx = __ffs(stat >> MC_INT_ERR_SHIFT);
+	req = mc_readl(mc, reg[idx].offset);
+	cid = (req >> reg[idx].cid_shift) & mc->info->id_mask;
+	addr = mc_readl(mc, reg[idx].offset + sizeof(u32));
+
+	if (cid < mc->info->num_client)
+		client = mc->info->client[cid];
+
+	pr_err_ratelimited("%s (0x%08x): 0x%08x %s (%s %s)\n",
+			   mc_int_err[idx], req, addr, client,
+			   (req & (1 << reg[idx].write_bit)) ? "write" : "read",
+			   (reg[idx].offset == MC_SECURITY_VIOLATION_STATUS) ?
+			   ((req & SECURITY_VIOLATION_TYPE) ?
+			    "carveout" : "trustzone") : "");
+}
+
+static struct tegra_mc_info tegra20_mc_info = {
+	.intmask = MC_INT_INVALID_GART_PAGE,
+	.decode = tegra20_mc_decode,
+	.client = tegra20_mc_client,
+	.num_client = ARRAY_SIZE(tegra20_mc_client),
+	.id_mask = 0x3f,
+};
+#else
+static struct tegra_mc_info tegra20_mc_info = {};
+#endif	/* CONFIG_ARCH_TEGRA_2x_SOC */
+
+#ifdef CONFIG_ARCH_TEGRA_3x_SOC
+static const char * const tegra30_mc_client[] = {
+	"csr_ptcr",
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
+	"csr_afir",
+	"csr_avpcarm7r",
+	"csr_displayhc",
+	"csr_displayhcb",
+	"csr_fdcdrd",
+	"csr_fdcdrd2",
+	"csr_g2dr",
+	"csr_hdar",
+	"csr_host1xdmar",
+	"csr_host1xr",
+	"csr_idxsrd",
+	"csr_idxsrd2",
+	"csr_mpe_ipred",
+	"csr_mpeamemrd",
+	"csr_mpecsrd",
+	"csr_ppcsahbdmar",
+	"csr_ppcsahbslvr",
+	"csr_satar",
+	"csr_texsrd",
+	"csr_texsrd2",
+	"csr_vdebsevr",
+	"csr_vdember",
+	"csr_vdemcer",
+	"csr_vdetper",
+	"csr_mpcorelpr",
+	"csr_mpcorer",
+	"cbw_eppu",
+	"cbw_eppv",
+	"cbw_eppy",
+	"cbw_mpeunifbw",
+	"cbw_viwsb",
+	"cbw_viwu",
+	"cbw_viwv",
+	"cbw_viwy",
+	"ccw_g2dw",
+	"csw_afiw",
+	"csw_avpcarm7w",
+	"csw_fdcdwr",
+	"csw_fdcdwr2",
+	"csw_hdaw",
+	"csw_host1xw",
+	"csw_ispw",
+	"csw_mpcorelpw",
+	"csw_mpcorew",
+	"csw_mpecswr",
+	"csw_ppcsahbdmaw",
+	"csw_ppcsahbslvw",
+	"csw_sataw",
+	"csw_vdebsevw",
+	"csw_vdedbgw",
+	"csw_vdembew",
+	"csw_vdetpmw",
+};
+
+static void tegra30_mc_decode(struct tegra_mc *mc, u32 stat)
+{
+	u32 err, addr;
+	char *err_type[] = {
+		"Unknown",
+		"Unknown",
+		"DECERR_EMEM",
+		"SECURITY_TRUSTZONE",
+		"SECURITY_CARVEOUT",
+		"Unknown",
+		"INVALID_SMMU_PAGE",
+		"Unknown",
+	};
+	char attr[6];
+	int cid, perm, type, idx;
+	const char *client = "Unknown";
+
+	err = readl(mc + MC_ERR_STATUS);
+	addr = readl(mc + MC_ERR_ADR);
+
+	idx = __ffs(stat >> MC_INT_ERR_SHIFT);
+	type = (err & MC_ERR_TYPE_MASK) >> MC_ERR_TYPE_SHIFT;
+
+	cid = err & mc->info->id_mask;
+	if (cid < mc->info->num_client)
+		client = mc->info->client[cid];
+
+	perm = (err & MC_ERR_INVALID_SMMU_PAGE_MASK) >>
+		MC_ERR_INVALID_SMMU_PAGE_SHIFT;
+
+	if (type == MC_ERR_TYPE_INVALID_SMMU_PAGE)
+		sprintf(attr, "%c-%c-%c",
+			(perm & BIT(2)) ? 'R' : '-',
+			(perm & BIT(1)) ? 'W' : '-',
+			(perm & BIT(0)) ? 'S' : '-');
+	else
+		attr[0] = '\0';
+
+	pr_err_ratelimited("%s (0x%08x): 0x%08x %s (%s %s %s %s)\n",
+			   mc_int_err[idx], err, addr, client,
+			   (err & MC_ERR_SECURITY) ? "secure" : "non-secure",
+			   (err & MC_ERR_RW) ? "write" : "read",
+			   err_type[type], attr);
+}
+
+static struct tegra_mc_info tegra30_mc_info = {
+	.intmask = MC_INT_INVALID_SMMU_PAGE,
+	.decode = tegra30_mc_decode,
+	.client = tegra30_mc_client,
+	.num_client = ARRAY_SIZE(tegra30_mc_client),
+	.id_mask = 0x7f,
+};
+
+static u32 tegra_mc_ctx[] = {
+	MC_EMEM_ARB_CFG,
+	MC_EMEM_ARB_OUTSTANDING_REQ,
+	MC_EMEM_ARB_TIMING_RCD,
+	MC_EMEM_ARB_TIMING_RP,
+	MC_EMEM_ARB_TIMING_RC,
+	MC_EMEM_ARB_TIMING_RAS,
+	MC_EMEM_ARB_TIMING_FAW,
+	MC_EMEM_ARB_TIMING_RRD,
+	MC_EMEM_ARB_TIMING_RAP2PRE,
+	MC_EMEM_ARB_TIMING_WAP2PRE,
+	MC_EMEM_ARB_TIMING_R2R,
+	MC_EMEM_ARB_TIMING_W2W,
+	MC_EMEM_ARB_TIMING_R2W,
+	MC_EMEM_ARB_TIMING_W2R,
+	MC_EMEM_ARB_DA_TURNS,
+	MC_EMEM_ARB_DA_COVERS,
+	MC_EMEM_ARB_MISC0,
+	MC_EMEM_ARB_MISC1,
+	MC_EMEM_ARB_RING3_THROTTLE,
+	MC_EMEM_ARB_OVERRIDE,
+	MC_INTMASK,
+};
+
+static int tegra_mc_suspend(struct device *dev)
+{
+	int i;
+	struct tegra_mc *mc = dev_get_drvdata(dev);
+
+	for (i = 0; i < ARRAY_SIZE(tegra_mc_ctx); i++)
+		mc->ctx[i] = mc_readl(mc, tegra_mc_ctx[i]);
+	return 0;
+}
+
+static int tegra_mc_resume(struct device *dev)
+{
+	int i;
+	struct tegra_mc *mc = dev_get_drvdata(dev);
+
+	for (i = 0; i < ARRAY_SIZE(tegra_mc_ctx); i++)
+		mc_writel(mc, mc->ctx[i], tegra_mc_ctx[i]);
+
+	mc_writel(mc, 1, MC_TIMING_CONTROL);
+	/* Read-back to ensure that write reached */
+	mc_readl(mc, MC_TIMING_CONTROL);
+	return 0;
+}
+
+#else
+static u32 tegra_mc_ctx[0];
+#define tegra_mc_suspend	NULL
+#define tegra_mc_resume		NULL
+static struct tegra_mc_info tegra30_mc_info = {};
+#endif	/* CONFIG_ARCH_TEGRA_3x_SOC */
+
+static UNIVERSAL_DEV_PM_OPS(tegra_mc_pm,
+			    tegra_mc_suspend,
+			    tegra_mc_resume, NULL);
+
+static const struct of_device_id tegra_mc_of_match[] __devinitconst = {
+	{ .compatible = "nvidia,tegra30-mc", .data = &tegra30_mc_info, },
+	{ .compatible = "nvidia,tegra20-mc", .data = &tegra20_mc_info, },
+	{},
+};
+
+static irqreturn_t tegra_mc_isr(int irq, void *data)
+{
+	u32 stat, mask, bit;
+	struct tegra_mc *mc = data;
+
+	stat = mc_readl(mc, MC_INTSTATUS);
+	mask = mc_readl(mc, MC_INTMASK);
+	mask &= stat;
+	while ((bit = ffs(mask)) != 0)
+		mc->info->decode(mc, 1 << (bit - 1));
+	mc_writel(mc, stat, MC_INTSTATUS);
+	return IRQ_HANDLED;
+}
+
+static int __devinit tegra_mc_probe(struct platform_device *pdev)
+{
+	struct resource *res;
+	struct tegra_mc *mc;
+	size_t bytes;
+	int err;
+	const struct of_device_id *id;
+	struct tegra_mc_info *info;
+
+	bytes = sizeof(*mc) + sizeof(u32) * ARRAY_SIZE(tegra_mc_ctx);
+	mc = devm_kzalloc(&pdev->dev, bytes, GFP_KERNEL);
+	if (!mc)
+		return -ENOMEM;
+	mc->dev = &pdev->dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+	mc->regs = devm_request_and_ioremap(&pdev->dev, res);
+	if (!mc->regs)
+		return -EBUSY;
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res)
+		return -ENODEV;
+	err = devm_request_irq(&pdev->dev, res->start, tegra_mc_isr,
+			       IRQF_SHARED, dev_name(&pdev->dev), mc);
+	if (err)
+		return -ENODEV;
+
+	id = of_match_device(tegra_mc_of_match, &pdev->dev);
+	if (!id)
+		return -ENODEV;
+	platform_set_drvdata(pdev, mc);
+
+	info = id->data;
+	if (!info)
+		return -EINVAL;
+	mc->info = info;
+	info->intmask |= MC_INT_DECERR_EMEM | MC_INT_SECURITY_VIOLATION;
+	mc_writel(mc, info->intmask, MC_INTMASK);
+	return 0;
+}
+
+static int __devexit tegra_mc_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver tegra_mc_driver = {
+	.probe = tegra_mc_probe,
+	.remove = __devexit_p(tegra_mc_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = tegra_mc_of_match,
+		.pm = &tegra_mc_pm,
+	},
+};
+module_platform_driver(tegra_mc_driver);
+
+MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
+MODULE_DESCRIPTION("Tegra MC driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.7.5.4

