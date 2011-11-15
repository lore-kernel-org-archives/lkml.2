Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1KOFR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 00:17:57 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:41274 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab1KOFRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 00:17:42 -0500
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        YoungLak Kim <younglak1004.kim@samsung.com>,
        KyongHo Cho <pullip.cho@samsung.com>
Subject: [PATCH v6 1/2] ARM: EXYNOS: Change System MMU platform device definitions
Date: Tue, 15 Nov 2011 13:58:51 +0900
Message-Id: <1321333132-17662-2-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1321333132-17662-1-git-send-email-pullip.cho@samsung.com>
References: <1321333132-17662-1-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling System MMUs with an identifier is not flexible to manage
System MMU platform devices because of the following reasons:
1. A device driver which needs to handle System MMU must know the ID.
2. A System MMU may not present in some implementations of Exynos family.
3. Handling System MMU with IOMMU API does not require an ID.

This patch is the result of removing ID of System MMUs.
Instead, a device driver that needs to handle its System MMU must
use IOMMU API while its descriptor of platform device is given.

This patch also includes the following enhanclements:
- A System MMU device becomes a child if its power domain device.
- clkdev

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos/Kconfig                      |    2 +
 arch/arm/mach-exynos/clock-exynos4210.c           |   16 ++
 arch/arm/mach-exynos/clock.c                      |   55 ++--
 arch/arm/mach-exynos/dev-sysmmu.c                 |  272 +++++----------------
 arch/arm/mach-exynos/include/mach/dev-sysmmu.h    |   61 +++++
 arch/arm/mach-exynos/include/mach/exynos4-clock.h |    1 +
 arch/arm/mach-exynos/include/mach/map.h           |    3 +-
 arch/arm/mach-exynos/include/mach/regs-sysmmu.h   |   26 +-
 arch/arm/mach-exynos/include/mach/sysmmu.h        |   46 ----
 arch/arm/mach-exynos/mach-armlex4210.c            |    1 -
 arch/arm/mach-exynos/mach-nuri.c                  |   40 +++
 arch/arm/mach-exynos/mach-origen.c                |   42 ++++
 arch/arm/mach-exynos/mach-smdk4x12.c              |    9 +
 arch/arm/mach-exynos/mach-smdkv310.c              |   43 ++++-
 arch/arm/mach-exynos/mach-universal_c210.c        |   42 ++++
 arch/arm/plat-samsung/include/plat/devs.h         |    1 -
 16 files changed, 356 insertions(+), 304 deletions(-)
 create mode 100644 arch/arm/mach-exynos/include/mach/dev-sysmmu.h
 delete mode 100644 arch/arm/mach-exynos/include/mach/sysmmu.h

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 0afcc3b..67769fb 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -272,6 +272,7 @@ config MACH_NURI
 	select EXYNOS4_SETUP_I2C5
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
+	select EXYNOS4_DEV_SYSMMU
 	select S5P_SETUP_MIPIPHY
 	select SAMSUNG_DEV_PWM
 	select SAMSUNG_DEV_ADC
@@ -301,6 +302,7 @@ config MACH_ORIGEN
 	select EXYNOS4_SETUP_FIMD0
 	select EXYNOS4_SETUP_SDHCI
 	select EXYNOS4_SETUP_USB_PHY
+	select EXYNOS4_DEV_SYSMMU
 	help
 	  Machine support for ORIGEN based on Samsung EXYNOS4210
 
diff --git a/arch/arm/mach-exynos/clock-exynos4210.c b/arch/arm/mach-exynos/clock-exynos4210.c
index b9d5ef6..a84136b 100644
--- a/arch/arm/mach-exynos/clock-exynos4210.c
+++ b/arch/arm/mach-exynos/clock-exynos4210.c
@@ -30,6 +30,7 @@
 #include <mach/map.h>
 #include <mach/regs-clock.h>
 #include <mach/exynos4-clock.h>
+#include <mach/dev-sysmmu.h>
 
 static struct sleep_save exynos4210_clock_save[] = {
 	SAVE_ITEM(S5P_CLKSRC_IMAGE),
@@ -93,6 +94,21 @@ static struct clk init_clocks_off[] = {
 		.devname	= "exynos4-fb.1",
 		.enable		= exynos4_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 0),
+	}, {
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(fimd1, 7),
+		.enable		= exynos4_clk_ip_lcd1_ctrl,
+		.ctrlbit	= (1 << 4),
+	}, {
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(pcie, 8),
+		.enable		= exynos4_clk_ip_fsys_ctrl,
+		.ctrlbit	= (1 << 18),
+	}, {
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(2d, 9),
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 3),
 	},
 };
 
diff --git a/arch/arm/mach-exynos/clock.c b/arch/arm/mach-exynos/clock.c
index 5d8d483..cf0f516 100644
--- a/arch/arm/mach-exynos/clock.c
+++ b/arch/arm/mach-exynos/clock.c
@@ -26,7 +26,7 @@
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
-#include <mach/sysmmu.h>
+#include <mach/dev-sysmmu.h>
 #include <mach/exynos4-clock.h>
 
 static struct sleep_save exynos4_clock_save[] = {
@@ -166,7 +166,7 @@ static int exynos4_clk_ip_tv_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(S5P_CLKGATE_IP_TV, clk, enable);
 }
 
-static int exynos4_clk_ip_image_ctrl(struct clk *clk, int enable)
+int exynos4_clk_ip_image_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(S5P_CLKGATE_IP_IMAGE, clk, enable);
 }
@@ -676,62 +676,61 @@ static struct clk init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 14),
 	}, {
-		.name		= "SYSMMU_MDMA",
-		.enable		= exynos4_clk_ip_image_ctrl,
-		.ctrlbit	= (1 << 5),
-	}, {
-		.name		= "SYSMMU_FIMC0",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(fimc0, 1),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 7),
 	}, {
-		.name		= "SYSMMU_FIMC1",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(fimc1, 2),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 8),
 	}, {
-		.name		= "SYSMMU_FIMC2",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(fimc2, 3),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 9),
 	}, {
-		.name		= "SYSMMU_FIMC3",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(fimc3, 4),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 10),
 	}, {
-		.name		= "SYSMMU_JPEG",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(jpeg, 5),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 11),
 	}, {
-		.name		= "SYSMMU_FIMD0",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(fimd0, 6),
 		.enable		= exynos4_clk_ip_lcd0_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_FIMD1",
-		.enable		= exynos4_clk_ip_lcd1_ctrl,
-		.ctrlbit	= (1 << 4),
-	}, {
-		.name		= "SYSMMU_PCIe",
-		.enable		= exynos4_clk_ip_fsys_ctrl,
-		.ctrlbit	= (1 << 18),
-	}, {
-		.name		= "SYSMMU_G2D",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(rot, 10),
 		.enable		= exynos4_clk_ip_image_ctrl,
-		.ctrlbit	= (1 << 3),
+		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_ROTATOR",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(mdma, 11),
 		.enable		= exynos4_clk_ip_image_ctrl,
-		.ctrlbit	= (1 << 4),
+		.ctrlbit	= (1 << 5),
 	}, {
-		.name		= "SYSMMU_TV",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(tv, 12),
 		.enable		= exynos4_clk_ip_tv_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_MFC_L",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(mfc_l, 13),
 		.enable		= exynos4_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 1),
 	}, {
-		.name		= "SYSMMU_MFC_R",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(mfc_r, 14),
 		.enable		= exynos4_clk_ip_mfc_ctrl,
 		.ctrlbit	= (1 << 2),
-	}
+	},
 };
 
 static struct clk init_clocks[] = {
diff --git a/arch/arm/mach-exynos/dev-sysmmu.c b/arch/arm/mach-exynos/dev-sysmmu.c
index 781563f..43b1719 100644
--- a/arch/arm/mach-exynos/dev-sysmmu.c
+++ b/arch/arm/mach-exynos/dev-sysmmu.c
@@ -1,9 +1,9 @@
-/* linux/arch/arm/mach-exynos4/dev-sysmmu.c
+/* linux/arch/arm/mach-exynos/dev-sysmmu.c
  *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * EXYNOS4 - System MMU support
+ * EXYNOS - System MMU support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -12,222 +12,70 @@
 
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/export.h>
 
 #include <mach/map.h>
 #include <mach/irqs.h>
-#include <mach/sysmmu.h>
+#include <mach/dev-sysmmu.h>
 #include <plat/s5p-clock.h>
 
-/* These names must be equal to the clock names in mach-exynos4/clock.c */
-const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM] = {
-	"SYSMMU_MDMA"	,
-	"SYSMMU_SSS"	,
-	"SYSMMU_FIMC0"	,
-	"SYSMMU_FIMC1"	,
-	"SYSMMU_FIMC2"	,
-	"SYSMMU_FIMC3"	,
-	"SYSMMU_JPEG"	,
-	"SYSMMU_FIMD0"	,
-	"SYSMMU_FIMD1"	,
-	"SYSMMU_PCIe"	,
-	"SYSMMU_G2D"	,
-	"SYSMMU_ROTATOR",
-	"SYSMMU_MDMA2"	,
-	"SYSMMU_TV"	,
-	"SYSMMU_MFC_L"	,
-	"SYSMMU_MFC_R"	,
-};
+#if defined(CONFIG_ARCH_EXYNOS4)
+#define EXYNOS_PA_SYSMMU(ipbase) EXYNOS4_PA_SYSMMU_##ipbase
+#endif
 
-static struct resource exynos4_sysmmu_resource[] = {
-	[0] = {
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
-		.start	= EXYNOS4_PA_SYSMMU_SSS,
-		.end	= EXYNOS4_PA_SYSMMU_SSS + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[3] = {
-		.start	= IRQ_SYSMMU_SSS_0,
-		.end	= IRQ_SYSMMU_SSS_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[4] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC0,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[5] = {
-		.start	= IRQ_SYSMMU_FIMC0_0,
-		.end	= IRQ_SYSMMU_FIMC0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[6] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC1,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[7] = {
-		.start	= IRQ_SYSMMU_FIMC1_0,
-		.end	= IRQ_SYSMMU_FIMC1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[8] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC2,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[9] = {
-		.start	= IRQ_SYSMMU_FIMC2_0,
-		.end	= IRQ_SYSMMU_FIMC2_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[10] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMC3,
-		.end	= EXYNOS4_PA_SYSMMU_FIMC3 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[11] = {
-		.start	= IRQ_SYSMMU_FIMC3_0,
-		.end	= IRQ_SYSMMU_FIMC3_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[12] = {
-		.start	= EXYNOS4_PA_SYSMMU_JPEG,
-		.end	= EXYNOS4_PA_SYSMMU_JPEG + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[13] = {
-		.start	= IRQ_SYSMMU_JPEG_0,
-		.end	= IRQ_SYSMMU_JPEG_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[14] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMD0,
-		.end	= EXYNOS4_PA_SYSMMU_FIMD0 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[15] = {
-		.start	= IRQ_SYSMMU_LCD0_M0_0,
-		.end	= IRQ_SYSMMU_LCD0_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[16] = {
-		.start	= EXYNOS4_PA_SYSMMU_FIMD1,
-		.end	= EXYNOS4_PA_SYSMMU_FIMD1 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[17] = {
-		.start	= IRQ_SYSMMU_LCD1_M1_0,
-		.end	= IRQ_SYSMMU_LCD1_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[18] = {
-		.start	= EXYNOS4_PA_SYSMMU_PCIe,
-		.end	= EXYNOS4_PA_SYSMMU_PCIe + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[19] = {
-		.start	= IRQ_SYSMMU_PCIE_0,
-		.end	= IRQ_SYSMMU_PCIE_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[20] = {
-		.start	= EXYNOS4_PA_SYSMMU_G2D,
-		.end	= EXYNOS4_PA_SYSMMU_G2D + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[21] = {
-		.start	= IRQ_SYSMMU_2D_0,
-		.end	= IRQ_SYSMMU_2D_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[22] = {
-		.start	= EXYNOS4_PA_SYSMMU_ROTATOR,
-		.end	= EXYNOS4_PA_SYSMMU_ROTATOR + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[23] = {
-		.start	= IRQ_SYSMMU_ROTATOR_0,
-		.end	= IRQ_SYSMMU_ROTATOR_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[24] = {
-		.start	= EXYNOS4_PA_SYSMMU_MDMA2,
-		.end	= EXYNOS4_PA_SYSMMU_MDMA2 + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[25] = {
-		.start	= IRQ_SYSMMU_MDMA1_0,
-		.end	= IRQ_SYSMMU_MDMA1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[26] = {
-		.start	= EXYNOS4_PA_SYSMMU_TV,
-		.end	= EXYNOS4_PA_SYSMMU_TV + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[27] = {
-		.start	= IRQ_SYSMMU_TV_M0_0,
-		.end	= IRQ_SYSMMU_TV_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[28] = {
-		.start	= EXYNOS4_PA_SYSMMU_MFC_L,
-		.end	= EXYNOS4_PA_SYSMMU_MFC_L + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[29] = {
-		.start	= IRQ_SYSMMU_MFC_M0_0,
-		.end	= IRQ_SYSMMU_MFC_M0_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-	[30] = {
-		.start	= EXYNOS4_PA_SYSMMU_MFC_R,
-		.end	= EXYNOS4_PA_SYSMMU_MFC_R + SZ_64K - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[31] = {
-		.start	= IRQ_SYSMMU_MFC_M1_0,
-		.end	= IRQ_SYSMMU_MFC_M1_0,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-struct platform_device exynos4_device_sysmmu = {
-	.name		= "s5p-sysmmu",
-	.id		= 32,
-	.num_resources	= ARRAY_SIZE(exynos4_sysmmu_resource),
-	.resource	= exynos4_sysmmu_resource,
-};
-EXPORT_SYMBOL(exynos4_device_sysmmu);
-
-static struct clk *sysmmu_clk[S5P_SYSMMU_TOTAL_IPNUM];
-void sysmmu_clk_init(struct device *dev, sysmmu_ips ips)
-{
-	sysmmu_clk[ips] = clk_get(dev, sysmmu_ips_name[ips]);
-	if (IS_ERR(sysmmu_clk[ips]))
-		sysmmu_clk[ips] = NULL;
-	else
-		clk_put(sysmmu_clk[ips]);
+#define SYSMMU_RESOURCE(ipname, base, irq) \
+static struct resource sysmmu_resource_##ipname[] =\
+{\
+	DEFINE_RES_MEM(EXYNOS_PA_SYSMMU(base), SZ_4K),\
+	DEFINE_RES_IRQ(IRQ_SYSMMU_##irq##_0)\
 }
 
-void sysmmu_clk_enable(sysmmu_ips ips)
-{
-	if (sysmmu_clk[ips])
-		clk_enable(sysmmu_clk[ips]);
+#define SYSMMU_PLATFORM_DEVICE(ipname, devid) \
+struct platform_device SYSMMU_PLATDEV(ipname) =\
+{\
+	.name		= SYSMMU_DEVNAME_BASE,\
+	.id		= devid,\
+	.num_resources	= ARRAY_SIZE(sysmmu_resource_##ipname),\
+	.resource	= sysmmu_resource_##ipname,\
+	.dev		= {\
+		.dma_mask		= &exynos_sysmmu_dma_mask,\
+		.coherent_dma_mask	= DMA_BIT_MASK(32),\
+	},\
 }
 
-void sysmmu_clk_disable(sysmmu_ips ips)
-{
-	if (sysmmu_clk[ips])
-		clk_disable(sysmmu_clk[ips]);
-}
+static u64 exynos_sysmmu_dma_mask = DMA_BIT_MASK(32);
+
+SYSMMU_RESOURCE(sss,	SSS,	SSS);
+SYSMMU_RESOURCE(jpeg,	JPEG,	JPEG);
+SYSMMU_RESOURCE(fimd1,	FIMD1,	LCD1_M1);
+SYSMMU_RESOURCE(2d,	G2D,	2D);
+SYSMMU_RESOURCE(rot,	ROTATOR, ROTATOR);
+SYSMMU_RESOURCE(mdma,	MDMA,	MDMA1);
+SYSMMU_RESOURCE(tv,	TV,	TV_M0);
+SYSMMU_RESOURCE(mfc_l,	MFC_L,	MFC_M1);
+SYSMMU_RESOURCE(mfc_r,	MFC_R,	MFC_M0);
+
+SYSMMU_PLATFORM_DEVICE(sss,	0);
+SYSMMU_PLATFORM_DEVICE(jpeg,	5);
+SYSMMU_PLATFORM_DEVICE(fimd1,	7);
+SYSMMU_PLATFORM_DEVICE(2d,	9);
+SYSMMU_PLATFORM_DEVICE(rot,	10);
+SYSMMU_PLATFORM_DEVICE(mdma,	11);
+SYSMMU_PLATFORM_DEVICE(tv,	12);
+SYSMMU_PLATFORM_DEVICE(mfc_l,	13);
+SYSMMU_PLATFORM_DEVICE(mfc_r,	14);
+
+#ifdef CONFIG_ARCH_EXYNOS4
+SYSMMU_RESOURCE(fimc0,	FIMC0,	FIMC0);
+SYSMMU_RESOURCE(fimc1,	FIMC1,	FIMC1);
+SYSMMU_RESOURCE(fimc2,	FIMC2,	FIMC2);
+SYSMMU_RESOURCE(fimc3,	FIMC3,	FIMC3);
+SYSMMU_RESOURCE(fimd0,	FIMD0,	LCD0_M0);
+SYSMMU_RESOURCE(pcie,	PCIe,	PCIE);
+
+SYSMMU_PLATFORM_DEVICE(fimc0,	1);
+SYSMMU_PLATFORM_DEVICE(fimc1,	2);
+SYSMMU_PLATFORM_DEVICE(fimc2,	3);
+SYSMMU_PLATFORM_DEVICE(fimc3,	4);
+SYSMMU_PLATFORM_DEVICE(fimd0,	6);
+SYSMMU_PLATFORM_DEVICE(pcie,	8);
+#endif
diff --git a/arch/arm/mach-exynos/include/mach/dev-sysmmu.h b/arch/arm/mach-exynos/include/mach/dev-sysmmu.h
new file mode 100644
index 0000000..957e215
--- /dev/null
+++ b/arch/arm/mach-exynos/include/mach/dev-sysmmu.h
@@ -0,0 +1,61 @@
+/* linux/arch/arm/mach-exynos/include/mach/dev-sysmmu.h
+ *
+ * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * EXYNOS - System MMU support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _ARM_MACH_EXYNOS_SYSMMU_H_
+#define _ARM_MACH_EXYNOS_SYSMMU_H_
+
+#define SYSMMU_DEVNAME_BASE "exynos-sysmmu"
+
+#ifdef CONFIG_EXYNOS4_DEV_SYSMMU
+#include <linux/device.h>
+
+#define SYSMMU_PLATDEV(ipname) exynos_device_sysmmu_##ipname
+
+#ifdef CONFIG_EXYNOS4_DEV_PD
+#define ASSIGN_SYSMMU_POWERDOMAIN(ipname, powerdomain) \
+		SYSMMU_PLATDEV(ipname).dev.parent = powerdomain
+#else
+#define ASSIGN_SYSMMU_POWERDOMAIN(ipname, powerdomain) do { } while (0)
+#endif
+
+extern struct platform_device SYSMMU_PLATDEV(sss);
+extern struct platform_device SYSMMU_PLATDEV(jpeg);
+extern struct platform_device SYSMMU_PLATDEV(fimd1);
+extern struct platform_device SYSMMU_PLATDEV(pcie);
+extern struct platform_device SYSMMU_PLATDEV(2d);
+extern struct platform_device SYSMMU_PLATDEV(rot);
+extern struct platform_device SYSMMU_PLATDEV(mdma);
+extern struct platform_device SYSMMU_PLATDEV(tv);
+extern struct platform_device SYSMMU_PLATDEV(mfc_l);
+extern struct platform_device SYSMMU_PLATDEV(mfc_r);
+
+#ifdef CONFIG_ARCH_EXYNOS4
+extern struct platform_device SYSMMU_PLATDEV(fimc0);
+extern struct platform_device SYSMMU_PLATDEV(fimc1);
+extern struct platform_device SYSMMU_PLATDEV(fimc2);
+extern struct platform_device SYSMMU_PLATDEV(fimc3);
+extern struct platform_device SYSMMU_PLATDEV(fimd0);
+#endif
+
+static inline void sysmmu_set_owner(struct device *sysmmu, struct device *owner)
+{
+	sysmmu->platform_data = owner;
+}
+
+#else /* !CONFIG_EXYNOS4_DEV_SYSMMU*/
+#define sysmmu_set_owner(sysmmu, owner) do { } while (0)
+#define ASSIGN_SYSMMU_POWERDOMAIN(ipname, powerdomain) do { } while (0)
+#endif
+
+#define SYSMMU_CLOCK_NAME(ipname, id) SYSMMU_DEVNAME_BASE "." #id
+
+#endif /* _ARM_MACH_EXYNOS_SYSMMU_H_ */
diff --git a/arch/arm/mach-exynos/include/mach/exynos4-clock.h b/arch/arm/mach-exynos/include/mach/exynos4-clock.h
index a07fcbf..d276912 100644
--- a/arch/arm/mach-exynos/include/mach/exynos4-clock.h
+++ b/arch/arm/mach-exynos/include/mach/exynos4-clock.h
@@ -39,5 +39,6 @@ extern struct clksrc_sources clkset_group;
 extern int exynos4_clksrc_mask_fsys_ctrl(struct clk *clk, int enable);
 extern int exynos4_clk_ip_fsys_ctrl(struct clk *clk, int enable);
 extern int exynos4_clk_ip_lcd1_ctrl(struct clk *clk, int enable);
+extern int exynos4_clk_ip_image_ctrl(struct clk *clk, int enable);
 
 #endif /* __ASM_ARCH_CLOCK_H */
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 058541d..45d1ab9 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -71,7 +71,6 @@
 #define EXYNOS4_PA_PDMA0		0x12680000
 #define EXYNOS4_PA_PDMA1		0x12690000
 
-#define EXYNOS4_PA_SYSMMU_MDMA		0x10A40000
 #define EXYNOS4_PA_SYSMMU_SSS		0x10A50000
 #define EXYNOS4_PA_SYSMMU_FIMC0		0x11A20000
 #define EXYNOS4_PA_SYSMMU_FIMC1		0x11A30000
@@ -83,7 +82,7 @@
 #define EXYNOS4_PA_SYSMMU_PCIe		0x12620000
 #define EXYNOS4_PA_SYSMMU_G2D		0x12A20000
 #define EXYNOS4_PA_SYSMMU_ROTATOR	0x12A30000
-#define EXYNOS4_PA_SYSMMU_MDMA2		0x12A40000
+#define EXYNOS4_PA_SYSMMU_MDMA		0x12A40000
 #define EXYNOS4_PA_SYSMMU_TV		0x12E20000
 #define EXYNOS4_PA_SYSMMU_MFC_L		0x13620000
 #define EXYNOS4_PA_SYSMMU_MFC_R		0x13630000
diff --git a/arch/arm/mach-exynos/include/mach/regs-sysmmu.h b/arch/arm/mach-exynos/include/mach/regs-sysmmu.h
index 68ff6ad..786eac9 100644
--- a/arch/arm/mach-exynos/include/mach/regs-sysmmu.h
+++ b/arch/arm/mach-exynos/include/mach/regs-sysmmu.h
@@ -1,9 +1,9 @@
-/* linux/arch/arm/mach-exynos4/include/mach/regs-sysmmu.h
+/* linux/arch/arm/mach-exynos/include/mach/regs-sysmmu.h
  *
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * EXYNOS4 - System MMU register
+ * EXYNOS - System MMU register
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -13,16 +13,16 @@
 #ifndef __ASM_ARCH_REGS_SYSMMU_H
 #define __ASM_ARCH_REGS_SYSMMU_H __FILE__
 
-#define S5P_MMU_CTRL			0x000
-#define S5P_MMU_CFG			0x004
-#define S5P_MMU_STATUS			0x008
-#define S5P_MMU_FLUSH			0x00C
-#define S5P_PT_BASE_ADDR		0x014
-#define S5P_INT_STATUS			0x018
-#define S5P_INT_CLEAR			0x01C
-#define S5P_PAGE_FAULT_ADDR		0x024
-#define S5P_AW_FAULT_ADDR		0x028
-#define S5P_AR_FAULT_ADDR		0x02C
-#define S5P_DEFAULT_SLAVE_ADDR		0x030
+#define EXYNOS_MMU_CTRL			0x000
+#define EXYNOS_MMU_CFG			0x004
+#define EXYNOS_MMU_STATUS		0x008
+#define EXYNOS_MMU_FLUSH		0x00C
+#define EXYNOS_PT_BASE_ADDR		0x014
+#define EXYNOS_INT_STATUS		0x018
+#define EXYNOS_INT_CLEAR		0x01C
+#define EXYNOS_PAGE_FAULT_ADDR		0x024
+#define EXYNOS_AW_FAULT_ADDR		0x028
+#define EXYNOS_AR_FAULT_ADDR		0x02C
+#define EXYNOS_DEFAULT_SLAVE_ADDR	0x030
 
 #endif /* __ASM_ARCH_REGS_SYSMMU_H */
diff --git a/arch/arm/mach-exynos/include/mach/sysmmu.h b/arch/arm/mach-exynos/include/mach/sysmmu.h
deleted file mode 100644
index 6a5fbb5..0000000
--- a/arch/arm/mach-exynos/include/mach/sysmmu.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/* linux/arch/arm/mach-exynos4/include/mach/sysmmu.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * Samsung sysmmu driver for EXYNOS4
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARM_ARCH_SYSMMU_H
-#define __ASM_ARM_ARCH_SYSMMU_H __FILE__
-
-enum exynos4_sysmmu_ips {
-	SYSMMU_MDMA,
-	SYSMMU_SSS,
-	SYSMMU_FIMC0,
-	SYSMMU_FIMC1,
-	SYSMMU_FIMC2,
-	SYSMMU_FIMC3,
-	SYSMMU_JPEG,
-	SYSMMU_FIMD0,
-	SYSMMU_FIMD1,
-	SYSMMU_PCIe,
-	SYSMMU_G2D,
-	SYSMMU_ROTATOR,
-	SYSMMU_MDMA2,
-	SYSMMU_TV,
-	SYSMMU_MFC_L,
-	SYSMMU_MFC_R,
-	EXYNOS4_SYSMMU_TOTAL_IPNUM,
-};
-
-#define S5P_SYSMMU_TOTAL_IPNUM		EXYNOS4_SYSMMU_TOTAL_IPNUM
-
-extern const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM];
-
-typedef enum exynos4_sysmmu_ips sysmmu_ips;
-
-void sysmmu_clk_init(struct device *dev, sysmmu_ips ips);
-void sysmmu_clk_enable(sysmmu_ips ips);
-void sysmmu_clk_disable(sysmmu_ips ips);
-
-#endif /* __ASM_ARM_ARCH_SYSMMU_H */
diff --git a/arch/arm/mach-exynos/mach-armlex4210.c b/arch/arm/mach-exynos/mach-armlex4210.c
index f0ca6c1..1aee61c 100644
--- a/arch/arm/mach-exynos/mach-armlex4210.c
+++ b/arch/arm/mach-exynos/mach-armlex4210.c
@@ -155,7 +155,6 @@ static struct platform_device *armlex4210_devices[] __initdata = {
 	&s3c_device_hsmmc3,
 	&s3c_device_rtc,
 	&s3c_device_wdt,
-	&exynos4_device_sysmmu,
 	&samsung_asoc_dma,
 	&armlex4210_smsc911x,
 	&exynos4_device_ahci,
diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index 236bbe1..5e19e6d 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -53,6 +53,7 @@
 #include <plat/mipi_csis.h>
 
 #include <mach/map.h>
+#include <mach/dev-sysmmu.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define NURI_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -1279,6 +1280,21 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&nuri_max8903_device,
 	&cam_vdda_fixed_rdev,
 	&cam_8m_12v_fixed_rdev,
+	&SYSMMU_PLATDEV(sss),
+	&SYSMMU_PLATDEV(jpeg),
+	&SYSMMU_PLATDEV(fimd1),
+	&SYSMMU_PLATDEV(2d),
+	&SYSMMU_PLATDEV(rot),
+	&SYSMMU_PLATDEV(mdma),
+	&SYSMMU_PLATDEV(tv),
+	&SYSMMU_PLATDEV(mfc_l),
+	&SYSMMU_PLATDEV(mfc_r),
+	&SYSMMU_PLATDEV(fimc0),
+	&SYSMMU_PLATDEV(fimc1),
+	&SYSMMU_PLATDEV(fimc2),
+	&SYSMMU_PLATDEV(fimc3),
+	&SYSMMU_PLATDEV(fimd0),
+	&SYSMMU_PLATDEV(pcie),
 };
 
 static void __init nuri_map_io(void)
@@ -1293,6 +1309,28 @@ static void __init nuri_reserve(void)
 	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
 }
 
+static void __init sysmmu_init(void)
+{
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc0, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc1, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc2, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc3, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(jpeg, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_l, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_r, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimd0, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(rot, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mdma, &exynos4_device_pd[PD_LCD0].dev);
+
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc0).dev, &s5p_device_fimc0.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc1).dev, &s5p_device_fimc1.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc2).dev, &s5p_device_fimc2.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc3).dev, &s5p_device_fimc3.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_l).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_r).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimd0).dev, &s5p_device_fimd0.dev);
+}
+
 static void __init nuri_machine_init(void)
 {
 	nuri_sdhci_init();
@@ -1316,6 +1354,8 @@ static void __init nuri_machine_init(void)
 	nuri_ehci_init();
 	clk_xusbxti.rate = 24000000;
 
+	sysmmu_init();
+
 	/* Last */
 	platform_add_devices(nuri_devices, ARRAY_SIZE(nuri_devices));
 	s5p_device_mfc.dev.parent = &exynos4_device_pd[PD_MFC].dev;
diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index f56d027..d887b66 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -43,6 +43,7 @@
 #include <plat/mfc.h>
 
 #include <mach/map.h>
+#include <mach/dev-sysmmu.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define ORIGEN_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -637,6 +638,21 @@ static struct platform_device *origen_devices[] __initdata = {
 	&origen_device_gpiokeys,
 	&origen_lcd_hv070wsa,
 	&origen_device_bluetooth,
+	&SYSMMU_PLATDEV(sss),
+	&SYSMMU_PLATDEV(jpeg),
+	&SYSMMU_PLATDEV(fimd1),
+	&SYSMMU_PLATDEV(2d),
+	&SYSMMU_PLATDEV(rot),
+	&SYSMMU_PLATDEV(mdma),
+	&SYSMMU_PLATDEV(tv),
+	&SYSMMU_PLATDEV(mfc_l),
+	&SYSMMU_PLATDEV(mfc_r),
+	&SYSMMU_PLATDEV(fimc0),
+	&SYSMMU_PLATDEV(fimc1),
+	&SYSMMU_PLATDEV(fimc2),
+	&SYSMMU_PLATDEV(fimc3),
+	&SYSMMU_PLATDEV(fimd0),
+	&SYSMMU_PLATDEV(pcie),
 };
 
 /* LCD Backlight data */
@@ -687,6 +703,30 @@ static void __init origen_reserve(void)
 	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
 }
 
+static void __init sysmmu_init(void)
+{
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc0, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc1, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc2, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc3, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(jpeg, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_l, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_r, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimd0, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(rot, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mdma, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(tv, &exynos4_device_pd[PD_TV].dev);
+
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc0).dev, &s5p_device_fimc0.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc1).dev, &s5p_device_fimc1.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc2).dev, &s5p_device_fimc2.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc3).dev, &s5p_device_fimc3.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_l).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_r).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimd0).dev, &s5p_device_fimd0.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(tv).dev, &s5p_device_mixer.dev);
+}
+
 static void __init origen_machine_init(void)
 {
 	origen_power_init();
@@ -709,6 +749,8 @@ static void __init origen_machine_init(void)
 
 	s5p_fimd0_set_platdata(&origen_lcd_pdata);
 
+	sysmmu_init();
+
 	platform_add_devices(origen_devices, ARRAY_SIZE(origen_devices));
 
 	s5p_device_fimd0.dev.parent = &exynos4_device_pd[PD_LCD0].dev;
diff --git a/arch/arm/mach-exynos/mach-smdk4x12.c b/arch/arm/mach-exynos/mach-smdk4x12.c
index fcf2e0e..35070ff 100644
--- a/arch/arm/mach-exynos/mach-smdk4x12.c
+++ b/arch/arm/mach-exynos/mach-smdk4x12.c
@@ -254,6 +254,13 @@ static void __init smdk4x12_map_io(void)
 	s3c24xx_init_uarts(smdk4x12_uartcfgs, ARRAY_SIZE(smdk4x12_uartcfgs));
 }
 
+static void __init sysmmu_init(void)
+{
+	/* No device is registered yet.
+	 * See mach-smdkv310.c to see what should be here.
+	 */
+}
+
 static void __init smdk4x12_machine_init(void)
 {
 	s3c_i2c0_set_platdata(NULL);
@@ -279,6 +286,8 @@ static void __init smdk4x12_machine_init(void)
 	s3c_sdhci2_set_platdata(&smdk4x12_hsmmc2_pdata);
 	s3c_sdhci3_set_platdata(&smdk4x12_hsmmc3_pdata);
 
+	sysmmu_init();
+
 	platform_add_devices(smdk4x12_devices, ARRAY_SIZE(smdk4x12_devices));
 }
 
diff --git a/arch/arm/mach-exynos/mach-smdkv310.c b/arch/arm/mach-exynos/mach-smdkv310.c
index cec2afa..f81886b 100644
--- a/arch/arm/mach-exynos/mach-smdkv310.c
+++ b/arch/arm/mach-exynos/mach-smdkv310.c
@@ -42,6 +42,7 @@
 #include <plat/clock.h>
 
 #include <mach/map.h>
+#include <mach/dev-sysmmu.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define SMDKV310_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -273,7 +274,21 @@ static struct platform_device *smdkv310_devices[] __initdata = {
 	&exynos4_device_pd[PD_TV],
 	&exynos4_device_pd[PD_GPS],
 	&exynos4_device_spdif,
-	&exynos4_device_sysmmu,
+	&SYSMMU_PLATDEV(sss),
+	&SYSMMU_PLATDEV(jpeg),
+	&SYSMMU_PLATDEV(fimd1),
+	&SYSMMU_PLATDEV(2d),
+	&SYSMMU_PLATDEV(rot),
+	&SYSMMU_PLATDEV(mdma),
+	&SYSMMU_PLATDEV(tv),
+	&SYSMMU_PLATDEV(mfc_l),
+	&SYSMMU_PLATDEV(mfc_r),
+	&SYSMMU_PLATDEV(fimc0),
+	&SYSMMU_PLATDEV(fimc1),
+	&SYSMMU_PLATDEV(fimc2),
+	&SYSMMU_PLATDEV(fimc3),
+	&SYSMMU_PLATDEV(fimd0),
+	&SYSMMU_PLATDEV(pcie),
 	&samsung_asoc_dma,
 	&samsung_asoc_idma,
 	&s5p_device_fimd0,
@@ -342,6 +357,30 @@ static void __init smdkv310_reserve(void)
 	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
 }
 
+static void __init sysmmu_init(void)
+{
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc0, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc1, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc2, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc3, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(jpeg, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_l, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_r, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimd0, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(rot, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mdma, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(tv, &exynos4_device_pd[PD_TV].dev);
+
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc0).dev, &s5p_device_fimc0.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc1).dev, &s5p_device_fimc1.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc2).dev, &s5p_device_fimc2.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc3).dev, &s5p_device_fimc3.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_l).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_r).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimd0).dev, &s5p_device_fimd0.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(tv).dev, &s5p_device_mixer.dev);
+}
+
 static void __init smdkv310_machine_init(void)
 {
 	s3c_i2c1_set_platdata(NULL);
@@ -365,6 +404,8 @@ static void __init smdkv310_machine_init(void)
 	smdkv310_ehci_init();
 	clk_xusbxti.rate = 24000000;
 
+	sysmmu_init();
+
 	platform_add_devices(smdkv310_devices, ARRAY_SIZE(smdkv310_devices));
 	s5p_device_mfc.dev.parent = &exynos4_device_pd[PD_MFC].dev;
 }
diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index a2a177f..b30be39 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -42,6 +42,7 @@
 #include <plat/mipi_csis.h>
 
 #include <mach/map.h>
+#include <mach/dev-sysmmu.h>
 
 #include <media/v4l2-mediabus.h>
 #include <media/s5p_fimc.h>
@@ -988,6 +989,21 @@ static struct platform_device *universal_devices[] __initdata = {
 	&cam_i_core_fixed_reg_dev,
 	&cam_s_if_fixed_reg_dev,
 	&s5p_device_fimc_md,
+	&SYSMMU_PLATDEV(sss),
+	&SYSMMU_PLATDEV(jpeg),
+	&SYSMMU_PLATDEV(fimd1),
+	&SYSMMU_PLATDEV(2d),
+	&SYSMMU_PLATDEV(rot),
+	&SYSMMU_PLATDEV(mdma),
+	&SYSMMU_PLATDEV(tv),
+	&SYSMMU_PLATDEV(mfc_l),
+	&SYSMMU_PLATDEV(mfc_r),
+	&SYSMMU_PLATDEV(fimc0),
+	&SYSMMU_PLATDEV(fimc1),
+	&SYSMMU_PLATDEV(fimc2),
+	&SYSMMU_PLATDEV(fimc3),
+	&SYSMMU_PLATDEV(fimd0),
+	&SYSMMU_PLATDEV(pcie),
 };
 
 static void __init universal_map_io(void)
@@ -1016,6 +1032,30 @@ static void __init universal_reserve(void)
 	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
 }
 
+static void __init sysmmu_init(void)
+{
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc0, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc1, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc2, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimc3, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(jpeg, &exynos4_device_pd[PD_CAM].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_l, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc_r, &exynos4_device_pd[PD_MFC].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(fimd0, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(rot, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(mdma, &exynos4_device_pd[PD_LCD0].dev);
+	ASSIGN_SYSMMU_POWERDOMAIN(tv, &exynos4_device_pd[PD_TV].dev);
+
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc0).dev, &s5p_device_fimc0.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc1).dev, &s5p_device_fimc1.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc2).dev, &s5p_device_fimc2.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimc3).dev, &s5p_device_fimc3.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_l).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_r).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(fimd0).dev, &s5p_device_fimd0.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(tv).dev, &s5p_device_mixer.dev);
+}
+
 static void __init universal_machine_init(void)
 {
 	universal_sdhci_init();
@@ -1040,6 +1080,8 @@ static void __init universal_machine_init(void)
 
 	universal_camera_init();
 
+	sysmmu_init();
+
 	/* Last */
 	platform_add_devices(universal_devices, ARRAY_SIZE(universal_devices));
 
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index ab633c9..57c2636 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -134,7 +134,6 @@ extern struct platform_device exynos4_device_pcm1;
 extern struct platform_device exynos4_device_pcm2;
 extern struct platform_device exynos4_device_pd[];
 extern struct platform_device exynos4_device_spdif;
-extern struct platform_device exynos4_device_sysmmu;
 
 extern struct platform_device samsung_asoc_dma;
 extern struct platform_device samsung_asoc_idma;
-- 
1.7.1

