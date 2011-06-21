Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab1FUCIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:08:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18663 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab1FUCHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:07:17 -0400
X-AuditID: cbfee61a-b7c59ae000003b70-c5-4dfffcd2c03b
Date: Tue, 21 Jun 2011 11:07:11 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 2/4] Exynos4 NURI: configure MAX17042 fuel gauge
In-reply-to: <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        myungjoo.ham@gmail.com, dg77.kim@samsung.com
Message-id: <1308622033-2521-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <20110620103124.GD31864@opensource.wolfsonmicro.com>
 <1308622033-2521-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 21 Jun 2011 02:06:38.0209 (UTC)
 FILETIME=[DABAAF10:01CC2FB7]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/mach-nuri.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
index 13b881f..25b9bcb 100644
--- a/arch/arm/mach-exynos4/mach-nuri.c
+++ b/arch/arm/mach-exynos4/mach-nuri.c
@@ -13,8 +13,10 @@
 #include <linux/input.h>
 #include <linux/i2c.h>
 #include <linux/i2c/atmel_mxt_ts.h>
+#include <linux/i2c-gpio.h>
 #include <linux/gpio_keys.h>
 #include <linux/gpio.h>
+#include <linux/power/max17042_battery.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/fixed.h>
 #include <linux/mfd/max8997.h>
@@ -954,6 +956,11 @@ static void __init nuri_pmic_init(void)
 	gpio_request(gpio, "AP_PMIC_IRQ");
 	s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
 	s3c_gpio_setpull(gpio, S3C_GPIO_PULL_NONE);
+
+	gpio = EXYNOS4_GPX2(3);
+	gpio_request(gpio, "FUEL_ALERT");
+	s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
+	s3c_gpio_setpull(gpio, S3C_GPIO_PULL_NONE);
 }
 
 /* GPIO I2C 5 (PMIC) */
@@ -965,6 +972,29 @@ static struct i2c_board_info i2c5_devs[] __initdata = {
 	},
 };
 
+static struct max17042_platform_data nuri_battery_platform_data = {
+};
+
+/* GPIO I2C 9 (Fuel Gauge) */
+static struct i2c_gpio_platform_data i2c9_gpio_data = {
+	.sda_pin		= EXYNOS4_GPY4(0),      /* XM0ADDR_8 */
+	.scl_pin		= EXYNOS4_GPY4(1),      /* XM0ADDR_9 */
+};
+static struct platform_device i2c9_gpio = {
+	.name			= "i2c-gpio",
+	.id			= 9,
+	.dev			= {
+		.platform_data	= &i2c9_gpio_data,
+	},
+};
+enum { I2C9_MAX17042};
+static struct i2c_board_info i2c9_devs[] __initdata = {
+	[I2C9_MAX17042] = {
+		I2C_BOARD_INFO("max17042", 0x36),
+		.platform_data = &nuri_battery_platform_data,
+	},
+};
+
 /* USB EHCI */
 static struct s5p_ehci_platdata nuri_ehci_pdata;
 
@@ -986,6 +1016,7 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&s5p_device_ehci,
 	&s3c_device_i2c3,
 	&s3c_device_i2c5,
+	&i2c9_gpio,
 
 	/* NURI Devices */
 	&nuri_gpio_keys,
@@ -1012,6 +1043,8 @@ static void __init nuri_machine_init(void)
 	s3c_i2c5_set_platdata(NULL);
 	i2c5_devs[I2C5_MAX8997].irq = gpio_to_irq(EXYNOS4_GPX0(7));
 	i2c_register_board_info(5, i2c5_devs, ARRAY_SIZE(i2c5_devs));
+	i2c9_devs[I2C9_MAX17042].irq = gpio_to_irq(EXYNOS4_GPX2(3));
+	i2c_register_board_info(9, i2c9_devs, ARRAY_SIZE(i2c9_devs));
 
 	nuri_ehci_init();
 	clk_xusbxti.rate = 24000000;
-- 
1.7.4.1

