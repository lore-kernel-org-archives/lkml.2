Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab0LQAvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:51:19 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab0LQAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:17 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="67160042"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 20/22] msm: iommu: Clock control for the IOMMU driver
Date: Thu, 16 Dec 2010 16:50:04 -0800
Message-Id: <1292547006-19741-21-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
In-Reply-To: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
References: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Add clock control to the IOMMU driver. The IOMMU bus clock
(and potentially an AXI clock) need to be on to gain access
to IOMMU registers. Actively control these clocks when
needed instead of leaving them on.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/iommu.c |   57 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index e2d58e4..c6d52ee 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -26,6 +26,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/iommu.h>
+#include <linux/clk.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sizes.h>
@@ -50,6 +51,30 @@ struct msm_priv {
 	struct list_head list_attached;
 };
 
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
 static int __flush_iotlb(struct iommu_domain *domain)
 {
 	struct msm_priv *priv = domain->priv;
@@ -77,9 +102,17 @@ static int __flush_iotlb(struct iommu_domain *domain)
 			BUG();
 
 		iommu_drvdata = dev_get_drvdata(ctx_drvdata->pdev->dev.parent);
+		if (!iommu_drvdata)
+			BUG();
+
+		ret = __enable_clocks(iommu_drvdata);
+		if (ret)
+			goto fail;
+
 		SET_CTX_TLBIALL(iommu_drvdata->base, ctx_drvdata->num, 0);
+		__disable_clocks(iommu_drvdata);
 	}
-
+fail:
 	return ret;
 }
 
@@ -265,9 +298,14 @@ static int msm_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
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
 	ret = __flush_iotlb(domain);
 
@@ -303,7 +341,12 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
 	if (ret)
 		goto fail;
 
+	ret = __enable_clocks(iommu_drvdata);
+	if (ret)
+		goto fail;
+
 	__reset_context(iommu_drvdata->base, ctx_dev->num);
+	__disable_clocks(iommu_drvdata);
 	list_del_init(&ctx_drvdata->attached_elm);
 
 fail:
@@ -532,6 +575,10 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	base = iommu_drvdata->base;
 	ctx = ctx_drvdata->num;
 
+	ret = __enable_clocks(iommu_drvdata);
+	if (ret)
+		goto fail;
+
 	/* Invalidate context TLB */
 	SET_CTX_TLBIALL(base, ctx, 0);
 	SET_V2PPR_VA(base, ctx, va >> V2Pxx_VA_SHIFT);
@@ -547,6 +594,7 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	if (GET_FAULT(base, ctx))
 		ret = 0;
 
+	__disable_clocks(iommu_drvdata);
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -590,7 +638,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 	struct msm_iommu_drvdata *drvdata = dev_id;
 	void __iomem *base;
 	unsigned int fsr;
-	int ncb, i;
+	int ncb, i, ret;
 
 	spin_lock(&msm_iommu_lock);
 
@@ -604,6 +652,10 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 	pr_err("Unexpected IOMMU page fault!\n");
 	pr_err("base = %08x\n", (unsigned int) base);
 
+	ret = __enable_clocks(drvdata);
+	if (ret)
+		goto fail;
+
 	ncb = GET_NCB(base)+1;
 	for (i = 0; i < ncb; i++) {
 		fsr = GET_FSR(base, i);
@@ -614,6 +666,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 			SET_FSR(base, i, 0x4000000F);
 		}
 	}
+	__disable_clocks(drvdata);
 fail:
 	spin_unlock(&msm_iommu_lock);
 	return 0;
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

