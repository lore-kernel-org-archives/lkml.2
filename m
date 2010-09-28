Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab0I1Oea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:34:30 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:53927 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755090Ab0I1Oe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:34:28 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 5/7] ARM: config Ux500 PL011 PL022 PL180 for DMA v12
Date: Tue, 28 Sep 2010 16:33:59 +0200
Message-ID: <1285684441-21700-6-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1285684441-21700-5-git-send-email-linus.walleij@stericsson.com>
References: <1285684441-21700-1-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-2-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-3-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-4-git-send-email-linus.walleij@stericsson.com>
 <1285684441-21700-5-git-send-email-linus.walleij@stericsson.com>
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
 arch/arm/mach-ux500/board-mop500-sdi.c |  127 ++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.c     |   12 ---
 arch/arm/mach-ux500/devices-db8500.c   |   92 +++++++++++++++++++++-
 arch/arm/mach-ux500/devices.c          |  133 +++++++++++++++++++++++++++++++-
 4 files changed, 346 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-sdi.c b/arch/arm/mach-ux500/board-mop500-sdi.c
index 2fbaa20..33a65f8 100644
--- a/arch/arm/mach-ux500/board-mop500-sdi.c
+++ b/arch/arm/mach-ux500/board-mop500-sdi.c
@@ -13,11 +13,13 @@
 #include <linux/platform_device.h>
 
 #include <plat/pincfg.h>
+#include <plat/ste_dma40.h>
 #include <mach/devices.h>
 #include <mach/hardware.h>
 
 #include "pins-db8500.h"
 #include "board-mop500.h"
+#include "ste-dma40-db8500.h"
 
 static pin_cfg_t mop500_sdi_pins[] = {
 	/* SDI0 (MicroSD slot) */
@@ -62,6 +64,20 @@ static pin_cfg_t mop500_sdi2_pins[] = {
 	GPIO138_MC2_DAT7,
 };
 
+/* Some custom DMA40 callbacks for MMC */
+static int dma40_mmc_pre_transfer(struct dma_chan *chan, void *data, int size)
+{
+	if (size <= 16)
+		stedma40_set_psize(chan,
+				   STEDMA40_PSIZE_LOG_1,
+				   STEDMA40_PSIZE_LOG_1);
+	else
+		stedma40_set_psize(chan,
+				   STEDMA40_PSIZE_LOG_4,
+				   STEDMA40_PSIZE_LOG_4);
+	return 0;
+}
+
 /*
  * SDI 0 (MicroSD slot)
  */
@@ -85,6 +101,38 @@ static u32 mop500_sdi0_vdd_handler(struct device *dev, unsigned int vdd,
 	       MCI_DATA2DIREN | MCI_DATA31DIREN;
 }
 
+#ifdef CONFIG_STE_DMA40
+struct stedma40_chan_cfg sdi0_dma_cfg_rx = {
+	.pre_transfer = dma40_mmc_pre_transfer,
+	.channel_type = STEDMA40_CHANNEL_IN_LOG_MODE
+			| STEDMA40_LCHAN_SRC_LOG_DST_LOG
+			| STEDMA40_NO_TIM_FOR_LINK
+			| STEDMA40_LOW_PRIORITY_CHANNEL,
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type = DB8500_DMA_DEV29_SD_MM0_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_WORD_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_WORD_WIDTH,
+};
+
+static struct stedma40_chan_cfg sdi0_dma_cfg_tx = {
+	.pre_transfer = dma40_mmc_pre_transfer,
+	.channel_type = STEDMA40_CHANNEL_IN_LOG_MODE
+			| STEDMA40_LCHAN_SRC_LOG_DST_LOG
+			| STEDMA40_NO_TIM_FOR_LINK
+			| STEDMA40_LOW_PRIORITY_CHANNEL,
+	.dir = STEDMA40_MEM_TO_PERIPH,
+	.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+	.dst_dev_type = DB8500_DMA_DEV29_SD_MM0_TX,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_WORD_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_WORD_WIDTH,
+};
+#endif
+
 static struct mmci_platform_data mop500_sdi0_data = {
 	.vdd_handler	= mop500_sdi0_vdd_handler,
 	.ocr_mask	= MMC_VDD_29_30,
@@ -92,6 +140,11 @@ static struct mmci_platform_data mop500_sdi0_data = {
 	.capabilities	= MMC_CAP_4_BIT_DATA,
 	.gpio_cd	= GPIO_SDMMC_CD,
 	.gpio_wp	= -1,
+#ifdef CONFIG_STE_DMA40
+	.dma_filter	= stedma40_filter,
+	.dma_rx_param	= &sdi0_dma_cfg_rx,
+	.dma_tx_param	= &sdi0_dma_cfg_tx,
+#endif
 };
 
 void mop500_sdi_tc35892_init(void)
@@ -115,18 +168,87 @@ void mop500_sdi_tc35892_init(void)
  * SDI 2 (POP eMMC, not on DB8500ed)
  */
 
+#ifdef CONFIG_STE_DMA40
+struct stedma40_chan_cfg sdi2_dma_cfg_rx = {
+	.pre_transfer = dma40_mmc_pre_transfer,
+	.channel_type = STEDMA40_CHANNEL_IN_LOG_MODE
+			| STEDMA40_LCHAN_SRC_LOG_DST_LOG
+			| STEDMA40_NO_TIM_FOR_LINK
+			| STEDMA40_LOW_PRIORITY_CHANNEL,
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type =  DB8500_DMA_DEV28_SD_MM2_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_WORD_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_WORD_WIDTH,
+};
+
+static struct stedma40_chan_cfg sdi2_dma_cfg_tx = {
+	.pre_transfer = dma40_mmc_pre_transfer,
+	.channel_type = STEDMA40_CHANNEL_IN_LOG_MODE
+			| STEDMA40_LCHAN_SRC_LOG_DST_LOG
+			| STEDMA40_NO_TIM_FOR_LINK
+			| STEDMA40_LOW_PRIORITY_CHANNEL,
+	.dir = STEDMA40_MEM_TO_PERIPH,
+	.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+	.dst_dev_type = DB8500_DMA_DEV28_SD_MM2_TX,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_WORD_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_WORD_WIDTH,
+};
+#endif
+
 static struct mmci_platform_data mop500_sdi2_data = {
 	.ocr_mask	= MMC_VDD_165_195,
 	.f_max		= 100000000,
 	.capabilities	= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA,
 	.gpio_cd	= -1,
 	.gpio_wp	= -1,
+#ifdef CONFIG_STE_DMA40
+	.dma_filter	= stedma40_filter,
+	.dma_rx_param	= &sdi2_dma_cfg_rx,
+	.dma_tx_param	= &sdi2_dma_cfg_tx,
+#endif
 };
 
 /*
  * SDI 4 (on-board eMMC)
  */
 
+#ifdef CONFIG_STE_DMA40
+struct stedma40_chan_cfg sdi4_dma_cfg_rx = {
+	.pre_transfer = dma40_mmc_pre_transfer,
+	.channel_type = STEDMA40_CHANNEL_IN_LOG_MODE
+			| STEDMA40_LCHAN_SRC_LOG_DST_LOG
+			| STEDMA40_NO_TIM_FOR_LINK
+			| STEDMA40_LOW_PRIORITY_CHANNEL,
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type =  DB8500_DMA_DEV42_SD_MM4_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_WORD_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_WORD_WIDTH,
+};
+
+static struct stedma40_chan_cfg sdi4_dma_cfg_tx = {
+	.pre_transfer = dma40_mmc_pre_transfer,
+	.channel_type = STEDMA40_CHANNEL_IN_LOG_MODE
+			| STEDMA40_LCHAN_SRC_LOG_DST_LOG
+			| STEDMA40_NO_TIM_FOR_LINK
+			| STEDMA40_LOW_PRIORITY_CHANNEL,
+	.dir = STEDMA40_MEM_TO_PERIPH,
+	.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+	.dst_dev_type = DB8500_DMA_DEV42_SD_MM4_TX,
+	.src_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.src_info.data_width = STEDMA40_WORD_WIDTH,
+	.dst_info.endianess = STEDMA40_LITTLE_ENDIAN,
+	.dst_info.data_width = STEDMA40_WORD_WIDTH,
+};
+#endif
+
 static struct mmci_platform_data mop500_sdi4_data = {
 	.ocr_mask	= MMC_VDD_29_30,
 	.f_max		= 100000000,
@@ -134,6 +256,11 @@ static struct mmci_platform_data mop500_sdi4_data = {
 			  MMC_CAP_MMC_HIGHSPEED,
 	.gpio_cd	= -1,
 	.gpio_wp	= -1,
+#ifdef CONFIG_STE_DMA40
+	.dma_filter	= stedma40_filter,
+	.dma_rx_param	= &sdi4_dma_cfg_rx,
+	.dma_tx_param	= &sdi4_dma_cfg_tx,
+#endif
 };
 
 void mop500_sdi_init(void)
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 6f2b6da..7461450 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -126,16 +126,6 @@ static struct spi_board_info ab8500_spi_devices[] = {
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
 /*
  * TC35892
  */
@@ -329,8 +319,6 @@ static void __init u8500_init_machine(void)
 	ux500_i2c3_device.dev.platform_data = &u8500_i2c3_data;
 	ux500_ske_keypad_device.dev.platform_data = &ske_keypad_board;
 
-	u8500_ssp0_device.dev.platform_data = &ssp0_platform_data;
-
 	/* Register the active AMBA devices on this board */
 	for (i = 0; i < ARRAY_SIZE(amba_devs); i++)
 		amba_device_register(amba_devs[i], &iomem_resource);
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 870e7b9..9bff942 100644
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
+	.src_dev_type =  DB8500_DMA_DEV8_SSP0_RX,
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
+	.dst_dev_type = DB8500_DMA_DEV8_SSP0_TX,
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
@@ -244,12 +290,52 @@ struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 
 /*
  * Mapping between destination event lines and physical device address.
- * The event line is tied to a device and therefor the address is constant.
+ * The event line is tied to a device and therefore the address is constant.
+ * When the address comes from a primecell it will be configured in runtime
+ * and we set the address to -1 as a placeholder.
  */
-static const dma_addr_t dma40_tx_map[DB8500_DMA_NR_DEV];
+static const dma_addr_t dma40_tx_map[DB8500_DMA_NR_DEV] = {
+	[DB8500_DMA_DEV0_SPI0_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV1_SD_MMC0_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV2_SD_MMC1_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV3_SD_MMC2_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV8_SSP0_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV9_SSP1_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV11_UART2_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV12_UART1_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV13_UART0_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV28_SD_MM2_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV29_SD_MM0_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV32_SD_MM1_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV33_SPI2_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV35_SPI1_TX] = -1,  /* PrimeCell DMA */
+	[DB8500_DMA_DEV40_SPI3_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV41_SD_MM3_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV42_SD_MM4_TX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV43_SD_MM5_TX] = -1, /* PrimeCell DMA */
+};
 
 /* Mapping between source event lines and physical device address */
-static const dma_addr_t dma40_rx_map[DB8500_DMA_NR_DEV];
+static const dma_addr_t dma40_rx_map[DB8500_DMA_NR_DEV] = {
+	[DB8500_DMA_DEV0_SPI0_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV1_SD_MMC0_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV2_SD_MMC1_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV3_SD_MMC2_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV8_SSP0_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV9_SSP1_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV11_UART2_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV12_UART1_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV13_UART0_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV28_SD_MM2_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV29_SD_MM0_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV32_SD_MM1_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV33_SPI2_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV35_SPI1_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV40_SPI3_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV41_SD_MM3_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV42_SD_MM4_RX] = -1, /* PrimeCell DMA */
+	[DB8500_DMA_DEV43_SD_MM5_RX] = -1, /* PrimeCell DMA */
+};
 
 /* Reserved event lines for memcpy only */
 static int dma40_memcpy_event[] = {
diff --git a/arch/arm/mach-ux500/devices.c b/arch/arm/mach-ux500/devices.c
index 8a26889..17dc29e 100644
--- a/arch/arm/mach-ux500/devices.c
+++ b/arch/arm/mach-ux500/devices.c
@@ -10,10 +10,21 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/amba/bus.h>
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
 
@@ -29,20 +40,136 @@ struct amba_device ux500_pl031_device = {
 	.irq = {IRQ_RTC_RTT, NO_IRQ},
 };
 
+#ifdef CONFIG_STE_DMA40
+static struct stedma40_chan_cfg uart0_dma_cfg_rx = {
+	.channel_type = (STEDMA40_CHANNEL_IN_LOG_MODE|
+			 STEDMA40_LCHAN_SRC_LOG_DST_LOG|STEDMA40_NO_TIM_FOR_LINK|
+			 STEDMA40_LOW_PRIORITY_CHANNEL),
+	.dir = STEDMA40_PERIPH_TO_MEM,
+	.src_dev_type =  DB8500_DMA_DEV13_UART0_RX,
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
+	.dst_dev_type = DB8500_DMA_DEV13_UART0_TX,
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
+	.src_dev_type =  DB8500_DMA_DEV12_UART1_RX,
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
+	.dst_dev_type = DB8500_DMA_DEV12_UART1_TX,
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
+	.src_dev_type =  DB8500_DMA_DEV11_UART2_RX,
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
+	.dst_dev_type = DB8500_DMA_DEV11_UART2_TX,
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

