Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab2JIOuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:50:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:42957 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538Ab2JIOue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,560,1344236400"; 
   d="scan'208";a="154176509"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/6] mei: mei_write: revamp error path handling
Date: Tue,  9 Oct 2012 16:50:18 +0200
Message-Id: <1349794221-8667-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
References: <1349794221-8667-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. unify common amt and regular error path and use it early in the
  function
2. fix indentation
3. propagate error code directly from copy_from_user
4. print out errors using dev_err instead of dev_dbg

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c |   75 +++++++++++++++++------------------------------
 1 files changed, 27 insertions(+), 48 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 15de4b1..8dcf59d 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -621,10 +621,26 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	mutex_lock(&dev->device_lock);
 
 	if (dev->dev_state != MEI_DEV_ENABLED) {
-		mutex_unlock(&dev->device_lock);
-		return -ENODEV;
+		rets = -ENODEV;
+		goto unlock_dev;
 	}
 
+	i = mei_me_cl_by_id(dev, cl->me_client_id);
+	if (i < 0) {
+		rets = -ENODEV;
+		goto unlock_dev;
+	}
+	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
+		rets = -EMSGSIZE;
+		goto unlock_dev;
+	}
+
+	if (cl->state != MEI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		dev_err(&dev->pdev->dev, "host client = %d,  is not connected to ME client = %d",
+			cl->host_client_id, cl->me_client_id);
+		goto unlock_dev;
+	}
 	if (cl == &dev->iamthif_cl) {
 		write_cb = find_amthi_read_list_entry(dev, file);
 
@@ -633,11 +649,11 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 					msecs_to_jiffies(IAMTHIF_READ_TIMER);
 
 			if (time_after(jiffies, timeout) ||
-				 cl->reading_state == MEI_READ_COMPLETE) {
-					*offset = 0;
-					list_del(&write_cb->cb_list);
-					mei_free_cb_private(write_cb);
-					write_cb = NULL;
+			    cl->reading_state == MEI_READ_COMPLETE) {
+				*offset = 0;
+				list_del(&write_cb->cb_list);
+				mei_free_cb_private(write_cb);
+				write_cb = NULL;
 			}
 		}
 	}
@@ -670,8 +686,8 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	dev_dbg(&dev->pdev->dev, "cb request size = %zd\n", length);
 
-	rets = -EFAULT;
-	if (copy_from_user(write_cb->request_buffer.data, ubuf, length))
+	rets = copy_from_user(write_cb->request_buffer.data, ubuf, length);
+	if (rets)
 		goto unlock_dev;
 
 	cl->sm_state = 0;
@@ -685,29 +701,11 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		cl->sm_state |= MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
 
 	if (cl == &dev->iamthif_cl) {
-		if (dev->dev_state != MEI_DEV_ENABLED) {
-			rets = -ENODEV;
-			goto unlock_dev;
-		}
-		i = mei_me_cl_by_id(dev, dev->iamthif_cl.me_client_id);
-		if (i < 0) {
-			rets = -ENODEV;
-			goto unlock_dev;
-		}
-		if (length > dev->me_clients[i].props.max_msg_length ||
-			   length <= 0) {
-			rets = -EMSGSIZE;
-			goto unlock_dev;
-		}
 		rets = mei_io_cb_alloc_resp_buf(write_cb, dev->iamthif_mtu);
 		if (rets)
 			goto unlock_dev;
 
 		write_cb->major_file_operations = MEI_IOCTL;
-		if (dev->iamthif_cl.state != MEI_FILE_CONNECTED) {
-			rets = -ENODEV;
-			goto unlock_dev;
-		}
 
 		if (!list_empty(&dev->amthi_cmd_list.mei_cb.cb_list) ||
 				dev->iamthif_state != MEI_IAMTHIF_IDLE) {
@@ -716,43 +714,24 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			dev_dbg(&dev->pdev->dev, "add amthi cb to amthi cmd waiting list\n");
 			list_add_tail(&write_cb->cb_list,
 					&dev->amthi_cmd_list.mei_cb.cb_list);
-			rets = length;
 		} else {
 			dev_dbg(&dev->pdev->dev, "call amthi write\n");
 			rets = amthi_write(dev, write_cb);
 
 			if (rets) {
-				dev_dbg(&dev->pdev->dev, "amthi write failed with status = %d\n",
+				dev_err(&dev->pdev->dev, "amthi write failed with status = %d\n",
 				    rets);
 				goto unlock_dev;
 			}
-			rets = length;
 		}
 		mutex_unlock(&dev->device_lock);
-		return rets;
+		return length;
 	}
 
 	write_cb->major_file_operations = MEI_WRITE;
 
 	dev_dbg(&dev->pdev->dev, "host client = %d, ME client = %d\n",
 	    cl->host_client_id, cl->me_client_id);
-	if (cl->state != MEI_FILE_CONNECTED) {
-		rets = -ENODEV;
-		dev_dbg(&dev->pdev->dev, "host client = %d,  is not connected to ME client = %d",
-		    cl->host_client_id,
-		    cl->me_client_id);
-		goto unlock_dev;
-	}
-	i = mei_me_cl_by_id(dev, cl->me_client_id);
-	if (i < 0) {
-		rets = -ENODEV;
-		goto unlock_dev;
-	}
-	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
-		rets = -EINVAL;
-		goto unlock_dev;
-	}
-
 	rets = mei_flow_ctrl_creds(dev, cl);
 	if (rets < 0)
 		goto unlock_dev;
-- 
1.7.4.4

