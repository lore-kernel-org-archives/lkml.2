Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3AHVIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:29241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab3AHVIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604856"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 02/21] mei: move client functions to client.c
Date: Tue,  8 Jan 2013 23:07:13 +0200
Message-Id: <1357679252-12958-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file now contains me and host client functions
and also io callback helpers
We also kill iorw.c which is no longer needed

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Makefile             |    2 +-
 drivers/misc/mei/{iorw.c => client.c} |  377 +++++++++++++++++++++++++++++++--
 drivers/misc/mei/init.c               |  252 ----------------------
 drivers/misc/mei/interface.c          |   96 ---------
 4 files changed, 361 insertions(+), 366 deletions(-)
 rename drivers/misc/mei/{iorw.c => client.c} (50%)

diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 1f382a5..67f543a 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -7,7 +7,7 @@ mei-objs := init.o
 mei-objs += hbm.o
 mei-objs += interrupt.o
 mei-objs += interface.o
-mei-objs += iorw.o
 mei-objs += main.o
 mei-objs += amthif.o
 mei-objs += wd.o
+mei-objs += client.o
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/client.c
similarity index 50%
rename from drivers/misc/mei/iorw.c
rename to drivers/misc/mei/client.c
index 4328c2d..19f6207 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/client.c
@@ -14,24 +14,10 @@
  *
  */
 
-
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/errno.h>
-#include <linux/types.h>
-#include <linux/fcntl.h>
-#include <linux/aio.h>
 #include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/ioctl.h>
-#include <linux/cdev.h>
-#include <linux/list.h>
-#include <linux/delay.h>
 #include <linux/sched.h>
-#include <linux/uuid.h>
-#include <linux/jiffies.h>
-#include <linux/uaccess.h>
-
+#include <linux/wait.h>
+#include <linux/delay.h>
 
 #include <linux/mei.h>
 
@@ -39,6 +25,24 @@
 #include "hbm.h"
 #include "interface.h"
 
+
+/**
+ * mei_io_list_flush - removes list entry belonging to cl.
+ *
+ * @list:  An instance of our list structure
+ * @cl: host client
+ */
+void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
+{
+	struct mei_cl_cb *cb;
+	struct mei_cl_cb *next;
+
+	list_for_each_entry_safe(cb, next, &list->list, list) {
+		if (cb->cl && mei_cl_cmp_id(cl, cb->cl))
+			list_del(&cb->list);
+	}
+}
+
 /**
  * mei_io_cb_free - free mei_cb_private related memory
  *
@@ -53,6 +57,7 @@ void mei_io_cb_free(struct mei_cl_cb *cb)
 	kfree(cb->response_buffer.data);
 	kfree(cb);
 }
+
 /**
  * mei_io_cb_init - allocate and initialize io callback
  *
@@ -77,7 +82,6 @@ struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp)
 	return cb;
 }
 
-
 /**
  * mei_io_cb_alloc_req_buf - allocate request buffer
  *
@@ -128,6 +132,50 @@ int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
 }
 
 
+
+/**
+ * mei_cl_flush_queues - flushes queue lists belonging to cl.
+ *
+ * @dev: the device structure
+ * @cl: host client
+ */
+int mei_cl_flush_queues(struct mei_cl *cl)
+{
+	if (!cl || !cl->dev)
+		return -EINVAL;
+
+	dev_dbg(&cl->dev->pdev->dev, "remove list entry belonging to cl\n");
+	mei_io_list_flush(&cl->dev->read_list, cl);
+	mei_io_list_flush(&cl->dev->write_list, cl);
+	mei_io_list_flush(&cl->dev->write_waiting_list, cl);
+	mei_io_list_flush(&cl->dev->ctrl_wr_list, cl);
+	mei_io_list_flush(&cl->dev->ctrl_rd_list, cl);
+	mei_io_list_flush(&cl->dev->amthif_cmd_list, cl);
+	mei_io_list_flush(&cl->dev->amthif_rd_complete_list, cl);
+	return 0;
+}
+
+/**
+ * mei_me_cl_by_uuid - locate index of me client
+ *
+ * @dev: mei device
+ * returns me client index or -ENOENT if not found
+ */
+int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
+{
+	int i, res = -ENOENT;
+
+	for (i = 0; i < dev->me_clients_num; ++i)
+		if (uuid_le_cmp(*uuid,
+				dev->me_clients[i].props.protocol_name) == 0) {
+			res = i;
+			break;
+		}
+
+	return res;
+}
+
+
 /**
  * mei_me_cl_by_id return index to me_clients for client_id
  *
@@ -155,6 +203,301 @@ int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
 }
 
 /**
+ * mei_cl_init - initializes intialize cl.
+ *
+ * @cl: host client to be initialized
+ * @dev: mei device
+ */
+void mei_cl_init(struct mei_cl *cl, struct mei_device *dev)
+{
+	memset(cl, 0, sizeof(struct mei_cl));
+	init_waitqueue_head(&cl->wait);
+	init_waitqueue_head(&cl->rx_wait);
+	init_waitqueue_head(&cl->tx_wait);
+	INIT_LIST_HEAD(&cl->link);
+	cl->reading_state = MEI_IDLE;
+	cl->writing_state = MEI_IDLE;
+	cl->dev = dev;
+}
+
+/**
+ * mei_cl_allocate - allocates cl  structure and sets it up.
+ *
+ * @dev: mei device
+ * returns  The allocated file or NULL on failure
+ */
+struct mei_cl *mei_cl_allocate(struct mei_device *dev)
+{
+	struct mei_cl *cl;
+
+	cl = kmalloc(sizeof(struct mei_cl), GFP_KERNEL);
+	if (!cl)
+		return NULL;
+
+	mei_cl_init(cl, dev);
+
+	return cl;
+}
+
+
+/**
+ * mei_me_cl_link - create link between host and me clinet and add
+ *   me_cl to the list
+ *
+ * @dev: the device structure
+ * @cl: link between me and host client assocated with opened file descriptor
+ * @uuid: uuid of ME client
+ * @client_id: id of the host client
+ *
+ * returns ME client index if ME client
+ *	-EINVAL on incorrect values
+ *	-ENONET if client not found
+ */
+int mei_me_cl_link(struct mei_device *dev, struct mei_cl *cl,
+			const uuid_le *uuid, u8 host_cl_id)
+{
+	int i;
+
+	if (!dev || !cl || !uuid)
+		return -EINVAL;
+
+	/* check for valid client id */
+	i = mei_me_cl_by_uuid(dev, uuid);
+	if (i >= 0) {
+		cl->me_client_id = dev->me_clients[i].client_id;
+		cl->state = MEI_FILE_CONNECTING;
+		cl->host_client_id = host_cl_id;
+
+		list_add_tail(&cl->link, &dev->file_list);
+		return (u8)i;
+	}
+
+	return -ENOENT;
+}
+/**
+ * mei_me_cl_unlink - remove me_cl from the list
+ *
+ * @dev: the device structure
+ * @host_client_id: host client id to be removed
+ */
+void mei_me_cl_unlink(struct mei_device *dev, struct mei_cl *cl)
+{
+	struct mei_cl *pos, *next;
+	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
+		if (cl->host_client_id == pos->host_client_id) {
+			dev_dbg(&dev->pdev->dev, "remove host client = %d, ME client = %d\n",
+					pos->host_client_id, pos->me_client_id);
+			list_del_init(&pos->link);
+			break;
+		}
+	}
+}
+
+
+void mei_host_client_init(struct work_struct *work)
+{
+	struct mei_device *dev = container_of(work,
+					      struct mei_device, init_work);
+	struct mei_client_properties *client_props;
+	int i;
+
+	mutex_lock(&dev->device_lock);
+
+	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
+	dev->open_handle_count = 0;
+
+	/*
+	 * Reserving the first three client IDs
+	 * 0: Reserved for MEI Bus Message communications
+	 * 1: Reserved for Watchdog
+	 * 2: Reserved for AMTHI
+	 */
+	bitmap_set(dev->host_clients_map, 0, 3);
+
+	for (i = 0; i < dev->me_clients_num; i++) {
+		client_props = &dev->me_clients[i].props;
+
+		if (!uuid_le_cmp(client_props->protocol_name, mei_amthi_guid))
+			mei_amthif_host_init(dev);
+		else if (!uuid_le_cmp(client_props->protocol_name, mei_wd_guid))
+			mei_wd_host_init(dev);
+	}
+
+	dev->dev_state = MEI_DEV_ENABLED;
+
+	mutex_unlock(&dev->device_lock);
+}
+
+
+/**
+ * mei_disconnect_host_client - sends disconnect message to fw from host client.
+ *
+ * @dev: the device structure
+ * @cl: private data of the file object
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
+{
+	struct mei_cl_cb *cb;
+	int rets, err;
+
+	if (!dev || !cl)
+		return -ENODEV;
+
+	if (cl->state != MEI_FILE_DISCONNECTING)
+		return 0;
+
+	cb = mei_io_cb_init(cl, NULL);
+	if (!cb)
+		return -ENOMEM;
+
+	cb->fop_type = MEI_FOP_CLOSE;
+	if (dev->mei_host_buffer_is_empty) {
+		dev->mei_host_buffer_is_empty = false;
+		if (mei_hbm_cl_disconnect_req(dev, cl)) {
+			rets = -ENODEV;
+			dev_err(&dev->pdev->dev, "failed to disconnect.\n");
+			goto free;
+		}
+		mdelay(10); /* Wait for hardware disconnection ready */
+		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
+	} else {
+		dev_dbg(&dev->pdev->dev, "add disconnect cb to control write list\n");
+		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
+
+	}
+	mutex_unlock(&dev->device_lock);
+
+	err = wait_event_timeout(dev->wait_recvd_msg,
+			MEI_FILE_DISCONNECTED == cl->state,
+			mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
+
+	mutex_lock(&dev->device_lock);
+	if (MEI_FILE_DISCONNECTED == cl->state) {
+		rets = 0;
+		dev_dbg(&dev->pdev->dev, "successfully disconnected from FW client.\n");
+	} else {
+		rets = -ENODEV;
+		if (MEI_FILE_DISCONNECTED != cl->state)
+			dev_dbg(&dev->pdev->dev, "wrong status client disconnect.\n");
+
+		if (err)
+			dev_dbg(&dev->pdev->dev,
+					"wait failed disconnect err=%08x\n",
+					err);
+
+		dev_dbg(&dev->pdev->dev, "failed to disconnect from FW client.\n");
+	}
+
+	mei_io_list_flush(&dev->ctrl_rd_list, cl);
+	mei_io_list_flush(&dev->ctrl_wr_list, cl);
+free:
+	mei_io_cb_free(cb);
+	return rets;
+}
+
+
+/**
+ * mei_other_client_is_connecting - checks if other
+ *    client with the same client id is connected.
+ *
+ * @dev: the device structure
+ * @cl: private data of the file object
+ *
+ * returns 1 if other client is connected, 0 - otherwise.
+ */
+int mei_other_client_is_connecting(struct mei_device *dev,
+				struct mei_cl *cl)
+{
+	struct mei_cl *cl_pos = NULL;
+	struct mei_cl *cl_next = NULL;
+
+	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
+		if ((cl_pos->state == MEI_FILE_CONNECTING) &&
+			(cl_pos != cl) &&
+			cl->me_client_id == cl_pos->me_client_id)
+			return 1;
+
+	}
+	return 0;
+}
+
+/**
+ * mei_flow_ctrl_creds - checks flow_control credentials.
+ *
+ * @dev: the device structure
+ * @cl: private data of the file object
+ *
+ * returns 1 if mei_flow_ctrl_creds >0, 0 - otherwise.
+ *	-ENOENT if mei_cl is not present
+ *	-EINVAL if single_recv_buf == 0
+ */
+int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl)
+{
+	int i;
+
+	if (!dev->me_clients_num)
+		return 0;
+
+	if (cl->mei_flow_ctrl_creds > 0)
+		return 1;
+
+	for (i = 0; i < dev->me_clients_num; i++) {
+		struct mei_me_client  *me_cl = &dev->me_clients[i];
+		if (me_cl->client_id == cl->me_client_id) {
+			if (me_cl->mei_flow_ctrl_creds) {
+				if (WARN_ON(me_cl->props.single_recv_buf == 0))
+					return -EINVAL;
+				return 1;
+			} else {
+				return 0;
+			}
+		}
+	}
+	return -ENOENT;
+}
+
+/**
+ * mei_flow_ctrl_reduce - reduces flow_control.
+ *
+ * @dev: the device structure
+ * @cl: private data of the file object
+ * @returns
+ *	0 on success
+ *	-ENOENT when me client is not found
+ *	-EINVAL when ctrl credits are <= 0
+ */
+int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl)
+{
+	int i;
+
+	if (!dev->me_clients_num)
+		return -ENOENT;
+
+	for (i = 0; i < dev->me_clients_num; i++) {
+		struct mei_me_client  *me_cl = &dev->me_clients[i];
+		if (me_cl->client_id == cl->me_client_id) {
+			if (me_cl->props.single_recv_buf != 0) {
+				if (WARN_ON(me_cl->mei_flow_ctrl_creds <= 0))
+					return -EINVAL;
+				dev->me_clients[i].mei_flow_ctrl_creds--;
+			} else {
+				if (WARN_ON(cl->mei_flow_ctrl_creds <= 0))
+					return -EINVAL;
+				cl->mei_flow_ctrl_creds--;
+			}
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+
+
+/**
  * mei_ioctl_connect_client - the connect to fw client IOCTL function
  *
  * @dev: the device structure
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 55895fc..6c1f1f8 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -22,7 +22,6 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
-#include "hbm.h"
 #include "interface.h"
 
 const char *mei_dev_state_str(int state)
@@ -45,47 +44,6 @@ const char *mei_dev_state_str(int state)
 
 
 
-/**
- * mei_io_list_flush - removes list entry belonging to cl.
- *
- * @list:  An instance of our list structure
- * @cl: private data of the file object
- */
-void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl)
-{
-	struct mei_cl_cb *pos;
-	struct mei_cl_cb *next;
-
-	list_for_each_entry_safe(pos, next, &list->list, list) {
-		if (pos->cl) {
-			if (mei_cl_cmp_id(cl, pos->cl))
-				list_del(&pos->list);
-		}
-	}
-}
-/**
- * mei_cl_flush_queues - flushes queue lists belonging to cl.
- *
- * @dev: the device structure
- * @cl: private data of the file object
- */
-int mei_cl_flush_queues(struct mei_cl *cl)
-{
-	if (!cl || !cl->dev)
-		return -EINVAL;
-
-	dev_dbg(&cl->dev->pdev->dev, "remove list entry belonging to cl\n");
-	mei_io_list_flush(&cl->dev->read_list, cl);
-	mei_io_list_flush(&cl->dev->write_list, cl);
-	mei_io_list_flush(&cl->dev->write_waiting_list, cl);
-	mei_io_list_flush(&cl->dev->ctrl_wr_list, cl);
-	mei_io_list_flush(&cl->dev->ctrl_rd_list, cl);
-	mei_io_list_flush(&cl->dev->amthif_cmd_list, cl);
-	mei_io_list_flush(&cl->dev->amthif_rd_complete_list, cl);
-	return 0;
-}
-
-
 
 /**
  * init_mei_device - allocates and initializes the mei device structure
@@ -360,215 +318,5 @@ void mei_allocate_me_clients_storage(struct mei_device *dev)
 	return ;
 }
 
-void mei_host_client_init(struct work_struct *work)
-{
-	struct mei_device *dev = container_of(work,
-					      struct mei_device, init_work);
-	struct mei_client_properties *client_props;
-	int i;
-
-	mutex_lock(&dev->device_lock);
-
-	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
-	dev->open_handle_count = 0;
-
-	/*
-	 * Reserving the first three client IDs
-	 * 0: Reserved for MEI Bus Message communications
-	 * 1: Reserved for Watchdog
-	 * 2: Reserved for AMTHI
-	 */
-	bitmap_set(dev->host_clients_map, 0, 3);
-
-	for (i = 0; i < dev->me_clients_num; i++) {
-		client_props = &dev->me_clients[i].props;
-
-		if (!uuid_le_cmp(client_props->protocol_name, mei_amthi_guid))
-			mei_amthif_host_init(dev);
-		else if (!uuid_le_cmp(client_props->protocol_name, mei_wd_guid))
-			mei_wd_host_init(dev);
-	}
 
-	dev->dev_state = MEI_DEV_ENABLED;
-
-	mutex_unlock(&dev->device_lock);
-}
-
-
-/**
- * mei_init_file_private - initializes private file structure.
- *
- * @priv: private file structure to be initialized
- * @file: the file structure
- */
-void mei_cl_init(struct mei_cl *priv, struct mei_device *dev)
-{
-	memset(priv, 0, sizeof(struct mei_cl));
-	init_waitqueue_head(&priv->wait);
-	init_waitqueue_head(&priv->rx_wait);
-	init_waitqueue_head(&priv->tx_wait);
-	INIT_LIST_HEAD(&priv->link);
-	priv->reading_state = MEI_IDLE;
-	priv->writing_state = MEI_IDLE;
-	priv->dev = dev;
-}
-
-int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid)
-{
-	int i, res = -ENOENT;
-
-	for (i = 0; i < dev->me_clients_num; ++i)
-		if (uuid_le_cmp(*cuuid,
-				dev->me_clients[i].props.protocol_name) == 0) {
-			res = i;
-			break;
-		}
-
-	return res;
-}
-
-
-/**
- * mei_me_cl_link - create link between host and me clinet and add
- *   me_cl to the list
- *
- * @dev: the device structure
- * @cl: link between me and host client assocated with opened file descriptor
- * @cuuid: uuid of ME client
- * @client_id: id of the host client
- *
- * returns ME client index if ME client
- *	-EINVAL on incorrect values
- *	-ENONET if client not found
- */
-int mei_me_cl_link(struct mei_device *dev, struct mei_cl *cl,
-			const uuid_le *cuuid, u8 host_cl_id)
-{
-	int i;
-
-	if (!dev || !cl || !cuuid)
-		return -EINVAL;
-
-	/* check for valid client id */
-	i = mei_me_cl_by_uuid(dev, cuuid);
-	if (i >= 0) {
-		cl->me_client_id = dev->me_clients[i].client_id;
-		cl->state = MEI_FILE_CONNECTING;
-		cl->host_client_id = host_cl_id;
-
-		list_add_tail(&cl->link, &dev->file_list);
-		return (u8)i;
-	}
-
-	return -ENOENT;
-}
-/**
- * mei_me_cl_unlink - remove me_cl from the list
- *
- * @dev: the device structure
- * @host_client_id: host client id to be removed
- */
-void mei_me_cl_unlink(struct mei_device *dev, struct mei_cl *cl)
-{
-	struct mei_cl *pos, *next;
-	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
-		if (cl->host_client_id == pos->host_client_id) {
-			dev_dbg(&dev->pdev->dev, "remove host client = %d, ME client = %d\n",
-					pos->host_client_id, pos->me_client_id);
-			list_del_init(&pos->link);
-			break;
-		}
-	}
-}
-
-/**
- * mei_alloc_file_private - allocates a private file structure and sets it up.
- * @file: the file structure
- *
- * returns  The allocated file or NULL on failure
- */
-struct mei_cl *mei_cl_allocate(struct mei_device *dev)
-{
-	struct mei_cl *cl;
-
-	cl = kmalloc(sizeof(struct mei_cl), GFP_KERNEL);
-	if (!cl)
-		return NULL;
-
-	mei_cl_init(cl, dev);
-
-	return cl;
-}
-
-
-
-/**
- * mei_disconnect_host_client - sends disconnect message to fw from host client.
- *
- * @dev: the device structure
- * @cl: private data of the file object
- *
- * Locking: called under "dev->device_lock" lock
- *
- * returns 0 on success, <0 on failure.
- */
-int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
-{
-	struct mei_cl_cb *cb;
-	int rets, err;
-
-	if (!dev || !cl)
-		return -ENODEV;
-
-	if (cl->state != MEI_FILE_DISCONNECTING)
-		return 0;
-
-	cb = mei_io_cb_init(cl, NULL);
-	if (!cb)
-		return -ENOMEM;
-
-	cb->fop_type = MEI_FOP_CLOSE;
-	if (dev->mei_host_buffer_is_empty) {
-		dev->mei_host_buffer_is_empty = false;
-		if (mei_hbm_cl_disconnect_req(dev, cl)) {
-			rets = -ENODEV;
-			dev_err(&dev->pdev->dev, "failed to disconnect.\n");
-			goto free;
-		}
-		mdelay(10); /* Wait for hardware disconnection ready */
-		list_add_tail(&cb->list, &dev->ctrl_rd_list.list);
-	} else {
-		dev_dbg(&dev->pdev->dev, "add disconnect cb to control write list\n");
-		list_add_tail(&cb->list, &dev->ctrl_wr_list.list);
-
-	}
-	mutex_unlock(&dev->device_lock);
-
-	err = wait_event_timeout(dev->wait_recvd_msg,
-			MEI_FILE_DISCONNECTED == cl->state,
-			mei_secs_to_jiffies(MEI_CL_CONNECT_TIMEOUT));
-
-	mutex_lock(&dev->device_lock);
-	if (MEI_FILE_DISCONNECTED == cl->state) {
-		rets = 0;
-		dev_dbg(&dev->pdev->dev, "successfully disconnected from FW client.\n");
-	} else {
-		rets = -ENODEV;
-		if (MEI_FILE_DISCONNECTED != cl->state)
-			dev_dbg(&dev->pdev->dev, "wrong status client disconnect.\n");
-
-		if (err)
-			dev_dbg(&dev->pdev->dev,
-					"wait failed disconnect err=%08x\n",
-					err);
-
-		dev_dbg(&dev->pdev->dev, "failed to disconnect from FW client.\n");
-	}
-
-	mei_io_list_flush(&dev->ctrl_rd_list, cl);
-	mei_io_list_flush(&dev->ctrl_wr_list, cl);
-free:
-	mei_io_cb_free(cb);
-	return rets;
-}
 
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 155bd7e..3cb0cff 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -297,99 +297,3 @@ void mei_read_slots(struct mei_device *dev, unsigned char *buffer,
 	mei_hcsr_set(dev);
 }
 
-/**
- * mei_flow_ctrl_creds - checks flow_control credentials.
- *
- * @dev: the device structure
- * @cl: private data of the file object
- *
- * returns 1 if mei_flow_ctrl_creds >0, 0 - otherwise.
- *	-ENOENT if mei_cl is not present
- *	-EINVAL if single_recv_buf == 0
- */
-int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl)
-{
-	int i;
-
-	if (!dev->me_clients_num)
-		return 0;
-
-	if (cl->mei_flow_ctrl_creds > 0)
-		return 1;
-
-	for (i = 0; i < dev->me_clients_num; i++) {
-		struct mei_me_client  *me_cl = &dev->me_clients[i];
-		if (me_cl->client_id == cl->me_client_id) {
-			if (me_cl->mei_flow_ctrl_creds) {
-				if (WARN_ON(me_cl->props.single_recv_buf == 0))
-					return -EINVAL;
-				return 1;
-			} else {
-				return 0;
-			}
-		}
-	}
-	return -ENOENT;
-}
-
-/**
- * mei_flow_ctrl_reduce - reduces flow_control.
- *
- * @dev: the device structure
- * @cl: private data of the file object
- * @returns
- *	0 on success
- *	-ENOENT when me client is not found
- *	-EINVAL when ctrl credits are <= 0
- */
-int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl)
-{
-	int i;
-
-	if (!dev->me_clients_num)
-		return -ENOENT;
-
-	for (i = 0; i < dev->me_clients_num; i++) {
-		struct mei_me_client  *me_cl = &dev->me_clients[i];
-		if (me_cl->client_id == cl->me_client_id) {
-			if (me_cl->props.single_recv_buf != 0) {
-				if (WARN_ON(me_cl->mei_flow_ctrl_creds <= 0))
-					return -EINVAL;
-				dev->me_clients[i].mei_flow_ctrl_creds--;
-			} else {
-				if (WARN_ON(cl->mei_flow_ctrl_creds <= 0))
-					return -EINVAL;
-				cl->mei_flow_ctrl_creds--;
-			}
-			return 0;
-		}
-	}
-	return -ENOENT;
-}
-
-
-/**
- * mei_other_client_is_connecting - checks if other
- *    client with the same client id is connected.
- *
- * @dev: the device structure
- * @cl: private data of the file object
- *
- * returns 1 if other client is connected, 0 - otherwise.
- */
-int mei_other_client_is_connecting(struct mei_device *dev,
-				struct mei_cl *cl)
-{
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
-
-	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
-		if ((cl_pos->state == MEI_FILE_CONNECTING) &&
-			(cl_pos != cl) &&
-			cl->me_client_id == cl_pos->me_client_id)
-			return 1;
-
-	}
-	return 0;
-}
-
-- 
1.7.4.4

