Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab0KMDal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:41 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab0KMDaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:15 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61810882"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 14/14] msm: iommu: Miscellaneous code cleanup
Date: Fri, 12 Nov 2010 19:30:00 -0800
Message-Id: <1289619000-13167-15-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unneeded assignments and messages, restructure
a failure path in iova_to_phys, and make __flush_iotlb
return int in preparation for adding IOMMU clock control.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/iommu.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index 935025e..932728c 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -50,12 +50,12 @@ struct msm_priv {
 	struct list_head list_attached;
 };
 
-static void __flush_iotlb(struct iommu_domain *domain)
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
@@ -79,6 +79,8 @@ static void __flush_iotlb(struct iommu_domain *domain)
 		iommu_drvdata = dev_get_drvdata(ctx_drvdata->pdev->dev.parent);
 		SET_CTX_TLBIALL(iommu_drvdata->base, ctx_drvdata->num, 0);
 	}
+
+	return ret;
 }
 
 static void __reset_context(void __iomem *base, int ctx)
@@ -267,7 +269,7 @@ static int msm_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			  __pa(priv->pgtable));
 
 	list_add(&(ctx_drvdata->attached_elm), &priv->list_attached);
-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);
 
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
@@ -282,6 +284,7 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
 	struct msm_iommu_drvdata *iommu_drvdata;
 	struct msm_iommu_ctx_drvdata *ctx_drvdata;
 	unsigned long flags;
+	int ret;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
 	priv = domain->priv;
@@ -296,7 +299,10 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
 	if (!iommu_drvdata || !ctx_drvdata || !ctx_dev)
 		goto fail;
 
-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);
+	if (ret)
+		goto fail;
+
 	__reset_context(iommu_drvdata->base, ctx_dev->num);
 	list_del_init(&ctx_drvdata->attached_elm);
 
@@ -410,7 +416,7 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 				SL_AP1 | SL_SHARED | SL_TYPE_LARGE | pgprot;
 	}
 
-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -495,7 +501,7 @@ static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
 		}
 	}
 
-	__flush_iotlb(domain);
+	ret = __flush_iotlb(domain);
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -530,9 +536,6 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	SET_CTX_TLBIALL(base, ctx, 0);
 	SET_V2PPR_VA(base, ctx, va >> V2Pxx_VA_SHIFT);
 
-	if (GET_FAULT(base, ctx))
-		goto fail;
-
 	par = GET_PAR(base, ctx);
 
 	/* We are dealing with a supersection */
@@ -541,6 +544,9 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	else	/* Upper 20 bits from PAR, lower 12 from VA */
 		ret = (par & 0xFFFFF000) | (va & 0x00000FFF);
 
+	if (GET_FAULT(base, ctx))
+		ret = 0;
+
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -583,8 +589,8 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 {
 	struct msm_iommu_drvdata *drvdata = dev_id;
 	void __iomem *base;
-	unsigned int fsr = 0;
-	int ncb = 0, i = 0;
+	unsigned int fsr;
+	int ncb, i;
 
 	spin_lock(&msm_iommu_lock);
 
@@ -595,7 +601,6 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 
 	base = drvdata->base;
 
-	pr_err("===== WOAH! =====\n");
 	pr_err("Unexpected IOMMU page fault!\n");
 	pr_err("base = %08x\n", (unsigned int) base);
 
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

