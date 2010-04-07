Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab0DGXPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:15:04 -0400
Received: from mail.df.lth.se ([194.47.250.12]:32778 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757558Ab0DGXO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:14:58 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 10/11] ARM: config U300 PL180 PL011 PL022 for DMA v5
Date: Thu,  8 Apr 2010 01:14:21 +0200
Message-Id: <1270682061-7317-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will configure the platform data for the PL180, PL011 and
PL022 PrimeCells found in the U300 to use DMA with the generic
PrimeCell DMA engine.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/core.c |  173 ++++++++++++++++++++++++++++++++++++++++-----
 arch/arm/mach-u300/mmc.c  |   13 +++-
 arch/arm/mach-u300/spi.c  |   21 ++++--
 3 files changed, 181 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 5f34eb6..7f7e738 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -3,7 +3,7 @@
  * arch/arm/mach-u300/core.c
  *
  *
- * Copyright (C) 2007-2010 ST-Ericsson AB
+ * Copyright (C) 2007-2010 ST-Ericsson SA
  * License terms: GNU General Public License (GPL) version 2
  * Core platform support, IRQ handling and device definitions.
  * Author: Linus Walleij <linus.walleij@stericsson.com>
@@ -16,7 +16,9 @@
 #include <linux/device.h>
 #include <linux/mm.h>
 #include <linux/termios.h>
+#include <linux/dmaengine.h>
 #include <linux/amba/bus.h>
+#include <linux/amba/serial.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <mach/coh901318.h>
@@ -92,10 +94,20 @@ void __init u300_map_io(void)
  * Declaration of devices found on the U300 board and
  * their respective memory locations.
  */
+
+static struct amba_pl011_data uart0_plat_data = {
+#ifdef CONFIG_COH901318
+	.dma_filter = coh901318_filter_id,
+	.dma_rx_param = (void *) U300_DMA_UART0_RX,
+	.dma_tx_param = (void *) U300_DMA_UART0_TX,
+#endif
+};
+
 static struct amba_device uart0_device = {
 	.dev = {
+		.coherent_dma_mask = ~0,
 		.init_name = "uart0", /* Slow device at 0x3000 offset */
-		.platform_data = NULL,
+		.platform_data = &uart0_plat_data,
 	},
 	.res = {
 		.start = U300_UART0_BASE,
@@ -107,10 +119,19 @@ static struct amba_device uart0_device = {
 
 /* The U335 have an additional UART1 on the APP CPU */
 #ifdef CONFIG_MACH_U300_BS335
+static struct amba_pl011_data uart1_plat_data = {
+#ifdef CONFIG_COH901318
+	.dma_filter = coh901318_filter_id,
+	.dma_rx_param = (void *) U300_DMA_UART1_RX,
+	.dma_tx_param = (void *) U300_DMA_UART1_TX,
+#endif
+};
+
 static struct amba_device uart1_device = {
 	.dev = {
+		.coherent_dma_mask = ~0,
 		.init_name = "uart1", /* Fast device at 0x7000 offset */
-		.platform_data = NULL,
+		.platform_data = &uart1_plat_data,
 	},
 	.res = {
 		.start = U300_UART1_BASE,
@@ -949,20 +970,21 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.priority_high = 0,
 		.dev_addr = U300_MSL_BASE + 6 * 0x40 + 0x220,
 	},
+	/*
+	 * Don't set up device address, burst count or size of src
+	 * or dst bus for this peripheral - handled by PrimeCell
+	 * DMA extension.
+	 */
 	{
 		.number = U300_DMA_MMCSD_RX_TX,
 		.name = "MMCSD RX TX",
 		.priority_high = 0,
-		.dev_addr =  U300_MMCSD_BASE + 0x080,
 		.param.config = COH901318_CX_CFG_CH_DISABLE |
 				COH901318_CX_CFG_LCR_DISABLE |
 				COH901318_CX_CFG_TC_IRQ_ENABLE |
 				COH901318_CX_CFG_BE_IRQ_ENABLE,
 		.param.ctrl_lli_chained = 0 |
 				COH901318_CX_CTRL_TC_ENABLE |
-				COH901318_CX_CTRL_BURST_COUNT_32_BYTES |
-				COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
-				COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_MASTER_MODE_M1RW |
 				COH901318_CX_CTRL_TCP_ENABLE |
 				COH901318_CX_CTRL_TC_IRQ_ENABLE |
@@ -971,9 +993,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 				COH901318_CX_CTRL_DDMA_LEGACY,
 		.param.ctrl_lli = 0 |
 				COH901318_CX_CTRL_TC_ENABLE |
-				COH901318_CX_CTRL_BURST_COUNT_32_BYTES |
-				COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
-				COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_MASTER_MODE_M1RW |
 				COH901318_CX_CTRL_TCP_ENABLE |
 				COH901318_CX_CTRL_TC_IRQ_ENABLE |
@@ -982,9 +1001,6 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 				COH901318_CX_CTRL_DDMA_LEGACY,
 		.param.ctrl_lli_last = 0 |
 				COH901318_CX_CTRL_TC_ENABLE |
-				COH901318_CX_CTRL_BURST_COUNT_32_BYTES |
-				COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
-				COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS |
 				COH901318_CX_CTRL_MASTER_MODE_M1RW |
 				COH901318_CX_CTRL_TCP_DISABLE |
 				COH901318_CX_CTRL_TC_IRQ_ENABLE |
@@ -1003,15 +1019,76 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.name = "MSPRO RX",
 		.priority_high = 0,
 	},
+	/*
+	 * Don't set up device address, burst count or size of src
+	 * or dst bus for this peripheral - handled by PrimeCell
+	 * DMA extension.
+	 */
 	{
 		.number = U300_DMA_UART0_TX,
 		.name = "UART0 TX",
 		.priority_high = 0,
+		.param.config = COH901318_CX_CFG_CH_DISABLE |
+				COH901318_CX_CFG_LCR_DISABLE |
+				COH901318_CX_CFG_TC_IRQ_ENABLE |
+				COH901318_CX_CFG_BE_IRQ_ENABLE,
+		.param.ctrl_lli_chained = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TC_IRQ_DISABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli_last = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
 	},
 	{
 		.number = U300_DMA_UART0_RX,
 		.name = "UART0 RX",
 		.priority_high = 0,
+		.param.config = COH901318_CX_CFG_CH_DISABLE |
+				COH901318_CX_CFG_LCR_DISABLE |
+				COH901318_CX_CFG_TC_IRQ_ENABLE |
+				COH901318_CX_CFG_BE_IRQ_ENABLE,
+		.param.ctrl_lli_chained = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TC_IRQ_DISABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli_last = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_ENABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
 	},
 	{
 		.number = U300_DMA_APEX_TX,
@@ -1241,15 +1318,77 @@ const struct coh_dma_channel chan_config[U300_DMA_CHANNELS] = {
 		.name = "XGAM PDI",
 		.priority_high = 0,
 	},
+	/*
+	 * Don't set up device address, burst count or size of src
+	 * or dst bus for this peripheral - handled by PrimeCell
+	 * DMA extension.
+	 */
 	{
 		.number = U300_DMA_SPI_TX,
 		.name = "SPI TX",
 		.priority_high = 0,
+		.param.config = COH901318_CX_CFG_CH_DISABLE |
+				COH901318_CX_CFG_LCR_DISABLE |
+				COH901318_CX_CFG_TC_IRQ_ENABLE |
+				COH901318_CX_CFG_BE_IRQ_ENABLE,
+		.param.ctrl_lli_chained = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_DISABLE |
+				COH901318_CX_CTRL_TC_IRQ_DISABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_DISABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli_last = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_DISABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
 	},
 	{
 		.number = U300_DMA_SPI_RX,
 		.name = "SPI RX",
 		.priority_high = 0,
+		.param.config = COH901318_CX_CFG_CH_DISABLE |
+				COH901318_CX_CFG_LCR_DISABLE |
+				COH901318_CX_CFG_TC_IRQ_ENABLE |
+				COH901318_CX_CFG_BE_IRQ_ENABLE,
+		.param.ctrl_lli_chained = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_DISABLE |
+				COH901318_CX_CTRL_TC_IRQ_DISABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_DISABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+		.param.ctrl_lli_last = 0 |
+				COH901318_CX_CTRL_TC_ENABLE |
+				COH901318_CX_CTRL_MASTER_MODE_M1RW |
+				COH901318_CX_CTRL_TCP_DISABLE |
+				COH901318_CX_CTRL_TC_IRQ_ENABLE |
+				COH901318_CX_CTRL_HSP_ENABLE |
+				COH901318_CX_CTRL_HSS_DISABLE |
+				COH901318_CX_CTRL_DDMA_LEGACY,
+
 	},
 	{
 		.number = U300_DMA_GENERAL_PURPOSE_0,
@@ -1577,7 +1716,7 @@ static void __init u300_init_check_chip(void)
 #endif
 #ifdef CONFIG_MACH_U300_BS335
 	if ((val & 0xFF00U) != 0xf000 && (val & 0xFF00U) != 0xf100) {
-		printk(KERN_ERR "Platform configured for BS365 " \
+		printk(KERN_ERR "Platform configured for BS335 " \
 		       " with DB3350 but %s detected, expect problems!",
 		       chipname);
 	}
@@ -1654,12 +1793,12 @@ void __init u300_init_devices(void)
 	/* Register subdevices on the I2C buses */
 	u300_i2c_register_board_devices();
 
-	/* Register subdevices on the SPI bus */
-	u300_spi_register_board_devices();
-
 	/* Register the platform devices */
 	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
 
+	/* Register subdevices on the SPI bus */
+	u300_spi_register_board_devices();
+
 #ifndef CONFIG_MACH_U300_SEMI_IS_SHARED
 	/*
 	 * Enable SEMI self refresh. Self-refresh of the SDRAM is entered when
diff --git a/arch/arm/mach-u300/mmc.c b/arch/arm/mach-u300/mmc.c
index 88506d0..3acb710 100644
--- a/arch/arm/mach-u300/mmc.c
+++ b/arch/arm/mach-u300/mmc.c
@@ -3,11 +3,11 @@
  * arch/arm/mach-u300/mmc.c
  *
  *
- * Copyright (C) 2009 ST-Ericsson AB
+ * Copyright (C) 2009 ST-Ericsson SA
  * License terms: GNU General Public License (GPL) version 2
  *
  * Author: Linus Walleij <linus.walleij@stericsson.com>
- * Author: Johan Lundin <johan.lundin@stericsson.com>
+ * Author: Johan Lundin
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
  */
 #include <linux/device.h>
@@ -19,8 +19,11 @@
 #include <linux/regulator/consumer.h>
 #include <linux/regulator/machine.h>
 #include <linux/gpio.h>
+#include <linux/dmaengine.h>
 #include <linux/amba/mmci.h>
 #include <linux/slab.h>
+#include <mach/coh901318.h>
+#include <mach/dma_channels.h>
 
 #include "mmc.h"
 #include "padmux.h"
@@ -108,6 +111,12 @@ int __devinit mmc_init(struct amba_device *adev)
 	mmci_card->mmc0_plat_data.gpio_cd = -1;
 	mmci_card->mmc0_plat_data.capabilities = MMC_CAP_MMC_HIGHSPEED |
 		MMC_CAP_SD_HIGHSPEED | MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
+#ifdef CONFIG_COH901318
+	mmci_card->mmc0_plat_data.dma_filter = coh901318_filter_id;
+	mmci_card->mmc0_plat_data.dma_rx_param =
+		(void *) U300_DMA_MMCSD_RX_TX;
+	/* Don't specify a TX channel, this RX channel is bidirectional */
+#endif
 
 	mmcsd_device->platform_data = (void *) &mmci_card->mmc0_plat_data;
 
diff --git a/arch/arm/mach-u300/spi.c b/arch/arm/mach-u300/spi.c
index f0e887b..243c999 100644
--- a/arch/arm/mach-u300/spi.c
+++ b/arch/arm/mach-u300/spi.c
@@ -11,6 +11,9 @@
 #include <linux/spi/spi.h>
 #include <linux/amba/pl022.h>
 #include <linux/err.h>
+#include <mach/coh901318.h>
+#include <mach/dma_channels.h>
+
 #include "padmux.h"
 
 /*
@@ -32,11 +35,8 @@ static void select_dummy_chip(u32 chipselect)
 struct pl022_config_chip dummy_chip_info = {
 	/* Nominally this is LOOPBACK_DISABLED, but this is our dummy chip! */
 	.lbm = LOOPBACK_ENABLED,
-	/*
-	 * available POLLING_TRANSFER and INTERRUPT_TRANSFER,
-	 * DMA_TRANSFER does not work
-	 */
-	.com_mode = INTERRUPT_TRANSFER,
+	/* available POLLING_TRANSFER, INTERRUPT_TRANSFER, DMA_TRANSFER */
+	.com_mode = DMA_TRANSFER,
 	.iface = SSP_INTERFACE_MOTOROLA_SPI,
 	/* We can only act as master but SSP_SLAVE is possible in theory */
 	.hierarchy = SSP_MASTER,
@@ -83,8 +83,6 @@ static struct spi_board_info u300_spi_devices[] = {
 static struct pl022_ssp_controller ssp_platform_data = {
 	/* If you have several SPI buses this varies, we have only bus 0 */
 	.bus_id = 0,
-	/* Set this to 1 when we think we got DMA working */
-	.enable_dma = 0,
 	/*
 	 * On the APP CPU GPIO 4, 5 and 6 are connected as generic
 	 * chip selects for SPI. (Same on U330, U335 and U365.)
@@ -92,6 +90,14 @@ static struct pl022_ssp_controller ssp_platform_data = {
 	 * and do padmuxing accordingly too.
 	 */
 	.num_chipselect = 3,
+#ifdef CONFIG_COH901318
+	.enable_dma = 1,
+	.dma_filter = coh901318_filter_id,
+	.dma_rx_param = (void *) U300_DMA_SPI_RX,
+	.dma_tx_param = (void *) U300_DMA_SPI_TX,
+#else
+	.enable_dma = 0,
+#endif
 };
 
 
@@ -117,6 +123,7 @@ void __init u300_spi_init(struct amba_device *adev)
 	}
 
 }
+
 void __init u300_spi_register_board_devices(void)
 {
 	/* Register any SPI devices */
-- 
1.6.3.3

