Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab0FKMJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 08:09:19 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:40728 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab0FKMJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 08:09:18 -0400
Date: Fri, 11 Jun 2010 14:09:10 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] smb380: accelerometer driver
Message-ID: <20100611120910.GY17833@buzzloop.caiaq.de>
References: <4C1216FD.6010107@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C1216FD.6010107@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 07:59:09PM +0900, Donggeun Kim wrote:
> This patch support driver for BOSCH SMB380 and BMA023.
> 
> This driver will read x, y, z coordinate registers from the device and
> report the values to users through sysfs interface.

Hmm, the patch is line-wrapped, and there seems to be something wrong
with indentation as well. Please consider using 'git send-email' and
have a look at Documentation/CodingSytle when resubmitting. Thanks :)

Daniel


> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> drivers/hwmon/Kconfig | 8 +
> drivers/hwmon/Makefile | 1 +
> drivers/hwmon/smb380.c | 572
> ++++++++++++++++++++++++++++++++++++++++++++++++
> include/linux/smb380.h | 20 ++
> 4 files changed, 601 insertions(+), 0 deletions(-)
> create mode 100644 drivers/hwmon/smb380.c
> create mode 100644 include/linux/smb380.h
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index e19cf8e..f68f47e 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1118,6 +1118,14 @@ config SENSORS_MC13783_ADC
> help
> Support for the A/D converter on MC13783 PMIC.
> 
> +config SENSORS_SMB380
> + tristate "SMB380 Triaxial acceleration sensor"
> + depends on HWMON && I2C
> + help
> + This driver provides support for the Bosch Sensortec Triaxial
> + Acceleration Sensor IC, which provides measurements of acceleration
> + in prependicular axes as well as absolute temperature measurement.
> +
> if ACPI
> 
> comment "ACPI drivers"
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 2138ceb..a840540 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -103,6 +103,7 @@ obj-$(CONFIG_SENSORS_W83L785TS) += w83l785ts.o
> obj-$(CONFIG_SENSORS_W83L786NG) += w83l786ng.o
> obj-$(CONFIG_SENSORS_WM831X) += wm831x-hwmon.o
> obj-$(CONFIG_SENSORS_WM8350) += wm8350-hwmon.o
> +obj-$(CONFIG_SENSORS_SMB380) += smb380.o
> 
> ifeq ($(CONFIG_HWMON_DEBUG_CHIP),y)
> EXTRA_CFLAGS += -DDEBUG
> diff --git a/drivers/hwmon/smb380.c b/drivers/hwmon/smb380.c
> new file mode 100644
> index 0000000..02a77ba
> --- /dev/null
> +++ b/drivers/hwmon/smb380.c
> @@ -0,0 +1,572 @@
> +/*
> + * smb380.c - SMB380 Tri-axis accelerometer driver
> + *
> + * Copyright (c) 2009 Samsung Eletronics
> + * Kim Kyuwon <q1.kim@samsung.com>
> + * Kyungmin Park <kyungmin.park@samsung.com>
> + * Donggeun Kim <dg77.kim@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/workqueue.h>
> +#include <linux/mutex.h>
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/smb380.h>
> +
> +#define SMB380_CHIP_ID_REG 0x00
> +#define SMB380_X_LSB_REG 0x02
> +#define SMB380_X_MSB_REG 0x03
> +#define SMB380_Y_LSB_REG 0x04
> +#define SMB380_Y_MSB_REG 0x05
> +#define SMB380_Z_LSB_REG 0x06
> +#define SMB380_Z_MSB_REG 0x07
> +#define SMB380_TEMP_REG 0x08
> +#define SMB380_CTRL1_REG 0x0a
> +#define SMB380_CTRL2_REG 0x0b
> +#define SMB380_SETTINGS1_REG 0x0c
> +#define SMB380_SETTINGS2_REG 0x0d
> +#define SMB380_SETTINGS3_REG 0x0e
> +#define SMB380_SETTINGS4_REG 0x0f
> +#define SMB380_SETTINGS5_REG 0x10
> +#define SMB380_SETTINGS6_REG 0x11
> +#define SMB380_RANGE_BW_REG 0x14
> +#define SMB380_CONF2_REG 0x15
> +
> +#define SMB380_ENABLE_ADV_INT_SHIFT 6
> +#define SMB380_ENABLE_ADV_INT_MASK (0x1 << 6)
> +#define SMB380_NEW_DATA_INT_SHIFT 5
> +#define SMB380_NEW_DATA_INT_MASK (0x1 << 5)
> +#define SMB380_LATCH_INT_SHIFT 4
> +#define SMB380_LATCH_INT_MASK (0x1 << 4)
> +#define SMB380_SHADOW_DIS_SHIFT 3
> +#define SMB380_SHADOW_DIS_MASK (0x1 << 3)
> +#define SMB380_WAKEUP_PAUSE_SHIFT 1
> +#define SMB380_WAKEUP_PAUSE_MASK (0x3 << 1)
> +#define SMB380_WAKEUP_SHIFT 0
> +#define SMB380_WAKEUP_MASK (0x1)
> +
> +#define SMB380_RANGE_SHIFT 3
> +#define SMB380_RANGE_MASK (0x3 << 3)
> +#define SMB380_BANDWIDTH_SHIFT 0
> +#define SMB380_BANDWIDTH_MASK (0x7)
> +
> +#define SMB380_ANY_MOTION_DUR_SHIFT 6
> +#define SMB380_ANY_MOTION_DUR_MASK (0x3 << 6)
> +#define SMB380_HG_HYST_SHIFT 3
> +#define SMB380_HG_HYST_MASK (0x7 << 3)
> +#define SMB380_LG_HYST_SHIFT 0
> +#define SMB380_LG_HYST_MASK (0x7)
> +
> +#define SMB380_ANY_MOTION_THRES_MASK (0xff)
> +#define SMB380_HG_DUR_MASK (0xff)
> +#define SMB380_HG_THRES_MASK (0xff)
> +#define SMB380_LG_DUR_MASK (0xff)
> +#define SMB380_LG_THRES_MASK (0xff)
> +
> +#define SMB380_ALERT_SHIFT 7
> +#define SMB380_ALERT_MASK (0x1 << 7)
> +#define SMB380_ANY_MOTION_SHIFT 6
> +#define SMB380_ANY_MOTION_MASK (0x1 << 6)
> +#define SMB380_COUNTER_HG_SHIFT 4
> +#define SMB380_COUNTER_HG_MASK (0x3 << 4)
> +#define SMB380_COUNTER_LG_SHIFT 2
> +#define SMB380_COUNTER_LG_MASK (0x3 << 2)
> +#define SMB380_ENABLE_HG_SHIFT 1
> +#define SMB380_ENABLE_HG_MASK (0x1 << 1)
> +#define SMB380_ENABLE_LG_SHIFT 0
> +#define SMB380_ENABLE_LG_MASK (0x1)
> +
> +#define SMB380_RESET_INT_SHIFT 6
> +#define SMB380_RESET_INT_MASK (0x1 << 6)
> +#define SMB380_SELF_TEST1_SHIFT 3
> +#define SMB380_SELF_TEST1_MASK (0x1 << 3)
> +#define SMB380_SELF_TEST0_SHIFT 2
> +#define SMB380_SELF_TEST0_MASK (0x1 << 2)
> +#define SMB380_SOFT_RESET_SHIFT 1
> +#define SMB380_SOFT_RESET_MASK (0x1 << 1)
> +#define SMB380_SLEEP_SHIFT 0
> +#define SMB380_SLEEP_MASK (0x1)
> +
> +#define SMB380_ST_RESULT_SHIFT 7
> +#define SMB380_ST_RESULT_MASK (0x1 << 7)
> +#define SMB380_ALERT_PHASE_SHIFT 4
> +#define SMB380_ALERT_PHASE_MASK (0x1 << 4)
> +#define SMB380_LG_LATCHED_SHIFT 3
> +#define SMB380_LG_LATCHED_MASK (0x1 << 3)
> +#define SMB380_HG_LATCHED_SHIFT 2
> +#define SMB380_HG_LATCHED_MASK (0x1 << 2)
> +#define SMB380_STATUS_LG_SHIFT 1
> +#define SMB380_STATUS_LG_MASK (0x1 << 1)
> +#define SMB380_STATUS_HG_SHIFT 0
> +#define SMB380_STATUS_HG_MASK (0x1)
> +
> +#define SMB380_ACCEL_BITS 10
> +
> +struct smb380_data {
> + s16 x;
> + s16 y;
> + s16 z;
> + u8 temp;
> +};
> +
> +enum scale_range {
> + RANGE_2G,
> + RANGE_4G,
> + RANGE_8G,
> +};
> +
> +/* Used to setup the digital filtering bandwitdh of ADC output */
> +enum filter_bw {
> + BW_25HZ,
> + BW_50HZ,
> + BW_100HZ,
> + BW_190HZ,
> + BW_375HZ,
> + BW_750HZ,
> + BW_1500HZ,
> +};
> +
> +struct smb380_sensor {
> + struct i2c_client *client;
> + struct device *dev;
> + struct work_struct work;
> + struct mutex lock;
> +
> + int (*trans_matrix)[3];
> + struct smb380_data data;
> +};
> +
> +static int smb380_write_reg(struct i2c_client *client, u8 reg, u8 val)
> +{
> + int ret;
> +
> + /*
> + * Accorting to the datasheet, the interrupt should be deactivated
> + * on the microprocessor side when write sequences are operated
> + */
> + disable_irq_nosync(client->irq);
> + ret = i2c_smbus_write_byte_data(client, reg, val);
> + enable_irq(client->irq);
> +
> + if (ret < 0)
> + dev_err(&client->dev, "%s: reg 0x%x, val 0x%x, err %d\n",
> + __func__, reg, val, ret);
> + return ret;
> +}
> +
> +static int smb380_read_reg(struct i2c_client *client, u8 reg)
> +{
> + int ret = i2c_smbus_read_byte_data(client, reg);
> +
> + if (ret < 0)
> + dev_err(&client->dev, "%s: reg 0x%x, err %d\n",
> + __func__, reg, ret);
> + return ret;
> +}
> +
> +static int smb380_xyz_read_reg(struct i2c_client *client,
> + u8 *buffer, int length)
> +{
> + struct i2c_msg msg[] = {
> + {
> + .addr = client->addr,
> + .flags = 0,
> + .len = 1,
> + .buf = buffer,
> + }, {
> + .addr = client->addr,
> + .flags = I2C_M_RD,
> + .len = length,
> + .buf = buffer,
> + },
> + };
> + return i2c_transfer(client->adapter, msg, 2);
> +}
> +
> +static int smb380_set_reg_bits(struct i2c_client *client,
> + int val, int shift, u8 mask, u8 reg)
> +{
> + u8 data = smb380_read_reg(client, reg);
> +
> + data = (data & ~mask) | ((val << shift) & mask);
> + return smb380_write_reg(client, reg, data);
> +}
> +
> +static int smb380_set_range(struct i2c_client *client, enum scale_range
> range)
> +{
> + return smb380_set_reg_bits(client, range,
> + SMB380_RANGE_SHIFT,
> + SMB380_RANGE_MASK,
> + SMB380_RANGE_BW_REG);
> +}
> +
> +static int smb380_set_bandwidth(struct i2c_client *client, enum
> filter_bw bw)
> +{
> + return smb380_set_reg_bits(client, bw,
> + SMB380_BANDWIDTH_SHIFT,
> + SMB380_BANDWIDTH_MASK,
> + SMB380_RANGE_BW_REG);
> +}
> +
> +static int smb380_set_new_data_int(struct i2c_client *client, u8 on)
> +{
> + return smb380_set_reg_bits(client, on,
> + SMB380_NEW_DATA_INT_SHIFT,
> + SMB380_NEW_DATA_INT_MASK,
> + SMB380_CONF2_REG);
> +}
> +
> +static int smb380_set_HG_int(struct i2c_client *client, u8 on)
> +{
> + return smb380_set_reg_bits(client, on,
> + SMB380_ENABLE_HG_SHIFT,
> + SMB380_ENABLE_HG_MASK,
> + SMB380_CTRL2_REG);
> +}
> +
> +static int smb380_set_LG_int(struct i2c_client *client, u8 on)
> +{
> + return smb380_set_reg_bits(client, on,
> + SMB380_ENABLE_LG_SHIFT,
> + SMB380_ENABLE_LG_MASK,
> + SMB380_CTRL2_REG);
> +}
> +
> +static int smb380_set_LG_dur(struct i2c_client *client, u8 dur)
> +{
> + return smb380_set_reg_bits(client, dur,
> + 0, SMB380_LG_DUR_MASK,
> + SMB380_SETTINGS2_REG);
> +}
> +
> +static int smb380_set_LG_thres(struct i2c_client *client, u8 thres)
> +{
> + return smb380_set_reg_bits(client, thres,
> + 0, SMB380_LG_THRES_MASK,
> + SMB380_SETTINGS1_REG);
> +}
> +
> +static int smb380_set_LG_hyst(struct i2c_client *client, u8 hyst)
> +{
> + return smb380_set_reg_bits(client, hyst,
> + SMB380_LG_HYST_SHIFT,
> + SMB380_LG_HYST_MASK,
> + SMB380_SETTINGS6_REG);
> +}
> +
> +static int smb380_set_HG_dur(struct i2c_client *client, u8 dur)
> +{
> + return smb380_set_reg_bits(client, dur,
> + 0, SMB380_HG_DUR_MASK,
> + SMB380_SETTINGS4_REG);
> +}
> +
> +static int smb380_set_HG_thres(struct i2c_client *client, u8 thres)
> +{
> + return smb380_set_reg_bits(client, thres,
> + 0, SMB380_HG_THRES_MASK,
> + SMB380_SETTINGS3_REG);
> +}
> +
> +static int smb380_set_HG_hyst(struct i2c_client *client, u8 hyst)
> +{
> + return smb380_set_reg_bits(client, hyst,
> + SMB380_HG_HYST_SHIFT,
> + SMB380_HG_HYST_MASK,
> + SMB380_SETTINGS6_REG);
> +}
> +
> +static int smb380_set_sleep(struct i2c_client *client, u8 on)
> +{
> + return smb380_set_reg_bits(client, on,
> + SMB380_SLEEP_SHIFT,
> + SMB380_SLEEP_MASK,
> + SMB380_CTRL1_REG);
> +}
> +
> +/*
> + * The description of the digital signals x, y and z is "2' complement".
> + * So we need to correct the sign of data read by i2c.
> + */
> +static inline void smb380_correct_accel_sign(s16 *val)
> +{
> + *val <<= (sizeof(s16) * BITS_PER_BYTE - SMB380_ACCEL_BITS);
> + *val >>= (sizeof(s16) * BITS_PER_BYTE - SMB380_ACCEL_BITS);
> +}
> +
> +static void smb380_read_x(struct i2c_client *client, s16 *x,
> + u8 *x_lsb, u8 *x_msb)
> +{
> + *x = (*x_msb << 2) | (*x_lsb >> 6);
> + smb380_correct_accel_sign(x);
> +}
> +
> +static void smb380_read_y(struct i2c_client *client, s16 *y,
> + u8 *y_lsb, u8 *y_msb)
> +{
> + *y = (*y_msb << 2) | (*y_lsb >> 6);
> + smb380_correct_accel_sign(y);
> +}
> +
> +static void smb380_read_z(struct i2c_client *client, s16 *z,
> + u8 *z_lsb, u8 *z_msb)
> +{
> + *z = (*z_msb << 2) | (*z_lsb >> 6);
> + smb380_correct_accel_sign(z);
> +}
> +
> +/*
> + * Read 8 bit temperature.
> + * An output of 0 equals -30C, 1 LSB equals 0.5C
> + */
> +static void smb380_read_temperature(struct i2c_client *client, u8 *temper)
> +{
> + *temper = smb380_read_reg(client, SMB380_TEMP_REG);
> +
> + dev_dbg(&client->dev, "%s: %d\n", __func__, *temper);
> +}
> +
> +static void smb380_read_xyz(struct i2c_client *client,
> + s16 *x, s16 *y, s16 *z)
> +{
> + u8 buffer[6];
> + buffer[0] = SMB380_X_LSB_REG;
> + smb380_xyz_read_reg(client, buffer, 6);
> +
> + smb380_read_x(client, x, &buffer[0], &buffer[1]);
> + smb380_read_y(client, y, &buffer[2], &buffer[3]);
> + smb380_read_z(client, z, &buffer[4], &buffer[5]);
> +
> + dev_dbg(&client->dev, "%s: x %d, y %d, z %d\n", __func__, *x, *y, *z);
> +}
> +
> +static ssize_t smb380_show_xyz(struct device *dev,
> + struct device_attribute *attr, char *buf)
> +{
> + struct smb380_sensor *sensor = dev_get_drvdata(dev);
> + int (*trans_matrix)[3] = sensor->trans_matrix;
> + s16 tmp_x, tmp_y, tmp_z;
> +
> + smb380_read_xyz(sensor->client,
> + &sensor->data.x, &sensor->data.y, &sensor->data.z);
> +
> + tmp_x = sensor->data.x;
> + tmp_y = sensor->data.y;
> + tmp_z = sensor->data.z;
> +
> + sensor->data.x = tmp_x * *(*(trans_matrix)) +
> + tmp_y * *(*(trans_matrix) + 1) +
> + tmp_z * *(*(trans_matrix) + 2);
> + sensor->data.y = tmp_x * *(*(trans_matrix + 1)) +
> + tmp_y * *(*(trans_matrix + 1) + 1) +
> + tmp_z * *(*(trans_matrix + 1) + 2);
> + sensor->data.z = tmp_x * *(*(trans_matrix + 2)) +
> + tmp_y * *(*(trans_matrix + 2) + 1) +
> + tmp_z * *(*(trans_matrix + 2) + 2);
> +
> + return sprintf(buf, "%d, %d, %d\n",
> + sensor->data.x, sensor->data.y, sensor->data.z);
> +}
> +static SENSOR_DEVICE_ATTR(xyz, S_IRUGO, smb380_show_xyz, NULL, 0);
> +
> +static ssize_t smb380_show_temper(struct device *dev,
> + struct device_attribute *attr, char *buf)
> +{
> + struct smb380_sensor *sensor = dev_get_drvdata(dev);
> + u8 temper;
> +
> + smb380_read_temperature(sensor->client, &temper);
> + return sprintf(buf, "%d\n", temper);
> +}
> +static SENSOR_DEVICE_ATTR(temperature, S_IRUGO, smb380_show_temper,
> NULL, 0);
> +
> +static struct attribute *smb380_attributes[] = {
> + &sensor_dev_attr_xyz.dev_attr.attr,
> + &sensor_dev_attr_temperature.dev_attr.attr,
> + NULL
> +};
> +
> +static const struct attribute_group smb380_group = {
> + .attrs = smb380_attributes,
> +};
> +
> +static void smb380_work(struct work_struct *work)
> +{
> + struct smb380_sensor *sensor =
> + container_of(work, struct smb380_sensor, work);
> +
> + smb380_read_xyz(sensor->client,
> + &sensor->data.x, &sensor->data.y, &sensor->data.z);
> + smb380_read_temperature(sensor->client, &sensor->data.temp);
> +
> + enable_irq(sensor->client->irq);
> +}
> +
> +static irqreturn_t smb380_irq(int irq, void *dev_id)
> +{
> + struct smb380_sensor *sensor = dev_id;
> +
> + if (!work_pending(&sensor->work)) {
> + disable_irq_nosync(irq);
> + schedule_work(&sensor->work);
> + }
> +
> + return IRQ_HANDLED;
> +}
> +
> +static void smb380_initialize(struct smb380_sensor *sensor)
> +{
> + smb380_set_range(sensor->client, RANGE_2G);
> + smb380_set_bandwidth(sensor->client, BW_25HZ);
> + smb380_set_new_data_int(sensor->client, 0);
> + smb380_set_HG_dur(sensor->client, 0x96);
> + smb380_set_HG_thres(sensor->client, 0xa0);
> + smb380_set_HG_hyst(sensor->client, 0x0);
> + smb380_set_LG_dur(sensor->client, 0x96);
> + smb380_set_LG_thres(sensor->client, 0x14);
> + smb380_set_LG_hyst(sensor->client, 0x0);
> + smb380_set_HG_int(sensor->client, 1);
> + smb380_set_LG_int(sensor->client, 1);
> +}
> +
> +static int __devinit smb380_probe(struct i2c_client *client,
> + const struct i2c_device_id *id)
> +{
> + struct smb380_sensor *sensor;
> + int ret;
> +
> + sensor = kzalloc(sizeof(struct smb380_sensor), GFP_KERNEL);
> + if (!sensor) {
> + dev_err(&client->dev, "failed to allocate driver data\n");
> + return -ENOMEM;
> + }
> +
> + sensor->client = client;
> + sensor->trans_matrix = ((struct smb380_platform_data *)
> + (client->dev.platform_data))->trans_matrix;
> + i2c_set_clientdata(client, sensor);
> +
> + ret = smb380_read_reg(client, SMB380_CHIP_ID_REG);
> + if (ret < 0) {
> + dev_err(&client->dev, "failed to detect device\n");
> + goto failed_free;
> + }
> +
> + INIT_WORK(&sensor->work, smb380_work);
> + mutex_init(&sensor->lock);
> +
> + ret = sysfs_create_group(&client->dev.kobj, &smb380_group);
> + if (ret) {
> + dev_err(&client->dev, "Creating attribute group failed");
> + goto failed_free;
> + }
> +
> + sensor->dev = hwmon_device_register(&client->dev);
> + if (IS_ERR(sensor->dev)) {
> + dev_err(&client->dev, "Registering to hwmon device is failed");
> + ret = PTR_ERR(sensor->dev);
> + goto failed_remove_sysfs;
> + }
> +
> + if (client->irq > 0) {
> + ret = request_irq(client->irq, smb380_irq, IRQF_TRIGGER_HIGH,
> + "smb380 accelerometer", sensor);
> + if (ret) {
> + dev_err(&client->dev, "can't get IRQ %d, ret %d\n",
> + client->irq, ret);
> + goto failed_unregister_hwmon;
> + }
> + }
> +
> + smb380_initialize(sensor);
> +
> + dev_info(&client->dev, "%s registered\n", id->name);
> + return 0;
> +
> +failed_unregister_hwmon:
> + hwmon_device_unregister(sensor->dev);
> +failed_remove_sysfs:
> + sysfs_remove_group(&client->dev.kobj, &smb380_group);
> +failed_free:
> + i2c_set_clientdata(client, NULL);
> + kfree(sensor);
> + return ret;
> +}
> +
> +static int __devexit smb380_remove(struct i2c_client *client)
> +{
> + struct smb380_sensor *sensor = i2c_get_clientdata(client);
> +
> + free_irq(client->irq, sensor);
> + hwmon_device_unregister(sensor->dev);
> + sysfs_remove_group(&client->dev.kobj, &smb380_group);
> + i2c_set_clientdata(client, NULL);
> + kfree(sensor);
> + return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int smb380_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> + smb380_set_sleep(client, 1);
> +
> + return 0;
> +}
> +
> +static int smb380_resume(struct i2c_client *client)
> +{
> + smb380_set_sleep(client, 0);
> +
> + return 0;
> +}
> +
> +#else
> +#define smb380_suspend NULL
> +#define smb380_resume NULL
> +
> +#endif
> +
> +static const struct i2c_device_id smb380_ids[] = {
> + { "smb380", 0 },
> + { "bma023", 1 },
> + { }
> +};
> +MODULE_DEVICE_TABLE(i2c, smb380_ids);
> +
> +static struct i2c_driver smb380_i2c_driver = {
> + .driver = {
> + .name = "smb380",
> + },
> + .probe = smb380_probe,
> + .remove = __devexit_p(smb380_remove),
> + .suspend = smb380_suspend,
> + .resume = smb380_resume,
> + .id_table = smb380_ids,
> +};
> +
> +static int __init smb380_init(void)
> +{
> + return i2c_add_driver(&smb380_i2c_driver);
> +}
> +module_init(smb380_init);
> +
> +static void __exit smb380_exit(void)
> +{
> + i2c_del_driver(&smb380_i2c_driver);
> +}
> +module_exit(smb380_exit);
> +
> +MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
> +MODULE_DESCRIPTION("SMB380/BMA023 Tri-axis accelerometer driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/smb380.h b/include/linux/smb380.h
> new file mode 100644
> index 0000000..15e6c3e
> --- /dev/null
> +++ b/include/linux/smb380.h
> @@ -0,0 +1,20 @@
> +/*
> + * smb380.h - SMB380 Tri-axis accelerometer driver
> + *
> + * Copyright (c) 2009 Samsung Eletronics
> + * Kyungmin Park <kyungmin.park@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#ifndef _SMB380_H_
> +#define _SMB380_H_
> +
> +struct smb380_platform_data {
> + int trans_matrix[3][3];
> +};
> +
> +#endif /* _SMB380_H_ */
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
