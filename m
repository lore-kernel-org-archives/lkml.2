Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2ATXn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:43:57 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:46848 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2ATXn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:43:56 -0500
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: x86@kernel.org
Cc: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH] x86/platform: (TS-5500) revised ADC driver
Date: Fri, 20 Jan 2012 18:43:22 -0500
Message-Id: <1327103002-5834-1-git-send-email-vivien.didelot@savoirfairelinux.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1326930731-21215-5-git-send-email-vivien.didelot@savoirfairelinux.com>
References: <1326930731-21215-5-git-send-email-vivien.didelot@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update of the ADC driver according to the Guenter Roeck's review.

Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
---
 arch/x86/platform/ts5500/ts5500_adc.c |  228 +++++++++++++--------------------
 1 files changed, 89 insertions(+), 139 deletions(-)

diff --git a/arch/x86/platform/ts5500/ts5500_adc.c b/arch/x86/platform/ts5500/ts5500_adc.c
index fc4560f..da6decf 100644
--- a/arch/x86/platform/ts5500/ts5500_adc.c
+++ b/arch/x86/platform/ts5500/ts5500_adc.c
@@ -62,57 +62,62 @@
 
 #define TS5500_ADC_READ_DELAY		15	/* usec */
 #define TS5500_ADC_READ_BUSY_MASK	0x01
-#define TS5500_ADC_NAME			"MAX197 (8 channels)"
+#define TS5500_ADC_NAME			"TS-5500 mapped MAX197 (8 channels)"
 
-/**
- * struct ts5500_adc_platform_data
- * @name:	Name of the device.
- * @ioaddr:	I/O address containing:
- *		.data:		Data register for conversion reading.
- *		.ctrl:		A/D Control Register (bit 0 = 0 when
- *				conversion completed).
- * @read:	Information about conversion reading, with:
- *		.delay:		Delay before next conversion.
- *		.busy_mask:	Control register bit 0 equals 1 means
- *				conversion is not completed yet.
- * @ctrl:	Data tables addressable by [polarity][range].
- * @ranges:	Ranges.
- *		.min:		Min value.
- *		.max:		Max value.
- * @scale:	Polarity/Range coefficients to scale raw conversion reading.
- */
-struct ts5500_adc_platform_data {
-	const char *name;
-	struct {
-		int data;
-		int ctrl;
-	} ioaddr;
-	struct {
-		u8 delay;
-		u8 busy_mask;
-	} read;
-	u8 ctrl[2][2];
-	struct {
-		int min[2][2];
-		int max[2][2];
-	} ranges;
-	int scale[2][2];
+/* Data tables addressable by [polarity][range] */
+static const u8 ts5500_adc_ctrl[2][2] = {
+	{
+		TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_5V,
+		TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_10V
+	},
+	{
+		TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_5V,
+		TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_10V
+	}
+};
+
+/* Min/Max ranges */
+#define TS5500_ADC_RANGES_MIN_UNIPOLAR_5V	0
+#define TS5500_ADC_RANGES_MIN_UNIPOLAR_10V	0
+#define TS5500_ADC_RANGES_MIN_BIPOLAR_5V	-5000
+#define TS5500_ADC_RANGES_MIN_BIPOLAR_10V	-10000
+
+static const int ts5500_adc_ranges_min[2][2] = {
+	{ TS5500_ADC_RANGES_MIN_UNIPOLAR_5V, TS5500_ADC_RANGES_MIN_UNIPOLAR_10V },
+	{ TS5500_ADC_RANGES_MIN_BIPOLAR_5V, TS5500_ADC_RANGES_MIN_BIPOLAR_10V }
+};
+
+#define TS5500_ADC_RANGES_MAX_UNIPOLAR_5V	5000
+#define TS5500_ADC_RANGES_MAX_UNIPOLAR_10V	10000
+#define TS5500_ADC_RANGES_MAX_BIPOLAR_5V	5000
+#define TS5500_ADC_RANGES_MAX_BIPOLAR_10V	10000
+
+static const int ts5500_adc_ranges_max[2][2] = {
+	{ TS5500_ADC_RANGES_MAX_UNIPOLAR_5V, TS5500_ADC_RANGES_MAX_UNIPOLAR_10V },
+	{ TS5500_ADC_RANGES_MAX_BIPOLAR_5V, TS5500_ADC_RANGES_MAX_BIPOLAR_10V }
 };
 
-#define ts5500_adc_test_bit(bit, map)	(test_bit(bit, map) != 0)
+/* Polarity/Range coefficients to scale raw conversion reading */
+#define TS5500_ADC_SCALE_UNIPOLAR_5V		12207
+#define TS5500_ADC_SCALE_UNIPOLAR_10V		24414
+#define TS5500_ADC_SCALE_BIPOLAR_5V		24414
+#define TS5500_ADC_SCALE_BIPOLAR_10V		48828
+
+static const int ts5500_adc_scales[2][2] = {
+	{ TS5500_ADC_SCALE_UNIPOLAR_5V, TS5500_ADC_SCALE_UNIPOLAR_10V },
+	{ TS5500_ADC_SCALE_BIPOLAR_5V, TS5500_ADC_SCALE_BIPOLAR_10V }
+};
 
 /**
  * struct ts5500_adc_chip
  * @hwmon_dev:		The hwmon device.
  * @lock:		Read/Write mutex.
- * @spec:		The mapped MAX197 platform data.
  * @polarity:		bitmap for polarity.
  * @range:		bitmap for range.
  */
 struct ts5500_adc_chip {
 	struct device *hwmon_dev;
 	struct mutex lock;
-	struct ts5500_adc_platform_data spec;
 	DECLARE_BITMAP(polarity, TS5500_ADC_CHANNELS_MAX);
 	DECLARE_BITMAP(range, TS5500_ADC_CHANNELS_MAX);
 };
@@ -122,7 +127,7 @@ static s32 ts5500_adc_scale(struct ts5500_adc_chip *chip, s16 raw,
 {
 	s32 scaled = raw;
 
-	scaled *= chip->spec.scale[polarity][range];
+	scaled *= ts5500_adc_scales[polarity][range];
 	scaled /= 10000;
 
 	return scaled;
@@ -132,22 +137,8 @@ static int ts5500_adc_range(struct ts5500_adc_chip *chip, int is_min,
 			       int polarity, int range)
 {
 	if (is_min)
-		return chip->spec.ranges.min[polarity][range];
-	return chip->spec.ranges.max[polarity][range];
-}
-
-static int ts5500_adc_strtol(const char *buf, long *value, int range1,
-				int range2)
-{
-	if (strict_strtol(buf, 10, value))
-		return -EINVAL;
-
-	if (range1 < range2)
-		*value = SENSORS_LIMIT(*value, range1, range2);
-	else
-		*value = SENSORS_LIMIT(*value, range2, range1);
-
-	return 0;
+		return ts5500_adc_ranges_min[polarity][range];
+	return ts5500_adc_ranges_max[polarity][range];
 }
 
 static struct ts5500_adc_chip *ts5500_adc_get_drvdata(struct device *dev)
@@ -166,14 +157,14 @@ static ssize_t ts5500_adc_show_range(struct device *dev,
 {
 	struct ts5500_adc_chip *chip = ts5500_adc_get_drvdata(dev);
 	struct sensor_device_attribute_2 *attr = to_sensor_dev_attr_2(devattr);
-	int is_min = attr->nr != 0;
+	int is_min = !!attr->nr;
 	int polarity, range;
 
 	if (mutex_lock_interruptible(&chip->lock))
 		return -ERESTARTSYS;
 
-	polarity = ts5500_adc_test_bit(attr->index, chip->polarity);
-	range = ts5500_adc_test_bit(attr->index, chip->range);
+	polarity = !!test_bit(attr->index, chip->polarity);
+	range = !!test_bit(attr->index, chip->range);
 
 	mutex_unlock(&chip->lock);
 
@@ -198,9 +189,14 @@ static ssize_t ts5500_adc_store_range(struct device *dev,
 	int range2 = ts5500_adc_range(chip, is_min, 1, 1);
 	long value;
 
-	if (ts5500_adc_strtol(buf, &value, range1, range2))
+	if (kstrtol(buf, 10, &value))
 		return -EINVAL;
 
+	if (range1 < range2)
+		value = SENSORS_LIMIT(value, range1, range2);
+	else
+		value = SENSORS_LIMIT(value, range2, range1);
+
 	if (mutex_lock_interruptible(&chip->lock))
 		return -ERESTARTSYS;
 
@@ -240,24 +236,23 @@ static ssize_t ts5500_adc_show_input(struct device *dev,
 	if (mutex_lock_interruptible(&chip->lock))
 		return -ERESTARTSYS;
 
-	polarity = ts5500_adc_test_bit(attr->index, chip->polarity);
-	range = ts5500_adc_test_bit(attr->index, chip->range);
+	polarity = !!test_bit(attr->index, chip->polarity);
+	range = !!test_bit(attr->index, chip->range);
 
-	command = attr->index | chip->spec.ctrl[polarity][range];
+	command = attr->index | ts5500_adc_ctrl[polarity][range];
 
-	outb(command, chip->spec.ioaddr.data);
+	outb(command, TS5500_ADC_INIT_LSB_REG);
 
-	udelay(chip->spec.read.delay);
-	ret = inb(chip->spec.ioaddr.ctrl);
+	udelay(TS5500_ADC_READ_DELAY);
+	ret = inb(TS5500_ADC_CTRL_REG);
 
-	if (ret & chip->spec.read.busy_mask) {
-		dev_err(dev, "device not ready (ret=0x0%x, try=%d)\n", ret,
-			range);
+	if (ret & TS5500_ADC_READ_BUSY_MASK) {
+		dev_err(dev, "device not ready\n");
 		ret = -EIO;
 	} else {
 		/* LSB of conversion is at 0x196 and MSB is at 0x197 */
-		u8 lsb = inb(chip->spec.ioaddr.data);
-		u8 msb = inb(chip->spec.ioaddr.data + 1);
+		u8 lsb = inb(TS5500_ADC_INIT_LSB_REG);
+		u8 msb = inb(TS5500_ADC_INIT_LSB_REG + 1);
 		s16 raw = (msb << 8) | lsb;
 		s32 scaled = ts5500_adc_scale(chip, raw, polarity, range);
 
@@ -271,18 +266,18 @@ static ssize_t ts5500_adc_show_input(struct device *dev,
 static ssize_t ts5500_adc_show_name(struct device *dev,
 	struct device_attribute *devattr, char *buf)
 {
-	return sprintf(buf, "%s\n", ts5500_adc_get_drvdata(dev)->spec.name);
+	return sprintf(buf, "%s\n", TS5500_ADC_NAME);
 }
 
-#define TS5500_ADC_HWMON_CHANNEL(chan)				\
-	SENSOR_DEVICE_ATTR(in##chan##_input, S_IRUGO,		\
-			   ts5500_adc_show_input, NULL, chan);	\
-	SENSOR_DEVICE_ATTR_2(in##chan##_max, S_IRUGO | S_IWUSR,	\
-			     ts5500_adc_show_range,		\
-			     ts5500_adc_store_range, 0, chan);	\
-	SENSOR_DEVICE_ATTR_2(in##chan##_min, S_IRUGO | S_IWUSR,	\
-			     ts5500_adc_show_range,		\
-			     ts5500_adc_store_range, 1, chan)	\
+#define TS5500_ADC_HWMON_CHANNEL(chan)					\
+	static SENSOR_DEVICE_ATTR(in##chan##_input, S_IRUGO,		\
+			   ts5500_adc_show_input, NULL, chan);	  	\
+	static SENSOR_DEVICE_ATTR_2(in##chan##_max, S_IRUGO | S_IWUSR,	\
+			     ts5500_adc_show_range,			\
+			     ts5500_adc_store_range, 0, chan);		\
+	static SENSOR_DEVICE_ATTR_2(in##chan##_min, S_IRUGO | S_IWUSR,	\
+			     ts5500_adc_show_range,			\
+			     ts5500_adc_store_range, 1, chan)
 
 #define TS5500_ADC_SYSFS_CHANNEL(chan)				\
 	&sensor_dev_attr_in##chan##_input.dev_attr.attr,	\
@@ -291,14 +286,14 @@ static ssize_t ts5500_adc_show_name(struct device *dev,
 
 static DEVICE_ATTR(name, S_IRUGO, ts5500_adc_show_name, NULL);
 
-static TS5500_ADC_HWMON_CHANNEL(0);
-static TS5500_ADC_HWMON_CHANNEL(1);
-static TS5500_ADC_HWMON_CHANNEL(2);
-static TS5500_ADC_HWMON_CHANNEL(3);
-static TS5500_ADC_HWMON_CHANNEL(4);
-static TS5500_ADC_HWMON_CHANNEL(5);
-static TS5500_ADC_HWMON_CHANNEL(6);
-static TS5500_ADC_HWMON_CHANNEL(7);
+TS5500_ADC_HWMON_CHANNEL(0);
+TS5500_ADC_HWMON_CHANNEL(1);
+TS5500_ADC_HWMON_CHANNEL(2);
+TS5500_ADC_HWMON_CHANNEL(3);
+TS5500_ADC_HWMON_CHANNEL(4);
+TS5500_ADC_HWMON_CHANNEL(5);
+TS5500_ADC_HWMON_CHANNEL(6);
+TS5500_ADC_HWMON_CHANNEL(7);
 
 static const struct attribute_group ts5500_adc_sysfs_group = {
 	.attrs = (struct attribute *[]) {
@@ -317,44 +312,34 @@ static const struct attribute_group ts5500_adc_sysfs_group = {
 
 static int __devinit ts5500_adc_probe(struct platform_device *pdev)
 {
-	struct ts5500_adc_platform_data *pdata = pdev->dev.platform_data;
 	struct ts5500_adc_chip *chip;
 	int ret;
 
-	if (pdata == NULL)
-		return -ENODEV;
-
 	chip = kzalloc(sizeof *chip, GFP_KERNEL);
 	if (!chip)
 		return -ENOMEM;
 
-	chip->spec = *pdata;
-
 	mutex_init(&chip->lock);
-	mutex_lock(&chip->lock);
+	platform_set_drvdata(pdev, chip);
 
 	ret = sysfs_create_group(&pdev->dev.kobj, &ts5500_adc_sysfs_group);
 	if (ret) {
-		dev_err(&pdev->dev, "sysfs_create_group failed.\n");
-		goto error_unlock_and_free;
+		dev_err(&pdev->dev, "sysfs_create_group failed\n");
+		goto error_free;
 	}
 
 	chip->hwmon_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(chip->hwmon_dev)) {
-		dev_err(&pdev->dev, "hwmon_device_register failed.\n");
+		dev_err(&pdev->dev, "hwmon_device_register failed\n");
 		ret = PTR_ERR(chip->hwmon_dev);
 		goto error_unregister_device;
 	}
 
-	platform_set_drvdata(pdev, chip);
-	mutex_unlock(&chip->lock);
 	return 0;
 
 error_unregister_device:
 	sysfs_remove_group(&pdev->dev.kobj, &ts5500_adc_sysfs_group);
-
-error_unlock_and_free:
-	mutex_unlock(&chip->lock);
+error_free:
 	kfree(chip);
 	return ret;
 }
@@ -379,58 +364,23 @@ static struct resource ts5500_adc_resources[] = {
 	}
 };
 
-static struct ts5500_adc_platform_data ts5500_adc_platform_data = {
-	.name = TS5500_ADC_NAME,
-	.ioaddr = {
-		.data = TS5500_ADC_INIT_LSB_REG,
-		.ctrl = TS5500_ADC_CTRL_REG,
-	},
-	.read = {
-		.delay     = TS5500_ADC_READ_DELAY,
-		.busy_mask = TS5500_ADC_READ_BUSY_MASK,
-	},
-	.ctrl = {
-		{ TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_5V,
-		  TS5500_ADC_UNIPOLAR | TS5500_ADC_RANGE_10V },
-		{ TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_5V,
-		  TS5500_ADC_BIPOLAR  | TS5500_ADC_RANGE_10V },
-	},
-	.ranges = {
-		.min = {
-			{  0,     0 },
-			{ -5000, -10000 },
-		},
-		.max = {
-			{  5000,  10000 },
-			{  5000,  10000 },
-		},
-	},
-	.scale = {
-		{ 12207, 24414 },
-		{ 24414, 48828 },
-	},
-};
-
 static struct platform_device ts5500_adc_device = {
 	.name = "ts5500_adc",
 	.id = -1,
 	.resource = ts5500_adc_resources,
 	.num_resources = ARRAY_SIZE(ts5500_adc_resources),
 	.dev = {
-		.platform_data = &ts5500_adc_platform_data,
-		.release = ts5500_adc_release,
-	},
+		.release = ts5500_adc_release
+	}
 };
 
 static int __devexit ts5500_adc_remove(struct platform_device *pdev)
 {
 	struct ts5500_adc_chip *chip = platform_get_drvdata(pdev);
 
-	mutex_lock(&chip->lock);
 	hwmon_device_unregister(chip->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &ts5500_adc_sysfs_group);
 	platform_set_drvdata(pdev, NULL);
-	mutex_unlock(&chip->lock);
 	kfree(chip);
 
 	return 0;
-- 
1.7.6.5

