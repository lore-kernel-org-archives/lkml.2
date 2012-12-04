Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2LDOFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:05:52 -0500
Received: from mga14.intel.com ([143.182.124.37]:42613 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab2LDOFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:05:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975757"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 13/15] mei: use structured buffer for write buffer
Date: Tue,  4 Dec 2012 16:04:42 +0200
Message-Id: <1354629884-3202-13-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
References: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can drop useless castings and use proper types
Modify mei_hbm_hdr as casting is not necessary anymore
Add mei_hbm_stop_request_prepare function that
utilize the new structure

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |   25 ++++----
 drivers/misc/mei/hbm.c       |  134 +++++++++++++++++++++---------------------
 drivers/misc/mei/interrupt.c |   25 ++++----
 drivers/misc/mei/mei_dev.h   |   12 +++-
 drivers/misc/mei/wd.c        |   17 +++---
 5 files changed, 108 insertions(+), 105 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index bb613f7..f9d458c 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -432,34 +432,33 @@ unsigned int mei_amthif_poll(struct mei_device *dev,
 int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
 {
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr mei_hdr;
 	struct mei_cl *cl = cb->cl;
 	size_t len = dev->iamthif_msg_buf_size - dev->iamthif_msg_buf_index;
 	size_t msg_slots = mei_data2slots(len);
 
-	mei_hdr = (struct mei_msg_hdr *)&dev->wr_msg_buf[0];
-	mei_hdr->host_addr = cl->host_client_id;
-	mei_hdr->me_addr = cl->me_client_id;
-	mei_hdr->reserved = 0;
+	mei_hdr.host_addr = cl->host_client_id;
+	mei_hdr.me_addr = cl->me_client_id;
+	mei_hdr.reserved = 0;
 
 	if (*slots >= msg_slots) {
-		mei_hdr->length = len;
-		mei_hdr->msg_complete = 1;
+		mei_hdr.length = len;
+		mei_hdr.msg_complete = 1;
 	/* Split the message only if we can write the whole host buffer */
 	} else if (*slots == dev->hbuf_depth) {
 		msg_slots = *slots;
 		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
-		mei_hdr->length = len;
-		mei_hdr->msg_complete = 0;
+		mei_hdr.length = len;
+		mei_hdr.msg_complete = 0;
 	} else {
 		/* wait for next time the host buffer is empty */
 		return 0;
 	}
 
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT,  MEI_HDR_PRM(mei_hdr));
+	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT,  MEI_HDR_PRM(&mei_hdr));
 
 	*slots -=  msg_slots;
-	if (mei_write_message(dev, mei_hdr,
+	if (mei_write_message(dev, &mei_hdr,
 		dev->iamthif_msg_buf + dev->iamthif_msg_buf_index)) {
 			dev->iamthif_state = MEI_IAMTHIF_IDLE;
 			cl->status = -ENODEV;
@@ -470,10 +469,10 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 	if (mei_flow_ctrl_reduce(dev, cl))
 		return -ENODEV;
 
-	dev->iamthif_msg_buf_index += mei_hdr->length;
+	dev->iamthif_msg_buf_index += mei_hdr.length;
 	cl->status = 0;
 
-	if (mei_hdr->msg_complete) {
+	if (mei_hdr.msg_complete) {
 		dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
 		dev->iamthif_flow_control_pending = true;
 
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index bc36c23..e9ba51d 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -67,21 +67,21 @@ bool mei_hbm_cl_addr_equal(struct mei_cl *cl, void *buf)
  */
 void mei_host_start_message(struct mei_device *dev)
 {
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_host_version_request *start_req;
 	const size_t len = sizeof(struct hbm_host_version_request);
 
-	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	mei_hbm_hdr(mei_hdr, len);
 
 	/* host start message */
-	start_req = (struct hbm_host_version_request *)&dev->wr_msg_buf[1];
+	start_req = (struct hbm_host_version_request *)dev->wr_msg.data;
 	memset(start_req, 0, len);
 	start_req->hbm_cmd = HOST_START_REQ_CMD;
 	start_req->host_version.major_version = HBM_MAJOR_VERSION;
 	start_req->host_version.minor_version = HBM_MINOR_VERSION;
 
 	dev->recvd_msg = false;
-	if (mei_write_message(dev, mei_hdr, (unsigned char *)start_req)) {
+	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev_dbg(&dev->pdev->dev, "write send version message to FW fail.\n");
 		dev->dev_state = MEI_DEV_RESETING;
 		mei_reset(dev, 1);
@@ -100,17 +100,17 @@ void mei_host_start_message(struct mei_device *dev)
  */
 void mei_host_enum_clients_message(struct mei_device *dev)
 {
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_host_enum_request *enum_req;
 	const size_t len = sizeof(struct hbm_host_enum_request);
 	/* enumerate clients */
-	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	mei_hbm_hdr(mei_hdr, len);
 
-	enum_req = (struct hbm_host_enum_request *) &dev->wr_msg_buf[1];
-	memset(enum_req, 0, sizeof(struct hbm_host_enum_request));
+	enum_req = (struct hbm_host_enum_request *)dev->wr_msg.data;
+	memset(enum_req, 0, len);
 	enum_req->hbm_cmd = HOST_ENUM_REQ_CMD;
 
-	if (mei_write_message(dev, mei_hdr, (unsigned char *)enum_req)) {
+	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev->dev_state = MEI_DEV_RESETING;
 		dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
 		mei_reset(dev, 1);
@@ -124,7 +124,7 @@ void mei_host_enum_clients_message(struct mei_device *dev)
 int mei_host_client_enumerate(struct mei_device *dev)
 {
 
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	struct hbm_props_request *prop_req;
 	const size_t len = sizeof(struct hbm_props_request);
 	unsigned long next_client_index;
@@ -146,8 +146,8 @@ int mei_host_client_enumerate(struct mei_device *dev)
 	dev->me_clients[client_num].client_id = next_client_index;
 	dev->me_clients[client_num].mei_flow_ctrl_creds = 0;
 
-	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
-	prop_req = (struct hbm_props_request *)&dev->wr_msg_buf[1];
+	mei_hbm_hdr(mei_hdr, len);
+	prop_req = (struct hbm_props_request *)dev->wr_msg.data;
 
 	memset(prop_req, 0, sizeof(struct hbm_props_request));
 
@@ -155,7 +155,7 @@ int mei_host_client_enumerate(struct mei_device *dev)
 	prop_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
 	prop_req->address = next_client_index;
 
-	if (mei_write_message(dev, mei_hdr, (unsigned char *) prop_req)) {
+	if (mei_write_message(dev, mei_hdr, dev->wr_msg.data)) {
 		dev->dev_state = MEI_DEV_RESETING;
 		dev_err(&dev->pdev->dev, "Properties request command failed\n");
 		mei_reset(dev, 1);
@@ -170,6 +170,27 @@ int mei_host_client_enumerate(struct mei_device *dev)
 }
 
 /**
+ * mei_hbm_stop_req_prepare - perpare stop request message
+ *
+ * @dev - mei device
+ * @mei_hdr - mei message header
+ * @data - hbm message body buffer
+ */
+static void mei_hbm_stop_req_prepare(struct mei_device *dev,
+		struct mei_msg_hdr *mei_hdr, unsigned char *data)
+{
+	struct hbm_host_stop_request *req =
+			(struct hbm_host_stop_request *)data;
+	const size_t len = sizeof(struct hbm_host_stop_request);
+
+	mei_hbm_hdr(mei_hdr, len);
+
+	memset(req, 0, len);
+	req->hbm_cmd = HOST_STOP_REQ_CMD;
+	req->reason = DRIVER_STOP_REQUEST;
+}
+
+/**
  * mei_send_flow_control - sends flow control to fw.
  *
  * @dev: the device structure
@@ -179,17 +200,16 @@ int mei_host_client_enumerate(struct mei_device *dev)
  */
 int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *mei_hdr;
-	unsigned char *buf = (unsigned char *)&dev->wr_msg_buf[1];
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_flow_control);
 
-	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
-	mei_hbm_cl_hdr(cl, MEI_FLOW_CONTROL_CMD, buf, len);
+	mei_hbm_hdr(mei_hdr, len);
+	mei_hbm_cl_hdr(cl, MEI_FLOW_CONTROL_CMD, dev->wr_msg.data, len);
 
 	dev_dbg(&dev->pdev->dev, "sending flow control host client = %d, ME client = %d\n",
 		cl->host_client_id, cl->me_client_id);
 
-	return mei_write_message(dev, mei_hdr, buf);
+	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 }
 
 /**
@@ -202,14 +222,13 @@ int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
  */
 int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *hdr;
-	unsigned char *buf = (unsigned char *)&dev->wr_msg_buf[1];
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
 
-	hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
-	mei_hbm_cl_hdr(cl, CLIENT_DISCONNECT_REQ_CMD, buf, len);
+	mei_hbm_hdr(mei_hdr, len);
+	mei_hbm_cl_hdr(cl, CLIENT_DISCONNECT_REQ_CMD, dev->wr_msg.data, len);
 
-	return mei_write_message(dev, hdr, buf);
+	return mei_write_message(dev, mei_hdr, dev->wr_msg.data);
 }
 
 /**
@@ -222,14 +241,13 @@ int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
  */
 int mei_connect(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *hdr;
-	unsigned char *buf = (unsigned char *)&dev->wr_msg_buf[1];
+	struct mei_msg_hdr *mei_hdr = &dev->wr_msg.hdr;
 	const size_t len = sizeof(struct hbm_client_connect_request);
 
-	hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
-	mei_hbm_cl_hdr(cl, CLIENT_CONNECT_REQ_CMD, buf, len);
+	mei_hbm_hdr(mei_hdr, len);
+	mei_hbm_cl_hdr(cl, CLIENT_CONNECT_REQ_CMD, dev->wr_msg.data, len);
 
-	return mei_write_message(dev, hdr, buf);
+	return mei_write_message(dev, mei_hdr,  dev->wr_msg.data);
 }
 
 /**
@@ -257,9 +275,9 @@ static void mei_client_disconnect_request(struct mei_device *dev,
 				dev->iamthif_timer = 0;
 
 			/* prepare disconnect response */
-			(void)mei_hbm_hdr((u32 *)&dev->wr_ext_msg.hdr, len);
+			mei_hbm_hdr(&dev->wr_ext_msg.hdr, len);
 			mei_hbm_cl_hdr(cl, CLIENT_DISCONNECT_RES_CMD,
-					 &dev->wr_ext_msg.data, len);
+					 dev->wr_ext_msg.data, len);
 			break;
 		}
 	}
@@ -284,7 +302,6 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 	struct hbm_flow_control *flow_control;
 	struct hbm_props_response *props_res;
 	struct hbm_host_enum_response *enum_res;
-	struct hbm_host_stop_request *stop_req;
 
 	/* read the message to our buffer */
 	BUG_ON(hdr->length >= sizeof(dev->rd_msg_buf));
@@ -294,34 +311,27 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 	switch (mei_msg->hbm_cmd) {
 	case HOST_START_RES_CMD:
 		version_res = (struct hbm_host_version_response *)mei_msg;
-		if (version_res->host_version_supported) {
-			dev->version.major_version = HBM_MAJOR_VERSION;
-			dev->version.minor_version = HBM_MINOR_VERSION;
-			if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
-			    dev->init_clients_state == MEI_START_MESSAGE) {
-				dev->init_clients_timer = 0;
-				mei_host_enum_clients_message(dev);
-			} else {
-				dev->recvd_msg = false;
-				dev_dbg(&dev->pdev->dev, "IMEI reset due to received host start response bus message.\n");
-				mei_reset(dev, 1);
-				return;
-			}
-		} else {
-			u32 *buf = dev->wr_msg_buf;
-			const size_t len = sizeof(struct hbm_host_stop_request);
-
+		if (!version_res->host_version_supported) {
 			dev->version = version_res->me_max_version;
+			dev_dbg(&dev->pdev->dev, "version mismatch.\n");
 
-			/* send stop message */
-			hdr = mei_hbm_hdr(&buf[0], len);
-			stop_req = (struct hbm_host_stop_request *)&buf[1];
-			memset(stop_req, 0, len);
-			stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
-			stop_req->reason = DRIVER_STOP_REQUEST;
+			mei_hbm_stop_req_prepare(dev, &dev->wr_msg.hdr,
+						dev->wr_msg.data);
+			mei_write_message(dev, &dev->wr_msg.hdr,
+					dev->wr_msg.data);
+			return;
+		}
 
-			mei_write_message(dev, hdr, (unsigned char *)stop_req);
-			dev_dbg(&dev->pdev->dev, "version mismatch.\n");
+		dev->version.major_version = HBM_MAJOR_VERSION;
+		dev->version.minor_version = HBM_MINOR_VERSION;
+		if (dev->dev_state == MEI_DEV_INIT_CLIENTS &&
+		    dev->init_clients_state == MEI_START_MESSAGE) {
+			dev->init_clients_timer = 0;
+			mei_host_enum_clients_message(dev);
+		} else {
+			dev->recvd_msg = false;
+			dev_dbg(&dev->pdev->dev, "reset due to received hbm: host start\n");
+			mei_reset(dev, 1);
 			return;
 		}
 
@@ -417,18 +427,10 @@ void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr)
 		break;
 
 	case ME_STOP_REQ_CMD:
-	{
-		/* prepare stop request: sent in next interrupt event */
 
-		const size_t len = sizeof(struct hbm_host_stop_request);
-
-		hdr = mei_hbm_hdr((u32 *)&dev->wr_ext_msg.hdr, len);
-		stop_req = (struct hbm_host_stop_request *)&dev->wr_ext_msg.data;
-		memset(stop_req, 0, len);
-		stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
-		stop_req->reason = DRIVER_STOP_REQUEST;
+		mei_hbm_stop_req_prepare(dev, &dev->wr_ext_msg.hdr,
+					dev->wr_ext_msg.data);
 		break;
-	}
 	default:
 		BUG();
 		break;
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index d4312a8..9cbf148 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -469,25 +469,24 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb, struct mei_cl_cb *cmpl_list)
 {
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr mei_hdr;
 	struct mei_cl *cl = cb->cl;
 	size_t len = cb->request_buffer.size - cb->buf_idx;
 	size_t msg_slots = mei_data2slots(len);
 
-	mei_hdr = (struct mei_msg_hdr *)&dev->wr_msg_buf[0];
-	mei_hdr->host_addr = cl->host_client_id;
-	mei_hdr->me_addr = cl->me_client_id;
-	mei_hdr->reserved = 0;
+	mei_hdr.host_addr = cl->host_client_id;
+	mei_hdr.me_addr = cl->me_client_id;
+	mei_hdr.reserved = 0;
 
 	if (*slots >= msg_slots) {
-		mei_hdr->length = len;
-		mei_hdr->msg_complete = 1;
+		mei_hdr.length = len;
+		mei_hdr.msg_complete = 1;
 	/* Split the message only if we can write the whole host buffer */
 	} else if (*slots == dev->hbuf_depth) {
 		msg_slots = *slots;
 		len = (*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
-		mei_hdr->length = len;
-		mei_hdr->msg_complete = 0;
+		mei_hdr.length = len;
+		mei_hdr.msg_complete = 0;
 	} else {
 		/* wait for next time the host buffer is empty */
 		return 0;
@@ -495,10 +494,10 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 
 	dev_dbg(&dev->pdev->dev, "buf: size = %d idx = %lu\n",
 			cb->request_buffer.size, cb->buf_idx);
-	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(mei_hdr));
+	dev_dbg(&dev->pdev->dev, MEI_HDR_FMT, MEI_HDR_PRM(&mei_hdr));
 
 	*slots -=  msg_slots;
-	if (mei_write_message(dev, mei_hdr,
+	if (mei_write_message(dev, &mei_hdr,
 			cb->request_buffer.data + cb->buf_idx)) {
 		cl->status = -ENODEV;
 		list_move_tail(&cb->list, &cmpl_list->list);
@@ -509,8 +508,8 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 		return -ENODEV;
 
 	cl->status = 0;
-	cb->buf_idx += mei_hdr->length;
-	if (mei_hdr->msg_complete)
+	cb->buf_idx += mei_hdr.length;
+	if (mei_hdr.msg_complete)
 		list_move_tail(&cb->list, &dev->write_waiting_list.list);
 
 	return 0;
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index bc2bedc..1017e54 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -265,7 +265,13 @@ struct mei_device {
 
 	unsigned char rd_msg_buf[MEI_RD_MSG_BUF_SIZE];	/* control messages */
 	u32 rd_msg_hdr;
-	u32 wr_msg_buf[128];	/* used for control messages */
+
+	/* used for control messages */
+	struct {
+		struct mei_msg_hdr hdr;
+		unsigned char data[128];
+	} wr_msg;
+
 	struct {
 		struct mei_msg_hdr hdr;
 		unsigned char data[4];	/* All HBM messages are 4 bytes */
@@ -459,15 +465,13 @@ void mei_disable_interrupts(struct mei_device *dev);
 
 void mei_hbm_dispatch(struct mei_device *dev, struct mei_msg_hdr *hdr);
 
-static inline struct mei_msg_hdr *mei_hbm_hdr(u32 *buf, size_t length)
+static inline void mei_hbm_hdr(struct mei_msg_hdr *hdr, size_t length)
 {
-	struct mei_msg_hdr *hdr = (struct mei_msg_hdr *)buf;
 	hdr->host_addr = 0;
 	hdr->me_addr = 0;
 	hdr->length = length;
 	hdr->msg_complete = 1;
 	hdr->reserved = 0;
-	return hdr;
 }
 
 #define MEI_HDR_FMT "hdr:host=%02d me=%02d len=%d comp=%1d"
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 9a5c782..9851de4 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -101,22 +101,21 @@ int mei_wd_host_init(struct mei_device *dev)
  */
 int mei_wd_send(struct mei_device *dev)
 {
-	struct mei_msg_hdr *hdr;
+	struct mei_msg_hdr hdr;
 
-	hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-	hdr->host_addr = dev->wd_cl.host_client_id;
-	hdr->me_addr = dev->wd_cl.me_client_id;
-	hdr->msg_complete = 1;
-	hdr->reserved = 0;
+	hdr.host_addr = dev->wd_cl.host_client_id;
+	hdr.me_addr = dev->wd_cl.me_client_id;
+	hdr.msg_complete = 1;
+	hdr.reserved = 0;
 
 	if (!memcmp(dev->wd_data, mei_start_wd_params, MEI_WD_HDR_SIZE))
-		hdr->length = MEI_WD_START_MSG_SIZE;
+		hdr.length = MEI_WD_START_MSG_SIZE;
 	else if (!memcmp(dev->wd_data, mei_stop_wd_params, MEI_WD_HDR_SIZE))
-		hdr->length = MEI_WD_STOP_MSG_SIZE;
+		hdr.length = MEI_WD_STOP_MSG_SIZE;
 	else
 		return -EINVAL;
 
-	return mei_write_message(dev, hdr, dev->wd_data);
+	return mei_write_message(dev, &hdr, dev->wd_data);
 }
 
 /**
-- 
1.7.4.4

