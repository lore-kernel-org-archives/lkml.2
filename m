Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0GAPMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 11:12:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48764 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab0GAPMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 11:12:50 -0400
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
To: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "sfking@fdwdc.com" <sfking@fdwdc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 1 Jul 2010 20:42:44 +0530
Subject: [RFC] [PATCH] digital compass hmc5843
Thread-Topic: [RFC] [PATCH] digital compass hmc5843
Thread-Index: AcsZLRJAkKawZBgVSPGOU0powpjtAwAASYhA
Message-ID: <0680EC522D0CC943BC586913CF3768C003B360319D@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for the Honeywell HMC5843. The interface to the device is i2c.
- Comments added
- The interface name of sampling frequency made similar to the convention
- The sysfs entries changed to io device

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/staging/iio/Kconfig                |    1 +
 drivers/staging/iio/Makefile               |    1 +
 drivers/staging/iio/magnetometer/Kconfig   |   15 +
 drivers/staging/iio/magnetometer/Makefile  |    5 +
 drivers/staging/iio/magnetometer/hmc5843.c |  607 ++++++++++++++++++++++++++++
 5 files changed, 629 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/iio/magnetometer/Kconfig
 create mode 100644 drivers/staging/iio/magnetometer/Makefile
 create mode 100644 drivers/staging/iio/magnetometer/hmc5843.c

diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
index b0e6244..569b938 100644
--- a/drivers/staging/iio/Kconfig
+++ b/drivers/staging/iio/Kconfig
@@ -44,6 +44,7 @@ source "drivers/staging/iio/adc/Kconfig"
 source "drivers/staging/iio/gyro/Kconfig"
 source "drivers/staging/iio/imu/Kconfig"
 source "drivers/staging/iio/light/Kconfig"
+source "drivers/staging/iio/magnetometer/Kconfig"

 source "drivers/staging/iio/trigger/Kconfig"

diff --git a/drivers/staging/iio/Makefile b/drivers/staging/iio/Makefile
index 3502b39..10d1f6b 100644
--- a/drivers/staging/iio/Makefile
+++ b/drivers/staging/iio/Makefile
@@ -14,5 +14,6 @@ obj-y += adc/
 obj-y += gyro/
 obj-y += imu/
 obj-y += light/
+obj-y += magnetometer/

 obj-y += trigger/
\ No newline at end of file
diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
new file mode 100644
index 0000000..6c67981
--- /dev/null
+++ b/drivers/staging/iio/magnetometer/Kconfig
@@ -0,0 +1,15 @@
+#
+# Magnetometer sensors
+#
+comment "Magnetometer sensors"
+
+config SENSORS_HMC5843
+       tristate "Honeywell HMC5843 3-Axis Magnetometer"
+       depends on I2C
+       help
+         Say Y here to add support for the Honeywell HMC 5843 3-Axis
+         Magnetometer (digital compass).
+
+         To compile this driver as a module, choose M here: the module
+         will be called hmc5843
+
diff --git a/drivers/staging/iio/magnetometer/Makefile b/drivers/staging/iio/magnetometer/Makefile
new file mode 100644
index 0000000..f9bfb2e
--- /dev/null
+++ b/drivers/staging/iio/magnetometer/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for industrial I/O Magnetometer sensors
+#
+
+obj-$(CONFIG_SENSORS_HMC5843)  += hmc5843.o
diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
new file mode 100644
index 0000000..d741d39
--- /dev/null
+++ b/drivers/staging/iio/magnetometer/hmc5843.c
@@ -0,0 +1,607 @@
+/*  Copyright (c) 2010  Shubhrajyoti Datta <shubhrajyoti@ti.com>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include "../iio.h"
+#include "../sysfs.h"
+#include "magnet.h"
+
+#define HMC5843_I2C_ADDRESS                    0x1E
+
+#define HMC5843_CONFIG_REG_A                   0x00
+#define HMC5843_CONFIG_REG_B                   0x01
+#define HMC5843_MODE_REG                       0x02
+#define HMC5843_DATA_OUT_X_MSB_REG             0x03
+#define HMC5843_DATA_OUT_X_LSB_REG             0x04
+#define HMC5843_DATA_OUT_Y_MSB_REG             0x05
+#define HMC5843_DATA_OUT_Y_LSB_REG             0x06
+#define HMC5843_DATA_OUT_Z_MSB_REG             0x07
+#define HMC5843_DATA_OUT_Z_LSB_REG             0x08
+#define HMC5843_STATUS_REG                     0x09
+#define HMC5843_ID_REG_A                       0x0A
+#define HMC5843_ID_REG_B                       0x0B
+#define HMC5843_ID_REG_C                       0x0C
+
+#define HMC5843_ID_REG_LENGTH                  0x03
+#define HMC5843_ID_STRING                      "H43"
+
+/*
+ * Range settings in  (+-)Ga
+ * */
+#define RANGE_GAIN_OFFSET                      0x05
+
+#define        RANGE_0_7                               0x00
+#define        RANGE_1_0                               0x01 /* default */
+#define        RANGE_1_5                               0x02
+#define        RANGE_2_0                               0x03
+#define        RANGE_3_2                               0x04
+#define        RANGE_3_8                               0x05
+#define        RANGE_4_5                               0x06
+#define        RANGE_6_5                               0x07 /* Not recommended */
+
+/*
+ * Device status
+ */
+#define        DATA_READY                              0x01
+#define        DATA_OUTPUT_LOCK                        0x02
+#define        VOLTAGE_REGULATOR_ENABLED               0x04
+
+/*
+ * Mode register configuration
+ */
+#define        MODE_CONVERSION_CONTINUOUS              0x00
+#define        MODE_CONVERSION_SINGLE                  0x01
+#define        MODE_IDLE                               0x02
+#define        MODE_SLEEP                              0x03
+
+/* Minimum Data Output Rate in 1/10 Hz  */
+#define RATE_OFFSET                            0x02
+#define RATE_BITMASK                           0x1C
+#define        RATE_5                                  0x00
+#define        RATE_10                                 0x01
+#define        RATE_20                                 0x02
+#define        RATE_50                                 0x03
+#define        RATE_100                                0x04
+#define        RATE_200                                0x05
+#define        RATE_500                                0x06
+#define        RATE_NOT_USED                           0x07
+
+/*
+ * Device Configutration
+ */
+#define        CONF_NORMAL                             0x00
+#define        CONF_POSITIVE_BIAS                      0x01
+#define        CONF_NEGATIVE_BIAS                      0x02
+#define        CONF_NOT_USED                           0x03
+#define        MEAS_CONF_MASK                          0x03
+
+static const int regval_to_counts_per_mg[] = {
+       1620,
+       1300,
+       970,
+       780,
+       530,
+       460,
+       390,
+       280
+};
+static const int regval_to_input_field_mg[] = {
+       700,
+       1000,
+       1500,
+       2000,
+       3200,
+       3800,
+       4500,
+       6500
+};
+static const int samp_freq_to_regval[] = {
+       5,
+       10,
+       20,
+       50,
+       100,
+       200,
+       500,
+};
+
+/* Addresses to scan: 0x1E */
+static const unsigned short normal_i2c[] = { HMC5843_I2C_ADDRESS,
+                                                       I2C_CLIENT_END };
+
+/* Each client has this additional data */
+struct hmc5843_data {
+       struct iio_dev  *indio_dev;
+       u8              rate;
+       u8              meas_conf;
+       u8              operating_mode;
+       u8              range;
+};
+
+static void hmc5843_init_client(struct i2c_client *client);
+
+static s32 hmc5843_configure(struct i2c_client *client,
+                                      u8 operating_mode)
+{
+       /* The lower two bits contain the current conversion mode */
+       return i2c_smbus_write_byte_data(client,
+                                       HMC5843_MODE_REG,
+                                       (operating_mode & 0x03));
+}
+
+/* Return the measurement value from the  specified channel */
+
+static ssize_t hmc5843_read_measurement(struct device *dev,
+               struct device_attribute *attr,
+               char *buf)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       s16 coordinate_val;
+       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+       s32 result;
+
+       result = i2c_smbus_read_byte_data(client, HMC5843_STATUS_REG);
+       while (!(result & DATA_READY))
+               result = i2c_smbus_read_byte_data(client, HMC5843_STATUS_REG);
+
+       result = i2c_smbus_read_word_data(client, this_attr->address);
+       if (result < 0)
+               return -EINVAL;
+
+       coordinate_val  = (s16)swab16((u16)result);
+       return sprintf(buf, "%d\n", coordinate_val);
+}
+static IIO_DEV_ATTR_MAGN_X(hmc5843_read_measurement,
+               HMC5843_DATA_OUT_X_MSB_REG);
+static IIO_DEV_ATTR_MAGN_Y(hmc5843_read_measurement,
+               HMC5843_DATA_OUT_Y_MSB_REG);
+static IIO_DEV_ATTR_MAGN_Z(hmc5843_read_measurement,
+               HMC5843_DATA_OUT_Z_MSB_REG);
+/*
+ * From the datasheet
+ * 0 - Continuous-Conversion Mode: In continuous-conversion mode, the
+ * device continuously performs conversions an places the result in the
+ * data register.
+ *
+ * 1 - Single-Conversion Mode : device performs a single measurement,
+ *  sets RDY high and returned to sleep mode
+ *
+ * 2 - Idle Mode :  Device is placed in idle mode.
+ *
+ * 3 - Sleep Mode. Device is placed in sleep mode.
+ *
+ */
+static ssize_t hmc5843_show_operating_mode(struct device *dev,
+                                       struct device_attribute *attr,
+                                       char *buf)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       return sprintf(buf, "%d\n", data->operating_mode);
+}
+static ssize_t hmc5843_set_operating_mode(struct device *dev,
+                               struct device_attribute *attr,
+                               const char *buf,
+                               size_t count)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+       unsigned long operating_mode = 0;
+       s32 status;
+       int error;
+       error = strict_strtoul(buf, 10, &operating_mode);
+       if (error)
+               return error;
+       dev_dbg(dev, "set Conversion mode to %lu\n", operating_mode);
+       if (operating_mode > MODE_SLEEP)
+                       return -EINVAL;
+
+       status = i2c_smbus_write_byte_data(client, this_attr->address,
+                                       operating_mode);
+       if (status)
+               return -EINVAL;
+
+       data->operating_mode = operating_mode;
+       return count;
+}
+static IIO_DEVICE_ATTR(operating_mode,
+                       S_IWUSR | S_IRUGO,
+                       hmc5843_show_operating_mode,
+                       hmc5843_set_operating_mode,
+                       HMC5843_MODE_REG);
+/*
+ * API for setting the measurement configuration to
+ * Normal, Positive bias and Negitive bias
+ * From the datasheet
+ *
+ * Normal measurement configuration (default): In normal measurement
+ * configuration the device follows normal measurement flow. Pins BP and BN
+ * are left floating and high impedance.
+ *
+ * Positive bias configuration: In positive bias configuration, a positive
+ * current is forced across the resistive load on pins BP and BN.
+ *
+ * Negative bias configuration. In negative bias configuration, a negative
+ * current is forced across the resistive load on pins BP and BN.
+ *
+ */
+static s32 hmc5843_set_meas_conf(struct i2c_client *client,
+                                     u8 meas_conf)
+{
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       u8 reg_val;
+       reg_val = (meas_conf & MEAS_CONF_MASK) |  (data->rate << RATE_OFFSET);
+       return i2c_smbus_write_byte_data(client, HMC5843_CONFIG_REG_A, reg_val);
+}
+
+static ssize_t hmc5843_show_measurement_configuration(struct device *dev,
+                                               struct device_attribute *attr,
+                                               char *buf)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       return sprintf(buf, "%d\n", data->meas_conf);
+}
+
+static ssize_t hmc5843_set_measurement_configuration(struct device *dev,
+                                               struct device_attribute *attr,
+                                               const char *buf,
+                                               size_t count)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       unsigned long meas_conf = 0;
+
+       int error = strict_strtoul(buf, 10, &meas_conf);
+       if (error)
+               return error;
+       dev_dbg(dev, "set mode to %lu\n", meas_conf);
+       if (hmc5843_set_meas_conf(client, meas_conf))
+               return -EINVAL;
+       data->meas_conf = meas_conf;
+       return count;
+}
+static IIO_DEVICE_ATTR(meas_conf,
+                       S_IWUSR | S_IRUGO,
+                       hmc5843_show_measurement_configuration,
+                       hmc5843_set_measurement_configuration,
+                       0);
+/*
+ * From Datasheet
+ * The table shows the minimum data output
+ * Value       | Minimum data output rate(Hz)
+ * 0           | 0.5
+ * 1           | 1
+ * 2           | 2
+ * 3           | 5
+ * 4           | 10 (default)
+ * 5           | 20
+ * 6           | 50
+ * 7           | Not used
+ */
+static ssize_t show_avail_samp_freq(struct device *dev,
+                       struct device_attribute *attr, char *buf)
+{
+       char freq[] = {"5 , 10, 20, 50, 100, 200 ,500"};
+       return sprintf(buf, "In units of 1/10 hz: %s\n", freq);
+}
+static IIO_DEV_ATTR_AVAIL_SAMP_FREQ(show_avail_samp_freq);
+
+static s32 hmc5843_set_rate(struct i2c_client *client,
+                               u8 rate)
+{
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       u8 reg_val;
+
+       reg_val = (data->meas_conf) |  (rate << RATE_OFFSET);
+       if (rate >= RATE_NOT_USED) {
+               dev_err(&client->dev,
+                       "This data output rate is not supported \n");
+               return -EINVAL;
+       }
+       return i2c_smbus_write_byte_data(client, HMC5843_CONFIG_REG_A, reg_val);
+}
+
+static ssize_t set_sampling_frequency(struct device *dev,
+                                       struct device_attribute *attr,
+                                       const char *buf, size_t count)
+{
+
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       unsigned long rate = 0;
+       unsigned long reg_val;
+       int error;
+
+       error = strict_strtoul(buf, 10, &rate);
+       if (error)
+               return error;
+       if (rate < 10)
+               reg_val = RATE_5;
+       else if (rate < 20)
+               reg_val = RATE_10;
+       else if (rate < 50)
+               reg_val = RATE_20;
+       else if (rate < 100)
+               reg_val = RATE_50;
+       else if (rate < 200)
+               reg_val = RATE_100;
+       else if (rate < 500)
+               reg_val = RATE_200;
+       else
+               reg_val = RATE_500;
+
+       dev_dbg(dev, "set rate to %lu\n", reg_val);
+       if (hmc5843_set_rate(client, reg_val) == -EINVAL)
+               return -EINVAL;
+       data->rate = rate;
+       return count;
+}
+
+static ssize_t show_sampling_frequency(struct device *dev,
+                       struct device_attribute *attr, char *buf)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+       u32 rate;
+
+       rate = i2c_smbus_read_byte_data(client,  this_attr->address);
+       if (rate < 0)
+               return -EINVAL;
+       rate = (rate & RATE_BITMASK) >> RATE_OFFSET;
+       return sprintf(buf, "%d\n", samp_freq_to_regval[rate]);
+}
+static IIO_DEVICE_ATTR(sampling_frequency,
+                       S_IWUSR | S_IRUGO,
+                       show_sampling_frequency,
+                       set_sampling_frequency,
+                       HMC5843_CONFIG_REG_A);
+/*
+ * From Datasheet
+ *     Nominal gain settings
+ * Value       | Sensor Input Field Range(Ga)  | Gain(counts/ milli-gauss)
+ *0            |(+-)0.7                        |1620
+ *1            |(+-)1.0                        |1300
+ *2            |(+-)1.5                        |970
+ *3            |(+-)2.0                        |780
+ *4            |(+-)3.2                        |530
+ *5            |(+-)3.8                        |460
+ *6            |(+-)4.5                        |390
+ *7            |(+-)6.5                        |280
+ */
+static ssize_t show_range(struct device *dev,
+                               struct device_attribute *attr,
+                               char *buf)
+{
+       u8 range;
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+
+       range = data->range;
+       return sprintf(buf, " %dmGa\n", regval_to_input_field_mg[range]);
+}
+
+static ssize_t set_range(struct device *dev,
+                       struct device_attribute *attr,
+                       const char *buf,
+                       size_t count)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       unsigned long range = 0;
+       int error;
+
+       error = strict_strtoul(buf, 10, &range);
+       if (error)
+               return error;
+       dev_dbg(dev, "set range to %lu\n", range);
+
+       if (range > RANGE_6_5)
+               return -EINVAL;
+
+       data->range = range;
+       range = range << RANGE_GAIN_OFFSET;
+       if (i2c_smbus_write_byte_data(client, this_attr->address, range) ==
+                                                                       -EINVAL)
+               return -EINVAL;
+
+       return count;
+}
+
+static IIO_DEVICE_ATTR(magn_range,
+                       S_IWUSR | S_IRUGO,
+                       show_range,
+                       set_range,
+                       HMC5843_CONFIG_REG_B);
+
+static ssize_t show_gain(struct device *dev,
+                       struct device_attribute *attr,
+                       char *buf)
+{
+       struct iio_dev *indio_dev = dev_get_drvdata(dev);
+       struct i2c_client *client = to_i2c_client(indio_dev->dev.parent);
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       return sprintf(buf, "%d\n", regval_to_counts_per_mg[data->range]);
+}
+static IIO_DEVICE_ATTR(magn_gain, S_IRUGO, show_gain, NULL , 0);
+
+
+static struct attribute *hmc5843_attributes[] = {
+       &iio_dev_attr_meas_conf.dev_attr.attr,
+       &iio_dev_attr_operating_mode.dev_attr.attr,
+       &iio_dev_attr_sampling_frequency.dev_attr.attr,
+       &iio_dev_attr_magn_range.dev_attr.attr,
+       &iio_dev_attr_magn_gain.dev_attr.attr,
+       &iio_dev_attr_magn_x_raw.dev_attr.attr,
+       &iio_dev_attr_magn_y_raw.dev_attr.attr,
+       &iio_dev_attr_magn_z_raw.dev_attr.attr,
+       &iio_dev_attr_available_sampling_frequency.dev_attr.attr,
+       NULL
+};
+
+static const struct attribute_group hmc5843_group = {
+       .attrs = hmc5843_attributes,
+};
+
+static int hmc5843_detect(struct i2c_client *client,
+                         struct i2c_board_info *info)
+{
+       unsigned char id_str[HMC5843_ID_REG_LENGTH];
+
+       if (client->addr != HMC5843_I2C_ADDRESS)
+               return -ENODEV;
+
+       if (i2c_smbus_read_i2c_block_data(client, HMC5843_ID_REG_A,
+                               HMC5843_ID_REG_LENGTH, id_str)
+                       != HMC5843_ID_REG_LENGTH)
+               return -ENODEV;
+
+       if (0 != strncmp(id_str, HMC5843_ID_STRING, HMC5843_ID_REG_LENGTH))
+               return -ENODEV;
+
+       return 0;
+}
+
+/* Called when we have found a new HMC5843. */
+static void hmc5843_init_client(struct i2c_client *client)
+{
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       hmc5843_set_meas_conf(client, data->meas_conf);
+       hmc5843_set_rate(client, data->rate);
+       hmc5843_configure(client, data->operating_mode);
+       i2c_smbus_write_byte_data(client, HMC5843_CONFIG_REG_B, data->range);
+       pr_info("HMC5843 initialized\n");
+}
+
+static int hmc5843_probe(struct i2c_client *client,
+                        const struct i2c_device_id *id)
+{
+       struct hmc5843_data *data;
+       int err = 0;
+
+       data = kzalloc(sizeof(struct hmc5843_data), GFP_KERNEL);
+       if (!data) {
+               err = -ENOMEM;
+               goto exit;
+       }
+
+       /* default settings at probe */
+
+       data->meas_conf = CONF_NORMAL;
+       data->range = RANGE_1_0;
+       data->operating_mode = MODE_CONVERSION_CONTINUOUS;
+
+       i2c_set_clientdata(client, data);
+
+       /* Initialize the HMC5843 chip */
+       hmc5843_init_client(client);
+
+       data->indio_dev = iio_allocate_device();
+       if (!data->indio_dev) {
+               err = -ENOMEM;
+               goto exit_free;
+       }
+       data->indio_dev->attrs = &hmc5843_group;
+       data->indio_dev->dev.parent = &client->dev;
+       data->indio_dev->dev_data = (void *)(data);
+       data->indio_dev->driver_module = THIS_MODULE;
+       data->indio_dev->modes = INDIO_DIRECT_MODE;
+       err = iio_device_register(data->indio_dev);
+       if (err)
+               goto exit_free;
+       return 0;
+exit_free:
+       kfree(data);
+exit:
+       return err;
+}
+
+static int hmc5843_remove(struct i2c_client *client)
+{
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+        /*  sleep mode to save power */
+       hmc5843_configure(client, MODE_SLEEP);
+       iio_device_unregister(data->indio_dev);
+       sysfs_remove_group(&client->dev.kobj, &hmc5843_group);
+       kfree(i2c_get_clientdata(client));
+       return 0;
+}
+
+static int hmc5843_suspend(struct i2c_client *client, pm_message_t mesg)
+{
+       hmc5843_configure(client, MODE_SLEEP);
+       return 0;
+}
+
+static int hmc5843_resume(struct i2c_client *client)
+{
+       struct hmc5843_data *data = i2c_get_clientdata(client);
+       hmc5843_configure(client, data->operating_mode);
+       return 0;
+}
+
+static const struct i2c_device_id hmc5843_id[] = {
+       { "hmc5843", 0 },
+       { }
+};
+
+static struct i2c_driver hmc5843_driver = {
+       .driver = {
+               .name   = "hmc5843",
+       },
+       .id_table       = hmc5843_id,
+       .probe          = hmc5843_probe,
+       .remove         = hmc5843_remove,
+       .detect         = hmc5843_detect,
+       .address_list   = normal_i2c,
+       .suspend        = hmc5843_suspend,
+       .resume         = hmc5843_resume,
+};
+
+static int __init hmc5843_init(void)
+{
+       printk(KERN_INFO "init!\n");
+       return i2c_add_driver(&hmc5843_driver);
+}
+
+static void __exit hmc5843_exit(void)
+{
+       printk(KERN_INFO "exit!\n");
+       i2c_del_driver(&hmc5843_driver);
+}
+
+MODULE_AUTHOR("Shubhrajyoti Datta <shubhrajyoti@ti.com");
+MODULE_DESCRIPTION("HMC5843 driver");
+MODULE_LICENSE("GPL");
+
+module_init(hmc5843_init);
+module_exit(hmc5843_exit);
--
1.5.4.7

