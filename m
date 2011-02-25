Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1BYCAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:00:53 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53149 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1BYCAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:00:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76352303"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 3/4] msm: iommu: Use ASID tagging instead of VMID tagging
Date: Thu, 24 Feb 2011 18:00:41 -0800
Message-Id: <1298599242-21971-3-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
In-Reply-To: <1298599242-21971-1-git-send-email-stepanm@codeaurora.org>
References: <1298599242-21971-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ASID tags in the TLB instead of VMID tags in
preparation for changes to the secure environment.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h |    4 +++-
 arch/arm/mach-msm/iommu.c                      |    9 ++++-----
 arch/arm/mach-msm/iommu_dev.c                  |   11 +++++++----
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
index c2c3da9..bbd397c 100644
--- a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
+++ b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 and
@@ -68,6 +68,7 @@ do { \
 #define FL_CACHEABLE		(1 << 3)
 #define FL_TEX0			(1 << 12)
 #define FL_OFFSET(va)		(((va) & 0xFFF00000) >> 20)
+#define FL_NG			(1 << 17)

 /* Second-level page table bits */
 #define SL_BASE_MASK_LARGE	0xFFFF0000
@@ -81,6 +82,7 @@ do { \
 #define SL_CACHEABLE		(1 << 3)
 #define SL_TEX0			(1 << 6)
 #define SL_OFFSET(va)		(((va) & 0xFF000) >> 12)
+#define SL_NG			(1 << 11)

 /* Memory type and cache policy attributes */
 #define MT_SO			0
diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index cde3cd0..9c08740 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -137,7 +137,6 @@ static void __reset_context(void __iomem *base, int ctx)
 	SET_TLBLKCR(base, ctx, 0);
 	SET_PRRR(base, ctx, 0);
 	SET_NMRR(base, ctx, 0);
-	SET_CONTEXTIDR(base, ctx, 0);
 }

 static void __program_context(void __iomem *base, int ctx, phys_addr_t pgtable)
@@ -418,11 +417,11 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,
 		for (i = 0; i < 16; i++)
 			*(fl_pte+i) = (pa & 0xFF000000) | FL_SUPERSECTION |
 				  FL_AP_READ | FL_AP_WRITE | FL_TYPE_SECT |
-				  FL_SHARED | pgprot;
+				  FL_SHARED | FL_NG | pgprot;
 	}

 	if (len == SZ_1M)
-		*fl_pte = (pa & 0xFFF00000) | FL_AP_READ | FL_AP_WRITE |
+		*fl_pte = (pa & 0xFFF00000) | FL_AP_READ | FL_AP_WRITE | FL_NG |
 					    FL_TYPE_SECT | FL_SHARED | pgprot;

 	/* Need a 2nd level table */
@@ -447,7 +446,7 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,


 	if (len == SZ_4K)
-		*sl_pte = (pa & SL_BASE_MASK_SMALL) | SL_AP0 | SL_AP1 |
+		*sl_pte = (pa & SL_BASE_MASK_SMALL) | SL_AP0 | SL_AP1 | SL_NG |
 					  SL_SHARED | SL_TYPE_SMALL | pgprot;

 	if (len == SZ_64K) {
@@ -455,7 +454,7 @@ static int msm_iommu_map(struct iommu_domain *domain, unsigned long va,

 		for (i = 0; i < 16; i++)
 			*(sl_pte+i) = (pa & SL_BASE_MASK_LARGE) | SL_AP0 |
-				SL_AP1 | SL_SHARED | SL_TYPE_LARGE | pgprot;
+			    SL_NG | SL_AP1 | SL_SHARED | SL_TYPE_LARGE | pgprot;
 	}

 	ret = __flush_iotlb(domain);
diff --git a/arch/arm/mach-msm/iommu_dev.c b/arch/arm/mach-msm/iommu_dev.c
index 69acd1e..c1722eb 100644
--- a/arch/arm/mach-msm/iommu_dev.c
+++ b/arch/arm/mach-msm/iommu_dev.c
@@ -330,14 +330,17 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 		SET_M2VCBR_N(drvdata->base, mid, 0);
 		SET_CBACR_N(drvdata->base, c->num, 0);

-		/* Set VMID = MID */
-		SET_VMID(drvdata->base, mid, mid);
+		/* Set VMID = 0 */
+		SET_VMID(drvdata->base, mid, 0);

 		/* Set the context number for that MID to this context */
 		SET_CBNDX(drvdata->base, mid, c->num);

-		/* Set MID associated with this context bank */
-		SET_CBVMID(drvdata->base, c->num, mid);
+		/* Set MID associated with this context bank to 0*/
+		SET_CBVMID(drvdata->base, c->num, 0);
+
+		/* Set the ASID for TLB tagging for this context */
+		SET_CONTEXTIDR_ASID(drvdata->base, c->num, c->num);

 		/* Set security bit override to be Non-secure */
 		SET_NSCFG(drvdata->base, mid, 3);
--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

