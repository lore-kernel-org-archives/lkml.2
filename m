Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1JRTAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:00:13 -0400
Received: from mail.fuel7.com ([74.222.0.51]:44535 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab1JRTAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:00:11 -0400
From: Kyle Manna <kyle.manna@fuel7.com>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@ti.com>
Cc: Kyle Manna <kyle.manna@fuel7.com>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH 5/6] mfd: TPS65910: Fix tps65910_set_voltage
Date: Tue, 18 Oct 2011 13:26:27 -0500
Message-Id: <1318962388-26151-6-git-send-email-kyle.manna@fuel7.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
References: <1318962388-26151-1-git-send-email-kyle.manna@fuel7.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously tps65910_set_voltage() only selected from a fixed number of
voltages.  Rename that function to tps65910_set_voltage_sel(). Do the
same for tps65911_set_voltage().

Also add a tps65910_set_voltage that works with the regulator framework
and applies the correct voltage with apply_uv is set in the regulator's
constraints.

This was tested on a TPS65910.

Signed-off-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/regulator/tps65910-regulator.c |   37 ++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 66d2d60..44ce2b0 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -693,7 +693,8 @@ static int tps65910_set_voltage_dcdc(struct regulator_dev *dev,
 	return 0;
 }
 
-static int tps65910_set_voltage(struct regulator_dev *dev, unsigned selector)
+static int tps65910_set_voltage_sel(struct regulator_dev *dev,
+				    unsigned selector)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, id = rdev_get_id(dev);
@@ -719,7 +720,35 @@ static int tps65910_set_voltage(struct regulator_dev *dev, unsigned selector)
 	return -EINVAL;
 }
 
-static int tps65911_set_voltage(struct regulator_dev *dev, unsigned selector)
+static int tps65910_set_voltage(struct regulator_dev *dev,
+		int min_uV, int max_uV, unsigned *selector)
+{
+	int id = rdev_get_id(dev);
+	int i;
+	int new_uV = 0, selected_uV = 0;
+	int midpoint = (max_uV + min_uV) >> 1;
+
+	/* Pick the nearest selector */
+	for (i = 0; i < tps65910_regs[id].table_len; i++) {
+		new_uV = tps65910_regs[id].table[i] * 1000;
+
+		if (new_uV >= min_uV && new_uV <= max_uV &&
+		   (abs(new_uV - midpoint) < abs(selected_uV - midpoint))) {
+			*selector = i;
+			selected_uV = tps65910_regs[id].table[i] * 1000;
+		}
+	}
+
+	/* If a match was found, set it */
+	if (selected_uV)
+		return tps65910_set_voltage_sel(dev, *selector);
+
+	return -EINVAL;
+}
+
+
+static int tps65911_set_voltage_sel(struct regulator_dev *dev,
+				    unsigned selector)
 {
 	struct tps65910_reg *pmic = rdev_get_drvdata(dev);
 	int reg, id = rdev_get_id(dev);
@@ -856,7 +885,7 @@ static struct regulator_ops tps65910_ops = {
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65910_get_voltage,
-	.set_voltage_sel	= tps65910_set_voltage,
+	.set_voltage		= tps65910_set_voltage,
 	.list_voltage		= tps65910_list_voltage,
 };
 
@@ -867,7 +896,7 @@ static struct regulator_ops tps65911_ops = {
 	.set_mode		= tps65910_set_mode,
 	.get_mode		= tps65910_get_mode,
 	.get_voltage		= tps65911_get_voltage,
-	.set_voltage_sel	= tps65911_set_voltage,
+	.set_voltage_sel	= tps65911_set_voltage_sel,
 	.list_voltage		= tps65911_list_voltage,
 };
 
-- 
1.7.5.4

