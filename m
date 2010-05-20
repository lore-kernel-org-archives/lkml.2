Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248Ab0ETHtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:49:09 -0400
Received: from mail.df.lth.se ([194.47.250.12]:63508 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751182Ab0ETHtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:49:07 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
       STEricsson_nomadik_linux@list.st.com
Subject: [PATCH] DMAENGINE: DMA40 U8500 platform configuration
Date: Thu, 20 May 2010 09:49:19 +0200
Message-Id: <1274341759-13086-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This completes the DMA40 support with the platform-specific
configuration for U8500/DB8500.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Reviewed-by: Alessandro Rubini <rubini@unipv.it>
Cc: STEricsson_nomadik_linux@list.st.com
---
Dan, now that Russells depending patches from the ARM tree have
been merged to Linus' (Torvalds) tree, do you think it's possible
to also push this DMA40 platform data through the async_tx tree?
This is the final version of it.
---
 arch/arm/mach-ux500/clock.c                    |    2 +-
 arch/arm/mach-ux500/cpu-db8500.c               |    4 +
 arch/arm/mach-ux500/devices-db8500.c           |  219 ++++++++++++++++++++++++
 arch/arm/mach-ux500/include/mach/db8500-regs.h |   12 ++
 arch/arm/mach-ux500/include/mach/devices.h     |    3 +
 arch/arm/mach-ux500/ste-dma40-db8500.h         |  154 +++++++++++++++++
 6 files changed, 393 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/mach-ux500/ste-dma40-db8500.h

diff --git a/arch/arm/mach-ux500/clock.c b/arch/arm/mach-ux500/clock.c
index 1b2c989..6544855 100644
--- a/arch/arm/mach-ux500/clock.c
+++ b/arch/arm/mach-ux500/clock.c
@@ -411,7 +411,7 @@ static struct clk_lookup u8500_common_clks[] = {
 	CLK(apetraceclk,	"apetrace",	NULL),
 	CLK(mcdeclk,	"mcde",		NULL),
 	CLK(ipi2clk,	"ipi2",		NULL),
-	CLK(dmaclk,	"dma40",	NULL),
+	CLK(dmaclk,	"dma40.0",	NULL),
 	CLK(b2r2clk,	"b2r2",		NULL),
 	CLK(tvclk,	"tv",		NULL),
 };
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index d04299f..f21c444 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -32,6 +32,7 @@ static struct platform_device *platform_devs[] __initdata = {
 	&u8500_gpio_devs[6],
 	&u8500_gpio_devs[7],
 	&u8500_gpio_devs[8],
+	&u8500_dma40_device,
 };
 
 /* minimum static i/o mapping required to boot U8500 platforms */
@@ -71,6 +72,9 @@ void __init u8500_init_devices(void)
 {
 	ux500_init_devices();
 
+	if (cpu_is_u8500ed())
+		dma40_u8500ed_fixup();
+
 	/* Register the platform devices */
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 2033423..7dca01f 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -12,9 +12,13 @@
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 
+#include <plat/ste_dma40.h>
+
 #include <mach/hardware.h>
 #include <mach/setup.h>
 
+#include "ste-dma40-db8500.h"
+
 static struct nmk_gpio_platform_data u8500_gpio_data[] = {
 	GPIO_DATA("GPIO-0-31", 0),
 	GPIO_DATA("GPIO-32-63", 32), /* 37..63 not routed to pin */
@@ -105,3 +109,218 @@ struct platform_device u8500_i2c4_device = {
 	.resource	= u8500_i2c4_resources,
 	.num_resources	= ARRAY_SIZE(u8500_i2c4_resources),
 };
+
+static struct resource dma40_resources[] = {
+	[0] = {
+		.start = U8500_DMA_BASE,
+		.end = U8500_DMA_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "base",
+	},
+	[1] = {
+		.start = U8500_DMA_LCPA_BASE,
+		.end = U8500_DMA_LCPA_BASE + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "lcpa",
+	},
+	[2] = {
+		.start = U8500_DMA_LCLA_BASE,
+		.end = U8500_DMA_LCLA_BASE + 16 * 1024 - 1,
+		.flags = IORESOURCE_MEM,
+		.name = "lcla",
+	},
+	[3] = {
+		.start = IRQ_DMA,
+		.end = IRQ_DMA,
+		.flags = IORESOURCE_IRQ}
+};
+
+/* Default configuration for physcial memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
+	.channel_type = (STEDMA40_CHANNEL_IN_PHY_MODE |
+			 STEDMA40_LOW_PRIORITY_CHANNEL |
+			 STEDMA40_PCHAN_BASIC_MODE),
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_PHY_1,
+
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
+
+};
+/* Default configuration for logical memcpy */
+struct stedma40_chan_cfg dma40_memcpy_conf_log = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE |
+			 STEDMA40_LOW_PRIORITY_CHANNEL |
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG |
+			 STEDMA40_NO_TIM_FOR_LINK),
+	.dir = STEDMA40_MEM_TO_MEM,
+
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.psize = STEDMA40_PSIZE_LOG_1,
+
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
+
+};
+
+/*
+ * Mapping between destination event lines and physical device address.
+ * The event line is tied to a device and therefor the address is constant.
+ */
+const static dma_addr_t dma40_tx_map[STEDMA40_NR_DEV] = {
+	[STEDMA40_DEV_SPI0_TX] = 0,
+	[STEDMA40_DEV_SD_MMC0_TX] = 0,
+	[STEDMA40_DEV_SD_MMC1_TX] = 0,
+	[STEDMA40_DEV_SD_MMC2_TX] = 0,
+	[STEDMA40_DEV_I2C1_TX] = 0,
+	[STEDMA40_DEV_I2C3_TX] = 0,
+	[STEDMA40_DEV_I2C2_TX] = 0,
+	[STEDMA40_DEV_SSP0_TX] = 0,
+	[STEDMA40_DEV_SSP1_TX] = 0,
+	[STEDMA40_DEV_UART2_TX] = 0,
+	[STEDMA40_DEV_UART1_TX] = 0,
+	[STEDMA40_DEV_UART0_TX] = 0,
+	[STEDMA40_DEV_MSP2_TX] = 0,
+	[STEDMA40_DEV_I2C0_TX] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_8] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_1_9] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_2_10] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_3_11] = 0,
+	[STEDMA40_DEV_SLIM0_CH0_TX_HSI_TX_CH0] = 0,
+	[STEDMA40_DEV_SLIM0_CH1_TX_HSI_TX_CH1] = 0,
+	[STEDMA40_DEV_SLIM0_CH2_TX_HSI_TX_CH2] = 0,
+	[STEDMA40_DEV_SLIM0_CH3_TX_HSI_TX_CH3] = 0,
+	[STEDMA40_DEV_DST_SXA0_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA1_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA2_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA3_RX_TX] = 0,
+	[STEDMA40_DEV_SD_MM2_TX] = 0,
+	[STEDMA40_DEV_SD_MM0_TX] = 0,
+	[STEDMA40_DEV_MSP1_TX] = 0,
+	[STEDMA40_SLIM0_CH0_TX] = 0,
+	[STEDMA40_DEV_MSP0_TX] = 0,
+	[STEDMA40_DEV_SD_MM1_TX] = 0,
+	[STEDMA40_DEV_SPI2_TX] = 0,
+	[STEDMA40_DEV_I2C3_TX2] = 0,
+	[STEDMA40_DEV_SPI1_TX] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_4_12] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_5_13] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_6_14] = 0,
+	[STEDMA40_DEV_USB_OTG_OEP_7_15] = 0,
+	[STEDMA40_DEV_SPI3_TX] = 0,
+	[STEDMA40_DEV_SD_MM3_TX] = 0,
+	[STEDMA40_DEV_SD_MM4_TX] = 0,
+	[STEDMA40_DEV_SD_MM5_TX] = 0,
+	[STEDMA40_DEV_DST_SXA4_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA5_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA6_RX_TX] = 0,
+	[STEDMA40_DEV_DST_SXA7_RX_TX] = 0,
+	[STEDMA40_DEV_CAC1_TX] = 0,
+	[STEDMA40_DEV_CAC1_TX_HAC1_TX] = 0,
+	[STEDMA40_DEV_HAC1_TX] = 0,
+	[STEDMA40_DEV_CAC0_TX] = 0,
+	[STEDMA40_DEV_CAC0_TX_HAC0_TX] = 0,
+	[STEDMA40_DEV_HAC0_TX] = 0,
+};
+
+/* Mapping between source event lines and physical device address */
+const static dma_addr_t dma40_rx_map[STEDMA40_NR_DEV] = {
+	[STEDMA40_DEV_SPI0_RX] = 0,
+	[STEDMA40_DEV_SD_MMC0_RX] = 0,
+	[STEDMA40_DEV_SD_MMC1_RX] = 0,
+	[STEDMA40_DEV_SD_MMC2_RX] = 0,
+	[STEDMA40_DEV_I2C1_RX] = 0,
+	[STEDMA40_DEV_I2C3_RX] = 0,
+	[STEDMA40_DEV_I2C2_RX] = 0,
+	[STEDMA40_DEV_SSP0_RX] = 0,
+	[STEDMA40_DEV_SSP1_RX] = 0,
+	[STEDMA40_DEV_MCDE_RX] = 0,
+	[STEDMA40_DEV_UART2_RX] = 0,
+	[STEDMA40_DEV_UART1_RX] = 0,
+	[STEDMA40_DEV_UART0_RX] = 0,
+	[STEDMA40_DEV_MSP2_RX] = 0,
+	[STEDMA40_DEV_I2C0_RX] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_8] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_1_9] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_2_10] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_3_11] = 0,
+	[STEDMA40_DEV_SLIM0_CH0_RX_HSI_RX_CH0] = 0,
+	[STEDMA40_DEV_SLIM0_CH1_RX_HSI_RX_CH1] = 0,
+	[STEDMA40_DEV_SLIM0_CH2_RX_HSI_RX_CH2] = 0,
+	[STEDMA40_DEV_SLIM0_CH3_RX_HSI_RX_CH3] = 0,
+	[STEDMA40_DEV_SRC_SXA0_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA1_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA2_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA3_RX_TX] = 0,
+	[STEDMA40_DEV_SD_MM2_RX] = 0,
+	[STEDMA40_DEV_SD_MM0_RX] = 0,
+	[STEDMA40_DEV_MSP1_RX] = 0,
+	[STEDMA40_SLIM0_CH0_RX] = 0,
+	[STEDMA40_DEV_MSP0_RX] = 0,
+	[STEDMA40_DEV_SD_MM1_RX] = 0,
+	[STEDMA40_DEV_SPI2_RX] = 0,
+	[STEDMA40_DEV_I2C3_RX2] = 0,
+	[STEDMA40_DEV_SPI1_RX] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_4_12] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_5_13] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_6_14] = 0,
+	[STEDMA40_DEV_USB_OTG_IEP_7_15] = 0,
+	[STEDMA40_DEV_SPI3_RX] = 0,
+	[STEDMA40_DEV_SD_MM3_RX] = 0,
+	[STEDMA40_DEV_SD_MM4_RX] = 0,
+	[STEDMA40_DEV_SD_MM5_RX] = 0,
+	[STEDMA40_DEV_SRC_SXA4_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA5_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA6_RX_TX] = 0,
+	[STEDMA40_DEV_SRC_SXA7_RX_TX] = 0,
+	[STEDMA40_DEV_CAC1_RX] = 0,
+	[STEDMA40_DEV_MSHC_RX] = 0,
+	[STEDMA40_DEV_SLIM1_CH0_RX_HSI_RX_CH4] = 0,
+	[STEDMA40_DEV_SLIM1_CH1_RX_HSI_RX_CH5] = 0,
+	[STEDMA40_DEV_SLIM1_CH2_RX_HSI_RX_CH6] = 0,
+	[STEDMA40_DEV_SLIM1_CH3_RX_HSI_RX_CH7] = 0,
+	[STEDMA40_DEV_CAC0_RX] = 0,
+};
+
+/* Reserved event lines for memcpy only */
+static int dma40_memcpy_event[] = {
+	STEDMA40_MEMCPY_TX_1,
+	STEDMA40_MEMCPY_TX_2,
+	STEDMA40_MEMCPY_TX_3,
+	STEDMA40_MEMCPY_TX_4,
+};
+
+static struct stedma40_platform_data dma40_plat_data = {
+	.dev_len = STEDMA40_NR_DEV,
+	.dev_rx = dma40_rx_map,
+	.dev_tx = dma40_tx_map,
+	.memcpy = dma40_memcpy_event,
+	.memcpy_len = ARRAY_SIZE(dma40_memcpy_event),
+	.memcpy_conf_phy = &dma40_memcpy_conf_phy,
+	.memcpy_conf_log = &dma40_memcpy_conf_log,
+	.llis_per_log = 8,
+};
+
+struct platform_device u8500_dma40_device = {
+	.dev = {
+		.platform_data = &dma40_plat_data,
+	},
+	.name = "dma40",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(dma40_resources),
+	.resource = dma40_resources
+};
+
+void dma40_u8500ed_fixup(void)
+{
+	dma40_plat_data.memcpy = NULL;
+	dma40_plat_data.memcpy_len = 0;
+	dma40_resources[0].start = U8500_DMA_BASE_ED;
+	dma40_resources[0].end = U8500_DMA_BASE_ED + SZ_4K - 1;
+}
diff --git a/arch/arm/mach-ux500/include/mach/db8500-regs.h b/arch/arm/mach-ux500/include/mach/db8500-regs.h
index 9169e1e..85fc6a8 100644
--- a/arch/arm/mach-ux500/include/mach/db8500-regs.h
+++ b/arch/arm/mach-ux500/include/mach/db8500-regs.h
@@ -7,6 +7,18 @@
 #ifndef __MACH_DB8500_REGS_H
 #define __MACH_DB8500_REGS_H
 
+/* Base address and bank offsets for ESRAM */
+#define U8500_ESRAM_BASE	0x40000000
+#define U8500_ESRAM_BANK_SIZE	0x00020000
+#define U8500_ESRAM_BANK0	U8500_ESRAM_BASE
+#define U8500_ESRAM_BANK1	(U8500_ESRAM_BASE + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK2	(U8500_ESRAM_BANK1 + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK3	(U8500_ESRAM_BANK2 + U8500_ESRAM_BANK_SIZE)
+#define U8500_ESRAM_BANK4	(U8500_ESRAM_BANK3 + U8500_ESRAM_BANK_SIZE)
+/* Use bank 4 for DMA LCLA and LCPA */
+#define U8500_DMA_LCLA_BASE	U8500_ESRAM_BANK4
+#define U8500_DMA_LCPA_BASE	(U8500_ESRAM_BANK4 + 0x4000)
+
 #define U8500_PER3_BASE		0x80000000
 #define U8500_STM_BASE		0x80100000
 #define U8500_STM_REG_BASE	(U8500_STM_BASE + 0xF000)
diff --git a/arch/arm/mach-ux500/include/mach/devices.h b/arch/arm/mach-ux500/include/mach/devices.h
index 0422af0..c2b2f25 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -25,5 +25,8 @@ extern struct platform_device ux500_i2c3_device;
 
 extern struct platform_device u8500_i2c0_device;
 extern struct platform_device u8500_i2c4_device;
+extern struct platform_device u8500_dma40_device;
+
+void dma40_u8500ed_fixup(void);
 
 #endif
diff --git a/arch/arm/mach-ux500/ste-dma40-db8500.h b/arch/arm/mach-ux500/ste-dma40-db8500.h
new file mode 100644
index 0000000..e701627
--- /dev/null
+++ b/arch/arm/mach-ux500/ste-dma40-db8500.h
@@ -0,0 +1,154 @@
+/*
+ * arch/arm/mach-ux500/ste_dma40_db8500.h
+ * DB8500-SoC-specific configuration for DMA40
+ *
+ * Copyright (C) ST-Ericsson 2007-2010
+ * License terms: GNU General Public License (GPL) version 2
+ * Author: Per Friden <per.friden@stericsson.com>
+ * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
+ */
+#ifndef STE_DMA40_DB8500_H
+#define STE_DMA40_DB8500_H
+
+#define STEDMA40_NR_DEV 64
+
+enum dma_src_dev_type {
+	STEDMA40_DEV_SPI0_RX = 0,
+	STEDMA40_DEV_SD_MMC0_RX = 1,
+	STEDMA40_DEV_SD_MMC1_RX = 2,
+	STEDMA40_DEV_SD_MMC2_RX = 3,
+	STEDMA40_DEV_I2C1_RX = 4,
+	STEDMA40_DEV_I2C3_RX = 5,
+	STEDMA40_DEV_I2C2_RX = 6,
+	STEDMA40_DEV_I2C4_RX = 7, /* Only on V1 */
+	STEDMA40_DEV_SSP0_RX = 8,
+	STEDMA40_DEV_SSP1_RX = 9,
+	STEDMA40_DEV_MCDE_RX = 10,
+	STEDMA40_DEV_UART2_RX = 11,
+	STEDMA40_DEV_UART1_RX = 12,
+	STEDMA40_DEV_UART0_RX = 13,
+	STEDMA40_DEV_MSP2_RX = 14,
+	STEDMA40_DEV_I2C0_RX = 15,
+	STEDMA40_DEV_USB_OTG_IEP_8 = 16,
+	STEDMA40_DEV_USB_OTG_IEP_1_9 = 17,
+	STEDMA40_DEV_USB_OTG_IEP_2_10 = 18,
+	STEDMA40_DEV_USB_OTG_IEP_3_11 = 19,
+	STEDMA40_DEV_SLIM0_CH0_RX_HSI_RX_CH0 = 20,
+	STEDMA40_DEV_SLIM0_CH1_RX_HSI_RX_CH1 = 21,
+	STEDMA40_DEV_SLIM0_CH2_RX_HSI_RX_CH2 = 22,
+	STEDMA40_DEV_SLIM0_CH3_RX_HSI_RX_CH3 = 23,
+	STEDMA40_DEV_SRC_SXA0_RX_TX = 24,
+	STEDMA40_DEV_SRC_SXA1_RX_TX = 25,
+	STEDMA40_DEV_SRC_SXA2_RX_TX = 26,
+	STEDMA40_DEV_SRC_SXA3_RX_TX = 27,
+	STEDMA40_DEV_SD_MM2_RX = 28,
+	STEDMA40_DEV_SD_MM0_RX = 29,
+	STEDMA40_DEV_MSP1_RX = 30,
+	/*
+	 * This channel is either SlimBus or MSP,
+	 * never both at the same time.
+	 */
+	STEDMA40_SLIM0_CH0_RX = 31,
+	STEDMA40_DEV_MSP0_RX = 31,
+	STEDMA40_DEV_SD_MM1_RX = 32,
+	STEDMA40_DEV_SPI2_RX = 33,
+	STEDMA40_DEV_I2C3_RX2 = 34,
+	STEDMA40_DEV_SPI1_RX = 35,
+	STEDMA40_DEV_USB_OTG_IEP_4_12 = 36,
+	STEDMA40_DEV_USB_OTG_IEP_5_13 = 37,
+	STEDMA40_DEV_USB_OTG_IEP_6_14 = 38,
+	STEDMA40_DEV_USB_OTG_IEP_7_15 = 39,
+	STEDMA40_DEV_SPI3_RX = 40,
+	STEDMA40_DEV_SD_MM3_RX = 41,
+	STEDMA40_DEV_SD_MM4_RX = 42,
+	STEDMA40_DEV_SD_MM5_RX = 43,
+	STEDMA40_DEV_SRC_SXA4_RX_TX = 44,
+	STEDMA40_DEV_SRC_SXA5_RX_TX = 45,
+	STEDMA40_DEV_SRC_SXA6_RX_TX = 46,
+	STEDMA40_DEV_SRC_SXA7_RX_TX = 47,
+	STEDMA40_DEV_CAC1_RX = 48,
+	/* RX channels 49 and 50 are unused */
+	STEDMA40_DEV_MSHC_RX = 51,
+	STEDMA40_DEV_SLIM1_CH0_RX_HSI_RX_CH4 = 52,
+	STEDMA40_DEV_SLIM1_CH1_RX_HSI_RX_CH5 = 53,
+	STEDMA40_DEV_SLIM1_CH2_RX_HSI_RX_CH6 = 54,
+	STEDMA40_DEV_SLIM1_CH3_RX_HSI_RX_CH7 = 55,
+	/* RX channels 56 thru 60 are unused */
+	STEDMA40_DEV_CAC0_RX = 61,
+	/* RX channels 62 and 63 are unused */
+};
+
+enum dma_dest_dev_type {
+	STEDMA40_DEV_SPI0_TX = 0,
+	STEDMA40_DEV_SD_MMC0_TX = 1,
+	STEDMA40_DEV_SD_MMC1_TX = 2,
+	STEDMA40_DEV_SD_MMC2_TX = 3,
+	STEDMA40_DEV_I2C1_TX = 4,
+	STEDMA40_DEV_I2C3_TX = 5,
+	STEDMA40_DEV_I2C2_TX = 6,
+	STEDMA50_DEV_I2C4_TX = 7, /* Only on V1 */
+	STEDMA40_DEV_SSP0_TX = 8,
+	STEDMA40_DEV_SSP1_TX = 9,
+	/* TX channel 10 is unused */
+	STEDMA40_DEV_UART2_TX = 11,
+	STEDMA40_DEV_UART1_TX = 12,
+	STEDMA40_DEV_UART0_TX= 13,
+	STEDMA40_DEV_MSP2_TX = 14,
+	STEDMA40_DEV_I2C0_TX = 15,
+	STEDMA40_DEV_USB_OTG_OEP_8 = 16,
+	STEDMA40_DEV_USB_OTG_OEP_1_9 = 17,
+	STEDMA40_DEV_USB_OTG_OEP_2_10= 18,
+	STEDMA40_DEV_USB_OTG_OEP_3_11 = 19,
+	STEDMA40_DEV_SLIM0_CH0_TX_HSI_TX_CH0 = 20,
+	STEDMA40_DEV_SLIM0_CH1_TX_HSI_TX_CH1 = 21,
+	STEDMA40_DEV_SLIM0_CH2_TX_HSI_TX_CH2 = 22,
+	STEDMA40_DEV_SLIM0_CH3_TX_HSI_TX_CH3 = 23,
+	STEDMA40_DEV_DST_SXA0_RX_TX = 24,
+	STEDMA40_DEV_DST_SXA1_RX_TX = 25,
+	STEDMA40_DEV_DST_SXA2_RX_TX = 26,
+	STEDMA40_DEV_DST_SXA3_RX_TX = 27,
+	STEDMA40_DEV_SD_MM2_TX = 28,
+	STEDMA40_DEV_SD_MM0_TX = 29,
+	STEDMA40_DEV_MSP1_TX = 30,
+	/*
+	 * This channel is either SlimBus or MSP,
+	 * never both at the same time.
+	 */
+	STEDMA40_SLIM0_CH0_TX = 31,
+	STEDMA40_DEV_MSP0_TX = 31,
+	STEDMA40_DEV_SD_MM1_TX = 32,
+	STEDMA40_DEV_SPI2_TX = 33,
+	/* Secondary I2C3 channel */
+	STEDMA40_DEV_I2C3_TX2 = 34,
+	STEDMA40_DEV_SPI1_TX = 35,
+	STEDMA40_DEV_USB_OTG_OEP_4_12 = 36,
+	STEDMA40_DEV_USB_OTG_OEP_5_13 = 37,
+	STEDMA40_DEV_USB_OTG_OEP_6_14 = 38,
+	STEDMA40_DEV_USB_OTG_OEP_7_15 = 39,
+	STEDMA40_DEV_SPI3_TX = 40,
+	STEDMA40_DEV_SD_MM3_TX = 41,
+	STEDMA40_DEV_SD_MM4_TX = 42,
+	STEDMA40_DEV_SD_MM5_TX = 43,
+	STEDMA40_DEV_DST_SXA4_RX_TX = 44,
+	STEDMA40_DEV_DST_SXA5_RX_TX = 45,
+	STEDMA40_DEV_DST_SXA6_RX_TX = 46,
+	STEDMA40_DEV_DST_SXA7_RX_TX = 47,
+	STEDMA40_DEV_CAC1_TX = 48,
+	STEDMA40_DEV_CAC1_TX_HAC1_TX = 49,
+	STEDMA40_DEV_HAC1_TX = 50,
+	STEDMA40_MEMXCPY_TX_0 = 51,
+	STEDMA40_DEV_SLIM1_CH0_TX_HSI_TX_CH4 = 52,
+	STEDMA40_DEV_SLIM1_CH1_TX_HSI_TX_CH5 = 53,
+	STEDMA40_DEV_SLIM1_CH2_TX_HSI_TX_CH6 = 54,
+	STEDMA40_DEV_SLIM1_CH3_TX_HSI_TX_CH7 = 55,
+	STEDMA40_MEMCPY_TX_1 = 56,
+	STEDMA40_MEMCPY_TX_2 = 57,
+	STEDMA40_MEMCPY_TX_3 = 58,
+	STEDMA40_MEMCPY_TX_4 = 59,
+	STEDMA40_MEMCPY_TX_5 = 60,
+	STEDMA40_DEV_CAC0_TX = 61,
+	STEDMA40_DEV_CAC0_TX_HAC0_TX = 62,
+	STEDMA40_DEV_HAC0_TX = 63,
+};
+
+#endif
-- 
1.6.3.3

