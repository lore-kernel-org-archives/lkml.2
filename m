Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab2GLKLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:11:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41488 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933639Ab2GLKJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:12 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/7] mfd/mc13xxx: drop modifying driver's id_table in probe
Date: Thu, 12 Jul 2012 11:57:51 +0200
Message-Id: <1342087073-3892-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
there were some, they have to be fixed in the spi/i2c core, not in
a driver.

Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
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

