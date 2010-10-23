Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab0JWOLB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 10:11:01 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:45872
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757199Ab0JWOK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 10:10:58 -0400
X-SpamScore: 11
X-BigFish: VS11(zzb922la1fflzz1202hzz8275bhz2dh2a8h45k61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv7 2/3] ARM: mx5: Add gpio-keys to mx51 babbage board
Date: Sat, 23 Oct 2010 09:12:47 -0500
Message-ID: <1287843168-18164-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287843168-18164-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1287843168-18164-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add functionality for the power button on MX51 Babbage board.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/configs/mx51_defconfig        |    1 +
 arch/arm/mach-mx5/board-mx51_babbage.c |   24 ++++++++++++++++++++++++
 arch/arm/mach-mx5/devices-imx51.h      |    2 ++
 3 files changed, 27 insertions(+), 0 deletions(-)

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
index 23ee4a4..276a1fb 100644
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
@@ -281,6 +299,7 @@ __setup("otg_mode=", babbage_otg_mode);
 static void __init mxc_board_init(void)
 {
 	struct pad_desc usbh1stp = MX51_PAD_USBH1_STP__USBH1_STP;
+	struct pad_desc power_key = MX51_PAD_EIM_A27__GPIO_2_21;
 
 	mxc_iomux_v3_setup_multiple_pads(mx51babbage_pads,
 					ARRAY_SIZE(mx51babbage_pads));
@@ -288,6 +307,11 @@ static void __init mxc_board_init(void)
 	babbage_fec_reset();
 	imx51_add_fec(NULL);
 
+	/* Set the PAD settings for the pwr key. */
+	power_key.pad_ctrl = MX51_GPIO_PAD_CTRL_2;
+	mxc_iomux_v3_setup_pad(&power_key);
+	imx51_add_gpio_keys(&imx_button_data);
+
 	imx51_add_imx_i2c(0, &babbage_i2c_data);
 	imx51_add_imx_i2c(1, &babbage_i2c_data);
 	mxc_register_device(&mxc_hsi2c_device, &babbage_hsi2c_data);
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


