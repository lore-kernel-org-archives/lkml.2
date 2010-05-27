Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab0E0O6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:58:24 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:36494 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842Ab0E0O6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:58:17 -0400
From: Dinh.Nguyen@freescale.com
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       xiao-lizhang@freescale.com, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv2 2.6.34 1/2] mx5: Add i2c to Freescale MX51 Babbage HW
Date: Thu, 27 May 2010 09:57:48 -0500
Message-Id: <1274972269-6946-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

This patch adds I2C functionality to the Freescale MX51 Babbage HW.
The patch adds device structures, i2c board slave device defines,
IOMUX pin defines, and clocks.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/mach-mx5/clock-mx51.c              |   11 +++++
 arch/arm/mach-mx5/devices.c                 |   58 +++++++++++++++++++++++++++
 arch/arm/mach-mx5/devices.h                 |    3 +
 arch/arm/plat-mxc/include/mach/iomux-mx51.h |   18 ++++++---
 4 files changed, 84 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-mx5/clock-mx51.c b/arch/arm/mach-mx5/clock-mx51.c
index d9f612d..fd24092 100644
--- a/arch/arm/mach-mx5/clock-mx51.c
+++ b/arch/arm/mach-mx5/clock-mx51.c
@@ -798,6 +798,14 @@ DEFINE_CLOCK(gpt_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG9_OFFSET,
 DEFINE_CLOCK(gpt_ipg_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG10_OFFSET,
 	NULL,  NULL, &ipg_clk, NULL);
 
+/* I2C */
+DEFINE_CLOCK(i2c1_clk, 0, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG9_OFFSET,
+	NULL, NULL, &ipg_clk, NULL);
+DEFINE_CLOCK(i2c2_clk, 1, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG10_OFFSET,
+	NULL, NULL, &ipg_clk, NULL);
+DEFINE_CLOCK(hsi2c_clk, 0, MXC_CCM_CCGR1, MXC_CCM_CCGRx_CG11_OFFSET,
+	NULL, NULL, &ipg_clk, NULL);
+
 /* FEC */
 DEFINE_CLOCK(fec_clk, 0, MXC_CCM_CCGR2, MXC_CCM_CCGRx_CG12_OFFSET,
 	NULL,  NULL, &ipg_clk, NULL);
@@ -815,6 +823,9 @@ static struct clk_lookup lookups[] = {
 	_REGISTER_CLOCK("imx-uart.2", NULL, uart3_clk)
 	_REGISTER_CLOCK(NULL, "gpt", gpt_clk)
 	_REGISTER_CLOCK("fec.0", NULL, fec_clk)
+	_REGISTER_CLOCK("imx-i2c.0", NULL, i2c1_clk)
+	_REGISTER_CLOCK("imx-i2c.1", NULL, i2c2_clk)
+	_REGISTER_CLOCK("imx-i2c.2", NULL, hsi2c_clk)
 	_REGISTER_CLOCK("mxc-ehci.0", "usb", usboh3_clk)
 	_REGISTER_CLOCK("mxc-ehci.0", "usb_ahb", ahb_clk)
 	_REGISTER_CLOCK("mxc-ehci.1", "usb", usboh3_clk)
diff --git a/arch/arm/mach-mx5/devices.c b/arch/arm/mach-mx5/devices.c
index 23850e6..922a70e 100644
--- a/arch/arm/mach-mx5/devices.c
+++ b/arch/arm/mach-mx5/devices.c
@@ -93,6 +93,64 @@ struct platform_device mxc_fec_device = {
 	.resource = mxc_fec_resources,
 };
 
+static struct resource mxc_i2c0_resources[] = {
+	{
+		.start = MX51_I2C1_BASE_ADDR,
+		.end = MX51_I2C1_BASE_ADDR + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = MX51_MXC_INT_I2C1,
+		.end = MX51_MXC_INT_I2C1,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device mxc_i2c_device0 = {
+	.name = "imx-i2c",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(mxc_i2c0_resources),
+	.resource = mxc_i2c0_resources,
+};
+
+static struct resource mxc_i2c1_resources[] = {
+	{
+		.start = MX51_I2C2_BASE_ADDR,
+		.end = MX51_I2C2_BASE_ADDR + SZ_4K - 1,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = MX51_MXC_INT_I2C2,
+		.end = MX51_MXC_INT_I2C2,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device mxc_i2c_device1 = {
+	.name = "imx-i2c",
+	.id = 1,
+	.num_resources = ARRAY_SIZE(mxc_i2c1_resources),
+	.resource = mxc_i2c1_resources,
+};
+
+static struct resource mxc_hsi2c_resources[] = {
+	{
+		.start = MX51_HSI2C_DMA_BASE_ADDR,
+		.end = MX51_HSI2C_DMA_BASE_ADDR + SZ_16K - 1,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = MX51_MXC_INT_HS_I2C,
+		.end = MX51_MXC_INT_HS_I2C,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+struct platform_device mxc_hsi2c_device = {
+	.name = "imx-i2c",
+	.id = 2,
+	.num_resources = ARRAY_SIZE(mxc_hsi2c_resources),
+	.resource = mxc_hsi2c_resources
+};
+
 static u64 usb_dma_mask = DMA_BIT_MASK(32);
 
 static struct resource usbotg_resources[] = {
diff --git a/arch/arm/mach-mx5/devices.h b/arch/arm/mach-mx5/devices.h
index 0494d6b..d0451bf 100644
--- a/arch/arm/mach-mx5/devices.h
+++ b/arch/arm/mach-mx5/devices.h
@@ -5,3 +5,6 @@ extern struct platform_device mxc_fec_device;
 extern struct platform_device mxc_usbdr_host_device;
 extern struct platform_device mxc_usbh1_device;
 extern struct platform_device mxc_usbdr_udc_device;
+extern struct platform_device mxc_i2c_device0;
+extern struct platform_device mxc_i2c_device1;
+extern struct platform_device mxc_hsi2c_device;
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
index ab0f95d..6ea6861 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
@@ -38,6 +38,8 @@ typedef enum iomux_config {
 				PAD_CTL_SRE_FAST)
 #define MX51_UART3_PAD_CTRL	(PAD_CTL_PKE | PAD_CTL_DSE_HIGH | \
 				PAD_CTL_SRE_FAST)
+#define MX51_I2C_PAD_CTRL		(PAD_CTL_SRE_FAST | PAD_CTL_ODE | \
++				PAD_CTL_DSE_HIGH | PAD_CTL_PUS_100K_UP | PAD_CTL_HYS)
 #define MX51_USBH1_PAD_CTRL	(PAD_CTL_SRE_FAST | PAD_CTL_DSE_HIGH | \
 				PAD_CTL_PUS_100K_UP | PAD_CTL_PUE | \
 				PAD_CTL_PKE | PAD_CTL_HYS)
@@ -57,10 +59,12 @@ typedef enum iomux_config {
 
 /*						PAD      MUX   ALT INPSE PATH PADCTRL */
 
-#define MX51_PAD_GPIO_2_0__EIM_D16	IOMUX_PAD(0x3f0, 0x05c, 1, 0x0,   0, NO_PAD_CTRL)
+#define MX51_PAD_EIM_D16__I2C1_SDA	IOMUX_PAD(0x3f0, 0x05c, IOMUX_CONFIG_ALT4 | IOMUX_CONFIG_SION, \
+					0x09b4, 0, MX51_I2C_PAD_CTRL)
 #define MX51_PAD_GPIO_2_1__EIM_D17	IOMUX_PAD(0x3f4, 0x060, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_2_2__EIM_D18	IOMUX_PAD(0x3f8, 0x064, 1, 0x0,   0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_2_3__EIM_D19	IOMUX_PAD(0x3fc, 0x068, 1, 0x0,   0, NO_PAD_CTRL)
+#define MX51_PAD_EIM_D19__I2C1_SCL	IOMUX_PAD(0x3fc, 0x068, IOMUX_CONFIG_ALT4 | IOMUX_CONFIG_SION, \
+					0x09b0, 0, MX51_I2C_PAD_CTRL)
 #define MX51_PAD_GPIO_2_4__EIM_D20	IOMUX_PAD(0x400, 0x06c, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_2_5__EIM_D21	IOMUX_PAD(0x404, 0x070, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_EIM_D21__GPIO_2_5	IOMUX_PAD(0x404, 0x070, IOMUX_CONFIG_ALT1, 0x0,   0, MX51_GPIO_PAD_CTRL)
@@ -179,8 +183,8 @@ typedef enum iomux_config {
 #define MX51_PAD_GPIO_4_14__CSI2_HSYNC	IOMUX_PAD(0x5E0, 0x1F0, 3, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_4_15__CSI2_PIXCLK	IOMUX_PAD(0x5E4, 0x1F4, 3, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_CSI2_PKE0__CSI2_PKE0	IOMUX_PAD(0x81C, 0x0, 0, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_4_16__I2C1_CLK	IOMUX_PAD(0x5E8, 0x1F8, 3, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_GPIO_4_17__I2C1_DAT	IOMUX_PAD(0x5EC, 0x1FC, 3, 0x0, 0, NO_PAD_CTRL)
+#define MX51_PAD_I2C1_CLK__HSI2C_CLK	IOMUX_PAD(0x5E8, 0x1F8, IOMUX_CONFIG_ALT0, 0x0, 0, NO_PAD_CTRL)
+#define MX51_PAD_I2C1_DAT__HSI2C_DAT	IOMUX_PAD(0x5EC, 0x1FC, IOMUX_CONFIG_ALT0, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_4_18__AUD3_BB_TXD	IOMUX_PAD(0x5F0, 0x200, 3, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_4_19__AUD3_BB_RXD	IOMUX_PAD(0x5F4, 0x204, 3, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_GPIO_4_20__AUD3_BB_CK	IOMUX_PAD(0x5F8, 0x208, 3, 0x0, 0, NO_PAD_CTRL)
@@ -213,8 +217,10 @@ typedef enum iomux_config {
 #define MX51_PAD_KEY_COL1__KEY_COL1	IOMUX_PAD(0x650, 0x260, 0, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_KEY_COL2__KEY_COL2	IOMUX_PAD(0x654, 0x264, 0, 0x0, 0, NO_PAD_CTRL)
 #define MX51_PAD_KEY_COL3__KEY_COL3	IOMUX_PAD(0x658, 0x268, 0, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_KEY_COL4__KEY_COL4	IOMUX_PAD(0x65C, 0x26C, 0, 0x0, 0, NO_PAD_CTRL)
-#define MX51_PAD_KEY_COL5__KEY_COL5	IOMUX_PAD(0x660, 0x270, 0, 0x0, 0, NO_PAD_CTRL)
+#define MX51_PAD_KEY_COL4__I2C2_SCL	IOMUX_PAD(0x65C, 0x26C, IOMUX_CONFIG_ALT3 | IOMUX_CONFIG_SION, \
+					0x09b8, 1, MX51_I2C_PAD_CTRL)
+#define MX51_PAD_KEY_COL5__I2C2_SDA	IOMUX_PAD(0x660, 0x270, IOMUX_CONFIG_ALT3 | IOMUX_CONFIG_SION, \
+					0x09bc, 1, MX51_I2C_PAD_CTRL)
 #define MX51_PAD_USBH1_CLK__USBH1_CLK	IOMUX_PAD(0x678, 0x278, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
 #define MX51_PAD_USBH1_DIR__USBH1_DIR	IOMUX_PAD(0x67C, 0x27C, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
 #define MX51_PAD_USBH1_STP__USBH1_STP	IOMUX_PAD(0x680, 0x280, IOMUX_CONFIG_ALT0, 0x0, 0, MX51_USBH1_PAD_CTRL)
-- 
1.6.0.4

