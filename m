Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1CQUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 16:02:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52763 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1CQUCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 16:02:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6288"; a="80591081"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH] msm: iommu: Use relaxed register access functions
Date: Thu, 17 Mar 2011 13:01:59 -0700
Message-Id: <1300392119-8062-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the relaxed versions of readl/writel for IOMMU register
access, inserting barriers where appropriate.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h |   15 ++++++++-------
 arch/arm/mach-msm/iommu.c                      |    5 +++++
 arch/arm/mach-msm/iommu_dev.c                  |    4 ++++
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
index fc16010..6d097d5 100644
--- a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
+++ b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
@@ -20,14 +20,14 @@

 #define CTX_SHIFT 12

-#define GET_GLOBAL_REG(reg, base) (readl((base) + (reg)))
+#define GET_GLOBAL_REG(reg, base) (readl_relaxed((base) + (reg)))
 #define GET_CTX_REG(reg, base, ctx) \
-				(readl((base) + (reg) + ((ctx) << CTX_SHIFT)))
+			(readl_relaxed((base) + (reg) + ((ctx) << CTX_SHIFT)))

-#define SET_GLOBAL_REG(reg, base, val)	writel((val), ((base) + (reg)))
+#define SET_GLOBAL_REG(reg, base, val)	writel_relaxed((val), ((base) + (reg)))

 #define SET_CTX_REG(reg, base, ctx, val) \
-			writel((val), ((base) + (reg) + ((ctx) << CTX_SHIFT)))
+		writel_relaxed((val), ((base) + (reg) + ((ctx) << CTX_SHIFT)))

 /* Wrappers for numbered registers */
 #define SET_GLOBAL_REG_N(b, n, r, v) SET_GLOBAL_REG(b, ((r) + (n << 2)), (v))
@@ -43,12 +43,13 @@
 #define SET_CONTEXT_FIELD(b, c, r, F, v)	\
 	SET_FIELD(((b) + (r) + ((c) << CTX_SHIFT)), F##_MASK, F##_SHIFT, (v))

-#define GET_FIELD(addr, mask, shift)  ((readl(addr) >> (shift)) & (mask))
+#define GET_FIELD(addr, mask, shift) ((readl_relaxed(addr) >> (shift)) & (mask))

 #define SET_FIELD(addr, mask, shift, v) \
 do { \
-	int t = readl(addr); \
-	writel((t & ~((mask) << (shift))) + (((v) & (mask)) << (shift)), addr);\
+	int t = readl_relaxed(addr); \
+	writel_relaxed((t & ~((mask) << (shift))) + (((v) & \
+		       (mask)) << (shift)), addr);\
 } while (0)


diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index 1a584e0..262491d 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -97,6 +97,7 @@ static int __flush_iotlb(struct iommu_domain *domain)
 	}
 #endif

+	mb();
 	list_for_each_entry(ctx_drvdata, &priv->list_attached, attached_elm) {
 		if (!ctx_drvdata->pdev || !ctx_drvdata->pdev->dev.parent)
 			BUG();
@@ -137,6 +138,7 @@ static void __reset_context(void __iomem *base, int ctx)
 	SET_TLBLKCR(base, ctx, 0);
 	SET_PRRR(base, ctx, 0);
 	SET_NMRR(base, ctx, 0);
+	mb();
 }

 static void __program_context(void __iomem *base, int ctx, phys_addr_t pgtable)
@@ -205,6 +207,7 @@ static void __program_context(void __iomem *base, int ctx, phys_addr_t pgtable)

 	/* Enable the MMU */
 	SET_M(base, ctx, 1);
+	mb();
 }

 static int msm_iommu_domain_init(struct iommu_domain *domain)
@@ -579,8 +582,10 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,

 	/* Invalidate context TLB */
 	SET_CTX_TLBIALL(base, ctx, 0);
+	mb();
 	SET_V2PPR(base, ctx, va & V2Pxx_VA);

+	mb();
 	par = GET_PAR(base, ctx);

 	/* We are dealing with a supersection */
diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
index 8e8fb07..a8976f7 100644
--- a/arch/arm/mach-msm/iommu_dev.c
+++ b/arch/arm/mach-msm/iommu_dev.c
@@ -124,6 +124,7 @@ static void msm_iommu_reset(void __iomem *base, int ncb)
 		SET_NMRR(base, ctx, 0);
 		SET_CONTEXTIDR(base, ctx, 0);
 	}
+	mb();
 }

 static int msm_iommu_probe(struct platform_device *pdev)
@@ -216,9 +217,11 @@ static int msm_iommu_probe(struct platform_device *pdev)
 	SET_PAR(regs_base, 0, 0);
 	SET_V2PCFG(regs_base, 0, 1);
 	SET_V2PPR(regs_base, 0, 0);
+	mb();
 	par = GET_PAR(regs_base, 0);
 	SET_V2PCFG(regs_base, 0, 0);
 	SET_M(regs_base, 0, 0);
+	mb();

 	if (!par) {
 		pr_err("%s: Invalid PAR value detected\n", iommu_dev->name);
@@ -350,6 +353,7 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 		/* Set security bit override to be Non-secure */
 		SET_NSCFG(drvdata->base, mid, 3);
 	}
+	mb();

 	if (drvdata->clk)
 		clk_disable(drvdata->clk);
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

