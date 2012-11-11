Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab2KKPi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 10:38:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:12053 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab2KKPiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 10:38:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,757,1344236400"; 
   d="scan'208";a="217934068"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 7/7] mei: use the same bus msg for connect and disconnect request
Date: Sun, 11 Nov 2012 17:38:04 +0200
Message-Id: <1352648284-8838-7-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
References: <1352648284-8838-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

structs hbm_client_connect_request and hbm_client_disconnect_request
have the same layout so we can drop the later

Add kdoc for the request and response structure so it is clear
they can be used for both purposes

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw.h        |   22 ++++++++++++++++------
 drivers/misc/mei/interface.c |   22 ++++++++++------------
 drivers/misc/mei/interrupt.c |   17 ++++++++---------
 3 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/misc/mei/hw.h b/drivers/misc/mei/hw.h
index f21721a..be8ca6b 100644
--- a/drivers/misc/mei/hw.h
+++ b/drivers/misc/mei/hw.h
@@ -293,6 +293,14 @@ struct hbm_props_response {
 	struct mei_client_properties client_properties;
 } __packed;
 
+/**
+ * struct hbm_client_connect_request - connect/disconnect request
+ *
+ * @hbm_cmd - bus message command header
+ * @me_addr - address of the client in ME
+ * @host_addr - address of the client in the driver
+ * @reserved
+ */
 struct hbm_client_connect_request {
 	u8 hbm_cmd;
 	u8 me_addr;
@@ -300,6 +308,14 @@ struct hbm_client_connect_request {
 	u8 reserved;
 } __packed;
 
+/**
+ * struct hbm_client_connect_response - connect/disconnect response
+ *
+ * @hbm_cmd - bus message command header
+ * @me_addr - address of the client in ME
+ * @host_addr - address of the client in the driver
+ * @status - status of the request
+ */
 struct hbm_client_connect_response {
 	u8 hbm_cmd;
 	u8 me_addr;
@@ -307,12 +323,6 @@ struct hbm_client_connect_response {
 	u8 status;
 } __packed;
 
-struct hbm_client_disconnect_request {
-	u8 hbm_cmd;
-	u8 me_addr;
-	u8 host_addr;
-	u8 reserved[1];
-} __packed;
 
 #define MEI_FC_MESSAGE_RESERVED_LENGTH           5
 
diff --git a/drivers/misc/mei/interface.c b/drivers/misc/mei/interface.c
index 509c395..6b50cf0 100644
--- a/drivers/misc/mei/interface.c
+++ b/drivers/misc/mei/interface.c
@@ -352,26 +352,24 @@ int mei_other_client_is_connecting(struct mei_device *dev,
 int mei_disconnect(struct mei_device *dev, struct mei_cl *cl)
 {
 	struct mei_msg_hdr *mei_hdr;
-	struct hbm_client_disconnect_request *mei_cli_disconnect;
+	struct hbm_client_connect_request *req;
 
 	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
 	mei_hdr->host_addr = 0;
 	mei_hdr->me_addr = 0;
-	mei_hdr->length = sizeof(struct hbm_client_disconnect_request);
+	mei_hdr->length = sizeof(struct hbm_client_connect_request);
 	mei_hdr->msg_complete = 1;
 	mei_hdr->reserved = 0;
 
-	mei_cli_disconnect =
-	    (struct hbm_client_disconnect_request *) &dev->wr_msg_buf[1];
-	memset(mei_cli_disconnect, 0, sizeof(*mei_cli_disconnect));
-	mei_cli_disconnect->host_addr = cl->host_client_id;
-	mei_cli_disconnect->me_addr = cl->me_client_id;
-	mei_cli_disconnect->hbm_cmd = CLIENT_DISCONNECT_REQ_CMD;
-	mei_cli_disconnect->reserved[0] = 0;
+	req = (struct hbm_client_connect_request *)&dev->wr_msg_buf[1];
+	memset(req, 0, sizeof(*req));
+	req->host_addr = cl->host_client_id;
+	req->me_addr = cl->me_client_id;
+	req->hbm_cmd = CLIENT_DISCONNECT_REQ_CMD;
+	req->reserved = 0;
 
-	return mei_write_message(dev, mei_hdr,
-				(unsigned char *) mei_cli_disconnect,
-				sizeof(struct hbm_client_disconnect_request));
+	return mei_write_message(dev, mei_hdr, (unsigned char *)req,
+				sizeof(struct hbm_client_connect_request));
 }
 
 /**
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 34e20cc..f882101 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -174,10 +174,10 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 				struct mei_cl_cb *cmpl_list)
 {
 	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_disconnect_request)))
+			sizeof(struct hbm_client_connect_request)))
 		return -EBADMSG;
 
-	*slots -= mei_data2slots(sizeof(struct hbm_client_disconnect_request));
+	*slots -= mei_data2slots(sizeof(struct hbm_client_connect_request));
 
 	if (mei_disconnect(dev, cl)) {
 		cl->status = 0;
@@ -414,10 +414,10 @@ static void mei_client_flow_control_response(struct mei_device *dev,
  * returns !=0, same; 0,not.
  */
 static int same_disconn_addr(struct mei_cl *cl,
-			     struct hbm_client_disconnect_request *disconn)
+			     struct hbm_client_connect_request *req)
 {
-	return (cl->host_client_id == disconn->host_addr &&
-		cl->me_client_id == disconn->me_addr);
+	return (cl->host_client_id == req->host_addr &&
+		cl->me_client_id == req->me_addr);
 }
 
 /**
@@ -427,7 +427,7 @@ static int same_disconn_addr(struct mei_cl *cl,
  * @disconnect_req: disconnect request bus message.
  */
 static void mei_client_disconnect_request(struct mei_device *dev,
-		struct hbm_client_disconnect_request *disconnect_req)
+		struct hbm_client_connect_request *disconnect_req)
 {
 	struct mei_msg_hdr *mei_hdr;
 	struct hbm_client_connect_response *disconnect_res;
@@ -484,10 +484,10 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	struct hbm_host_version_response *version_res;
 	struct hbm_client_connect_response *connect_res;
 	struct hbm_client_connect_response *disconnect_res;
+	struct hbm_client_connect_request *disconnect_req;
 	struct hbm_flow_control *flow_control;
 	struct hbm_props_response *props_res;
 	struct hbm_host_enum_response *enum_res;
-	struct hbm_client_disconnect_request *disconnect_req;
 	struct hbm_host_stop_request *host_stop_req;
 	int res;
 
@@ -653,8 +653,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 
 	case CLIENT_DISCONNECT_REQ_CMD:
 		/* search for client */
-		disconnect_req =
-			(struct hbm_client_disconnect_request *) mei_msg;
+		disconnect_req = (struct hbm_client_connect_request *)mei_msg;
 		mei_client_disconnect_request(dev, disconnect_req);
 		break;
 
-- 
1.7.4.4

