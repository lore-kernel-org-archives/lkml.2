Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab2JOIYu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:24:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:21946 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab2JOIYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:24:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,587,1344236400"; 
   d="scan'208";a="204498700"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/6 V2] mei: kill usless struct mei_io_list
Date: Mon, 15 Oct 2012 10:24:39 +0200
Message-Id: <1350289479-4599-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kill useless mei_io_list list wrapper and use directly
struct mei_cl_cb mei_cb which was its only member for managing io queues

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: drivers/misc/mei/init.c: line 689 was exidently removed

 drivers/misc/mei/init.c      |   31 +++-------
 drivers/misc/mei/interrupt.c |  134 ++++++++++++++++++------------------------
 drivers/misc/mei/iorw.c      |   34 +++++------
 drivers/misc/mei/main.c      |   43 ++++++--------
 drivers/misc/mei/mei_dev.h   |   32 ++++++-----
 5 files changed, 118 insertions(+), 156 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 98f1430..d34a16a 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -48,34 +48,22 @@ const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
 						0x81, 0x4c);
 
 /**
- * mei_io_list_init - Sets up a queue list.
- *
- * @list: An instance io list structure
- * @dev: the device structure
- */
-void mei_io_list_init(struct mei_io_list *list)
-{
-	/* initialize our queue list */
-	INIT_LIST_HEAD(&list->mei_cb.cb_list);
-}
-
-/**
  * mei_io_list_flush - removes list entry belonging to cl.
  *
  * @list:  An instance of our list structure
  * @cl: private data of the file object
  */
-void mei_io_list_flush(struct mei_io_list *list, struct mei_cl *cl)
+void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
 {
 	struct mei_cl_cb *pos;
 	struct mei_cl_cb *next;
 
-	list_for_each_entry_safe(pos, next, &list->mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(pos, next, &list->list, list) {
 		if (pos->file_private) {
 			struct mei_cl *cl_tmp;
 			cl_tmp = (struct mei_cl *)pos->file_private;
 			if (mei_cl_cmp_id(cl, cl_tmp))
-				list_del(&pos->cb_list);
+				list_del(&pos->list);
 		}
 	}
 }
@@ -351,9 +339,8 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		}
 	}
 	/* remove all waiting requests */
-	list_for_each_entry_safe(cb_pos, cb_next,
-			&dev->write_list.mei_cb.cb_list, cb_list) {
-		list_del(&cb_pos->cb_list);
+	list_for_each_entry_safe(cb_pos, cb_next, &dev->write_list.list, list) {
+		list_del(&cb_pos->list);
 		mei_free_cb_private(cb_pos);
 	}
 }
@@ -685,7 +672,7 @@ int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 	if (!cb)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&cb->cb_list);
+	mei_io_list_init(cb);
 	cb->file_private = cl;
 	cb->major_file_operations = MEI_CLOSE;
 	if (dev->mei_host_buffer_is_empty) {
@@ -696,11 +683,11 @@ int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 			goto free;
 		}
 		mdelay(10); /* Wait for hardware disconnection ready */
-		list_add_tail(&cb->cb_list, &dev->ctrl_rd_list.mei_cb.cb_list);
+		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 	} else {
 		dev_dbg(&dev->pdev->dev, "add disconnect cb to control write list\n");
-		list_add_tail(&cb->cb_list,
-				&dev->ctrl_wr_list.mei_cb.cb_list);
+		list_add_tail(&cb->cb_list, &dev->ctrl_wr_list.mei_cb.cb_list);
+
 	}
 	mutex_unlock(&dev->device_lock);
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 320ebd2..54d6f1a 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -87,9 +87,8 @@ static void _mei_cmpl_iamthif(struct mei_device *dev, struct mei_cl_cb *cb_pos)
 		memcpy(cb_pos->response_buffer.data,
 				dev->iamthif_msg_buf,
 				dev->iamthif_msg_buf_index);
-		list_add_tail(&cb_pos->cb_list,
-				&dev->amthi_read_complete_list.mei_cb.cb_list);
-		dev_dbg(&dev->pdev->dev, "amthi read completed.\n");
+		list_add_tail(&cb_pos->list, &dev->amthi_read_complete_list.list);
+		dev_dbg(&dev->pdev->dev, "amthi read completed\n");
 		dev->iamthif_timer = jiffies;
 		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
 				dev->iamthif_timer);
@@ -112,7 +111,7 @@ static void _mei_cmpl_iamthif(struct mei_device *dev, struct mei_cl_cb *cb_pos)
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_read_amthi_message(struct mei_io_list *complete_list,
+static int mei_irq_thread_read_amthi_message(struct mei_cl_cb *complete_list,
 		struct mei_device *dev,
 		struct mei_msg_hdr *mei_hdr)
 {
@@ -155,8 +154,7 @@ static int mei_irq_thread_read_amthi_message(struct mei_io_list *complete_list,
 		/* found the iamthif cb */
 		dev_dbg(&dev->pdev->dev, "complete the amthi read cb.\n ");
 		dev_dbg(&dev->pdev->dev, "add the amthi read cb to complete.\n ");
-		list_add_tail(&cb->cb_list,
-						&complete_list->mei_cb.cb_list);
+		list_add_tail(&cb->list, &complete_list->list);
 	}
 	return 0;
 }
@@ -188,7 +186,7 @@ static int _mei_irq_thread_state_ok(struct mei_cl *cl,
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
+static int mei_irq_thread_read_client_message(struct mei_cl_cb *complete_list,
 		struct mei_device *dev,
 		struct mei_msg_hdr *mei_hdr)
 {
@@ -197,11 +195,10 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 	unsigned char *buffer = NULL;
 
 	dev_dbg(&dev->pdev->dev, "start client msg\n");
-	if (list_empty(&dev->read_list.mei_cb.cb_list))
+	if (list_empty(&dev->read_list.list))
 		goto quit;
 
-	list_for_each_entry_safe(cb_pos, cb_next,
-			&dev->read_list.mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(cb_pos, cb_next, &dev->read_list.list, list) {
 		cl = (struct mei_cl *)cb_pos->file_private;
 		if (cl && _mei_irq_thread_state_ok(cl, mei_hdr)) {
 			cl->reading_state = MEI_READING;
@@ -210,7 +207,7 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 			if (cb_pos->response_buffer.size <
 					mei_hdr->length + cb_pos->buf_idx) {
 				dev_dbg(&dev->pdev->dev, "message overflow.\n");
-				list_del(&cb_pos->cb_list);
+				list_del(&cb_pos->list);
 				return -ENOMEM;
 			}
 			if (buffer)
@@ -219,15 +216,15 @@ static int mei_irq_thread_read_client_message(struct mei_io_list *complete_list,
 			cb_pos->buf_idx += mei_hdr->length;
 			if (mei_hdr->msg_complete) {
 				cl->status = 0;
-				list_del(&cb_pos->cb_list);
+				list_del(&cb_pos->list);
 				dev_dbg(&dev->pdev->dev,
 					"completed read H cl = %d, ME cl = %d, length = %lu\n",
 					cl->host_client_id,
 					cl->me_client_id,
 					cb_pos->buf_idx);
 
-				list_add_tail(&cb_pos->cb_list,
-					&complete_list->mei_cb.cb_list);
+				list_add_tail(&cb_pos->list,
+						&complete_list->list);
 			}
 
 			break;
@@ -291,7 +288,7 @@ static int _mei_irq_thread_iamthif_read(struct mei_device *dev, s32 *slots)
 static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 				struct mei_cl_cb *cb_pos,
 				struct mei_cl *cl,
-				struct mei_io_list *cmpl_list)
+				struct mei_cl_cb *cmpl_list)
 {
 	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_disconnect_request)))
@@ -302,15 +299,13 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 	if (mei_disconnect(dev, cl)) {
 		cl->status = 0;
 		cb_pos->buf_idx = 0;
-		list_move_tail(&cb_pos->cb_list,
-				&cmpl_list->mei_cb.cb_list);
+		list_move_tail(&cb_pos->list, &cmpl_list->list);
 		return -EMSGSIZE;
 	} else {
 		cl->state = MEI_FILE_DISCONNECTING;
 		cl->status = 0;
 		cb_pos->buf_idx = 0;
-		list_move_tail(&cb_pos->cb_list,
-				&dev->ctrl_rd_list.mei_cb.cb_list);
+		list_move_tail(&cb_pos->list, &dev->ctrl_rd_list.list);
 		cl->timer_count = MEI_CONNECT_TIMEOUT;
 	}
 
@@ -357,7 +352,7 @@ static void mei_client_connect_response(struct mei_device *dev,
 {
 
 	struct mei_cl *cl;
-	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
+	struct mei_cl_cb *pos = NULL, *next = NULL;
 
 	dev_dbg(&dev->pdev->dev,
 			"connect_response:\n"
@@ -383,17 +378,16 @@ static void mei_client_connect_response(struct mei_device *dev,
 		dev->iamthif_state = MEI_IAMTHIF_IDLE;
 		return;
 	}
-	list_for_each_entry_safe(cb_pos, cb_next,
-				&dev->ctrl_rd_list.mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
 
-		cl = (struct mei_cl *)cb_pos->file_private;
+		cl = (struct mei_cl *)pos->file_private;
 		if (!cl) {
-			list_del(&cb_pos->cb_list);
+			list_del(&pos->list);
 			return;
 		}
-		if (MEI_IOCTL == cb_pos->major_file_operations) {
+		if (MEI_IOCTL == pos->major_file_operations) {
 			if (is_treat_specially_client(cl, rs)) {
-				list_del(&cb_pos->cb_list);
+				list_del(&pos->list);
 				cl->status = 0;
 				cl->timer_count = 0;
 				break;
@@ -412,7 +406,7 @@ static void mei_client_disconnect_response(struct mei_device *dev,
 					struct hbm_client_connect_response *rs)
 {
 	struct mei_cl *cl;
-	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
+	struct mei_cl_cb *pos = NULL, *next = NULL;
 
 	dev_dbg(&dev->pdev->dev,
 			"disconnect_response:\n"
@@ -423,12 +417,11 @@ static void mei_client_disconnect_response(struct mei_device *dev,
 			rs->host_addr,
 			rs->status);
 
-	list_for_each_entry_safe(cb_pos, cb_next,
-			&dev->ctrl_rd_list.mei_cb.cb_list, cb_list) {
-		cl = (struct mei_cl *)cb_pos->file_private;
+	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
+		cl = (struct mei_cl *)pos->file_private;
 
 		if (!cl) {
-			list_del(&cb_pos->cb_list);
+			list_del(&pos->list);
 			return;
 		}
 
@@ -436,7 +429,7 @@ static void mei_client_disconnect_response(struct mei_device *dev,
 		if (cl->host_client_id == rs->host_addr &&
 		    cl->me_client_id == rs->me_addr) {
 
-			list_del(&cb_pos->cb_list);
+			list_del(&pos->list);
 			if (!rs->status)
 				cl->state = MEI_FILE_DISCONNECTED;
 
@@ -822,12 +815,12 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
-			struct mei_io_list *cmpl_list)
+			struct mei_cl_cb *cmpl_list)
 {
 	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_flow_control))) {
 		/* return the cancel routine */
-		list_del(&cb_pos->cb_list);
+		list_del(&cb_pos->list);
 		return -EBADMSG;
 	}
 
@@ -836,10 +829,10 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 	if (mei_send_flow_control(dev, cl)) {
 		cl->status = -ENODEV;
 		cb_pos->buf_idx = 0;
-		list_move_tail(&cb_pos->cb_list, &cmpl_list->mei_cb.cb_list);
+		list_move_tail(&cb_pos->list, &cmpl_list->list);
 		return -ENODEV;
 	}
-	list_move_tail(&cb_pos->cb_list, &dev->read_list.mei_cb.cb_list);
+	list_move_tail(&cb_pos->list, &dev->read_list.list);
 
 	return 0;
 }
@@ -859,12 +852,12 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
-			struct mei_io_list *cmpl_list)
+			struct mei_cl_cb *cmpl_list)
 {
 	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_connect_request))) {
 		/* return the cancel routine */
-		list_del(&cb_pos->cb_list);
+		list_del(&cb_pos->list);
 		return -EBADMSG;
 	}
 
@@ -873,11 +866,10 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 	if (mei_connect(dev, cl)) {
 		cl->status = -ENODEV;
 		cb_pos->buf_idx = 0;
-		list_del(&cb_pos->cb_list);
+		list_del(&cb_pos->list);
 		return -ENODEV;
 	} else {
-		list_move_tail(&cb_pos->cb_list,
-			&dev->ctrl_rd_list.mei_cb.cb_list);
+		list_move_tail(&cb_pos->list, &dev->ctrl_rd_list.list);
 		cl->timer_count = MEI_CONNECT_TIMEOUT;
 	}
 	return 0;
@@ -897,7 +889,7 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
-			struct mei_io_list *cmpl_list)
+			struct mei_cl_cb *cmpl_list)
 {
 	struct mei_msg_hdr *mei_hdr;
 
@@ -924,16 +916,14 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 				cb_pos->buf_idx),
 				mei_hdr->length)) {
 			cl->status = -ENODEV;
-			list_move_tail(&cb_pos->cb_list,
-				&cmpl_list->mei_cb.cb_list);
+			list_move_tail(&cb_pos->list, &cmpl_list->list);
 			return -ENODEV;
 		} else {
 			if (mei_flow_ctrl_reduce(dev, cl))
 				return -ENODEV;
 			cl->status = 0;
 			cb_pos->buf_idx += mei_hdr->length;
-			list_move_tail(&cb_pos->cb_list,
-				&dev->write_waiting_list.mei_cb.cb_list);
+			list_move_tail(&cb_pos->list, &dev->write_waiting_list.list);
 		}
 	} else if (*slots == dev->hbuf_depth) {
 		/* buffer is still empty */
@@ -951,8 +941,7 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 					cb_pos->buf_idx),
 					mei_hdr->length)) {
 			cl->status = -ENODEV;
-			list_move_tail(&cb_pos->cb_list,
-				&cmpl_list->mei_cb.cb_list);
+			list_move_tail(&cb_pos->list, &cmpl_list->list);
 			return -ENODEV;
 		} else {
 			cb_pos->buf_idx += mei_hdr->length;
@@ -988,7 +977,7 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
-			struct mei_io_list *cmpl_list)
+			struct mei_cl_cb *cmpl_list)
 {
 	struct mei_msg_hdr *mei_hdr;
 
@@ -1011,7 +1000,7 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 					mei_hdr->length)) {
 			dev->iamthif_state = MEI_IAMTHIF_IDLE;
 			cl->status = -ENODEV;
-			list_del(&cb_pos->cb_list);
+			list_del(&cb_pos->list);
 			return -ENODEV;
 		} else {
 			if (mei_flow_ctrl_reduce(dev, cl))
@@ -1023,8 +1012,7 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 			dev->iamthif_flow_control_pending = true;
 			/* save iamthif cb sent to amthi client */
 			dev->iamthif_current_cb = cb_pos;
-			list_move_tail(&cb_pos->cb_list,
-				&dev->write_waiting_list.mei_cb.cb_list);
+			list_move_tail(&cb_pos->list, &dev->write_waiting_list.list);
 
 		}
 	} else if (*slots == dev->hbuf_depth) {
@@ -1044,7 +1032,7 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 					dev->iamthif_msg_buf_index),
 					mei_hdr->length)) {
 			cl->status = -ENODEV;
-			list_del(&cb_pos->cb_list);
+			list_del(&cb_pos->list);
 		} else {
 			dev->iamthif_msg_buf_index += mei_hdr->length;
 		}
@@ -1066,7 +1054,7 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
+static int mei_irq_thread_read_handler(struct mei_cl_cb *cmpl_list,
 		struct mei_device *dev,
 		s32 *slots)
 {
@@ -1169,14 +1157,13 @@ end:
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
-		struct mei_device *dev,
-		s32 *slots)
+static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
+		struct mei_device *dev, s32 *slots)
 {
 
 	struct mei_cl *cl;
 	struct mei_cl_cb *pos = NULL, *next = NULL;
-	struct mei_io_list *list;
+	struct mei_cl_cb *list;
 	int ret;
 
 	if (!mei_hbuf_is_empty(dev)) {
@@ -1191,20 +1178,19 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	dev_dbg(&dev->pdev->dev, "complete all waiting for write cb.\n");
 
 	list = &dev->write_waiting_list;
-	list_for_each_entry_safe(pos, next, &list->mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(pos, next, &list->list, list) {
 		cl = (struct mei_cl *)pos->file_private;
 		if (cl == NULL)
 			continue;
 
 		cl->status = 0;
-		list_del(&pos->cb_list);
+		list_del(&pos->list);
 		if (MEI_WRITING == cl->writing_state &&
 		   (pos->major_file_operations == MEI_WRITE) &&
 		   (cl != &dev->iamthif_cl)) {
 			dev_dbg(&dev->pdev->dev, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
-			list_add_tail(&pos->cb_list,
-				      &cmpl_list->mei_cb.cb_list);
+			list_add_tail(&pos->list, &cmpl_list->list);
 		}
 		if (cl == &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "check iamthif flow control.\n");
@@ -1250,11 +1236,10 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 
 	/* complete control write list CB */
 	dev_dbg(&dev->pdev->dev, "complete control write list cb.\n");
-	list_for_each_entry_safe(pos, next,
-				&dev->ctrl_wr_list.mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(pos, next, &dev->ctrl_wr_list.list, list) {
 		cl = (struct mei_cl *) pos->file_private;
 		if (!cl) {
-			list_del(&pos->cb_list);
+			list_del(&pos->list);
 			return -ENODEV;
 		}
 		switch (pos->major_file_operations) {
@@ -1289,8 +1274,7 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	}
 	/* complete  write list CB */
 	dev_dbg(&dev->pdev->dev, "complete write list cb.\n");
-	list_for_each_entry_safe(pos, next,
-				&dev->write_list.mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(pos, next, &dev->write_list.list, list) {
 		cl = (struct mei_cl *)pos->file_private;
 		if (cl == NULL)
 			continue;
@@ -1410,16 +1394,15 @@ void mei_timer(struct work_struct *work)
 
 			dev_dbg(&dev->pdev->dev, "freeing AMTHI for other requests\n");
 
-			amthi_complete_list = &dev->amthi_read_complete_list.
-					mei_cb.cb_list;
+			amthi_complete_list = &dev->amthi_read_complete_list.list;
 
-			list_for_each_entry_safe(cb_pos, cb_next, amthi_complete_list, cb_list) {
+			list_for_each_entry_safe(cb_pos, cb_next, amthi_complete_list, list) {
 
 				cl_pos = cb_pos->file_object->private_data;
 
 				/* Finding the AMTHI entry. */
 				if (cl_pos == &dev->iamthif_cl)
-					list_del(&cb_pos->cb_list);
+					list_del(&cb_pos->list);
 			}
 			if (dev->iamthif_current_cb)
 				mei_free_cb_private(dev->iamthif_current_cb);
@@ -1450,7 +1433,7 @@ out:
 irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 {
 	struct mei_device *dev = (struct mei_device *) dev_id;
-	struct mei_io_list complete_list;
+	struct mei_cl_cb complete_list;
 	struct mei_cl_cb *cb_pos = NULL, *cb_next = NULL;
 	struct mei_cl *cl;
 	s32 slots;
@@ -1530,14 +1513,13 @@ end:
 		wake_up_interruptible(&dev->wait_recvd_msg);
 		bus_message_received = false;
 	}
-	if (list_empty(&complete_list.mei_cb.cb_list))
+	if (list_empty(&complete_list.list))
 		return IRQ_HANDLED;
 
 
-	list_for_each_entry_safe(cb_pos, cb_next,
-			&complete_list.mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(cb_pos, cb_next, &complete_list.list, list) {
 		cl = (struct mei_cl *)cb_pos->file_private;
-		list_del(&cb_pos->cb_list);
+		list_del(&cb_pos->list);
 		if (cl) {
 			if (cl != &dev->iamthif_cl) {
 				dev_dbg(&dev->pdev->dev, "completing call back.\n");
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index 20652e1..4ff9eaf 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -104,7 +104,7 @@ int mei_ioctl_connect_client(struct file *file,
 		rets = -ENOMEM;
 		goto end;
 	}
-	INIT_LIST_HEAD(&cb->cb_list);
+	mei_io_list_init(cb);
 
 	cb->major_file_operations = MEI_IOCTL;
 
@@ -193,9 +193,7 @@ int mei_ioctl_connect_client(struct file *file,
 			dev_dbg(&dev->pdev->dev, "Sending connect message - succeeded\n");
 			cl->timer_count = MEI_CONNECT_TIMEOUT;
 			cb->file_private = cl;
-			list_add_tail(&cb->cb_list,
-				      &dev->ctrl_rd_list.mei_cb.
-				      cb_list);
+			list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 		}
 
 
@@ -203,8 +201,7 @@ int mei_ioctl_connect_client(struct file *file,
 		dev_dbg(&dev->pdev->dev, "Queuing the connect request due to device busy\n");
 		cb->file_private = cl;
 		dev_dbg(&dev->pdev->dev, "add connect cb to control write list.\n");
-		list_add_tail(&cb->cb_list,
-			      &dev->ctrl_wr_list.mei_cb.cb_list);
+		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 	}
 	mutex_unlock(&dev->device_lock);
 	err = wait_event_timeout(dev->wait_recvd_msg,
@@ -255,7 +252,7 @@ struct mei_cl_cb *find_amthi_read_list_entry(
 	struct mei_cl_cb *next = NULL;
 
 	list_for_each_entry_safe(pos, next,
-	    &dev->amthi_read_complete_list.mei_cb.cb_list, cb_list) {
+	    &dev->amthi_read_complete_list.list, list) {
 		cl_temp = (struct mei_cl *)pos->file_private;
 		if (cl_temp && cl_temp == &dev->iamthif_cl &&
 			pos->file_object == file)
@@ -340,17 +337,17 @@ int amthi_read(struct mei_device *dev, struct file *file,
 		if  (time_after(jiffies, timeout)) {
 			dev_dbg(&dev->pdev->dev, "amthi Time out\n");
 			/* 15 sec for the message has expired */
-			list_del(&cb->cb_list);
+			list_del(&cb->list);
 			rets = -ETIMEDOUT;
 			goto free;
 		}
 	}
 	/* if the whole message will fit remove it from the list */
 	if (cb->buf_idx >= *offset && length >= (cb->buf_idx - *offset))
-		list_del(&cb->cb_list);
+		list_del(&cb->list);
 	else if (cb->buf_idx > 0 && cb->buf_idx <= *offset) {
 		/* end of the message has been reached */
-		list_del(&cb->cb_list);
+		list_del(&cb->list);
 		rets = 0;
 		goto free;
 	}
@@ -441,9 +438,9 @@ int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
 			rets = -ENODEV;
 			goto unlock;
 		}
-		list_add_tail(&cb->cb_list, &dev->read_list.mei_cb.cb_list);
+		list_add_tail(&cb->list, &dev->read_list.list);
 	} else {
-		list_add_tail(&cb->cb_list, &dev->ctrl_wr_list.mei_cb.cb_list);
+		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 	}
 	return rets;
 unlock:
@@ -510,13 +507,11 @@ int amthi_write(struct mei_device *dev, struct mei_cl_cb *cb)
 			dev_dbg(&dev->pdev->dev, "add amthi cb to write waiting list\n");
 			dev->iamthif_current_cb = cb;
 			dev->iamthif_file_object = cb->file_object;
-			list_add_tail(&cb->cb_list,
-				      &dev->write_waiting_list.mei_cb.cb_list);
+			list_add_tail(&cb->list, &dev->write_waiting_list.list);
 		} else {
 			dev_dbg(&dev->pdev->dev, "message does not complete, "
 					"so add amthi cb to write list.\n");
-			list_add_tail(&cb->cb_list,
-				      &dev->write_list.mei_cb.cb_list);
+			list_add_tail(&cb->list, &dev->write_list.list);
 		}
 	} else {
 		if (!(dev->mei_host_buffer_is_empty))
@@ -524,7 +519,7 @@ int amthi_write(struct mei_device *dev, struct mei_cl_cb *cb)
 
 		dev_dbg(&dev->pdev->dev, "No flow control credentials, "
 				"so add iamthif cb to write list.\n");
-		list_add_tail(&cb->cb_list, &dev->write_list.mei_cb.cb_list);
+		list_add_tail(&cb->list, &dev->write_list.list);
 	}
 	return 0;
 }
@@ -556,9 +551,8 @@ void mei_run_next_iamthif_cmd(struct mei_device *dev)
 
 	dev_dbg(&dev->pdev->dev, "complete amthi cmd_list cb.\n");
 
-	list_for_each_entry_safe(pos, next,
-			&dev->amthi_cmd_list.mei_cb.cb_list, cb_list) {
-		list_del(&pos->cb_list);
+	list_for_each_entry_safe(pos, next, &dev->amthi_cmd_list.list, list) {
+		list_del(&pos->list);
 		cl_tmp = (struct mei_cl *)pos->file_private;
 
 		if (cl_tmp && cl_tmp == &dev->iamthif_cl) {
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 8dcf59d..2e46291 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -111,12 +111,12 @@ static bool mei_clear_list(struct mei_device *dev,
 	bool removed = false;
 
 	/* list all list member */
-	list_for_each_entry_safe(cb_pos, cb_next, mei_cb_list, cb_list) {
+	list_for_each_entry_safe(cb_pos, cb_next, mei_cb_list, list) {
 		file_temp = (struct file *)cb_pos->file_object;
 		/* check if list member associated with a file */
 		if (file_temp == file) {
 			/* remove member from the list */
-			list_del(&cb_pos->cb_list);
+			list_del(&cb_pos->list);
 			/* check if cb equal to current iamthif cb */
 			if (dev->iamthif_current_cb == cb_pos) {
 				dev->iamthif_current_cb = NULL;
@@ -148,20 +148,20 @@ static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 	bool removed = false;
 
 	/* remove callbacks associated with a file */
-	mei_clear_list(dev, file, &dev->amthi_cmd_list.mei_cb.cb_list);
+	mei_clear_list(dev, file, &dev->amthi_cmd_list.list);
 	if (mei_clear_list(dev, file,
-			    &dev->amthi_read_complete_list.mei_cb.cb_list))
+			    &dev->amthi_read_complete_list.list))
 		removed = true;
 
-	mei_clear_list(dev, file, &dev->ctrl_rd_list.mei_cb.cb_list);
+	mei_clear_list(dev, file, &dev->ctrl_rd_list.list);
 
-	if (mei_clear_list(dev, file, &dev->ctrl_wr_list.mei_cb.cb_list))
+	if (mei_clear_list(dev, file, &dev->ctrl_wr_list.list))
 		removed = true;
 
-	if (mei_clear_list(dev, file, &dev->write_waiting_list.mei_cb.cb_list))
+	if (mei_clear_list(dev, file, &dev->write_waiting_list.list))
 		removed = true;
 
-	if (mei_clear_list(dev, file, &dev->write_list.mei_cb.cb_list))
+	if (mei_clear_list(dev, file, &dev->write_list.list))
 		removed = true;
 
 	/* check if iamthif_current_cb not NULL */
@@ -192,8 +192,7 @@ static struct mei_cl_cb *find_read_list_entry(
 	struct mei_cl_cb *next = NULL;
 
 	dev_dbg(&dev->pdev->dev, "remove read_list CB\n");
-	list_for_each_entry_safe(pos, next,
-			&dev->read_list.mei_cb.cb_list, cb_list) {
+	list_for_each_entry_safe(pos, next, &dev->read_list.list, list) {
 		struct mei_cl *cl_temp;
 		cl_temp = (struct mei_cl *)pos->file_private;
 
@@ -324,7 +323,7 @@ static int mei_release(struct inode *inode, struct file *file)
 			cb = find_read_list_entry(dev, cl);
 			/* Remove entry from read list */
 			if (cb)
-				list_del(&cb->cb_list);
+				list_del(&cb->list);
 
 			cb = cl->read_cb;
 			cl->read_cb = NULL;
@@ -504,7 +503,7 @@ free:
 	cb_pos = find_read_list_entry(dev, cl);
 	/* Remove entry from read list */
 	if (cb_pos)
-		list_del(&cb_pos->cb_list);
+		list_del(&cb_pos->list);
 	mei_free_cb_private(cb);
 	cl->reading_state = MEI_IDLE;
 	cl->read_cb = NULL;
@@ -534,7 +533,7 @@ static struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
 	if (!cb)
 		return NULL;
 
-	INIT_LIST_HEAD(&cb->cb_list);
+	mei_io_list_init(cb);
 
 	cb->file_object = fp;
 	cb->file_private = cl;
@@ -651,7 +650,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			if (time_after(jiffies, timeout) ||
 			    cl->reading_state == MEI_READ_COMPLETE) {
 				*offset = 0;
-				list_del(&write_cb->cb_list);
+				list_del(&write_cb->list);
 				mei_free_cb_private(write_cb);
 				write_cb = NULL;
 			}
@@ -663,7 +662,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		*offset = 0;
 		write_cb = find_read_list_entry(dev, cl);
 		if (write_cb) {
-			list_del(&write_cb->cb_list);
+			list_del(&write_cb->list);
 			mei_free_cb_private(write_cb);
 			write_cb = NULL;
 			cl->reading_state = MEI_IDLE;
@@ -707,13 +706,12 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 		write_cb->major_file_operations = MEI_IOCTL;
 
-		if (!list_empty(&dev->amthi_cmd_list.mei_cb.cb_list) ||
+		if (!list_empty(&dev->amthi_cmd_list.list) ||
 				dev->iamthif_state != MEI_IAMTHIF_IDLE) {
 			dev_dbg(&dev->pdev->dev, "amthi_state = %d\n",
 					(int) dev->iamthif_state);
 			dev_dbg(&dev->pdev->dev, "add amthi cb to amthi cmd waiting list\n");
-			list_add_tail(&write_cb->cb_list,
-					&dev->amthi_cmd_list.mei_cb.cb_list);
+			list_add_tail(&write_cb->list, &dev->amthi_cmd_list.list);
 		} else {
 			dev_dbg(&dev->pdev->dev, "call amthi write\n");
 			rets = amthi_write(dev, write_cb);
@@ -764,19 +762,16 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 				rets = -ENODEV;
 				goto unlock_dev;
 			}
-			list_add_tail(&write_cb->cb_list,
-				      &dev->write_waiting_list.mei_cb.cb_list);
+			list_add_tail(&write_cb->list, &dev->write_waiting_list.list);
 		} else {
-			list_add_tail(&write_cb->cb_list,
-				      &dev->write_list.mei_cb.cb_list);
+			list_add_tail(&write_cb->list, &dev->write_list.list);
 		}
 
 	} else {
 
 		write_cb->buf_idx = 0;
 		cl->writing_state = MEI_WRITING;
-		list_add_tail(&write_cb->cb_list,
-			      &dev->write_list.mei_cb.cb_list);
+		list_add_tail(&write_cb->list, &dev->write_list.list);
 	}
 	mutex_unlock(&dev->device_lock);
 	return length;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index c58b6fa..de5babc 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -144,7 +144,7 @@ struct mei_message_data {
 
 
 struct mei_cl_cb {
-	struct list_head cb_list;
+	struct list_head list;
 	enum mei_cb_major_types major_file_operations;
 	void *file_private;
 	struct mei_message_data request_buffer;
@@ -175,10 +175,6 @@ struct mei_cl {
 	struct mei_cl_cb *read_cb;
 };
 
-struct mei_io_list {
-	struct mei_cl_cb mei_cb;
-};
-
 /**
  * struct mei_deive -  MEI private device struct
  * @hbuf_depth - depth of host(write) buffer
@@ -189,15 +185,15 @@ struct mei_device {
 	 * lists of queues
 	 */
 	 /* array of pointers to aio lists */
-	struct mei_io_list read_list;		/* driver read queue */
-	struct mei_io_list write_list;		/* driver write queue */
-	struct mei_io_list write_waiting_list;	/* write waiting queue */
-	struct mei_io_list ctrl_wr_list;	/* managed write IOCTL list */
-	struct mei_io_list ctrl_rd_list;	/* managed read IOCTL list */
-	struct mei_io_list amthi_cmd_list;	/* amthi list for cmd waiting */
+	struct mei_cl_cb read_list;		/* driver read queue */
+	struct mei_cl_cb write_list;		/* driver write queue */
+	struct mei_cl_cb write_waiting_list;	/* write waiting queue */
+	struct mei_cl_cb ctrl_wr_list;		/* managed write IOCTL list */
+	struct mei_cl_cb ctrl_rd_list;		/* managed read IOCTL list */
+	struct mei_cl_cb amthi_cmd_list;	/* amthi list for cmd waiting */
 
 	/* driver managed amthi list for reading completed amthi cmd data */
-	struct mei_io_list amthi_read_complete_list;
+	struct mei_cl_cb amthi_read_complete_list;
 	/*
 	 * list of files
 	 */
@@ -297,8 +293,16 @@ int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
 /*
  * MEI IO List Functions
  */
-void mei_io_list_init(struct mei_io_list *list);
-void mei_io_list_flush(struct mei_io_list *list, struct mei_cl *cl);
+/**
+ * mei_io_list_init - Sets up a queue list.
+ *
+ * @list: An instance cl callback structure
+ */
+static inline void mei_io_list_init(struct mei_cl_cb *list)
+{
+	INIT_LIST_HEAD(&list->list);
+}
+void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl);
 
 /*
  * MEI ME Client Functions
-- 
1.7.4.4

