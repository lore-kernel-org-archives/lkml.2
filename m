Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1CAAFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:05:04 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32510 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab1CAAFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:05:02 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77214389"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 1/2] msm: iommu: Don't read from write-only registers
Date: Mon, 28 Feb 2011 16:04:55 -0800
Message-Id: <1298937896-29324-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't read from V2Pxx command registers when doing
iova-to-phys operations. These registers are write-only and
reading the value before modifying the VA bits is
unnecessary.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h |   28 ------------------------
 arch/arm/mach-msm/iommu.c                      |    2 +-
 2 files changed, 1 insertions(+), 29 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
index bbd397c..fc16010 100644
--- a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
+++ b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
@@ -625,20 +625,6 @@ do { \
 #define SET_INDEX(b, c, v)	 SET_CONTEXT_FIELD(b, c, V2PSR, INDEX, v)


-/* V2Pxx UW UR PW PR */
-#define SET_V2PUW_INDEX(b, c, v) SET_CONTEXT_FIELD(b, c, V2PUW, V2Pxx_INDEX, v)
-#define SET_V2PUW_VA(b, c, v)	 SET_CONTEXT_FIELD(b, c, V2PUW, V2Pxx_VA, v)
-
-#define SET_V2PUR_INDEX(b, c, v) SET_CONTEXT_FIELD(b, c, V2PUR, V2Pxx_INDEX, v)
-#define SET_V2PUR_VA(b, c, v)	 SET_CONTEXT_FIELD(b, c, V2PUR, V2Pxx_VA, v)
-
-#define SET_V2PPW_INDEX(b, c, v) SET_CONTEXT_FIELD(b, c, V2PPW, V2Pxx_INDEX, v)
-#define SET_V2PPW_VA(b, c, v)	 SET_CONTEXT_FIELD(b, c, V2PPW, V2Pxx_VA, v)
-
-#define SET_V2PPR_INDEX(b, c, v) SET_CONTEXT_FIELD(b, c, V2PPR, V2Pxx_INDEX, v)
-#define SET_V2PPR_VA(b, c, v)	 SET_CONTEXT_FIELD(b, c, V2PPR, V2Pxx_VA, v)
-
-
 /* Context Register getters */
 /* ACTLR */
 #define GET_CFERE(b, c)	        GET_CONTEXT_FIELD(b, c, ACTLR, CFERE)
@@ -826,20 +812,6 @@ do { \
 #define GET_INDEX(b, c)		GET_CONTEXT_FIELD(b, c, V2PSR, INDEX)


-/* V2Pxx UW UR PW PR */
-#define GET_V2PUW_INDEX(b, c)	GET_CONTEXT_FIELD(b, c, V2PUW, V2Pxx_INDEX)
-#define GET_V2PUW_VA(b, c)	GET_CONTEXT_FIELD(b, c, V2PUW, V2Pxx_VA)
-
-#define GET_V2PUR_INDEX(b, c)	GET_CONTEXT_FIELD(b, c, V2PUR, V2Pxx_INDEX)
-#define GET_V2PUR_VA(b, c)	GET_CONTEXT_FIELD(b, c, V2PUR, V2Pxx_VA)
-
-#define GET_V2PPW_INDEX(b, c)	GET_CONTEXT_FIELD(b, c, V2PPW, V2Pxx_INDEX)
-#define GET_V2PPW_VA(b, c)	GET_CONTEXT_FIELD(b, c, V2PPW, V2Pxx_VA)
-
-#define GET_V2PPR_INDEX(b, c)	GET_CONTEXT_FIELD(b, c, V2PPR, V2Pxx_INDEX)
-#define GET_V2PPR_VA(b, c)	GET_CONTEXT_FIELD(b, c, V2PPR, V2Pxx_VA)
-
-
 /* Global Registers */
 #define M2VCBR_N	(0xFF000)
 #define CBACR_N		(0xFF800)
diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index 0146f519..1a584e0 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -579,7 +579,7 @@ static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,

 	/* Invalidate context TLB */
 	SET_CTX_TLBIALL(base, ctx, 0);
-	SET_V2PPR_VA(base, ctx, va >> V2Pxx_VA_SHIFT);
+	SET_V2PPR(base, ctx, va & V2Pxx_VA);

 	par = GET_PAR(base, ctx);

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

