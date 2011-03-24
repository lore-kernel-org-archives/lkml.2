Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779Ab1CXWV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 18:21:26 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40392 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab1CXWVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 18:21:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6295"; a="81716425"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCHv2] msm: iommu: Use relaxed register access functions
Date: Thu, 24 Mar 2011 15:21:19 -0700
Message-Id: <1301005279-24901-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1300392119-8062-1-git-send-email-stepanm@codeaurora.org>
References: <1300392119-8062-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the relaxed versions of readl/writel for IOMMU register
access, inserting barriers where appropriate.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
v2:
Add barrier comments
Remove one unnecessary barrier in tlb flush
Add a needed barrier in device probe

 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h |   15 ++++++++-------
 arch/arm/mach-msm/iommu.c                      |   16 ++++++++++++++++
 arch/arm/mach-msm/iommu_dev.c                  |   17 +++++++++++++++++
 3 files changed, 41 insertions(+), 7 deletions(-)

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
index 1a584e0..b72475b 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -137,6 +137,9 @@ static void __reset_context(void __iomem *base, int ctx)
 	SET_TLBLKCR(base, ctx, 0);
 	SET_PRRR(base, ctx, 0);
 	SET_NMRR(base, ctx, 0);
+
+	/* Make sure the reset completes before any further hardware access */
+	mb();
 }

 static void __program_context(void __iomem *base, int ctx, phys_addr_t pgtable)
@@ -203,8 +206,14 @@ static void __program_context(void __iomem *base, int ctx, phys_addr_t pgtable)
 	SET_TTBR1_ORGN(base, ctx, 1); /* WB, WA */
 #endif

+	/* Allow configuration to commit before enabling the MMU */
+	mb();
+
 	/* Enable the MMU */
 	SET_M(base, ctx, 1);
+
+	/* Make sure the MMU is enabled before returning */
+	mb();
 }

 static int msm_iommu_domain_init(struct iommu_domain *domain)
@@ -579,8 +588,15 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,

 	/* Invalidate context TLB */
 	SET_CTX_TLBIALL(base, ctx, 0);
+
+	/* Make sure the TLB is invalidated before translating */
+	mb();
+
 	SET_V2PPR(base, ctx, va & V2Pxx_VA);

+	/* Make sure the translation request is written before reading result */
+	mb();
+
 	par = GET_PAR(base, ctx);

 	/* We are dealing with a supersection */
diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
index 8e8fb07..b3d06c9 100644
--- a/arch/arm/mach-msm/iommu_dev.c
+++ b/arch/arm/mach-msm/iommu_dev.c
@@ -124,6 +124,9 @@ static void msm_iommu_reset(void __iomem *base, int ncb)
 		SET_NMRR(base, ctx, 0);
 		SET_CONTEXTIDR(base, ctx, 0);
 	}
+
+	/* Make sure the reset completes before any further hardware access */
+	mb();
 }

 static int msm_iommu_probe(struct platform_device *pdev)
@@ -212,14 +215,25 @@ static int msm_iommu_probe(struct platform_device *pdev)

 	msm_iommu_reset(regs_base, iommu_dev->ncb);

+	/*
+	 * Barriers make sure that the device is configured for V2P mode prior
+	 * to doing any V2P access, and that we read the result only after
+	 * the V2P request is written.
+	 */
 	SET_M(regs_base, 0, 1);
 	SET_PAR(regs_base, 0, 0);
 	SET_V2PCFG(regs_base, 0, 1);
+	mb();
 	SET_V2PPR(regs_base, 0, 0);
+	mb();
 	par = GET_PAR(regs_base, 0);
 	SET_V2PCFG(regs_base, 0, 0);
+
 	SET_M(regs_base, 0, 0);

+	/* Make sure device state is restored before any subsequent access */
+	mb();
+
 	if (!par) {
 		pr_err("%s: Invalid PAR value detected\n", iommu_dev->name);
 		ret = -ENODEV;
@@ -351,6 +365,9 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 		SET_NSCFG(drvdata->base, mid, 3);
 	}

+	/* Make sure the device is fully configured before completing probe */
+	mb();
+
 	if (drvdata->clk)
 		clk_disable(drvdata->clk);
 	clk_disable(drvdata->pclk);
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

