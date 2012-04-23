Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab2DWL7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:59:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13704 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab2DWL7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:59:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 23 Apr 2012 04:59:08 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] iommu/tegra: smmu: Reserve SMMU reg regions precisely
Date: Mon, 23 Apr 2012 14:58:53 +0300
Message-Id: <1335182340-17237-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMMU register regions are located into 3 blocks discontiguously.

Get them and reserve each region respectively. This allows other
module to use/reserve other register regions between SMMU register
blocks.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-smmu.c |   44 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index de9fafe..90bbf07 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -173,6 +173,8 @@
 #define SMMU_ASID_DISABLE	0
 #define SMMU_ASID_ASID(n)	((n) & ~SMMU_ASID_ENABLE(0))
 
+#define NUM_SMMU_REG_BLOCKS	3
+
 #define smmu_client_enable_hwgrp(c, m)	smmu_client_set_hwgrp(c, m, 1)
 #define smmu_client_disable_hwgrp(c)	smmu_client_set_hwgrp(c, 0, 0)
 #define __smmu_client_enable_hwgrp(c, m) __smmu_client_set_hwgrp(c, m, 1)
@@ -866,7 +868,7 @@ static int tegra_smmu_resume(struct device *dev)
 static int tegra_smmu_probe(struct platform_device *pdev)
 {
 	struct smmu_device *smmu;
-	struct resource *regs, *window;
+	struct resource *res[NUM_SMMU_REG_BLOCKS], *window;
 	struct device *dev = &pdev->dev;
 	int i, err = 0;
 
@@ -875,9 +877,25 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 
 	BUILD_BUG_ON(PAGE_SHIFT != SMMU_PAGE_SHIFT);
 
-	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	window = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!regs || !window) {
+	for (i = 0; i < ARRAY_SIZE(res); i++) {
+		res[i] = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		if (!res[i])
+			return -ENODEV;
+
+		res[i] = devm_request_mem_region(&pdev->dev, res[i]->start,
+						 resource_size(res[i]),
+						 dev_name(&pdev->dev));
+		if (res[i])
+			continue;
+
+		while (--i >= 0)
+			devm_release_mem_region(&pdev->dev, res[i]->start,
+						resource_size(res[i]));
+		return -EIO;
+	}
+
+	window = platform_get_resource(pdev, IORESOURCE_MEM, 3);
+	if (!window) {
 		dev_err(dev, "No SMMU resources\n");
 		return -ENODEV;
 	}
@@ -892,7 +910,8 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	smmu->num_as = SMMU_NUM_ASIDS;
 	smmu->iovmm_base = (unsigned long)window->start;
 	smmu->page_count = resource_size(window) >> SMMU_PAGE_SHIFT;
-	smmu->regs = devm_ioremap(dev, regs->start, resource_size(regs));
+	smmu->regs = devm_ioremap(dev, res[0]->start,
+				  res[2]->end - res[0]->start + 1);
 	if (!smmu->regs) {
 		dev_err(dev, "failed to remap SMMU registers\n");
 		err = -ENXIO;
@@ -905,7 +924,7 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	smmu->asid_security = 0;
 
 	smmu->as = devm_kzalloc(dev,
-			sizeof(smmu->as[0]) * smmu->num_as, GFP_KERNEL);
+				sizeof(smmu->as[0]) * smmu->num_as, GFP_KERNEL);
 	if (!smmu->as) {
 		dev_err(dev, "failed to allocate smmu_as\n");
 		err = -ENOMEM;
@@ -950,6 +969,9 @@ fail:
 		devm_kfree(dev, smmu->as);
 	}
 	devm_kfree(dev, smmu);
+	for (i = 0; i < ARRAY_SIZE(res); i++)
+		devm_release_mem_region(&pdev->dev, res[i]->start,
+					resource_size(res[i]));
 	return err;
 }
 
@@ -957,12 +979,11 @@ static int tegra_smmu_remove(struct platform_device *pdev)
 {
 	struct smmu_device *smmu = platform_get_drvdata(pdev);
 	struct device *dev = smmu->dev;
+	int i;
 
 	smmu_write(smmu, SMMU_CONFIG_DISABLE, SMMU_CONFIG);
 	platform_set_drvdata(pdev, NULL);
 	if (smmu->as) {
-		int i;
-
 		for (i = 0; i < smmu->num_as; i++)
 			free_pdir(&smmu->as[i]);
 		devm_kfree(dev, smmu->as);
@@ -973,6 +994,13 @@ static int tegra_smmu_remove(struct platform_device *pdev)
 		devm_iounmap(dev, smmu->regs);
 	devm_kfree(dev, smmu);
 	smmu_handle = NULL;
+	for (i = 0; i < NUM_SMMU_REG_BLOCKS; i++) {
+		struct resource *res;
+
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+		devm_release_mem_region(&pdev->dev, res->start,
+					resource_size(res));
+	}
 	return 0;
 }
 
-- 
1.7.5.4

