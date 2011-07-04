Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab1GDCOx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:14:53 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:35568 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1GDCO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:14:27 -0400
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kwanghyun La <nala.la@samsung.com>, Ilho Lee <ilho215.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: [PATCH 1/6] ARM: EXYNOS4: SYSMMU: Remove SYSMMU_MDMA2
Date: Mon,  4 Jul 2011 10:41:42 +0900
Message-Id: <1309743708-1505-2-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
References: <1309743708-1505-1-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXYNOS4210 has 2 MDMA(MDMA0 and MDMA1) and thus 2 System MMUs
for each MDMAs.

The current definition of sysmmu_ips represented like below:
SYSMMU_MDMA -> System MMU of MDM0
SYSMMU_MDMA2 -> System MMU of MDMA1

Since MDMA0 is not used anymore, it is removed and the definition
of sysmmu_ips is changed as following:
SYSMMU_MDMA -> System MMU of MDMA1
SYSMMU_MDMA2 -> removed.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos4/clock.c               |    8 ++--
 arch/arm/mach-exynos4/dev-sysmmu.c          |   73 +++++++++++---------------
 arch/arm/mach-exynos4/include/mach/sysmmu.h |    3 +-
 3 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/arch/arm/mach-exynos4/clock.c b/arch/arm/mach-exynos4/clock.c
index 5091e13..256b46b 100644
--- a/arch/arm/mach-exynos4/clock.c
+++ b/arch/arm/mach-exynos4/clock.c
@@ -622,10 +622,6 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 13),
 	}, {
-		.name		= "SYSMMU_MDMA",
-		.enable		= exynos4_clk_ip_image_ctrl,
-		.ctrlbit	= (1 << 5),
-	}, {
 		.name		= "SYSMMU_FIMC0",
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 7),
@@ -666,6 +662,10 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
+		.name		= "SYSMMU_MDMA",
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 5),
+	}, {
 		.name		= "SYSMMU_TV",
 		.enable		= exynos4_clk_ip_tv_ctrl,
 		.ctrlbit	= (1 << 4),
diff --git a/arch/arm/mach-exynos4/dev-sysmmu.c b/arch/arm/mach-exynos4/dev-sysmmu.c
index 3b7cae0..af1110e 100644
--- a/arch/arm/mach-exynos4/dev-sysmmu.c
+++ b/arch/arm/mach-exynos4/dev-sysmmu.c
@@ -20,7 +20,6 @@
 
 /* These names must be equal to the clock names in mach-exynos4/clock.c */
 const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM] = {
-	"SYSMMU_MDMA"	,
 	"SYSMMU_SSS"	,
 	"SYSMMU_FIMC0"	,
 	"SYSMMU_FIMC1"	,
@@ -32,7 +31,7 @@ const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM] = {
 	"SYSMMU_PCIe"	,
 	"SYSMMU_G2D"	,
 	"SYSMMU_ROTATOR",
-	"SYSMMU_MDMA2"	,
+	"SYSMMU_MDMA"	,
 	"SYSMMU_TV"	,
 	"SYSMMU_MFC_L"	,
 	"SYSMMU_MFC_R"	,
@@ -40,161 +39,151 @@ const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM] = {
 
 static struct resource exynos4_sysmmu_resource[] = {
 	[0] = {
-		.start	= EXYNOS4_PA_SYSMMU_MDMA,
-		.end	= EXYNOS4_PA_SYSMMU_MDMA + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= IRQ_SYSMMU_MDMA0_0,
-		.end	= IRQ_SYSMMU_MDMA0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[2] = {
 		.start	= EXYNOS4_PA_SYSMMU_SSS,
 		.end	= EXYNOS4_PA_SYSMMU_SSS + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[3] = {
+	[1] = {
 		.start	= IRQ_SYSMMU_SSS_0,
 		.end	= IRQ_SYSMMU_SSS_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[4] = {
+	[2] = {
 		.start	= EXYNOS4_PA_SYSMMU_FIMC0,
 		.end	= EXYNOS4_PA_SYSMMU_FIMC0 + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[5] = {
+	[3] = {
 		.start	= IRQ_SYSMMU_FIMC0_0,
 		.end	= IRQ_SYSMMU_FIMC0_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[6] = {
+	[4] = {
 		.start	= EXYNOS4_PA_SYSMMU_FIMC1,
 		.end	= EXYNOS4_PA_SYSMMU_FIMC1 + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[7] = {
+	[5] = {
 		.start	= IRQ_SYSMMU_FIMC1_0,
 		.end	= IRQ_SYSMMU_FIMC1_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[8] = {
+	[6] = {
 		.start	= EXYNOS4_PA_SYSMMU_FIMC2,
 		.end	= EXYNOS4_PA_SYSMMU_FIMC2 + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[9] = {
+	[7] = {
 		.start	= IRQ_SYSMMU_FIMC2_0,
 		.end	= IRQ_SYSMMU_FIMC2_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[10] = {
+	[8] = {
 		.start	= EXYNOS4_PA_SYSMMU_FIMC3,
 		.end	= EXYNOS4_PA_SYSMMU_FIMC3 + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[11] = {
+	[9] = {
 		.start	= IRQ_SYSMMU_FIMC3_0,
 		.end	= IRQ_SYSMMU_FIMC3_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[12] = {
+	[10] = {
 		.start	= EXYNOS4_PA_SYSMMU_JPEG,
 		.end	= EXYNOS4_PA_SYSMMU_JPEG + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[13] = {
+	[11] = {
 		.start	= IRQ_SYSMMU_JPEG_0,
 		.end	= IRQ_SYSMMU_JPEG_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[14] = {
+	[12] = {
 		.start	= EXYNOS4_PA_SYSMMU_FIMD0,
 		.end	= EXYNOS4_PA_SYSMMU_FIMD0 + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[15] = {
+	[13] = {
 		.start	= IRQ_SYSMMU_LCD0_M0_0,
 		.end	= IRQ_SYSMMU_LCD0_M0_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[16] = {
+	[14] = {
 		.start	= EXYNOS4_PA_SYSMMU_FIMD1,
 		.end	= EXYNOS4_PA_SYSMMU_FIMD1 + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[17] = {
+	[15] = {
 		.start	= IRQ_SYSMMU_LCD1_M1_0,
 		.end	= IRQ_SYSMMU_LCD1_M1_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[18] = {
+	[16] = {
 		.start	= EXYNOS4_PA_SYSMMU_PCIe,
 		.end	= EXYNOS4_PA_SYSMMU_PCIe + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[19] = {
+	[17] = {
 		.start	= IRQ_SYSMMU_PCIE_0,
 		.end	= IRQ_SYSMMU_PCIE_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[20] = {
+	[18] = {
 		.start	= EXYNOS4_PA_SYSMMU_G2D,
 		.end	= EXYNOS4_PA_SYSMMU_G2D + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[21] = {
+	[19] = {
 		.start	= IRQ_SYSMMU_2D_0,
 		.end	= IRQ_SYSMMU_2D_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[22] = {
+	[20] = {
 		.start	= EXYNOS4_PA_SYSMMU_ROTATOR,
 		.end	= EXYNOS4_PA_SYSMMU_ROTATOR + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[23] = {
+	[21] = {
 		.start	= IRQ_SYSMMU_ROTATOR_0,
 		.end	= IRQ_SYSMMU_ROTATOR_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[24] = {
+	[22] = {
 		.start	= EXYNOS4_PA_SYSMMU_MDMA2,
 		.end	= EXYNOS4_PA_SYSMMU_MDMA2 + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[25] = {
+	[23] = {
 		.start	= IRQ_SYSMMU_MDMA1_0,
 		.end	= IRQ_SYSMMU_MDMA1_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[26] = {
+	[24] = {
 		.start	= EXYNOS4_PA_SYSMMU_TV,
 		.end	= EXYNOS4_PA_SYSMMU_TV + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[27] = {
+	[25] = {
 		.start	= IRQ_SYSMMU_TV_M0_0,
 		.end	= IRQ_SYSMMU_TV_M0_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[28] = {
+	[26] = {
 		.start	= EXYNOS4_PA_SYSMMU_MFC_L,
 		.end	= EXYNOS4_PA_SYSMMU_MFC_L + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[29] = {
+	[27] = {
 		.start	= IRQ_SYSMMU_MFC_M0_0,
 		.end	= IRQ_SYSMMU_MFC_M0_0,
 		.flags	= IORESOURCE_IRQ,
 	},
-	[30] = {
+	[28] = {
 		.start	= EXYNOS4_PA_SYSMMU_MFC_R,
 		.end	= EXYNOS4_PA_SYSMMU_MFC_R + SZ_64K - 1,
 		.flags	= IORESOURCE_MEM,
 	},
-	[31] = {
+	[29] = {
 		.start	= IRQ_SYSMMU_MFC_M1_0,
 		.end	= IRQ_SYSMMU_MFC_M1_0,
 		.flags	= IORESOURCE_IRQ,
@@ -203,7 +192,7 @@ static struct resource exynos4_sysmmu_resource[] = {
 
 struct platform_device exynos4_device_sysmmu = {
 	.name		= "s5p-sysmmu",
-	.id		= 32,
+	.id		= 30,
 	.num_resources	= ARRAY_SIZE(exynos4_sysmmu_resource),
 	.resource	= exynos4_sysmmu_resource,
 };
diff --git a/arch/arm/mach-exynos4/include/mach/sysmmu.h b/arch/arm/mach-exynos4/include/mach/sysmmu.h
index 6a5fbb5..2d5d78b 100644
--- a/arch/arm/mach-exynos4/include/mach/sysmmu.h
+++ b/arch/arm/mach-exynos4/include/mach/sysmmu.h
@@ -14,7 +14,6 @@
 #define __ASM_ARM_ARCH_SYSMMU_H __FILE__
 
 enum exynos4_sysmmu_ips {
-	SYSMMU_MDMA,
 	SYSMMU_SSS,
 	SYSMMU_FIMC0,
 	SYSMMU_FIMC1,
@@ -26,7 +25,7 @@ enum exynos4_sysmmu_ips {
 	SYSMMU_PCIe,
 	SYSMMU_G2D,
 	SYSMMU_ROTATOR,
-	SYSMMU_MDMA2,
+	SYSMMU_MDMA,
 	SYSMMU_TV,
 	SYSMMU_MFC_L,
 	SYSMMU_MFC_R,
-- 
1.7.1

