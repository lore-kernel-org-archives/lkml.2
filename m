Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab2GaNju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:39:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53416 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab2GaNjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:39:44 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/19] ARM: ux500: Rename MSP board file to something more meaningful
Date: Tue, 31 Jul 2012 14:39:07 +0100
Message-Id: <1343741953-17828-14-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
References: <1343741953-17828-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'msp' board file does more than just register MSP devices. It
also registers some other components necessary to get audio working
on ux500 based platforms; such as the PCM and Machine Drivers. For
that reason we're changing the filename to be more encompassing -
'audio'.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/Makefile             |    2 +-
 arch/arm/mach-ux500/board-mop500-audio.c |  189 ++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500-msp.c   |  189 ------------------------------
 arch/arm/mach-ux500/board-mop500.c       |   10 +-
 arch/arm/mach-ux500/board-mop500.h       |    2 +-
 5 files changed, 196 insertions(+), 196 deletions(-)
 create mode 100644 arch/arm/mach-ux500/board-mop500-audio.c
 delete mode 100644 arch/arm/mach-ux500/board-mop500-msp.c

diff --git a/arch/arm/mach-ux500/Makefile b/arch/arm/mach-ux500/Makefile
index 026086f..1dc2cfa 100644
--- a/arch/arm/mach-ux500/Makefile
+++ b/arch/arm/mach-ux500/Makefile
@@ -12,6 +12,6 @@ obj-$(CONFIG_MACH_MOP500)	+= board-mop500.o board-mop500-sdi.o \
 				board-mop500-uib.o board-mop500-stuib.o \
 				board-mop500-u8500uib.o \
 				board-mop500-pins.o \
-				board-mop500-msp.o
+				board-mop500-audio.o
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
diff --git a/arch/arm/mach-ux500/board-mop500-audio.c b/arch/arm/mach-ux500/board-mop500-audio.c
new file mode 100644
index 0000000..7848cd8
--- /dev/null
+++ b/arch/arm/mach-ux500/board-mop500-audio.c
@@ -0,0 +1,189 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License terms: GNU General Public License (GPL), version 2
+ */
+
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/pinctrl/consumer.h>
+
+#include <plat/gpio-nomadik.h>
+#include <plat/pincfg.h>
+#include <plat/ste_dma40.h>
+
+#include <mach/devices.h>
+#include <mach/hardware.h>
+#include <mach/irqs.h>
+#include <mach/msp.h>
+
+#include "ste-dma40-db8500.h"
+#include "board-mop500.h"
+#include "devices-db8500.h"
+#include "pins-db8500.h"
+
+static struct stedma40_chan_cfg msp0_dma_rx = {
+	.high_priority = true,
+	.dir = STEDMA40_PERIPH_TO_MEM,
+
+	.src_dev_type = DB8500_DMA_DEV31_MSP0_RX_SLIM0_CH0_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+
+	.src_info.psize = STEDMA40_PSIZE_LOG_4,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+
+	/* data_width is set during configuration */
+};
+
+static struct stedma40_chan_cfg msp0_dma_tx = {
+	.high_priority = true,
+	.dir = STEDMA40_MEM_TO_PERIPH,
+
+	.src_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.dst_dev_type = DB8500_DMA_DEV31_MSP0_TX_SLIM0_CH0_TX,
+
+	.src_info.psize = STEDMA40_PSIZE_LOG_4,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+
+	/* data_width is set during configuration */
+};
+
+struct msp_i2s_platform_data msp0_platform_data = {
+	.id = MSP_I2S_0,
+	.msp_i2s_dma_rx = &msp0_dma_rx,
+	.msp_i2s_dma_tx = &msp0_dma_tx,
+};
+
+static struct stedma40_chan_cfg msp1_dma_rx = {
+	.high_priority = true,
+	.dir = STEDMA40_PERIPH_TO_MEM,
+
+	.src_dev_type = DB8500_DMA_DEV30_MSP3_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+
+	.src_info.psize = STEDMA40_PSIZE_LOG_4,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+
+	/* data_width is set during configuration */
+};
+
+static struct stedma40_chan_cfg msp1_dma_tx = {
+	.high_priority = true,
+	.dir = STEDMA40_MEM_TO_PERIPH,
+
+	.src_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.dst_dev_type = DB8500_DMA_DEV30_MSP1_TX,
+
+	.src_info.psize = STEDMA40_PSIZE_LOG_4,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+
+	/* data_width is set during configuration */
+};
+
+struct msp_i2s_platform_data msp1_platform_data = {
+	.id = MSP_I2S_1,
+	.msp_i2s_dma_rx = NULL,
+	.msp_i2s_dma_tx = &msp1_dma_tx,
+};
+
+static struct stedma40_chan_cfg msp2_dma_rx = {
+	.high_priority = true,
+	.dir = STEDMA40_PERIPH_TO_MEM,
+
+	.src_dev_type = DB8500_DMA_DEV14_MSP2_RX,
+	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+
+	/* MSP2 DMA doesn't work with PSIZE == 4 on DB8500v2 */
+	.src_info.psize = STEDMA40_PSIZE_LOG_1,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
+
+	/* data_width is set during configuration */
+};
+
+static struct stedma40_chan_cfg msp2_dma_tx = {
+	.high_priority = true,
+	.dir = STEDMA40_MEM_TO_PERIPH,
+
+	.src_dev_type = STEDMA40_DEV_DST_MEMORY,
+	.dst_dev_type = DB8500_DMA_DEV14_MSP2_TX,
+
+	.src_info.psize = STEDMA40_PSIZE_LOG_4,
+	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+
+	.use_fixed_channel = true,
+	.phy_channel = 1,
+
+	/* data_width is set during configuration */
+};
+
+static struct platform_device *db8500_add_msp_i2s(struct device *parent,
+			int id,
+			resource_size_t base, int irq,
+			struct msp_i2s_platform_data *pdata)
+{
+	struct platform_device *pdev;
+	struct resource res[] = {
+		DEFINE_RES_MEM(base, SZ_4K),
+		DEFINE_RES_IRQ(irq),
+	};
+
+	pr_info("Register platform-device 'ux500-msp-i2s', id %d, irq %d\n",
+		id, irq);
+	pdev = platform_device_register_resndata(parent, "ux500-msp-i2s", id,
+						res, ARRAY_SIZE(res),
+						pdata, sizeof(*pdata));
+	if (!pdev) {
+		pr_err("Failed to register platform-device 'ux500-msp-i2s.%d'!\n",
+			id);
+		return NULL;
+	}
+
+	return pdev;
+}
+
+/* Platform device for ASoC U8500 machine */
+static struct platform_device snd_soc_mop500 = {
+	.name = "snd-soc-mop500",
+	.id = 0,
+	.dev = {
+		.platform_data = NULL,
+	},
+};
+
+/* Platform device for Ux500-PCM */
+static struct platform_device ux500_pcm = {
+	.name = "ux500-pcm",
+	.id = 0,
+	.dev = {
+		.platform_data = NULL,
+	},
+};
+
+struct msp_i2s_platform_data msp2_platform_data = {
+	.id = MSP_I2S_2,
+	.msp_i2s_dma_rx = &msp2_dma_rx,
+	.msp_i2s_dma_tx = &msp2_dma_tx,
+};
+
+struct msp_i2s_platform_data msp3_platform_data = {
+	.id		= MSP_I2S_3,
+	.msp_i2s_dma_rx	= &msp1_dma_rx,
+	.msp_i2s_dma_tx	= NULL,
+};
+
+void mop500_audio_init(struct device *parent)
+{
+	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
+	platform_device_register(&snd_soc_mop500);
+
+	pr_info("Initialize MSP I2S-devices.\n");
+	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
+			   &msp0_platform_data);
+	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
+			   &msp1_platform_data);
+	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
+			   &msp2_platform_data);
+	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
+			   &msp3_platform_data);
+}
diff --git a/arch/arm/mach-ux500/board-mop500-msp.c b/arch/arm/mach-ux500/board-mop500-msp.c
deleted file mode 100644
index 19473f7..0000000
--- a/arch/arm/mach-ux500/board-mop500-msp.c
+++ /dev/null
@@ -1,189 +0,0 @@
-/*
- * Copyright (C) ST-Ericsson SA 2010
- *
- * License terms: GNU General Public License (GPL), version 2
- */
-
-#include <linux/platform_device.h>
-#include <linux/init.h>
-#include <linux/gpio.h>
-#include <linux/pinctrl/consumer.h>
-
-#include <plat/gpio-nomadik.h>
-#include <plat/pincfg.h>
-#include <plat/ste_dma40.h>
-
-#include <mach/devices.h>
-#include <mach/hardware.h>
-#include <mach/irqs.h>
-#include <mach/msp.h>
-
-#include "ste-dma40-db8500.h"
-#include "board-mop500.h"
-#include "devices-db8500.h"
-#include "pins-db8500.h"
-
-static struct stedma40_chan_cfg msp0_dma_rx = {
-	.high_priority = true,
-	.dir = STEDMA40_PERIPH_TO_MEM,
-
-	.src_dev_type = DB8500_DMA_DEV31_MSP0_RX_SLIM0_CH0_RX,
-	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
-};
-
-static struct stedma40_chan_cfg msp0_dma_tx = {
-	.high_priority = true,
-	.dir = STEDMA40_MEM_TO_PERIPH,
-
-	.src_dev_type = STEDMA40_DEV_DST_MEMORY,
-	.dst_dev_type = DB8500_DMA_DEV31_MSP0_TX_SLIM0_CH0_TX,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
-};
-
-struct msp_i2s_platform_data msp0_platform_data = {
-	.id = MSP_I2S_0,
-	.msp_i2s_dma_rx = &msp0_dma_rx,
-	.msp_i2s_dma_tx = &msp0_dma_tx,
-};
-
-static struct stedma40_chan_cfg msp1_dma_rx = {
-	.high_priority = true,
-	.dir = STEDMA40_PERIPH_TO_MEM,
-
-	.src_dev_type = DB8500_DMA_DEV30_MSP3_RX,
-	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
-};
-
-static struct stedma40_chan_cfg msp1_dma_tx = {
-	.high_priority = true,
-	.dir = STEDMA40_MEM_TO_PERIPH,
-
-	.src_dev_type = STEDMA40_DEV_DST_MEMORY,
-	.dst_dev_type = DB8500_DMA_DEV30_MSP1_TX,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	/* data_width is set during configuration */
-};
-
-struct msp_i2s_platform_data msp1_platform_data = {
-	.id = MSP_I2S_1,
-	.msp_i2s_dma_rx = NULL,
-	.msp_i2s_dma_tx = &msp1_dma_tx,
-};
-
-static struct stedma40_chan_cfg msp2_dma_rx = {
-	.high_priority = true,
-	.dir = STEDMA40_PERIPH_TO_MEM,
-
-	.src_dev_type = DB8500_DMA_DEV14_MSP2_RX,
-	.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
-
-	/* MSP2 DMA doesn't work with PSIZE == 4 on DB8500v2 */
-	.src_info.psize = STEDMA40_PSIZE_LOG_1,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
-
-	/* data_width is set during configuration */
-};
-
-static struct stedma40_chan_cfg msp2_dma_tx = {
-	.high_priority = true,
-	.dir = STEDMA40_MEM_TO_PERIPH,
-
-	.src_dev_type = STEDMA40_DEV_DST_MEMORY,
-	.dst_dev_type = DB8500_DMA_DEV14_MSP2_TX,
-
-	.src_info.psize = STEDMA40_PSIZE_LOG_4,
-	.dst_info.psize = STEDMA40_PSIZE_LOG_4,
-
-	.use_fixed_channel = true,
-	.phy_channel = 1,
-
-	/* data_width is set during configuration */
-};
-
-static struct platform_device *db8500_add_msp_i2s(struct device *parent,
-			int id,
-			resource_size_t base, int irq,
-			struct msp_i2s_platform_data *pdata)
-{
-	struct platform_device *pdev;
-	struct resource res[] = {
-		DEFINE_RES_MEM(base, SZ_4K),
-		DEFINE_RES_IRQ(irq),
-	};
-
-	pr_info("Register platform-device 'ux500-msp-i2s', id %d, irq %d\n",
-		id, irq);
-	pdev = platform_device_register_resndata(parent, "ux500-msp-i2s", id,
-						res, ARRAY_SIZE(res),
-						pdata, sizeof(*pdata));
-	if (!pdev) {
-		pr_err("Failed to register platform-device 'ux500-msp-i2s.%d'!\n",
-			id);
-		return NULL;
-	}
-
-	return pdev;
-}
-
-/* Platform device for ASoC U8500 machine */
-static struct platform_device snd_soc_mop500 = {
-	.name = "snd-soc-mop500",
-	.id = 0,
-	.dev = {
-		.platform_data = NULL,
-	},
-};
-
-/* Platform device for Ux500-PCM */
-static struct platform_device ux500_pcm = {
-	.name = "ux500-pcm",
-	.id = 0,
-	.dev = {
-		.platform_data = NULL,
-	},
-};
-
-struct msp_i2s_platform_data msp2_platform_data = {
-	.id = MSP_I2S_2,
-	.msp_i2s_dma_rx = &msp2_dma_rx,
-	.msp_i2s_dma_tx = &msp2_dma_tx,
-};
-
-struct msp_i2s_platform_data msp3_platform_data = {
-	.id		= MSP_I2S_3,
-	.msp_i2s_dma_rx	= &msp1_dma_rx,
-	.msp_i2s_dma_tx	= NULL,
-};
-
-void mop500_msp_init(struct device *parent)
-{
-	pr_info("%s: Register platform-device 'snd-soc-u8500'.\n", __func__);
-	platform_device_register(&snd_soc_mop500);
-
-	pr_info("Initialize MSP I2S-devices.\n");
-	db8500_add_msp_i2s(parent, 0, U8500_MSP0_BASE, IRQ_DB8500_MSP0,
-			   &msp0_platform_data);
-	db8500_add_msp_i2s(parent, 1, U8500_MSP1_BASE, IRQ_DB8500_MSP1,
-			   &msp1_platform_data);
-	db8500_add_msp_i2s(parent, 2, U8500_MSP2_BASE, IRQ_DB8500_MSP2,
-			   &msp2_platform_data);
-	db8500_add_msp_i2s(parent, 3, U8500_MSP3_BASE, IRQ_DB8500_MSP1,
-			   &msp3_platform_data);
-}
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 2ef26c8..202df4b 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -607,7 +607,7 @@ static void __init mop500_init_machine(void)
 	mop500_i2c_init(parent);
 	mop500_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_msp_init(parent);
+	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	u8500_cryp1_hash1_init(parent);
@@ -641,7 +641,7 @@ static void __init snowball_init_machine(void)
 	mop500_i2c_init(parent);
 	snowball_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_msp_init(parent);
+	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	/* This board has full regulator constraints */
@@ -673,7 +673,7 @@ static void __init hrefv60_init_machine(void)
 	mop500_i2c_init(parent);
 	hrefv60_sdi_init(parent);
 	mop500_spi_init(parent);
-	mop500_msp_init(parent);
+	mop500_audio_init(parent);
 	mop500_uart_init(parent);
 
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
@@ -802,7 +802,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		mop500_sdi_init(parent);
-		mop500_msp_init(parent);
+		mop500_audio_init(parent);
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
 		i2c_register_board_info(2, mop500_i2c2_devices,
@@ -821,7 +821,7 @@ static void __init u8500_init_machine(void)
 				ARRAY_SIZE(mop500_platform_devs));
 
 		hrefv60_sdi_init(parent);
-		mop500_msp_init(parent);
+		mop500_audio_init(parent);
 
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c0_devs -= NUM_PRE_V60_I2C0_DEVICES;
diff --git a/arch/arm/mach-ux500/board-mop500.h b/arch/arm/mach-ux500/board-mop500.h
index e56c983..a0f920d 100644
--- a/arch/arm/mach-ux500/board-mop500.h
+++ b/arch/arm/mach-ux500/board-mop500.h
@@ -97,7 +97,7 @@ void __init mop500_stuib_init(void);
 void __init mop500_pinmaps_init(void);
 void __init snowball_pinmaps_init(void);
 void __init hrefv60_pinmaps_init(void);
-void mop500_msp_init(struct device *parent);
+void mop500_audio_init(struct device *parent);
 
 int __init mop500_uib_init(void);
 void mop500_uib_i2c_add(int busnum, struct i2c_board_info *info,
-- 
1.7.9.5

