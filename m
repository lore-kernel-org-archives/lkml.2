Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3AHVIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:45970 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747Ab3AHVII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243605039"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 11/21] mei: normalize me host client linking routines
Date: Tue,  8 Jan 2013 23:07:22 +0200
Message-Id: <1357679252-12958-12-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order we can use the same code pattern for in-kernel
and user space host clients we replace mei_cl_link_to_me
with mei_cl_link function.
We then have to keep me client lookupout of the new link function.

The unlinking cannot be yet symetric due to amthif connection
handling

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c  |   42 +++++++++++++++++++++-------------
 drivers/misc/mei/client.c  |   53 ++++++++++++++++++++++++-------------------
 drivers/misc/mei/client.h  |    2 +-
 drivers/misc/mei/init.c    |    4 +++
 drivers/misc/mei/main.c    |   27 +++++++---------------
 drivers/misc/mei/mei_dev.h |   10 ++++----
 drivers/misc/mei/wd.c      |   35 +++++++++++++++++++----------
 7 files changed, 98 insertions(+), 75 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 64a9bfa..88e6aa0 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -65,22 +65,22 @@ void mei_amthif_reset_params(struct mei_device *dev)
  * @dev: the device structure
  *
  */
-void mei_amthif_host_init(struct mei_device *dev)
+int mei_amthif_host_init(struct mei_device *dev)
 {
-	int i;
+	struct mei_cl *cl = &dev->iamthif_cl;
 	unsigned char *msg_buf;
+	int ret, i;
 
-	mei_cl_init(&dev->iamthif_cl, dev);
-	dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
+	mei_cl_init(cl, dev);
 
-	/* find ME amthif client */
-	i = mei_cl_link_me(&dev->iamthif_cl,
-			    &mei_amthif_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
+	i = mei_me_cl_by_uuid(dev, &mei_amthif_guid);
 	if (i < 0) {
-		dev_info(&dev->pdev->dev, "failed to find iamthif client.\n");
-		return;
+		dev_info(&dev->pdev->dev, "amthif: failed to find the client\n");
+		return -ENOENT;
 	}
 
+	cl->me_client_id = dev->me_clients[i].client_id;
+
 	/* Assign iamthif_mtu to the value received from ME  */
 
 	dev->iamthif_mtu = dev->me_clients[i].props.max_msg_length;
@@ -94,19 +94,29 @@ void mei_amthif_host_init(struct mei_device *dev)
 	msg_buf = kcalloc(dev->iamthif_mtu,
 			sizeof(unsigned char), GFP_KERNEL);
 	if (!msg_buf) {
-		dev_dbg(&dev->pdev->dev, "memory allocation for ME message buffer failed.\n");
-		return;
+		dev_err(&dev->pdev->dev, "amthif: memory allocation for ME message buffer failed.\n");
+		return -ENOMEM;
 	}
 
 	dev->iamthif_msg_buf = msg_buf;
 
-	if (mei_hbm_cl_connect_req(dev, &dev->iamthif_cl)) {
-		dev_dbg(&dev->pdev->dev, "Failed to connect to AMTHI client\n");
-		dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
-		dev->iamthif_cl.host_client_id = 0;
+	ret = mei_cl_link(cl, MEI_IAMTHIF_HOST_CLIENT_ID);
+
+	if (ret < 0) {
+		dev_err(&dev->pdev->dev, "amthif: failed link client\n");
+		return -ENOENT;
+	}
+
+	cl->state = MEI_FILE_CONNECTING;
+
+	if (mei_hbm_cl_connect_req(dev, cl)) {
+		dev_dbg(&dev->pdev->dev, "amthif: Failed to connect to ME client\n");
+		cl->state = MEI_FILE_DISCONNECTED;
+		cl->host_client_id = 0;
 	} else {
-		dev->iamthif_cl.timer_count = MEI_CONNECT_TIMEOUT;
+		cl->timer_count = MEI_CONNECT_TIMEOUT;
 	}
+	return 0;
 }
 
 /**
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 8103d94..d566dd8 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -258,54 +258,61 @@ struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
 	return NULL;
 }
 
-
-/**
- * mei_me_cl_link - create link between host and me clinet and add
- *   me_cl to the list
- *
- * @cl: link between me and host client assocated with opened file descriptor
- * @uuid: uuid of ME client
- * @client_id: id of the host client
+/** mei_cl_link: allocte host id in the host map
  *
- * returns ME client index if ME client
+ * @cl - host client
+ * @id - fixed host id or -1 for genereting one
+ * returns 0 on success
  *	-EINVAL on incorrect values
  *	-ENONET if client not found
  */
-int mei_cl_link_me(struct mei_cl *cl, const uuid_le *uuid, u8 host_cl_id)
+int mei_cl_link(struct mei_cl *cl, int id)
 {
 	struct mei_device *dev;
-	int i;
 
-	if (WARN_ON(!cl || !cl->dev || !uuid))
+	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
 
 	dev = cl->dev;
 
-	/* check for valid client id */
-	i = mei_me_cl_by_uuid(dev, uuid);
-	if (i >= 0) {
-		cl->me_client_id = dev->me_clients[i].client_id;
-		cl->state = MEI_FILE_CONNECTING;
-		cl->host_client_id = host_cl_id;
+	/* If Id is not asigned get one*/
+	if (id == MEI_HOST_CLIENT_ID_ANY)
+		id = find_first_zero_bit(dev->host_clients_map,
+					MEI_CLIENTS_MAX);
 
-		list_add_tail(&cl->link, &dev->file_list);
-		return (u8)i;
+	if (id >= MEI_CLIENTS_MAX) {
+		dev_err(&dev->pdev->dev, "id exceded %d", MEI_CLIENTS_MAX) ;
+		return -ENOENT;
 	}
 
-	return -ENOENT;
+	dev->open_handle_count++;
+
+	cl->host_client_id = id;
+	list_add_tail(&cl->link, &dev->file_list);
+
+	set_bit(id, dev->host_clients_map);
+
+	cl->state = MEI_FILE_INITIALIZING;
+
+	dev_dbg(&dev->pdev->dev, "link cl host id = %d\n", cl->host_client_id);
+	return 0;
 }
+
 /**
  * mei_cl_unlink - remove me_cl from the list
  *
  * @dev: the device structure
- * @host_client_id: host client id to be removed
  */
 int mei_cl_unlink(struct mei_cl *cl)
 {
 	struct mei_device *dev;
 	struct mei_cl *pos, *next;
 
-	if (WARN_ON(!cl || !cl->dev))
+	/* don't shout on error exit path */
+	if (!cl)
+		return 0;
+
+	if (WARN_ON(!cl->dev))
 		return -EINVAL;
 
 	dev = cl->dev;
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
index 8dfd052..240a1f3 100644
--- a/drivers/misc/mei/client.h
+++ b/drivers/misc/mei/client.h
@@ -55,7 +55,7 @@ struct mei_cl *mei_cl_allocate(struct mei_device *dev);
 void mei_cl_init(struct mei_cl *cl, struct mei_device *dev);
 
 
-int mei_cl_link_me(struct mei_cl *cl, const uuid_le *uuid, u8 host_cl_id);
+int mei_cl_link(struct mei_cl *cl, int id);
 int mei_cl_unlink(struct mei_cl *cl);
 
 int mei_cl_flush_queues(struct mei_cl *cl);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 636639f..9e4011e 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -242,7 +242,11 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		/* remove entry if already in list */
 		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
 		mei_cl_unlink(&dev->wd_cl);
+		if (dev->open_handle_count > 0)
+			dev->open_handle_count--;
 		mei_cl_unlink(&dev->iamthif_cl);
+		if (dev->open_handle_count > 0)
+			dev->open_handle_count--;
 
 		mei_amthif_reset_params(dev);
 		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index d5d1a59..ec5fd7a 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -103,7 +103,6 @@ static int mei_open(struct inode *inode, struct file *file)
 {
 	struct mei_cl *cl;
 	struct mei_device *dev;
-	unsigned long cl_id;
 	int err;
 
 	err = -ENODEV;
@@ -133,24 +132,9 @@ static int mei_open(struct inode *inode, struct file *file)
 		goto out_unlock;
 	}
 
-	cl_id = find_first_zero_bit(dev->host_clients_map, MEI_CLIENTS_MAX);
-	if (cl_id >= MEI_CLIENTS_MAX) {
-		dev_err(&dev->pdev->dev, "client_id exceded %d",
-				MEI_CLIENTS_MAX) ;
+	err = mei_cl_link(cl, MEI_HOST_CLIENT_ID_ANY);
+	if (err)
 		goto out_unlock;
-	}
-
-	cl->host_client_id  = cl_id;
-
-	dev_dbg(&dev->pdev->dev, "client_id = %d\n", cl->host_client_id);
-
-	dev->open_handle_count++;
-
-	list_add_tail(&cl->link, &dev->file_list);
-
-	set_bit(cl->host_client_id, dev->host_clients_map);
-	cl->state = MEI_FILE_INITIALIZING;
-	cl->sm_state = 0;
 
 	file->private_data = cl;
 	mutex_unlock(&dev->device_lock);
@@ -209,6 +193,7 @@ static int mei_release(struct inode *inode, struct file *file)
 	}
 	mei_cl_unlink(cl);
 
+
 	/* free read cb */
 	cb = NULL;
 	if (cl->read_cb) {
@@ -991,7 +976,13 @@ static void mei_remove(struct pci_dev *pdev)
 
 	/* remove entry if already in list */
 	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
+
+	if (dev->open_handle_count > 0)
+		dev->open_handle_count--;
 	mei_cl_unlink(&dev->wd_cl);
+
+	if (dev->open_handle_count > 0)
+		dev->open_handle_count--;
 	mei_cl_unlink(&dev->iamthif_cl);
 
 	dev->iamthif_current_cb = NULL;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 285e8e0..dcd7a44 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -67,16 +67,16 @@ extern const u8 mei_wd_state_independence_msg[3][4];
  * Number of File descriptors/handles
  * that can be opened to the driver.
  *
- * Limit to 253: 256 Total Clients
+ * Limit to 255: 256 Total Clients
  * minus internal client for MEI Bus Messags
- * minus internal client for AMTHI
- * minus internal client for Watchdog
  */
-#define  MEI_MAX_OPEN_HANDLE_COUNT (MEI_CLIENTS_MAX - 3)
+#define  MEI_MAX_OPEN_HANDLE_COUNT (MEI_CLIENTS_MAX - 1)
 
 /*
  * Internal Clients Number
  */
+#define MEI_HOST_CLIENT_ID_ANY        (-1)
+#define MEI_HBM_HOST_CLIENT_ID         0 /* not used, just for documentation */
 #define MEI_WD_HOST_CLIENT_ID          1
 #define MEI_IAMTHIF_HOST_CLIENT_ID     2
 
@@ -339,7 +339,7 @@ void mei_timer(struct work_struct *work);
  */
 void mei_amthif_reset_params(struct mei_device *dev);
 
-void mei_amthif_host_init(struct mei_device *dev);
+int mei_amthif_host_init(struct mei_device *dev);
 
 int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *priv_cb);
 
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index bfcbcc8..77b3820 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -64,30 +64,41 @@ static void mei_wd_set_start_timeout(struct mei_device *dev, u16 timeout)
  */
 int mei_wd_host_init(struct mei_device *dev)
 {
-	int id;
-	mei_cl_init(&dev->wd_cl, dev);
+	struct mei_cl *cl = &dev->wd_cl;
+	int i;
+	int ret;
+
+	mei_cl_init(cl, dev);
 
-	/* look for WD client and connect to it */
-	dev->wd_cl.state = MEI_FILE_DISCONNECTED;
 	dev->wd_timeout = MEI_WD_DEFAULT_TIMEOUT;
 	dev->wd_state = MEI_WD_IDLE;
 
-	/* Connect WD ME client to the host client */
-	id = mei_cl_link_me(&dev->wd_cl,
-				&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
 
-	if (id < 0) {
+	/* check for valid client id */
+	i = mei_me_cl_by_uuid(dev, &mei_wd_guid);
+	if (i < 0) {
 		dev_info(&dev->pdev->dev, "wd: failed to find the client\n");
 		return -ENOENT;
 	}
 
-	if (mei_hbm_cl_connect_req(dev, &dev->wd_cl)) {
+	cl->me_client_id = dev->me_clients[i].client_id;
+
+	ret = mei_cl_link(cl, MEI_WD_HOST_CLIENT_ID);
+
+	if (ret < 0) {
+		dev_info(&dev->pdev->dev, "wd: failed link client\n");
+		return -ENOENT;
+	}
+
+	cl->state = MEI_FILE_CONNECTING;
+
+	if (mei_hbm_cl_connect_req(dev, cl)) {
 		dev_err(&dev->pdev->dev, "wd: failed to connect to the client\n");
-		dev->wd_cl.state = MEI_FILE_DISCONNECTED;
-		dev->wd_cl.host_client_id = 0;
+		cl->state = MEI_FILE_DISCONNECTED;
+		cl->host_client_id = 0;
 		return -EIO;
 	}
-	dev->wd_cl.timer_count = MEI_CONNECT_TIMEOUT;
+	cl->timer_count = MEI_CONNECT_TIMEOUT;
 
 	return 0;
 }
-- 
1.7.4.4

