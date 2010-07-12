Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0GLKfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 06:35:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38948 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab0GLKfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 06:35:03 -0400
From: Sekhar Nori <nsekhar@ti.com>
To: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
        Anuj Aggarwal <anuj.aggarwal@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: tps6507x: allow driver to use DEFDCDC{2,3}_HIGH register
Date: Mon, 12 Jul 2010 16:04:46 +0530
Message-Id: <1278930888-26810-1-git-send-email-nsekhar@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anuj Aggarwal <anuj.aggarwal@ti.com>

In TPS6507x, depending on the status of DEFDCDC{2,3} pin either
DEFDCDC{2,3}_LOW or DEFDCDC{2,3}_HIGH register needs to be read or
programmed to change the output voltage.

The current driver assumes DEFDCDC{2,3} pins are always tied low
and thus operates only on DEFDCDC{2,3}_LOW register. This need
not always be the case (as is found on OMAP-L138 EVM).

Unfortunately, software cannot read the status of DEFDCDC{2,3} pins.
So, this information is passed through platform data depending on
how the board is wired.

Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 drivers/regulator/tps6507x-regulator.c |   36 +++++++++++++++++++++++++------
 include/linux/regulator/tps6507x.h     |   32 ++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/regulator/tps6507x.h

diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
index 14b4576..fc1c33c 100644
--- a/drivers/regulator/tps6507x-regulator.c
+++ b/drivers/regulator/tps6507x-regulator.c
@@ -22,6 +22,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
+#include <linux/regulator/tps6507x.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/mfd/tps6507x.h>
@@ -101,9 +102,12 @@ struct tps_info {
 	unsigned max_uV;
 	u8 table_len;
 	const u16 *table;
+
+	/* Does DCDC high or the low register defines output voltage? */
+	bool defdcdc_high;
 };
 
-static const struct tps_info tps6507x_pmic_regs[] = {
+static struct tps_info tps6507x_pmic_regs[] = {
 	{
 		.name = "VDCDC1",
 		.min_uV = 725000,
@@ -145,7 +149,7 @@ struct tps6507x_pmic {
 	struct regulator_desc desc[TPS6507X_NUM_REGULATOR];
 	struct tps6507x_dev *mfd;
 	struct regulator_dev *rdev[TPS6507X_NUM_REGULATOR];
-	const struct tps_info *info[TPS6507X_NUM_REGULATOR];
+	struct tps_info *info[TPS6507X_NUM_REGULATOR];
 	struct mutex io_lock;
 };
 static inline int tps6507x_pmic_read(struct tps6507x_pmic *tps, u8 reg)
@@ -341,10 +345,16 @@ static int tps6507x_pmic_dcdc_get_voltage(struct regulator_dev *dev)
 		reg = TPS6507X_REG_DEFDCDC1;
 		break;
 	case TPS6507X_DCDC_2:
-		reg = TPS6507X_REG_DEFDCDC2_LOW;
+		if (tps->info[dcdc]->defdcdc_high)
+			reg = TPS6507X_REG_DEFDCDC2_HIGH;
+		else
+			reg = TPS6507X_REG_DEFDCDC2_LOW;
 		break;
 	case TPS6507X_DCDC_3:
-		reg = TPS6507X_REG_DEFDCDC3_LOW;
+		if (tps->info[dcdc]->defdcdc_high)
+			reg = TPS6507X_REG_DEFDCDC3_HIGH;
+		else
+			reg = TPS6507X_REG_DEFDCDC3_LOW;
 		break;
 	default:
 		return -EINVAL;
@@ -370,10 +380,16 @@ static int tps6507x_pmic_dcdc_set_voltage(struct regulator_dev *dev,
 		reg = TPS6507X_REG_DEFDCDC1;
 		break;
 	case TPS6507X_DCDC_2:
-		reg = TPS6507X_REG_DEFDCDC2_LOW;
+		if (tps->info[dcdc]->defdcdc_high)
+			reg = TPS6507X_REG_DEFDCDC2_HIGH;
+		else
+			reg = TPS6507X_REG_DEFDCDC2_LOW;
 		break;
 	case TPS6507X_DCDC_3:
-		reg = TPS6507X_REG_DEFDCDC3_LOW;
+		if (tps->info[dcdc]->defdcdc_high)
+			reg = TPS6507X_REG_DEFDCDC3_HIGH;
+		else
+			reg = TPS6507X_REG_DEFDCDC3_LOW;
 		break;
 	default:
 		return -EINVAL;
@@ -532,7 +548,7 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 {
 	struct tps6507x_dev *tps6507x_dev = dev_get_drvdata(pdev->dev.parent);
 	static int desc_id;
-	const struct tps_info *info = &tps6507x_pmic_regs[0];
+	struct tps_info *info = &tps6507x_pmic_regs[0];
 	struct regulator_init_data *init_data;
 	struct regulator_dev *rdev;
 	struct tps6507x_pmic *tps;
@@ -569,6 +585,12 @@ int tps6507x_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < TPS6507X_NUM_REGULATOR; i++, info++, init_data++) {
 		/* Register the regulators */
 		tps->info[i] = info;
+		if (init_data->driver_data) {
+			struct tps6507x_reg_platform_data *data =
+							init_data->driver_data;
+			tps->info[i]->defdcdc_high = data->defdcdc_high;
+		}
+
 		tps->desc[i].name = info->name;
 		tps->desc[i].id = desc_id++;
 		tps->desc[i].n_voltages = num_voltages[i];
diff --git a/include/linux/regulator/tps6507x.h b/include/linux/regulator/tps6507x.h
new file mode 100644
index 0000000..33d91cd
--- /dev/null
+++ b/include/linux/regulator/tps6507x.h
@@ -0,0 +1,32 @@
+/*
+ * tps6507x.h  --  Voltage regulation for the Texas Instruments TPS6507X
+ *
+ * Copyright (C) 2010 Texas Instruments, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#ifndef REGULATOR_TPS6507X
+#define REGULATOR_TPS6507X
+
+/**
+ * tps6507x_reg_platform_data - platform data for tps6507x
+ * @defdcdc_high: Defines whether DCDC high or the low register controls
+ *	output voltage. Valid for DCDC2 and DCDC3 outputs only.
+ */
+struct tps6507x_reg_platform_data {
+	bool defdcdc_high;
+};
+
+#endif
-- 
1.6.2.4

