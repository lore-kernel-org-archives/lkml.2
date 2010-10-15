Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab0JOURm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:17:42 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:40001
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757025Ab0JOURk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:17:40 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h66h)
X-Spam-TCS-SCL: 5:0
From: <Dinh.Nguyen@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        <xiao-lizhang@freescale.com>, Dinh Nguyen <Dinh.Nguyen@freescale.com>
Subject: [PATCH 2/2] ARM: imx: Add POWER_KEY to mx51 babbage board
Date: Fri, 15 Oct 2010 15:18:28 -0500
Message-ID: <1287173908-25758-2-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
References: <1287173908-25758-1-git-send-email-Dinh.Nguyen@freescale.com>
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
 arch/arm/mach-mx5/board-mx51_babbage.c      |   42 +++++++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/iomux-mx51.h |    4 ++-
 2 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mx5/board-mx51_babbage.c b/arch/arm/mach-mx5/board-mx51_babbage.c
index 6e384d9..92f16ca 100644
--- a/arch/arm/mach-mx5/board-mx51_babbage.c
+++ b/arch/arm/mach-mx5/board-mx51_babbage.c
@@ -16,6 +16,8 @@
 #include <linux/gpio.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/fsl_devices.h>
 
 #include <mach/common.h>
@@ -36,6 +38,7 @@
 #define BABBAGE_USB_HUB_RESET	(0*32 + 7)	/* GPIO_1_7 */
 #define BABBAGE_USBH1_STP	(0*32 + 27)	/* GPIO_1_27 */
 #define BABBAGE_PHY_RESET (1*32 +5)	/* GPIO_2_5 */
+#define BABBAGE_POWER_KEY		(1*32 + 21)	/* GPIO_2_21 */
 
 /* USB_CTRL_1 */
 #define MX51_USB_CTRL_1_OFFSET			0x10
@@ -93,6 +96,9 @@ static struct pad_desc mx51babbage_pads[] = {
 
 	/* USB HUB reset line*/
 	MX51_PAD_GPIO_1_7__GPIO_1_7,
+
+	/* Power Key */
+	MX51_PAD_EIM_A27__GPIO_2_21,
 };
 
 /* Serial ports */
@@ -240,6 +246,42 @@ static int __init babbage_otg_mode(char *options)
 }
 __setup("otg_mode=", babbage_otg_mode);
 
+/*!
+ * Power Key interrupt handler.
+ */
+static irqreturn_t power_key_int(int irq, void *dev_id)
+{
+	printk(KERN_INFO "PWR key pressed\n");
+	return 0;
+}
+
+/*!
+ * Power Key initialization.
+ */
+static int __init mxc_init_power_key(void)
+{
+	/* Set power key as wakeup resource */
+	int irq, ret;
+
+	/* power key */
+	ret = gpio_request(BABBAGE_POWER_KEY, "power-key");
+	if (ret) {
+		printk(KERN_ERR"failed to get BABBAGE_POWER_KEY: %d\n", ret);
+		return ret;
+	}
+	gpio_direction_input(BABBAGE_POWER_KEY);
+
+	irq = IOMUX_TO_IRQ(BABBAGE_POWER_KEY);
+	set_irq_type(irq, IRQF_TRIGGER_RISING);
+	ret = request_irq(irq, power_key_int, 0, "power-key", 0);
+	if (ret)
+		pr_info("register on-off key interrupt failed\n");
+	else
+		enable_irq_wake(irq);
+	return ret;
+}
+late_initcall(mxc_init_power_key);
+
 /*
  * Board specific initialization.
  */
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


