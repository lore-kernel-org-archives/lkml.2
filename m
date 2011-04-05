Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1DEIb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 04:31:26 -0400
Received: from mail.microcatalog.org.uk ([217.6.246.34]:41503 "EHLO
	root.phytec.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483Ab1DEIbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 04:31:25 -0400
From: Jan Weitzel <j.weitzel@phytec.de>
To: riku.voipio@iki.fi, rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Jan Weitzel <j.weitzel@phytec.de>
Subject: [PATCH] leds: leds-pca9532 add support pca9530, pca9531 and pca9533
Date: Tue, 5 Apr 2011 10:27:23 +0200
Message-Id: <1301992043-9552-1-git-send-email-j.weitzel@phytec.de>
X-Mailer: git-send-email 1.7.0.4
X-MIMETrack: Itemize by SMTP Server on Idefix/Phytec(Release 8.5.2 HF194|November 09, 2010) at
 05.04.2011 10:31:23,
	Serialize by Router on Idefix/Phytec(Release 8.5.2 HF194|November 09, 2010) at
 05.04.2011 10:31:23,
	Serialize complete at 05.04.2011 10:31:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding chipinfo to use driver with pca953x family
Rename driver to pca953x, but left files and platformflags named pca9532

Tested with pca9530 and pca9533

Tested-by: Juergen Kilb <j.kilb@phytec.de>
Signed-off-by: Jan Weitzel <j.weitzel@phytec.de>
---
 drivers/leds/leds-pca9532.c |   80 ++++++++++++++++++++++++++++++++-----------
 1 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index afac338..5479b8f 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -1,13 +1,14 @@
 /*
  * pca9532.c - 16-bit Led dimmer
  *
+ * Copyright (C) 2011 Jan Weitzel
  * Copyright (C) 2008 Riku Voipio
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; version 2 of the License.
  *
- * Datasheet: http://www.nxp.com/acrobat/datasheets/PCA9532_3.pdf
+ * Datasheet: http://www.nxp.com/documents/data_sheet/PCA9532.pdf
  *
  */
 
@@ -20,20 +21,26 @@
 #include <linux/workqueue.h>
 #include <linux/leds-pca9532.h>
 
-#define PCA9532_REG_PSC(i) (0x2+(i)*2)
-#define PCA9532_REG_PWM(i) (0x3+(i)*2)
-#define PCA9532_REG_LS0  0x6
-#define LED_REG(led) ((led>>2)+PCA9532_REG_LS0)
-#define LED_NUM(led) (led & 0x3)
+/* m =  num_leds*/
+#define PCA9532_REG_OFFSET(m)	((m) >> 4)
+#define PCA9532_REG_PSC(m, i)	(PCA9532_REG_OFFSET(m) + 0x1 + (i) * 2)
+#define PCA9532_REG_PWM(m, i)	(PCA9532_REG_OFFSET(m) + 0x2 + (i) * 2)
+#define LED_REG(m, led)		(PCA9532_REG_OFFSET(m) + 0x5 + (led >> 2))
+#define LED_NUM(led)		(led & 0x3)
 
 #define ldev_to_led(c)       container_of(c, struct pca9532_led, ldev)
 
+struct pca9532_chip_info {
+	u8	num_leds;
+};
+
 struct pca9532_data {
 	struct i2c_client *client;
 	struct pca9532_led leds[16];
 	struct mutex update_lock;
 	struct input_dev *idev;
 	struct work_struct work;
+	const struct pca9532_chip_info *chip_info;
 	u8 pwm[2];
 	u8 psc[2];
 };
@@ -42,16 +49,41 @@ static int pca9532_probe(struct i2c_client *client,
 	const struct i2c_device_id *id);
 static int pca9532_remove(struct i2c_client *client);
 
+enum {
+	pca9530,
+	pca9531,
+	pca9532,
+	pca9533,
+};
+
 static const struct i2c_device_id pca9532_id[] = {
-	{ "pca9532", 0 },
+	{ "pca9530", pca9530 },
+	{ "pca9531", pca9531 },
+	{ "pca9532", pca9532 },
+	{ "pca9533", pca9533 },
 	{ }
 };
 
 MODULE_DEVICE_TABLE(i2c, pca9532_id);
 
+static const struct pca9532_chip_info pca9532_chip_info_tbl[] = {
+	[pca9530] = {
+		.num_leds = 2,
+	},
+	[pca9531] = {
+		.num_leds = 8,
+	},
+	[pca9532] = {
+		.num_leds = 16,
+	},
+	[pca9533] = {
+		.num_leds = 4,
+	},
+};
+
 static struct i2c_driver pca9532_driver = {
 	.driver = {
-		.name = "pca9532",
+		.name = "pca953x",
 	},
 	.probe = pca9532_probe,
 	.remove = pca9532_remove,
@@ -68,7 +100,7 @@ static int pca9532_calcpwm(struct i2c_client *client, int pwm, int blink,
 {
 	int a = 0, b = 0, i = 0;
 	struct pca9532_data *data = i2c_get_clientdata(client);
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < data->chip_info->num_leds; i++) {
 		if (data->leds[i].type == PCA9532_TYPE_LED &&
 			data->leds[i].state == PCA9532_PWM0+pwm) {
 				a++;
@@ -92,10 +124,12 @@ static int pca9532_calcpwm(struct i2c_client *client, int pwm, int blink,
 static int pca9532_setpwm(struct i2c_client *client, int pwm)
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
+	u8 maxleds = data->chip_info->num_leds;
+
 	mutex_lock(&data->update_lock);
-	i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(pwm),
+	i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(maxleds, pwm),
 		data->pwm[pwm]);
-	i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(pwm),
+	i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(maxleds, pwm),
 		data->psc[pwm]);
 	mutex_unlock(&data->update_lock);
 	return 0;
@@ -106,15 +140,16 @@ static void pca9532_setled(struct pca9532_led *led)
 {
 	struct i2c_client *client = led->client;
 	struct pca9532_data *data = i2c_get_clientdata(client);
+	u8 maxleds = data->chip_info->num_leds;
 	char reg;
 
 	mutex_lock(&data->update_lock);
-	reg = i2c_smbus_read_byte_data(client, LED_REG(led->id));
+	reg = i2c_smbus_read_byte_data(client, LED_REG(maxleds, led->id));
 	/* zero led bits */
 	reg = reg & ~(0x3<<LED_NUM(led->id)*2);
 	/* set the new value */
 	reg = reg | (led->state << LED_NUM(led->id)*2);
-	i2c_smbus_write_byte_data(client, LED_REG(led->id), reg);
+	i2c_smbus_write_byte_data(client, LED_REG(maxleds, led->id), reg);
 	mutex_unlock(&data->update_lock);
 }
 
@@ -183,10 +218,12 @@ static int pca9532_event(struct input_dev *dev, unsigned int type,
 
 static void pca9532_input_work(struct work_struct *work)
 {
-	struct pca9532_data *data;
-	data = container_of(work, struct pca9532_data, work);
+	struct pca9532_data *data =
+		container_of(work, struct pca9532_data, work);
+	u8 maxleds = data->chip_info->num_leds;
+
 	mutex_lock(&data->update_lock);
-	i2c_smbus_write_byte_data(data->client, PCA9532_REG_PWM(1),
+	i2c_smbus_write_byte_data(data->client, PCA9532_REG_PWM(maxleds, 1),
 		data->pwm[1]);
 	mutex_unlock(&data->update_lock);
 }
@@ -230,17 +267,18 @@ static int pca9532_configure(struct i2c_client *client,
 	struct pca9532_data *data, struct pca9532_platform_data *pdata)
 {
 	int i, err = 0;
+	u8 maxleds = data->chip_info->num_leds;
 
 	for (i = 0; i < 2; i++)	{
 		data->pwm[i] = pdata->pwm[i];
 		data->psc[i] = pdata->psc[i];
-		i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(i),
+		i2c_smbus_write_byte_data(client, PCA9532_REG_PWM(maxleds, i),
 			data->pwm[i]);
-		i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(i),
+		i2c_smbus_write_byte_data(client, PCA9532_REG_PSC(maxleds, i),
 			data->psc[i]);
 	}
 
-	for (i = 0; i < 16; i++) {
+	for (i = 0; i < data->chip_info->num_leds; i++) {
 		struct pca9532_led *led = &data->leds[i];
 		struct pca9532_led *pled = &pdata->leds[i];
 		led->client = client;
@@ -322,6 +360,8 @@ static int pca9532_probe(struct i2c_client *client,
 	if (!data)
 		return -ENOMEM;
 
+	data->chip_info = &pca9532_chip_info_tbl[id->driver_data];
+
 	dev_info(&client->dev, "setting platform data\n");
 	i2c_set_clientdata(client, data);
 	data->client = client;
@@ -337,7 +377,7 @@ static int pca9532_probe(struct i2c_client *client,
 static int pca9532_remove(struct i2c_client *client)
 {
 	struct pca9532_data *data = i2c_get_clientdata(client);
-	pca9532_destroy_devices(data, 16);
+	pca9532_destroy_devices(data, data->chip_info->num_leds);
 	kfree(data);
 	return 0;
 }
-- 
1.7.0.4

