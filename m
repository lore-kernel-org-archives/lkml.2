Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2KAGT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 02:19:29 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:32260
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751312Ab2KAGT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 02:19:28 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537hbe9i1155h)
Subject: [patch v1 1/2] mfd: i2c issue fix for DA9052/53 and support for
 DA9053-BC
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, David Dajun Chen <dchen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 1 Nov 2012 11:48:42 +0530
Message-ID: <1351750722.19193.16.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an issue where the DA9052/53-AA/BA/BB PMIC either locks up or fails to
respond following a system Reset. This could result in a second write
in which the bus writes the current content of the write buffer to address
of the last I2C access.

The failure case is where this unwanted write transfers incorrect data to
a critical register.

This patch fixes this issue to by following any read or write with a dummy read
to a safe register address. A safe register address is one where the contents
will not affect the operation of the system.

Apart from this the patch also adds support to the DA9053-BC PMIC chip

Signed-off-by: David Dajun Chen <dchen@diasemi.com>
Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
---
 drivers/mfd/da9052-i2c.c          |   58 +++++++++++++++++++++++++++++++++++++
 drivers/mfd/da9052-spi.c          |    1 +
 include/linux/mfd/da9052/da9052.h |   48 ++++++++++++++++++++++++++++--
 include/linux/mfd/da9052/reg.h    |    3 ++
 4 files changed, 106 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 352c58b..279e5f8 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -27,6 +27,62 @@
 #include <linux/of_device.h>
 #endif
 
+/* safe register to park I2C operation */
+static inline bool is_i2c_safe_reg(unsigned char reg)
+{
+	switch (reg) {
+	case DA9052_STATUS_A_REG:
+	case DA9052_STATUS_B_REG:
+	case DA9052_STATUS_C_REG:
+	case DA9052_STATUS_D_REG:
+	case DA9052_ADC_RES_L_REG:
+	case DA9052_ADC_RES_H_REG:
+	case DA9052_VDD_RES_REG:
+	case DA9052_ICHG_AV_REG:
+	case DA9052_TBAT_RES_REG:
+	case DA9052_ADCIN4_RES_REG:
+	case DA9052_ADCIN5_RES_REG:
+	case DA9052_ADCIN6_RES_REG:
+	case DA9052_TJUNC_RES_REG:
+	case DA9052_TSI_X_MSB_REG:
+	case DA9052_TSI_Y_MSB_REG:
+	case DA9052_TSI_LSB_REG:
+	case DA9052_TSI_Z_MSB_REG:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/*
+ * There is an issue with DA9052 and DA9053_AA/BA/BB PMIC where the PMIC
+ * gets lockup up or fails to respond following a system reset.
+ * This fix is to follow any read or write with a dummy read to a safe
+ * register.
+ */
+int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
+{
+	int val;
+
+	switch (da9052->chip_id) {
+	case DA9052:
+	case DA9053_AA:
+	case DA9053_BA:
+	case DA9053_BB:
+		/* A dummy read to a safe register address. */
+		if (!is_i2c_safe_reg(reg))
+			return regmap_read(da9052->regmap, DA9052_PARK_REGISTER,
+					   &val);
+		break;
+	default:
+		/* Do nothing */
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(da9052_i2c_fix);
+
 static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
 {
 	int reg_val, ret;
@@ -51,6 +107,7 @@ static const struct i2c_device_id da9052_i2c_id[] = {
 	{"da9053-aa", DA9053_AA},
 	{"da9053-ba", DA9053_BA},
 	{"da9053-bb", DA9053_BB},
+	{"da9053-bc", DA9053_BC},
 	{}
 };
 
@@ -60,6 +117,7 @@ static const struct of_device_id dialog_dt_ids[] = {
 	{ .compatible = "dlg,da9053-aa", .data = &da9052_i2c_id[1] },
 	{ .compatible = "dlg,da9053-ab", .data = &da9052_i2c_id[2] },
 	{ .compatible = "dlg,da9053-bb", .data = &da9052_i2c_id[3] },
+	{ .compatible = "dlg,da9053-bc", .data = &da9052_i2c_id[4] },
 	{ /* sentinel */ }
 };
 #endif
diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index dbeadc5..524bd76 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -71,6 +71,7 @@ static struct spi_device_id da9052_spi_id[] = {
 	{"da9053-aa", DA9053_AA},
 	{"da9053-ba", DA9053_BA},
 	{"da9053-bb", DA9053_BB},
+	{"da9053-bc", DA9053_BC},
 	{}
 };
 
diff --git a/include/linux/mfd/da9052/da9052.h b/include/linux/mfd/da9052/da9052.h
index 0507c4c..21b934a 100644
--- a/include/linux/mfd/da9052/da9052.h
+++ b/include/linux/mfd/da9052/da9052.h
@@ -83,6 +83,7 @@ enum da9052_chip_id {
 	DA9053_AA,
 	DA9053_BA,
 	DA9053_BB,
+	DA9053_BC,
 };
 
 struct da9052_pdata;
@@ -101,6 +102,16 @@ struct da9052 {
 	int chip_irq;
 };
 
+/* I2C Fix */
+#if defined(CONFIG_MFD_DA9052_SPI)
+static inline int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
+{
+	return 0;
+}
+#else
+int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg);
+#endif
+
 /* ADC API */
 int da9052_adc_manual_read(struct da9052 *da9052, unsigned char channel);
 int da9052_adc_read_temp(struct da9052 *da9052);
@@ -113,32 +124,61 @@ static inline int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
 	ret = regmap_read(da9052->regmap, reg, &val);
 	if (ret < 0)
 		return ret;
+
+	ret = da9052_i2c_fix(da9052, reg);
+	if (ret < 0)
+		return ret;
+
 	return val;
 }
 
 static inline int da9052_reg_write(struct da9052 *da9052, unsigned char reg,
 				    unsigned char val)
 {
-	return regmap_write(da9052->regmap, reg, val);
+	int ret;
+
+	ret = regmap_write(da9052->regmap, reg, val);
+	if (ret < 0)
+		return ret;
+
+	return da9052_i2c_fix(da9052, reg);
 }
 
 static inline int da9052_group_read(struct da9052 *da9052, unsigned char reg,
 				     unsigned reg_cnt, unsigned char *val)
 {
-	return regmap_bulk_read(da9052->regmap, reg, val, reg_cnt);
+	int ret;
+
+	ret = regmap_bulk_read(da9052->regmap, reg, val, reg_cnt);
+	if (ret < 0)
+		return ret;
+
+	return da9052_i2c_fix(da9052, reg);
 }
 
 static inline int da9052_group_write(struct da9052 *da9052, unsigned char reg,
 				      unsigned reg_cnt, unsigned char *val)
 {
-	return regmap_raw_write(da9052->regmap, reg, val, reg_cnt);
+	int ret;
+
+	ret = regmap_raw_write(da9052->regmap, reg, val, reg_cnt);
+	if (ret < 0)
+		return ret;
+
+	return da9052_i2c_fix(da9052, reg);
 }
 
 static inline int da9052_reg_update(struct da9052 *da9052, unsigned char reg,
 				     unsigned char bit_mask,
 				     unsigned char reg_val)
 {
-	return regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
+	int ret;
+
+	ret = regmap_update_bits(da9052->regmap, reg, bit_mask, reg_val);
+	if (ret < 0)
+		return ret;
+
+	return da9052_i2c_fix(da9052, reg);
 }
 
 int da9052_device_init(struct da9052 *da9052, u8 chip_id);
diff --git a/include/linux/mfd/da9052/reg.h b/include/linux/mfd/da9052/reg.h
index b97f730..c4dd3a8 100644
--- a/include/linux/mfd/da9052/reg.h
+++ b/include/linux/mfd/da9052/reg.h
@@ -34,6 +34,9 @@
 #define DA9052_STATUS_C_REG		3
 #define DA9052_STATUS_D_REG		4
 
+/* PARK REGISTER */
+#define DA9052_PARK_REGISTER		DA9052_STATUS_D_REG
+
 /* EVENT REGISTERS */
 #define DA9052_EVENT_A_REG		5
 #define DA9052_EVENT_B_REG		6
-- 
1.7.0.4


