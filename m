Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2LDOE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:04:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:14163 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab2LDOEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:04:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="scan'208";a="175975231"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 01/15] mei: drop redundant length paramter from mei_write_message function
Date: Tue,  4 Dec 2012 16:04:30 +0200
Message-Id: <1354629884-3202-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The length is already part of the message header and it is validated
before the function call

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    |    6 ++----
 drivers/misc/mei/init.c      |    7 +++----
 drivers/misc/mei/interface.c |   24 +++++++++++-------------
 drivers/misc/mei/interface.h |    5 ++---
 drivers/misc/mei/interrupt.c |   17 ++++++++---------
 drivers/misc/mei/main.c      |    3 +--
 drivers/misc/mei/wd.c        |   18 +++++++++---------
 7 files changed, 36 insertions(+), 44 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index 18794ae..8a9313a 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -300,8 +300,7 @@ static int mei_amthif_send_cmd(struct mei_device *dev, struct mei_cl_cb *cb)
 		mei_hdr.reserved = 0;
 		dev->iamthif_msg_buf_index += mei_hdr.length;
 		if (mei_write_message(dev, &mei_hdr,
-					(unsigned char *)(dev->iamthif_msg_buf),
-					mei_hdr.length))
+					(unsigned char *)dev->iamthif_msg_buf))
 			return -ENODEV;
 
 		if (mei_hdr.msg_complete) {
@@ -463,8 +462,7 @@ int mei_amthif_irq_write_complete(struct mei_device *dev, s32 *slots,
 
 	*slots -=  msg_slots;
 	if (mei_write_message(dev, mei_hdr,
-		dev->iamthif_msg_buf + dev->iamthif_msg_buf_index,
-		mei_hdr->length)) {
+		dev->iamthif_msg_buf + dev->iamthif_msg_buf_index)) {
 			dev->iamthif_state = MEI_IAMTHIF_IDLE;
 			cl->status = -ENODEV;
 			list_del(&cb->list);
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index a54cd55..c0c0b3e 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -345,7 +345,7 @@ void mei_host_start_message(struct mei_device *dev)
 	start_req->host_version.minor_version = HBM_MINOR_VERSION;
 
 	dev->recvd_msg = false;
-	if (mei_write_message(dev, mei_hdr, (unsigned char *)start_req, len)) {
+	if (mei_write_message(dev, mei_hdr, (unsigned char *)start_req)) {
 		dev_dbg(&dev->pdev->dev, "write send version message to FW fail.\n");
 		dev->dev_state = MEI_DEV_RESETING;
 		mei_reset(dev, 1);
@@ -374,7 +374,7 @@ void mei_host_enum_clients_message(struct mei_device *dev)
 	memset(enum_req, 0, sizeof(struct hbm_host_enum_request));
 	enum_req->hbm_cmd = HOST_ENUM_REQ_CMD;
 
-	if (mei_write_message(dev, mei_hdr, (unsigned char *)enum_req, len)) {
+	if (mei_write_message(dev, mei_hdr, (unsigned char *)enum_req)) {
 		dev->dev_state = MEI_DEV_RESETING;
 		dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
 		mei_reset(dev, 1);
@@ -492,8 +492,7 @@ int mei_host_client_enumerate(struct mei_device *dev)
 	prop_req->hbm_cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
 	prop_req->address = next_client_index;
 
-	if (mei_write_message(dev, mei_hdr, (unsigned char *) prop_req,
-			      mei_hdr->length)) {
+	if (mei_write_message(dev, mei_hdr, (unsigned char *) prop_req)) {
 		dev->dev_state = MEI_DEV_RESETING;
 		dev_err(&dev->pdev->dev, "Properties request command failed\n");
 		mei_reset(dev, 1);
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 8de8547..21ccbe6 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -113,21 +113,20 @@ int mei_hbuf_empty_slots(struct mei_device *dev)
  * mei_write_message - writes a message to mei device.
  *
  * @dev: the device structure
- * @header: header of message
- * @write_buffer: message buffer will be written
- * @write_length: message size will be written
+ * @hader: mei HECI header of message
+ * @buf: message payload will be written
  *
  * This function returns -EIO if write has failed
  */
 int mei_write_message(struct mei_device *dev, struct mei_msg_hdr *header,
-		      unsigned char *buf, unsigned long length)
+		      unsigned char *buf)
 {
 	unsigned long rem, dw_cnt;
+	unsigned long length = header->length;
 	u32 *reg_buf = (u32 *)buf;
 	int i;
 	int empty_slots;
 
-
 	dev_dbg(&dev->pdev->dev,
 			"mei_write_message header=%08x.\n",
 			*((u32 *) header));
@@ -307,8 +306,7 @@ int mei_send_flow_control(struct mei_device *dev, struct mei_cl *cl)
 	dev_dbg(&dev->pdev->dev, "sending flow control host client = %d, ME client = %d\n",
 		cl->host_client_id, cl->me_client_id);
 
-	return mei_write_message(dev, mei_hdr,
-			(unsigned char *) flow_ctrl, len);
+	return mei_write_message(dev, mei_hdr, (unsigned char *) flow_ctrl);
 }
 
 /**
@@ -346,11 +344,11 @@ int mei_other_client_is_connecting(struct mei_device *dev,
  */
 int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr *hdr;
 	struct hbm_client_connect_request *req;
 	const size_t len = sizeof(struct hbm_client_connect_request);
 
-	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
 
 	req = (struct hbm_client_connect_request *)&dev->wr_msg_buf[1];
 	memset(req, 0, len);
@@ -359,7 +357,7 @@ int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 	req->me_addr = cl->me_client_id;
 	req->reserved = 0;
 
-	return mei_write_message(dev, mei_hdr, (unsigned char *)req, len);
+	return mei_write_message(dev, hdr, (unsigned char *)req);
 }
 
 /**
@@ -372,11 +370,11 @@ int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
  */
 int mei_connect(struct mei_device *dev, struct mei_cl *cl)
 {
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr *hdr;
 	struct hbm_client_connect_request *req;
 	const size_t len = sizeof(struct hbm_client_connect_request);
 
-	mei_hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
+	hdr = mei_hbm_hdr(&dev->wr_msg_buf[0], len);
 
 	req = (struct hbm_client_connect_request *) &dev->wr_msg_buf[1];
 	req->hbm_cmd = CLIENT_CONNECT_REQ_CMD;
@@ -384,5 +382,5 @@ int mei_connect(struct mei_device *dev, struct mei_cl *cl)
 	req->me_addr = cl->me_client_id;
 	req->reserved = 0;
 
-	return mei_write_message(dev, mei_hdr, (unsigned char *) req, len);
+	return mei_write_message(dev, hdr, (unsigned char *) req);
 }
diff --git a/drivers/misc/mei/interface.h b/drivers/misc/mei/interface.h
index ec6c785..ca73299 100644
--- a/drivers/misc/mei/interface.h
+++ b/drivers/misc/mei/interface.h
@@ -29,9 +29,8 @@ void mei_read_slots(struct mei_device *dev,
 		     unsigned long buffer_length);
 
 int mei_write_message(struct mei_device *dev,
-			     struct mei_msg_hdr *header,
-			     unsigned char *write_buffer,
-			     unsigned long write_length);
+			struct mei_msg_hdr *header,
+			unsigned char *buf);
 
 bool mei_hbuf_is_empty(struct mei_device *dev);
 
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 04fa213..b72fa81 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -465,7 +465,7 @@ static void mei_client_disconnect_request(struct mei_device *dev,
  * @mei_hdr: header of bus message
  */
 static void mei_irq_thread_read_bus_message(struct mei_device *dev,
-		struct mei_msg_hdr *mei_hdr)
+		struct mei_msg_hdr *hdr)
 {
 	struct mei_bus_message *mei_msg;
 	struct mei_me_client *me_client;
@@ -479,8 +479,8 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	struct hbm_host_stop_request *stop_req;
 
 	/* read the message to our buffer */
-	BUG_ON(mei_hdr->length >= sizeof(dev->rd_msg_buf));
-	mei_read_slots(dev, dev->rd_msg_buf, mei_hdr->length);
+	BUG_ON(hdr->length >= sizeof(dev->rd_msg_buf));
+	mei_read_slots(dev, dev->rd_msg_buf, hdr->length);
 	mei_msg = (struct mei_bus_message *)dev->rd_msg_buf;
 
 	switch (mei_msg->hbm_cmd) {
@@ -506,14 +506,13 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 			dev->version = version_res->me_max_version;
 
 			/* send stop message */
-			mei_hdr = mei_hbm_hdr(&buf[0], len);
+			hdr = mei_hbm_hdr(&buf[0], len);
 			stop_req = (struct hbm_host_stop_request *)&buf[1];
 			memset(stop_req, 0, len);
 			stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
 			stop_req->reason = DRIVER_STOP_REQUEST;
 
-			mei_write_message(dev, mei_hdr,
-					(unsigned char *)stop_req, len);
+			mei_write_message(dev, hdr, (unsigned char *)stop_req);
 			dev_dbg(&dev->pdev->dev, "version mismatch.\n");
 			return;
 		}
@@ -615,7 +614,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 
 		const size_t len = sizeof(struct hbm_host_stop_request);
 
-		mei_hdr = mei_hbm_hdr((u32 *)&dev->wr_ext_msg.hdr, len);
+		hdr = mei_hbm_hdr((u32 *)&dev->wr_ext_msg.hdr, len);
 		stop_req = (struct hbm_host_stop_request *)&dev->wr_ext_msg.data;
 		memset(stop_req, 0, len);
 		stop_req->hbm_cmd = HOST_STOP_REQ_CMD;
@@ -748,7 +747,7 @@ static int mei_irq_thread_write_complete(struct mei_device *dev, s32 *slots,
 
 	*slots -=  msg_slots;
 	if (mei_write_message(dev, mei_hdr,
-		cb->request_buffer.data + cb->buf_idx, len)) {
+			cb->request_buffer.data + cb->buf_idx)) {
 		cl->status = -ENODEV;
 		list_move_tail(&cb->list, &cmpl_list->list);
 		return -ENODEV;
@@ -930,7 +929,7 @@ static int mei_irq_thread_write_handler(struct mei_device *dev,
 
 	if (dev->wr_ext_msg.hdr.length) {
 		mei_write_message(dev, &dev->wr_ext_msg.hdr,
-			dev->wr_ext_msg.data, dev->wr_ext_msg.hdr.length);
+				dev->wr_ext_msg.data);
 		slots -= mei_data2slots(dev->wr_ext_msg.hdr.length);
 		dev->wr_ext_msg.hdr.length = 0;
 	}
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 43fb52f..b281c23 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -554,8 +554,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 	mei_hdr.reserved = 0;
 	dev_dbg(&dev->pdev->dev, "call mei_write_message header=%08x.\n",
 	    *((u32 *) &mei_hdr));
-	if (mei_write_message(dev, &mei_hdr,
-		write_cb->request_buffer.data, mei_hdr.length)) {
+	if (mei_write_message(dev, &mei_hdr, write_cb->request_buffer.data)) {
 		rets = -ENODEV;
 		goto err;
 	}
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index 636409f..fe19945 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -101,22 +101,22 @@ int mei_wd_host_init(struct mei_device *dev)
  */
 int mei_wd_send(struct mei_device *dev)
 {
-	struct mei_msg_hdr *mei_hdr;
+	struct mei_msg_hdr *hdr;
 
-	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-	mei_hdr->host_addr = dev->wd_cl.host_client_id;
-	mei_hdr->me_addr = dev->wd_cl.me_client_id;
-	mei_hdr->msg_complete = 1;
-	mei_hdr->reserved = 0;
+	hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	hdr->host_addr = dev->wd_cl.host_client_id;
+	hdr->me_addr = dev->wd_cl.me_client_id;
+	hdr->msg_complete = 1;
+	hdr->reserved = 0;
 
 	if (!memcmp(dev->wd_data, mei_start_wd_params, MEI_WD_HDR_SIZE))
-		mei_hdr->length = MEI_WD_START_MSG_SIZE;
+		hdr->length = MEI_WD_START_MSG_SIZE;
 	else if (!memcmp(dev->wd_data, mei_stop_wd_params, MEI_WD_HDR_SIZE))
-		mei_hdr->length = MEI_WD_STOP_MSG_SIZE;
+		hdr->length = MEI_WD_STOP_MSG_SIZE;
 	else
 		return -EINVAL;
 
-	return mei_write_message(dev, mei_hdr, dev->wd_data, mei_hdr->length);
+	return mei_write_message(dev, hdr, dev->wd_data);
 }
 
 /**
-- 
1.7.4.4

