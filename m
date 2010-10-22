Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab0JVQyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:54:22 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:35485
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597Ab0JVQyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:54:21 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <bryan.wu@canonical.com>,
        <amit.kucheria@canonical.com>, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv5 1/3] ARM: mx5: Add gpio-keys to mx51 babbage board
Date: Fri, 22 Oct 2010 11:56:13 -0500
Message-ID: <1287766575-4092-1-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add functionality for the power button on MX51 Babbage board.

This patch is based on Sascha Hauer's imx/linux-2.6 for-rmk tree.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/configs/mx51_defconfig        |    1 +
 arch/arm/mach-mx5/board-mx51_babbage.c |   22 ++++++++++++++++++++++
 arch/arm/mach-mx5/devices-imx51.h      |    2 ++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
index 163cfee..5c7a872 100644
--- a/arch/arm/configs/mx51_defconfig
+++ b/arch/arm/configs/mx51_defconfig
@@ -82,6 +82,7 @@ CONFIG_FEC=y
 CONFIG_INPUT_FF_MEMLESS=m
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
+CONFIG_KEYBOARD_GPIO=y
 CONFIG_INPUT_EVBUG=m
 CONFIG_MOUSE_PS2=m
 CONFIG_MOUSE_PS2_ELANTECH=y
diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index 23ee4a4..8458852 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -18,6 +18,8 @@
 #include <linux/io.h>
 #include <linux/fsl_devices.h>
 #include <linux/fec.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
 
 #include <mach/common.h>
 #include <mach/hardware.h>
@@ -37,6 +39,7 @@
 #define BABBAGE_USBH1_STP	(0*32 + 27)	/* GPIO_1_27 */
 #define BABBAGE_PHY_RESET	(1*32 + 5)	/* GPIO_2_5 */
 #define BABBAGE_FEC_PHY_RESET	(1*32 + 14)	/* GPIO_2_14 */
+#define BABBAGE_POWER_KEY	(1*32 + 21)	/* GPIO_2_21 */
 
 /* USB_CTRL_1 */
 #define MX51_USB_CTRL_1_OFFSET			0x10
@@ -46,6 +49,21 @@
 #define	MX51_USB_PLL_DIV_19_2_MHZ	0x01
 #define	MX51_USB_PLL_DIV_24_MHZ	0x02
 
+static struct gpio_keys_button babbage_buttons[] = {
+	{
+		.gpio		= BABBAGE_POWER_KEY,
+		.code		= BTN_0,
+		.desc		= "PWR",
+		.active_low	= 1,
+		.wakeup		= 1,
+	},
+};
+
+static const struct gpio_keys_platform_data imx_button_data __initconst = {
+	.buttons	= babbage_buttons,
+	.nbuttons	= ARRAY_SIZE(babbage_buttons),
+};
+
 static struct pad_desc mx51babbage_pads[] = {
 	/* UART1 */
 	MX51_PAD_UART1_RXD__UART1_RXD,
@@ -112,6 +130,9 @@ static struct pad_desc mx51babbage_pads[] = {
 
 	/* FEC PHY reset line */
 	MX51_PAD_EIM_A20__GPIO_2_14,
+
+	/* Power Key */
+	MX51_PAD_EIM_A27__GPIO_2_21,
 };
 
 /* Serial ports */
@@ -287,6 +308,7 @@ static void __init mxc_board_init(void)
 	mxc_init_imx_uart();
 	babbage_fec_reset();
 	imx51_add_fec(NULL);
+	imx51_add_gpio_keys(&imx_button_data);
 
 	imx51_add_imx_i2c(0, &babbage_i2c_data);
 	imx51_add_imx_i2c(1, &babbage_i2c_data);
diff --git a/arch/arm/mach-mx5/devices-imx51.h b/arch/arm/mach-mx5/devices-imx51.h
index 5cc910e..8c50cb5 100644
--- a/arch/arm/mach-mx5/devices-imx51.h
+++ b/arch/arm/mach-mx5/devices-imx51.h
@@ -13,6 +13,8 @@ extern const struct imx_fec_data imx51_fec_data __initconst;
 #define imx51_add_fec(pdata)	\
 	imx_add_fec(&imx51_fec_data, pdata)
 
+#define imx51_add_gpio_keys(pdata) imx_add_gpio_keys(pdata)
+
 extern const struct imx_imx_i2c_data imx51_imx_i2c_data[] __initconst;
 #define imx51_add_imx_i2c(id, pdata)	\
 	imx_add_imx_i2c(&imx51_imx_i2c_data[id], pdata)
-- 
1.6.0.4


