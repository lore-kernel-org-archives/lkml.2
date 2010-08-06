Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177Ab0HFLv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:51:28 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:41832 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761297Ab0HFLvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:51:22 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 5/5] ARM: config Ux500 PL011 PL022 for DMA v9
Date: Fri, 6 Aug 2010 13:51:04 +0200
Message-ID: <1281095464-15836-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will configure the platform data for the PL011 and PL022
PrimeCells found in the Ux500 to use DMA with the generic
PrimeCell DMA engine.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c   |   12 ---
 arch/arm/mach-ux500/devices-db8500.c |   92 ++++++++++++++++++++++-
 arch/arm/mach-ux500/devices.c        |  134 +++++++++++++++++++++++++++++++++-
 3 files changed, 220 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 0e8fd13..5336521 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -88,16 +88,6 @@ static struct spi_board_info u8500_spi_devices[] = {
 	},
 };
 
-static struct pl022_ssp_controller ssp0_platform_data = {
-	.bus_id = 0,
-	/* pl022 not yet supports dma */
-	.enable_dma = 0,
-	/* on this platform, gpio 31,142,144,214 &
-	 * 224 are connected as chip selects
-	 */
-	.num_chipselect = 5,
-};
-
 #define U8500_I2C_CONTROLLER(id, _slsu, _tft, _rft, clk, _sm) \
 static struct nmk_i2c_controller u8500_i2c##id##_data = { \
 	/*				\
@@ -155,8 +145,6 @@ static void __init u8500_init_machine(void)
 	ux500_i2c2_device.dev.platform_data = &u8500_i2c2_data;
 	ux500_i2c3_device.dev.platform_data = &u8500_i2c3_data;
 
-	u8500_ssp0_device.dev.platform_data = &ssp0_platform_data;
-
 	/* Register the active AMBA devices on this board */
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++)
 		amba_device_register(amba_devs[i], &iomem_resource);
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 9280d25..6aff288 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/pl022.h>
 
 #include <plat/ste_dma40.h>
 
@@ -55,10 +56,55 @@ struct platform_device u8500_gpio_devs[] = {
 	GPIO_DEVICE(8),
 };
 
+#ifdef CONFIG_STE_DMA40
+static struct stedma40_chan_cfg ssp0_dma_cfg_rx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type =  STEDMA40_DEV_SSP0_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+
+static struct stedma40_chan_cfg ssp0_dma_cfg_tx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_MEM_TO_PERIPH,
+	.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+	.dst_dev_type = STEDMA40_DEV_SSP0_TX,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+#endif
+
+static struct pl022_ssp_controller ssp0_platform_data = {
+	.bus_id = 0,
+#ifdef CONFIG_STE_DMA40
+	.enable_dma = 1,
+	.dma_filter = stedma40_filter,
+	.dma_rx_param = &ssp0_dma_cfg_rx,
+	.dma_tx_param = &ssp0_dma_cfg_tx,
+#else
+	.enable_dma = 0,
+#endif
+	/* on this platform, gpio 31,142,144,214 &
+	 * 224 are connected as chip selects
+	 */
+	.num_chipselect = 5,
+};
+
 struct amba_device u8500_ssp0_device = {
 	.dev = {
 		.coherent_dma_mask = ~0,
 		.init_name = "ssp0",
+		.platform_data = &ssp0_platform_data,
 	},
 	.res = {
 		.start = U8500_SSP0_BASE,
@@ -168,12 +214,52 @@ struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 
 /*
  * Mapping between destination event lines and physical device address.
- * The event line is tied to a device and therefor the address is constant.
+ * The event line is tied to a device and therefore the address is constant.
+ * When the address comes from a primecell it will be configured in runtime
+ * and we set the address to -1 as a placeholder.
  */
-static const dma_addr_t dma40_tx_map[STEDMA40_NR_DEV];
+static const dma_addr_t dma40_tx_map[STEDMA40_NR_DEV] = {
+	[STEDMA40_DEV_SPI0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC2_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SSP0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SSP1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART2_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM2_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI2_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI1_TX] = -1,  /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI3_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM3_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM4_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM5_TX] = -1, /* PrimeCell DMA */
+};
 
 /* Mapping between source event lines and physical device address */
-static const dma_addr_t dma40_rx_map[STEDMA40_NR_DEV];
+static const dma_addr_t dma40_rx_map[STEDMA40_NR_DEV] = {
+	[STEDMA40_DEV_SPI0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC2_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SSP0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SSP1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART2_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM2_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI2_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI3_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM3_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM4_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM5_RX] = -1, /* PrimeCell DMA */
+};
 
 /* Reserved event lines for memcpy only */
 static int dma40_memcpy_event[] = {
diff --git a/arch/arm/mach-ux500/devices.c b/arch/arm/mach-ux500/devices.c
index 8a26889..f234461 100644
--- a/arch/arm/mach-ux500/devices.c
+++ b/arch/arm/mach-ux500/devices.c
@@ -10,10 +10,22 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/dma.h>
+#include <linux/amba/serial.h>
+
+#include <plat/ste_dma40.h>
 
 #include <mach/hardware.h>
 #include <mach/setup.h>
 
+/* Channel assignments are per-SoC */
+#ifdef CONFIG_UX500_SOC_DB8500
+#include "ste-dma40-db8500.h"
+#endif
+#if defined(CONFIG_UX500_SOC_DB5500) && defined(CONFIG_STE_DMA40)
+#error "You need to define the DMA channels for DB5500!"
+#endif
+
 #define __MEM_4K_RESOURCE(x) \
 	.res = {.start = (x), .end = (x) + SZ_4K - 1, .flags = IORESOURCE_MEM}
 
@@ -29,20 +41,136 @@ struct amba_device ux500_pl031_device = {
 	.irq = {IRQ_RTC_RTT, NO_IRQ},
 };
 
+#ifdef CONFIG_STE_DMA40
+static struct stedma40_chan_cfg uart0_dma_cfg_rx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type =  STEDMA40_DEV_UART0_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+
+static struct stedma40_chan_cfg uart0_dma_cfg_tx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_MEM_TO_PERIPH,
+	.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+	.dst_dev_type = STEDMA40_DEV_UART0_TX,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+
+static struct stedma40_chan_cfg uart1_dma_cfg_rx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type =  STEDMA40_DEV_UART1_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+
+static struct stedma40_chan_cfg uart1_dma_cfg_tx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_MEM_TO_PERIPH,
+	.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+	.dst_dev_type = STEDMA40_DEV_UART1_TX,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+
+static struct stedma40_chan_cfg uart2_dma_cfg_rx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type =  STEDMA40_DEV_UART2_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+
+static struct stedma40_chan_cfg uart2_dma_cfg_tx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_MEM_TO_PERIPH,
+	.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+	.dst_dev_type = STEDMA40_DEV_UART2_TX,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+};
+#endif
+
+static struct amba_pl011_data uart0_plat = {
+#ifdef CONFIG_STE_DMA40
+	.dma_filter = stedma40_filter,
+	.dma_rx_param = &uart0_dma_cfg_rx,
+	.dma_tx_param = &uart0_dma_cfg_tx,
+#endif
+};
+
+static struct amba_pl011_data uart1_plat = {
+#ifdef CONFIG_STE_DMA40
+	.dma_filter = stedma40_filter,
+	.dma_rx_param = &uart1_dma_cfg_rx,
+	.dma_tx_param = &uart1_dma_cfg_tx,
+#endif
+};
+
+static struct amba_pl011_data uart2_plat = {
+#ifdef CONFIG_STE_DMA40
+	.dma_filter = stedma40_filter,
+	.dma_rx_param = &uart2_dma_cfg_rx,
+	.dma_tx_param = &uart2_dma_cfg_tx,
+#endif
+};
+
 struct amba_device ux500_uart0_device = {
-	.dev = { .init_name = "uart0" },
+	.dev =  {
+		.coherent_dma_mask = ~0,
+		.init_name = "uart0",
+		.platform_data = &uart0_plat,
+	},
 	__MEM_4K_RESOURCE(UX500_UART0_BASE),
 	.irq = {IRQ_UART0, NO_IRQ},
 };
 
 struct amba_device ux500_uart1_device = {
-	.dev = { .init_name = "uart1" },
+	.dev =  {
+		.coherent_dma_mask = ~0,
+		.init_name = "uart1",
+		.platform_data = &uart1_plat,
+	},
 	__MEM_4K_RESOURCE(UX500_UART1_BASE),
 	.irq = {IRQ_UART1, NO_IRQ},
 };
 
 struct amba_device ux500_uart2_device = {
-	.dev = { .init_name = "uart2" },
+	.dev =  {
+		.coherent_dma_mask = ~0,
+		.init_name = "uart2",
+		.platform_data = &uart2_plat,
+	},
 	__MEM_4K_RESOURCE(UX500_UART2_BASE),
 	.irq = {IRQ_UART2, NO_IRQ},
 };
-- 
1.6.3.3

