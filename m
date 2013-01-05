Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab3AEHd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 02:33:58 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58945 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3AEHd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 02:33:56 -0500
Message-ID: <1357371223.22227.1.camel@phoenix>
Subject: [PATCH RFT] regulator: lp8788-ldo: Use ldo->en_pin to check if
 regulator is enabled by external pin
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sat, 05 Jan 2013 15:33:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ldo->en_pin is set iff the regulator is enabled by external pin.

This patch sets ldo->en_pin to NULL if lp8788_gpio_request_ldo_en() fails, then
we can use it to determinate if the regulator is controlled by external pin or
register.

lp8788_get_ldo_enable_mode(), lp8788_ldo_ctrl_by_extern_pin() and
lp8788_ldo_is_enabled_by_extern_pin() functions are not used now, remove them.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8788-ldo.c |  107 ++++++----------------------------------
 1 file changed, 14 insertions(+), 93 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 416bb60..cd5a14a 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -88,11 +88,6 @@
 #define ENABLE				GPIOF_OUT_INIT_HIGH
 #define DISABLE				GPIOF_OUT_INIT_LOW
 
-enum lp8788_enable_mode {
-	REGISTER,
-	EXTPIN,
-};
-
 enum lp8788_ldo_id {
 	DLDO1,
 	DLDO2,
@@ -189,114 +184,38 @@ static enum lp8788_ldo_id lp8788_aldo_id[] = {
 	ALDO10,
 };
 
-/* DLDO 7, 9 and 11, ALDO 1 ~ 5 and 7
-   : can be enabled either by external pin or by i2c register */
-static enum lp8788_enable_mode
-lp8788_get_ldo_enable_mode(struct lp8788_ldo *ldo, enum lp8788_ldo_id id)
-{
-	int ret;
-	u8 val, mask;
-
-	ret = lp8788_read_byte(ldo->lp, LP8788_EN_SEL, &val);
-	if (ret)
-		return ret;
-
-	switch (id) {
-	case DLDO7:
-		mask =  LP8788_EN_SEL_DLDO7_M;
-		break;
-	case DLDO9:
-	case DLDO11:
-		mask =  LP8788_EN_SEL_DLDO911_M;
-		break;
-	case ALDO1:
-		mask =  LP8788_EN_SEL_ALDO1_M;
-		break;
-	case ALDO2 ... ALDO4:
-		mask =  LP8788_EN_SEL_ALDO234_M;
-		break;
-	case ALDO5:
-		mask =  LP8788_EN_SEL_ALDO5_M;
-		break;
-	case ALDO7:
-		mask =  LP8788_EN_SEL_ALDO7_M;
-		break;
-	default:
-		return REGISTER;
-	}
-
-	return val & mask ? EXTPIN : REGISTER;
-}
-
-static int lp8788_ldo_ctrl_by_extern_pin(struct lp8788_ldo *ldo, int pinstate)
-{
-	struct lp8788_ldo_enable_pin *pin = ldo->en_pin;
-
-	if (!pin)
-		return -EINVAL;
-
-	if (gpio_is_valid(pin->gpio))
-		gpio_set_value(pin->gpio, pinstate);
-
-	return 0;
-}
-
-static int lp8788_ldo_is_enabled_by_extern_pin(struct lp8788_ldo *ldo)
-{
-	struct lp8788_ldo_enable_pin *pin = ldo->en_pin;
-
-	if (!pin)
-		return -EINVAL;
-
-	return gpio_get_value(pin->gpio) ? 1 : 0;
-}
-
 static int lp8788_ldo_enable(struct regulator_dev *rdev)
 {
 	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
-	enum lp8788_ldo_id id = rdev_get_id(rdev);
-	enum lp8788_enable_mode mode = lp8788_get_ldo_enable_mode(ldo, id);
 
-	switch (mode) {
-	case EXTPIN:
-		return lp8788_ldo_ctrl_by_extern_pin(ldo, ENABLE);
-	case REGISTER:
+	if (ldo->en_pin) {
+		gpio_set_value(ldo->en_pin->gpio, ENABLE);
+		return 0;
+	} else {
 		return regulator_enable_regmap(rdev);
-	default:
-		return -EINVAL;
 	}
 }
 
 static int lp8788_ldo_disable(struct regulator_dev *rdev)
 {
 	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
-	enum lp8788_ldo_id id = rdev_get_id(rdev);
-	enum lp8788_enable_mode mode = lp8788_get_ldo_enable_mode(ldo, id);
 
-	switch (mode) {
-	case EXTPIN:
-		return lp8788_ldo_ctrl_by_extern_pin(ldo, DISABLE);
-	case REGISTER:
+	if (ldo->en_pin) {
+		gpio_set_value(ldo->en_pin->gpio, DISABLE);
+		return 0;
+	} else {
 		return regulator_disable_regmap(rdev);
-	default:
-		return -EINVAL;
 	}
 }
 
 static int lp8788_ldo_is_enabled(struct regulator_dev *rdev)
 {
 	struct lp8788_ldo *ldo = rdev_get_drvdata(rdev);
-	enum lp8788_ldo_id id = rdev_get_id(rdev);
-	enum lp8788_enable_mode mode = lp8788_get_ldo_enable_mode(ldo, id);
 
-	switch (mode) {
-	case EXTPIN:
-		return lp8788_ldo_is_enabled_by_extern_pin(ldo);
-	case REGISTER:
+	if (ldo->en_pin)
+		return gpio_get_value(ldo->en_pin->gpio) ? 1 : 0;
+	else
 		return regulator_is_enabled_regmap(rdev);
-	default:
-		return -EINVAL;
-	}
 }
 
 static int lp8788_ldo_enable_time(struct regulator_dev *rdev)
@@ -696,8 +615,10 @@ static int lp8788_config_ldo_enable_mode(struct platform_device *pdev,
 	ldo->en_pin = pdata->ldo_pin[enable_id];
 
 	ret = lp8788_gpio_request_ldo_en(pdev, ldo, enable_id);
-	if (ret)
+	if (ret) {
+		ldo->en_pin = NULL;
 		goto set_default_ldo_enable_mode;
+	}
 
 	return ret;
 
-- 
1.7.9.5



