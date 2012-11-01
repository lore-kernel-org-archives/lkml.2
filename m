Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936041Ab2KATRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:17:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:22415 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935955Ab2KATRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="241495322"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 6/6] mei: move amthif specific code from mei_write to mei_amthif_write
Date: Thu,  1 Nov 2012 21:17:18 +0200
Message-Id: <1351797438-26345-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
References: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For sake of amthif consolidation move amthif specific code from
mei_write to mei_amthif_write

The original mei_amthif_write to mei_amthif_send_cmd
as this function deals with sending single command
while mei_amthif_write is interface function called from
the main driver which in turns calls mei_amthif_send_cmd

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c |   39 ++++++++++++++++++++++++++++++++++++---
 drivers/misc/mei/main.c   |   25 +++++--------------------
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 392203d..96db3ad 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -255,14 +255,15 @@ out:
 }
 
 /**
- * mei_amthif_write - write amthif data to amthif client
+ * mei_amthif_send_cmd - send amthif command to the ME
  *
  * @dev: the device structure
  * @cb: mei call back struct
  *
  * returns 0 on success, <0 on failure.
+ *
  */
-int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
+static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 {
 	struct mei_msg_hdr mei_hdr;
 	int ret;
@@ -329,6 +330,38 @@ int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
 }
 
 /**
+ * mei_amthif_write - write amthif data to amthif client
+ *
+ * @dev: the device structure
+ * @cb: mei call back struct
+ *
+ * returns 0 on success, <0 on failure.
+ *
+ */
+int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
+{
+	int ret;
+
+	if (!dev || !cb)
+		return -ENODEV;
+
+	ret = mei_io_cb_alloc_resp_buf(cb, dev->iamthif_mtu);
+	if (ret)
+		return ret;
+
+	cb->major_file_operations = MEI_IOCTL;
+
+	if (!list_empty(&dev->amthi_cmd_list.list) ||
+	    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
+		dev_dbg(&dev->pdev->dev,
+			"amthif state = %d\n", dev->iamthif_state);
+		dev_dbg(&dev->pdev->dev, "AMTHIF: add cb to the wait list\n");
+		list_add_tail(&cb->list, &dev->amthi_cmd_list.list);
+		return 0;
+	}
+	return mei_amthif_send_cmd(dev, cb);
+}
+/**
  * mei_amthif_run_next_cmd
  *
  * @dev: the device structure
@@ -360,7 +393,7 @@ void mei_amthif_run_next_cmd(struct mei_device *dev)
 		cl_tmp = (struct mei_cl *)pos->file_private;
 
 		if (cl_tmp && cl_tmp == &dev->iamthif_cl) {
-			status = mei_amthif_write(dev, pos);
+			status = mei_amthif_send_cmd(dev, pos);
 			if (status) {
 				dev_dbg(&dev->pdev->dev,
 					"amthi write failed status = %d\n",
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index d8221a5..ff50cc1 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -620,27 +620,12 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		cl->sm_state |= MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
 
 	if (cl == &dev->iamthif_cl) {
-		rets = mei_io_cb_alloc_resp_buf(write_cb, dev->iamthif_mtu);
-		if (rets)
-			goto err;
+		rets = mei_amthif_write(dev, write_cb);
 
-		write_cb->major_file_operations = MEI_IOCTL;
-
-		if (!list_empty(&dev->amthi_cmd_list.list) ||
-				dev->iamthif_state != MEI_IAMTHIF_IDLE) {
-			dev_dbg(&dev->pdev->dev, "amthi_state = %d\n",
-					(int) dev->iamthif_state);
-			dev_dbg(&dev->pdev->dev, "add amthi cb to amthi cmd waiting list\n");
-			list_add_tail(&write_cb->list, &dev->amthi_cmd_list.list);
-		} else {
-			dev_dbg(&dev->pdev->dev, "call amthi write\n");
-			rets = mei_amthif_write(dev, write_cb);
-
-			if (rets) {
-				dev_err(&dev->pdev->dev, "amthi write failed with status = %d\n",
-				    rets);
-				goto err;
-			}
+		if (rets) {
+			dev_err(&dev->pdev->dev,
+				"amthi write failed with status = %d\n", rets);
+			goto err;
 		}
 		mutex_unlock(&dev->device_lock);
 		return length;
-- 
1.7.4.4

