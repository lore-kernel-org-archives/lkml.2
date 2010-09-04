Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab0IDQCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 12:02:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54097 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab0IDQCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 12:02:50 -0400
From: Michael Williamson <michael.williamson@criticallink.com>
To: linux-kernel@vger.kernel.org
Cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com, dtor@mail.ru,
        khali@linux-fr.org, gregkh@suse.de,
        Michael Williamson <michael.williamson@criticallink.com>
Subject: [PATCH 1/3] tps65023: Allow platforms to specify DCDC_2 and DCDC_3 value.
Date: Sat,  4 Sep 2010 12:02:40 -0400
Message-Id: <1283616160-6215-1-git-send-email-michael.williamson@criticallink.com>
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
 drivers/regulator/tps65023-regulator.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index cd6d4fc..68cd7d3 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -124,7 +124,7 @@ struct tps_pmic {
 	struct regulator_desc desc[TPS65023_NUM_REGULATOR];
 	struct i2c_client *client;
 	struct regulator_dev *rdev[TPS65023_NUM_REGULATOR];
-	const struct tps_info *info[TPS65023_NUM_REGULATOR];
+	struct tps_info *info[TPS65023_NUM_REGULATOR];
 	struct mutex io_lock;
 };
 
@@ -462,9 +462,10 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 				     const struct i2c_device_id *id)
 {
 	static int desc_id;
-	const struct tps_info *info = (void *)id->driver_data;
+	struct tps_info *info = (void *)id->driver_data;
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
+	struct regulation_constraints *c;
 	struct tps_pmic *tps;
 	int i;
 	int error;
@@ -501,6 +502,14 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 		tps->desc[i].type = REGULATOR_VOLTAGE;
 		tps->desc[i].owner = THIS_MODULE;
 
+		/* Override default DCDC2/3 values if provided */
+		c = &init_data->constraints;
+		if ((i == TPS65023_DCDC_2) || (i == TPS65023_DCDC_3)
+			&& c->min_uV && c->min_uV == c->max_uV) {
+			info->min_uV = c->min_uV;
+			info->max_uV = c->max_uV;
+		}
+
 		/* Register the regulators */
 		rdev = regulator_register(&tps->desc[i], &client->dev,
 					  init_data, tps);
@@ -519,7 +528,7 @@ static int __devinit tps_65023_probe(struct i2c_client *client,
 
 	return 0;
 
- fail:
+fail:
 	while (--i >= 0)
 		regulator_unregister(tps->rdev[i]);
 
@@ -546,7 +555,7 @@ static int __devexit tps_65023_remove(struct i2c_client *client)
 	return 0;
 }
 
-static const struct tps_info tps65023_regs[] = {
+static struct tps_info tps65023_regs[] = {
 	{
 		.name = "VDCDC1",
 		.min_uV =  800000,
-- 
1.7.0.4

