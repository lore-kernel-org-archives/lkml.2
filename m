Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab2JIOvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:51:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:42957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2JIOuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:50:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="154176529"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/6] mei: rename mei_free_cb_private to mei_io_cb_free
Date: Tue,  9 Oct 2012 16:50:20 +0200
Message-Id: <1349794221-8667-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
References: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. cb_private was an old name that we depriacated in earlier
cleanups

2. we also group the funcion declaration with other _io_
functions

3. Don't check cb for NULL as mei_io_cb_free is NULL safe

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c      |    4 ++--
 drivers/misc/mei/interrupt.c |   12 +++++-------
 drivers/misc/mei/iorw.c      |   35 ++++++++++++++++++-----------------
 drivers/misc/mei/main.c      |   14 +++++++-------
 drivers/misc/mei/mei_dev.h   |    5 +++--
 5 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index dd02e87..2dcdedf 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -341,7 +341,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 	/* remove all waiting requests */
 	list_for_each_entry_safe(cb_pos, cb_next, &dev->write_list.list, list) {
 		list_del(&cb_pos->list);
-		mei_free_cb_private(cb_pos);
+		mei_io_cb_free(cb_pos);
 	}
 }
 
@@ -713,7 +713,7 @@ int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 	mei_io_list_flush(&dev->ctrl_rd_list, cl);
 	mei_io_list_flush(&dev->ctrl_wr_list, cl);
 free:
-	mei_free_cb_private(cb);
+	mei_io_cb_free(cb);
 	return rets;
 }
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 54d6f1a..5c65bac 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -58,7 +58,7 @@ irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
 static void _mei_cmpl(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
 {
 	if (cb_pos->major_file_operations == MEI_WRITE) {
-		mei_free_cb_private(cb_pos);
+		mei_io_cb_free(cb_pos);
 		cb_pos = NULL;
 		cl->writing_state = MEI_WRITE_COMPLETE;
 		if (waitqueue_active(&cl->tx_wait))
@@ -1368,11 +1368,10 @@ void mei_timer(struct work_struct *work)
 			dev->iamthif_state = MEI_IAMTHIF_IDLE;
 			dev->iamthif_timer = 0;
 
-			if (dev->iamthif_current_cb)
-				mei_free_cb_private(dev->iamthif_current_cb);
+			mei_io_cb_free(dev->iamthif_current_cb);
+			dev->iamthif_current_cb = NULL;
 
 			dev->iamthif_file_object = NULL;
-			dev->iamthif_current_cb = NULL;
 			mei_run_next_iamthif_cmd(dev);
 		}
 	}
@@ -1404,12 +1403,11 @@ void mei_timer(struct work_struct *work)
 				if (cl_pos == &dev->iamthif_cl)
 					list_del(&cb_pos->list);
 			}
-			if (dev->iamthif_current_cb)
-				mei_free_cb_private(dev->iamthif_current_cb);
+			mei_io_cb_free(dev->iamthif_current_cb);
+			dev->iamthif_current_cb = NULL;
 
 			dev->iamthif_file_object->private_data = NULL;
 			dev->iamthif_file_object = NULL;
-			dev->iamthif_current_cb = NULL;
 			dev->iamthif_timer = 0;
 			mei_run_next_iamthif_cmd(dev);
 
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index 4ff9eaf..2891bc4 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -39,6 +39,21 @@
 #include "interface.h"
 
 /**
+ * mei_io_cb_free - free mei_cb_private related memory
+ *
+ * @cb: mei callback struct
+ */
+void mei_io_cb_free(struct mei_cl_cb *cb)
+{
+	if (cb == NULL)
+		return;
+
+	kfree(cb->request_buffer.data);
+	kfree(cb->response_buffer.data);
+	kfree(cb);
+}
+
+/**
  * mei_me_cl_by_id return index to me_clients for client_id
  *
  * @dev: the device structure
@@ -231,7 +246,7 @@ int mei_ioctl_connect_client(struct file *file,
 	rets = 0;
 end:
 	dev_dbg(&dev->pdev->dev, "free connect cb memory.");
-	kfree(cb);
+	mei_io_cb_free(cb);
 	return rets;
 }
 
@@ -375,7 +390,7 @@ int amthi_read(struct mei_device *dev, struct file *file,
 free:
 	dev_dbg(&dev->pdev->dev, "free amthi cb memory.\n");
 	*offset = 0;
-	mei_free_cb_private(cb);
+	mei_io_cb_free(cb);
 out:
 	return rets;
 }
@@ -444,7 +459,7 @@ int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
 	}
 	return rets;
 unlock:
-	mei_free_cb_private(cb);
+	mei_io_cb_free(cb);
 	return rets;
 }
 
@@ -568,17 +583,3 @@ void mei_run_next_iamthif_cmd(struct mei_device *dev)
 	}
 }
 
-/**
- * mei_free_cb_private - free mei_cb_private related memory
- *
- * @cb: mei callback struct
- */
-void mei_free_cb_private(struct mei_cl_cb *cb)
-{
-	if (cb == NULL)
-		return;
-
-	kfree(cb->request_buffer.data);
-	kfree(cb->response_buffer.data);
-	kfree(cb);
-}
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 2e46291..518e07e 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -124,7 +124,7 @@ static bool mei_clear_list(struct mei_device *dev,
 				mei_send_flow_control(dev, &dev->iamthif_cl);
 			}
 			/* free all allocated buffers */
-			mei_free_cb_private(cb_pos);
+			mei_io_cb_free(cb_pos);
 			cb_pos = NULL;
 			removed = true;
 		}
@@ -169,7 +169,7 @@ static bool mei_clear_lists(struct mei_device *dev, struct file *file)
 		/* check file and iamthif current cb association */
 		if (dev->iamthif_current_cb->file_object == file) {
 			/* remove cb */
-			mei_free_cb_private(dev->iamthif_current_cb);
+			mei_io_cb_free(dev->iamthif_current_cb);
 			dev->iamthif_current_cb = NULL;
 			removed = true;
 		}
@@ -332,7 +332,7 @@ static int mei_release(struct inode *inode, struct file *file)
 		file->private_data = NULL;
 
 		if (cb) {
-			mei_free_cb_private(cb);
+			mei_io_cb_free(cb);
 			cb = NULL;
 		}
 
@@ -504,7 +504,7 @@ free:
 	/* Remove entry from read list */
 	if (cb_pos)
 		list_del(&cb_pos->list);
-	mei_free_cb_private(cb);
+	mei_io_cb_free(cb);
 	cl->reading_state = MEI_IDLE;
 	cl->read_cb = NULL;
 	cl->read_pending = 0;
@@ -651,7 +651,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			    cl->reading_state == MEI_READ_COMPLETE) {
 				*offset = 0;
 				list_del(&write_cb->list);
-				mei_free_cb_private(write_cb);
+				mei_io_cb_free(write_cb);
 				write_cb = NULL;
 			}
 		}
@@ -663,7 +663,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		write_cb = find_read_list_entry(dev, cl);
 		if (write_cb) {
 			list_del(&write_cb->list);
-			mei_free_cb_private(write_cb);
+			mei_io_cb_free(write_cb);
 			write_cb = NULL;
 			cl->reading_state = MEI_IDLE;
 			cl->read_cb = NULL;
@@ -778,7 +778,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 unlock_dev:
 	mutex_unlock(&dev->device_lock);
-	mei_free_cb_private(write_cb);
+	mei_io_cb_free(write_cb);
 	return rets;
 }
 
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index de5babc..4545a9e 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -291,8 +291,10 @@ int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid);
 int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
 
 /*
- * MEI IO List Functions
+ * MEI IO Functions
  */
+void mei_io_cb_free(struct mei_cl_cb *priv_cb);
+
 /**
  * mei_io_list_init - Sets up a queue list.
  *
@@ -361,7 +363,6 @@ struct mei_cl_cb *find_amthi_read_list_entry(struct mei_device *dev,
 
 void mei_run_next_iamthif_cmd(struct mei_device *dev);
 
-void mei_free_cb_private(struct mei_cl_cb *priv_cb);
 
 
 /*
-- 
1.7.4.4

