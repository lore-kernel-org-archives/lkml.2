Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab1CaO4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:56:31 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57413 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab1CaOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:52 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 10/21] staging:iio: lis3l02dq - separate entirely interrupt handling for thesholds from that for the datardy signal.
Date: Thu, 31 Mar 2011 15:54:04 +0100
Message-Id: <1301583255-28468-11-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the one and only real user of the rather complex event list management.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/accel/lis3l02dq.h      |    2 +
 drivers/staging/iio/accel/lis3l02dq_core.c |  104 +++++++++++++++++++++-------
 drivers/staging/iio/accel/lis3l02dq_ring.c |   56 ++++++++-------
 3 files changed, 111 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index 5925405..ba40f50 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -181,6 +181,8 @@ int lis3l02dq_spi_write_reg_8(struct iio_dev *indio_dev,
 			      u8 reg_address,
 			      u8 *val);
 
+int lis3l02dq_disable_all_events(struct iio_dev *indio_dev);
+
 #ifdef CONFIG_IIO_RING_BUFFER
 /* At the moment triggers are only used for ring buffer
  * filling. This may change!
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 42f4d9b..96cdb82 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -242,7 +242,7 @@ static int lis3l02dq_read_raw(struct iio_dev *indio_dev,
 		else {
 			reg = lis3l02dq_axis_map
 				[LIS3L02DQ_ACCEL][chan->address];
-			ret = lis3l02dq_read_16bit_s(st, reg, val);
+			ret = lis3l02dq_read_reg_s16(indio_dev, reg, val);
 		}
 		mutex_unlock(&indio_dev->mlock);
 		break;
@@ -415,26 +415,21 @@ static IIO_DEV_ATTR_SAMP_FREQ(S_IWUSR | S_IRUGO,
 
 static IIO_CONST_ATTR_SAMP_FREQ_AVAIL("280 560 1120 4480");
 
-static int lis3l02dq_thresh_handler_th(struct iio_dev *indio_dev,
-				       int index,
-				       s64 timestamp,
-				       int no_test)
+static irqreturn_t lis3l02dq_event_handler(int irq, void *_int_info)
 {
+	struct iio_interrupt *int_info = _int_info;
+	struct iio_dev *indio_dev = int_info->dev_info;
 	struct iio_sw_ring_helper_state *h
 		= iio_dev_get_devdata(indio_dev);
 	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
-	/* Stash the timestamp somewhere convenient for the bh */
-	st->thresh_timestamp = timestamp;
+	disable_irq_nosync(irq);
+	st->thresh_timestamp = iio_get_time_ns();
 	schedule_work(&st->work_thresh);
 
-	return 0;
+	return IRQ_HANDLED;
 }
 
-/* A shared handler for a number of threshold types */
-IIO_EVENT_SH(threshold, &lis3l02dq_thresh_handler_th);
-
-
 #define LIS3L02DQ_INFO_MASK				\
 	((1 << IIO_CHAN_INFO_SCALE_SHARED) |		\
 	 (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE) |	\
@@ -447,12 +442,13 @@ IIO_EVENT_SH(threshold, &lis3l02dq_thresh_handler_th);
 static struct iio_chan_spec lis3l02dq_channels[] = {
 	IIO_CHAN_EV(IIO_ACCEL, 'x', LIS3L02DQ_INFO_MASK,
 		    0, 0, IIO_ST('s', 12, 16, 0),
-		    LIS3L02DQ_EVENT_MASK, &iio_event_threshold),
+		    LIS3L02DQ_EVENT_MASK, NULL),
 	IIO_CHAN_EV(IIO_ACCEL, 'y', LIS3L02DQ_INFO_MASK,
 		    1, 1, IIO_ST('s', 12, 16, 0),
-		    LIS3L02DQ_EVENT_MASK, &iio_event_threshold),
-	IIO_CHAN(IIO_ACCEL, 'z', LIS3L02DQ_INFO_MASK,
-		 2, 2, IIO_ST('s', 12, 16, 0)),
+		    LIS3L02DQ_EVENT_MASK, NULL),
+	IIO_CHAN_EV(IIO_ACCEL, 'z', LIS3L02DQ_INFO_MASK,
+		    2, 2, IIO_ST('s', 12, 16, 0),
+		    LIS3L02DQ_EVENT_MASK, NULL),
 	IIO_CHAN_SOFT_TIMESTAMP(3)
 };
 
@@ -475,11 +471,57 @@ static ssize_t lis3l02dq_read_event_config(struct iio_dev *indio_dev,
 	return !!(val & mask);
 }
 
+int lis3l02dq_disable_all_events(struct iio_dev *indio_dev)
+{
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
+	int ret;
+	u8 control, val;
+	bool irqtofree;
+
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
+				       LIS3L02DQ_REG_CTRL_2_ADDR,
+				       &control);
+
+	irqtofree = !!(control & LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
+
+	control &= ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT;
+	ret = lis3l02dq_spi_write_reg_8(indio_dev,
+					LIS3L02DQ_REG_CTRL_2_ADDR,
+					&control);
+	if (ret)
+		goto error_ret;
+	/* Also for consistency clear the mask */
+	ret = lis3l02dq_spi_read_reg_8(indio_dev,
+				       LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
+				       &val);
+	if (ret)
+		goto error_ret;
+	val &= ~0x3f;
+
+	ret = lis3l02dq_spi_write_reg_8(indio_dev,
+					LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
+					&val);
+	if (ret)
+		goto error_ret;
+
+	if (irqtofree)
+		free_irq(st->us->irq, indio_dev->interrupts[0]);
+
+	ret = control;
+error_ret:
+	return ret;
+}
+
 static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 					int event_code,
 					struct iio_event_handler_list *list_el,
 					int state)
 {
+	struct iio_sw_ring_helper_state *h
+		= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 	int ret = 0;
 	u8 val, control;
 	u8 currentlyset;
@@ -505,27 +547,39 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 	if (!currentlyset && state) {
 		changed = true;
 		val |= mask;
-		iio_add_event_to_list(list_el,
-				      &indio_dev->interrupts[0]->ev_list);
-
 	} else if (currentlyset && !state) {
 		changed = true;
 		val &= ~mask;
-		iio_remove_event_from_list(list_el,
-					   &indio_dev->interrupts[0]->ev_list);
 	}
+
 	if (changed) {
+		if (!(control & LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT)) {
+			ret = request_irq(st->us->irq,
+					  &lis3l02dq_event_handler,
+					  IRQF_TRIGGER_RISING,
+					  "lis3l02dq_event",
+					  indio_dev->interrupts[0]);
+			if (ret)
+				goto error_ret;
+		}
+
 		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_WAKE_UP_CFG_ADDR,
 						&val);
 		if (ret)
 			goto error_ret;
-		control = list_el->refcount ?
+		control = val & 0x3f ?
 			(control | LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT) :
 			(control & ~LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT);
 		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 					       LIS3L02DQ_REG_CTRL_2_ADDR,
 					       &control);
+		if (ret)
+			goto error_ret;
+
+		/* remove interrupt handler if nothing is still on */
+		if (!(val & 0x3f))
+			free_irq(st->us->irq, indio_dev->interrupts[0]);
 	}
 
 error_ret:
@@ -538,7 +592,7 @@ error_ret:
  */
 static void lis3l02dq_thresh_handler_bh_no_check(struct work_struct *work_s)
 {
-       struct lis3l02dq_state *st
+	struct lis3l02dq_state *st
 	       = container_of(work_s,
 		       struct lis3l02dq_state, work_thresh);
 
@@ -696,7 +750,6 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 						  "lis3l02dq");
 		if (ret)
 			goto error_uninitialize_ring;
-
 		ret = lis3l02dq_probe_trigger(st->help.indio_dev);
 		if (ret)
 			goto error_unregister_line;
@@ -767,6 +820,9 @@ static int lis3l02dq_remove(struct spi_device *spi)
 	int ret;
 	struct lis3l02dq_state *st = spi_get_drvdata(spi);
 	struct iio_dev *indio_dev = st->help.indio_dev;
+	ret = lis3l02dq_disable_all_events(indio_dev);
+	if (ret)
+		goto err_ret;
 
 	ret = lis3l02dq_stop_device(indio_dev);
 	if (ret)
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 1a4b3fc..9b15cad 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -51,23 +51,14 @@ static void lis3l02dq_poll_func_th(struct iio_dev *indio_dev, s64 time)
 /**
  * lis3l02dq_data_rdy_trig_poll() the event handler for the data rdy trig
  **/
-static int lis3l02dq_data_rdy_trig_poll(struct iio_dev *indio_dev,
-				       int index,
-				       s64 timestamp,
-				       int no_test)
+static irqreturn_t lis3l02dq_data_rdy_trig_poll(int irq, void *private)
 {
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
-
-	iio_trigger_poll(st->trig, timestamp);
+	disable_irq_nosync(irq);
+	iio_trigger_poll(private, iio_get_time_ns());
 
 	return IRQ_HANDLED;
 }
 
-/* This is an event as it is a response to a physical interrupt */
-IIO_EVENT_SH(data_rdy_trig, &lis3l02dq_data_rdy_trig_poll);
-
 /**
  * lis3l02dq_read_accel_from_ring() individual acceleration read from ring
  **/
@@ -196,14 +187,15 @@ static int lis3l02dq_get_ring_element(struct iio_sw_ring_helper_state *h,
 
 /* Caller responsible for locking as necessary. */
 static int
-__lis3l02dq_write_data_ready_config(struct device *dev,
-				    struct iio_event_handler_list *list,
-				    bool state)
+__lis3l02dq_write_data_ready_config(struct device *dev, bool state)
 {
 	int ret;
 	u8 valold;
 	bool currentlyset;
 	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_sw_ring_helper_state *h
+				= iio_dev_get_devdata(indio_dev);
+	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
 
 /* Get the current event mask register */
 	ret = lis3l02dq_spi_read_reg_8(indio_dev,
@@ -217,8 +209,9 @@ __lis3l02dq_write_data_ready_config(struct device *dev,
 
 /* Disable requested */
 	if (!state && currentlyset) {
-
+		/* disable the data ready signal */
 		valold &= ~LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
+
 		/* The double write is to overcome a hardware bug?*/
 		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_CTRL_2_ADDR,
@@ -231,20 +224,31 @@ __lis3l02dq_write_data_ready_config(struct device *dev,
 		if (ret)
 			goto error_ret;
 
-		iio_remove_event_from_list(list,
-					   &indio_dev->interrupts[0]
-					   ->ev_list);
-
+		free_irq(st->us->irq, st->trig);
 /* Enable requested */
 	} else if (state && !currentlyset) {
 		/* if not set, enable requested */
-		valold |= LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
-		iio_add_event_to_list(list, &indio_dev->interrupts[0]->ev_list);
+		/* first disable all events */
+		ret = lis3l02dq_disable_all_events(indio_dev);
+		if (ret < 0)
+			goto error_ret;
+
+		valold = ret |
+			LIS3L02DQ_REG_CTRL_2_ENABLE_DATA_READY_GENERATION;
+		ret = request_irq(st->us->irq,
+				  lis3l02dq_data_rdy_trig_poll,
+				  IRQF_TRIGGER_RISING, "lis3l02dq_datardy",
+				  st->trig);
+		if (ret)
+			goto error_ret;
+
 		ret = lis3l02dq_spi_write_reg_8(indio_dev,
 						LIS3L02DQ_REG_CTRL_2_ADDR,
 						&valold);
-		if (ret)
+		if (ret) {
+			free_irq(st->us->irq, st->trig);
 			goto error_ret;
+		}
 	}
 
 	return 0;
@@ -265,10 +269,8 @@ static int lis3l02dq_data_rdy_trigger_set_state(struct iio_trigger *trig,
 	struct lis3l02dq_state *st = trig->private_data;
 	int ret = 0;
 	u8 t;
-	__lis3l02dq_write_data_ready_config(&st->help.indio_dev->dev,
-					    &iio_event_data_rdy_trig,
-					    state);
-	if (st == false) {
+	__lis3l02dq_write_data_ready_config(&st->help.indio_dev->dev, state);
+	if (state == false) {
 		/* possible quirk with handler currently worked around
 		   by ensuring the work queue is empty */
 		flush_scheduled_work();
-- 
1.7.3.4

