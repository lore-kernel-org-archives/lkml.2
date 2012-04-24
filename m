Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2DXMFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 08:05:49 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3624 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab2DXMFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 08:05:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Apr 2012 05:05:44 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] iommu/tegra: smmu: Refrain from accessing to AHB registers
Date: Tue, 24 Apr 2012 15:05:16 +0300
Message-Id: <1335269116-9578-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
References: <1335269116-9578-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
ready, instead of directly aceessing AHB registers.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-smmu.c |   40 ++++++++--------------------------------
 1 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index ecd6790..de9fafe 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -36,6 +36,7 @@
 
 #include <mach/iomap.h>
 #include <mach/smmu.h>
+#include <mach/tegra-ahb.h>
 
 /* bitmap of the page sizes currently supported */
 #define SMMU_IOMMU_PGSIZES	(SZ_4K)
@@ -111,11 +112,6 @@
 
 #define SMMU_PDE_NEXT_SHIFT		28
 
-/* AHB Arbiter Registers */
-#define AHB_XBAR_CTRL				0xe0
-#define AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE	1
-#define AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT	17
-
 #define SMMU_NUM_ASIDS				4
 #define SMMU_TLB_FLUSH_VA_SECTION__MASK		0xffc00000
 #define SMMU_TLB_FLUSH_VA_SECTION__SHIFT	12 /* right shift */
@@ -235,7 +231,7 @@ struct smmu_as {
  * Per SMMU device - IOMMU device
  */
 struct smmu_device {
-	void __iomem	*regs, *regs_ahbarb;
+	void __iomem	*regs;
 	unsigned long	iovmm_base;	/* remappable base address */
 	unsigned long	page_count;	/* total remappable size */
 	spinlock_t	lock;
@@ -257,7 +253,7 @@ struct smmu_device {
 static struct smmu_device *smmu_handle; /* unique for a system */
 
 /*
- *	SMMU/AHB register accessors
+ *	SMMU register accessors
  */
 static inline u32 smmu_read(struct smmu_device *smmu, size_t offs)
 {
@@ -268,15 +264,6 @@ static inline void smmu_write(struct smmu_device *smmu, u32 val, size_t offs)
 	writel(val, smmu->regs + offs);
 }
 
-static inline u32 ahb_read(struct smmu_device *smmu, size_t offs)
-{
-	return readl(smmu->regs_ahbarb + offs);
-}
-static inline void ahb_write(struct smmu_device *smmu, u32 val, size_t offs)
-{
-	writel(val, smmu->regs_ahbarb + offs);
-}
-
 #define VA_PAGE_TO_PA(va, page)	\
 	(page_to_phys(page) + ((unsigned long)(va) & ~PAGE_MASK))
 
@@ -397,11 +384,7 @@ static void smmu_setup_regs(struct smmu_device *smmu)
 	smmu_write(smmu, SMMU_PTC_CONFIG_RESET_VAL, SMMU_PTC_CONFIG);
 
 	smmu_flush_regs(smmu, 1);
-
-	val = ahb_read(smmu, AHB_XBAR_CTRL);
-	val |= AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
-		AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
-	ahb_write(smmu, val, AHB_XBAR_CTRL);
+	tegra_ahb_enable_smmu();
 }
 
 static void flush_ptc_and_tlb(struct smmu_device *smmu,
@@ -883,7 +866,7 @@ static int tegra_smmu_resume(struct device *dev)
 static int tegra_smmu_probe(struct platform_device *pdev)
 {
 	struct smmu_device *smmu;
-	struct resource *regs, *regs2, *window;
+	struct resource *regs, *window;
 	struct device *dev = &pdev->dev;
 	int i, err = 0;
 
@@ -893,9 +876,8 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	BUILD_BUG_ON(PAGE_SHIFT != SMMU_PAGE_SHIFT);
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	regs2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	window = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	if (!regs || !regs2 || !window) {
+	window = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!regs || !window) {
 		dev_err(dev, "No SMMU resources\n");
 		return -ENODEV;
 	}
@@ -911,9 +893,7 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 	smmu->iovmm_base = (unsigned long)window->start;
 	smmu->page_count = resource_size(window) >> SMMU_PAGE_SHIFT;
 	smmu->regs = devm_ioremap(dev, regs->start, resource_size(regs));
-	smmu->regs_ahbarb = devm_ioremap(dev, regs2->start,
-					 resource_size(regs2));
-	if (!smmu->regs || !smmu->regs_ahbarb) {
+	if (!smmu->regs) {
 		dev_err(dev, "failed to remap SMMU registers\n");
 		err = -ENXIO;
 		goto fail;
@@ -960,8 +940,6 @@ fail:
 		__free_page(smmu->avp_vector_page);
 	if (smmu->regs)
 		devm_iounmap(dev, smmu->regs);
-	if (smmu->regs_ahbarb)
-		devm_iounmap(dev, smmu->regs_ahbarb);
 	if (smmu && smmu->as) {
 		for (i = 0; i < smmu->num_as; i++) {
 			if (smmu->as[i].pdir_page) {
@@ -993,8 +971,6 @@ static int tegra_smmu_remove(struct platform_device *pdev)
 		__free_page(smmu->avp_vector_page);
 	if (smmu->regs)
 		devm_iounmap(dev, smmu->regs);
-	if (smmu->regs_ahbarb)
-		devm_iounmap(dev, smmu->regs_ahbarb);
 	devm_kfree(dev, smmu);
 	smmu_handle = NULL;
 	return 0;
-- 
1.7.5.4

