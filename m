Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab0DLXFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:05:48 -0400
Received: from mail.df.lth.se ([194.47.250.12]:62278 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752744Ab0DLXFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:05:45 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com,
       Linus Walleij <linus.walleij@stericsson.com>,
       Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH 2/3] MFD: AB3100 interface change to ABx500
Date: Tue, 13 Apr 2010 01:05:26 +0200
Message-Id: <1271113526-7043-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interface for AB3100 is changed to make way for the chips
AB3550, AB5500 and future ST-Ericsson analog baseband chips.
The arguments to mask_and_set_register function have changed and a
u8 bank have been added since the new chips have several banks.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c  |   57 +++++++++++++++---------
 drivers/mfd/ab3100-otp.c   |   11 ++---
 drivers/regulator/ab3100.c |   33 +++++++-------
 drivers/rtc/rtc-ab3100.c   |   39 +++++++----------
 include/linux/mfd/abx500.h |  105 +++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 165 insertions(+), 80 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index f8c4a33..a480f0d 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -59,22 +59,12 @@
  * The AB3100 is usually assigned address 0x48 (7-bit)
  * The chip is defined in the platform i2c_board_data section.
  */
-
-u8 ab3100_get_chip_type(struct ab3100 *ab3100)
+u8 abx500_get_chip_id(struct device *dev)
 {
-	u8 chip = ABUNKNOWN;
-
-	switch (ab3100->chip_id & 0xf0) {
-	case  0xa0:
-		chip = AB3000;
-		break;
-	case  0xc0:
-		chip = AB3100;
-		break;
-	}
-	return chip;
+	struct ab3100 *ab3100 = dev_get_drvdata(dev->parent);
+
+	return ab3100->chip_id;
 }
-EXPORT_SYMBOL(ab3100_get_chip_type);
 
 int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval)
 {
@@ -108,8 +98,14 @@ int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval)
 	mutex_unlock(&ab3100->access_mutex);
 	return err;
 }
-EXPORT_SYMBOL(ab3100_set_register_interruptible);
 
+int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
+	u8 value)
+{
+	struct ab3100 *ab3100 = dev_get_drvdata(dev->parent);
+	return ab3100_set_register_interruptible(ab3100, reg, value);
+}
+EXPORT_SYMBOL(abx500_set_register_interruptible);
 
 /*
  * The test registers exist at an I2C bus address up one
@@ -203,8 +199,14 @@ int ab3100_get_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 *regval)
 	mutex_unlock(&ab3100->access_mutex);
 	return err;
 }
-EXPORT_SYMBOL(ab3100_get_register_interruptible);
 
+int abx500_get_register_interruptible(struct device *dev, u8 bank, u8 reg,
+	u8 *value)
+{
+	struct ab3100 *ab3100 = dev_get_drvdata(dev->parent);
+	return ab3100_get_register_interruptible(ab3100, reg, value);
+}
+EXPORT_SYMBOL(abx500_get_register_interruptible);
 
 int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
 			     u8 first_reg, u8 *regvals, u8 numregs)
@@ -260,11 +262,18 @@ int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
 	mutex_unlock(&ab3100->access_mutex);
 	return err;
 }
-EXPORT_SYMBOL(ab3100_get_register_page_interruptible);
 
+int abx500_get_register_page_interruptible(struct device *dev, u8 bank,
+	u8 first_reg, u8 *regvals, u8 numregs)
+{
+	struct ab3100 *ab3100 = dev_get_drvdata(dev->parent);
+	return ab3100_get_register_page_interruptible(ab3100, first_reg,
+		regvals, numregs);
+}
+EXPORT_SYMBOL(abx500_get_register_page_interruptible);
 
 int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
-				 u8 reg, u8 andmask, u8 ormask)
+				 u8 reg, u8 bitmask, u8 bitvalues)
 {
 	u8 regandval[2] = {reg, 0};
 	int err;
@@ -305,8 +314,7 @@ int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
 	}
 
 	/* Modify the register */
-	regandval[1] &= andmask;
-	regandval[1] |= ormask;
+	regandval[1] = ((~bitmask & regandval[1]) | (bitmask & bitvalues));
 
 	/* Write the register */
 	err = i2c_master_send(ab3100->i2c_client, regandval, 2);
@@ -331,8 +339,15 @@ int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
 	mutex_unlock(&ab3100->access_mutex);
 	return err;
 }
-EXPORT_SYMBOL(ab3100_mask_and_set_register_interruptible);
 
+int abx500_mask_and_set_register_interruptible(struct device *dev, u8 bank,
+	u8 reg, u8 bitmask, u8 bitvalues)
+{
+	struct ab3100 *ab3100 = dev_get_drvdata(dev->parent);
+	return ab3100_mask_and_set_register_interruptible(
+		ab3100, reg, bitmask, bitvalues);
+}
+EXPORT_SYMBOL(abx500_mask_and_set_register_interruptible);
 
 /*
  * Register a simple callback for handling any AB3100 events.
diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
index 7093f1a..63d2b72 100644
--- a/drivers/mfd/ab3100-otp.c
+++ b/drivers/mfd/ab3100-otp.c
@@ -30,7 +30,6 @@
 /**
  * struct ab3100_otp
  * @dev containing device
- * @ab3100 a pointer to the parent ab3100 device struct
  * @locked whether the OTP is locked, after locking, no more bits
  *       can be changed but before locking it is still possible
  *       to change bits from 1->0.
@@ -49,7 +48,6 @@
  */
 struct ab3100_otp {
 	struct device *dev;
-	struct ab3100 *ab3100;
 	bool locked;
 	u32 freq;
 	bool paf;
@@ -63,19 +61,19 @@ struct ab3100_otp {
 
 static int __init ab3100_otp_read(struct ab3100_otp *otp)
 {
-	struct ab3100 *ab = otp->ab3100;
 	u8 otpval[8];
 	u8 otpp;
 	int err;
 
-	err = ab3100_get_register_interruptible(ab, AB3100_OTPP, &otpp);
+	err = abx500_get_register_interruptible(otp->dev, 0,
+		AB3100_OTPP, &otpp);
 	if (err) {
 		dev_err(otp->dev, "unable to read OTPP register\n");
 		return err;
 	}
 
-	err = ab3100_get_register_page_interruptible(ab, AB3100_OTP0,
-						     otpval, 8);
+	err = abx500_get_register_page_interruptible(otp->dev, 0,
+		AB3100_OTP0, otpval, 8);
 	if (err) {
 		dev_err(otp->dev, "unable to read OTP register page\n");
 		return err;
@@ -197,7 +195,6 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
 	otp->dev = &pdev->dev;
 
 	/* Replace platform data coming in with a local struct */
-	otp->ab3100 = platform_get_drvdata(pdev);
 	platform_set_drvdata(pdev, otp);
 
 	err = ab3100_otp_read(otp);
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 1b8b0ab..6580e26 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -41,7 +41,7 @@
  * struct ab3100_regulator
  * A struct passed around the individual regulator functions
  * @platform_device: platform device holding this regulator
- * @ab3100: handle to the AB3100 parent chip
+ * @dev: handle to the device
  * @plfdata: AB3100 platform data passed in at probe time
  * @regreg: regulator register number in the AB3100
  * @fixed_voltage: a fixed voltage for this regulator, if this
@@ -52,7 +52,7 @@
  */
 struct ab3100_regulator {
 	struct regulator_dev *rdev;
-	struct ab3100 *ab3100;
+	struct device *dev;
 	struct ab3100_platform_data *plfdata;
 	u8 regreg;
 	int fixed_voltage;
@@ -183,7 +183,7 @@ static int ab3100_enable_regulator(struct regulator_dev *reg)
 	int err;
 	u8 regval;
 
-	err = ab3100_get_register_interruptible(abreg->ab3100, abreg->regreg,
+	err = abx500_get_register_interruptible(abreg->dev, 0, abreg->regreg,
 						&regval);
 	if (err) {
 		dev_warn(&reg->dev, "failed to get regid %d value\n",
@@ -197,7 +197,7 @@ static int ab3100_enable_regulator(struct regulator_dev *reg)
 
 	regval |= AB3100_REG_ON_MASK;
 
-	err = ab3100_set_register_interruptible(abreg->ab3100, abreg->regreg,
+	err = abx500_set_register_interruptible(abreg->dev, 0, abreg->regreg,
 						regval);
 	if (err) {
 		dev_warn(&reg->dev, "failed to set regid %d value\n",
@@ -245,14 +245,14 @@ static int ab3100_disable_regulator(struct regulator_dev *reg)
 	if (abreg->regreg == AB3100_LDO_D) {
 		dev_info(&reg->dev, "disabling LDO D - shut down system\n");
 		/* Setting LDO D to 0x00 cuts the power to the SoC */
-		return ab3100_set_register_interruptible(abreg->ab3100,
+		return abx500_set_register_interruptible(abreg->dev, 0,
 							 AB3100_LDO_D, 0x00U);
 	}
 
 	/*
 	 * All other regulators are handled here
 	 */
-	err = ab3100_get_register_interruptible(abreg->ab3100, abreg->regreg,
+	err = abx500_get_register_interruptible(abreg->dev, 0, abreg->regreg,
 						&regval);
 	if (err) {
 		dev_err(&reg->dev, "unable to get register 0x%x\n",
@@ -260,7 +260,7 @@ static int ab3100_disable_regulator(struct regulator_dev *reg)
 		return err;
 	}
 	regval &= ~AB3100_REG_ON_MASK;
-	return ab3100_set_register_interruptible(abreg->ab3100, abreg->regreg,
+	return abx500_set_register_interruptible(abreg->dev, 0, abreg->regreg,
 						 regval);
 }
 
@@ -270,7 +270,7 @@ static int ab3100_is_enabled_regulator(struct regulator_dev *reg)
 	u8 regval;
 	int err;
 
-	err = ab3100_get_register_interruptible(abreg->ab3100, abreg->regreg,
+	err = abx500_get_register_interruptible(abreg->dev, 0, abreg->regreg,
 						&regval);
 	if (err) {
 		dev_err(&reg->dev, "unable to get register 0x%x\n",
@@ -305,7 +305,7 @@ static int ab3100_get_voltage_regulator(struct regulator_dev *reg)
 	 * For variable types, read out setting and index into
 	 * supplied voltage list.
 	 */
-	err = ab3100_get_register_interruptible(abreg->ab3100,
+	err = abx500_get_register_interruptible(abreg->dev, 0,
 						abreg->regreg, &regval);
 	if (err) {
 		dev_warn(&reg->dev,
@@ -373,7 +373,7 @@ static int ab3100_set_voltage_regulator(struct regulator_dev *reg,
 	if (bestindex < 0)
 		return bestindex;
 
-	err = ab3100_get_register_interruptible(abreg->ab3100,
+	err = abx500_get_register_interruptible(abreg->dev, 0,
 						abreg->regreg, &regval);
 	if (err) {
 		dev_warn(&reg->dev,
@@ -386,7 +386,7 @@ static int ab3100_set_voltage_regulator(struct regulator_dev *reg,
 	regval &= ~0xE0;
 	regval |= (bestindex << 5);
 
-	err = ab3100_set_register_interruptible(abreg->ab3100,
+	err = abx500_set_register_interruptible(abreg->dev, 0,
 						abreg->regreg, regval);
 	if (err)
 		dev_warn(&reg->dev, "failed to set regulator register %02x\n",
@@ -414,7 +414,7 @@ static int ab3100_set_suspend_voltage_regulator(struct regulator_dev *reg,
 	/* LDO E and BUCK have special suspend voltages you can set */
 	bestindex = ab3100_get_best_voltage_index(reg, uV, uV);
 
-	err = ab3100_get_register_interruptible(abreg->ab3100,
+	err = abx500_get_register_interruptible(abreg->dev, 0,
 						targetreg, &regval);
 	if (err) {
 		dev_warn(&reg->dev,
@@ -427,7 +427,7 @@ static int ab3100_set_suspend_voltage_regulator(struct regulator_dev *reg,
 	regval &= ~0xE0;
 	regval |= (bestindex << 5);
 
-	err = ab3100_set_register_interruptible(abreg->ab3100,
+	err = abx500_set_register_interruptible(abreg->dev, 0,
 						targetreg, regval);
 	if (err)
 		dev_warn(&reg->dev, "failed to set regulator register %02x\n",
@@ -564,13 +564,12 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 {
 	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
-	struct ab3100 *ab3100 = platform_get_drvdata(pdev);
 	int err = 0;
 	u8 data;
 	int i;
 
 	/* Check chip state */
-	err = ab3100_get_register_interruptible(ab3100,
+	err = abx500_get_register_interruptible(&pdev->dev, 0,
 						AB3100_LDO_D, &data);
 	if (err) {
 		dev_err(&pdev->dev, "could not read initial status of LDO_D\n");
@@ -585,7 +584,7 @@ static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 
 	/* Set up regulators */
 	for (i = 0; i < ARRAY_SIZE(ab3100_reg_init_order); i++) {
-		err = ab3100_set_register_interruptible(ab3100,
+		err = abx500_set_register_interruptible(&pdev->dev, 0,
 					ab3100_reg_init_order[i],
 					plfdata->reg_initvals[i]);
 		if (err) {
@@ -607,7 +606,7 @@ static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 		 * see what it looks like for a certain machine, go
 		 * into the machine I2C setup.
 		 */
-		reg->ab3100 = ab3100;
+		reg->dev = &pdev->dev;
 		reg->plfdata = plfdata;
 
 		/*
diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index b46b85d..d26780e 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -45,7 +45,6 @@
  */
 static int ab3100_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
-	struct ab3100 *ab3100_data = dev_get_drvdata(dev);
 	u8 regs[] = {AB3100_TI0, AB3100_TI1, AB3100_TI2,
 		     AB3100_TI3, AB3100_TI4, AB3100_TI5};
 	unsigned char buf[6];
@@ -61,27 +60,26 @@ static int ab3100_rtc_set_mmss(struct device *dev, unsigned long secs)
 	buf[5] = (fat_time >> 40) & 0xFF;
 
 	for (i = 0; i < 6; i++) {
-		err = ab3100_set_register_interruptible(ab3100_data,
+		err = abx500_set_register_interruptible(dev, 0,
 							regs[i], buf[i]);
 		if (err)
 			return err;
 	}
 
 	/* Set the flag to mark that the clock is now set */
-	return ab3100_mask_and_set_register_interruptible(ab3100_data,
+	return abx500_mask_and_set_register_interruptible(dev, 0,
 							  AB3100_RTC,
-							  0xFE, 0x01);
+							  0x01, 0x01);
 
 }
 
 static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	struct ab3100 *ab3100_data = dev_get_drvdata(dev);
 	unsigned long time;
 	u8 rtcval;
 	int err;
 
-	err = ab3100_get_register_interruptible(ab3100_data,
+	err = abx500_get_register_interruptible(dev, 0,
 						AB3100_RTC, &rtcval);
 	if (err)
 		return err;
@@ -94,7 +92,7 @@ static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		u8 buf[6];
 
 		/* Read out time registers */
-		err = ab3100_get_register_page_interruptible(ab3100_data,
+		err = abx500_get_register_page_interruptible(dev, 0,
 							     AB3100_TI0,
 							     buf, 6);
 		if (err != 0)
@@ -114,7 +112,6 @@ static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
-	struct ab3100 *ab3100_data = dev_get_drvdata(dev);
 	unsigned long time;
 	u64 fat_time;
 	u8 buf[6];
@@ -122,7 +119,7 @@ static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	int err;
 
 	/* Figure out if alarm is enabled or not */
-	err = ab3100_get_register_interruptible(ab3100_data,
+	err = abx500_get_register_interruptible(dev, 0,
 						AB3100_RTC, &rtcval);
 	if (err)
 		return err;
@@ -133,7 +130,7 @@ static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	/* No idea how this could be represented */
 	alarm->pending = 0;
 	/* Read out alarm registers, only 4 bytes */
-	err = ab3100_get_register_page_interruptible(ab3100_data,
+	err = abx500_get_register_page_interruptible(dev, 0,
 						     AB3100_AL0, buf, 4);
 	if (err)
 		return err;
@@ -148,7 +145,6 @@ static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 
 static int ab3100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
-	struct ab3100 *ab3100_data = dev_get_drvdata(dev);
 	u8 regs[] = {AB3100_AL0, AB3100_AL1, AB3100_AL2, AB3100_AL3};
 	unsigned char buf[4];
 	unsigned long secs;
@@ -165,21 +161,19 @@ static int ab3100_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 
 	/* Set the alarm */
 	for (i = 0; i < 4; i++) {
-		err = ab3100_set_register_interruptible(ab3100_data,
+		err = abx500_set_register_interruptible(dev, 0,
 							regs[i], buf[i]);
 		if (err)
 			return err;
 	}
 	/* Then enable the alarm */
-	return ab3100_mask_and_set_register_interruptible(ab3100_data,
-							  AB3100_RTC, ~(1 << 2),
+	return abx500_mask_and_set_register_interruptible(dev, 0,
+							  AB3100_RTC, (1 << 2),
 							  alarm->enabled << 2);
 }
 
 static int ab3100_rtc_irq_enable(struct device *dev, unsigned int enabled)
 {
-	struct ab3100 *ab3100_data = dev_get_drvdata(dev);
-
 	/*
 	 * It's not possible to enable/disable the alarm IRQ for this RTC.
 	 * It does not actually trigger any IRQ: instead its only function is
@@ -188,12 +182,12 @@ static int ab3100_rtc_irq_enable(struct device *dev, unsigned int enabled)
 	 * and need to be handled there instead.
 	 */
 	if (enabled)
-		return ab3100_mask_and_set_register_interruptible(ab3100_data,
-						    AB3100_RTC, ~(1 << 2),
+		return abx500_mask_and_set_register_interruptible(dev, 0,
+						    AB3100_RTC, (1 << 2),
 						    1 << 2);
 	else
-		return ab3100_mask_and_set_register_interruptible(ab3100_data,
-						    AB3100_RTC, ~(1 << 2),
+		return abx500_mask_and_set_register_interruptible(dev, 0,
+						    AB3100_RTC, (1 << 2),
 						    0);
 }
 
@@ -210,10 +204,9 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
 	int err;
 	u8 regval;
 	struct rtc_device *rtc;
-	struct ab3100 *ab3100_data = platform_get_drvdata(pdev);
 
 	/* The first RTC register needs special treatment */
-	err = ab3100_get_register_interruptible(ab3100_data,
+	err = abx500_get_register_interruptible(&pdev->dev, 0,
 						AB3100_RTC, &regval);
 	if (err) {
 		dev_err(&pdev->dev, "unable to read RTC register\n");
@@ -231,7 +224,7 @@ static int __init ab3100_rtc_probe(struct platform_device *pdev)
 		 * This bit remains until RTC power is lost.
 		 */
 		regval = 1 | RTC_SETTING;
-		err = ab3100_set_register_interruptible(ab3100_data,
+		err = abx500_set_register_interruptible(&pdev->dev, 0,
 							AB3100_RTC, regval);
 		/* Ignore any error on this write */
 	}
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 9a881c3..cecbf30 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -3,17 +3,34 @@
  * License terms: GNU General Public License (GPL) version 2
  * AB3100 core access functions
  * Author: Linus Walleij <linus.walleij@stericsson.com>
+ *
+ * ABX500 core access functions.
+ * The abx500 interface is used for the Analog Baseband chip
+ * ab3100, ab3550, ab5500 and possibly comming. It is not used for
+ * ab4500 and ab8500 since they are another family of chip.
+ *
+ * Author: Mattias Wallin <mattias.wallin@stericsson.com>
+ * Author: Mattias Nilsson <mattias.i.nilsson@stericsson.com>
+ * Author: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
+ * Author: Rickard Andersson <rickard.andersson@stericsson.com>
  */
 
 #include <linux/device.h>
 #include <linux/regulator/machine.h>
 
-#ifndef MFD_AB3100_H
-#define MFD_AB3100_H
+#ifndef MFD_ABX500_H
+#define MFD_ABX500_H
 
-#define ABUNKNOWN	0
-#define	AB3000		1
-#define	AB3100		2
+#define AB3100_P1A	0xc0
+#define AB3100_P1B	0xc1
+#define AB3100_P1C	0xc2
+#define AB3100_P1D	0xc3
+#define AB3100_P1E	0xc4
+#define AB3100_P1F	0xc5
+#define AB3100_P1G	0xc6
+#define AB3100_R2A	0xc7
+#define AB3100_R2B	0xc8
+#define AB3550_P1A	0x10
 
 /*
  * AB3100, EVENTA1, A2 and A3 event register flags
@@ -112,13 +129,6 @@ struct ab3100_platform_data {
 	int external_voltage;
 };
 
-int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval);
-int ab3100_get_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 *regval);
-int ab3100_get_register_page_interruptible(struct ab3100 *ab3100,
-			     u8 first_reg, u8 *regvals, u8 numregs);
-int ab3100_mask_and_set_register_interruptible(struct ab3100 *ab3100,
-				 u8 reg, u8 andmask, u8 ormask);
-u8 ab3100_get_chip_type(struct ab3100 *ab3100);
 int ab3100_event_register(struct ab3100 *ab3100,
 			  struct notifier_block *nb);
 int ab3100_event_unregister(struct ab3100 *ab3100,
@@ -126,4 +136,75 @@ int ab3100_event_unregister(struct ab3100 *ab3100,
 int ab3100_event_registers_startup_state_get(struct ab3100 *ab3100,
 					     u32 *fatevent);
 
+/* AB3550, STR register flags */
+#define AB3550_STR_ONSWA				(0x01)
+#define AB3550_STR_ONSWB				(0x02)
+#define AB3550_STR_ONSWC				(0x04)
+#define AB3550_STR_DCIO					(0x08)
+#define AB3550_STR_BOOT_MODE				(0x10)
+#define AB3550_STR_SIM_OFF				(0x20)
+#define AB3550_STR_BATT_REMOVAL				(0x40)
+#define AB3550_STR_VBUS					(0x80)
+
+enum ab3550_devid {
+	AB3550_DEVID_ADC,
+	AB3550_DEVID_DAC,
+	AB3550_DEVID_LEDS,
+	AB3550_DEVID_POWER,
+	AB3550_DEVID_REGULATORS,
+	AB3550_DEVID_SIM,
+	AB3550_DEVID_UART,
+	AB3550_DEVID_RTC,
+	AB3550_DEVID_CHARGER,
+	AB3550_DEVID_FUELGAUGE,
+	AB3550_DEVID_VIBRATOR,
+	AB3550_DEVID_CODEC,
+	AB3550_NUM_DEVICES,
+};
+
+/**
+ * struct abx500_init_setting
+ * Initial value of the registers for driver to use during setup.
+ */
+struct abx500_init_settings {
+	u8 bank;
+	u8 reg;
+	u8 setting;
+};
+
+/**
+ * struct ab3550_platform_data
+ * Data supplied to initialize board connections to the AB3550
+ */
+struct ab3550_platform_data {
+	struct {unsigned int base; unsigned int count; } irq;
+	void *dev_data[AB3550_NUM_DEVICES];
+	struct abx500_init_settings *init_settings;
+	unsigned int init_settings_sz;
+};
+
+int abx500_set_register_interruptible(struct device *dev, u8 bank, u8 reg,
+	u8 value);
+int abx500_get_register_interruptible(struct device *dev, u8 bank, u8 reg,
+	u8 *value);
+int abx500_get_register_page_interruptible(struct device *dev, u8 bank,
+	u8 first_reg, u8 *regvals, u8 numregs);
+/**
+ * abx500_mask_and_set_register_inerruptible() - Modifies selected bits of a
+ *	target register
+ *
+ * @dev: The AB sub device.
+ * @bank: The i2c bank number.
+ * @bitmask: The bit mask to use.
+ * @bitvalues: The new bit values.
+ *
+ * Updates the value of an AB register:
+ * value -> ((value & ~bitmask) | (bitvalues & bitmask))
+ */
+int abx500_mask_and_set_register_interruptible(struct device *dev, u8 bank,
+	u8 reg, u8 bitmask, u8 bitvalues);
+u8 abx500_get_chip_id(struct device *dev);
+int abx500_event_registers_startup_state_get(struct device *dev, u8 *event);
+bool abx500_startup_irq_enabled(unsigned int irq);
+
 #endif
-- 
1.7.0.1

