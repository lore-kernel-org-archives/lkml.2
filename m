Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab1CaOzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:55:55 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57420 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab1CaOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 12/21] staging:iio:lis3l02dq make threshold interrupt threaded.
Date: Thu, 31 Mar 2011 15:54:06 +0100
Message-Id: <1301583255-28468-13-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have moved the timestamp acquisition into the bottom half. It may
technically be less accurate but for this device I very much doubt
anyone cares!

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/accel/lis3l02dq.h      |    4 -
 drivers/staging/iio/accel/lis3l02dq_core.c |  160 +++++++++++++---------------
 2 files changed, 73 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index ba40f50..6d73325 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -150,8 +150,6 @@ Form of high byte dependant on justification set in ctrl reg */
  * struct lis3l02dq_state - device instance specific data
  * @helper:		data and func pointer allowing generic functions
  * @us:			actual spi_device
- * @work_thresh:	bh for threshold events
- * @thresh_timestamp:	timestamp for threshold interrupts.
  * @inter:		used to check if new interrupt has been triggered
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
@@ -161,8 +159,6 @@ Form of high byte dependant on justification set in ctrl reg */
 struct lis3l02dq_state {
 	struct iio_sw_ring_helper_state	help;
 	struct spi_device		*us;
-	struct work_struct		work_thresh;
-	s64				thresh_timestamp;
 	bool				inter;
 	struct iio_trigger		*trig;
 	u8				*tx;
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 70b1ae0..2bded87 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -421,10 +421,72 @@ static irqreturn_t lis3l02dq_event_handler(int irq, void *private)
 	struct iio_sw_ring_helper_state *h
 		= iio_dev_get_devdata(indio_dev);
 	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
+	u8 t;
+
+	s64 timestamp = iio_get_time_ns();
+
+	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
+				 LIS3L02DQ_REG_WAKE_UP_SRC_ADDR,
+				 &t);
 
-	disable_irq_nosync(irq);
-	st->thresh_timestamp = iio_get_time_ns();
-	schedule_work(&st->work_thresh);
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH)
+		iio_push_event(st->help.indio_dev, 0,
+			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
+						  0,
+						  IIO_EV_MOD_Z,
+						  IIO_EV_TYPE_THRESH,
+						  IIO_EV_DIR_RISING),
+			       timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW)
+		iio_push_event(st->help.indio_dev, 0,
+			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
+						  0,
+						  IIO_EV_MOD_Z,
+						  IIO_EV_TYPE_THRESH,
+						  IIO_EV_DIR_FALLING),
+			       timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH)
+		iio_push_event(st->help.indio_dev, 0,
+			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
+						  0,
+						  IIO_EV_MOD_Y,
+						  IIO_EV_TYPE_THRESH,
+						  IIO_EV_DIR_RISING),
+			       timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_LOW)
+		iio_push_event(st->help.indio_dev, 0,
+			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
+						  0,
+						  IIO_EV_MOD_Y,
+						  IIO_EV_TYPE_THRESH,
+						  IIO_EV_DIR_FALLING),
+			       timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_HIGH)
+		iio_push_event(st->help.indio_dev, 0,
+			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
+						  0,
+						  IIO_EV_MOD_X,
+						  IIO_EV_TYPE_THRESH,
+						  IIO_EV_DIR_RISING),
+			       timestamp);
+
+	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_LOW)
+		iio_push_event(st->help.indio_dev, 0,
+			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
+						  0,
+						  IIO_EV_MOD_X,
+						  IIO_EV_TYPE_THRESH,
+						  IIO_EV_DIR_FALLING),
+			       timestamp);
+
+	/* Ack and allow for new interrupts */
+	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
+				 LIS3L02DQ_REG_WAKE_UP_ACK_ADDR,
+				 &t);
 
 	return IRQ_HANDLED;
 }
@@ -552,11 +614,13 @@ static int lis3l02dq_write_event_config(struct iio_dev *indio_dev,
 
 	if (changed) {
 		if (!(control & LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT)) {
-			ret = request_irq(st->us->irq,
-					  &lis3l02dq_event_handler,
-					  IRQF_TRIGGER_RISING,
-					  "lis3l02dq_event",
-					  indio_dev);
+			ret = request_threaded_irq(st->us->irq,
+						   NULL,
+						   &lis3l02dq_event_handler,
+						   IRQF_TRIGGER_RISING |
+						   IRQF_ONESHOT,
+						   "lis3l02dq_event",
+						   indio_dev);
 			if (ret)
 				goto error_ret;
 		}
@@ -585,84 +649,6 @@ error_ret:
 	return ret;
 }
 
-/* Unforunately it appears the interrupt won't clear unless you read from the
- * src register.
- */
-static void lis3l02dq_thresh_handler_bh_no_check(struct work_struct *work_s)
-{
-	struct lis3l02dq_state *st
-	       = container_of(work_s,
-		       struct lis3l02dq_state, work_thresh);
-
-	u8 t;
-
-	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
-				 LIS3L02DQ_REG_WAKE_UP_SRC_ADDR,
-				 &t);
-
-	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH)
-		iio_push_event(st->help.indio_dev, 0,
-			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
-						  0,
-						  IIO_EV_MOD_Z,
-						  IIO_EV_TYPE_THRESH,
-						  IIO_EV_DIR_RISING),
-			       st->thresh_timestamp);
-
-	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW)
-		iio_push_event(st->help.indio_dev, 0,
-			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
-						  0,
-						  IIO_EV_MOD_Z,
-						  IIO_EV_TYPE_THRESH,
-						  IIO_EV_DIR_FALLING),
-			       st->thresh_timestamp);
-
-	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH)
-		iio_push_event(st->help.indio_dev, 0,
-			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
-						  0,
-						  IIO_EV_MOD_Y,
-						  IIO_EV_TYPE_THRESH,
-						  IIO_EV_DIR_RISING),
-			       st->thresh_timestamp);
-
-	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_LOW)
-		iio_push_event(st->help.indio_dev, 0,
-			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
-						  0,
-						  IIO_EV_MOD_Y,
-						  IIO_EV_TYPE_THRESH,
-						  IIO_EV_DIR_FALLING),
-			       st->thresh_timestamp);
-
-	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_HIGH)
-		iio_push_event(st->help.indio_dev, 0,
-			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
-						  0,
-						  IIO_EV_MOD_X,
-						  IIO_EV_TYPE_THRESH,
-						  IIO_EV_DIR_RISING),
-			       st->thresh_timestamp);
-
-	if (t & LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_X_LOW)
-		iio_push_event(st->help.indio_dev, 0,
-			       IIO_MOD_EVENT_CODE(IIO_EV_CLASS_ACCEL,
-						  0,
-						  IIO_EV_MOD_X,
-						  IIO_EV_TYPE_THRESH,
-						  IIO_EV_DIR_FALLING),
-			       st->thresh_timestamp);
-	/* reenable the irq */
-	enable_irq(st->us->irq);
-	/* Ack and allow for new interrupts */
-	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
-				 LIS3L02DQ_REG_WAKE_UP_ACK_ADDR,
-				 &t);
-
-	return;
-}
-
 static IIO_CONST_ATTR_NAME("lis3l02dq");
 
 static struct attribute *lis3l02dq_attributes[] = {
@@ -684,7 +670,7 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 		ret =  -ENOMEM;
 		goto error_ret;
 	}
-	INIT_WORK(&st->work_thresh, lis3l02dq_thresh_handler_bh_no_check);
+
 	/* this is only used tor removal purposes */
 	spi_set_drvdata(spi, st);
 
-- 
1.7.3.4

