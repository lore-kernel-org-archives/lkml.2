Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab2DJGFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 02:05:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41969 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2DJGFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 02:05:50 -0400
Message-ID: <1334037944.15859.8.camel@phoenix>
Subject: [PATCH RESEND 1/3] regulator: Rework s5m8767_set_voltage to support
 both LDOs and BUCKs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 10 Apr 2012 14:05:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s5m8767_set_voltage not only implement set_voltage callbacks for LDOs,
but also for BUCKs when s5m8767->buck_gpioindex is not set.
s5m8767_set_voltage_buck actually only for buck[2|3|4] when
s5m8767->buck_gpioindex is set.
Conditionally calling s5m8767_set_voltage in s5m8767_set_voltage_buck makes
the code hard to read.

I think merging s5m8767_set_voltage_buck and s5m8767_set_voltage actually
simplifies things. It's easy to use buck234_vol pointer to differentiate if
we need to control voltage for buck[2|3|4] by DVS GPIOs.

This patch reworks s5m8767_set_voltage to support both LDOx and BUCKx in all
cases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/s5m8767.c |  145 +++++++++++++++----------------------------
 1 files changed, 50 insertions(+), 95 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 4ca2db0..7576134 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -305,14 +305,33 @@ static int s5m8767_convert_voltage_to_sel(
 	return selector;
 }
 
+static inline void s5m8767_set_high(struct s5m8767_info *s5m8767)
+{
+	int temp_index = s5m8767->buck_gpioindex;
+
+	gpio_set_value(s5m8767->buck_gpios[0], (temp_index >> 2) & 0x1);
+	gpio_set_value(s5m8767->buck_gpios[1], (temp_index >> 1) & 0x1);
+	gpio_set_value(s5m8767->buck_gpios[2], temp_index & 0x1);
+}
+
+static inline void s5m8767_set_low(struct s5m8767_info *s5m8767)
+{
+	int temp_index = s5m8767->buck_gpioindex;
+
+	gpio_set_value(s5m8767->buck_gpios[2], temp_index & 0x1);
+	gpio_set_value(s5m8767->buck_gpios[1], (temp_index >> 1) & 0x1);
+	gpio_set_value(s5m8767->buck_gpios[0], (temp_index >> 2) & 0x1);
+}
+
 static int s5m8767_set_voltage(struct regulator_dev *rdev,
 				int min_uV, int max_uV, unsigned *selector)
 {
 	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 	const struct s5m_voltage_desc *desc;
 	int reg_id = rdev_get_id(rdev);
-	int sel, reg, mask, ret;
+	int sel, reg, mask, ret = 0, old_index, index = 0;
 	u8 val;
+	u8 *buck234_vol = NULL;
 
 	switch (reg_id) {
 	case S5M8767_LDO1 ... S5M8767_LDO28:
@@ -320,6 +339,12 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 		break;
 	case S5M8767_BUCK1 ... S5M8767_BUCK6:
 		mask = 0xff;
+		if (reg_id == S5M8767_BUCK2 && s5m8767->buck2_gpiodvs)
+			buck234_vol = &s5m8767->buck2_vol[0];
+		else if (reg_id == S5M8767_BUCK3 && s5m8767->buck3_gpiodvs)
+			buck234_vol = &s5m8767->buck3_vol[0];
+		else if (reg_id == S5M8767_BUCK4 && s5m8767->buck4_gpiodvs)
+			buck234_vol = &s5m8767->buck4_vol[0];
 		break;
 	case S5M8767_BUCK7 ... S5M8767_BUCK8:
 		return -EINVAL;
@@ -336,102 +361,32 @@ static int s5m8767_set_voltage(struct regulator_dev *rdev,
 	if (sel < 0)
 		return sel;
 
-	ret = s5m8767_get_voltage_register(rdev, &reg);
-	if (ret)
-		return ret;
-
-	s5m_reg_read(s5m8767->iodev, reg, &val);
-	val &= ~mask;
-	val |= sel;
-
-	ret = s5m_reg_write(s5m8767->iodev, reg, val);
-	*selector = sel;
-
-	return ret;
-}
-
-static inline void s5m8767_set_high(struct s5m8767_info *s5m8767)
-{
-	int temp_index = s5m8767->buck_gpioindex;
-
-	gpio_set_value(s5m8767->buck_gpios[0], (temp_index >> 2) & 0x1);
-	gpio_set_value(s5m8767->buck_gpios[1], (temp_index >> 1) & 0x1);
-	gpio_set_value(s5m8767->buck_gpios[2], temp_index & 0x1);
-}
-
-static inline void s5m8767_set_low(struct s5m8767_info *s5m8767)
-{
-	int temp_index = s5m8767->buck_gpioindex;
-
-	gpio_set_value(s5m8767->buck_gpios[2], temp_index & 0x1);
-	gpio_set_value(s5m8767->buck_gpios[1], (temp_index >> 1) & 0x1);
-	gpio_set_value(s5m8767->buck_gpios[0], (temp_index >> 2) & 0x1);
-}
-
-static int s5m8767_set_voltage_buck(struct regulator_dev *rdev,
-				    int min_uV, int max_uV, unsigned *selector)
-{
-	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int reg_id = rdev_get_id(rdev);
-	const struct s5m_voltage_desc *desc;
-	int new_val, old_val, i = 0;
-
-	if (reg_id < S5M8767_BUCK1 || reg_id > S5M8767_BUCK6)
-		return -EINVAL;
-
-	switch (reg_id) {
-	case S5M8767_BUCK1:
-		return s5m8767_set_voltage(rdev, min_uV, max_uV, selector);
-	case S5M8767_BUCK2 ... S5M8767_BUCK4:
-		break;
-	case S5M8767_BUCK5 ... S5M8767_BUCK6:
-		return s5m8767_set_voltage(rdev, min_uV, max_uV, selector);
-	case S5M8767_BUCK9:
-		return s5m8767_set_voltage(rdev, min_uV, max_uV, selector);
-	}
+	/* buck234_vol != NULL means to control buck234 voltage via DVS GPIO */
+	if (buck234_vol) {
+		while (*buck234_vol != sel) {
+			buck234_vol++;
+			index++;
+		}
+		old_index = s5m8767->buck_gpioindex;
+		s5m8767->buck_gpioindex = index;
+
+		if (index > old_index)
+			s5m8767_set_high(s5m8767);
+		else
+			s5m8767_set_low(s5m8767);
+	} else {
+		ret = s5m8767_get_voltage_register(rdev, &reg);
+		if (ret)
+			return ret;
 
-	desc = reg_voltage_map[reg_id];
-	new_val = s5m8767_convert_voltage_to_sel(desc, min_uV, max_uV);
-	if (new_val < 0)
-		return new_val;
+		s5m_reg_read(s5m8767->iodev, reg, &val);
+		val = (val & ~mask) | sel;
 
-	switch (reg_id) {
-	case S5M8767_BUCK2:
-		if (s5m8767->buck2_gpiodvs) {
-			while (s5m8767->buck2_vol[i] != new_val)
-				i++;
-		} else
-			return s5m8767_set_voltage(rdev, min_uV,
-						   max_uV, selector);
-		break;
-	case S5M8767_BUCK3:
-		if (s5m8767->buck3_gpiodvs) {
-			while (s5m8767->buck3_vol[i] != new_val)
-				i++;
-		} else
-			return s5m8767_set_voltage(rdev, min_uV,
-						   max_uV, selector);
-		break;
-	case S5M8767_BUCK4:
-		if (s5m8767->buck3_gpiodvs) {
-			while (s5m8767->buck4_vol[i] != new_val)
-				i++;
-		} else
-			return s5m8767_set_voltage(rdev, min_uV,
-						   max_uV, selector);
-		break;
+		ret = s5m_reg_write(s5m8767->iodev, reg, val);
 	}
 
-	old_val = s5m8767->buck_gpioindex;
-	s5m8767->buck_gpioindex = i;
-
-	if (i > old_val)
-		s5m8767_set_high(s5m8767);
-	else
-		s5m8767_set_low(s5m8767);
-
-	*selector = new_val;
-	return 0;
+	*selector = sel;
+	return ret;
 }
 
 static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
@@ -466,7 +421,7 @@ static struct regulator_ops s5m8767_buck_ops = {
 	.enable			= s5m8767_reg_enable,
 	.disable		= s5m8767_reg_disable,
 	.get_voltage_sel	= s5m8767_get_voltage_sel,
-	.set_voltage		= s5m8767_set_voltage_buck,
+	.set_voltage		= s5m8767_set_voltage,
 	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
 };
 
-- 
1.7.5.4



