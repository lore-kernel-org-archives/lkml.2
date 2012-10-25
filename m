Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935851Ab2JYPQP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:16:15 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38812 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935800Ab2JYPQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:16:06 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] Fix the warning related to type check in kfifo.h
Date: Thu, 25 Oct 2012 23:15:37 +0800
Message-Id: <1351178137-10760-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12102515-2674-0000-0000-00000679A95B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In d096f3b046, typecheck() replace the original code to check the type
mismatch for kfifo related macros.

After this patch, there shows several warnings. This reason is the original
code use the assignment to check the type. When the left value is a type of
"void *", then there is no warning. This type of mismatch can be detected by
typecheck() macro.

This patch fix the warnings detected by the typecheck() macro.
1. kfifo_in() second parameter should be type "const void *"
1. kfifo_out() second parameter should by type "void *"
3. kfifo_out_locked() second parameter should be type "void *"
4. kfifo_in_locked() second parameter should be type "const void *"

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 arch/arm/plat-omap/mailbox.c                |    8 ++++----
 drivers/char/sonypi.c                       |    8 ++++----
 drivers/hid/hid-logitech-dj.c               |    8 ++++----
 drivers/iio/kfifo_buf.c                     |    2 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c |   16 ++++++++--------
 drivers/media/i2c/cx25840/cx25840-ir.c      |    4 ++--
 drivers/media/pci/cx23885/cx23888-ir.c      |    4 ++--
 drivers/media/pci/meye/meye.c               |   16 ++++++++--------
 drivers/media/rc/ir-raw.c                   |    4 ++--
 drivers/memstick/host/r592.c                |   14 +++++++-------
 drivers/mmc/card/sdio_uart.c                |    5 +++--
 drivers/mtd/sm_ftl.c                        |   10 +++++-----
 drivers/net/wireless/libertas/main.c        |    4 ++--
 drivers/platform/x86/fujitsu-laptop.c       |    4 ++--
 drivers/platform/x86/sony-laptop.c          |   10 +++++-----
 drivers/rapidio/devices/tsi721.c            |    2 +-
 drivers/scsi/libiscsi.c                     |    8 ++++----
 drivers/scsi/libiscsi_tcp.c                 |   12 ++++++------
 drivers/scsi/libsrp.c                       |    4 ++--
 drivers/tty/n_gsm.c                         |    4 ++--
 drivers/tty/nozomi.c                        |    4 ++--
 drivers/tty/serial/ifx6x60.c                |    4 ++--
 drivers/tty/serial/kgdb_nmi.c               |    4 ++--
 drivers/usb/host/fhci.h                     |    2 +-
 drivers/usb/serial/aircable.c               |    3 ++-
 drivers/usb/serial/cypress_m8.c             |    4 ++--
 drivers/usb/serial/ftdi_sio.c               |    2 +-
 drivers/usb/serial/generic.c                |    2 +-
 drivers/usb/serial/io_ti.c                  |    4 ++--
 drivers/usb/serial/ir-usb.c                 |    2 +-
 drivers/usb/serial/kl5kusb105.c             |    4 ++--
 drivers/usb/serial/oti6858.c                |    4 ++--
 drivers/usb/serial/safe_serial.c            |    4 ++--
 drivers/usb/serial/ti_usb_3410_5052.c       |    4 ++--
 include/media/lirc_dev.h                    |    4 ++--
 net/dccp/probe.c                            |    4 ++--
 net/sctp/probe.c                            |    4 ++--
 samples/kfifo/bytestream-example.c          |    6 +++---
 samples/kfifo/inttype-example.c             |    4 ++--
 samples/kfifo/record-example.c              |    4 ++--
 40 files changed, 111 insertions(+), 109 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 42377ef..4ea1668 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -105,7 +105,7 @@ int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg)
 		goto out;
 	}
 
-	len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+	len = kfifo_in(&mq->fifo, (const void *)&msg, sizeof(msg));
 	WARN_ON(len != sizeof(msg));
 
 	tasklet_schedule(&mbox->txq->tasklet);
@@ -129,7 +129,7 @@ static void mbox_tx_tasklet(unsigned long tx_data)
 			break;
 		}
 
-		ret = kfifo_out(&mq->fifo, (unsigned char *)&msg,
+		ret = kfifo_out(&mq->fifo, (void *)&msg,
 								sizeof(msg));
 		WARN_ON(ret != sizeof(msg));
 
@@ -148,7 +148,7 @@ static void mbox_rx_work(struct work_struct *work)
 	int len;
 
 	while (kfifo_len(&mq->fifo) >= sizeof(msg)) {
-		len = kfifo_out(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+		len = kfifo_out(&mq->fifo, (void *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
 		blocking_notifier_call_chain(&mq->mbox->notifier, len,
@@ -187,7 +187,7 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
 
 		msg = mbox_fifo_read(mbox);
 
-		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
+		len = kfifo_in(&mq->fifo, (const void *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
 		if (mbox->ops->type == OMAP_MBOX_TYPE1)
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 320debb..974bf9b 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -776,7 +776,7 @@ static void input_keyrelease(struct work_struct *work)
 {
 	struct sonypi_keypress kp;
 
-	while (kfifo_out_locked(&sonypi_device.input_fifo, (unsigned char *)&kp,
+	while (kfifo_out_locked(&sonypi_device.input_fifo, (void *)&kp,
 			 sizeof(kp), &sonypi_device.input_fifo_lock)
 			== sizeof(kp)) {
 		msleep(10);
@@ -828,7 +828,7 @@ static void sonypi_report_input_event(u8 event)
 		input_report_key(kp.dev, kp.key, 1);
 		input_sync(kp.dev);
 		kfifo_in_locked(&sonypi_device.input_fifo,
-			(unsigned char *)&kp, sizeof(kp),
+			(const void *)&kp, sizeof(kp),
 			&sonypi_device.input_fifo_lock);
 		schedule_work(&sonypi_device.input_work);
 	}
@@ -881,7 +881,7 @@ found:
 		acpi_bus_generate_proc_event(sonypi_acpi_device, 1, event);
 #endif
 
-	kfifo_in_locked(&sonypi_device.fifo, (unsigned char *)&event,
+	kfifo_in_locked(&sonypi_device.fifo, (const void *)&event,
 			sizeof(event), &sonypi_device.fifo_lock);
 	kill_fasync(&sonypi_device.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_device.fifo_proc_list);
@@ -930,7 +930,7 @@ static ssize_t sonypi_misc_read(struct file *file, char __user *buf,
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_out_locked(&sonypi_device.fifo, &c, sizeof(c),
+	       (kfifo_out_locked(&sonypi_device.fifo, (void *)&c, sizeof(c),
 				 &sonypi_device.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 9500f2f..9b72917 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -320,7 +320,7 @@ static void delayedwork_callback(struct work_struct *work)
 
 	spin_lock_irqsave(&djrcv_dev->lock, flags);
 
-	count = kfifo_out(&djrcv_dev->notif_fifo, &dj_report,
+	count = kfifo_out(&djrcv_dev->notif_fifo, (void *)&dj_report,
 				sizeof(struct dj_report));
 
 	if (count != sizeof(struct dj_report)) {
@@ -375,7 +375,7 @@ static void logi_dj_recv_queue_notification(struct dj_receiver_dev *djrcv_dev,
 {
 	/* We are called from atomic context (tasklet && djrcv->lock held) */
 
-	kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
+	kfifo_in(&djrcv_dev->notif_fifo, (const void *)dj_report, sizeof(struct dj_report));
 
 	if (schedule_work(&djrcv_dev->work) == 0) {
 		dbg_hid("%s: did not schedule the work item, was already "
@@ -396,7 +396,7 @@ static void logi_dj_recv_forward_null_report(struct dj_receiver_dev *djrcv_dev,
 	if (!djdev) {
 		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
 			" is NULL, index %d\n", dj_report->device_index);
-		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
+		kfifo_in(&djrcv_dev->notif_fifo, (const void *)dj_report, sizeof(struct dj_report));
 
 		if (schedule_work(&djrcv_dev->work) == 0) {
 			dbg_hid("%s: did not schedule the work item, was already "
@@ -432,7 +432,7 @@ static void logi_dj_recv_forward_report(struct dj_receiver_dev *djrcv_dev,
 	if (dj_device == NULL) {
 		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
 			" is NULL, index %d\n", dj_report->device_index);
-		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
+		kfifo_in(&djrcv_dev->notif_fifo, (const void *)dj_report, sizeof(struct dj_report));
 
 		if (schedule_work(&djrcv_dev->work) == 0) {
 			dbg_hid("%s: did not schedule the work item, was already "
diff --git a/drivers/iio/kfifo_buf.c b/drivers/iio/kfifo_buf.c
index 5bc5c86..d122aee 100644
--- a/drivers/iio/kfifo_buf.c
+++ b/drivers/iio/kfifo_buf.c
@@ -99,7 +99,7 @@ static int iio_store_to_kfifo(struct iio_buffer *r,
 {
 	int ret;
 	struct iio_kfifo *kf = iio_to_kfifo(r);
-	ret = kfifo_in(&kf->kf, data, 1);
+	ret = kfifo_in(&kf->kf, (const void *)data, 1);
 	if (ret != 1)
 		return -EBUSY;
 	r->stufftoread = true;
diff --git a/drivers/infiniband/hw/cxgb3/cxio_resource.c b/drivers/infiniband/hw/cxgb3/cxio_resource.c
index 31f9201..e9d3843 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_resource.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_resource.c
@@ -59,7 +59,7 @@ static int __cxio_init_resource_fifo(struct kfifo *fifo,
 		return -ENOMEM;
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));
+		kfifo_in(fifo, (const void*) &entry, sizeof(u32));
 	if (random) {
 		j = 0;
 		random_bytes = random32();
@@ -72,21 +72,21 @@ static int __cxio_init_resource_fifo(struct kfifo *fifo,
 			}
 			idx = (random_bytes >> (j * 2)) & 0xF;
 			kfifo_in(fifo,
-				(unsigned char *) &rarray[idx],
+				(const void *) &rarray[idx],
 				sizeof(u32));
 			rarray[idx] = i;
 			j++;
 		}
 		for (i = 0; i < RANDOM_SIZE; i++)
 			kfifo_in(fifo,
-				(unsigned char *) &rarray[i],
+				(const void *) &rarray[i],
 				sizeof(u32));
 	} else
 		for (i = skip_low; i < nr - skip_high; i++)
-			kfifo_in(fifo, (unsigned char *) &i, sizeof(u32));
+			kfifo_in(fifo, (const void *) &i, sizeof(u32));
 
 	for (i = 0; i < skip_low + skip_high; i++)
-		if (kfifo_out_locked(fifo, (unsigned char *) &entry,
+		if (kfifo_out_locked(fifo, (void *) &entry,
 				sizeof(u32), fifo_lock) != sizeof(u32))
 					break;
 	return 0;
@@ -121,7 +121,7 @@ static int cxio_init_qpid_fifo(struct cxio_rdev *rdev_p)
 	for (i = 16; i < T3_MAX_NUM_QP; i++)
 		if (!(i & rdev_p->qpmask))
 			kfifo_in(&rdev_p->rscp->qpid_fifo,
-				    (unsigned char *) &i, sizeof(u32));
+				    (const void *) &i, sizeof(u32));
 	return 0;
 }
 
@@ -181,7 +181,7 @@ tpt_err:
 static u32 cxio_hal_get_resource(struct kfifo *fifo, spinlock_t * lock)
 {
 	u32 entry;
-	if (kfifo_out_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock))
+	if (kfifo_out_locked(fifo, (void *) &entry, sizeof(u32), lock))
 		return entry;
 	else
 		return 0;	/* fifo emptry */
@@ -191,7 +191,7 @@ static void cxio_hal_put_resource(struct kfifo *fifo, spinlock_t * lock,
 		u32 entry)
 {
 	BUG_ON(
-	kfifo_in_locked(fifo, (unsigned char *) &entry, sizeof(u32), lock)
+	kfifo_in_locked(fifo, (const void *) &entry, sizeof(u32), lock)
 	== 0);
 }
 
diff --git a/drivers/media/i2c/cx25840/cx25840-ir.c b/drivers/media/i2c/cx25840/cx25840-ir.c
index 38ce76e..1724837 100644
--- a/drivers/media/i2c/cx25840/cx25840-ir.c
+++ b/drivers/media/i2c/cx25840/cx25840-ir.c
@@ -611,7 +611,7 @@ int cx25840_ir_irq_handler(struct v4l2_subdev *sd, u32 status, bool *handled)
 				break;
 			j = i * sizeof(union cx25840_ir_fifo_rec);
 			k = kfifo_in_locked(&ir_state->rx_kfifo,
-					    (unsigned char *) rx_data, j,
+					    (const void *) rx_data, j,
 					    &ir_state->rx_kfifo_lock);
 			if (k != j)
 				kror++; /* rx_kfifo over run */
@@ -682,7 +682,7 @@ static int cx25840_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		return 0;
 	}
 
-	n = kfifo_out_locked(&ir_state->rx_kfifo, buf, n,
+	n = kfifo_out_locked(&ir_state->rx_kfifo, (void *)buf, n,
 			     &ir_state->rx_kfifo_lock);
 
 	n /= sizeof(union cx25840_ir_fifo_rec);
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index c2bc39c..b14bcac 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -613,7 +613,7 @@ static int cx23888_ir_irq_handler(struct v4l2_subdev *sd, u32 status,
 				break;
 			j = i * sizeof(union cx23888_ir_fifo_rec);
 			k = kfifo_in_locked(&state->rx_kfifo,
-				      (unsigned char *) rx_data, j,
+				      (const void *) rx_data, j,
 				      &state->rx_kfifo_lock);
 			if (k != j)
 				kror++; /* rx_kfifo over run */
@@ -680,7 +680,7 @@ static int cx23888_ir_rx_read(struct v4l2_subdev *sd, u8 *buf, size_t count,
 		return 0;
 	}
 
-	n = kfifo_out_locked(&state->rx_kfifo, buf, n, &state->rx_kfifo_lock);
+	n = kfifo_out_locked(&state->rx_kfifo, (void *)buf, n, &state->rx_kfifo_lock);
 
 	n /= sizeof(union cx23888_ir_fifo_rec);
 	*num = n * sizeof(union cx23888_ir_fifo_rec);
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index e5a76da..7a79c46 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -802,7 +802,7 @@ again:
 		return IRQ_HANDLED;
 
 	if (meye.mchip_mode == MCHIP_HIC_MODE_CONT_OUT) {
-		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_out_locked(&meye.grabq, (void *)&reqnr,
 			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			return IRQ_HANDLED;
@@ -813,7 +813,7 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
+		kfifo_in_locked(&meye.doneq, (const void *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	} else {
@@ -823,7 +823,7 @@ again:
 			mchip_free_frame();
 			goto again;
 		}
-		if (kfifo_out_locked(&meye.grabq, (unsigned char *)&reqnr,
+		if (kfifo_out_locked(&meye.grabq, (void *)&reqnr,
 			      sizeof(int), &meye.grabq_lock) != sizeof(int)) {
 			mchip_free_frame();
 			goto again;
@@ -834,7 +834,7 @@ again:
 		meye.grab_buffer[reqnr].state = MEYE_BUF_DONE;
 		do_gettimeofday(&meye.grab_buffer[reqnr].timestamp);
 		meye.grab_buffer[reqnr].sequence = sequence++;
-		kfifo_in_locked(&meye.doneq, (unsigned char *)&reqnr,
+		kfifo_in_locked(&meye.doneq, (const void *)&reqnr,
 				sizeof(int), &meye.doneq_lock);
 		wake_up_interruptible(&meye.proc_list);
 	}
@@ -937,7 +937,7 @@ static int meyeioc_qbuf_capt(int *nb)
 		mchip_cont_compression_start();
 
 	meye.grab_buffer[*nb].state = MEYE_BUF_USING;
-	kfifo_in_locked(&meye.grabq, (unsigned char *)nb, sizeof(int),
+	kfifo_in_locked(&meye.grabq, (const void *)nb, sizeof(int),
 			 &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
@@ -970,7 +970,7 @@ static int meyeioc_sync(struct file *file, void *fh, int *i)
 		/* fall through */
 	case MEYE_BUF_DONE:
 		meye.grab_buffer[*i].state = MEYE_BUF_UNUSED;
-		if (kfifo_out_locked(&meye.doneq, (unsigned char *)&unused,
+		if (kfifo_out_locked(&meye.doneq, (void *)&unused,
 				sizeof(int), &meye.doneq_lock) != sizeof(int))
 					break;
 	}
@@ -1459,7 +1459,7 @@ static int vidioc_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 	buf->flags |= V4L2_BUF_FLAG_QUEUED;
 	buf->flags &= ~V4L2_BUF_FLAG_DONE;
 	meye.grab_buffer[buf->index].state = MEYE_BUF_USING;
-	kfifo_in_locked(&meye.grabq, (unsigned char *)&buf->index,
+	kfifo_in_locked(&meye.grabq, (const void *)&buf->index,
 			sizeof(int), &meye.grabq_lock);
 	mutex_unlock(&meye.lock);
 
@@ -1486,7 +1486,7 @@ static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
 		return -EINTR;
 	}
 
-	if (!kfifo_out_locked(&meye.doneq, (unsigned char *)&reqnr,
+	if (!kfifo_out_locked(&meye.doneq, (void *)&reqnr,
 		       sizeof(int), &meye.doneq_lock)) {
 		mutex_unlock(&meye.lock);
 		return -EBUSY;
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 97dc8d1..0699aa9 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -59,7 +59,7 @@ static int ir_raw_event_thread(void *data)
 			continue;
 		}
 
-		retval = kfifo_out(&raw->kfifo, &ev, sizeof(ev));
+		retval = kfifo_out(&raw->kfifo, (void *)&ev, sizeof(ev));
 		spin_unlock_irq(&raw->lock);
 
 		mutex_lock(&ir_raw_handler_lock);
@@ -90,7 +90,7 @@ int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev)
 	IR_dprintk(2, "sample: (%05dus %s)\n",
 		   TO_US(ev->duration), TO_STR(ev->pulse));
 
-	if (kfifo_in(&dev->raw->kfifo, ev, sizeof(*ev)) != sizeof(*ev))
+	if (kfifo_in(&dev->raw->kfifo, (const void *)ev, sizeof(*ev)) != sizeof(*ev))
 		return -ENOMEM;
 
 	return 0;
diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 29b2172..445d4e0 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -332,14 +332,14 @@ static void r592_write_fifo_pio(struct r592_device *dev,
 	if (!kfifo_is_empty(&dev->pio_fifo)) {
 
 		u8 tmp[4] = {0};
-		int copy_len = kfifo_in(&dev->pio_fifo, buffer, len);
+		int copy_len = kfifo_in(&dev->pio_fifo, (const void *)buffer, len);
 
 		if (!kfifo_is_full(&dev->pio_fifo))
 			return;
 		len -= copy_len;
 		buffer += copy_len;
 
-		copy_len = kfifo_out(&dev->pio_fifo, tmp, 4);
+		copy_len = kfifo_out(&dev->pio_fifo, (void *)tmp, 4);
 		WARN_ON(copy_len != 4);
 		r592_write_reg_raw_be(dev, R592_FIFO_PIO, *(u32 *)tmp);
 	}
@@ -355,7 +355,7 @@ static void r592_write_fifo_pio(struct r592_device *dev,
 
 	/* put remaining bytes to the spill */
 	if (len)
-		kfifo_in(&dev->pio_fifo, buffer, len);
+		kfifo_in(&dev->pio_fifo, (const void *)buffer, len);
 }
 
 /* Flushes the temporary FIFO used to make aligned DWORD writes */
@@ -367,7 +367,7 @@ static void r592_flush_fifo_write(struct r592_device *dev)
 	if (kfifo_is_empty(&dev->pio_fifo))
 		return;
 
-	len = kfifo_out(&dev->pio_fifo, buffer, 4);
+	len = kfifo_out(&dev->pio_fifo, (void *)buffer, 4);
 	r592_write_reg_raw_be(dev, R592_FIFO_PIO, *(u32 *)buffer);
 }
 
@@ -384,7 +384,7 @@ static void r592_read_fifo_pio(struct r592_device *dev,
 	/* Read from last spill */
 	if (!kfifo_is_empty(&dev->pio_fifo)) {
 		int bytes_copied =
-			kfifo_out(&dev->pio_fifo, buffer, min(4, len));
+			kfifo_out(&dev->pio_fifo, (void *)buffer, min(4, len));
 		buffer += bytes_copied;
 		len -= bytes_copied;
 
@@ -401,8 +401,8 @@ static void r592_read_fifo_pio(struct r592_device *dev,
 
 	if (len) {
 		*(u32 *)tmp = r592_read_reg_raw_be(dev, R592_FIFO_PIO);
-		kfifo_in(&dev->pio_fifo, tmp, 4);
-		len -= kfifo_out(&dev->pio_fifo, buffer, len);
+		kfifo_in(&dev->pio_fifo, (const void *)tmp, 4);
+		len -= kfifo_out(&dev->pio_fifo, (void *)buffer, len);
 	}
 
 	WARN_ON(len);
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index d2339ea..ac91ffc 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -472,7 +472,7 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 		return;
 	}
 
-	len = kfifo_out_locked(xmit, iobuf, 16, &port->write_lock);
+	len = kfifo_out_locked(xmit, (void *)iobuf, 16, &port->write_lock);
 	for (count = 0; count < len; count++) {
 		sdio_out(port, UART_TX, iobuf[count]);
 		port->icount.tx++;
@@ -806,7 +806,8 @@ static int sdio_uart_write(struct tty_struct *tty, const unsigned char *buf,
 	if (!port->func)
 		return -ENODEV;
 
-	ret = kfifo_in_locked(&port->xmit_fifo, buf, count, &port->write_lock);
+	ret = kfifo_in_locked(&port->xmit_fifo, (const void *)buf, count, 
+			&port->write_lock);
 	if (!(port->ier & UART_IER_THRI)) {
 		int err = sdio_uart_claim_func(port);
 		if (!err) {
diff --git a/drivers/mtd/sm_ftl.c b/drivers/mtd/sm_ftl.c
index 8dd6ba5..0890ee8 100644
--- a/drivers/mtd/sm_ftl.c
+++ b/drivers/mtd/sm_ftl.c
@@ -495,7 +495,7 @@ static int sm_erase_block(struct sm_ftl *ftl, int zone_num, uint16_t block,
 
 	if (put_free)
 		kfifo_in(&zone->free_sectors,
-			(const unsigned char *)&block, sizeof(block));
+			(const void *)&block, sizeof(block));
 
 	return 0;
 error:
@@ -798,7 +798,7 @@ static int sm_init_zone(struct sm_ftl *ftl, int zone_num)
 			first sector, because erase happens in one shot */
 		if (sm_block_erased(&oob)) {
 			kfifo_in(&zone->free_sectors,
-				(unsigned char *)&block, 2);
+				(const void *)&block, 2);
 			continue;
 		}
 
@@ -870,9 +870,9 @@ static int sm_init_zone(struct sm_ftl *ftl, int zone_num)
 
 	while (i--) {
 		len = kfifo_out(&zone->free_sectors,
-					(unsigned char *)&block, 2);
+					(void *)&block, 2);
 		WARN_ON(len != 2);
-		kfifo_in(&zone->free_sectors, (const unsigned char *)&block, 2);
+		kfifo_in(&zone->free_sectors, (const void *)&block, 2);
 	}
 	return 0;
 }
@@ -968,7 +968,7 @@ restart:
 		but for such worn out media it doesn't worth the trouble,
 			and the dangers */
 	if (kfifo_out(&zone->free_sectors,
-				(unsigned char *)&write_sector, 2) != 2) {
+				(void *)&write_sector, 2) != 2) {
 		dbg("no free sectors for write!");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 0c02f04..1208b30 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -547,7 +547,7 @@ static int lbs_thread(void *data)
 			u32 event;
 
 			if (kfifo_out(&priv->event_fifo,
-				(unsigned char *) &event, sizeof(event)) !=
+				(void *) &event, sizeof(event)) !=
 				sizeof(event))
 					break;
 			spin_unlock_irq(&priv->driver_lock);
@@ -1172,7 +1172,7 @@ void lbs_queue_event(struct lbs_private *priv, u32 event)
 	if (priv->psstate == PS_STATE_SLEEP)
 		priv->psstate = PS_STATE_AWAKE;
 
-	kfifo_in(&priv->event_fifo, (unsigned char *) &event, sizeof(u32));
+	kfifo_in(&priv->event_fifo, (const void *) &event, sizeof(u32));
 
 	wake_up(&priv->waitq);
 
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index c4c1a54..0c67d47 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -1006,7 +1006,7 @@ static void acpi_fujitsu_hotkey_notify(struct acpi_device *device, u32 event)
 					"Push keycode into ringbuffer [%d]\n",
 					keycode);
 				status = kfifo_in_locked(&fujitsu_hotkey->fifo,
-						   (unsigned char *)&keycode,
+						   (const void *)&keycode,
 						   sizeof(keycode),
 						   &fujitsu_hotkey->fifo_lock);
 				if (status != sizeof(keycode)) {
@@ -1021,7 +1021,7 @@ static void acpi_fujitsu_hotkey_notify(struct acpi_device *device, u32 event)
 				while ((status =
 					kfifo_out_locked(
 					 &fujitsu_hotkey->fifo,
-					 (unsigned char *) &keycode_r,
+					 (void *) &keycode_r,
 					 sizeof(keycode_r),
 					 &fujitsu_hotkey->fifo_lock))
 					 == sizeof(keycode_r)) {
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index daaddec..201e719 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -354,7 +354,7 @@ static void do_sony_laptop_release_key(unsigned long unused)
 	spin_lock_irqsave(&sony_laptop_input.fifo_lock, flags);
 
 	if (kfifo_out(&sony_laptop_input.fifo,
-		      (unsigned char *)&kp, sizeof(kp)) == sizeof(kp)) {
+		      (void *)&kp, sizeof(kp)) == sizeof(kp)) {
 		input_report_key(kp.dev, kp.key, 0);
 		input_sync(kp.dev);
 	}
@@ -425,7 +425,7 @@ static void sony_laptop_report_input_event(u8 event)
 
 		/* schedule key release */
 		kfifo_in_locked(&sony_laptop_input.fifo,
-				(unsigned char *)&kp, sizeof(kp),
+				(const void *)&kp, sizeof(kp),
 				&sony_laptop_input.fifo_lock);
 		mod_timer(&sony_laptop_input.release_key_timer,
 			  jiffies + msecs_to_jiffies(10));
@@ -542,7 +542,7 @@ static void sony_laptop_remove_input(void)
 	 * need locking since nobody is adding new events to the kfifo.
 	 */
 	while (kfifo_out(&sony_laptop_input.fifo,
-			 (unsigned char *)&kp, sizeof(kp)) == sizeof(kp)) {
+			 (void *)&kp, sizeof(kp)) == sizeof(kp)) {
 		input_report_key(kp.dev, kp.key, 0);
 		input_sync(kp.dev);
 	}
@@ -3557,7 +3557,7 @@ static ssize_t sonypi_misc_read(struct file *file, char __user *buf,
 		return ret;
 
 	while (ret < count &&
-	       (kfifo_out_locked(&sonypi_compat.fifo, &c, sizeof(c),
+	       (kfifo_out_locked(&sonypi_compat.fifo, (void *)&c, sizeof(c),
 			  &sonypi_compat.fifo_lock) == sizeof(c))) {
 		if (put_user(c, buf++))
 			return -EFAULT;
@@ -3740,7 +3740,7 @@ static struct miscdevice sonypi_misc_device = {
 
 static void sonypi_compat_report_event(u8 event)
 {
-	kfifo_in_locked(&sonypi_compat.fifo, (unsigned char *)&event,
+	kfifo_in_locked(&sonypi_compat.fifo, (const void *)&event,
 			sizeof(event), &sonypi_compat.fifo_lock);
 	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
 	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
diff --git a/drivers/rapidio/devices/tsi721.c b/drivers/rapidio/devices/tsi721.c
index 38ecd8f..728c6d7 100644
--- a/drivers/rapidio/devices/tsi721.c
+++ b/drivers/rapidio/devices/tsi721.c
@@ -263,7 +263,7 @@ tsi721_pw_handler(struct rio_mport *mport)
 		 */
 		spin_lock(&priv->pw_fifo_lock);
 		if (kfifo_avail(&priv->pw_fifo) >= TSI721_RIO_PW_MSG_SIZE)
-			kfifo_in(&priv->pw_fifo, pw_buf,
+			kfifo_in(&priv->pw_fifo, (const void *)pw_buf,
 						TSI721_RIO_PW_MSG_SIZE);
 		else
 			priv->pw_discard_count++;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 82c3fd4..094c56b 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -504,7 +504,7 @@ static void iscsi_free_task(struct iscsi_task *task)
 	if (conn->login_task == task)
 		return;
 
-	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
+	kfifo_in(&session->cmdpool.queue, (const void*)&task, sizeof(void*));
 
 	if (sc) {
 		task->sc = NULL;
@@ -2507,7 +2507,7 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 			q->max = i;
 			goto enomem;
 		}
-		kfifo_in(&q->queue, (void*)&q->pool[i], sizeof(void*));
+		kfifo_in(&q->queue, (const void*)&q->pool[i], sizeof(void*));
 	}
 
 	if (items) {
@@ -2878,7 +2878,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	return cls_conn;
 
 login_task_data_alloc_fail:
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->cmdpool.queue, (const void*)&conn->login_task,
 		    sizeof(void*));
 login_task_alloc_fail:
 	iscsi_destroy_conn(cls_conn);
@@ -2941,7 +2941,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
-	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
+	kfifo_in(&session->cmdpool.queue, (const void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
 		session->leadconn = NULL;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 552e8a2..be9a6d8 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -459,14 +459,14 @@ void iscsi_tcp_cleanup_task(struct iscsi_task *task)
 
 	/* flush task's r2t queues */
 	while (kfifo_out(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*))) {
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (const void*)&r2t,
 			    sizeof(void*));
 		ISCSI_DBG_TCP(task->conn, "pending r2t dropped\n");
 	}
 
 	r2t = tcp_task->r2t;
 	if (r2t != NULL) {
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (const void*)&r2t,
 			    sizeof(void*));
 		tcp_task->r2t = NULL;
 	}
@@ -567,7 +567,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	if (r2t->data_length == 0) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "invalid R2T with zero data len\n");
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (const void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -583,7 +583,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 				  "invalid R2T with data len %u at offset %u "
 				  "and total length %d\n", r2t->data_length,
 				  r2t->data_offset, scsi_out(task->sc)->length);
-		kfifo_in(&tcp_task->r2tpool.queue, (void*)&r2t,
+		kfifo_in(&tcp_task->r2tpool.queue, (const void*)&r2t,
 			    sizeof(void*));
 		return ISCSI_ERR_DATALEN;
 	}
@@ -593,7 +593,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	r2t->sent = 0;
 
 	tcp_task->exp_datasn = r2tsn + 1;
-	kfifo_in(&tcp_task->r2tqueue, (void*)&r2t, sizeof(void*));
+	kfifo_in(&tcp_task->r2tqueue, (const void*)&r2t, sizeof(void*));
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_task(task);
@@ -996,7 +996,7 @@ static struct iscsi_r2t_info *iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
 				ISCSI_DBG_TCP(task->conn,
 					      "  done with r2t %p\n", r2t);
 				kfifo_in(&tcp_task->r2tpool.queue,
-					    (void *)&tcp_task->r2t,
+					    (const void *)&tcp_task->r2t,
 					    sizeof(void *));
 				tcp_task->r2t = r2t = NULL;
 			}
diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 0707ecd..d9fb78d 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -63,7 +63,7 @@ static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
 
 	for (i = 0, iue = q->items; i < max; i++) {
-		kfifo_in(&q->queue, (void *) &iue, sizeof(void *));
+		kfifo_in(&q->queue, (const void *) &iue, sizeof(void *));
 		iue->sbuf = ring[i];
 		iue++;
 	}
@@ -181,7 +181,7 @@ EXPORT_SYMBOL_GPL(srp_iu_get);
 
 void srp_iu_put(struct iu_entry *iue)
 {
-	kfifo_in_locked(&iue->target->iu_queue.queue, (void *) &iue,
+	kfifo_in_locked(&iue->target->iu_queue.queue, (const void *) &iue,
 			sizeof(void *), &iue->target->iu_queue.lock);
 }
 EXPORT_SYMBOL_GPL(srp_iu_put);
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 1e8e8ce..d5c59f3 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -833,7 +833,7 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 			*dp++ = gsm_encode_modem(dlci);
 			break;
 		}
-		WARN_ON(kfifo_out_locked(dlci->fifo, dp , len, &dlci->lock) != len);
+		WARN_ON(kfifo_out_locked(dlci->fifo, (void *)dp , len, &dlci->lock) != len);
 		__gsm_data_queue(dlci, msg);
 		total_size += size;
 	}
@@ -2975,7 +2975,7 @@ static int gsmtty_write(struct tty_struct *tty, const unsigned char *buf,
 {
 	struct gsm_dlci *dlci = tty->driver_data;
 	/* Stuff the bytes into the fifo queue */
-	int sent = kfifo_in_locked(dlci->fifo, buf, len, &dlci->lock);
+	int sent = kfifo_in_locked(dlci->fifo, (const void *)buf, len, &dlci->lock);
 	/* Need to kick the channel */
 	gsm_dlci_data_kick(dlci);
 	return sent;
diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index b917c94..7a2fb00 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -794,7 +794,7 @@ static int send_data(enum port_type index, struct nozomi *dc)
 	struct tty_struct *tty = tty_port_tty_get(&port->port);
 
 	/* Get data from tty and place in buf for now */
-	size = kfifo_out(&port->fifo_ul, dc->send_buf,
+	size = kfifo_out(&port->fifo_ul, (void *)dc->send_buf,
 			   ul_size < SEND_BUF_MAX ? ul_size : SEND_BUF_MAX);
 
 	if (size == 0) {
@@ -1680,7 +1680,7 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	if (!dc || !port)
 		return -ENODEV;
 
-	rval = kfifo_in(&port->fifo_ul, (unsigned char *)buffer, count);
+	rval = kfifo_in(&port->fifo_ul, (const void *)buffer, count);
 
 	/* notify card */
 	if (unlikely(dc == NULL)) {
diff --git a/drivers/tty/serial/ifx6x60.c b/drivers/tty/serial/ifx6x60.c
index 5b9bc19..0ab66eb 100644
--- a/drivers/tty/serial/ifx6x60.c
+++ b/drivers/tty/serial/ifx6x60.c
@@ -430,7 +430,7 @@ static int ifx_spi_prepare_tx_buffer(struct ifx_spi_device *ifx_dev)
 			/* data to mux -- see if there's room for it */
 			temp_count = min(queue_length, IFX_SPI_PAYLOAD_SIZE);
 			temp_count = kfifo_out_locked(&ifx_dev->tx_fifo,
-					tx_buffer, temp_count,
+					(void *)tx_buffer, temp_count,
 					&ifx_dev->fifo_lock);
 
 			/* update buffer pointer and data count in message */
@@ -469,7 +469,7 @@ static int ifx_spi_write(struct tty_struct *tty, const unsigned char *buf,
 {
 	struct ifx_spi_device *ifx_dev = tty->driver_data;
 	unsigned char *tmp_buf = (unsigned char *)buf;
-	int tx_count = kfifo_in_locked(&ifx_dev->tx_fifo, tmp_buf, count,
+	int tx_count = kfifo_in_locked(&ifx_dev->tx_fifo, (const void *)tmp_buf, count,
 				   &ifx_dev->fifo_lock);
 	mrdy_assert(ifx_dev);
 	return tx_count;
diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index d185247..390b777 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -119,7 +119,7 @@ static void kgdb_tty_recv(int ch)
 	 * possible.
 	 */
 	priv = kgdb_nmi_port_to_priv(kgdb_nmi_port);
-	kfifo_in(&priv->fifo, &c, 1);
+	kfifo_in(&priv->fifo, (const void *)&c, 1);
 	kgdb_tty_poke();
 }
 
@@ -215,7 +215,7 @@ static void kgdb_nmi_tty_receiver(unsigned long data)
 	if (!tty)
 		return;
 
-	while (kfifo_out(&priv->fifo, &ch, 1))
+	while (kfifo_out(&priv->fifo, (void *)&ch, 1))
 		tty_insert_flip_char(priv->port.tty, ch, TTY_NORMAL);
 	tty_flip_buffer_push(priv->port.tty);
 
diff --git a/drivers/usb/host/fhci.h b/drivers/usb/host/fhci.h
index 7cc1c32..dc7ab17 100644
--- a/drivers/usb/host/fhci.h
+++ b/drivers/usb/host/fhci.h
@@ -493,7 +493,7 @@ static inline unsigned int cq_howmany(struct kfifo *kfifo)
 
 static inline int cq_put(struct kfifo *kfifo, void *p)
 {
-	return kfifo_in(kfifo, (void *)&p, sizeof(p));
+	return kfifo_in(kfifo, (const void *)&p, sizeof(p));
 }
 
 static inline void *cq_get(struct kfifo *kfifo)
diff --git a/drivers/usb/serial/aircable.c b/drivers/usb/serial/aircable.c
index 54e1bb6..dbfc1c0 100644
--- a/drivers/usb/serial/aircable.c
+++ b/drivers/usb/serial/aircable.c
@@ -88,7 +88,8 @@ static int aircable_prepare_write_buffer(struct usb_serial_port *port,
 	int count;
 	unsigned char *buf = dest;
 
-	count = kfifo_out_locked(&port->write_fifo, buf + HCI_HEADER_LENGTH,
+	count = kfifo_out_locked(&port->write_fifo, 
+			                (void *)(buf + HCI_HEADER_LENGTH),
 					size - HCI_HEADER_LENGTH, &port->lock);
 	buf[0] = TX_HEADER_0;
 	buf[1] = TX_HEADER_1;
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index f0da127..13ef131 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -678,7 +678,7 @@ static int cypress_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (!count)
 		return count;
 
-	count = kfifo_in_locked(&priv->write_fifo, buf, count, &priv->lock);
+	count = kfifo_in_locked(&priv->write_fifo, (const void *)buf, count, &priv->lock);
 
 finish:
 	cypress_send(port);
@@ -739,7 +739,7 @@ static void cypress_send(struct usb_serial_port *port)
 		spin_unlock_irqrestore(&priv->lock, flags);
 
 	count = kfifo_out_locked(&priv->write_fifo,
-					&port->interrupt_out_buffer[offset],
+					(void *)&port->interrupt_out_buffer[offset],
 					port->interrupt_out_size - offset,
 					&priv->lock);
 	if (count == 0)
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index be84587..daad2cd 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1936,7 +1936,7 @@ static int ftdi_prepare_write_buffer(struct usb_serial_port *port,
 		spin_lock_irqsave(&port->lock, flags);
 		for (i = 0; i < size - 1; i += priv->max_packet_size) {
 			len = min_t(int, size - i, priv->max_packet_size) - 1;
-			c = kfifo_out(&port->write_fifo, &buffer[i + 1], len);
+			c = kfifo_out(&port->write_fifo, (void *)&buffer[i + 1], len);
 			if (!c)
 				break;
 			priv->icount.tx += c;
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 2966121..132c912 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -220,7 +220,7 @@ int usb_serial_generic_write(struct tty_struct *tty,
 	if (!count)
 		return 0;
 
-	count = kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
+	count = kfifo_in_locked(&port->write_fifo, (const void *)buf, count, &port->lock);
 	result = usb_serial_generic_write_start(port);
 	if (result)
 		return result;
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 60023c2..c419950 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2020,7 +2020,7 @@ static int edge_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (edge_port->close_pending == 1)
 		return -ENODEV;
 
-	count = kfifo_in_locked(&edge_port->write_fifo, data, count,
+	count = kfifo_in_locked(&edge_port->write_fifo, (const void *)data, count,
 							&edge_port->ep_lock);
 	edge_send(tty);
 
@@ -2042,7 +2042,7 @@ static void edge_send(struct tty_struct *tty)
 	}
 
 	count = kfifo_out(&edge_port->write_fifo,
-				port->write_urb->transfer_buffer,
+				(void *)port->write_urb->transfer_buffer,
 				port->bulk_out_size);
 
 	if (count == 0) {
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index e24e2d4..c2eb2a6 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -278,7 +278,7 @@ static int ir_prepare_write_buffer(struct usb_serial_port *port,
 	 */
 	*buf = ir_xbof | ir_baud;
 
-	count = kfifo_out_locked(&port->write_fifo, buf + 1, size - 1,
+	count = kfifo_out_locked(&port->write_fifo, (void *)(buf + 1), size - 1,
 								&port->lock);
 	return count + 1;
 }
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 1f45178..4b5d189 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -380,8 +380,8 @@ static int klsi_105_prepare_write_buffer(struct usb_serial_port *port,
 	unsigned char *buf = dest;
 	int count;
 
-	count = kfifo_out_locked(&port->write_fifo, buf + KLSI_HDR_LEN, size,
-								&port->lock);
+	count = kfifo_out_locked(&port->write_fifo, (void *)(buf + KLSI_HDR_LEN),
+			size, &port->lock);
 	put_unaligned_le16(count, buf);
 
 	return count + KLSI_HDR_LEN;
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index cee9a52..30d4bcf 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -318,7 +318,7 @@ static void send_data(struct work_struct *work)
 	}
 
 	count = kfifo_out_locked(&port->write_fifo,
-					port->write_urb->transfer_buffer,
+					(void *)port->write_urb->transfer_buffer,
 					count, &port->lock);
 	port->write_urb->transfer_buffer_length = count;
 	result = usb_submit_urb(port->write_urb, GFP_NOIO);
@@ -366,7 +366,7 @@ static int oti6858_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (!count)
 		return count;
 
-	count = kfifo_in_locked(&port->write_fifo, buf, count, &port->lock);
+	count = kfifo_in_locked(&port->write_fifo, (const void *)buf, count, &port->lock);
 
 	return count;
 }
diff --git a/drivers/usb/serial/safe_serial.c b/drivers/usb/serial/safe_serial.c
index c949ce6..df0b051 100644
--- a/drivers/usb/serial/safe_serial.c
+++ b/drivers/usb/serial/safe_serial.c
@@ -252,8 +252,8 @@ static int safe_prepare_write_buffer(struct usb_serial_port *port,
 
 	trailer_len = safe ? 2 : 0;
 
-	count = kfifo_out_locked(&port->write_fifo, buf, size - trailer_len,
-								&port->lock);
+	count = kfifo_out_locked(&port->write_fifo, (void *)buf, 
+			size - trailer_len, &port->lock);
 	if (!safe)
 		return count;
 
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index f2530d2..8475911 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -656,7 +656,7 @@ static int ti_write(struct tty_struct *tty, struct usb_serial_port *port,
 	if (tport == NULL || !tport->tp_is_open)
 		return -ENODEV;
 
-	count = kfifo_in_locked(&tport->write_fifo, data, count,
+	count = kfifo_in_locked(&tport->write_fifo, (const void *)data, count,
 							&tport->tp_lock);
 	ti_send(tport);
 
@@ -1244,7 +1244,7 @@ static void ti_send(struct ti_port *tport)
 		goto unlock;
 
 	count = kfifo_out(&tport->write_fifo,
-				port->write_urb->transfer_buffer,
+				(void *)port->write_urb->transfer_buffer,
 				port->bulk_out_size);
 
 	if (count == 0)
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 168dd0b..00101e1 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -105,7 +105,7 @@ static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
 	unsigned int ret = 0;
 
 	if (lirc_buffer_len(buf) >= buf->chunk_size)
-		ret = kfifo_out_locked(&buf->fifo, dest, buf->chunk_size,
+		ret = kfifo_out_locked(&buf->fifo, (void *)dest, buf->chunk_size,
 				       &buf->fifo_lock);
 	return ret;
 
@@ -116,7 +116,7 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
 {
 	unsigned int ret;
 
-	ret = kfifo_in_locked(&buf->fifo, orig, buf->chunk_size,
+	ret = kfifo_in_locked(&buf->fifo, (const void *)orig, buf->chunk_size,
 			      &buf->fifo_lock);
 
 	return ret;
diff --git a/net/dccp/probe.c b/net/dccp/probe.c
index 0a8d6eb..76affe7 100644
--- a/net/dccp/probe.c
+++ b/net/dccp/probe.c
@@ -68,7 +68,7 @@ static void printl(const char *fmt, ...)
 	len += vscnprintf(tbuf+len, sizeof(tbuf)-len, fmt, args);
 	va_end(args);
 
-	kfifo_in_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
+	kfifo_in_locked(&dccpw.fifo, (const void *)tbuf, len, &dccpw.lock);
 	wake_up(&dccpw.wait);
 }
 
@@ -136,7 +136,7 @@ static ssize_t dccpprobe_read(struct file *file, char __user *buf,
 	if (error)
 		goto out_free;
 
-	cnt = kfifo_out_locked(&dccpw.fifo, tbuf, len, &dccpw.lock);
+	cnt = kfifo_out_locked(&dccpw.fifo, (void *)tbuf, len, &dccpw.lock);
 	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:
diff --git a/net/sctp/probe.c b/net/sctp/probe.c
index bc6cd75..7a87846 100644
--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -73,7 +73,7 @@ static void printl(const char *fmt, ...)
 	len = vscnprintf(tbuf, sizeof(tbuf), fmt, args);
 	va_end(args);
 
-	kfifo_in_locked(&sctpw.fifo, tbuf, len, &sctpw.lock);
+	kfifo_in_locked(&sctpw.fifo, (const void *)tbuf, len, &sctpw.lock);
 	wake_up(&sctpw.wait);
 }
 
@@ -106,7 +106,7 @@ static ssize_t sctpprobe_read(struct file *file, char __user *buf,
 	if (error)
 		goto out_free;
 
-	cnt = kfifo_out_locked(&sctpw.fifo, tbuf, len, &sctpw.lock);
+	cnt = kfifo_out_locked(&sctpw.fifo, (void *)tbuf, len, &sctpw.lock);
 	error = copy_to_user(buf, tbuf, cnt) ? -EFAULT : 0;
 
 out_free:
diff --git a/samples/kfifo/bytestream-example.c b/samples/kfifo/bytestream-example.c
index cfe40ad..383872c 100644
--- a/samples/kfifo/bytestream-example.c
+++ b/samples/kfifo/bytestream-example.c
@@ -70,14 +70,14 @@ static int __init testfunc(void)
 	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
 
 	/* get max of 5 bytes from the fifo */
-	i = kfifo_out(&test, buf, 5);
+	i = kfifo_out(&test, (void *)buf, 5);
 	printk(KERN_INFO "buf: %.*s\n", i, buf);
 
 	/* get max of 2 elements from the fifo */
-	ret = kfifo_out(&test, buf, 2);
+	ret = kfifo_out(&test, (void *)buf, 2);
 	printk(KERN_INFO "ret: %d\n", ret);
 	/* and put it back to the end of the fifo */
-	ret = kfifo_in(&test, buf, ret);
+	ret = kfifo_in(&test, (const void *)buf, ret);
 	printk(KERN_INFO "ret: %d\n", ret);
 
 	/* skip first element of the fifo */
diff --git a/samples/kfifo/inttype-example.c b/samples/kfifo/inttype-example.c
index 6f8e79e..1517ae5 100644
--- a/samples/kfifo/inttype-example.c
+++ b/samples/kfifo/inttype-example.c
@@ -67,10 +67,10 @@ static int __init testfunc(void)
 	printk(KERN_INFO "fifo len: %u\n", kfifo_len(&test));
 
 	/* get max of 2 elements from the fifo */
-	ret = kfifo_out(&test, buf, 2);
+	ret = kfifo_out(&test, (void *)buf, 2);
 	printk(KERN_INFO "ret: %d\n", ret);
 	/* and put it back to the end of the fifo */
-	ret = kfifo_in(&test, buf, ret);
+	ret = kfifo_in(&test, (const void *)buf, ret);
 	printk(KERN_INFO "ret: %d\n", ret);
 
 	/* skip first element of the fifo */
diff --git a/samples/kfifo/record-example.c b/samples/kfifo/record-example.c
index 2d7529e..34e7718 100644
--- a/samples/kfifo/record-example.c
+++ b/samples/kfifo/record-example.c
@@ -85,7 +85,7 @@ static int __init testfunc(void)
 	/* put in variable length data */
 	for (i = 0; i < 10; i++) {
 		memset(buf, 'a' + i, i + 1);
-		kfifo_in(&test, buf, i + 1);
+		kfifo_in(&test, (const void *)buf, i + 1);
 	}
 
 	/* skip first element of the fifo */
@@ -102,7 +102,7 @@ static int __init testfunc(void)
 	/* check the correctness of all values in the fifo */
 	i = 0;
 	while (!kfifo_is_empty(&test)) {
-		ret = kfifo_out(&test, buf, sizeof(buf));
+		ret = kfifo_out(&test, (void *)buf, sizeof(buf));
 		buf[ret] = '\0';
 		printk(KERN_INFO "item = %.*s\n", ret, buf);
 		if (strcmp(buf, expected_result[i++])) {
-- 
1.7.5.4

