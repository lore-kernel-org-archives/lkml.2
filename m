Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1FNJBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:01:31 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:13711 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab1FNJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:00:50 -0400
From: David Jander <david@protonic.nl>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v5 2/5] GPIO: pca953x.c: Remove dynamic platform data pointer
Date: Tue, 14 Jun 2011 11:00:55 +0200
Message-Id: <1308042058-20107-3-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308042058-20107-1-git-send-email-david@protonic.nl>
References: <1308042058-20107-1-git-send-email-david@protonic.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case that we obtain device-tree data to fill in platform_data, the new
platform data struct was dynamically allocated, but the pointer to it was not
used everywhere it should. It seems easier to fix this issue by removing the
dynamic allocation altogether since its data is only used during driver
probing.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/gpio/pca953x.c |   77 +++++++++++++++++------------------------------
 1 files changed, 28 insertions(+), 49 deletions(-)

diff --git a/drivers/gpio/pca953x.c b/drivers/gpio/pca953x.c
index 5f6940a..db69d9e 100644
--- a/drivers/gpio/pca953x.c
+++ b/drivers/gpio/pca953x.c
@@ -85,7 +85,6 @@ struct pca953x_chip {
 #endif
 
 	struct i2c_client *client;
-	struct pca953x_platform_data *dyn_pdata;
 	struct gpio_chip gpio_chip;
 	const char *const *names;
 	int	chip_type;
@@ -446,13 +445,13 @@ static irqreturn_t pca953x_irq_handler(int irq, void *devid)
 }
 
 static int pca953x_irq_setup(struct pca953x_chip *chip,
-			     const struct i2c_device_id *id)
+			     const struct i2c_device_id *id,
+			     int irq_base)
 {
 	struct i2c_client *client = chip->client;
-	struct pca953x_platform_data *pdata = client->dev.platform_data;
 	int ret, offset = 0;
 
-	if (pdata->irq_base != -1
+	if (irq_base != -1
 			&& (id->driver_data & PCA_INT)) {
 		int lvl;
 
@@ -476,7 +475,7 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 		chip->irq_stat &= chip->reg_direction;
 		mutex_init(&chip->irq_lock);
 
-		chip->irq_base = irq_alloc_descs(-1, pdata->irq_base, chip->gpio_chip.ngpio, -1);
+		chip->irq_base = irq_alloc_descs(-1, irq_base, chip->gpio_chip.ngpio, -1);
 		if (chip->irq_base < 0)
 			goto out_failed;
 
@@ -525,12 +524,12 @@ static void pca953x_irq_teardown(struct pca953x_chip *chip)
 }
 #else /* CONFIG_GPIO_PCA953X_IRQ */
 static int pca953x_irq_setup(struct pca953x_chip *chip,
-			     const struct i2c_device_id *id)
+			     const struct i2c_device_id *id,
+			     int irq_base)
 {
 	struct i2c_client *client = chip->client;
-	struct pca953x_platform_data *pdata = client->dev.platform_data;
 
-	if (pdata->irq_base != -1 && (id->driver_data & PCA_INT))
+	if (irq_base != -1 && (id->driver_data & PCA_INT))
 		dev_warn(&client->dev, "interrupt support not compiled in\n");
 
 	return 0;
@@ -548,45 +547,35 @@ static void pca953x_irq_teardown(struct pca953x_chip *chip)
 /*
  * Translate OpenFirmware node properties into platform_data
  */
-static struct pca953x_platform_data *
-pca953x_get_alt_pdata(struct i2c_client *client)
+void
+pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 {
-	struct pca953x_platform_data *pdata;
 	struct device_node *node;
 	const __be32 *val;
 	int size;
 
 	node = client->dev.of_node;
 	if (node == NULL)
-		return NULL;
+		return;
 
-	pdata = kzalloc(sizeof(struct pca953x_platform_data), GFP_KERNEL);
-	if (pdata == NULL) {
-		dev_err(&client->dev, "Unable to allocate platform_data\n");
-		return NULL;
-	}
-
-	pdata->gpio_base = -1;
+	*gpio_base = -1;
 	val = of_get_property(node, "linux,gpio-base", &size);
 	if (val) {
 		if (size != sizeof(*val))
 			dev_warn(&client->dev, "%s: wrong linux,gpio-base\n",
 				 node->full_name);
 		else
-			pdata->gpio_base = be32_to_cpup(val);
+			*gpio_base = be32_to_cpup(val);
 	}
 
 	val = of_get_property(node, "polarity", NULL);
 	if (val)
-		pdata->invert = *val;
-
-	return pdata;
+		*invert = *val;
 }
 #else
-static struct pca953x_platform_data *
-pca953x_get_alt_pdata(struct i2c_client *client)
+void
+pca953x_get_alt_pdata(struct i2c_client *client, int *gpio_base, int *invert)
 {
-	return NULL;
 }
 #endif
 
@@ -648,6 +637,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 {
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
+	int irq_base=-1, invert=0;
 	int ret = 0;
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
@@ -655,26 +645,17 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	pdata = client->dev.platform_data;
-	if (pdata == NULL) {
-		pdata = pca953x_get_alt_pdata(client);
-		/*
-		 * Unlike normal platform_data, this is allocated
-		 * dynamically and must be freed in the driver
-		 */
-		chip->dyn_pdata = pdata;
-	}
-
-	if (pdata == NULL) {
-		dev_dbg(&client->dev, "no platform data\n");
-		ret = -EINVAL;
-		goto out_failed;
+	if (pdata) {
+		irq_base = pdata->irq_base;
+		chip->gpio_start = pdata->gpio_base;
+		invert = pdata->invert;
+		chip->names = pdata->names;
+	} else {
+		pca953x_get_alt_pdata(client, &chip->gpio_start, &invert);
 	}
 
 	chip->client = client;
 
-	chip->gpio_start = pdata->gpio_base;
-
-	chip->names = pdata->names;
 	chip->chip_type = id->driver_data & (PCA953X_TYPE | PCA957X_TYPE);
 
 	mutex_init(&chip->i2c_lock);
@@ -685,13 +666,13 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	pca953x_setup_gpio(chip, id->driver_data & PCA_GPIO_MASK);
 
 	if (chip->chip_type == PCA953X_TYPE)
-		device_pca953x_init(chip, pdata->invert);
+		device_pca953x_init(chip, invert);
 	else if (chip->chip_type == PCA957X_TYPE)
-		device_pca957x_init(chip, pdata->invert);
+		device_pca957x_init(chip, invert);
 	else
 		goto out_failed;
 
-	ret = pca953x_irq_setup(chip, id);
+	ret = pca953x_irq_setup(chip, id, irq_base);
 	if (ret)
 		goto out_failed;
 
@@ -699,7 +680,7 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 	if (ret)
 		goto out_failed_irq;
 
-	if (pdata->setup) {
+	if (pdata && pdata->setup) {
 		ret = pdata->setup(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0)
@@ -712,7 +693,6 @@ static int __devinit pca953x_probe(struct i2c_client *client,
 out_failed_irq:
 	pca953x_irq_teardown(chip);
 out_failed:
-	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return ret;
 }
@@ -723,7 +703,7 @@ static int pca953x_remove(struct i2c_client *client)
 	struct pca953x_chip *chip = i2c_get_clientdata(client);
 	int ret = 0;
 
-	if (pdata->teardown) {
+	if (pdata && pdata->teardown) {
 		ret = pdata->teardown(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0) {
@@ -741,7 +721,6 @@ static int pca953x_remove(struct i2c_client *client)
 	}
 
 	pca953x_irq_teardown(chip);
-	kfree(chip->dyn_pdata);
 	kfree(chip);
 	return 0;
 }
-- 
1.7.4.1

