Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab2GKLhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 07:37:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52657 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2GKLhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 07:37:10 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [RFC internal PATCH] mfd/mc13xxx: drop modifying driver's id_table in probe
Date: Wed, 11 Jul 2012 13:36:48 +0200
Message-Id: <1342006608-30550-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced in commit

	876989d (mfd: Add device tree probe support for mc13xxx)

for spi and later while introducing support for i2c copied to the i2c
driver.

Modifying driver details is very strange, for example probing an
mc13892 device (instantiated via dt) removes the driver's ability to
handle (traditionally probed) mc13783 devices in this case.
I'm not aware of any problems that make this hack necessary and if
there were some, they'd have to be fixed in the spi/i2c core, not in
a driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello Samuel,

even though this qualifies as fix, I don't think it's necessary to annoy
Linus with it for 3.5. Usually there is only one pmic on each machine so
it's not grave when probing one device disables support for another.

Best regards
Uwe

 drivers/mfd/mc13xxx-i2c.c |    6 ------
 drivers/mfd/mc13xxx-spi.c |    6 ------
 2 files changed, 12 deletions(-)

diff --git a/drivers/mfd/mc13xxx-i2c.c b/drivers/mfd/mc13xxx-i2c.c
index d22501d..e00e885 100644
--- a/drivers/mfd/mc13xxx-i2c.c
+++ b/drivers/mfd/mc13xxx-i2c.c
@@ -53,16 +53,10 @@ static struct regmap_config mc13xxx_regmap_i2c_config = {
 static int mc13xxx_i2c_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
-	const struct of_device_id *of_id;
-	struct i2c_driver *idrv = to_i2c_driver(client->dev.driver);
 	struct mc13xxx *mc13xxx;
 	struct mc13xxx_platform_data *pdata = dev_get_platdata(&client->dev);
 	int ret;
 
-	of_id = of_match_device(mc13xxx_dt_ids, &client->dev);
-	if (of_id)
-		idrv->id_table = (const struct i2c_device_id*) of_id->data;
-
 	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
 	if (!mc13xxx)
 		return -ENOMEM;
diff --git a/drivers/mfd/mc13xxx-spi.c b/drivers/mfd/mc13xxx-spi.c
index 03df422..b99e728 100644
--- a/drivers/mfd/mc13xxx-spi.c
+++ b/drivers/mfd/mc13xxx-spi.c
@@ -119,16 +119,10 @@ static struct regmap_bus regmap_mc13xxx_bus = {
 
 static int mc13xxx_spi_probe(struct spi_device *spi)
 {
-	const struct of_device_id *of_id;
-	struct spi_driver *sdrv = to_spi_driver(spi->dev.driver);
 	struct mc13xxx *mc13xxx;
 	struct mc13xxx_platform_data *pdata = dev_get_platdata(&spi->dev);
 	int ret;
 
-	of_id = of_match_device(mc13xxx_dt_ids, &spi->dev);
-	if (of_id)
-		sdrv->id_table = &mc13xxx_device_id[(enum mc13xxx_id) of_id->data];
-
 	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
 	if (!mc13xxx)
 		return -ENOMEM;
-- 
1.7.10.4

