Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab2JFPw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 11:52:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3268 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943Ab2JFPvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 11:51:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 06 Oct 2012 08:51:15 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <sameo@linux.intel.com>
CC: <vbyravarasu@nvidia.com>, <axel.lin@gmail.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/5] regulator; tps65090: Register all regulators in single probe call
Date: Sat, 6 Oct 2012 20:47:48 +0530
Message-ID: <1349536671-31714-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
References: <1349536671-31714-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD drier registers the regulator driver once per device and
hence it is require to register all regulators in single probe
call.
Following are details of changes done to achieve this:
- Add max regulator and register all regulators even if there
  is no regulator init data from platform.
- Convert regulator init data to pointer type in platform data.
- Add input supply name in regulator desc to provide input supply.
- Separate desc information from driver information.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/tps65090-regulator.c       |  137 ++++++++++++++------------
 include/linux/mfd/tps65090.h                 |    1 +
 include/linux/regulator/tps65090-regulator.h |    8 +-
 3 files changed, 82 insertions(+), 64 deletions(-)

diff --git a/drivers/regulator/tps65090-regulator.c b/drivers/regulator/tps65090-regulator.c
index 96d59ad..f825fc9 100644
--- a/drivers/regulator/tps65090-regulator.c
+++ b/drivers/regulator/tps65090-regulator.c
@@ -27,12 +27,9 @@
 #include <linux/regulator/tps65090-regulator.h>
 
 struct tps65090_regulator {
-	int		id;
-	/* used by regulator core */
-	struct regulator_desc	desc;
-
-	/* Device */
 	struct device		*dev;
+	struct regulator_desc	*desc;
+	struct regulator_dev	*rdev;
 };
 
 static struct regulator_ops tps65090_ops = {
@@ -41,46 +38,31 @@ static struct regulator_ops tps65090_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 };
 
-#define tps65090_REG(_id)				\
+#define tps65090_REG_DESC(_id, _sname, _en_reg, _ops)	\
 {							\
-	.id		= TPS65090_REGULATOR_##_id,		\
-	.desc = {					\
-		.name = tps65090_rails(_id),		\
-		.id = TPS65090_REGULATOR_##_id,		\
-		.ops = &tps65090_ops,			\
-		.type = REGULATOR_VOLTAGE,		\
-		.owner = THIS_MODULE,			\
-		.enable_reg = (TPS65090_REGULATOR_##_id) + 12,	\
-		.enable_mask = BIT(0),			\
-	},						\
+	.name = tps65090_rails(_id),		\
+	.supply_name = _sname,			\
+	.id = TPS65090_REGULATOR_##_id,		\
+	.ops = &_ops,				\
+	.enable_reg = _en_reg,			\
+	.enable_mask = BIT(0),			\
+	.type = REGULATOR_VOLTAGE,		\
+	.owner = THIS_MODULE,			\
 }
 
-static struct tps65090_regulator TPS65090_regulator[] = {
-	tps65090_REG(DCDC1),
-	tps65090_REG(DCDC2),
-	tps65090_REG(DCDC3),
-	tps65090_REG(FET1),
-	tps65090_REG(FET2),
-	tps65090_REG(FET3),
-	tps65090_REG(FET4),
-	tps65090_REG(FET5),
-	tps65090_REG(FET6),
-	tps65090_REG(FET7),
+static struct regulator_desc tps65090_regulator_desc[] = {
+	tps65090_REG_DESC(DCDC1, "vsys1",   0x0C, tps65090_ops),
+	tps65090_REG_DESC(DCDC2, "vsys2",   0x0D, tps65090_ops),
+	tps65090_REG_DESC(DCDC3, "vsys3",   0x0E, tps65090_ops),
+	tps65090_REG_DESC(FET1,  "infet1",  0x0F, tps65090_ops),
+	tps65090_REG_DESC(FET2,  "infet2",  0x10, tps65090_ops),
+	tps65090_REG_DESC(FET3,  "infet3",  0x11, tps65090_ops),
+	tps65090_REG_DESC(FET4,  "infet4",  0x12, tps65090_ops),
+	tps65090_REG_DESC(FET5,  "infet5",  0x13, tps65090_ops),
+	tps65090_REG_DESC(FET6,  "infet6",  0x14, tps65090_ops),
+	tps65090_REG_DESC(FET7,  "infet7",  0x15, tps65090_ops),
 };
 
-static inline struct tps65090_regulator *find_regulator_info(int id)
-{
-	struct tps65090_regulator *ri;
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(TPS65090_regulator); i++) {
-		ri = &TPS65090_regulator[i];
-		if (ri->desc.id == id)
-			return ri;
-	}
-	return NULL;
-}
-
 static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 {
 	struct tps65090 *tps65090_mfd = dev_get_drvdata(pdev->dev.parent);
@@ -88,39 +70,72 @@ static int __devinit tps65090_regulator_probe(struct platform_device *pdev)
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 	struct tps65090_regulator_platform_data *tps_pdata;
-	int id = pdev->id;
+	struct tps65090_regulator *pmic;
+	struct tps65090_platform_data *tps65090_pdata;
+	int num;
+	int ret;
 
-	dev_dbg(&pdev->dev, "Probing regulator %d\n", id);
+	dev_dbg(&pdev->dev, "Probing regulator\n");
 
-	ri = find_regulator_info(id);
-	if (ri == NULL) {
-		dev_err(&pdev->dev, "invalid regulator ID specified\n");
+	tps65090_pdata = dev_get_platdata(pdev->dev.parent);
+	if (!tps65090_pdata) {
+		dev_err(&pdev->dev, "Platform data missing\n");
 		return -EINVAL;
 	}
-	tps_pdata = pdev->dev.platform_data;
-	ri->dev = &pdev->dev;
-
-	config.dev = &pdev->dev;
-	config.init_data = &tps_pdata->regulator;
-	config.driver_data = ri;
-	config.regmap = tps65090_mfd->rmap;
-
-	rdev = regulator_register(&ri->desc, &config);
-	if (IS_ERR(rdev)) {
-		dev_err(&pdev->dev, "failed to register regulator %s\n",
-				ri->desc.name);
-		return PTR_ERR(rdev);
+
+	pmic = devm_kzalloc(&pdev->dev, TPS65090_REGULATOR_MAX * sizeof(*pmic),
+			GFP_KERNEL);
+	if (!pmic) {
+		dev_err(&pdev->dev, "mem alloc for pmic failed\n");
+		return -ENOMEM;
+	}
+
+	for (num = 0; num < TPS65090_REGULATOR_MAX; num++) {
+		tps_pdata = tps65090_pdata->reg_pdata[num];
+
+		ri = &pmic[num];
+		ri->dev = &pdev->dev;
+		ri->desc = &tps65090_regulator_desc[num];
+
+		config.dev = &pdev->dev;
+		config.driver_data = ri;
+		config.regmap = tps65090_mfd->rmap;
+		if (tps_pdata)
+			config.init_data = tps_pdata->reg_init_data;
+		else
+			config.init_data = NULL;
+
+		rdev = regulator_register(ri->desc, &config);
+		if (IS_ERR(rdev)) {
+			dev_err(&pdev->dev, "failed to register regulator %s\n",
+				ri->desc->name);
+			ret = PTR_ERR(rdev);
+			goto scrub;
+		}
+		ri->rdev = rdev;
 	}
 
-	platform_set_drvdata(pdev, rdev);
+	platform_set_drvdata(pdev, pmic);
 	return 0;
+
+scrub:
+	while (--num >= 0) {
+		ri = &pmic[num];
+		regulator_unregister(ri->rdev);
+	}
+	return ret;
 }
 
 static int __devexit tps65090_regulator_remove(struct platform_device *pdev)
 {
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
+	struct tps65090_regulator *pmic = platform_get_drvdata(pdev);
+	struct tps65090_regulator *ri;
+	int num;
 
-	regulator_unregister(rdev);
+	for (num = 0; num < TPS65090_REGULATOR_MAX; ++num) {
+		ri = &pmic[num];
+		regulator_unregister(ri->rdev);
+	}
 	return 0;
 }
 
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 6bc31d8..10f339f 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -45,6 +45,7 @@ struct tps65090_platform_data {
 	int irq_base;
 	int num_subdevs;
 	struct tps65090_subdev_info *subdevs;
+	struct tps65090_regulator_platform_data **reg_pdata;
 };
 
 /*
diff --git a/include/linux/regulator/tps65090-regulator.h b/include/linux/regulator/tps65090-regulator.h
index 5e27d4a..3572557 100644
--- a/include/linux/regulator/tps65090-regulator.h
+++ b/include/linux/regulator/tps65090-regulator.h
@@ -34,17 +34,19 @@ enum {
 	TPS65090_REGULATOR_FET5,
 	TPS65090_REGULATOR_FET6,
 	TPS65090_REGULATOR_FET7,
+
+	/* Last entry */
+	TPS65090_REGULATOR_MAX,
 };
 
 /*
  * struct tps65090_regulator_platform_data
  *
- * @regulator: The regulator init data.
- * @slew_rate_uV_per_us: Slew rate microvolt per microsec.
+ * @reg_init_data: The regulator init data.
  */
 
 struct tps65090_regulator_platform_data {
-	struct regulator_init_data regulator;
+	struct regulator_init_data *reg_init_data;
 };
 
 #endif	/* __REGULATOR_TPS65090_H */
-- 
1.7.1.1

