Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2KKPiV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:38:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:12053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab2KKPiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:38:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,757,1344236400"; 
   d="scan'208";a="217934043"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/7] mei: move amthif specific release code to amithif
Date: Sun, 11 Nov 2012 17:38:01 +0200
Message-Id: <1352648284-8838-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
References: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move amthif code part into separate function
mei_amthif_release.
Also helper functions mei_clear_list and mei_clear_lists
are moved along

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |  114 ++++++++++++++++++++++++++++
 drivers/misc/mei/main.c    |  178 ++++++++++----------------------------------
 drivers/misc/mei/mei_dev.h |    2 +
 3 files changed, 155 insertions(+), 139 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 34d37a9..8f4373a 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -596,4 +596,118 @@ void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
 	wake_up_interruptible(&dev->iamthif_cl.wait);
 }
 
+/**
+ * mei_clear_list - removes all callbacks associated with file
+ *		from mei_cb_list
+ *
+ * @dev: device structure.
+ * @file: file structure
+ * @mei_cb_list: callbacks list
+ *
+ * mei_clear_list is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * returns true if callback removed from the list, false otherwise
+ */
+static bool mei_clear_list(struct mei_device *dev,
+		const struct file *file, struct list_head *mei_cb_list)
+{
+	struct mei_cl_cb *cb_pos = NULL;
+	struct mei_cl_cb *cb_next = NULL;
+	bool removed = false;
+
+	/* list all list member */
+	list_for_each_entry_safe(cb_pos, cb_next, mei_cb_list, list) {
+		/* check if list member associated with a file */
+		if (file == cb_pos->file_object) {
+			/* remove member from the list */
+			list_del(&cb_pos->list);
+			/* check if cb equal to current iamthif cb */
+			if (dev->iamthif_current_cb == cb_pos) {
+				dev->iamthif_current_cb = NULL;
+				/* send flow control to iamthif client */
+				mei_send_flow_control(dev, &dev->iamthif_cl);
+			}
+			/* free all allocated buffers */
+			mei_io_cb_free(cb_pos);
+			cb_pos = NULL;
+			removed = true;
+		}
+	}
+	return removed;
+}
+
+/**
+ * mei_clear_lists - removes all callbacks associated with file
+ *
+ * @dev: device structure
+ * @file: file structure
+ *
+ * mei_clear_lists is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * returns true if callback removed from the list, false otherwise
+ */
+static bool mei_clear_lists(struct mei_device *dev, struct file *file)
+{
+	bool removed = false;
+
+	/* remove callbacks associated with a file */
+	mei_clear_list(dev, file, &dev->amthif_cmd_list.list);
+	if (mei_clear_list(dev, file, &dev->amthif_rd_complete_list.list))
+		removed = true;
 
+	mei_clear_list(dev, file, &dev->ctrl_rd_list.list);
+
+	if (mei_clear_list(dev, file, &dev->ctrl_wr_list.list))
+		removed = true;
+
+	if (mei_clear_list(dev, file, &dev->write_waiting_list.list))
+		removed = true;
+
+	if (mei_clear_list(dev, file, &dev->write_list.list))
+		removed = true;
+
+	/* check if iamthif_current_cb not NULL */
+	if (dev->iamthif_current_cb && !removed) {
+		/* check file and iamthif current cb association */
+		if (dev->iamthif_current_cb->file_object == file) {
+			/* remove cb */
+			mei_io_cb_free(dev->iamthif_current_cb);
+			dev->iamthif_current_cb = NULL;
+			removed = true;
+		}
+	}
+	return removed;
+}
+
+/**
+* mei_amthif_release - the release function
+*
+*  @inode: pointer to inode structure
+*  @file: pointer to file structure
+*
+*  returns 0 on success, <0 on error
+*/
+int mei_amthif_release(struct mei_device *dev, struct file *file)
+{
+	if (dev->open_handle_count > 0)
+		dev->open_handle_count--;
+
+	if (dev->iamthif_file_object == file &&
+	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
+
+		dev_dbg(&dev->pdev->dev, "amthi canceled iamthif state %d\n",
+		    dev->iamthif_state);
+		dev->iamthif_canceled = true;
+		if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE) {
+			dev_dbg(&dev->pdev->dev, "run next amthi iamthif cb\n");
+			mei_amthif_run_next_cmd(dev);
+		}
+	}
+
+	if (mei_clear_lists(dev, file))
+		dev->iamthif_state = MEI_IAMTHIF_IDLE;
+
+	return 0;
+}
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 57bf96c..43512e5 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -90,90 +90,6 @@ static DEFINE_MUTEX(mei_mutex);
 
 
 /**
- * mei_clear_list - removes all callbacks associated with file
- *		from mei_cb_list
- *
- * @dev: device structure.
- * @file: file structure
- * @mei_cb_list: callbacks list
- *
- * mei_clear_list is called to clear resources associated with file
- * when application calls close function or Ctrl-C was pressed
- *
- * returns true if callback removed from the list, false otherwise
- */
-static bool mei_clear_list(struct mei_device *dev,
-		const struct file *file, struct list_head *mei_cb_list)
-{
-	struct mei_cl_cb *cb_pos = NULL;
-	struct mei_cl_cb *cb_next = NULL;
-	bool removed = false;
-
-	/* list all list member */
-	list_for_each_entry_safe(cb_pos, cb_next, mei_cb_list, list) {
-		/* check if list member associated with a file */
-		if (file == cb_pos->file_object) {
-			/* remove member from the list */
-			list_del(&cb_pos->list);
-			/* check if cb equal to current iamthif cb */
-			if (dev->iamthif_current_cb == cb_pos) {
-				dev->iamthif_current_cb = NULL;
-				/* send flow control to iamthif client */
-				mei_send_flow_control(dev, &dev->iamthif_cl);
-			}
-			/* free all allocated buffers */
-			mei_io_cb_free(cb_pos);
-			cb_pos = NULL;
-			removed = true;
-		}
-	}
-	return removed;
-}
-
-/**
- * mei_clear_lists - removes all callbacks associated with file
- *
- * @dev: device structure
- * @file: file structure
- *
- * mei_clear_lists is called to clear resources associated with file
- * when application calls close function or Ctrl-C was pressed
- *
- * returns true if callback removed from the list, false otherwise
- */
-static bool mei_clear_lists(struct mei_device *dev, struct file *file)
-{
-	bool removed = false;
-
-	/* remove callbacks associated with a file */
-	mei_clear_list(dev, file, &dev->amthif_cmd_list.list);
-	if (mei_clear_list(dev, file, &dev->amthif_rd_complete_list.list))
-		removed = true;
-
-	mei_clear_list(dev, file, &dev->ctrl_rd_list.list);
-
-	if (mei_clear_list(dev, file, &dev->ctrl_wr_list.list))
-		removed = true;
-
-	if (mei_clear_list(dev, file, &dev->write_waiting_list.list))
-		removed = true;
-
-	if (mei_clear_list(dev, file, &dev->write_list.list))
-		removed = true;
-
-	/* check if iamthif_current_cb not NULL */
-	if (dev->iamthif_current_cb && !removed) {
-		/* check file and iamthif current cb association */
-		if (dev->iamthif_current_cb->file_object == file) {
-			/* remove cb */
-			mei_io_cb_free(dev->iamthif_current_cb);
-			dev->iamthif_current_cb = NULL;
-			removed = true;
-		}
-	}
-	return removed;
-}
-/**
  * find_read_list_entry - find read list entry
  *
  * @dev: device structure
@@ -289,67 +205,51 @@ static int mei_release(struct inode *inode, struct file *file)
 	dev = cl->dev;
 
 	mutex_lock(&dev->device_lock);
-	if (cl != &dev->iamthif_cl) {
-		if (cl->state == MEI_FILE_CONNECTED) {
-			cl->state = MEI_FILE_DISCONNECTING;
-			dev_dbg(&dev->pdev->dev,
-				"disconnecting client host client = %d, "
-			    "ME client = %d\n",
-			    cl->host_client_id,
-			    cl->me_client_id);
-			rets = mei_disconnect_host_client(dev, cl);
-		}
-		mei_cl_flush_queues(cl);
-		dev_dbg(&dev->pdev->dev, "remove client host client = %d, ME client = %d\n",
+	if (cl == &dev->iamthif_cl) {
+		rets = mei_amthif_release(dev, file);
+		goto out;
+	}
+	if (cl->state == MEI_FILE_CONNECTED) {
+		cl->state = MEI_FILE_DISCONNECTING;
+		dev_dbg(&dev->pdev->dev,
+			"disconnecting client host client = %d, "
+		    "ME client = %d\n",
 		    cl->host_client_id,
 		    cl->me_client_id);
+		rets = mei_disconnect_host_client(dev, cl);
+	}
+	mei_cl_flush_queues(cl);
+	dev_dbg(&dev->pdev->dev, "remove client host client = %d, ME client = %d\n",
+	    cl->host_client_id,
+	    cl->me_client_id);
+
+	if (dev->open_handle_count > 0) {
+		clear_bit(cl->host_client_id, dev->host_clients_map);
+		dev->open_handle_count--;
+	}
+	mei_remove_client_from_file_list(dev, cl->host_client_id);
 
-		if (dev->open_handle_count > 0) {
-			clear_bit(cl->host_client_id, dev->host_clients_map);
-			dev->open_handle_count--;
-		}
-		mei_remove_client_from_file_list(dev, cl->host_client_id);
-
-		/* free read cb */
-		cb = NULL;
-		if (cl->read_cb) {
-			cb = find_read_list_entry(dev, cl);
-			/* Remove entry from read list */
-			if (cb)
-				list_del(&cb->list);
-
-			cb = cl->read_cb;
-			cl->read_cb = NULL;
-		}
-
-		file->private_data = NULL;
-
-		if (cb) {
-			mei_io_cb_free(cb);
-			cb = NULL;
-		}
+	/* free read cb */
+	cb = NULL;
+	if (cl->read_cb) {
+		cb = find_read_list_entry(dev, cl);
+		/* Remove entry from read list */
+		if (cb)
+			list_del(&cb->list);
 
-		kfree(cl);
-	} else {
-		if (dev->open_handle_count > 0)
-			dev->open_handle_count--;
-
-		if (dev->iamthif_file_object == file &&
-		    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
-
-			dev_dbg(&dev->pdev->dev, "amthi canceled iamthif state %d\n",
-			    dev->iamthif_state);
-			dev->iamthif_canceled = true;
-			if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE) {
-				dev_dbg(&dev->pdev->dev, "run next amthi iamthif cb\n");
-				mei_amthif_run_next_cmd(dev);
-			}
-		}
+		cb = cl->read_cb;
+		cl->read_cb = NULL;
+	}
 
-		if (mei_clear_lists(dev, file))
-			dev->iamthif_state = MEI_IAMTHIF_IDLE;
+	file->private_data = NULL;
 
+	if (cb) {
+		mei_io_cb_free(cb);
+		cb = NULL;
 	}
+
+	kfree(cl);
+out:
 	mutex_unlock(&dev->device_lock);
 	return rets;
 }
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 59e94c2..bdad35e 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -389,6 +389,8 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *priv_cb);
 int mei_amthif_read(struct mei_device *dev, struct file *file,
 	      char __user *ubuf, size_t length, loff_t *offset);
 
+int mei_amthif_release(struct mei_device *dev, struct file *file);
+
 struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 						struct file *file);
 
-- 
1.7.4.4

