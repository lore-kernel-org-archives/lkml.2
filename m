Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2KRNNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 08:13:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:12219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab2KRNN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 08:13:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="250943253"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/7] mei: compact code for mei bus message creation
Date: Sun, 18 Nov 2012 15:13:14 +0200
Message-Id: <1353244400-9619-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. replace boilerplate code for filling up the bus message header
 with a common wrapper function
2. shorten variable names and use temporal variables
 to save some screen space

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c      |   78 +++++++++++++++-------------------
 drivers/misc/mei/interface.c |   75 +++++++++++++--------------------
 drivers/misc/mei/interrupt.c |   96 ++++++++++++++++-------------------------
 drivers/misc/mei/mei_dev.h   |   11 +++++
 4 files changed, 112 insertions(+), 148 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 4fcb0bb..02784af 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -43,6 +43,7 @@ const char *mei_dev_state_str(int state)
 }
 
 
+
 /**
  * mei_io_list_flush - removes list entry belonging to cl.
  *
@@ -331,25 +332,20 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 void mei_host_start_message(struct mei_device *dev)
 {
 	struct mei_msg_hdr *mei_hdr;
-	struct hbm_host_version_request *host_start_req;
+	struct hbm_host_version_request *start_req;
+	const size_t len = sizeof(struct hbm_host_version_request);
+
+	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
 
 	/* host start message */
-	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-	mei_hdr->host_addr = 0;
-	mei_hdr->me_addr = 0;
-	mei_hdr->length = sizeof(struct hbm_host_version_request);
-	mei_hdr->msg_complete = 1;
-	mei_hdr->reserved = 0;
-
-	host_start_req =
-	    (struct hbm_host_version_request *) &dev->wr_msg_buf[1];
-	memset(host_start_req, 0, sizeof(struct hbm_host_version_request));
-	host_start_req->hbm_cmd = HOST_START_REQ_CMD;
-	host_start_req->host_version.major_version = HBM_MAJOR_VERSION;
-	host_start_req->host_version.minor_version = HBM_MINOR_VERSION;
+	start_req = (struct hbm_host_version_request *)&dev->wr_msg_buf[1];
+	memset(start_req, 0, len);
+	start_req->hbm_cmd = HOST_START_REQ_CMD;
+	start_req->host_version.major_version = HBM_MAJOR_VERSION;
+	start_req->host_version.minor_version = HBM_MINOR_VERSION;
+
 	dev->recvd_msg = false;
-	if (mei_write_message(dev, mei_hdr, (unsigned char *)host_start_req,
-				       mei_hdr->length)) {
+	if (mei_write_message(dev, mei_hdr, (unsigned char *)start_req, len)) {
 		dev_dbg(&dev->pdev->dev, "write send version message to FW fail.\n");
 		dev->dev_state = MEI_DEV_RESETING;
 		mei_reset(dev, 1);
@@ -369,20 +365,16 @@ void mei_host_start_message(struct mei_device *dev)
 void mei_host_enum_clients_message(struct mei_device *dev)
 {
 	struct mei_msg_hdr *mei_hdr;
-	struct hbm_host_enum_request *host_enum_req;
-	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	struct hbm_host_enum_request *enum_req;
+	const size_t len = sizeof(struct hbm_host_enum_request);
 	/* enumerate clients */
-	mei_hdr->host_addr = 0;
-	mei_hdr->me_addr = 0;
-	mei_hdr->length = sizeof(struct hbm_host_enum_request);
-	mei_hdr->msg_complete = 1;
-	mei_hdr->reserved = 0;
-
-	host_enum_req = (struct hbm_host_enum_request *) &dev->wr_msg_buf[1];
-	memset(host_enum_req, 0, sizeof(struct hbm_host_enum_request));
-	host_enum_req->hbm_cmd = HOST_ENUM_REQ_CMD;
-	if (mei_write_message(dev, mei_hdr, (unsigned char *)host_enum_req,
-				mei_hdr->length)) {
+	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+
+	enum_req = (struct hbm_host_enum_request *) &dev->wr_msg_buf[1];
+	memset(enum_req, 0, sizeof(struct hbm_host_enum_request));
+	enum_req->hbm_cmd = HOST_ENUM_REQ_CMD;
+
+	if (mei_write_message(dev, mei_hdr, (unsigned char *)enum_req, len)) {
 		dev->dev_state = MEI_DEV_RESETING;
 		dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
 		mei_reset(dev, 1);
@@ -443,33 +435,31 @@ void mei_allocate_me_clients_storage(struct mei_device *dev)
  */
 int mei_host_client_properties(struct mei_device *dev)
 {
-	struct mei_msg_hdr *mei_header;
-	struct hbm_props_request *host_cli_req;
+
+	struct mei_msg_hdr *mei_hdr;
+	struct hbm_props_request *prop_req;
+	const size_t len = sizeof(struct hbm_props_request);
+
 	int b;
 	u8 client_num = dev->me_client_presentation_num;
 
+	prop_req = (struct hbm_props_request *)&dev->wr_msg_buf[1];
+
 	b = dev->me_client_index;
 	b = find_next_bit(dev->me_clients_map, MEI_CLIENTS_MAX, b);
 	if (b < MEI_CLIENTS_MAX) {
 		dev->me_clients[client_num].client_id = b;
 		dev->me_clients[client_num].mei_flow_ctrl_creds = 0;
-		mei_header = (struct mei_msg_hdr *)&dev->wr_msg_buf[0];
-		mei_header->host_addr = 0;
-		mei_header->me_addr = 0;
-		mei_header->length = sizeof(struct hbm_props_request);
-		mei_header->msg_complete = 1;
-		mei_header->reserved = 0;
+		mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
 
-		host_cli_req = (struct hbm_props_request *)&dev->wr_msg_buf[1];
 
-		memset(host_cli_req, 0, sizeof(struct hbm_props_request));
+		memset(prop_req, 0, sizeof(struct hbm_props_request));
 
-		host_cli_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
-		host_cli_req->address = b;
+		prop_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
+		prop_req->address = b;
 
-		if (mei_write_message(dev, mei_header,
-				(unsigned char *)host_cli_req,
-				mei_header->length)) {
+		if (mei_write_message(dev, mei_hdr,
+				(unsigned char *)prop_req, len)) {
 			dev->dev_state = MEI_DEV_RESETING;
 			dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
 			mei_reset(dev, 1);
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 6b50cf0..8de8547 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -292,28 +292,23 @@ int mei_flow_ctrl_reduce(struct mei_device *dev, struct mei_cl *cl)
 int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr;
-	struct hbm_flow_control *mei_flow_control;
-
-	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-	mei_hdr->host_addr = 0;
-	mei_hdr->me_addr = 0;
-	mei_hdr->length = sizeof(struct hbm_flow_control);
-	mei_hdr->msg_complete = 1;
-	mei_hdr->reserved = 0;
-
-	mei_flow_control = (struct hbm_flow_control *) &dev->wr_msg_buf[1];
-	memset(mei_flow_control, 0, sizeof(*mei_flow_control));
-	mei_flow_control->host_addr = cl->host_client_id;
-	mei_flow_control->me_addr = cl->me_client_id;
-	mei_flow_control->hbm_cmd = MEI_FLOW_CONTROL_CMD;
-	memset(mei_flow_control->reserved, 0,
-			sizeof(mei_flow_control->reserved));
+	struct hbm_flow_control *flow_ctrl;
+	const size_t len = sizeof(struct hbm_flow_control);
+
+	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+
+	flow_ctrl = (struct hbm_flow_control *)&dev->wr_msg_buf[1];
+	memset(flow_ctrl, 0, len);
+	flow_ctrl->hbm_cmd = MEI_FLOW_CONTROL_CMD;
+	flow_ctrl->host_addr = cl->host_client_id;
+	flow_ctrl->me_addr = cl->me_client_id;
+	/* FIXME: reserved !? */
+	memset(flow_ctrl->reserved, 0, sizeof(flow_ctrl->reserved));
 	dev_dbg(&dev->pdev->dev, "sending flow control host client = %d, ME client = %d\n",
 		cl->host_client_id, cl->me_client_id);
 
 	return mei_write_message(dev, mei_hdr,
-				(unsigned char *) mei_flow_control,
-				sizeof(struct hbm_flow_control));
+			(unsigned char *) flow_ctrl, len);
 }
 
 /**
@@ -353,23 +348,18 @@ int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr;
 	struct hbm_client_connect_request *req;
+	const size_t len = sizeof(struct hbm_client_connect_request);
 
-	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-	mei_hdr->host_addr = 0;
-	mei_hdr->me_addr = 0;
-	mei_hdr->length = sizeof(struct hbm_client_connect_request);
-	mei_hdr->msg_complete = 1;
-	mei_hdr->reserved = 0;
+	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
 
 	req = (struct hbm_client_connect_request *)&dev->wr_msg_buf[1];
-	memset(req, 0, sizeof(*req));
+	memset(req, 0, len);
+	req->hbm_cmd = CLIENT_DISCONNECT_REQ_CMD;
 	req->host_addr = cl->host_client_id;
 	req->me_addr = cl->me_client_id;
-	req->hbm_cmd = CLIENT_DISCONNECT_REQ_CMD;
 	req->reserved = 0;
 
-	return mei_write_message(dev, mei_hdr, (unsigned char *)req,
-				sizeof(struct hbm_client_connect_request));
+	return mei_write_message(dev, mei_hdr, (unsigned char *)req, len);
 }
 
 /**
@@ -383,23 +373,16 @@ int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 int mei_connect(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr;
-	struct hbm_client_connect_request *mei_cli_connect;
-
-	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-	mei_hdr->host_addr = 0;
-	mei_hdr->me_addr = 0;
-	mei_hdr->length = sizeof(struct hbm_client_connect_request);
-	mei_hdr->msg_complete = 1;
-	mei_hdr->reserved = 0;
-
-	mei_cli_connect =
-	    (struct hbm_client_connect_request *) &dev->wr_msg_buf[1];
-	mei_cli_connect->host_addr = cl->host_client_id;
-	mei_cli_connect->me_addr = cl->me_client_id;
-	mei_cli_connect->hbm_cmd = CLIENT_CONNECT_REQ_CMD;
-	mei_cli_connect->reserved = 0;
+	struct hbm_client_connect_request *req;
+	const size_t len = sizeof(struct hbm_client_connect_request);
 
-	return mei_write_message(dev, mei_hdr,
-				(unsigned char *) mei_cli_connect,
-				sizeof(struct hbm_client_connect_request));
+	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+
+	req = (struct hbm_client_connect_request *) &dev->wr_msg_buf[1];
+	req->hbm_cmd = CLIENT_CONNECT_REQ_CMD;
+	req->host_addr = cl->host_client_id;
+	req->me_addr = cl->me_client_id;
+	req->reserved = 0;
+
+	return mei_write_message(dev, mei_hdr, (unsigned char *) req, len);
 }
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index f882101..14becc0 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -429,39 +429,30 @@ static int same_disconn_addr(struct mei_cl *cl,
 static void mei_client_disconnect_request(struct mei_device *dev,
 		struct hbm_client_connect_request *disconnect_req)
 {
-	struct mei_msg_hdr *mei_hdr;
 	struct hbm_client_connect_response *disconnect_res;
-	struct mei_cl *cl_pos = NULL;
-	struct mei_cl *cl_next = NULL;
+	struct mei_cl *pos, *next;
+	const size_t len = sizeof(struct hbm_client_connect_response);
 
-	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
-		if (same_disconn_addr(cl_pos, disconnect_req)) {
+	list_for_each_entry_safe(pos, next, &dev->file_list, link) {
+		if (same_disconn_addr(pos, disconnect_req)) {
 			dev_dbg(&dev->pdev->dev, "disconnect request host client %d ME client %d.\n",
 					disconnect_req->host_addr,
 					disconnect_req->me_addr);
-			cl_pos->state = MEI_FILE_DISCONNECTED;
-			cl_pos->timer_count = 0;
-			if (cl_pos == &dev->wd_cl)
+			pos->state = MEI_FILE_DISCONNECTED;
+			pos->timer_count = 0;
+			if (pos == &dev->wd_cl)
 				dev->wd_pending = false;
-			else if (cl_pos == &dev->iamthif_cl)
+			else if (pos == &dev->iamthif_cl)
 				dev->iamthif_timer = 0;
 
 			/* prepare disconnect response */
-			mei_hdr =
-				(struct mei_msg_hdr *) &dev->ext_msg_buf[0];
-			mei_hdr->host_addr = 0;
-			mei_hdr->me_addr = 0;
-			mei_hdr->length =
-				sizeof(struct hbm_client_connect_response);
-			mei_hdr->msg_complete = 1;
-			mei_hdr->reserved = 0;
-
+			(void)mei_hbm_hdr(&dev->ext_msg_buf[0], len);
 			disconnect_res =
 				(struct hbm_client_connect_response *)
 				&dev->ext_msg_buf[1];
-			disconnect_res->host_addr = cl_pos->host_client_id;
-			disconnect_res->me_addr = cl_pos->me_client_id;
 			disconnect_res->hbm_cmd = CLIENT_DISCONNECT_RES_CMD;
+			disconnect_res->host_addr = pos->host_client_id;
+			disconnect_res->me_addr = pos->me_client_id;
 			disconnect_res->status = 0;
 			dev->extra_write_index = 2;
 			break;
@@ -469,7 +460,6 @@ static void mei_client_disconnect_request(struct mei_device *dev,
 	}
 }
 
-
 /**
  * mei_irq_thread_read_bus_message - bottom half read routine after ISR to
  * handle the read bus message cmd processing.
@@ -488,7 +478,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	struct hbm_flow_control *flow_control;
 	struct hbm_props_response *props_res;
 	struct hbm_host_enum_response *enum_res;
-	struct hbm_host_stop_request *host_stop_req;
+	struct hbm_host_stop_request *stop_req;
 	int res;
 
 
@@ -514,26 +504,20 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 				return;
 			}
 		} else {
+			u32 *buf = dev->wr_msg_buf;
+			const size_t len = sizeof(struct hbm_host_stop_request);
+
 			dev->version = version_res->me_max_version;
+
 			/* send stop message */
-			mei_hdr = (struct mei_msg_hdr *)&dev->wr_msg_buf[0];
-			mei_hdr->host_addr = 0;
-			mei_hdr->me_addr = 0;
-			mei_hdr->length = sizeof(struct hbm_host_stop_request);
-			mei_hdr->msg_complete = 1;
-			mei_hdr->reserved = 0;
-
-			host_stop_req = (struct hbm_host_stop_request *)
-							&dev->wr_msg_buf[1];
-
-			memset(host_stop_req,
-					0,
-					sizeof(struct hbm_host_stop_request));
-			host_stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
-			host_stop_req->reason = DRIVER_STOP_REQUEST;
+			mei_hdr = mei_hbm_hdr(&buf[0], len);
+			stop_req = (struct hbm_host_stop_request *)&buf[1];
+			memset(stop_req, 0, len);
+			stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
+			stop_req->reason = DRIVER_STOP_REQUEST;
+
 			mei_write_message(dev, mei_hdr,
-					   (unsigned char *) (host_stop_req),
-					   mei_hdr->length);
+					(unsigned char *)stop_req, len);
 			dev_dbg(&dev->pdev->dev, "version mismatch.\n");
 			return;
 		}
@@ -543,16 +527,14 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 		break;
 
 	case CLIENT_CONNECT_RES_CMD:
-		connect_res =
-			(struct hbm_client_connect_response *) mei_msg;
+		connect_res = (struct hbm_client_connect_response *) mei_msg;
 		mei_client_connect_response(dev, connect_res);
 		dev_dbg(&dev->pdev->dev, "client connect response message received.\n");
 		wake_up(&dev->wait_recvd_msg);
 		break;
 
 	case CLIENT_DISCONNECT_RES_CMD:
-		disconnect_res =
-			(struct hbm_client_connect_response *) mei_msg;
+		disconnect_res = (struct hbm_client_connect_response *) mei_msg;
 		mei_client_disconnect_response(dev, disconnect_res);
 		dev_dbg(&dev->pdev->dev, "client disconnect response message received.\n");
 		wake_up(&dev->wait_recvd_msg);
@@ -658,23 +640,21 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 		break;
 
 	case ME_STOP_REQ_CMD:
-		/* prepare stop request */
-		mei_hdr = (struct mei_msg_hdr *) &dev->ext_msg_buf[0];
-		mei_hdr->host_addr = 0;
-		mei_hdr->me_addr = 0;
-		mei_hdr->length = sizeof(struct hbm_host_stop_request);
-		mei_hdr->msg_complete = 1;
-		mei_hdr->reserved = 0;
-		host_stop_req =
-			(struct hbm_host_stop_request *) &dev->ext_msg_buf[1];
-		memset(host_stop_req, 0, sizeof(struct hbm_host_stop_request));
-		host_stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
-		host_stop_req->reason = DRIVER_STOP_REQUEST;
-		host_stop_req->reserved[0] = 0;
-		host_stop_req->reserved[1] = 0;
+	{
+		/* prepare stop request: sent in next interrupt event */
+
+		u32 *buf = dev->ext_msg_buf;
+		const size_t len = sizeof(struct hbm_host_stop_request);
+
+		mei_hdr = mei_hbm_hdr(&buf[0], len);
+		stop_req = (struct hbm_host_stop_request *)&buf[1];
+		memset(stop_req, 0, len);
+		stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
+		stop_req->reason = DRIVER_STOP_REQUEST;
+
 		dev->extra_write_index = 2;
 		break;
-
+	}
 	default:
 		BUG();
 		break;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index aaee666..e511b84 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -491,4 +491,15 @@ void mei_csr_clear_his(struct mei_device *dev);
 void mei_enable_interrupts(struct mei_device *dev);
 void mei_disable_interrupts(struct mei_device *dev);
 
+static inline struct mei_msg_hdr *mei_hbm_hdr(u32 *buf, size_t length)
+{
+	struct mei_msg_hdr *hdr = (struct mei_msg_hdr *)buf;
+	hdr->host_addr = 0;
+	hdr->me_addr = 0;
+	hdr->length = length;
+	hdr->msg_complete = 1;
+	hdr->reserved = 0;
+	return hdr;
+}
+
 #endif
-- 
1.7.4.4

