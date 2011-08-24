Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1HXOgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:36:31 -0400
Received: from 64-198-47-7.ip.mcleodusa.net ([64.198.47.7]:51758 "EHLO
	mail02.indesign-llc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab1HXOf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:35:29 -0400
Message-ID: <4E550C2A.80407@indesign-llc.com>
Date: Wed, 24 Aug 2011 10:35:22 -0400
From: Clifton Barnes <cabarnes@indesign-llc.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <simon.inizan@goobie.fr>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] w1: ds2780, create central point for calling w1 interface
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply creates one point to call the w1 interface.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
---
 drivers/power/ds2780_battery.c |   77 ++++++++++++++++++++++------------------
 1 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
index 1fefe82..2571b41 100644
--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -49,8 +49,8 @@ enum current_types {
 static const char model[] = "DS2780";
 static const char manufacturer[] = "Maxim/Dallas";
 
-static inline struct ds2780_device_info *to_ds2780_device_info(
-	struct power_supply *psy)
+static inline struct ds2780_device_info *
+to_ds2780_device_info(struct power_supply *psy)
 {
 	return container_of(psy, struct ds2780_device_info, bat);
 }
@@ -60,17 +60,25 @@ static inline struct power_supply *to_power_supply(struct device *dev)
 	return dev_get_drvdata(dev);
 }
 
-static inline int ds2780_read8(struct device *dev, u8 *val, int addr)
+static inline int ds2780_battery_io(struct ds2780_device_info *dev_info,
+	char *buf, int addr, size_t count, int io)
 {
-	return w1_ds2780_io(dev, val, addr, sizeof(u8), 0);
+		return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
 }
 
-static int ds2780_read16(struct device *dev, s16 *val, int addr)
+static inline int ds2780_read8(struct ds2780_device_info *dev_info, u8 *val,
+	int addr)
+{
+	return ds2780_battery_io(dev_info, val, addr, sizeof(u8), 0);
+}
+
+static int ds2780_read16(struct ds2780_device_info *dev_info, s16 *val,
+	int addr)
 {
 	int ret;
 	u8 raw[2];
 
-	ret = w1_ds2780_io(dev, raw, addr, sizeof(u8) * 2, 0);
+	ret = ds2780_battery_io(dev_info, raw, addr, sizeof(raw), 0);
 	if (ret < 0)
 		return ret;
 
@@ -79,16 +87,16 @@ static int ds2780_read16(struct device *dev, s16 *val, int addr)
 	return 0;
 }
 
-static inline int ds2780_read_block(struct device *dev, u8 *val, int addr,
-	size_t count)
+static inline int ds2780_read_block(struct ds2780_device_info *dev_info,
+	u8 *val, int addr, size_t count)
 {
-	return w1_ds2780_io(dev, val, addr, count, 0);
+	return ds2780_battery_io(dev_info, val, addr, count, 0);
 }
 
-static inline int ds2780_write(struct device *dev, u8 *val, int addr,
-	size_t count)
+static inline int ds2780_write(struct ds2780_device_info *dev_info, u8 *val,
+	int addr, size_t count)
 {
-	return w1_ds2780_io(dev, val, addr, count, 1);
+	return ds2780_battery_io(dev_info, val, addr, count, 1);
 }
 
 static inline int ds2780_store_eeprom(struct device *dev, int addr)
@@ -122,7 +130,7 @@ static int ds2780_set_sense_register(struct ds2780_device_info *dev_info,
 {
 	int ret;
 
-	ret = ds2780_write(dev_info->w1_dev, &conductance,
+	ret = ds2780_write(dev_info, &conductance,
 				DS2780_RSNSP_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
@@ -134,7 +142,7 @@ static int ds2780_set_sense_register(struct ds2780_device_info *dev_info,
 static int ds2780_get_rsgain_register(struct ds2780_device_info *dev_info,
 	u16 *rsgain)
 {
-	return ds2780_read16(dev_info->w1_dev, rsgain, DS2780_RSGAIN_MSB_REG);
+	return ds2780_read16(dev_info, rsgain, DS2780_RSGAIN_MSB_REG);
 }
 
 /* Set RSGAIN value from 0 to 1.999 in steps of 0.001 */
@@ -144,8 +152,8 @@ static int ds2780_set_rsgain_register(struct ds2780_device_info *dev_info,
 	int ret;
 	u8 raw[] = {rsgain >> 8, rsgain & 0xFF};
 
-	ret = ds2780_write(dev_info->w1_dev, raw,
-				DS2780_RSGAIN_MSB_REG, sizeof(u8) * 2);
+	ret = ds2780_write(dev_info, raw,
+				DS2780_RSGAIN_MSB_REG, sizeof(raw));
 	if (ret < 0)
 		return ret;
 
@@ -167,7 +175,7 @@ static int ds2780_get_voltage(struct ds2780_device_info *dev_info,
 	 * Bits 2 - 0 of the voltage value are in bits 7 - 5 of the
 	 * voltage LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &voltage_raw,
+	ret = ds2780_read16(dev_info, &voltage_raw,
 				DS2780_VOLT_MSB_REG);
 	if (ret < 0)
 		return ret;
@@ -196,7 +204,7 @@ static int ds2780_get_temperature(struct ds2780_device_info *dev_info,
 	 * Bits 2 - 0 of the temperature value are in bits 7 - 5 of the
 	 * temperature LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &temperature_raw,
+	ret = ds2780_read16(dev_info, &temperature_raw,
 				DS2780_TEMP_MSB_REG);
 	if (ret < 0)
 		return ret;
@@ -222,13 +230,13 @@ static int ds2780_get_current(struct ds2780_device_info *dev_info,
 	 * The units of measurement for current are dependent on the value of
 	 * the sense resistor.
 	 */
-	ret = ds2780_read8(dev_info->w1_dev, &sense_res_raw, DS2780_RSNSP_REG);
+	ret = ds2780_read8(dev_info, &sense_res_raw, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
 	if (sense_res_raw == 0) {
 		dev_err(dev_info->dev, "sense resistor value is 0\n");
-		return -ENXIO;
+		return -EINVAL;
 	}
 	sense_res = 1000 / sense_res_raw;
 
@@ -248,7 +256,7 @@ static int ds2780_get_current(struct ds2780_device_info *dev_info,
 	 * Bits 7 - 0 of the current value are in bits 7 - 0 of the current
 	 * LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &current_raw, reg_msb);
+	ret = ds2780_read16(dev_info, &current_raw, reg_msb);
 	if (ret < 0)
 		return ret;
 
@@ -267,7 +275,7 @@ static int ds2780_get_accumulated_current(struct ds2780_device_info *dev_info,
 	 * The units of measurement for accumulated current are dependent on
 	 * the value of the sense resistor.
 	 */
-	ret = ds2780_read8(dev_info->w1_dev, &sense_res_raw, DS2780_RSNSP_REG);
+	ret = ds2780_read8(dev_info, &sense_res_raw, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
@@ -285,7 +293,7 @@ static int ds2780_get_accumulated_current(struct ds2780_device_info *dev_info,
 	 * Bits 7 - 0 of the ACR value are in bits 7 - 0 of the ACR
 	 * LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &current_raw, DS2780_ACR_MSB_REG);
+	ret = ds2780_read16(dev_info, &current_raw, DS2780_ACR_MSB_REG);
 	if (ret < 0)
 		return ret;
 
@@ -299,7 +307,7 @@ static int ds2780_get_capacity(struct ds2780_device_info *dev_info,
 	int ret;
 	u8 raw;
 
-	ret = ds2780_read8(dev_info->w1_dev, &raw, DS2780_RARC_REG);
+	ret = ds2780_read8(dev_info, &raw, DS2780_RARC_REG);
 	if (ret < 0)
 		return ret;
 
@@ -345,7 +353,7 @@ static int ds2780_get_charge_now(struct ds2780_device_info *dev_info,
 	 * Bits 7 - 0 of the RAAC value are in bits 7 - 0 of the RAAC
 	 * LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &charge_raw, DS2780_RAAC_MSB_REG);
+	ret = ds2780_read16(dev_info, &charge_raw, DS2780_RAAC_MSB_REG);
 	if (ret < 0)
 		return ret;
 
@@ -356,7 +364,7 @@ static int ds2780_get_charge_now(struct ds2780_device_info *dev_info,
 static int ds2780_get_control_register(struct ds2780_device_info *dev_info,
 	u8 *control_reg)
 {
-	return ds2780_read8(dev_info->w1_dev, control_reg, DS2780_CONTROL_REG);
+	return ds2780_read8(dev_info, control_reg, DS2780_CONTROL_REG);
 }
 
 static int ds2780_set_control_register(struct ds2780_device_info *dev_info,
@@ -364,7 +372,7 @@ static int ds2780_set_control_register(struct ds2780_device_info *dev_info,
 {
 	int ret;
 
-	ret = ds2780_write(dev_info->w1_dev, &control_reg,
+	ret = ds2780_write(dev_info, &control_reg,
 				DS2780_CONTROL_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
@@ -503,7 +511,7 @@ static ssize_t ds2780_get_sense_resistor_value(struct device *dev,
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = ds2780_read8(dev_info->w1_dev, &sense_resistor, DS2780_RSNSP_REG);
+	ret = ds2780_read8(dev_info, &sense_resistor, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
@@ -584,7 +592,7 @@ static ssize_t ds2780_get_pio_pin(struct device *dev,
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = ds2780_read8(dev_info->w1_dev, &sfr, DS2780_SFR_REG);
+	ret = ds2780_read8(dev_info, &sfr, DS2780_SFR_REG);
 	if (ret < 0)
 		return ret;
 
@@ -611,7 +619,7 @@ static ssize_t ds2780_set_pio_pin(struct device *dev,
 		return -EINVAL;
 	}
 
-	ret = ds2780_write(dev_info->w1_dev, &new_setting,
+	ret = ds2780_write(dev_info, &new_setting,
 				DS2780_SFR_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
@@ -632,7 +640,7 @@ static ssize_t ds2780_read_param_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
-	return ds2780_read_block(dev_info->w1_dev, buf,
+	return ds2780_read_block(dev_info, buf,
 				DS2780_EEPROM_BLOCK1_START + off, count);
 }
 
@@ -650,7 +658,7 @@ static ssize_t ds2780_write_param_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
-	ret = ds2780_write(dev_info->w1_dev, buf,
+	ret = ds2780_write(dev_info, buf,
 				DS2780_EEPROM_BLOCK1_START + off, count);
 	if (ret < 0)
 		return ret;
@@ -685,9 +693,8 @@ static ssize_t ds2780_read_user_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
-	return ds2780_read_block(dev_info->w1_dev, buf,
+	return ds2780_read_block(dev_info, buf,
 				DS2780_EEPROM_BLOCK0_START + off, count);
-
 }
 
 static ssize_t ds2780_write_user_eeprom_bin(struct file *filp,
@@ -704,7 +711,7 @@ static ssize_t ds2780_write_user_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
-	ret = ds2780_write(dev_info->w1_dev, buf,
+	ret = ds2780_write(dev_info, buf,
 				DS2780_EEPROM_BLOCK0_START + off, count);
 	if (ret < 0)
 		return ret;
-- 
1.7.6

