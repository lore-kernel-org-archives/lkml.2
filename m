Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab2AJHKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 02:10:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62158 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2AJHKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 02:10:04 -0500
Message-ID: <1326179396.4956.3.camel@phoenix>
Subject: [PATCH] mfd: da9052: Add missing regmap_exit to free a previously
 allocated register map
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 10 Jan 2012 15:09:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/da9052-i2c.c |    7 +++++--
 drivers/mfd/da9052-spi.c |    5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 44b97c7..fdc2c6a 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -74,14 +74,16 @@ static int __devinit da9052_i2c_probe(struct i2c_client *client,
 
 	ret = da9052_i2c_enable_multiwrite(da9052);
 	if (ret < 0)
-		goto err;
+		goto err_regmap;
 
 	ret = da9052_device_init(da9052, id->driver_data);
 	if (ret != 0)
-		goto err;
+		goto err_regmap;
 
 	return 0;
 
+err_regmap:
+	regmap_exit(da9052->regmap);
 err:
 	kfree(da9052);
 	return ret;
@@ -92,6 +94,7 @@ static int da9052_i2c_remove(struct i2c_client *client)
 	struct da9052 *da9052 = i2c_get_clientdata(client);
 
 	da9052_device_exit(da9052);
+	regmap_exit(da9052->regmap);
 	kfree(da9052);
 
 	return 0;
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index cdbc7ca..76bb9ea08 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -52,10 +52,12 @@ static int da9052_spi_probe(struct spi_device *spi)
 
 	ret = da9052_device_init(da9052, id->driver_data);
 	if (ret != 0)
-		goto err;
+		goto err_regmap;
 
 	return 0;
 
+err_regmap:
+	regmap_exit(da9052->regmap);
 err:
 	kfree(da9052);
 	return ret;
@@ -66,6 +68,7 @@ static int da9052_spi_remove(struct spi_device *spi)
 	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
 
 	da9052_device_exit(da9052);
+	regmap_exit(da9052->regmap);
 	kfree(da9052);
 
 	return 0;
-- 
1.7.5.4



