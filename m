Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab1EYQ14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:27:56 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:57455 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044Ab1EYQ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:27:53 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Carlos Chinea <carlos.chinea@nokia.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Pawel Szyszuk <pawel.szyszuk@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] mach-ux500: platform data for ST-E HSI controller
Date: Wed, 25 May 2011 18:27:38 +0200
Message-ID: <1306340858-31397-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pawel Szyszuk <pawel.szyszuk@stericsson.com>

Signed-off-by: Pawel Szyszuk <pawel.szyszuk@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-pins.c    |   10 +++
 arch/arm/mach-ux500/board-mop500.c         |   65 +++++++++++++++
 arch/arm/mach-ux500/clock.c                |    8 +-
 arch/arm/mach-ux500/devices-db8500.c       |  118 +++++++++++++++++++++++++++
 arch/arm/mach-ux500/include/mach/devices.h |    1 +
 arch/arm/mach-ux500/include/mach/hsi.h     |  122 ++++++++++++++++++++++++++++
 6 files changed, 320 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-ux500/include/mach/hsi.h

diff --git a/arch/arm/mach-ux500/board-mop500-pins.c b/arch/arm/mach-ux500/board-mop500-pins.c
index fd4cf1c..030324f1 100644
--- a/arch/arm/mach-ux500/board-mop500-pins.c
+++ b/arch/arm/mach-ux500/board-mop500-pins.c
@@ -123,6 +123,16 @@ static pin_cfg_t mop500_pins_common[] = {
 	/* Display & HDMI HW sync */
 	GPIO68_LCD_VSI0	| PIN_INPUT_PULLUP,
 	GPIO69_LCD_VSI1	| PIN_INPUT_PULLUP,
+
+	/* HSI */
+	GPIO219_HSIR_FLA0,
+	GPIO220_HSIR_DAT0,
+	GPIO221_HSIR_RDY0,
+	GPIO222_HSIT_FLA0,
+	GPIO223_HSIT_DAT0,
+	GPIO224_HSIT_RDY0,
+	GPIO225_GPIO	| PIN_INPUT_PULLDOWN, /* CA_WAKE0 */
+	GPIO226_GPIO	| PIN_OUTPUT_HIGH, /* AC_WAKE0 */
 };
 
 static pin_cfg_t mop500_pins_default[] = {
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 6e1907fa..b1cc44a 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/i2c.h>
+#include <linux/hsi/hsi.h>
 #include <linux/gpio.h>
 #include <linux/amba/bus.h>
 #include <linux/amba/pl022.h>
@@ -233,6 +234,62 @@ U8500_I2C_CONTROLLER(1, 0xe, 1, 1, 100000, I2C_FREQ_MODE_STANDARD);
 U8500_I2C_CONTROLLER(2,	0xe, 1, 1, 100000, I2C_FREQ_MODE_STANDARD);
 U8500_I2C_CONTROLLER(3,	0xe, 1, 1, 100000, I2C_FREQ_MODE_STANDARD);
 
+#ifdef CONFIG_HSI
+static struct hsi_board_info __initdata u8500_hsi_devices[] = {
+	{
+		.name = "hsi_char",
+		.hsi_id = 0,
+		.port = 0,
+		.tx_cfg = {
+			.mode = HSI_MODE_STREAM,
+			.channels = 2,
+			.speed = 100000,
+			{.arb_mode = HSI_ARB_RR},
+		},
+		.rx_cfg = {
+			.mode = HSI_MODE_STREAM,
+			.channels = 2,
+			.speed = 200000,
+			{.flow = HSI_FLOW_SYNC},
+		},
+	},
+	{
+		.name = "hsi_test",
+		.hsi_id = 0,
+		.port = 0,
+		.tx_cfg = {
+			.mode = HSI_MODE_FRAME,
+			.channels = 2,
+			.speed = 100000,
+			{.arb_mode = HSI_ARB_RR},
+		},
+		.rx_cfg = {
+			.mode = HSI_MODE_FRAME,
+			.channels = 2,
+			.speed = 200000,
+			{.flow = HSI_FLOW_SYNC},
+		},
+	},
+	{
+		.name = "cfhsi_v3_driver",
+		.hsi_id = 0,
+		.port = 0,
+		.tx_cfg = {
+			.mode = HSI_MODE_STREAM,
+			.channels = 2,
+			.speed = 20000,
+			{.arb_mode = HSI_ARB_RR},
+		},
+		.rx_cfg = {
+			.mode = HSI_MODE_STREAM,
+			.channels = 2,
+			.speed = 200000,
+			{.flow = HSI_FLOW_SYNC},
+		},
+	},
+};
+#endif
+
 static void __init mop500_i2c_init(void)
 {
 	db8500_add_i2c0(&u8500_i2c0_data);
@@ -292,6 +349,9 @@ static void mop500_prox_deactivate(struct device *dev)
 /* add any platform devices here - TODO */
 static struct platform_device *platform_devs[] __initdata = {
 	&mop500_gpio_keys_device,
+#ifdef CONFIG_HSI
+	&u8500_hsi_device,
+#endif
 };
 
 #ifdef CONFIG_STE_DMA40
@@ -456,6 +516,11 @@ static void __init mop500_init_machine(void)
 	i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
 	i2c_register_board_info(2, mop500_i2c2_devices,
 				ARRAY_SIZE(mop500_i2c2_devices));
+#ifdef CONFIG_HSI
+	hsi_register_board_info(u8500_hsi_devices,
+				ARRAY_SIZE(u8500_hsi_devices));
+#endif
+
 }
 
 MACHINE_START(U8500, "ST-Ericsson MOP500 platform")
diff --git a/arch/arm/mach-ux500/clock.c b/arch/arm/mach-ux500/clock.c
index 32ce908..cf6ff61 100644
--- a/arch/arm/mach-ux500/clock.c
+++ b/arch/arm/mach-ux500/clock.c
@@ -483,8 +483,8 @@ static struct clk_lookup u8500_common_clks[] = {
 	CLK(slimclk,	"slim",		NULL),
 	CLK(lcdclk,	"lcd",		NULL),
 	CLK(bmlclk,	"bml",		NULL),
-	CLK(hsitxclk,	"stm-hsi.0",	NULL),
-	CLK(hsirxclk,	"stm-hsi.1",	NULL),
+	CLK(hsitxclk,	"ste_hsi.0",	"hsit_hsitxclk"),
+	CLK(hsirxclk,	"ste_hsi.0",	"hsir_hsirxclk"),
 	CLK(hdmiclk,	"hdmi",		NULL),
 	CLK(apeatclk,	"apeat",	NULL),
 	CLK(apetraceclk,	"apetrace",	NULL),
@@ -544,8 +544,8 @@ static struct clk_lookup u8500_v1_clks[] = {
 	/* Peripheral Cluster #2 */
 	CLK(gpio1_v1,	"gpio.6",	NULL),
 	CLK(gpio1_v1,	"gpio.7",	NULL),
-	CLK(ssitx_v1,	"ssitx",	NULL),
-	CLK(ssirx_v1,	"ssirx",	NULL),
+	CLK(ssitx_v1,	"ste_hsi.0",	"hsit_hclk"),
+	CLK(ssirx_v1,	"ste_hsi.0",	"hsir_hclk"),
 	CLK(spi0_v1,	"spi0",		NULL),
 	CLK(sdi3_v1,	"sdi3",		NULL),
 	CLK(sdi1_v1,	"sdi1",		NULL),
diff --git a/arch/arm/mach-ux500/devices-db8500.c b/arch/arm/mach-ux500/devices-db8500.c
index 73b1740..2e685c1 100644
--- a/arch/arm/mach-ux500/devices-db8500.c
+++ b/arch/arm/mach-ux500/devices-db8500.c
@@ -18,6 +18,7 @@
 #include <mach/hardware.h>
 #include <mach/setup.h>
 
+#include <mach/hsi.h>
 #include "ste-dma40-db8500.h"
 
 static struct resource dma40_resources[] = {
@@ -195,3 +196,120 @@ struct platform_device u8500_ske_keypad_device = {
 	.num_resources = ARRAY_SIZE(keypad_resources),
 	.resource = keypad_resources,
 };
+
+/*
+ * HSI
+ */
+#define HSIR_OVERRUN(num) {			    \
+	.start  = IRQ_DB8500_HSIR_CH##num##_OVRRUN, \
+	.end    = IRQ_DB8500_HSIR_CH##num##_OVRRUN, \
+	.flags  = IORESOURCE_IRQ,		    \
+	.name   = "hsi_rx_overrun_ch"#num	    \
+}
+
+#define STE_HSI_PORT0_TX_CHANNEL_CFG(n) { \
+       .dir = STEDMA40_MEM_TO_PERIPH, \
+       .high_priority = false, \
+       .mode = STEDMA40_MODE_LOGICAL, \
+       .mode_opt = STEDMA40_LCHAN_SRC_LOG_DST_LOG, \
+       .src_dev_type = STEDMA40_DEV_SRC_MEMORY, \
+       .dst_dev_type = n,\
+       .src_info.big_endian = false,\
+       .src_info.data_width = STEDMA40_WORD_WIDTH,\
+       .dst_info.big_endian = false,\
+       .dst_info.data_width = STEDMA40_WORD_WIDTH,\
+},
+
+#define STE_HSI_PORT0_RX_CHANNEL_CFG(n) { \
+       .dir = STEDMA40_PERIPH_TO_MEM, \
+       .high_priority = false, \
+       .mode = STEDMA40_MODE_LOGICAL, \
+       .mode_opt = STEDMA40_LCHAN_SRC_LOG_DST_LOG, \
+       .src_dev_type = n,\
+       .dst_dev_type = STEDMA40_DEV_DST_MEMORY, \
+       .src_info.big_endian = false,\
+       .src_info.data_width = STEDMA40_WORD_WIDTH,\
+       .dst_info.big_endian = false,\
+       .dst_info.data_width = STEDMA40_WORD_WIDTH,\
+},
+
+static struct resource u8500_hsi_resources[] = {
+       {
+	       .start  = U8500_HSIR_BASE,
+	       .end    = U8500_HSIR_BASE + SZ_4K - 1,
+	       .flags  = IORESOURCE_MEM,
+	       .name   = "hsi_rx_base"
+       },
+       {
+	       .start  = U8500_HSIT_BASE,
+	       .end    = U8500_HSIT_BASE + SZ_4K - 1,
+	       .flags  = IORESOURCE_MEM,
+	       .name   = "hsi_tx_base"
+       },
+       {
+	       .start  = IRQ_DB8500_HSIRD0,
+	       .end    = IRQ_DB8500_HSIRD0,
+	       .flags  = IORESOURCE_IRQ,
+	       .name   = "hsi_rx_irq0"
+       },
+       {
+	       .start  = IRQ_DB8500_HSITD0,
+	       .end    = IRQ_DB8500_HSITD0,
+	       .flags  = IORESOURCE_IRQ,
+	       .name   = "hsi_tx_irq0"
+       },
+       {
+	       .start  = IRQ_DB8500_HSIR_EXCEP,
+	       .end    = IRQ_DB8500_HSIR_EXCEP,
+	       .flags  = IORESOURCE_IRQ,
+	       .name   = "hsi_rx_excep0"
+       },
+       HSIR_OVERRUN(0),
+       HSIR_OVERRUN(1),
+       HSIR_OVERRUN(2),
+       HSIR_OVERRUN(3),
+       HSIR_OVERRUN(4),
+       HSIR_OVERRUN(5),
+       HSIR_OVERRUN(6),
+       HSIR_OVERRUN(7),
+};
+
+#ifdef CONFIG_STE_DMA40
+static struct stedma40_chan_cfg ste_hsi_port0_dma_tx_cfg[] = {
+       STE_HSI_PORT0_TX_CHANNEL_CFG(DB8500_DMA_DEV20_SLIM0_CH0_TX_HSI_TX_CH0)
+       STE_HSI_PORT0_TX_CHANNEL_CFG(DB8500_DMA_DEV21_SLIM0_CH1_TX_HSI_TX_CH1)
+       STE_HSI_PORT0_TX_CHANNEL_CFG(DB8500_DMA_DEV22_SLIM0_CH2_TX_HSI_TX_CH2)
+       STE_HSI_PORT0_TX_CHANNEL_CFG(DB8500_DMA_DEV23_SLIM0_CH3_TX_HSI_TX_CH3)
+};
+
+static struct stedma40_chan_cfg ste_hsi_port0_dma_rx_cfg[] = {
+       STE_HSI_PORT0_RX_CHANNEL_CFG(DB8500_DMA_DEV20_SLIM0_CH0_RX_HSI_RX_CH0)
+       STE_HSI_PORT0_RX_CHANNEL_CFG(DB8500_DMA_DEV21_SLIM0_CH1_RX_HSI_RX_CH1)
+       STE_HSI_PORT0_RX_CHANNEL_CFG(DB8500_DMA_DEV22_SLIM0_CH2_RX_HSI_RX_CH2)
+       STE_HSI_PORT0_RX_CHANNEL_CFG(DB8500_DMA_DEV23_SLIM0_CH3_RX_HSI_RX_CH3)
+};
+#endif
+
+static struct ste_hsi_port_cfg ste_hsi_port0_cfg = {
+#ifdef CONFIG_STE_DMA40
+       .dma_filter = stedma40_filter,
+       .dma_tx_cfg = ste_hsi_port0_dma_tx_cfg,
+       .dma_rx_cfg = ste_hsi_port0_dma_rx_cfg
+#endif
+};
+
+struct ste_hsi_platform_data u8500_hsi_platform_data = {
+       .num_ports = 1,
+       .use_dma = 1,
+       .port_cfg = &ste_hsi_port0_cfg,
+};
+
+struct platform_device u8500_hsi_device = {
+       .dev = {
+		.platform_data = &u8500_hsi_platform_data,
+       },
+       .name = "ste_hsi",
+       .id = 0,
+       .resource = u8500_hsi_resources,
+       .num_resources = ARRAY_SIZE(u8500_hsi_resources)
+};
diff --git a/arch/arm/mach-ux500/include/mach/devices.h b/arch/arm/mach-ux500/include/mach/devices.h
index 020b636..176cda7 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -17,6 +17,7 @@ extern struct amba_device ux500_pl031_device;
 
 extern struct platform_device u8500_dma40_device;
 extern struct platform_device ux500_ske_keypad_device;
+extern struct platform_device u8500_hsi_device;
 
 void dma40_u8500ed_fixup(void);
 
diff --git a/arch/arm/mach-ux500/include/mach/hsi.h b/arch/arm/mach-ux500/include/mach/hsi.h
new file mode 100644
index 0000000..030e35e
--- /dev/null
+++ b/arch/arm/mach-ux500/include/mach/hsi.h
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ */
+
+#ifndef __MACH_HSI_H
+#define __MACH_HSI_H
+
+#include <plat/ste_dma40.h>
+
+/* HSIT register offsets */
+#define STE_HSI_TX_ID                  0x000
+#define STE_HSI_TX_MODE                0x004
+#define STE_HSI_TX_STATE               0x008
+#define STE_HSI_TX_IOSTATE             0x00C
+#define STE_HSI_TX_BUFSTATE            0x010
+#define STE_HSI_TX_DIVISOR             0x014
+#define STE_HSI_TX_PARITY              0x018
+#define STE_HSI_TX_BREAK               0x01C
+#define STE_HSI_TX_CHANNELS            0x020
+#define STE_HSI_TX_FLUSHBITS           0x024
+#define STE_HSI_TX_PRIORITY            0x028
+#define STE_HSI_TX_BURSTLEN            0x02C
+#define STE_HSI_TX_PREAMBLE            0x030
+#define STE_HSI_TX_DATASWAP            0x034
+#define STE_HSI_TX_FRAMELENX           0x080
+#define STE_HSI_TX_BUFFERX             0x0C0
+#define STE_HSI_TX_BASEX               0x100
+#define STE_HSI_TX_SPANX               0x140
+#define STE_HSI_TX_GAUGEX              0x180
+#define STE_HSI_TX_WATERMARKX          0x1C0
+#define STE_HSI_TX_DMAEN               0x200
+#define STE_HSI_TX_WATERMARKIS         0x204
+#define STE_HSI_TX_WATERMARKIM         0x208
+#define STE_HSI_TX_WATERMARKIC         0x20C
+#define STE_HSI_TX_WATERMARKID         0x210
+#define STE_HSI_TX_PERIPHID0           0xFE0
+#define STE_HSI_TX_PERIPHID1           0xFE4
+#define STE_HSI_TX_PERIPHID2           0xFE8
+#define STE_HSI_TX_PERIPHID3           0xFEC
+
+/* HSIR register offsets */
+#define STE_HSI_RX_ID                  0x000
+#define STE_HSI_RX_MODE                0x004
+#define STE_HSI_RX_STATE               0x008
+#define STE_HSI_RX_BUFSTATE            0x00C
+#define STE_HSI_RX_THRESHOLD           0x010
+#define STE_HSI_RX_PARITY              0x014
+#define STE_HSI_RX_DETECTOR            0x018
+#define STE_HSI_RX_EXCEP               0x01C
+#define STE_HSI_RX_ACK                 0x020
+#define STE_HSI_RX_CHANNELS            0x024
+#define STE_HSI_RX_REALTIME            0x028
+#define STE_HSI_RX_OVERRUN             0x02C
+#define STE_HSI_RX_OVERRUNACK          0x030
+#define STE_HSI_RX_PREAMBLE            0x034
+#define STE_HSI_RX_PIPEGAUGE           0x038
+#define STE_HSI_RX_STATICCONFID        0x03C
+#define STE_HSI_RX_BUFFERX             0x080
+#define STE_HSI_RX_FRAMELENX           0x0C0
+#define STE_HSI_RX_BASEX               0x100
+#define STE_HSI_RX_SPANX               0x140
+#define STE_HSI_RX_GAUGEX              0x180
+#define STE_HSI_RX_WATERMARKX          0x1C0
+#define STE_HSI_RX_DMAEN               0x200
+#define STE_HSI_RX_WATERMARKIS         0x204
+#define STE_HSI_RX_WATERMARKIM         0x208
+#define STE_HSI_RX_WATERMARKIC         0x20C
+#define STE_HSI_RX_WATERMARKID         0x210
+#define STE_HSI_RX_OVERRUNMIS          0x214
+#define STE_HSI_RX_OVERRUNIM           0x218
+#define STE_HSI_RX_EXCEPMIS            0x21C
+#define STE_HSI_RX_EXCEPIM             0x220
+#define STE_HSI_RX_PERIPHID0           0xFE0
+#define STE_HSI_RX_PERIPHID1           0xFE4
+#define STE_HSI_RX_PERIPHID2           0xFE8
+#define STE_HSI_RX_PERIPHID3           0xFEC
+
+/* HSI states */
+#define STE_HSI_STATE_IDLE             0x00
+#define STE_HSI_STATE_START            0x01
+#define STE_HSI_STATE_TRANSMIT         0x02
+#define STE_HSI_STATE_BREAK            0x03
+#define STE_HSI_STATE_FLUSH            0x04
+#define STE_HSI_STATE_HALT             0x05
+
+/* HSI exceptions */
+#define STE_HSI_EXCEP_TIMEOUT          0x01
+#define STE_HSI_EXCEP_OVERRUN          0x02
+#define STE_HSI_EXCEP_BREAK            0x04
+#define STE_HSI_EXCEP_PARITY           0x08
+
+/* HSI modes */
+#define STE_HSI_MODE_SLEEP             0x00
+#define STE_HSI_MODE_STREAM            0x01
+#define STE_HSI_MODE_FRAME             0x02
+#define STE_HSI_MODE_PIPELINED         0x03
+#define STE_HSI_MODE_FAILSAFE          0x04
+
+#define STE_HSI_MAX_BUFFERS            32
+
+/* Max channels of STE HSI controller */
+#define STE_HSI_MAX_CHANNELS           4
+
+struct stedma40_chan_cfg;
+
+struct ste_hsi_port_cfg {
+#ifdef CONFIG_STE_DMA40
+       bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
+       struct stedma40_chan_cfg *dma_tx_cfg;
+       struct stedma40_chan_cfg *dma_rx_cfg;
+#endif
+};
+
+struct ste_hsi_platform_data {
+       int num_ports;
+       int use_dma;
+       struct ste_hsi_port_cfg *port_cfg;
+};
+
+#endif
-- 
1.7.3.2

