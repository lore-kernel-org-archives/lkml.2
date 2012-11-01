Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935071Ab2KATR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:17:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:15805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329Ab2KATR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:17:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="241495262"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/6] mei: mei_write: revamp function flow
Date: Thu,  1 Nov 2012 21:17:13 +0200
Message-Id: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use goto statement for error handling instead of deeper if constructs
and rename label 'unlock_dev' to more appropriate 'err'

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |   88 +++++++++++++++++++++++-----------------------
 1 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index ed4943f..7a03d77 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -543,24 +543,24 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	if (dev->dev_state != MEI_DEV_ENABLED) {
 		rets = -ENODEV;
-		goto unlock_dev;
+		goto err;
 	}
 
 	i = mei_me_cl_by_id(dev, cl->me_client_id);
 	if (i < 0) {
 		rets = -ENODEV;
-		goto unlock_dev;
+		goto err;
 	}
 	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
 		rets = -EMSGSIZE;
-		goto unlock_dev;
+		goto err;
 	}
 
 	if (cl->state != MEI_FILE_CONNECTED) {
 		rets = -ENODEV;
 		dev_err(&dev->pdev->dev, "host client = %d,  is not connected to ME client = %d",
 			cl->host_client_id, cl->me_client_id);
-		goto unlock_dev;
+		goto err;
 	}
 	if (cl == &dev->iamthif_cl) {
 		write_cb = find_amthi_read_list_entry(dev, file);
@@ -599,17 +599,17 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	if (!write_cb) {
 		dev_err(&dev->pdev->dev, "write cb allocation failed\n");
 		rets = -ENOMEM;
-		goto unlock_dev;
+		goto err;
 	}
 	rets = mei_io_cb_alloc_req_buf(write_cb, length);
 	if (rets)
-		goto unlock_dev;
+		goto err;
 
 	dev_dbg(&dev->pdev->dev, "cb request size = %zd\n", length);
 
 	rets = copy_from_user(write_cb->request_buffer.data, ubuf, length);
 	if (rets)
-		goto unlock_dev;
+		goto err;
 
 	cl->sm_state = 0;
 	if (length == 4 &&
@@ -624,7 +624,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	if (cl == &dev->iamthif_cl) {
 		rets = mei_io_cb_alloc_resp_buf(write_cb, dev->iamthif_mtu);
 		if (rets)
-			goto unlock_dev;
+			goto err;
 
 		write_cb->major_file_operations = MEI_IOCTL;
 
@@ -641,7 +641,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			if (rets) {
 				dev_err(&dev->pdev->dev, "amthi write failed with status = %d\n",
 				    rets);
-				goto unlock_dev;
+				goto err;
 			}
 		}
 		mutex_unlock(&dev->device_lock);
@@ -654,51 +654,51 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	    cl->host_client_id, cl->me_client_id);
 	rets = mei_flow_ctrl_creds(dev, cl);
 	if (rets < 0)
-		goto unlock_dev;
+		goto err;
 
-	if (rets && dev->mei_host_buffer_is_empty) {
-		rets = 0;
-		dev->mei_host_buffer_is_empty = false;
-		if (length >  mei_hbuf_max_data(dev)) {
-			mei_hdr.length = mei_hbuf_max_data(dev);
-			mei_hdr.msg_complete = 0;
-		} else {
-			mei_hdr.length = length;
-			mei_hdr.msg_complete = 1;
-		}
-		mei_hdr.host_addr = cl->host_client_id;
-		mei_hdr.me_addr = cl->me_client_id;
-		mei_hdr.reserved = 0;
-		dev_dbg(&dev->pdev->dev, "call mei_write_message header=%08x.\n",
-		    *((u32 *) &mei_hdr));
-		if (mei_write_message(dev, &mei_hdr,
-			(unsigned char *) (write_cb->request_buffer.data),
-			mei_hdr.length)) {
-			rets = -ENODEV;
-			goto unlock_dev;
-		}
+	if (rets == 0 || dev->mei_host_buffer_is_empty == false) {
+		write_cb->buf_idx = 0;
+		mei_hdr.msg_complete = 0;
 		cl->writing_state = MEI_WRITING;
-		write_cb->buf_idx = mei_hdr.length;
-		if (mei_hdr.msg_complete) {
-			if (mei_flow_ctrl_reduce(dev, cl)) {
-				rets = -ENODEV;
-				goto unlock_dev;
-			}
-			list_add_tail(&write_cb->list, &dev->write_waiting_list.list);
-		} else {
-			list_add_tail(&write_cb->list, &dev->write_list.list);
-		}
+		goto out;
+	}
 
+	dev->mei_host_buffer_is_empty = false;
+	if (length >  mei_hbuf_max_data(dev)) {
+		mei_hdr.length = mei_hbuf_max_data(dev);
+		mei_hdr.msg_complete = 0;
 	} else {
+		mei_hdr.length = length;
+		mei_hdr.msg_complete = 1;
+	}
+	mei_hdr.host_addr = cl->host_client_id;
+	mei_hdr.me_addr = cl->me_client_id;
+	mei_hdr.reserved = 0;
+	dev_dbg(&dev->pdev->dev, "call mei_write_message header=%08x.\n",
+	    *((u32 *) &mei_hdr));
+	if (mei_write_message(dev, &mei_hdr,
+		write_cb->request_buffer.data, mei_hdr.length)) {
+		rets = -ENODEV;
+		goto err;
+	}
+	cl->writing_state = MEI_WRITING;
+	write_cb->buf_idx = mei_hdr.length;
 
-		write_cb->buf_idx = 0;
-		cl->writing_state = MEI_WRITING;
+out:
+	if (mei_hdr.msg_complete) {
+		if (mei_flow_ctrl_reduce(dev, cl)) {
+			rets = -ENODEV;
+			goto err;
+		}
+		list_add_tail(&write_cb->list, &dev->write_waiting_list.list);
+	} else {
 		list_add_tail(&write_cb->list, &dev->write_list.list);
 	}
+
 	mutex_unlock(&dev->device_lock);
 	return length;
 
-unlock_dev:
+err:
 	mutex_unlock(&dev->device_lock);
 	mei_io_cb_free(write_cb);
 	return rets;
-- 
1.7.4.4

