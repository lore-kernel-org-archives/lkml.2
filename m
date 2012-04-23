Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2DWL7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:59:22 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13730 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab2DWL7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:59:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 23 Apr 2012 04:59:19 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] iommu/tegra: smmu: Add device tree support for SMMU
Date: Mon, 23 Apr 2012 14:58:54 +0300
Message-Id: <1335182340-17237-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com>
References: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for Tegra30 IOMMU(SMMU).

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 .../bindings/iommu/nvidia,tegra30-smmu.txt         |   20 ++++++++
 drivers/iommu/tegra-smmu.c                         |   47 +++++++++++++++-----
 2 files changed, 55 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt
new file mode 100644
index 0000000..6f942ff
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/nvidia,tegra30-smmu.txt
@@ -0,0 +1,20 @@
+NVIDIA Tegra 30 IOMMU H/W, SMMU (System Memory Management Unit)
+
+Required properties:
+- compatible : "nvidia,tegra30-smmu"
+- reg : Should contain 3 register ranges(address and length) for each
+  of the SMMU register blocks.
+- interrupts : Should contain MC General interrupt.
+- asids	     : # of ASIDs
+- dma-window: IOVA start address and length.
+
+Example:
+	smmu: smmu@7000f000 {
+		compatible = "nvidia,tegra30-smmu";
+		reg = <0x7000f010 0x2c		/* controller registers */
+		       0x7000f1f0 0x10		/* statics */
+		       0x7000f228 0x5c>;	/* module configuration */
+		interrupts = <0 13 0x40>;
+		asids = <4>;			/* # of ASIDs */
+		dma-window = <0 0x40000000>;	/* IOVA start & length */
+	};
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 90bbf07..c2827a6 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -30,6 +30,8 @@
 #include <linux/sched.h>
 #include <linux/iommu.h>
 #include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
 
 #include <asm/page.h>
 #include <asm/cacheflush.h>
@@ -112,7 +114,6 @@
 
 #define SMMU_PDE_NEXT_SHIFT		28
 
-#define SMMU_NUM_ASIDS				4
 #define SMMU_TLB_FLUSH_VA_SECTION__MASK		0xffc00000
 #define SMMU_TLB_FLUSH_VA_SECTION__SHIFT	12 /* right shift */
 #define SMMU_TLB_FLUSH_VA_GROUP__MASK		0xffffc000
@@ -868,15 +869,33 @@ static int tegra_smmu_resume(struct device *dev)
 static int tegra_smmu_probe(struct platform_device *pdev)
 {
 	struct smmu_device *smmu;
-	struct resource *res[NUM_SMMU_REG_BLOCKS], *window;
+	struct resource *res[NUM_SMMU_REG_BLOCKS];
 	struct device *dev = &pdev->dev;
-	int i, err = 0;
+	int i, asids, err = 0;
+	dma_addr_t base;
+	size_t size;
+
+	if (!dev->of_node)
+		return -ENODEV;
 
 	if (smmu_handle)
 		return -EIO;
 
 	BUILD_BUG_ON(PAGE_SHIFT != SMMU_PAGE_SHIFT);
 
+	err = of_parse_dma_window(dev->of_node, "dma-window", 0, NULL,
+				  &base, &size);
+	if (err)
+		return -ENODEV;
+
+	size >>= SMMU_PAGE_SHIFT;
+	if (!size)
+		return -ENODEV;
+
+	asids = be32_to_cpup(of_get_property(dev->of_node, "asids", NULL));
+	if (!asids)
+		return -ENODEV;
+
 	for (i = 0; i < ARRAY_SIZE(res); i++) {
 		res[i] = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res[i])
@@ -894,12 +913,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		return -EIO;
 	}
 
-	window = platform_get_resource(pdev, IORESOURCE_MEM, 3);
-	if (!window) {
-		dev_err(dev, "No SMMU resources\n");
-		return -ENODEV;
-	}
-
 	smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
 	if (!smmu) {
 		dev_err(dev, "failed to allocate smmu_device\n");
@@ -907,9 +920,9 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	}
 
 	smmu->dev = dev;
-	smmu->num_as = SMMU_NUM_ASIDS;
-	smmu->iovmm_base = (unsigned long)window->start;
-	smmu->page_count = resource_size(window) >> SMMU_PAGE_SHIFT;
+	smmu->num_as = asids;
+	smmu->iovmm_base = base;
+	smmu->page_count = size;
 	smmu->regs = devm_ioremap(dev, res[0]->start,
 				  res[2]->end - res[0]->start + 1);
 	if (!smmu->regs) {
@@ -1009,6 +1022,14 @@ const struct dev_pm_ops tegra_smmu_pm_ops = {
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
@@ -1016,6 +1037,7 @@ static struct platform_driver tegra_smmu_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "tegra-smmu",
 		.pm	= &tegra_smmu_pm_ops,
+		.of_match_table = of_match_ptr(tegra_smmu_of_match),
 	},
 };
 
@@ -1035,4 +1057,5 @@ module_exit(tegra_smmu_exit);
 
 MODULE_DESCRIPTION("IOMMU API for SMMU in Tegra30");
 MODULE_AUTHOR("Hiroshi DOYU <hdoyu@nvidia.com>");
+MODULE_ALIAS("platform:tegra-smmu");
 MODULE_LICENSE("GPL v2");
-- 
1.7.5.4

