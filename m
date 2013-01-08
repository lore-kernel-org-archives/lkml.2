Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3AHVIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:08:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:26469 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab3AHVIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:08:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,433,1355126400"; 
   d="scan'208";a="243604865"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 03/21] mei: fix client functions names
Date: Tue,  8 Jan 2013 23:07:14 +0200
Message-Id: <1357679252-12958-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
References: <1357679252-12958-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use common prefix for function names:

mei_cl_  - for host clients
mei_me_  - for me clients
mei_io_  - for io callback functions

Because mei_cl holds mei_device back pointer
we can also drop the dev argument from the client
functions

add client.h header to export the clients API

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |    9 +-
 drivers/misc/mei/client.c    |  221 ++++++++++++++++++++++++++----------------
 drivers/misc/mei/client.h    |   97 ++++++++++++++++++
 drivers/misc/mei/init.c      |    6 +-
 drivers/misc/mei/interface.h |    8 --
 drivers/misc/mei/interrupt.c |   11 +-
 drivers/misc/mei/main.c      |   47 +++-------
 drivers/misc/mei/mei_dev.h   |   53 ----------
 drivers/misc/mei/wd.c        |   13 ++-
 9 files changed, 267 insertions(+), 198 deletions(-)
 create mode 100644 drivers/misc/mei/client.h

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index add4254..cbc9c4e 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -36,6 +36,7 @@
 #include "mei_dev.h"
 #include "hbm.h"
 #include "interface.h"
+#include "client.h"
 
 const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
 						0xa8, 0x46, 0xe0, 0xff, 0x65,
@@ -73,7 +74,7 @@ void mei_amthif_host_init(struct mei_device *dev)
 	dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
 
 	/* find ME amthi client */
-	i = mei_me_cl_link(dev, &dev->iamthif_cl,
+	i = mei_cl_link_me(&dev->iamthif_cl,
 			    &mei_amthi_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
 	if (i < 0) {
 		dev_info(&dev->pdev->dev, "failed to find iamthif client.\n");
@@ -280,7 +281,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 	memcpy(dev->iamthif_msg_buf, cb->request_buffer.data,
 	       cb->request_buffer.size);
 
-	ret = mei_flow_ctrl_creds(dev, &dev->iamthif_cl);
+	ret = mei_cl_flow_ctrl_creds(&dev->iamthif_cl);
 	if (ret < 0)
 		return ret;
 
@@ -304,7 +305,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 			return -ENODEV;
 
 		if (mei_hdr.msg_complete) {
-			if (mei_flow_ctrl_reduce(dev, &dev->iamthif_cl))
+			if (mei_cl_flow_ctrl_reduce(&dev->iamthif_cl))
 				return -ENODEV;
 			dev->iamthif_flow_control_pending = true;
 			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
@@ -467,7 +468,7 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 			return -ENODEV;
 	}
 
-	if (mei_flow_ctrl_reduce(dev, cl))
+	if (mei_cl_flow_ctrl_reduce(cl))
 		return -ENODEV;
 
 	dev->iamthif_msg_buf_index += mei_hdr.length;
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 19f6207..e300637 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -24,6 +24,54 @@
 #include "mei_dev.h"
 #include "hbm.h"
 #include "interface.h"
+#include "client.h"
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
+/**
+ * mei_me_cl_by_id return index to me_clients for client_id
+ *
+ * @dev: the device structure
+ * @client_id: me client id
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * returns index on success, -ENOENT on failure.
+ */
+
+int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
+{
+	int i;
+	for (i = 0; i < dev->me_clients_num; i++)
+		if (dev->me_clients[i].client_id == client_id)
+			break;
+	if (WARN_ON(dev->me_clients[i].client_id != client_id))
+		return -ENOENT;
+
+	if (i == dev->me_clients_num)
+		return -ENOENT;
+
+	return i;
+}
 
 
 /**
@@ -141,7 +189,7 @@ int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length)
  */
 int mei_cl_flush_queues(struct mei_cl *cl)
 {
-	if (!cl || !cl->dev)
+	if (WARN_ON(!cl || !cl->dev))
 		return -EINVAL;
 
 	dev_dbg(&cl->dev->pdev->dev, "remove list entry belonging to cl\n");
@@ -155,52 +203,6 @@ int mei_cl_flush_queues(struct mei_cl *cl)
 	return 0;
 }
 
-/**
- * mei_me_cl_by_uuid - locate index of me client
- *
- * @dev: mei device
- * returns me client index or -ENOENT if not found
- */
-int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *uuid)
-{
-	int i, res = -ENOENT;
-
-	for (i = 0; i < dev->me_clients_num; ++i)
-		if (uuid_le_cmp(*uuid,
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
- * mei_me_cl_by_id return index to me_clients for client_id
- *
- * @dev: the device structure
- * @client_id: me client id
- *
- * Locking: called under "dev->device_lock" lock
- *
- * returns index on success, -ENOENT on failure.
- */
-
-int mei_me_cl_by_id(struct mei_device *dev, u8 client_id)
-{
-	int i;
-	for (i = 0; i < dev->me_clients_num; i++)
-		if (dev->me_clients[i].client_id == client_id)
-			break;
-	if (WARN_ON(dev->me_clients[i].client_id != client_id))
-		return -ENOENT;
-
-	if (i == dev->me_clients_num)
-		return -ENOENT;
-
-	return i;
-}
 
 /**
  * mei_cl_init - initializes intialize cl.
@@ -239,12 +241,29 @@ struct mei_cl *mei_cl_allocate(struct mei_device *dev)
 	return cl;
 }
 
+/**
+ * mei_cl_find_read_cb - find this cl's callback in the read list
+ *
+ * @dev: device structure
+ * returns cb on success, NULL on error
+ */
+struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
+{
+	struct mei_device *dev = cl->dev;
+	struct mei_cl_cb *cb = NULL;
+	struct mei_cl_cb *next = NULL;
+
+	list_for_each_entry_safe(cb, next, &dev->read_list.list, list)
+		if (mei_cl_cmp_id(cl, cb->cl))
+			return cb;
+	return NULL;
+}
+
 
 /**
  * mei_me_cl_link - create link between host and me clinet and add
  *   me_cl to the list
  *
- * @dev: the device structure
  * @cl: link between me and host client assocated with opened file descriptor
  * @uuid: uuid of ME client
  * @client_id: id of the host client
@@ -253,14 +272,16 @@ struct mei_cl *mei_cl_allocate(struct mei_device *dev)
  *	-EINVAL on incorrect values
  *	-ENONET if client not found
  */
-int mei_me_cl_link(struct mei_device *dev, struct mei_cl *cl,
-			const uuid_le *uuid, u8 host_cl_id)
+int mei_cl_link_me(struct mei_cl *cl, const uuid_le *uuid, u8 host_cl_id)
 {
+	struct mei_device *dev;
 	int i;
 
-	if (!dev || !cl || !uuid)
+	if (WARN_ON(!cl || !cl->dev || !uuid))
 		return -EINVAL;
 
+	dev = cl->dev;
+
 	/* check for valid client id */
 	i = mei_me_cl_by_uuid(dev, uuid);
 	if (i >= 0) {
@@ -275,22 +296,30 @@ int mei_me_cl_link(struct mei_device *dev, struct mei_cl *cl,
 	return -ENOENT;
 }
 /**
- * mei_me_cl_unlink - remove me_cl from the list
+ * mei_cl_unlink - remove me_cl from the list
  *
  * @dev: the device structure
  * @host_client_id: host client id to be removed
  */
-void mei_me_cl_unlink(struct mei_device *dev, struct mei_cl *cl)
+int mei_cl_unlink(struct mei_cl *cl)
 {
+	struct mei_device *dev;
 	struct mei_cl *pos, *next;
+
+	if (WARN_ON(!cl || !cl->dev))
+		return -EINVAL;
+
+	dev = cl->dev;
+
 	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
 		if (cl->host_client_id == pos->host_client_id) {
 			dev_dbg(&dev->pdev->dev, "remove host client = %d, ME client = %d\n",
-					pos->host_client_id, pos->me_client_id);
+				pos->host_client_id, pos->me_client_id);
 			list_del_init(&pos->link);
 			break;
 		}
 	}
+	return 0;
 }
 
 
@@ -330,23 +359,25 @@ void mei_host_client_init(struct work_struct *work)
 
 
 /**
- * mei_disconnect_host_client - sends disconnect message to fw from host client.
+ * mei_cl_disconnect - disconnect host clinet form the me one
  *
- * @dev: the device structure
- * @cl: private data of the file object
+ * @cl: host client
  *
  * Locking: called under "dev->device_lock" lock
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
+int mei_cl_disconnect(struct mei_cl *cl)
 {
+	struct mei_device *dev;
 	struct mei_cl_cb *cb;
 	int rets, err;
 
-	if (!dev || !cl)
+	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
 
+	dev = cl->dev;
+
 	if (cl->state != MEI_FILE_DISCONNECTING)
 		return 0;
 
@@ -401,32 +432,36 @@ free:
 
 
 /**
- * mei_other_client_is_connecting - checks if other
- *    client with the same client id is connected.
+ * mei_cl_is_other_connecting - checks if other
+ *    client with the same me client id is connecting
  *
- * @dev: the device structure
  * @cl: private data of the file object
  *
- * returns 1 if other client is connected, 0 - otherwise.
+ * returns ture if other client is connected, 0 - otherwise.
  */
-int mei_other_client_is_connecting(struct mei_device *dev,
-				struct mei_cl *cl)
+bool mei_cl_is_other_connecting(struct mei_cl *cl)
 {
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
+	struct mei_device *dev;
+	struct mei_cl *pos;
+	struct mei_cl *next;
 
-	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
-		if ((cl_pos->state == MEI_FILE_CONNECTING) &&
-			(cl_pos != cl) &&
-			cl->me_client_id == cl_pos->me_client_id)
-			return 1;
+	if (WARN_ON(!cl || !cl->dev))
+		return false;
+
+	dev = cl->dev;
+
+	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
+		if ((pos->state == MEI_FILE_CONNECTING) &&
+		    (pos != cl) && cl->me_client_id == pos->me_client_id)
+			return true;
 
 	}
-	return 0;
+
+	return false;
 }
 
 /**
- * mei_flow_ctrl_creds - checks flow_control credentials.
+ * mei_cl_flow_ctrl_creds - checks flow_control credits for cl.
  *
  * @dev: the device structure
  * @cl: private data of the file object
@@ -435,10 +470,16 @@ int mei_other_client_is_connecting(struct mei_device *dev,
  *	-ENOENT if mei_cl is not present
  *	-EINVAL if single_recv_buf == 0
  */
-int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl)
+int mei_cl_flow_ctrl_creds(struct mei_cl *cl)
 {
+	struct mei_device *dev;
 	int i;
 
+	if (WARN_ON(!cl || !cl->dev))
+		return -EINVAL;
+
+	dev = cl->dev;
+
 	if (!dev->me_clients_num)
 		return 0;
 
@@ -461,7 +502,7 @@ int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_flow_ctrl_reduce - reduces flow_control.
+ * mei_cl_flow_ctrl_reduce - reduces flow_control.
  *
  * @dev: the device structure
  * @cl: private data of the file object
@@ -470,10 +511,16 @@ int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl)
  *	-ENOENT when me client is not found
  *	-EINVAL when ctrl credits are <= 0
  */
-int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl)
+int mei_cl_flow_ctrl_reduce(struct mei_cl *cl)
 {
+	struct mei_device *dev;
 	int i;
 
+	if (WARN_ON(!cl || !cl->dev))
+		return -EINVAL;
+
+	dev = cl->dev;
+
 	if (!dev->me_clients_num)
 		return -ENOENT;
 
@@ -571,7 +618,7 @@ int mei_ioctl_connect_client(struct file *file,
 			goto end;
 		}
 		clear_bit(cl->host_client_id, dev->host_clients_map);
-		mei_me_cl_unlink(dev, cl);
+		mei_cl_unlink(cl);
 
 		kfree(cl);
 		cl = NULL;
@@ -598,8 +645,8 @@ int mei_ioctl_connect_client(struct file *file,
 	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
 	client->protocol_version = dev->me_clients[i].props.protocol_version;
 	dev_dbg(&dev->pdev->dev, "Can connect?\n");
-	if (dev->mei_host_buffer_is_empty
-	    && !mei_other_client_is_connecting(dev, cl)) {
+	if (dev->mei_host_buffer_is_empty &&
+	    !mei_cl_is_other_connecting(cl)) {
 		dev_dbg(&dev->pdev->dev, "Sending Connect Message\n");
 		dev->mei_host_buffer_is_empty = false;
 		if (mei_hbm_cl_connect_req(dev, cl)) {
@@ -650,20 +697,24 @@ end:
 }
 
 /**
- * mei_start_read - the start read client message function.
+ * mei_cl_start_read - the start read client message function.
  *
- * @dev: the device structure
- * @if_num:  minor number
- * @cl: private data of the file object
+ * @cl: host client
  *
  * returns 0 on success, <0 on failure.
  */
-int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
+int mei_cl_read_start(struct mei_cl *cl)
 {
+	struct mei_device *dev;
 	struct mei_cl_cb *cb;
 	int rets;
 	int i;
 
+	if (WARN_ON(!cl || !cl->dev))
+		return -ENODEV;
+
+	dev = cl->dev;
+
 	if (cl->state != MEI_FILE_CONNECTED)
 		return -ENODEV;
 
diff --git a/drivers/misc/mei/client.h b/drivers/misc/mei/client.h
new file mode 100644
index 0000000..8dfd052
--- /dev/null
+++ b/drivers/misc/mei/client.h
@@ -0,0 +1,97 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2012, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#ifndef _MEI_CLIENT_H_
+#define _MEI_CLIENT_H_
+
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/poll.h>
+#include <linux/mei.h>
+
+#include "mei_dev.h"
+
+int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid);
+int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
+
+/*
+ * MEI IO Functions
+ */
+struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp);
+void mei_io_cb_free(struct mei_cl_cb *priv_cb);
+int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length);
+int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length);
+
+
+/**
+ * mei_io_list_init - Sets up a queue list.
+ *
+ * @list: An instance cl callback structure
+ */
+static inline void mei_io_list_init(struct mei_cl_cb *list)
+{
+	INIT_LIST_HEAD(&list->list);
+}
+void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl);
+
+/*
+ * MEI Host Client Functions
+ */
+
+struct mei_cl *mei_cl_allocate(struct mei_device *dev);
+void mei_cl_init(struct mei_cl *cl, struct mei_device *dev);
+
+
+int mei_cl_link_me(struct mei_cl *cl, const uuid_le *uuid, u8 host_cl_id);
+int mei_cl_unlink(struct mei_cl *cl);
+
+int mei_cl_flush_queues(struct mei_cl *cl);
+struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl);
+
+/**
+ * mei_cl_cmp_id - tells if file private data have same id
+ *
+ * @fe1: private data of 1. file object
+ * @fe2: private data of 2. file object
+ *
+ * returns true  - if ids are the same and not NULL
+ */
+static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
+				const struct mei_cl *cl2)
+{
+	return cl1 && cl2 &&
+		(cl1->host_client_id == cl2->host_client_id) &&
+		(cl1->me_client_id == cl2->me_client_id);
+}
+
+
+int mei_cl_flow_ctrl_creds(struct mei_cl *cl);
+
+int mei_cl_flow_ctrl_reduce(struct mei_cl *cl);
+/*
+ *  MEI input output function prototype
+ */
+bool mei_cl_is_other_connecting(struct mei_cl *cl);
+int mei_cl_disconnect(struct mei_cl *cl);
+
+int mei_cl_read_start(struct mei_cl *cl);
+
+int mei_cl_connect(struct mei_cl *cl, struct file *file);
+
+void mei_host_client_init(struct work_struct *work);
+
+
+#endif /* _MEI_CLIENT_H_ */
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 6c1f1f8..7028dbd 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -23,6 +23,7 @@
 
 #include "mei_dev.h"
 #include "interface.h"
+#include "client.h"
 
 const char *mei_dev_state_str(int state)
 {
@@ -241,9 +242,8 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		}
 		/* remove entry if already in list */
 		dev_dbg(&dev->pdev->dev, "remove iamthif and wd from the file list.\n");
-		mei_me_cl_unlink(dev, &dev->wd_cl);
-
-		mei_me_cl_unlink(dev, &dev->iamthif_cl);
+		mei_cl_unlink(&dev->wd_cl);
+		mei_cl_unlink(&dev->iamthif_cl);
 
 		mei_amthif_reset_params(dev);
 		memset(&dev->wr_ext_msg, 0, sizeof(dev->wr_ext_msg));
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index 3d06c08..01d1ef5 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -50,7 +50,6 @@ static inline unsigned char mei_data2slots(size_t length)
 int mei_count_full_read_slots(struct mei_device *dev);
 
 
-int mei_flow_ctrl_creds(struct mei_device *dev, struct mei_cl *cl);
 
 
 
@@ -69,12 +68,5 @@ void mei_watchdog_register(struct mei_device *dev);
  */
 void mei_watchdog_unregister(struct mei_device *dev);
 
-int mei_other_client_is_connecting(struct mei_device *dev, struct mei_cl *cl);
-int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl);
-
-void mei_host_client_init(struct work_struct *work);
-
-
-
 
 #endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 2495e35..0a141af 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -26,6 +26,7 @@
 #include "mei_dev.h"
 #include "hbm.h"
 #include "interface.h"
+#include "client.h"
 
 
 /**
@@ -297,7 +298,7 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 		return -ENODEV;
 	}
 
-	if (mei_flow_ctrl_reduce(dev, cl))
+	if (mei_cl_flow_ctrl_reduce(cl))
 		return -ENODEV;
 
 	cl->status = 0;
@@ -478,10 +479,10 @@ static int mei_irq_thread_write_handler(struct mei_device *dev,
 	}
 	if (dev->dev_state == MEI_DEV_ENABLED) {
 		if (dev->wd_pending &&
-		    mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
+		    mei_cl_flow_ctrl_creds(&dev->wd_cl) > 0) {
 			if (mei_wd_send(dev))
 				dev_dbg(&dev->pdev->dev, "wd send failed.\n");
-			else if (mei_flow_ctrl_reduce(dev, &dev->wd_cl))
+			else if (mei_cl_flow_ctrl_reduce(&dev->wd_cl))
 				return -ENODEV;
 
 			dev->wd_pending = false;
@@ -520,7 +521,7 @@ static int mei_irq_thread_write_handler(struct mei_device *dev,
 			break;
 		case MEI_FOP_IOCTL:
 			/* connect message */
-			if (mei_other_client_is_connecting(dev, cl))
+			if (mei_cl_is_other_connecting(cl))
 				continue;
 			ret = _mei_irq_thread_ioctl(dev, &slots, pos,
 						cl, cmpl_list);
@@ -540,7 +541,7 @@ static int mei_irq_thread_write_handler(struct mei_device *dev,
 		cl = pos->cl;
 		if (cl == NULL)
 			continue;
-		if (mei_flow_ctrl_creds(dev, cl) <= 0) {
+		if (mei_cl_flow_ctrl_creds(cl) <= 0) {
 			dev_dbg(&dev->pdev->dev,
 				"No flow control credentials for client %d, not sending.\n",
 				cl->host_client_id);
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index da94260..95f05d9 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -41,6 +41,7 @@
 
 #include "mei_dev.h"
 #include "interface.h"
+#include "client.h"
 
 /* AMT device is a singleton on the platform */
 static struct pci_dev *mei_pdev;
@@ -91,28 +92,6 @@ static DEFINE_MUTEX(mei_mutex);
 
 
 /**
- * find_read_list_entry - find read list entry
- *
- * @dev: device structure
- * @file: pointer to file structure
- *
- * returns cb on success, NULL on error
- */
-static struct mei_cl_cb *find_read_list_entry(
-		struct mei_device *dev,
-		struct mei_cl *cl)
-{
-	struct mei_cl_cb *pos = NULL;
-	struct mei_cl_cb *next = NULL;
-
-	dev_dbg(&dev->pdev->dev, "remove read_list CB\n");
-	list_for_each_entry_safe(pos, next, &dev->read_list.list, list)
-		if (mei_cl_cmp_id(cl, pos->cl))
-			return pos;
-	return NULL;
-}
-
-/**
  * mei_open - the open function
  *
  * @inode: pointer to inode structure
@@ -217,7 +196,7 @@ static int mei_release(struct inode *inode, struct file *file)
 		    "ME client = %d\n",
 		    cl->host_client_id,
 		    cl->me_client_id);
-		rets = mei_disconnect_host_client(dev, cl);
+		rets = mei_cl_disconnect(cl);
 	}
 	mei_cl_flush_queues(cl);
 	dev_dbg(&dev->pdev->dev, "remove client host client = %d, ME client = %d\n",
@@ -228,12 +207,12 @@ static int mei_release(struct inode *inode, struct file *file)
 		clear_bit(cl->host_client_id, dev->host_clients_map);
 		dev->open_handle_count--;
 	}
-	mei_me_cl_unlink(dev, cl);
+	mei_cl_unlink(cl);
 
 	/* free read cb */
 	cb = NULL;
 	if (cl->read_cb) {
-		cb = find_read_list_entry(dev, cl);
+		cb = mei_cl_find_read_cb(cl);
 		/* Remove entry from read list */
 		if (cb)
 			list_del(&cb->list);
@@ -323,7 +302,7 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 		goto out;
 	}
 
-	err = mei_start_read(dev, cl);
+	err = mei_cl_read_start(cl);
 	if (err && err != -EBUSY) {
 		dev_dbg(&dev->pdev->dev,
 			"mei start read failure with status = %d\n", err);
@@ -394,7 +373,7 @@ copy_buffer:
 		goto out;
 
 free:
-	cb_pos = find_read_list_entry(dev, cl);
+	cb_pos = mei_cl_find_read_cb(cl);
 	/* Remove entry from read list */
 	if (cb_pos)
 		list_del(&cb_pos->list);
@@ -476,7 +455,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	/* free entry used in read */
 	if (cl->reading_state == MEI_READ_COMPLETE) {
 		*offset = 0;
-		write_cb = find_read_list_entry(dev, cl);
+		write_cb = mei_cl_find_read_cb(cl);
 		if (write_cb) {
 			list_del(&write_cb->list);
 			mei_io_cb_free(write_cb);
@@ -531,7 +510,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 	dev_dbg(&dev->pdev->dev, "host client = %d, ME client = %d\n",
 	    cl->host_client_id, cl->me_client_id);
-	rets = mei_flow_ctrl_creds(dev, cl);
+	rets = mei_cl_flow_ctrl_creds(cl);
 	if (rets < 0)
 		goto err;
 
@@ -565,7 +544,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 
 out:
 	if (mei_hdr.msg_complete) {
-		if (mei_flow_ctrl_reduce(dev, cl)) {
+		if (mei_cl_flow_ctrl_reduce(cl)) {
 			rets = -ENODEV;
 			goto err;
 		}
@@ -904,11 +883,11 @@ static void mei_remove(struct pci_dev *pdev)
 
 	if (dev->iamthif_cl.state == MEI_FILE_CONNECTED) {
 		dev->iamthif_cl.state = MEI_FILE_DISCONNECTING;
-		mei_disconnect_host_client(dev, &dev->iamthif_cl);
+		mei_cl_disconnect(&dev->iamthif_cl);
 	}
 	if (dev->wd_cl.state == MEI_FILE_CONNECTED) {
 		dev->wd_cl.state = MEI_FILE_DISCONNECTING;
-		mei_disconnect_host_client(dev, &dev->wd_cl);
+		mei_cl_disconnect(&dev->wd_cl);
 	}
 
 	/* Unregistering watchdog device */
@@ -916,8 +895,8 @@ static void mei_remove(struct pci_dev *pdev)
 
 	/* remove entry if already in list */
 	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
-	mei_me_cl_unlink(dev, &dev->wd_cl);
-	mei_me_cl_unlink(dev, &dev->iamthif_cl);
+	mei_cl_unlink(&dev->wd_cl);
+	mei_cl_unlink(&dev->iamthif_cl);
 
 	dev->iamthif_current_cb = NULL;
 	dev->me_clients_num = 0;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 1b54e67..5a1ac9a 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -329,59 +329,9 @@ void mei_reset(struct mei_device *dev, int interrupts);
 int mei_hw_init(struct mei_device *dev);
 int mei_task_initialize_clients(void *data);
 int mei_initialize_clients(struct mei_device *dev);
-int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl);
 void mei_allocate_me_clients_storage(struct mei_device *dev);
 
 
-int mei_me_cl_link(struct mei_device *dev, struct mei_cl *cl,
-			const uuid_le *cguid, u8 host_client_id);
-void mei_me_cl_unlink(struct mei_device *dev, struct mei_cl *cl);
-int mei_me_cl_by_uuid(const struct mei_device *dev, const uuid_le *cuuid);
-int mei_me_cl_by_id(struct mei_device *dev, u8 client_id);
-
-/*
- * MEI IO Functions
- */
-struct mei_cl_cb *mei_io_cb_init(struct mei_cl *cl, struct file *fp);
-void mei_io_cb_free(struct mei_cl_cb *priv_cb);
-int mei_io_cb_alloc_req_buf(struct mei_cl_cb *cb, size_t length);
-int mei_io_cb_alloc_resp_buf(struct mei_cl_cb *cb, size_t length);
-
-
-/**
- * mei_io_list_init - Sets up a queue list.
- *
- * @list: An instance cl callback structure
- */
-static inline void mei_io_list_init(struct mei_cl_cb *list)
-{
-	INIT_LIST_HEAD(&list->list);
-}
-void mei_io_list_flush(struct mei_cl_cb *list, struct mei_cl *cl);
-
-/*
- * MEI ME Client Functions
- */
-
-struct mei_cl *mei_cl_allocate(struct mei_device *dev);
-void mei_cl_init(struct mei_cl *cl, struct mei_device *dev);
-int mei_cl_flush_queues(struct mei_cl *cl);
-/**
- * mei_cl_cmp_id - tells if file private data have same id
- *
- * @fe1: private data of 1. file object
- * @fe2: private data of 2. file object
- *
- * returns true  - if ids are the same and not NULL
- */
-static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
-				const struct mei_cl *cl2)
-{
-	return cl1 && cl2 &&
-		(cl1->host_client_id == cl2->host_client_id) &&
-		(cl1->me_client_id == cl2->me_client_id);
-}
-
 
 /*
  *  MEI interrupt functions prototype
@@ -395,9 +345,6 @@ void mei_timer(struct work_struct *work);
  */
 int mei_ioctl_connect_client(struct file *file,
 			struct mei_connect_client_data *data);
-
-int mei_start_read(struct mei_device *dev, struct mei_cl *cl);
-
 /*
  * AMTHIF - AMT Host Interface Functions
  */
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 9814bc1..5ad5225 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -26,6 +26,7 @@
 #include "mei_dev.h"
 #include "hbm.h"
 #include "interface.h"
+#include "client.h"
 
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
 static const u8 mei_stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
@@ -72,7 +73,7 @@ int mei_wd_host_init(struct mei_device *dev)
 	dev->wd_state = MEI_WD_IDLE;
 
 	/* Connect WD ME client to the host client */
-	id = mei_me_cl_link(dev, &dev->wd_cl,
+	id = mei_cl_link_me(&dev->wd_cl,
 				&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
 
 	if (id < 0) {
@@ -141,7 +142,7 @@ int mei_wd_stop(struct mei_device *dev)
 
 	dev->wd_state = MEI_WD_STOPPING;
 
-	ret = mei_flow_ctrl_creds(dev, &dev->wd_cl);
+	ret = mei_cl_flow_ctrl_creds(&dev->wd_cl);
 	if (ret < 0)
 		goto out;
 
@@ -150,7 +151,7 @@ int mei_wd_stop(struct mei_device *dev)
 		dev->mei_host_buffer_is_empty = false;
 
 		if (!mei_wd_send(dev)) {
-			ret = mei_flow_ctrl_reduce(dev, &dev->wd_cl);
+			ret = mei_cl_flow_ctrl_reduce(&dev->wd_cl);
 			if (ret)
 				goto out;
 		} else {
@@ -271,7 +272,7 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 
 	/* Check if we can send the ping to HW*/
 	if (dev->mei_host_buffer_is_empty &&
-		mei_flow_ctrl_creds(dev, &dev->wd_cl) > 0) {
+	    mei_cl_flow_ctrl_creds(&dev->wd_cl) > 0) {
 
 		dev->mei_host_buffer_is_empty = false;
 		dev_dbg(&dev->pdev->dev, "wd: sending ping\n");
@@ -282,9 +283,9 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 			goto end;
 		}
 
-		if (mei_flow_ctrl_reduce(dev, &dev->wd_cl)) {
+		if (mei_cl_flow_ctrl_reduce(&dev->wd_cl)) {
 			dev_err(&dev->pdev->dev,
-				"wd: mei_flow_ctrl_reduce() failed.\n");
+				"wd: mei_cl_flow_ctrl_reduce() failed.\n");
 			ret = -EIO;
 			goto end;
 		}
-- 
1.7.4.4

