Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab2EOINU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 04:13:20 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16200 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab2EOINQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 04:13:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 15 May 2012 01:13:08 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>, <iommu@lists.linux-foundation.org>
CC: <linux-tegra@vger.kernel.org>, Stephen Warren <swarren@wwwdotorg.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <linux-kernel@vger.kernel.org>
Subject: [v2 2/2] iommu/tegra: smmu: Remove unnecessary cleanups with devm_*()
Date: Tue, 15 May 2012 11:12:49 +0300
Message-ID: <1337069574-2022-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337069574-2022-1-git-send-email-hdoyu@nvidia.com>
References: <4FB19677.4040702@wwwdotorg.org>
 <1337069574-2022-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary cleanup procedures with devm_*() functions.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/iommu/tegra-smmu.c |   37 ++++++-------------------------------
 1 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 5eb32b3..9c2a99e 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -973,51 +973,26 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	spin_lock_init(&smmu->lock);
 	err = smmu_setup_regs(smmu);
 	if (err)
-		goto fail;
+		return err;
 	platform_set_drvdata(pdev, smmu);
 
 	smmu->avp_vector_page = alloc_page(GFP_KERNEL);
 	if (!smmu->avp_vector_page)
-		goto fail;
+		return -ENOMEM;
 
 	smmu_handle = smmu;
 	return 0;
-
-fail:
-	if (smmu->avp_vector_page)
-		__free_page(smmu->avp_vector_page);
-	if (smmu && smmu->as) {
-		for (i = 0; i < smmu->num_as; i++) {
-			if (smmu->as[i].pdir_page) {
-				ClearPageReserved(smmu->as[i].pdir_page);
-				__free_page(smmu->as[i].pdir_page);
-			}
-		}
-		devm_kfree(dev, smmu->as);
-	}
-	devm_kfree(dev, smmu);
-	return err;
 }
 
 static int tegra_smmu_remove(struct platform_device *pdev)
 {
 	struct smmu_device *smmu = platform_get_drvdata(pdev);
-	struct device *dev = smmu->dev;
+	int i;
 
 	smmu_write(smmu, SMMU_CONFIG_DISABLE, SMMU_CONFIG);
-	platform_set_drvdata(pdev, NULL);
-	if (smmu->as) {
-		int i;
-
-		for (i = 0; i < smmu->num_as; i++)
-			free_pdir(&smmu->as[i]);
-		devm_kfree(dev, smmu->as);
-	}
-	if (smmu->avp_vector_page)
-		__free_page(smmu->avp_vector_page);
-	if (smmu->regs)
-		devm_iounmap(dev, smmu->regs);
-	devm_kfree(dev, smmu);
+	for (i = 0; i < smmu->num_as; i++)
+		free_pdir(&smmu->as[i]);
+	__free_page(smmu->avp_vector_page);
 	smmu_handle = NULL;
 	return 0;
 }
-- 
1.7.5.4

