Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1DROST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:18:19 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58550 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1DROSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:18:13 -0400
X-ASG-Debug-ID: 1303136293-082e70400001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: haojian.zhuang@gmail.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>
X-ASG-Orig-Subj: [PATCH 01/01] gpio: support pca9574 and pca9575
Subject: [PATCH 01/01] gpio: support pca9574 and pca9575
Date: Mon, 18 Apr 2011 22:12:46 +0800
X-ASG-Orig-Subj: [PATCH 01/01] gpio: support pca9574 and pca9575
Message-Id: <1303135966-29400-1-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041802>
References: <2011041802>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303136293
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCA957x is i2c gpio expander, and similar to PCA953x. Although register
configurations are different between PCA957x and PCA953x. They can share
a lot of components, such as IRQ handling, GPIO IN/OUT. So updating PCA953x
driver to support PCA957x chips.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/gpio/pca953x.c |  249 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 191 insertions(+), 58 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index b473429..0de208f 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -24,33 +24,46 @@
 #include <linux/of_gpio.h>
 #endif
 
-#define PCA953X_INPUT          0
-#define PCA953X_OUTPUT         1
-#define PCA953X_INVERT         2
-#define PCA953X_DIRECTION      3
-
-#define PCA953X_GPIOS	       0x00FF
-#define PCA953X_INT	       0x0100
+#define PCA953X_INPUT		0
+#define PCA953X_OUTPUT		1
+#define PCA953X_INVERT		2
+#define PCA953X_DIRECTION	3
+
+#define PCA957X_IN		0
+#define PCA957X_INVRT		1
+#define PCA957X_BKEN		2
+#define PCA957X_PUPD		3
+#define PCA957X_CFG		4
+#define PCA957X_OUT		5
+#define PCA957X_MSK		6
+#define PCA957X_INTS		7
+
+#define PCA_GPIO_MASK		0x00FF
+#define PCA_INT			0x0100
+#define PCA953X_TYPE		0x1000
+#define PCA957X_TYPE		0x2000
 
 static const struct i2c_device_id pca953x_id[] = {
-	{ "pca9534", 8  | PCA953X_INT, },
-	{ "pca9535", 16 | PCA953X_INT, },
-	{ "pca9536", 4, },
-	{ "pca9537", 4  | PCA953X_INT, },
-	{ "pca9538", 8  | PCA953X_INT, },
-	{ "pca9539", 16 | PCA953X_INT, },
-	{ "pca9554", 8  | PCA953X_INT, },
-	{ "pca9555", 16 | PCA953X_INT, },
-	{ "pca9556", 8, },
-	{ "pca9557", 8, },
-
-	{ "max7310", 8, },
-	{ "max7312", 16 | PCA953X_INT, },
-	{ "max7313", 16 | PCA953X_INT, },
-	{ "max7315", 8  | PCA953X_INT, },
-	{ "pca6107", 8  | PCA953X_INT, },
-	{ "tca6408", 8  | PCA953X_INT, },
-	{ "tca6416", 16 | PCA953X_INT, },
+	{ "pca9534", 8  | PCA953X_TYPE | PCA_INT, },
+	{ "pca9535", 16 | PCA953X_TYPE | PCA_INT, },
+	{ "pca9536", 4  | PCA953X_TYPE, },
+	{ "pca9537", 4  | PCA953X_TYPE | PCA_INT, },
+	{ "pca9538", 8  | PCA953X_TYPE | PCA_INT, },
+	{ "pca9539", 16 | PCA953X_TYPE | PCA_INT, },
+	{ "pca9554", 8  | PCA953X_TYPE | PCA_INT, },
+	{ "pca9555", 16 | PCA953X_TYPE | PCA_INT, },
+	{ "pca9556", 8  | PCA953X_TYPE, },
+	{ "pca9557", 8  | PCA953X_TYPE, },
+	{ "pca9574", 8  | PCA957X_TYPE | PCA_INT, },
+	{ "pca9575", 16 | PCA957X_TYPE | PCA_INT, },
+
+	{ "max7310", 8  | PCA953X_TYPE, },
+	{ "max7312", 16 | PCA953X_TYPE | PCA_INT, },
+	{ "max7313", 16 | PCA953X_TYPE | PCA_INT, },
+	{ "max7315", 8  | PCA953X_TYPE | PCA_INT, },
+	{ "pca6107", 8  | PCA953X_TYPE | PCA_INT, },
+	{ "tca6408", 8  | PCA953X_TYPE | PCA_INT, },
+	{ "tca6416", 16 | PCA953X_TYPE | PCA_INT, },
 	/* NYET:  { "tca6424", 24, }, */
 	{ }
 };
@@ -75,16 +88,32 @@ struct pca953x_chip {
 	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
 	const char *const *names;
+	int	chip_type;
 };
 
 static int pca953x_write_reg(struct pca953x_chip *chip, int reg, uint16_t val)
 {
-	int ret;
+	int ret = 0;
 
 	if (chip->gpio_chip.ngpio <= 8)
 		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
-	else
-		ret = i2c_smbus_write_word_data(chip->client, reg << 1, val);
+	else {
+		switch (chip->chip_type) {
+		case PCA953X_TYPE:
+			ret = i2c_smbus_write_word_data(chip->client,
+							reg << 1, val);
+			break;
+		case PCA957X_TYPE:
+			ret = i2c_smbus_write_byte_data(chip->client, reg << 1,
+							val & 0xff);
+			if (ret < 0)
+				break;
+			ret = i2c_smbus_write_byte_data(chip->client,
+							(reg << 1) + 1,
+							(val & 0xff00) >> 8);
+			break;
+		}
+	}
 
 	if (ret < 0) {
 		dev_err(&chip->client->dev, "failed writing register\n");
@@ -116,13 +145,22 @@ static int pca953x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
 {
 	struct pca953x_chip *chip;
 	uint16_t reg_val;
-	int ret;
+	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
 	mutex_lock(&chip->i2c_lock);
 	reg_val = chip->reg_direction | (1u << off);
-	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
+
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_DIRECTION;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_CFG;
+		break;
+	}
+	ret = pca953x_write_reg(chip, offset, reg_val);
 	if (ret)
 		goto exit;
 
@@ -138,7 +176,7 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 {
 	struct pca953x_chip *chip;
 	uint16_t reg_val;
-	int ret;
+	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
@@ -149,7 +187,15 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 	else
 		reg_val = chip->reg_output & ~(1u << off);
 
-	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_OUTPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_OUT;
+		break;
+	}
+	ret = pca953x_write_reg(chip, offset, reg_val);
 	if (ret)
 		goto exit;
 
@@ -157,7 +203,15 @@ static int pca953x_gpio_direction_output(struct gpio_chip *gc,
 
 	/* then direction */
 	reg_val = chip->reg_direction & ~(1u << off);
-	ret = pca953x_write_reg(chip, PCA953X_DIRECTION, reg_val);
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_DIRECTION;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_CFG;
+		break;
+	}
+	ret = pca953x_write_reg(chip, offset, reg_val);
 	if (ret)
 		goto exit;
 
@@ -172,12 +226,20 @@ static int pca953x_gpio_get_value(struct gpio_chip *gc, unsigned off)
 {
 	struct pca953x_chip *chip;
 	uint16_t reg_val;
-	int ret;
+	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
 	mutex_lock(&chip->i2c_lock);
-	ret = pca953x_read_reg(chip, PCA953X_INPUT, &reg_val);
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_INPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_IN;
+		break;
+	}
+	ret = pca953x_read_reg(chip, offset, &reg_val);
 	mutex_unlock(&chip->i2c_lock);
 	if (ret < 0) {
 		/* NOTE:  diagnostic already emitted; that's all we should
@@ -194,7 +256,7 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 {
 	struct pca953x_chip *chip;
 	uint16_t reg_val;
-	int ret;
+	int ret, offset = 0;
 
 	chip = container_of(gc, struct pca953x_chip, gpio_chip);
 
@@ -204,7 +266,15 @@ static void pca953x_gpio_set_value(struct gpio_chip *gc, unsigned off, int val)
 	else
 		reg_val = chip->reg_output & ~(1u << off);
 
-	ret = pca953x_write_reg(chip, PCA953X_OUTPUT, reg_val);
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_OUTPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_OUT;
+		break;
+	}
+	ret = pca953x_write_reg(chip, offset, reg_val);
 	if (ret)
 		goto exit;
 
@@ -322,9 +392,17 @@ static uint16_t pca953x_irq_pending(struct pca953x_chip *chip)
 	uint16_t old_stat;
 	uint16_t pending;
 	uint16_t trigger;
-	int ret;
-
-	ret = pca953x_read_reg(chip, PCA953X_INPUT, &cur_stat);
+	int ret, offset = 0;
+
+	switch (chip->chip_type) {
+	case PCA953X_TYPE:
+		offset = PCA953X_INPUT;
+		break;
+	case PCA957X_TYPE:
+		offset = PCA957X_IN;
+		break;
+	}
+	ret = pca953x_read_reg(chip, offset, &cur_stat);
 	if (ret)
 		return 0;
 
@@ -372,14 +450,21 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 {
 	struct i2c_client *client = chip->client;
 	struct pca953x_platform_data *pdata = client->dev.platform_data;
-	int ret;
+	int ret, offset = 0;
 
 	if (pdata->irq_base != -1
-			&& (id->driver_data & PCA953X_INT)) {
+			&& (id->driver_data & PCA_INT)) {
 		int lvl;
 
-		ret = pca953x_read_reg(chip, PCA953X_INPUT,
-				       &chip->irq_stat);
+		switch (chip->chip_type) {
+		case PCA953X_TYPE:
+			offset = PCA953X_INPUT;
+			break;
+		case PCA957X_TYPE:
+			offset = PCA957X_IN;
+			break;
+		}
+		ret = pca953x_read_reg(chip, offset, &chip->irq_stat);
 		if (ret)
 			goto out_failed;
 
@@ -439,7 +524,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 	struct i2c_client *client = chip->client;
 	struct pca953x_platform_data *pdata = client->dev.platform_data;
 
-	if (pdata->irq_base != -1 && (id->driver_data & PCA953X_INT))
+	if (pdata->irq_base != -1 && (id->driver_data & PCA_INT))
 		dev_warn(&client->dev, "interrupt support not compiled in\n");
 
 	return 0;
@@ -498,12 +583,65 @@ pca953x_get_alt_pdata(struct i2c_client *client)
 }
 #endif
 
+static int __devinit device_pca953x_init(struct pca953x_chip *chip, int invert)
+{
+	int ret;
+
+	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
+	if (ret)
+		goto out;
+
+	ret = pca953x_read_reg(chip, PCA953X_DIRECTION,
+			       &chip->reg_direction);
+	if (ret)
+		goto out;
+
+	/* set platform specific polarity inversion */
+	ret = pca953x_write_reg(chip, PCA953X_INVERT, invert);
+	if (ret)
+		goto out;
+	return 0;
+out:
+	return ret;
+}
+
+static int __devinit device_pca957x_init(struct pca953x_chip *chip, int invert)
+{
+	int ret;
+	uint16_t val = 0;
+
+	/* Let every port in proper state, that could save power */
+	pca953x_write_reg(chip, PCA957X_PUPD, 0x0);
+	pca953x_write_reg(chip, PCA957X_CFG, 0xffff);
+	pca953x_write_reg(chip, PCA957X_OUT, 0x0);
+
+	ret = pca953x_read_reg(chip, PCA957X_IN, &val);
+	if (ret)
+		goto out;
+	ret = pca953x_read_reg(chip, PCA957X_OUT, &chip->reg_output);
+	if (ret)
+		goto out;
+	ret = pca953x_read_reg(chip, PCA957X_CFG, &chip->reg_direction);
+	if (ret)
+		goto out;
+
+	/* set platform specific polarity inversion */
+	pca953x_write_reg(chip, PCA957X_INVRT, invert);
+
+	/* To enable register 6, 7 to controll pull up and pull down */
+	pca953x_write_reg(chip, PCA957X_BKEN, 0x202);
+
+	return 0;
+out:
+	return ret;
+}
+
 static int __devinit pca953x_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
-	int ret;
+	int ret = 0;
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -530,25 +668,20 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	chip->gpio_start = pdata->gpio_base;
 
 	chip->names = pdata->names;
+	chip->chip_type = id->driver_data & (PCA953X_TYPE | PCA957X_TYPE);
 
 	mutex_init(&chip->i2c_lock);
 
 	/* initialize cached registers from their original values.
 	 * we can't share this chip with another i2c master.
 	 */
-	pca953x_setup_gpio(chip, id->driver_data & PCA953X_GPIOS);
+	pca953x_setup_gpio(chip, id->driver_data & PCA_GPIO_MASK);
 
-	ret = pca953x_read_reg(chip, PCA953X_OUTPUT, &chip->reg_output);
-	if (ret)
-		goto out_failed;
-
-	ret = pca953x_read_reg(chip, PCA953X_DIRECTION, &chip->reg_direction);
-	if (ret)
-		goto out_failed;
-
-	/* set platform specific polarity inversion */
-	ret = pca953x_write_reg(chip, PCA953X_INVERT, pdata->invert);
-	if (ret)
+	if (chip->chip_type == PCA953X_TYPE)
+		device_pca953x_init(chip, pdata->invert);
+	else if (chip->chip_type == PCA957X_TYPE)
+		device_pca957x_init(chip, pdata->invert);
+	else
 		goto out_failed;
 
 	ret = pca953x_irq_setup(chip, id);
-- 
1.5.6.5

