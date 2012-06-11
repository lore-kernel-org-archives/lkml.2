Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2FKCOj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 22:14:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38610 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2FKCOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 22:14:38 -0400
Message-ID: <1339380868.13491.1.camel@phoenix>
Subject: [PATCH RFT] regulator: ab3100: Convert fixed voltage to use
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 11 Jun 2012 10:14:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index b088b6c..16d420b 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -43,15 +43,12 @@
  * @dev: handle to the device
  * @plfdata: AB3100 platform data passed in at probe time
  * @regreg: regulator register number in the AB3100
- * @fixed_voltage: a fixed voltage for this regulator, if this
- *          0 the voltages array is used instead.
  */
 struct ab3100_regulator {
 	struct regulator_dev *rdev;
 	struct device *dev;
 	struct ab3100_platform_data *plfdata;
 	u8 regreg;
-	int fixed_voltage;
 };
 
 /* The order in which registers are initialized */
@@ -121,15 +118,12 @@ static struct ab3100_regulator
 ab3100_regulators[AB3100_NUM_REGULATORS] = {
 	{
 		.regreg = AB3100_LDO_A,
-		.fixed_voltage = LDO_A_VOLTAGE,
 	},
 	{
 		.regreg = AB3100_LDO_C,
-		.fixed_voltage = LDO_C_VOLTAGE,
 	},
 	{
 		.regreg = AB3100_LDO_D,
-		.fixed_voltage = LDO_D_VOLTAGE,
 	},
 	{
 		.regreg = AB3100_LDO_E,
@@ -246,10 +240,6 @@ static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 	u8 regval;
 	int err;
 
-	/* Return the voltage for fixed regulators immediately */
-	if (abreg->fixed_voltage)
-		return abreg->fixed_voltage;
-
 	/*
 	 * For variable types, read out setting and index into
 	 * supplied voltage list.
@@ -382,11 +372,17 @@ static int ab3100_enable_time_regulator(struct regulator_dev *reg)
 	return 0;
 }
 
+static int ab3100_get_fixed_voltage_regulator(struct regulator_dev *reg)
+{
+	return reg->desc->min_uV;
+}
+
 static struct regulator_ops regulator_ops_fixed = {
+	.list_voltage = regulator_list_voltage_linear,
 	.enable      = ab3100_enable_regulator,
 	.disable     = ab3100_disable_regulator,
 	.is_enabled  = ab3100_is_enabled_regulator,
-	.get_voltage = ab3100_get_voltage_regulator,
+	.get_voltage = ab3100_get_fixed_voltage_regulator,
 	.enable_time = ab3100_enable_time_regulator,
 };
 
@@ -430,22 +426,28 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.name = "LDO_A",
 		.id   = AB3100_LDO_A,
 		.ops  = &regulator_ops_fixed,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.min_uV = LDO_A_VOLTAGE,
 	},
 	{
 		.name = "LDO_C",
 		.id   = AB3100_LDO_C,
 		.ops  = &regulator_ops_fixed,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.min_uV = LDO_C_VOLTAGE,
 	},
 	{
 		.name = "LDO_D",
 		.id   = AB3100_LDO_D,
 		.ops  = &regulator_ops_fixed,
+		.n_voltages = 1,
 		.type = REGULATOR_VOLTAGE,
 		.owner = THIS_MODULE,
+		.min_uV = LDO_D_VOLTAGE,
 	},
 	{
 		.name = "LDO_E",
-- 
1.7.9.5



