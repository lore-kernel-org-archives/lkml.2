Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab0D0KP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:15:56 -0400
Received: from mail.renesas.com ([202.234.163.13]:42077 "EHLO
	mail01.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754043Ab0D0KPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:15:53 -0400
X-AuditID: ac140384-00000008000004f6-8c-4bd6b94631eb
Date: Tue, 27 Apr 2010 19:15:32 +0900
From: Yusuke Goda <yusuke.goda.sx@renesas.com>
Subject: [PATCH 2/2] sh: Add support MMCIF for ecovec
To: linux-sh@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, akpm@linux-foundation.org,
       ben@decadent.org.uk, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <4BD6B944.1090606@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 This patch adds MMCIF platform data for the Ecovec board.

Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
---
 arch/sh/boards/mach-ecovec24/setup.c |   86 +++++++++++++++++++++++++++++++++-
 1 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 6c13b92..55bf3d6 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -26,6 +26,8 @@
 #include <linux/input.h>
 #include <linux/input/sh_keysc.h>
 #include <linux/mfd/sh_mobile_sdhi.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sh_mmcif.h>
 #include <video/sh_mobile_lcdc.h>
 #include <sound/sh_fsi.h>
 #include <media/sh_mobile_ceu.h>
@@ -435,7 +437,7 @@ static struct i2c_board_info ts_i2c_clients = {
 };

 #ifdef CONFIG_MFD_SH_MOBILE_SDHI
-/* SHDI0 */
+/* SDHI0 */
 static void sdhi0_set_pwr(struct platform_device *pdev, int state)
 {
 	gpio_set_value(GPIO_PTB6, state);
@@ -471,7 +473,8 @@ static struct platform_device sdhi0_device = {
 	},
 };

-/* SHDI1 */
+#if !defined(CONFIG_MMC_SH_MMCIF)
+/* SDHI1 */
 static void sdhi1_set_pwr(struct platform_device *pdev, int state)
 {
 	gpio_set_value(GPIO_PTB7, state);
@@ -506,6 +509,7 @@ static struct platform_device sdhi1_device = {
 		.hwblk_id = HWBLK_SDHI1,
 	},
 };
+#endif /* CONFIG_MMC_SH_MMCIF */

 #else

@@ -771,6 +775,58 @@ static struct platform_device irda_device = {
 	.resource       = irda_resources,
 };

+#if defined(CONFIG_MMC_SH_MMCIF)
+/* SH_MMCIF */
+static void mmcif_set_pwr(struct platform_device *pdev, int state)
+{
+	gpio_set_value(GPIO_PTB7, state);
+}
+
+static void mmcif_down_pwr(struct platform_device *pdev)
+{
+	gpio_set_value(GPIO_PTB7, 0);
+}
+
+static struct resource sh_mmcif_resources[] = {
+	[0] = {
+		.name	= "SH_MMCIF",
+		.start	= 0xA4CA0000,
+		.end	= 0xA4CA00FF,
+		.flags	= IORESOURCE_MEM,
+	},
+	[1] = {
+		/* MMC2I */
+		.start	= 29,
+		.flags	= IORESOURCE_IRQ,
+	},
+	[2] = {
+		/* MMC3I */
+		.start	= 30,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+struct sh_mmcif_plat_data sh_mmcif_plat = {
+	.set_pwr	= mmcif_set_pwr,
+	.down_pwr	= mmcif_down_pwr,
+	.sup_pclk	= 0, /* SH7724: Max Pclk/2 */
+	.caps		= MMC_CAP_4_BIT_DATA |
+			  MMC_CAP_8_BIT_DATA |
+			  MMC_CAP_NEEDS_POLL,
+	.ocr		= MMC_VDD_32_33 | MMC_VDD_33_34,
+};
+
+static struct platform_device sh_mmcif_device = {
+	.name		= "sh_mmcif",
+	.id		= 0,
+	.dev		= {
+		.platform_data		= &sh_mmcif_plat,
+	},
+	.num_resources	= ARRAY_SIZE(sh_mmcif_resources),
+	.resource	= sh_mmcif_resources,
+};
+#endif
+
 static struct platform_device *ecovec_devices[] __initdata = {
 	&heartbeat_device,
 	&nor_flash_device,
@@ -783,7 +839,9 @@ static struct platform_device *ecovec_devices[] __initdata = {
 	&keysc_device,
 #ifdef CONFIG_MFD_SH_MOBILE_SDHI
 	&sdhi0_device,
+#if !defined(CONFIG_MMC_SH_MMCIF)
 	&sdhi1_device,
+#endif
 #else
 	&msiof0_device,
 #endif
@@ -792,6 +850,9 @@ static struct platform_device *ecovec_devices[] __initdata = {
 	&camera_devices[2],
 	&fsi_device,
 	&irda_device,
+#if defined(CONFIG_MMC_SH_MMCIF)
+	&sh_mmcif_device,
+#endif
 };

 #ifdef CONFIG_I2C
@@ -1085,6 +1146,7 @@ static int __init arch_setup(void)
 	gpio_request(GPIO_PTB6, NULL);
 	gpio_direction_output(GPIO_PTB6, 0);

+#if !defined(CONFIG_MMC_SH_MMCIF)
 	/* enable SDHI1 on CN12 (needs DS2.6,7 set to ON,OFF) */
 	gpio_request(GPIO_FN_SDHI1CD,  NULL);
 	gpio_request(GPIO_FN_SDHI1WP,  NULL);
@@ -1099,6 +1161,7 @@ static int __init arch_setup(void)

 	/* I/O buffer drive ability is high for SDHI1 */
 	__raw_writew((__raw_readw(IODRIVEA) & ~0x3000) | 0x2000 , IODRIVEA);
+#endif /* CONFIG_MMC_SH_MMCIF */
 #else
 	/* enable MSIOF0 on CN11 (needs DS2.4 set to OFF) */
 	gpio_request(GPIO_FN_MSIOF0_TXD, NULL);
@@ -1168,6 +1231,25 @@ static int __init arch_setup(void)
 	gpio_request(GPIO_PTU5, NULL);
 	gpio_direction_output(GPIO_PTU5, 0);

+#if defined(CONFIG_MMC_SH_MMCIF)
+	/* enable MMCIF (needs DS2.6,7 set to OFF,ON) */
+	gpio_request(GPIO_FN_MMC_D7, NULL);
+	gpio_request(GPIO_FN_MMC_D6, NULL);
+	gpio_request(GPIO_FN_MMC_D5, NULL);
+	gpio_request(GPIO_FN_MMC_D4, NULL);
+	gpio_request(GPIO_FN_MMC_D3, NULL);
+	gpio_request(GPIO_FN_MMC_D2, NULL);
+	gpio_request(GPIO_FN_MMC_D1, NULL);
+	gpio_request(GPIO_FN_MMC_D0, NULL);
+	gpio_request(GPIO_FN_MMC_CLK, NULL);
+	gpio_request(GPIO_FN_MMC_CMD, NULL);
+	gpio_request(GPIO_PTB7, NULL);
+	gpio_direction_output(GPIO_PTB7, 0);
+
+	/* I/O buffer drive ability is high for MMCIF */
+	__raw_writew((__raw_readw(IODRIVEA) & ~0x3000) | 0x2000 , IODRIVEA);
+#endif
+
 	/* enable I2C device */
 	i2c_register_board_info(0, i2c0_devices,
 				ARRAY_SIZE(i2c0_devices));
-- 
1.7.0



