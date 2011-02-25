Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab1BYCAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:00:54 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6408 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab1BYCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:00:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76555715"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 4/4] msm: iommu: Remove dependency on IDR
Date: Thu, 24 Feb 2011 18:00:42 -0800
Message-Id: <1298599242-21971-4-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1298599242-21971-1-git-send-email-stepanm@codeaurora.org>
References: <1298599242-21971-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the depencency on the IOMMU IDR register, as it may
not be accessible depending on the security configuraton.
This involves moving the NCB field of IDR into the platform
data.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/devices-iommu.c      |   26 +++++++++++++++++++-------
 arch/arm/mach-msm/include/mach/iommu.h |    4 ++++
 arch/arm/mach-msm/iommu.c              |    5 ++---
 arch/arm/mach-msm/iommu_dev.c          |   29 +++++++++++++++++------------
 4 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-msm/devices-iommu.c b/arch/arm/mach-msm/devices-iommu.c
index af97afe..24030d0 100644
--- a/arch/arm/mach-msm/devices-iommu.c
+++ b/arch/arm/mach-msm/devices-iommu.c
@@ -280,50 +280,62 @@ static struct platform_device msm_root_iommu_dev = {

 static struct msm_iommu_dev jpegd_iommu = {
 	.name = "jpegd",
+	.ncb = 2,
 };

 static struct msm_iommu_dev vpe_iommu = {
-	.name = "vpe"
+	.name = "vpe",
+	.ncb = 2,
 };

 static struct msm_iommu_dev mdp0_iommu = {
-	.name = "mdp0"
+	.name = "mdp0",
+	.ncb = 2,
 };

 static struct msm_iommu_dev mdp1_iommu = {
-	.name = "mdp1"
+	.name = "mdp1",
+	.ncb = 2,
 };

 static struct msm_iommu_dev rot_iommu = {
-	.name = "rot"
+	.name = "rot",
+	.ncb = 2,
 };

 static struct msm_iommu_dev ijpeg_iommu = {
-	.name = "ijpeg"
+	.name = "ijpeg",
+	.ncb = 2,
 };

 static struct msm_iommu_dev vfe_iommu = {
 	.name = "vfe",
+	.ncb = 2,
 };

 static struct msm_iommu_dev vcodec_a_iommu = {
-	.name = "vcodec_a"
+	.name = "vcodec_a",
+	.ncb = 2,
 };

 static struct msm_iommu_dev vcodec_b_iommu = {
-	.name = "vcodec_b"
+	.name = "vcodec_b",
+	.ncb = 2,
 };

 static struct msm_iommu_dev gfx3d_iommu = {
 	.name = "gfx3d",
+	.ncb = 3,
 };

 static struct msm_iommu_dev gfx2d0_iommu = {
 	.name = "gfx2d0",
+	.ncb = 2,
 };

 static struct msm_iommu_dev gfx2d1_iommu = {
 	.name = "gfx2d1",
+	.ncb = 2,
 };

 static struct platform_device msm_device_iommu_jpegd = {
diff --git a/arch/arm/mach-msm/include/mach/iommu.h b/arch/arm/mach-msm/include/mach/iommu.h
index 4dfe7ef..5c7c955 100644
--- a/arch/arm/mach-msm/include/mach/iommu.h
+++ b/arch/arm/mach-msm/include/mach/iommu.h
@@ -45,9 +45,11 @@
 /**
  * struct msm_iommu_dev - a single IOMMU hardware instance
  * name		Human-readable name given to this IOMMU HW instance
+ * ncb		Number of context banks present on this IOMMU HW instance
  */
 struct msm_iommu_dev {
 	const char *name;
+	int ncb;
 };

 /**
@@ -69,6 +71,7 @@ struct msm_iommu_ctx_dev {
 /**
  * struct msm_iommu_drvdata - A single IOMMU hardware instance
  * @base:	IOMMU config port base address (VA)
+ * @ncb		The number of contexts on this IOMMU
  * @irq:	Interrupt number
  * @clk:	The bus clock for this IOMMU hardware instance
  * @pclk:	The clock for the IOMMU bus interconnect
@@ -79,6 +82,7 @@ struct msm_iommu_ctx_dev {
 struct msm_iommu_drvdata {
 	void __iomem *base;
 	int irq;
+	int ncb;
 	struct clk *clk;
 	struct clk *pclk;
 };
diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index 9c08740..0146f519 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -636,7 +636,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 	struct msm_iommu_drvdata *drvdata = dev_id;
 	void __iomem *base;
 	unsigned int fsr;
-	int ncb, i, ret;
+	int i, ret;

 	spin_lock(&msm_iommu_lock);

@@ -654,8 +654,7 @@ irqreturn_t msm_iommu_fault_handler(int irq, void *dev_id)
 	if (ret)
 		goto fail;

-	ncb = GET_NCB(base)+1;
-	for (i = 0; i < ncb; i++) {
+	for (i = 0; i < drvdata->ncb; i++) {
 		fsr = GET_FSR(base, i);
 		if (fsr) {
 			pr_err("Fault occurred in context %d.\n", i);
diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
index c1722eb..826a21d 100644
--- a/arch/arm/mach-msm/iommu_dev.c
+++ b/arch/arm/mach-msm/iommu_dev.c
@@ -85,9 +85,9 @@ fail:
 }
 EXPORT_SYMBOL(msm_iommu_get_ctx);

-static void msm_iommu_reset(void __iomem *base)
+static void msm_iommu_reset(void __iomem *base, int ncb)
 {
-	int ctx, ncb;
+	int ctx;

 	SET_RPUE(base, 0);
 	SET_RPUEIE(base, 0);
@@ -100,7 +100,6 @@ static void msm_iommu_reset(void __iomem *base)
 	SET_GLOBAL_TLBIALL(base, 0);
 	SET_RPU_ACR(base, 0);
 	SET_TLBLKCRWE(base, 1);
-	ncb = GET_NCB(base)+1;

 	for (ctx = 0; ctx < ncb; ctx++) {
 		SET_BPRCOSH(base, ctx, 0);
@@ -136,7 +135,7 @@ static int msm_iommu_probe(struct platform_device *pdev)
 	struct msm_iommu_dev *iommu_dev = pdev->dev.platform_data;
 	void __iomem *regs_base;
 	resource_size_t	len;
-	int ret, ncb, nm2v, irq;
+	int ret, irq, par;

 	if (pdev->id == -1) {
 		msm_iommu_root_dev = pdev;
@@ -211,10 +210,18 @@ static int msm_iommu_probe(struct platform_device *pdev)
 		goto fail_io;
 	}

-	mb();
+	msm_iommu_reset(regs_base, iommu_dev->ncb);

-	if (GET_IDR(regs_base) == 0) {
-		pr_err("Invalid IDR value detected\n");
+	SET_M(regs_base, 0, 1);
+	SET_PAR(regs_base, 0, 0);
+	SET_V2PCFG(regs_base, 0, 1);
+	SET_V2PPR(regs_base, 0, 0);
+	par = GET_PAR(regs_base, 0);
+	SET_V2PCFG(regs_base, 0, 0);
+	SET_M(regs_base, 0, 0);
+
+	if (!par) {
+		pr_err("%s: Invalid PAR value detected\n", iommu_dev->name);
 		ret = -ENODEV;
 		goto fail_io;
 	}
@@ -226,17 +233,15 @@ static int msm_iommu_probe(struct platform_device *pdev)
 		goto fail_io;
 	}

-	msm_iommu_reset(regs_base);
+
 	drvdata->pclk = iommu_pclk;
 	drvdata->clk = iommu_clk;
 	drvdata->base = regs_base;
 	drvdata->irq = irq;
-
-	nm2v = GET_NM2VCBMT((unsigned long) regs_base);
-	ncb = GET_NCB((unsigned long) regs_base);
+	drvdata->ncb = iommu_dev->ncb;

 	pr_info("device %s mapped at %p, irq %d with %d ctx banks\n",
-			iommu_dev->name, regs_base, irq, ncb+1);
+		iommu_dev->name, regs_base, irq, iommu_dev->ncb);

 	platform_set_drvdata(pdev, drvdata);

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

