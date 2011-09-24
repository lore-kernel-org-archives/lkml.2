Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1I0Lrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 07:47:37 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:40438 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab1I0LnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 07:43:18 -0400
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Joerg Roedel <joro@8bytes.org>, Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        YoungLak Kim <younglak1004.kim@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, KyongHo Cho <pullip.cho@samsung.com>
Subject: [PATCH 1/4] ARM: EXYNOS4: Change System MMU device definition
Date: Sat, 24 Sep 2011 11:02:47 +0900
Message-Id: <1316829770-21949-2-git-send-email-pullip.cho@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1316829770-21949-1-git-send-email-pullip.cho@samsung.com>
References: <1316829770-21949-1-git-send-email-pullip.cho@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains a lot of changes of System MMU device definition.

1. Removed sysmmu_ips enumeration that are definitions of ID of System MMU
   Instead, a System MMU device descriptor must be bound with a device
   descriptor that needs System MMU in machine initialization.
2. Removed MDMA that is included in LCD0 block because it is not used
   anymore. Use MDMA in TOP block.
3. Changed System MMU definitions of platform device. It is not an array
   anymore.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos4/Kconfig               |    2 -
 arch/arm/mach-exynos4/clock.c               |   43 +++--
 arch/arm/mach-exynos4/dev-sysmmu.c          |  281 +++++++--------------------
 arch/arm/mach-exynos4/include/mach/irqs.h   |    1 -
 arch/arm/mach-exynos4/include/mach/map.h    |    1 -
 arch/arm/mach-exynos4/include/mach/sysmmu.h |   96 ++++++----
 arch/arm/mach-exynos4/mach-armlex4210.c     |   24 +++-
 arch/arm/mach-exynos4/mach-smdkv310.c       |   28 +++-
 8 files changed, 210 insertions(+), 266 deletions(-)

diff --git a/arch/arm/mach-exynos4/Kconfig b/arch/arm/mach-exynos4/Kconfig
index 3b594fe..e9ccf5e 100644
--- a/arch/arm/mach-exynos4/Kconfig
+++ b/arch/arm/mach-exynos4/Kconfig
@@ -141,7 +141,6 @@ config MACH_SMDKV310
 	select SAMSUNG_DEV_KEYPAD
 	select EXYNOS4_DEV_PD
 	select SAMSUNG_DEV_PWM
-	select EXYNOS4_DEV_SYSMMU
 	select EXYNOS4_SETUP_FIMD0
 	select EXYNOS4_SETUP_I2C1
 	select EXYNOS4_SETUP_KEYPAD
@@ -158,7 +157,6 @@ config MACH_ARMLEX4210
 	select S3C_DEV_HSMMC2
 	select S3C_DEV_HSMMC3
 	select EXYNOS4_DEV_AHCI
-	select EXYNOS4_DEV_SYSMMU
 	select EXYNOS4_SETUP_SDHCI
 	help
 	  Machine support for Samsung ARMLEX4210 based on EXYNOS4210
diff --git a/arch/arm/mach-exynos4/clock.c b/arch/arm/mach-exynos4/clock.c
index da9567a..b907d5f 100644
--- a/arch/arm/mach-exynos4/clock.c
+++ b/arch/arm/mach-exynos4/clock.c
@@ -691,59 +691,68 @@ static struct clk init_clocks_off[] = {
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
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(fimd1, 7),
 		.enable		= exynos4_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_PCIe",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(pcie, 8),
 		.enable		= exynos4_clk_ip_fsys_ctrl,
 		.ctrlbit	= (1 << 18),
 	}, {
-		.name		= "SYSMMU_G2D",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(g2d, 9),
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 3),
 	}, {
-		.name		= "SYSMMU_ROTATOR",
+		.name		= "sysmmu",
+		.devname	= SYSMMU_CLOCK_NAME(rot, 10),
 		.enable		= exynos4_clk_ip_image_ctrl,
 		.ctrlbit	= (1 << 4),
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
 	}
diff --git a/arch/arm/mach-exynos4/dev-sysmmu.c b/arch/arm/mach-exynos4/dev-sysmmu.c
index 3b7cae0..f7cb163 100644
--- a/arch/arm/mach-exynos4/dev-sysmmu.c
+++ b/arch/arm/mach-exynos4/dev-sysmmu.c
@@ -1,6 +1,6 @@
 /* linux/arch/arm/mach-exynos4/dev-sysmmu.c
  *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * EXYNOS4 - System MMU support
@@ -12,221 +12,86 @@
 
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/slab.h>
+
+#include <plat/s5p-clock.h>
 
 #include <mach/map.h>
 #include <mach/irqs.h>
 #include <mach/sysmmu.h>
-#include <plat/s5p-clock.h>
 
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
+#define SYSMMU_RESOURCE(ipname, base, irq) \
+static struct resource sysmmu_resource_##ipname[] =\
+{\
+	{\
+		.start	= EXYNOS4_PA_SYSMMU_##base,\
+		.end	= EXYNOS4_PA_SYSMMU_##base + SZ_4K - 1,\
+		.flags	= IORESOURCE_MEM,\
+	}, {\
+		.start	= IRQ_SYSMMU_##irq##_0,\
+		.end	= IRQ_SYSMMU_##irq##_0,\
+		.flags	= IORESOURCE_IRQ,\
+	},\
+}
 
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
+}
 
-struct platform_device exynos4_device_sysmmu = {
-	.name		= "s5p-sysmmu",
-	.id		= 32,
-	.num_resources	= ARRAY_SIZE(exynos4_sysmmu_resource),
-	.resource	= exynos4_sysmmu_resource,
-};
-EXPORT_SYMBOL(exynos4_device_sysmmu);
+static u64 exynos_sysmmu_dma_mask = DMA_BIT_MASK(32);
 
-static struct clk *sysmmu_clk[S5P_SYSMMU_TOTAL_IPNUM];
-void sysmmu_clk_init(struct device *dev, sysmmu_ips ips)
-{
-	sysmmu_clk[ips] = clk_get(dev, sysmmu_ips_name[ips]);
-	if (IS_ERR(sysmmu_clk[ips]))
-		sysmmu_clk[ips] = NULL;
-	else
-		clk_put(sysmmu_clk[ips]);
-}
+SYSMMU_RESOURCE(sss,	SSS,	SSS);
+SYSMMU_RESOURCE(fimc0,	FIMC0,	FIMC0);
+SYSMMU_RESOURCE(fimc1,	FIMC1,	FIMC1);
+SYSMMU_RESOURCE(fimc2,	FIMC2,	FIMC2);
+SYSMMU_RESOURCE(fimc3,	FIMC3,	FIMC3);
+SYSMMU_RESOURCE(jpeg,	JPEG,	JPEG);
+SYSMMU_RESOURCE(fimd0,	FIMD0,	LCD0_M0);
+SYSMMU_RESOURCE(fimd1,	FIMD1,	LCD1_M1);
+SYSMMU_RESOURCE(pcie,	PCIe,	PCIE);
+SYSMMU_RESOURCE(g2d,	G2D,	2D);
+SYSMMU_RESOURCE(rot,	ROTATOR, ROTATOR);
+SYSMMU_RESOURCE(mdma,	MDMA2,	MDMA1);
+SYSMMU_RESOURCE(tv,	TV,	TV_M0);
+SYSMMU_RESOURCE(mfc_l,	MFC_L,	MFC_M0);
+SYSMMU_RESOURCE(mfc_r,	MFC_R,	MFC_M1);
 
-void sysmmu_clk_enable(sysmmu_ips ips)
-{
-	if (sysmmu_clk[ips])
-		clk_enable(sysmmu_clk[ips]);
-}
+SYSMMU_PLATFORM_DEVICE(sss,	0);
+SYSMMU_PLATFORM_DEVICE(fimc0,	1);
+SYSMMU_PLATFORM_DEVICE(fimc1,	2);
+SYSMMU_PLATFORM_DEVICE(fimc2,	3);
+SYSMMU_PLATFORM_DEVICE(fimc3,	4);
+SYSMMU_PLATFORM_DEVICE(jpeg,	5);
+SYSMMU_PLATFORM_DEVICE(fimd0,	6);
+SYSMMU_PLATFORM_DEVICE(fimd1,	7);
+SYSMMU_PLATFORM_DEVICE(pcie,	8);
+SYSMMU_PLATFORM_DEVICE(g2d,	9);
+SYSMMU_PLATFORM_DEVICE(rot,	10);
+SYSMMU_PLATFORM_DEVICE(mdma,	11);
+SYSMMU_PLATFORM_DEVICE(tv,	12);
+SYSMMU_PLATFORM_DEVICE(mfc_l,	13);
+SYSMMU_PLATFORM_DEVICE(mfc_r,	14);
 
-void sysmmu_clk_disable(sysmmu_ips ips)
+void sysmmu_set_owner(struct device *sysmmu, struct device *owner)
 {
-	if (sysmmu_clk[ips])
-		clk_disable(sysmmu_clk[ips]);
-}
+	struct sysmmu_platdata *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data) {
+		data->owner = owner;
+		data->dev = sysmmu;
+
+		INIT_LIST_HEAD(&data->node);
+	}
+
+	sysmmu->platform_data = data;
+}
diff --git a/arch/arm/mach-exynos4/include/mach/irqs.h b/arch/arm/mach-exynos4/include/mach/irqs.h
index 62093b9..9eeb9a6 100644
--- a/arch/arm/mach-exynos4/include/mach/irqs.h
+++ b/arch/arm/mach-exynos4/include/mach/irqs.h
@@ -123,7 +123,6 @@
 #define COMBINER_GROUP(x)	((x) * MAX_IRQ_IN_COMBINER + IRQ_SPI(128))
 #define COMBINER_IRQ(x, y)	(COMBINER_GROUP(x) + y)
 
-#define IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(4, 0)
 #define IRQ_SYSMMU_SSS_0	COMBINER_IRQ(4, 1)
 #define IRQ_SYSMMU_FIMC0_0	COMBINER_IRQ(4, 2)
 #define IRQ_SYSMMU_FIMC1_0	COMBINER_IRQ(4, 3)
diff --git a/arch/arm/mach-exynos4/include/mach/map.h b/arch/arm/mach-exynos4/include/mach/map.h
index 1bea7d1..114d8b8 100644
--- a/arch/arm/mach-exynos4/include/mach/map.h
+++ b/arch/arm/mach-exynos4/include/mach/map.h
@@ -72,7 +72,6 @@
 #define EXYNOS4_PA_PDMA0		0x12680000
 #define EXYNOS4_PA_PDMA1		0x12690000
 
-#define EXYNOS4_PA_SYSMMU_MDMA		0x10A40000
 #define EXYNOS4_PA_SYSMMU_SSS		0x10A50000
 #define EXYNOS4_PA_SYSMMU_FIMC0		0x11A20000
 #define EXYNOS4_PA_SYSMMU_FIMC1		0x11A30000
diff --git a/arch/arm/mach-exynos4/include/mach/sysmmu.h b/arch/arm/mach-exynos4/include/mach/sysmmu.h
index 6a5fbb5..7a5d7d9 100644
--- a/arch/arm/mach-exynos4/include/mach/sysmmu.h
+++ b/arch/arm/mach-exynos4/include/mach/sysmmu.h
@@ -3,44 +3,70 @@
  * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Samsung sysmmu driver for EXYNOS4
+ * Exynos - System MMU Support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
 */
 
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
+#ifndef _ARM_MACH_EXYNOS_SYSMMU_H_
+#define _ARM_MACH_EXYNOS_SYSMMU_H_
+
+#include <linux/atomic.h>
+
+struct clk;
+struct device;
+struct iommu_domain;
+
+struct sysmmu_platdata {
+	struct list_head node;
+	struct device *dev;
+	struct device *owner;
+	void __iomem *sfrbase;
+	struct clk *clk;
+	atomic_t activations;
+	struct iommu_domain *domain;
+};
+
+#define SYSMMU_DEVNAME_BASE "s5p-sysmmu"
+#define SYSMMU_CLOCK_NAME(ipname, id) SYSMMU_DEVNAME_BASE "." #id
+
+#ifdef CONFIG_EXYNOS4_DEV_SYSMMU
+
+#define SYSMMU_PLATDEV(ipname) exynos_device_sysmmu_##ipname
+
+#ifdef CONFIG_EXYNOS4_DEV_PD
+#define ASSIGN_SYSMMU_POWERDOMAIN(ipname, powerdomain) \
+		SYSMMU_PLATDEV(mfc_l).dev.parent = powerdomain
+#else
+#define ASSIGN_SYSMMU_POWERDOMAIN(ipname, powerdomain) do { } while (0)
+#endif
+
+extern struct platform_device SYSMMU_PLATDEV(sss);
+extern struct platform_device SYSMMU_PLATDEV(fimc0);
+extern struct platform_device SYSMMU_PLATDEV(fimc1);
+extern struct platform_device SYSMMU_PLATDEV(fimc2);
+extern struct platform_device SYSMMU_PLATDEV(fimc3);
+extern struct platform_device SYSMMU_PLATDEV(jpeg);
+extern struct platform_device SYSMMU_PLATDEV(fimd0);
+extern struct platform_device SYSMMU_PLATDEV(fimd1);
+extern struct platform_device SYSMMU_PLATDEV(pcie);
+extern struct platform_device SYSMMU_PLATDEV(g2d);
+extern struct platform_device SYSMMU_PLATDEV(rot);
+extern struct platform_device SYSMMU_PLATDEV(mdma);
+extern struct platform_device SYSMMU_PLATDEV(tv);
+extern struct platform_device SYSMMU_PLATDEV(mfc_l);
+extern struct platform_device SYSMMU_PLATDEV(mfc_r);
+extern struct platform_device SYSMMU_PLATDEV(g2d_acp);
+
+void sysmmu_set_owner(struct device *sysmmu, struct device *owner);
+
+#else /* CONFIG_EXYNOS4_DEV_SYSMMU */
+
+#define sysmmu_set_owner(sysmmu, owner) do { } while (0)
+#define ASSIGN_SYSMMU_POWERDOMAIN(ipname, powerdomain) do { } while (0)
+
+#endif /* CONFIG_EXYNOS4_DEV_SYSMMU */
+
+#endif /* _ARM_MACH_EXYNOS_SYSMMU_H_ */
diff --git a/arch/arm/mach-exynos4/mach-armlex4210.c b/arch/arm/mach-exynos4/mach-armlex4210.c
index b482c62..d7d2ff5 100644
--- a/arch/arm/mach-exynos4/mach-armlex4210.c
+++ b/arch/arm/mach-exynos4/mach-armlex4210.c
@@ -155,7 +155,23 @@ static struct platform_device *armlex4210_devices[] __initdata = {
 	&s3c_device_hsmmc3,
 	&s3c_device_rtc,
 	&s3c_device_wdt,
-	&exynos4_device_sysmmu,
+#ifdef CONFIG_EXYNOS4_DEV_SYSMMU
+	&SYSMMU_PLATDEV(sss),
+	&SYSMMU_PLATDEV(fimc0),
+	&SYSMMU_PLATDEV(fimc1),
+	&SYSMMU_PLATDEV(fimc2),
+	&SYSMMU_PLATDEV(fimc3),
+	&SYSMMU_PLATDEV(jpeg),
+	&SYSMMU_PLATDEV(fimd0),
+	&SYSMMU_PLATDEV(fimd1),
+	&SYSMMU_PLATDEV(pcie),
+	&SYSMMU_PLATDEV(g2d),
+	&SYSMMU_PLATDEV(rot),
+	&SYSMMU_PLATDEV(mdma),
+	&SYSMMU_PLATDEV(tv),
+	&SYSMMU_PLATDEV(mfc_l),
+	&SYSMMU_PLATDEV(mfc_r),
+#endif
 	&samsung_asoc_dma,
 	&armlex4210_smsc911x,
 	&exynos4_device_ahci,
@@ -193,6 +209,10 @@ static void __init armlex4210_map_io(void)
 			   ARRAY_SIZE(armlex4210_uartcfgs));
 }
 
+static void __init sysmmu_init(void)
+{
+}
+
 static void __init armlex4210_machine_init(void)
 {
 	armlex4210_smsc911x_init();
@@ -201,6 +221,8 @@ static void __init armlex4210_machine_init(void)
 
 	armlex4210_wlan_init();
 
+	sysmmu_init();
+
 	platform_add_devices(armlex4210_devices,
 			     ARRAY_SIZE(armlex4210_devices));
 }
diff --git a/arch/arm/mach-exynos4/mach-smdkv310.c b/arch/arm/mach-exynos4/mach-smdkv310.c
index 57cf632..92b7ccd 100644
--- a/arch/arm/mach-exynos4/mach-smdkv310.c
+++ b/arch/arm/mach-exynos4/mach-smdkv310.c
@@ -40,6 +40,7 @@
 #include <plat/mfc.h>
 
 #include <mach/map.h>
+#include <mach/sysmmu.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define SMDKV310_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -255,7 +256,23 @@ static struct platform_device *smdkv310_devices[] __initdata = {
 	&exynos4_device_pd[PD_TV],
 	&exynos4_device_pd[PD_GPS],
 	&exynos4_device_spdif,
-	&exynos4_device_sysmmu,
+#ifdef CONFIG_S5P_SYSTEM_MMU
+	&SYSMMU_PLATDEV(sss),
+	&SYSMMU_PLATDEV(fimc0),
+	&SYSMMU_PLATDEV(fimc1),
+	&SYSMMU_PLATDEV(fimc2),
+	&SYSMMU_PLATDEV(fimc3),
+	&SYSMMU_PLATDEV(jpeg),
+	&SYSMMU_PLATDEV(fimd0),
+	&SYSMMU_PLATDEV(fimd1),
+	&SYSMMU_PLATDEV(pcie),
+	&SYSMMU_PLATDEV(g2d),
+	&SYSMMU_PLATDEV(rot),
+	&SYSMMU_PLATDEV(mdma),
+	&SYSMMU_PLATDEV(tv),
+	&SYSMMU_PLATDEV(mfc_l),
+	&SYSMMU_PLATDEV(mfc_r),
+#endif
 	&samsung_asoc_dma,
 	&samsung_asoc_idma,
 	&s5p_device_fimd0,
@@ -310,6 +327,13 @@ static void __init smdkv310_reserve(void)
 	s5p_mfc_reserve_mem(0x43000000, 8 << 20, 0x51000000, 8 << 20);
 }
 
+static void __init sysmmu_init(void)
+{
+	ASSIGN_SYSMMU_POWERDOMAIN(mfc, &exynos4_device_pd[PD_MFC].dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_l).dev, &s5p_device_mfc.dev);
+	sysmmu_set_owner(&SYSMMU_PLATDEV(mfc_r).dev, &s5p_device_mfc.dev);
+}
+
 static void __init smdkv310_machine_init(void)
 {
 	s3c_i2c1_set_platdata(NULL);
@@ -327,6 +351,8 @@ static void __init smdkv310_machine_init(void)
 	samsung_bl_set(&smdkv310_bl_gpio_info, &smdkv310_bl_data);
 	s5p_fimd0_set_platdata(&smdkv310_lcd0_pdata);
 
+	sysmmu_init();
+
 	platform_add_devices(smdkv310_devices, ARRAY_SIZE(smdkv310_devices));
 	s5p_device_mfc.dev.parent = &exynos4_device_pd[PD_MFC].dev;
 }
-- 
1.7.1

