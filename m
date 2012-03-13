Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab2CMGKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:10:48 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9135 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455Ab2CMGKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:10:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 12 Mar 2012 23:10:31 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, ldewangan@nvidia.com
Subject: [PATCH V1 2/2] regulator: tps65910: Provide settling time for DCDC voltage change
Date: Tue, 13 Mar 2012 11:35:21 +0530
Message-Id: <1331618721-26326-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com>
References: <1331618721-26326-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Settling time is require when there is dcdc rail's voltage change.
Returning proper delay time for dcdc voltage change to settle down
the output voltage to new value.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65910-regulator.c |   45 ++++++++++++++++++++++---------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 9084664..c99091d 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -561,10 +561,10 @@ static unsigned int tps65910_get_mode(struct regulator_dev *dev)
 		return REGULATOR_MODE_NORMAL;
 }
 
-static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
+static int tps65910_get_voltage_dcdc_sel(struct regulator_dev *dev)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
-	int id = rdev_get_id(dev), voltage = 0;
+	int id = rdev_get_id(dev);
 	int opvsel = 0, srvsel = 0, vselmax = 0, mult = 0, sr = 0;
 
 	switch (id) {
@@ -608,9 +608,7 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
 			srvsel = 3;
 		if (srvsel > vselmax)
 			srvsel = vselmax;
-		srvsel -= 3;
-
-		voltage = (srvsel * VDD1_2_OFFSET + VDD1_2_MIN_VOLT) * 100;
+		return srvsel - 3;
 	} else {
 
 		/* normalise to valid range*/
@@ -618,14 +616,9 @@ static int tps65910_get_voltage_dcdc(struct regulator_dev *dev)
 			opvsel = 3;
 		if (opvsel > vselmax)
 			opvsel = vselmax;
-		opvsel -= 3;
-
-		voltage = (opvsel * VDD1_2_OFFSET + VDD1_2_MIN_VOLT) * 100;
+		return opvsel - 3;
 	}
-
-	voltage *= mult;
-
-	return voltage;
+	return -EINVAL;
 }
 
 static int tps65910_get_voltage(struct regulator_dev *dev)
@@ -892,6 +885,31 @@ static int tps65911_list_voltage(struct regulator_dev *dev, unsigned selector)
 	return (LDO_MIN_VOLT + selector * step_mv) * 1000;
 }
 
+static int tps65910_set_voltage_dcdc_time_sel(struct regulator_dev *dev,
+		unsigned int old_selector, unsigned int new_selector)
+{
+	int id = rdev_get_id(dev);
+	int old_volt, new_volt;
+
+	old_volt = tps65910_list_voltage_dcdc(dev, old_selector);
+	if (old_volt < 0)
+		return old_volt;
+
+	new_volt = tps65910_list_voltage_dcdc(dev, new_selector);
+	if (new_volt < 0)
+		return new_volt;
+
+	/* VDD1 and VDD2 are 12.5mV/us, VDDCTRL is 100mV/20us */
+	switch (id) {
+	case TPS65910_REG_VDD1:
+	case TPS65910_REG_VDD2:
+		return DIV_ROUND_UP(abs(old_volt - new_volt), 12500);
+	case TPS65911_REG_VDDCTRL:
+		return DIV_ROUND_UP(abs(old_volt - new_volt), 5000);
+	}
+	return -EINVAL;
+}
+
 /* Regulator ops (except VRTC) */
 static struct regulator_ops tps65910_ops_dcdc = {
 	.is_enabled		= tps65910_is_enabled,
@@ -900,8 +918,9 @@ static struct regulator_ops tps65910_ops_dcdc = {
 	.enable_time		= tps65910_enable_time,
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
-	.get_voltage		= tps65910_get_voltage_dcdc,
+	.get_voltage_sel	= tps65910_get_voltage_dcdc_sel,
 	.set_voltage_sel	= tps65910_set_voltage_dcdc,
+	.set_voltage_time_sel	= tps65910_set_voltage_dcdc_time_sel,
 	.list_voltage		= tps65910_list_voltage_dcdc,
 };
 
-- 
1.7.1.1

