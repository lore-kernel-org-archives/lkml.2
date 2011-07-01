Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1GALdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:33:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60742 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab1GALdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:33:38 -0400
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Fri, 1 Jul 2011 13:33:18 +0200
Message-ID: <BANLkTimSkDEzPvRMmX1O0YjjpoPzQt6_+w@mail.gmail.com>
Subject: pca953x: support working w/o platform data
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide defaults for pca953x, so the driver can be used w/o
providing platform data.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
 pca953x.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)
diff -Nur linux-3.0-rc5/drivers/gpio//pca953x.c
linux-3.0-rc5__patched/drivers/gpio//pca953x.c
--- linux-3.0-rc5/drivers/gpio//pca953x.c	2011-06-28 04:12:22.000000000 +0200
+++ linux-3.0-rc5__patched/drivers/gpio//pca953x.c	2011-07-01
13:19:08.369130336 +0200
@@ -452,7 +452,7 @@
 	struct pca953x_platform_data *pdata = client->dev.platform_data;
 	int ret, offset = 0;

-	if (pdata->irq_base != -1
+	if (pdata && pdata->irq_base != -1
 			&& (id->driver_data & PCA_INT)) {
 		int lvl;

@@ -524,7 +524,7 @@
 	struct i2c_client *client = chip->client;
 	struct pca953x_platform_data *pdata = client->dev.platform_data;

-	if (pdata->irq_base != -1 && (id->driver_data & PCA_INT))
+	if (pdata && pdata->irq_base != -1 && (id->driver_data & PCA_INT))
 		dev_warn(&client->dev, "interrupt support not compiled in\n");

 	return 0;
@@ -643,6 +643,7 @@
 	struct pca953x_platform_data *pdata;
 	struct pca953x_chip *chip;
 	int ret = 0;
+	int invert = 0;

 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
@@ -660,15 +661,13 @@

 	if (pdata == NULL) {
 		dev_dbg(&client->dev, "no platform data\n");
-		ret = -EINVAL;
-		goto out_failed;
 	}

 	chip->client = client;

-	chip->gpio_start = pdata->gpio_base;
+	chip->gpio_start = pdata ? pdata->gpio_base : -1;

-	chip->names = pdata->names;
+	chip->names = pdata ? pdata->names : NULL;
 	chip->chip_type = id->driver_data & (PCA953X_TYPE | PCA957X_TYPE);

 	mutex_init(&chip->i2c_lock);
@@ -678,10 +677,12 @@
 	 */
 	pca953x_setup_gpio(chip, id->driver_data & PCA_GPIO_MASK);

+	invert = pdata ? pdata->invert : 0;
+
 	if (chip->chip_type == PCA953X_TYPE)
-		device_pca953x_init(chip, pdata->invert);
+		device_pca953x_init(chip, invert);
 	else if (chip->chip_type == PCA957X_TYPE)
-		device_pca957x_init(chip, pdata->invert);
+		device_pca957x_init(chip, invert);
 	else
 		goto out_failed;

@@ -693,7 +694,7 @@
 	if (ret)
 		goto out_failed_irq;

-	if (pdata->setup) {
+	if (pdata && pdata->setup) {
 		ret = pdata->setup(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0)
@@ -717,7 +718,7 @@
 	struct pca953x_chip *chip = i2c_get_clientdata(client);
 	int ret = 0;

-	if (pdata->teardown) {
+	if (pdata && pdata->teardown) {
 		ret = pdata->teardown(client, chip->gpio_chip.base,
 				chip->gpio_chip.ngpio, pdata->context);
 		if (ret < 0) {
---
