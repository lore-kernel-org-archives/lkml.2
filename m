Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab2EXIfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:35:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44337 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab2EXIfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:35:12 -0400
Message-ID: <1337848502.21777.1.camel@phoenix>
Subject: [PATCH] mfd: mc13xxx: Use devm_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Philippe =?ISO-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 24 May 2012 16:35:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/mc13xxx-core.c |    4 ----
 drivers/mfd/mc13xxx-i2c.c  |    6 +++---
 drivers/mfd/mc13xxx-spi.c  |    5 ++---
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
index f0ea3b8..b801dc7 100644
--- a/drivers/mfd/mc13xxx-core.c
+++ b/drivers/mfd/mc13xxx-core.c
@@ -723,10 +723,6 @@ void mc13xxx_common_cleanup(struct mc13xxx *mc13xxx)
 	free_irq(mc13xxx->irq, mc13xxx);
 
 	mfd_remove_devices(mc13xxx->dev);
-
-	regmap_exit(mc13xxx->regmap);
-
-	kfree(mc13xxx);
 }
 EXPORT_SYMBOL_GPL(mc13xxx_common_cleanup);
 
diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index d22501d..18d29f3 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -63,7 +63,7 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 	if (of_id)
 		idrv->id_table = (const struct i2c_device_id*) of_id->data;
 
-	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
+	mc13xxx = devm_kzalloc(&client->dev, sizeof(*mc13xxx), GFP_KERNEL);
 	if (!mc13xxx)
 		return -ENOMEM;
 
@@ -72,13 +72,13 @@ static int mc13xxx_i2c_probe(struct i2c_client *client,
 	mc13xxx->dev = &client->dev;
 	mutex_init(&mc13xxx->lock);
 
-	mc13xxx->regmap = regmap_init_i2c(client, &mc13xxx_regmap_i2c_config);
+	mc13xxx->regmap = devm_regmap_init_i2c(client,
+					       &mc13xxx_regmap_i2c_config);
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
 				ret);
 		dev_set_drvdata(&client->dev, NULL);
-		kfree(mc13xxx);
 		return ret;
 	}
 
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 3fcdab3..c629f59 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -67,7 +67,7 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 	if (of_id)
 		sdrv->id_table = &mc13xxx_device_id[(enum mc13xxx_id) of_id->data];
 
-	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
+	mc13xxx = devm_kzalloc(&spi->dev, sizeof(*mc13xxx), GFP_KERNEL);
 	if (!mc13xxx)
 		return -ENOMEM;
 
@@ -78,13 +78,12 @@ static int mc13xxx_spi_probe(struct spi_device *spi)
 	mc13xxx->dev = &spi->dev;
 	mutex_init(&mc13xxx->lock);
 
-	mc13xxx->regmap = regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
+	mc13xxx->regmap = devm_regmap_init_spi(spi, &mc13xxx_regmap_spi_config);
 	if (IS_ERR(mc13xxx->regmap)) {
 		ret = PTR_ERR(mc13xxx->regmap);
 		dev_err(mc13xxx->dev, "Failed to initialize register map: %d\n",
 				ret);
 		dev_set_drvdata(&spi->dev, NULL);
-		kfree(mc13xxx);
 		return ret;
 	}
 
-- 
1.7.5.4



