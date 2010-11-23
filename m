Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab0KWDOO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 22:14:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14472 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab0KWDOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 22:14:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6175"; a="63963697"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH v2 3/3] msm: iommu: Rework clock logic and add IOMMU bus clock control
Date: Mon, 22 Nov 2010 19:14:05 -0800
Message-Id: <1290482045-6043-2-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1290222154-11096-3-git-send-email-stepanm@codeaurora.org>
References: <1290222154-11096-3-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the clock control code in the probe calls, and add
support for controlling the clock for the IOMMU bus
interconnect. With the (proper) clock driver in place, the
clock control logic in the probe function can be made much
cleaner since it does not have to deal with the placeholder
driver anymore.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
Please hold off on this until the clock driver is in.
The patch seems like it is a lot of changes, but a lot of
it comes from removing one condition, which causes a bunch
of code to be unindented by one level. This implementation
is a lot cleaner IMO.

Changes in v2:
 * Remove two unnecessart memset calls
 * Fix alignment / whitespace

 arch/arm/mach-msm/devices-msm8x60-iommu.c |    5 -
 arch/arm/mach-msm/include/mach/iommu.h    |    5 -
 arch/arm/mach-msm/iommu_dev.c             |  204 +++++++++++++++++------------
 3 files changed, 119 insertions(+), 95 deletions(-)

diff --git a/arch/arm/mach-msm/devices-msm8x60-iommu.c b/arch/arm/mach-msm/devices-msm8x60-iommu.c
index f9e7bd3..e12d7e2 100644
--- a/arch/arm/mach-msm/devices-msm8x60-iommu.c
+++ b/arch/arm/mach-msm/devices-msm8x60-iommu.c
@@ -282,7 +282,6 @@ static struct platform_device msm_root_iommu_dev = {

 static struct msm_iommu_dev jpegd_iommu = {
 	.name = "jpegd",
-	.clk_rate = -1
 };

 static struct msm_iommu_dev vpe_iommu = {
@@ -307,7 +306,6 @@ static struct msm_iommu_dev ijpeg_iommu = {

 static struct msm_iommu_dev vfe_iommu = {
 	.name = "vfe",
-	.clk_rate = -1
 };

 static struct msm_iommu_dev vcodec_a_iommu = {
@@ -320,17 +318,14 @@ static struct msm_iommu_dev vcodec_b_iommu = {

 static struct msm_iommu_dev gfx3d_iommu = {
 	.name = "gfx3d",
-	.clk_rate = 27000000
 };

 static struct msm_iommu_dev gfx2d0_iommu = {
 	.name = "gfx2d0",
-	.clk_rate = 27000000
 };

 static struct msm_iommu_dev gfx2d1_iommu = {
 	.name = "gfx2d1",
-	.clk_rate = 27000000
 };

 static struct platform_device msm_device_iommu_jpegd = {
diff --git a/arch/arm/mach-msm/include/mach/iommu.h b/arch/arm/mach-msm/include/mach/iommu.h
index 62f6699..10811ba 100644
--- a/arch/arm/mach-msm/include/mach/iommu.h
+++ b/arch/arm/mach-msm/include/mach/iommu.h
@@ -45,14 +45,9 @@
 /**
  * struct msm_iommu_dev - a single IOMMU hardware instance
  * name		Human-readable name given to this IOMMU HW instance
- * clk_rate	Rate to set for this IOMMU's clock, if applicable to this
- *		particular IOMMU. 0 means don't set a rate.
- *		-1 means it is an AXI clock with no valid rate
- *
  */
 struct msm_iommu_dev {
 	const char *name;
-	int clk_rate;
 };

 /**
diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
index b83c73b..7819ed2 100644
--- a/arch/arm/mach-msm/iommu_dev.c
+++ b/arch/arm/mach-msm/iommu_dev.c
@@ -29,6 +29,7 @@

 #include <mach/iommu_hw-8xxx.h>
 #include <mach/iommu.h>
+#include <mach/clk.h>

 struct iommu_ctx_iter_data {
 	/* input */
@@ -130,117 +131,134 @@ static int msm_iommu_probe(struct platform_device *pdev)
 {
 	struct resource *r, *r2;
 	struct clk *iommu_clk;
+	struct clk *iommu_pclk;
 	struct msm_iommu_drvdata *drvdata;
 	struct msm_iommu_dev *iommu_dev = pdev->dev.platform_data;
 	void __iomem *regs_base;
 	resource_size_t	len;
-	int ret = 0, ncb, nm2v, irq;
+	int ret, ncb, nm2v, irq;

-	if (pdev->id != -1) {
-		drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);
+	if (pdev->id == -1) {
+		msm_iommu_root_dev = pdev;
+		return 0;
+	}

-		if (!drvdata) {
-			ret = -ENOMEM;
-			goto fail;
-		}
+	drvdata = kzalloc(sizeof(*drvdata), GFP_KERNEL);

-		if (!iommu_dev) {
-			ret = -ENODEV;
-			goto fail;
-		}
+	if (!drvdata) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	if (!iommu_dev) {
+		ret = -ENODEV;
+		goto fail;
+	}

-		if (iommu_dev->clk_rate != 0) {
-			iommu_clk = clk_get(&pdev->dev, "iommu_clk");
-
-			if (IS_ERR(iommu_clk)) {
-				ret = -ENODEV;
-				goto fail;
-			}
-
-			if (iommu_dev->clk_rate > 0) {
-				ret = clk_set_rate(iommu_clk,
-							iommu_dev->clk_rate);
-				if (ret) {
-					clk_put(iommu_clk);
-					goto fail;
-				}
-			}
-
-			ret = clk_enable(iommu_clk);
-			if (ret) {
-				clk_put(iommu_clk);
-				goto fail;
-			}
+	iommu_pclk = clk_get(NULL, "smmu_pclk");
+	if (IS_ERR(iommu_pclk)) {
+		ret = -ENODEV;
+		goto fail;
+	}
+
+	ret = clk_enable(iommu_pclk);
+	if (ret)
+		goto fail_enable;
+
+	iommu_clk = clk_get(&pdev->dev, "iommu_clk");
+
+	if (!IS_ERR(iommu_clk))	{
+		if (clk_get_rate(iommu_clk) == 0)
+			clk_set_min_rate(iommu_clk, 1);
+
+		ret = clk_enable(iommu_clk);
+		if (ret) {
 			clk_put(iommu_clk);
+			goto fail_pclk;
 		}
+	} else
+		iommu_clk = NULL;

-		r = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-						 "physbase");
-		if (!r) {
-			ret = -ENODEV;
-			goto fail;
-		}
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, "physbase");

-		len = r->end - r->start + 1;
+	if (!r) {
+		ret = -ENODEV;
+		goto fail_clk;
+	}

-		r2 = request_mem_region(r->start, len, r->name);
-		if (!r2) {
-			pr_err("Could not request memory region: "
-			"start=%p, len=%d\n", (void *) r->start, len);
-			ret = -EBUSY;
-			goto fail;
-		}
+	len = r->end - r->start + 1;

-		regs_base = ioremap(r2->start, len);
+	r2 = request_mem_region(r->start, len, r->name);
+	if (!r2) {
+		pr_err("Could not request memory region: start=%p, len=%d\n",
+			(void *) r->start, len);
+		ret = -EBUSY;
+		goto fail_clk;
+	}

-		if (!regs_base) {
-			pr_err("Could not ioremap: start=%p, len=%d\n",
-				 (void *) r2->start, len);
-			ret = -EBUSY;
-			goto fail_mem;
-		}
+	regs_base = ioremap(r2->start, len);

-		irq = platform_get_irq_byname(pdev, "secure_irq");
-		if (irq < 0) {
-			ret = -ENODEV;
-			goto fail_io;
-		}
+	if (!regs_base) {
+		pr_err("Could not ioremap: start=%p, len=%d\n",
+			 (void *) r2->start, len);
+		ret = -EBUSY;
+		goto fail_mem;
+	}
+
+	irq = platform_get_irq_byname(pdev, "secure_irq");
+	if (irq < 0) {
+		ret = -ENODEV;
+		goto fail_io;
+	}

-		mb();
+	mb();

-		if (GET_IDR(regs_base) == 0) {
-			pr_err("Invalid IDR value detected\n");
-			ret = -ENODEV;
-			goto fail_io;
-		}
+	if (GET_IDR(regs_base) == 0) {
+		pr_err("Invalid IDR value detected\n");
+		ret = -ENODEV;
+		goto fail_io;
+	}

-		ret = request_irq(irq, msm_iommu_fault_handler, 0,
-				"msm_iommu_secure_irpt_handler", drvdata);
-		if (ret) {
-			pr_err("Request IRQ %d failed with ret=%d\n", irq, ret);
-			goto fail_io;
-		}
+	ret = request_irq(irq, msm_iommu_fault_handler, 0,
+			"msm_iommu_secure_irpt_handler", drvdata);
+	if (ret) {
+		pr_err("Request IRQ %d failed with ret=%d\n", irq, ret);
+		goto fail_io;
+	}

-		msm_iommu_reset(regs_base);
-		drvdata->base = regs_base;
-		drvdata->irq = irq;
+	msm_iommu_reset(regs_base);
+	drvdata->pclk = iommu_pclk;
+	drvdata->clk = iommu_clk;
+	drvdata->base = regs_base;
+	drvdata->irq = irq;

-		nm2v = GET_NM2VCBMT((unsigned long) regs_base);
-		ncb = GET_NCB((unsigned long) regs_base);
+	nm2v = GET_NM2VCBMT((unsigned long) regs_base);
+	ncb = GET_NCB((unsigned long) regs_base);

-		pr_info("device %s mapped at %p, irq %d with %d ctx banks\n",
+	pr_info("device %s mapped at %p, irq %d with %d ctx banks\n",
 			iommu_dev->name, regs_base, irq, ncb+1);

-		platform_set_drvdata(pdev, drvdata);
-	} else
-		msm_iommu_root_dev = pdev;
+	platform_set_drvdata(pdev, drvdata);

-	return 0;
+	if (iommu_clk)
+		clk_disable(iommu_clk);
+
+	clk_disable(iommu_pclk);

+	return 0;
 fail_io:
 	iounmap(regs_base);
 fail_mem:
 	release_mem_region(r->start, len);
+fail_clk:
+	if (iommu_clk) {
+		clk_disable(iommu_clk);
+		clk_put(iommu_clk);
+	}
+fail_pclk:
+	clk_disable(iommu_pclk);
+fail_enable:
+	clk_put(iommu_pclk);
 fail:
 	kfree(drvdata);
 	return ret;
@@ -252,7 +270,9 @@ static int msm_iommu_remove(struct platform_device *pdev)

 	drv = platform_get_drvdata(pdev);
 	if (drv) {
-		memset(drv, 0, sizeof(struct msm_iommu_drvdata));
+		if (drv->clk)
+			clk_put(drv->clk);
+		clk_put(drv->pclk);
 		kfree(drv);
 		platform_set_drvdata(pdev, NULL);
 	}
@@ -264,7 +284,7 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 	struct msm_iommu_ctx_dev *c = pdev->dev.platform_data;
 	struct msm_iommu_drvdata *drvdata;
 	struct msm_iommu_ctx_drvdata *ctx_drvdata = NULL;
-	int i, ret = 0;
+	int i, ret;
 	if (!c || !pdev->dev.parent) {
 		ret = -EINVAL;
 		goto fail;
@@ -288,6 +308,18 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&ctx_drvdata->attached_elm);
 	platform_set_drvdata(pdev, ctx_drvdata);

+	ret = clk_enable(drvdata->pclk);
+	if (ret)
+		goto fail;
+
+	if (drvdata->clk) {
+		ret = clk_enable(drvdata->clk);
+		if (ret) {
+			clk_disable(drvdata->pclk);
+			goto fail;
+		}
+	}
+
 	/* Program the M2V tables for this context */
 	for (i = 0; i < MAX_NUM_MIDS; i++) {
 		int mid = c->mids[i];
@@ -310,8 +342,11 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 		SET_NSCFG(drvdata->base, mid, 3);
 	}

-	pr_info("context device %s with bank index %d\n", c->name, c->num);
+	if (drvdata->clk)
+		clk_disable(drvdata->clk);
+	clk_disable(drvdata->pclk);

+	dev_info(&pdev->dev, "context %s using bank %d\n", c->name, c->num);
 	return 0;
 fail:
 	kfree(ctx_drvdata);
@@ -323,7 +358,6 @@ static int msm_iommu_ctx_remove(struct platform_device *pdev)
 	struct msm_iommu_ctx_drvdata *drv = NULL;
 	drv = platform_get_drvdata(pdev);
 	if (drv) {
-		memset(drv, 0, sizeof(struct msm_iommu_ctx_drvdata));
 		kfree(drv);
 		platform_set_drvdata(pdev, NULL);
 	}
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

