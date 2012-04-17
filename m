Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab2DQJJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:09:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50121 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab2DQJJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:09:09 -0400
Message-ID: <1334653736.23427.7.camel@phoenix>
Subject: [PATCH RFT] regulator: tps65090: Use generic regmap enable/disable
 operations
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 17 Apr 2012 17:08:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts tps65090 regulator driver to use generic regmap
enable/disable operations.

Also move struct tps65090 to include/linux/mfd/tps65090.h because
the regulator driver needs to access the rmap field of struct tps65090.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps65090.c                 |   11 -----
 drivers/regulator/tps65090-regulator.c |   64 +++----------------------------
 include/linux/mfd/tps65090.h           |   13 ++++++
 3 files changed, 20 insertions(+), 68 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index a66d4df..47f802b 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -78,17 +78,6 @@ static struct mfd_cell tps65090s[] = {
 	},
 };
 
-struct tps65090 {
-	struct mutex		lock;
-	struct device		*dev;
-	struct i2c_client	*client;
-	struct regmap		*rmap;
-	struct irq_chip		irq_chip;
-	struct mutex		irq_lock;
-	int			irq_base;
-	unsigned int		id;
-};
-
 int tps65090_write(struct device *dev, int reg, uint8_t val)
 {
 	struct tps65090 *tps = dev_get_drvdata(dev);
diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 6bbf760..299237d 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -29,10 +29,6 @@
 
 struct tps65090_regulator {
 	int		id;
-	/* Regulator register address.*/
-	u8		reg_en_reg;
-	u8		en_bit;
-
 	/* used by regulator core */
 	struct regulator_desc	desc;
 
@@ -40,64 +36,14 @@ struct tps65090_regulator {
 	struct device		*dev;
 };
 
-static inline struct device *to_tps65090_dev(struct regulator_dev *rdev)
-{
-	return rdev_get_dev(rdev)->parent->parent;
-}
-
-static int tps65090_reg_is_enabled(struct regulator_dev *rdev)
-{
-	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps65090_dev(rdev);
-	uint8_t control;
-	int ret;
-
-	ret = tps65090_read(parent, ri->reg_en_reg, &control);
-	if (ret < 0) {
-		dev_err(&rdev->dev, "Error in reading reg 0x%x\n",
-			ri->reg_en_reg);
-		return ret;
-	}
-	return (((control >> ri->en_bit) & 1) == 1);
-}
-
-static int tps65090_reg_enable(struct regulator_dev *rdev)
-{
-	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps65090_dev(rdev);
-	int ret;
-
-	ret = tps65090_set_bits(parent, ri->reg_en_reg, ri->en_bit);
-	if (ret < 0)
-		dev_err(&rdev->dev, "Error in updating reg 0x%x\n",
-			ri->reg_en_reg);
-	return ret;
-}
-
-static int tps65090_reg_disable(struct regulator_dev *rdev)
-{
-	struct tps65090_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps65090_dev(rdev);
-	int ret;
-
-	ret = tps65090_clr_bits(parent, ri->reg_en_reg, ri->en_bit);
-	if (ret < 0)
-		dev_err(&rdev->dev, "Error in updating reg 0x%x\n",
-			ri->reg_en_reg);
-
-	return ret;
-}
-
 static struct regulator_ops tps65090_ops = {
-	.enable		= tps65090_reg_enable,
-	.disable	= tps65090_reg_disable,
-	.is_enabled	= tps65090_reg_is_enabled,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 };
 
 #define tps65090_REG(_id)				\
 {							\
-	.reg_en_reg	= (TPS65090_ID_##_id) + 12,	\
-	.en_bit		= 0,				\
 	.id		= TPS65090_ID_##_id,		\
 	.desc = {					\
 		.name = tps65090_rails(_id),		\
@@ -105,6 +51,8 @@ static struct regulator_ops tps65090_ops = {
 		.ops = &tps65090_ops,			\
 		.type = REGULATOR_VOLTAGE,		\
 		.owner = THIS_MODULE,			\
+		.enable_reg = (TPS65090_ID_##_id) + 12,	\
+		.enable_mask = BIT(0),			\
 	},						\
 }
 
@@ -136,6 +84,7 @@ static inline struct tps65090_regulator *find_regulator_info(int id)
 
 static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 {
+	struct tps65090 *tps65090_mfd = dev_get_drvdata(pdev->dev.parent);
 	struct tps65090_regulator *ri = NULL;
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
@@ -155,6 +104,7 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.init_data = &tps_pdata->regulator;
 	config.driver_data = ri;
+	config.regmap = tps65090_mfd->rmap;
 
 	rdev = regulator_register(&ri->desc, &config);
 	if (IS_ERR(rdev)) {
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 38e31c5..6bc31d8 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -22,6 +22,19 @@
 #ifndef __LINUX_MFD_TPS65090_H
 #define __LINUX_MFD_TPS65090_H
 
+#include <linux/irq.h>
+
+struct tps65090 {
+	struct mutex		lock;
+	struct device		*dev;
+	struct i2c_client	*client;
+	struct regmap		*rmap;
+	struct irq_chip		irq_chip;
+	struct mutex		irq_lock;
+	int			irq_base;
+	unsigned int		id;
+};
+
 struct tps65090_subdev_info {
 	int		id;
 	const char	*name;
-- 
1.7.5.4



