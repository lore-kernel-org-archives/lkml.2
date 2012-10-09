Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088Ab2JIOur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:50:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:42957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab2JIOum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:50:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="154176542"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/6] mei: use mei_io_cb_ warppers also for control flows
Date: Tue,  9 Oct 2012 16:50:21 +0200
Message-Id: <1349794221-8667-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
References: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move the mei_io_cb_ wrappers to to iorw.c for global use
and use them also for handling control flows

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c    |    4 +-
 drivers/misc/mei/iorw.c    |  120 +++++++++++++++++++++++++++++++++----------
 drivers/misc/mei/main.c    |   78 ----------------------------
 drivers/misc/mei/mei_dev.h |    4 ++
 4 files changed, 97 insertions(+), 109 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 2dcdedf..e1205b3 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -668,12 +668,10 @@ int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 	if (cl->state != MEI_FILE_DISCONNECTING)
 		return 0;
 
-	cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	cb = mei_io_cb_init(cl, NULL);
 	if (!cb)
 		return -ENOMEM;
 
-	mei_io_list_init(cb);
-	cb->file_private = cl;
 	cb->major_file_operations = MEI_CLOSE;
 	if (dev->mei_host_buffer_is_empty) {
 		dev->mei_host_buffer_is_empty = false;
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index 2891bc4..4c91908 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -52,6 +52,83 @@ void mei_io_cb_free(struct mei_cl_cb *cb)
 	kfree(cb->response_buffer.data);
 	kfree(cb);
 }
+/**
+ * mei_io_cb_init - allocate and initialize io callback
+ *
+ * @cl - mei client
+ * @file: pointer to file structure
+ *
+ * returns mei_cl_cb pointer or NULL;
+ */
+struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
+{
+	struct mei_cl_cb *cb;
+	struct mei_device *dev;
+
+	dev = cl->dev;
+
+	cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	if (!cb)
+		return NULL;
+
+	mei_io_list_init(cb);
+
+	cb->file_object = fp;
+	cb->file_private = cl;
+	cb->buf_idx = 0;
+	return cb;
+}
+
+
+/**
+ * mei_io_cb_alloc_req_buf - allocate request buffer
+ *
+ * @cb -  io callback structure
+ * @size: size of the buffer
+ *
+ * returns 0 on success
+ *         -EINVAL if cb is NULL
+ *         -ENOMEM if allocation failed
+ */
+int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length)
+{
+	if (!cb)
+		return -EINVAL;
+
+	if (length == 0)
+		return 0;
+
+	cb->request_buffer.data = kmalloc(length, GFP_KERNEL);
+	if (!cb->request_buffer.data)
+		return -ENOMEM;
+	cb->request_buffer.size = length;
+	return 0;
+}
+/**
+ * mei_io_cb_alloc_req_buf - allocate respose buffer
+ *
+ * @cb -  io callback structure
+ * @size: size of the buffer
+ *
+ * returns 0 on success
+ *         -EINVAL if cb is NULL
+ *         -ENOMEM if allocation failed
+ */
+int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
+{
+	if (!cb)
+		return -EINVAL;
+
+	if (length == 0)
+		return 0;
+
+	cb->response_buffer.data = kmalloc(length, GFP_KERNEL);
+	if (!cb->response_buffer.data)
+		return -ENOMEM;
+	cb->response_buffer.size = length;
+	return 0;
+}
+
 
 /**
  * mei_me_cl_by_id return index to me_clients for client_id
@@ -112,14 +189,12 @@ int mei_ioctl_connect_client(struct file *file,
 
 	dev_dbg(&dev->pdev->dev, "mei_ioctl_connect_client() Entry\n");
 
-
 	/* buffered ioctl cb */
-	cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	cb = mei_io_cb_init(cl, file);
 	if (!cb) {
 		rets = -ENOMEM;
 		goto end;
 	}
-	mei_io_list_init(cb);
 
 	cb->major_file_operations = MEI_IOCTL;
 
@@ -207,14 +282,12 @@ int mei_ioctl_connect_client(struct file *file,
 		} else {
 			dev_dbg(&dev->pdev->dev, "Sending connect message - succeeded\n");
 			cl->timer_count = MEI_CONNECT_TIMEOUT;
-			cb->file_private = cl;
 			list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
 		}
 
 
 	} else {
 		dev_dbg(&dev->pdev->dev, "Queuing the connect request due to device busy\n");
-		cb->file_private = cl;
 		dev_dbg(&dev->pdev->dev, "add connect cb to control write list.\n");
 		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 	}
@@ -407,7 +480,7 @@ out:
 int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_cl_cb *cb;
-	int rets = 0;
+	int rets;
 	int i;
 
 	if (cl->state != MEI_FILE_CONNECTED)
@@ -416,49 +489,40 @@ int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
 	if (dev->dev_state != MEI_DEV_ENABLED)
 		return -ENODEV;
 
-	dev_dbg(&dev->pdev->dev, "check if read is pending.\n");
 	if (cl->read_pending || cl->read_cb) {
 		dev_dbg(&dev->pdev->dev, "read is pending.\n");
 		return -EBUSY;
 	}
+	i = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (i < 0) {
+		dev_err(&dev->pdev->dev, "no such me client %d\n",
+			cl->me_client_id);
+		return  -ENODEV;
+	}
 
-	cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	cb = mei_io_cb_init(cl, NULL);
 	if (!cb)
 		return -ENOMEM;
 
-	dev_dbg(&dev->pdev->dev, "allocation call back successful. host client = %d, ME client = %d\n",
-		cl->host_client_id, cl->me_client_id);
-	i = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (i < 0) {
-		rets = -ENODEV;
-		goto unlock;
-	}
+	rets = mei_io_cb_alloc_resp_buf(cb,
+			dev->me_clients[i].props.max_msg_length);
+	if (rets)
+		goto err;
 
-	cb->response_buffer.size = dev->me_clients[i].props.max_msg_length;
-	cb->response_buffer.data =
-			kmalloc(cb->response_buffer.size, GFP_KERNEL);
-	if (!cb->response_buffer.data) {
-		rets = -ENOMEM;
-		goto unlock;
-	}
-	dev_dbg(&dev->pdev->dev, "allocation call back data success.\n");
 	cb->major_file_operations = MEI_READ;
-	/* make sure buffer index is zero before we start */
-	cb->buf_idx = 0;
-	cb->file_private = (void *) cl;
 	cl->read_cb = cb;
 	if (dev->mei_host_buffer_is_empty) {
 		dev->mei_host_buffer_is_empty = false;
 		if (mei_send_flow_control(dev, cl)) {
 			rets = -ENODEV;
-			goto unlock;
+			goto err;
 		}
 		list_add_tail(&cb->list, &dev->read_list.list);
 	} else {
 		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
 	}
 	return rets;
-unlock:
+err:
 	mei_io_cb_free(cb);
 	return rets;
 }
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 518e07e..ed4943f 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -513,84 +513,6 @@ out:
 	mutex_unlock(&dev->device_lock);
 	return rets;
 }
-
-/**
- * mei_io_cb_init - allocate and initialize io callback
- *
- * @cl - mei client
- * @file: pointer to file structure
- *
- * returns mei_cl_cb pointer or NULL;
- */
-static struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
-{
-	struct mei_cl_cb *cb;
-	struct mei_device *dev;
-
-	dev = cl->dev;
-
-	cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
-	if (!cb)
-		return NULL;
-
-	mei_io_list_init(cb);
-
-	cb->file_object = fp;
-	cb->file_private = cl;
-	cb->buf_idx = 0;
-	return cb;
-}
-
-
-/**
- * mei_io_cb_alloc_req_buf - allocate request buffer
- *
- * @cb -  io callback structure
- * @size: size of the buffer
- *
- * returns 0 on success
- *         -EINVAL if cb is NULL
- *         -ENOMEM if allocation failed
- */
-static int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length)
-{
-	if (!cb)
-		return -EINVAL;
-
-	if (length == 0)
-		return 0;
-
-	cb->request_buffer.data = kmalloc(length, GFP_KERNEL);
-	if (!cb->request_buffer.data)
-		return -ENOMEM;
-	cb->request_buffer.size = length;
-	return 0;
-}
-/**
- * mei_io_cb_alloc_req_buf - allocate respose buffer
- *
- * @cb -  io callback structure
- * @size: size of the buffer
- *
- * returns 0 on success
- *         -EINVAL if cb is NULL
- *         -ENOMEM if allocation failed
- */
-static int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
-{
-	if (!cb)
-		return -EINVAL;
-
-	if (length == 0)
-		return 0;
-
-	cb->response_buffer.data = kmalloc(length, GFP_KERNEL);
-	if (!cb->response_buffer.data)
-		return -ENOMEM;
-	cb->response_buffer.size = length;
-	return 0;
-}
-
 /**
  * mei_write - the write function.
  *
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 4545a9e..6adcb3f 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -293,7 +293,11 @@ int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
 /*
  * MEI IO Functions
  */
+struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp);
 void mei_io_cb_free(struct mei_cl_cb *priv_cb);
+int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length);
+int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length);
+
 
 /**
  * mei_io_list_init - Sets up a queue list.
-- 
1.7.4.4

