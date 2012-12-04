Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab2LDOGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:06:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:42613 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178Ab2LDOFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975769"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 14/15] mei: add common prefix to hbm function
Date: Tue,  4 Dec 2012 16:04:43 +0200
Message-Id: <1354629884-3202-14-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. use mei_hbm_ for basic host bus message function
2. use mei_hbm_cl prefix for host bus messages that operation
on behalf of a client

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |    7 +++--
 drivers/misc/mei/hbm.c       |   56 ++++++++++++++++++++++++------------------
 drivers/misc/mei/init.c      |    4 +-
 drivers/misc/mei/interface.h |   11 +++++---
 drivers/misc/mei/interrupt.c |   10 +++---
 drivers/misc/mei/iorw.c      |    4 +-
 drivers/misc/mei/mei_dev.h   |    9 ------
 drivers/misc/mei/wd.c        |    2 +-
 8 files changed, 53 insertions(+), 50 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index f9d458c..6e3cd31 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -98,7 +98,7 @@ void mei_amthif_host_init(struct mei_device *dev)
 
 	dev->iamthif_msg_buf = msg_buf;
 
-	if (mei_connect(dev, &dev->iamthif_cl)) {
+	if (mei_hbm_cl_connect_req(dev, &dev->iamthif_cl)) {
 		dev_dbg(&dev->pdev->dev, "Failed to connect to AMTHI client\n");
 		dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
 		dev->iamthif_cl.host_client_id = 0;
@@ -558,7 +558,7 @@ int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
 		return -EMSGSIZE;
 	}
 	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
-	if (mei_send_flow_control(dev, &dev->iamthif_cl)) {
+	if (mei_hbm_cl_flow_control_req(dev, &dev->iamthif_cl)) {
 		dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
 		return -EIO;
 	}
@@ -630,7 +630,8 @@ static bool mei_clear_list(struct mei_device *dev,
 			if (dev->iamthif_current_cb == cb_pos) {
 				dev->iamthif_current_cb = NULL;
 				/* send flow control to iamthif client */
-				mei_send_flow_control(dev, &dev->iamthif_cl);
+				mei_hbm_cl_flow_control_req(dev,
+							&dev->iamthif_cl);
 			}
 			/* free all allocated buffers */
 			mei_io_cb_free(cb_pos);
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index e9ba51d..3c99140 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -59,13 +59,11 @@ bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
 
 
 /**
- * host_start_message - mei host sends start message.
+ * mei_hbm_start_req - sends start request message.
  *
  * @dev: the device structure
- *
- * returns none.
  */
-void mei_host_start_message(struct mei_device *dev)
+void mei_hbm_start_req(struct mei_device *dev)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_host_version_request *start_req;
@@ -92,13 +90,13 @@ void mei_host_start_message(struct mei_device *dev)
 }
 
 /**
- * host_enum_clients_message - host sends enumeration client request message.
+ * mei_hbm_enum_clients_req - sends enumeration client request message.
  *
  * @dev: the device structure
  *
  * returns none.
  */
-void mei_host_enum_clients_message(struct mei_device *dev)
+static void mei_hbm_enum_clients_req(struct mei_device *dev)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_host_enum_request *enum_req;
@@ -120,8 +118,15 @@ void mei_host_enum_clients_message(struct mei_device *dev)
 	return;
 }
 
+/**
+ * mei_hbm_prop_requsest - request property for a single client
+ *
+ * @dev: the device structure
+ *
+ * returns none.
+ */
 
-int mei_host_client_enumerate(struct mei_device *dev)
+static int mei_hbm_prop_req(struct mei_device *dev)
 {
 
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
@@ -191,14 +196,14 @@ static void mei_hbm_stop_req_prepare(struct mei_device *dev,
 }
 
 /**
- * mei_send_flow_control - sends flow control to fw.
+ * mei_hbm_cl_flow_control_req - sends flow control requst.
  *
  * @dev: the device structure
- * @cl: private data of the file object
+ * @cl: client info
  *
  * This function returns -EIO on write failure
  */
-int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
+int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_flow_control);
@@ -213,14 +218,14 @@ int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_disconnect - sends disconnect message to fw.
+ * mei_hbm_cl_disconnect_req - sends disconnect message to fw.
  *
  * @dev: the device structure
- * @cl: private data of the file object
+ * @cl: a client to disconnect from
  *
  * This function returns -EIO on write failure
  */
-int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
+int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
@@ -232,14 +237,14 @@ int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_connect - sends connect message to fw.
+ * mei_hbm_cl_connect_req - send connection request to specific me client
  *
  * @dev: the device structure
- * @cl: private data of the file object
+ * @cl: a client to connect to
  *
- * This function returns -EIO on write failure
+ * returns -EIO on write failure
  */
-int mei_connect(struct mei_device *dev, struct mei_cl *cl)
+int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
@@ -251,12 +256,13 @@ int mei_connect(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
- * mei_client_disconnect_request - disconnects from request irq routine
+ * mei_client_disconnect_request - disconnect request initiated by me
+ *  host sends disoconnect response
  *
  * @dev: the device structure.
- * @disconnect_req: disconnect request bus message.
+ * @disconnect_req: disconnect request bus message from the me
  */
-static void mei_client_disconnect_request(struct mei_device *dev,
+static void mei_hbm_fw_disconnect_req(struct mei_device *dev,
 		struct hbm_client_connect_request *disconnect_req)
 {
 	struct mei_cl *cl, *next;
@@ -327,7 +333,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
 		    dev->init_clients_state == MEI_START_MESSAGE) {
 			dev->init_clients_timer = 0;
-			mei_host_enum_clients_message(dev);
+			mei_hbm_enum_clients_req(dev);
 		} else {
 			dev->recvd_msg = false;
 			dev_dbg(&dev->pdev->dev, "reset due to received hbm: host start\n");
@@ -390,7 +396,8 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		dev->me_client_index++;
 		dev->me_client_presentation_num++;
 
-		mei_host_client_enumerate(dev);
+		/* request property for the next client */
+		mei_hbm_prop_req(dev);
 
 		break;
 
@@ -406,7 +413,8 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 				dev->init_clients_state =
 					MEI_CLIENT_PROPERTIES_MESSAGE;
 
-				mei_host_client_enumerate(dev);
+				/* first property reqeust */
+				mei_hbm_prop_req(dev);
 		} else {
 			dev_dbg(&dev->pdev->dev, "reset due to received host enumeration clients response bus message.\n");
 			mei_reset(dev, 1);
@@ -423,7 +431,7 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 	case CLIENT_DISCONNECT_REQ_CMD:
 		/* search for client */
 		disconnect_req = (struct hbm_client_connect_request *)mei_msg;
-		mei_client_disconnect_request(dev, disconnect_req);
+		mei_hbm_fw_disconnect_req(dev, disconnect_req);
 		break;
 
 	case ME_STOP_REQ_CMD:
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 0536170..418a85f 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -529,9 +529,9 @@ int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl)
 	cb->fop_type = MEI_FOP_CLOSE;
 	if (dev->mei_host_buffer_is_empty) {
 		dev->mei_host_buffer_is_empty = false;
-		if (mei_disconnect(dev, cl)) {
+		if (mei_hbm_cl_disconnect_req(dev, cl)) {
 			rets = -ENODEV;
-			dev_dbg(&dev->pdev->dev, "failed to call mei_disconnect.\n");
+			dev_err(&dev->pdev->dev, "failed to disconnect.\n");
 			goto free;
 		}
 		mdelay(10); /* Wait for hardware disconnection ready */
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index ca73299..90a3dfd 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -69,12 +69,15 @@ void mei_watchdog_register(struct mei_device *dev);
  */
 void mei_watchdog_unregister(struct mei_device *dev);
 
+int mei_other_client_is_connecting(struct mei_device *dev, struct mei_cl *cl);
 int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl);
 
-int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl);
+void mei_hbm_start_req(struct mei_device *dev);
 
-int mei_disconnect(struct mei_device *dev, struct mei_cl *cl);
-int mei_other_client_is_connecting(struct mei_device *dev, struct mei_cl *cl);
-int mei_connect(struct mei_device *dev, struct mei_cl *cl);
+int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl);
+int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl);
+int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl);
+
+void mei_host_client_init(struct work_struct *work);
 
 #endif /* _MEI_INTERFACE_H_ */
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 9cbf148..eb744cc 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -157,7 +157,7 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 
 	*slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
 
-	if (mei_disconnect(dev, cl)) {
+	if (mei_hbm_cl_disconnect_req(dev, cl)) {
 		cl->status = 0;
 		cb_pos->buf_idx = 0;
 		list_move_tail(&cb_pos->list, &cmpl_list->list);
@@ -407,7 +407,7 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 
 	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
 
-	if (mei_send_flow_control(dev, cl)) {
+	if (mei_hbm_cl_flow_control_req(dev, cl)) {
 		cl->status = -ENODEV;
 		cb_pos->buf_idx = 0;
 		list_move_tail(&cb_pos->list, &cmpl_list->list);
@@ -443,8 +443,8 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 	}
 
 	cl->state = MEI_FILE_CONNECTING;
-	 *slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
-	if (mei_connect(dev, cl)) {
+	*slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
+	if (mei_hbm_cl_connect_req(dev, cl)) {
 		cl->status = -ENODEV;
 		cb_pos->buf_idx = 0;
 		list_del(&cb_pos->list);
@@ -927,7 +927,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 			/* link is established
 			 * start sending messages.
 			 */
-			mei_host_start_message(dev);
+			mei_hbm_start_req(dev);
 			mutex_unlock(&dev->device_lock);
 			return IRQ_HANDLED;
 		} else {
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index 7ccc3d8..d8e08bc 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -258,7 +258,7 @@ int mei_ioctl_connect_client(struct file *file,
 	    && !mei_other_client_is_connecting(dev, cl)) {
 		dev_dbg(&dev->pdev->dev, "Sending Connect Message\n");
 		dev->mei_host_buffer_is_empty = false;
-		if (mei_connect(dev, cl)) {
+		if (mei_hbm_cl_connect_req(dev, cl)) {
 			dev_dbg(&dev->pdev->dev, "Sending connect message - failed\n");
 			rets = -ENODEV;
 			goto end;
@@ -350,7 +350,7 @@ int mei_start_read(struct mei_device *dev, struct mei_cl *cl)
 	cl->read_cb = cb;
 	if (dev->mei_host_buffer_is_empty) {
 		dev->mei_host_buffer_is_empty = false;
-		if (mei_send_flow_control(dev, cl)) {
+		if (mei_hbm_cl_flow_control_req(dev, cl)) {
 			rets = -ENODEV;
 			goto err;
 		}
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 1017e54..3da92c7 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -383,15 +383,6 @@ static inline bool mei_cl_cmp_id(const struct mei_cl *cl1,
 }
 
 
-
-/*
- * MEI Host Client Functions
- */
-void mei_host_start_message(struct mei_device *dev);
-void mei_host_enum_clients_message(struct mei_device *dev);
-int mei_host_client_enumerate(struct mei_device *dev);
-void mei_host_client_init(struct work_struct *work);
-
 /*
  *  MEI interrupt functions prototype
  */
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 9851de4..3c5b2b0 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -79,7 +79,7 @@ int mei_wd_host_init(struct mei_device *dev)
 		return -ENOENT;
 	}
 
-	if (mei_connect(dev, &dev->wd_cl)) {
+	if (mei_hbm_cl_connect_req(dev, &dev->wd_cl)) {
 		dev_err(&dev->pdev->dev, "wd: failed to connect to the client\n");
 		dev->wd_cl.state = MEI_FILE_DISCONNECTED;
 		dev->wd_cl.host_client_id = 0;
-- 
1.7.4.4

