Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2KKPiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:38:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:12053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2KKPiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:38:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,757,1344236400"; 
   d="scan'208";a="217934036"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/7] mei: rename enum mei_cb_major_types to enum mei_cb_file_ops
Date: Sun, 11 Nov 2012 17:38:00 +0200
Message-Id: <1352648284-8838-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
References: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Rename mei_cb_major_types to more understandable mei_cb_file_ops
2. Rename member struct mei_cl_cb of this type to simple 'fop_type'
3. Add kernel doc for the type

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |    2 +-
 drivers/misc/mei/init.c      |    2 +-
 drivers/misc/mei/interrupt.c |   18 +++++++++---------
 drivers/misc/mei/iorw.c      |    4 ++--
 drivers/misc/mei/main.c      |    2 +-
 drivers/misc/mei/mei_dev.h   |   26 +++++++++++++++++---------
 6 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 74d593f..34d37a9 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -347,7 +347,7 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
 	if (ret)
 		return ret;
 
-	cb->major_file_operations = MEI_IOCTL;
+	cb->fop_type = MEI_FOP_IOCTL;
 
 	if (!list_empty(&dev->amthif_cmd_list.list) ||
 	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 0046ca5..85b6520 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -597,7 +597,7 @@ int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 	if (!cb)
 		return -ENOMEM;
 
-	cb->major_file_operations = MEI_CLOSE;
+	cb->fop_type = MEI_FOP_CLOSE;
 	if (dev->mei_host_buffer_is_empty) {
 		dev->mei_host_buffer_is_empty = false;
 		if (mei_disconnect(dev, cl)) {
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index acc994e..34e20cc 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -57,14 +57,14 @@ irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
  */
 static void _mei_cmpl(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
 {
-	if (cb_pos->major_file_operations == MEI_WRITE) {
+	if (cb_pos->fop_type == MEI_FOP_WRITE) {
 		mei_io_cb_free(cb_pos);
 		cb_pos = NULL;
 		cl->writing_state = MEI_WRITE_COMPLETE;
 		if (waitqueue_active(&cl->tx_wait))
 			wake_up_interruptible(&cl->tx_wait);
 
-	} else if (cb_pos->major_file_operations == MEI_READ &&
+	} else if (cb_pos->fop_type == MEI_FOP_READ &&
 			MEI_READING == cl->reading_state) {
 		cl->reading_state = MEI_READ_COMPLETE;
 		if (waitqueue_active(&cl->rx_wait))
@@ -268,7 +268,7 @@ static void mei_client_connect_response(struct mei_device *dev,
 			list_del(&pos->list);
 			return;
 		}
-		if (MEI_IOCTL == pos->major_file_operations) {
+		if (pos->fop_type == MEI_FOP_IOCTL) {
 			if (is_treat_specially_client(cl, rs)) {
 				list_del(&pos->list);
 				cl->status = 0;
@@ -988,8 +988,8 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 		cl->status = 0;
 		list_del(&pos->list);
 		if (MEI_WRITING == cl->writing_state &&
-		   (pos->major_file_operations == MEI_WRITE) &&
-		   (cl != &dev->iamthif_cl)) {
+		    pos->fop_type == MEI_FOP_WRITE &&
+		    cl != &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
 			list_add_tail(&pos->list, &cmpl_list->list);
@@ -1044,22 +1044,22 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 			list_del(&pos->list);
 			return -ENODEV;
 		}
-		switch (pos->major_file_operations) {
-		case MEI_CLOSE:
+		switch (pos->fop_type) {
+		case MEI_FOP_CLOSE:
 			/* send disconnect message */
 			ret = _mei_irq_thread_close(dev, slots, pos, cl, cmpl_list);
 			if (ret)
 				return ret;
 
 			break;
-		case MEI_READ:
+		case MEI_FOP_READ:
 			/* send flow control message */
 			ret = _mei_irq_thread_read(dev, slots, pos, cl, cmpl_list);
 			if (ret)
 				return ret;
 
 			break;
-		case MEI_IOCTL:
+		case MEI_FOP_IOCTL:
 			/* connect message */
 			if (mei_other_client_is_connecting(dev, cl))
 				continue;
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index cc53ce7..cf11076 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -193,7 +193,7 @@ int mei_ioctl_connect_client(struct file *file,
 		goto end;
 	}
 
-	cb->major_file_operations = MEI_IOCTL;
+	cb->fop_type = MEI_FOP_IOCTL;
 
 	if (dev->dev_state != MEI_DEV_ENABLED) {
 		rets = -ENODEV;
@@ -360,7 +360,7 @@ int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
 	if (rets)
 		goto err;
 
-	cb->major_file_operations = MEI_READ;
+	cb->fop_type = MEI_FOP_READ;
 	cl->read_cb = cb;
 	if (dev->mei_host_buffer_is_empty) {
 		dev->mei_host_buffer_is_empty = false;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index e0e39c4..57bf96c 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -626,7 +626,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		return length;
 	}
 
-	write_cb->major_file_operations = MEI_WRITE;
+	write_cb->fop_type = MEI_FOP_WRITE;
 
 	dev_dbg(&dev->pdev->dev, "host client = %d, ME client = %d\n",
 	    cl->host_client_id, cl->me_client_id);
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index da0c1f5..59e94c2 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -125,13 +125,20 @@ enum mei_wd_states {
 	MEI_WD_STOPPING,
 };
 
-/* MEI CB */
-enum mei_cb_major_types {
-	MEI_READ = 0,
-	MEI_WRITE,
-	MEI_IOCTL,
-	MEI_OPEN,
-	MEI_CLOSE
+/**
+ * enum mei_cb_file_ops  - file operation associated with the callback
+ * @MEI_FOP_READ   - read
+ * @MEI_FOP_WRITE  - write
+ * @MEI_FOP_IOCTL  - ioctl
+ * @MEI_FOP_OPEN   - open
+ * @MEI_FOP_CLOSE  - close
+ */
+enum mei_cb_file_ops {
+	MEI_FOP_READ = 0,
+	MEI_FOP_WRITE,
+	MEI_FOP_IOCTL,
+	MEI_FOP_OPEN,
+	MEI_FOP_CLOSE
 };
 
 /*
@@ -145,15 +152,16 @@ struct mei_message_data {
 
 struct mei_cl;
 
-/*
+/**
  * struct mei_cl_cb - file operation callback structure
  *
  * @cl - file client who is running this operation
+ * @fop_type - file operation type
  */
 struct mei_cl_cb {
 	struct list_head list;
 	struct mei_cl *cl;
-	enum mei_cb_major_types major_file_operations;
+	enum mei_cb_file_ops fop_type;
 	struct mei_message_data request_buffer;
 	struct mei_message_data response_buffer;
 	unsigned long buf_idx;
-- 
1.7.4.4

