Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2JIOud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:50:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:42957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2JIOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:50:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="154176494"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/6] mei: rename mei_cl_cb.information to mei_cl_cb.buf_idx
Date: Tue,  9 Oct 2012 16:50:16 +0200
Message-Id: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rename 'information' member of the struct mei_cl_cb to
more self-descriptive 'buf_idx'

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/interrupt.c |   43 ++++++++++++++++++++---------------------
 drivers/misc/mei/iorw.c      |   17 +++++++--------
 drivers/misc/mei/main.c      |   33 ++++++++++++++-----------------
 drivers/misc/mei/mei_dev.h   |    2 +-
 4 files changed, 45 insertions(+), 50 deletions(-)

diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 3533edd..320ebd2 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -149,7 +149,7 @@ static int mei_irq_thread_read_amthi_message(struct mei_io_list *complete_list,
 		return -ENODEV;
 
 	dev->iamthif_stall_timer = 0;
-	cb->information =	dev->iamthif_msg_buf_index;
+	cb->buf_idx = dev->iamthif_msg_buf_index;
 	cb->read_time = jiffies;
 	if (dev->iamthif_ioctl && cl == &dev->iamthif_cl) {
 		/* found the iamthif cb */
@@ -205,10 +205,10 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 		cl = (struct mei_cl *)cb_pos->file_private;
 		if (cl && _mei_irq_thread_state_ok(cl, mei_hdr)) {
 			cl->reading_state = MEI_READING;
-			buffer = cb_pos->response_buffer.data + cb_pos->information;
+			buffer = cb_pos->response_buffer.data + cb_pos->buf_idx;
 
 			if (cb_pos->response_buffer.size <
-					mei_hdr->length + cb_pos->information) {
+					mei_hdr->length + cb_pos->buf_idx) {
 				dev_dbg(&dev->pdev->dev, "message overflow.\n");
 				list_del(&cb_pos->cb_list);
 				return -ENOMEM;
@@ -216,7 +216,7 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 			if (buffer)
 				mei_read_slots(dev, buffer, mei_hdr->length);
 
-			cb_pos->information += mei_hdr->length;
+			cb_pos->buf_idx += mei_hdr->length;
 			if (mei_hdr->msg_complete) {
 				cl->status = 0;
 				list_del(&cb_pos->cb_list);
@@ -224,7 +224,8 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 					"completed read H cl = %d, ME cl = %d, length = %lu\n",
 					cl->host_client_id,
 					cl->me_client_id,
-					cb_pos->information);
+					cb_pos->buf_idx);
+
 				list_add_tail(&cb_pos->cb_list,
 					&complete_list->mei_cb.cb_list);
 			}
@@ -300,14 +301,14 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 
 	if (mei_disconnect(dev, cl)) {
 		cl->status = 0;
-		cb_pos->information = 0;
+		cb_pos->buf_idx = 0;
 		list_move_tail(&cb_pos->cb_list,
 				&cmpl_list->mei_cb.cb_list);
 		return -EMSGSIZE;
 	} else {
 		cl->state = MEI_FILE_DISCONNECTING;
 		cl->status = 0;
-		cb_pos->information = 0;
+		cb_pos->buf_idx = 0;
 		list_move_tail(&cb_pos->cb_list,
 				&dev->ctrl_rd_list.mei_cb.cb_list);
 		cl->timer_count = MEI_CONNECT_TIMEOUT;
@@ -834,7 +835,7 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 
 	if (mei_send_flow_control(dev, cl)) {
 		cl->status = -ENODEV;
-		cb_pos->information = 0;
+		cb_pos->buf_idx = 0;
 		list_move_tail(&cb_pos->cb_list, &cmpl_list->mei_cb.cb_list);
 		return -ENODEV;
 	}
@@ -871,7 +872,7 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 	 *slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
 	if (mei_connect(dev, cl)) {
 		cl->status = -ENODEV;
-		cb_pos->information = 0;
+		cb_pos->buf_idx = 0;
 		list_del(&cb_pos->cb_list);
 		return -ENODEV;
 	} else {
@@ -901,28 +902,26 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 	struct mei_msg_hdr *mei_hdr;
 
 	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
-			(cb_pos->request_buffer.size -
-			cb_pos->information))) {
+			(cb_pos->request_buffer.size - cb_pos->buf_idx))) {
 		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
 		mei_hdr->host_addr = cl->host_client_id;
 		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length = cb_pos->request_buffer.size -
-					cb_pos->information;
+		mei_hdr->length = cb_pos->request_buffer.size - cb_pos->buf_idx;
 		mei_hdr->msg_complete = 1;
 		mei_hdr->reserved = 0;
 		dev_dbg(&dev->pdev->dev, "cb_pos->request_buffer.size =%d"
 			"mei_hdr->msg_complete = %d\n",
 				cb_pos->request_buffer.size,
 				mei_hdr->msg_complete);
-		dev_dbg(&dev->pdev->dev, "cb_pos->information  =%lu\n",
-				cb_pos->information);
+		dev_dbg(&dev->pdev->dev, "cb_pos->buf_idx  =%lu\n",
+				cb_pos->buf_idx);
 		dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
 				mei_hdr->length);
 		*slots -= mei_data2slots(mei_hdr->length);
 		if (mei_write_message(dev, mei_hdr,
 				(unsigned char *)
 				(cb_pos->request_buffer.data +
-				cb_pos->information),
+				cb_pos->buf_idx),
 				mei_hdr->length)) {
 			cl->status = -ENODEV;
 			list_move_tail(&cb_pos->cb_list,
@@ -932,7 +931,7 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 			if (mei_flow_ctrl_reduce(dev, cl))
 				return -ENODEV;
 			cl->status = 0;
-			cb_pos->information += mei_hdr->length;
+			cb_pos->buf_idx += mei_hdr->length;
 			list_move_tail(&cb_pos->cb_list,
 				&dev->write_waiting_list.mei_cb.cb_list);
 		}
@@ -949,21 +948,21 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 		if (mei_write_message(dev, mei_hdr,
 					(unsigned char *)
 					(cb_pos->request_buffer.data +
-					cb_pos->information),
+					cb_pos->buf_idx),
 					mei_hdr->length)) {
 			cl->status = -ENODEV;
 			list_move_tail(&cb_pos->cb_list,
 				&cmpl_list->mei_cb.cb_list);
 			return -ENODEV;
 		} else {
-			cb_pos->information += mei_hdr->length;
+			cb_pos->buf_idx += mei_hdr->length;
 			dev_dbg(&dev->pdev->dev,
 					"cb_pos->request_buffer.size =%d"
 					" mei_hdr->msg_complete = %d\n",
 					cb_pos->request_buffer.size,
 					mei_hdr->msg_complete);
-			dev_dbg(&dev->pdev->dev, "cb_pos->information  =%lu\n",
-					cb_pos->information);
+			dev_dbg(&dev->pdev->dev, "cb_pos->buf_idx  =%lu\n",
+					cb_pos->buf_idx);
 			dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
 					mei_hdr->length);
 		}
@@ -1018,7 +1017,7 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 			if (mei_flow_ctrl_reduce(dev, cl))
 				return -ENODEV;
 			dev->iamthif_msg_buf_index += mei_hdr->length;
-			cb_pos->information = dev->iamthif_msg_buf_index;
+			cb_pos->buf_idx = dev->iamthif_msg_buf_index;
 			cl->status = 0;
 			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
 			dev->iamthif_flow_control_pending = true;
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index fcba98e..20652e1 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -346,9 +346,9 @@ int amthi_read(struct mei_device *dev, struct file *file,
 		}
 	}
 	/* if the whole message will fit remove it from the list */
-	if (cb->information >= *offset && length >= (cb->information - *offset))
+	if (cb->buf_idx >= *offset && length >= (cb->buf_idx - *offset))
 		list_del(&cb->cb_list);
-	else if (cb->information > 0 && cb->information <= *offset) {
+	else if (cb->buf_idx > 0 && cb->buf_idx <= *offset) {
 		/* end of the message has been reached */
 		list_del(&cb->cb_list);
 		rets = 0;
@@ -360,18 +360,17 @@ int amthi_read(struct mei_device *dev, struct file *file,
 
 	dev_dbg(&dev->pdev->dev, "amthi cb->response_buffer size - %d\n",
 	    cb->response_buffer.size);
-	dev_dbg(&dev->pdev->dev, "amthi cb->information - %lu\n",
-	    cb->information);
+	dev_dbg(&dev->pdev->dev, "amthi cb->buf_idx - %lu\n", cb->buf_idx);
 
 	/* length is being turncated to PAGE_SIZE, however,
-	 * the information may be longer */
-	length = min_t(size_t, length, (cb->information - *offset));
+	 * the buf_idx may point beyond */
+	length = min_t(size_t, length, (cb->buf_idx - *offset));
 
 	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length))
 		rets = -EFAULT;
 	else {
 		rets = length;
-		if ((*offset + length) < cb->information) {
+		if ((*offset + length) < cb->buf_idx) {
 			*offset += length;
 			goto out;
 		}
@@ -432,8 +431,8 @@ int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
 	}
 	dev_dbg(&dev->pdev->dev, "allocation call back data success.\n");
 	cb->major_file_operations = MEI_READ;
-	/* make sure information is zero before we start */
-	cb->information = 0;
+	/* make sure buffer index is zero before we start */
+	cb->buf_idx = 0;
 	cb->file_private = (void *) cl;
 	cl->read_cb = cb;
 	if (dev->mei_host_buffer_is_empty) {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index e8b0858..3d4f6d1 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -415,16 +415,15 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 		goto out;
 	}
 
-	if (cl->read_cb && cl->read_cb->information > *offset) {
+	if (cl->read_cb && cl->read_cb->buf_idx > *offset) {
 		cb = cl->read_cb;
 		goto copy_buffer;
-	} else if (cl->read_cb && cl->read_cb->information > 0 &&
-		   cl->read_cb->information <= *offset) {
+	} else if (cl->read_cb && cl->read_cb->buf_idx > 0 &&
+		   cl->read_cb->buf_idx <= *offset) {
 		cb = cl->read_cb;
 		rets = 0;
 		goto free;
-	} else if ((!cl->read_cb || !cl->read_cb->information) &&
-		    *offset > 0) {
+	} else if ((!cl->read_cb || !cl->read_cb->buf_idx) && *offset > 0) {
 		/*Offset needs to be cleaned for contiguous reads*/
 		*offset = 0;
 		rets = 0;
@@ -481,16 +480,15 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 copy_buffer:
 	dev_dbg(&dev->pdev->dev, "cb->response_buffer size - %d\n",
 	    cb->response_buffer.size);
-	dev_dbg(&dev->pdev->dev, "cb->information - %lu\n",
-	    cb->information);
-	if (length == 0 || ubuf == NULL || *offset > cb->information) {
+	dev_dbg(&dev->pdev->dev, "cb->buf_idx - %lu\n", cb->buf_idx);
+	if (length == 0 || ubuf == NULL || *offset > cb->buf_idx) {
 		rets = -EMSGSIZE;
 		goto free;
 	}
 
-	/* length is being truncated to PAGE_SIZE, however, */
-	/* information size may be longer */
-	length = min_t(size_t, length, (cb->information - *offset));
+	/* length is being truncated to PAGE_SIZE,
+	 * however buf_idx may point beyond that */
+	length = min_t(size_t, length, cb->buf_idx - *offset);
 
 	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length)) {
 		rets = -EFAULT;
@@ -499,7 +497,7 @@ copy_buffer:
 
 	rets = length;
 	*offset += length;
-	if ((unsigned long)*offset < cb->information)
+	if ((unsigned long)*offset < cb->buf_idx)
 		goto out;
 
 free:
@@ -637,7 +635,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 		write_cb->response_buffer.size = dev->iamthif_mtu;
 		write_cb->major_file_operations = MEI_IOCTL;
-		write_cb->information = 0;
+		write_cb->buf_idx = 0;
 		write_cb->request_buffer.size = length;
 		if (dev->iamthif_cl.state != MEI_FILE_CONNECTED) {
 			rets = -ENODEV;
@@ -668,9 +666,8 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	write_cb->major_file_operations = MEI_WRITE;
-	/* make sure information is zero before we start */
-
-	write_cb->information = 0;
+	/* make sure buffer index is zero before we start */
+	write_cb->buf_idx = 0;
 	write_cb->request_buffer.size = length;
 
 	dev_dbg(&dev->pdev->dev, "host client = %d, ME client = %d\n",
@@ -719,7 +716,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			goto unlock_dev;
 		}
 		cl->writing_state = MEI_WRITING;
-		write_cb->information = mei_hdr.length;
+		write_cb->buf_idx = mei_hdr.length;
 		if (mei_hdr.msg_complete) {
 			if (mei_flow_ctrl_reduce(dev, cl)) {
 				rets = -ENODEV;
@@ -734,7 +731,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	} else {
 
-		write_cb->information = 0;
+		write_cb->buf_idx = 0;
 		cl->writing_state = MEI_WRITING;
 		list_add_tail(&write_cb->cb_list,
 			      &dev->write_list.mei_cb.cb_list);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index adb35fb..c58b6fa 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -149,7 +149,7 @@ struct mei_cl_cb {
 	void *file_private;
 	struct mei_message_data request_buffer;
 	struct mei_message_data response_buffer;
-	unsigned long information;
+	unsigned long buf_idx;
 	unsigned long read_time;
 	struct file *file_object;
 };
-- 
1.7.4.4

