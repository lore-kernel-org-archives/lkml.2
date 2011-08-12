Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab1HLS4J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:56:09 -0400
Received: from 64-198-47-7.ip.mcleodusa.net ([64.198.47.7]:19485 "EHLO
	mail02.indesign-llc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab1HLS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:56:06 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Aug 2011 14:56:06 EDT
Message-ID: <4E4575F9.40006@indesign-llc.com>
Date: Fri, 12 Aug 2011 14:50:33 -0400
From: Clifton Barnes <cabarnes@indesign-llc.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>
CC: <ryan@bluewatersys.com>, <haojian.zhuang@marvell.com>,
        <johnpol@2ka.mipt.ru>, <simon.inizan@goobie.fr>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] w1: ds2780, fix potential deadlock on insertion and removal
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Inizan found a synchronization problem with the w1 interface locking the 
mutex during insertion and removal, but the power supply interface trying to 
get POWER_SUPPLY_PROP_STATUS upon insertion and removal, which causes a 1-wire 
transaction that tries to lock the mutex again.  The following patch has been 
tested to fix the problem.  It is not a very elegant solution with using a 
variable to store the lock status, so if anyone has a better idea please 
present it.

Signed-off-by: Clifton Barnes <cabarnes@indesign-llc.com>
Tested-by: Simon Inizan <simon.inizan@goobie.fr>
---
 drivers/power/ds2780_battery.c |   86 +++++++++++++++++++++++----------------
 drivers/w1/slaves/w1_ds2780.c  |    1 -
 2 files changed, 51 insertions(+), 36 deletions(-)

diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
index 1fefe82..2be668d 100644
--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -39,6 +39,7 @@ struct ds2780_device_info {
 	struct device *dev;
 	struct power_supply bat;
 	struct device *w1_dev;
+	int lock_held;
 };
 
 enum current_types {
@@ -49,8 +50,8 @@ enum current_types {
 static const char model[] = "DS2780";
 static const char manufacturer[] = "Maxim/Dallas";
 
-static inline struct ds2780_device_info *to_ds2780_device_info(
-	struct power_supply *psy)
+static inline struct ds2780_device_info *
+to_ds2780_device_info(struct power_supply *psy)
 {
 	return container_of(psy, struct ds2780_device_info, bat);
 }
@@ -60,17 +61,28 @@ static inline struct power_supply *to_power_supply(struct device *dev)
 	return dev_get_drvdata(dev);
 }
 
-static inline int ds2780_read8(struct device *dev, u8 *val, int addr)
+static inline int ds2780_battery_io(struct ds2780_device_info *dev_info,
+	char *buf, int addr, size_t count, int io)
 {
-	return w1_ds2780_io(dev, val, addr, sizeof(u8), 0);
+	if (dev_info->lock_held)
+		return count;
+	else
+		return w1_ds2780_io(dev_info->w1_dev, buf, addr, count, io);
+}
+
+static inline int ds2780_read8(struct ds2780_device_info *dev_info, u8 *val,
+	int addr)
+{
+	return ds2780_battery_io(dev_info, val, addr, sizeof(u8), 0);
 }
 
-static int ds2780_read16(struct device *dev, s16 *val, int addr)
+static int ds2780_read16(struct ds2780_device_info *dev_info, s16 *val,
+	int addr)
 {
 	int ret;
 	u8 raw[2];
 
-	ret = w1_ds2780_io(dev, raw, addr, sizeof(u8) * 2, 0);
+	ret = ds2780_battery_io(dev_info, raw, addr, sizeof(raw), 0);
 	if (ret < 0)
 		return ret;
 
@@ -79,16 +91,16 @@ static int ds2780_read16(struct device *dev, s16 *val, int addr)
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
@@ -122,7 +134,7 @@ static int ds2780_set_sense_register(struct ds2780_device_info *dev_info,
 {
 	int ret;
 
-	ret = ds2780_write(dev_info->w1_dev, &conductance,
+	ret = ds2780_write(dev_info, &conductance,
 				DS2780_RSNSP_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
@@ -134,7 +146,7 @@ static int ds2780_set_sense_register(struct ds2780_device_info *dev_info,
 static int ds2780_get_rsgain_register(struct ds2780_device_info *dev_info,
 	u16 *rsgain)
 {
-	return ds2780_read16(dev_info->w1_dev, rsgain, DS2780_RSGAIN_MSB_REG);
+	return ds2780_read16(dev_info, rsgain, DS2780_RSGAIN_MSB_REG);
 }
 
 /* Set RSGAIN value from 0 to 1.999 in steps of 0.001 */
@@ -144,8 +156,8 @@ static int ds2780_set_rsgain_register(struct ds2780_device_info *dev_info,
 	int ret;
 	u8 raw[] = {rsgain >> 8, rsgain & 0xFF};
 
-	ret = ds2780_write(dev_info->w1_dev, raw,
-				DS2780_RSGAIN_MSB_REG, sizeof(u8) * 2);
+	ret = ds2780_write(dev_info, raw,
+				DS2780_RSGAIN_MSB_REG, sizeof(raw);
 	if (ret < 0)
 		return ret;
 
@@ -167,7 +179,7 @@ static int ds2780_get_voltage(struct ds2780_device_info *dev_info,
 	 * Bits 2 - 0 of the voltage value are in bits 7 - 5 of the
 	 * voltage LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &voltage_raw,
+	ret = ds2780_read16(dev_info, &voltage_raw,
 				DS2780_VOLT_MSB_REG);
 	if (ret < 0)
 		return ret;
@@ -196,7 +208,7 @@ static int ds2780_get_temperature(struct ds2780_device_info *dev_info,
 	 * Bits 2 - 0 of the temperature value are in bits 7 - 5 of the
 	 * temperature LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &temperature_raw,
+	ret = ds2780_read16(dev_info, &temperature_raw,
 				DS2780_TEMP_MSB_REG);
 	if (ret < 0)
 		return ret;
@@ -222,13 +234,13 @@ static int ds2780_get_current(struct ds2780_device_info *dev_info,
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
 
@@ -248,7 +260,7 @@ static int ds2780_get_current(struct ds2780_device_info *dev_info,
 	 * Bits 7 - 0 of the current value are in bits 7 - 0 of the current
 	 * LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &current_raw, reg_msb);
+	ret = ds2780_read16(dev_info, &current_raw, reg_msb);
 	if (ret < 0)
 		return ret;
 
@@ -267,7 +279,7 @@ static int ds2780_get_accumulated_current(struct ds2780_device_info *dev_info,
 	 * The units of measurement for accumulated current are dependent on
 	 * the value of the sense resistor.
 	 */
-	ret = ds2780_read8(dev_info->w1_dev, &sense_res_raw, DS2780_RSNSP_REG);
+	ret = ds2780_read8(dev_info, &sense_res_raw, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
@@ -285,7 +297,7 @@ static int ds2780_get_accumulated_current(struct ds2780_device_info *dev_info,
 	 * Bits 7 - 0 of the ACR value are in bits 7 - 0 of the ACR
 	 * LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &current_raw, DS2780_ACR_MSB_REG);
+	ret = ds2780_read16(dev_info, &current_raw, DS2780_ACR_MSB_REG);
 	if (ret < 0)
 		return ret;
 
@@ -299,7 +311,7 @@ static int ds2780_get_capacity(struct ds2780_device_info *dev_info,
 	int ret;
 	u8 raw;
 
-	ret = ds2780_read8(dev_info->w1_dev, &raw, DS2780_RARC_REG);
+	ret = ds2780_read8(dev_info, &raw, DS2780_RARC_REG);
 	if (ret < 0)
 		return ret;
 
@@ -345,7 +357,7 @@ static int ds2780_get_charge_now(struct ds2780_device_info *dev_info,
 	 * Bits 7 - 0 of the RAAC value are in bits 7 - 0 of the RAAC
 	 * LSB register
 	 */
-	ret = ds2780_read16(dev_info->w1_dev, &charge_raw, DS2780_RAAC_MSB_REG);
+	ret = ds2780_read16(dev_info, &charge_raw, DS2780_RAAC_MSB_REG);
 	if (ret < 0)
 		return ret;
 
@@ -356,7 +368,7 @@ static int ds2780_get_charge_now(struct ds2780_device_info *dev_info,
 static int ds2780_get_control_register(struct ds2780_device_info *dev_info,
 	u8 *control_reg)
 {
-	return ds2780_read8(dev_info->w1_dev, control_reg, DS2780_CONTROL_REG);
+	return ds2780_read8(dev_info, control_reg, DS2780_CONTROL_REG);
 }
 
 static int ds2780_set_control_register(struct ds2780_device_info *dev_info,
@@ -364,7 +376,7 @@ static int ds2780_set_control_register(struct ds2780_device_info *dev_info,
 {
 	int ret;
 
-	ret = ds2780_write(dev_info->w1_dev, &control_reg,
+	ret = ds2780_write(dev_info, &control_reg,
 				DS2780_CONTROL_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
@@ -503,7 +515,7 @@ static ssize_t ds2780_get_sense_resistor_value(struct device *dev,
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = ds2780_read8(dev_info->w1_dev, &sense_resistor, DS2780_RSNSP_REG);
+	ret = ds2780_read8(dev_info, &sense_resistor, DS2780_RSNSP_REG);
 	if (ret < 0)
 		return ret;
 
@@ -584,7 +596,7 @@ static ssize_t ds2780_get_pio_pin(struct device *dev,
 	struct power_supply *psy = to_power_supply(dev);
 	struct ds2780_device_info *dev_info = to_ds2780_device_info(psy);
 
-	ret = ds2780_read8(dev_info->w1_dev, &sfr, DS2780_SFR_REG);
+	ret = ds2780_read8(dev_info, &sfr, DS2780_SFR_REG);
 	if (ret < 0)
 		return ret;
 
@@ -611,7 +623,7 @@ static ssize_t ds2780_set_pio_pin(struct device *dev,
 		return -EINVAL;
 	}
 
-	ret = ds2780_write(dev_info->w1_dev, &new_setting,
+	ret = ds2780_write(dev_info, &new_setting,
 				DS2780_SFR_REG, sizeof(u8));
 	if (ret < 0)
 		return ret;
@@ -632,7 +644,7 @@ static ssize_t ds2780_read_param_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
-	return ds2780_read_block(dev_info->w1_dev, buf,
+	return ds2780_read_block(dev_info, buf,
 				DS2780_EEPROM_BLOCK1_START + off, count);
 }
 
@@ -650,7 +662,7 @@ static ssize_t ds2780_write_param_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK1_END -
 		DS2780_EEPROM_BLOCK1_START + 1 - off);
 
-	ret = ds2780_write(dev_info->w1_dev, buf,
+	ret = ds2780_write(dev_info, buf,
 				DS2780_EEPROM_BLOCK1_START + off, count);
 	if (ret < 0)
 		return ret;
@@ -685,9 +697,8 @@ static ssize_t ds2780_read_user_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
-	return ds2780_read_block(dev_info->w1_dev, buf,
+	return ds2780_read_block(dev_info, buf,
 				DS2780_EEPROM_BLOCK0_START + off, count);
-
 }
 
 static ssize_t ds2780_write_user_eeprom_bin(struct file *filp,
@@ -704,7 +715,7 @@ static ssize_t ds2780_write_user_eeprom_bin(struct file *filp,
 		DS2780_EEPROM_BLOCK0_END -
 		DS2780_EEPROM_BLOCK0_START + 1 - off);
 
-	ret = ds2780_write(dev_info->w1_dev, buf,
+	ret = ds2780_write(dev_info, buf,
 				DS2780_EEPROM_BLOCK0_START + off, count);
 	if (ret < 0)
 		return ret;
@@ -768,6 +779,7 @@ static int __devinit ds2780_battery_probe(struct platform_device *pdev)
 	dev_info->bat.properties	= ds2780_battery_props;
 	dev_info->bat.num_properties	= ARRAY_SIZE(ds2780_battery_props);
 	dev_info->bat.get_property	= ds2780_battery_get_property;
+	dev_info->lock_held		= 1;
 
 	ret = power_supply_register(&pdev->dev, &dev_info->bat);
 	if (ret) {
@@ -797,6 +809,8 @@ static int __devinit ds2780_battery_probe(struct platform_device *pdev)
 		goto fail_remove_bin_file;
 	}
 
+	dev_info->lock_held = 0;
+
 	return 0;
 
 fail_remove_bin_file:
@@ -816,6 +830,8 @@ static int __devexit ds2780_battery_remove(struct platform_device *pdev)
 {
 	struct ds2780_device_info *dev_info = platform_get_drvdata(pdev);
 
+	dev_info->lock_held = 1;
+
 	/* remove attributes */
 	sysfs_remove_group(&dev_info->bat.dev->kobj, &ds2780_attr_group);
 
diff --git a/drivers/w1/slaves/w1_ds2780.c b/drivers/w1/slaves/w1_ds2780.c
index 274c8f3..4c33b7c 100644
--- a/drivers/w1/slaves/w1_ds2780.c
+++ b/drivers/w1/slaves/w1_ds2780.c
@@ -47,7 +47,6 @@ int w1_ds2780_io(struct device *dev, char *buf, int addr, size_t count,
 			w1_write_8(sl->master, W1_DS2780_WRITE_DATA);
 			w1_write_8(sl->master, addr);
 			w1_write_block(sl->master, buf, count);
-			/* XXX w1_write_block returns void, not n_written */
 		} else {
 			w1_write_8(sl->master, W1_DS2780_READ_DATA);
 			w1_write_8(sl->master, addr);
-- 
1.7.3.4


