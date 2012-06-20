Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2FTOcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:32:16 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35828 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2FTOcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:32:15 -0400
Message-ID: <1340202728.8003.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: tps6524x: Convert fixed ilimsel to table
 based
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cyril Chemparathy <cyril@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 20 Jun 2012 22:32:08 +0800
In-Reply-To: <1340202615.8003.1.camel@phoenix>
References: <1340202615.8003.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refactors the code to get rid of the fixed_ilimsel and FIXED_ILIMSEL
flag usage, and convert all the fixed ilimsel to table based (with one entry in
the table).

We can differentiate fixed ilimsel by checking info->n_ilimsels == 1,
thus FIXED_ILIMSEL flag can be removed.

This change makes the logic of the code simpler as all the ilimsels are table
based now.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/tps6524x-regulator.c |   44 +++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 48e37bd..947ece9 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -110,8 +110,6 @@
 #define N_SWITCH		2
 #define N_REGULATORS		(N_DCDC + N_LDO + N_SWITCH)
 
-#define FIXED_ILIMSEL		BIT(0)
-
 #define CMD_READ(reg)		((reg) << 6)
 #define CMD_WRITE(reg)		(BIT(5) | (reg) << 6)
 #define STAT_CLK		BIT(3)
@@ -130,9 +128,7 @@ struct supply_info {
 	int		n_voltages;
 	const unsigned int *voltages;
 	int		n_ilimsels;
-	const int	*ilimsels;
-	int		fixed_ilimsel;
-	int		flags;
+	const unsigned int *ilimsels;
 	struct field	enable, voltage, ilimsel;
 };
 
@@ -353,24 +349,36 @@ static const unsigned int fixed_5000000_voltage[] = {
 	5000000
 };
 
-static const int ldo_ilimsel[] = {
+static const unsigned int ldo_ilimsel[] = {
 	400000, 1500000
 };
 
-static const int usb_ilimsel[] = {
+static const unsigned int usb_ilimsel[] = {
 	200000, 400000, 800000, 1000000
 };
 
+static const unsigned int fixed_2400000_ilimsel[] = {
+	2400000
+};
+
+static const unsigned int fixed_1200000_ilimsel[] = {
+	1200000
+};
+
+static const unsigned int fixed_400000_ilimsel[] = {
+	400000
+};
+
 #define __MK_FIELD(_reg, _mask, _shift) \
 	{ .reg = (_reg), .mask = (_mask), .shift = (_shift), }
 
 static const struct supply_info supply_info[N_REGULATORS] = {
 	{
 		.name		= "DCDC1",
-		.flags		= FIXED_ILIMSEL,
 		.n_voltages	= ARRAY_SIZE(dcdc1_voltages),
 		.voltages	= dcdc1_voltages,
-		.fixed_ilimsel	= 2400000,
+		.n_ilimsels	= ARRAY_SIZE(fixed_2400000_ilimsel),
+		.ilimsels	= fixed_2400000_ilimsel,
 		.enable		= __MK_FIELD(REG_DCDC_EN, DCDCDCDC_EN_MASK,
 					     DCDCDCDC1_EN_SHIFT),
 		.voltage	= __MK_FIELD(REG_DCDC_SET, DCDC_VDCDC_MASK,
@@ -378,10 +386,10 @@ static const struct supply_info supply_info[N_REGULATORS] = {
 	},
 	{
 		.name		= "DCDC2",
-		.flags		= FIXED_ILIMSEL,
 		.n_voltages	= ARRAY_SIZE(dcdc2_voltages),
 		.voltages	= dcdc2_voltages,
-		.fixed_ilimsel	= 1200000,
+		.n_ilimsels	= ARRAY_SIZE(fixed_1200000_ilimsel),
+		.ilimsels	= fixed_1200000_ilimsel,
 		.enable		= __MK_FIELD(REG_DCDC_EN, DCDCDCDC_EN_MASK,
 					     DCDCDCDC2_EN_SHIFT),
 		.voltage	= __MK_FIELD(REG_DCDC_SET, DCDC_VDCDC_MASK,
@@ -389,10 +397,10 @@ static const struct supply_info supply_info[N_REGULATORS] = {
 	},
 	{
 		.name		= "DCDC3",
-		.flags		= FIXED_ILIMSEL,
 		.n_voltages	= ARRAY_SIZE(dcdc3_voltages),
 		.voltages	= dcdc3_voltages,
-		.fixed_ilimsel	= 1200000,
+		.n_ilimsels	= ARRAY_SIZE(fixed_1200000_ilimsel),
+		.ilimsels	= fixed_1200000_ilimsel,
 		.enable		= __MK_FIELD(REG_DCDC_EN, DCDCDCDC_EN_MASK,
 					DCDCDCDC3_EN_SHIFT),
 		.voltage	= __MK_FIELD(REG_DCDC_SET, DCDC_VDCDC_MASK,
@@ -439,8 +447,8 @@ static const struct supply_info supply_info[N_REGULATORS] = {
 		.name		= "LCD",
 		.n_voltages	= ARRAY_SIZE(fixed_5000000_voltage),
 		.voltages	= fixed_5000000_voltage,
-		.flags		= FIXED_ILIMSEL,
-		.fixed_ilimsel	=  400000,
+		.n_ilimsels	= ARRAY_SIZE(fixed_400000_ilimsel),
+		.ilimsels	= fixed_400000_ilimsel,
 		.enable		= __MK_FIELD(REG_BLOCK_EN, BLOCK_MASK,
 					     BLOCK_LCD_SHIFT),
 	},
@@ -491,7 +499,7 @@ static int set_current_limit(struct regulator_dev *rdev, int min_uA,
 	hw	= rdev_get_drvdata(rdev);
 	info	= &supply_info[rdev_get_id(rdev)];
 
-	if (info->flags & FIXED_ILIMSEL)
+	if (info->n_ilimsels == 1)
 		return -EINVAL;
 
 	for (i = 0; i < info->n_ilimsels; i++)
@@ -514,8 +522,8 @@ static int get_current_limit(struct regulator_dev *rdev)
 	hw	= rdev_get_drvdata(rdev);
 	info	= &supply_info[rdev_get_id(rdev)];
 
-	if (info->flags & FIXED_ILIMSEL)
-		return info->fixed_ilimsel;
+	if (info->n_ilimsels == 1)
+		return info->ilimsels[0];
 
 	ret = read_field(hw, &info->ilimsel);
 	if (ret < 0)
-- 
1.7.9.5



