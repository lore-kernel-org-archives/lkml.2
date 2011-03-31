Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab1CaO4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:56:53 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57405 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758060Ab1CaOwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:51 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 08/21] staging:iio:lis3l02dq: General cleanup
Date: Thu, 31 Mar 2011 15:54:02 +0100
Message-Id: <1301583255-28468-9-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Arnd observed, things are clearner if we pass iio_dev into read and write fucntions.

Now uses st for lis3l02dq_state everywhere.

Other bits of trivial tidying.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/accel/lis3l02dq.h      |    4 +-
 drivers/staging/iio/accel/lis3l02dq_core.c |  116 ++++++++++++----------------
 drivers/staging/iio/accel/lis3l02dq_ring.c |   64 ++++++++-------
 3 files changed, 84 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index 1d90b7d..5925405 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -173,11 +173,11 @@ struct lis3l02dq_state {
 #define lis3l02dq_h_to_s(_h)				\
 	container_of(_h, struct lis3l02dq_state, help)
 
-int lis3l02dq_spi_read_reg_8(struct device *dev,
+int lis3l02dq_spi_read_reg_8(struct iio_dev *indio_dev,
 			     u8 reg_address,
 			     u8 *val);
 
-int lis3l02dq_spi_write_reg_8(struct device *dev,
+int lis3l02dq_spi_write_reg_8(struct iio_dev *indio_dev,
 			      u8 reg_address,
 			      u8 *val);
 
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 5d22116..42f4d9b 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -39,9 +39,17 @@
  * This means that use cannot be made of spi_write etc.
  */
 
-static int __lis3l02dq_spi_read_reg_8(struct lis3l02dq_state *st,
-				      u8 reg_address, u8 *val)
+/**
+ * lis3l02dq_spi_read_reg_8() - read single byte from a single register
+ * @indio_dev: iio_dev for this actual device
+ * @reg_address: the address of the register to be read
+ * @val: pass back the resulting value
+ **/
+int lis3l02dq_spi_read_reg_8(struct iio_dev *indio_dev,
+			     u8 reg_address, u8 *val)
 {
+	struct iio_sw_ring_helper_state *h = iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 	struct spi_message msg;
 	int ret;
 	struct spi_transfer xfer = {
@@ -49,7 +57,6 @@ static int __lis3l02dq_spi_read_reg_8(struct lis3l02dq_state *st,
 		.rx_buf = st->rx,
 		.bits_per_word = 8,
 		.len = 2,
-		.cs_change = 1,
 	};
 
 	mutex_lock(&st->buf_lock);
@@ -64,50 +71,26 @@ static int __lis3l02dq_spi_read_reg_8(struct lis3l02dq_state *st,
 
 	return ret;
 }
-/**
- * lis3l02dq_spi_read_reg_8() - read single byte from a single register
- * @dev: device asosciated with child of actual device (iio_dev or iio_trig)
- * @reg_address: the address of the register to be read
- * @val: pass back the resulting value
- **/
-int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct iio_sw_ring_helper_state *h = iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
-	return __lis3l02dq_spi_read_reg_8(st, reg_address, val);
-}
 
 /**
  * lis3l02dq_spi_write_reg_8() - write single byte to a register
- * @dev: device associated with child of actual device (iio_dev or iio_trig)
+ * @indio_dev: iio_dev for this device
  * @reg_address: the address of the register to be writen
  * @val: the value to write
  **/
-int lis3l02dq_spi_write_reg_8(struct device *dev,
+int lis3l02dq_spi_write_reg_8(struct iio_dev *indio_dev,
 			      u8 reg_address,
 			      u8 *val)
 {
 	int ret;
-	struct spi_message msg;
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct iio_sw_ring_helper_state *h
 		= iio_dev_get_devdata(indio_dev);
 	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
-	struct spi_transfer xfer = {
-		.tx_buf = st->tx,
-		.bits_per_word = 8,
-		.len = 2,
-		.cs_change = 1,
-	};
 
 	mutex_lock(&st->buf_lock);
 	st->tx[0] = LIS3L02DQ_WRITE_REG(reg_address);
 	st->tx[1] = *val;
-
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-	ret = spi_sync(st->us, &msg);
+	ret = spi_write(st->us, st->tx, 2);
 	mutex_unlock(&st->buf_lock);
 
 	return ret;
@@ -115,18 +98,17 @@ int lis3l02dq_spi_write_reg_8(struct device *dev,
 
 /**
  * lisl302dq_spi_write_reg_s16() - write 2 bytes to a pair of registers
- * @dev: device associated with child of actual device (iio_dev or iio_trig)
- * @reg_address: the address of the lower of the two registers. Second register
- *               is assumed to have address one greater.
- * @val: value to be written
+ * @indio_dev: iio_dev for this device
+ * @lower_reg_address: the address of the lower of the two registers.
+ *               Second register is assumed to have address one greater.
+ * @value: value to be written
  **/
-static int lis3l02dq_spi_write_reg_s16(struct device *dev,
+static int lis3l02dq_spi_write_reg_s16(struct iio_dev *indio_dev,
 				       u8 lower_reg_address,
 				       s16 value)
 {
 	int ret;
 	struct spi_message msg;
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	struct iio_sw_ring_helper_state *h
 		= iio_dev_get_devdata(indio_dev);
 	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
@@ -139,7 +121,6 @@ static int lis3l02dq_spi_write_reg_s16(struct device *dev,
 			.tx_buf = st->tx + 2,
 			.bits_per_word = 8,
 			.len = 2,
-			.cs_change = 1,
 		},
 	};
 
@@ -158,10 +139,14 @@ static int lis3l02dq_spi_write_reg_s16(struct device *dev,
 	return ret;
 }
 
-static int lis3l02dq_read_16bit_s(struct lis3l02dq_state *st,
+static int lis3l02dq_read_reg_s16(struct iio_dev *indio_dev,
 				  u8 lower_reg_address,
 				  int *val)
 {
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
+
 	struct spi_message msg;
 	int ret;
 	s16 tempval;
@@ -176,7 +161,6 @@ static int lis3l02dq_read_16bit_s(struct lis3l02dq_state *st,
 			.rx_buf = st->rx + 2,
 			.bits_per_word = 8,
 			.len = 2,
-			.cs_change = 0,
 		},
 	};
 
@@ -224,11 +208,7 @@ static int lis3l02dq_read_thresh(struct iio_dev *indio_dev,
 				 int e,
 				 int *val)
 {
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
-
-	return lis3l02dq_read_16bit_s(st, LIS3L02DQ_REG_THS_L_ADDR, val);
+	return lis3l02dq_read_reg_s16(indio_dev, LIS3L02DQ_REG_THS_L_ADDR, val);
 }
 
 static int lis3l02dq_write_thresh(struct iio_dev *indio_dev,
@@ -236,7 +216,7 @@ static int lis3l02dq_write_thresh(struct iio_dev *indio_dev,
 				  int val)
 {
 	u16 value = val;
-	return lis3l02dq_spi_write_reg_s16(&indio_dev->dev,
+	return lis3l02dq_spi_write_reg_s16(indio_dev,
 					   LIS3L02DQ_REG_THS_L_ADDR,
 					   value);
 }
@@ -249,10 +229,8 @@ static int lis3l02dq_read_raw(struct iio_dev *indio_dev,
 	u8 utemp;
 	s8 stemp;
 	ssize_t ret = 0;
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 	u8 reg;
+
 	switch (mask) {
 	case 0:
 		/* Take the iio_dev status lock */
@@ -273,7 +251,7 @@ static int lis3l02dq_read_raw(struct iio_dev *indio_dev,
 		break;
 	case (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE):
 		reg = lis3l02dq_axis_map[LIS3L02DQ_GAIN][chan->address];
-		ret = __lis3l02dq_spi_read_reg_8(st, reg, &utemp);
+		ret = lis3l02dq_spi_read_reg_8(indio_dev, reg, &utemp);
 		if (ret)
 			goto error_ret;
 		/* to match with what previous code does */
@@ -282,7 +260,7 @@ static int lis3l02dq_read_raw(struct iio_dev *indio_dev,
 
 	case (1 << IIO_CHAN_INFO_CALIBBIAS_SEPARATE):
 		reg = lis3l02dq_axis_map[LIS3L02DQ_BIAS][chan->address];
-		ret = __lis3l02dq_spi_read_reg_8(st, reg, (u8 *)&stemp);
+		ret = lis3l02dq_spi_read_reg_8(indio_dev, reg, (u8 *)&stemp);
 		/* to match with what previous code does */
 		*val = 1000000*stemp;
 		break;
@@ -296,9 +274,10 @@ static ssize_t lis3l02dq_read_frequency(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 	int ret, len = 0;
 	s8 t;
-	ret = lis3l02dq_spi_read_reg_8(dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_1_ADDR,
 				       (u8 *)&t);
 	if (ret)
@@ -336,7 +315,7 @@ static ssize_t lis3l02dq_write_frequency(struct device *dev,
 		return ret;
 
 	mutex_lock(&indio_dev->mlock);
-	ret = lis3l02dq_spi_read_reg_8(dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_1_ADDR,
 				       &t);
 	if (ret)
@@ -361,7 +340,7 @@ static ssize_t lis3l02dq_write_frequency(struct device *dev,
 		goto error_ret_mutex;
 	};
 
-	ret = lis3l02dq_spi_write_reg_8(dev,
+	ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					LIS3L02DQ_REG_CTRL_1_ADDR,
 					&t);
 
@@ -382,7 +361,7 @@ static int lis3l02dq_initial_setup(struct lis3l02dq_state *st)
 
 	val = LIS3L02DQ_DEFAULT_CTRL1;
 	/* Write suitable defaults to ctrl1 */
-	ret = lis3l02dq_spi_write_reg_8(&st->help.indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(st->help.indio_dev,
 					LIS3L02DQ_REG_CTRL_1_ADDR,
 					&val);
 	if (ret) {
@@ -390,7 +369,7 @@ static int lis3l02dq_initial_setup(struct lis3l02dq_state *st)
 		goto err_ret;
 	}
 	/* Repeat as sometimes doesn't work first time?*/
-	ret = lis3l02dq_spi_write_reg_8(&st->help.indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(st->help.indio_dev,
 					LIS3L02DQ_REG_CTRL_1_ADDR,
 					&val);
 	if (ret) {
@@ -400,17 +379,18 @@ static int lis3l02dq_initial_setup(struct lis3l02dq_state *st)
 
 	/* Read back to check this has worked acts as loose test of correct
 	 * chip */
-	ret = lis3l02dq_spi_read_reg_8(&st->help.indio_dev->dev,
+	ret = lis3l02dq_spi_read_reg_8(st->help.indio_dev,
 				       LIS3L02DQ_REG_CTRL_1_ADDR,
 				       &valtest);
 	if (ret || (valtest != val)) {
-		dev_err(&st->help.indio_dev->dev, "device not playing ball");
+		dev_err(&st->help.indio_dev->dev,
+			"device not playing ball %d %d\n", valtest, val);
 		ret = -EINVAL;
 		goto err_ret;
 	}
 
 	val = LIS3L02DQ_DEFAULT_CTRL2;
-	ret = lis3l02dq_spi_write_reg_8(&st->help.indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(st->help.indio_dev,
 					LIS3L02DQ_REG_CTRL_2_ADDR,
 					&val);
 	if (ret) {
@@ -419,7 +399,7 @@ static int lis3l02dq_initial_setup(struct lis3l02dq_state *st)
 	}
 
 	val = LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC;
-	ret = lis3l02dq_spi_write_reg_8(&st->help.indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(st->help.indio_dev,
 					LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 					&val);
 	if (ret)
@@ -486,7 +466,7 @@ static ssize_t lis3l02dq_read_event_config(struct iio_dev *indio_dev,
 	u8 mask = (1 << (IIO_EVENT_CODE_EXTRACT_MODIFIER(event_code)*2 +
 			 (IIO_EVENT_CODE_EXTRACT_DIR(event_code) ==
 			  IIO_EV_DIR_RISING)));
-	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 				       &val);
 	if (ret < 0)
@@ -510,12 +490,12 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 
 	mutex_lock(&indio_dev->mlock);
 	/* read current control */
-	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_2_ADDR,
 				       &control);
 	if (ret)
 		goto error_ret;
-	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 				       &val);
 	if (ret < 0)
@@ -535,7 +515,7 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 					   &indio_dev->interrupts[0]->ev_list);
 	}
 	if (changed) {
-		ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 						&val);
 		if (ret)
@@ -543,7 +523,7 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 		control = list_el->refcount ?
 			(control | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT) :
 			(control & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
-		ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					       LIS3L02DQ_REG_CTRL_2_ADDR,
 					       &control);
 	}
@@ -564,7 +544,7 @@ static void lis3l02dq_thresh_handler_bh_no_check(struct work_struct *work_s)
 
 	u8 t;
 
-	lis3l02dq_spi_read_reg_8(&st->help.indio_dev->dev,
+	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
 				 LIS3L02DQ_REG_WAKE_UP_SRC_ADDR,
 				 &t);
 
@@ -624,7 +604,7 @@ static void lis3l02dq_thresh_handler_bh_no_check(struct work_struct *work_s)
 	/* reenable the irq */
 	enable_irq(st->us->irq);
 	/* Ack and allow for new interrupts */
-	lis3l02dq_spi_read_reg_8(&st->help.indio_dev->dev,
+	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
 				 LIS3L02DQ_REG_WAKE_UP_ACK_ADDR,
 				 &t);
 
@@ -763,7 +743,7 @@ static int lis3l02dq_stop_device(struct iio_dev *indio_dev)
 	u8 val = 0;
 
 	mutex_lock(&indio_dev->mlock);
-	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					LIS3L02DQ_REG_CTRL_1_ADDR,
 					&val);
 	if (ret) {
@@ -771,7 +751,7 @@ static int lis3l02dq_stop_device(struct iio_dev *indio_dev)
 		goto err_ret;
 	}
 
-	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					LIS3L02DQ_REG_CTRL_2_ADDR,
 					&val);
 	if (ret)
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index c6c4762..1a4b3fc 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -206,7 +206,7 @@ __lis3l02dq_write_data_ready_config(struct device *dev,
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
 
 /* Get the current event mask register */
-	ret = lis3l02dq_spi_read_reg_8(dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_2_ADDR,
 				       &valold);
 	if (ret)
@@ -220,12 +220,12 @@ __lis3l02dq_write_data_ready_config(struct device *dev,
 
 		valold &= ~LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
 		/* The double write is to overcome a hardware bug?*/
-		ret = lis3l02dq_spi_write_reg_8(dev,
+		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_CTRL_2_ADDR,
 						&valold);
 		if (ret)
 			goto error_ret;
-		ret = lis3l02dq_spi_write_reg_8(dev,
+		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_CTRL_2_ADDR,
 						&valold);
 		if (ret)
@@ -240,7 +240,7 @@ __lis3l02dq_write_data_ready_config(struct device *dev,
 		/* if not set, enable requested */
 		valold |= LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
 		iio_add_event_to_list(list, &indio_dev->interrupts[0]->ev_list);
-		ret = lis3l02dq_spi_write_reg_8(dev,
+		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_CTRL_2_ADDR,
 						&valold);
 		if (ret)
@@ -268,14 +268,14 @@ static int lis3l02dq_data_rdy_trigger_set_state(struct iio_trigger *trig,
 	__lis3l02dq_write_data_ready_config(&st->help.indio_dev->dev,
 					    &iio_event_data_rdy_trig,
 					    state);
-	if (state == false) {
+	if (st == false) {
 		/* possible quirk with handler currently worked around
 		   by ensuring the work queue is empty */
 		flush_scheduled_work();
 		/* Clear any outstanding ready events */
 		ret = lis3l02dq_read_all(st, NULL);
 	}
-	lis3l02dq_spi_read_reg_8(&st->help.indio_dev->dev,
+	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
 				 LIS3L02DQ_REG_WAKE_UP_SRC_ADDR,
 				 &t);
 	return ret;
@@ -328,47 +328,51 @@ static int lis3l02dq_trig_try_reen(struct iio_trigger *trig)
 int lis3l02dq_probe_trigger(struct iio_dev *indio_dev)
 {
 	int ret;
-	struct lis3l02dq_state *state = indio_dev->dev_data;
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
-	state->trig = iio_allocate_trigger();
-	if (!state->trig)
+	st->trig = iio_allocate_trigger();
+	if (!st->trig)
 		return -ENOMEM;
 
-	state->trig->name = kasprintf(GFP_KERNEL,
-				      "lis3l02dq-dev%d",
-				      indio_dev->id);
-	if (!state->trig->name) {
+	st->trig->name = kasprintf(GFP_KERNEL,
+				   "lis3l02dq-dev%d",
+				   indio_dev->id);
+	if (!st->trig->name) {
 		ret = -ENOMEM;
 		goto error_free_trig;
 	}
 
-	state->trig->dev.parent = &state->us->dev;
-	state->trig->owner = THIS_MODULE;
-	state->trig->private_data = state;
-	state->trig->set_trigger_state = &lis3l02dq_data_rdy_trigger_set_state;
-	state->trig->try_reenable = &lis3l02dq_trig_try_reen;
-	state->trig->control_attrs = &lis3l02dq_trigger_attr_group;
-	ret = iio_trigger_register(state->trig);
+	st->trig->dev.parent = &st->us->dev;
+	st->trig->owner = THIS_MODULE;
+	st->trig->private_data = st;
+	st->trig->set_trigger_state = &lis3l02dq_data_rdy_trigger_set_state;
+	st->trig->try_reenable = &lis3l02dq_trig_try_reen;
+	st->trig->control_attrs = &lis3l02dq_trigger_attr_group;
+	ret = iio_trigger_register(st->trig);
 	if (ret)
 		goto error_free_trig_name;
 
 	return 0;
 
 error_free_trig_name:
-	kfree(state->trig->name);
+	kfree(st->trig->name);
 error_free_trig:
-	iio_free_trigger(state->trig);
+	iio_free_trigger(st->trig);
 
 	return ret;
 }
 
 void lis3l02dq_remove_trigger(struct iio_dev *indio_dev)
 {
-	struct lis3l02dq_state *state = indio_dev->dev_data;
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
-	iio_trigger_unregister(state->trig);
-	kfree(state->trig->name);
-	iio_free_trigger(state->trig);
+	iio_trigger_unregister(st->trig);
+	kfree(st->trig->name);
+	iio_free_trigger(st->trig);
 }
 
 void lis3l02dq_unconfigure_ring(struct iio_dev *indio_dev)
@@ -384,7 +388,7 @@ static int lis3l02dq_ring_postenable(struct iio_dev *indio_dev)
 	int ret;
 	bool oneenabled = false;
 
-	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_1_ADDR,
 				       &t);
 	if (ret)
@@ -408,7 +412,7 @@ static int lis3l02dq_ring_postenable(struct iio_dev *indio_dev)
 
 	if (!oneenabled) /* what happens in this case is unknown */
 		return -EINVAL;
-	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					LIS3L02DQ_REG_CTRL_1_ADDR,
 					&t);
 	if (ret)
@@ -429,7 +433,7 @@ static int lis3l02dq_ring_predisable(struct iio_dev *indio_dev)
 	if (ret)
 		goto error_ret;
 
-	ret = lis3l02dq_spi_read_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
 				       LIS3L02DQ_REG_CTRL_1_ADDR,
 				       &t);
 	if (ret)
@@ -438,7 +442,7 @@ static int lis3l02dq_ring_predisable(struct iio_dev *indio_dev)
 		LIS3L02DQ_REG_CTRL_1_AXES_Y_ENABLE |
 		LIS3L02DQ_REG_CTRL_1_AXES_Z_ENABLE;
 
-	ret = lis3l02dq_spi_write_reg_8(&indio_dev->dev,
+	ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					LIS3L02DQ_REG_CTRL_1_ADDR,
 					&t);
 
-- 
1.7.3.4

