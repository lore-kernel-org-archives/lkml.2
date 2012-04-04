Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2DDBfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 21:35:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55928 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab2DDBeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 21:34:23 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Rob Herring <rob.herring@calxeda.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 3/5] i2c: remove ixp2000 driver
Date: Tue,  3 Apr 2012 20:34:01 -0500
Message-Id: <1333503243-7702-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
References: <1333503243-7702-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The platform is removed, so there are no users of this driver.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/busses/Kconfig       |   14 ----
 drivers/i2c/busses/Makefile      |    1 -
 drivers/i2c/busses/i2c-ixp2000.c |  157 --------------------------------------
 3 files changed, 0 insertions(+), 172 deletions(-)
 delete mode 100644 drivers/i2c/busses/i2c-ixp2000.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index d2c5095..188543d 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -445,20 +445,6 @@ config I2C_IOP3XX
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-iop3xx.
 
-config I2C_IXP2000
-	tristate "IXP2000 GPIO-Based I2C Interface (DEPRECATED)"
-	depends on ARCH_IXP2000
-	select I2C_ALGOBIT
-	help
-	  Say Y here if you have an Intel IXP2000 (2400, 2800, 2850) based
-	  system and are using GPIO lines for an I2C bus.
-
-	  This support is also available as a module. If so, the module
-	  will be called i2c-ixp2000.
-
-	  This driver is deprecated and will be dropped soon. Use i2c-gpio
-	  instead.
-
 config I2C_MPC
 	tristate "MPC107/824x/85xx/512x/52xx/83xx/86xx"
 	depends on PPC
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 569567b..ce3c2be 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -44,7 +44,6 @@ obj-$(CONFIG_I2C_IBM_IIC)	+= i2c-ibm_iic.o
 obj-$(CONFIG_I2C_IMX)		+= i2c-imx.o
 obj-$(CONFIG_I2C_INTEL_MID)	+= i2c-intel-mid.o
 obj-$(CONFIG_I2C_IOP3XX)	+= i2c-iop3xx.o
-obj-$(CONFIG_I2C_IXP2000)	+= i2c-ixp2000.o
 obj-$(CONFIG_I2C_MPC)		+= i2c-mpc.o
 obj-$(CONFIG_I2C_MV64XXX)	+= i2c-mv64xxx.o
 obj-$(CONFIG_I2C_MXS)		+= i2c-mxs.o
diff --git a/drivers/i2c/busses/i2c-ixp2000.c b/drivers/i2c/busses/i2c-ixp2000.c
deleted file mode 100644
index 5d263f90..0000000
--- a/drivers/i2c/busses/i2c-ixp2000.c
+++ /dev/null
@@ -1,157 +0,0 @@
-/*
- * drivers/i2c/busses/i2c-ixp2000.c
- *
- * I2C adapter for IXP2000 systems using GPIOs for I2C bus
- *
- * Author: Deepak Saxena <dsaxena@plexity.net>
- * Based on IXDP2400 code by: Naeem M. Afzal <naeem.m.afzal@intel.com>
- * Made generic by: Jeff Daly <jeffrey.daly@intel.com>
- *
- * Copyright (c) 2003-2004 MontaVista Software Inc.
- *
- * This file is licensed under  the terms of the GNU General Public 
- * License version 2. This program is licensed "as is" without any 
- * warranty of any kind, whether express or implied.
- *
- * From Jeff Daly:
- *
- * I2C adapter driver for Intel IXDP2xxx platforms. This should work for any
- * IXP2000 platform if it uses the HW GPIO in the same manner.  Basically, 
- * SDA and SCL GPIOs have external pullups.  Setting the respective GPIO to 
- * an input will make the signal a '1' via the pullup.  Setting them to 
- * outputs will pull them down. 
- *
- * The GPIOs are open drain signals and are used as configuration strap inputs
- * during power-up so there's generally a buffer on the board that needs to be 
- * 'enabled' to drive the GPIOs.
- */
-
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include <linux/module.h>
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-#include <linux/slab.h>
-
-#include <mach/hardware.h>	/* Pick up IXP2000-specific bits */
-#include <mach/gpio-ixp2000.h>
-
-static inline int ixp2000_scl_pin(void *data)
-{
-	return ((struct ixp2000_i2c_pins*)data)->scl_pin;
-}
-
-static inline int ixp2000_sda_pin(void *data)
-{
-	return ((struct ixp2000_i2c_pins*)data)->sda_pin;
-}
-
-
-static void ixp2000_bit_setscl(void *data, int val)
-{
-	int i = 5000;
-
-	if (val) {
-		gpio_line_config(ixp2000_scl_pin(data), GPIO_IN);
-		while(!gpio_line_get(ixp2000_scl_pin(data)) && i--);
-	} else {
-		gpio_line_config(ixp2000_scl_pin(data), GPIO_OUT);
-	}
-}
-
-static void ixp2000_bit_setsda(void *data, int val)
-{
-	if (val) {
-		gpio_line_config(ixp2000_sda_pin(data), GPIO_IN);
-	} else {
-		gpio_line_config(ixp2000_sda_pin(data), GPIO_OUT);
-	}
-}
-
-static int ixp2000_bit_getscl(void *data)
-{
-	return gpio_line_get(ixp2000_scl_pin(data));
-}
-
-static int ixp2000_bit_getsda(void *data)
-{
-	return gpio_line_get(ixp2000_sda_pin(data));
-}
-
-struct ixp2000_i2c_data {
-	struct ixp2000_i2c_pins *gpio_pins;
-	struct i2c_adapter adapter;
-	struct i2c_algo_bit_data algo_data;
-};
-
-static int ixp2000_i2c_remove(struct platform_device *plat_dev)
-{
-	struct ixp2000_i2c_data *drv_data = platform_get_drvdata(plat_dev);
-
-	platform_set_drvdata(plat_dev, NULL);
-
-	i2c_del_adapter(&drv_data->adapter);
-
-	kfree(drv_data);
-
-	return 0;
-}
-
-static int ixp2000_i2c_probe(struct platform_device *plat_dev)
-{
-	int err;
-	struct ixp2000_i2c_pins *gpio = plat_dev->dev.platform_data;
-	struct ixp2000_i2c_data *drv_data = 
-		kzalloc(sizeof(struct ixp2000_i2c_data), GFP_KERNEL);
-
-	if (!drv_data)
-		return -ENOMEM;
-	drv_data->gpio_pins = gpio;
-
-	drv_data->algo_data.data = gpio;
-	drv_data->algo_data.setsda = ixp2000_bit_setsda;
-	drv_data->algo_data.setscl = ixp2000_bit_setscl;
-	drv_data->algo_data.getsda = ixp2000_bit_getsda;
-	drv_data->algo_data.getscl = ixp2000_bit_getscl;
-	drv_data->algo_data.udelay = 6;
-	drv_data->algo_data.timeout = HZ;
-
-	strlcpy(drv_data->adapter.name, plat_dev->dev.driver->name,
-		sizeof(drv_data->adapter.name));
-	drv_data->adapter.algo_data = &drv_data->algo_data,
-
-	drv_data->adapter.dev.parent = &plat_dev->dev;
-
-	gpio_line_config(gpio->sda_pin, GPIO_IN);
-	gpio_line_config(gpio->scl_pin, GPIO_IN);
-	gpio_line_set(gpio->scl_pin, 0);
-	gpio_line_set(gpio->sda_pin, 0);
-
-	if ((err = i2c_bit_add_bus(&drv_data->adapter)) != 0) {
-		dev_err(&plat_dev->dev, "Could not install, error %d\n", err);
-		kfree(drv_data);
-		return err;
-	} 
-
-	platform_set_drvdata(plat_dev, drv_data);
-
-	return 0;
-}
-
-static struct platform_driver ixp2000_i2c_driver = {
-	.probe		= ixp2000_i2c_probe,
-	.remove		= ixp2000_i2c_remove,
-	.driver		= {
-		.name	= "IXP2000-I2C",
-		.owner	= THIS_MODULE,
-	},
-};
-
-module_platform_driver(ixp2000_i2c_driver);
-
-MODULE_AUTHOR ("Deepak Saxena <dsaxena@plexity.net>");
-MODULE_DESCRIPTION("IXP2000 GPIO-based I2C bus driver");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:IXP2000-I2C");
-
-- 
1.7.5.4

