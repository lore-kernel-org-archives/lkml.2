Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab0FKL60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:58:26 -0400
Received: from ppsw-32.csi.cam.ac.uk ([131.111.8.132]:35648 "EHLO
	ppsw-32.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab0FKL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:58:25 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C1224AE.6070607@jic23.retrosnub.co.uk>
Date: Fri, 11 Jun 2010 12:57:34 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100426 Thunderbird/3.0.4
MIME-Version: 1.0
To: Donggeun Kim <dg77.kim@samsung.com>
CC: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] smb380: accelerometer driver
References: <4C1216FD.6010107@samsung.com>
In-Reply-To: <4C1216FD.6010107@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/10 11:59, Donggeun Kim wrote:
> This patch support driver for BOSCH SMB380 and BMA023.
> 
> This driver will read x, y, z coordinate registers from the device and
> report the values to users through sysfs interface.
Nack. This should not be in hwmon.

Where to put it is a bit use dependent. Dmitry might
take it into input if you can convince him that its
primary use is human input. I'm happy to take it
in IIO or if you prefer not to go in staging, then 
drivers/misc is the remaining option.  Conversion to 
misc or IIO would be pretty trivial, though we would
want to see a few more attributes to allow userspace
to know what it is getting from the device.

Also please consult MAINTAINERS. If you did believe
this was suitable for hwmon it should have gone to the
relevant mailing list (lm-sensors).

A few coments inline below, Mostly nice and clean, but
a few naming changes and additions of documentation would
make it clearer for future readers.

This is a very basic driver at the moment. I'd personally
like to see a few of the options you have control functions
for exposed to userspace (e.g. range). Still that shouldn't
hold back merging the driver as those who want the can
add them!

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
Looks like a formatting quirk here, might be an email client
issue. Have you run this through checkpatch.pl?
> + dev_err(&client->dev, "%s: reg 0x%x, err %d\n",
> + __func__, reg, ret);
> + return ret;
> +}
> +
This has some slightly odd semantics, perhaps a comment 
explaining the parameters?
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
I'm not personally convince that all of these functions make
the code easier to read. As things currently stand they are
only used on init so I would put the content in there rather
than wrapping it again.
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
The next three look idenitical to me. Why the seperate 
functions?
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

These functions are confusingly named.  They do data
conversion not reading from the device.  Please rename.
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
units?  Please match existing interfaces where possible. 
whether these 3 things can be grouped is dependent on whether
they are guaranteed to be from the same 'scan' (e.g. pretty
close to being taken at the same time.)  If not, then
should probably be 3 seperate attributes. Again, userspace
needs to know units or how to convert.  Again IIO has a standard
interface for this. Please take a look, we spent a fair bit
of time pinning down what people needed at how to make it as
general as possible.

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

units etc?  Please match against a standard interface where
possible. Actually this is the only thing that can be sensibly
lifted from hwmon.  Their interfaces definition is sensible and
pretty general. It's extended in IIO for things it doesn't cover
but we try to match where we can.  


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

magic numbers.  Please comment on what these mean
and comment on why the repeats...
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
worth checking the result against a known value?
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
> + if (client->irq > 0){
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

