Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965416Ab2CBM4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 07:56:52 -0500
Received: from h1778886.stratoserver.net ([85.214.133.74]:56704 "EHLO
	h1778886.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab2CBM4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 07:56:50 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: [PATCH 1/2] pxa: magician/hx4700: Convert to gpio-regulator from bq24022
Date: Fri, 2 Mar 2012 13:56:38 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
References: <201203021355.21669.heiko@sntech.de>
In-Reply-To: <201203021355.21669.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203021356.38857.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bq24022 on these machines is a very simple regulator using gpios.
One provides the on/off functionality and a second one is used to
change the current between 100 and 500 mA.

This functionality can also be provided by the more generic gpio-regulator.

Therefore convert both machines which makes it possible to remove the
bq24022 driver later on.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 arch/arm/configs/magician_defconfig |    2 +-
 arch/arm/mach-pxa/hx4700.c          |   33 +++++++++++++++++++++++++++------
 arch/arm/mach-pxa/magician.c        |   33 +++++++++++++++++++++++++++------
 3 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index 443675d..a691ef4 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -101,7 +101,7 @@ CONFIG_MFD_ASIC3=y
 CONFIG_HTC_EGPIO=y
 CONFIG_HTC_PASIC3=y
 CONFIG_REGULATOR=y
-CONFIG_REGULATOR_BQ24022=y
+CONFIG_REGULATOR_GPIO=y
 CONFIG_FB=y
 CONFIG_FB_PXA=y
 CONFIG_FB_PXA_OVERLAY=y
diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index f2c23ea..7571f0d 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -28,7 +28,8 @@
 #include <linux/mtd/physmap.h>
 #include <linux/pda_power.h>
 #include <linux/pwm_backlight.h>
-#include <linux/regulator/bq24022.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/gpio-regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/max1586.h>
 #include <linux/spi/ads7846.h>
@@ -698,14 +699,34 @@ static struct regulator_init_data bq24022_init_data = {
 	.consumer_supplies      = bq24022_consumers,
 };
 
-static struct bq24022_mach_info bq24022_info = {
-	.gpio_nce   = GPIO72_HX4700_BQ24022_nCHARGE_EN,
-	.gpio_iset2 = GPIO96_HX4700_BQ24022_ISET2,
-	.init_data  = &bq24022_init_data,
+static struct gpio bq24022_gpios[] = {
+	{ GPIO96_HX4700_BQ24022_ISET2, GPIOF_OUT_INIT_LOW, "bq24022_iset2" },
+};
+
+static struct gpio_regulator_state bq24022_states[] = {
+	{ .value = 100000, .gpios = (0 << 0) },
+	{ .value = 500000, .gpios = (1 << 0) },
+};
+
+static struct gpio_regulator_config bq24022_info = {
+	.supply_name = "bq24022",
+
+	.enable_gpio = GPIO72_HX4700_BQ24022_nCHARGE_EN,
+	.enable_high = 0,
+	.enabled_at_boot = 0,
+
+	.gpios = bq24022_gpios,
+	.nr_gpios = ARRAY_SIZE(bq24022_gpios),
+
+	.states = bq24022_states,
+	.nr_states = ARRAY_SIZE(bq24022_states),
+
+	.type = REGULATOR_CURRENT,
+	.init_data = &bq24022_init_data,
 };
 
 static struct platform_device bq24022 = {
-	.name = "bq24022",
+	.name = "gpio-regulator",
 	.id   = -1,
 	.dev  = {
 		.platform_data = &bq24022_info,
diff --git a/arch/arm/mach-pxa/magician.c b/arch/arm/mach-pxa/magician.c
index 3d6baf9..5e26f3e 100644
--- a/arch/arm/mach-pxa/magician.c
+++ b/arch/arm/mach-pxa/magician.c
@@ -25,7 +25,8 @@
 #include <linux/mtd/physmap.h>
 #include <linux/pda_power.h>
 #include <linux/pwm_backlight.h>
-#include <linux/regulator/bq24022.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/gpio-regulator.h>
 #include <linux/regulator/machine.h>
 #include <linux/usb/gpio_vbus.h>
 #include <linux/i2c/pxa-i2c.h>
@@ -596,14 +597,34 @@ static struct regulator_init_data bq24022_init_data = {
 	.consumer_supplies      = bq24022_consumers,
 };
 
-static struct bq24022_mach_info bq24022_info = {
-	.gpio_nce   = GPIO30_MAGICIAN_BQ24022_nCHARGE_EN,
-	.gpio_iset2 = EGPIO_MAGICIAN_BQ24022_ISET2,
-	.init_data  = &bq24022_init_data,
+static struct gpio bq24022_gpios[] = {
+	{ EGPIO_MAGICIAN_BQ24022_ISET2, GPIOF_OUT_INIT_LOW, "bq24022_iset2" },
+};
+
+static struct gpio_regulator_state bq24022_states[] = {
+	{ .value = 100000, .gpios = (0 << 0) },
+	{ .value = 500000, .gpios = (1 << 0) },
+};
+
+static struct gpio_regulator_config bq24022_info = {
+	.supply_name = "bq24022",
+
+	.enable_gpio = GPIO30_MAGICIAN_BQ24022_nCHARGE_EN,
+	.enable_high = 0,
+	.enabled_at_boot = 0,
+
+	.gpios = bq24022_gpios,
+	.nr_gpios = ARRAY_SIZE(bq24022_gpios),
+
+	.states = bq24022_states,
+	.nr_states = ARRAY_SIZE(bq24022_states),
+
+	.type = REGULATOR_CURRENT,
+	.init_data = &bq24022_init_data,
 };
 
 static struct platform_device bq24022 = {
-	.name = "bq24022",
+	.name = "gpio-regulator",
 	.id   = -1,
 	.dev  = {
 		.platform_data = &bq24022_info,
-- 
1.7.5.4

