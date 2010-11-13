Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab0KMDat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:49 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28676 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab0KMDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61810881"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 12/14] msm: iommu: Definitions for extended memory attributes
Date: Fri, 12 Nov 2010 19:29:58 -0800
Message-Id: <1289619000-13167-13-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the register field definitions and memory attribute
definitions that will be needed to support IOMMU
transactions with cache-coherent memory access.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/iommu.h         |   11 +++++++++++
 arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h |   22 +++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/iommu.h b/arch/arm/mach-msm/include/mach/iommu.h
index 17fc79f..bfc80c8 100644
--- a/arch/arm/mach-msm/include/mach/iommu.h
+++ b/arch/arm/mach-msm/include/mach/iommu.h
@@ -20,6 +20,17 @@
 
 #include <linux/interrupt.h>
 
+/* Sharability attributes of MSM IOMMU mappings */
+#define MSM_IOMMU_ATTR_NON_SH		0x0
+#define MSM_IOMMU_ATTR_SH		0x4
+
+/* Cacheability attributes of MSM IOMMU mappings */
+#define MSM_IOMMU_ATTR_NONCACHED	0x0
+#define MSM_IOMMU_ATTR_CACHED_WB_WA	0x1
+#define MSM_IOMMU_ATTR_CACHED_WB_NWA	0x2
+#define MSM_IOMMU_ATTR_CACHED_WT	0x3
+
+
 /* Maximum number of Machine IDs that we are allowing to be mapped to the same
  * context bank. The number of MIDs mapped to the same CB does not affect
  * performance, but there is a practical limit on how many distinct MIDs may
diff --git a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
index f9386d3..c2c3da9 100644
--- a/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
+++ b/arch/arm/mach-msm/include/mach/iommu_hw-8xxx.h
@@ -54,6 +54,7 @@ do { \
 
 #define NUM_FL_PTE	4096
 #define NUM_SL_PTE	256
+#define NUM_TEX_CLASS	8
 
 /* First-level page table bits */
 #define FL_BASE_MASK		0xFFFFFC00
@@ -63,6 +64,9 @@ do { \
 #define FL_AP_WRITE		(1 << 10)
 #define FL_AP_READ		(1 << 11)
 #define FL_SHARED		(1 << 16)
+#define FL_BUFFERABLE		(1 << 2)
+#define FL_CACHEABLE		(1 << 3)
+#define FL_TEX0			(1 << 12)
 #define FL_OFFSET(va)		(((va) & 0xFFF00000) >> 20)
 
 /* Second-level page table bits */
@@ -73,8 +77,20 @@ do { \
 #define SL_AP0			(1 << 4)
 #define SL_AP1			(2 << 4)
 #define SL_SHARED		(1 << 10)
+#define SL_BUFFERABLE		(1 << 2)
+#define SL_CACHEABLE		(1 << 3)
+#define SL_TEX0			(1 << 6)
 #define SL_OFFSET(va)		(((va) & 0xFF000) >> 12)
 
+/* Memory type and cache policy attributes */
+#define MT_SO			0
+#define MT_DEV			1
+#define MT_NORMAL		2
+#define CP_NONCACHED		0
+#define CP_WB_WA		1
+#define CP_WT			2
+#define CP_WB_NWA		3
+
 /* Global register setters / getters */
 #define SET_M2VCBR_N(b, N, v)	 SET_GLOBAL_REG_N(M2VCBR_N, N, (b), (v))
 #define SET_CBACR_N(b, N, v)	 SET_GLOBAL_REG_N(CBACR_N, N, (b), (v))
@@ -706,7 +722,9 @@ do { \
 #define GET_OCPC5(b, c)		GET_CONTEXT_FIELD(b, c, NMRR, OCPC5)
 #define GET_OCPC6(b, c)		GET_CONTEXT_FIELD(b, c, NMRR, OCPC6)
 #define GET_OCPC7(b, c)		GET_CONTEXT_FIELD(b, c, NMRR, OCPC7)
-
+#define NMRR_ICP(nmrr, n)	(((nmrr) & (3 << ((n) * 2))) >> ((n) * 2))
+#define NMRR_OCP(nmrr, n)	(((nmrr) & (3 << ((n) * 2 + 16))) >> \
+								((n) * 2 + 16))
 
 /* PAR */
 #define GET_FAULT(b, c)		GET_CONTEXT_FIELD(b, c, PAR, FAULT)
@@ -750,6 +768,8 @@ do { \
 #define GET_NOS5(b, c)		GET_CONTEXT_FIELD(b, c, PRRR, NOS5)
 #define GET_NOS6(b, c)		GET_CONTEXT_FIELD(b, c, PRRR, NOS6)
 #define GET_NOS7(b, c)		GET_CONTEXT_FIELD(b, c, PRRR, NOS7)
+#define PRRR_NOS(prrr, n)	 ((prrr) & (1 << ((n) + 24)) ? 1 : 0)
+#define PRRR_MT(prrr, n)	 ((((prrr) & (3 << ((n) * 2))) >> ((n) * 2)))
 
 
 /* RESUME */
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

