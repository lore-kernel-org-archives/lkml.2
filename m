Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab1CaO4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:56:54 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57389 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 03/21] staging:iio:max1363 - experimental move to channel_spec registration.
Date: Thu, 31 Mar 2011 15:53:57 +0100
Message-Id: <1301583255-28468-4-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/iio/adc/max1363.h      |    8 +-
 drivers/staging/iio/adc/max1363_core.c | 1277 ++++++++++++--------------------
 drivers/staging/iio/adc/max1363_ring.c |    1 -
 3 files changed, 478 insertions(+), 808 deletions(-)

diff --git a/drivers/staging/iio/adc/max1363.h b/drivers/staging/iio/adc/max1363.h
index 6a8687f..b5a3dcd 100644
--- a/drivers/staging/iio/adc/max1363.h
+++ b/drivers/staging/iio/adc/max1363.h
@@ -152,24 +152,24 @@ enum max1363_modes {
 /**
  * struct max1363_chip_info - chip specifc information
  * @name:		indentification string for chip
- * @num_inputs:		number of physical inputs on chip
  * @bits:		accuracy of the adc in bits
  * @int_vref_mv:	the internal reference voltage
  * @monitor_mode:	whether the chip supports monitor interrupts
  * @mode_list:		array of available scan modes
  * @num_modes:		the number of scan modes available
  * @default_mode:	the scan mode in which the chip starts up
+ * @channel:		channel specification
+ * @num_channels:	number of channels
  */
 struct max1363_chip_info {
-	u8				num_inputs;
 	u8				bits;
 	u16				int_vref_mv;
 	bool				monitor_mode;
 	const enum max1363_modes	*mode_list;
 	int				num_modes;
 	enum max1363_modes		default_mode;
-	struct attribute_group		*dev_attrs;
-	struct attribute_group		*scan_attrs;
+	struct iio_chan_spec *channels;
+	int num_channels;
 };
 
 /**
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index a060b3d..ce4727e 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -42,39 +42,6 @@
 /* Here we claim all are 16 bits. This currently does no harm and saves
  * us a lot of scan element listings */
 
-#define MAX1363_SCAN_EL(number)				\
-	IIO_SCAN_EL_C(in##number, number, 0, NULL);
-#define MAX1363_SCAN_EL_D(p, n, number)					\
-	IIO_SCAN_NAMED_EL_C(in##p##m##in##n, in##p-in##n, number, 0, NULL);
-
-static MAX1363_SCAN_EL(0);
-static MAX1363_SCAN_EL(1);
-static MAX1363_SCAN_EL(2);
-static MAX1363_SCAN_EL(3);
-static MAX1363_SCAN_EL(4);
-static MAX1363_SCAN_EL(5);
-static MAX1363_SCAN_EL(6);
-static MAX1363_SCAN_EL(7);
-static MAX1363_SCAN_EL(8);
-static MAX1363_SCAN_EL(9);
-static MAX1363_SCAN_EL(10);
-static MAX1363_SCAN_EL(11);
-static MAX1363_SCAN_EL_D(0, 1, 12);
-static MAX1363_SCAN_EL_D(2, 3, 13);
-static MAX1363_SCAN_EL_D(4, 5, 14);
-static MAX1363_SCAN_EL_D(6, 7, 15);
-static MAX1363_SCAN_EL_D(8, 9, 16);
-static MAX1363_SCAN_EL_D(10, 11, 17);
-static MAX1363_SCAN_EL_D(1, 0, 18);
-static MAX1363_SCAN_EL_D(3, 2, 19);
-static MAX1363_SCAN_EL_D(5, 4, 20);
-static MAX1363_SCAN_EL_D(7, 6, 21);
-static MAX1363_SCAN_EL_D(9, 8, 22);
-static MAX1363_SCAN_EL_D(11, 10, 23);
-
-static IIO_SCAN_EL_TIMESTAMP(24);
-static IIO_CONST_ATTR_SCAN_EL_TYPE(timestamp, s, 64, 64);
-
 static const struct max1363_mode max1363_mode_table[] = {
 	/* All of the single channel options first */
 	MAX1363_MODE_SINGLE(0, 1 << 0),
@@ -150,58 +117,6 @@ const struct max1363_mode
 	return NULL;
 }
 
-static ssize_t max1363_show_precision_u(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	struct iio_ring_buffer *ring = dev_get_drvdata(dev);
-	struct max1363_state *st = iio_priv(ring->indio_dev);
-	return sprintf(buf, "u%d/16\n", st->chip_info->bits);
-}
-
-static ssize_t max1363_show_precision_s(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	struct iio_ring_buffer *ring = dev_get_drvdata(dev);
-	struct max1363_state *st = iio_priv(ring->indio_dev);
-	return sprintf(buf, "s%d/16\n", st->chip_info->bits);
-}
-
-#define MAX1363_SCAN_TYPE(n)						\
-	DEVICE_ATTR(in##n##_type, S_IRUGO,				\
-		    max1363_show_precision_u, NULL);
-#define MAX1363_SCAN_TYPE_D(p, n)					\
-	struct device_attribute dev_attr_in##p##m##in##n##_type =	\
-		__ATTR(in##p-in##n##_type, S_IRUGO,			\
-		       max1363_show_precision_s, NULL);
-
-static MAX1363_SCAN_TYPE(0);
-static MAX1363_SCAN_TYPE(1);
-static MAX1363_SCAN_TYPE(2);
-static MAX1363_SCAN_TYPE(3);
-static MAX1363_SCAN_TYPE(4);
-static MAX1363_SCAN_TYPE(5);
-static MAX1363_SCAN_TYPE(6);
-static MAX1363_SCAN_TYPE(7);
-static MAX1363_SCAN_TYPE(8);
-static MAX1363_SCAN_TYPE(9);
-static MAX1363_SCAN_TYPE(10);
-static MAX1363_SCAN_TYPE(11);
-
-static MAX1363_SCAN_TYPE_D(0, 1);
-static MAX1363_SCAN_TYPE_D(2, 3);
-static MAX1363_SCAN_TYPE_D(4, 5);
-static MAX1363_SCAN_TYPE_D(6, 7);
-static MAX1363_SCAN_TYPE_D(8, 9);
-static MAX1363_SCAN_TYPE_D(10, 11);
-static MAX1363_SCAN_TYPE_D(1, 0);
-static MAX1363_SCAN_TYPE_D(3, 2);
-static MAX1363_SCAN_TYPE_D(5, 4);
-static MAX1363_SCAN_TYPE_D(7, 6);
-static MAX1363_SCAN_TYPE_D(9, 8);
-static MAX1363_SCAN_TYPE_D(11, 10);
-
 static int max1363_write_basic_config(struct i2c_client *client,
 				      unsigned char d1,
 				      unsigned char d2)
@@ -232,18 +147,17 @@ int max1363_set_scan_mode(struct max1363_state *st)
 					  st->configbyte);
 }
 
-static ssize_t max1363_read_single_channel(struct device *dev,
-				   struct device_attribute *attr,
-				   char *buf)
+static int max1363_read_single_chan(struct iio_dev *indio_dev,
+				    struct iio_chan_spec *chan,
+				    int *val,
+				    long m)
 {
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct max1363_state *st = iio_priv(indio_dev);
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	struct i2c_client *client = st->client;
-	int ret = 0, len = 0;
-	s32 data ;
+	int ret = 0;
+	s32 data;
 	char rxbuf[2];
 	long mask;
+	struct max1363_state *st = iio_priv(indio_dev);
+	struct i2c_client *client = st->client;
 
 	mutex_lock(&indio_dev->mlock);
 	/*
@@ -258,7 +172,7 @@ static ssize_t max1363_read_single_channel(struct device *dev,
 
 	/* If ring buffer capture is occuring, query the buffer */
 	if (iio_ring_enabled(indio_dev)) {
-		mask = max1363_mode_table[this_attr->address].modemask;
+		mask = max1363_mode_table[chan->address].modemask;
 		data = max1363_single_channel_from_ring(mask, st);
 		if (data < 0) {
 			ret = data;
@@ -267,10 +181,10 @@ static ssize_t max1363_read_single_channel(struct device *dev,
 	} else {
 		/* Check to see if current scan mode is correct */
 		if (st->current_mode !=
-		    &max1363_mode_table[this_attr->address]) {
+		    &max1363_mode_table[chan->address]) {
 			/* Update scan mode if needed */
 			st->current_mode
-				= &max1363_mode_table[this_attr->address];
+				= &max1363_mode_table[chan->address];
 			ret = max1363_set_scan_mode(st);
 			if (ret)
 				goto error_ret;
@@ -282,7 +196,6 @@ static ssize_t max1363_read_single_channel(struct device *dev,
 				ret = data;
 				goto error_ret;
 			}
-
 			data = (s32)(rxbuf[1]) | ((s32)(rxbuf[0] & 0x0F)) << 8;
 		} else {
 			/* Get reading */
@@ -294,60 +207,38 @@ static ssize_t max1363_read_single_channel(struct device *dev,
 			data = rxbuf[0];
 		}
 	}
-	/* Pretty print the result */
-	len = sprintf(buf, "%u\n", data);
-
+	*val = data;
 error_ret:
 	mutex_unlock(&indio_dev->mlock);
-	return ret ? ret : len;
+	return ret;
+
 }
 
-/* Direct read attribtues */
-static IIO_DEV_ATTR_IN_RAW(0, max1363_read_single_channel, _s0);
-static IIO_DEV_ATTR_IN_RAW(1, max1363_read_single_channel, _s1);
-static IIO_DEV_ATTR_IN_RAW(2, max1363_read_single_channel, _s2);
-static IIO_DEV_ATTR_IN_RAW(3, max1363_read_single_channel, _s3);
-static IIO_DEV_ATTR_IN_RAW(4, max1363_read_single_channel, _s4);
-static IIO_DEV_ATTR_IN_RAW(5, max1363_read_single_channel, _s5);
-static IIO_DEV_ATTR_IN_RAW(6, max1363_read_single_channel, _s6);
-static IIO_DEV_ATTR_IN_RAW(7, max1363_read_single_channel, _s7);
-static IIO_DEV_ATTR_IN_RAW(8, max1363_read_single_channel, _s8);
-static IIO_DEV_ATTR_IN_RAW(9, max1363_read_single_channel, _s9);
-static IIO_DEV_ATTR_IN_RAW(10, max1363_read_single_channel, _s10);
-static IIO_DEV_ATTR_IN_RAW(11, max1363_read_single_channel, _s11);
-
-static IIO_DEV_ATTR_IN_DIFF_RAW(0, 1, max1363_read_single_channel, d0m1);
-static IIO_DEV_ATTR_IN_DIFF_RAW(2, 3, max1363_read_single_channel, d2m3);
-static IIO_DEV_ATTR_IN_DIFF_RAW(4, 5, max1363_read_single_channel, d4m5);
-static IIO_DEV_ATTR_IN_DIFF_RAW(6, 7, max1363_read_single_channel, d6m7);
-static IIO_DEV_ATTR_IN_DIFF_RAW(8, 9, max1363_read_single_channel, d8m9);
-static IIO_DEV_ATTR_IN_DIFF_RAW(10, 11, max1363_read_single_channel, d10m11);
-static IIO_DEV_ATTR_IN_DIFF_RAW(1, 0, max1363_read_single_channel, d1m0);
-static IIO_DEV_ATTR_IN_DIFF_RAW(3, 2, max1363_read_single_channel, d3m2);
-static IIO_DEV_ATTR_IN_DIFF_RAW(5, 4, max1363_read_single_channel, d5m4);
-static IIO_DEV_ATTR_IN_DIFF_RAW(7, 6, max1363_read_single_channel, d7m6);
-static IIO_DEV_ATTR_IN_DIFF_RAW(9, 8, max1363_read_single_channel, d9m8);
-static IIO_DEV_ATTR_IN_DIFF_RAW(11, 10, max1363_read_single_channel, d11m10);
-
-
-static ssize_t max1363_show_scale(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
+static int max1363_read_raw(struct iio_dev *indio_dev,
+			    struct iio_chan_spec *chan,
+			    int *val,
+			    long m)
 {
-	/* Driver currently only support internal vref */
-	struct max1363_state *st = iio_priv(dev_get_drvdata(dev));
-	/* Corresponds to Vref / 2^(bits) */
+	struct max1363_state *st = iio_priv(indio_dev);
 
-	if ((1 << (st->chip_info->bits + 1))
-	    > st->chip_info->int_vref_mv)
-		return sprintf(buf, "0.5\n");
-	else
-		return sprintf(buf, "%d\n",
-			st->chip_info->int_vref_mv >> st->chip_info->bits);
+	switch (m) {
+	case 0:
+		return max1363_read_single_chan(indio_dev, chan, val, m);
+		break;
+	case (1 << IIO_CHAN_INFO_SCALE_SHARED):
+		if ((1 << (st->chip_info->bits + 1)) >
+		    st->chip_info->int_vref_mv)
+			*val = 500000;
+		else
+			*val = (1000000*st->chip_info->int_vref_mv)
+				>> st->chip_info->bits;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
 }
 
-static IIO_DEVICE_ATTR(in_scale, S_IRUGO, max1363_show_scale, NULL, 0);
-
 static ssize_t max1363_show_name(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
@@ -366,17 +257,119 @@ static const enum max1363_modes max1363_mode_list[] = {
 	d0m1to2m3, d1m0to3m2,
 };
 
+static int max1363_int_th(struct iio_dev *indio_dev,
+			int index,
+			s64 timestamp,
+			int not_test)
+{
+	struct max1363_state *st = iio_priv(indio_dev);
+
+	st->last_timestamp = timestamp;
+	schedule_work(&st->thresh_work);
+	return 0;
+}
+
+IIO_EVENT_SH(max1363_thresh, max1363_int_th);
+
+#define MAX1363_EV_M						\
+	(IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING)	\
+	 | IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING))
+#define MAX1363_INFO_MASK (1 << IIO_CHAN_INFO_SCALE_SHARED)
+
+static struct iio_chan_spec max1363_channels[] = {
+	IIO_CHAN_EV(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0,
+		    IIO_ST('u', 12, 16, 0),
+		    MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_EV(IIO_IN, 1, MAX1363_INFO_MASK,
+		    _s1, 1, IIO_ST('u', 12, 16, 0),
+		    MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_EV(IIO_IN, 2, MAX1363_INFO_MASK,
+		    _s2, 2, IIO_ST('u', 12, 16, 0),
+		    MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_EV(IIO_IN, 3, MAX1363_INFO_MASK,
+		    _s3, 3, IIO_ST('u', 12, 16, 0),
+		    MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_COMPOUND_EV(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			     d0m1, 4, IIO_ST('s', 12, 16, 0),
+			     MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_COMPOUND_EV(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			     d2m3, 5, IIO_ST('s', 12, 16, 0),
+			     MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_COMPOUND_EV(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			     d1m0, 6, IIO_ST('s', 12, 16, 0),
+			     MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_COMPOUND_EV(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			     d3m2, 7, IIO_ST('s', 12, 16, 0),
+			     MAX1363_EV_M, &iio_event_max1363_thresh),
+	IIO_CHAN_SOFT_TIMESTAMP(8)
+};
+
+static struct iio_chan_spec max1236_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s1, 1, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s2, 2, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s3, 3, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 4, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 5, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 6, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 7, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(8)
+};
+
+static struct iio_chan_spec max1361_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s1, 1, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s2, 2, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s3, 3, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 4, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 5, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 6, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 7, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(8)
+};
+
+static struct iio_chan_spec max1136_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s1, 1, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s2, 2, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s3, 3, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 4, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 5, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 6, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 7, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(8)
+};
+
+static struct iio_chan_spec max1036_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s1, 1, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s2, 2, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s3, 3, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 4, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 5, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 6, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 7, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(8)
+};
+
 static struct attribute *max1363_device_attrs[] = {
-	&iio_dev_attr_in0_raw.dev_attr.attr,
-	&iio_dev_attr_in1_raw.dev_attr.attr,
-	&iio_dev_attr_in2_raw.dev_attr.attr,
-	&iio_dev_attr_in3_raw.dev_attr.attr,
-	&iio_dev_attr_in0min1_raw.dev_attr.attr,
-	&iio_dev_attr_in2min3_raw.dev_attr.attr,
-	&iio_dev_attr_in1min0_raw.dev_attr.attr,
-	&iio_dev_attr_in3min2_raw.dev_attr.attr,
 	&iio_dev_attr_name.dev_attr.attr,
-	&iio_dev_attr_in_scale.dev_attr.attr,
 	NULL
 };
 
@@ -384,34 +377,6 @@ static struct attribute_group max1363_dev_attr_group = {
 	.attrs = max1363_device_attrs,
 };
 
-static struct attribute *max1363_scan_el_attrs[] = {
-	&iio_scan_el_in0.dev_attr.attr,	&dev_attr_in0_type.attr,
-	&iio_const_attr_in0_index.dev_attr.attr,
-	&iio_scan_el_in1.dev_attr.attr,	&dev_attr_in1_type.attr,
-	&iio_const_attr_in1_index.dev_attr.attr,
-	&iio_scan_el_in2.dev_attr.attr,	&dev_attr_in2_type.attr,
-	&iio_const_attr_in2_index.dev_attr.attr,
-	&iio_scan_el_in3.dev_attr.attr,	&dev_attr_in3_type.attr,
-	&iio_const_attr_in3_index.dev_attr.attr,
-	&iio_scan_el_in0min1.dev_attr.attr,	&dev_attr_in0min1_type.attr,
-	&iio_const_attr_in0min1_index.dev_attr.attr,
-	&iio_scan_el_in2min3.dev_attr.attr,	&dev_attr_in2min3_type.attr,
-	&iio_const_attr_in2min3_index.dev_attr.attr,
-	&iio_scan_el_in1min0.dev_attr.attr,	&dev_attr_in1min0_type.attr,
-	&iio_const_attr_in1min0_index.dev_attr.attr,
-	&iio_scan_el_in3min2.dev_attr.attr,	&dev_attr_in3min2_type.attr,
-	&iio_const_attr_in3min2_index.dev_attr.attr,
-	&iio_const_attr_timestamp_index.dev_attr.attr,
-	&iio_scan_el_timestamp.dev_attr.attr,
-	&iio_const_attr_timestamp_type.dev_attr.attr,
-	NULL,
-};
-
-static struct attribute_group max1363_scan_el_group = {
-	.name = "scan_elements",
-	.attrs = max1363_scan_el_attrs,
-};
-
 /* Appies to max1236, max1237 */
 static const enum max1363_modes max1236_mode_list[] = {
 	_s0, _s1, _s2, _s3,
@@ -434,101 +399,130 @@ static const enum max1363_modes max1238_mode_list[] = {
 	d6m7to8m9, d6m7to10m11, d7m6to9m8, d7m6to11m10,
 };
 
-static struct attribute *max1238_device_attrs[] = {
-	&iio_dev_attr_in0_raw.dev_attr.attr,
-	&iio_dev_attr_in1_raw.dev_attr.attr,
-	&iio_dev_attr_in2_raw.dev_attr.attr,
-	&iio_dev_attr_in3_raw.dev_attr.attr,
-	&iio_dev_attr_in4_raw.dev_attr.attr,
-	&iio_dev_attr_in5_raw.dev_attr.attr,
-	&iio_dev_attr_in6_raw.dev_attr.attr,
-	&iio_dev_attr_in7_raw.dev_attr.attr,
-	&iio_dev_attr_in8_raw.dev_attr.attr,
-	&iio_dev_attr_in9_raw.dev_attr.attr,
-	&iio_dev_attr_in10_raw.dev_attr.attr,
-	&iio_dev_attr_in11_raw.dev_attr.attr,
-	&iio_dev_attr_in0min1_raw.dev_attr.attr,
-	&iio_dev_attr_in2min3_raw.dev_attr.attr,
-	&iio_dev_attr_in4min5_raw.dev_attr.attr,
-	&iio_dev_attr_in6min7_raw.dev_attr.attr,
-	&iio_dev_attr_in8min9_raw.dev_attr.attr,
-	&iio_dev_attr_in10min11_raw.dev_attr.attr,
-	&iio_dev_attr_in1min0_raw.dev_attr.attr,
-	&iio_dev_attr_in3min2_raw.dev_attr.attr,
-	&iio_dev_attr_in5min4_raw.dev_attr.attr,
-	&iio_dev_attr_in7min6_raw.dev_attr.attr,
-	&iio_dev_attr_in9min8_raw.dev_attr.attr,
-	&iio_dev_attr_in11min10_raw.dev_attr.attr,
-	&iio_dev_attr_name.dev_attr.attr,
-	&iio_dev_attr_in_scale.dev_attr.attr,
-	NULL
+static struct iio_chan_spec max1038_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s0, 1, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s0, 2, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s0, 3, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 4, MAX1363_INFO_MASK, _s0, 4, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 5, MAX1363_INFO_MASK, _s0, 5, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 6, MAX1363_INFO_MASK, _s0, 6, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 7, MAX1363_INFO_MASK, _s0, 7, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 8, MAX1363_INFO_MASK, _s0, 8, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 9, MAX1363_INFO_MASK, _s0, 9, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 10, MAX1363_INFO_MASK, _s0, 10, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 11, MAX1363_INFO_MASK, _s0, 11, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 12, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 13, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 4, 5, MAX1363_INFO_MASK,
+			  d4m5, 14, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 6, 7, MAX1363_INFO_MASK,
+			  d6m7, 15, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 8, 9, MAX1363_INFO_MASK,
+			  d8m9, 16, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 10, 11, MAX1363_INFO_MASK,
+			  d10m11, 17, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 18, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 19, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 5, 4, MAX1363_INFO_MASK,
+			  d5m4, 20, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 7, 6, MAX1363_INFO_MASK,
+			  d7m6, 21, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 9, 8, MAX1363_INFO_MASK,
+			  d9m8, 22, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 11, 10, MAX1363_INFO_MASK,
+			  d11m10, 23, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(24)
 };
 
-static struct attribute_group max1238_dev_attr_group = {
-	.attrs = max1238_device_attrs,
-};
-
-static struct attribute *max1238_scan_el_attrs[] = {
-	&iio_scan_el_in0.dev_attr.attr,	&dev_attr_in0_type.attr,
-	&iio_const_attr_in0_index.dev_attr.attr,
-	&iio_scan_el_in1.dev_attr.attr,	&dev_attr_in1_type.attr,
-	&iio_const_attr_in1_index.dev_attr.attr,
-	&iio_scan_el_in2.dev_attr.attr,	&dev_attr_in2_type.attr,
-	&iio_const_attr_in2_index.dev_attr.attr,
-	&iio_scan_el_in3.dev_attr.attr,	&dev_attr_in3_type.attr,
-	&iio_const_attr_in3_index.dev_attr.attr,
-	&iio_scan_el_in4.dev_attr.attr,	&dev_attr_in4_type.attr,
-	&iio_const_attr_in4_index.dev_attr.attr,
-	&iio_scan_el_in5.dev_attr.attr,	&dev_attr_in5_type.attr,
-	&iio_const_attr_in5_index.dev_attr.attr,
-	&iio_scan_el_in6.dev_attr.attr,	&dev_attr_in6_type.attr,
-	&iio_const_attr_in6_index.dev_attr.attr,
-	&iio_scan_el_in7.dev_attr.attr,	&dev_attr_in7_type.attr,
-	&iio_const_attr_in7_index.dev_attr.attr,
-	&iio_scan_el_in8.dev_attr.attr,	&dev_attr_in8_type.attr,
-	&iio_const_attr_in8_index.dev_attr.attr,
-	&iio_scan_el_in9.dev_attr.attr,	&dev_attr_in9_type.attr,
-	&iio_const_attr_in9_index.dev_attr.attr,
-	&iio_scan_el_in10.dev_attr.attr,	&dev_attr_in10_type.attr,
-	&iio_const_attr_in10_index.dev_attr.attr,
-	&iio_scan_el_in11.dev_attr.attr,	&dev_attr_in11_type.attr,
-	&iio_const_attr_in11_index.dev_attr.attr,
-	&iio_scan_el_in0min1.dev_attr.attr,	&dev_attr_in0min1_type.attr,
-	&iio_const_attr_in0min1_index.dev_attr.attr,
-	&iio_scan_el_in2min3.dev_attr.attr,	&dev_attr_in2min3_type.attr,
-	&iio_const_attr_in2min3_index.dev_attr.attr,
-	&iio_scan_el_in4min5.dev_attr.attr,	&dev_attr_in4min5_type.attr,
-	&iio_const_attr_in4min5_index.dev_attr.attr,
-	&iio_scan_el_in6min7.dev_attr.attr,	&dev_attr_in6min7_type.attr,
-	&iio_const_attr_in6min7_index.dev_attr.attr,
-	&iio_scan_el_in8min9.dev_attr.attr,	&dev_attr_in8min9_type.attr,
-	&iio_const_attr_in8min9_index.dev_attr.attr,
-	&iio_scan_el_in10min11.dev_attr.attr,	&dev_attr_in10min11_type.attr,
-	&iio_const_attr_in10min11_index.dev_attr.attr,
-	&iio_scan_el_in1min0.dev_attr.attr,	&dev_attr_in1min0_type.attr,
-	&iio_const_attr_in1min0_index.dev_attr.attr,
-	&iio_scan_el_in3min2.dev_attr.attr,	&dev_attr_in3min2_type.attr,
-	&iio_const_attr_in3min2_index.dev_attr.attr,
-	&iio_scan_el_in5min4.dev_attr.attr,	&dev_attr_in5min4_type.attr,
-	&iio_const_attr_in5min4_index.dev_attr.attr,
-	&iio_scan_el_in7min6.dev_attr.attr,	&dev_attr_in7min6_type.attr,
-	&iio_const_attr_in7min6_index.dev_attr.attr,
-	&iio_scan_el_in9min8.dev_attr.attr,	&dev_attr_in9min8_type.attr,
-	&iio_const_attr_in9min8_index.dev_attr.attr,
-	&iio_scan_el_in11min10.dev_attr.attr,	&dev_attr_in11min10_type.attr,
-	&iio_const_attr_in11min10_index.dev_attr.attr,
-	&iio_const_attr_timestamp_index.dev_attr.attr,
-	&iio_scan_el_timestamp.dev_attr.attr,
-	&iio_const_attr_timestamp_type.dev_attr.attr,
-	NULL,
+static struct iio_chan_spec max1138_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s0, 1, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s0, 2, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s0, 3, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 4, MAX1363_INFO_MASK, _s0, 4, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 5, MAX1363_INFO_MASK, _s0, 5, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 6, MAX1363_INFO_MASK, _s0, 6, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 7, MAX1363_INFO_MASK, _s0, 7, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 8, MAX1363_INFO_MASK, _s0, 8, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 9, MAX1363_INFO_MASK, _s0, 9, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 10, MAX1363_INFO_MASK, _s0, 10,
+		 IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 11, MAX1363_INFO_MASK, _s0, 11,
+		 IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 12, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 13, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 4, 5, MAX1363_INFO_MASK,
+			  d4m5, 14, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 6, 7, MAX1363_INFO_MASK,
+			  d6m7, 15, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 8, 9, MAX1363_INFO_MASK,
+			  d8m9, 16, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 10, 11, MAX1363_INFO_MASK,
+			  d10m11, 17, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 18, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 19, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 5, 4, MAX1363_INFO_MASK,
+			  d5m4, 20, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 7, 6, MAX1363_INFO_MASK,
+			  d7m6, 21, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 9, 8, MAX1363_INFO_MASK,
+			  d9m8, 22, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 11, 10, MAX1363_INFO_MASK,
+			  d11m10, 23, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(24)
 };
 
-static struct attribute_group max1238_scan_el_group = {
-	.name = "scan_elements",
-	.attrs = max1238_scan_el_attrs,
+static struct iio_chan_spec max1238_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s0, 1, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s0, 2, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s0, 3, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 4, MAX1363_INFO_MASK, _s0, 4, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 5, MAX1363_INFO_MASK, _s0, 5, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 6, MAX1363_INFO_MASK, _s0, 6, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 7, MAX1363_INFO_MASK, _s0, 7, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 8, MAX1363_INFO_MASK, _s0, 8, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 9, MAX1363_INFO_MASK, _s0, 9, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 10, MAX1363_INFO_MASK, _s0,
+		 10, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 11, MAX1363_INFO_MASK, _s0,
+		 11, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 12, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 13, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 4, 5, MAX1363_INFO_MASK,
+			  d4m5, 14, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 6, 7, MAX1363_INFO_MASK,
+			  d6m7, 15, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 8, 9, MAX1363_INFO_MASK,
+			  d8m9, 16, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 10, 11, MAX1363_INFO_MASK,
+			  d10m11, 17, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 18, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 19, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 5, 4, MAX1363_INFO_MASK,
+			  d5m4, 20, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 7, 6, MAX1363_INFO_MASK,
+			  d7m6, 21, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 9, 8, MAX1363_INFO_MASK,
+			  d9m8, 22, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 11, 10, MAX1363_INFO_MASK,
+			  d11m10, 23, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(24)
 };
 
-
 static const enum max1363_modes max11607_mode_list[] = {
 	_s0, _s1, _s2, _s3,
 	s0to1, s0to2, s0to3,
@@ -547,74 +541,88 @@ static const enum max1363_modes max11608_mode_list[] = {
 	d1m0to3m2, d1m0to5m4, d1m0to7m6,
 };
 
-static struct attribute *max11608_device_attrs[] = {
-	&iio_dev_attr_in0_raw.dev_attr.attr,
-	&iio_dev_attr_in1_raw.dev_attr.attr,
-	&iio_dev_attr_in2_raw.dev_attr.attr,
-	&iio_dev_attr_in3_raw.dev_attr.attr,
-	&iio_dev_attr_in4_raw.dev_attr.attr,
-	&iio_dev_attr_in5_raw.dev_attr.attr,
-	&iio_dev_attr_in6_raw.dev_attr.attr,
-	&iio_dev_attr_in7_raw.dev_attr.attr,
-	&iio_dev_attr_in0min1_raw.dev_attr.attr,
-	&iio_dev_attr_in2min3_raw.dev_attr.attr,
-	&iio_dev_attr_in4min5_raw.dev_attr.attr,
-	&iio_dev_attr_in6min7_raw.dev_attr.attr,
-	&iio_dev_attr_in1min0_raw.dev_attr.attr,
-	&iio_dev_attr_in3min2_raw.dev_attr.attr,
-	&iio_dev_attr_in5min4_raw.dev_attr.attr,
-	&iio_dev_attr_in7min6_raw.dev_attr.attr,
-	&iio_dev_attr_name.dev_attr.attr,
-	&iio_dev_attr_in_scale.dev_attr.attr,
-	NULL
-};
-
-static struct attribute_group max11608_dev_attr_group = {
-	.attrs = max11608_device_attrs,
+static struct iio_chan_spec max11602_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s0, 1, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s0, 2, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s0, 3, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 4, MAX1363_INFO_MASK, _s0, 4, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 5, MAX1363_INFO_MASK, _s0, 5, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 6, MAX1363_INFO_MASK, _s0, 6, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN(IIO_IN, 7, MAX1363_INFO_MASK, _s0, 7, IIO_ST('u', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 8, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 9, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 4, 5, MAX1363_INFO_MASK,
+			  d4m5, 10, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 6, 7, MAX1363_INFO_MASK,
+			  d6m7, 11, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 12, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 13, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 5, 4, MAX1363_INFO_MASK,
+			  d5m4, 14, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 7, 6, MAX1363_INFO_MASK,
+			  d7m6, 15, IIO_ST('s', 8, 8, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(16)
 };
 
-static struct attribute *max11608_scan_el_attrs[] = {
-	&iio_scan_el_in0.dev_attr.attr,	&dev_attr_in0_type.attr,
-	&iio_const_attr_in0_index.dev_attr.attr,
-	&iio_scan_el_in1.dev_attr.attr,	&dev_attr_in1_type.attr,
-	&iio_const_attr_in1_index.dev_attr.attr,
-	&iio_scan_el_in2.dev_attr.attr,	&dev_attr_in2_type.attr,
-	&iio_const_attr_in2_index.dev_attr.attr,
-	&iio_scan_el_in3.dev_attr.attr,	&dev_attr_in3_type.attr,
-	&iio_const_attr_in3_index.dev_attr.attr,
-	&iio_scan_el_in4.dev_attr.attr,	&dev_attr_in4_type.attr,
-	&iio_const_attr_in4_index.dev_attr.attr,
-	&iio_scan_el_in5.dev_attr.attr,	&dev_attr_in5_type.attr,
-	&iio_const_attr_in5_index.dev_attr.attr,
-	&iio_scan_el_in6.dev_attr.attr,	&dev_attr_in6_type.attr,
-	&iio_const_attr_in6_index.dev_attr.attr,
-	&iio_scan_el_in7.dev_attr.attr,	&dev_attr_in7_type.attr,
-	&iio_const_attr_in7_index.dev_attr.attr,
-	&iio_scan_el_in0min1.dev_attr.attr,	&dev_attr_in0min1_type.attr,
-	&iio_const_attr_in0min1_index.dev_attr.attr,
-	&iio_scan_el_in2min3.dev_attr.attr,	&dev_attr_in2min3_type.attr,
-	&iio_const_attr_in2min3_index.dev_attr.attr,
-	&iio_scan_el_in4min5.dev_attr.attr,	&dev_attr_in4min5_type.attr,
-	&iio_const_attr_in4min5_index.dev_attr.attr,
-	&iio_scan_el_in6min7.dev_attr.attr,	&dev_attr_in6min7_type.attr,
-	&iio_const_attr_in6min7_index.dev_attr.attr,
-	&iio_scan_el_in1min0.dev_attr.attr,	&dev_attr_in1min0_type.attr,
-	&iio_const_attr_in1min0_index.dev_attr.attr,
-	&iio_scan_el_in3min2.dev_attr.attr,	&dev_attr_in3min2_type.attr,
-	&iio_const_attr_in3min2_index.dev_attr.attr,
-	&iio_scan_el_in5min4.dev_attr.attr,	&dev_attr_in5min4_type.attr,
-	&iio_const_attr_in5min4_index.dev_attr.attr,
-	&iio_scan_el_in7min6.dev_attr.attr,	&dev_attr_in7min6_type.attr,
-	&iio_const_attr_in7min6_index.dev_attr.attr,
-	&iio_const_attr_timestamp_index.dev_attr.attr,
-	&iio_scan_el_timestamp.dev_attr.attr,
-	&iio_const_attr_timestamp_type.dev_attr.attr,
-	NULL
+static struct iio_chan_spec max11608_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s0, 1, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s0, 2, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s0, 3, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 4, MAX1363_INFO_MASK, _s0, 4, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 5, MAX1363_INFO_MASK, _s0, 5, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 6, MAX1363_INFO_MASK, _s0, 6, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN(IIO_IN, 7, MAX1363_INFO_MASK, _s0, 7, IIO_ST('u', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 8, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 9, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 4, 5, MAX1363_INFO_MASK,
+			  d4m5, 10, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 6, 7, MAX1363_INFO_MASK,
+			  d6m7, 11, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 12, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 13, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 5, 4, MAX1363_INFO_MASK,
+			  d5m4, 14, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 7, 6, MAX1363_INFO_MASK,
+			  d7m6, 15, IIO_ST('s', 10, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(16)
 };
 
-static struct attribute_group max11608_scan_el_group = {
-	.name = "scan_elements",
-	.attrs = max11608_scan_el_attrs,
+static struct iio_chan_spec max11614_channels[] = {
+	IIO_CHAN(IIO_IN, 0, MAX1363_INFO_MASK, _s0, 0, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 1, MAX1363_INFO_MASK, _s0, 1, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 2, MAX1363_INFO_MASK, _s0, 2, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 3, MAX1363_INFO_MASK, _s0, 3, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 4, MAX1363_INFO_MASK, _s0, 4, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 5, MAX1363_INFO_MASK, _s0, 5, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 6, MAX1363_INFO_MASK, _s0, 6, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN(IIO_IN, 7, MAX1363_INFO_MASK, _s0, 7, IIO_ST('u', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 0, 1, MAX1363_INFO_MASK,
+			  d0m1, 8, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 2, 3, MAX1363_INFO_MASK,
+			  d2m3, 9, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 4, 5, MAX1363_INFO_MASK,
+			  d4m5, 10, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 6, 7, MAX1363_INFO_MASK,
+			  d6m7, 11, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 1, 0, MAX1363_INFO_MASK,
+			  d1m0, 12, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 3, 2, MAX1363_INFO_MASK,
+			  d3m2, 13, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 5, 4, MAX1363_INFO_MASK,
+			  d5m4, 14, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_COMPOUND(IIO_IN_DIFF, 7, 6, MAX1363_INFO_MASK,
+			  d7m6, 15, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(16)
 };
 
 enum { max1361,
@@ -656,348 +664,314 @@ enum { max1361,
 /* max1363 and max1368 tested - rest from data sheet */
 static const struct max1363_chip_info max1363_chip_info_tbl[] = {
 	[max1361] = {
-		.num_inputs = 4,
 		.bits = 10,
 		.int_vref_mv = 2048,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1361_channels,
+		.num_channels = ARRAY_SIZE(max1361_channels),
 	},
 	[max1362] = {
-		.num_inputs = 4,
 		.bits = 10,
 		.int_vref_mv = 4096,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1361_channels,
+		.num_channels = ARRAY_SIZE(max1361_channels),
 	},
 	[max1363] = {
-		.num_inputs = 4,
 		.bits = 12,
 		.int_vref_mv = 2048,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1363_channels,
+		.num_channels = ARRAY_SIZE(max1363_channels),
 	},
 	[max1364] = {
-		.num_inputs = 4,
 		.bits = 12,
 		.int_vref_mv = 4096,
 		.monitor_mode = 1,
 		.mode_list = max1363_mode_list,
 		.num_modes = ARRAY_SIZE(max1363_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1363_channels,
+		.num_channels = ARRAY_SIZE(max1363_channels),
 	},
 	[max1036] = {
-		.num_inputs = 4,
 		.bits = 8,
 		.int_vref_mv = 4096,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1036_channels,
+		.num_channels = ARRAY_SIZE(max1036_channels),
 	},
 	[max1037] = {
-		.num_inputs = 4,
 		.bits = 8,
 		.int_vref_mv = 2048,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1036_channels,
+		.num_channels = ARRAY_SIZE(max1036_channels),
 	},
 	[max1038] = {
-		.num_inputs = 12,
 		.bits = 8,
 		.int_vref_mv = 4096,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1038_channels,
+		.num_channels = ARRAY_SIZE(max1038_channels),
 	},
 	[max1039] = {
-		.num_inputs = 12,
 		.bits = 8,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1038_channels,
+		.num_channels = ARRAY_SIZE(max1038_channels),
 	},
 	[max1136] = {
-		.num_inputs = 4,
 		.bits = 10,
 		.int_vref_mv = 4096,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1136_channels,
+		.num_channels = ARRAY_SIZE(max1136_channels),
 	},
 	[max1137] = {
-		.num_inputs = 4,
 		.bits = 10,
 		.int_vref_mv = 2048,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1136_channels,
+		.num_channels = ARRAY_SIZE(max1136_channels),
 	},
 	[max1138] = {
-		.num_inputs = 12,
 		.bits = 10,
 		.int_vref_mv = 4096,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1138_channels,
+		.num_channels = ARRAY_SIZE(max1138_channels),
 	},
 	[max1139] = {
-		.num_inputs = 12,
 		.bits = 10,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1138_channels,
+		.num_channels = ARRAY_SIZE(max1138_channels),
 	},
 	[max1236] = {
-		.num_inputs = 4,
 		.bits = 12,
 		.int_vref_mv = 4096,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1236_channels,
+		.num_channels = ARRAY_SIZE(max1236_channels),
 	},
 	[max1237] = {
-		.num_inputs = 4,
 		.bits = 12,
 		.int_vref_mv = 2048,
 		.mode_list = max1236_mode_list,
 		.num_modes = ARRAY_SIZE(max1236_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1236_channels,
+		.num_channels = ARRAY_SIZE(max1236_channels),
 	},
 	[max1238] = {
-		.num_inputs = 12,
 		.bits = 12,
 		.int_vref_mv = 4096,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	},
 	[max1239] = {
-		.num_inputs = 12,
 		.bits = 12,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	},
 	[max11600] = {
-		.num_inputs = 4,
 		.bits = 8,
 		.int_vref_mv = 4096,
 		.mode_list = max11607_mode_list,
 		.num_modes = ARRAY_SIZE(max11607_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1036_channels,
+		.num_channels = ARRAY_SIZE(max1036_channels),
 	},
 	[max11601] = {
-		.num_inputs = 4,
 		.bits = 8,
 		.int_vref_mv = 2048,
 		.mode_list = max11607_mode_list,
 		.num_modes = ARRAY_SIZE(max11607_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1036_channels,
+		.num_channels = ARRAY_SIZE(max1036_channels),
 	},
 	[max11602] = {
-		.num_inputs = 8,
 		.bits = 8,
 		.int_vref_mv = 4096,
 		.mode_list = max11608_mode_list,
 		.num_modes = ARRAY_SIZE(max11608_mode_list),
 		.default_mode = s0to7,
-		.dev_attrs = &max11608_dev_attr_group,
-		.scan_attrs = &max11608_scan_el_group,
+		.channels = max11602_channels,
+		.num_channels = ARRAY_SIZE(max11602_channels),
 	},
 	[max11603] = {
-		.num_inputs = 8,
 		.bits = 8,
 		.int_vref_mv = 2048,
 		.mode_list = max11608_mode_list,
 		.num_modes = ARRAY_SIZE(max11608_mode_list),
 		.default_mode = s0to7,
-		.dev_attrs = &max11608_dev_attr_group,
-		.scan_attrs = &max11608_scan_el_group,
+		.channels = max11602_channels,
+		.num_channels = ARRAY_SIZE(max11602_channels),
 	},
 	[max11604] = {
-		.num_inputs = 12,
 		.bits = 8,
 		.int_vref_mv = 4098,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	},
 	[max11605] = {
-		.num_inputs = 12,
 		.bits = 8,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	},
 	[max11606] = {
-		.num_inputs = 4,
 		.bits = 10,
 		.int_vref_mv = 4096,
 		.mode_list = max11607_mode_list,
 		.num_modes = ARRAY_SIZE(max11607_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1136_channels,
+		.num_channels = ARRAY_SIZE(max1136_channels),
 	},
 	[max11607] = {
-		.num_inputs = 4,
 		.bits = 10,
 		.int_vref_mv = 2048,
 		.mode_list = max11607_mode_list,
 		.num_modes = ARRAY_SIZE(max11607_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1136_channels,
+		.num_channels = ARRAY_SIZE(max1136_channels),
 	},
 	[max11608] = {
-		.num_inputs = 8,
 		.bits = 10,
 		.int_vref_mv = 4096,
 		.mode_list = max11608_mode_list,
 		.num_modes = ARRAY_SIZE(max11608_mode_list),
 		.default_mode = s0to7,
-		.dev_attrs = &max11608_dev_attr_group,
-		.scan_attrs = &max11608_scan_el_group,
+		.channels = max11608_channels,
+		.num_channels = ARRAY_SIZE(max11608_channels),
 	},
 	[max11609] = {
-		.num_inputs = 8,
 		.bits = 10,
 		.int_vref_mv = 2048,
 		.mode_list = max11608_mode_list,
 		.num_modes = ARRAY_SIZE(max11608_mode_list),
 		.default_mode = s0to7,
-		.dev_attrs = &max11608_dev_attr_group,
-		.scan_attrs = &max11608_scan_el_group,
+		.channels = max11608_channels,
+		.num_channels = ARRAY_SIZE(max11608_channels),
 	},
 	[max11610] = {
-		.num_inputs = 12,
 		.bits = 10,
 		.int_vref_mv = 4098,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	},
 	[max11611] = {
-		.num_inputs = 12,
 		.bits = 10,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	},
 	[max11612] = {
-		.num_inputs = 4,
 		.bits = 12,
 		.int_vref_mv = 4096,
 		.mode_list = max11607_mode_list,
 		.num_modes = ARRAY_SIZE(max11607_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1363_channels,
+		.num_channels = ARRAY_SIZE(max1363_channels),
 	},
 	[max11613] = {
-		.num_inputs = 4,
 		.bits = 12,
 		.int_vref_mv = 2048,
 		.mode_list = max11607_mode_list,
 		.num_modes = ARRAY_SIZE(max11607_mode_list),
 		.default_mode = s0to3,
-		.dev_attrs = &max1363_dev_attr_group,
-		.scan_attrs = &max1363_scan_el_group,
+		.channels = max1363_channels,
+		.num_channels = ARRAY_SIZE(max1363_channels),
 	},
 	[max11614] = {
-		.num_inputs = 8,
 		.bits = 12,
 		.int_vref_mv = 4096,
 		.mode_list = max11608_mode_list,
 		.num_modes = ARRAY_SIZE(max11608_mode_list),
 		.default_mode = s0to7,
-		.dev_attrs = &max11608_dev_attr_group,
-		.scan_attrs = &max11608_scan_el_group,
+		.channels = max11614_channels,
+		.num_channels = ARRAY_SIZE(max11614_channels),
 	},
 	[max11615] = {
-		.num_inputs = 8,
 		.bits = 12,
 		.int_vref_mv = 2048,
 		.mode_list = max11608_mode_list,
 		.num_modes = ARRAY_SIZE(max11608_mode_list),
 		.default_mode = s0to7,
-		.dev_attrs = &max11608_dev_attr_group,
-		.scan_attrs = &max11608_scan_el_group,
+		.channels = max11614_channels,
+		.num_channels = ARRAY_SIZE(max11614_channels),
 	},
 	[max11616] = {
-		.num_inputs = 12,
 		.bits = 12,
 		.int_vref_mv = 4098,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	},
 	[max11617] = {
-		.num_inputs = 12,
 		.bits = 12,
 		.int_vref_mv = 2048,
 		.mode_list = max1238_mode_list,
 		.num_modes = ARRAY_SIZE(max1238_mode_list),
 		.default_mode = s0to11,
-		.dev_attrs = &max1238_dev_attr_group,
-		.scan_attrs = &max1238_scan_el_group,
+		.channels = max1238_channels,
+		.num_channels = ARRAY_SIZE(max1238_channels),
 	}
 };
 
@@ -1048,51 +1022,24 @@ static IIO_DEV_ATTR_SAMP_FREQ(S_IRUGO | S_IWUSR,
 static IIO_CONST_ATTR(sampling_frequency_available,
 		"133000 665000 33300 16600 8300 4200 2000 1000");
 
-static ssize_t max1363_show_thresh(struct device *dev,
-				struct device_attribute *attr,
-				char *buf,
-				bool high)
+static int max1363_read_thresh(struct iio_dev *indio_dev,
+			       int event_code,
+			       int *val)
 {
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct max1363_state *st = iio_priv(indio_dev);
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-
-	if (high)
-		return sprintf(buf, "%d\n",
-			st->thresh_high[this_attr->address]);
+	if (IIO_EVENT_CODE_EXTRACT_DIR(event_code) == IIO_EV_DIR_FALLING)
+		*val = st->thresh_low[IIO_EVENT_CODE_EXTRACT_NUM(event_code)];
 	else
-		return sprintf(buf, "%d\n",
-			st->thresh_low[this_attr->address & 0x7]);
-}
-
-static ssize_t max1363_show_thresh_low(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	return max1363_show_thresh(dev, attr, buf, false);
-}
-
-static ssize_t max1363_show_thresh_high(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
-{
-	return max1363_show_thresh(dev, attr, buf, true);
+		*val = st->thresh_high[IIO_EVENT_CODE_EXTRACT_NUM(event_code)];
+	return 0;
 }
 
-static ssize_t max1363_store_thresh_unsigned(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf,
-					size_t len,
-					bool high)
+static int max1363_write_thresh(struct iio_dev *indio_dev,
+				int event_code,
+				int val)
 {
-	struct max1363_state *st = iio_priv(dev_get_drvdata(dev));
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	unsigned long val;
-	int ret;
-
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
-		return -EINVAL;
+	struct max1363_state *st = iio_priv(indio_dev);
+	/* make it handle signed correctly as well */
 	switch (st->chip_info->bits) {
 	case 10:
 		if (val > 0x3FF)
@@ -1104,154 +1051,15 @@ static ssize_t max1363_store_thresh_unsigned(struct device *dev,
 		break;
 	}
 
-	switch (high) {
-	case 1:
-		st->thresh_high[this_attr->address] = val;
+	switch (IIO_EVENT_CODE_EXTRACT_DIR(event_code)) {
+	case IIO_EV_DIR_FALLING:
+		st->thresh_low[IIO_EVENT_CODE_EXTRACT_NUM(event_code)] = val;
 		break;
-	case 0:
-		st->thresh_low[this_attr->address & 0x7] = val;
+	case IIO_EV_DIR_RISING:
+		st->thresh_high[IIO_EVENT_CODE_EXTRACT_NUM(event_code)] = val;
 		break;
 	}
 
-	return len;
-}
-
-static ssize_t max1363_store_thresh_high_unsigned(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf,
-						size_t len)
-{
-	return max1363_store_thresh_unsigned(dev, attr, buf, len, true);
-}
-
-static ssize_t max1363_store_thresh_low_unsigned(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf,
-						size_t len)
-{
-	return max1363_store_thresh_unsigned(dev, attr, buf, len, false);
-}
-
-static ssize_t max1363_store_thresh_signed(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf,
-					size_t len,
-					bool high)
-{
-	struct max1363_state *st = iio_priv(dev_get_drvdata(dev));
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	long val;
-	int ret;
-
-	ret = strict_strtol(buf, 10, &val);
-	if (ret)
-		return -EINVAL;
-	switch (st->chip_info->bits) {
-	case 10:
-		if (val < -512 || val > 511)
-			return -EINVAL;
-		break;
-	case 12:
-		if (val < -2048 || val > 2047)
-			return -EINVAL;
-		break;
-	}
-
-	switch (high) {
-	case 1:
-		st->thresh_high[this_attr->address] = val;
-		break;
-	case 0:
-		st->thresh_low[this_attr->address & 0x7] = val;
-		break;
-	}
-
-	return len;
-}
-
-static ssize_t max1363_store_thresh_high_signed(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf,
-						size_t len)
-{
-	return max1363_store_thresh_signed(dev, attr, buf, len, true);
-}
-
-static ssize_t max1363_store_thresh_low_signed(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf,
-						size_t len)
-{
-	return max1363_store_thresh_signed(dev, attr, buf, len, false);
-}
-
-static IIO_DEVICE_ATTR(in0_thresh_high_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_high,
-		max1363_store_thresh_high_unsigned, 0);
-static IIO_DEVICE_ATTR(in0_thresh_low_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_low,
-		max1363_store_thresh_low_unsigned, 0);
-static IIO_DEVICE_ATTR(in1_thresh_high_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_high,
-		max1363_store_thresh_high_unsigned, 1);
-static IIO_DEVICE_ATTR(in1_thresh_low_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_low,
-		max1363_store_thresh_low_unsigned, 1);
-static IIO_DEVICE_ATTR(in2_thresh_high_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_high,
-		max1363_store_thresh_high_unsigned, 2);
-static IIO_DEVICE_ATTR(in2_thresh_low_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_low,
-		max1363_store_thresh_low_unsigned, 2);
-static IIO_DEVICE_ATTR(in3_thresh_high_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_high,
-		max1363_store_thresh_high_unsigned, 3);
-static IIO_DEVICE_ATTR(in3_thresh_low_value, S_IRUGO | S_IWUSR,
-		max1363_show_thresh_low,
-		max1363_store_thresh_low_unsigned, 3);
-
-static IIO_DEVICE_ATTR_NAMED(in0min1_thresh_high_value,
-			in0-in1_thresh_high_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_high,
-			max1363_store_thresh_high_signed, 4);
-static IIO_DEVICE_ATTR_NAMED(in0min1_thresh_low_value,
-			in0-in1_thresh_low_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_low,
-			max1363_store_thresh_low_signed, 4);
-static IIO_DEVICE_ATTR_NAMED(in2min3_thresh_high_value,
-			in2-in3_thresh_high_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_high,
-			max1363_store_thresh_high_signed, 5);
-static IIO_DEVICE_ATTR_NAMED(in2min3_thresh_low_value,
-			in2-in3_thresh_low_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_low,
-			max1363_store_thresh_low_signed, 5);
-static IIO_DEVICE_ATTR_NAMED(in1min0_thresh_high_value,
-			in1-in0_thresh_high_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_high,
-			max1363_store_thresh_high_signed, 6);
-static IIO_DEVICE_ATTR_NAMED(in1min0_thresh_low_value,
-			in1-in0_thresh_low_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_low,
-			max1363_store_thresh_low_signed, 6);
-static IIO_DEVICE_ATTR_NAMED(in3min2_thresh_high_value,
-			in3-in2_thresh_high_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_high,
-			max1363_store_thresh_high_signed, 7);
-static IIO_DEVICE_ATTR_NAMED(in3min2_thresh_low_value,
-			in3-in2_thresh_low_value,
-			S_IRUGO | S_IWUSR, max1363_show_thresh_low,
-			max1363_store_thresh_low_signed, 7);
-
-static int max1363_int_th(struct iio_dev *indio_dev,
-			int index,
-			s64 timestamp,
-			int not_test)
-{
-	struct max1363_state *st = iio_priv(indio_dev);
-
-	st->last_timestamp = timestamp;
-	schedule_work(&st->thresh_work);
 	return 0;
 }
 
@@ -1265,6 +1073,7 @@ static void max1363_thresh_handler_bh(struct work_struct *work_s)
 		     MAX1363_MON_INT_ENABLE | (st->monitor_speed << 1) | 0xF0 };
 
 	i2c_master_recv(st->client, &rx, 1);
+	/* todo - begging for use of for_each_set_bit */
 	if (rx & (1 << 0))
 		iio_push_event(indio_dev, 0,
 			IIO_EVENT_CODE_IN_LOW_THRESH(3),
@@ -1301,23 +1110,21 @@ static void max1363_thresh_handler_bh(struct work_struct *work_s)
 	i2c_master_send(st->client, tx, 2);
 }
 
-static ssize_t max1363_read_interrupt_config(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
+static int max1363_read_event_config(struct iio_dev *indio_dev,
+				     int event_code)
 {
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct max1363_state *st = iio_priv(indio_dev);
-	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
-	int val;
 
+	int val;
+	int number = IIO_EVENT_CODE_EXTRACT_NUM(event_code);
 	mutex_lock(&indio_dev->mlock);
-	if (this_attr->mask & 0x8)
-		val = (1 << (this_attr->mask & 0x7)) & st->mask_low;
+	if (IIO_EVENT_CODE_EXTRACT_DIR(event_code) == IIO_EV_DIR_FALLING)
+		val = (1 << number) & st->mask_low;
 	else
-		val = (1 << this_attr->mask) & st->mask_high;
+		val = (1 << number) & st->mask_high;
 	mutex_unlock(&indio_dev->mlock);
 
-	return sprintf(buf, "%d\n", !!val);
+	return val;
 }
 
 static int max1363_monitor_mode_update(struct max1363_state *st, int enabled)
@@ -1434,6 +1241,7 @@ error_ret:
  * To keep this managable we always use one of 3 scan modes.
  * Scan 0...3, 0-1,2-3 and 1-0,3-2
  */
+
 static inline int __max1363_check_event_mask(int thismask, int checkmask)
 {
 	int ret = 0;
@@ -1454,206 +1262,61 @@ error_ret:
 	return ret;
 }
 
-static ssize_t max1363_write_interrupt_config(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf,
-					size_t len)
+static int max1363_write_event_config(struct iio_dev *indio_dev,
+				      int event_code,
+				      struct iio_event_handler_list *listel,
+				      int state)
 {
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	int ret = 0;
 	struct max1363_state *st = iio_priv(indio_dev);
-	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
-	unsigned long val;
-	int ret;
 	u16 unifiedmask;
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
-		return -EINVAL;
+	int number = IIO_EVENT_CODE_EXTRACT_NUM(event_code);
+
 	mutex_lock(&indio_dev->mlock);
 	unifiedmask = st->mask_low | st->mask_high;
-	if (this_attr->mask & 0x08) {
-		/* If we are disabling no need to test */
-		if (val == 0)
-			st->mask_low &= ~(1 << (this_attr->mask & 0x7));
+	if (IIO_EVENT_CODE_EXTRACT_DIR(event_code) == IIO_EV_DIR_FALLING) {
+
+		if (state == 0)
+			st->mask_low &= ~(1 << number);
 		else {
-			ret = __max1363_check_event_mask(this_attr->mask & 0x7,
-							unifiedmask);
+			ret = __max1363_check_event_mask((1 << number),
+							 unifiedmask);
 			if (ret)
 				goto error_ret;
-			st->mask_low |= (1 << (this_attr->mask & 0x7));
+			st->mask_low |= (1 << number);
 		}
 	} else {
-		if (val == 0)
-			st->mask_high &= ~(1 << (this_attr->mask));
+		if (state == 0)
+			st->mask_high &= ~(1 << number);
 		else {
-			ret = __max1363_check_event_mask(this_attr->mask,
-							unifiedmask);
+			ret = __max1363_check_event_mask((1 << number),
+							 unifiedmask);
 			if (ret)
 				goto error_ret;
-			st->mask_high |= (1 << this_attr->mask);
+			st->mask_high |= (1 << number);
 		}
 	}
 	if (st->monitor_on && !st->mask_high && !st->mask_low)
-		iio_remove_event_from_list(this_attr->listel,
-					&indio_dev->interrupts[0]->ev_list);
-	if (!st->monitor_on && val)
-		iio_add_event_to_list(this_attr->listel,
-				&indio_dev->interrupts[0]->ev_list);
+		iio_remove_event_from_list(listel,
+					   &indio_dev->interrupts[0]->ev_list);
+	if (!st->monitor_on && state)
+		iio_add_event_to_list(listel,
+				      &indio_dev->interrupts[0]->ev_list);
 
 	max1363_monitor_mode_update(st, !!(st->mask_high | st->mask_low));
 error_ret:
 	mutex_unlock(&indio_dev->mlock);
 
-	return len;
+	return ret;
 }
 
-IIO_EVENT_SH(max1363_thresh, max1363_int_th);
-
-#define MAX1363_HIGH_THRESH(a) a
-#define MAX1363_LOW_THRESH(a) (a | 0x8)
-
-IIO_EVENT_ATTR_SH(in0_thresh_high_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_HIGH_THRESH(0));
-
-IIO_EVENT_ATTR_SH(in0_thresh_low_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_LOW_THRESH(0));
-
-IIO_EVENT_ATTR_SH(in1_thresh_high_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_HIGH_THRESH(1));
-
-IIO_EVENT_ATTR_SH(in1_thresh_low_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_LOW_THRESH(1));
-
-IIO_EVENT_ATTR_SH(in2_thresh_high_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_HIGH_THRESH(2));
-
-IIO_EVENT_ATTR_SH(in2_thresh_low_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_LOW_THRESH(2));
-
-IIO_EVENT_ATTR_SH(in3_thresh_high_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_HIGH_THRESH(3));
-
-IIO_EVENT_ATTR_SH(in3_thresh_low_en,
-		iio_event_max1363_thresh,
-		max1363_read_interrupt_config,
-		max1363_write_interrupt_config,
-		MAX1363_LOW_THRESH(3));
-
-IIO_EVENT_ATTR_NAMED_SH(in0min1_thresh_high_en,
-			in0-in1_thresh_high_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_HIGH_THRESH(4));
-
-IIO_EVENT_ATTR_NAMED_SH(in0min1_thresh_low_en,
-			in0-in1_thresh_low_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_LOW_THRESH(4));
-
-IIO_EVENT_ATTR_NAMED_SH(in3min2_thresh_high_en,
-			in3-in2_thresh_high_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_HIGH_THRESH(5));
-
-IIO_EVENT_ATTR_NAMED_SH(in3min2_thresh_low_en,
-			in3-in2_thresh_low_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_LOW_THRESH(5));
-
-IIO_EVENT_ATTR_NAMED_SH(in1min0_thresh_high_en,
-			in1-in0_thresh_high_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_HIGH_THRESH(6));
-
-IIO_EVENT_ATTR_NAMED_SH(in1min0_thresh_low_en,
-			in1-in0_thresh_low_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_LOW_THRESH(6));
-
-IIO_EVENT_ATTR_NAMED_SH(in2min3_thresh_high_en,
-			in2-in3_thresh_high_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_HIGH_THRESH(7));
-
-IIO_EVENT_ATTR_NAMED_SH(in2min3_thresh_low_en,
-			in2-in3_thresh_low_en,
-			iio_event_max1363_thresh,
-			max1363_read_interrupt_config,
-			max1363_write_interrupt_config,
-			MAX1363_LOW_THRESH(7));
-
 /*
  * As with scan_elements, only certain sets of these can
  * be combined.
  */
 static struct attribute *max1363_event_attributes[] = {
-	&iio_dev_attr_in0_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in0_thresh_low_value.dev_attr.attr,
-	&iio_dev_attr_in1_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in1_thresh_low_value.dev_attr.attr,
-	&iio_dev_attr_in2_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in2_thresh_low_value.dev_attr.attr,
-	&iio_dev_attr_in3_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in3_thresh_low_value.dev_attr.attr,
-	&iio_dev_attr_in0min1_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in0min1_thresh_low_value.dev_attr.attr,
-	&iio_dev_attr_in2min3_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in2min3_thresh_low_value.dev_attr.attr,
-	&iio_dev_attr_in1min0_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in1min0_thresh_low_value.dev_attr.attr,
-	&iio_dev_attr_in3min2_thresh_high_value.dev_attr.attr,
-	&iio_dev_attr_in3min2_thresh_low_value.dev_attr.attr,
 	&iio_dev_attr_sampling_frequency.dev_attr.attr,
 	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
-	&iio_event_attr_in0_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in0_thresh_low_en.dev_attr.attr,
-	&iio_event_attr_in1_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in1_thresh_low_en.dev_attr.attr,
-	&iio_event_attr_in2_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in2_thresh_low_en.dev_attr.attr,
-	&iio_event_attr_in3_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in3_thresh_low_en.dev_attr.attr,
-	&iio_event_attr_in0min1_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in0min1_thresh_low_en.dev_attr.attr,
-	&iio_event_attr_in3min2_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in3min2_thresh_low_en.dev_attr.attr,
-	&iio_event_attr_in1min0_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in1min0_thresh_low_en.dev_attr.attr,
-	&iio_event_attr_in2min3_thresh_high_en.dev_attr.attr,
-	&iio_event_attr_in2min3_thresh_low_en.dev_attr.attr,
 	NULL,
 };
 
@@ -1721,8 +1384,14 @@ static int __devinit max1363_probe(struct i2c_client *client,
 			.modemask;
 	/* Estabilish that the iio_dev is a child of the i2c device */
 	indio_dev->dev.parent = &client->dev;
-	indio_dev->attrs = st->chip_info->dev_attrs;
-
+	indio_dev->attrs = &max1363_dev_attr_group;
+	indio_dev->read_event_value = &max1363_read_thresh;
+	indio_dev->write_event_value = &max1363_write_thresh;
+	indio_dev->read_event_config = &max1363_read_event_config;
+	indio_dev->write_event_config = &max1363_write_event_config;
+	indio_dev->channels = st->chip_info->channels;
+	indio_dev->num_channels = st->chip_info->num_channels;
+	indio_dev->read_raw = &max1363_read_raw;
 	/* Todo: this shouldn't be here. */
 	indio_dev->driver_module = THIS_MODULE;
 	indio_dev->modes = INDIO_DIRECT_MODE;
@@ -1744,7 +1413,9 @@ static int __devinit max1363_probe(struct i2c_client *client,
 	if (ret)
 		goto error_cleanup_ring;
 	regdone = 1;
-	ret = iio_ring_buffer_register(indio_dev->ring, 0);
+	ret = iio_ring_buffer_register_ex(indio_dev->ring, 0,
+					  st->chip_info->channels,
+					  st->chip_info->num_channels);
 	if (ret)
 		goto error_cleanup_ring;
 
@@ -1754,9 +1425,9 @@ static int __devinit max1363_probe(struct i2c_client *client,
 						0,
 						IRQF_TRIGGER_RISING,
 						client->name);
+
 		if (ret)
 			goto error_uninit_ring;
-
 		INIT_WORK(&st->thresh_work, max1363_thresh_handler_bh);
 	}
 
diff --git a/drivers/staging/iio/adc/max1363_ring.c b/drivers/staging/iio/adc/max1363_ring.c
index 944ff7a..caebe44 100644
--- a/drivers/staging/iio/adc/max1363_ring.c
+++ b/drivers/staging/iio/adc/max1363_ring.c
@@ -199,7 +199,6 @@ int max1363_register_ring_funcs_and_init(struct iio_dev *indio_dev)
 		goto error_deallocate_sw_rb;
 
 	/* Ring buffer functions - here trigger setup related */
-	indio_dev->ring->scan_el_attrs = st->chip_info->scan_attrs;
 	indio_dev->ring->postenable = &iio_triggered_ring_postenable;
 	indio_dev->ring->preenable = &max1363_ring_preenable;
 	indio_dev->ring->predisable = &iio_triggered_ring_predisable;
-- 
1.7.3.4

