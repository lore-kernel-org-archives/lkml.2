Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab1EBTRd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:17:33 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:56505 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755624Ab1EBTR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:17:29 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] pinmux: activate pinmux driver, delete old padmux driver
Date: Mon, 2 May 2011 21:16:58 +0200
Message-ID: <1304363818-30479-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This hooks the pinmux driver into the U300 platform and deletes
the old machine-specific driver.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/Kconfig               |    2 +
 arch/arm/mach-u300/Makefile              |    2 +-
 arch/arm/mach-u300/core.c                |   30 +++-
 arch/arm/mach-u300/include/mach/pinmux.h |    2 +
 arch/arm/mach-u300/include/mach/syscon.h |  136 -----------
 arch/arm/mach-u300/mmc.c                 |   16 --
 arch/arm/mach-u300/padmux.c              |  367 ------------------------------
 arch/arm/mach-u300/padmux.h              |   39 ----
 arch/arm/mach-u300/spi.c                 |   20 --
 9 files changed, 33 insertions(+), 581 deletions(-)
 create mode 100644 arch/arm/mach-u300/include/mach/pinmux.h
 delete mode 100644 arch/arm/mach-u300/padmux.c
 delete mode 100644 arch/arm/mach-u300/padmux.h

diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
index 7b5c229..7b6aa8a 100644
--- a/arch/arm/mach-u300/Kconfig
+++ b/arch/arm/mach-u300/Kconfig
@@ -7,6 +7,8 @@ comment "ST-Ericsson Mobile Platform Products"
 config MACH_U300
 	bool "U300"
 	select GPIO_U300
+	select MACH_HAS_PINMUX
+	select PINMUX_U300
 
 comment "ST-Ericsson U300/U330/U335/U365 Feature Selections"
 
diff --git a/arch/arm/mach-u300/Makefile b/arch/arm/mach-u300/Makefile
index 73da230..4b909b4 100644
--- a/arch/arm/mach-u300/Makefile
+++ b/arch/arm/mach-u300/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel, U300 machine.
 #
 
-obj-y				:= core.o clock.o timer.o padmux.o
+obj-y				:= core.o clock.o timer.o
 obj-$(CONFIG_ARCH_U300)	          += u300.o
 obj-$(CONFIG_MMC)                 += mmc.o
 obj-$(CONFIG_SPI_PL022)           += spi.o
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index ddb604c..5e88d9e 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -26,6 +26,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/fsmc.h>
 #include <linux/gpio/u300.h>
+#include <linux/pinmux.h>
 
 #include <asm/types.h>
 #include <asm/setup.h>
@@ -1536,6 +1537,14 @@ static struct coh901318_platform coh901318_platform = {
 	.max_channels = U300_DMA_CHANNELS,
 };
 
+static struct resource pinmux_resources[] = {
+	{
+		.start = U300_SYSCON_BASE,
+		.end   = U300_SYSCON_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
 static struct platform_device wdog_device = {
 	.name = "coh901327_wdog",
 	.id = -1,
@@ -1655,6 +1664,19 @@ static struct platform_device dma_device = {
 	},
 };
 
+static struct platform_device pinmux_device = {
+	.name = "pinmux-u300",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(pinmux_resources),
+	.resource = pinmux_resources,
+};
+
+/* Pinmux settings */
+static struct pinmux_map u300_pinmux_map[] = {
+	PINMUX_MAP("mmc0", "mmci"),
+	PINMUX_MAP("spi0", "pl022"),
+};
+
 /*
  * Notice that AMBA devices are initialized before platform devices.
  *
@@ -1668,10 +1690,10 @@ static struct platform_device *platform_devs[] __initdata = {
 	&gpio_device,
 	&nand_device,
 	&wdog_device,
-	&ave_device
+	&ave_device,
+	&pinmux_device,
 };
 
-
 /*
  * Interrupts: the U300 platforms have two pl190 ARM PrimeCells connected
  * together so some interrupts are connected to the first one and some
@@ -1853,6 +1875,10 @@ void __init u300_init_devices(void)
 
 	u300_assign_physmem();
 
+	/* Initialize pinmuxing */
+	pinmux_register_mappings(u300_pinmux_map,
+				 ARRAY_SIZE(u300_pinmux_map));
+
 	/* Register subdevices on the I2C buses */
 	u300_i2c_register_board_devices();
 
diff --git a/arch/arm/mach-u300/include/mach/pinmux.h b/arch/arm/mach-u300/include/mach/pinmux.h
new file mode 100644
index 0000000..e049895
--- /dev/null
+++ b/arch/arm/mach-u300/include/mach/pinmux.h
@@ -0,0 +1,2 @@
+/* This is the number of muxable pins on the DBxxxx SoCs */
+#define MACH_NR_PINS 467
diff --git a/arch/arm/mach-u300/include/mach/syscon.h b/arch/arm/mach-u300/include/mach/syscon.h
index 7444f5c..6e84f07 100644
--- a/arch/arm/mach-u300/include/mach/syscon.h
+++ b/arch/arm/mach-u300/include/mach/syscon.h
@@ -234,91 +234,6 @@
 #define U300_SYSCON_ECCR_EMIF_1_RET_OUT_CLK_EN_N_DISABLE	(0x0004)
 #define U300_SYSCON_ECCR_EMIF_MEMCLK_RET_EN_N_DISABLE		(0x0002)
 #define U300_SYSCON_ECCR_EMIF_SDRCLK_RET_EN_N_DISABLE		(0x0001)
-/* PAD MUX Control register 1 (LOW) 16bit (R/W) */
-#define U300_SYSCON_PMC1LR					(0x007C)
-#define U300_SYSCON_PMC1LR_MASK					(0xFFFF)
-#define U300_SYSCON_PMC1LR_CDI_MASK				(0xC000)
-#define U300_SYSCON_PMC1LR_CDI_CDI				(0x0000)
-#define U300_SYSCON_PMC1LR_CDI_EMIF				(0x4000)
-#ifdef CONFIG_MACH_U300_BS335
-#define U300_SYSCON_PMC1LR_CDI_CDI2				(0x8000)
-#define U300_SYSCON_PMC1LR_CDI_WCDMA_APP_GPIO			(0xC000)
-#elif CONFIG_MACH_U300_BS365
-#define U300_SYSCON_PMC1LR_CDI_GPIO				(0x8000)
-#define U300_SYSCON_PMC1LR_CDI_WCDMA				(0xC000)
-#endif
-#define U300_SYSCON_PMC1LR_PDI_MASK				(0x3000)
-#define U300_SYSCON_PMC1LR_PDI_PDI				(0x0000)
-#define U300_SYSCON_PMC1LR_PDI_EGG				(0x1000)
-#define U300_SYSCON_PMC1LR_PDI_WCDMA				(0x3000)
-#define U300_SYSCON_PMC1LR_MMCSD_MASK				(0x0C00)
-#define U300_SYSCON_PMC1LR_MMCSD_MMCSD				(0x0000)
-#define U300_SYSCON_PMC1LR_MMCSD_MSPRO				(0x0400)
-#define U300_SYSCON_PMC1LR_MMCSD_DSP				(0x0800)
-#define U300_SYSCON_PMC1LR_MMCSD_WCDMA				(0x0C00)
-#define U300_SYSCON_PMC1LR_ETM_MASK				(0x0300)
-#define U300_SYSCON_PMC1LR_ETM_ACC				(0x0000)
-#define U300_SYSCON_PMC1LR_ETM_APP				(0x0100)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS2_MASK			(0x00C0)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS2_STATIC			(0x0000)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS2_NFIF			(0x0040)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS2_SDRAM			(0x0080)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS2_STATIC_2GB		(0x00C0)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS1_MASK			(0x0030)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS1_STATIC			(0x0000)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS1_NFIF			(0x0010)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS1_SDRAM			(0x0020)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS1_SEMI			(0x0030)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS0_MASK			(0x000C)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS0_STATIC			(0x0000)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS0_NFIF			(0x0004)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS0_SDRAM			(0x0008)
-#define U300_SYSCON_PMC1LR_EMIF_1_CS0_SEMI			(0x000C)
-#define U300_SYSCON_PMC1LR_EMIF_1_MASK				(0x0003)
-#define U300_SYSCON_PMC1LR_EMIF_1_STATIC			(0x0000)
-#define U300_SYSCON_PMC1LR_EMIF_1_SDRAM0			(0x0001)
-#define U300_SYSCON_PMC1LR_EMIF_1_SDRAM1			(0x0002)
-#define U300_SYSCON_PMC1LR_EMIF_1				(0x0003)
-/* PAD MUX Control register 2 (HIGH) 16bit (R/W) */
-#define U300_SYSCON_PMC1HR					(0x007E)
-#define U300_SYSCON_PMC1HR_MASK					(0xFFFF)
-#define U300_SYSCON_PMC1HR_MISC_2_MASK				(0xC000)
-#define U300_SYSCON_PMC1HR_MISC_2_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC1HR_MISC_2_MSPRO				(0x4000)
-#define U300_SYSCON_PMC1HR_MISC_2_DSP				(0x8000)
-#define U300_SYSCON_PMC1HR_MISC_2_AAIF				(0xC000)
-#define U300_SYSCON_PMC1HR_APP_GPIO_2_MASK			(0x3000)
-#define U300_SYSCON_PMC1HR_APP_GPIO_2_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC1HR_APP_GPIO_2_NFIF			(0x1000)
-#define U300_SYSCON_PMC1HR_APP_GPIO_2_DSP			(0x2000)
-#define U300_SYSCON_PMC1HR_APP_GPIO_2_AAIF			(0x3000)
-#define U300_SYSCON_PMC1HR_APP_GPIO_1_MASK			(0x0C00)
-#define U300_SYSCON_PMC1HR_APP_GPIO_1_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC1HR_APP_GPIO_1_MMC			(0x0400)
-#define U300_SYSCON_PMC1HR_APP_GPIO_1_DSP			(0x0800)
-#define U300_SYSCON_PMC1HR_APP_GPIO_1_AAIF			(0x0C00)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_MASK			(0x0300)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_APP_GPIO		(0x0000)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_SPI			(0x0100)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_2_AAIF			(0x0300)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_MASK			(0x00C0)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_APP_GPIO		(0x0000)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_SPI			(0x0040)
-#define U300_SYSCON_PMC1HR_APP_SPI_CS_1_AAIF			(0x00C0)
-#define U300_SYSCON_PMC1HR_APP_SPI_2_MASK			(0x0030)
-#define U300_SYSCON_PMC1HR_APP_SPI_2_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC1HR_APP_SPI_2_SPI			(0x0010)
-#define U300_SYSCON_PMC1HR_APP_SPI_2_DSP			(0x0020)
-#define U300_SYSCON_PMC1HR_APP_SPI_2_AAIF			(0x0030)
-#define U300_SYSCON_PMC1HR_APP_UART0_2_MASK			(0x000C)
-#define U300_SYSCON_PMC1HR_APP_UART0_2_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC1HR_APP_UART0_2_UART0			(0x0004)
-#define U300_SYSCON_PMC1HR_APP_UART0_2_NFIF_CS			(0x0008)
-#define U300_SYSCON_PMC1HR_APP_UART0_2_AAIF			(0x000C)
-#define U300_SYSCON_PMC1HR_APP_UART0_1_MASK			(0x0003)
-#define U300_SYSCON_PMC1HR_APP_UART0_1_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC1HR_APP_UART0_1_UART0			(0x0001)
-#define U300_SYSCON_PMC1HR_APP_UART0_1_AAIF			(0x0003)
 /* Step one for killing the applications system 16bit (-/W) */
 #define U300_SYSCON_KA1R					(0x0080)
 #define U300_SYSCON_KA1R_MASK					(0xFFFF)
@@ -357,57 +272,6 @@
 #define U300_SYSCON_PUCR_EMIF_1_16BIT_PU_ENABLE			(0x0080)
 #define U300_SYSCON_PUCR_EMIF_1_8BIT_PU_ENABLE			(0x0040)
 #define U300_SYSCON_PUCR_KEY_IN_PU_EN_MASK			(0x003F)
-/* Padmux 2 control */
-#define U300_SYSCON_PMC2R					(0x100)
-#define U300_SYSCON_PMC2R_APP_MISC_0_MASK			(0x00C0)
-#define U300_SYSCON_PMC2R_APP_MISC_0_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC2R_APP_MISC_0_EMIF_SDRAM			(0x0040)
-#define U300_SYSCON_PMC2R_APP_MISC_0_MMC			(0x0080)
-#define U300_SYSCON_PMC2R_APP_MISC_0_CDI2			(0x00C0)
-#define U300_SYSCON_PMC2R_APP_MISC_1_MASK			(0x0300)
-#define U300_SYSCON_PMC2R_APP_MISC_1_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC2R_APP_MISC_1_EMIF_SDRAM			(0x0100)
-#define U300_SYSCON_PMC2R_APP_MISC_1_MMC			(0x0200)
-#define U300_SYSCON_PMC2R_APP_MISC_1_CDI2			(0x0300)
-#define U300_SYSCON_PMC2R_APP_MISC_2_MASK			(0x0C00)
-#define U300_SYSCON_PMC2R_APP_MISC_2_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC2R_APP_MISC_2_EMIF_SDRAM			(0x0400)
-#define U300_SYSCON_PMC2R_APP_MISC_2_MMC			(0x0800)
-#define U300_SYSCON_PMC2R_APP_MISC_2_CDI2			(0x0C00)
-#define U300_SYSCON_PMC2R_APP_MISC_3_MASK			(0x3000)
-#define U300_SYSCON_PMC2R_APP_MISC_3_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC2R_APP_MISC_3_EMIF_SDRAM			(0x1000)
-#define U300_SYSCON_PMC2R_APP_MISC_3_MMC			(0x2000)
-#define U300_SYSCON_PMC2R_APP_MISC_3_CDI2			(0x3000)
-#define U300_SYSCON_PMC2R_APP_MISC_4_MASK			(0xC000)
-#define U300_SYSCON_PMC2R_APP_MISC_4_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC2R_APP_MISC_4_EMIF_SDRAM			(0x4000)
-#define U300_SYSCON_PMC2R_APP_MISC_4_MMC			(0x8000)
-#define U300_SYSCON_PMC2R_APP_MISC_4_ACC_GPIO			(0xC000)
-/* TODO: More SYSCON registers missing */
-#define U300_SYSCON_PMC3R					(0x10c)
-#define U300_SYSCON_PMC3R_APP_MISC_11_MASK			(0xc000)
-#define U300_SYSCON_PMC3R_APP_MISC_11_SPI			(0x4000)
-#define U300_SYSCON_PMC3R_APP_MISC_10_MASK			(0x3000)
-#define U300_SYSCON_PMC3R_APP_MISC_10_SPI			(0x1000)
-/* TODO: Missing other configs */
-#define U300_SYSCON_PMC4R					(0x168)
-#define U300_SYSCON_PMC4R_APP_MISC_12_MASK			(0x0003)
-#define U300_SYSCON_PMC4R_APP_MISC_12_APP_GPIO			(0x0000)
-#define U300_SYSCON_PMC4R_APP_MISC_13_MASK			(0x000C)
-#define U300_SYSCON_PMC4R_APP_MISC_13_CDI			(0x0000)
-#define U300_SYSCON_PMC4R_APP_MISC_13_SMIA			(0x0004)
-#define U300_SYSCON_PMC4R_APP_MISC_13_SMIA2			(0x0008)
-#define U300_SYSCON_PMC4R_APP_MISC_13_APP_GPIO			(0x000C)
-#define U300_SYSCON_PMC4R_APP_MISC_14_MASK			(0x0030)
-#define U300_SYSCON_PMC4R_APP_MISC_14_CDI			(0x0000)
-#define U300_SYSCON_PMC4R_APP_MISC_14_SMIA			(0x0010)
-#define U300_SYSCON_PMC4R_APP_MISC_14_CDI2			(0x0020)
-#define U300_SYSCON_PMC4R_APP_MISC_14_APP_GPIO			(0x0030)
-#define U300_SYSCON_PMC4R_APP_MISC_16_MASK			(0x0300)
-#define U300_SYSCON_PMC4R_APP_MISC_16_APP_GPIO_13		(0x0000)
-#define U300_SYSCON_PMC4R_APP_MISC_16_APP_UART1_CTS		(0x0100)
-#define U300_SYSCON_PMC4R_APP_MISC_16_EMIF_1_STATIC_CS5_N	(0x0200)
 /* SYS_0_CLK_CONTROL first clock control 16bit (R/W) */
 #define U300_SYSCON_S0CCR					(0x120)
 #define U300_SYSCON_S0CCR_FIELD_MASK				(0x43FF)
diff --git a/arch/arm/mach-u300/mmc.c b/arch/arm/mach-u300/mmc.c
index 677ccef..d5e4a98 100644
--- a/arch/arm/mach-u300/mmc.c
+++ b/arch/arm/mach-u300/mmc.c
@@ -21,7 +21,6 @@
 #include <mach/dma_channels.h>
 
 #include "mmc.h"
-#include "padmux.h"
 
 static struct mmci_platform_data mmc0_plat_data = {
 	/*
@@ -45,24 +44,9 @@ static struct mmci_platform_data mmc0_plat_data = {
 int __devinit mmc_init(struct amba_device *adev)
 {
 	struct device *mmcsd_device = &adev->dev;
-	struct pmx *pmx;
 	int ret = 0;
 
 	mmcsd_device->platform_data = &mmc0_plat_data;
 
-	/*
-	 * Setup padmuxing for MMC. Since this must always be
-	 * compiled into the kernel, pmx is never released.
-	 */
-	pmx = pmx_get(mmcsd_device, U300_APP_PMX_MMC_SETTING);
-
-	if (IS_ERR(pmx))
-		pr_warning("Could not get padmux handle\n");
-	else {
-		ret = pmx_activate(mmcsd_device, pmx);
-		if (IS_ERR_VALUE(ret))
-			pr_warning("Could not activate padmuxing\n");
-	}
-
 	return ret;
 }
diff --git a/arch/arm/mach-u300/padmux.c b/arch/arm/mach-u300/padmux.c
deleted file mode 100644
index 4c93c6c..0000000
--- a/arch/arm/mach-u300/padmux.c
+++ /dev/null
@@ -1,367 +0,0 @@
-/*
- *
- * arch/arm/mach-u300/padmux.c
- *
- *
- * Copyright (C) 2009 ST-Ericsson AB
- * License terms: GNU General Public License (GPL) version 2
- * U300 PADMUX functions
- * Author: Martin Persson <martin.persson@stericsson.com>
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/errno.h>
-#include <linux/io.h>
-#include <linux/mutex.h>
-#include <linux/string.h>
-#include <linux/bug.h>
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
-#include <mach/u300-regs.h>
-#include <mach/syscon.h>
-#include "padmux.h"
-
-static DEFINE_MUTEX(pmx_mutex);
-
-const u32 pmx_registers[] = {
-	(U300_SYSCON_VBASE + U300_SYSCON_PMC1LR),
-	(U300_SYSCON_VBASE + U300_SYSCON_PMC1HR),
-	(U300_SYSCON_VBASE + U300_SYSCON_PMC2R),
-	(U300_SYSCON_VBASE + U300_SYSCON_PMC3R),
-	(U300_SYSCON_VBASE + U300_SYSCON_PMC4R)
-};
-
-/* High level functionality */
-
-/* Lazy dog:
- * onmask = {
- *   {"PMC1LR" mask, "PMC1LR" value},
- *   {"PMC1HR" mask, "PMC1HR" value},
- *   {"PMC2R"  mask, "PMC2R"  value},
- *   {"PMC3R"  mask, "PMC3R"  value},
- *   {"PMC4R"  mask, "PMC4R"  value}
- * }
- */
-static struct pmx mmc_setting = {
-	.setting = U300_APP_PMX_MMC_SETTING,
-	.default_on = false,
-	.activated = false,
-	.name = "MMC",
-	.onmask = {
-		   {U300_SYSCON_PMC1LR_MMCSD_MASK,
-		    U300_SYSCON_PMC1LR_MMCSD_MMCSD},
-		   {0, 0},
-		   {0, 0},
-		   {0, 0},
-		   {U300_SYSCON_PMC4R_APP_MISC_12_MASK,
-		    U300_SYSCON_PMC4R_APP_MISC_12_APP_GPIO}
-		   },
-};
-
-static struct pmx spi_setting = {
-	.setting = U300_APP_PMX_SPI_SETTING,
-	.default_on = false,
-	.activated = false,
-	.name = "SPI",
-	.onmask = {{0, 0},
-		   {U300_SYSCON_PMC1HR_APP_SPI_2_MASK |
-		    U300_SYSCON_PMC1HR_APP_SPI_CS_1_MASK |
-		    U300_SYSCON_PMC1HR_APP_SPI_CS_2_MASK,
-		    U300_SYSCON_PMC1HR_APP_SPI_2_SPI |
-		    U300_SYSCON_PMC1HR_APP_SPI_CS_1_SPI |
-		    U300_SYSCON_PMC1HR_APP_SPI_CS_2_SPI},
-		   {0, 0},
-		   {0, 0},
-		   {0, 0}
-		   },
-};
-
-/* Available padmux settings */
-static struct pmx *pmx_settings[] = {
-	&mmc_setting,
-	&spi_setting,
-};
-
-static void update_registers(struct pmx *pmx, bool activate)
-{
-	u16 regval, val, mask;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(pmx_registers); i++) {
-		if (activate)
-			val = pmx->onmask[i].val;
-		else
-			val = 0;
-
-		mask = pmx->onmask[i].mask;
-		if (mask != 0) {
-			regval = readw(pmx_registers[i]);
-			regval &= ~mask;
-			regval |= val;
-			writew(regval, pmx_registers[i]);
-		}
-	}
-}
-
-struct pmx *pmx_get(struct device *dev, enum pmx_settings setting)
-{
-	int i;
-	struct pmx *pmx = ERR_PTR(-ENOENT);
-
-	if (dev == NULL)
-		return ERR_PTR(-EINVAL);
-
-	mutex_lock(&pmx_mutex);
-	for (i = 0; i < ARRAY_SIZE(pmx_settings); i++) {
-
-		if (setting == pmx_settings[i]->setting) {
-
-			if (pmx_settings[i]->dev != NULL) {
-				WARN(1, "padmux: required setting "
-				     "in use by another consumer\n");
-			} else {
-				pmx = pmx_settings[i];
-				pmx->dev = dev;
-				dev_dbg(dev, "padmux: setting nr %d is now "
-					"bound to %s and ready to use\n",
-					setting, dev_name(dev));
-				break;
-			}
-		}
-	}
-	mutex_unlock(&pmx_mutex);
-
-	return pmx;
-}
-EXPORT_SYMBOL(pmx_get);
-
-int pmx_put(struct device *dev, struct pmx *pmx)
-{
-	int i;
-	int ret = -ENOENT;
-
-	if (pmx == NULL || dev == NULL)
-		return -EINVAL;
-
-	mutex_lock(&pmx_mutex);
-	for (i = 0; i < ARRAY_SIZE(pmx_settings); i++) {
-
-		if (pmx->setting == pmx_settings[i]->setting) {
-
-			if (dev != pmx->dev) {
-				WARN(1, "padmux: cannot release handle as "
-					"it is bound to another consumer\n");
-				ret = -EINVAL;
-				break;
-			} else {
-				pmx_settings[i]->dev = NULL;
-				ret = 0;
-				break;
-			}
-		}
-	}
-	mutex_unlock(&pmx_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(pmx_put);
-
-int pmx_activate(struct device *dev, struct pmx *pmx)
-{
-	int i, j, ret;
-	ret = 0;
-
-	if (pmx == NULL || dev == NULL)
-		return -EINVAL;
-
-	mutex_lock(&pmx_mutex);
-
-	/* Make sure the required bits are not used */
-	for (i = 0; i < ARRAY_SIZE(pmx_settings); i++) {
-
-		if (pmx_settings[i]->dev == NULL || pmx_settings[i] == pmx)
-			continue;
-
-		for (j = 0; j < ARRAY_SIZE(pmx_registers); j++) {
-
-			if (pmx_settings[i]->onmask[j].mask & pmx->
-				onmask[j].mask) {
-				/* More than one entry on the same bits */
-				WARN(1, "padmux: cannot activate "
-					"setting. Bit conflict with "
-					"an active setting\n");
-
-				ret = -EUSERS;
-				goto exit;
-			}
-		}
-	}
-	update_registers(pmx, true);
-	pmx->activated = true;
-	dev_dbg(dev, "padmux: setting nr %d is activated\n",
-		pmx->setting);
-
-exit:
-	mutex_unlock(&pmx_mutex);
-	return ret;
-}
-EXPORT_SYMBOL(pmx_activate);
-
-int pmx_deactivate(struct device *dev, struct pmx *pmx)
-{
-	int i;
-	int ret = -ENOENT;
-
-	if (pmx == NULL || dev == NULL)
-		return -EINVAL;
-
-	mutex_lock(&pmx_mutex);
-	for (i = 0; i < ARRAY_SIZE(pmx_settings); i++) {
-
-		if (pmx_settings[i]->dev == NULL)
-			continue;
-
-		if (pmx->setting == pmx_settings[i]->setting) {
-
-			if (dev != pmx->dev) {
-				WARN(1, "padmux: cannot deactivate "
-				     "pmx setting as it was activated "
-				     "by another consumer\n");
-
-				ret = -EBUSY;
-				continue;
-			} else {
-				update_registers(pmx, false);
-				pmx_settings[i]->dev = NULL;
-				pmx->activated = false;
-				ret = 0;
-				dev_dbg(dev, "padmux: setting nr %d is deactivated",
-					pmx->setting);
-				break;
-			}
-		}
-	}
-	mutex_unlock(&pmx_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(pmx_deactivate);
-
-/*
- * For internal use only. If it is to be exported,
- * it should be reentrant. Notice that pmx_activate
- * (i.e. runtime settings) always override default settings.
- */
-static int pmx_set_default(void)
-{
-	/* Used to identify several entries on the same bits */
-	u16 modbits[ARRAY_SIZE(pmx_registers)];
-
-	int i, j;
-
-	memset(modbits, 0, ARRAY_SIZE(pmx_registers) * sizeof(u16));
-
-	for (i = 0; i < ARRAY_SIZE(pmx_settings); i++) {
-
-		if (!pmx_settings[i]->default_on)
-			continue;
-
-		for (j = 0; j < ARRAY_SIZE(pmx_registers); j++) {
-
-			/* Make sure there is only one entry on the same bits */
-			if (modbits[j] & pmx_settings[i]->onmask[j].mask) {
-				BUG();
-				return -EUSERS;
-			}
-			modbits[j] |= pmx_settings[i]->onmask[j].mask;
-		}
-		update_registers(pmx_settings[i], true);
-	}
-	return 0;
-}
-
-#if (defined(CONFIG_DEBUG_FS) && defined(CONFIG_U300_DEBUG))
-static int pmx_show(struct seq_file *s, void *data)
-{
-	int i;
-	seq_printf(s, "-------------------------------------------------\n");
-	seq_printf(s, "SETTING     BOUND TO DEVICE               STATE\n");
-	seq_printf(s, "-------------------------------------------------\n");
-	mutex_lock(&pmx_mutex);
-	for (i = 0; i < ARRAY_SIZE(pmx_settings); i++) {
-		/* Format pmx and device name nicely */
-		char cdp[33];
-		int chars;
-
-		chars = snprintf(&cdp[0], 17, "%s", pmx_settings[i]->name);
-		while (chars < 16) {
-			cdp[chars] = ' ';
-			chars++;
-		}
-		chars = snprintf(&cdp[16], 17, "%s", pmx_settings[i]->dev ?
-				dev_name(pmx_settings[i]->dev) : "N/A");
-		while (chars < 16) {
-			cdp[chars+16] = ' ';
-			chars++;
-		}
-		cdp[32] = '\0';
-
-		seq_printf(s,
-			"%s\t%s\n",
-			&cdp[0],
-			pmx_settings[i]->activated ?
-			"ACTIVATED" : "DEACTIVATED"
-			);
-
-	}
-	mutex_unlock(&pmx_mutex);
-	return 0;
-}
-
-static int pmx_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pmx_show, NULL);
-}
-
-static const struct file_operations pmx_operations = {
-	.owner		= THIS_MODULE,
-	.open		= pmx_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __init init_pmx_read_debugfs(void)
-{
-	/* Expose a simple debugfs interface to view pmx settings */
-	(void) debugfs_create_file("padmux", S_IFREG | S_IRUGO,
-				   NULL, NULL,
-				   &pmx_operations);
-	return 0;
-}
-
-/*
- * This needs to come in after the core_initcall(),
- * because debugfs is not available until
- * the subsystems come up.
- */
-module_init(init_pmx_read_debugfs);
-#endif
-
-static int __init pmx_init(void)
-{
-	int ret;
-
-	ret = pmx_set_default();
-
-	if (IS_ERR_VALUE(ret))
-		pr_crit("padmux: default settings could not be set\n");
-
-	return 0;
-}
-
-/* Should be initialized before consumers */
-core_initcall(pmx_init);
diff --git a/arch/arm/mach-u300/padmux.h b/arch/arm/mach-u300/padmux.h
deleted file mode 100644
index 6e8b860..0000000
--- a/arch/arm/mach-u300/padmux.h
+++ /dev/null
@@ -1,39 +0,0 @@
-/*
- *
- * arch/arm/mach-u300/padmux.h
- *
- *
- * Copyright (C) 2009 ST-Ericsson AB
- * License terms: GNU General Public License (GPL) version 2
- * U300 PADMUX API
- * Author: Martin Persson <martin.persson@stericsson.com>
- */
-
-#ifndef __MACH_U300_PADMUX_H
-#define __MACH_U300_PADMUX_H
-
-enum pmx_settings {
-	U300_APP_PMX_MMC_SETTING,
-	U300_APP_PMX_SPI_SETTING
-};
-
-struct pmx_onmask {
-	u16 mask;		/* Mask bits */
-	u16 val;		/* Value when active */
-};
-
-struct pmx {
-	struct device *dev;
-	enum pmx_settings setting;
-	char *name;
-	bool activated;
-	bool default_on;
-	struct pmx_onmask onmask[];
-};
-
-struct pmx *pmx_get(struct device *dev, enum pmx_settings setting);
-int pmx_put(struct device *dev, struct pmx *pmx);
-int pmx_activate(struct device *dev, struct pmx *pmx);
-int pmx_deactivate(struct device *dev, struct pmx *pmx);
-
-#endif
diff --git a/arch/arm/mach-u300/spi.c b/arch/arm/mach-u300/spi.c
index 5767208..628e785 100644
--- a/arch/arm/mach-u300/spi.c
+++ b/arch/arm/mach-u300/spi.c
@@ -14,8 +14,6 @@
 #include <mach/coh901318.h>
 #include <mach/dma_channels.h>
 
-#include "padmux.h"
-
 /*
  * The following is for the actual devices on the SSP/SPI bus
  */
@@ -95,25 +93,7 @@ static struct pl022_ssp_controller ssp_platform_data = {
 
 void __init u300_spi_init(struct amba_device *adev)
 {
-	struct pmx *pmx;
-
 	adev->dev.platform_data = &ssp_platform_data;
-	/*
-	 * Setup padmuxing for SPI. Since this must always be
-	 * compiled into the kernel, pmx is never released.
-	 */
-	pmx = pmx_get(&adev->dev, U300_APP_PMX_SPI_SETTING);
-
-	if (IS_ERR(pmx))
-		dev_warn(&adev->dev, "Could not get padmux handle\n");
-	else {
-		int ret;
-
-		ret = pmx_activate(&adev->dev, pmx);
-		if (IS_ERR_VALUE(ret))
-			dev_warn(&adev->dev, "Could not activate padmuxing\n");
-	}
-
 }
 
 void __init u300_spi_register_board_devices(void)
-- 
1.7.3.2

