Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2ENTQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:16:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9296 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab2ENTQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:16:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 May 2012 12:16:22 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH 1/2] iommu/tegra: smmu: Simplify allocation at once
Date: Mon, 14 May 2012 22:16:10 +0300
Message-ID: <1337022975-23999-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simplify the code, alloc necessary data at once.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
This patch requires:

    [PATCH 1/2] iommu/tegra: smmu: Add device tree support for SMMU
        http://marc.info/?l=linux-tegra&m=133663641107327&w=2

Also the above patch requires:

    [PATCH 1/1] dt: Add general DMA window parser
        http://marc.info/?l=linux-tegra&m=133671302703840&w=2
---
 drivers/iommu/tegra-smmu.c |   29 +++++++++--------------------
 1 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index dbaba77..e4acd44 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -241,8 +241,6 @@ struct smmu_device {
 	spinlock_t	lock;
 	char		*name;
 	struct device	*dev;
-	int		num_as;
-	struct smmu_as	*as;		/* Run-time allocated array */
 	struct page *avp_vector_page;	/* dummy page shared by all AS's */
 
 	/*
@@ -254,6 +252,9 @@ struct smmu_device {
 	unsigned long asid_security;
 
 	struct device_node *ahb;
+
+	int		num_as;
+	struct smmu_as	as[0];		/* Run-time allocated array */
 };
 
 static struct smmu_device *smmu_handle; /* unique for a system */
@@ -902,15 +903,18 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int i, asids, err = 0;
 	dma_addr_t base;
-	size_t size;
-	const void *prop;
+	size_t bytes, size;
 
 	if (smmu_handle)
 		return -EIO;
 
 	BUILD_BUG_ON(PAGE_SHIFT != SMMU_PAGE_SHIFT);
 
-	smmu = devm_kzalloc(dev, sizeof(*smmu), GFP_KERNEL);
+	if (of_property_read_u32(dev->of_node, "nvidia,#asids", &asids))
+		return -ENODEV;
+
+	bytes = sizeof(*smmu) + asids * sizeof(*smmu->as);
+	smmu = devm_kzalloc(dev, bytes, GFP_KERNEL);
 	if (!smmu) {
 		dev_err(dev, "failed to allocate smmu_device\n");
 		return -ENOMEM;
@@ -939,13 +943,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	if (!size)
 		return -EINVAL;
 
-	prop = of_get_property(dev->of_node, "nvidia,#asids", NULL);
-	if (!prop)
-		return -ENODEV;
-	asids = be32_to_cpup(prop);
-	if (!asids)
-		return -ENODEV;
-
 	smmu->ahb = of_parse_phandle(dev->of_node, "nvidia,ahb", 0);
 	if (!smmu->ahb)
 		return -ENODEV;
@@ -960,14 +957,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	smmu->translation_enable_2 = ~0;
 	smmu->asid_security = 0;
 
-	smmu->as = devm_kzalloc(dev,
-			sizeof(smmu->as[0]) * smmu->num_as, GFP_KERNEL);
-	if (!smmu->as) {
-		dev_err(dev, "failed to allocate smmu_as\n");
-		err = -ENOMEM;
-		goto fail;
-	}
-
 	for (i = 0; i < smmu->num_as; i++) {
 		struct smmu_as *as = &smmu->as[i];
 
-- 
1.7.5.4

