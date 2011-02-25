Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1BYCAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:00:55 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53149 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab1BYCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:00:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76352304"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 1/4] msm: iommu: Clock control for the IOMMU driver
Date: Thu, 24 Feb 2011 18:00:39 -0800
Message-Id: <1298599242-21971-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock control to the IOMMU driver. The IOMMU bus clock
(and potentially an AXI clock) need to be on to gain access
to IOMMU registers. Actively control these clocks when
needed instead of leaving them on.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/iommu.h |    9 ++++-
 arch/arm/mach-msm/iommu.c              |   58 ++++++++++++++++++++++++++++++--
 2 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/iommu.h b/arch/arm/mach-msm/include/mach/iommu.h
index 296c0f1..8738a44 100644
--- a/arch/arm/mach-msm/include/mach/iommu.h
+++ b/arch/arm/mach-msm/include/mach/iommu.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -19,6 +19,7 @@
 #define MSM_IOMMU_H

 #include <linux/interrupt.h>
+#include <linux/clk.h>

 /* Sharability attributes of MSM IOMMU mappings */
 #define MSM_IOMMU_ATTR_NON_SH		0x0
@@ -74,13 +75,17 @@ struct msm_iommu_ctx_dev {
  * struct msm_iommu_drvdata - A single IOMMU hardware instance
  * @base:	IOMMU config port base address (VA)
  * @irq:	Interrupt number
-  *
+ * @clk:	The bus clock for this IOMMU hardware instance
+ * @pclk:	The clock for the IOMMU bus interconnect
+ *
  * A msm_iommu_drvdata holds the global driver data about a single piece
  * of an IOMMU hardware instance.
  */
 struct msm_iommu_drvdata {
 	void __iomem *base;
 	int irq;
+	struct clk *clk;
+	struct clk *pclk;
 };

 /**
diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index e2d58e4..cde3cd0 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
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
@@ -77,9 +102,16 @@ static int __flush_iotlb(struct iommu_domain *domain)
 			BUG();

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
-
+fail:
 	return ret;
 }

@@ -265,9 +297,14 @@ static int msm_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
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

@@ -303,7 +340,12 @@ static void msm_iommu_detach_dev(struct iommu_domain *domain,
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
@@ -532,6 +574,10 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	base = iommu_drvdata->base;
 	ctx = ctx_drvdata->num;

+	ret = __enable_clocks(iommu_drvdata);
+	if (ret)
+		goto fail;
+
 	/* Invalidate context TLB */
 	SET_CTX_TLBIALL(base, ctx, 0);
 	SET_V2PPR_VA(base, ctx, va >> V2Pxx_VA_SHIFT);
@@ -547,6 +593,7 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
 	if (GET_FAULT(base, ctx))
 		ret = 0;

+	__disable_clocks(iommu_drvdata);
 fail:
 	spin_unlock_irqrestore(&msm_iommu_lock, flags);
 	return ret;
@@ -590,7 +637,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 	struct msm_iommu_drvdata *drvdata = dev_id;
 	void __iomem *base;
 	unsigned int fsr;
-	int ncb, i;
+	int ncb, i, ret;

 	spin_lock(&msm_iommu_lock);

@@ -604,6 +651,10 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 	pr_err("Unexpected IOMMU page fault!\n");
 	pr_err("base = %08x\n", (unsigned int) base);

+	ret = __enable_clocks(drvdata);
+	if (ret)
+		goto fail;
+
 	ncb = GET_NCB(base)+1;
 	for (i = 0; i < ncb; i++) {
 		fsr = GET_FSR(base, i);
@@ -614,6 +665,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
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

