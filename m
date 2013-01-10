Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab3AJJqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:46:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55483 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab3AJJqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:46:22 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] lp8788-ldo: use ena_pin of regulator-core for external
 control
Thread-Topic: [PATCH 3/3] lp8788-ldo: use ena_pin of regulator-core for
 external control
Thread-Index: Ac3vF1TTOc01xfknSAmTOMQzw74IIg==
Date: Thu, 10 Jan 2013 09:46:15 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E122B2@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Regulator core driver provides enable GPIO control for enabling/disabling a
 regulator.
 Use this internal working, so unnecessary code are removed.
 GPIO enable pin configurations are added in digital LDO and analog LDO drivers.

Cc: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/lp8788-ldo.c |   98 +++++++---------------------------------
 1 file changed, 17 insertions(+), 81 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index cd5a14a..fcba90a 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -184,40 +184,6 @@ static enum lp8788_ldo_id lp8788_aldo_id[] = {
 	ALDO10,
 };
 
-static int lp8788_ldo_enable(struct regulator_dev *rdev)
-{
-	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
-
-	if (ldo->en_pin) {
-		gpio_set_value(ldo->en_pin->gpio, ENABLE);
-		return 0;
-	} else {
-		return regulator_enable_regmap(rdev);
-	}
-}
-
-static int lp8788_ldo_disable(struct regulator_dev *rdev)
-{
-	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
-
-	if (ldo->en_pin) {
-		gpio_set_value(ldo->en_pin->gpio, DISABLE);
-		return 0;
-	} else {
-		return regulator_disable_regmap(rdev);
-	}
-}
-
-static int lp8788_ldo_is_enabled(struct regulator_dev *rdev)
-{
-	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
-
-	if (ldo->en_pin)
-		return gpio_get_value(ldo->en_pin->gpio) ? 1 : 0;
-	else
-		return regulator_is_enabled_regmap(rdev);
-}
-
 static int lp8788_ldo_enable_time(struct regulator_dev *rdev)
 {
 	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
@@ -253,17 +219,17 @@ static struct regulator_ops lp8788_ldo_voltage_table_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.enable = lp8788_ldo_enable,
-	.disable = lp8788_ldo_disable,
-	.is_enabled = lp8788_ldo_is_enabled,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 	.enable_time = lp8788_ldo_enable_time,
 };
 
 static struct regulator_ops lp8788_ldo_voltage_fixed_ops = {
 	.get_voltage = lp8788_ldo_fixed_get_voltage,
-	.enable = lp8788_ldo_enable,
-	.disable = lp8788_ldo_disable,
-	.is_enabled = lp8788_ldo_is_enabled,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 	.enable_time = lp8788_ldo_enable_time,
 };
 
@@ -535,43 +501,10 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 	},
 };
 
-static int lp8788_gpio_request_ldo_en(struct platform_device *pdev,
-				struct lp8788_ldo *ldo,
-				enum lp8788_ext_ldo_en_id id)
-{
-	struct device *dev = &pdev->dev;
-	struct lp8788_ldo_enable_pin *pin = ldo->en_pin;
-	int ret, gpio, pinstate;
-	char *name[] = {
-		[EN_ALDO1]   = "LP8788_EN_ALDO1",
-		[EN_ALDO234] = "LP8788_EN_ALDO234",
-		[EN_ALDO5]   = "LP8788_EN_ALDO5",
-		[EN_ALDO7]   = "LP8788_EN_ALDO7",
-		[EN_DLDO7]   = "LP8788_EN_DLDO7",
-		[EN_DLDO911] = "LP8788_EN_DLDO911",
-	};
-
-	gpio = pin->gpio;
-	if (!gpio_is_valid(gpio)) {
-		dev_err(dev, "invalid gpio: %d\n", gpio);
-		return -EINVAL;
-	}
-
-	pinstate = pin->init_state;
-	ret = devm_gpio_request_one(dev, gpio, pinstate, name[id]);
-	if (ret == -EBUSY) {
-		dev_warn(dev, "gpio%d already used\n", gpio);
-		return 0;
-	}
-
-	return ret;
-}
-
 static int lp8788_config_ldo_enable_mode(struct platform_device *pdev,
 					struct lp8788_ldo *ldo,
 					enum lp8788_ldo_id id)
 {
-	int ret;
 	struct lp8788 *lp = ldo->lp;
 	struct lp8788_platform_data *pdata = lp->pdata;
 	enum lp8788_ext_ldo_en_id enable_id;
@@ -613,14 +546,7 @@ static int lp8788_config_ldo_enable_mode(struct platform_device *pdev,
 		goto set_default_ldo_enable_mode;
 
 	ldo->en_pin = pdata->ldo_pin[enable_id];
-
-	ret = lp8788_gpio_request_ldo_en(pdev, ldo, enable_id);
-	if (ret) {
-		ldo->en_pin = NULL;
-		goto set_default_ldo_enable_mode;
-	}
-
-	return ret;
+	return 0;
 
 set_default_ldo_enable_mode:
 	return lp8788_update_bits(lp, LP8788_EN_SEL, en_mask[enable_id], 0);
@@ -644,6 +570,11 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (ldo->en_pin) {
+		cfg.ena_gpio = ldo->en_pin->gpio;
+		cfg.ena_gpio_flags = ldo->en_pin->init_state;
+	}
+
 	cfg.dev = pdev->dev.parent;
 	cfg.init_data = lp->pdata ? lp->pdata->dldo_data[id] : NULL;
 	cfg.driver_data = ldo;
@@ -700,6 +631,11 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (ldo->en_pin) {
+		cfg.ena_gpio = ldo->en_pin->gpio;
+		cfg.ena_gpio_flags = ldo->en_pin->init_state;
+	}
+
 	cfg.dev = pdev->dev.parent;
 	cfg.init_data = lp->pdata ? lp->pdata->aldo_data[id] : NULL;
 	cfg.driver_data = ldo;
-- 
1.7.9.5


Best Regards,
Milo


