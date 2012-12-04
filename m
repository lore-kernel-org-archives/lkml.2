Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2LDOFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:42613 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2LDOFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975752"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 12/15] mei: simplify preparing client host bus messages
Date: Tue,  4 Dec 2012 16:04:41 +0200
Message-Id: <1354629884-3202-12-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a new parrent type mei_hbm_cl_cmd for hbm
command that are send on behalf of specific client
Now we can compat boilerplate code using mei_hbm_cl_hdr
function

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hbm.c |  110 +++++++++++++++++++++++------------------------
 drivers/misc/mei/hw.h  |   16 +++++++
 2 files changed, 70 insertions(+), 56 deletions(-)

diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 2c4c1bb..bc36c23 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -23,6 +23,42 @@
 #include "interface.h"
 
 /**
+ * mei_hbm_cl_hdr - construct client hbm header
+ * @cl: - client
+ * @hbm_cmd: host bus message command
+ * @buf: buffer for cl header
+ * @len: buffer length
+ */
+static inline
+void mei_hbm_cl_hdr(struct mei_cl *cl, u8 hbm_cmd, void *buf, size_t len)
+{
+	struct mei_hbm_cl_cmd *cmd = buf;
+
+	memset(cmd, 0, len);
+
+	cmd->hbm_cmd = hbm_cmd;
+	cmd->host_addr = cl->host_client_id;
+	cmd->me_addr = cl->me_client_id;
+}
+
+/**
+ * same_disconn_addr - tells if they have the same address
+ *
+ * @file: private data of the file object.
+ * @disconn: disconnection request.
+ *
+ * returns true if addres are same
+ */
+static inline
+bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
+{
+	struct mei_hbm_cl_cmd *cmd = buf;
+	return cl->host_client_id == cmd->host_addr &&
+		cl->me_client_id == cmd->me_addr;
+}
+
+
+/**
  * host_start_message - mei host sends start message.
  *
  * @dev: the device structure
@@ -144,22 +180,16 @@ int mei_host_client_enumerate(struct mei_device *dev)
 int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr;
-	struct hbm_flow_control *flow_ctrl;
+	unsigned char *buf = (unsigned char *)&dev->wr_msg_buf[1];
 	const size_t len = sizeof(struct hbm_flow_control);
 
 	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	mei_hbm_cl_hdr(cl, MEI_FLOW_CONTROL_CMD, buf, len);
 
-	flow_ctrl = (struct hbm_flow_control *)&dev->wr_msg_buf[1];
-	memset(flow_ctrl, 0, len);
-	flow_ctrl->hbm_cmd = MEI_FLOW_CONTROL_CMD;
-	flow_ctrl->host_addr = cl->host_client_id;
-	flow_ctrl->me_addr = cl->me_client_id;
-	/* FIXME: reserved !? */
-	memset(flow_ctrl->reserved, 0, sizeof(flow_ctrl->reserved));
 	dev_dbg(&dev->pdev->dev, "sending flow control host client = %d, ME client = %d\n",
 		cl->host_client_id, cl->me_client_id);
 
-	return mei_write_message(dev, mei_hdr, (unsigned char *) flow_ctrl);
+	return mei_write_message(dev, mei_hdr, buf);
 }
 
 /**
@@ -173,19 +203,13 @@ int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
 int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *hdr;
-	struct hbm_client_connect_request *req;
+	unsigned char *buf = (unsigned char *)&dev->wr_msg_buf[1];
 	const size_t len = sizeof(struct hbm_client_connect_request);
 
 	hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	mei_hbm_cl_hdr(cl, CLIENT_DISCONNECT_REQ_CMD, buf, len);
 
-	req = (struct hbm_client_connect_request *)&dev->wr_msg_buf[1];
-	memset(req, 0, len);
-	req->hbm_cmd = CLIENT_DISCONNECT_REQ_CMD;
-	req->host_addr = cl->host_client_id;
-	req->me_addr = cl->me_client_id;
-	req->reserved = 0;
-
-	return mei_write_message(dev, hdr, (unsigned char *)req);
+	return mei_write_message(dev, hdr, buf);
 }
 
 /**
@@ -199,33 +223,13 @@ int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 int mei_connect(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *hdr;
-	struct hbm_client_connect_request *req;
+	unsigned char *buf = (unsigned char *)&dev->wr_msg_buf[1];
 	const size_t len = sizeof(struct hbm_client_connect_request);
 
 	hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	mei_hbm_cl_hdr(cl, CLIENT_CONNECT_REQ_CMD, buf, len);
 
-	req = (struct hbm_client_connect_request *) &dev->wr_msg_buf[1];
-	req->hbm_cmd = CLIENT_CONNECT_REQ_CMD;
-	req->host_addr = cl->host_client_id;
-	req->me_addr = cl->me_client_id;
-	req->reserved = 0;
-
-	return mei_write_message(dev, hdr, (unsigned char *) req);
-}
-
-/**
- * same_disconn_addr - tells if they have the same address
- *
- * @file: private data of the file object.
- * @disconn: disconnection request.
- *
- * returns !=0, same; 0,not.
- */
-static int same_disconn_addr(struct mei_cl *cl,
-			     struct hbm_client_connect_request *req)
-{
-	return (cl->host_client_id == req->host_addr &&
-		cl->me_client_id == req->me_addr);
+	return mei_write_message(dev, hdr, buf);
 }
 
 /**
@@ -237,31 +241,25 @@ static int same_disconn_addr(struct mei_cl *cl,
 static void mei_client_disconnect_request(struct mei_device *dev,
 		struct hbm_client_connect_request *disconnect_req)
 {
-	struct hbm_client_connect_response *disconnect_res;
-	struct mei_cl *pos, *next;
+	struct mei_cl *cl, *next;
 	const size_t len = sizeof(struct hbm_client_connect_response);
 
-	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
-		if (same_disconn_addr(pos, disconnect_req)) {
+	list_for_each_entry_safe(cl, next, &dev->file_list, link) {
+		if (mei_hbm_cl_addr_equal(cl, disconnect_req)) {
 			dev_dbg(&dev->pdev->dev, "disconnect request host client %d ME client %d.\n",
 					disconnect_req->host_addr,
 					disconnect_req->me_addr);
-			pos->state = MEI_FILE_DISCONNECTED;
-			pos->timer_count = 0;
-			if (pos == &dev->wd_cl)
+			cl->state = MEI_FILE_DISCONNECTED;
+			cl->timer_count = 0;
+			if (cl == &dev->wd_cl)
 				dev->wd_pending = false;
-			else if (pos == &dev->iamthif_cl)
+			else if (cl == &dev->iamthif_cl)
 				dev->iamthif_timer = 0;
 
 			/* prepare disconnect response */
 			(void)mei_hbm_hdr((u32 *)&dev->wr_ext_msg.hdr, len);
-			disconnect_res =
-				(struct hbm_client_connect_response *)
-				&dev->wr_ext_msg.data;
-			disconnect_res->hbm_cmd = CLIENT_DISCONNECT_RES_CMD;
-			disconnect_res->host_addr = pos->host_client_id;
-			disconnect_res->me_addr = pos->me_client_id;
-			disconnect_res->status = 0;
+			mei_hbm_cl_hdr(cl, CLIENT_DISCONNECT_RES_CMD,
+					 &dev->wr_ext_msg.data, len);
 			break;
 		}
 	}
diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index 6ebb369..cb2f556 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -121,6 +121,22 @@ struct mei_bus_message {
 	u8 data[0];
 } __packed;
 
+/**
+ * struct hbm_cl_cmd - client specific host bus command
+ *	CONNECT, DISCONNECT, and FlOW CONTROL
+ *
+ * @hbm_cmd - bus message command header
+ * @me_addr - address of the client in ME
+ * @host_addr - address of the client in the driver
+ * @data
+ */
+struct mei_hbm_cl_cmd {
+	u8 hbm_cmd;
+	u8 me_addr;
+	u8 host_addr;
+	u8 data;
+};
+
 struct hbm_version {
 	u8 minor_version;
 	u8 major_version;
-- 
1.7.4.4

