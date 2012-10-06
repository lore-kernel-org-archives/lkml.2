Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2JFPva (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:51:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3285 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2JFPvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:51:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 06 Oct 2012 08:49:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>
CC: <vbyravarasu@nvidia.com>, <axel.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/5] regulator: tps65090: Add voltage out level in platform data
Date: Sat, 6 Oct 2012 20:47:50 +0530
Message-ID: <1349536671-31714-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65090's DCDCs and FETs act as switch and so output
voltage can be enable or disable only. The output voltage
of this regulators depends on the input voltage.
Add the voltage parameter to tell the output voltage value
of these rails.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65090-regulator.c       |   32 ++++++++++++++++++++++++-
 include/linux/regulator/tps65090-regulator.h |    2 +
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 254ee66..279154b 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -27,18 +27,44 @@
 #include <linux/regulator/tps65090-regulator.h>
 
 struct tps65090_regulator {
+	int			microvolts;
 	struct device		*dev;
 	struct regulator_desc	*desc;
 	struct regulator_dev	*rdev;
 };
 
+static int tps65090_voltage_get_voltage(struct regulator_dev *rdev)
+{
+	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
+
+	if (ri->microvolts)
+		return ri->microvolts;
+	else
+		return -EINVAL;
+}
+
+static int tps65090_voltage_list_voltage(struct regulator_dev *rdev,
+				      unsigned selector)
+{
+	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
+
+	if (selector != 0)
+		return -EINVAL;
+
+	return ri->microvolts;
+}
+
 static struct regulator_ops tps65090_ops = {
+	.get_voltage	= tps65090_voltage_get_voltage,
+	.list_voltage	= tps65090_voltage_list_voltage,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
 };
 
 static struct regulator_ops tps65090_ldo_ops = {
+	.get_voltage	= tps65090_voltage_get_voltage,
+	.list_voltage	= tps65090_voltage_list_voltage,
 };
 
 #define tps65090_REG_DESC(_id, _sname, _en_reg, _ops)	\
@@ -105,10 +131,12 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 		config.dev = &pdev->dev;
 		config.driver_data = ri;
 		config.regmap = tps65090_mfd->rmap;
-		if (tps_pdata)
+		if (tps_pdata) {
+			ri->microvolts = tps_pdata->microvolts;
 			config.init_data = tps_pdata->reg_init_data;
-		else
+		} else {
 			config.init_data = NULL;
+		}
 
 		rdev = regulator_register(ri->desc, &config);
 		if (IS_ERR(rdev)) {
diff --git a/include/linux/regulator/tps65090-regulator.h b/include/linux/regulator/tps65090-regulator.h
index 48e3db1..0b29ffa 100644
--- a/include/linux/regulator/tps65090-regulator.h
+++ b/include/linux/regulator/tps65090-regulator.h
@@ -45,10 +45,12 @@ enum {
  * struct tps65090_regulator_platform_data
  *
  * @reg_init_data: The regulator init data.
+ * @microvolts: The rail's voltage level.
  */
 
 struct tps65090_regulator_platform_data {
 	struct regulator_init_data *reg_init_data;
+	int microvolts;
 };
 
 #endif	/* __REGULATOR_TPS65090_H */
-- 
1.7.1.1

