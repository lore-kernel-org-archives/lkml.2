Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab2EKBaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:30:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34230 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab2EKBaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:30:01 -0400
Message-ID: <1336699791.8454.1.camel@phoenix>
Subject: [PATCH 1/2] mfd: da9052: Convert to use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Fri, 11 May 2012 09:29:51 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/da9052-i2c.c |   24 +++++++-----------------
 drivers/mfd/da9052-spi.c |   18 +++++-------------
 2 files changed, 12 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index d8abdb3..115a9c7 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -70,7 +70,7 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 	struct da9052 *da9052;
 	int ret;
 
-	da9052 = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+	da9052 = devm_kzalloc(&client->dev, sizeof(struct da9052), GFP_KERNEL);
 	if (!da9052)
 		return -ENOMEM;
 
@@ -78,8 +78,7 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 				     I2C_FUNC_SMBUS_BYTE_DATA)) {
 		dev_info(&client->dev, "Error in %s:i2c_check_functionality\n",
 			 __func__);
-		ret = -ENODEV;
-		goto err;
+		return  -ENODEV;
 	}
 
 	da9052->dev = &client->dev;
@@ -87,17 +86,17 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 
 	i2c_set_clientdata(client, da9052);
 
-	da9052->regmap = regmap_init_i2c(client, &da9052_regmap_config);
+	da9052->regmap = devm_regmap_init_i2c(client, &da9052_regmap_config);
 	if (IS_ERR(da9052->regmap)) {
 		ret = PTR_ERR(da9052->regmap);
 		dev_err(&client->dev, "Failed to allocate register map: %d\n",
 			ret);
-		goto err;
+		return ret;
 	}
 
 	ret = da9052_i2c_enable_multiwrite(da9052);
 	if (ret < 0)
-		goto err_regmap;
+		return ret;
 
 #ifdef CONFIG_OF
 	if (!id) {
@@ -112,20 +111,14 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 	if (!id) {
 		ret = -ENODEV;
 		dev_err(&client->dev, "id is null.\n");
-		goto err_regmap;
+		return ret;
 	}
 
 	ret = da9052_device_init(da9052, id->driver_data);
 	if (ret != 0)
-		goto err_regmap;
+		return ret;
 
 	return 0;
-
-err_regmap:
-	regmap_exit(da9052->regmap);
-err:
-	kfree(da9052);
-	return ret;
 }
 
 static int __devexit da9052_i2c_remove(struct i2c_client *client)
@@ -133,9 +126,6 @@ static int __devexit da9052_i2c_remove(struct i2c_client *client)
 	struct da9052 *da9052 = i2c_get_clientdata(client);
 
 	da9052_device_exit(da9052);
-	regmap_exit(da9052->regmap);
-	kfree(da9052);
-
 	return 0;
 }
 
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 6e09498..dbeadc5 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -25,8 +25,9 @@ static int __devinit da9052_spi_probe(struct spi_device *spi)
 {
 	int ret;
 	const struct spi_device_id *id = spi_get_device_id(spi);
-	struct da9052 *da9052 = kzalloc(sizeof(struct da9052), GFP_KERNEL);
+	struct da9052 *da9052;
 
+	da9052 = devm_kzalloc(&spi->dev, sizeof(struct da9052), GFP_KERNEL);
 	if (!da9052)
 		return -ENOMEM;
 
@@ -42,25 +43,19 @@ static int __devinit da9052_spi_probe(struct spi_device *spi)
 	da9052_regmap_config.read_flag_mask = 1;
 	da9052_regmap_config.write_flag_mask = 0;
 
-	da9052->regmap = regmap_init_spi(spi, &da9052_regmap_config);
+	da9052->regmap = devm_regmap_init_spi(spi, &da9052_regmap_config);
 	if (IS_ERR(da9052->regmap)) {
 		ret = PTR_ERR(da9052->regmap);
 		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
 			ret);
-		goto err;
+		return ret;
 	}
 
 	ret = da9052_device_init(da9052, id->driver_data);
 	if (ret != 0)
-		goto err_regmap;
+		return ret;
 
 	return 0;
-
-err_regmap:
-	regmap_exit(da9052->regmap);
-err:
-	kfree(da9052);
-	return ret;
 }
 
 static int __devexit da9052_spi_remove(struct spi_device *spi)
@@ -68,9 +63,6 @@ static int __devexit da9052_spi_remove(struct spi_device *spi)
 	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
 
 	da9052_device_exit(da9052);
-	regmap_exit(da9052->regmap);
-	kfree(da9052);
-
 	return 0;
 }
 
-- 
1.7.5.4



