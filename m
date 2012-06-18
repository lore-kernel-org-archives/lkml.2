Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2FRGZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 02:25:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62356 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2FRGZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:25:33 -0400
Message-ID: <1340000727.18659.7.camel@phoenix>
Subject: [PATCH RFT] regulator: s5m8767: Convert ot
 regulator_list_voltage_linear
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 18 Jun 2012 14:25:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, .list_voltage and .set_voltage_sel callbacks for BUCK7 and
BUCK8 return -EINVAL.

This patch adds s5m8767_buck78_ops for BUCK7 and BUCK8 which does not set
.list_voltage, .get_voltage_sel and .set_voltage_sel. ( This has the same
effect of returning -EINVAL in the callbacks)

Then for all the users of s5m8767_list_voltage, we don't need to worry about
the case reg_voltage_map[reg_id] is NULL.
So we can convert s5m8767_list_voltage to regulator_list_voltage_linear.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s5m8767.c |   46 ++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index fafc9a4..d484108 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -120,27 +120,6 @@ static const struct s5m_voltage_desc *reg_voltage_map[] = {
 	[S5M8767_BUCK9] = &buck_voltage_val3,
 };
 
-static int s5m8767_list_voltage(struct regulator_dev *rdev,
-				unsigned int selector)
-{
-	const struct s5m_voltage_desc *desc;
-	int reg_id = rdev_get_id(rdev);
-	int val;
-
-	if (reg_id >= ARRAY_SIZE(reg_voltage_map) || reg_id < 0)
-		return -EINVAL;
-
-	desc = reg_voltage_map[reg_id];
-	if (desc == NULL)
-		return -EINVAL;
-
-	val = desc->min + desc->step * selector;
-	if (val > desc->max)
-		return -EINVAL;
-
-	return val;
-}
-
 static unsigned int s5m8767_opmode_reg[][4] = {
 	/* {OFF, ON, LOWPOWER, SUSPEND} */
 	/* LDO1 ... LDO28 */
@@ -448,7 +427,7 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops s5m8767_ops = {
-	.list_voltage		= s5m8767_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.is_enabled		= s5m8767_reg_is_enabled,
 	.enable			= s5m8767_reg_enable,
 	.disable		= s5m8767_reg_disable,
@@ -457,6 +436,12 @@ static struct regulator_ops s5m8767_ops = {
 	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
 };
 
+static struct regulator_ops s5m8767_buck78_ops = {
+	.is_enabled		= s5m8767_reg_is_enabled,
+	.enable			= s5m8767_reg_enable,
+	.disable		= s5m8767_reg_disable,
+};
+
 #define s5m8767_regulator_desc(_name) {		\
 	.name		= #_name,		\
 	.id		= S5M8767_##_name,	\
@@ -465,6 +450,14 @@ static struct regulator_ops s5m8767_ops = {
 	.owner		= THIS_MODULE,		\
 }
 
+#define s5m8767_regulator_buck78_desc(_name) {	\
+	.name		= #_name,		\
+	.id		= S5M8767_##_name,	\
+	.ops		= &s5m8767_buck78_ops,	\
+	.type		= REGULATOR_VOLTAGE,	\
+	.owner		= THIS_MODULE,		\
+}
+
 static struct regulator_desc regulators[] = {
 	s5m8767_regulator_desc(LDO1),
 	s5m8767_regulator_desc(LDO2),
@@ -500,8 +493,8 @@ static struct regulator_desc regulators[] = {
 	s5m8767_regulator_desc(BUCK4),
 	s5m8767_regulator_desc(BUCK5),
 	s5m8767_regulator_desc(BUCK6),
-	s5m8767_regulator_desc(BUCK7),
-	s5m8767_regulator_desc(BUCK8),
+	s5m8767_regulator_buck78_desc(BUCK7),
+	s5m8767_regulator_buck78_desc(BUCK8),
 	s5m8767_regulator_desc(BUCK9),
 };
 
@@ -698,9 +691,12 @@ static __devinit int s5m8767_pmic_probe(struct platform_device *pdev)
 		int id = pdata->regulators[i].id;
 
 		desc = reg_voltage_map[id];
-		if (desc)
+		if (desc) {
 			regulators[id].n_voltages =
 				(desc->max - desc->min) / desc->step + 1;
+			regulators[id].min_uV = desc->min;
+			regulators[id].uV_step = desc->step;
+		}
 
 		config.dev = s5m8767->dev;
 		config.init_data = pdata->regulators[i].initdata;
-- 
1.7.9.5



