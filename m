Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab2LDOGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:06:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:42613 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2LDOFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975776"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 15/15] mei: move hbm responses from interrupt.c to hbm.c
Date: Tue,  4 Dec 2012 16:04:44 +0200
Message-Id: <1354629884-3202-15-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add common prefix mei_hbm_ to all handlers
and made them static
drop now useless function  same_flow_addr

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c       |  189 +++++++++++++++++++++++++++++++++++++-
 drivers/misc/mei/interrupt.c |  208 ------------------------------------------
 drivers/misc/mei/mei_dev.h   |    9 --
 3 files changed, 186 insertions(+), 220 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 3c99140..6b58b0a 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -59,6 +59,33 @@ bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
 
 
 /**
+ * is_treat_specially_client - checks if the message belongs
+ * to the file private data.
+ *
+ * @cl: private data of the file object
+ * @rs: connect response bus message
+ *
+ */
+static bool is_treat_specially_client(struct mei_cl *cl,
+		struct hbm_client_connect_response *rs)
+{
+	if (mei_hbm_cl_addr_equal(cl, rs)) {
+		if (!rs->status) {
+			cl->state = MEI_FILE_CONNECTED;
+			cl->status = 0;
+
+		} else {
+			cl->state = MEI_FILE_DISCONNECTED;
+			cl->status = -ENODEV;
+		}
+		cl->timer_count = 0;
+
+		return true;
+	}
+	return false;
+}
+
+/**
  * mei_hbm_start_req - sends start request message.
  *
  * @dev: the device structure
@@ -218,6 +245,66 @@ int mei_hbm_cl_flow_control_req(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
+ * add_single_flow_creds - adds single buffer credentials.
+ *
+ * @file: private data ot the file object.
+ * @flow: flow control.
+ */
+static void mei_hbm_add_single_flow_creds(struct mei_device *dev,
+				  struct hbm_flow_control *flow)
+{
+	struct mei_me_client *client;
+	int i;
+
+	for (i = 0; i < dev->me_clients_num; i++) {
+		client = &dev->me_clients[i];
+		if (client && flow->me_addr == client->client_id) {
+			if (client->props.single_recv_buf) {
+				client->mei_flow_ctrl_creds++;
+				dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single).\n",
+				    flow->me_addr);
+				dev_dbg(&dev->pdev->dev, "flow control credentials =%d.\n",
+				    client->mei_flow_ctrl_creds);
+			} else {
+				BUG();	/* error in flow control */
+			}
+		}
+	}
+}
+
+/**
+ * mei_hbm_cl_flow_control_res - flow control response from me
+ *
+ * @dev: the device structure
+ * @flow_control: flow control response bus message
+ */
+static void mei_hbm_cl_flow_control_res(struct mei_device *dev,
+		struct hbm_flow_control *flow_control)
+{
+	struct mei_cl *cl = NULL;
+	struct mei_cl *next = NULL;
+
+	if (!flow_control->host_addr) {
+		/* single receive buffer */
+		mei_hbm_add_single_flow_creds(dev, flow_control);
+		return;
+	}
+
+	/* normal connection */
+	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
+		if (mei_hbm_cl_addr_equal(cl, flow_control)) {
+			cl->mei_flow_ctrl_creds++;
+			dev_dbg(&dev->pdev->dev, "flow ctrl msg for host %d ME %d.\n",
+				flow_control->host_addr, flow_control->me_addr);
+			dev_dbg(&dev->pdev->dev, "flow control credentials = %d.\n",
+				    cl->mei_flow_ctrl_creds);
+				break;
+		}
+	}
+}
+
+
+/**
  * mei_hbm_cl_disconnect_req - sends disconnect message to fw.
  *
  * @dev: the device structure
@@ -237,6 +324,48 @@ int mei_hbm_cl_disconnect_req(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
+ * mei_hbm_cl_disconnect_res - disconnect response from ME
+ *
+ * @dev: the device structure
+ * @rs: disconnect response bus message
+ */
+static void mei_hbm_cl_disconnect_res(struct mei_device *dev,
+		struct hbm_client_connect_response *rs)
+{
+	struct mei_cl *cl;
+	struct mei_cl_cb *pos = NULL, *next = NULL;
+
+	dev_dbg(&dev->pdev->dev,
+			"disconnect_response:\n"
+			"ME Client = %d\n"
+			"Host Client = %d\n"
+			"Status = %d\n",
+			rs->me_addr,
+			rs->host_addr,
+			rs->status);
+
+	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
+		cl = pos->cl;
+
+		if (!cl) {
+			list_del(&pos->list);
+			return;
+		}
+
+		dev_dbg(&dev->pdev->dev, "list_for_each_entry_safe in ctrl_rd_list.\n");
+		if (mei_hbm_cl_addr_equal(cl, rs)) {
+			list_del(&pos->list);
+			if (!rs->status)
+				cl->state = MEI_FILE_DISCONNECTED;
+
+			cl->status = 0;
+			cl->timer_count = 0;
+			break;
+		}
+	}
+}
+
+/**
  * mei_hbm_cl_connect_req - send connection request to specific me client
  *
  * @dev: the device structure
@@ -256,6 +385,60 @@ int mei_hbm_cl_connect_req(struct mei_device *dev, struct mei_cl *cl)
 }
 
 /**
+ * mei_hbm_cl_connect_res - connect resposne from the ME
+ *
+ * @dev: the device structure
+ * @rs: connect response bus message
+ */
+static void mei_hbm_cl_connect_res(struct mei_device *dev,
+		struct hbm_client_connect_response *rs)
+{
+
+	struct mei_cl *cl;
+	struct mei_cl_cb *pos = NULL, *next = NULL;
+
+	dev_dbg(&dev->pdev->dev,
+			"connect_response:\n"
+			"ME Client = %d\n"
+			"Host Client = %d\n"
+			"Status = %d\n",
+			rs->me_addr,
+			rs->host_addr,
+			rs->status);
+
+	/* if WD or iamthif client treat specially */
+
+	if (is_treat_specially_client(&dev->wd_cl, rs)) {
+		dev_dbg(&dev->pdev->dev, "successfully connected to WD client.\n");
+		mei_watchdog_register(dev);
+
+		return;
+	}
+
+	if (is_treat_specially_client(&dev->iamthif_cl, rs)) {
+		dev->iamthif_state = MEI_IAMTHIF_IDLE;
+		return;
+	}
+	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
+
+		cl = pos->cl;
+		if (!cl) {
+			list_del(&pos->list);
+			return;
+		}
+		if (pos->fop_type == MEI_FOP_IOCTL) {
+			if (is_treat_specially_client(cl, rs)) {
+				list_del(&pos->list);
+				cl->status = 0;
+				cl->timer_count = 0;
+				break;
+			}
+		}
+	}
+}
+
+
+/**
  * mei_client_disconnect_request - disconnect request initiated by me
  *  host sends disoconnect response
  *
@@ -347,21 +530,21 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 
 	case CLIENT_CONNECT_RES_CMD:
 		connect_res = (struct hbm_client_connect_response *) mei_msg;
-		mei_client_connect_response(dev, connect_res);
+		mei_hbm_cl_connect_res(dev, connect_res);
 		dev_dbg(&dev->pdev->dev, "client connect response message received.\n");
 		wake_up(&dev->wait_recvd_msg);
 		break;
 
 	case CLIENT_DISCONNECT_RES_CMD:
 		disconnect_res = (struct hbm_client_connect_response *) mei_msg;
-		mei_client_disconnect_response(dev, disconnect_res);
+		mei_hbm_cl_disconnect_res(dev, disconnect_res);
 		dev_dbg(&dev->pdev->dev, "client disconnect response message received.\n");
 		wake_up(&dev->wait_recvd_msg);
 		break;
 
 	case MEI_FLOW_CONTROL_CMD:
 		flow_control = (struct hbm_flow_control *) mei_msg;
-		mei_client_flow_control_response(dev, flow_control);
+		mei_hbm_cl_flow_control_res(dev, flow_control);
 		dev_dbg(&dev->pdev->dev, "client flow control response message received.\n");
 		break;
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index eb744cc..a735c8b 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -173,214 +173,6 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 	return 0;
 }
 
-/**
- * is_treat_specially_client - checks if the message belongs
- * to the file private data.
- *
- * @cl: private data of the file object
- * @rs: connect response bus message
- *
- */
-static bool is_treat_specially_client(struct mei_cl *cl,
-		struct hbm_client_connect_response *rs)
-{
-
-	if (cl->host_client_id == rs->host_addr &&
-	    cl->me_client_id == rs->me_addr) {
-		if (!rs->status) {
-			cl->state = MEI_FILE_CONNECTED;
-			cl->status = 0;
-
-		} else {
-			cl->state = MEI_FILE_DISCONNECTED;
-			cl->status = -ENODEV;
-		}
-		cl->timer_count = 0;
-
-		return true;
-	}
-	return false;
-}
-
-/**
- * mei_client_connect_response - connects to response irq routine
- *
- * @dev: the device structure
- * @rs: connect response bus message
- */
-void mei_client_connect_response(struct mei_device *dev,
-		struct hbm_client_connect_response *rs)
-{
-
-	struct mei_cl *cl;
-	struct mei_cl_cb *pos = NULL, *next = NULL;
-
-	dev_dbg(&dev->pdev->dev,
-			"connect_response:\n"
-			"ME Client = %d\n"
-			"Host Client = %d\n"
-			"Status = %d\n",
-			rs->me_addr,
-			rs->host_addr,
-			rs->status);
-
-	/* if WD or iamthif client treat specially */
-
-	if (is_treat_specially_client(&(dev->wd_cl), rs)) {
-		dev_dbg(&dev->pdev->dev, "successfully connected to WD client.\n");
-		mei_watchdog_register(dev);
-
-		return;
-	}
-
-	if (is_treat_specially_client(&(dev->iamthif_cl), rs)) {
-		dev->iamthif_state = MEI_IAMTHIF_IDLE;
-		return;
-	}
-	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
-
-		cl = pos->cl;
-		if (!cl) {
-			list_del(&pos->list);
-			return;
-		}
-		if (pos->fop_type == MEI_FOP_IOCTL) {
-			if (is_treat_specially_client(cl, rs)) {
-				list_del(&pos->list);
-				cl->status = 0;
-				cl->timer_count = 0;
-				break;
-			}
-		}
-	}
-}
-
-/**
- * mei_client_disconnect_response - disconnects from response irq routine
- *
- * @dev: the device structure
- * @rs: disconnect response bus message
- */
-void mei_client_disconnect_response(struct mei_device *dev,
-				    struct hbm_client_connect_response *rs)
-{
-	struct mei_cl *cl;
-	struct mei_cl_cb *pos = NULL, *next = NULL;
-
-	dev_dbg(&dev->pdev->dev,
-			"disconnect_response:\n"
-			"ME Client = %d\n"
-			"Host Client = %d\n"
-			"Status = %d\n",
-			rs->me_addr,
-			rs->host_addr,
-			rs->status);
-
-	list_for_each_entry_safe(pos, next, &dev->ctrl_rd_list.list, list) {
-		cl = pos->cl;
-
-		if (!cl) {
-			list_del(&pos->list);
-			return;
-		}
-
-		dev_dbg(&dev->pdev->dev, "list_for_each_entry_safe in ctrl_rd_list.\n");
-		if (cl->host_client_id == rs->host_addr &&
-		    cl->me_client_id == rs->me_addr) {
-
-			list_del(&pos->list);
-			if (!rs->status)
-				cl->state = MEI_FILE_DISCONNECTED;
-
-			cl->status = 0;
-			cl->timer_count = 0;
-			break;
-		}
-	}
-}
-
-/**
- * same_flow_addr - tells if they have the same address.
- *
- * @file: private data of the file object.
- * @flow: flow control.
- *
- * returns  !=0, same; 0,not.
- */
-static int same_flow_addr(struct mei_cl *cl, struct hbm_flow_control *flow)
-{
-	return (cl->host_client_id == flow->host_addr &&
-		cl->me_client_id == flow->me_addr);
-}
-
-/**
- * add_single_flow_creds - adds single buffer credentials.
- *
- * @file: private data ot the file object.
- * @flow: flow control.
- */
-static void add_single_flow_creds(struct mei_device *dev,
-				  struct hbm_flow_control *flow)
-{
-	struct mei_me_client *client;
-	int i;
-
-	for (i = 0; i < dev->me_clients_num; i++) {
-		client = &dev->me_clients[i];
-		if (client && flow->me_addr == client->client_id) {
-			if (client->props.single_recv_buf) {
-				client->mei_flow_ctrl_creds++;
-				dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single).\n",
-				    flow->me_addr);
-				dev_dbg(&dev->pdev->dev, "flow control credentials =%d.\n",
-				    client->mei_flow_ctrl_creds);
-			} else {
-				BUG();	/* error in flow control */
-			}
-		}
-	}
-}
-
-/**
- * mei_client_flow_control_response - flow control response irq routine
- *
- * @dev: the device structure
- * @flow_control: flow control response bus message
- */
-void mei_client_flow_control_response(struct mei_device *dev,
-		struct hbm_flow_control *flow_control)
-{
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
-
-	if (!flow_control->host_addr) {
-		/* single receive buffer */
-		add_single_flow_creds(dev, flow_control);
-	} else {
-		/* normal connection */
-		list_for_each_entry_safe(cl_pos, cl_next,
-				&dev->file_list, link) {
-			dev_dbg(&dev->pdev->dev, "list_for_each_entry_safe in file_list\n");
-
-			dev_dbg(&dev->pdev->dev, "cl of host client %d ME client %d.\n",
-			    cl_pos->host_client_id,
-			    cl_pos->me_client_id);
-			dev_dbg(&dev->pdev->dev, "flow ctrl msg for host %d ME %d.\n",
-			    flow_control->host_addr,
-			    flow_control->me_addr);
-			if (same_flow_addr(cl_pos, flow_control)) {
-				dev_dbg(&dev->pdev->dev, "recv ctrl msg for host  %d ME %d.\n",
-				    flow_control->host_addr,
-				    flow_control->me_addr);
-				cl_pos->mei_flow_ctrl_creds++;
-				dev_dbg(&dev->pdev->dev, "flow control credentials = %d.\n",
-				    cl_pos->mei_flow_ctrl_creds);
-				break;
-			}
-		}
-	}
-}
-
 
 /**
  * _mei_hb_read - processes read related operation.
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 3da92c7..13ddab8 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -398,15 +398,6 @@ int mei_ioctl_connect_client(struct file *file,
 
 int mei_start_read(struct mei_device *dev, struct mei_cl *cl);
 
-
-void mei_client_disconnect_response(struct mei_device *dev,
-			struct hbm_client_connect_response *rs);
-
-void mei_client_connect_response(struct mei_device *dev,
-		struct hbm_client_connect_response *rs);
-
-void mei_client_flow_control_response(struct mei_device *dev,
-		struct hbm_flow_control *flow_control);
 /*
  * AMTHIF - AMT Host Interface Functions
  */
-- 
1.7.4.4

