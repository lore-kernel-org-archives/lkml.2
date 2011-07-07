Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1GGTCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:02:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33874 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab1GGTCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:02:18 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, gregkh@suse.de, rklein@nvidia.com,
        linux-iio@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v2 3/4] staging:iio:light:isl29018: Convert some of the isl29018 driver to the new iio_chan_spec framework.
Date: Thu,  7 Jul 2011 12:01:56 -0700
Message-Id: <1310065317-3872-4-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310065317-3872-1-git-send-email-bfreed@chromium.org>
References: <1310065317-3872-1-git-send-email-bfreed@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the driver's get_sensor_data() interfaces and replace them with
iio_chan_spec channels.  This converts 4 files to the new framework.
Driver ABI change: The intensity_infrared_raw file is now intensity_ir_raw.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/isl29018.c |  168 ++++++++++++++++------------------
 1 files changed, 78 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index cc6d718..070e94d 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -224,74 +224,7 @@ static int isl29018_read_proximity_ir(struct i2c_client *client, int scheme,
 	return 0;
 }
 
-static ssize_t get_sensor_data(struct device *dev, char *buf, int mode)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct isl29018_chip *chip = iio_priv(indio_dev);
-	struct i2c_client *client = chip->client;
-	int value = 0;
-	int status;
-
-	mutex_lock(&chip->lock);
-	switch (mode) {
-	case COMMMAND1_OPMODE_PROX_ONCE:
-		status = isl29018_read_proximity_ir(client,
-				chip->prox_scheme, &value);
-		break;
-
-	case COMMMAND1_OPMODE_ALS_ONCE:
-		status = isl29018_read_lux(client, &value);
-		break;
-
-	case COMMMAND1_OPMODE_IR_ONCE:
-		status = isl29018_read_ir(client, &value);
-		break;
-
-	default:
-		dev_err(&client->dev, "Mode %d is not supported\n", mode);
-		mutex_unlock(&chip->lock);
-		return -EBUSY;
-	}
-	if (status < 0) {
-		dev_err(&client->dev, "Error in Reading data");
-		mutex_unlock(&chip->lock);
-		return status;
-	}
-
-	mutex_unlock(&chip->lock);
-
-	return sprintf(buf, "%d\n", value);
-}
-
 /* Sysfs interface */
-/* lux_scale */
-static ssize_t show_lux_scale(struct device *dev,
-			struct device_attribute *attr, char *buf)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct isl29018_chip *chip = indio_dev->dev_data;
-
-	return sprintf(buf, "%d\n", chip->lux_scale);
-}
-
-static ssize_t store_lux_scale(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct isl29018_chip *chip = indio_dev->dev_data;
-	unsigned long lval;
-
-	lval = simple_strtoul(buf, NULL, 10);
-	if (lval == 0)
-		return -EINVAL;
-
-	mutex_lock(&chip->lock);
-	chip->lux_scale = lval;
-	mutex_unlock(&chip->lock);
-
-	return count;
-}
-
 /* range */
 static ssize_t show_range(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -409,27 +342,87 @@ static ssize_t store_prox_infrared_supression(struct device *dev,
 	return count;
 }
 
-/* Read lux */
-static ssize_t show_lux(struct device *dev,
-		struct device_attribute *devattr, char *buf)
+/* Channel IO */
+static int isl29018_write_raw(struct iio_dev *indio_dev,
+			      struct iio_chan_spec const *chan,
+			      int val,
+			      int val2,
+			      long mask)
 {
-	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_ALS_ONCE);
-}
+	struct isl29018_chip *chip = iio_priv(indio_dev);
+	int ret = -EINVAL;
 
-/* Read ir */
-static ssize_t show_ir(struct device *dev,
-		struct device_attribute *devattr, char *buf)
-{
-	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_IR_ONCE);
+	mutex_lock(&chip->lock);
+	if (mask == (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE) &&
+	    chan->type == IIO_LIGHT) {
+		chip->lux_scale = val;
+		ret = 0;
+	}
+	mutex_unlock(&chip->lock);
+
+	return 0;
 }
 
-/* Read nearest ir */
-static ssize_t show_proxim_ir(struct device *dev,
-		struct device_attribute *devattr, char *buf)
+static int isl29018_read_raw(struct iio_dev *indio_dev,
+			     struct iio_chan_spec const *chan,
+			     int *val,
+			     int *val2,
+			     long mask)
 {
-	return get_sensor_data(dev, buf, COMMMAND1_OPMODE_PROX_ONCE);
+	int ret = -EINVAL;
+	struct isl29018_chip *chip = iio_priv(indio_dev);
+	struct i2c_client *client = chip->client;
+
+	mutex_lock(&chip->lock);
+	switch (mask) {
+	case 0:
+		switch (chan->type) {
+		case IIO_LIGHT:
+			ret = isl29018_read_lux(client, val);
+			break;
+		case IIO_INTENSITY:
+			ret = isl29018_read_ir(client, val);
+			break;
+		case IIO_PROXIMITY:
+			ret = isl29018_read_proximity_ir(client,
+					chip->prox_scheme, val);
+			break;
+		default:
+			break;
+		}
+		if (!ret)
+			ret = IIO_VAL_INT;
+		break;
+	case (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE):
+		if (chan->type == IIO_LIGHT) {
+			*val = chip->lux_scale;
+			ret = IIO_VAL_INT;
+		}
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&chip->lock);
+	return ret;
 }
 
+static const struct iio_chan_spec isl29018_channels[] = {
+	{
+		.type = IIO_LIGHT,
+		.indexed = 1,
+		.channel = 0,
+		.processed_val = 1,
+		.info_mask = (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE),
+	}, {
+		.type = IIO_INTENSITY,
+		.modified = 1,
+		.channel2 = IIO_MOD_LIGHT_IR,
+	}, {
+		/* Unindexed in current ABI.  But perhaps it should be. */
+		.type = IIO_PROXIMITY,
+	}
+};
+
 static IIO_DEVICE_ATTR(range, S_IRUGO | S_IWUSR, show_range, store_range, 0);
 static IIO_CONST_ATTR(range_available, "1000 4000 16000 64000");
 static IIO_CONST_ATTR(adc_resolution_available, "4 8 12 16");
@@ -439,11 +432,6 @@ static IIO_DEVICE_ATTR(proximity_on_chip_ambient_infrared_supression,
 					S_IRUGO | S_IWUSR,
 					show_prox_infrared_supression,
 					store_prox_infrared_supression, 0);
-static IIO_DEVICE_ATTR(illuminance0_input, S_IRUGO, show_lux, NULL, 0);
-static IIO_DEVICE_ATTR(illuminance0_calibscale, S_IRUGO | S_IWUSR,
-					show_lux_scale, store_lux_scale, 0);
-static IIO_DEVICE_ATTR(intensity_infrared_raw, S_IRUGO, show_ir, NULL, 0);
-static IIO_DEVICE_ATTR(proximity_raw, S_IRUGO, show_proxim_ir, NULL, 0);
 
 #define ISL29018_DEV_ATTR(name) (&iio_dev_attr_##name.dev_attr.attr)
 #define ISL29018_CONST_ATTR(name) (&iio_const_attr_##name.dev_attr.attr)
@@ -453,10 +441,6 @@ static struct attribute *isl29018_attributes[] = {
 	ISL29018_DEV_ATTR(adc_resolution),
 	ISL29018_CONST_ATTR(adc_resolution_available),
 	ISL29018_DEV_ATTR(proximity_on_chip_ambient_infrared_supression),
-	ISL29018_DEV_ATTR(illuminance0_input),
-	ISL29018_DEV_ATTR(illuminance0_calibscale),
-	ISL29018_DEV_ATTR(intensity_infrared_raw),
-	ISL29018_DEV_ATTR(proximity_raw),
 	NULL
 };
 
@@ -489,6 +473,8 @@ static int isl29018_chip_init(struct i2c_client *client)
 static const struct iio_info isl29108_info = {
 	.attrs = &isl29108_group,
 	.driver_module = THIS_MODULE,
+	.read_raw = &isl29018_read_raw,
+	.write_raw = &isl29018_write_raw,
 };
 
 static int __devinit isl29018_probe(struct i2c_client *client,
@@ -520,6 +506,8 @@ static int __devinit isl29018_probe(struct i2c_client *client,
 		goto exit_iio_free;
 
 	indio_dev->info = &isl29108_info;
+	indio_dev->channels = isl29018_channels;
+	indio_dev->num_channels = ARRAY_SIZE(isl29018_channels);
 	indio_dev->name = id->name;
 	indio_dev->dev.parent = &client->dev;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-- 
1.7.3.1

