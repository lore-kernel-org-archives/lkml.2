Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab2ENCfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:35:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963Ab2ENCfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:35:46 -0400
Message-ID: <1336962940.24732.3.camel@phoenix>
Subject: [PATCH RFT 2/3] regulator: max8925: Convert to
 regulator_list_voltage_linear()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Mon, 14 May 2012 10:35:40 +0800
In-Reply-To: <1336962890.24732.2.camel@phoenix>
References: <1336962890.24732.2.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/max8925-regulator.c |   25 ++++++++-----------------
 1 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 529ee41..7dbae39 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -38,9 +38,7 @@ struct max8925_regulator_info {
 	struct i2c_client	*i2c;
 	struct max8925_chip	*chip;
 
-	int	min_uV;
 	int	max_uV;
-	int	step_uV;
 	int	vol_reg;
 	int	enable_reg;
 };
@@ -48,18 +46,12 @@ struct max8925_regulator_info {
 static inline int check_range(struct max8925_regulator_info *info,
 			      int min_uV, int max_uV)
 {
-	if (min_uV < info->min_uV || min_uV > info->max_uV)
+	if (min_uV < info->desc.min_uV || min_uV > info->max_uV)
 		return -EINVAL;
 
 	return 0;
 }
 
-static int max8925_list_voltage(struct regulator_dev *rdev, unsigned index)
-{
-	struct max8925_regulator_info *info = rdev_get_drvdata(rdev);
-	return info->min_uV + index * info->step_uV;
-}
-
 static int max8925_set_voltage(struct regulator_dev *rdev,
 			       int min_uV, int max_uV, unsigned int *selector)
 {
@@ -71,7 +63,7 @@ static int max8925_set_voltage(struct regulator_dev *rdev,
 			min_uV, max_uV);
 		return -EINVAL;
 	}
-	data = DIV_ROUND_UP(min_uV - info->min_uV, info->step_uV);
+	data = DIV_ROUND_UP(min_uV - info->desc.min_uV, info->desc.uV_step);
 	*selector = data;
 	mask = rdev->desc->n_voltages - 1;
 
@@ -160,7 +152,7 @@ static int max8925_set_dvm_disable(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops max8925_regulator_sdv_ops = {
-	.list_voltage		= max8925_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage		= max8925_set_voltage,
 	.get_voltage_sel	= max8925_get_voltage_sel,
 	.enable			= max8925_enable,
@@ -172,7 +164,7 @@ static struct regulator_ops max8925_regulator_sdv_ops = {
 };
 
 static struct regulator_ops max8925_regulator_ldo_ops = {
-	.list_voltage		= max8925_list_voltage,
+	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage		= max8925_set_voltage,
 	.get_voltage_sel	= max8925_get_voltage_sel,
 	.enable			= max8925_enable,
@@ -189,10 +181,10 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 		.id	= MAX8925_ID_SD##_id,			\
 		.owner	= THIS_MODULE,				\
 		.n_voltages = 64,				\
+		.min_uV = min * 1000,				\
+		.uV_step = step * 1000,				\
 	},							\
-	.min_uV		= min * 1000,				\
 	.max_uV		= max * 1000,				\
-	.step_uV	= step * 1000,				\
 	.vol_reg	= MAX8925_SDV##_id,			\
 	.enable_reg	= MAX8925_SDCTL##_id,			\
 }
@@ -206,10 +198,10 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
 		.id	= MAX8925_ID_LDO##_id,			\
 		.owner	= THIS_MODULE,				\
 		.n_voltages = 64,				\
+		.min_uV = min * 1000,				\
+		.uV_step = step * 1000,				\
 	},							\
-	.min_uV		= min * 1000,				\
 	.max_uV		= max * 1000,				\
-	.step_uV	= step * 1000,				\
 	.vol_reg	= MAX8925_LDOVOUT##_id,			\
 	.enable_reg	= MAX8925_LDOCTL##_id,			\
 }
@@ -320,4 +312,3 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
 MODULE_DESCRIPTION("Regulator Driver for Maxim 8925 PMIC");
 MODULE_ALIAS("platform:max8925-regulator");
-
-- 
1.7.5.4



