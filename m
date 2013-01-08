Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3AHVIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:29241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741Ab3AHVIC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604877"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 04/21] mei: implement mei_cl_connect function
Date: Tue,  8 Jan 2013 23:07:15 +0200
Message-Id: <1357679252-12958-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement mei_cl_connect that warps host client
parts of the connection and leave the ioctl specifics
in the mei_ioctl_connect_client function.
Move mei_ioctl_connect_client to main.c where it
belongs

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c  |  219 +++++++++++++-------------------------------
 drivers/misc/mei/main.c    |   98 ++++++++++++++++++++
 drivers/misc/mei/mei_dev.h |    5 -
 3 files changed, 163 insertions(+), 159 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index e300637..cc3e76c 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -461,6 +461,71 @@ bool mei_cl_is_other_connecting(struct mei_cl *cl)
 }
 
 /**
+ * mei_cl_connect - connect host clinet to the me one
+ *
+ * @cl: host client
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_cl_connect(struct mei_cl *cl, struct file *file)
+{
+	struct mei_device *dev;
+	struct mei_cl_cb *cb;
+	long timeout = mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT);
+	int rets;
+
+	if (WARN_ON(!cl || !cl->dev))
+		return -ENODEV;
+
+	dev = cl->dev;
+
+	cb = mei_io_cb_init(cl, file);
+	if (!cb) {
+		rets = -ENOMEM;
+		goto out;
+	}
+
+	cb->fop_type = MEI_FOP_IOCTL;
+
+	if (dev->mei_host_buffer_is_empty &&
+	    !mei_cl_is_other_connecting(cl)) {
+		dev->mei_host_buffer_is_empty = false;
+
+		if (mei_hbm_cl_connect_req(dev, cl)) {
+			rets = -ENODEV;
+			goto out;
+		}
+		cl->timer_count = MEI_CONNECT_TIMEOUT;
+		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
+	} else {
+		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
+	}
+
+	mutex_unlock(&dev->device_lock);
+	rets = wait_event_timeout(dev->wait_recvd_msg,
+				 (cl->state == MEI_FILE_CONNECTED ||
+				  cl->state == MEI_FILE_DISCONNECTED),
+				 timeout * HZ);
+	mutex_lock(&dev->device_lock);
+
+	if (cl->state != MEI_FILE_CONNECTED) {
+		rets = -EFAULT;
+
+		mei_io_list_flush(&dev->ctrl_rd_list, cl);
+		mei_io_list_flush(&dev->ctrl_wr_list, cl);
+		goto out;
+	}
+
+	rets = cl->status;
+
+out:
+	mei_io_cb_free(cb);
+	return rets;
+}
+
+/**
  * mei_cl_flow_ctrl_creds - checks flow_control credits for cl.
  *
  * @dev: the device structure
@@ -542,160 +607,6 @@ int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 	return -ENOENT;
 }
 
-
-
-/**
- * mei_ioctl_connect_client - the connect to fw client IOCTL function
- *
- * @dev: the device structure
- * @data: IOCTL connect data, input and output parameters
- * @file: private data of the file object
- *
- * Locking: called under "dev->device_lock" lock
- *
- * returns 0 on success, <0 on failure.
- */
-int mei_ioctl_connect_client(struct file *file,
-			struct mei_connect_client_data *data)
-{
-	struct mei_device *dev;
-	struct mei_cl_cb *cb;
-	struct mei_client *client;
-	struct mei_cl *cl;
-	long timeout = mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT);
-	int i;
-	int err;
-	int rets;
-
-	cl = file->private_data;
-	if (WARN_ON(!cl || !cl->dev))
-		return -ENODEV;
-
-	dev = cl->dev;
-
-	dev_dbg(&dev->pdev->dev, "mei_ioctl_connect_client() Entry\n");
-
-	/* buffered ioctl cb */
-	cb = mei_io_cb_init(cl, file);
-	if (!cb) {
-		rets = -ENOMEM;
-		goto end;
-	}
-
-	cb->fop_type = MEI_FOP_IOCTL;
-
-	if (dev->dev_state != MEI_DEV_ENABLED) {
-		rets = -ENODEV;
-		goto end;
-	}
-	if (cl->state != MEI_FILE_INITIALIZING &&
-	    cl->state != MEI_FILE_DISCONNECTED) {
-		rets = -EBUSY;
-		goto end;
-	}
-
-	/* find ME client we're trying to connect to */
-	i = mei_me_cl_by_uuid(dev, &data->in_client_uuid);
-	if (i >= 0 && !dev->me_clients[i].props.fixed_address) {
-		cl->me_client_id = dev->me_clients[i].client_id;
-		cl->state = MEI_FILE_CONNECTING;
-	}
-
-	dev_dbg(&dev->pdev->dev, "Connect to FW Client ID = %d\n",
-			cl->me_client_id);
-	dev_dbg(&dev->pdev->dev, "FW Client - Protocol Version = %d\n",
-			dev->me_clients[i].props.protocol_version);
-	dev_dbg(&dev->pdev->dev, "FW Client - Max Msg Len = %d\n",
-			dev->me_clients[i].props.max_msg_length);
-
-	/* if we're connecting to amthi client then we will use the
-	 * existing connection
-	 */
-	if (uuid_le_cmp(data->in_client_uuid, mei_amthi_guid) == 0) {
-		dev_dbg(&dev->pdev->dev, "FW Client is amthi\n");
-		if (dev->iamthif_cl.state != MEI_FILE_CONNECTED) {
-			rets = -ENODEV;
-			goto end;
-		}
-		clear_bit(cl->host_client_id, dev->host_clients_map);
-		mei_cl_unlink(cl);
-
-		kfree(cl);
-		cl = NULL;
-		file->private_data = &dev->iamthif_cl;
-
-		client = &data->out_client_properties;
-		client->max_msg_length =
-			dev->me_clients[i].props.max_msg_length;
-		client->protocol_version =
-			dev->me_clients[i].props.protocol_version;
-		rets = dev->iamthif_cl.status;
-
-		goto end;
-	}
-
-	if (cl->state != MEI_FILE_CONNECTING) {
-		rets = -ENODEV;
-		goto end;
-	}
-
-
-	/* prepare the output buffer */
-	client = &data->out_client_properties;
-	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
-	client->protocol_version = dev->me_clients[i].props.protocol_version;
-	dev_dbg(&dev->pdev->dev, "Can connect?\n");
-	if (dev->mei_host_buffer_is_empty &&
-	    !mei_cl_is_other_connecting(cl)) {
-		dev_dbg(&dev->pdev->dev, "Sending Connect Message\n");
-		dev->mei_host_buffer_is_empty = false;
-		if (mei_hbm_cl_connect_req(dev, cl)) {
-			dev_dbg(&dev->pdev->dev, "Sending connect message - failed\n");
-			rets = -ENODEV;
-			goto end;
-		} else {
-			dev_dbg(&dev->pdev->dev, "Sending connect message - succeeded\n");
-			cl->timer_count = MEI_CONNECT_TIMEOUT;
-			list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
-		}
-
-
-	} else {
-		dev_dbg(&dev->pdev->dev, "Queuing the connect request due to device busy\n");
-		dev_dbg(&dev->pdev->dev, "add connect cb to control write list.\n");
-		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
-	}
-	mutex_unlock(&dev->device_lock);
-	err = wait_event_timeout(dev->wait_recvd_msg,
-			(MEI_FILE_CONNECTED == cl->state ||
-			 MEI_FILE_DISCONNECTED == cl->state), timeout);
-
-	mutex_lock(&dev->device_lock);
-	if (MEI_FILE_CONNECTED == cl->state) {
-		dev_dbg(&dev->pdev->dev, "successfully connected to FW client.\n");
-		rets = cl->status;
-		goto end;
-	} else {
-		dev_dbg(&dev->pdev->dev, "failed to connect to FW client.cl->state = %d.\n",
-		    cl->state);
-		if (!err) {
-			dev_dbg(&dev->pdev->dev,
-				"wait_event_interruptible_timeout failed on client"
-				" connect message fw response message.\n");
-		}
-		rets = -EFAULT;
-
-		mei_io_list_flush(&dev->ctrl_rd_list, cl);
-		mei_io_list_flush(&dev->ctrl_wr_list, cl);
-		goto end;
-	}
-	rets = 0;
-end:
-	dev_dbg(&dev->pdev->dev, "free connect cb memory.");
-	mei_io_cb_free(cb);
-	return rets;
-}
-
 /**
  * mei_cl_start_read - the start read client message function.
  *
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 95f05d9..8d3c134 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -562,6 +562,103 @@ err:
 	return rets;
 }
 
+/**
+ * mei_ioctl_connect_client - the connect to fw client IOCTL function
+ *
+ * @dev: the device structure
+ * @data: IOCTL connect data, input and output parameters
+ * @file: private data of the file object
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_ioctl_connect_client(struct file *file,
+			struct mei_connect_client_data *data)
+{
+	struct mei_device *dev;
+	struct mei_client *client;
+	struct mei_cl *cl;
+	int i;
+	int rets;
+
+	cl = file->private_data;
+	if (WARN_ON(!cl || !cl->dev))
+		return -ENODEV;
+
+	dev = cl->dev;
+
+	if (dev->dev_state != MEI_DEV_ENABLED) {
+		rets = -ENODEV;
+		goto end;
+	}
+
+	if (cl->state != MEI_FILE_INITIALIZING &&
+	    cl->state != MEI_FILE_DISCONNECTED) {
+		rets = -EBUSY;
+		goto end;
+	}
+
+	/* find ME client we're trying to connect to */
+	i = mei_me_cl_by_uuid(dev, &data->in_client_uuid);
+	if (i >= 0 && !dev->me_clients[i].props.fixed_address) {
+		cl->me_client_id = dev->me_clients[i].client_id;
+		cl->state = MEI_FILE_CONNECTING;
+	}
+
+	dev_dbg(&dev->pdev->dev, "Connect to FW Client ID = %d\n",
+			cl->me_client_id);
+	dev_dbg(&dev->pdev->dev, "FW Client - Protocol Version = %d\n",
+			dev->me_clients[i].props.protocol_version);
+	dev_dbg(&dev->pdev->dev, "FW Client - Max Msg Len = %d\n",
+			dev->me_clients[i].props.max_msg_length);
+
+	/* if we're connecting to amthi client then we will use the
+	 * existing connection
+	 */
+	if (uuid_le_cmp(data->in_client_uuid, mei_amthi_guid) == 0) {
+		dev_dbg(&dev->pdev->dev, "FW Client is amthi\n");
+		if (dev->iamthif_cl.state != MEI_FILE_CONNECTED) {
+			rets = -ENODEV;
+			goto end;
+		}
+		clear_bit(cl->host_client_id, dev->host_clients_map);
+		mei_cl_unlink(cl);
+
+		kfree(cl);
+		cl = NULL;
+		file->private_data = &dev->iamthif_cl;
+
+		client = &data->out_client_properties;
+		client->max_msg_length =
+			dev->me_clients[i].props.max_msg_length;
+		client->protocol_version =
+			dev->me_clients[i].props.protocol_version;
+		rets = dev->iamthif_cl.status;
+
+		goto end;
+	}
+
+	if (cl->state != MEI_FILE_CONNECTING) {
+		rets = -ENODEV;
+		goto end;
+	}
+
+
+	/* prepare the output buffer */
+	client = &data->out_client_properties;
+	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
+	client->protocol_version = dev->me_clients[i].props.protocol_version;
+	dev_dbg(&dev->pdev->dev, "Can connect?\n");
+
+
+	rets = mei_cl_connect(cl, file);
+
+end:
+	dev_dbg(&dev->pdev->dev, "free connect cb memory.");
+	return rets;
+}
+
 
 /**
  * mei_ioctl - the IOCTL function
@@ -610,6 +707,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 		rets = -EFAULT;
 		goto out;
 	}
+
 	rets = mei_ioctl_connect_client(file, connect_data);
 
 	/* if all is ok, copying the data back to user. */
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 5a1ac9a..f3da153 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -341,11 +341,6 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id);
 void mei_timer(struct work_struct *work);
 
 /*
- *  MEI input output function prototype
- */
-int mei_ioctl_connect_client(struct file *file,
-			struct mei_connect_client_data *data);
-/*
  * AMTHIF - AMT Host Interface Functions
  */
 void mei_amthif_reset_params(struct mei_device *dev);
-- 
1.7.4.4

