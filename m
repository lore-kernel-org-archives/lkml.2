Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab0KWDOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:14:11 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14472 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0KWDOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:14:10 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6175"; a="63963693"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH v2 2/3] msm: iommu: Clock control for the IOMMU driver
Date: Mon, 22 Nov 2010 19:14:04 -0800
Message-Id: <1290482045-6043-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1290222154-11096-3-git-send-email-stepanm@codeaurora.org>
References: <1290222154-11096-3-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock control to the IOMMU driver. The IOMMU bus clock
(and potentially an AXI clock) need to be on to gain access
to IOMMU registers. Actively control these clocks when
needed instead of leaving them on. Additionally, perform
minor code cleanups.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
Please hold off on this until the clock driver is in.
Changes in v2:
 * Two minor cleanups of the form of changing if (..) BUG() to BUG_ON()
 * Amend the commit text to that effect

 arch/arm/mach-msm/iommu.c |   84 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 70 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index a468ee3..3cdecb9 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/iommu.h>
+#include <linux/clk.h>

 #include <asm/cacheflush.h>
 #include <asm/sizes.h>
@@ -50,12 +51,36 @@ struct msm_priv {
 	struct list_head list_attached;
 };

-static void __flush_iotlb(struct iommu_domain *domain)
+static int __enable_clocks(struct msm_iommu_drvdata *drvdata)
+{
+	int ret;
+
+	ret = clk_enable(drvdata->pclk);
+	if (ret)
+		goto fail;
+
+	if (drvdata->clk) {
+		ret = clk_enable(drvdata->clk);
+		if (ret)
+			clk_disable(drvdata->pclk);
+	}
+fail:
+	return ret;
+}
+
+static void __disable_clocks(struct msm_iommu_drvdata *drvdata)
+{
+	if (drvdata->clk)
+		clk_disable(drvdata->clk);
+	clk_disable(drvdata->pclk);
+}
+
+static int __flush_iotlb(struct iommu_domain *domain)
 {
 	struct msm_priv *priv = domain->priv;
 	struct msm_iommu_drvdata *iommu_drvdata;
 	struct msm_iommu_ctx_drvdata *ctx_drvdata;
-
+	int ret = 0;
 #ifndef CONFIG_IOMMU_PGTABLES_L2
 	unsigned long *fl_table = priv->pgtable;
 	int i;
@@ -73,12 +98,20 @@ static void __flush_iotlb(struct iommu_domain *domain)
 #endif

 	list_for_each_entry(ctx_drvdata, &priv->list_attached, attached_elm) {
-		if (!ctx_drvdata->pdev || !ctx_drvdata->pdev->dev.parent)
-			BUG();
+		BUG_ON(!ctx_drvdata->pdev || !ctx_drvdata->pdev->dev.parent);

 		iommu_drvdata = dev_get_drvdata(ctx_drvdata->pdev->dev.parent);
+		BUG_ON(!iommu_drvdata);
+
+		ret = __enable_clocks(iommu_drvdata);
+		if (ret)
+			goto fail;
+
 		SET_CTX_TLBIALL(iommu_drvdata->base, ctx_drvdata->num, 0);
+		__disable_clocks(iommu_drvdata);
 	}
+fail:
+	return ret;
 }

 static void __reset_context(void __iomem *base, int ctx)
@@ -263,11 +296,16 @@ static int msm_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			goto fail;
 		}

+	ret = __enable_clocks(iommu_drvdata);
+	if (ret)
+		goto fail;
+
 	__program_context(iommu_drvdata->base, ctx_dev->num,
 			  __pa(priv->pgtable));

+	__disable_clocks(iommu_drvdata);
 	list_add(&(ctx_drvdata->attached_elm), &priv->list_attached);
-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);

 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
@@ -282,6 +320,7 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
 	struct msm_iommu_drvdata *iommu_drvdata;
 	struct msm_iommu_ctx_drvdata *ctx_drvdata;
 	unsigned long flags;
+	int ret;

 	spin_lock_irqsave(&msm_iommu_lock, flags);
 	priv = domain->priv;
@@ -296,8 +335,16 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
 	if (!iommu_drvdata || !ctx_drvdata || !ctx_dev)
 		goto fail;

-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);
+	if (ret)
+		goto fail;
+
+	ret = __enable_clocks(iommu_drvdata);
+	if (ret)
+		goto fail;
+
 	__reset_context(iommu_drvdata->base, ctx_dev->num);
+	__disable_clocks(iommu_drvdata);
 	list_del_init(&ctx_drvdata->attached_elm);

 fail:
@@ -410,7 +457,7 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 				SL_AP1 | SL_SHARED | SL_TYPE_LARGE | pgprot;
 	}

-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -495,7 +542,7 @@ static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
 		}
 	}

-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -526,13 +573,14 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	base = iommu_drvdata->base;
 	ctx = ctx_drvdata->num;

+	ret = __enable_clocks(iommu_drvdata);
+	if (ret)
+		goto fail;
+
 	/* Invalidate context TLB */
 	SET_CTX_TLBIALL(base, ctx, 0);
 	SET_V2PPR_VA(base, ctx, va >> V2Pxx_VA_SHIFT);

-	if (GET_FAULT(base, ctx))
-		goto fail;
-
 	par = GET_PAR(base, ctx);

 	/* We are dealing with a supersection */
@@ -541,6 +589,10 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	else	/* Upper 20 bits from PAR, lower 12 from VA */
 		ret = (par & 0xFFFFF000) | (va & 0x00000FFF);

+	if (GET_FAULT(base, ctx))
+		ret = 0;
+
+	__disable_clocks(iommu_drvdata);
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -583,8 +635,8 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 {
 	struct msm_iommu_drvdata *drvdata = dev_id;
 	void __iomem *base;
-	unsigned int fsr = 0;
-	int ncb = 0, i = 0;
+	unsigned int fsr;
+	int ncb, i, ret;

 	spin_lock(&msm_iommu_lock);

@@ -595,10 +647,13 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)

 	base = drvdata->base;

-	pr_err("===== WOAH! =====\n");
 	pr_err("Unexpected IOMMU page fault!\n");
 	pr_err("base = %08x\n", (unsigned int) base);

+	ret = __enable_clocks(drvdata);
+	if (ret)
+		goto fail;
+
 	ncb = GET_NCB(base)+1;
 	for (i = 0; i < ncb; i++) {
 		fsr = GET_FSR(base, i);
@@ -609,6 +664,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 			SET_FSR(base, i, 0x4000000F);
 		}
 	}
+	__disable_clocks(drvdata);
 fail:
 	spin_unlock(&msm_iommu_lock);
 	return 0;
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

