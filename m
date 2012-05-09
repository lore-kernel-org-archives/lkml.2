Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2EINPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:15:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8111 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab2EINO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:14:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 09 May 2012 06:14:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        jedu@slimlogic.co.uk, lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 3/4] mfd: tps65910: register gpio as mfd device
Date: Wed,  9 May 2012 18:40:56 +0530
Message-Id: <1336569057-3890-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
References: <1336569057-3890-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As gpio support for tps65910 is on gpio driver, registering
gpio support as the mfd sub devices instead of calling gpio_init()
from the core probe.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/Kconfig          |    1 -
 drivers/mfd/tps65910.c       |    6 +++---
 include/linux/mfd/tps65910.h |    6 ------
 3 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 77873d3..5e8481c 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -176,7 +176,6 @@ config MFD_TPS65910
 	bool "TPS65910 Power Management chip"
 	depends on I2C=y && GPIOLIB
 	select MFD_CORE
-	select GPIO_TPS65910
 	select REGMAP_I2C
 	help
 	  if you say yes here you get support for the TPS65910 series of
diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d0d8ae9..f51ab30 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -19,13 +19,15 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
-#include <linux/gpio.h>
 #include <linux/mfd/core.h>
 #include <linux/regmap.h>
 #include <linux/mfd/tps65910.h>
 
 static struct mfd_cell tps65910s[] = {
 	{
+		.name = "tps65910-gpio",
+	},
+	{
 		.name = "tps65910-pmic",
 	},
 	{
@@ -195,8 +197,6 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	init_data->irq = pmic_plat_data->irq;
 	init_data->irq_base = pmic_plat_data->irq_base;
 
-	tps65910_gpio_init(tps65910, pmic_plat_data->gpio_base);
-
 	tps65910_irq_init(tps65910, init_data->irq, init_data);
 
 	tps65910_sleepinit(tps65910, pmic_plat_data);
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 56903ad..7884f0b 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -17,8 +17,6 @@
 #ifndef __LINUX_MFD_TPS65910_H
 #define __LINUX_MFD_TPS65910_H
 
-#include <linux/gpio.h>
-
 /* TPS chip id list */
 #define TPS65910			0
 #define TPS65911			1
@@ -831,9 +829,6 @@ struct tps65910 {
 	struct tps65910_rtc *rtc;
 	struct tps65910_power *power;
 
-	/* GPIO Handling */
-	struct gpio_chip gpio;
-
 	/* IRQ Handling */
 	struct mutex irq_lock;
 	int chip_irq;
@@ -849,7 +844,6 @@ struct tps65910_platform_data {
 
 int tps65910_set_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
 int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
-void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
 int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		struct tps65910_platform_data *pdata);
 int tps65910_irq_exit(struct tps65910 *tps65910);
-- 
1.7.1.1

