Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab2CLQfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 12:35:36 -0400
Received: from mail.meprolight.com ([194.90.149.17]:45226 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751872Ab2CLQfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 12:35:34 -0400
From: Alex <alexg@meprolight.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <g.liakhovetski@gmx.de>,
        <fabio.estevam@freescale.com>, <linux-media@vger.kernel.org>,
        Alex <alexg@meprolight.com>
Subject: [PATCH] i.MX35-PDK: Add Camera support
Date: Mon, 12 Mar 2012 18:28:51 +0200
Message-ID: <1331569731-30973-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In i.MX35-PDK, OV2640  camera is populated on the
personality board. This camera is registered as a subdevice via soc-camera interface.

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 arch/arm/mach-imx/mach-mx35_3ds.c |   87 +++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index a477e46..55f5b0a 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -35,6 +35,8 @@
 #include <asm/mach/time.h>
 #include <asm/mach/map.h>
 
+#include <asm/memblock.h>
+
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/iomux-mx35.h>
@@ -43,6 +45,8 @@
 
 #include "devices-imx35.h"
 
+#include <media/soc_camera.h>
+
 #define EXPIO_PARENT_INT	gpio_to_irq(IMX_GPIO_NR(1, 1))
 
 static const struct imxuart_platform_data uart_pdata __initconst = {
@@ -145,6 +149,21 @@ static iomux_v3_cfg_t mx35pdk_pads[] = {
 	MX35_PAD_CONTRAST__IPU_DISPB_CONTR,
 	MX35_PAD_D3_REV__IPU_DISPB_D3_REV,
 	MX35_PAD_D3_CLS__IPU_DISPB_D3_CLS,
+	/* CSI */
+	MX35_PAD_TX1__IPU_CSI_D_6,
+	MX35_PAD_TX0__IPU_CSI_D_7,
+	MX35_PAD_CSI_D8__IPU_CSI_D_8,
+	MX35_PAD_CSI_D9__IPU_CSI_D_9,
+	MX35_PAD_CSI_D10__IPU_CSI_D_10,
+	MX35_PAD_CSI_D11__IPU_CSI_D_11,
+	MX35_PAD_CSI_D12__IPU_CSI_D_12,
+	MX35_PAD_CSI_D13__IPU_CSI_D_13,
+	MX35_PAD_CSI_D14__IPU_CSI_D_14,
+	MX35_PAD_CSI_D15__IPU_CSI_D_15,
+	MX35_PAD_CSI_HSYNC__IPU_CSI_HSYNC,
+	MX35_PAD_CSI_MCLK__IPU_CSI_MCLK,
+	MX35_PAD_CSI_PIXCLK__IPU_CSI_PIXCLK,
+	MX35_PAD_CSI_VSYNC__IPU_CSI_VSYNC,
 };
 
 static const struct fb_videomode fb_modedb[] = {
@@ -177,6 +196,64 @@ static struct mx3fb_platform_data mx3fb_pdata __initdata = {
 	.num_modes	= ARRAY_SIZE(fb_modedb),
 };
 
+/*
+ * Camera support
+ */
+static phys_addr_t mx3_camera_base __initdata;
+#define MX35_3DS_CAMERA_BUF_SIZE SZ_8M
+
+static const struct mx3_camera_pdata mx35_3ds_camera_pdata __initconst = {
+	.flags = MX3_CAMERA_DATAWIDTH_8,
+	.mclk_10khz = 2000,
+};
+
+static int __init imx35_3ds_init_camera(void)
+{
+	int dma, ret = -ENOMEM;
+	struct platform_device *pdev =
+		imx35_alloc_mx3_camera(&mx35_3ds_camera_pdata);
+
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	if (!mx3_camera_base)
+		goto err;
+
+	dma = dma_declare_coherent_memory(&pdev->dev,
+					mx3_camera_base, mx3_camera_base,
+					MX35_3DS_CAMERA_BUF_SIZE,
+					DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
+
+	if (!(dma & DMA_MEMORY_MAP))
+		goto err;
+
+	ret = platform_device_add(pdev);
+	if (ret)
+err:
+		platform_device_put(pdev);
+
+	return ret;
+}
+
+static struct i2c_board_info mx35_3ds_i2c_camera = {
+	I2C_BOARD_INFO("ov2640", 0x30),
+};
+
+static struct soc_camera_link iclink_ov2640 = {
+	.bus_id		= 0,
+	.board_info	= &mx35_3ds_i2c_camera,
+	.i2c_adapter_id	= 0,
+	.power		= NULL,
+};
+
+static struct platform_device mx35_3ds_ov2640 = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
+		.platform_data = &iclink_ov2640,
+	},
+};
+
 static int mx35_3ds_otg_init(struct platform_device *pdev)
 {
 	return mx35_initialize_usb_hw(pdev->id, MXC_EHCI_INTERNAL_PHY);
@@ -261,6 +338,8 @@ static void __init mx35_3ds_init(void)
 	imx35_add_imx_i2c0(&mx35_3ds_i2c0_data);
 	imx35_add_ipu_core(&mx35_3ds_ipu_data);
 	imx35_add_mx3_sdc_fb(&mx3fb_pdata);
+	platform_device_register(&mx35_3ds_ov2640);
+	imx35_3ds_init_camera();
 }
 
 static void __init mx35pdk_timer_init(void)
@@ -272,6 +351,13 @@ struct sys_timer mx35pdk_timer = {
 	.init	= mx35pdk_timer_init,
 };
 
+static void __init mx35_3ds_reserve(void)
+{
+	/* reserve MX35_3DS_CAMERA_BUF_SIZE bytes for mx3-camera */
+	mx3_camera_base = arm_memblock_steal(MX35_3DS_CAMERA_BUF_SIZE,
+					 MX35_3DS_CAMERA_BUF_SIZE);
+}
+
 MACHINE_START(MX35_3DS, "Freescale MX35PDK")
 	/* Maintainer: Freescale Semiconductor, Inc */
 	.atag_offset = 0x100,
@@ -281,5 +367,6 @@ MACHINE_START(MX35_3DS, "Freescale MX35PDK")
 	.handle_irq = imx35_handle_irq,
 	.timer = &mx35pdk_timer,
 	.init_machine = mx35_3ds_init,
+	.reserve = mx35_3ds_reserve,
 	.restart	= mxc_restart,
 MACHINE_END
-- 
1.7.0.4

