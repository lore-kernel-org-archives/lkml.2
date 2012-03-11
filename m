Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab2CKMmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 08:42:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54759 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2CKMl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 08:41:56 -0400
X-AuditID: cbfee61b-b7c62ae000000989-7a-4f5c9d93eb61
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, patches@linaro.org
Subject: [PATCH 3/5] ARM: Exynos4: Add pinctrl devices and pin maps
Date: Sun, 11 Mar 2012 18:16:03 +0530
Message-id: <1331469965-28846-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
References: <1331469965-28846-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the three pinctrl platform devices and the pin maps for Exynos4.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
---
 arch/arm/mach-exynos/Kconfig              |    1 +
 arch/arm/mach-exynos/Makefile             |    1 +
 arch/arm/mach-exynos/common.h             |    6 ++
 arch/arm/mach-exynos/dev-pinctrl.c        |  115 +++++++++++++++++++++++++++++
 arch/arm/plat-samsung/include/plat/devs.h |    3 +
 5 files changed, 126 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-exynos/dev-pinctrl.c

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index c49d450..3e6a1cd 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -18,6 +18,7 @@ choice
 config ARCH_EXYNOS4
 	bool "SAMSUNG EXYNOS4"
 	select HAVE_SMP
+	select PINCTRL
 	select MIGHT_HAVE_CACHE_L2X0
 	help
 	  Samsung EXYNOS4 SoCs based systems
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 6fd8dd9..dbac5f9 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_EXYNOS4_DEV_SYSMMU)	+= dev-sysmmu.o
 obj-$(CONFIG_EXYNOS4_DEV_DWMCI)		+= dev-dwmci.o
 obj-$(CONFIG_EXYNOS4_DEV_DMA)		+= dma.o
 obj-$(CONFIG_EXYNOS4_DEV_USB_OHCI)	+= dev-ohci.o
+obj-$(CONFIG_PINCTRL_SAMSUNG)		+= dev-pinctrl.o
 
 obj-$(CONFIG_ARCH_EXYNOS)		+= setup-i2c0.o
 obj-$(CONFIG_EXYNOS4_SETUP_FIMC)	+= setup-fimc.o
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 677b546..64f3c57 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -52,4 +52,10 @@ void exynos4212_register_clocks(void);
 #define exynos4212_register_clocks()
 #endif
 
+#ifdef CONFIG_PINCTRL_SAMSUNG
+extern int exynos4210_pinctrl_register_def_mappings(void);
+#else
+#define exynos4210_pinctrl_register_def_mappings()
+#endif
+
 #endif /* __ARCH_ARM_MACH_EXYNOS_COMMON_H */
diff --git a/arch/arm/mach-exynos/dev-pinctrl.c b/arch/arm/mach-exynos/dev-pinctrl.c
new file mode 100644
index 0000000..d909052
--- /dev/null
+++ b/arch/arm/mach-exynos/dev-pinctrl.c
@@ -0,0 +1,115 @@
+/*
+ * platform device for all the instances of pinctrl.
+ *
+ * Copyright (c) 2012 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/pinctrl/machine.h>
+
+#include <plat/devs.h>
+#include <plat/pinctrl.h>
+
+#include <mach/map.h>
+
+static struct resource exynos4_pinctrl_resource0[] = {
+	[0] = {
+		.start  = EXYNOS4_PA_GPIO1,
+		.end    = EXYNOS4_PA_GPIO1 + SZ_4K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_GPIO_XA,
+		.end    = IRQ_GPIO_XA,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device exynos4_pinctrl0 = {
+	.name		= "exynos4-pinctrl",
+	.id		= 0,
+	.resource	= exynos4_pinctrl_resource0,
+	.num_resources	= ARRAY_SIZE(exynos4_pinctrl_resource0),
+};
+
+static struct resource exynos4_pinctrl_resource1[] = {
+	[0] = {
+		.start  = EXYNOS4_PA_GPIO2,
+		.end    = EXYNOS4_PA_GPIO2 + SZ_4K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_GPIO_XB,
+		.end    = IRQ_GPIO_XB,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device exynos4_pinctrl1 = {
+	.name		= "exynos4-pinctrl",
+	.id		= 1,
+	.resource	= exynos4_pinctrl_resource1,
+	.num_resources	= ARRAY_SIZE(exynos4_pinctrl_resource1),
+};
+
+static struct resource exynos4_pinctrl_resource2[] = {
+	[0] = {
+		.start  = EXYNOS4_PA_GPIO3,
+		.end    = EXYNOS4_PA_GPIO3 + SZ_4K - 1,
+		.flags  = IORESOURCE_MEM,
+	},
+};
+
+struct platform_device exynos4_pinctrl2 = {
+	.name		= "exynos4-pinctrl",
+	.id		= 2,
+	.resource	= exynos4_pinctrl_resource2,
+	.num_resources	= ARRAY_SIZE(exynos4_pinctrl_resource2),
+};
+
+/* pin config options. todo: add other options here. */
+static unsigned long pcfg_pu_drv3[] __initdata = {
+	PINCTRL_CFG_PACK(PUD_UP, DRV_4X),
+};
+
+static unsigned long pcfg_pn_drv3[] __initdata = {
+	PINCTRL_CFG_PACK(PUD_NONE, DRV_4X),
+};
+
+/* Exynos4210 SoC default pin-maps reusable by Exynos4210 based boards*/
+
+static struct pinctrl_map __initdata exynos4210_sdhci2_8bit_map[] = {
+	PIN_MAP_MUX_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_ctrl_grp", "sdhci2-mux"),
+	PIN_MAP_MUX_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_cd_grp", "sdhci2-mux"),
+	PIN_MAP_MUX_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_4bit_grp", "sdhci2-mux"),
+	PIN_MAP_MUX_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_8bit_grp", "sdhci2-mux"),
+	PIN_MAP_CONFIGS_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_ctrl_grp", pcfg_pn_drv3),
+	PIN_MAP_CONFIGS_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_cd_grp", pcfg_pu_drv3),
+	PIN_MAP_CONFIGS_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_4bit_grp", pcfg_pu_drv3),
+	PIN_MAP_CONFIGS_GROUP("exynos4-sdhci.2", "sdhci-pcfg8", "exynos4-pinctrl.1", "sdhci2_8bit_grp", pcfg_pu_drv3),
+};
+
+static struct pinctrl_map __initdata exynos4210_sdhci2_4bit_map[] = {
+	PIN_MAP_MUX_GROUP("exynos4-sdhci.2", "sdhci-pcfg4", "exynos4-pinctrl.1", "sdhci2_ctrl_grp", "sdhci2-mux"),
+	PIN_MAP_MUX_GROUP("exynos4-sdhci.2", "sdhci-pcfg4", "exynos4-pinctrl.1", "sdhci2_cd_grp", "sdhci2-mux"),
+	PIN_MAP_MUX_GROUP("exynos4-sdhci.2", "sdhci-pcfg4", "exynos4-pinctrl.1", "sdhci2_4bit_grp", "sdhci2-mux"),
+	PIN_MAP_CONFIGS_GROUP("exynos4-sdhci.2", "sdhci-pcfg4", "exynos4-pinctrl.1", "sdhci2_ctrl_grp", pcfg_pn_drv3),
+	PIN_MAP_CONFIGS_GROUP("exynos4-sdhci.2", "sdhci-pcfg4", "exynos4-pinctrl.1", "sdhci2_cd_grp", pcfg_pu_drv3),
+	PIN_MAP_CONFIGS_GROUP("exynos4-sdhci.2", "sdhci-pcfg4", "exynos4-pinctrl.1", "sdhci2_4bit_grp", pcfg_pu_drv3),
+};
+
+int __init exynos4210_pinctrl_register_def_mappings(void)
+{
+	pinctrl_register_mappings(exynos4210_sdhci2_8bit_map, ARRAY_SIZE(exynos4210_sdhci2_8bit_map));
+	pinctrl_register_mappings(exynos4210_sdhci2_4bit_map, ARRAY_SIZE(exynos4210_sdhci2_4bit_map));
+	return 0;
+}
diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
index 2dd5267..760445f 100644
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@ -133,6 +133,9 @@ extern struct platform_device exynos4_device_pcm2;
 extern struct platform_device exynos4_device_pd[];
 extern struct platform_device exynos4_device_spdif;
 extern struct platform_device exynos4_device_sysmmu;
+extern struct platform_device exynos4_pinctrl0;
+extern struct platform_device exynos4_pinctrl1;
+extern struct platform_device exynos4_pinctrl2;
 
 extern struct platform_device samsung_asoc_dma;
 extern struct platform_device samsung_asoc_idma;
-- 
1.6.6.rc2

