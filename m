Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab2EOINJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:13:09 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16167 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab2EOINE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:13:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 15 May 2012 01:12:01 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>, <iommu@lists.linux-foundation.org>
CC: <linux-tegra@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: [v2 1/2] iommu/tegra: smmu: Simplify allocation at once
Date: Tue, 15 May 2012 11:12:48 +0300
Message-ID: <1337069574-2022-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4FB19677.4040702@wwwdotorg.org>
References: <4FB19677.4040702@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To simplify the code, alloc necessary data at once.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
---
This patch requires:

    [PATCH 1/1] dt: Add general DMA window parser
        http://marc.info/?l=linux-tegra&m=133671302703840&w=2
---
 drivers/iommu/tegra-smmu.c |   32 +++++++++++---------------------
 1 files changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index dbaba77..5eb32b3 100644
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
@@ -900,17 +901,21 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 {
 	struct smmu_device *smmu;
 	struct device *dev = &pdev->dev;
-	int i, asids, err = 0;
+	int i, err = 0;
+	u32 asids;
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
@@ -939,13 +944,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
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
@@ -960,14 +958,6 @@ static int tegra_smmu_probe(struct platform_device *pdev)
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

