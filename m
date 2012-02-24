Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2BXBki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 20:40:38 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63832 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab2BXBjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 20:39:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of djpohly@gmail.com designates 10.229.69.96 as permitted sender) smtp.mail=djpohly@gmail.com; dkim=pass header.i=djpohly@gmail.com
From: "Devin J. Pohly" <djpohly@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, "Devin J. Pohly" <djpohly@gmail.com>
Subject: [PATCH 6/9] mei: reduce indentation with early returns
Date: Thu, 23 Feb 2012 20:38:53 -0500
Message-Id: <1330047536-3827-7-git-send-email-djpohly@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
References: <1330047536-3827-1-git-send-email-djpohly@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Devin J. Pohly" <djpohly@gmail.com>

Rather than check an error condition in the last part of an if-else set,
check it up front, return, and then don't bother with the "else" part.

Signed-off-by: Devin J. Pohly <djpohly@gmail.com>
---
 drivers/staging/mei/interrupt.c |  352 +++++++++++++++++++--------------------
 1 file changed, 170 insertions(+), 182 deletions(-)

diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index ade5574..541d018 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -261,26 +261,26 @@ out:
  */
 static int _mei_irq_thread_iamthif_read(struct mei_device *dev, s32 *slots)
 {
-	if (((*slots) * sizeof(u32)) >= (sizeof(struct mei_msg_hdr)
-			+ sizeof(struct hbm_flow_control))) {
-		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
-				sizeof(struct hbm_flow_control), sizeof(u32));
-		if (!mei_send_flow_control(dev, &dev->iamthif_cl)) {
-			dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
-		} else {
-			dev_dbg(&dev->pdev->dev, "iamthif flow control success\n");
-			dev->iamthif_state = MEI_IAMTHIF_READING;
-			dev->iamthif_flow_control_pending = false;
-			dev->iamthif_msg_buf_index = 0;
-			dev->iamthif_msg_buf_size = 0;
-			dev->iamthif_stall_timer = IAMTHIF_STALL_TIMER;
-			dev->mei_host_buffer_is_empty =
-					mei_host_buffer_is_empty(dev);
-		}
-		return 0;
-	} else {
+	if (*slots * sizeof(u32) < (sizeof(struct mei_msg_hdr)
+			+ sizeof(struct hbm_flow_control)))
 		return -EMSGSIZE;
+	*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_flow_control),
+			sizeof(u32));
+	if (!mei_send_flow_control(dev, &dev->iamthif_cl)) {
+		dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
+		return 0;
 	}
+
+	dev_dbg(&dev->pdev->dev, "iamthif flow control success\n");
+	dev->iamthif_state = MEI_IAMTHIF_READING;
+	dev->iamthif_flow_control_pending = false;
+	dev->iamthif_msg_buf_index = 0;
+	dev->iamthif_msg_buf_size = 0;
+	dev->iamthif_stall_timer = IAMTHIF_STALL_TIMER;
+	dev->mei_host_buffer_is_empty =
+		mei_host_buffer_is_empty(dev);
+	return 0;
 }
 
 /**
@@ -299,31 +299,27 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 				struct mei_cl *cl,
 				struct mei_io_list *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_disconnect_request))) {
-		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_disconnect_request)))
+		return -EBADMSG;
+
+	*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_disconnect_request),
 			sizeof(u32));
 
-		if (!mei_disconnect(dev, cl)) {
-			cl->status = 0;
-			cb_pos->information = 0;
-			list_move_tail(&cb_pos->cb_list,
-					&cmpl_list->mei_cb.cb_list);
-			return -EMSGSIZE;
-		} else {
-			cl->state = MEI_FILE_DISCONNECTING;
-			cl->status = 0;
-			cb_pos->information = 0;
-			list_move_tail(&cb_pos->cb_list,
-					&dev->ctrl_rd_list.mei_cb.cb_list);
-			cl->timer_count = MEI_CONNECT_TIMEOUT;
-		}
-	} else {
-		/* return the cancel routine */
-		return -EBADMSG;
+	if (!mei_disconnect(dev, cl)) {
+		cl->status = 0;
+		cb_pos->information = 0;
+		list_move_tail(&cb_pos->cb_list, &cmpl_list->mei_cb.cb_list);
+		return -EMSGSIZE;
 	}
 
+	cl->state = MEI_FILE_DISCONNECTING;
+	cl->status = 0;
+	cb_pos->information = 0;
+	list_move_tail(&cb_pos->cb_list, &dev->ctrl_rd_list.mei_cb.cb_list);
+	cl->timer_count = MEI_CONNECT_TIMEOUT;
+
 	return 0;
 }
 
@@ -338,22 +334,20 @@ static int _mei_irq_thread_close(struct mei_device *dev, s32 *slots,
 static bool is_treat_specially_client(struct mei_cl *cl,
 		struct hbm_client_connect_response *rs)
 {
+	if (cl->host_client_id != rs->host_addr ||
+				cl->me_client_id != rs->me_addr)
+		return false;
 
-	if (cl->host_client_id == rs->host_addr &&
-			cl->me_client_id == rs->me_addr) {
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
+	if (!rs->status) {
+		cl->state = MEI_FILE_CONNECTED;
+		cl->status = 0;
+	} else {
+		cl->state = MEI_FILE_DISCONNECTED;
+		cl->status = -ENODEV;
 	}
-	return false;
+	cl->timer_count = 0;
+
+	return true;
 }
 
 /**
@@ -486,15 +480,14 @@ static void add_single_flow_creds(struct mei_device *dev,
 	for (i = 0; i < dev->me_clients_num; i++) {
 		client = &dev->me_clients[i];
 		if (client && flow->me_addr == client->client_id) {
-			if (client->props.single_recv_buf) {
-				client->mei_flow_ctrl_creds++;
-				dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single).\n",
-						flow->me_addr);
-				dev_dbg(&dev->pdev->dev, "flow control credentials =%d.\n",
-						client->mei_flow_ctrl_creds);
-			} else {
-				BUG();	/* error in flow control */
-			}
+			/* bug on error in flow control */
+			BUG_ON(!client->props.single_recv_buf);
+
+			client->mei_flow_ctrl_creds++;
+			dev_dbg(&dev->pdev->dev, "recv flow ctrl msg ME %d (single).\n",
+					flow->me_addr);
+			dev_dbg(&dev->pdev->dev, "flow control credentials =%d.\n",
+					client->mei_flow_ctrl_creds);
 		}
 	}
 }
@@ -569,38 +562,37 @@ static void mei_client_disconnect_request(struct mei_device *dev,
 	struct mei_cl *cl_next = NULL;
 
 	list_for_each_entry_safe(cl_pos, cl_next, &dev->file_list, link) {
-		if (same_disconn_addr(cl_pos, disconnect_req)) {
-			dev_dbg(&dev->pdev->dev, "disconnect request host client %d ME client %d.\n",
-					disconnect_req->host_addr,
-					disconnect_req->me_addr);
-			cl_pos->state = MEI_FILE_DISCONNECTED;
-			cl_pos->timer_count = 0;
-			if (cl_pos == &dev->wd_cl) {
-				dev->wd_due_counter = 0;
-				dev->wd_pending = false;
-			} else if (cl_pos == &dev->iamthif_cl)
-				dev->iamthif_timer = 0;
-
-			/* prepare disconnect response */
-			mei_hdr =
-				(struct mei_msg_hdr *) &dev->ext_msg_buf[0];
-			mei_hdr->host_addr = 0;
-			mei_hdr->me_addr = 0;
-			mei_hdr->length = sizeof(*disconnect_res);
-			mei_hdr->msg_complete = 1;
-			mei_hdr->reserved = 0;
+		if (!same_disconn_addr(cl_pos, disconnect_req))
+			continue;
 
-			disconnect_res =
-				(struct hbm_client_connect_response *)
-				&dev->ext_msg_buf[1];
-			disconnect_res->host_addr = cl_pos->host_client_id;
-			disconnect_res->me_addr = cl_pos->me_client_id;
-			*(u8 *) (&disconnect_res->cmd) =
-				CLIENT_DISCONNECT_RES_CMD;
-			disconnect_res->status = 0;
-			dev->extra_write_index = 2;
-			break;
+		dev_dbg(&dev->pdev->dev, "disconnect request host client %d ME client %d.\n",
+				disconnect_req->host_addr,
+				disconnect_req->me_addr);
+		cl_pos->state = MEI_FILE_DISCONNECTED;
+		cl_pos->timer_count = 0;
+		if (cl_pos == &dev->wd_cl) {
+			dev->wd_due_counter = 0;
+			dev->wd_pending = false;
+		} else if (cl_pos == &dev->iamthif_cl) {
+			dev->iamthif_timer = 0;
 		}
+
+		/* prepare disconnect response */
+		mei_hdr = (struct mei_msg_hdr *) &dev->ext_msg_buf[0];
+		mei_hdr->host_addr = 0;
+		mei_hdr->me_addr = 0;
+		mei_hdr->length = sizeof(*disconnect_res);
+		mei_hdr->msg_complete = 1;
+		mei_hdr->reserved = 0;
+
+		disconnect_res = (struct hbm_client_connect_response *)
+			&dev->ext_msg_buf[1];
+		disconnect_res->host_addr = cl_pos->host_client_id;
+		disconnect_res->me_addr = cl_pos->me_client_id;
+		*(u8 *) (&disconnect_res->cmd) = CLIENT_DISCONNECT_RES_CMD;
+		disconnect_res->status = 0;
+		dev->extra_write_index = 2;
+		break;
 	}
 }
 
@@ -704,82 +696,82 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 			return;
 		}
 		if (dev->me_clients[dev->me_client_presentation_num]
-					.client_id == props_res->address) {
-
-			dev->me_clients[dev->me_client_presentation_num].props
-						= props_res->client_properties;
+					.client_id != props_res->address) {
+			dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message for wrong client ID\n");
+			mei_reset(dev, 1);
+			return;
+		}
 
-			if (dev->mei_state == MEI_INIT_CLIENTS &&
-					dev->init_clients_state ==
-					MEI_CLIENT_PROPERTIES_MESSAGE) {
-				dev->me_client_index++;
-				dev->me_client_presentation_num++;
-
-				/* Send Client Properties request */
-				res = mei_host_client_properties(dev);
-				if (res < 0) {
-					dev_dbg(&dev->pdev->dev, "mei_host_client_properties() failed");
-					return;
-				} else if (!res) {
-					/*
-					 * No more clients to send to.
-					 * Clear Map for indicating now ME
-					 * clients with associated host client
-					 */
-					bitmap_zero(dev->host_clients_map,
-							MEI_CLIENTS_MAX);
-					dev->open_handle_count = 0;
-
-					/*
-					 * Reserving the first three client IDs
-					 * Client Id 0 - Reserved for MEI Bus
-					 *               Message communications
-					 * Client Id 1 - Reserved for Watchdog
-					 * Client ID 2 - Reserved for AMTHI
-					 */
-					bitmap_set(dev->host_clients_map, 0, 3);
-					dev->mei_state = MEI_ENABLED;
-
-					/* if wd initialization fails,
-					 * initialize the AMTHI client,
-					 * otherwise the AMTHI client will be
-					 * initialized after the WD client
-					 * connect response is received
-					 */
-					if (mei_wd_host_init(dev))
-						mei_host_init_iamthif(dev);
-				}
+		dev->me_clients[dev->me_client_presentation_num].props
+					= props_res->client_properties;
 
-			} else {
-				dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message");
-				mei_reset(dev, 1);
-				return;
-			}
-		} else {
-			dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message for wrong client ID\n");
+		if (dev->mei_state != MEI_INIT_CLIENTS ||
+				dev->init_clients_state !=
+				MEI_CLIENT_PROPERTIES_MESSAGE) {
+			dev_dbg(&dev->pdev->dev, "reset due to received host client properties response bus message");
 			mei_reset(dev, 1);
 			return;
 		}
+
+		dev->me_client_index++;
+		dev->me_client_presentation_num++;
+
+		/* Send Client Properties request */
+		res = mei_host_client_properties(dev);
+		if (res < 0) {
+			dev_dbg(&dev->pdev->dev, "mei_host_client_properties() failed");
+			return;
+		}
+		if (res)
+			break;
+
+		/*
+		 * No more clients to send to.
+		 * Clear Map for indicating now ME
+		 * clients with associated host client
+		 */
+		bitmap_zero(dev->host_clients_map,
+				MEI_CLIENTS_MAX);
+		dev->open_handle_count = 0;
+
+		/*
+		 * Reserving the first three client IDs
+		 * Client Id 0 - Reserved for MEI Bus
+		 *               Message communications
+		 * Client Id 1 - Reserved for Watchdog
+		 * Client ID 2 - Reserved for AMTHI
+		 */
+		bitmap_set(dev->host_clients_map, 0, 3);
+		dev->mei_state = MEI_ENABLED;
+
+		/* if wd initialization fails,
+		 * initialize the AMTHI client,
+		 * otherwise the AMTHI client will be
+		 * initialized after the WD client
+		 * connect response is received
+		 */
+		if (mei_wd_host_init(dev))
+			mei_host_init_iamthif(dev);
 		break;
 
 	case HOST_ENUM_RES_CMD:
 		enum_res = (struct hbm_host_enum_response *) mei_msg;
 		memcpy(dev->me_clients_map, enum_res->valid_addresses, 32);
-		if (dev->mei_state == MEI_INIT_CLIENTS &&
-				dev->init_clients_state ==
-				MEI_ENUM_CLIENTS_MESSAGE) {
-			dev->init_clients_timer = 0;
-			dev->me_client_presentation_num = 0;
-			dev->me_client_index = 0;
-			mei_allocate_me_clients_storage(dev);
-			dev->init_clients_state =
-				MEI_CLIENT_PROPERTIES_MESSAGE;
-			mei_host_client_properties(dev);
-		} else {
+		if (dev->mei_state != MEI_INIT_CLIENTS ||
+					dev->init_clients_state !=
+					MEI_ENUM_CLIENTS_MESSAGE) {
 			dev_dbg(&dev->pdev->dev, "reset due to received host enumeration clients response bus message.\n");
 			mei_reset(dev, 1);
 			return;
 		}
+
+		dev->init_clients_timer = 0;
+		dev->me_client_presentation_num = 0;
+		dev->me_client_index = 0;
+		mei_allocate_me_clients_storage(dev);
+		dev->init_clients_state =
+			MEI_CLIENT_PROPERTIES_MESSAGE;
+		mei_host_client_properties(dev);
 		break;
 
 	case HOST_STOP_RES_CMD:
@@ -835,26 +827,24 @@ static int _mei_irq_thread_read(struct mei_device *dev, s32 *slots,
 			struct mei_cl *cl,
 			struct mei_io_list *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_flow_control))) {
-		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_flow_control), sizeof(u32));
-		if (!mei_send_flow_control(dev, cl)) {
-			cl->status = -ENODEV;
-			cb_pos->information = 0;
-			list_move_tail(&cb_pos->cb_list,
-					&cmpl_list->mei_cb.cb_list);
-			return -ENODEV;
-		} else {
-			list_move_tail(&cb_pos->cb_list,
-					&dev->read_list.mei_cb.cb_list);
-		}
-	} else {
 		/* return the cancel routine */
 		list_del(&cb_pos->cb_list);
 		return -EBADMSG;
 	}
+	*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+		sizeof(struct hbm_flow_control), sizeof(u32));
+	if (!mei_send_flow_control(dev, cl)) {
+		cl->status = -ENODEV;
+		cb_pos->information = 0;
+		list_move_tail(&cb_pos->cb_list,
+				&cmpl_list->mei_cb.cb_list);
+		return -ENODEV;
+	}
 
+	list_move_tail(&cb_pos->cb_list,
+			&dev->read_list.mei_cb.cb_list);
 	return 0;
 }
 
@@ -874,26 +864,24 @@ static int _mei_irq_thread_ioctl(struct mei_device *dev, s32 *slots,
 			struct mei_cl *cl,
 			struct mei_io_list *cmpl_list)
 {
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+	if ((*slots * sizeof(u32)) < (sizeof(struct mei_msg_hdr) +
 			sizeof(struct hbm_client_connect_request))) {
-		cl->state = MEI_FILE_CONNECTING;
-		*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
-			sizeof(struct hbm_client_connect_request), sizeof(u32));
-		if (!mei_connect(dev, cl)) {
-			cl->status = -ENODEV;
-			cb_pos->information = 0;
-			list_del(&cb_pos->cb_list);
-			return -ENODEV;
-		} else {
-			list_move_tail(&cb_pos->cb_list,
-				&dev->ctrl_rd_list.mei_cb.cb_list);
-			cl->timer_count = MEI_CONNECT_TIMEOUT;
-		}
-	} else {
 		/* return the cancel routine */
 		list_del(&cb_pos->cb_list);
 		return -EBADMSG;
 	}
+	cl->state = MEI_FILE_CONNECTING;
+	*slots -= DIV_ROUND_UP(sizeof(struct mei_msg_hdr) +
+		sizeof(struct hbm_client_connect_request), sizeof(u32));
+	if (!mei_connect(dev, cl)) {
+		cl->status = -ENODEV;
+		cb_pos->information = 0;
+		list_del(&cb_pos->cb_list);
+		return -ENODEV;
+	}
+	list_move_tail(&cb_pos->cb_list,
+			&dev->ctrl_rd_list.mei_cb.cb_list);
+	cl->timer_count = MEI_CONNECT_TIMEOUT;
 
 	return 0;
 }
-- 
1.7.9.2

