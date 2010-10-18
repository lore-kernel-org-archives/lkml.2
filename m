Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab0JRQeL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:34:11 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:57672
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751896Ab0JRQeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:34:08 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);(null);(null)
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <bryan.wu@canonical.com>,
        <amit.kucheria@canonical.com>, <xiao-lizhang@freescale.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCHv2 2/2] ARM: imx: Add gpio-keys to mx51 babbage board
Date: Mon, 18 Oct 2010 11:35:31 -0500
Message-ID: <1287419731-7885-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287419731-7885-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1287419731-7885-1-git-send-email-Dinh.Nguyen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <Dinh.Nguyen@freescale.com>

Add functionality for the power button on MX51 Babbage board.

Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
---
 arch/arm/configs/mx51_defconfig             |    1 +
 arch/arm/mach-mx5/board-mx51_babbage.c      |   33 +++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/iomux-mx51.h |    4 ++-
 3 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/mx51_defconfig b/arch/arm/configs/mx51_defconfig
index a665ecb..f46f87e 100644
--- a/arch/arm/configs/mx51_defconfig
+++ b/arch/arm/configs/mx51_defconfig
@@ -81,6 +81,7 @@ CONFIG_FEC=y
 CONFIG_INPUT_FF_MEMLESS=m
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
+CONFIG_KEYBOARD_GPIO=y
 CONFIG_INPUT_EVBUG=m
 CONFIG_MOUSE_PS2=m
 CONFIG_MOUSE_PS2_ELANTECH=y
diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index 6e384d9..0dded49 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -16,7 +16,11 @@
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/fsl_devices.h>
+#include <linux/gpio_keys.h>
+#include <linux/input.h>
 
 #include <mach/common.h>
 #include <mach/hardware.h>
@@ -36,6 +40,7 @@
 #define BABBAGE_USB_HUB_RESET	(0*32 + 7)	/* GPIO_1_7 */
 #define BABBAGE_USBH1_STP	(0*32 + 27)	/* GPIO_1_27 */
 #define BABBAGE_PHY_RESET (1*32 +5)	/* GPIO_2_5 */
+#define BABBAGE_POWER_KEY	(1*32 + 21)	/* GPIO_2_21 */
 
 /* USB_CTRL_1 */
 #define MX51_USB_CTRL_1_OFFSET			0x10
@@ -45,8 +50,33 @@
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
+static struct gpio_keys_platform_data babbage_button_data = {
+	.buttons	= babbage_buttons,
+	.nbuttons	= ARRAY_SIZE(babbage_buttons),
+};
+
+static struct platform_device babbage_button_device = {
+	.name		= "gpio-keys",
+	.id		= -1,
+	.num_resources	= 0,
+	.dev		= {
+		.platform_data	= &babbage_button_data,
+	}
+};
+
 static struct platform_device *devices[] __initdata = {
 	&mxc_fec_device,
+	&babbage_button_device,
 };
 
 static struct pad_desc mx51babbage_pads[] = {
@@ -93,6 +123,9 @@ static struct pad_desc mx51babbage_pads[] = {
 
 	/* USB HUB reset line*/
 	MX51_PAD_GPIO_1_7__GPIO_1_7,
+
+	/* Power Key */
+	MX51_PAD_EIM_A27__GPIO_2_21,
 };
 
 /* Serial ports */
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx51.h b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
index 21bfa46..05f62a4 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx51.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx51.h
@@ -31,6 +31,8 @@ typedef enum iomux_config {
 	IOMUX_CONFIG_SION = 0x1 << 4,   /* LOOPBACK:MUX SION bit */
 } iomux_pin_cfg_t;
 
+#define IOMUX_TO_IRQ(pin)	(MXC_GPIO_IRQ_START + pin)
+
 /* Pad control groupings */
 #define MX51_UART1_PAD_CTRL	(PAD_CTL_HYS | PAD_CTL_PKE | PAD_CTL_PUE | \
 				PAD_CTL_DSE_HIGH)
@@ -102,7 +104,7 @@ typedef enum iomux_config {
 #define MX51_PAD_EIM_A24__GPIO_2_18             IOMUX_PAD(0x450, 0x0bc, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_EIM_A25__GPIO_2_19             IOMUX_PAD(0x454, 0x0c0, 1, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_EIM_A26__GPIO_2_20             IOMUX_PAD(0x458, 0x0c4, 1, 0x0,   0, NO_PAD_CTRL)
-#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, NO_PAD_CTRL)
+#define MX51_PAD_EIM_A27__GPIO_2_21             IOMUX_PAD(0x45c, 0x0c8, 1, 0x0,   0, MX51_I2C_PAD_CTRL)
 #define MX51_PAD_EIM_EB0__EIM_EB0               IOMUX_PAD(0x460, 0x0cc, 0, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_EIM_EB1__EIM_EB1               IOMUX_PAD(0x464, 0x0d0, 0, 0x0,   0, NO_PAD_CTRL)
 #define MX51_PAD_EIM_EB2__GPIO_2_22             IOMUX_PAD(0x468, 0x0d4, 1, 0x0,   0, NO_PAD_CTRL)
-- 
1.6.0.4


