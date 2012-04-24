Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2DXHcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 03:32:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab2DXHcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 03:32:50 -0400
Date: Tue, 24 Apr 2012 09:32:47 +0200
From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] GPIO: Add support for TI TCA6424
Content-Type: multipart/mixed;
	boundary="------------070106090909080508090806"
X-KSE-AntiSpam-Interceptor-Info: protection disabled
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean
Message-Id: <0LgtFa-1RqHgs3C6g-00neuS@mrelayeu.kundenserver.de>
X-Provags-ID: V02:K0:qBDITRsNRVisXT0N2ou5ScO/1EqPwciohUSa6x50Lt8
 6/It57ywJAkCxoHHlTnPBdGFrhNM3FNxStG714j792vjMlV4E1
 gAHCU4R2jJht/Ip/OkmX/KgmpI646f/3vV+CDmW8uCTV4tMfzL
 abHgSz4tZ3n3/AuaPMndUqncWcapobnekPQnl9HLZntSXBUBzV
 Lo8GBTIZOXTdPTKAASZ3HTOwI+pCnhK3x7I9tcgKMnKFWWdocC
 eM9UJyiejlDhfAKrtD8XfUYX/hOc9FKXHPb1dmn4rM4SMdtLmf
 wB3fUkB9k3yPqAP6pmbSLQm9Q920cIdFGgLUe/r9fXjEFJKO7V
 ESRZj2SXokMXhv447YUehhT48k9AvSUnGm08y0XjAMtJZFngyB
 GNjcdfOmErxjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------070106090909080508090806
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

This patch extends the PCA953x driver to support TI's TCA6424.
It is based on code by Michele Bevilacqua. Please review.

Signed-off-by: Andreas Schallenberg<Andreas.Schallenberg@3alitytechnica.com>


--------------070106090909080508090806
Content-Type: text/plain; charset="UTF-8";
	name="0001-Add-support-for-TCA6424.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-Add-support-for-TCA6424.patch"

>From 25f4cbad51cec9107a9bdc90bb8182a98304a1c2 Mon Sep 17 00:00:00 2001
From: Andreas Schallenberg <aschallenberg@GWS026Linux.(none)>
Date: Thu, 19 Apr 2012 10:48:45 +0200
Subject: [PATCH] Add support for TCA6424

---
 drivers/gpio/gpio-pca953x.c |   43 ++++++++++++++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 0550dcb..58f9428 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -28,6 +28,8 @@
 #define PCA953X_INVERT		2
 #define PCA953X_DIRECTION	3
 
+#define REG_ADDR_AI		0x80
+
 #define PCA957X_IN		0
 #define PCA957X_INVRT		1
 #define PCA957X_BKEN		2
@@ -63,15 +65,15 @@ static const struct i2c_device_id pca953x_id[] = {
 	{ "pca6107", 8  | PCA953X_TYPE | PCA_INT, },
 	{ "tca6408", 8  | PCA953X_TYPE | PCA_INT, },
 	{ "tca6416", 16 | PCA953X_TYPE | PCA_INT, },
-	/* NYET:  { "tca6424", 24, }, */
+	{ "tca6424", 24 | PCA953X_TYPE | PCA_INT, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
 
 struct pca953x_chip {
 	unsigned gpio_start;
-	uint16_t reg_output;
-	uint16_t reg_direction;
+	uint reg_output;
+	uint reg_direction;
 	struct mutex i2c_lock;
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
@@ -89,12 +91,20 @@ struct pca953x_chip {
 	int	chip_type;
 };
 
-static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
+static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint val)
 {
 	int ret = 0;
 
 	if (chip->gpio_chip.ngpio <= 8)
 		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
+	else if (chip->gpio_chip.ngpio > 16) {
+		ret = i2c_smbus_write_word_data(chip->client,
+						(reg << 2) | REG_ADDR_AI,
+						val & 0xffff);
+		ret = i2c_smbus_write_byte_data(chip->client,
+						(reg << 2) + 2,
+						(val & 0xff0000) >> 16);
+	}
 	else {
 		switch (chip->chip_type) {
 		case PCA953X_TYPE:
@@ -121,12 +131,17 @@ static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
 	return 0;
 }
 
-static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
+static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint *val)
 {
 	int ret;
 
 	if (chip->gpio_chip.ngpio <= 8)
 		ret = i2c_smbus_read_byte_data(chip->client, reg);
+	else if (chip->gpio_chip.ngpio == 24) {
+		ret =  i2c_smbus_read_word_data(chip->client, reg << 2);
+		ret |= (i2c_smbus_read_byte_data(chip->client,
+						 (reg << 2) + 2)<<16);
+	}
 	else
 		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
 
@@ -135,14 +150,14 @@ static int pca953x_read_reg(struct pca953x_chip *chip, int reg, uint16_t *val)
 		return ret;
 	}
 
-	*val = (uint16_t)ret;
+	*val = (uint)ret;
 	return 0;
 }
 
 static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 {
 	struct pca953x_chip *chip;
-	uint16_t reg_val;
+	uint reg_val;
 	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
@@ -173,7 +188,7 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 		unsigned off, int val)
 {
 	struct pca953x_chip *chip;
-	uint16_t reg_val;
+	uint reg_val;
 	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
@@ -223,7 +238,7 @@ exit:
 static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 {
 	struct pca953x_chip *chip;
-	uint16_t reg_val;
+	uint reg_val;
 	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
@@ -253,7 +268,7 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 {
 	struct pca953x_chip *chip;
-	uint16_t reg_val;
+	uint reg_val;
 	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
@@ -386,7 +401,7 @@ static struct irq_chip pca953x_irq_chip = {
 
 static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
 {
-	uint16_t cur_stat;
+	uint     cur_stat;
 	uint16_t old_stat;
 	uint16_t pending;
 	uint16_t trigger;
@@ -449,6 +464,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 {
 	struct i2c_client *client = chip->client;
 	int ret, offset = 0;
+	uint temporary;
 
 	if (irq_base != -1
 			&& (id->driver_data & PCA_INT)) {
@@ -462,7 +478,8 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 			offset = PCA957X_IN;
 			break;
 		}
-		ret = pca953x_read_reg(chip, offset, &chip->irq_stat);
+		ret = pca953x_read_reg(chip, offset, &temporary);
+		chip->irq_stat = temporary;
 		if (ret)
 			goto out_failed;
 
@@ -606,7 +623,7 @@ out:
 static int __devinit device_pca957x_init(struct pca953x_chip *chip, int invert)
 {
 	int ret;
-	uint16_t val = 0;
+	uint val = 0;
 
 	/* Let every port in proper state, that could save power */
 	pca953x_write_reg(chip, PCA957X_PUPD, 0x0);
-- 
1.7.3.4


--------------070106090909080508090806--
