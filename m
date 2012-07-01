Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab2GARUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 13:20:42 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:33641 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960Ab2GARUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 13:20:39 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-kernel@vger.kernel.org
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
        davem@davemloft.net, plagnioj@jcrosoft.com, nicolas@eukrea.com,
        eric@eukrea.com
Subject: [PATCH 1/5] ARM: AT91SAM9G45: add crypto peripherals
Date: Sun,  1 Jul 2012 19:19:43 +0200
Message-Id: <1341163187-14946-2-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1341163187-14946-1-git-send-email-eric@eukrea.com>
References: <1341163187-14946-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Royer <nicolas@eukrea.com>

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric Bénard <eric@eukrea.com>
Tested-by: Eric Bénard <eric@eukrea.com>
---
 arch/arm/mach-at91/at91sam9g45.c              |   13 +++-
 arch/arm/mach-at91/at91sam9g45_devices.c      |  128 +++++++++++++++++++++++++
 arch/arm/mach-at91/include/mach/at91sam9g45.h |    2 +
 include/linux/platform_data/atmel-aes.h       |   22 ++++
 4 files changed, 164 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/platform_data/atmel-aes.h

diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91sam9g45.c
index 4792682..da6dc0f 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -182,6 +182,13 @@ static struct clk adc_op_clk = {
 	.rate_hz	= 13200000,
 };
 
+/* AES/TDES/SHA clock - Only for sam9m11/sam9g56 */
+static struct clk aestdessha_clk = {
+	.name		= "aestdessha_clk",
+	.pmc_mask	= 1 << AT91SAM9G45_ID_AESTDESSHA,
+	.type		= CLK_TYPE_PERIPHERAL,
+};
+
 static struct clk *periph_clocks[] __initdata = {
 	&pioA_clk,
 	&pioB_clk,
@@ -211,6 +218,7 @@ static struct clk *periph_clocks[] __initdata = {
 	&udphs_clk,
 	&mmc1_clk,
 	&adc_op_clk,
+	&aestdessha_clk,
 	// irq0
 };
 
@@ -231,6 +239,9 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc0_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.1", &ssc1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "atmel-trng", &trng_clk),
+	CLKDEV_CON_DEV_ID(NULL, "atmel_sha", &aestdessha_clk),
+	CLKDEV_CON_DEV_ID(NULL, "atmel_tdes", &aestdessha_clk),
+	CLKDEV_CON_DEV_ID(NULL, "atmel_aes", &aestdessha_clk),
 	/* more usart lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("usart", "ffffee00.serial", &mck),
 	CLKDEV_CON_DEV_ID("usart", "fff8c000.serial", &usart0_clk),
@@ -387,7 +398,7 @@ static unsigned int at91sam9g45_default_irq_priority[NR_AIC_IRQS] __initdata = {
 	3,	/* Ethernet */
 	0,	/* Image Sensor Interface */
 	2,	/* USB Device High speed port */
-	0,
+	0,	/* AESTDESSHA Crypto HW Accelerators */
 	0,	/* Multimedia Card Interface 1 */
 	0,
 	0,	/* Advanced Interrupt Controller (IRQ0) */
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 933fc9a..7102f62 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-gpio.h>
 #include <linux/atmel-mci.h>
+#include <linux/platform_data/atmel-aes.h>
 
 #include <linux/platform_data/at91_adc.h>
 
@@ -1830,6 +1831,130 @@ void __init at91_register_uart(unsigned id, unsigned portnr, unsigned pins) {}
 void __init at91_add_device_serial(void) {}
 #endif
 
+/* --------------------------------------------------------------------
+ *  SHA1/SHA256
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_CRYPTO_DEV_ATMEL_SHA) || defined(CONFIG_CRYPTO_DEV_ATMEL_SHA_MODULE)
+static struct resource sha_resources[] = {
+	{
+		.start	= AT91SAM9G45_BASE_SHA,
+		.end	= AT91SAM9G45_BASE_SHA + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_AESTDESSHA,
+		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_sha_device = {
+	.name	= "atmel_sha",
+	.id		= -1,
+	.resource	= sha_resources,
+	.num_resources	= ARRAY_SIZE(sha_resources),
+};
+
+static void __init at91_add_device_sha(void)
+{
+	platform_device_register(&at91sam9g45_sha_device);
+}
+#else
+static void __init at91_add_device_sha(void) {}
+#endif
+
+/* --------------------------------------------------------------------
+ *  DES/TDES
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_CRYPTO_DEV_ATMEL_TDES) || defined(CONFIG_CRYPTO_DEV_ATMEL_TDES_MODULE)
+static struct resource tdes_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_TDES,
+		.end	= AT91SAM9G45_BASE_TDES + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_AESTDESSHA,
+		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_tdes_device = {
+	.name	= "atmel_tdes",
+	.id		= -1,
+	.resource	= tdes_resources,
+	.num_resources	= ARRAY_SIZE(tdes_resources),
+};
+
+static void __init at91_add_device_tdes(void)
+{
+	platform_device_register(&at91sam9g45_tdes_device);
+}
+#else
+static void __init at91_add_device_tdes(void) {}
+#endif
+
+/* --------------------------------------------------------------------
+ *  AES
+ * -------------------------------------------------------------------- */
+
+#if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_ATMEL_AES_MODULE)
+static struct aes_platform_data aes_data;
+static u64 aes_dmamask = DMA_BIT_MASK(32);
+
+static struct resource aes_resources[] = {
+	[0] = {
+		.start	= AT91SAM9G45_BASE_AES,
+		.end	= AT91SAM9G45_BASE_AES + SZ_16K - 1,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		.start	= AT91SAM9G45_ID_AESTDESSHA,
+		.end	= AT91SAM9G45_ID_AESTDESSHA,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_aes_device = {
+	.name	= "atmel_aes",
+	.id		= -1,
+	.dev	= {
+		.dma_mask		= &aes_dmamask,
+		.coherent_dma_mask	= DMA_BIT_MASK(32),
+		.platform_data		= &aes_data,
+	},
+	.resource	= aes_resources,
+	.num_resources	= ARRAY_SIZE(aes_resources),
+};
+
+static void __init at91_add_device_aes(void)
+{
+	struct at_dma_slave	*atslave;
+	struct aes_dma_data	*alt_atslave;
+
+	alt_atslave = kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
+
+	/* DMA TX slave channel configuration */
+	atslave = &alt_atslave->txdata;
+	atslave->dma_dev = &at_hdmac_device.dev;
+	atslave->cfg = ATC_FIFOCFG_ENOUGHSPACE	| ATC_SRC_H2SEL_HW |
+						ATC_SRC_PER(AT_DMA_ID_AES_RX);
+
+	/* DMA RX slave channel configuration */
+	atslave = &alt_atslave->rxdata;
+	atslave->dma_dev = &at_hdmac_device.dev;
+	atslave->cfg = ATC_FIFOCFG_ENOUGHSPACE	| ATC_DST_H2SEL_HW |
+						ATC_DST_PER(AT_DMA_ID_AES_TX);
+
+	aes_data.dma_slave = alt_atslave;
+	platform_device_register(&at91sam9g45_aes_device);
+}
+#else
+static void __init at91_add_device_aes(void) {}
+#endif
 
 /* -------------------------------------------------------------------- */
 /*
@@ -1847,6 +1972,9 @@ static int __init at91_add_standard_devices(void)
 	at91_add_device_trng();
 	at91_add_device_watchdog();
 	at91_add_device_tc();
+	at91_add_device_sha();
+	at91_add_device_tdes();
+	at91_add_device_aes();
 	return 0;
 }
 
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
index 3a4da24..8eba102 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
@@ -136,6 +136,8 @@
 #define AT_DMA_ID_SSC1_RX	 8
 #define AT_DMA_ID_AC97_TX	 9
 #define AT_DMA_ID_AC97_RX	10
+#define AT_DMA_ID_AES_TX	11
+#define AT_DMA_ID_AES_RX	12
 #define AT_DMA_ID_MCI1		13
 
 #endif
diff --git a/include/linux/platform_data/atmel-aes.h b/include/linux/platform_data/atmel-aes.h
new file mode 100644
index 0000000..e7a1949
--- /dev/null
+++ b/include/linux/platform_data/atmel-aes.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_ATMEL_AES_H
+#define __LINUX_ATMEL_AES_H
+
+#include <mach/at_hdmac.h>
+
+/**
+ * struct aes_dma_data - DMA data for AES
+ */
+struct aes_dma_data {
+	struct at_dma_slave	txdata;
+	struct at_dma_slave	rxdata;
+};
+
+/**
+ * struct aes_platform_data - board-specific AES configuration
+ * @dma_slave: DMA slave interface to use in data transfers.
+ */
+struct aes_platform_data {
+	struct aes_dma_data	*dma_slave;
+};
+
+#endif /* __LINUX_ATMEL_AES_H */
-- 
1.7.7.6

