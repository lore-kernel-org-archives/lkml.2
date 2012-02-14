Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab2BNLDz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:03:55 -0500
Received: from skyrme.org ([193.175.80.135]:34714 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759495Ab2BNLDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:03:40 -0500
Date: 14 Feb 2012 10:34:32 +0000
Message-Id: <1329215672-15706-8-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: sameo@linux.intel.com
Cc: dmitry.torokhov@gmail.com, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, philippe.retornaz@epfl.ch,
        michael.thalmeier@hale.at, linux-kernel@vger.kernel.org,
        "Oskar Schirmer" <oskar@scara.com>
Subject: [PATCH 7/7] arm/imx: add mc13892 I2C based touch panel support for
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1329215672-15706-1-git-send-email-oskar@scara.com>
References: <1329215672-15706-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MX35_3DS development board comes with optional touch screen
driven by I2C wired mc13892. Set up platform specific declarations.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
---
 arch/arm/mach-imx/mach-mx35_3ds.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mach-mx35_3ds.c b/arch/arm/mach-imx/mach-mx35_3ds.c
index 0af6c9c..c65b815 100644
--- a/arch/arm/mach-imx/mach-mx35_3ds.c
+++ b/arch/arm/mach-imx/mach-mx35_3ds.c
@@ -41,9 +41,13 @@
 #include <mach/irqs.h>
 #include <mach/3ds_debugboard.h>
 
+#include <linux/i2c.h>
+#include <linux/mfd/mc13xxx.h>
+
 #include "devices-imx35.h"
 
 #define EXPIO_PARENT_INT	gpio_to_irq(IMX_GPIO_NR(1, 1))
+#define GPIO_PMIC_INT		IMX_GPIO_NR(2, 0)
 
 static const struct imxuart_platform_data uart_pdata __initconst = {
 	.flags = IMXUART_HAVE_RTSCTS,
@@ -117,6 +121,8 @@ static iomux_v3_cfg_t mx35pdk_pads[] = {
 	MX35_PAD_SD1_DATA1__ESDHC1_DAT1,
 	MX35_PAD_SD1_DATA2__ESDHC1_DAT2,
 	MX35_PAD_SD1_DATA3__ESDHC1_DAT3,
+	/* PMIC */
+	MX35_PAD_GPIO2_0__GPIO2_0,
 	/* I2C1 */
 	MX35_PAD_I2C1_CLK__I2C1_SCL,
 	MX35_PAD_I2C1_DAT__I2C1_SDA,
@@ -174,6 +180,18 @@ static const struct imxi2c_platform_data mx35_3ds_i2c0_data __initconst = {
 	.bitrate = 100000,
 };
 
+static struct mc13xxx_platform_data mx35_3ds_pmic = {
+	.flags = MC13XXX_USE_TOUCHSCREEN,
+};
+
+static struct i2c_board_info mx35_3ds_i2c_devices[] = {
+	{
+		I2C_BOARD_INFO("mc13892", 0x08),
+		.platform_data = &mx35_3ds_pmic,
+		.irq = IMX_GPIO_TO_IRQ(GPIO_PMIC_INT),
+	}
+};
+
 /*
  * Board specific initialization.
  */
@@ -187,6 +205,12 @@ static void __init mx35_3ds_init(void)
 	imx35_add_imx2_wdt(NULL);
 	platform_add_devices(devices, ARRAY_SIZE(devices));
 
+	if (0 != gpio_request(GPIO_PMIC_INT, "PMIC_INT"))
+		printk(KERN_WARNING "PMIC_INT: Couldn't get gpio (%d)\n",
+			GPIO_PMIC_INT);
+	else
+		gpio_direction_input(GPIO_PMIC_INT);
+
 	imx35_add_imx_uart0(&uart_pdata);
 
 	if (otg_mode_host)
@@ -203,6 +227,9 @@ static void __init mx35_3ds_init(void)
 	if (mxc_expio_init(MX35_CS5_BASE_ADDR, EXPIO_PARENT_INT))
 		pr_warn("Init of the debugboard failed, all "
 				"devices on the debugboard are unusable.\n");
+
+	i2c_register_board_info(0, mx35_3ds_i2c_devices,
+			ARRAY_SIZE(mx35_3ds_i2c_devices));
 	imx35_add_imx_i2c0(&mx35_3ds_i2c0_data);
 }
 
-- 
1.7.5.4

