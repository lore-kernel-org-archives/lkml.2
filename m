Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1FPJJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:09:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20110 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab1FPJJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:09:35 -0400
X-AuditID: cbfee61b-b7c62ae0000056ed-b5-4df9c84c766d
Date: Thu, 16 Jun 2011 18:09:32 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH 2/2] Exynos4 NURI: add MAX17042 fuel gauge
In-reply-to: <1308215372-17420-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, kyungmin.park@samsung.com,
        myungjoo.ham@gmail.com, dg77.kim@samsung.com
Message-id: <1308215372-17420-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1308215372-17420-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 16 Jun 2011 09:09:19.0997 (UTC)
 FILETIME=[1377AAD0:01CC2C05]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos4/mach-nuri.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos4/mach-nuri.c b/arch/arm/mach-exynos4/mach-nuri.c
index c8c2431..b8c0c5d 100644
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
@@ -983,6 +985,7 @@ static struct max8997_platform_data nuri_max8997_pdata = {
 };
 
 #define NURI_PMIC_GPIO		EXYNOS4_GPX0(7)
+#define NURI_FUELGAUGE_GPIO	EXYNOS4_GPX2(3)
 static void __init nuri_pmic_init(void)
 {
 	int gpio;
@@ -992,6 +995,11 @@ static void __init nuri_pmic_init(void)
 	gpio_request(gpio, "AP_PMIC_IRQ");
 	s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
 	s3c_gpio_setpull(gpio, S3C_GPIO_PULL_NONE);
+
+	gpio = NURI_FUELGAUGE_GPIO;
+	gpio_request(gpio, "FUEL_ALERT");
+	s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
+	s3c_gpio_setpull(gpio, S3C_GPIO_PULL_NONE);
 }
 
 /* GPIO I2C 5 (PMIC) */
@@ -1003,6 +1011,30 @@ static struct i2c_board_info i2c5_devs[] __initdata = {
 	},
 };
 
+static struct max17042_platform_data nuri_battery_platform_data = {
+	.enable_current_sense = false,
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
 
@@ -1024,6 +1056,7 @@ static struct platform_device *nuri_devices[] __initdata = {
 	&s5p_device_ehci,
 	&s3c_device_i2c3,
 	&s3c_device_i2c5,
+	&i2c9_gpio,
 
 	/* NURI Devices */
 	&nuri_gpio_keys,
@@ -1050,6 +1083,8 @@ static void __init nuri_machine_init(void)
 	s3c_i2c5_set_platdata(NULL);
 	i2c5_devs[I2C5_MAX8997].irq = gpio_to_irq(NURI_PMIC_GPIO);
 	i2c_register_board_info(5, i2c5_devs, ARRAY_SIZE(i2c5_devs));
+	i2c9_devs[I2C9_MAX17042].irq = gpio_to_irq(NURI_FUELGAUGE_GPIO);
+	i2c_register_board_info(9, i2c9_devs, ARRAY_SIZE(i2c9_devs));
 
 	nuri_ehci_init();
 	clk_xusbxti.rate = 24000000;
-- 
1.7.4.1

