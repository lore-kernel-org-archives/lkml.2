Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2BXBj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:39:26 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:48576 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2BXBjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:25 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.136.146 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 1/9] mei: cosmetic cleanup in interrupt.c
Date: Thu, 23 Feb 2012 20:38:48 -0500
Message-Id: <1330047536-3827-2-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

Tabs, spaces, long lines, lines that could be combined, superfluous
parentheses, etc.  Also uses DIV_ROUND_UP and sizeof(*ptr) where
appropriate.

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/init.c        |    2 +-
 drivers/staging/mei/interrupt.c   |  239 +++++++++++++++++--------------------
 drivers/staging/mei/mei_dev.h     |    3 +-
 drivers/staging/mei/mei_version.h |    6 +-
 drivers/staging/mei/wd.c          |   23 ++--
 5 files changed, 131 insertions(+), 142 deletions(-)

diff --git a/drivers/staging/mei/init.c b/drivers/staging/mei/init.c
index 4ac3696..1a00ede 100644
--- a/drivers/staging/mei/init.c
+++ b/drivers/staging/mei/init.c
@@ -455,7 +455,7 @@ void mei_allocate_me_clients_storage(struct mei_device *dev)
  * @dev: the device structure
  *
  * returns:
- * 	< 0 - Error.
+ *  < 0 - Error.
  *  = 0 - no more clients.
  *  = 1 - still have clients to send properties request.
  */
diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 3544fee..4914589 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -14,7 +14,6 @@
  *
  */
 
-
 #include <linux/pci.h>
 #include <linux/kthread.h>
 #include <linux/interrupt.h>
@@ -26,7 +25,6 @@
 #include "hw.h"
 #include "interface.h"
 
-
 /**
  * mei_interrupt_quick_handler - The ISR of the MEI device
  *
@@ -69,7 +67,6 @@ static void _mei_cmpl(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
 		cl->reading_state = MEI_READ_COMPLETE;
 		if (waitqueue_active(&cl->rx_wait))
 			wake_up_interruptible(&cl->rx_wait);
-
 	}
 }
 
@@ -101,7 +98,6 @@ static void _mei_cmpl_iamthif(struct mei_device *dev, struct mei_cl_cb *cb_pos)
 	wake_up_interruptible(&dev->iamthif_cl.wait);
 }
 
-
 /**
  * mei_irq_thread_read_amthi_message - bottom half read routine after ISR to
  * handle the read amthi message data processing.
@@ -150,14 +146,13 @@ static int mei_irq_thread_read_amthi_message(struct mei_io_list *complete_list,
 		return -ENODEV;
 
 	dev->iamthif_stall_timer = 0;
-	cb->information =	dev->iamthif_msg_buf_index;
+	cb->information = dev->iamthif_msg_buf_index;
 	cb->read_time = jiffies;
 	if (dev->iamthif_ioctl && cl == &dev->iamthif_cl) {
 		/* found the iamthif cb */
 		dev_dbg(&dev->pdev->dev, "complete the amthi read cb.\n ");
 		dev_dbg(&dev->pdev->dev, "add the amthi read cb to complete.\n ");
-		list_add_tail(&cb->cb_list,
-						&complete_list->mei_cb.cb_list);
+		list_add_tail(&cb->cb_list, &complete_list->mei_cb.cb_list);
 	}
 	return 0;
 }
@@ -266,11 +261,10 @@ quit:
  */
 static int _mei_irq_thread_iamthif_read(struct mei_device *dev, s32 *slots)
 {
-
 	if (((*slots) * sizeof(u32)) >= (sizeof(struct mei_msg_hdr)
 			+ sizeof(struct hbm_flow_control))) {
-		*slots -= (sizeof(struct mei_msg_hdr) +
-				sizeof(struct hbm_flow_control) + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+				sizeof(struct hbm_flow_control), sizeof(u32));
 		if (!mei_send_flow_control(dev, &dev->iamthif_cl)) {
 			dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
 		} else {
@@ -307,8 +301,9 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 {
 	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_disconnect_request))) {
-		*slots -= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_disconnect_request) + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_disconnect_request),
+			sizeof(u32));
 
 		if (!mei_disconnect(dev, cl)) {
 			cl->status = 0;
@@ -345,7 +340,7 @@ static bool is_treat_specially_client(struct mei_cl *cl,
 {
 
 	if (cl->host_client_id == rs->host_addr &&
-	    cl->me_client_id == rs->me_addr) {
+			cl->me_client_id == rs->me_addr) {
 		if (!rs->status) {
 			cl->state = MEI_FILE_CONNECTED;
 			cl->status = 0;
@@ -449,7 +444,7 @@ static void mei_client_disconnect_response(struct mei_device *dev,
 
 		dev_dbg(&dev->pdev->dev, "list_for_each_entry_safe in ctrl_rd_list.\n");
 		if (cl->host_client_id == rs->host_addr &&
-		    cl->me_client_id == rs->me_addr) {
+					cl->me_client_id == rs->me_addr) {
 
 			list_del(&cb_pos->cb_list);
 			if (!rs->status)
@@ -483,7 +478,7 @@ static int same_flow_addr(struct mei_cl *cl, struct hbm_flow_control *flow)
  * @flow: flow control.
  */
 static void add_single_flow_creds(struct mei_device *dev,
-				  struct hbm_flow_control *flow)
+				struct hbm_flow_control *flow)
 {
 	struct mei_me_client *client;
 	int i;
@@ -494,9 +489,9 @@ static void add_single_flow_creds(struct mei_device *dev,
 			if (client->props.single_recv_buf) {
 				client->mei_flow_ctrl_creds++;
 				dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single).\n",
-				    flow->me_addr);
+						flow->me_addr);
 				dev_dbg(&dev->pdev->dev, "flow control credentials =%d.\n",
-				    client->mei_flow_ctrl_creds);
+						client->mei_flow_ctrl_creds);
 			} else {
 				BUG();	/* error in flow control */
 			}
@@ -526,18 +521,18 @@ static void mei_client_flow_control_response(struct mei_device *dev,
 			dev_dbg(&dev->pdev->dev, "list_for_each_entry_safe in file_list\n");
 
 			dev_dbg(&dev->pdev->dev, "cl of host client %d ME client %d.\n",
-			    cl_pos->host_client_id,
-			    cl_pos->me_client_id);
+						cl_pos->host_client_id,
+						cl_pos->me_client_id);
 			dev_dbg(&dev->pdev->dev, "flow ctrl msg for host %d ME %d.\n",
-			    flow_control->host_addr,
-			    flow_control->me_addr);
+						flow_control->host_addr,
+						flow_control->me_addr);
 			if (same_flow_addr(cl_pos, flow_control)) {
 				dev_dbg(&dev->pdev->dev, "recv ctrl msg for host  %d ME %d.\n",
-				    flow_control->host_addr,
-				    flow_control->me_addr);
+							flow_control->host_addr,
+							flow_control->me_addr);
 				cl_pos->mei_flow_ctrl_creds++;
 				dev_dbg(&dev->pdev->dev, "flow control credentials = %d.\n",
-				    cl_pos->mei_flow_ctrl_creds);
+						cl_pos->mei_flow_ctrl_creds);
 				break;
 			}
 		}
@@ -553,7 +548,7 @@ static void mei_client_flow_control_response(struct mei_device *dev,
  * returns !=0, same; 0,not.
  */
 static int same_disconn_addr(struct mei_cl *cl,
-			     struct hbm_client_disconnect_request *disconn)
+			struct hbm_client_disconnect_request *disconn)
 {
 	return (cl->host_client_id == disconn->host_addr &&
 		cl->me_client_id == disconn->me_addr);
@@ -591,8 +586,7 @@ static void mei_client_disconnect_request(struct mei_device *dev,
 				(struct mei_msg_hdr *) &dev->ext_msg_buf[0];
 			mei_hdr->host_addr = 0;
 			mei_hdr->me_addr = 0;
-			mei_hdr->length =
-				sizeof(struct hbm_client_connect_response);
+			mei_hdr->length = sizeof(*disconnect_res);
 			mei_hdr->msg_complete = 1;
 			mei_hdr->reserved = 0;
 
@@ -610,7 +604,6 @@ static void mei_client_disconnect_request(struct mei_device *dev,
 	}
 }
 
-
 /**
  * mei_irq_thread_read_bus_message - bottom half read routine after ISR to
  * handle the read bus message cmd processing.
@@ -647,7 +640,8 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 			dev->version.major_version = HBM_MAJOR_VERSION;
 			dev->version.minor_version = HBM_MINOR_VERSION;
 			if (dev->mei_state == MEI_INIT_CLIENTS &&
-			    dev->init_clients_state == MEI_START_MESSAGE) {
+					dev->init_clients_state ==
+					MEI_START_MESSAGE) {
 				dev->init_clients_timer = 0;
 				mei_host_enum_clients_message(dev);
 			} else {
@@ -661,21 +655,19 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 			/* send stop message */
 			mei_hdr->host_addr = 0;
 			mei_hdr->me_addr = 0;
-			mei_hdr->length = sizeof(struct hbm_host_stop_request);
+			mei_hdr->length = sizeof(*host_stop_req);
 			mei_hdr->msg_complete = 1;
 			mei_hdr->reserved = 0;
 
 			host_stop_req = (struct hbm_host_stop_request *)
 							&dev->wr_msg_buf[1];
 
-			memset(host_stop_req,
-					0,
-					sizeof(struct hbm_host_stop_request));
+			memset(host_stop_req, 0, sizeof(*host_stop_req));
 			host_stop_req->cmd.cmd = HOST_STOP_REQ_CMD;
 			host_stop_req->reason = DRIVER_STOP_REQUEST;
 			mei_write_message(dev, mei_hdr,
-					   (unsigned char *) (host_stop_req),
-					   mei_hdr->length);
+					(unsigned char *) (host_stop_req),
+					mei_hdr->length);
 			dev_dbg(&dev->pdev->dev, "version mismatch.\n");
 			return;
 		}
@@ -685,16 +677,14 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
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
@@ -720,12 +710,12 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 						= props_res->client_properties;
 
 			if (dev->mei_state == MEI_INIT_CLIENTS &&
-			    dev->init_clients_state ==
+					dev->init_clients_state ==
 					MEI_CLIENT_PROPERTIES_MESSAGE) {
 				dev->me_client_index++;
 				dev->me_client_presentation_num++;
 
-				/** Send Client Propeties request **/
+				/* Send Client Properties request */
 				res = mei_host_client_properties(dev);
 				if (res < 0) {
 					dev_dbg(&dev->pdev->dev, "mei_host_client_properties() failed");
@@ -733,24 +723,28 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 				} else if (!res) {
 					/*
 					 * No more clients to send to.
-					 * Clear Map for indicating now ME clients
-					 * with associated host client
+					 * Clear Map for indicating now ME
+					 * clients with associated host client
 					 */
-					bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
+					bitmap_zero(dev->host_clients_map,
+							MEI_CLIENTS_MAX);
 					dev->open_handle_count = 0;
 
 					/*
 					 * Reserving the first three client IDs
-					 * Client Id 0 - Reserved for MEI Bus Message communications
+					 * Client Id 0 - Reserved for MEI Bus
+					 *               Message communications
 					 * Client Id 1 - Reserved for Watchdog
 					 * Client ID 2 - Reserved for AMTHI
 					 */
 					bitmap_set(dev->host_clients_map, 0, 3);
 					dev->mei_state = MEI_ENABLED;
 
-					/* if wd initialization fails, initialization the AMTHI client,
-					 * otherwise the AMTHI client will be initialized after the WD client connect response
-					 * will be received
+					/* if wd initialization fails,
+					 * initialize the AMTHI client,
+					 * otherwise the AMTHI client will be
+					 * initialized after the WD client
+					 * connect response is received
 					 */
 					if (mei_wd_host_init(dev))
 						mei_host_init_iamthif(dev);
@@ -772,14 +766,15 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 		enum_res = (struct hbm_host_enum_response *) mei_msg;
 		memcpy(dev->me_clients_map, enum_res->valid_addresses, 32);
 		if (dev->mei_state == MEI_INIT_CLIENTS &&
-		    dev->init_clients_state == MEI_ENUM_CLIENTS_MESSAGE) {
-				dev->init_clients_timer = 0;
-				dev->me_client_presentation_num = 0;
-				dev->me_client_index = 0;
-				mei_allocate_me_clients_storage(dev);
-				dev->init_clients_state =
-					MEI_CLIENT_PROPERTIES_MESSAGE;
-				mei_host_client_properties(dev);
+				dev->init_clients_state ==
+				MEI_ENUM_CLIENTS_MESSAGE) {
+			dev->init_clients_timer = 0;
+			dev->me_client_presentation_num = 0;
+			dev->me_client_index = 0;
+			mei_allocate_me_clients_storage(dev);
+			dev->init_clients_state =
+				MEI_CLIENT_PROPERTIES_MESSAGE;
+			mei_host_client_properties(dev);
 		} else {
 			dev_dbg(&dev->pdev->dev, "reset due to received host enumeration clients response bus message.\n");
 			mei_reset(dev, 1);
@@ -805,12 +800,12 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 		mei_hdr = (struct mei_msg_hdr *) &dev->ext_msg_buf[0];
 		mei_hdr->host_addr = 0;
 		mei_hdr->me_addr = 0;
-		mei_hdr->length = sizeof(struct hbm_host_stop_request);
+		mei_hdr->length = sizeof(*host_stop_req);
 		mei_hdr->msg_complete = 1;
 		mei_hdr->reserved = 0;
 		host_stop_req =
 			(struct hbm_host_stop_request *) &dev->ext_msg_buf[1];
-		memset(host_stop_req, 0, sizeof(struct hbm_host_stop_request));
+		memset(host_stop_req, 0, sizeof(*host_stop_req));
 		host_stop_req->cmd.cmd = HOST_STOP_REQ_CMD;
 		host_stop_req->reason = DRIVER_STOP_REQUEST;
 		host_stop_req->reserved[0] = 0;
@@ -821,11 +816,9 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 	default:
 		BUG();
 		break;
-
 	}
 }
 
-
 /**
  * _mei_hb_read - processes read related operation.
  *
@@ -837,15 +830,15 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
+static int _mei_irq_thread_read(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
 			struct mei_io_list *cmpl_list)
 {
 	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_flow_control))) {
-		*slots -= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_flow_control) + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_flow_control), sizeof(u32));
 		if (!mei_send_flow_control(dev, cl)) {
 			cl->status = -ENODEV;
 			cb_pos->information = 0;
@@ -865,7 +858,6 @@ static int _mei_irq_thread_read(struct mei_device *dev,	s32 *slots,
 	return 0;
 }
 
-
 /**
  * _mei_irq_thread_ioctl - processes ioctl related operation.
  *
@@ -885,8 +877,8 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_connect_request))) {
 		cl->state = MEI_FILE_CONNECTING;
-		*slots -= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_connect_request) + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_connect_request), sizeof(u32));
 		if (!mei_connect(dev, cl)) {
 			cl->status = -ENODEV;
 			cb_pos->information = 0;
@@ -917,7 +909,7 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
  *
  * returns 0, OK; otherwise, error.
  */
-static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
+static int _mei_irq_thread_cmpl(struct mei_device *dev, s32 *slots,
 			struct mei_cl_cb *cb_pos,
 			struct mei_cl *cl,
 			struct mei_io_list *cmpl_list)
@@ -942,8 +934,8 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 				cb_pos->information);
 		dev_dbg(&dev->pdev->dev, "mei_hdr->length  =%d\n",
 				mei_hdr->length);
-		*slots -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+				mei_hdr->length, sizeof(u32));
 		if (!mei_write_message(dev, mei_hdr,
 				(unsigned char *)
 				(cb_pos->request_buffer.data +
@@ -966,13 +958,12 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
 		mei_hdr->host_addr = cl->host_client_id;
 		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length =
-			(*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		mei_hdr->length = (*slots * sizeof(u32)) - sizeof(*mei_hdr);
 		mei_hdr->msg_complete = 0;
 		mei_hdr->reserved = 0;
 
-		(*slots) -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+				mei_hdr->length, sizeof(u32));
 		if (!mei_write_message(dev, mei_hdr,
 					(unsigned char *)
 					(cb_pos->request_buffer.data +
@@ -1031,8 +1022,8 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 		mei_hdr->msg_complete = 1;
 		mei_hdr->reserved = 0;
 
-		*slots -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+				mei_hdr->length, sizeof(u32));
 
 		if (!mei_write_message(dev, mei_hdr,
 					(dev->iamthif_msg_buf +
@@ -1061,13 +1052,12 @@ static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
 		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
 		mei_hdr->host_addr = cl->host_client_id;
 		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length =
-			(*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		mei_hdr->length = (*slots * sizeof(u32)) - sizeof(*mei_hdr);
 		mei_hdr->msg_complete = 0;
 		mei_hdr->reserved = 0;
 
-		*slots -= (sizeof(struct mei_msg_hdr) +
-				mei_hdr->length + 3) / 4;
+		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+				mei_hdr->length, sizeof(u32));
 
 		if (!mei_write_message(dev, mei_hdr,
 					(dev->iamthif_msg_buf +
@@ -1129,7 +1119,8 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 					cl_pos->host_client_id,
 					cl_pos->me_client_id);
 			if (cl_pos->host_client_id == mei_hdr->host_addr &&
-			    cl_pos->me_client_id == mei_hdr->me_addr)
+					cl_pos->me_client_id ==
+					mei_hdr->me_addr)
 				break;
 		}
 
@@ -1154,8 +1145,8 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 		mei_irq_thread_read_bus_message(dev, mei_hdr);
 		dev_dbg(&dev->pdev->dev, "end mei_irq_thread_read_bus_message.\n");
 	} else if (mei_hdr->host_addr == dev->iamthif_cl.host_client_id &&
-		   (MEI_FILE_CONNECTED == dev->iamthif_cl.state) &&
-		   (dev->iamthif_state == MEI_IAMTHIF_READING)) {
+				(MEI_FILE_CONNECTED == dev->iamthif_cl.state) &&
+				(dev->iamthif_state == MEI_IAMTHIF_READING)) {
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_iamthif_message.\n");
 		dev_dbg(&dev->pdev->dev, "mei_hdr->length =%d\n",
 				mei_hdr->length);
@@ -1167,7 +1158,7 @@ static int mei_irq_thread_read_handler(struct mei_io_list *cmpl_list,
 	} else {
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_client_message.\n");
 		ret = mei_irq_thread_read_client_message(cmpl_list,
-							 dev, mei_hdr);
+							dev, mei_hdr);
 		if (ret)
 			goto end;
 
@@ -1188,7 +1179,6 @@ end:
 	return ret;
 }
 
-
 /**
  * mei_irq_thread_write_handler - bottom half write routine after
  * ISR to handle the write processing.
@@ -1220,15 +1210,15 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	list = &dev->write_waiting_list;
 	list_for_each_entry_safe(pos, next,
 			&list->mei_cb.cb_list, cb_list) {
-		cl = (struct mei_cl *)pos->file_private;
+		cl = (struct mei_cl *) pos->file_private;
 		if (cl == NULL)
 			continue;
 
 		cl->status = 0;
 		list_del(&pos->cb_list);
 		if (MEI_WRITING == cl->writing_state &&
-		   (pos->major_file_operations == MEI_WRITE) &&
-		   (cl != &dev->iamthif_cl)) {
+				(pos->major_file_operations == MEI_WRITE) &&
+				(cl != &dev->iamthif_cl)) {
 			dev_dbg(&dev->pdev->dev,
 				"MEI WRITE COMPLETE\n");
 			cl->writing_state = MEI_WRITE_COMPLETE;
@@ -1274,12 +1264,14 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			dev->wd_pending = false;
 
 			if (dev->wd_timeout) {
-				*slots -= (sizeof(struct mei_msg_hdr) +
-					 MEI_START_WD_DATA_SIZE + 3) / 4;
+				*slots -= DIV_ROUND_UP(
+					sizeof(struct mei_msg_hdr) +
+					MEI_START_WD_DATA_SIZE, sizeof(u32));
 				dev->wd_due_counter = 2;
 			} else {
-				*slots -= (sizeof(struct mei_msg_hdr) +
-					 MEI_WD_PARAMS_SIZE + 3) / 4;
+				*slots -= DIV_ROUND_UP(
+					sizeof(struct mei_msg_hdr) +
+					MEI_WD_PARAMS_SIZE, sizeof(u32));
 				dev->wd_due_counter = 0;
 			}
 
@@ -1300,34 +1292,32 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 		switch (pos->major_file_operations) {
 		case MEI_CLOSE:
 			/* send disconnect message */
-			ret = _mei_irq_thread_close(dev, slots, pos, cl, cmpl_list);
+			ret = _mei_irq_thread_close(dev, slots, pos, cl,
+					cmpl_list);
 			if (ret)
 				return ret;
-
 			break;
 		case MEI_READ:
 			/* send flow control message */
-			ret = _mei_irq_thread_read(dev, slots, pos, cl, cmpl_list);
+			ret = _mei_irq_thread_read(dev, slots, pos, cl,
+					cmpl_list);
 			if (ret)
 				return ret;
-
 			break;
 		case MEI_IOCTL:
 			/* connect message */
 			if (mei_other_client_is_connecting(dev, cl))
 				continue;
-			ret = _mei_irq_thread_ioctl(dev, slots, pos, cl, cmpl_list);
+			ret = _mei_irq_thread_ioctl(dev, slots, pos, cl,
+					cmpl_list);
 			if (ret)
 				return ret;
-
 			break;
-
 		default:
 			BUG();
 		}
-
 	}
-	/* complete  write list CB */
+	/* complete write list CB */
 	dev_dbg(&dev->pdev->dev, "complete write list cb.\n");
 	list_for_each_entry_safe(pos, next,
 			&dev->write_list.mei_cb.cb_list, cb_list) {
@@ -1339,14 +1329,13 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			if (!mei_flow_ctrl_creds(dev, cl)) {
 				dev_dbg(&dev->pdev->dev,
 					"No flow control"
-				    " credentials for client"
-				    " %d, not sending.\n",
-				    cl->host_client_id);
+					" credentials for client"
+					" %d, not sending.\n",
+					cl->host_client_id);
 				continue;
 			}
-			ret = _mei_irq_thread_cmpl(dev, slots,
-					    pos,
-					    cl, cmpl_list);
+			ret = _mei_irq_thread_cmpl(dev, slots, pos, cl,
+					cmpl_list);
 			if (ret)
 				return ret;
 
@@ -1356,15 +1345,12 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 			if (!mei_flow_ctrl_creds(dev, cl)) {
 				dev_dbg(&dev->pdev->dev,
 					"No flow control"
-				    " credentials for amthi"
-				    " client %d.\n",
-				    cl->host_client_id);
+					" credentials for amthi"
+					" client %d.\n",
+					cl->host_client_id);
 				continue;
 			}
-			ret = _mei_irq_thread_cmpl_iamthif(dev,
-						slots,
-						pos,
-						cl,
+			ret = _mei_irq_thread_cmpl_iamthif(dev, slots, pos, cl,
 						cmpl_list);
 			if (ret)
 				return ret;
@@ -1375,8 +1361,6 @@ static int mei_irq_thread_write_handler(struct mei_io_list *cmpl_list,
 	return 0;
 }
 
-
-
 /**
  * mei_timer - timer function.
  *
@@ -1390,13 +1374,12 @@ void mei_timer(struct work_struct *work)
 	struct mei_cl *cl_pos = NULL;
 	struct mei_cl *cl_next = NULL;
 	struct list_head *amthi_complete_list = NULL;
-	struct mei_cl_cb  *cb_pos = NULL;
-	struct mei_cl_cb  *cb_next = NULL;
+	struct mei_cl_cb *cb_pos = NULL;
+	struct mei_cl_cb *cb_next = NULL;
 
 	struct mei_device *dev = container_of(work,
 					struct mei_device, timer_work.work);
 
-
 	mutex_lock(&dev->device_lock);
 	if (dev->mei_state != MEI_ENABLED) {
 		if (dev->mei_state == MEI_INIT_CLIENTS) {
@@ -1410,7 +1393,7 @@ void mei_timer(struct work_struct *work)
 		}
 		goto out;
 	}
-	/*** connect/disconnect timeouts ***/
+	/* connect/disconnect timeouts */
 	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
 		if (cl_pos->timer_count) {
 			if (--cl_pos->timer_count == 0) {
@@ -1442,7 +1425,6 @@ void mei_timer(struct work_struct *work)
 	}
 
 	if (dev->iamthif_timer) {
-
 		timeout = dev->iamthif_timer +
 				msecs_to_jiffies(IAMTHIF_READ_TIMER);
 
@@ -1461,7 +1443,8 @@ void mei_timer(struct work_struct *work)
 			amthi_complete_list = &dev->amthi_read_complete_list.
 					mei_cb.cb_list;
 
-			list_for_each_entry_safe(cb_pos, cb_next, amthi_complete_list, cb_list) {
+			list_for_each_entry_safe(cb_pos, cb_next,
+					amthi_complete_list, cb_list) {
 
 				cl_pos = cb_pos->file_object->private_data;
 
@@ -1486,8 +1469,8 @@ out:
 }
 
 /**
- *  mei_interrupt_thread_handler - function called after ISR to handle the interrupt
- * processing.
+ * mei_interrupt_thread_handler - function called after ISR to handle the
+ * interrupt processing.
  *
  * @irq: The irq number
  * @dev_id: pointer to the device structure
@@ -1503,8 +1486,7 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 	struct mei_cl *cl;
 	s32 slots;
 	int rets;
-	bool  bus_message_received;
-
+	bool bus_message_received;
 
 	dev_dbg(&dev->pdev->dev, "function called after ISR to handle the interrupt processing.\n");
 	/* initialize our complete list */
@@ -1521,15 +1503,15 @@ irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
 
 	/* check if ME wants a reset */
 	if ((dev->me_hw_state & ME_RDY_HRA) == 0 &&
-	    dev->mei_state != MEI_RESETING &&
-	    dev->mei_state != MEI_INITIALIZING) {
+			dev->mei_state != MEI_RESETING &&
+			dev->mei_state != MEI_INITIALIZING) {
 		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
 		mei_reset(dev, 1);
 		mutex_unlock(&dev->device_lock);
 		return IRQ_HANDLED;
 	}
 
-	/*  check if we need to start the dev */
+	/* check if we need to start the dev */
 	if ((dev->host_hw_state & H_RDY) == 0) {
 		if ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA) {
 			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
@@ -1581,7 +1563,6 @@ end:
 	if (list_empty(&complete_list.mei_cb.cb_list))
 		return IRQ_HANDLED;
 
-
 	list_for_each_entry_safe(cb_pos, cb_next,
 			&complete_list.mei_cb.cb_list, cb_list) {
 		cl = (struct mei_cl *)cb_pos->file_private;
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index 82bacfc..8ed54da 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -271,7 +271,8 @@ int mei_hw_init(struct mei_device *dev);
 int mei_task_initialize_clients(void *data);
 int mei_initialize_clients(struct mei_device *dev);
 int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl);
-void mei_remove_client_from_file_list(struct mei_device *dev, u8 host_client_id);
+void mei_remove_client_from_file_list(struct mei_device *dev,
+		u8 host_client_id);
 void mei_host_init_iamthif(struct mei_device *dev);
 void mei_allocate_me_clients_storage(struct mei_device *dev);
 
diff --git a/drivers/staging/mei/mei_version.h b/drivers/staging/mei/mei_version.h
index 075bad8..70de574 100644
--- a/drivers/staging/mei/mei_version.h
+++ b/drivers/staging/mei/mei_version.h
@@ -23,9 +23,9 @@
 #define QUICK_FIX_NUMBER	20
 #define VER_BUILD		1
 
-#define MEI_DRV_VER1 __stringify(MAJOR_VERSION) "." __stringify(MINOR_VERSION)
-#define MEI_DRV_VER2 __stringify(QUICK_FIX_NUMBER) "." __stringify(VER_BUILD)
+#define MEI_DRV_VER1 (__stringify(MAJOR_VERSION) "." __stringify(MINOR_VERSION))
+#define MEI_DRV_VER2 (__stringify(QUICK_FIX_NUMBER) "." __stringify(VER_BUILD))
 
-#define MEI_DRIVER_VERSION	MEI_DRV_VER1 "." MEI_DRV_VER2
+#define MEI_DRIVER_VERSION	(MEI_DRV_VER1 "." MEI_DRV_VER2)
 
 #endif
diff --git a/drivers/staging/mei/wd.c b/drivers/staging/mei/wd.c
index 8094941..e1b6b2e 100644
--- a/drivers/staging/mei/wd.c
+++ b/drivers/staging/mei/wd.c
@@ -75,7 +75,8 @@ bool mei_wd_host_init(struct mei_device *dev)
 	dev_dbg(&dev->pdev->dev, "check wd_cl\n");
 	if (MEI_FILE_CONNECTING == dev->wd_cl.state) {
 		if (!mei_connect(dev, &dev->wd_cl)) {
-			dev_dbg(&dev->pdev->dev, "Failed to connect to WD client\n");
+			dev_dbg(&dev->pdev->dev,
+					"Failed to connect to WD client\n");
 			dev->wd_cl.state = MEI_FILE_DISCONNECTED;
 			dev->wd_cl.host_client_id = 0;
 			ret = false;
@@ -210,13 +211,15 @@ static int mei_wd_ops_start(struct watchdog_device *wd_dev)
 	mutex_lock(&dev->device_lock);
 
 	if (dev->mei_state != MEI_ENABLED) {
-		dev_dbg(&dev->pdev->dev, "mei_state != MEI_ENABLED  mei_state= %d\n",
-		    dev->mei_state);
+		dev_dbg(&dev->pdev->dev,
+			"mei_state != MEI_ENABLED  mei_state= %d\n",
+			dev->mei_state);
 		goto end_unlock;
 	}
 
 	if (dev->wd_cl.state != MEI_FILE_CONNECTED)	{
-		dev_dbg(&dev->pdev->dev, "MEI Driver is not connected to Watchdog Client\n");
+		dev_dbg(&dev->pdev->dev,
+			"MEI Driver is not connected to Watchdog Client\n");
 		goto end_unlock;
 	}
 
@@ -288,7 +291,8 @@ static int mei_wd_ops_ping(struct watchdog_device *wd_dev)
 		}
 
 		if (mei_flow_ctrl_reduce(dev, &dev->wd_cl)) {
-			dev_dbg(&dev->pdev->dev, "mei_flow_ctrl_reduce() failed.\n");
+			dev_dbg(&dev->pdev->dev,
+					"mei_flow_ctrl_reduce() failed.\n");
 			ret = -EIO;
 			goto end;
 		}
@@ -310,7 +314,8 @@ end:
  *
  * returns 0 if success, negative errno code for failure
  */
-static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev, unsigned int timeout)
+static int mei_wd_ops_set_timeout(struct watchdog_device *wd_dev,
+		unsigned int timeout)
 {
 	struct mei_device *dev;
 	dev = pci_get_drvdata(mei_device);
@@ -363,10 +368,12 @@ void  mei_watchdog_register(struct mei_device *dev)
 	dev->wd_due_counter = !!dev->wd_timeout;
 
 	if (watchdog_register_device(&amt_wd_dev)) {
-		dev_err(&dev->pdev->dev, "unable to register watchdog device.\n");
+		dev_err(&dev->pdev->dev,
+				"unable to register watchdog device.\n");
 		dev->wd_interface_reg = false;
 	} else {
-		dev_dbg(&dev->pdev->dev, "successfully register watchdog interface.\n");
+		dev_dbg(&dev->pdev->dev,
+				"successfully register watchdog interface.\n");
 		dev->wd_interface_reg = true;
 	}
 }
-- 
1.7.9.2

