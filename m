Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0KMDam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:42 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31686 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab0KMDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61718511"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 13/14] msm: iommu: Support cache-coherent memory access
Date: Fri, 12 Nov 2010 19:29:59 -0800
Message-Id: <1289619000-13167-14-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for allowing IOMMU memory transactions to be
cache coherent, eliminating the need for software cache
management in certain situations. This can lead to
improvements in performance and power usage, assuming the
multimedia core's access pattern exhibits spatial locality
and that its working set fits into the cache.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/iommu.c |   93 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 82 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index 67e8f53..935025e 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -33,6 +33,16 @@
 #include <mach/iommu_hw-8xxx.h>
 #include <mach/iommu.h>
 
+#define MRC(reg, processor, op1, crn, crm, op2)				\
+__asm__ __volatile__ (							\
+"   mrc   "   #processor "," #op1 ", %0,"  #crn "," #crm "," #op2 "\n"  \
+: "=r" (reg))
+
+#define RCP15_PRRR(reg)		MRC(reg, p15, 0, c10, c2, 0)
+#define RCP15_NMRR(reg)		MRC(reg, p15, 0, c10, c2, 1)
+
+static int msm_iommu_tex_class[4];
+
 DEFINE_SPINLOCK(msm_iommu_lock);
 
 struct msm_priv {
@@ -98,6 +108,7 @@ static void __reset_context(void __iomem *base, int ctx)
 
 static void __program_context(void __iomem *base, int ctx, phys_addr_t pgtable)
 {
+	unsigned int prrr, nmrr;
 	__reset_context(base, ctx);
 
 	/* Set up HTW mode */
@@ -130,11 +141,11 @@ static void __program_context(void __iomem *base, int ctx, phys_addr_t pgtable)
 	/* Turn on TEX Remap */
 	SET_TRE(base, ctx, 1);
 
-	/* Do not configure PRRR / NMRR on the IOMMU for now. We will assume
-	 * TEX class 0 for everything until attributes are properly worked out
-	 */
-	SET_PRRR(base, ctx, 0);
-	SET_NMRR(base, ctx, 0);
+	/* Set TEX remap attributes */
+	RCP15_PRRR(prrr);
+	RCP15_NMRR(nmrr);
+	SET_PRRR(base, ctx, prrr);
+	SET_NMRR(base, ctx, nmrr);
 
 	/* Turn on BFB prefetch */
 	SET_BFBDFE(base, ctx, 1);
@@ -304,12 +315,21 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 	unsigned long *sl_table;
 	unsigned long *sl_pte;
 	unsigned long sl_offset;
+	unsigned int pgprot;
 	size_t len = 0x1000UL << order;
-	int ret = 0;
+	int ret = 0, tex, sh;
 
 	spin_lock_irqsave(&msm_iommu_lock, flags);
-	priv = domain->priv;
 
+	sh = (prot & MSM_IOMMU_ATTR_SH) ? 1 : 0;
+	tex = msm_iommu_tex_class[prot & 0x03];
+
+	if (tex < 0 || tex > NUM_TEX_CLASS - 1) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	priv = domain->priv;
 	if (!priv) {
 		ret = -EINVAL;
 		goto fail;
@@ -330,6 +350,18 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 		goto fail;
 	}
 
+	if (len == SZ_16M || len == SZ_1M) {
+		pgprot = sh ? FL_SHARED : 0;
+		pgprot |= tex & 0x01 ? FL_BUFFERABLE : 0;
+		pgprot |= tex & 0x02 ? FL_CACHEABLE : 0;
+		pgprot |= tex & 0x04 ? FL_TEX0 : 0;
+	} else	{
+		pgprot = sh ? SL_SHARED : 0;
+		pgprot |= tex & 0x01 ? SL_BUFFERABLE : 0;
+		pgprot |= tex & 0x02 ? SL_CACHEABLE : 0;
+		pgprot |= tex & 0x04 ? SL_TEX0 : 0;
+	}
+
 	fl_offset = FL_OFFSET(va);	/* Upper 12 bits */
 	fl_pte = fl_table + fl_offset;	/* int pointers, 4 bytes */
 
@@ -338,12 +370,12 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 		for (i = 0; i < 16; i++)
 			*(fl_pte+i) = (pa & 0xFF000000) | FL_SUPERSECTION |
 				  FL_AP_READ | FL_AP_WRITE | FL_TYPE_SECT |
-				  FL_SHARED;
+				  FL_SHARED | pgprot;
 	}
 
 	if (len == SZ_1M)
 		*fl_pte = (pa & 0xFFF00000) | FL_AP_READ | FL_AP_WRITE |
-						FL_TYPE_SECT | FL_SHARED;
+					    FL_TYPE_SECT | FL_SHARED | pgprot;
 
 	/* Need a 2nd level table */
 	if ((len == SZ_4K || len == SZ_64K) && (*fl_pte) == 0) {
@@ -368,14 +400,14 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 
 	if (len == SZ_4K)
 		*sl_pte = (pa & SL_BASE_MASK_SMALL) | SL_AP0 | SL_AP1 |
-					  SL_SHARED | SL_TYPE_SMALL;
+					  SL_SHARED | SL_TYPE_SMALL | pgprot;
 
 	if (len == SZ_64K) {
 		int i;
 
 		for (i = 0; i < 16; i++)
 			*(sl_pte+i) = (pa & SL_BASE_MASK_LARGE) | SL_AP0 |
-					    SL_AP1 | SL_SHARED | SL_TYPE_LARGE;
+				SL_AP1 | SL_SHARED | SL_TYPE_LARGE | pgprot;
 	}
 
 	__flush_iotlb(domain);
@@ -593,8 +625,47 @@ static struct iommu_ops msm_iommu_ops = {
 	.domain_has_cap = msm_iommu_domain_has_cap
 };
 
+static int __init get_tex_class(int icp, int ocp, int mt, int nos)
+{
+	int i = 0;
+	unsigned int prrr = 0;
+	unsigned int nmrr = 0;
+	int c_icp, c_ocp, c_mt, c_nos;
+
+	RCP15_PRRR(prrr);
+	RCP15_NMRR(nmrr);
+
+	for (i = 0; i < NUM_TEX_CLASS; i++) {
+		c_nos = PRRR_NOS(prrr, i);
+		c_mt = PRRR_MT(prrr, i);
+		c_icp = NMRR_ICP(nmrr, i);
+		c_ocp = NMRR_OCP(nmrr, i);
+
+		if (icp == c_icp && ocp == c_ocp && c_mt == mt && c_nos == nos)
+			return i;
+	}
+
+	return -ENODEV;
+}
+
+static void __init setup_iommu_tex_classes(void)
+{
+	msm_iommu_tex_class[MSM_IOMMU_ATTR_NONCACHED] =
+			get_tex_class(CP_NONCACHED, CP_NONCACHED, MT_NORMAL, 1);
+
+	msm_iommu_tex_class[MSM_IOMMU_ATTR_CACHED_WB_WA] =
+			get_tex_class(CP_WB_WA, CP_WB_WA, MT_NORMAL, 1);
+
+	msm_iommu_tex_class[MSM_IOMMU_ATTR_CACHED_WB_NWA] =
+			get_tex_class(CP_WB_NWA, CP_WB_NWA, MT_NORMAL, 1);
+
+	msm_iommu_tex_class[MSM_IOMMU_ATTR_CACHED_WT] =
+			get_tex_class(CP_WT, CP_WT, MT_NORMAL, 1);
+}
+
 static int __init msm_iommu_init(void)
 {
+	setup_iommu_tex_classes();
 	register_iommu(&msm_iommu_ops);
 	return 0;
 }
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

