Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209Ab0DGXPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:15:13 -0400
Received: from mail.df.lth.se ([194.47.250.12]:32792 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758175Ab0DGXPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:15:05 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 11/11] ARM: config Ux500 PL011 PL022 for DMA v1
Date: Thu,  8 Apr 2010 01:14:30 +0200
Message-Id: <1270682070-7579-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will configure the platform data for the PL011 and PL022
PrimeCells found in the Ux500 to use DMA with the generic
PrimeCell DMA engine.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c |  236 +++++++++++++++++++++++++++++------
 1 files changed, 195 insertions(+), 41 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 6e95678..2cad265 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -14,7 +14,9 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/dma.h>
 #include <linux/amba/pl022.h>
+#include <linux/amba/serial.h>
 #include <linux/spi/spi.h>
 
 #include <asm/mach-types.h>
@@ -31,21 +33,137 @@
 #define __MEM_4K_RESOURCE(x) \
 	.res = {.start = (x), .end = (x) + SZ_4K - 1, .flags = IORESOURCE_MEM}
 
+#ifdef CONFIG_STE_DMA40
+struct stedma40_chan_cfg uart0_dma_cfg_rx = {
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
+struct stedma40_chan_cfg uart1_dma_cfg_rx = {
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
+struct stedma40_chan_cfg uart2_dma_cfg_rx = {
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
 /* These are active devices on this board */
 static struct amba_device uart0_device = {
-	.dev = { .init_name = "uart0" },
+	.dev =  {
+		.coherent_dma_mask = ~0,
+		.init_name = "uart0",
+		.platform_data = &uart0_plat,
+	},
 	__MEM_4K_RESOURCE(U8500_UART0_BASE),
 	.irq = {IRQ_UART0, NO_IRQ},
 };
 
 static struct amba_device uart1_device = {
-	.dev = { .init_name = "uart1" },
+	.dev =  {
+		.coherent_dma_mask = ~0,
+		.init_name = "uart1",
+		.platform_data = &uart1_plat,
+	},
 	__MEM_4K_RESOURCE(U8500_UART1_BASE),
 	.irq = {IRQ_UART1, NO_IRQ},
 };
 
 static struct amba_device uart2_device = {
-	.dev = { .init_name = "uart2" },
+	.dev =  {
+		.coherent_dma_mask = ~0,
+		.init_name = "uart2",
+		.platform_data = &uart2_plat,
+	},
 	__MEM_4K_RESOURCE(U8500_UART2_BASE),
 	.irq = {IRQ_UART2, NO_IRQ},
 };
@@ -84,10 +202,44 @@ static struct spi_board_info u8500_spi_devices[] = {
 	},
 };
 
+#ifdef CONFIG_STE_DMA40
+struct stedma40_chan_cfg ssp0_dma_cfg_rx = {
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
 static struct pl022_ssp_controller ssp0_platform_data = {
 	.bus_id = 0,
-	/* pl022 not yet supports dma */
+#ifdef CONFIG_STE_DMA40
+	.enable_dma = 1,
+	.dma_filter = stedma40_filter,
+	.dma_rx_param = &ssp0_dma_cfg_rx,
+	.dma_tx_param = &ssp0_dma_cfg_tx,
+#else
 	.enable_dma = 0,
+#endif
 	/* on this platform, gpio 31,142,144,214 &
 	 * 224 are connected as chip selects
 	 */
@@ -247,21 +399,23 @@ struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 
 /*
  * Mapping between destination event lines and physical device address.
- * The event line is tied to a device and therefor the address is constant.
+ * The event line is tied to a device and therefore the address is constant.
+ * When the address comes from a primecell it will be configured in runtime
+ * and we set the address to -1 as a placeholder.
  */
 const static dma_addr_t dma40_tx_map[STEDMA40_DEV_MAX] = {
-	[STEDMA40_DEV_SPI0_TX] = 0,
-	[STEDMA40_DEV_SD_MMC0_TX] = 0,
-	[STEDMA40_DEV_SD_MMC1_TX] = 0,
-	[STEDMA40_DEV_SD_MMC2_TX] = 0,
+	[STEDMA40_DEV_SPI0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC2_TX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_I2C1_TX] = 0,
 	[STEDMA40_DEV_I2C3_TX] = 0,
 	[STEDMA40_DEV_I2C2_TX] = 0,
-	[STEDMA40_DEV_SSP0_TX] = 0,
-	[STEDMA40_DEV_SSP1_TX] = 0,
-	[STEDMA40_DEV_UART2_TX] = 0,
-	[STEDMA40_DEV_UART1_TX] = 0,
-	[STEDMA40_DEV_UART0_TX] = 0,
+	[STEDMA40_DEV_SSP0_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SSP1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART2_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART0_TX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_MSP2_TX] = 0,
 	[STEDMA40_DEV_I2C0_TX] = 0,
 	[STEDMA40_DEV_USB_OTG_OEP_8] = 0,
@@ -276,23 +430,23 @@ const static dma_addr_t dma40_tx_map[STEDMA40_DEV_MAX] = {
 	[STEDMA40_DEV_DST_SXA1_RX_TX] = 0,
 	[STEDMA40_DEV_DST_SXA2_RX_TX] = 0,
 	[STEDMA40_DEV_DST_SXA3_RX_TX] = 0,
-	[STEDMA40_DEV_SD_MM2_TX] = 0,
-	[STEDMA40_DEV_SD_MM0_TX] = 0,
+	[STEDMA40_DEV_SD_MM2_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM0_TX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_MSP1_TX] = 0,
 	[STEDMA40_SLIM0_CH0_TX] = 0,
 	[STEDMA40_DEV_MSP0_TX] = 0,
-	[STEDMA40_DEV_SD_MM1_TX] = 0,
-	[STEDMA40_DEV_SPI2_TX] = 0,
+	[STEDMA40_DEV_SD_MM1_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI2_TX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_I2C3_TX2] = 0,
-	[STEDMA40_DEV_SPI1_TX] = 0,
+	[STEDMA40_DEV_SPI1_TX] = -1,  /* PrimeCell DMA */
 	[STEDMA40_DEV_USB_OTG_OEP_4_12] = 0,
 	[STEDMA40_DEV_USB_OTG_OEP_5_13] = 0,
 	[STEDMA40_DEV_USB_OTG_OEP_6_14] = 0,
 	[STEDMA40_DEV_USB_OTG_OEP_7_15] = 0,
-	[STEDMA40_DEV_SPI3_TX] = 0,
-	[STEDMA40_DEV_SD_MM3_TX] = 0,
-	[STEDMA40_DEV_SD_MM4_TX] = 0,
-	[STEDMA40_DEV_SD_MM5_TX] = 0,
+	[STEDMA40_DEV_SPI3_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM3_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM4_TX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM5_TX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_DST_SXA4_RX_TX] = 0,
 	[STEDMA40_DEV_DST_SXA5_RX_TX] = 0,
 	[STEDMA40_DEV_DST_SXA6_RX_TX] = 0,
@@ -307,19 +461,19 @@ const static dma_addr_t dma40_tx_map[STEDMA40_DEV_MAX] = {
 
 /* Mapping between source event lines and physical device address */
 const static dma_addr_t dma40_rx_map[STEDMA40_DEV_MAX] = {
-	[STEDMA40_DEV_SPI0_RX] = 0,
-	[STEDMA40_DEV_SD_MMC0_RX] = 0,
-	[STEDMA40_DEV_SD_MMC1_RX] = 0,
-	[STEDMA40_DEV_SD_MMC2_RX] = 0,
+	[STEDMA40_DEV_SPI0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MMC2_RX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_I2C1_RX] = 0,
 	[STEDMA40_DEV_I2C3_RX] = 0,
 	[STEDMA40_DEV_I2C2_RX] = 0,
-	[STEDMA40_DEV_SSP0_RX] = 0,
-	[STEDMA40_DEV_SSP1_RX] = 0,
+	[STEDMA40_DEV_SSP0_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SSP1_RX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_MCDE_RX] = 0,
-	[STEDMA40_DEV_UART2_RX] = 0,
-	[STEDMA40_DEV_UART1_RX] = 0,
-	[STEDMA40_DEV_UART0_RX] = 0,
+	[STEDMA40_DEV_UART2_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_UART0_RX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_MSP2_RX] = 0,
 	[STEDMA40_DEV_I2C0_RX] = 0,
 	[STEDMA40_DEV_USB_OTG_IEP_8] = 0,
@@ -334,23 +488,23 @@ const static dma_addr_t dma40_rx_map[STEDMA40_DEV_MAX] = {
 	[STEDMA40_DEV_SRC_SXA1_RX_TX] = 0,
 	[STEDMA40_DEV_SRC_SXA2_RX_TX] = 0,
 	[STEDMA40_DEV_SRC_SXA3_RX_TX] = 0,
-	[STEDMA40_DEV_SD_MM2_RX] = 0,
-	[STEDMA40_DEV_SD_MM0_RX] = 0,
+	[STEDMA40_DEV_SD_MM2_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM0_RX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_MSP1_RX] = 0,
 	[STEDMA40_SLIM0_CH0_RX] = 0,
 	[STEDMA40_DEV_MSP0_RX] = 0,
-	[STEDMA40_DEV_SD_MM1_RX] = 0,
-	[STEDMA40_DEV_SPI2_RX] = 0,
+	[STEDMA40_DEV_SD_MM1_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SPI2_RX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_I2C3_RX2] = 0,
-	[STEDMA40_DEV_SPI1_RX] = 0,
+	[STEDMA40_DEV_SPI1_RX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_USB_OTG_IEP_4_12] = 0,
 	[STEDMA40_DEV_USB_OTG_IEP_5_13] = 0,
 	[STEDMA40_DEV_USB_OTG_IEP_6_14] = 0,
 	[STEDMA40_DEV_USB_OTG_IEP_7_15] = 0,
-	[STEDMA40_DEV_SPI3_RX] = 0,
-	[STEDMA40_DEV_SD_MM3_RX] = 0,
-	[STEDMA40_DEV_SD_MM4_RX] = 0,
-	[STEDMA40_DEV_SD_MM5_RX] = 0,
+	[STEDMA40_DEV_SPI3_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM3_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM4_RX] = -1, /* PrimeCell DMA */
+	[STEDMA40_DEV_SD_MM5_RX] = -1, /* PrimeCell DMA */
 	[STEDMA40_DEV_SRC_SXA4_RX_TX] = 0,
 	[STEDMA40_DEV_SRC_SXA5_RX_TX] = 0,
 	[STEDMA40_DEV_SRC_SXA6_RX_TX] = 0,
-- 
1.6.3.3

