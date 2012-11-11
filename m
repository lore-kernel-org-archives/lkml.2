Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2KKPiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:38:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:12053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252Ab2KKPiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:38:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,757,1344236400"; 
   d="scan'208";a="217934023"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/7] mei: amthif: prefix cb list with amthif
Date: Sun, 11 Nov 2012 17:37:58 +0200
Message-Id: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amthif cb list were prefixed with amthi_ instead
if amthif.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |   10 +++++-----
 drivers/misc/mei/init.c      |    8 ++++----
 drivers/misc/mei/interrupt.c |    6 ++----
 drivers/misc/mei/main.c      |    5 ++---
 drivers/misc/mei/mei_dev.h   |    9 +++++----
 5 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 96db3ad..1de28df 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -124,7 +124,7 @@ struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 	struct mei_cl_cb *next = NULL;
 
 	list_for_each_entry_safe(pos, next,
-	    &dev->amthi_read_complete_list.list, list) {
+				&dev->amthif_rd_complete_list.list, list) {
 		cl_temp = (struct mei_cl *)pos->file_private;
 		if (cl_temp && cl_temp == &dev->iamthif_cl &&
 			pos->file_object == file)
@@ -351,12 +351,12 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
 
 	cb->major_file_operations = MEI_IOCTL;
 
-	if (!list_empty(&dev->amthi_cmd_list.list) ||
+	if (!list_empty(&dev->amthif_cmd_list.list) ||
 	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
 		dev_dbg(&dev->pdev->dev,
 			"amthif state = %d\n", dev->iamthif_state);
 		dev_dbg(&dev->pdev->dev, "AMTHIF: add cb to the wait list\n");
-		list_add_tail(&cb->list, &dev->amthi_cmd_list.list);
+		list_add_tail(&cb->list, &dev->amthif_cmd_list.list);
 		return 0;
 	}
 	return mei_amthif_send_cmd(dev, cb);
@@ -388,7 +388,7 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 
 	dev_dbg(&dev->pdev->dev, "complete amthi cmd_list cb.\n");
 
-	list_for_each_entry_safe(pos, next, &dev->amthi_cmd_list.list, list) {
+	list_for_each_entry_safe(pos, next, &dev->amthif_cmd_list.list, list) {
 		list_del(&pos->list);
 		cl_tmp = (struct mei_cl *)pos->file_private;
 
@@ -589,7 +589,7 @@ void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
 		memcpy(cb->response_buffer.data,
 				dev->iamthif_msg_buf,
 				dev->iamthif_msg_buf_index);
-		list_add_tail(&cb->list, &dev->amthi_read_complete_list.list);
+		list_add_tail(&cb->list, &dev->amthif_rd_complete_list.list);
 		dev_dbg(&dev->pdev->dev, "amthi read completed\n");
 		dev->iamthif_timer = jiffies;
 		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 8c3c268..7e6d591 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -80,8 +80,8 @@ int mei_cl_flush_queues(struct mei_cl *cl)
 	mei_io_list_flush(&cl->dev->write_waiting_list, cl);
 	mei_io_list_flush(&cl->dev->ctrl_wr_list, cl);
 	mei_io_list_flush(&cl->dev->ctrl_rd_list, cl);
-	mei_io_list_flush(&cl->dev->amthi_cmd_list, cl);
-	mei_io_list_flush(&cl->dev->amthi_read_complete_list, cl);
+	mei_io_list_flush(&cl->dev->amthif_cmd_list, cl);
+	mei_io_list_flush(&cl->dev->amthif_rd_complete_list, cl);
 	return 0;
 }
 
@@ -117,8 +117,8 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
 	mei_io_list_init(&dev->write_waiting_list);
 	mei_io_list_init(&dev->ctrl_wr_list);
 	mei_io_list_init(&dev->ctrl_rd_list);
-	mei_io_list_init(&dev->amthi_cmd_list);
-	mei_io_list_init(&dev->amthi_read_complete_list);
+	mei_io_list_init(&dev->amthif_cmd_list);
+	mei_io_list_init(&dev->amthif_rd_complete_list);
 	dev->pdev = pdev;
 	return dev;
 }
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 62f8b65..7193149 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -1127,7 +1127,6 @@ void mei_timer(struct work_struct *work)
 	unsigned long timeout;
 	struct mei_cl *cl_pos = NULL;
 	struct mei_cl *cl_next = NULL;
-	struct list_head *amthi_complete_list = NULL;
 	struct mei_cl_cb  *cb_pos = NULL;
 	struct mei_cl_cb  *cb_next = NULL;
 
@@ -1195,9 +1194,8 @@ void mei_timer(struct work_struct *work)
 
 			dev_dbg(&dev->pdev->dev, "freeing AMTHI for other requests\n");
 
-			amthi_complete_list = &dev->amthi_read_complete_list.list;
-
-			list_for_each_entry_safe(cb_pos, cb_next, amthi_complete_list, list) {
+			list_for_each_entry_safe(cb_pos, cb_next,
+				&dev->amthif_rd_complete_list.list, list) {
 
 				cl_pos = cb_pos->file_object->private_data;
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index ff50cc1..bea545a 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -146,9 +146,8 @@ static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 	bool removed = false;
 
 	/* remove callbacks associated with a file */
-	mei_clear_list(dev, file, &dev->amthi_cmd_list.list);
-	if (mei_clear_list(dev, file,
-			    &dev->amthi_read_complete_list.list))
+	mei_clear_list(dev, file, &dev->amthif_cmd_list.list);
+	if (mei_clear_list(dev, file, &dev->amthif_rd_complete_list.list))
 		removed = true;
 
 	mei_clear_list(dev, file, &dev->ctrl_rd_list.list);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 8b96d99..ce246b0 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -184,16 +184,13 @@ struct mei_device {
 	/*
 	 * lists of queues
 	 */
-	 /* array of pointers to aio lists */
+	/* array of pointers to aio lists */
 	struct mei_cl_cb read_list;		/* driver read queue */
 	struct mei_cl_cb write_list;		/* driver write queue */
 	struct mei_cl_cb write_waiting_list;	/* write waiting queue */
 	struct mei_cl_cb ctrl_wr_list;		/* managed write IOCTL list */
 	struct mei_cl_cb ctrl_rd_list;		/* managed read IOCTL list */
-	struct mei_cl_cb amthi_cmd_list;	/* amthi list for cmd waiting */
 
-	/* driver managed amthi list for reading completed amthi cmd data */
-	struct mei_cl_cb amthi_read_complete_list;
 	/*
 	 * list of files
 	 */
@@ -254,6 +251,10 @@ struct mei_device {
 	unsigned char wd_data[MEI_WD_START_MSG_SIZE];
 
 
+	/* amthif list for cmd waiting */
+	struct mei_cl_cb amthif_cmd_list;
+	/* driver managed amthif list for reading completed amthif cmd data */
+	struct mei_cl_cb amthif_rd_complete_list;
 	struct file *iamthif_file_object;
 	struct mei_cl iamthif_cl;
 	struct mei_cl_cb *iamthif_current_cb;
-- 
1.7.4.4

