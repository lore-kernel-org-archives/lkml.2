Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab1A2Lpn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 06:45:43 -0500
Received: from mail.work-microwave.de ([62.245.205.51]:32916 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751567Ab1A2Lpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 06:45:41 -0500
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Jan 2011 06:45:41 EST
From: stigge@antcom.de
To: bgardner@wabtec.com, eric.miao@marvell.com, linux-kernel@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] pca953x: Added mutex to fix race condition
Date: Sat, 29 Jan 2011 12:33:35 +0100
Message-Id: <1296300815-24925-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.2.3
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pca953x: Added mutex to fix race condition

This patch adds a mutex to register communication and handling. Without the
mutex, GPIOs didn't switch as expected when toggled in a fast sequence of
status changes of multiple outputs.

Signed-off-by: Roland Stigge <stigge@antcom.de>

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index a261972..b473429e 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -60,6 +60,7 @@ struct pca953x_chip {
 	unsigned gpio_start;
 	uint16_t reg_output;
 	uint16_t reg_direction;
+	struct mutex i2c_lock;
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 	struct mutex irq_lock;
@@ -119,13 +120,17 @@ static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	reg_val = chip->reg_direction | (1u << off);
 	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
 	if (ret)
-		return ret;
+		goto exit;
 
 	chip->reg_direction = reg_val;
-	return 0;
+	ret = 0;
+exit:
+	mutex_unlock(&chip->i2c_lock);
+	return ret;
 }
 
 static int pca953x_gpio_direction_output(struct gpio_chip *gc,
@@ -137,6 +142,7 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	/* set output level */
 	if (val)
 		reg_val = chip->reg_output | (1u << off);
@@ -145,7 +151,7 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 
 	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
 	if (ret)
-		return ret;
+		goto exit;
 
 	chip->reg_output = reg_val;
 
@@ -153,10 +159,13 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 	reg_val = chip->reg_direction & ~(1u << off);
 	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
 	if (ret)
-		return ret;
+		goto exit;
 
 	chip->reg_direction = reg_val;
-	return 0;
+	ret = 0;
+exit:
+	mutex_unlock(&chip->i2c_lock);
+	return ret;
 }
 
 static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
@@ -167,7 +176,9 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	ret = pca953x_read_reg(chip, PCA953X_INPUT, &reg_val);
+	mutex_unlock(&chip->i2c_lock);
 	if (ret < 0) {
 		/* NOTE:  diagnostic already emitted; that's all we should
 		 * do unless gpio_*_value_cansleep() calls become different
@@ -187,6 +198,7 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
+	mutex_lock(&chip->i2c_lock);
 	if (val)
 		reg_val = chip->reg_output | (1u << off);
 	else
@@ -194,9 +206,11 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 
 	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
 	if (ret)
-		return;
+		goto exit;
 
 	chip->reg_output = reg_val;
+exit:
+	mutex_unlock(&chip->i2c_lock);
 }
 
 static void pca953x_setup_gpio(struct pca953x_chip *chip, int gpios)
@@ -517,6 +531,8 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 
 	chip->names = pdata->names;
 
+	mutex_init(&chip->i2c_lock);
+
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
