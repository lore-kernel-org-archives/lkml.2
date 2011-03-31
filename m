Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab1CaOx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:53:29 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:57444 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069Ab1CaOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:52:55 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, tglx@linutronix.de, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 19/21] staging:iio:lis3l02dq move to threaded trigger handling.
Date: Thu, 31 Mar 2011 15:54:13 +0100
Message-Id: <1301583255-28468-20-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
References: <1301583255-28468-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/accel/lis3l02dq.h      |    2 -
 drivers/staging/iio/accel/lis3l02dq_core.c |    2 -
 drivers/staging/iio/accel/lis3l02dq_ring.c |   96 ++++++++++-----------------
 3 files changed, 36 insertions(+), 64 deletions(-)

diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index 6d73325..e7f64bd 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -150,7 +150,6 @@ Form of high byte dependant on justification set in ctrl reg */
  * struct lis3l02dq_state - device instance specific data
  * @helper:		data and func pointer allowing generic functions
  * @us:			actual spi_device
- * @inter:		used to check if new interrupt has been triggered
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
  * @rx:			recieve buffer
@@ -159,7 +158,6 @@ Form of high byte dependant on justification set in ctrl reg */
 struct lis3l02dq_state {
 	struct iio_sw_ring_helper_state	help;
 	struct spi_device		*us;
-	bool				inter;
 	struct iio_trigger		*trig;
 	u8				*tx;
 	u8				*rx;
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index 2bded87..46f0633 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/gpio.h>
-#include <linux/workqueue.h>
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -726,7 +725,6 @@ static int __devinit lis3l02dq_probe(struct spi_device *spi)
 	}
 
 	if (spi->irq && gpio_is_valid(irq_to_gpio(spi->irq)) > 0) {
-		st->inter = 0;
 		ret = lis3l02dq_probe_trigger(st->help.indio_dev);
 		if (ret)
 			goto error_uninitialize_ring;
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 9b15cad..04a0265 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -29,31 +29,10 @@ static inline u16 combine_8_to_16(u8 lower, u8 upper)
 }
 
 /**
- * lis3l02dq_poll_func_th() top half interrupt handler called by trigger
- * @private_data:	iio_dev
- **/
-static void lis3l02dq_poll_func_th(struct iio_dev *indio_dev, s64 time)
-{
-	struct iio_sw_ring_helper_state *h
-		= iio_dev_get_devdata(indio_dev);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
-	/* in this case we need to slightly extend the helper function */
-	iio_sw_poll_func_th(indio_dev, time);
-
-	/* Indicate that this interrupt is being handled */
-	/* Technically this is trigger related, but without this
-	 * handler running there is currently now way for the interrupt
-	 * to clear.
-	 */
-	st->inter = 1;
-}
-
-/**
  * lis3l02dq_data_rdy_trig_poll() the event handler for the data rdy trig
  **/
 static irqreturn_t lis3l02dq_data_rdy_trig_poll(int irq, void *private)
 {
-	disable_irq_nosync(irq);
 	iio_trigger_poll(private, iio_get_time_ns());
 
 	return IRQ_HANDLED;
@@ -153,15 +132,16 @@ static int lis3l02dq_read_all(struct lis3l02dq_state *st, u8 *rx_array)
 	return ret;
 }
 
-static void lis3l02dq_trigger_bh_to_ring(struct work_struct *work_s)
+static irqreturn_t lis3l02dq_trigger_handler(int irq, void *p)
 {
-	struct iio_sw_ring_helper_state *h
-		= container_of(work_s, struct iio_sw_ring_helper_state,
-			work_trigger_to_ring);
-	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
+	struct iio_poll_func *pf = p;
+	struct iio_dev *indio_dev = pf->private_data;
+	struct iio_sw_ring_helper_state *h = iio_dev_get_devdata(indio_dev);
 
-	st->inter = 0;
-	iio_sw_trigger_bh_to_ring(work_s);
+	h->last_timestamp = iio_get_time_ns();
+	iio_sw_trigger_to_ring(h);
+
+	return IRQ_HANDLED;
 }
 
 static int lis3l02dq_get_ring_element(struct iio_sw_ring_helper_state *h,
@@ -271,10 +251,10 @@ static int lis3l02dq_data_rdy_trigger_set_state(struct iio_trigger *trig,
 	u8 t;
 	__lis3l02dq_write_data_ready_config(&st->help.indio_dev->dev, state);
 	if (state == false) {
-		/* possible quirk with handler currently worked around
-		   by ensuring the work queue is empty */
-		flush_scheduled_work();
-		/* Clear any outstanding ready events */
+		/*
+		 * A possible quirk with teh handler is currently worked around
+		 *  by ensuring outstanding read events are cleared.
+		 */
 		ret = lis3l02dq_read_all(st, NULL);
 	}
 	lis3l02dq_spi_read_reg_8(st->help.indio_dev,
@@ -297,32 +277,15 @@ static const struct attribute_group lis3l02dq_trigger_attr_group = {
 /**
  * lis3l02dq_trig_try_reen() try renabling irq for data rdy trigger
  * @trig:	the datardy trigger
- *
- * As the trigger may occur on any data element being updated it is
- * really rather likely to occur during the read from the previous
- * trigger event.  The only way to discover if this has occured on
- * boards not supporting level interrupts is to take a look at the line.
- * If it is indicating another interrupt and we don't seem to have a
- * handler looking at it, then we need to notify the core that we need
- * to tell the triggering core to try reading all these again.
- **/
+ */
 static int lis3l02dq_trig_try_reen(struct iio_trigger *trig)
 {
 	struct lis3l02dq_state *st = trig->private_data;
-	enable_irq(st->us->irq);
 	/* If gpio still high (or high again) */
+	/* In theory possible we will need to do this several times */
 	if (gpio_get_value(irq_to_gpio(st->us->irq)))
-		if (st->inter == 0) {
-			/* already interrupt handler dealing with it */
-			disable_irq_nosync(st->us->irq);
-			if (st->inter == 1) {
-				/* interrupt handler snuck in between test
-				 * and disable */
-				enable_irq(st->us->irq);
-				return 0;
-			}
-			return -EAGAIN;
-		}
+		lis3l02dq_read_all(st, NULL);
+
 	/* irq reenabled so success! */
 	return 0;
 }
@@ -333,14 +296,16 @@ int lis3l02dq_probe_trigger(struct iio_dev *indio_dev)
 	struct iio_sw_ring_helper_state *h
 		= iio_dev_get_devdata(indio_dev);
 	struct lis3l02dq_state *st = lis3l02dq_h_to_s(h);
+	char *name;
 
-	st->trig = iio_allocate_trigger();
+	name = kasprintf(GFP_KERNEL,
+			 "lis3l02dq-dev%d",
+			 indio_dev->id);
+	st->trig = iio_allocate_trigger_named(name);
 	if (!st->trig)
 		return -ENOMEM;
 
-	st->trig->name = kasprintf(GFP_KERNEL,
-				   "lis3l02dq-dev%d",
-				   indio_dev->id);
+	st->trig->name = name;
 	if (!st->trig->name) {
 		ret = -ENOMEM;
 		goto error_free_trig;
@@ -379,6 +344,7 @@ void lis3l02dq_remove_trigger(struct iio_dev *indio_dev)
 
 void lis3l02dq_unconfigure_ring(struct iio_dev *indio_dev)
 {
+	kfree(indio_dev->pollfunc->name);
 	kfree(indio_dev->pollfunc);
 	lis3l02dq_free_buf(indio_dev->ring);
 }
@@ -458,7 +424,7 @@ int lis3l02dq_configure_ring(struct iio_dev *indio_dev)
 	int ret;
 	struct iio_sw_ring_helper_state *h = iio_dev_get_devdata(indio_dev);
 	struct iio_ring_buffer *ring;
-	INIT_WORK(&h->work_trigger_to_ring, lis3l02dq_trigger_bh_to_ring);
+
 	h->get_ring_element = &lis3l02dq_get_ring_element;
 
 	ring = lis3l02dq_alloc_buf(indio_dev);
@@ -481,9 +447,19 @@ int lis3l02dq_configure_ring(struct iio_dev *indio_dev)
 	iio_scan_mask_set(ring, 1);
 	iio_scan_mask_set(ring, 2);
 
-	ret = iio_alloc_pollfunc(indio_dev, NULL, &lis3l02dq_poll_func_th);
-	if (ret)
+	/* Functions are NULL as we set handler below */
+	indio_dev->pollfunc = kzalloc(sizeof(*indio_dev->pollfunc), GFP_KERNEL);
+
+	if (indio_dev->pollfunc == NULL) {
+		ret = -ENOMEM;
 		goto error_iio_sw_rb_free;
+	}
+	indio_dev->pollfunc->private_data = indio_dev;
+	indio_dev->pollfunc->handler = &lis3l02dq_trigger_handler;
+	indio_dev->pollfunc->type = IRQF_ONESHOT;
+	indio_dev->pollfunc->name
+		= kasprintf(GFP_KERNEL, "lis3l02dq_consumer%d", indio_dev->id);
+
 	indio_dev->modes |= INDIO_RING_TRIGGERED;
 	return 0;
 
-- 
1.7.3.4

