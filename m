Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2ENSMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:12:19 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1633 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab2ENSMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:12:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 14 May 2012 11:12:15 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] iommu/tegra: gart: Remove unnecessary cleanup with devm_*()
Date: Mon, 14 May 2012 21:12:02 +0300
Message-ID: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary cleanup procedures with devm_*().

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-gart.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index 0c0a377..33a23b6 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -345,7 +345,6 @@ static int tegra_gart_probe(struct platform_device *pdev)
 	struct gart_device *gart;
 	struct resource *res, *res_remap;
 	void __iomem *gart_regs;
-	int err;
 	struct device *dev = &pdev->dev;
 
 	if (gart_handle)
@@ -370,8 +369,7 @@ static int tegra_gart_probe(struct platform_device *pdev)
 	gart_regs = devm_ioremap(dev, res->start, resource_size(res));
 	if (!gart_regs) {
 		dev_err(dev, "failed to remap GART registers\n");
-		err = -ENXIO;
-		goto fail;
+		return -ENXIO;
 	}
 
 	gart->dev = &pdev->dev;
@@ -385,8 +383,7 @@ static int tegra_gart_probe(struct platform_device *pdev)
 	gart->savedata = vmalloc(sizeof(u32) * gart->page_count);
 	if (!gart->savedata) {
 		dev_err(dev, "failed to allocate context save area\n");
-		err = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, gart);
@@ -394,27 +391,14 @@ static int tegra_gart_probe(struct platform_device *pdev)
 
 	gart_handle = gart;
 	return 0;
-
-fail:
-	if (gart_regs)
-		devm_iounmap(dev, gart_regs);
-	if (gart && gart->savedata)
-		vfree(gart->savedata);
-	devm_kfree(dev, gart);
-	return err;
 }
 
 static int tegra_gart_remove(struct platform_device *pdev)
 {
 	struct gart_device *gart = platform_get_drvdata(pdev);
-	struct device *dev = gart->dev;
 
 	writel(0, gart->regs + GART_CONFIG);
-	if (gart->savedata)
-		vfree(gart->savedata);
-	if (gart->regs)
-		devm_iounmap(dev, gart->regs);
-	devm_kfree(dev, gart);
+	vfree(gart->savedata);
 	gart_handle = NULL;
 	return 0;
 }
-- 
1.7.5.4

