Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1KGPDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:03:03 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55953 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab1KGPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:02:58 -0500
From: jic23@cam.ac.uk
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 4/6] IIO:light:tsl2563 initial move out of staging.
Date: Mon,  7 Nov 2011 14:52:41 +0000
Message-Id: <1320677563-18378-5-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
References: <1320677563-18378-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Kucheria <amit.kucheria@verdurent.com>

Driver has had all event related elements stripped out leaving just
the raw sysfs reads for now.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/iio/Kconfig         |    1 +
 drivers/iio/Makefile        |    1 +
 drivers/iio/light/Kconfig   |   16 +
 drivers/iio/light/Makefile  |    6 +
 drivers/iio/light/tsl2563.c |  654 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/iio/tsl2563.h |    8 +
 6 files changed, 686 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index f1e8a22..5dcd9e5 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -12,5 +12,6 @@ menuconfig IIO
 if IIO
 
 source "drivers/iio/adc/Kconfig"
+source "drivers/iio/light/Kconfig"
 
 endif # IIO
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 42d6d12..0e59946 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_IIO) += iio.o
 industrialio-y := core.o
 
 obj-y += adc/
+obj-y += light/
diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
new file mode 100644
index 0000000..6282ce0
--- /dev/null
+++ b/drivers/iio/light/Kconfig
@@ -0,0 +1,16 @@
+#
+# IIO Light Sensor Drivers
+#
+menu "Light Sensors"
+
+config IIO_TSL2563
+tristate "TAOS TSL2560, TSL2561, TSL2562 and TSL2563 ambient light sensors"
+	depends on I2C
+	help
+	 If you say yes here you get support for the Taos TSL2560,
+	 TSL2561, TSL2562 and TSL2563 ambient light sensors.
+
+	 This driver can also be built as a module.  If so, the module
+	 will be called iio_tsl2563.
+
+endmenu
diff --git a/drivers/iio/light/Makefile b/drivers/iio/light/Makefile
new file mode 100644
index 0000000..f7fe4fd
--- /dev/null
+++ b/drivers/iio/light/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for IIO Light Sensors
+#
+
+iio_tsl2563-y := tsl2563.o
+obj-$(CONFIG_IIO_MAX1363) += iio_tsl2563.o
diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
new file mode 100644
index 0000000..c4abe07
--- /dev/null
+++ b/drivers/iio/light/tsl2563.c
@@ -0,0 +1,654 @@
+/*
+ * drivers/i2c/chips/tsl2563.c
+ *
+ * Copyright (C) 2008 Nokia Corporation
+ *
+ * Written by Timo O. Karjalainen <timo.o.karjalainen@nokia.com>
+ * Contact: Amit Kucheria <amit.kucheria@verdurent.com>
+ *
+ * Converted to IIO driver
+ * Amit Kucheria <amit.kucheria@verdurent.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include <linux/iio/tsl2563.h>
+
+/* Use this many bits for fraction part. */
+#define ADC_FRAC_BITS		(14)
+
+/* Given number of 1/10000's in ADC_FRAC_BITS precision. */
+#define FRAC10K(f)		(((f) * (1L << (ADC_FRAC_BITS))) / (10000))
+
+/* Bits used for fraction in calibration coefficients.*/
+#define CALIB_FRAC_BITS		(10)
+/* 0.5 in CALIB_FRAC_BITS precision */
+#define CALIB_FRAC_HALF		(1 << (CALIB_FRAC_BITS - 1))
+/* Make a fraction from a number n that was multiplied with b. */
+#define CALIB_FRAC(n, b)	(((n) << CALIB_FRAC_BITS) / (b))
+/* Decimal 10^(digits in sysfs presentation) */
+#define CALIB_BASE_SYSFS	(1000)
+
+#define TSL2563_CMD		(0x80)
+#define TSL2563_CLEARINT	(0x40)
+
+#define TSL2563_REG_CTRL	(0x00)
+#define TSL2563_REG_TIMING	(0x01)
+#define TSL2563_REG_LOWLOW	(0x02) /* data0 low threshold, 2 bytes */
+#define TSL2563_REG_LOWHIGH	(0x03)
+#define TSL2563_REG_HIGHLOW	(0x04) /* data0 high threshold, 2 bytes */
+#define TSL2563_REG_HIGHHIGH	(0x05)
+#define TSL2563_REG_INT		(0x06)
+#define TSL2563_REG_ID		(0x0a)
+#define TSL2563_REG_DATA0LOW	(0x0c) /* broadband sensor value, 2 bytes */
+#define TSL2563_REG_DATA0HIGH	(0x0d)
+#define TSL2563_REG_DATA1LOW	(0x0e) /* infrared sensor value, 2 bytes */
+#define TSL2563_REG_DATA1HIGH	(0x0f)
+
+#define TSL2563_CMD_POWER_ON	(0x03)
+#define TSL2563_CMD_POWER_OFF	(0x00)
+#define TSL2563_CTRL_POWER_MASK	(0x03)
+
+#define TSL2563_TIMING_13MS	(0x00)
+#define TSL2563_TIMING_100MS	(0x01)
+#define TSL2563_TIMING_400MS	(0x02)
+#define TSL2563_TIMING_MASK	(0x03)
+#define TSL2563_TIMING_GAIN16	(0x10)
+#define TSL2563_TIMING_GAIN1	(0x00)
+
+#define TSL2563_INT_DISBLED	(0x00)
+#define TSL2563_INT_LEVEL	(0x10)
+#define TSL2563_INT_PERSIST(n)	((n) & 0x0F)
+
+struct tsl2563_gainlevel_coeff {
+	u8 gaintime;
+	u16 min;
+	u16 max;
+};
+
+static const struct tsl2563_gainlevel_coeff tsl2563_gainlevel_table[] = {
+	{
+		.gaintime	= TSL2563_TIMING_400MS | TSL2563_TIMING_GAIN16,
+		.min		= 0,
+		.max		= 65534,
+	}, {
+		.gaintime	= TSL2563_TIMING_400MS | TSL2563_TIMING_GAIN1,
+		.min		= 2048,
+		.max		= 65534,
+	}, {
+		.gaintime	= TSL2563_TIMING_100MS | TSL2563_TIMING_GAIN1,
+		.min		= 4095,
+		.max		= 37177,
+	}, {
+		.gaintime	= TSL2563_TIMING_13MS | TSL2563_TIMING_GAIN1,
+		.min		= 3000,
+		.max		= 65535,
+	},
+};
+
+struct tsl2563_chip {
+	struct mutex		lock;
+	struct i2c_client	*client;
+	struct delayed_work	poweroff_work;
+
+	/* Remember state for suspend and resume functions */
+	pm_message_t		state;
+
+	struct tsl2563_gainlevel_coeff const *gainlevel;
+
+	/* Calibration coefficients */
+	u32			calib0;
+	u32			calib1;
+	int			cover_comp_gain;
+
+	/* Cache current values, to be returned while suspended */
+	u32			data0;
+	u32			data1;
+};
+
+static int tsl2563_set_power(struct tsl2563_chip *chip, int on)
+{
+	return i2c_smbus_write_byte_data(chip->client,
+					 TSL2563_CMD | TSL2563_REG_CTRL,
+					 on ?
+					 TSL2563_CMD_POWER_ON :
+					 TSL2563_CMD_POWER_OFF);
+}
+
+/*
+ * Return value is 0 for off, 1 for on, or a negative error
+ * code if reading failed.
+ */
+static int tsl2563_get_power(struct tsl2563_chip *chip)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(chip->client,
+				       TSL2563_CMD | TSL2563_REG_CTRL);
+	if (ret < 0)
+		return ret;
+
+	return (ret & TSL2563_CTRL_POWER_MASK) == TSL2563_CMD_POWER_ON;
+}
+
+static int tsl2563_configure(struct tsl2563_chip *chip)
+{
+	return i2c_smbus_write_byte_data(chip->client,
+					 TSL2563_CMD | TSL2563_REG_TIMING,
+					 chip->gainlevel->gaintime);
+}
+
+static void tsl2563_poweroff_work(struct work_struct *work)
+{
+	struct tsl2563_chip *chip =
+		container_of(work, struct tsl2563_chip, poweroff_work.work);
+	tsl2563_set_power(chip, 0);
+}
+
+static int tsl2563_detect(struct tsl2563_chip *chip)
+{
+	int ret;
+
+	ret = tsl2563_set_power(chip, 1);
+	if (ret)
+		return ret;
+
+	ret = tsl2563_get_power(chip);
+	if (ret < 0)
+		return ret;
+
+	return ret ? 0 : -ENODEV;
+}
+
+/*
+ * "Normalized" ADC value is one obtained with 400ms of integration time and
+ * 16x gain. This function returns the number of bits of shift needed to
+ * convert between normalized values and HW values obtained using given
+ * timing and gain settings.
+ */
+static int adc_shiftbits(u8 timing)
+{
+	int shift = 0;
+
+	switch (timing & TSL2563_TIMING_MASK) {
+	case TSL2563_TIMING_13MS:
+		shift += 5;
+		break;
+	case TSL2563_TIMING_100MS:
+		shift += 2;
+		break;
+	case TSL2563_TIMING_400MS:
+		/* no-op */
+		break;
+	}
+
+	if (!(timing & TSL2563_TIMING_GAIN16))
+		shift += 4;
+
+	return shift;
+}
+
+/* Convert a HW ADC value to normalized scale. */
+static u32 normalize_adc(u16 adc, u8 timing)
+{
+	return adc << adc_shiftbits(timing);
+}
+
+static void tsl2563_wait_adc(struct tsl2563_chip *chip)
+{
+	unsigned int delay;
+
+	switch (chip->gainlevel->gaintime & TSL2563_TIMING_MASK) {
+	case TSL2563_TIMING_13MS:
+		delay = 14;
+		break;
+	case TSL2563_TIMING_100MS:
+		delay = 101;
+		break;
+	default:
+		delay = 402;
+	}
+	/*
+	 * TODO: Make sure that we wait at least required delay but why we
+	 * have to extend it one tick more?
+	 */
+	schedule_timeout_interruptible(msecs_to_jiffies(delay) + 2);
+}
+
+static int tsl2563_adjust_gainlevel(struct tsl2563_chip *chip, u16 adc)
+{
+	struct i2c_client *client = chip->client;
+
+	if (adc > chip->gainlevel->max || adc < chip->gainlevel->min) {
+
+		(adc > chip->gainlevel->max) ?
+			chip->gainlevel++ : chip->gainlevel--;
+
+		i2c_smbus_write_byte_data(client,
+					  TSL2563_CMD | TSL2563_REG_TIMING,
+					  chip->gainlevel->gaintime);
+
+		tsl2563_wait_adc(chip);
+		tsl2563_wait_adc(chip);
+
+		return 1;
+	} else
+		return 0;
+}
+
+static int tsl2563_get_adc(struct tsl2563_chip *chip)
+{
+	struct i2c_client *client = chip->client;
+	u16 adc0, adc1;
+	int retry = 1;
+	int ret = 0;
+
+	if (chip->state.event != PM_EVENT_ON)
+		goto out;
+
+	cancel_delayed_work(&chip->poweroff_work);
+
+	if (!tsl2563_get_power(chip)) {
+		ret = tsl2563_set_power(chip, 1);
+		if (ret)
+			goto out;
+		ret = tsl2563_configure(chip);
+		if (ret)
+			goto out;
+		tsl2563_wait_adc(chip);
+	}
+
+	while (retry) {
+		ret = i2c_smbus_read_word_data(client,
+				TSL2563_CMD | TSL2563_REG_DATA0LOW);
+		if (ret < 0)
+			goto out;
+		adc0 = ret;
+
+		ret = i2c_smbus_read_word_data(client,
+				TSL2563_CMD | TSL2563_REG_DATA1LOW);
+		if (ret < 0)
+			goto out;
+		adc1 = ret;
+
+		retry = tsl2563_adjust_gainlevel(chip, adc0);
+	}
+
+	chip->data0 = normalize_adc(adc0, chip->gainlevel->gaintime);
+	chip->data1 = normalize_adc(adc1, chip->gainlevel->gaintime);
+
+
+	ret = 0;
+out:
+	return ret;
+}
+
+static inline int calib_to_sysfs(u32 calib)
+{
+	return (int) (((calib * CALIB_BASE_SYSFS) +
+		       CALIB_FRAC_HALF) >> CALIB_FRAC_BITS);
+}
+
+static inline u32 calib_from_sysfs(int value)
+{
+	return (((u32) value) << CALIB_FRAC_BITS) / CALIB_BASE_SYSFS;
+}
+
+/*
+ * Conversions between lux and ADC values.
+ *
+ * The basic formula is lux = c0 * adc0 - c1 * adc1, where c0 and c1 are
+ * appropriate constants. Different constants are needed for different
+ * kinds of light, determined by the ratio adc1/adc0 (basically the ratio
+ * of the intensities in infrared and visible wavelengths). lux_table below
+ * lists the upper threshold of the adc1/adc0 ratio and the corresponding
+ * constants.
+ */
+
+struct tsl2563_lux_coeff {
+	unsigned long ch_ratio;
+	unsigned long ch0_coeff;
+	unsigned long ch1_coeff;
+};
+
+static const struct tsl2563_lux_coeff lux_table[] = {
+	{
+		.ch_ratio	= FRAC10K(1300),
+		.ch0_coeff	= FRAC10K(315),
+		.ch1_coeff	= FRAC10K(262),
+	}, {
+		.ch_ratio	= FRAC10K(2600),
+		.ch0_coeff	= FRAC10K(337),
+		.ch1_coeff	= FRAC10K(430),
+	}, {
+		.ch_ratio	= FRAC10K(3900),
+		.ch0_coeff	= FRAC10K(363),
+		.ch1_coeff	= FRAC10K(529),
+	}, {
+		.ch_ratio	= FRAC10K(5200),
+		.ch0_coeff	= FRAC10K(392),
+		.ch1_coeff	= FRAC10K(605),
+	}, {
+		.ch_ratio	= FRAC10K(6500),
+		.ch0_coeff	= FRAC10K(229),
+		.ch1_coeff	= FRAC10K(291),
+	}, {
+		.ch_ratio	= FRAC10K(8000),
+		.ch0_coeff	= FRAC10K(157),
+		.ch1_coeff	= FRAC10K(180),
+	}, {
+		.ch_ratio	= FRAC10K(13000),
+		.ch0_coeff	= FRAC10K(34),
+		.ch1_coeff	= FRAC10K(26),
+	}, {
+		.ch_ratio	= ULONG_MAX,
+		.ch0_coeff	= 0,
+		.ch1_coeff	= 0,
+	},
+};
+
+/*
+ * Convert normalized, scaled ADC values to lux.
+ */
+static unsigned int adc_to_lux(u32 adc0, u32 adc1)
+{
+	const struct tsl2563_lux_coeff *lp = lux_table;
+	unsigned long ratio, lux, ch0 = adc0, ch1 = adc1;
+
+	ratio = ch0 ? ((ch1 << ADC_FRAC_BITS) / ch0) : ULONG_MAX;
+
+	while (lp->ch_ratio < ratio)
+		lp++;
+
+	lux = ch0 * lp->ch0_coeff - ch1 * lp->ch1_coeff;
+
+	return (unsigned int) (lux >> ADC_FRAC_BITS);
+}
+
+/* Apply calibration coefficient to ADC count. */
+static u32 calib_adc(u32 adc, u32 calib)
+{
+	unsigned long scaled = adc;
+
+	scaled *= calib;
+	scaled >>= CALIB_FRAC_BITS;
+
+	return (u32) scaled;
+}
+
+static int tsl2563_write_raw(struct iio_dev *indio_dev,
+			       struct iio_chan_spec const *chan,
+			       int val,
+			       int val2,
+			       long mask)
+{
+	struct tsl2563_chip *chip = iio_priv(indio_dev);
+
+	if (chan->channel == 0)
+		chip->calib0 = calib_from_sysfs(val);
+	else
+		chip->calib1 = calib_from_sysfs(val);
+
+	return 0;
+}
+
+static int tsl2563_read_raw(struct iio_dev *indio_dev,
+			    struct iio_chan_spec const *chan,
+			    int *val,
+			    int *val2,
+			    long m)
+{
+	int ret = -EINVAL;
+	u32 calib0, calib1;
+	struct tsl2563_chip *chip = iio_priv(indio_dev);
+
+	mutex_lock(&chip->lock);
+	switch (m) {
+	case 0:
+		switch (chan->type) {
+		case IIO_LIGHT:
+			ret = tsl2563_get_adc(chip);
+			if (ret)
+				goto error_ret;
+			calib0 = calib_adc(chip->data0, chip->calib0) *
+				chip->cover_comp_gain;
+			calib1 = calib_adc(chip->data1, chip->calib1) *
+				chip->cover_comp_gain;
+			*val = adc_to_lux(calib0, calib1);
+			ret = IIO_VAL_INT;
+			break;
+		case IIO_INTENSITY:
+			ret = tsl2563_get_adc(chip);
+			if (ret)
+				goto error_ret;
+			if (chan->channel == 0)
+				*val = chip->data0;
+			else
+				*val = chip->data1;
+			ret = IIO_VAL_INT;
+			break;
+		default:
+			break;
+		}
+		break;
+
+	case IIO_CHAN_INFO_CALIBSCALE:
+		if (chan->channel == 0)
+			*val = calib_to_sysfs(chip->calib0);
+		else
+			*val = calib_to_sysfs(chip->calib1);
+		ret = IIO_VAL_INT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+error_ret:
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+static const struct iio_chan_spec tsl2563_channels[] = {
+	{
+		.type = IIO_LIGHT,
+		.indexed = 1,
+		.channel = 0,
+	}, {
+		.type = IIO_INTENSITY,
+		.modified = 1,
+		.channel2 = IIO_MOD_LIGHT_BOTH,
+		.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
+	}, {
+		.type = IIO_INTENSITY,
+		.modified = 1,
+		.channel2 = IIO_MOD_LIGHT_INFRARED,
+		.info_mask = IIO_CHAN_INFO_CALIBSCALE_SEPARATE_BIT,
+	}
+};
+
+static const struct iio_info tsl2563_info = {
+	.driver_module = THIS_MODULE,
+	.read_raw = &tsl2563_read_raw,
+	.write_raw = &tsl2563_write_raw,
+};
+
+static int __devinit tsl2563_probe(struct i2c_client *client,
+				const struct i2c_device_id *device_id)
+{
+	struct iio_dev *indio_dev;
+	struct tsl2563_chip *chip;
+	struct tsl2563_platform_data *pdata = client->dev.platform_data;
+	int err = 0;
+	int ret;
+	u8 id = 0;
+
+	indio_dev = iio_device_allocate(sizeof(*chip));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	chip = iio_priv(indio_dev);
+
+	i2c_set_clientdata(client, indio_dev);
+	chip->client = client;
+
+	err = tsl2563_detect(chip);
+	if (err) {
+		dev_err(&client->dev, "device not found, error %d\n", -err);
+		goto fail1;
+	}
+
+	/* Check we can read the id */
+	err = i2c_smbus_read_byte_data(chip->client,
+				       TSL2563_CMD | TSL2563_REG_ID);
+	if (err < 0)
+		goto fail1;
+
+	mutex_init(&chip->lock);
+
+	/* Default values used until userspace says otherwise */
+	chip->gainlevel = tsl2563_gainlevel_table;
+	chip->calib0 = calib_from_sysfs(CALIB_BASE_SYSFS);
+	chip->calib1 = calib_from_sysfs(CALIB_BASE_SYSFS);
+
+	if (pdata)
+		chip->cover_comp_gain = pdata->cover_comp_gain;
+	else
+		chip->cover_comp_gain = 1;
+
+	dev_info(&client->dev, "model %d, rev. %d\n", id >> 4, id & 0x0f);
+	indio_dev->name = client->name;
+	indio_dev->channels = tsl2563_channels;
+	indio_dev->num_channels = ARRAY_SIZE(tsl2563_channels);
+	indio_dev->dev.parent = &client->dev;
+	indio_dev->info = &tsl2563_info;
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto fail1;
+	err = tsl2563_configure(chip);
+	if (err)
+		goto fail2;
+
+	INIT_DELAYED_WORK(&chip->poweroff_work, tsl2563_poweroff_work);
+
+	schedule_delayed_work(&chip->poweroff_work, 5 * HZ);
+
+	return 0;
+fail2:
+	iio_device_unregister(indio_dev);
+fail1:
+	kfree(chip);
+	return err;
+}
+
+static int tsl2563_remove(struct i2c_client *client)
+{
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+	struct tsl2563_chip *chip = iio_priv(indio_dev);
+
+	iio_device_unregister(indio_dev);
+	tsl2563_set_power(chip, 0);
+	iio_device_free(indio_dev);
+
+	return 0;
+}
+
+static int tsl2563_suspend(struct i2c_client *client, pm_message_t state)
+{
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+	struct tsl2563_chip *chip = iio_priv(indio_dev);
+	int ret;
+
+	mutex_lock(&chip->lock);
+
+	ret = tsl2563_set_power(chip, 0);
+	if (ret)
+		goto out;
+
+	chip->state = state;
+
+out:
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+static int tsl2563_resume(struct i2c_client *client)
+{
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+	struct tsl2563_chip *chip = iio_priv(indio_dev);
+	int ret;
+
+	mutex_lock(&chip->lock);
+
+	ret = tsl2563_set_power(chip, 1);
+	if (ret)
+		goto out;
+
+	ret = tsl2563_configure(chip);
+	if (ret)
+		goto out;
+
+	chip->state.event = PM_EVENT_ON;
+
+out:
+	mutex_unlock(&chip->lock);
+	return ret;
+}
+
+static const struct i2c_device_id tsl2563_id[] = {
+	{ "tsl2560", 0 },
+	{ "tsl2561", 0 },
+	{ "tsl2562", 0 },
+	{ "tsl2563", 0 },
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, tsl2563_id);
+
+static struct i2c_driver tsl2563_i2c_driver = {
+	.driver = {
+		.name	 = "tsl2563",
+	},
+	.suspend	= tsl2563_suspend,
+	.resume		= tsl2563_resume,
+	.probe		= tsl2563_probe,
+	.remove		= __devexit_p(tsl2563_remove),
+	.id_table	= tsl2563_id,
+};
+
+static int __init tsl2563_init(void)
+{
+	return i2c_add_driver(&tsl2563_i2c_driver);
+}
+module_init(tsl2563_init);
+
+static void __exit tsl2563_exit(void)
+{
+	i2c_del_driver(&tsl2563_i2c_driver);
+}
+module_exit(tsl2563_exit);
+
+MODULE_AUTHOR("Nokia Corporation");
+MODULE_DESCRIPTION("tsl2563 light sensor driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/iio/tsl2563.h b/include/linux/iio/tsl2563.h
new file mode 100644
index 0000000..3e503cd
--- /dev/null
+++ b/include/linux/iio/tsl2563.h
@@ -0,0 +1,8 @@
+#ifndef _TSL2563_H_
+#define _TSL2563_H_
+
+struct tsl2563_platform_data {
+	int cover_comp_gain;
+};
+
+#endif /* _TSL2563_H_ */
-- 
1.7.7.2

