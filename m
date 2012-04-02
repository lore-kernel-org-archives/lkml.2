Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab2DBKTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 06:19:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34627 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2DBKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 06:19:36 -0400
Message-ID: <1333361968.2802.1.camel@phoenix>
Subject: [PATCH RFT] regulator: Add support for tps62362 and tps62363 in
 tps62360-regulator driver
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 02 Apr 2012 18:19:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet[1], tps62360 is register compatible with tps62362.
tps62361B is register compatible with tps62363.
Thus this patch adds support for tps62362 and tps62363.

[1] http://www.ti.com/litv/pdf/slvsau9b

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/Kconfig              |    4 ++--
 drivers/regulator/tps62360-regulator.c |   30 ++++++++++++++++++++++--------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index ed37125..8fb5f81 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -268,11 +268,11 @@ config REGULATOR_TPS6105X
 	  audio amplifiers.
 
 config REGULATOR_TPS62360
-	tristate "TI TPS62360 Power Regulator"
+	tristate "TI TPS6236x Power Regulator"
 	depends on I2C
 	select REGMAP_I2C
 	help
-	  This driver supports TPS62360 voltage regulator chip. This
+	  This driver supports TPS6236x voltage regulator chip. This
 	  regulator is meant for processor core supply. This chip is
 	  high-frequency synchronous step down dc-dc converter optimized
 	  for battery-powered portable applications.
diff --git a/drivers/regulator/tps62360-regulator.c b/drivers/regulator/tps62360-regulator.c
index b18b7ca..aa57632 100644
--- a/drivers/regulator/tps62360-regulator.c
+++ b/drivers/regulator/tps62360-regulator.c
@@ -1,7 +1,7 @@
 /*
  * tps62360.c -- TI tps62360
  *
- * Driver for processor core supply tps62360 and tps62361B
+ * Driver for processor core supply tps62360, tps62361B, tps62362 and tps62363.
  *
  * Copyright (c) 2012, NVIDIA Corporation.
  *
@@ -46,7 +46,7 @@
 #define REG_RAMPCTRL		6
 #define REG_CHIPID		8
 
-enum chips {TPS62360, TPS62361};
+enum chips {TPS62360, TPS62361, TPS62362, TPS62363};
 
 #define TPS62360_BASE_VOLTAGE	770
 #define TPS62360_N_VOLTAGES	64
@@ -296,14 +296,26 @@ static int __devinit tps62360_probe(struct i2c_client *client,
 	tps->vsel0_gpio = pdata->vsel0_gpio;
 	tps->vsel1_gpio = pdata->vsel1_gpio;
 	tps->dev = &client->dev;
-	tps->voltage_base = (id->driver_data == TPS62360) ?
-				TPS62360_BASE_VOLTAGE : TPS62361_BASE_VOLTAGE;
-	tps->voltage_reg_mask = (id->driver_data == TPS62360) ? 0x3F : 0x7F;
+
+	switch (id->driver_data) {
+	case TPS62360:
+	case TPS62362:
+		tps->voltage_base = TPS62360_BASE_VOLTAGE;
+		tps->voltage_reg_mask = 0x3F;
+		tps->desc.n_voltages = TPS62360_N_VOLTAGES;
+		break;
+	case TPS62361:
+	case TPS62363:
+		tps->voltage_base = TPS62361_BASE_VOLTAGE;
+		tps->voltage_reg_mask = 0x7F;
+		tps->desc.n_voltages = TPS62361_N_VOLTAGES;
+		break;
+	default:
+		return -ENODEV;
+	}
 
 	tps->desc.name = id->name;
 	tps->desc.id = 0;
-	tps->desc.n_voltages = (id->driver_data == TPS62360) ?
-				TPS62360_N_VOLTAGES : TPS62361_N_VOLTAGES;
 	tps->desc.ops = &tps62360_dcdc_ops;
 	tps->desc.type = REGULATOR_VOLTAGE;
 	tps->desc.owner = THIS_MODULE;
@@ -435,6 +447,8 @@ static void tps62360_shutdown(struct i2c_client *client)
 static const struct i2c_device_id tps62360_id[] = {
 	{.name = "tps62360", .driver_data = TPS62360},
 	{.name = "tps62361", .driver_data = TPS62361},
+	{.name = "tps62362", .driver_data = TPS62362},
+	{.name = "tps62363", .driver_data = TPS62363},
 	{},
 };
 
@@ -464,5 +478,5 @@ static void __exit tps62360_cleanup(void)
 module_exit(tps62360_cleanup);
 
 MODULE_AUTHOR("Laxman Dewangan <ldewangan@nvidia.com>");
-MODULE_DESCRIPTION("TPS62360 voltage regulator driver");
+MODULE_DESCRIPTION("TPS6236x voltage regulator driver");
 MODULE_LICENSE("GPL v2");
-- 
1.7.5.4



