Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab1ADFY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 00:24:56 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29137 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1ADFYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 00:24:32 -0500
Date: Tue, 04 Jan 2011 14:17:40 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v4 2/3] regulator MAX8998/LP3974: Support DVS-GPIO.
In-reply-to: <20101224113805.GI27832@sortiz-mobl>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Message-id: <1294118261-18906-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.1
Content-transfer-encoding: 7BIT
References: <20101224113805.GI27832@sortiz-mobl>
X-OriginalArrivalTime: 04 Jan 2011 05:17:41.0843 (UTC)
 FILETIME=[B6306A30:01CBABCE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous driver did not support BUCK1-DVS3, BUCK1-DVS4, and
BUCK2-DVS2 modes. This patch adds such modes and an option to block
setting buck1/2 voltages out of the preset values.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/max8998.c |   87 +++++++++++++++++++++++++++++++++----------
 include/linux/mfd/max8998.h |   26 ++++++++++---
 2 files changed, 87 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index d183756..9946488 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -425,6 +425,9 @@ static int max8998_set_voltage_buck(struct regulator_dev *rdev,
 				}
 			}
 
+			if (pdata->buck_voltage_lock)
+				return -EINVAL;
+
 			/* no predefine regulator found */
 			max8998->buck1_idx = (buck1_last_val % 2) + 2;
 			dev_dbg(max8998->dev, "max8998->buck1_idx:%d\n",
@@ -452,18 +455,26 @@ buck1_exit:
 			"BUCK2, i:%d buck2_vol1:%d, buck2_vol2:%d\n"
 			, i, max8998->buck2_vol[0], max8998->buck2_vol[1]);
 		if (gpio_is_valid(pdata->buck2_set3)) {
-			if (max8998->buck2_vol[0] == i) {
-				max8998->buck2_idx = 0;
-				buck2_gpio_set(pdata->buck2_set3, 0);
-			} else {
-				max8998->buck2_idx = 1;
-				ret = max8998_get_voltage_register(rdev, &reg,
-								   &shift,
-								   &mask);
-				ret = max8998_write_reg(i2c, reg, i);
-				max8998->buck2_vol[1] = i;
-				buck2_gpio_set(pdata->buck2_set3, 1);
+
+			/* check if requested voltage */
+			/* value is already defined */
+			for (j = 0; j < ARRAY_SIZE(max8998->buck2_vol); j++) {
+				if (max8998->buck2_vol[j] == i) {
+					max8998->buck2_idx = j;
+					buck2_gpio_set(pdata->buck2_set3, j);
+					goto buck2_exit;
+				}
 			}
+
+			if (pdata->buck_voltage_lock)
+				return -EINVAL;
+
+			max8998_get_voltage_register(rdev,
+					&reg, &shift, &mask);
+			ret = max8998_write_reg(i2c, reg, i);
+			max8998->buck2_vol[max8998->buck2_idx] = i;
+			buck2_gpio_set(pdata->buck2_set3, max8998->buck2_idx);
+buck2_exit:
 			dev_dbg(max8998->dev, "%s: SET3:%d\n", i2c->name,
 				gpio_get_value(pdata->buck2_set3));
 		} else {
@@ -708,6 +719,9 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, max8998);
 	i2c = max8998->iodev->i2c;
 
+	max8998->buck1_idx = pdata->buck1_default_idx;
+	max8998->buck2_idx = pdata->buck2_default_idx;
+
 	/* NOTE: */
 	/* For unused GPIO NOT marked as -1 (thereof equal to 0)  WARN_ON */
 	/* will be displayed */
@@ -740,23 +754,46 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       != (pdata->buck1_max_voltage1 / 1000))
+		       < (pdata->buck1_voltage1 / 1000))
 			i++;
-		printk(KERN_ERR "i:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
 		max8998->buck1_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE1, i);
+		if (ret)
+			return ret;
 
 		/* Set predefined value for BUCK1 register 2 */
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       != (pdata->buck1_max_voltage2 / 1000))
+		       < (pdata->buck1_voltage2 / 1000))
 			i++;
 
 		max8998->buck1_vol[1] = i;
-		printk(KERN_ERR "i:%d, buck1_idx:%d\n", i, max8998->buck1_idx);
-		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE2, i)
-			+ ret;
+		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE2, i);
+		if (ret)
+			return ret;
+
+		/* Set predefined value for BUCK1 register 3 */
+		i = 0;
+		while (buck12_voltage_map_desc.min +
+		       buck12_voltage_map_desc.step*i
+		       < (pdata->buck1_voltage3 / 1000))
+			i++;
+
+		max8998->buck1_vol[2] = i;
+		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE3, i);
+		if (ret)
+			return ret;
+
+		/* Set predefined value for BUCK1 register 4 */
+		i = 0;
+		while (buck12_voltage_map_desc.min +
+		       buck12_voltage_map_desc.step*i
+		       < (pdata->buck1_voltage4 / 1000))
+			i++;
+
+		max8998->buck1_vol[3] = i;
+		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK1_VOLTAGE4, i);
 		if (ret)
 			return ret;
 
@@ -773,18 +810,28 @@ static __devinit int max8998_pmic_probe(struct platform_device *pdev)
 		gpio_direction_output(pdata->buck2_set3,
 				      max8998->buck2_idx & 0x1);
 
-		/* BUCK2 - set preset default voltage value to buck2_vol[0] */
+		/* BUCK2 register 1 */
 		i = 0;
 		while (buck12_voltage_map_desc.min +
 		       buck12_voltage_map_desc.step*i
-		       != (pdata->buck2_max_voltage / 1000))
+		       < (pdata->buck2_voltage1 / 1000))
 			i++;
-		printk(KERN_ERR "i:%d, buck2_idx:%d\n", i, max8998->buck2_idx);
 		max8998->buck2_vol[0] = i;
 		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE1, i);
 		if (ret)
 			return ret;
 
+		/* BUCK2 register 2 */
+		i = 0;
+		while (buck12_voltage_map_desc.min +
+		       buck12_voltage_map_desc.step*i
+		       < (pdata->buck2_voltage2 / 1000))
+			i++;
+		printk(KERN_ERR "i2:%d, buck2_idx:%d\n", i, max8998->buck2_idx);
+		max8998->buck2_vol[1] = i;
+		ret = max8998_write_reg(i2c, MAX8998_REG_BUCK2_VOLTAGE2, i);
+		if (ret)
+			return ret;
 	}
 
 	for (i = 0; i < pdata->num_regulators; i++) {
diff --git a/include/linux/mfd/max8998.h b/include/linux/mfd/max8998.h
index c22b9a4..61daa16 100644
--- a/include/linux/mfd/max8998.h
+++ b/include/linux/mfd/max8998.h
@@ -70,12 +70,20 @@ struct max8998_regulator_data {
  * @num_regulators: number of regultors used
  * @irq_base: base IRQ number for max8998, required for IRQs
  * @ono: power onoff IRQ number for max8998
- * @buck1_max_voltage1: BUCK1 maximum alowed voltage register 1
- * @buck1_max_voltage2: BUCK1 maximum alowed voltage register 2
- * @buck2_max_voltage: BUCK2 maximum alowed voltage
+ * @buck_voltage_lock: Do NOT change the values of the following six
+ *   registers set by buck?_voltage?. The voltage of BUCK1/2 cannot
+ *   be other than the preset values.
+ * @buck1_voltage1: BUCK1 DVS mode 1 voltage register
+ * @buck1_voltage2: BUCK1 DVS mode 2 voltage register
+ * @buck1_voltage3: BUCK1 DVS mode 3 voltage register
+ * @buck1_voltage4: BUCK1 DVS mode 4 voltage register
+ * @buck2_voltage1: BUCK2 DVS mode 1 voltage register
+ * @buck2_voltage2: BUCK2 DVS mode 2 voltage register
  * @buck1_set1: BUCK1 gpio pin 1 to set output voltage
  * @buck1_set2: BUCK1 gpio pin 2 to set output voltage
+ * @buck1_default_idx: Default for BUCK1 gpio pin 1, 2
  * @buck2_set3: BUCK2 gpio pin to set output voltage
+ * @buck2_default_idx: Default for BUCK2 gpio pin.
  * @wakeup: Allow to wake up from suspend
  * @rtc_delay: LP3974 RTC chip bug that requires delay after a register
  * write before reading it.
@@ -85,12 +93,18 @@ struct max8998_platform_data {
 	int				num_regulators;
 	int				irq_base;
 	int				ono;
-	int                             buck1_max_voltage1;
-	int                             buck1_max_voltage2;
-	int                             buck2_max_voltage;
+	bool				buck_voltage_lock;
+	int				buck1_voltage1;
+	int				buck1_voltage2;
+	int				buck1_voltage3;
+	int				buck1_voltage4;
+	int				buck2_voltage1;
+	int				buck2_voltage2;
 	int				buck1_set1;
 	int				buck1_set2;
+	int				buck1_default_idx;
 	int				buck2_set3;
+	int				buck2_default_idx;
 	bool				wakeup;
 	bool				rtc_delay;
 };
-- 
1.7.1

