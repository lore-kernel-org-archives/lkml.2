Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab2KKPiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:38:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:12053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab2KKPiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:38:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,757,1344236400"; 
   d="scan'208";a="217934028"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/7] mei: use type struct mei_cl *cl instead of void in struct mei_cb
Date: Sun, 11 Nov 2012 17:37:59 +0200
Message-Id: <1352648284-8838-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
References: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use correct type 'struct mei_cl' instead of
'void *' for file_private in the struct mei_cb
as there is no other type assigned to this member of the structure

We rename the member from file_private to cl

Remove about 10 lines of declarations of temporary variables
used for type casting

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |   14 ++++----------
 drivers/misc/mei/init.c      |    6 ++----
 drivers/misc/mei/interrupt.c |   14 +++++++-------
 drivers/misc/mei/iorw.c      |    2 +-
 drivers/misc/mei/main.c      |    8 ++------
 drivers/misc/mei/mei_dev.h   |    9 ++++++++-
 6 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 1de28df..74d593f 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -119,14 +119,12 @@ void mei_amthif_host_init(struct mei_device *dev)
 struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 						struct file *file)
 {
-	struct mei_cl *cl_temp;
 	struct mei_cl_cb *pos = NULL;
 	struct mei_cl_cb *next = NULL;
 
 	list_for_each_entry_safe(pos, next,
 				&dev->amthif_rd_complete_list.list, list) {
-		cl_temp = (struct mei_cl *)pos->file_private;
-		if (cl_temp && cl_temp == &dev->iamthif_cl &&
+		if (pos->cl && pos->cl == &dev->iamthif_cl &&
 			pos->file_object == file)
 			return pos;
 	}
@@ -370,7 +368,6 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
  */
 void mei_amthif_run_next_cmd(struct mei_device *dev)
 {
-	struct mei_cl *cl_tmp;
 	struct mei_cl_cb *pos = NULL;
 	struct mei_cl_cb *next = NULL;
 	int status;
@@ -390,9 +387,8 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 
 	list_for_each_entry_safe(pos, next, &dev->amthif_cmd_list.list, list) {
 		list_del(&pos->list);
-		cl_tmp = (struct mei_cl *)pos->file_private;
 
-		if (cl_tmp && cl_tmp == &dev->iamthif_cl) {
+		if (pos->cl && pos->cl == &dev->iamthif_cl) {
 			status = mei_amthif_send_cmd(dev, pos);
 			if (status) {
 				dev_dbg(&dev->pdev->dev,
@@ -500,7 +496,6 @@ int mei_amthif_irq_process_completed(struct mei_device *dev, s32 *slots,
 int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
 		struct mei_device *dev, struct mei_msg_hdr *mei_hdr)
 {
-	struct mei_cl *cl;
 	struct mei_cl_cb *cb;
 	unsigned char *buffer;
 
@@ -528,14 +523,13 @@ int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
 	cb = dev->iamthif_current_cb;
 	dev->iamthif_current_cb = NULL;
 
-	cl = (struct mei_cl *)cb->file_private;
-	if (!cl)
+	if (!cb->cl)
 		return -ENODEV;
 
 	dev->iamthif_stall_timer = 0;
 	cb->buf_idx = dev->iamthif_msg_buf_index;
 	cb->read_time = jiffies;
-	if (dev->iamthif_ioctl && cl == &dev->iamthif_cl) {
+	if (dev->iamthif_ioctl && cb->cl == &dev->iamthif_cl) {
 		/* found the iamthif cb */
 		dev_dbg(&dev->pdev->dev, "complete the amthi read cb.\n ");
 		dev_dbg(&dev->pdev->dev, "add the amthi read cb to complete.\n ");
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 7e6d591..0046ca5 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -55,10 +55,8 @@ void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
 	struct mei_cl_cb *next;
 
 	list_for_each_entry_safe(pos, next, &list->list, list) {
-		if (pos->file_private) {
-			struct mei_cl *cl_tmp;
-			cl_tmp = (struct mei_cl *)pos->file_private;
-			if (mei_cl_cmp_id(cl, cl_tmp))
+		if (pos->cl) {
+			if (mei_cl_cmp_id(cl, pos->cl))
 				list_del(&pos->list);
 		}
 	}
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 7193149..acc994e 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -113,7 +113,7 @@ static int mei_irq_thread_read_client_message(struct mei_cl_cb *complete_list,
 		goto quit;
 
 	list_for_each_entry_safe(cb_pos, cb_next, &dev->read_list.list, list) {
-		cl = (struct mei_cl *)cb_pos->file_private;
+		cl = cb_pos->cl;
 		if (cl && _mei_irq_thread_state_ok(cl, mei_hdr)) {
 			cl->reading_state = MEI_READING;
 			buffer = cb_pos->response_buffer.data + cb_pos->buf_idx;
@@ -263,7 +263,7 @@ static void mei_client_connect_response(struct mei_device *dev,
 	}
 	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
 
-		cl = (struct mei_cl *)pos->file_private;
+		cl = pos->cl;
 		if (!cl) {
 			list_del(&pos->list);
 			return;
@@ -301,7 +301,7 @@ static void mei_client_disconnect_response(struct mei_device *dev,
 			rs->status);
 
 	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
-		cl = (struct mei_cl *)pos->file_private;
+		cl = pos->cl;
 
 		if (!cl) {
 			list_del(&pos->list);
@@ -981,7 +981,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 
 	list = &dev->write_waiting_list;
 	list_for_each_entry_safe(pos, next, &list->list, list) {
-		cl = (struct mei_cl *)pos->file_private;
+		cl = pos->cl;
 		if (cl == NULL)
 			continue;
 
@@ -1039,7 +1039,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 	/* complete control write list CB */
 	dev_dbg(&dev->pdev->dev, "complete control write list cb.\n");
 	list_for_each_entry_safe(pos, next, &dev->ctrl_wr_list.list, list) {
-		cl = (struct mei_cl *) pos->file_private;
+		cl = pos->cl;
 		if (!cl) {
 			list_del(&pos->list);
 			return -ENODEV;
@@ -1077,7 +1077,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 	/* complete  write list CB */
 	dev_dbg(&dev->pdev->dev, "complete write list cb.\n");
 	list_for_each_entry_safe(pos, next, &dev->write_list.list, list) {
-		cl = (struct mei_cl *)pos->file_private;
+		cl = pos->cl;
 		if (cl == NULL)
 			continue;
 
@@ -1316,7 +1316,7 @@ end:
 
 
 	list_for_each_entry_safe(cb_pos, cb_next, &complete_list.list, list) {
-		cl = (struct mei_cl *)cb_pos->file_private;
+		cl = cb_pos->cl;
 		list_del(&cb_pos->list);
 		if (cl) {
 			if (cl != &dev->iamthif_cl) {
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index a1d9ba1..cc53ce7 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -71,7 +71,7 @@ struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
 	mei_io_list_init(cb);
 
 	cb->file_object = fp;
-	cb->file_private = cl;
+	cb->cl = cl;
 	cb->buf_idx = 0;
 	return cb;
 }
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index bea545a..e0e39c4 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -189,13 +189,9 @@ static struct mei_cl_cb *find_read_list_entry(
 	struct mei_cl_cb *next = NULL;
 
 	dev_dbg(&dev->pdev->dev, "remove read_list CB\n");
-	list_for_each_entry_safe(pos, next, &dev->read_list.list, list) {
-		struct mei_cl *cl_temp;
-		cl_temp = (struct mei_cl *)pos->file_private;
-
-		if (mei_cl_cmp_id(cl, cl_temp))
+	list_for_each_entry_safe(pos, next, &dev->read_list.list, list)
+		if (mei_cl_cmp_id(cl, pos->cl))
 			return pos;
-	}
 	return NULL;
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index ce246b0..da0c1f5 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -143,10 +143,17 @@ struct mei_message_data {
 };
 
 
+struct mei_cl;
+
+/*
+ * struct mei_cl_cb - file operation callback structure
+ *
+ * @cl - file client who is running this operation
+ */
 struct mei_cl_cb {
 	struct list_head list;
+	struct mei_cl *cl;
 	enum mei_cb_major_types major_file_operations;
-	void *file_private;
 	struct mei_message_data request_buffer;
 	struct mei_message_data response_buffer;
 	unsigned long buf_idx;
-- 
1.7.4.4

