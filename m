Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2ECQGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 12:06:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3233 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757548Ab2ECQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 12:06:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 03 May 2012 09:06:01 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: hdoyu@nvidia.com
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Joerg Roedel <joerg.roedel@amd.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 3/4] iommu/tegra: smmu: Refrain from accessing to AHB
Date: Thu,  3 May 2012 19:05:44 +0300
Message-Id: <1336061147-10245-3-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com>
References: <1336061147-10245-1-git-send-email-hdoyu@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "tegra_ahb_enable_smmu()" to inform AHB that SMMU is
ready, instead of directly aceessing AHB registers.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-smmu.c |   60 +++++++++++++++++--------------------------
 1 files changed, 24 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index ecd6790..c70e4e7 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -30,12 +30,14 @@
 #include <linux/sched.h>
 #include <linux/iommu.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 
 #include <mach/iomap.h>
 #include <mach/smmu.h>
+#include <mach/tegra-ahb.h>
 
 /* bitmap of the page sizes currently supported */
 #define SMMU_IOMMU_PGSIZES	(SZ_4K)
@@ -111,11 +113,6 @@
 
 #define SMMU_PDE_NEXT_SHIFT		28
 
-/* AHB Arbiter Registers */
-#define AHB_XBAR_CTRL				0xe0
-#define AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE	1
-#define AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT	17
-
 #define SMMU_NUM_ASIDS				4
 #define SMMU_TLB_FLUSH_VA_SECTION__MASK		0xffc00000
 #define SMMU_TLB_FLUSH_VA_SECTION__SHIFT	12 /* right shift */
@@ -235,7 +232,7 @@ struct smmu_as {
  * Per SMMU device - IOMMU device
  */
 struct smmu_device {
-	void __iomem	*regs, *regs_ahbarb;
+	void __iomem	*regs;
 	unsigned long	iovmm_base;	/* remappable base address */
 	unsigned long	page_count;	/* total remappable size */
 	spinlock_t	lock;
@@ -252,12 +249,14 @@ struct smmu_device {
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
@@ -268,15 +267,6 @@ static inline void smmu_write(struct smmu_device *smmu, u32 val, size_t offs)
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
 
@@ -370,9 +360,9 @@ static void smmu_flush_regs(struct smmu_device *smmu, int enable)
 	FLUSH_SMMU_REGS(smmu);
 }
 
-static void smmu_setup_regs(struct smmu_device *smmu)
+static int smmu_setup_regs(struct smmu_device *smmu)
 {
-	int i;
+	int i, err;
 	u32 val;
 
 	for (i = 0; i < smmu->num_as; i++) {
@@ -398,10 +388,8 @@ static void smmu_setup_regs(struct smmu_device *smmu)
 
 	smmu_flush_regs(smmu, 1);
 
-	val = ahb_read(smmu, AHB_XBAR_CTRL);
-	val |= AHB_XBAR_CTRL_SMMU_INIT_DONE_DONE <<
-		AHB_XBAR_CTRL_SMMU_INIT_DONE_SHIFT;
-	ahb_write(smmu, val, AHB_XBAR_CTRL);
+	err = tegra_ahb_enable_smmu(smmu->ahb);
+	return err;
 }
 
 static void flush_ptc_and_tlb(struct smmu_device *smmu,
@@ -873,17 +861,18 @@ static int tegra_smmu_resume(struct device *dev)
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
+	struct resource *regs, *window;
 	struct device *dev = &pdev->dev;
 	int i, err = 0;
 
@@ -893,9 +882,8 @@ static int tegra_smmu_probe(struct platform_device *pdev)
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
@@ -911,14 +899,16 @@ static int tegra_smmu_probe(struct platform_device *pdev)
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
 	}
 
+	smmu->ahb = of_parse_phandle(pdev->dev.of_node, "ahb", 0);
+	if (!smmu->ahb)
+		return -ENODEV;
+
 	smmu->translation_enable_0 = ~0;
 	smmu->translation_enable_1 = ~0;
 	smmu->translation_enable_2 = ~0;
@@ -945,7 +935,9 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&as->client);
 	}
 	spin_lock_init(&smmu->lock);
-	smmu_setup_regs(smmu);
+	err = smmu_setup_regs(smmu);
+	if (err)
+		goto fail;
 	platform_set_drvdata(pdev, smmu);
 
 	smmu->avp_vector_page = alloc_page(GFP_KERNEL);
@@ -960,8 +952,6 @@ fail:
 		__free_page(smmu->avp_vector_page);
 	if (smmu->regs)
 		devm_iounmap(dev, smmu->regs);
-	if (smmu->regs_ahbarb)
-		devm_iounmap(dev, smmu->regs_ahbarb);
 	if (smmu && smmu->as) {
 		for (i = 0; i < smmu->num_as; i++) {
 			if (smmu->as[i].pdir_page) {
@@ -993,8 +983,6 @@ static int tegra_smmu_remove(struct platform_device *pdev)
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

