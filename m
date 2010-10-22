Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0JVQWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:22:14 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:37371 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0JVQWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:22:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: avictor.za@gmail.com, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v3] at91/atmel-mci: inclusion of sd/mmc driver in at91sam9g45 chip and board
Date: Fri, 22 Oct 2010 19:28:59 +0200
Message-Id: <1287768546-18513-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
References: <af311282c5a0076ec618be68facdd3ad98d509b8.1287767949.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the support of atmel-mci sd/mmc driver in at91sam9g45 devices and
board files. This also configures the DMA controller slave interface for
at_hdmac dmaengine driver.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
v3: remove the gpio setting to "-1": gpiolib is corectly dealing with "0" value
using gpio_request() function.

 arch/arm/mach-at91/at91sam9g45_devices.c |  165 ++++++++++++++++++++++++++++++
 arch/arm/mach-at91/board-sam9m10g45ek.c  |   24 +++++
 drivers/mmc/host/Kconfig                 |    2 +-
 3 files changed, 190 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 1276bab..1e8f275 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -15,6 +15,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/i2c-gpio.h>
+#include <linux/atmel-mci.h>
 
 #include <linux/fb.h>
 #include <video/atmel_lcdc.h>
@@ -25,6 +26,7 @@
 #include <mach/at91sam9g45_matrix.h>
 #include <mach/at91sam9_smc.h>
 #include <mach/at_hdmac.h>
+#include <mach/atmel-mci.h>
 
 #include "generic.h"
 
@@ -350,6 +352,169 @@ void __init at91_add_device_eth(struct at91_eth_data *data) {}
 
 
 /* --------------------------------------------------------------------
+ *  MMC / SD
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_MMC_ATMELMCI) || defined(CONFIG_MMC_ATMELMCI_MODULE)
+static u64 mmc_dmamask = DMA_BIT_MASK(32);
+static struct mci_platform_data mmc0_data, mmc1_data;
+
+static struct resource mmc0_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_MCI0,
+		.end	= AT91SAM9G45_BASE_MCI0 + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_MCI0,
+		.end	= AT91SAM9G45_ID_MCI0,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_mmc0_device = {
+	.name		= "atmel_mci",
+	.id		= 0,
+	.dev		= {
+				.dma_mask		= &mmc_dmamask,
+				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &mmc0_data,
+	},
+	.resource	= mmc0_resources,
+	.num_resources	= ARRAY_SIZE(mmc0_resources),
+};
+
+static struct resource mmc1_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_MCI1,
+		.end	= AT91SAM9G45_BASE_MCI1 + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_MCI1,
+		.end	= AT91SAM9G45_ID_MCI1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_mmc1_device = {
+	.name		= "atmel_mci",
+	.id		= 1,
+	.dev		= {
+				.dma_mask		= &mmc_dmamask,
+				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &mmc1_data,
+	},
+	.resource	= mmc1_resources,
+	.num_resources	= ARRAY_SIZE(mmc1_resources),
+};
+
+/* Consider only one slot : slot 0 */
+void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data)
+{
+
+	if (!data)
+		return;
+
+	/* Must have at least one usable slot */
+	if (!data->slot[0].bus_width)
+		return;
+
+#if defined(CONFIG_AT_HDMAC) || defined(CONFIG_AT_HDMAC_MODULE)
+	{
+	struct at_dma_slave	*atslave;
+	struct mci_dma_data	*alt_atslave;
+
+	alt_atslave = kzalloc(sizeof(struct mci_dma_data), GFP_KERNEL);
+	atslave = &alt_atslave->sdata;
+
+	/* DMA slave channel configuration */
+	atslave->dma_dev = &at_hdmac_device.dev;
+	atslave->reg_width = AT_DMA_SLAVE_WIDTH_32BIT;
+	atslave->cfg = ATC_FIFOCFG_HALFFIFO
+			| ATC_SRC_H2SEL_HW | ATC_DST_H2SEL_HW;
+	atslave->ctrla = ATC_SCSIZE_16 | ATC_DCSIZE_16;
+	if (mmc_id == 0)	/* MCI0 */
+		atslave->cfg |= ATC_SRC_PER(AT_DMA_ID_MCI0)
+			      | ATC_DST_PER(AT_DMA_ID_MCI0);
+
+	else			/* MCI1 */
+		atslave->cfg |= ATC_SRC_PER(AT_DMA_ID_MCI1)
+			      | ATC_DST_PER(AT_DMA_ID_MCI1);
+
+	data->dma_slave = alt_atslave;
+	}
+#endif
+
+
+	/* input/irq */
+	if (data->slot[0].detect_pin) {
+		at91_set_gpio_input(data->slot[0].detect_pin, 1);
+		at91_set_deglitch(data->slot[0].detect_pin, 1);
+	}
+	if (data->slot[0].wp_pin)
+		at91_set_gpio_input(data->slot[0].wp_pin, 1);
+
+	if (mmc_id == 0) {		/* MCI0 */
+
+		/* CLK */
+		at91_set_A_periph(AT91_PIN_PA0, 0);
+
+		/* CMD */
+		at91_set_A_periph(AT91_PIN_PA1, 1);
+
+		/* DAT0, maybe DAT1..DAT3 and maybe DAT4..DAT7 */
+		at91_set_A_periph(AT91_PIN_PA2, 1);
+		if (data->slot[0].bus_width == 4) {
+			at91_set_A_periph(AT91_PIN_PA3, 1);
+			at91_set_A_periph(AT91_PIN_PA4, 1);
+			at91_set_A_periph(AT91_PIN_PA5, 1);
+			if (data->slot[0].bus_width == 8) {
+				at91_set_A_periph(AT91_PIN_PA6, 1);
+				at91_set_A_periph(AT91_PIN_PA7, 1);
+				at91_set_A_periph(AT91_PIN_PA8, 1);
+				at91_set_A_periph(AT91_PIN_PA9, 1);
+			}
+		}
+
+		mmc0_data = *data;
+		at91_clock_associate("mci0_clk", &at91sam9g45_mmc0_device.dev, "mci_clk");
+		platform_device_register(&at91sam9g45_mmc0_device);
+
+	} else {			/* MCI1 */
+
+		/* CLK */
+		at91_set_A_periph(AT91_PIN_PA31, 0);
+
+		/* CMD */
+		at91_set_A_periph(AT91_PIN_PA22, 1);
+
+		/* DAT0, maybe DAT1..DAT3 and maybe DAT4..DAT7 */
+		at91_set_A_periph(AT91_PIN_PA23, 1);
+		if (data->slot[0].bus_width == 4) {
+			at91_set_A_periph(AT91_PIN_PA24, 1);
+			at91_set_A_periph(AT91_PIN_PA25, 1);
+			at91_set_A_periph(AT91_PIN_PA26, 1);
+			if (data->slot[0].bus_width == 8) {
+				at91_set_A_periph(AT91_PIN_PA27, 1);
+				at91_set_A_periph(AT91_PIN_PA28, 1);
+				at91_set_A_periph(AT91_PIN_PA29, 1);
+				at91_set_A_periph(AT91_PIN_PA30, 1);
+			}
+		}
+
+		mmc1_data = *data;
+		at91_clock_associate("mci1_clk", &at91sam9g45_mmc1_device.dev, "mci_clk");
+		platform_device_register(&at91sam9g45_mmc1_device);
+
+	}
+}
+#else
+void __init at91_add_device_mci(short mmc_id, struct mci_platform_data *data) {}
+#endif
+
+
+/* --------------------------------------------------------------------
  *  NAND / SmartMedia
  * -------------------------------------------------------------------- */
 
diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
index 7913984..86ff4b5 100644
--- a/arch/arm/mach-at91/board-sam9m10g45ek.c
+++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
@@ -24,7 +24,9 @@
 #include <linux/input.h>
 #include <linux/leds.h>
 #include <linux/clk.h>
+#include <linux/atmel-mci.h>
 
+#include <mach/hardware.h>
 #include <video/atmel_lcdc.h>
 
 #include <asm/setup.h>
@@ -98,6 +100,25 @@ static struct spi_board_info ek_spi_devices[] = {
 
 
 /*
+ * MCI (SD/MMC)
+ */
+static struct mci_platform_data __initdata mci0_data = {
+	.slot[0] = {
+		.bus_width	= 4,
+		.detect_pin	= AT91_PIN_PD10,
+	},
+};
+
+static struct mci_platform_data __initdata mci1_data = {
+	.slot[0] = {
+		.bus_width	= 4,
+		.detect_pin	= AT91_PIN_PD11,
+		.wp_pin		= AT91_PIN_PD29,
+	},
+};
+
+
+/*
  * MACB Ethernet device
  */
 static struct at91_eth_data __initdata ek_macb_data = {
@@ -380,6 +401,9 @@ static void __init ek_board_init(void)
 	at91_add_device_usba(&ek_usba_udc_data);
 	/* SPI */
 	at91_add_device_spi(ek_spi_devices, ARRAY_SIZE(ek_spi_devices));
+	/* MMC */
+	at91_add_device_mci(0, &mci0_data);
+	at91_add_device_mci(1, &mci1_data);
 	/* Ethernet */
 	at91_add_device_eth(&ek_macb_data);
 	/* NAND */
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 68d1279..1a02611 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -237,7 +237,7 @@ endchoice
 
 config MMC_ATMELMCI_DMA
 	bool "Atmel MCI DMA support (EXPERIMENTAL)"
-	depends on MMC_ATMELMCI && AVR32 && DMA_ENGINE && EXPERIMENTAL
+	depends on MMC_ATMELMCI && (AVR32 || ARCH_AT91SAM9G45) && DMA_ENGINE && EXPERIMENTAL
 	help
 	  Say Y here to have the Atmel MCI driver use a DMA engine to
 	  do data transfers and thus increase the throughput and
-- 
1.7.3

