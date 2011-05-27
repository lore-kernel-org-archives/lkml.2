Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab1E0Xg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:36:28 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:20700 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756608Ab1E0Xg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:36:27 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-160.messagelabs.com!1306539386!24107119!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.99]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpio: 74x164: remove unnecessary defines and prototype
Date: Fri, 27 May 2011 16:35:59 -0700
User-Agent: KMail/1.9.9
CC: <spi-devel-general@lists.sourceforge.net>, <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201105271635.59593.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the #define GEN_74X164_GPIO_COUNT since it's only used in
one place and it's meaning is obvious.  Also remove the #define
GEN_74X164_DRIVER_NAME and use spi->modalias to set the gpio chip's
label and the string "74x164" for the driver name.

Reorder the code slightly to remove the need to prototype
gen_74x164_set_value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Grant Likely <grant.likely@secretlab.ca>

---

diff --git a/drivers/gpio/74x164.c b/drivers/gpio/74x164.c
index 84e0702..7fb60b6 100644
--- a/drivers/gpio/74x164.c
+++ b/drivers/gpio/74x164.c
@@ -16,9 +16,6 @@
 #include <linux/gpio.h>
 #include <linux/slab.h>
 
-#define GEN_74X164_GPIO_COUNT	8
-
-
 struct gen_74x164_chip {
 	struct spi_device	*spi;
 	struct gpio_chip	gpio_chip;
@@ -26,8 +23,6 @@ struct gen_74x164_chip {
 	u8			port_config;
 };
 
-static void gen_74x164_set_value(struct gpio_chip *, unsigned, int);
-
 static struct gen_74x164_chip *gpio_to_chip(struct gpio_chip *gc)
 {
 	return container_of(gc, struct gen_74x164_chip, gpio_chip);
@@ -39,13 +34,6 @@ static int __gen_74x164_write_config(struct gen_74x164_chip *chip)
 			 &chip->port_config, sizeof(chip->port_config));
 }
 
-static int gen_74x164_direction_output(struct gpio_chip *gc,
-		unsigned offset, int val)
-{
-	gen_74x164_set_value(gc, offset, val);
-	return 0;
-}
-
 static int gen_74x164_get_value(struct gpio_chip *gc, unsigned offset)
 {
 	struct gen_74x164_chip *chip = gpio_to_chip(gc);
@@ -73,6 +61,13 @@ static void gen_74x164_set_value(struct gpio_chip *gc,
 	mutex_unlock(&chip->lock);
 }
 
+static int gen_74x164_direction_output(struct gpio_chip *gc,
+		unsigned offset, int val)
+{
+	gen_74x164_set_value(gc, offset, val);
+	return 0;
+}
+
 static int __devinit gen_74x164_probe(struct spi_device *spi)
 {
 	struct gen_74x164_chip *chip;
@@ -104,12 +99,12 @@ static int __devinit gen_74x164_probe(struct spi_device *spi)
 
 	chip->spi = spi;
 
-	chip->gpio_chip.label = GEN_74X164_DRIVER_NAME,
-		chip->gpio_chip.direction_output = gen_74x164_direction_output;
+	chip->gpio_chip.label = spi->modalias;
+	chip->gpio_chip.direction_output = gen_74x164_direction_output;
 	chip->gpio_chip.get = gen_74x164_get_value;
 	chip->gpio_chip.set = gen_74x164_set_value;
 	chip->gpio_chip.base = pdata->base;
-	chip->gpio_chip.ngpio = GEN_74X164_GPIO_COUNT;
+	chip->gpio_chip.ngpio = 8;
 	chip->gpio_chip.can_sleep = 1;
 	chip->gpio_chip.dev = &spi->dev;
 	chip->gpio_chip.owner = THIS_MODULE;
@@ -157,7 +152,7 @@ static int __devexit gen_74x164_remove(struct spi_device *spi)
 
 static struct spi_driver gen_74x164_driver = {
 	.driver = {
-		.name		= GEN_74X164_DRIVER_NAME,
+		.name		= "74x164",
 		.owner		= THIS_MODULE,
 	},
 	.probe		= gen_74x164_probe,
diff --git a/include/linux/spi/74x164.h b/include/linux/spi/74x164.h
index d85c52f..0aa6acc 100644
--- a/include/linux/spi/74x164.h
+++ b/include/linux/spi/74x164.h
@@ -1,8 +1,6 @@
 #ifndef LINUX_SPI_74X164_H
 #define LINUX_SPI_74X164_H
 
-#define GEN_74X164_DRIVER_NAME "74x164"
-
 struct gen_74x164_chip_platform_data {
 	/* number assigned to the first GPIO */
 	unsigned	base;

