Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab1F1WAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:00:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13652 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1F1WAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:00:20 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, rklein@nvidia.com, jic23@cam.ac.uk,
        gregkh@suse.de, arnd@arndb.de, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH] light sensor: Add a calibscale file to the isl29018 light sensor driver.
Date: Tue, 28 Jun 2011 15:00:01 -0700
Message-Id: <1309298401-8623-1-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Defaulting to 1, this gives a way to amplify the lux value before being
reduced by the programmed adc_bit shift.
Only support whole numbers right now.  When this driver is converted to the new
IIO_CHAN framework, it will be easy to support the framework's pseudo float.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/isl29018.c |   35 +++++++++++++++++++++++++++++++++-
 1 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 4794ffd..cd88311 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -57,6 +57,7 @@ struct isl29018_chip {
 	struct iio_dev		*indio_dev;
 	struct i2c_client	*client;
 	struct mutex		lock;
+	unsigned int		lux_scale;
 	unsigned int		range;
 	unsigned int		adc_bit;
 	int			prox_scheme;
@@ -166,7 +167,7 @@ static int isl29018_read_lux(struct i2c_client *client, int *lux)
 	if (lux_data < 0)
 		return lux_data;
 
-	*lux = (lux_data * chip->range) >> chip->adc_bit;
+	*lux = (lux_data * chip->range * chip->lux_scale) >> chip->adc_bit;
 
 	return 0;
 }
@@ -264,6 +265,34 @@ static ssize_t get_sensor_data(struct device *dev, char *buf, int mode)
 }
 
 /* Sysfs interface */
+/* lux_scale */
+static ssize_t show_lux_scale(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct isl29018_chip *chip = indio_dev->dev_data;
+
+	return sprintf(buf, "%d\n", chip->lux_scale);
+}
+
+static ssize_t store_lux_scale(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct isl29018_chip *chip = indio_dev->dev_data;
+	unsigned long lval;
+
+	lval = simple_strtoul(buf, NULL, 10);
+	if (lval == 0)
+		return -EINVAL;
+
+	mutex_lock(&chip->lock);
+	chip->lux_scale = lval;
+	mutex_unlock(&chip->lock);
+
+	return count;
+}
+
 /* range */
 static ssize_t show_range(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -412,6 +441,8 @@ static IIO_DEVICE_ATTR(proximity_on_chip_ambient_infrared_supression,
 					show_prox_infrared_supression,
 					store_prox_infrared_supression, 0);
 static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
+static IIO_DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
+					show_lux_scale, store_lux_scale, 0);
 static IIO_DEVICE_ATTR(intensity_infrared_raw, S_IRUGO, show_ir, NULL, 0);
 static IIO_DEVICE_ATTR(proximity_raw, S_IRUGO, show_proxim_ir, NULL, 0);
 
@@ -424,6 +455,7 @@ static struct attribute *isl29018_attributes[] = {
 	ISL29018_CONST_ATTR(adc_resolution_available),
 	ISL29018_DEV_ATTR(proximity_on_chip_ambient_infrared_supression),
 	ISL29018_DEV_ATTR(illuminance0_input),
+	ISL29018_DEV_ATTR(illuminance0_calibscale),
 	ISL29018_DEV_ATTR(intensity_infrared_raw),
 	ISL29018_DEV_ATTR(proximity_raw),
 	NULL
@@ -478,6 +510,7 @@ static int __devinit isl29018_probe(struct i2c_client *client,
 
 	mutex_init(&chip->lock);
 
+	chip->lux_scale = 1;
 	chip->range = 1000;
 	chip->adc_bit = 16;
 
-- 
1.7.3.1

