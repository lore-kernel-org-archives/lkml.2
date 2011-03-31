Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab1CaO53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:57:29 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57385 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 02/21] staging:iio:lis3l02dq - experimental move to new channel_spec approach.
Date: Thu, 31 Mar 2011 15:53:56 +0100
Message-Id: <1301583255-28468-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/iio/accel/lis3l02dq.h      |   13 +-
 drivers/staging/iio/accel/lis3l02dq_core.c |  541 +++++++++++-----------------
 drivers/staging/iio/accel/lis3l02dq_ring.c |  227 +++++-------
 3 files changed, 306 insertions(+), 475 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index 579b3a2..1d90b7d 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -188,9 +188,9 @@ int lis3l02dq_spi_write_reg_8(struct device *dev,
 void lis3l02dq_remove_trigger(struct iio_dev *indio_dev);
 int lis3l02dq_probe_trigger(struct iio_dev *indio_dev);
 
-ssize_t lis3l02dq_read_accel_from_ring(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf);
+ssize_t lis3l02dq_read_accel_from_ring(struct iio_ring_buffer *ring,
+				       int index,
+				       int *val);
 
 
 int lis3l02dq_configure_ring(struct iio_dev *indio_dev);
@@ -215,11 +215,10 @@ static inline int lis3l02dq_probe_trigger(struct iio_dev *indio_dev)
 {
 	return 0;
 }
-
 static inline ssize_t
-lis3l02dq_read_accel_from_ring(struct device *dev,
-			       struct device_attribute *attr,
-			       char *buf)
+lis3l02dq_read_accel_from_ring(struct iio_ring_buffer *ring,
+			       int index,
+			       int *val)
 {
 	return 0;
 }
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index b5d6711..5d22116 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -39,20 +39,11 @@
  * This means that use cannot be made of spi_write etc.
  */
 
-/**
- * lis3l02dq_spi_read_reg_8() - read single byte from a single register
- * @dev: device asosciated with child of actual device (iio_dev or iio_trig)
- * @reg_address: the address of the register to be read
- * @val: pass back the resulting value
- **/
-int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
+static int __lis3l02dq_spi_read_reg_8(struct lis3l02dq_state *st,
+				      u8 reg_address, u8 *val)
 {
-	int ret;
 	struct spi_message msg;
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct iio_sw_ring_helper_state *h = iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
-
+	int ret;
 	struct spi_transfer xfer = {
 		.tx_buf = st->tx,
 		.rx_buf = st->rx,
@@ -73,6 +64,19 @@ int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
 
 	return ret;
 }
+/**
+ * lis3l02dq_spi_read_reg_8() - read single byte from a single register
+ * @dev: device asosciated with child of actual device (iio_dev or iio_trig)
+ * @reg_address: the address of the register to be read
+ * @val: pass back the resulting value
+ **/
+int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_sw_ring_helper_state *h = iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
+	return __lis3l02dq_spi_read_reg_8(st, reg_address, val);
+}
 
 /**
  * lis3l02dq_spi_write_reg_8() - write single byte to a register
@@ -154,23 +158,13 @@ static int lis3l02dq_spi_write_reg_s16(struct device *dev,
 	return ret;
 }
 
-/**
- * lisl302dq_spi_read_reg_s16() - write 2 bytes to a pair of registers
- * @dev: device associated with child of actual device (iio_dev or iio_trig)
- * @reg_address: the address of the lower of the two registers. Second register
- *               is assumed to have address one greater.
- * @val: somewhere to pass back the value read
- **/
-static int lis3l02dq_spi_read_reg_s16(struct device *dev,
-				      u8 lower_reg_address,
-				      s16 *val)
+static int lis3l02dq_read_16bit_s(struct lis3l02dq_state *st,
+				  u8 lower_reg_address,
+				  int *val)
 {
 	struct spi_message msg;
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 	int ret;
+	s16 tempval;
 	struct spi_transfer xfers[] = { {
 			.tx_buf = st->tx,
 			.rx_buf = st->rx,
@@ -182,15 +176,14 @@ static int lis3l02dq_spi_read_reg_s16(struct device *dev,
 			.rx_buf = st->rx + 2,
 			.bits_per_word = 8,
 			.len = 2,
-			.cs_change = 1,
-
+			.cs_change = 0,
 		},
 	};
 
 	mutex_lock(&st->buf_lock);
 	st->tx[0] = LIS3L02DQ_READ_REG(lower_reg_address);
 	st->tx[1] = 0;
-	st->tx[2] = LIS3L02DQ_READ_REG(lower_reg_address+1);
+	st->tx[2] = LIS3L02DQ_READ_REG(lower_reg_address + 1);
 	st->tx[3] = 0;
 
 	spi_message_init(&msg);
@@ -201,135 +194,102 @@ static int lis3l02dq_spi_read_reg_s16(struct device *dev,
 		dev_err(&st->us->dev, "problem when reading 16 bit register");
 		goto error_ret;
 	}
-	*val = (s16)(st->rx[1]) | ((s16)(st->rx[3]) << 8);
+	tempval = (s16)(st->rx[1]) | ((s16)(st->rx[3]) << 8);
 
+	*val = tempval;
 error_ret:
 	mutex_unlock(&st->buf_lock);
 	return ret;
 }
 
-/**
- * lis3l02dq_read_signed() - attribute function used for 8 bit signed values
- * @dev: the child device associated with the iio_dev or iio_trigger
- * @attr: the attribute being processed
- * @buf: buffer into which put the output string
- **/
-static ssize_t lis3l02dq_read_signed(struct device *dev,
-				     struct device_attribute *attr,
-				     char *buf)
-{
-	int ret;
-	s8 val;
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-
-	ret = lis3l02dq_spi_read_reg_8(dev, this_attr->address, (u8 *)&val);
-
-	return ret ? ret : sprintf(buf, "%d\n", val);
-}
-
-static ssize_t lis3l02dq_read_unsigned(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
-{
-	int ret;
-	u8 val;
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-
-	ret = lis3l02dq_spi_read_reg_8(dev, this_attr->address, &val);
-
-	return ret ? ret : sprintf(buf, "%d\n", val);
-}
-
-static ssize_t lis3l02dq_write_signed(struct device *dev,
-				      struct device_attribute *attr,
-				      const char *buf,
-				      size_t len)
-{
-	long valin;
-	s8 val;
-	int ret;
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-
-	ret = strict_strtol(buf, 10, &valin);
-	if (ret)
-		goto error_ret;
-	val = valin;
-	ret = lis3l02dq_spi_write_reg_8(dev, this_attr->address, (u8 *)&val);
-
-error_ret:
-	return ret ? ret : len;
-}
-
-static ssize_t lis3l02dq_write_unsigned(struct device *dev,
-					struct device_attribute *attr,
-					const char *buf,
-					size_t len)
-{
-	int ret;
-	ulong valin;
-	u8 val;
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-
-	ret = strict_strtoul(buf, 10, &valin);
-	if (ret)
-		goto err_ret;
-	val = valin;
-	ret = lis3l02dq_spi_write_reg_8(dev, this_attr->address, &val);
+enum lis3l02dq_rm_ind {
+	LIS3L02DQ_ACCEL,
+	LIS3L02DQ_GAIN,
+	LIS3L02DQ_BIAS,
+};
 
-err_ret:
-	return ret ? ret : len;
-}
+static u8 lis3l02dq_axis_map[3][3] = {
+	[LIS3L02DQ_ACCEL] = { LIS3L02DQ_REG_OUT_X_L_ADDR,
+			      LIS3L02DQ_REG_OUT_Y_L_ADDR,
+			      LIS3L02DQ_REG_OUT_Z_L_ADDR },
+	[LIS3L02DQ_GAIN] = { LIS3L02DQ_REG_GAIN_X_ADDR,
+			     LIS3L02DQ_REG_GAIN_Y_ADDR,
+			     LIS3L02DQ_REG_GAIN_Z_ADDR },
+	[LIS3L02DQ_BIAS] = { LIS3L02DQ_REG_OFFSET_X_ADDR,
+			     LIS3L02DQ_REG_OFFSET_Y_ADDR,
+			     LIS3L02DQ_REG_OFFSET_Z_ADDR }
+};
 
-static ssize_t lis3l02dq_read_16bit_signed(struct device *dev,
-					   struct device_attribute *attr,
-					   char *buf)
+static int lis3l02dq_read_thresh(struct iio_dev *indio_dev,
+				 int e,
+				 int *val)
 {
-	int ret;
-	s16 val = 0;
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-
-	ret = lis3l02dq_spi_read_reg_s16(dev, this_attr->address, &val);
-
-	if (ret)
-		return ret;
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
-	return sprintf(buf, "%d\n", val);
+	return lis3l02dq_read_16bit_s(st, LIS3L02DQ_REG_THS_L_ADDR, val);
 }
 
-static ssize_t lis3l02dq_read_accel(struct device *dev,
-				    struct device_attribute *attr,
-				    char *buf)
+static int lis3l02dq_write_thresh(struct iio_dev *indio_dev,
+				  int event_code,
+				  int val)
 {
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	ssize_t ret;
-
-	/* Take the iio_dev status lock */
-	mutex_lock(&indio_dev->mlock);
-	if (indio_dev->currentmode == INDIO_RING_TRIGGERED)
-		ret = lis3l02dq_read_accel_from_ring(dev, attr, buf);
-	else
-		ret =  lis3l02dq_read_16bit_signed(dev, attr, buf);
-	mutex_unlock(&indio_dev->mlock);
-
-	return ret;
+	u16 value = val;
+	return lis3l02dq_spi_write_reg_s16(&indio_dev->dev,
+					   LIS3L02DQ_REG_THS_L_ADDR,
+					   value);
 }
 
-static ssize_t lis3l02dq_write_16bit_signed(struct device *dev,
-					    struct device_attribute *attr,
-					    const char *buf,
-					    size_t len)
+static int lis3l02dq_read_raw(struct iio_dev *indio_dev,
+			      struct iio_chan_spec *chan,
+			      int *val,
+			      long mask)
 {
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	int ret;
-	long val;
+	u8 utemp;
+	s8 stemp;
+	ssize_t ret = 0;
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
+	u8 reg;
+	switch (mask) {
+	case 0:
+		/* Take the iio_dev status lock */
+		mutex_lock(&indio_dev->mlock);
+		if (indio_dev->currentmode == INDIO_RING_TRIGGERED)
+			ret = lis3l02dq_read_accel_from_ring(indio_dev->ring,
+							     chan->scan_index,
+							     val);
+		else {
+			reg = lis3l02dq_axis_map
+				[LIS3L02DQ_ACCEL][chan->address];
+			ret = lis3l02dq_read_16bit_s(st, reg, val);
+		}
+		mutex_unlock(&indio_dev->mlock);
+		break;
+	case (1 << IIO_CHAN_INFO_SCALE_SHARED):
+		*val = 9580;
+		break;
+	case (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE):
+		reg = lis3l02dq_axis_map[LIS3L02DQ_GAIN][chan->address];
+		ret = __lis3l02dq_spi_read_reg_8(st, reg, &utemp);
+		if (ret)
+			goto error_ret;
+		/* to match with what previous code does */
+		*val = 1000000*utemp;
+		break;
 
-	ret = strict_strtol(buf, 10, &val);
-	if (ret)
-		goto error_ret;
-	ret = lis3l02dq_spi_write_reg_s16(dev, this_attr->address, val);
+	case (1 << IIO_CHAN_INFO_CALIBBIAS_SEPARATE):
+		reg = lis3l02dq_axis_map[LIS3L02DQ_BIAS][chan->address];
+		ret = __lis3l02dq_spi_read_reg_8(st, reg, (u8 *)&stemp);
+		/* to match with what previous code does */
+		*val = 1000000*stemp;
+		break;
 
+	}
 error_ret:
-	return ret ? ret : len;
+	return ret;
 }
 
 static ssize_t lis3l02dq_read_frequency(struct device *dev,
@@ -469,159 +429,130 @@ err_ret:
 	return ret;
 }
 
-#define LIS3L02DQ_SIGNED_ATTR(name, reg)	\
-	IIO_DEVICE_ATTR(name,			\
-			S_IWUSR | S_IRUGO,	\
-			lis3l02dq_read_signed,	\
-			lis3l02dq_write_signed, \
-			reg);
-
-#define LIS3L02DQ_UNSIGNED_ATTR(name, reg)		\
-	IIO_DEVICE_ATTR(name,				\
-			S_IWUSR | S_IRUGO,		\
-			lis3l02dq_read_unsigned,	\
-			lis3l02dq_write_unsigned,	\
-			reg);
-
-static LIS3L02DQ_SIGNED_ATTR(accel_x_calibbias,
-			     LIS3L02DQ_REG_OFFSET_X_ADDR);
-static LIS3L02DQ_SIGNED_ATTR(accel_y_calibbias,
-			     LIS3L02DQ_REG_OFFSET_Y_ADDR);
-static LIS3L02DQ_SIGNED_ATTR(accel_z_calibbias,
-			     LIS3L02DQ_REG_OFFSET_Z_ADDR);
-
-static LIS3L02DQ_UNSIGNED_ATTR(accel_x_calibscale,
-			       LIS3L02DQ_REG_GAIN_X_ADDR);
-static LIS3L02DQ_UNSIGNED_ATTR(accel_y_calibscale,
-			       LIS3L02DQ_REG_GAIN_Y_ADDR);
-static LIS3L02DQ_UNSIGNED_ATTR(accel_z_calibscale,
-			       LIS3L02DQ_REG_GAIN_Z_ADDR);
-
-static IIO_DEVICE_ATTR(accel_raw_mag_value,
-		       S_IWUSR | S_IRUGO,
-		       lis3l02dq_read_16bit_signed,
-		       lis3l02dq_write_16bit_signed,
-		       LIS3L02DQ_REG_THS_L_ADDR);
-/* RFC The reading method for these will change depending on whether
- * ring buffer capture is in use. Is it worth making these take two
- * functions and let the core handle which to call, or leave as in this
- * driver where it is the drivers problem to manage this?
- */
-
-static IIO_DEV_ATTR_ACCEL_X(lis3l02dq_read_accel,
-			    LIS3L02DQ_REG_OUT_X_L_ADDR);
-
-static IIO_DEV_ATTR_ACCEL_Y(lis3l02dq_read_accel,
-			    LIS3L02DQ_REG_OUT_Y_L_ADDR);
-
-static IIO_DEV_ATTR_ACCEL_Z(lis3l02dq_read_accel,
-			    LIS3L02DQ_REG_OUT_Z_L_ADDR);
-
 static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
 			      lis3l02dq_read_frequency,
 			      lis3l02dq_write_frequency);
 
 static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("280 560 1120 4480");
 
-static ssize_t lis3l02dq_read_interrupt_config(struct device *dev,
-					       struct device_attribute *attr,
-					       char *buf)
+static int lis3l02dq_thresh_handler_th(struct iio_dev *indio_dev,
+				       int index,
+				       s64 timestamp,
+				       int no_test)
 {
-	int ret;
-	s8 val;
-	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
-	ret = lis3l02dq_spi_read_reg_8(dev->parent,
-				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
-				       (u8 *)&val);
+	/* Stash the timestamp somewhere convenient for the bh */
+	st->thresh_timestamp = timestamp;
+	schedule_work(&st->work_thresh);
 
-	return ret ? ret : sprintf(buf, "%d\n", !!(val & this_attr->mask));
+	return 0;
 }
 
-static ssize_t lis3l02dq_write_interrupt_config(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf,
-						size_t len)
-{
-	struct iio_event_attr *this_attr = to_iio_event_attr(attr);
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	int ret, currentlyset, changed = 0;
-	u8 valold, controlold;
-	bool val;
+/* A shared handler for a number of threshold types */
+IIO_EVENT_SH(threshold, &lis3l02dq_thresh_handler_th);
 
-	val = !(buf[0] == '0');
 
-	mutex_lock(&indio_dev->mlock);
-	/* read current value */
-	ret = lis3l02dq_spi_read_reg_8(dev->parent,
+#define LIS3L02DQ_INFO_MASK				\
+	((1 << IIO_CHAN_INFO_SCALE_SHARED) |		\
+	 (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE) |	\
+	 (1 << IIO_CHAN_INFO_CALIBBIAS_SEPARATE))
+
+#define LIS3L02DQ_EVENT_MASK					\
+	(IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) |	\
+	 IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING))
+
+static struct iio_chan_spec lis3l02dq_channels[] = {
+	IIO_CHAN_EV(IIO_ACCEL, 'x', LIS3L02DQ_INFO_MASK,
+		    0, 0, IIO_ST('s', 12, 16, 0),
+		    LIS3L02DQ_EVENT_MASK, &iio_event_threshold),
+	IIO_CHAN_EV(IIO_ACCEL, 'y', LIS3L02DQ_INFO_MASK,
+		    1, 1, IIO_ST('s', 12, 16, 0),
+		    LIS3L02DQ_EVENT_MASK, &iio_event_threshold),
+	IIO_CHAN(IIO_ACCEL, 'z', LIS3L02DQ_INFO_MASK,
+		 2, 2, IIO_ST('s', 12, 16, 0)),
+	IIO_CHAN_SOFT_TIMESTAMP(3)
+};
+
+
+static ssize_t lis3l02dq_read_event_config(struct iio_dev *indio_dev,
+					   int event_code)
+{
+
+	u8 val;
+	int ret;
+	u8 mask = (1 << (IIO_EVENT_CODE_EXTRACT_MODIFIER(event_code)*2 +
+			 (IIO_EVENT_CODE_EXTRACT_DIR(event_code) ==
+			  IIO_EV_DIR_RISING)));
+	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
 				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
-				       &valold);
-	if (ret)
-		goto error_mutex_unlock;
+				       &val);
+	if (ret < 0)
+		return ret;
+
+	return !!(val & mask);
+}
+
+static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
+					int event_code,
+					struct iio_event_handler_list *list_el,
+					int state)
+{
+	int ret = 0;
+	u8 val, control;
+	u8 currentlyset;
+	bool changed = false;
+	u8 mask = (1 << (IIO_EVENT_CODE_EXTRACT_MODIFIER(event_code)*2 +
+			 (IIO_EVENT_CODE_EXTRACT_DIR(event_code) ==
+			  IIO_EV_DIR_RISING)));
 
+	mutex_lock(&indio_dev->mlock);
 	/* read current control */
-	ret = lis3l02dq_spi_read_reg_8(dev,
+	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
 				       LIS3L02DQ_REG_CTRL_2_ADDR,
-				       &controlold);
+				       &control);
 	if (ret)
-		goto error_mutex_unlock;
-	currentlyset = !!(valold & this_attr->mask);
-	if (val == false && currentlyset) {
-		valold &= ~this_attr->mask;
-		changed = 1;
-		iio_remove_event_from_list(this_attr->listel,
-						 &indio_dev->interrupts[0]
-						 ->ev_list);
-	} else if (val == true && !currentlyset) {
-		changed = 1;
-		valold |= this_attr->mask;
-		iio_add_event_to_list(this_attr->listel,
-					    &indio_dev->interrupts[0]->ev_list);
+		goto error_ret;
+	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
+				       &val);
+	if (ret < 0)
+		goto error_ret;
+	currentlyset = val & mask;
+
+	if (!currentlyset && state) {
+		changed = true;
+		val |= mask;
+		iio_add_event_to_list(list_el,
+				      &indio_dev->interrupts[0]->ev_list);
+
+	} else if (currentlyset && !state) {
+		changed = true;
+		val &= ~mask;
+		iio_remove_event_from_list(list_el,
+					   &indio_dev->interrupts[0]->ev_list);
 	}
-
 	if (changed) {
-		ret = lis3l02dq_spi_write_reg_8(dev,
+		ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
 						LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
-						&valold);
-		if (ret)
-			goto error_mutex_unlock;
-		/* This always enables the interrupt, even if we've remove the
-		 * last thing using it. For this device we can use the reference
-		 * count on the handler to tell us if anyone wants the interrupt
-		 */
-		controlold = this_attr->listel->refcount ?
-			(controlold | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT) :
-			(controlold & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
-		ret = lis3l02dq_spi_write_reg_8(dev,
-						LIS3L02DQ_REG_CTRL_2_ADDR,
-						&controlold);
+						&val);
 		if (ret)
-			goto error_mutex_unlock;
+			goto error_ret;
+		control = list_el->refcount ?
+			(control | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT) :
+			(control & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
+		ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+					       LIS3L02DQ_REG_CTRL_2_ADDR,
+					       &control);
 	}
-error_mutex_unlock:
-	mutex_unlock(&indio_dev->mlock);
-
-	return ret ? ret : len;
-}
-
-
-static int lis3l02dq_thresh_handler_th(struct iio_dev *indio_dev,
-				       int index,
-				       s64 timestamp,
-				       int no_test)
-{
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
-	/* Stash the timestamp somewhere convenient for the bh */
-	st->thresh_timestamp = timestamp;
-	schedule_work(&st->work_thresh);
-
-	return 0;
+error_ret:
+	mutex_unlock(&indio_dev->mlock);
+	return ret;
 }
 
-
 /* Unforunately it appears the interrupt won't clear unless you read from the
  * src register.
  */
@@ -700,75 +631,9 @@ static void lis3l02dq_thresh_handler_bh_no_check(struct work_struct *work_s)
 	return;
 }
 
-/* A shared handler for a number of threshold types */
-IIO_EVENT_SH(threshold, &lis3l02dq_thresh_handler_th);
-
-IIO_EVENT_ATTR_SH(accel_x_thresh_rising_en,
-		  iio_event_threshold,
-		  lis3l02dq_read_interrupt_config,
-		  lis3l02dq_write_interrupt_config,
-		  LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_HIGH);
-
-IIO_EVENT_ATTR_SH(accel_y_thresh_rising_en,
-		  iio_event_threshold,
-		  lis3l02dq_read_interrupt_config,
-		  lis3l02dq_write_interrupt_config,
-		  LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_HIGH);
-
-IIO_EVENT_ATTR_SH(accel_z_thresh_rising_en,
-		  iio_event_threshold,
-		  lis3l02dq_read_interrupt_config,
-		  lis3l02dq_write_interrupt_config,
-		  LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_HIGH);
-
-IIO_EVENT_ATTR_SH(accel_x_thresh_falling_en,
-		  iio_event_threshold,
-		  lis3l02dq_read_interrupt_config,
-		  lis3l02dq_write_interrupt_config,
-		  LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_LOW);
-
-IIO_EVENT_ATTR_SH(accel_y_thresh_falling_en,
-		  iio_event_threshold,
-		  lis3l02dq_read_interrupt_config,
-		  lis3l02dq_write_interrupt_config,
-		  LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_LOW);
-
-IIO_EVENT_ATTR_SH(accel_z_thresh_falling_en,
-		  iio_event_threshold,
-		  lis3l02dq_read_interrupt_config,
-		  lis3l02dq_write_interrupt_config,
-		  LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_LOW);
-
-
-static struct attribute *lis3l02dq_event_attributes[] = {
-	&iio_event_attr_accel_x_thresh_rising_en.dev_attr.attr,
-	&iio_event_attr_accel_y_thresh_rising_en.dev_attr.attr,
-	&iio_event_attr_accel_z_thresh_rising_en.dev_attr.attr,
-	&iio_event_attr_accel_x_thresh_falling_en.dev_attr.attr,
-	&iio_event_attr_accel_y_thresh_falling_en.dev_attr.attr,
-	&iio_event_attr_accel_z_thresh_falling_en.dev_attr.attr,
-	&iio_dev_attr_accel_raw_mag_value.dev_attr.attr,
-	NULL
-};
-
-static struct attribute_group lis3l02dq_event_attribute_group = {
-	.attrs = lis3l02dq_event_attributes,
-};
-
 static IIO_CONST_ATTR_NAME("lis3l02dq");
-static IIO_CONST_ATTR(accel_scale, "0.00958");
 
 static struct attribute *lis3l02dq_attributes[] = {
-	&iio_dev_attr_accel_x_calibbias.dev_attr.attr,
-	&iio_dev_attr_accel_y_calibbias.dev_attr.attr,
-	&iio_dev_attr_accel_z_calibbias.dev_attr.attr,
-	&iio_dev_attr_accel_x_calibscale.dev_attr.attr,
-	&iio_dev_attr_accel_y_calibscale.dev_attr.attr,
-	&iio_dev_attr_accel_z_calibscale.dev_attr.attr,
-	&iio_const_attr_accel_scale.dev_attr.attr,
-	&iio_dev_attr_accel_x_raw.dev_attr.attr,
-	&iio_dev_attr_accel_y_raw.dev_attr.attr,
-	&iio_dev_attr_accel_z_raw.dev_attr.attr,
 	&iio_dev_attr_sampling_frequency.dev_attr.attr,
 	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
 	&iio_const_attr_name.dev_attr.attr,
@@ -813,7 +678,13 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 
 	st->help.indio_dev->dev.parent = &spi->dev;
 	st->help.indio_dev->num_interrupt_lines = 1;
-	st->help.indio_dev->event_attrs = &lis3l02dq_event_attribute_group;
+	st->help.indio_dev->channels = lis3l02dq_channels;
+	st->help.indio_dev->num_channels = ARRAY_SIZE(lis3l02dq_channels);
+	st->help.indio_dev->read_raw = &lis3l02dq_read_raw;
+	st->help.indio_dev->read_event_value = &lis3l02dq_read_thresh;
+	st->help.indio_dev->write_event_value = &lis3l02dq_write_thresh;
+	st->help.indio_dev->write_event_config = &lis3l02dq_write_event_config;
+	st->help.indio_dev->read_event_config = &lis3l02dq_read_event_config;
 	st->help.indio_dev->attrs = &lis3l02dq_attribute_group;
 	st->help.indio_dev->dev_data = (void *)(&st->help);
 	st->help.indio_dev->driver_module = THIS_MODULE;
@@ -828,7 +699,9 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 		goto error_unreg_ring_funcs;
 	regdone = 1;
 
-	ret = iio_ring_buffer_register(st->help.indio_dev->ring, 0);
+	ret = iio_ring_buffer_register_ex(st->help.indio_dev->ring, 0,
+					  lis3l02dq_channels,
+					  ARRAY_SIZE(lis3l02dq_channels));
 	if (ret) {
 		printk(KERN_ERR "failed to initialize the ring\n");
 		goto error_unreg_ring_funcs;
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 2c461a3..c6c4762 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -29,86 +29,6 @@ static inline u16 combine_8_to_16(u8 lower, u8 upper)
 }
 
 /**
- * lis3l02dq_scan_el_set_state() set whether a scan contains a given channel
- * @scan_el:	associtate iio scan element attribute
- * @indio_dev:	the device structure
- * @bool:	desired state
- *
- * mlock already held when this is called.
- **/
-static int lis3l02dq_scan_el_set_state(struct iio_scan_el *scan_el,
-				       struct iio_dev *indio_dev,
-				       bool state)
-{
-	u8 t, mask;
-	int ret;
-
-	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
-				       LIS3L02DQ_REG_CTRL_1_ADDR,
-				       &t);
-	if (ret)
-		goto error_ret;
-	switch (scan_el->label) {
-	case LIS3L02DQ_REG_OUT_X_L_ADDR:
-		mask = LIS3L02DQ_REG_CTRL_1_AXES_X_ENABLE;
-		break;
-	case LIS3L02DQ_REG_OUT_Y_L_ADDR:
-		mask = LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE;
-		break;
-	case LIS3L02DQ_REG_OUT_Z_L_ADDR:
-		mask = LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE;
-		break;
-	default:
-		ret = -EINVAL;
-		goto error_ret;
-	}
-
-	if (!(mask & t) == state) {
-		if (state)
-			t |= mask;
-		else
-			t &= ~mask;
-		ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
-						LIS3L02DQ_REG_CTRL_1_ADDR,
-						&t);
-	}
-error_ret:
-	return ret;
-
-}
-static IIO_SCAN_EL_C(accel_x, 0,
-		     LIS3L02DQ_REG_OUT_X_L_ADDR,
-		     &lis3l02dq_scan_el_set_state);
-static IIO_SCAN_EL_C(accel_y, 1,
-		     LIS3L02DQ_REG_OUT_Y_L_ADDR,
-		     &lis3l02dq_scan_el_set_state);
-static IIO_SCAN_EL_C(accel_z, 2,
-		     LIS3L02DQ_REG_OUT_Z_L_ADDR,
-		     &lis3l02dq_scan_el_set_state);
-static IIO_CONST_ATTR_SCAN_EL_TYPE(accel, s, 12, 16);
-static IIO_SCAN_EL_TIMESTAMP(3);
-static IIO_CONST_ATTR_SCAN_EL_TYPE(timestamp, s, 64, 64);
-
-static struct attribute *lis3l02dq_scan_el_attrs[] = {
-	&iio_scan_el_accel_x.dev_attr.attr,
-	&iio_const_attr_accel_x_index.dev_attr.attr,
-	&iio_scan_el_accel_y.dev_attr.attr,
-	&iio_const_attr_accel_y_index.dev_attr.attr,
-	&iio_scan_el_accel_z.dev_attr.attr,
-	&iio_const_attr_accel_z_index.dev_attr.attr,
-	&iio_const_attr_accel_type.dev_attr.attr,
-	&iio_scan_el_timestamp.dev_attr.attr,
-	&iio_const_attr_timestamp_index.dev_attr.attr,
-	&iio_const_attr_timestamp_type.dev_attr.attr,
-	NULL,
-};
-
-static struct attribute_group lis3l02dq_scan_el_group = {
-	.attrs = lis3l02dq_scan_el_attrs,
-	.name = "scan_elements",
-};
-
-/**
  * lis3l02dq_poll_func_th() top half interrupt handler called by trigger
  * @private_data:	iio_dev
  **/
@@ -151,58 +71,27 @@ IIO_EVENT_SH(data_rdy_trig, &lis3l02dq_data_rdy_trig_poll);
 /**
  * lis3l02dq_read_accel_from_ring() individual acceleration read from ring
  **/
-ssize_t lis3l02dq_read_accel_from_ring(struct device *dev,
-				       struct device_attribute *attr,
-				       char *buf)
+ssize_t lis3l02dq_read_accel_from_ring(struct iio_ring_buffer *ring,
+				       int index,
+				       int *val)
 {
-	struct iio_scan_el *el = NULL;
-	int ret, len = 0, i = 0;
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	struct iio_dev *dev_info = dev_get_drvdata(dev);
-	struct iio_ring_buffer *ring = dev_info->ring;
-	struct attribute_group *scan_el_attrs = ring->scan_el_attrs;
+	int ret;
 	s16 *data;
+	if (!iio_scan_mask_query(ring, index))
+		return -EINVAL;
 
-	while (scan_el_attrs->attrs[i]) {
-		el = to_iio_scan_el((struct device_attribute *)
-				    (scan_el_attrs->attrs[i]));
-		/* label is in fact the address */
-		if (el->label == this_attr->address)
-			break;
-		i++;
-	}
-	if (!scan_el_attrs->attrs[i]) {
-		ret = -EINVAL;
-		goto error_ret;
-	}
-	/* If this element is in the scan mask */
-	ret = iio_scan_mask_query(ring, el->number);
-	if (ret < 0)
-		goto error_ret;
-	if (ret) {
-		data = kmalloc(ring->access.get_bytes_per_datum(ring),
-			       GFP_KERNEL);
-		if (data == NULL)
-			return -ENOMEM;
-		ret = ring->access.read_last(ring,
-					(u8 *)data);
-		if (ret)
-			goto error_free_data;
-	} else {
-		ret = -EINVAL;
-		goto error_ret;
-	}
-	len = iio_scan_mask_count_to_right(ring, el->number);
-	if (len < 0) {
-		ret = len;
+	data = kmalloc(ring->access.get_bytes_per_datum(ring),
+		       GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	ret = ring->access.read_last(ring, (u8 *)data);
+	if (ret)
 		goto error_free_data;
-	}
-	len = sprintf(buf, "ring %d\n", data[len]);
+	*val = data[iio_scan_mask_count_to_right(ring, index)];
 error_free_data:
 	kfree(data);
-error_ret:
-	return ret ? ret : len;
-
+	return ret;
 }
 
 static const u8 read_all_tx_array[] = {
@@ -234,7 +123,7 @@ static int lis3l02dq_read_all(struct lis3l02dq_state *st, u8 *rx_array)
 
 	mutex_lock(&st->buf_lock);
 
-	for (i = 0; i < ARRAY_SIZE(read_all_tx_array)/4; i++) {
+	for (i = 0; i < ARRAY_SIZE(read_all_tx_array)/4; i++)
 		if (ring->scan_mask & (1 << i)) {
 			/* lower byte */
 			xfers[j].tx_buf = st->tx + 2*j;
@@ -258,7 +147,7 @@ static int lis3l02dq_read_all(struct lis3l02dq_state *st, u8 *rx_array)
 			xfers[j].cs_change = 1;
 			j++;
 		}
-	}
+
 	/* After these are transmitted, the rx_buff should have
 	 * values in alternate bytes
 	 */
@@ -488,6 +377,76 @@ void lis3l02dq_unconfigure_ring(struct iio_dev *indio_dev)
 	lis3l02dq_free_buf(indio_dev->ring);
 }
 
+static int lis3l02dq_ring_postenable(struct iio_dev *indio_dev)
+{
+	/* Disable unwanted channels otherwise the interrupt will not clear */
+	u8 t;
+	int ret;
+	bool oneenabled = false;
+
+	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+				       LIS3L02DQ_REG_CTRL_1_ADDR,
+				       &t);
+	if (ret)
+		goto error_ret;
+
+	if (iio_scan_mask_query(indio_dev->ring, 0)) {
+		t |= LIS3L02DQ_REG_CTRL_1_AXES_X_ENABLE;
+		oneenabled = true;
+	} else
+		t &= ~LIS3L02DQ_REG_CTRL_1_AXES_X_ENABLE;
+	if (iio_scan_mask_query(indio_dev->ring, 1)) {
+		t |= LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE;
+		oneenabled = true;
+	} else
+		t &= ~LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE;
+	if (iio_scan_mask_query(indio_dev->ring, 2)) {
+		t |= LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE;
+		oneenabled = true;
+	} else
+		t &= ~LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE;
+
+	if (!oneenabled) /* what happens in this case is unknown */
+		return -EINVAL;
+	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+					LIS3L02DQ_REG_CTRL_1_ADDR,
+					&t);
+	if (ret)
+		goto error_ret;
+
+	return iio_triggered_ring_postenable(indio_dev);
+error_ret:
+	return ret;
+}
+
+/* Turn all channels on again */
+static int lis3l02dq_ring_predisable(struct iio_dev *indio_dev)
+{
+	u8 t;
+	int ret;
+
+	ret = iio_triggered_ring_predisable(indio_dev);
+	if (ret)
+		goto error_ret;
+
+	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+				       LIS3L02DQ_REG_CTRL_1_ADDR,
+				       &t);
+	if (ret)
+		goto error_ret;
+	t |= LIS3L02DQ_REG_CTRL_1_AXES_X_ENABLE |
+		LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE |
+		LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE;
+
+	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+					LIS3L02DQ_REG_CTRL_1_ADDR,
+					&t);
+
+error_ret:
+	return ret;
+}
+
+
 int lis3l02dq_configure_ring(struct iio_dev *indio_dev)
 {
 	int ret;
@@ -504,17 +463,17 @@ int lis3l02dq_configure_ring(struct iio_dev *indio_dev)
 	/* Effectively select the ring buffer implementation */
 	lis3l02dq_register_buf_funcs(&ring->access);
 	ring->bpe = 2;
-	ring->scan_el_attrs = &lis3l02dq_scan_el_group;
+
 	ring->scan_timestamp = true;
 	ring->preenable = &iio_sw_ring_preenable;
-	ring->postenable = &iio_triggered_ring_postenable;
-	ring->predisable = &iio_triggered_ring_predisable;
+	ring->postenable = &lis3l02dq_ring_postenable;
+	ring->predisable = &lis3l02dq_ring_predisable;
 	ring->owner = THIS_MODULE;
 
 	/* Set default scan mode */
-	iio_scan_mask_set(ring, iio_scan_el_accel_x.number);
-	iio_scan_mask_set(ring, iio_scan_el_accel_y.number);
-	iio_scan_mask_set(ring, iio_scan_el_accel_z.number);
+	iio_scan_mask_set(ring, 0);
+	iio_scan_mask_set(ring, 1);
+	iio_scan_mask_set(ring, 2);
 
 	ret = iio_alloc_pollfunc(indio_dev, NULL, &lis3l02dq_poll_func_th);
 	if (ret)
-- 
1.7.3.4

