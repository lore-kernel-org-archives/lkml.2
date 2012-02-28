Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2B1GhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 01:37:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25318 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2B1GhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 01:37:09 -0500
X-AuditID: cbfee61b-b7c62ae000000989-79-4f4c7613b36d
Reply-to: pullip.cho@samsung.com
From: KyongHo Cho <pullip.cho@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: "'Joerg Roedel'" <joro@8bytes.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        "'Marek Szyprowski'" <m.szyprowski@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>
Subject: [PATCH v9 1/2] ARM: EXYNOS: Change System MMU platform device
 definitions
Date: Tue, 28 Feb 2012 15:37:17 +0900
Organization: Samsung Electronics Co., Ltd
Message-id: <001901ccf5e3$6a363320$3ea29960$%cho@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczxzHiu6N/cWUD5RuOH+Au/hcxPGQEFQ9jA
X-Brightmail-Tracker: AAAAAA==
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

This patch also includes the following enhancements:
- A System MMU device becomes a child if its power domain device.
- clkdev

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
---
 arch/arm/mach-exynos/Kconfig                    |   11 +-
 arch/arm/mach-exynos/Makefile                   |    2 +-
 arch/arm/mach-exynos/clock-exynos4.c            |   79 ++--
 arch/arm/mach-exynos/clock-exynos4.h            |    2 +
 arch/arm/mach-exynos/clock-exynos4210.c         |   11 +
 arch/arm/mach-exynos/clock-exynos4212.c         |   28 ++-
 arch/arm/mach-exynos/clock-exynos5.c            |   90 +++++
 arch/arm/mach-exynos/dev-sysmmu.c               |  451 ++++++++++++-----------
 arch/arm/mach-exynos/include/mach/irqs.h        |  179 +++++-----
 arch/arm/mach-exynos/include/mach/map.h         |   38 ++
 arch/arm/mach-exynos/include/mach/regs-clock.h  |    5 +
 arch/arm/mach-exynos/include/mach/regs-sysmmu.h |   28 --
 arch/arm/mach-exynos/include/mach/sysmmu.h      |   84 +++--
 arch/arm/mach-exynos/mach-armlex4210.c          |    1 -
 arch/arm/mach-exynos/mach-smdkv310.c            |    1 -
 arch/arm/plat-s5p/sysmmu.c                      |   13 +-
 arch/arm/plat-samsung/include/plat/devs.h       |    1 -
 17 files changed, 618 insertions(+), 406 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/include/mach/regs-sysmmu.h

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 40ad6b4..f7eabaf 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -95,10 +95,10 @@ config EXYNOS4_DEV_PD
 	help
 	  Compile in platform device definitions for Power Domain
 
-config EXYNOS4_DEV_SYSMMU
+config EXYNOS_DEV_SYSMMU
 	bool
 	help
-	  Common setup code for SYSTEM MMU in EXYNOS4
+	  Common setup code for SYSTEM MMU in EXYNOS platforms
 
 config EXYNOS4_DEV_DWMCI
 	bool
@@ -212,9 +212,9 @@ config MACH_SMDKV310
 	select SAMSUNG_DEV_KEYPAD
 	select SAMSUNG_DEV_PWM
 	select EXYNOS_DEV_DMA
+	select EXYNOS_DEV_SYSMMU
 	select EXYNOS4_DEV_PD
 	select EXYNOS4_DEV_USB_OHCI
-	select EXYNOS4_DEV_SYSMMU
 	select EXYNOS4_SETUP_FIMD0
 	select EXYNOS4_SETUP_I2C1
 	select EXYNOS4_SETUP_KEYPAD
@@ -233,7 +233,6 @@ config MACH_ARMLEX4210
 	select S3C_DEV_HSMMC3
 	select EXYNOS_DEV_DMA
 	select EXYNOS4_DEV_AHCI
-	select EXYNOS4_DEV_SYSMMU
 	select EXYNOS4_SETUP_SDHCI
 	help
 	  Machine support for Samsung ARMLEX4210 based on EXYNOS4210
@@ -259,6 +258,7 @@ config MACH_UNIVERSAL_C210
 	select S5P_DEV_ONENAND
 	select S5P_DEV_TV
 	select EXYNOS_DEV_DMA
+	select EXYNOS_DEV_SYSMMU
 	select EXYNOS4_DEV_PD
 	select EXYNOS4_SETUP_FIMD0
 	select EXYNOS4_SETUP_I2C1
@@ -326,6 +326,7 @@ config MACH_ORIGEN
 	select SAMSUNG_DEV_BACKLIGHT
 	select SAMSUNG_DEV_PWM
 	select EXYNOS_DEV_DMA
+	select EXYNOS_DEV_SYSMMU
 	select EXYNOS4_DEV_PD
 	select EXYNOS4_DEV_USB_OHCI
 	select EXYNOS4_SETUP_FIMD0
@@ -350,6 +351,7 @@ config MACH_SMDK4212
 	select SAMSUNG_DEV_KEYPAD
 	select SAMSUNG_DEV_PWM
 	select EXYNOS_DEV_DMA
+	select EXYNOS_DEV_SYSMMU
 	select EXYNOS4_SETUP_I2C1
 	select EXYNOS4_SETUP_I2C3
 	select EXYNOS4_SETUP_I2C7
@@ -376,6 +378,7 @@ config MACH_SMDK5250
 	bool "SMDK5250"
 	select SOC_EXYNOS5250
 	select EXYNOS_DEV_DMA
+	select EXYNOS_DEV_SYSMMU
 	help
 	  Machine support for Samsung SMDK5250
 endif
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 08b4eb1..aac02a8 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -52,7 +52,7 @@ obj-y					+= dev-uart.o
 obj-$(CONFIG_ARCH_EXYNOS4)		+= dev-audio.o
 obj-$(CONFIG_EXYNOS4_DEV_AHCI)		+= dev-ahci.o
 obj-$(CONFIG_EXYNOS4_DEV_PD)		+= dev-pd.o
-obj-$(CONFIG_EXYNOS4_DEV_SYSMMU)	+= dev-sysmmu.o
+obj-$(CONFIG_EXYNOS_DEV_SYSMMU)		+= dev-sysmmu.o
 obj-$(CONFIG_EXYNOS4_DEV_DWMCI)		+= dev-dwmci.o
 obj-$(CONFIG_EXYNOS_DEV_DMA)		+= dma.o
 obj-$(CONFIG_EXYNOS4_DEV_USB_OHCI)	+= dev-ohci.o
diff --git a/arch/arm/mach-exynos/clock-exynos4.c b/arch/arm/mach-exynos/clock-exynos4.c
index 3bc95f0..f69f9f3 100644
--- a/arch/arm/mach-exynos/clock-exynos4.c
+++ b/arch/arm/mach-exynos/clock-exynos4.c
@@ -169,7 +169,7 @@ static int exynos4_clk_ip_tv_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_TV, clk, enable);
 }
 
-static int exynos4_clk_ip_image_ctrl(struct clk *clk, int enable)
+int exynos4_clk_ip_image_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_IMAGE, clk, enable);
 }
@@ -199,6 +199,11 @@ static int exynos4_clk_ip_perir_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_PERIR, clk, enable);
 }
 
+int exynos4_clk_ip_dmc_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_DMC, clk, enable);
+}
+
 static int exynos4_clk_hdmiphy_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(S5P_HDMI_PHY_CONTROL, clk, enable);
@@ -679,61 +684,55 @@ static struct clk exynos4_init_clocks_off[] = {
 		.enable		= exynos4_clk_ip_peril_ctrl,
 		.ctrlbit	= (1 << 14),
 	}, {
-		.name		= "SYSMMU_MDMA",
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
+		.enable		= exynos4_clk_ip_mfc_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_r, 1),
+		.enable		= exynos4_clk_ip_mfc_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(tv, 2),
+		.enable		= exynos4_clk_ip_tv_ctrl,
+		.ctrlbit	= (1 << 4),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(jpeg, 3),
+		.enable		= exynos4_clk_ip_cam_ctrl,
+		.ctrlbit	= (1 << 11),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(rot, 4),
 		.enable		= exynos4_clk_ip_image_ctrl,
-		.ctrlbit	= (1 << 5),
+		.ctrlbit	= (1 << 4),
 	}, {
-		.name		= "SYSMMU_FIMC0",
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc0, 5),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 7),
 	}, {
-		.name		= "SYSMMU_FIMC1",
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc1, 6),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 8),
 	}, {
-		.name		= "SYSMMU_FIMC2",
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc2, 7),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 9),
 	}, {
-		.name		= "SYSMMU_FIMC3",
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc3, 8),
 		.enable		= exynos4_clk_ip_cam_ctrl,
 		.ctrlbit	= (1 << 10),
 	}, {
-		.name		= "SYSMMU_JPEG",
-		.enable		= exynos4_clk_ip_cam_ctrl,
-		.ctrlbit	= (1 << 11),
-	}, {
-		.name		= "SYSMMU_FIMD0",
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(fimd0, 10),
 		.enable		= exynos4_clk_ip_lcd0_ctrl,
 		.ctrlbit	= (1 << 4),
-	}, {
-		.name		= "SYSMMU_FIMD1",
-		.enable		= exynos4_clk_ip_lcd1_ctrl,
-		.ctrlbit	= (1 << 4),
-	}, {
-		.name		= "SYSMMU_PCIe",
-		.enable		= exynos4_clk_ip_fsys_ctrl,
-		.ctrlbit	= (1 << 18),
-	}, {
-		.name		= "SYSMMU_G2D",
-		.enable		= exynos4_clk_ip_image_ctrl,
-		.ctrlbit	= (1 << 3),
-	}, {
-		.name		= "SYSMMU_ROTATOR",
-		.enable		= exynos4_clk_ip_image_ctrl,
-		.ctrlbit	= (1 << 4),
-	}, {
-		.name		= "SYSMMU_TV",
-		.enable		= exynos4_clk_ip_tv_ctrl,
-		.ctrlbit	= (1 << 4),
-	}, {
-		.name		= "SYSMMU_MFC_L",
-		.enable		= exynos4_clk_ip_mfc_ctrl,
-		.ctrlbit	= (1 << 1),
-	}, {
-		.name		= "SYSMMU_MFC_R",
-		.enable		= exynos4_clk_ip_mfc_ctrl,
-		.ctrlbit	= (1 << 2),
 	}
 };
 
diff --git a/arch/arm/mach-exynos/clock-exynos4.h b/arch/arm/mach-exynos/clock-exynos4.h
index 9d27a56..309cc71 100644
--- a/arch/arm/mach-exynos/clock-exynos4.h
+++ b/arch/arm/mach-exynos/clock-exynos4.h
@@ -28,5 +28,7 @@ extern struct clk *exynos4_clkset_group_list[];
 extern int exynos4_clksrc_mask_fsys_ctrl(struct clk *clk, int enable);
 extern int exynos4_clk_ip_fsys_ctrl(struct clk *clk, int enable);
 extern int exynos4_clk_ip_lcd1_ctrl(struct clk *clk, int enable);
+extern int exynos4_clk_ip_image_ctrl(struct clk *clk, int enable);
+extern int exynos4_clk_ip_dmc_ctrl(struct clk *clk, int enable);
 
 #endif /* __ASM_ARCH_CLOCK_H */
diff --git a/arch/arm/mach-exynos/clock-exynos4210.c b/arch/arm/mach-exynos/clock-exynos4210.c
index 8f2bed1..45c5b40 100644
--- a/arch/arm/mach-exynos/clock-exynos4210.c
+++ b/arch/arm/mach-exynos/clock-exynos4210.c
@@ -28,6 +28,7 @@
 #include <mach/hardware.h>
 #include <mach/map.h>
 #include <mach/regs-clock.h>
+#include <mach/sysmmu.h>
 
 #include "clock-exynos4.h"
 #include "common.h"
@@ -96,6 +97,16 @@ static struct clk init_clocks_off[] = {
 		.devname	= "exynos4-fb.1",
 		.enable		= exynos4_clk_ip_lcd1_ctrl,
 		.ctrlbit	= (1 << 0),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(2d, 14),
+		.enable		= exynos4_clk_ip_image_ctrl,
+		.ctrlbit	= (1 << 3),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(fimd1, 11),
+		.enable		= exynos4_clk_ip_lcd1_ctrl,
+		.ctrlbit	= (1 << 4),
 	},
 };
 
diff --git a/arch/arm/mach-exynos/clock-exynos4212.c b/arch/arm/mach-exynos/clock-exynos4212.c
index b2fe57c..a31a10b 100644
--- a/arch/arm/mach-exynos/clock-exynos4212.c
+++ b/arch/arm/mach-exynos/clock-exynos4212.c
@@ -28,6 +28,7 @@
 #include <mach/hardware.h>
 #include <mach/map.h>
 #include <mach/regs-clock.h>
+#include <mach/sysmmu.h>
 
 #include "clock-exynos4.h"
 #include "common.h"
@@ -41,6 +42,16 @@ static struct sleep_save exynos4212_clock_save[] = {
 };
 #endif
 
+static int exynos4212_clk_ip_isp0_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_ISP0, clk, enable);
+}
+
+static int exynos4212_clk_ip_isp1_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS4_CLKGATE_IP_ISP1, clk, enable);
+}
+
 static struct clk *clk_src_mpll_user_list[] = {
 	[0] = &clk_fin_mpll,
 	[1] = &exynos4_clk_mout_mpll.clk,
@@ -68,7 +79,22 @@ static struct clksrc_clk clksrcs[] = {
 };
 
 static struct clk init_clocks_off[] = {
-	/* nothing here yet */
+	{
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(2d, 14),
+		.enable		= exynos4_clk_ip_dmc_ctrl,
+		.ctrlbit	= (1 << 24),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.enable		= exynos4212_clk_ip_isp0_ctrl,
+		.ctrlbit	= (7 << 8),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME2,
+		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.enable		= exynos4212_clk_ip_isp1_ctrl,
+		.ctrlbit	= (1 << 4),
+	}
 };
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/arch/arm/mach-exynos/clock-exynos5.c b/arch/arm/mach-exynos/clock-exynos5.c
index d013982..3320ad1 100644
--- a/arch/arm/mach-exynos/clock-exynos5.c
+++ b/arch/arm/mach-exynos/clock-exynos5.c
@@ -82,6 +82,11 @@ static int exynos5_clksrc_mask_peric0_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(EXYNOS5_CLKSRC_MASK_PERIC0, clk, enable);
 }
 
+static int exynos5_clk_ip_acp_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_ACP, clk, enable);
+}
+
 static int exynos5_clk_ip_core_ctrl(struct clk *clk, int enable)
 {
 	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_CORE, clk, enable);
@@ -127,6 +132,21 @@ static int exynos5_clk_ip_peris_ctrl(struct clk *clk, int enable)
 	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_PERIS, clk, enable);
 }
 
+static int exynos5_clk_ip_gscl_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_GSCL, clk, enable);
+}
+
+static int exynos5_clk_ip_isp0_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_ISP0, clk, enable);
+}
+
+static int exynos5_clk_ip_isp1_ctrl(struct clk *clk, int enable)
+{
+	return s5p_gatectrl(EXYNOS5_CLKGATE_IP_ISP1, clk, enable);
+}
+
 /* Core list of CMU_CPU side */
 
 static struct clksrc_clk exynos5_clk_mout_apll = {
@@ -630,6 +650,76 @@ static struct clk exynos5_init_clocks_off[] = {
 		.parent		= &exynos5_clk_aclk_66.clk,
 		.enable		= exynos5_clk_ip_peric_ctrl,
 		.ctrlbit	= (1 << 14),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
+		.enable		= &exynos5_clk_ip_mfc_ctrl,
+		.ctrlbit	= (1 << 1),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(mfc_r, 1),
+		.enable		= &exynos5_clk_ip_mfc_ctrl,
+		.ctrlbit	= (1 << 2),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(tv, 2),
+		.enable		= &exynos5_clk_ip_disp1_ctrl,
+		.ctrlbit	= (1 << 9)
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(jpeg, 3),
+		.enable		= &exynos5_clk_ip_gen_ctrl,
+		.ctrlbit	= (1 << 7),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(rot, 4),
+		.enable		= &exynos5_clk_ip_gen_ctrl,
+		.ctrlbit	= (1 << 6)
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc0, 5),
+		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 7),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc1, 6),
+		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 8),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc2, 7),
+		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 9),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(gsc3, 8),
+		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 10),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.enable		= &exynos5_clk_ip_isp0_ctrl,
+		.ctrlbit	= (0x3F << 8),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME2,
+		.devname	= SYSMMU_CLOCK_DEVNAME(isp, 9),
+		.enable		= &exynos5_clk_ip_isp1_ctrl,
+		.ctrlbit	= (0xF << 4),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(camif0, 12),
+		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 11),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(camif1, 13),
+		.enable		= &exynos5_clk_ip_gscl_ctrl,
+		.ctrlbit	= (1 << 12),
+	}, {
+		.name		= SYSMMU_CLOCK_NAME,
+		.devname	= SYSMMU_CLOCK_DEVNAME(2d, 14),
+		.enable		= &exynos5_clk_ip_acp_ctrl,
+		.ctrlbit	= (1 << 7)
 	}
 };
 
diff --git a/arch/arm/mach-exynos/dev-sysmmu.c b/arch/arm/mach-exynos/dev-sysmmu.c
index 781563f..ccc2ed1 100644
--- a/arch/arm/mach-exynos/dev-sysmmu.c
+++ b/arch/arm/mach-exynos/dev-sysmmu.c
@@ -1,9 +1,9 @@
-/* linux/arch/arm/mach-exynos4/dev-sysmmu.c
+/* linux/arch/arm/mach-exynos/dev-sysmmu.c
  *
- * Copyright (c) 2010 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2010-2012 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * EXYNOS4 - System MMU support
+ * EXYNOS - System MMU support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -12,222 +12,257 @@
 
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
-#include <linux/export.h>
+
+#include <plat/cpu.h>
 
 #include <mach/map.h>
 #include <mach/irqs.h>
 #include <mach/sysmmu.h>
-#include <plat/s5p-clock.h>
-
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
+static u64 exynos_sysmmu_dma_mask = DMA_BIT_MASK(32);
+
+#define SYSMMU_PLATFORM_DEVICE(ipname, devid)				\
+static struct sysmmu_platform_data platdata_##ipname = {		\
+	.dbgname = #ipname,						\
+};									\
+struct platform_device SYSMMU_PLATDEV(ipname) =				\
+{									\
+	.name		= SYSMMU_DEVNAME_BASE,				\
+	.id		= devid,					\
+	.dev		= {						\
+		.dma_mask		= &exynos_sysmmu_dma_mask,	\
+		.coherent_dma_mask	= DMA_BIT_MASK(32),		\
+		.platform_data		= &platdata_##ipname,		\
+	},								\
+}
+
+SYSMMU_PLATFORM_DEVICE(mfc_l,	0);
+SYSMMU_PLATFORM_DEVICE(mfc_r,	1);
+SYSMMU_PLATFORM_DEVICE(tv,	2);
+SYSMMU_PLATFORM_DEVICE(jpeg,	3);
+SYSMMU_PLATFORM_DEVICE(rot,	4);
+SYSMMU_PLATFORM_DEVICE(gsc0,	5);
+SYSMMU_PLATFORM_DEVICE(gsc1,	6);
+SYSMMU_PLATFORM_DEVICE(gsc2,	7);
+SYSMMU_PLATFORM_DEVICE(gsc3,	8);
+SYSMMU_PLATFORM_DEVICE(isp,	9);
+SYSMMU_PLATFORM_DEVICE(fimd0,	10);
+SYSMMU_PLATFORM_DEVICE(fimd1,	11);
+SYSMMU_PLATFORM_DEVICE(camif0,	12);
+SYSMMU_PLATFORM_DEVICE(camif1,	13);
+SYSMMU_PLATFORM_DEVICE(2d,	14);
+
+#define SYSMMU_RESOURCE_NAME(core, ipname) sysmmures_##core##_##ipname
+
+#define SYSMMU_RESOURCE(core, ipname)					\
+	static struct resource SYSMMU_RESOURCE_NAME(core, ipname)[] __initdata =
+
+#define DEFINE_SYSMMU_RESOURCE(core, mem, irq)				\
+	DEFINE_RES_MEM_NAMED(core##_PA_SYSMMU_##mem, SZ_4K, #mem),	\
+	DEFINE_RES_IRQ_NAMED(core##_IRQ_SYSMMU_##irq##_0, #mem)
+
+#define SYSMMU_RESOURCE_DEFINE(core, ipname, mem, irq)			\
+	SYSMMU_RESOURCE(core, ipname) {					\
+		DEFINE_SYSMMU_RESOURCE(core, mem, irq)			\
+	}
 
-struct platform_device exynos4_device_sysmmu = {
-	.name		= "s5p-sysmmu",
-	.id		= 32,
-	.num_resources	= ARRAY_SIZE(exynos4_sysmmu_resource),
-	.resource	= exynos4_sysmmu_resource,
+struct sysmmu_resource_map {
+	struct platform_device *pdev;
+	struct resource *res;
+	u32 rnum;
+	struct device *pdd;
+	char *clocknames;
 };
-EXPORT_SYMBOL(exynos4_device_sysmmu);
 
-static struct clk *sysmmu_clk[S5P_SYSMMU_TOTAL_IPNUM];
-void sysmmu_clk_init(struct device *dev, sysmmu_ips ips)
-{
-	sysmmu_clk[ips] = clk_get(dev, sysmmu_ips_name[ips]);
-	if (IS_ERR(sysmmu_clk[ips]))
-		sysmmu_clk[ips] = NULL;
-	else
-		clk_put(sysmmu_clk[ips]);
+#define SYSMMU_RESOURCE_MAPPING(core, ipname, resname) {		\
+	.pdev = &SYSMMU_PLATDEV(ipname),				\
+	.res = SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
+	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
+	.clocknames = SYSMMU_CLOCK_NAME,				\
 }
 
-void sysmmu_clk_enable(sysmmu_ips ips)
-{
-	if (sysmmu_clk[ips])
-		clk_enable(sysmmu_clk[ips]);
+#define SYSMMU_RESOURCE_MAPPING_MC(core, ipname, resname, pdata) {	\
+	.pdev = &SYSMMU_PLATDEV(ipname),				\
+	.res = SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
+	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
+	.clocknames = SYSMMU_CLOCK_NAME "," SYSMMU_CLOCK_NAME2,		\
+}
+
+#ifdef CONFIG_EXYNOS_DEV_PD
+#define SYSMMU_RESOURCE_MAPPING_PD(core, ipname, resname, pd) {		\
+	.pdev = &SYSMMU_PLATDEV(ipname),				\
+	.res = &SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
+	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
+	.clocknames = SYSMMU_CLOCK_NAME,				\
+	.pdd = &exynos##core##_device_pd[pd].dev,			\
+}
+
+#define SYSMMU_RESOURCE_MAPPING_MCPD(core, ipname, resname, pd, pdata) {\
+	.pdev = &SYSMMU_PLATDEV(ipname),				\
+	.res = &SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),		\
+	.rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
+	.clocknames = SYSMMU_CLOCK_NAME "," SYSMMU_CLOCK_NAME2,		\
+	.pdd = &exynos##core##_device_pd[pd].dev,			\
 }
+#else
+#define SYSMMU_RESOURCE_MAPPING_PD(core, ipname, resname, pd)		\
+		SYSMMU_RESOURCE_MAPPING(core, ipname, resname)
+#define SYSMMU_RESOURCE_MAPPING_MCPD(core, ipname, resname, pd, pdata)	\
+		SYSMMU_RESOURCE_MAPPING_MC(core, ipname, resname, pdata)
+
+#endif /* CONFIG_EXYNOS_DEV_PD */
+
+#ifdef CONFIG_ARCH_EXYNOS4
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc0,	FIMC0,	FIMC0);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc1,	FIMC1,	FIMC1);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc2,	FIMC2,	FIMC2);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc3,	FIMC3,	FIMC3);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, jpeg,	JPEG,	JPEG);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, 2d,	G2D,	2D);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, tv,	TV,	TV_M0);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, 2d_acp,	2D_ACP,	2D);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, rot,	ROTATOR, ROTATOR);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimd0,	FIMD0,	LCD0_M0);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimd1,	FIMD1,	LCD1_M1);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, flite0,	FIMC_LITE0, FIMC_LITE0);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, flite1,	FIMC_LITE1, FIMC_LITE1);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, mfc_r,	MFC_R,	MFC_M0);
+SYSMMU_RESOURCE_DEFINE(EXYNOS4, mfc_l,	MFC_L,	MFC_M1);
+SYSMMU_RESOURCE(EXYNOS4, isp) {
+	DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_ISP, FIMC_ISP),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_DRC, FIMC_DRC),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_FD, FIMC_FD),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS4, ISPCPU, FIMC_CX),
+};
+
+static struct sysmmu_resource_map sysmmu_resmap4[] __initdata = {
+	SYSMMU_RESOURCE_MAPPING_PD(4, gsc0,	fimc0,	PD_CAM),
+	SYSMMU_RESOURCE_MAPPING_PD(4, gsc1,	fimc1,	PD_CAM),
+	SYSMMU_RESOURCE_MAPPING_PD(4, gsc2,	fimc2,	PD_CAM),
+	SYSMMU_RESOURCE_MAPPING_PD(4, gsc3,	fimc3,	PD_CAM),
+	SYSMMU_RESOURCE_MAPPING_PD(4, tv,	tv,	PD_TV),
+	SYSMMU_RESOURCE_MAPPING_PD(4, mfc,	mfc,	PD_TV),
+	SYSMMU_RESOURCE_MAPPING_PD(4, rot,	rot,	PD_LCD0),
+	SYSMMU_RESOURCE_MAPPING_PD(4, jpeg,	jpeg,	PD_CAM),
+	SYSMMU_RESOURCE_MAPPING_PD(4, fimd0,	fimd0,	PD_LCD0),
+};
+
+static struct sysmmu_resource_map sysmmu_resmap4210[] __initdata = {
+	SYSMMU_RESOURCE_MAPPING_PD(4, 2d,	2d,	PD_LCD0),
+	SYSMMU_RESOURCE_MAPPING_PD(4, fimd1,	fimd1,	PD_LCD1),
+};
+
+static struct sysmmu_resource_map sysmmu_resmap4212[] __initdata = {
+	SYSMMU_RESOURCE_MAPPING(4,	2d,	2d_acp),
+	SYSMMU_RESOURCE_MAPPING_PD(4,	camif0, flite0,	PD_ISP),
+	SYSMMU_RESOURCE_MAPPING_PD(4,	camif1, flite1,	PD_ISP),
+	SYSMMU_RESOURCE_MAPPING_PD(4,	isp,	isp,	PD_ISP),
+};
+
+#endif
+
+#ifdef CONFIG_ARCH_EXYNOS5
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, jpeg,	JPEG,	JPEG);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, fimd1,	FIMD1,	FIMD1);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, 2d,	2D,	2D);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, rot,	ROTATOR, ROTATOR);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, tv,	TV,	TV);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, flite0,	LITE0,	LITE0);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, flite1,	LITE1,	LITE1);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc0,	GSC0,	GSC0);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc1,	GSC1,	GSC1);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc2,	GSC2,	GSC2);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, gsc3,	GSC3,	GSC3);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, mfc_r,	MFC_R,	MFC_R);
+SYSMMU_RESOURCE_DEFINE(EXYNOS5, mfc_l,	MFC_L,	MFC_L);
+SYSMMU_RESOURCE(EXYNOS5, isp) {
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, ISP, ISP),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, DRC, DRC),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, FD, FD),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, ISPCPU, MCUISP),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, SCALERC, SCALERCISP),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, SCALERP, SCALERPISP),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5,	ODC, ODC),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, DIS0, DIS0),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, DIS1, DIS1),
+	DEFINE_SYSMMU_RESOURCE(EXYNOS5, 3DNR, 3DNR),
+};
+
+static struct sysmmu_resource_map sysmmu_resmap5[] __initdata = {
+	SYSMMU_RESOURCE_MAPPING(5,	jpeg,	jpeg),
+	SYSMMU_RESOURCE_MAPPING(5,	fimd1,	fimd1),
+	SYSMMU_RESOURCE_MAPPING(5,	2d,	2d),
+	SYSMMU_RESOURCE_MAPPING(5,	rot,	rot),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	tv,	tv,	PD_DISP1),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	camif0,	flite0,	PD_GSCL),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	camif1,	flite1,	PD_GSCL),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc0,	gsc0,	PD_GSCL),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc1,	gsc1,	PD_GSCL),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc2,	gsc2,	PD_GSCL),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	gsc3,	gsc3,	PD_GSCL),
+	SYSMMU_RESOURCE_MAPPING_PD(5,	mfc,	mfc,	PD_MFC),
+	SYSMMU_RESOURCE_MAPPING_MCPD(5,	isp,	isp,	PD_ISP, mc_platdata),
+};
+#endif
 
-void sysmmu_clk_disable(sysmmu_ips ips)
+static int __init init_sysmmu_platform_device(void)
 {
-	if (sysmmu_clk[ips])
-		clk_disable(sysmmu_clk[ips]);
+	int i, j;
+	struct sysmmu_resource_map *resmap[2] = {NULL, NULL};
+	int nmap[2] = {0, 0};
+
+#ifdef CONFIG_ARCH_EXYNOS5
+	if (soc_is_exynos5250()) {
+		resmap[0] = sysmmu_resmap5;
+		nmap[0] = ARRAY_SIZE(sysmmu_resmap5);
+		nmap[1] = 0;
+	}
+#endif
+
+#ifdef CONFIG_ARCH_EXYNOS4
+	if (resmap[0] == NULL) {
+		resmap[0] = sysmmu_resmap4;
+		nmap[0] = ARRAY_SIZE(sysmmu_resmap4);
+	}
+
+	if (soc_is_exynos4210()) {
+		resmap[1] = sysmmu_resmap4210;
+		nmap[1] = ARRAY_SIZE(sysmmu_resmap4210);
+	}
+
+	if (soc_is_exynos4412() || soc_is_exynos4212()) {
+		resmap[1] = sysmmu_resmap4212;
+		nmap[1] = ARRAY_SIZE(sysmmu_resmap4212);
+	}
+#endif
+	for (j = 0; j < 2; j++) {
+		for (i = 0; i < nmap[j]; i++) {
+			struct sysmmu_resource_map *map;
+			struct sysmmu_platform_data *platdata;
+
+			map = &resmap[j][i];
+
+			map->pdev->dev.parent = map->pdd;
+
+			platdata = map->pdev->dev.platform_data;
+			platdata->clockname = map->clocknames;
+
+			if (platform_device_add_resources(map->pdev, map->res,
+								map->rnum)) {
+				pr_err("%s: Failed to add device resources for "
+						"%s.%d\n", __func__,
+						map->pdev->name, map->pdev->id);
+				continue;
+			}
+
+			if (platform_device_register(map->pdev)) {
+				pr_err("%s: Failed to register %s.%d\n",
+					__func__, map->pdev->name,
+						map->pdev->id);
+			}
+		}
+	}
+
+	return 0;
 }
+arch_initcall(init_sysmmu_platform_device);
diff --git a/arch/arm/mach-exynos/include/mach/irqs.h b/arch/arm/mach-exynos/include/mach/irqs.h
index 2fd2c25..60c5c81 100644
--- a/arch/arm/mach-exynos/include/mach/irqs.h
+++ b/arch/arm/mach-exynos/include/mach/irqs.h
@@ -131,23 +131,30 @@
 #define COMBINER_GROUP(x)	((x) * MAX_IRQ_IN_COMBINER + IRQ_SPI(128))
 #define COMBINER_IRQ(x, y)	(COMBINER_GROUP(x) + y)
 
-#define IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(4, 0)
-#define IRQ_SYSMMU_SSS_0	COMBINER_IRQ(4, 1)
-#define IRQ_SYSMMU_FIMC0_0	COMBINER_IRQ(4, 2)
-#define IRQ_SYSMMU_FIMC1_0	COMBINER_IRQ(4, 3)
-#define IRQ_SYSMMU_FIMC2_0	COMBINER_IRQ(4, 4)
-#define IRQ_SYSMMU_FIMC3_0	COMBINER_IRQ(4, 5)
-#define IRQ_SYSMMU_JPEG_0	COMBINER_IRQ(4, 6)
-#define IRQ_SYSMMU_2D_0		COMBINER_IRQ(4, 7)
-
-#define IRQ_SYSMMU_ROTATOR_0	COMBINER_IRQ(5, 0)
-#define IRQ_SYSMMU_MDMA1_0	COMBINER_IRQ(5, 1)
-#define IRQ_SYSMMU_LCD0_M0_0	COMBINER_IRQ(5, 2)
-#define IRQ_SYSMMU_LCD1_M1_0	COMBINER_IRQ(5, 3)
-#define IRQ_SYSMMU_TV_M0_0	COMBINER_IRQ(5, 4)
-#define IRQ_SYSMMU_MFC_M0_0	COMBINER_IRQ(5, 5)
-#define IRQ_SYSMMU_MFC_M1_0	COMBINER_IRQ(5, 6)
-#define IRQ_SYSMMU_PCIE_0	COMBINER_IRQ(5, 7)
+#define EXYNOS4_IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(4, 0)
+#define EXYNOS4_IRQ_SYSMMU_SSS_0	COMBINER_IRQ(4, 1)
+#define EXYNOS4_IRQ_SYSMMU_FIMC0_0	COMBINER_IRQ(4, 2)
+#define EXYNOS4_IRQ_SYSMMU_FIMC1_0	COMBINER_IRQ(4, 3)
+#define EXYNOS4_IRQ_SYSMMU_FIMC2_0	COMBINER_IRQ(4, 4)
+#define EXYNOS4_IRQ_SYSMMU_FIMC3_0	COMBINER_IRQ(4, 5)
+#define EXYNOS4_IRQ_SYSMMU_JPEG_0	COMBINER_IRQ(4, 6)
+#define EXYNOS4_IRQ_SYSMMU_2D_0		COMBINER_IRQ(4, 7)
+
+#define EXYNOS4_IRQ_SYSMMU_ROTATOR_0	COMBINER_IRQ(5, 0)
+#define EXYNOS4_IRQ_SYSMMU_MDMA1_0	COMBINER_IRQ(5, 1)
+#define EXYNOS4_IRQ_SYSMMU_LCD0_M0_0	COMBINER_IRQ(5, 2)
+#define EXYNOS4_IRQ_SYSMMU_LCD1_M1_0	COMBINER_IRQ(5, 3)
+#define EXYNOS4_IRQ_SYSMMU_TV_M0_0	COMBINER_IRQ(5, 4)
+#define EXYNOS4_IRQ_SYSMMU_MFC_M0_0	COMBINER_IRQ(5, 5)
+#define EXYNOS4_IRQ_SYSMMU_MFC_M1_0	COMBINER_IRQ(5, 6)
+#define EXYNOS4_IRQ_SYSMMU_PCIE_0	COMBINER_IRQ(5, 7)
+
+#define EXYNOS4_IRQ_SYSMMU_FIMC_LITE0_0	COMBINER_IRQ(16, 0)
+#define EXYNOS4_IRQ_SYSMMU_FIMC_LITE1_0	COMBINER_IRQ(16, 1)
+#define EXYNOS4_IRQ_SYSMMU_FIMC_ISP_0	COMBINER_IRQ(16, 2)
+#define EXYNOS4_IRQ_SYSMMU_FIMC_DRC_0	COMBINER_IRQ(16, 3)
+#define EXYNOS4_IRQ_SYSMMU_FIMC_FD_0	COMBINER_IRQ(16, 4)
+#define EXYNOS4_IRQ_SYSMMU_FIMC_CX_0	COMBINER_IRQ(16, 5)
 
 #define IRQ_FIMD0_FIFO		COMBINER_IRQ(11, 0)
 #define IRQ_FIMD0_VSYNC		COMBINER_IRQ(11, 1)
@@ -277,70 +284,70 @@
 #define IRQ_PMU			COMBINER_IRQ(1, 2)
 #define IRQ_PMU_CPU1		COMBINER_IRQ(1, 6)
 
-#define IRQ_SYSMMU_GSC0_0	COMBINER_IRQ(2, 0)
-#define IRQ_SYSMMU_GSC0_1	COMBINER_IRQ(2, 1)
-#define IRQ_SYSMMU_GSC1_0	COMBINER_IRQ(2, 2)
-#define IRQ_SYSMMU_GSC1_1	COMBINER_IRQ(2, 3)
-#define IRQ_SYSMMU_GSC2_0	COMBINER_IRQ(2, 4)
-#define IRQ_SYSMMU_GSC2_1	COMBINER_IRQ(2, 5)
-#define IRQ_SYSMMU_GSC3_0	COMBINER_IRQ(2, 6)
-#define IRQ_SYSMMU_GSC3_1	COMBINER_IRQ(2, 7)
-
-#define IRQ_SYSMMU_FIMD1_0	COMBINER_IRQ(3, 2)
-#define IRQ_SYSMMU_FIMD1_1	COMBINER_IRQ(3, 3)
-#define IRQ_SYSMMU_LITE0_0	COMBINER_IRQ(3, 4)
-#define IRQ_SYSMMU_LITE0_1	COMBINER_IRQ(3, 5)
-#define IRQ_SYSMMU_SCALERPISP_0	COMBINER_IRQ(3, 6)
-#define IRQ_SYSMMU_SCALERPISP_1	COMBINER_IRQ(3, 7)
-
-#define IRQ_SYSMMU_ROTATOR_0	COMBINER_IRQ(4, 0)
-#define IRQ_SYSMMU_ROTATOR_1	COMBINER_IRQ(4, 1)
-#define IRQ_SYSMMU_JPEG_0	COMBINER_IRQ(4, 2)
-#define IRQ_SYSMMU_JPEG_1	COMBINER_IRQ(4, 3)
-
-#define IRQ_SYSMMU_FD_0		COMBINER_IRQ(5, 0)
-#define IRQ_SYSMMU_FD_1		COMBINER_IRQ(5, 1)
-#define IRQ_SYSMMU_SCALERCISP_0	COMBINER_IRQ(5, 2)
-#define IRQ_SYSMMU_SCALERCISP_1	COMBINER_IRQ(5, 3)
-#define IRQ_SYSMMU_MCUISP_0	COMBINER_IRQ(5, 4)
-#define IRQ_SYSMMU_MCUISP_1	COMBINER_IRQ(5, 5)
-#define IRQ_SYSMMU_3DNR_0	COMBINER_IRQ(5, 6)
-#define IRQ_SYSMMU_3DNR_1	COMBINER_IRQ(5, 7)
-
-#define IRQ_SYSMMU_ARM_0	COMBINER_IRQ(6, 0)
-#define IRQ_SYSMMU_ARM_1	COMBINER_IRQ(6, 1)
-#define IRQ_SYSMMU_MFC_L_0	COMBINER_IRQ(6, 2)
-#define IRQ_SYSMMU_MFC_L_1	COMBINER_IRQ(6, 3)
-#define IRQ_SYSMMU_RTIC_0	COMBINER_IRQ(6, 4)
-#define IRQ_SYSMMU_RTIC_1	COMBINER_IRQ(6, 5)
-#define IRQ_SYSMMU_SSS_0	COMBINER_IRQ(6, 6)
-#define IRQ_SYSMMU_SSS_1	COMBINER_IRQ(6, 7)
-
-#define IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(7, 0)
-#define IRQ_SYSMMU_MDMA0_1	COMBINER_IRQ(7, 1)
-#define IRQ_SYSMMU_MDMA1_0	COMBINER_IRQ(7, 2)
-#define IRQ_SYSMMU_MDMA1_1	COMBINER_IRQ(7, 3)
-#define IRQ_SYSMMU_TV_0		COMBINER_IRQ(7, 4)
-#define IRQ_SYSMMU_TV_1		COMBINER_IRQ(7, 5)
-#define IRQ_SYSMMU_GPSX_0	COMBINER_IRQ(7, 6)
-#define IRQ_SYSMMU_GPSX_1	COMBINER_IRQ(7, 7)
-
-#define IRQ_SYSMMU_MFC_R_0	COMBINER_IRQ(8, 5)
-#define IRQ_SYSMMU_MFC_R_1	COMBINER_IRQ(8, 6)
-
-#define IRQ_SYSMMU_DIS1_0	COMBINER_IRQ(9, 4)
-#define IRQ_SYSMMU_DIS1_1	COMBINER_IRQ(9, 5)
-
-#define IRQ_DP			COMBINER_IRQ(10, 3)
-#define IRQ_SYSMMU_DIS0_0	COMBINER_IRQ(10, 4)
-#define IRQ_SYSMMU_DIS0_1	COMBINER_IRQ(10, 5)
-#define IRQ_SYSMMU_ISP_0	COMBINER_IRQ(10, 6)
-#define IRQ_SYSMMU_ISP_1	COMBINER_IRQ(10, 7)
-
-#define IRQ_SYSMMU_ODC_0	COMBINER_IRQ(11, 0)
-#define IRQ_SYSMMU_ODC_1	COMBINER_IRQ(11, 1)
-#define IRQ_SYSMMU_DRC_0	COMBINER_IRQ(11, 6)
-#define IRQ_SYSMMU_DRC_1	COMBINER_IRQ(11, 7)
+#define EXYNOS5_IRQ_SYSMMU_GSC0_0	COMBINER_IRQ(2, 0)
+#define EXYNOS5_IRQ_SYSMMU_GSC0_1	COMBINER_IRQ(2, 1)
+#define EXYNOS5_IRQ_SYSMMU_GSC1_0	COMBINER_IRQ(2, 2)
+#define EXYNOS5_IRQ_SYSMMU_GSC1_1	COMBINER_IRQ(2, 3)
+#define EXYNOS5_IRQ_SYSMMU_GSC2_0	COMBINER_IRQ(2, 4)
+#define EXYNOS5_IRQ_SYSMMU_GSC2_1	COMBINER_IRQ(2, 5)
+#define EXYNOS5_IRQ_SYSMMU_GSC3_0	COMBINER_IRQ(2, 6)
+#define EXYNOS5_IRQ_SYSMMU_GSC3_1	COMBINER_IRQ(2, 7)
+
+#define EXYNOS5_IRQ_SYSMMU_FIMD1_0	COMBINER_IRQ(3, 2)
+#define EXYNOS5_IRQ_SYSMMU_FIMD1_1	COMBINER_IRQ(3, 3)
+#define EXYNOS5_IRQ_SYSMMU_LITE0_0	COMBINER_IRQ(3, 4)
+#define EXYNOS5_IRQ_SYSMMU_LITE0_1	COMBINER_IRQ(3, 5)
+#define EXYNOS5_IRQ_SYSMMU_SCALERPISP_0	COMBINER_IRQ(3, 6)
+#define EXYNOS5_IRQ_SYSMMU_SCALERPISP_1	COMBINER_IRQ(3, 7)
+
+#define EXYNOS5_IRQ_SYSMMU_ROTATOR_0	COMBINER_IRQ(4, 0)
+#define EXYNOS5_IRQ_SYSMMU_ROTATOR_1	COMBINER_IRQ(4, 1)
+#define EXYNOS5_IRQ_SYSMMU_JPEG_0	COMBINER_IRQ(4, 2)
+#define EXYNOS5_IRQ_SYSMMU_JPEG_1	COMBINER_IRQ(4, 3)
+
+#define EXYNOS5_IRQ_SYSMMU_FD_0		COMBINER_IRQ(5, 0)
+#define EXYNOS5_IRQ_SYSMMU_FD_1		COMBINER_IRQ(5, 1)
+#define EXYNOS5_IRQ_SYSMMU_SCALERCISP_0	COMBINER_IRQ(5, 2)
+#define EXYNOS5_IRQ_SYSMMU_SCALERCISP_1	COMBINER_IRQ(5, 3)
+#define EXYNOS5_IRQ_SYSMMU_MCUISP_0	COMBINER_IRQ(5, 4)
+#define EXYNOS5_IRQ_SYSMMU_MCUISP_1	COMBINER_IRQ(5, 5)
+#define EXYNOS5_IRQ_SYSMMU_3DNR_0	COMBINER_IRQ(5, 6)
+#define EXYNOS5_IRQ_SYSMMU_3DNR_1	COMBINER_IRQ(5, 7)
+
+#define EXYNOS5_IRQ_SYSMMU_ARM_0	COMBINER_IRQ(6, 0)
+#define EXYNOS5_IRQ_SYSMMU_ARM_1	COMBINER_IRQ(6, 1)
+#define EXYNOS5_IRQ_SYSMMU_MFC_L_0	COMBINER_IRQ(6, 2)
+#define EXYNOS5_IRQ_SYSMMU_MFC_L_1	COMBINER_IRQ(6, 3)
+#define EXYNOS5_IRQ_SYSMMU_RTIC_0	COMBINER_IRQ(6, 4)
+#define EXYNOS5_IRQ_SYSMMU_RTIC_1	COMBINER_IRQ(6, 5)
+#define EXYNOS5_IRQ_SYSMMU_SSS_0	COMBINER_IRQ(6, 6)
+#define EXYNOS5_IRQ_SYSMMU_SSS_1	COMBINER_IRQ(6, 7)
+
+#define EXYNOS5_IRQ_SYSMMU_MDMA0_0	COMBINER_IRQ(7, 0)
+#define EXYNOS5_IRQ_SYSMMU_MDMA0_1	COMBINER_IRQ(7, 1)
+#define EXYNOS5_IRQ_SYSMMU_MDMA1_0	COMBINER_IRQ(7, 2)
+#define EXYNOS5_IRQ_SYSMMU_MDMA1_1	COMBINER_IRQ(7, 3)
+#define EXYNOS5_IRQ_SYSMMU_TV_0		COMBINER_IRQ(7, 4)
+#define EXYNOS5_IRQ_SYSMMU_TV_1		COMBINER_IRQ(7, 5)
+#define EXYNOS5_IRQ_SYSMMU_GPSX_0	COMBINER_IRQ(7, 6)
+#define EXYNOS5_IRQ_SYSMMU_GPSX_1	COMBINER_IRQ(7, 7)
+
+#define EXYNOS5_IRQ_SYSMMU_MFC_R_0	COMBINER_IRQ(8, 5)
+#define EXYNOS5_IRQ_SYSMMU_MFC_R_1	COMBINER_IRQ(8, 6)
+
+#define EXYNOS5_IRQ_SYSMMU_DIS1_0	COMBINER_IRQ(9, 4)
+#define EXYNOS5_IRQ_SYSMMU_DIS1_1	COMBINER_IRQ(9, 5)
+
+#define IRQ_DP				COMBINER_IRQ(10, 3)
+#define EXYNOS5_IRQ_SYSMMU_DIS0_0	COMBINER_IRQ(10, 4)
+#define EXYNOS5_IRQ_SYSMMU_DIS0_1	COMBINER_IRQ(10, 5)
+#define EXYNOS5_IRQ_SYSMMU_ISP_0	COMBINER_IRQ(10, 6)
+#define EXYNOS5_IRQ_SYSMMU_ISP_1	COMBINER_IRQ(10, 7)
+
+#define EXYNOS5_IRQ_SYSMMU_ODC_0	COMBINER_IRQ(11, 0)
+#define EXYNOS5_IRQ_SYSMMU_ODC_1	COMBINER_IRQ(11, 1)
+#define EXYNOS5_IRQ_SYSMMU_DRC_0	COMBINER_IRQ(11, 6)
+#define EXYNOS5_IRQ_SYSMMU_DRC_1	COMBINER_IRQ(11, 7)
 
 #define IRQ_FIMD1_FIFO		COMBINER_IRQ(18, 4)
 #define IRQ_FIMD1_VSYNC		COMBINER_IRQ(18, 5)
@@ -354,11 +361,11 @@
 #define IRQ_MCT_G2		COMBINER_IRQ(23, 5)
 #define IRQ_MCT_G3		COMBINER_IRQ(23, 6)
 
-#define IRQ_EINT1		COMBINER_IRQ(24, 0)
-#define IRQ_SYSMMU_LITE1_0	COMBINER_IRQ(24, 1)
-#define IRQ_SYSMMU_LITE1_1	COMBINER_IRQ(24, 2)
-#define IRQ_SYSMMU_2D_0		COMBINER_IRQ(24, 5)
-#define IRQ_SYSMMU_2D_1		COMBINER_IRQ(24, 6)
+#define IRQ_EINT1			COMBINER_IRQ(24, 0)
+#define EXYNOS5_IRQ_SYSMMU_LITE1_0	COMBINER_IRQ(24, 1)
+#define EXYNOS5_IRQ_SYSMMU_LITE1_1	COMBINER_IRQ(24, 2)
+#define EXYNOS5_IRQ_SYSMMU_2D_0		COMBINER_IRQ(24, 5)
+#define EXYNOS5_IRQ_SYSMMU_2D_1		COMBINER_IRQ(24, 6)
 
 #define IRQ_EINT2		COMBINER_IRQ(25, 0)
 #define IRQ_EINT3		COMBINER_IRQ(25, 1)
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index b96d008..4ad7b21 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -90,6 +90,7 @@
 #define EXYNOS5_PA_PDMA1		0x121b0000
 
 #define EXYNOS4_PA_SYSMMU_MDMA		0x10A40000
+#define EXYNOS4_PA_SYSMMU_2D_ACP	0x10A40000
 #define EXYNOS4_PA_SYSMMU_SSS		0x10A50000
 #define EXYNOS4_PA_SYSMMU_FIMC0		0x11A20000
 #define EXYNOS4_PA_SYSMMU_FIMC1		0x11A30000
@@ -98,6 +99,12 @@
 #define EXYNOS4_PA_SYSMMU_JPEG		0x11A60000
 #define EXYNOS4_PA_SYSMMU_FIMD0		0x11E20000
 #define EXYNOS4_PA_SYSMMU_FIMD1		0x12220000
+#define EXYNOS4_PA_SYSMMU_FIMC_ISP	0x12260000
+#define EXYNOS4_PA_SYSMMU_FIMC_DRC	0x12270000
+#define EXYNOS4_PA_SYSMMU_FIMC_FD	0x122A0000
+#define EXYNOS4_PA_SYSMMU_ISPCPU	0x122B0000
+#define EXYNOS4_PA_SYSMMU_FIMC_LITE0	0x123B0000
+#define EXYNOS4_PA_SYSMMU_FIMC_LITE1	0x123C0000
 #define EXYNOS4_PA_SYSMMU_PCIe		0x12620000
 #define EXYNOS4_PA_SYSMMU_G2D		0x12A20000
 #define EXYNOS4_PA_SYSMMU_ROTATOR	0x12A30000
@@ -105,6 +112,37 @@
 #define EXYNOS4_PA_SYSMMU_TV		0x12E20000
 #define EXYNOS4_PA_SYSMMU_MFC_L		0x13620000
 #define EXYNOS4_PA_SYSMMU_MFC_R		0x13630000
+
+#define EXYNOS5_PA_SYSMMU_MDMA1		0x10A40000
+#define EXYNOS5_PA_SYSMMU_SSS		0x10A50000
+#define EXYNOS5_PA_SYSMMU_2D		0x10A60000
+#define EXYNOS5_PA_SYSMMU_MFC_L		0x11200000
+#define EXYNOS5_PA_SYSMMU_MFC_R		0x11210000
+#define EXYNOS5_PA_SYSMMU_ROTATOR	0x11D40000
+#define EXYNOS5_PA_SYSMMU_MDMA2		0x11D50000
+#define EXYNOS5_PA_SYSMMU_JPEG		0x11F20000
+#define EXYNOS5_PA_SYSMMU_IOP		0x12360000
+#define EXYNOS5_PA_SYSMMU_RTIC		0x12370000
+#define EXYNOS5_PA_SYSMMU_GPS		0x12630000
+#define EXYNOS5_PA_SYSMMU_ISP		0x13260000
+#define EXYNOS5_PA_SYSMMU_DRC		0x12370000
+#define EXYNOS5_PA_SYSMMU_SCALERC	0x13280000
+#define EXYNOS5_PA_SYSMMU_SCALERP	0x13290000
+#define EXYNOS5_PA_SYSMMU_FD		0x132A0000
+#define EXYNOS5_PA_SYSMMU_ISPCPU	0x132B0000
+#define EXYNOS5_PA_SYSMMU_ODC		0x132C0000
+#define EXYNOS5_PA_SYSMMU_DIS0		0x132D0000
+#define EXYNOS5_PA_SYSMMU_DIS1		0x132E0000
+#define EXYNOS5_PA_SYSMMU_3DNR		0x132F0000
+#define EXYNOS5_PA_SYSMMU_LITE0		0x13C40000
+#define EXYNOS5_PA_SYSMMU_LITE1		0x13C50000
+#define EXYNOS5_PA_SYSMMU_GSC0		0x13E80000
+#define EXYNOS5_PA_SYSMMU_GSC1		0x13E90000
+#define EXYNOS5_PA_SYSMMU_GSC2		0x13EA0000
+#define EXYNOS5_PA_SYSMMU_GSC3		0x13EB0000
+#define EXYNOS5_PA_SYSMMU_FIMD1		0x14640000
+#define EXYNOS5_PA_SYSMMU_TV		0x14650000
+
 #define EXYNOS4_PA_SPI0			0x13920000
 #define EXYNOS4_PA_SPI1			0x13930000
 #define EXYNOS4_PA_SPI2			0x13940000
diff --git a/arch/arm/mach-exynos/include/mach/regs-clock.h b/arch/arm/mach-exynos/include/mach/regs-clock.h
index d859958..298c3f8 100644
--- a/arch/arm/mach-exynos/include/mach/regs-clock.h
+++ b/arch/arm/mach-exynos/include/mach/regs-clock.h
@@ -130,6 +130,9 @@
 #define EXYNOS4_CLKGATE_SCLKCPU			EXYNOS_CLKREG(0x14800)
 #define EXYNOS4_CLKGATE_IP_CPU			EXYNOS_CLKREG(0x14900)
 
+#define EXYNOS4_CLKGATE_IP_ISP0			EXYNOS_CLKREG(0x18800)
+#define EXYNOS4_CLKGATE_IP_ISP1			EXYNOS_CLKREG(0x18804)
+
 #define EXYNOS4_APLL_LOCKTIME			(0x1C20)	/* 300us */
 
 #define EXYNOS4_APLLCON0_ENABLE_SHIFT		(31)
@@ -261,6 +264,8 @@
 #define EXYNOS5_CLKDIV_PERIC0			EXYNOS_CLKREG(0x10558)
 
 #define EXYNOS5_CLKGATE_IP_ACP			EXYNOS_CLKREG(0x08800)
+#define EXYNOS5_CLKGATE_IP_ISP0			EXYNOS_CLKREG(0x0C800)
+#define EXYNOS5_CLKGATE_IP_ISP1			EXYNOS_CLKREG(0x0C804)
 #define EXYNOS5_CLKGATE_IP_GSCL			EXYNOS_CLKREG(0x10920)
 #define EXYNOS5_CLKGATE_IP_DISP1		EXYNOS_CLKREG(0x10928)
 #define EXYNOS5_CLKGATE_IP_MFC			EXYNOS_CLKREG(0x1092C)
diff --git a/arch/arm/mach-exynos/include/mach/regs-sysmmu.h b/arch/arm/mach-exynos/include/mach/regs-sysmmu.h
deleted file mode 100644
index 68ff6ad..0000000
--- a/arch/arm/mach-exynos/include/mach/regs-sysmmu.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/* linux/arch/arm/mach-exynos4/include/mach/regs-sysmmu.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
- *		http://www.samsung.com
- *
- * EXYNOS4 - System MMU register
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#ifndef __ASM_ARCH_REGS_SYSMMU_H
-#define __ASM_ARCH_REGS_SYSMMU_H __FILE__
-
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
-
-#endif /* __ASM_ARCH_REGS_SYSMMU_H */
diff --git a/arch/arm/mach-exynos/include/mach/sysmmu.h b/arch/arm/mach-exynos/include/mach/sysmmu.h
index 6a5fbb5..7fe8527 100644
--- a/arch/arm/mach-exynos/include/mach/sysmmu.h
+++ b/arch/arm/mach-exynos/include/mach/sysmmu.h
@@ -1,46 +1,62 @@
-/* linux/arch/arm/mach-exynos4/include/mach/sysmmu.h
- *
- * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+/*
+ * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
- * Samsung sysmmu driver for EXYNOS4
+ * EXYNOS - System MMU support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
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
+ */
+
+#ifndef _ARM_MACH_EXYNOS_SYSMMU_H_
+#define _ARM_MACH_EXYNOS_SYSMMU_H_
+
+struct sysmmu_platform_data {
+	char *dbgname;
+	/* comma(,) separated list of clock names for clock gating */
+	char *clockname;
 };
 
-#define S5P_SYSMMU_TOTAL_IPNUM		EXYNOS4_SYSMMU_TOTAL_IPNUM
+#define SYSMMU_DEVNAME_BASE "exynos-sysmmu"
+
+#define SYSMMU_CLOCK_NAME "sysmmu"
+#define SYSMMU_CLOCK_NAME2 "sysmmu_mc"
+
+#ifdef CONFIG_EXYNOS_DEV_SYSMMU
+#include <linux/device.h>
+struct platform_device;
+
+#define SYSMMU_PLATDEV(ipname) exynos_device_sysmmu_##ipname
+
+extern struct platform_device SYSMMU_PLATDEV(mfc_l);
+extern struct platform_device SYSMMU_PLATDEV(mfc_r);
+extern struct platform_device SYSMMU_PLATDEV(tv);
+extern struct platform_device SYSMMU_PLATDEV(jpeg);
+extern struct platform_device SYSMMU_PLATDEV(rot);
+extern struct platform_device SYSMMU_PLATDEV(gsc0);
+extern struct platform_device SYSMMU_PLATDEV(gsc1);
+extern struct platform_device SYSMMU_PLATDEV(gsc2);
+extern struct platform_device SYSMMU_PLATDEV(gsc3);
+extern struct platform_device SYSMMU_PLATDEV(isp);
+extern struct platform_device SYSMMU_PLATDEV(fimd0);
+extern struct platform_device SYSMMU_PLATDEV(fimd1);
+extern struct platform_device SYSMMU_PLATDEV(camif0);
+extern struct platform_device SYSMMU_PLATDEV(camif1);
+extern struct platform_device SYSMMU_PLATDEV(2d);
 
-extern const char *sysmmu_ips_name[EXYNOS4_SYSMMU_TOTAL_IPNUM];
+#ifdef CONFIG_IOMMU_API
+static inline void platform_set_sysmmu(
+				struct device *sysmmu, struct device *dev)
+{
+	dev->archdata.iommu = sysmmu;
+}
+#endif
 
-typedef enum exynos4_sysmmu_ips sysmmu_ips;
+#else /* !CONFIG_EXYNOS_DEV_SYSMMU */
+#define platform_set_sysmmu(dev, sysmmu) do { } while (0)
+#endif
 
-void sysmmu_clk_init(struct device *dev, sysmmu_ips ips);
-void sysmmu_clk_enable(sysmmu_ips ips);
-void sysmmu_clk_disable(sysmmu_ips ips);
+#define SYSMMU_CLOCK_DEVNAME(ipname, id) (SYSMMU_DEVNAME_BASE "." #id)
 
-#endif /* __ASM_ARM_ARCH_SYSMMU_H */
+#endif /* _ARM_MACH_EXYNOS_SYSMMU_H_ */
diff --git a/arch/arm/mach-exynos/mach-armlex4210.c b/arch/arm/mach-exynos/mach-armlex4210.c
index d726fcd..6ce2148 100644
--- a/arch/arm/mach-exynos/mach-armlex4210.c
+++ b/arch/arm/mach-exynos/mach-armlex4210.c
@@ -157,7 +157,6 @@ static struct platform_device *armlex4210_devices[] __initdata = {
 	&s3c_device_hsmmc3,
 	&s3c_device_rtc,
 	&s3c_device_wdt,
-	&exynos4_device_sysmmu,
 	&samsung_asoc_dma,
 	&armlex4210_smsc911x,
 	&exynos4_device_ahci,
diff --git a/arch/arm/mach-exynos/mach-smdkv310.c b/arch/arm/mach-exynos/mach-smdkv310.c
index b2c5557..0fb247f 100644
--- a/arch/arm/mach-exynos/mach-smdkv310.c
+++ b/arch/arm/mach-exynos/mach-smdkv310.c
@@ -285,7 +285,6 @@ static struct platform_device *smdkv310_devices[] __initdata = {
 	&exynos4_device_pd[PD_TV],
 	&exynos4_device_pd[PD_GPS],
 	&exynos4_device_spdif,
-	&exynos4_device_sysmmu,
 	&samsung_asoc_dma,
 	&samsung_asoc_idma,
 	&s5p_device_fimd0,
diff --git a/arch/arm/plat-s5p/sysmmu.c b/arch/arm/plat-s5p/sysmmu.c
index c8bec9c..98b87c1 100644
--- a/arch/arm/plat-s5p/sysmmu.c
+++ b/arch/arm/plat-s5p/sysmmu.c
@@ -16,7 +16,6 @@
 #include <asm/pgtable.h>
 
 #include <mach/map.h>
-#include <mach/regs-sysmmu.h>
 #include <plat/sysmmu.h>
 
 #define CTRL_ENABLE	0x5
@@ -25,6 +24,18 @@
 
 static struct device *dev;
 
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
+
 static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
 	S5P_PAGE_FAULT_ADDR,
 	S5P_AR_FAULT_ADDR,
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 32cc67e..2f9e534 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -131,7 +131,6 @@ extern struct platform_device exynos4_device_pcm1;
 extern struct platform_device exynos4_device_pcm2;
 extern struct platform_device exynos4_device_pd[];
 extern struct platform_device exynos4_device_spdif;
-extern struct platform_device exynos4_device_sysmmu;
 
 extern struct platform_device samsung_asoc_dma;
 extern struct platform_device samsung_asoc_idma;
-- 
1.7.1


