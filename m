Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0IACZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 22:25:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62176 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0IACZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 22:25:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dq7qYlzX+rC7dJyNiPAMZyGr6/X37btmzAP/Ku60MqLBZpQ2QO0pJcLgo+36Olz6Sh
         DmcRry4/n4Tng7AjyXO4Kfd3iwh3nlrZgMv6PoTQ2X+n2K/JLGREcHzKlu11HToxQBlH
         YoUhFkXSqvFPoZrrYo7+wXyLoMBQhMdqRVXWU=
Subject: [PATCH] regulator: ad5398 - fix a memory leak
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain
Date: Wed, 01 Sep 2010 10:29:18 +0800
Message-Id: <1283308158.23075.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, the address return from regulator_register()
is different from the address for regulator_unregister().

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ad5398.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/ad5398.c b/drivers/regulator/ad5398.c
index 15ff61d..a4be416 100644
--- a/drivers/regulator/ad5398.c
+++ b/drivers/regulator/ad5398.c
@@ -25,7 +25,7 @@ struct ad5398_chip_info {
 	unsigned int current_level;
 	unsigned int current_mask;
 	unsigned int current_offset;
-	struct regulator_dev rdev;
+	struct regulator_dev *rdev;
 };
 
 static int ad5398_calc_current(struct ad5398_chip_info *chip,
@@ -211,7 +211,6 @@ MODULE_DEVICE_TABLE(i2c, ad5398_id);
 static int __devinit ad5398_probe(struct i2c_client *client,
 				const struct i2c_device_id *id)
 {
-	struct regulator_dev *rdev;
 	struct regulator_init_data *init_data = client->dev.platform_data;
 	struct ad5398_chip_info *chip;
 	const struct ad5398_current_data_format *df =
@@ -233,9 +232,10 @@ static int __devinit ad5398_probe(struct i2c_client *client,
 	chip->current_offset = df->current_offset;
 	chip->current_mask = (chip->current_level - 1) << chip->current_offset;
 
-	rdev = regulator_register(&ad5398_reg, &client->dev, init_data, chip);
-	if (IS_ERR(rdev)) {
-		ret = PTR_ERR(rdev);
+	chip->rdev = regulator_register(&ad5398_reg, &client->dev,
+					init_data, chip);
+	if (IS_ERR(chip->rdev)) {
+		ret = PTR_ERR(chip->rdev);
 		dev_err(&client->dev, "failed to register %s %s\n",
 			id->name, ad5398_reg.name);
 		goto err;
@@ -254,7 +254,7 @@ static int __devexit ad5398_remove(struct i2c_client *client)
 {
 	struct ad5398_chip_info *chip = i2c_get_clientdata(client);
 
-	regulator_unregister(&chip->rdev);
+	regulator_unregister(chip->rdev);
 	kfree(chip);
 
 	return 0;
-- 
1.7.2



