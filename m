Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080Ab1FJUg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:36:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1FJUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:36:23 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH 1/2] light sensor: Add a calibration file to the isl29018 driver.
Date: Fri, 10 Jun 2011 13:26:19 -0700
Message-Id: <1307737580-14131-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the same tuning file used in tsl2583.c.
Add documentation for it to sysfs-bus-iio-light.
Normalize it at 1024 instead of 1000 so we can avoid 64bit division (div_u64).
Use u64 so we can do all multiplication before division to avoid loss of
granularity on amplified values.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 .../staging/iio/Documentation/sysfs-bus-iio-light  |   10 +++++
 drivers/staging/iio/light/isl29018.c               |   36 +++++++++++++++++++-
 2 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio-light b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
index 21d2774..704b6c9 100644
--- a/drivers/staging/iio/Documentation/sysfs-bus-iio-light
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio-light
@@ -75,3 +75,13 @@ KernelVersion:	2.6.37
 Contact:	linux-iio@vger.kernel.org
 Description:
 		This property gets/sets the sensors ADC analog integration time.
+
+What:		/sys/bus/iio/devices/device[n]/illuminance0_calibbias
+KernelVersion:	2.6.38
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This property gets/sets the illuminance0_input amplification
+		value.  The calculated lux reading is multiplied by this value
+		and divided by 1024.  Default of 1024 gives no amplification.
+		This provides compensation for glass or bezel that can
+		attenuate the ambient light.
diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 4794ffd..a106f16 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -57,6 +57,7 @@ struct isl29018_chip {
 	struct iio_dev		*indio_dev;
 	struct i2c_client	*client;
 	struct mutex		lock;
+	unsigned int		calibbias;
 	unsigned int		range;
 	unsigned int		adc_bit;
 	int			prox_scheme;
@@ -157,6 +158,7 @@ static int isl29018_read_sensor_input(struct i2c_client *client, int mode)
 
 static int isl29018_read_lux(struct i2c_client *client, int *lux)
 {
+	u64 lux64;
 	int lux_data;
 	struct isl29018_chip *chip = i2c_get_clientdata(client);
 
@@ -166,7 +168,8 @@ static int isl29018_read_lux(struct i2c_client *client, int *lux)
 	if (lux_data < 0)
 		return lux_data;
 
-	*lux = (lux_data * chip->range) >> chip->adc_bit;
+	lux64 = lux_data * chip->range;
+	*lux = (lux64 * chip->calibbias) >> (10 + chip->adc_bit);
 
 	return 0;
 }
@@ -264,6 +267,33 @@ static ssize_t get_sensor_data(struct device *dev, char *buf, int mode)
 }
 
 /* Sysfs interface */
+/* calibbias */
+static ssize_t show_calibbias(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct isl29018_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%u\n", chip->calibbias);
+}
+
+static ssize_t store_calibbias(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct isl29018_chip *chip = indio_dev->dev_data;
+	unsigned long lval;
+
+	if (strict_strtoul(buf, 10, &lval))
+		return -EINVAL;
+
+	mutex_lock(&chip->lock);
+	chip->calibbias = lval;
+	mutex_unlock(&chip->lock);
+
+	return count;
+}
+
 /* range */
 static ssize_t show_range(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -412,6 +442,8 @@ static IIO_DEVICE_ATTR(proximity_on_chip_ambient_infrared_supression,
 					show_prox_infrared_supression,
 					store_prox_infrared_supression, 0);
 static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
+static IIO_DEVICE_ATTR(illuminance0_calibbias, S_IRUGO | S_IWUSR,
+					show_calibbias, store_calibbias, 0);
 static IIO_DEVICE_ATTR(intensity_infrared_raw, S_IRUGO, show_ir, NULL, 0);
 static IIO_DEVICE_ATTR(proximity_raw, S_IRUGO, show_proxim_ir, NULL, 0);
 
@@ -424,6 +456,7 @@ static struct attribute *isl29018_attributes[] = {
 	ISL29018_CONST_ATTR(adc_resolution_available),
 	ISL29018_DEV_ATTR(proximity_on_chip_ambient_infrared_supression),
 	ISL29018_DEV_ATTR(illuminance0_input),
+	ISL29018_DEV_ATTR(illuminance0_calibbias),
 	ISL29018_DEV_ATTR(intensity_infrared_raw),
 	ISL29018_DEV_ATTR(proximity_raw),
 	NULL
@@ -478,6 +511,7 @@ static int __devinit isl29018_probe(struct i2c_client *client,
 
 	mutex_init(&chip->lock);
 
+	chip->calibbias = 1024;
 	chip->range = 1000;
 	chip->adc_bit = 16;
 
-- 
1.7.3.1

