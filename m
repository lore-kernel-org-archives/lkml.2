Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab2JIOvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:51:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:42957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab2JIOuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="154176501"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/6] mei: add allocation and initialization wrappers for io callback
Date: Tue,  9 Oct 2012 16:50:17 +0200
Message-Id: <1349794221-8667-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
References: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mei_io_cb_init - allocat and initializate mei_cl_cb
mei_io_cb_alloc_req/resp_buf are separate function as buffers
are not always needed

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |  111 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 87 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 3d4f6d1..15de4b1 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -516,6 +516,83 @@ out:
 }
 
 /**
+ * mei_io_cb_init - allocate and initialize io callback
+ *
+ * @cl - mei client
+ * @file: pointer to file structure
+ *
+ * returns mei_cl_cb pointer or NULL;
+ */
+static struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
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
+	INIT_LIST_HEAD(&cb->cb_list);
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
+static int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length)
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
+static int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
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
+/**
  * mei_write - the write function.
  *
  * @file: pointer to file structure
@@ -581,20 +658,17 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		*offset = 0;
 
 
-	write_cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	write_cb = mei_io_cb_init(cl, file);
 	if (!write_cb) {
-		mutex_unlock(&dev->device_lock);
-		return -ENOMEM;
+		dev_err(&dev->pdev->dev, "write cb allocation failed\n");
+		rets = -ENOMEM;
+		goto unlock_dev;
 	}
-
-	write_cb->file_object = file;
-	write_cb->file_private = cl;
-	write_cb->request_buffer.data = kmalloc(length, GFP_KERNEL);
-	rets = -ENOMEM;
-	if (!write_cb->request_buffer.data)
+	rets = mei_io_cb_alloc_req_buf(write_cb, length);
+	if (rets)
 		goto unlock_dev;
 
-	dev_dbg(&dev->pdev->dev, "length =%d\n", (int) length);
+	dev_dbg(&dev->pdev->dev, "cb request size = %zd\n", length);
 
 	rets = -EFAULT;
 	if (copy_from_user(write_cb->request_buffer.data, ubuf, length))
@@ -610,14 +684,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 				 write_cb->request_buffer.data, 4) == 0)))
 		cl->sm_state |= MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
 
-	INIT_LIST_HEAD(&write_cb->cb_list);
 	if (cl == &dev->iamthif_cl) {
-		write_cb->response_buffer.data =
-		    kmalloc(dev->iamthif_mtu, GFP_KERNEL);
-		if (!write_cb->response_buffer.data) {
-			rets = -ENOMEM;
-			goto unlock_dev;
-		}
 		if (dev->dev_state != MEI_DEV_ENABLED) {
 			rets = -ENODEV;
 			goto unlock_dev;
@@ -632,11 +699,11 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			rets = -EMSGSIZE;
 			goto unlock_dev;
 		}
+		rets = mei_io_cb_alloc_resp_buf(write_cb, dev->iamthif_mtu);
+		if (rets)
+			goto unlock_dev;
 
-		write_cb->response_buffer.size = dev->iamthif_mtu;
 		write_cb->major_file_operations = MEI_IOCTL;
-		write_cb->buf_idx = 0;
-		write_cb->request_buffer.size = length;
 		if (dev->iamthif_cl.state != MEI_FILE_CONNECTED) {
 			rets = -ENODEV;
 			goto unlock_dev;
@@ -666,9 +733,6 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	}
 
 	write_cb->major_file_operations = MEI_WRITE;
-	/* make sure buffer index is zero before we start */
-	write_cb->buf_idx = 0;
-	write_cb->request_buffer.size = length;
 
 	dev_dbg(&dev->pdev->dev, "host client = %d, ME client = %d\n",
 	    cl->host_client_id, cl->me_client_id);
@@ -688,7 +752,6 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		rets = -EINVAL;
 		goto unlock_dev;
 	}
-	write_cb->file_private = cl;
 
 	rets = mei_flow_ctrl_creds(dev, cl);
 	if (rets < 0)
-- 
1.7.4.4

