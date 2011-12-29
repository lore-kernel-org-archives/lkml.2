Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1L2JSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 04:18:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38369 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1L2JR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 04:17:59 -0500
Message-ID: <1325150268.13424.1.camel@phoenix>
Subject: [PATCH] mfd: Fix section mismatch warning for da9052
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 29 Dec 2011 17:17:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes da9052_subdev_info to __devinitdata and marks __devinit
for probe functions to fix below build warning.
For completeness, also marks __devexit for remove functions.

  LD      drivers/mfd/built-in.o
WARNING: drivers/mfd/built-in.o(.text+0x104fc): Section mismatch in reference from the function da9052_device_init() to the (unknown reference) .init.data:(unknown)
The function da9052_device_init() references
the (unknown reference) __initdata (unknown).
This is often because da9052_device_init lacks a __initdata
annotation or the annotation of (unknown) is wrong.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/da9052-core.c |    4 ++--
 drivers/mfd/da9052-i2c.c  |    4 ++--
 drivers/mfd/da9052-spi.c  |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/da9052-core.c b/drivers/mfd/da9052-core.c
index a7c115c..2a5e271 100644
--- a/drivers/mfd/da9052-core.c
+++ b/drivers/mfd/da9052-core.c
@@ -383,7 +383,7 @@ static struct resource da9052_tsi_resources[] = {
 	},
 };
 
-static struct mfd_cell __initdata da9052_subdev_info[] = {
+static struct mfd_cell __devinitdata da9052_subdev_info[] = {
 	{
 		.name = "da9052-regulator",
 		.id = 1,
@@ -637,7 +637,7 @@ struct regmap_config da9052_regmap_config = {
 };
 EXPORT_SYMBOL_GPL(da9052_regmap_config);
 
-int da9052_device_init(struct da9052 *da9052, u8 chip_id)
+int __devinit da9052_device_init(struct da9052 *da9052, u8 chip_id)
 {
 	struct da9052_pdata *pdata = da9052->dev->platform_data;
 	struct irq_desc *desc;
diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 44b97c7..f99685a 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -87,7 +87,7 @@ err:
 	return ret;
 }
 
-static int da9052_i2c_remove(struct i2c_client *client)
+static int __devexit da9052_i2c_remove(struct i2c_client *client)
 {
 	struct da9052 *da9052 = i2c_get_clientdata(client);
 
@@ -107,7 +107,7 @@ static struct i2c_device_id da9052_i2c_id[] = {
 
 static struct i2c_driver da9052_i2c_driver = {
 	.probe = da9052_i2c_probe,
-	.remove = da9052_i2c_remove,
+	.remove = __devexit_p(da9052_i2c_remove),
 	.id_table = da9052_i2c_id,
 	.driver = {
 		.name = "da9052",
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index cdbc7ca..2693c87 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -21,7 +21,7 @@
 
 #include <linux/mfd/da9052/da9052.h>
 
-static int da9052_spi_probe(struct spi_device *spi)
+static int __devinit da9052_spi_probe(struct spi_device *spi)
 {
 	int ret;
 	const struct spi_device_id *id = spi_get_device_id(spi);
@@ -61,7 +61,7 @@ err:
 	return ret;
 }
 
-static int da9052_spi_remove(struct spi_device *spi)
+static int __devexit da9052_spi_remove(struct spi_device *spi)
 {
 	struct da9052 *da9052 = dev_get_drvdata(&spi->dev);
 
-- 
1.7.5.4



