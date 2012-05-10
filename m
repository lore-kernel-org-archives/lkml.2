Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134Ab2EJHun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:50:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18553 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab2EJHuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:50:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 May 2012 00:49:55 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Joerg Roedel <joerg.roedel@amd.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>, Jiri Kosina <jkosina@suse.cz>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
Date: Thu, 10 May 2012 10:50:20 +0300
Message-ID: <1336636221-31575-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336636221-31575-1-git-send-email-hdoyu@nvidia.com>
References: <1336636221-31575-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The necessary info is expected to pass from DT.

For more precise resource reservation, there shouldn't be any
overlapping of register range between SMMU and MC. SMMU register
offset needs to be calculated correctly, based on its register bank.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
This patch requires the following ones, sent earlier:

DMA window:
http://article.gmane.org/gmane.linux.ports.tegra/4603

AHB:
http://article.gmane.org/gmane.linux.ports.tegra/4657
---
 .../bindings/iommu/nvidia,tegra30-smmu.txt         |   21 +++
 drivers/iommu/Kconfig                              |    2 +-
 drivers/iommu/tegra-smmu.c                         |  150 +++++++++++++-------
 3 files changed, 118 insertions(+), 55 deletions(-)

diff --git a/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt
new file mode 100644
index 0000000..89fb543
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt
@@ -0,0 +1,21 @@
+NVIDIA Tegra 30 IOMMU H/W, SMMU (System Memory Management Unit)
+
+Required properties:
+- compatible : "nvidia,tegra30-smmu"
+- reg : Should contain 3 register banks(address and length) for each
+  of the SMMU register blocks.
+- interrupts : Should contain MC General interrupt.
+- nvidia,#asids : # of ASIDs
+- dma-window : IOVA start address and length.
+- nvidia,ahb : phandle to the ahb bus connected to SMMU.
+
+Example:
+	smmu {
+		compatible = "nvidia,tegra30-smmu";
+		reg = <0x7000f010 0x02c
+		       0x7000f1f0 0x010
+		       0x7000f228 0x05c>;
+		nvidia,#asids = <4>;		/* # of ASIDs */
+		dma-window = <0 0x40000000>;	/* IOVA start & length */
+		nvidia,ahb = <&ahb>;
+	};
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index c698437..bc711b3 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -154,7 +154,7 @@ config TEGRA_IOMMU_GART
 
 config TEGRA_IOMMU_SMMU
 	bool "Tegra SMMU IOMMU Support"
-	depends on ARCH_TEGRA_3x_SOC
+	depends on ARCH_TEGRA_3x_SOC && TEGRA_AHB
 	select IOMMU_API
 	help
 	  Enables support for remapping discontiguous physical memory
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index ecd6790..dbaba77 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -30,12 +30,15 @@
 #include <linux/sched.h>
 #include <linux/iommu.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 
 #include <mach/iomap.h>
 #include <mach/smmu.h>
+#include <mach/tegra-ahb.h>
 
 /* bitmap of the page sizes currently supported */
 #define SMMU_IOMMU_PGSIZES	(SZ_4K)
@@ -111,12 +114,6 @@
 
 #define SMMU_PDE_NEXT_SHIFT		28
 
-/* AHB Arbiter Registers */
-#define AHB_XBAR_CTRL				0xe0
-#define AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE	1
-#define AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT	17
-
-#define SMMU_NUM_ASIDS				4
 #define SMMU_TLB_FLUSH_VA_SECTION__MASK		0xffc00000
 #define SMMU_TLB_FLUSH_VA_SECTION__SHIFT	12 /* right shift */
 #define SMMU_TLB_FLUSH_VA_GROUP__MASK		0xffffc000
@@ -136,6 +133,7 @@
 
 #define SMMU_PAGE_SHIFT 12
 #define SMMU_PAGE_SIZE	(1 << SMMU_PAGE_SHIFT)
+#define SMMU_PAGE_MASK	((1 << SMMU_PAGE_SHIFT) - 1)
 
 #define SMMU_PDIR_COUNT	1024
 #define SMMU_PDIR_SIZE	(sizeof(unsigned long) * SMMU_PDIR_COUNT)
@@ -177,6 +175,8 @@
 #define SMMU_ASID_DISABLE	0
 #define SMMU_ASID_ASID(n)	((n) & ~SMMU_ASID_ENABLE(0))
 
+#define NUM_SMMU_REG_BANKS	3
+
 #define smmu_client_enable_hwgrp(c, m)	smmu_client_set_hwgrp(c, m, 1)
 #define smmu_client_disable_hwgrp(c)	smmu_client_set_hwgrp(c, 0, 0)
 #define __smmu_client_enable_hwgrp(c, m) __smmu_client_set_hwgrp(c, m, 1)
@@ -235,7 +235,7 @@ struct smmu_as {
  * Per SMMU device - IOMMU device
  */
 struct smmu_device {
-	void __iomem	*regs, *regs_ahbarb;
+	void __iomem	*regs[NUM_SMMU_REG_BANKS];
 	unsigned long	iovmm_base;	/* remappable base address */
 	unsigned long	page_count;	/* total remappable size */
 	spinlock_t	lock;
@@ -252,29 +252,47 @@ struct smmu_device {
 	unsigned long translation_enable_1;
 	unsigned long translation_enable_2;
 	unsigned long asid_security;
+
+	struct device_node *ahb;
 };
 
 static struct smmu_device *smmu_handle; /* unique for a system */
 
 /*
- *	SMMU/AHB register accessors
+ *	SMMU register accessors
  */
 static inline u32 smmu_read(struct smmu_device *smmu, size_t offs)
 {
-	return readl(smmu->regs + offs);
-}
-static inline void smmu_write(struct smmu_device *smmu, u32 val, size_t offs)
-{
-	writel(val, smmu->regs + offs);
+	BUG_ON(offs < 0x10);
+	if (offs < 0x3c)
+		return readl(smmu->regs[0] + offs - 0x10);
+	BUG_ON(offs < 0x1f0);
+	if (offs < 0x200)
+		return readl(smmu->regs[1] + offs - 0x1f0);
+	BUG_ON(offs < 0x228);
+	if (offs < 0x284)
+		return readl(smmu->regs[2] + offs - 0x228);
+	BUG();
 }
 
-static inline u32 ahb_read(struct smmu_device *smmu, size_t offs)
-{
-	return readl(smmu->regs_ahbarb + offs);
-}
-static inline void ahb_write(struct smmu_device *smmu, u32 val, size_t offs)
+static inline void smmu_write(struct smmu_device *smmu, u32 val, size_t offs)
 {
-	writel(val, smmu->regs_ahbarb + offs);
+	BUG_ON(offs < 0x10);
+	if (offs < 0x3c) {
+		writel(val, smmu->regs[0] + offs - 0x10);
+		return;
+	}
+	BUG_ON(offs < 0x1f0);
+	if (offs < 0x200) {
+		writel(val, smmu->regs[1] + offs - 0x1f0);
+		return;
+	}
+	BUG_ON(offs < 0x228);
+	if (offs < 0x284) {
+		writel(val, smmu->regs[2] + offs - 0x228);
+		return;
+	}
+	BUG();
 }
 
 #define VA_PAGE_TO_PA(va, page)	\
@@ -370,7 +388,7 @@ static void smmu_flush_regs(struct smmu_device *smmu, int enable)
 	FLUSH_SMMU_REGS(smmu);
 }
 
-static void smmu_setup_regs(struct smmu_device *smmu)
+static int smmu_setup_regs(struct smmu_device *smmu)
 {
 	int i;
 	u32 val;
@@ -398,10 +416,7 @@ static void smmu_setup_regs(struct smmu_device *smmu)
 
 	smmu_flush_regs(smmu, 1);
 
-	val = ahb_read(smmu, AHB_XBAR_CTRL);
-	val |= AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
-		AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
-	ahb_write(smmu, val, AHB_XBAR_CTRL);
+	return tegra_ahb_enable_smmu(smmu->ahb);
 }
 
 static void flush_ptc_and_tlb(struct smmu_device *smmu,
@@ -873,52 +888,73 @@ static int tegra_smmu_resume(struct device *dev)
 {
 	struct smmu_device *smmu = dev_get_drvdata(dev);
 	unsigned long flags;
+	int err;
 
 	spin_lock_irqsave(&smmu->lock, flags);
-	smmu_setup_regs(smmu);
+	err = smmu_setup_regs(smmu);
 	spin_unlock_irqrestore(&smmu->lock, flags);
-	return 0;
+	return err;
 }
 
 static int tegra_smmu_probe(struct platform_device *pdev)
 {
 	struct smmu_device *smmu;
-	struct resource *regs, *regs2, *window;
 	struct device *dev = &pdev->dev;
-	int i, err = 0;
+	int i, asids, err = 0;
+	dma_addr_t base;
+	size_t size;
+	const void *prop;
 
 	if (smmu_handle)
 		return -EIO;
 
 	BUILD_BUG_ON(PAGE_SHIFT != SMMU_PAGE_SHIFT);
 
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	regs2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	window = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	if (!regs || !regs2 || !window) {
-		dev_err(dev, "No SMMU resources\n");
-		return -ENODEV;
-	}
-
 	smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
 	if (!smmu) {
 		dev_err(dev, "failed to allocate smmu_device\n");
 		return -ENOMEM;
 	}
 
-	smmu->dev = dev;
-	smmu->num_as = SMMU_NUM_ASIDS;
-	smmu->iovmm_base = (unsigned long)window->start;
-	smmu->page_count = resource_size(window) >> SMMU_PAGE_SHIFT;
-	smmu->regs = devm_ioremap(dev, regs->start, resource_size(regs));
-	smmu->regs_ahbarb = devm_ioremap(dev, regs2->start,
-					 resource_size(regs2));
-	if (!smmu->regs || !smmu->regs_ahbarb) {
-		dev_err(dev, "failed to remap SMMU registers\n");
-		err = -ENXIO;
-		goto fail;
+	for (i = 0; i < ARRAY_SIZE(smmu->regs); i++) {
+		struct resource *res;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res)
+			return -ENODEV;
+		smmu->regs[i] = devm_request_and_ioremap(&pdev->dev, res);
+		if (!smmu->regs[i])
+			return -EBUSY;
 	}
 
+	err = of_get_dma_window(dev->of_node, "dma-window", 0, NULL,
+				&base, &size);
+	if (err)
+		return -ENODEV;
+
+	if (size & SMMU_PAGE_MASK)
+		return -EINVAL;
+
+	size >>= SMMU_PAGE_SHIFT;
+	if (!size)
+		return -EINVAL;
+
+	prop = of_get_property(dev->of_node, "nvidia,#asids", NULL);
+	if (!prop)
+		return -ENODEV;
+	asids = be32_to_cpup(prop);
+	if (!asids)
+		return -ENODEV;
+
+	smmu->ahb = of_parse_phandle(dev->of_node, "nvidia,ahb", 0);
+	if (!smmu->ahb)
+		return -ENODEV;
+
+	smmu->dev = dev;
+	smmu->num_as = asids;
+	smmu->iovmm_base = base;
+	smmu->page_count = size;
+
 	smmu->translation_enable_0 = ~0;
 	smmu->translation_enable_1 = ~0;
 	smmu->translation_enable_2 = ~0;
@@ -945,7 +981,9 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&as->client);
 	}
 	spin_lock_init(&smmu->lock);
-	smmu_setup_regs(smmu);
+	err = smmu_setup_regs(smmu);
+	if (err)
+		goto fail;
 	platform_set_drvdata(pdev, smmu);
 
 	smmu->avp_vector_page = alloc_page(GFP_KERNEL);
@@ -958,10 +996,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 fail:
 	if (smmu->avp_vector_page)
 		__free_page(smmu->avp_vector_page);
-	if (smmu->regs)
-		devm_iounmap(dev, smmu->regs);
-	if (smmu->regs_ahbarb)
-		devm_iounmap(dev, smmu->regs_ahbarb);
 	if (smmu && smmu->as) {
 		for (i = 0; i < smmu->num_as; i++) {
 			if (smmu->as[i].pdir_page) {
@@ -993,8 +1027,6 @@ static int tegra_smmu_remove(struct platform_device *pdev)
 		__free_page(smmu->avp_vector_page);
 	if (smmu->regs)
 		devm_iounmap(dev, smmu->regs);
-	if (smmu->regs_ahbarb)
-		devm_iounmap(dev, smmu->regs_ahbarb);
 	devm_kfree(dev, smmu);
 	smmu_handle = NULL;
 	return 0;
@@ -1005,6 +1037,14 @@ const struct dev_pm_ops tegra_smmu_pm_ops = {
 	.resume		= tegra_smmu_resume,
 };
 
+#ifdef CONFIG_OF
+static struct of_device_id tegra_smmu_of_match[] __devinitdata = {
+	{ .compatible = "nvidia,tegra30-smmu", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tegra_smmu_of_match);
+#endif
+
 static struct platform_driver tegra_smmu_driver = {
 	.probe		= tegra_smmu_probe,
 	.remove		= tegra_smmu_remove,
@@ -1012,6 +1052,7 @@ static struct platform_driver tegra_smmu_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "tegra-smmu",
 		.pm	= &tegra_smmu_pm_ops,
+		.of_match_table = of_match_ptr(tegra_smmu_of_match),
 	},
 };
 
@@ -1031,4 +1072,5 @@ module_exit(tegra_smmu_exit);
 
 MODULE_DESCRIPTION("IOMMU API for SMMU in Tegra30");
 MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
+MODULE_ALIAS("platform:tegra-smmu");
 MODULE_LICENSE("GPL v2");
-- 
1.7.5.4

