Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab0IDSUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 14:20:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54524 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0IDSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 14:20:34 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com, dtor@mail.ru,
        gregkh@suse.de,
        Michael Williamson <michael.williamson@criticallink.com>
Subject: [PATCH v1] tps65023: Allow platforms to specify DCDC_2 and DCDC_3 value.
Date: Sat,  4 Sep 2010 14:20:21 -0400
Message-Id: <1283624421-10326-1-git-send-email-michael.williamson@criticallink.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPS65023 regulator includes 5 regulators (3 DCDC and 2 LDO's).
2 of the DCDC regulators are of fixed voltage and can only be
turned on or off via the I2C interface.  The current driver defaults
the values of the fixed DCDC regulators.  However, the actual
voltage of these regulators may be set differently for a board (via
voltage divider circuit, etc.).

This patch allows a platform to pass in the actual voltage used
for these DCDC supplies such that they are reported correctly in
sysfs.

Signed-off-by: Michael Williamson <michael.williamson@criticallink.com>
---
Built against 2.6.36-rc3.

Changes since v1:
	1) Moved overrided parameters to tps_pmic structure 
	   in order to support multiple instances of driver.
	2) Altered check for valid range.
	3) Added some clarification comments.

 drivers/regulator/tps65023-regulator.c |   25 +++++++++++++++++++++----
 1 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index cd6d4fc..b2ac95c 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -72,6 +72,8 @@
 #define TPS65023_NUM_LDO		2
 /* Number of total regulators available */
 #define TPS65023_NUM_REGULATOR	(TPS65023_NUM_DCDC + TPS65023_NUM_LDO)
+/* Number of total regulators that are fixed in voltage */
+#define TPS65023_NUM_FIXED_REGULATOR	2
 
 /* DCDCs */
 #define TPS65023_DCDC_1			0
@@ -114,7 +116,6 @@ struct tps_info {
 	const char *name;
 	unsigned min_uV;
 	unsigned max_uV;
-	bool fixed;
 	u8 table_len;
 	const u16 *table;
 };
@@ -126,6 +127,7 @@ struct tps_pmic {
 	struct regulator_dev *rdev[TPS65023_NUM_REGULATOR];
 	const struct tps_info *info[TPS65023_NUM_REGULATOR];
 	struct mutex io_lock;
+	struct tps_info fixed[TPS65023_NUM_FIXED_REGULATOR];
 };
 
 static inline int tps_65023_read(struct tps_pmic *tps, u8 reg)
@@ -465,6 +467,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 	const struct tps_info *info = (void *)id->driver_data;
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
+	const struct regulation_constraints *c;
 	struct tps_pmic *tps;
 	int i;
 	int error;
@@ -501,6 +504,22 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
 
+		/*
+		 * DCDC 2 and DCDC 3 voltage (min and max range) is defined by
+		 * the DEFDCDC2 and DEFDCDC3 pins.  The setpoint cannot be
+		 * determined via the I2C interface. If the platform has
+		 * provided the appropriate value, override the default
+		 * values stored for the driver.
+		 */
+		c = &init_data->constraints;
+		if (((i == TPS65023_DCDC_2) || (i == TPS65023_DCDC_3))
+			&& c->min_uV && c->min_uV <= c->max_uV) {
+			tps->fixed[i-TPS65023_DCDC_2] = *tps->info[i];
+			tps->fixed[i-TPS65023_DCDC_2].max_uV = c->max_uV;
+			tps->fixed[i-TPS65023_DCDC_2].min_uV = c->min_uV;
+			tps->info[i] = &tps->fixed[i-TPS65023_DCDC_2];
+		}
+
 		/* Register the regulators */
 		rdev = regulator_register(&tps->desc[i], &client->dev,
 					  init_data, tps);
@@ -519,7 +538,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 	return 0;
 
- fail:
+fail:
 	while (--i >= 0)
 		regulator_unregister(tps->rdev[i]);
 
@@ -558,13 +577,11 @@ static const struct tps_info tps65023_regs[] = {
 		.name = "VDCDC2",
 		.min_uV =  3300000,
 		.max_uV = 3300000,
-		.fixed = 1,
 	},
 	{
 		.name = "VDCDC3",
 		.min_uV =  1800000,
 		.max_uV = 1800000,
-		.fixed = 1,
 	},
 	{
 		.name = "LDO1",
