Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0HBHiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 03:38:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19806 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0HBHiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 03:38:17 -0400
Date: Mon, 02 Aug 2010 16:35:05 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
Subject: [PATCH v2 1/3] mfd: MAX8998: Use struct i2c_client to argument on i2c
 operation functions
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, akpm@linux-foundation.org, a.zummo@towertech.it,
        p_gortmaker@yahoo.com, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com
Message-id: <1280734507-8398-1-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.7.0.4
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 02 Aug 2010 07:35:08.0383 (UTC)
 FILETIME=[3B7B4EF0:01CB3215]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAX8998 chip have regulator and rtc features. The i2c slave address
of regulator and rtc is different, so needs each i2c client on i2c
operation functions.

Also, this patch exports i2c operation functions instead of callback to
make easy to read.

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/max8998.c               |   29 ++++++++++++++---------------
 drivers/regulator/max8998.c         |   17 +++++++++++------
 include/linux/mfd/max8998-private.h |   30 +++++-------------------------
 3 files changed, 30 insertions(+), 46 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 0d68de2..183964e 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -36,13 +36,13 @@ static struct mfd_cell max8998_devs[] = {
 	}
 };
 
-static int max8998_i2c_device_read(struct max8998_dev *max8998, u8 reg, u8 *dest)
+int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest)
 {
-	struct i2c_client *client = max8998->i2c_client;
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 	int ret;
 
 	mutex_lock(&max8998->iolock);
-	ret = i2c_smbus_read_byte_data(client, reg);
+	ret = i2c_smbus_read_byte_data(i2c, reg);
 	mutex_unlock(&max8998->iolock);
 	if (ret < 0)
 		return ret;
@@ -51,36 +51,38 @@ static int max8998_i2c_device_read(struct max8998_dev *max8998, u8 reg, u8 *dest
 	*dest = ret;
 	return 0;
 }
+EXPORT_SYMBOL(max8998_read_reg);
 
-static int max8998_i2c_device_write(struct max8998_dev *max8998, u8 reg, u8 value)
+int max8998_write_reg(struct i2c_client *i2c, u8 reg, u8 value)
 {
-	struct i2c_client *client = max8998->i2c_client;
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 	int ret;
 
 	mutex_lock(&max8998->iolock);
-	ret = i2c_smbus_write_byte_data(client, reg, value);
+	ret = i2c_smbus_write_byte_data(i2c, reg, value);
 	mutex_unlock(&max8998->iolock);
 	return ret;
 }
+EXPORT_SYMBOL(max8998_write_reg);
 
-static int max8998_i2c_device_update(struct max8998_dev *max8998, u8 reg,
-				     u8 val, u8 mask)
+int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 {
-	struct i2c_client *client = max8998->i2c_client;
+	struct max8998_dev *max8998 = i2c_get_clientdata(i2c);
 	int ret;
 
 	mutex_lock(&max8998->iolock);
-	ret = i2c_smbus_read_byte_data(client, reg);
+	ret = i2c_smbus_read_byte_data(i2c, reg);
 	if (ret >= 0) {
 		u8 old_val = ret & 0xff;
 		u8 new_val = (val & mask) | (old_val & (~mask));
-		ret = i2c_smbus_write_byte_data(client, reg, new_val);
+		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
 		if (ret >= 0)
 			ret = 0;
 	}
 	mutex_unlock(&max8998->iolock);
 	return ret;
 }
+EXPORT_SYMBOL(max8998_update_reg);
 
 static int max8998_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
@@ -96,10 +98,7 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 
 	i2c_set_clientdata(i2c, max8998);
 	max8998->dev = &i2c->dev;
-	max8998->i2c_client = i2c;
-	max8998->dev_read = max8998_i2c_device_read;
-	max8998->dev_write = max8998_i2c_device_write;
-	max8998->dev_update = max8998_i2c_device_update;
+	max8998->i2c = i2c;
 	mutex_init(&max8998->iolock);
 
 	ret = mfd_add_devices(max8998->dev, -1,
diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index 03e55a1..7fe9418 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -173,6 +173,7 @@ static int max8998_get_enable_register(struct regulator_dev *rdev,
 static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int ret, reg, shift = 8;
 	u8 val;
 
@@ -180,7 +181,7 @@ static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	ret = max8998_read_reg(max8998->iodev, reg, &val);
+	ret = max8998_read_reg(i2c, reg, &val);
 	if (ret)
 		return ret;
 
@@ -190,25 +191,27 @@ static int max8998_ldo_is_enabled(struct regulator_dev *rdev)
 static int max8998_ldo_enable(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int reg, shift = 8, ret;
 
 	ret = max8998_get_enable_register(rdev, &reg, &shift);
 	if (ret)
 		return ret;
 
-	return max8998_update_reg(max8998->iodev, reg, 1<<shift, 1<<shift);
+	return max8998_update_reg(i2c, reg, 1<<shift, 1<<shift);
 }
 
 static int max8998_ldo_disable(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int reg, shift = 8, ret;
 
 	ret = max8998_get_enable_register(rdev, &reg, &shift);
 	if (ret)
 		return ret;
 
-	return max8998_update_reg(max8998->iodev, reg, 0, 1<<shift);
+	return max8998_update_reg(i2c, reg, 0, 1<<shift);
 }
 
 static int max8998_get_voltage_register(struct regulator_dev *rdev,
@@ -276,6 +279,7 @@ static int max8998_get_voltage_register(struct regulator_dev *rdev,
 static int max8998_get_voltage(struct regulator_dev *rdev)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int reg, shift = 0, mask, ret;
 	u8 val;
 
@@ -283,7 +287,7 @@ static int max8998_get_voltage(struct regulator_dev *rdev)
 	if (ret)
 		return ret;
 
-	ret = max8998_read_reg(max8998->iodev, reg, &val);
+	ret = max8998_read_reg(i2c, reg, &val);
 	if (ret)
 		return ret;
 
@@ -297,6 +301,7 @@ static int max8998_set_voltage(struct regulator_dev *rdev,
 				int min_uV, int max_uV)
 {
 	struct max8998_data *max8998 = rdev_get_drvdata(rdev);
+	struct i2c_client *i2c = max8998->iodev->i2c;
 	int min_vol = min_uV / 1000, max_vol = max_uV / 1000;
 	int previous_vol = 0;
 	const struct voltage_map_desc *desc;
@@ -330,14 +335,14 @@ static int max8998_set_voltage(struct regulator_dev *rdev,
 	/* wait for RAMP_UP_DELAY if rdev is BUCK1/2 and
 	 * ENRAMP is ON */
 	if (ldo == MAX8998_BUCK1 || ldo == MAX8998_BUCK2) {
-		max8998_read_reg(max8998->iodev, MAX8998_REG_ONOFF4, &val);
+		max8998_read_reg(i2c, MAX8998_REG_ONOFF4, &val);
 		if (val & (1 << 4)) {
 			en_ramp = true;
 			previous_vol = max8998_get_voltage(rdev);
 		}
 	}
 
-	ret = max8998_update_reg(max8998->iodev, reg, i<<shift, mask<<shift);
+	ret = max8998_update_reg(i2c, reg, i<<shift, mask<<shift);
 
 	if (en_ramp == true) {
 		int difference = desc->min + desc->step*i - previous_vol/1000;
diff --git a/include/linux/mfd/max8998-private.h b/include/linux/mfd/max8998-private.h
index 6dc75b3..f0a20cd 100644
--- a/include/linux/mfd/max8998-private.h
+++ b/include/linux/mfd/max8998-private.h
@@ -75,38 +75,18 @@ enum {
 /**
  * struct max8998_dev - max8998 master device for sub-drivers
  * @dev: master device of the chip (can be used to access platform data)
- * @i2c_client: i2c client private data
- * @dev_read():	chip register read function
- * @dev_write(): chip register write function
- * @dev_update(): chip register update function
+ * @i2c: i2c client private data
  * @iolock: mutex for serializing io access
  */
 
 struct max8998_dev {
 	struct device *dev;
-	struct i2c_client *i2c_client;
-	int (*dev_read)(struct max8998_dev *max8998, u8 reg, u8 *dest);
-	int (*dev_write)(struct max8998_dev *max8998, u8 reg, u8 val);
-	int (*dev_update)(struct max8998_dev *max8998, u8 reg, u8 val, u8 mask);
+	struct i2c_client *i2c;
 	struct mutex iolock;
 };
 
-static inline int max8998_read_reg(struct max8998_dev *max8998, u8 reg,
-				   u8 *value)
-{
-	return max8998->dev_read(max8998, reg, value);
-}
-
-static inline int max8998_write_reg(struct max8998_dev *max8998, u8 reg,
-				    u8 value)
-{
-	return max8998->dev_write(max8998, reg, value);
-}
-
-static inline int max8998_update_reg(struct max8998_dev *max8998, u8 reg,
-				     u8 value, u8 mask)
-{
-	return max8998->dev_update(max8998, reg, value, mask);
-}
+extern int max8998_read_reg(struct i2c_client *i2c, u8 reg, u8 *dest);
+extern int max8998_write_reg(struct i2c_client *i2c, u8 reg, u8 value);
+extern int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask);
 
 #endif /*  __LINUX_MFD_MAX8998_PRIV_H */
-- 
1.7.0.4

