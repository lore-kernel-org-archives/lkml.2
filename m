Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab1BJJzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:55:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:28196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097Ab1BJJzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:43 -0500
Message-Id: <1bdc18$jhtkoq@fmsmga002.fm.intel.com>
Date: 10 Feb 2011 01:55:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="656331560"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 08/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/interrupt.c b/drivers/char/mei/interrupt.c
new file mode 100644
index 0000000..89f8879
--- /dev/null
+++ b/drivers/char/mei/interrupt.c
@@ -0,0 +1,1552 @@
+/*
+ *
+ * Intel(R) Management Engine Interface (Intel(R) MEI) Linux driver
+ * Copyright (c) 2003-2011, Intel Corporation.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+
+#include <linux/kthread.h>
+#include <linux/interrupt.h>
+
+#include "mei.h"
+#include "interface.h"
+
+
+/**
+ * mei_interrupt_quick_handler - The ISR of the MEI device
+ *
+ * @irq: The irq number
+ * @dev_id: pointer to the device structure
+ *
+ * returns irqreturn_t
+ */
+irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id)
+{
+	struct iamt_mei_device *dev = (struct iamt_mei_device *) dev_id;
+
+	dev->host_hw_state = get_host_hw_state(dev);
+
+	if ((dev->host_hw_state & H_IS) != H_IS)
+		return IRQ_NONE;
+	/* clear H_IS bit in H_CSR */
+	mei_csr_clear_his(dev);
+
+	return IRQ_WAKE_THREAD;
+}
+
+/**
+ * _mei_cmpl - processes completed operation.
+ *
+ * @file_ext: private data of the file object.
+ * @priv_cb_pos: callback block.
+ */
+static void _mei_cmpl(struct mei_file_private *file_ext,
+				struct mei_cb_private *priv_cb_pos)
+{
+	if (priv_cb_pos->major_file_operations == MEI_WRITE) {
+		mei_free_cb_private(priv_cb_pos);
+		priv_cb_pos = NULL;
+		DBG("completing write call back.\n");
+		file_ext->writing_state = MEI_WRITE_COMPLETE;
+		if ((&file_ext->tx_wait) &&
+		    waitqueue_active(&file_ext->tx_wait))
+			wake_up_interruptible(&file_ext->tx_wait);
+
+	} else if (priv_cb_pos->major_file_operations == MEI_READ
+				&& MEI_READING == file_ext->reading_state) {
+		DBG("completing read call back information = %lu\n",
+				priv_cb_pos->information);
+		file_ext->reading_state = MEI_READ_COMPLETE;
+		if ((&file_ext->rx_wait) &&
+		    waitqueue_active(&file_ext->rx_wait))
+			wake_up_interruptible(&file_ext->rx_wait);
+
+	}
+}
+
+/**
+ * _mei_cmpl_iamthif - processes completed iamthif operation.
+ *
+ * @dev: the device structure.
+ * @priv_cb_pos: callback block.
+ */
+static void _mei_cmpl_iamthif(struct iamt_mei_device *dev,
+				struct mei_cb_private *priv_cb_pos)
+{
+	if (dev->iamthif_canceled != 1) {
+		dev->iamthif_state = MEI_IAMTHIF_READ_COMPLETE;
+		dev->iamthif_stall_timer = 0;
+		memcpy(priv_cb_pos->response_buffer.data,
+				dev->iamthif_msg_buf,
+				dev->iamthif_msg_buf_index);
+		list_add_tail(&priv_cb_pos->cb_list,
+				&dev->pthi_read_complete_list.mei_cb.cb_list);
+		DBG("pthi read completed.\n");
+	} else {
+		run_next_iamthif_cmd(dev);
+	}
+
+	DBG("completing pthi call back.\n");
+	wake_up_interruptible(&dev->iamthif_file_ext.wait);
+}
+
+
+/**
+ * mei_irq_thread_read_pthi_message - bottom half read routine after ISR to
+ * handle the read pthi message data processing.
+ *
+ * @complete_list: An instance of our list structure
+ * @dev: the device structure
+ * @mei_hdr: header of pthi message
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_irq_thread_read_pthi_message(struct io_mei_list *complete_list,
+		struct iamt_mei_device *dev,
+		struct mei_msg_hdr *mei_hdr)
+{
+	struct mei_file_private *file_ext;
+	struct mei_cb_private *priv_cb;
+	unsigned char *buffer;
+
+	BUG_ON(mei_hdr->me_addr != dev->iamthif_file_ext.me_client_id);
+	BUG_ON(dev->iamthif_state != MEI_IAMTHIF_READING);
+
+	buffer = (unsigned char *) (dev->iamthif_msg_buf +
+			dev->iamthif_msg_buf_index);
+	BUG_ON(dev->iamthif_mtu < dev->iamthif_msg_buf_index + mei_hdr->length);
+
+	mei_read_slots(dev, buffer, mei_hdr->length);
+
+	dev->iamthif_msg_buf_index += mei_hdr->length;
+
+	if (!(mei_hdr->msg_complete))
+		return 0;
+
+	DBG("pthi_message_buffer_index =%d\n", mei_hdr->length);
+	DBG("completed pthi read.\n ");
+	if (!dev->iamthif_current_cb)
+		return -ENODEV;
+
+	priv_cb = dev->iamthif_current_cb;
+	dev->iamthif_current_cb = NULL;
+
+	file_ext = (struct mei_file_private *)priv_cb->file_private;
+	if (!file_ext)
+		return -ENODEV;
+
+	dev->iamthif_stall_timer = 0;
+	priv_cb->information =	dev->iamthif_msg_buf_index;
+	priv_cb->read_time = get_seconds();
+	if ((dev->iamthif_ioctl) && (file_ext == &dev->iamthif_file_ext)) {
+		/* found the iamthif cb */
+		DBG("complete the pthi read cb.\n ");
+		DBG("add the pthi read cb to complete.\n ");
+		list_add_tail(&priv_cb->cb_list, &complete_list->mei_cb.cb_list);
+	}
+	return 0;
+}
+
+/**
+ * _mei_irq_thread_state_ok - checks if mei header matches file private data
+ *
+ * @file_ext: private data of the file object
+ * @mei_hdr: header of mei client message
+ *
+ * returns !=0 if matches, 0 if no match.
+ */
+static int _mei_irq_thread_state_ok(struct mei_file_private *file_ext,
+					struct mei_msg_hdr *mei_hdr)
+{
+	return ((file_ext->host_client_id == mei_hdr->host_addr)
+		&& (file_ext->me_client_id == mei_hdr->me_addr)
+		&& (file_ext->state == MEI_FILE_CONNECTED)
+		&& (MEI_READ_COMPLETE != file_ext->reading_state));
+}
+
+/**
+ * mei_irq_thread_read_client_message - bottom half read routine after ISR to
+ * handle the read mei client message data processing.
+ *
+ * @complete_list: An instance of our list structure
+ * @dev: the device structure
+ * @mei_hdr: header of mei client message
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_irq_thread_read_client_message(struct io_mei_list *complete_list,
+		struct iamt_mei_device *dev,
+		struct mei_msg_hdr *mei_hdr)
+{
+	struct mei_file_private *file_ext;
+	struct mei_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+	unsigned char *buffer;
+
+	DBG("start client msg\n");
+	if (!((dev->read_list.status == 0) &&
+	      !list_empty(&dev->read_list.mei_cb.cb_list)))
+		goto quit;
+
+	list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+			&dev->read_list.mei_cb.cb_list, cb_list) {
+		file_ext = (struct mei_file_private *)
+				priv_cb_pos->file_private;
+		if ((file_ext != NULL) &&
+		    (_mei_irq_thread_state_ok(file_ext, mei_hdr))) {
+			file_ext->reading_state = MEI_READING;
+			buffer = (unsigned char *)
+				(priv_cb_pos->response_buffer.data +
+				priv_cb_pos->information);
+			BUG_ON(priv_cb_pos->response_buffer.size <
+					mei_hdr->length +
+					priv_cb_pos->information);
+
+			if (priv_cb_pos->response_buffer.size <
+					mei_hdr->length +
+					priv_cb_pos->information) {
+				DBG("message overflow.\n");
+				list_del(&priv_cb_pos->cb_list);
+				return -ENOMEM;
+			}
+			if (buffer) {
+				mei_read_slots(dev, buffer,
+						mei_hdr->length);
+			}
+			priv_cb_pos->information += mei_hdr->length;
+			if (mei_hdr->msg_complete) {
+				file_ext->status = 0;
+				list_del(&priv_cb_pos->cb_list);
+				DBG("completed read host client = %d,"
+					"ME client = %d, "
+					"data length = %lu\n",
+					file_ext->host_client_id,
+					file_ext->me_client_id,
+					priv_cb_pos->information);
+
+				*(priv_cb_pos->response_buffer.data +
+					priv_cb_pos->information) = '\0';
+				DBG("priv_cb_pos->res_buffer - %s\n",
+					priv_cb_pos->response_buffer.data);
+				list_add_tail(&priv_cb_pos->cb_list,
+					&complete_list->mei_cb.cb_list);
+			}
+
+			break;
+		}
+
+	}
+
+quit:
+	DBG("message read\n");
+	if (!buffer) {
+		mei_read_slots(dev, (unsigned char *) dev->rd_msg_buf,
+						mei_hdr->length);
+		DBG("discarding message, header =%08x.\n",
+				*(u32 *) dev->rd_msg_buf);
+	}
+
+	return 0;
+}
+
+/**
+ * _mei_irq_thread_iamthif_read - prepares to read iamthif data.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+static int _mei_irq_thread_iamthif_read(struct iamt_mei_device *dev, s32 *slots)
+{
+
+	if (((*slots) * sizeof(u32)) >= (sizeof(struct mei_msg_hdr)
+			+ sizeof(struct hbm_flow_control))) {
+		*slots -= (sizeof(struct mei_msg_hdr) +
+				sizeof(struct hbm_flow_control) + 3) / 4;
+		if (!mei_send_flow_control(dev, &dev->iamthif_file_ext)) {
+			DBG("iamthif flow control failed\n");
+		} else {
+			DBG("iamthif flow control success\n");
+			dev->iamthif_state = MEI_IAMTHIF_READING;
+			dev->iamthif_flow_control_pending = 0;
+			dev->iamthif_msg_buf_index = 0;
+			dev->iamthif_msg_buf_size = 0;
+			dev->iamthif_stall_timer = IAMTHIF_STALL_TIMER;
+			dev->host_buffer_is_empty = host_buffer_is_empty(dev);
+		}
+		return 0;
+	} else {
+		return -ECOMPLETE_MESSAGE;
+	}
+}
+
+/**
+ * _mei_irq_thread_close - processes close related operation.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ * @priv_cb_pos: callback block.
+ * @file_ext: private data of the file object.
+ * @cmpl_list: complete list.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+static int _mei_irq_thread_close(struct iamt_mei_device *dev,	s32 *slots,
+			struct mei_cb_private *priv_cb_pos,
+			struct mei_file_private *file_ext,
+			struct io_mei_list *cmpl_list)
+{
+	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_disconnect_request))) {
+		*slots -= (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_disconnect_request) + 3) / 4;
+
+		if (!mei_disconnect(dev, file_ext)) {
+			file_ext->status = 0;
+			priv_cb_pos->information = 0;
+			list_move_tail(&priv_cb_pos->cb_list,
+					&cmpl_list->mei_cb.cb_list);
+			return -ECOMPLETE_MESSAGE;
+		} else {
+			file_ext->state = MEI_FILE_DISCONNECTING;
+			file_ext->status = 0;
+			priv_cb_pos->information = 0;
+			list_move_tail(&priv_cb_pos->cb_list,
+					&dev->ctrl_rd_list.mei_cb.cb_list);
+			file_ext->timer_count = MEI_CONNECT_TIMEOUT;
+		}
+	} else {
+		/* return the cancel routine */
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * is_treat_specially_client - checks if the message belongs
+ * to the file private data.
+ *
+ * @file_ext: private data of the file object
+ * @rs: connect response bus message
+ * @dev: the device structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int is_treat_specially_client(struct mei_file_private *file_ext,
+		struct hbm_client_connect_response *rs)
+{
+	int ret = 0;
+
+	if ((file_ext->host_client_id == rs->host_addr) &&
+	    (file_ext->me_client_id == rs->me_addr)) {
+		if (rs->status == 0) {
+			DBG("client connect status = 0x%08x.\n", rs->status);
+			file_ext->state = MEI_FILE_CONNECTED;
+			file_ext->status = 0;
+
+		} else {
+			DBG("client connect status = 0x%08x.\n", rs->status);
+			file_ext->state = MEI_FILE_DISCONNECTED;
+			file_ext->status = -ENODEV;
+		}
+		file_ext->timer_count = 0;
+		ret = 1;
+	}
+	DBG("client state = %d.\n", file_ext->state);
+	return ret;
+}
+
+/**
+ * mei_client_connect_response - connects to response irq routine
+ *
+ * @dev: the device structure
+ * @rs: connect response bus message
+ */
+static void mei_client_connect_response(struct iamt_mei_device *dev,
+		struct hbm_client_connect_response *rs)
+{
+
+	struct mei_file_private *file_ext;
+	struct mei_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+
+	/* if WD or iamthif client treat specially */
+
+	if (is_treat_specially_client(&(dev->wd_file_ext), rs)) {
+		DBG("dev->wd_timeout =%d.\n", dev->wd_timeout);
+		if (dev->wd_timeout != 0)
+			dev->wd_due_counter = 1;
+		else
+			dev->wd_due_counter = 0;
+		DBG("successfully connected to WD client.\n");
+		host_init_iamthif(dev);
+		return;
+	}
+	if (is_treat_specially_client(&(dev->iamthif_file_ext), rs)) {
+
+		dev->iamthif_state = MEI_IAMTHIF_IDLE;
+		return;
+	}
+	if (dev->ctrl_rd_list.status == 0
+	    && !list_empty(&dev->ctrl_rd_list.mei_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+			&dev->ctrl_rd_list.mei_cb.cb_list, cb_list) {
+			file_ext = (struct mei_file_private *)
+					priv_cb_pos->file_private;
+			if (file_ext == NULL) {
+				list_del(&priv_cb_pos->cb_list);
+				return;
+			}
+			if (MEI_IOCTL == priv_cb_pos->major_file_operations) {
+				if (is_treat_specially_client(file_ext, rs)) {
+					list_del(&priv_cb_pos->cb_list);
+					file_ext->status = 0;
+					file_ext->timer_count = 0;
+					break;
+				}
+			}
+		}
+	}
+}
+
+/**
+ * mei_client_disconnect_response - disconnects from response irq routine
+ *
+ * @dev: the device structure
+ * @rs: disconnect response bus message
+ */
+static void mei_client_disconnect_response(struct iamt_mei_device *dev,
+					struct hbm_client_connect_response *rs)
+{
+	struct mei_file_private *file_ext;
+	struct mei_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+
+	if (dev->ctrl_rd_list.status == 0
+	    && !list_empty(&dev->ctrl_rd_list.mei_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->ctrl_rd_list.mei_cb.cb_list, cb_list) {
+			file_ext = (struct mei_file_private *)
+				priv_cb_pos->file_private;
+
+			if (file_ext == NULL) {
+				list_del(&priv_cb_pos->cb_list);
+				return;
+			}
+
+			DBG("list_for_each_entry_safe in ctrl_rd_list.\n");
+			if ((file_ext->host_client_id == rs->host_addr) &&
+				(file_ext->me_client_id == rs->me_addr)) {
+
+				list_del(&priv_cb_pos->cb_list);
+				if (rs->status == 0) {
+					file_ext->state =
+					    MEI_FILE_DISCONNECTED;
+				}
+
+				file_ext->status = 0;
+				file_ext->timer_count = 0;
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * same_flow_addr - tells if they have the same address.
+ *
+ * @file: private data of the file object.
+ * @flow: flow control.
+ *
+ * returns  !=0, same; 0,not.
+ */
+static int same_flow_addr(struct mei_file_private *file,
+					struct hbm_flow_control *flow)
+{
+	return ((file->host_client_id == flow->host_addr)
+		&& (file->me_client_id == flow->me_addr));
+}
+
+/**
+ * add_single_flow_creds - adds single buffer credentials.
+ *
+ * @file: private data ot the file object.
+ * @flow: flow control.
+ */
+static void add_single_flow_creds(struct iamt_mei_device *dev,
+				  struct hbm_flow_control *flow)
+{
+	struct mei_me_client *client;
+	int i;
+
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		client = &dev->me_clients[i];
+		if ((client != NULL) &&
+		    (flow->me_addr == client->client_id)) {
+			if (client->props.single_recv_buf != 0) {
+				client->flow_ctrl_creds++;
+				DBG("recv flow ctrl msg ME %d (single).\n",
+				    flow->me_addr);
+				DBG("flow control credentials =%d.\n",
+				    client->flow_ctrl_creds);
+			} else {
+				BUG();	/* error in flow control */
+			}
+		}
+	}
+}
+
+/**
+ * mei_client_flow_control_response - flow control response irq routine
+ *
+ * @dev: the device structure
+ * @flow_control: flow control response bus message
+ */
+static void mei_client_flow_control_response(struct iamt_mei_device *dev,
+		struct hbm_flow_control *flow_control)
+{
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+
+	if (flow_control->host_addr == 0) {
+		/* single receive buffer */
+		add_single_flow_creds(dev, flow_control);
+	} else {
+		/* normal connection */
+		list_for_each_entry_safe(file_pos, file_next,
+				&dev->file_list, link) {
+			DBG("list_for_each_entry_safe in file_list\n");
+
+			DBG("file_ext of host client %d ME client %d.\n",
+			    file_pos->host_client_id,
+			    file_pos->me_client_id);
+			DBG("flow ctrl msg for host %d ME %d.\n",
+			    flow_control->host_addr,
+			    flow_control->me_addr);
+			if (same_flow_addr(file_pos, flow_control)) {
+				DBG("recv ctrl msg for host  %d ME %d.\n",
+				    flow_control->host_addr,
+				    flow_control->me_addr);
+				file_pos->flow_ctrl_creds++;
+				DBG("flow control credentials = %d.\n",
+				    file_pos->flow_ctrl_creds);
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * same_disconn_addr - tells if they have the same address
+ *
+ * @file: private data of the file object.
+ * @disconn: disconnection request.
+ *
+ * returns !=0, same; 0,not.
+ */
+static int same_disconn_addr(struct mei_file_private *file,
+			     struct hbm_client_disconnect_request *disconn)
+{
+	return ((file->host_client_id == disconn->host_addr)
+		&& (file->me_client_id == disconn->me_addr));
+}
+
+/**
+ * mei_client_disconnect_request - disconnects from request irq routine
+ *
+ * @dev: the device structure.
+ * @disconnect_req: disconnect request bus message.
+ */
+static void mei_client_disconnect_request(struct iamt_mei_device *dev,
+		struct hbm_client_disconnect_request *disconnect_req)
+{
+	struct mei_msg_hdr *mei_hdr;
+	struct hbm_client_connect_response *disconnect_res;
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if (same_disconn_addr(file_pos, disconnect_req)) {
+			DBG("disconnect request host client %d ME client %d.\n",
+					disconnect_req->host_addr,
+					disconnect_req->me_addr);
+			file_pos->state = MEI_FILE_DISCONNECTED;
+			file_pos->timer_count = 0;
+			if (file_pos == &dev->wd_file_ext) {
+				dev->wd_due_counter = 0;
+				dev->wd_pending = 0;
+			} else if (file_pos == &dev->iamthif_file_ext)
+				dev->iamthif_timer = 0;
+
+			/* prepare disconnect response */
+			mei_hdr =
+				(struct mei_msg_hdr *) &dev->ext_msg_buf[0];
+			mei_hdr->host_addr = 0;
+			mei_hdr->me_addr = 0;
+			mei_hdr->length =
+				sizeof(struct hbm_client_connect_response);
+			mei_hdr->msg_complete = 1;
+			mei_hdr->reserved = 0;
+
+			disconnect_res =
+				(struct hbm_client_connect_response *)
+				&dev->ext_msg_buf[1];
+			disconnect_res->host_addr = file_pos->host_client_id;
+			disconnect_res->me_addr = file_pos->me_client_id;
+			*(u8 *) (&disconnect_res->cmd) =
+				CLIENT_DISCONNECT_RES_CMD;
+			disconnect_res->status = 0;
+			dev->extra_write_index = 2;
+			break;
+		}
+	}
+}
+
+
+/**
+ * mei_irq_thread_read_bus_message - bottom half read routine after ISR to
+ * handle the read bus message cmd processing.
+ *
+ * @dev: the device structure
+ * @mei_hdr: header of bus message
+ */
+static void mei_irq_thread_read_bus_message(struct iamt_mei_device *dev,
+		struct mei_msg_hdr *mei_hdr)
+{
+	struct mei_bus_message *mei_msg;
+	struct hbm_host_version_response *version_res;
+	struct hbm_client_connect_response *connect_res;
+	struct hbm_client_connect_response *disconnect_res;
+	struct hbm_flow_control *flow_control;
+	struct hbm_props_response *props_res;
+	struct hbm_host_enum_response *enum_res;
+	struct hbm_client_disconnect_request *disconnect_req;
+	struct hbm_host_stop_request *host_stop_req;
+
+	unsigned char *buffer;
+
+	/* read the message to our buffer */
+	buffer = (unsigned char *) dev->rd_msg_buf;
+	BUG_ON(mei_hdr->length >= sizeof(dev->rd_msg_buf));
+	mei_read_slots(dev, buffer, mei_hdr->length);
+	mei_msg = (struct mei_bus_message *) buffer;
+
+	switch (*(u8 *) mei_msg) {
+	case HOST_START_RES_CMD:
+		version_res = (struct hbm_host_version_response *) mei_msg;
+		if (version_res->host_version_supported) {
+			dev->version.major_version = HBM_MAJOR_VERSION;
+			dev->version.minor_version = HBM_MINOR_VERSION;
+			if ((dev->mei_state == MEI_INIT_CLIENTS) &&
+			    (dev->init_clients_state == MEI_START_MESSAGE)) {
+				dev->init_clients_timer = 0;
+				host_enum_clients_message(dev);
+			} else {
+				DBG("IMEI reset due to received host start response bus message.\n");
+				mei_reset(dev, 1);
+				return;
+			}
+		} else {
+			dev->version = version_res->me_max_version;
+			/* send stop message */
+			mei_hdr->host_addr = 0;
+			mei_hdr->me_addr = 0;
+			mei_hdr->length = sizeof(struct hbm_host_stop_request);
+			mei_hdr->msg_complete = 1;
+			mei_hdr->reserved = 0;
+
+			host_stop_req = (struct hbm_host_stop_request *)&dev->wr_msg_buf[1];
+
+			memset(host_stop_req, 0, sizeof(struct hbm_host_stop_request));
+			host_stop_req->cmd.cmd = HOST_STOP_REQ_CMD;
+			host_stop_req->reason = DRIVER_STOP_REQUEST;
+			mei_write_message(dev, mei_hdr,
+					   (unsigned char *) (host_stop_req),
+					   mei_hdr->length);
+			DBG("version mismatch.\n");
+			return;
+		}
+
+		dev->recvd_msg = 1;
+		DBG("host start response message received.\n");
+		break;
+
+	case CLIENT_CONNECT_RES_CMD:
+		connect_res =
+			(struct hbm_client_connect_response *) mei_msg;
+		mei_client_connect_response(dev, connect_res);
+		DBG("client connect response message received.\n");
+		wake_up(&dev->wait_recvd_msg);
+		break;
+
+	case CLIENT_DISCONNECT_RES_CMD:
+		disconnect_res =
+			(struct hbm_client_connect_response *) mei_msg;
+		mei_client_disconnect_response(dev,	 disconnect_res);
+		DBG("client disconnect response message received.\n");
+		wake_up(&dev->wait_recvd_msg);
+		break;
+
+	case MEI_FLOW_CONTROL_CMD:
+		flow_control = (struct hbm_flow_control *) mei_msg;
+		mei_client_flow_control_response(dev, flow_control);
+		DBG("client flow control response message received.\n");
+		break;
+
+	case HOST_CLIENT_PROPERTIES_RES_CMD:
+		props_res = (struct hbm_props_response *) mei_msg;
+		if (props_res->status != 0 || dev->me_clients == NULL) {
+			DBG("reset due to received host client properties response bus message wrong status.\n");
+		mei_reset(dev, 1);
+			return;
+		}
+	       if (dev->me_clients[dev->me_client_presentation_num].client_id == props_res->address) {
+			dev->me_clients[dev->me_client_presentation_num].props = props_res->client_properties;
+			if ((dev->mei_state == MEI_INIT_CLIENTS) &&
+			    (dev->init_clients_state
+					== MEI_CLIENT_PROPERTIES_MESSAGE)) {
+				dev->me_client_index++;
+				dev->me_client_presentation_num++;
+				host_client_properties(dev);
+			} else {
+				DBG("reset due to received host client properties response bus message");
+				mei_reset(dev, 1);
+				return;
+			}
+		} else {
+			DBG("reset due to received host client properties response bus message for wrong client ID\n");
+			mei_reset(dev, 1);
+			return;
+		}
+		break;
+
+	case HOST_ENUM_RES_CMD:
+		enum_res = (struct hbm_host_enum_response *) mei_msg;
+		memcpy(dev->mei_me_clients, enum_res->valid_addresses, 32);
+		if ((dev->mei_state == MEI_INIT_CLIENTS) &&
+		    (dev->init_clients_state == MEI_ENUM_CLIENTS_MESSAGE)) {
+				dev->init_clients_timer = 0;
+				dev->me_client_presentation_num = 0;
+				dev->me_client_index = 0;
+				allocate_me_clients_storage(dev);
+				dev->init_clients_state = MEI_CLIENT_PROPERTIES_MESSAGE;
+				host_client_properties(dev);
+		} else {
+			DBG("reset due to received host enumeration clients response bus message.\n");
+			mei_reset(dev, 1);
+			return;
+		}
+		break;
+
+	case HOST_STOP_RES_CMD:
+		dev->mei_state = MEI_DISABLED;
+		DBG("reseting because of FW stop response.\n");
+		mei_reset(dev, 1);
+		break;
+
+	case CLIENT_DISCONNECT_REQ_CMD:
+		/* search for client */
+		disconnect_req =
+			(struct hbm_client_disconnect_request *) mei_msg;
+		mei_client_disconnect_request(dev, disconnect_req);
+		break;
+
+	case ME_STOP_REQ_CMD:
+		/* prepare stop request */
+		mei_hdr = (struct mei_msg_hdr *) &dev->ext_msg_buf[0];
+		mei_hdr->host_addr = 0;
+		mei_hdr->me_addr = 0;
+		mei_hdr->length = sizeof(struct hbm_host_stop_request);
+		mei_hdr->msg_complete = 1;
+		mei_hdr->reserved = 0;
+		host_stop_req =
+			(struct hbm_host_stop_request *) &dev->ext_msg_buf[1];
+		memset(host_stop_req, 0, sizeof(struct hbm_host_stop_request));
+		host_stop_req->cmd.cmd = HOST_STOP_REQ_CMD;
+		host_stop_req->reason = DRIVER_STOP_REQUEST;
+		host_stop_req->reserved[0] = 0;
+		host_stop_req->reserved[1] = 0;
+		dev->extra_write_index = 2;
+		break;
+
+	default:
+		BUG();
+		break;
+
+	}
+}
+
+
+/**
+ * _mei_hb_read - processes read related operation.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ * @priv_cb_pos: callback block.
+ * @file_ext: private data of the file object.
+ * @cmpl_list: complete list.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+static int _mei_irq_thread_read(struct iamt_mei_device *dev,	s32 *slots,
+			struct mei_cb_private *priv_cb_pos,
+			struct mei_file_private *file_ext,
+			struct io_mei_list *cmpl_list)
+{
+	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_flow_control))) {
+		*slots -= (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_flow_control) + 3) / 4;
+		if (!mei_send_flow_control(dev, file_ext)) {
+			file_ext->status = -ENODEV;
+			priv_cb_pos->information = 0;
+			list_move_tail(&priv_cb_pos->cb_list,
+					&cmpl_list->mei_cb.cb_list);
+			return -ENODEV;
+		} else {
+			list_move_tail(&priv_cb_pos->cb_list,
+					&dev->read_list.mei_cb.cb_list);
+		}
+	} else {
+		/* return the cancel routine */
+		list_del(&priv_cb_pos->cb_list);
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+
+/**
+ * _mei_irq_thread_ioctl - processes ioctl related operation.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ * @priv_cb_pos: callback block.
+ * @file_ext: private data of the file object.
+ * @cmpl_list: complete list.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+static int _mei_irq_thread_ioctl(struct iamt_mei_device *dev,	s32 *slots,
+			struct mei_cb_private *priv_cb_pos,
+			struct mei_file_private *file_ext,
+			struct io_mei_list *cmpl_list)
+{
+	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_connect_request))) {
+		file_ext->state = MEI_FILE_CONNECTING;
+		*slots -= (sizeof(struct mei_msg_hdr) +
+			sizeof(struct hbm_client_connect_request) + 3) / 4;
+		if (!mei_connect(dev, file_ext)) {
+			file_ext->status = -ENODEV;
+			priv_cb_pos->information = 0;
+			list_del(&priv_cb_pos->cb_list);
+			return -ENODEV;
+		} else {
+			list_move_tail(&priv_cb_pos->cb_list,
+				&dev->ctrl_rd_list.mei_cb.cb_list);
+			file_ext->timer_count = MEI_CONNECT_TIMEOUT;
+		}
+	} else {
+		/* return the cancel routine */
+		list_del(&priv_cb_pos->cb_list);
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * _mei_irq_thread_cmpl - processes completed and no-iamthif operation.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ * @priv_cb_pos: callback block.
+ * @file_ext: private data of the file object.
+ * @cmpl_list: complete list.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+static int _mei_irq_thread_cmpl(struct iamt_mei_device *dev,	s32 *slots,
+			struct mei_cb_private *priv_cb_pos,
+			struct mei_file_private *file_ext,
+			struct io_mei_list *cmpl_list)
+{
+	struct mei_msg_hdr *mei_hdr;
+
+	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+			(priv_cb_pos->request_buffer.size -
+			priv_cb_pos->information))) {
+		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+		mei_hdr->host_addr = file_ext->host_client_id;
+		mei_hdr->me_addr = file_ext->me_client_id;
+		mei_hdr->length = ((priv_cb_pos->request_buffer.size) -
+				(priv_cb_pos->information));
+		mei_hdr->msg_complete = 1;
+		mei_hdr->reserved = 0;
+		DBG("priv_cb_pos->request_buffer.size =%d"
+			"mei_hdr->msg_complete = %d\n",
+				priv_cb_pos->request_buffer.size,
+				mei_hdr->msg_complete);
+		DBG("priv_cb_pos->information  =%lu\n",
+				priv_cb_pos->information);
+		DBG("mei_hdr->length  =%d\n",
+				mei_hdr->length);
+		*slots -= (sizeof(struct mei_msg_hdr) +
+				mei_hdr->length + 3) / 4;
+		if (!mei_write_message(dev, mei_hdr,
+				(unsigned char *)
+				(priv_cb_pos->request_buffer.data +
+				priv_cb_pos->information),
+				mei_hdr->length)) {
+			file_ext->status = -ENODEV;
+			list_move_tail(&priv_cb_pos->cb_list,
+				&cmpl_list->mei_cb.cb_list);
+			return -ENODEV;
+		} else {
+			flow_ctrl_reduce(dev, file_ext);
+			file_ext->status = 0;
+			priv_cb_pos->information += mei_hdr->length;
+			list_move_tail(&priv_cb_pos->cb_list,
+				&dev->write_waiting_list.mei_cb.cb_list);
+		}
+	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
+		/* buffer is still empty */
+		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+		mei_hdr->host_addr = file_ext->host_client_id;
+		mei_hdr->me_addr = file_ext->me_client_id;
+		mei_hdr->length =
+			(*slots * sizeof(u32)) -sizeof(struct mei_msg_hdr);
+		mei_hdr->msg_complete = 0;
+		mei_hdr->reserved = 0;
+
+		(*slots) -= (sizeof(struct mei_msg_hdr) +
+				mei_hdr->length + 3) / 4;
+		if (!mei_write_message(dev, mei_hdr,
+					(unsigned char *)
+					(priv_cb_pos->request_buffer.data +
+					priv_cb_pos->information),
+					mei_hdr->length)) {
+			file_ext->status = -ENODEV;
+			list_move_tail(&priv_cb_pos->cb_list,
+				&cmpl_list->mei_cb.cb_list);
+			return -ENODEV;
+		} else {
+			priv_cb_pos->information += mei_hdr->length;
+			DBG("priv_cb_pos->request_buffer.size =%d"
+					" mei_hdr->msg_complete = %d\n",
+					priv_cb_pos->request_buffer.size,
+					mei_hdr->msg_complete);
+			DBG("priv_cb_pos->information  =%lu\n",
+					priv_cb_pos->information);
+			DBG("mei_hdr->length  =%d\n", mei_hdr->length);
+		}
+		return -ECOMPLETE_MESSAGE;
+	} else {
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * _mei_irq_thread_cmpl_iamthif - processes completed iamthif operation.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ * @priv_cb_pos: callback block.
+ * @file_ext: private data of the file object.
+ * @cmpl_list: complete list.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+static int _mei_irq_thread_cmpl_iamthif(struct iamt_mei_device *dev, s32 *slots,
+			struct mei_cb_private *priv_cb_pos,
+			struct mei_file_private *file_ext,
+			struct io_mei_list *cmpl_list)
+{
+	struct mei_msg_hdr *mei_hdr;
+
+	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+			dev->iamthif_msg_buf_size -
+			dev->iamthif_msg_buf_index)) {
+		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+		mei_hdr->host_addr = file_ext->host_client_id;
+		mei_hdr->me_addr = file_ext->me_client_id;
+		mei_hdr->length = dev->iamthif_msg_buf_size -
+			dev->iamthif_msg_buf_index;
+		mei_hdr->msg_complete = 1;
+		mei_hdr->reserved = 0;
+
+		*slots -= (sizeof(struct mei_msg_hdr) +
+				mei_hdr->length + 3) / 4;
+
+		if (!mei_write_message(dev, mei_hdr,
+					(dev->iamthif_msg_buf +
+					dev->iamthif_msg_buf_index),
+					mei_hdr->length)) {
+			dev->iamthif_state = MEI_IAMTHIF_IDLE;
+			file_ext->status = -ENODEV;
+			list_del(&priv_cb_pos->cb_list);
+			return -ENODEV;
+		} else {
+			flow_ctrl_reduce(dev, file_ext);
+			dev->iamthif_msg_buf_index += mei_hdr->length;
+			priv_cb_pos->information = dev->iamthif_msg_buf_index;
+			file_ext->status = 0;
+			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
+			dev->iamthif_flow_control_pending = 1;
+			/* save iamthif cb sent to pthi client */
+			dev->iamthif_current_cb = priv_cb_pos;
+			list_move_tail(&priv_cb_pos->cb_list,
+				&dev->write_waiting_list.mei_cb.cb_list);
+
+		}
+	} else if (*slots == ((dev->host_hw_state & H_CBD) >> 24)) {
+			/* buffer is still empty */
+		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+		mei_hdr->host_addr = file_ext->host_client_id;
+		mei_hdr->me_addr = file_ext->me_client_id;
+		mei_hdr->length =
+			(*slots * sizeof(u32)) -sizeof(struct mei_msg_hdr);
+		mei_hdr->msg_complete = 0;
+		mei_hdr->reserved = 0;
+
+		*slots -= (sizeof(struct mei_msg_hdr) +
+				mei_hdr->length + 3) / 4;
+
+		if (!mei_write_message(dev, mei_hdr,
+					(dev->iamthif_msg_buf +
+					dev->iamthif_msg_buf_index),
+					mei_hdr->length)) {
+			file_ext->status = -ENODEV;
+			list_del(&priv_cb_pos->cb_list);
+		} else {
+			dev->iamthif_msg_buf_index += mei_hdr->length;
+		}
+		return -ECOMPLETE_MESSAGE;
+	} else {
+		return -ECORRUPTED_MESSAGE_HEADER;
+	}
+
+	return 0;
+}
+
+/**
+ * mei_irq_thread_read_handler - bottom half read routine after ISR to
+ * handle the read processing.
+ *
+ * @cmpl_list: An instance of our list structure
+ * @dev: the device structure
+ * @slots: slots to read.
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_irq_thread_read_handler(struct io_mei_list *cmpl_list,
+		struct iamt_mei_device *dev,
+		s32 *slots)
+{
+	struct mei_msg_hdr *mei_hdr;
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+	int ret;
+
+	if (!dev->rd_msg_hdr) {
+		dev->rd_msg_hdr = get_me_cb_rw(dev);
+		DBG("slots =%08x.\n", *slots);
+		(*slots)--;
+		DBG("slots =%08x.\n", *slots);
+	}
+	mei_hdr = (struct mei_msg_hdr *) &dev->rd_msg_hdr;
+	DBG("mei_hdr->length =%d\n", mei_hdr->length);
+
+	if ((mei_hdr->reserved) || !(dev->rd_msg_hdr)) {
+		DBG("corrupted message header.\n");
+		ret = -ECORRUPTED_MESSAGE_HEADER;
+		goto end;
+	}
+
+	if ((mei_hdr->host_addr) || (mei_hdr->me_addr)) {
+		list_for_each_entry_safe(file_pos, file_next,
+				&dev->file_list, link) {
+			DBG("list_for_each_entry_safe read host"
+					" client = %d, ME client = %d\n",
+					file_pos->host_client_id,
+					file_pos->me_client_id);
+			if ((file_pos->host_client_id == mei_hdr->host_addr)
+			    && (file_pos->me_client_id == mei_hdr->me_addr))
+				break;
+		}
+
+		if (&file_pos->link == &dev->file_list) {
+			DBG("corrupted message header\n");
+			ret = -ECORRUPTED_MESSAGE_HEADER;
+			goto end;
+		}
+	}
+	if (((*slots) * sizeof(u32)) < mei_hdr->length) {
+		DBG("we can't read the message slots =%08x.\n", *slots);
+		/* we can't read the message */
+		ret = -ERANGE;
+		goto end;
+	}
+
+	/* decide where to read the message too */
+	if (!mei_hdr->host_addr) {
+		DBG("call mei_irq_thread_read_bus_message.\n");
+		mei_irq_thread_read_bus_message(dev, mei_hdr);
+		DBG("end mei_irq_thread_read_bus_message.\n");
+	} else if ((mei_hdr->host_addr == dev->iamthif_file_ext.host_client_id)
+		   && (MEI_FILE_CONNECTED == dev->iamthif_file_ext.state)
+		   && (dev->iamthif_state == MEI_IAMTHIF_READING)) {
+		DBG("call mei_irq_thread_read_iamthif_message.\n");
+		DBG("mei_hdr->length =%d\n", mei_hdr->length);
+		ret = mei_irq_thread_read_pthi_message(cmpl_list, dev, mei_hdr);
+		if (ret != 0)
+			goto end;
+
+	} else {
+		DBG("call mei_irq_thread_read_client_message.\n");
+		ret = mei_irq_thread_read_client_message(cmpl_list,
+							 dev, mei_hdr);
+		if (ret != 0)
+			goto end;
+
+	}
+
+	/* reset the number of slots and header */
+	*slots = count_full_read_slots(dev);
+	dev->rd_msg_hdr = 0;
+
+	if (*slots == -ESLOTS_OVERFLOW) {
+		/* overflow - reset */
+		DBG("reseting due to slots overflow.\n");
+		/* set the event since message has been read */
+		ret = -ERANGE;
+		goto end;
+	}
+end:
+	return ret;
+}
+
+
+/**
+ * mei_irq_thread_write_handler - bottom half write routine after
+ * ISR to handle the write processing.
+ *
+ * @cmpl_list: An instance of our list structure
+ * @dev: the device structure
+ * @slots: slots to write.
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_irq_thread_write_handler(struct io_mei_list *cmpl_list,
+		struct iamt_mei_device *dev,
+		s32 *slots)
+{
+
+	struct mei_file_private *file_ext;
+	struct mei_cb_private *priv_cb_pos = NULL, *priv_cb_next = NULL;
+	struct io_mei_list *list;
+	int ret;
+
+	if (!host_buffer_is_empty(dev)) {
+		DBG("host buffer is not empty.\n");
+		return 0;
+	}
+	dev->write_hang = -1;
+	*slots = count_empty_write_slots(dev);
+	/* complete all waiting for write CB */
+	DBG("complete all waiting for write cb.\n");
+
+	list = &dev->write_waiting_list;
+	if ((list->status == 0)
+	    && !list_empty(&list->mei_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&list->mei_cb.cb_list, cb_list) {
+			file_ext = (struct mei_file_private *)
+					priv_cb_pos->file_private;
+			if (file_ext != NULL) {
+				file_ext->status = 0;
+				list_del(&priv_cb_pos->cb_list);
+				if ((MEI_WRITING == file_ext->writing_state) &&
+					(priv_cb_pos->major_file_operations ==
+						MEI_WRITE) &&
+					(file_ext != &dev->iamthif_file_ext)) {
+					DBG("MEI WRITE COMPLETE\n");
+					file_ext->writing_state =
+						MEI_WRITE_COMPLETE;
+					list_add_tail(&priv_cb_pos->cb_list,
+						&cmpl_list->mei_cb.cb_list);
+				}
+				if (file_ext == &dev->iamthif_file_ext) {
+					DBG("check iamthif flow control.\n");
+					if (dev->iamthif_flow_control_pending) {
+						ret =
+						_mei_irq_thread_iamthif_read(
+								dev, slots);
+						if (ret != 0)
+							return ret;
+					}
+				}
+			}
+
+		}
+	}
+
+	if ((dev->stop) && (!dev->wd_pending)) {
+		dev->wd_stopped = 1;
+		wake_up_interruptible(&dev->wait_stop_wd);
+		return 0;
+	}
+
+	if (dev->extra_write_index != 0) {
+		DBG("extra_write_index =%d.\n",	dev->extra_write_index);
+		mei_write_message(dev,
+				(struct mei_msg_hdr *) &dev->ext_msg_buf[0],
+				(unsigned char *) &dev->ext_msg_buf[1],
+				(dev->extra_write_index - 1) * sizeof(u32));
+		*slots -= dev->extra_write_index;
+		dev->extra_write_index = 0;
+	}
+	if (dev->mei_state == MEI_ENABLED) {
+		if ((dev->wd_pending)
+		    && flow_ctrl_creds(dev, &dev->wd_file_ext)) {
+			if (!mei_send_wd(dev))
+				DBG("wd send failed.\n");
+			else
+				flow_ctrl_reduce(dev, &dev->wd_file_ext);
+
+			dev->wd_pending = 0;
+
+			if (dev->wd_timeout != 0) {
+				*slots -= (sizeof(struct mei_msg_hdr) +
+					 MEI_START_WD_DATA_SIZE + 3) / 4;
+				dev->wd_due_counter = 2;
+			} else {
+				*slots -= (sizeof(struct mei_msg_hdr) +
+					 MEI_WD_PARAMS_SIZE + 3) / 4;
+				dev->wd_due_counter = 0;
+			}
+
+		}
+	}
+	if (dev->stop)
+		return ~ENODEV;
+
+	/* complete control write list CB */
+	if (dev->ctrl_wr_list.status == 0) {
+		/* complete control write list CB */
+		DBG("complete control write list cb.\n");
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->ctrl_wr_list.mei_cb.cb_list, cb_list) {
+			file_ext = (struct mei_file_private *)
+				priv_cb_pos->file_private;
+			if (file_ext == NULL) {
+				list_del(&priv_cb_pos->cb_list);
+				return -ENODEV;
+			}
+			switch (priv_cb_pos->major_file_operations) {
+			case MEI_CLOSE:
+				/* send disconnect message */
+				ret = _mei_irq_thread_close(dev, slots,
+						     priv_cb_pos,
+						     file_ext, cmpl_list);
+				if (ret != 0)
+					return ret;
+
+				break;
+			case MEI_READ:
+				/* send flow control message */
+				ret = _mei_irq_thread_read(dev, slots,
+						    priv_cb_pos,
+						    file_ext, cmpl_list);
+				if (ret != 0)
+					return ret;
+
+				break;
+			case MEI_IOCTL:
+				/* connect message */
+				if (!other_client_is_connecting(dev, file_ext))
+					continue;
+				ret = _mei_irq_thread_ioctl(dev, slots,
+						     priv_cb_pos,
+						     file_ext, cmpl_list);
+				if (ret != 0)
+					return ret;
+
+				break;
+
+			default:
+				BUG();
+			}
+
+		}
+	}
+	/* complete  write list CB */
+	if ((dev->write_list.status == 0)
+	    && !list_empty(&dev->write_list.mei_cb.cb_list)) {
+		DBG("complete write list cb.\n");
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->write_list.mei_cb.cb_list, cb_list) {
+			file_ext = (struct mei_file_private *)
+					priv_cb_pos->file_private;
+
+			if (file_ext != NULL) {
+				if (file_ext != &dev->iamthif_file_ext) {
+					if (!flow_ctrl_creds(dev, file_ext)) {
+						DBG("No flow control"
+						    " credentials for client"
+						    " %d, not sending.\n",
+						    file_ext->host_client_id);
+						continue;
+					}
+					ret = _mei_irq_thread_cmpl(dev, slots,
+							    priv_cb_pos,
+							    file_ext,
+							    cmpl_list);
+					if (ret != 0)
+						return ret;
+
+				} else if (file_ext == &dev->iamthif_file_ext) {
+					/* IAMTHIF IOCTL */
+					DBG("complete pthi write cb.\n");
+					if (!flow_ctrl_creds(dev, file_ext)) {
+						DBG("No flow control"
+						    " credentials for pthi"
+						    " client %d.\n",
+						    file_ext->host_client_id);
+						continue;
+					}
+					ret = _mei_irq_thread_cmpl_iamthif(dev,
+								slots,
+								priv_cb_pos,
+								file_ext,
+								cmpl_list);
+					if (ret != 0)
+						return ret;
+
+				}
+			}
+
+		}
+	}
+	return 0;
+}
+
+
+
+/**
+ * mei_timer - timer function.
+ *
+ * @work: pointer to the work_struct structure
+ *
+ * NOTE: This function is called by timer interrupt work
+ */
+void mei_wd_timer(struct work_struct *work)
+{
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+
+	struct iamt_mei_device *dev = container_of(work,
+					struct iamt_mei_device, wd_work.work);
+
+	DBG("send watchdog.\n");
+	mutex_lock(&dev->device_lock);
+	if (dev->mei_state != MEI_ENABLED) {
+		if (dev->mei_state == MEI_INIT_CLIENTS) {
+			if (dev->init_clients_timer != 0) {
+				if (--dev->init_clients_timer == 0) {
+					DBG("IMEI reset due to init clients timeout ,init clients state = %d.\n",
+						dev->init_clients_state);
+					mei_reset(dev, 1);
+				}
+			}
+		}
+		goto out;
+	}
+	/*** connect/disconnect timeouts ***/
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if (file_pos->timer_count != 0) {
+			if (--file_pos->timer_count == 0) {
+				DBG("HECI reset due to connect/disconnect timeout.\n");
+				mei_reset(dev, 1);
+				goto out;
+			}
+		}
+	}
+
+	if (dev->wd_file_ext.state != MEI_FILE_CONNECTED)
+		goto out;
+
+	/* Watchdog */
+	if ((dev->wd_due_counter != 0) && (dev->wd_bypass == 0)) {
+		if (--dev->wd_due_counter == 0) {
+			if (dev->host_buffer_is_empty &&
+			    flow_ctrl_creds(dev, &dev->wd_file_ext)) {
+				dev->host_buffer_is_empty = 0;
+				if (!mei_send_wd(dev)) {
+					DBG("wd send failed.\n");
+				} else {
+					flow_ctrl_reduce(dev,
+							 &dev->wd_file_ext);
+				}
+
+				if (dev->wd_timeout != 0)
+					dev->wd_due_counter = 2;
+				else
+					dev->wd_due_counter = 0;
+
+			} else
+				dev->wd_pending = 1;
+
+		}
+	}
+	if (dev->iamthif_stall_timer != 0) {
+		if (--dev->iamthif_stall_timer == 0) {
+			DBG("reseting because of hang to PTHI.\n");
+			mei_reset(dev, 1);
+			dev->iamthif_msg_buf_size = 0;
+			dev->iamthif_msg_buf_index = 0;
+			dev->iamthif_canceled = 0;
+			dev->iamthif_ioctl = 1;
+			dev->iamthif_state = MEI_IAMTHIF_IDLE;
+			dev->iamthif_timer = 0;
+
+			if (dev->iamthif_current_cb)
+				mei_free_cb_private(dev->iamthif_current_cb);
+
+			dev->iamthif_file_object = NULL;
+			dev->iamthif_current_cb = NULL;
+			run_next_iamthif_cmd(dev);
+		}
+	}
+out:
+	 schedule_delayed_work(&dev->wd_work, 2 * HZ);
+	 mutex_unlock(&dev->device_lock);
+}
+
+/**
+ *  mei_interrupt_thread_handler - function called after ISR to handle the interrupt
+ * processing.
+ *
+ * @irq: The irq number
+ * @dev_id: pointer to the device structure
+ *
+ * returns irqreturn_t
+ *
+ */
+irqreturn_t mei_interrupt_thread_handler(int irq, void *dev_id)
+{
+	struct iamt_mei_device *dev = (struct iamt_mei_device *) dev_id;
+	struct io_mei_list complete_list;
+	struct mei_cb_private *cb_pos = NULL, *cb_next = NULL;
+	struct mei_file_private *file_ext;
+	s32 slots;
+	int rets;
+	bool  bus_message_received;
+
+
+	DBG("function called after ISR to handle the interrupt processing.\n");
+	/* initialize our complete list */
+	mutex_lock(&dev->device_lock);
+	mei_initialize_list(&complete_list, dev);
+	dev->host_hw_state = get_host_hw_state(dev);
+	dev->me_hw_state = get_me_hw_state(dev);
+
+	/* check if ME wants a reset */
+	if (((dev->me_hw_state & ME_RDY_HRA) == 0)
+	    && (dev->mei_state != MEI_RESETING)
+	    && (dev->mei_state != MEI_INITIALIZING)) {
+		DBG("FW not ready.\n");
+		mei_reset(dev, 1);
+		mutex_unlock(&dev->device_lock);
+		return IRQ_HANDLED;
+	}
+
+	/*  check if we need to start the dev */
+	if ((dev->host_hw_state & H_RDY) == 0) {
+		if ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA) {
+			DBG("we need to start the dev.\n");
+			dev->host_hw_state |= (H_IE | H_IG | H_RDY);
+			mei_set_csr_register(dev);
+			dev->mei_state = MEI_INIT_CLIENTS;
+			DBG("link is established start sending messages.\n");
+			/* link is established
+			 * start sending messages.
+			 */
+			host_start_message(dev);
+			mutex_unlock(&dev->device_lock);
+			return IRQ_HANDLED;
+		} else {
+			DBG("FW not ready.\n");
+			mutex_unlock(&dev->device_lock);
+			return IRQ_HANDLED;
+		}
+	}
+	/* check slots avalable for reading */
+	slots = count_full_read_slots(dev);
+	DBG("slots =%08x  extra_write_index =%08x.\n",
+		slots, dev->extra_write_index);
+	while ((slots > 0) && (!dev->extra_write_index)) {
+		DBG("slots =%08x  extra_write_index =%08x.\n", slots,
+				dev->extra_write_index);
+		DBG("call mei_irq_thread_read_handler.\n");
+		rets = mei_irq_thread_read_handler(&complete_list, dev, &slots);
+		if (rets != 0)
+			goto end;
+	}
+	rets = mei_irq_thread_write_handler(&complete_list, dev, &slots);
+end:
+	DBG("end of bottom half function.\n");
+	dev->host_hw_state = get_host_hw_state(dev);
+	dev->host_buffer_is_empty = host_buffer_is_empty(dev);
+
+	bus_message_received = false;
+	if (dev->recvd_msg && waitqueue_active(&dev->wait_recvd_msg)) {
+		DBG("received waiting bus message\n");
+		bus_message_received = true;
+	}
+	mutex_unlock(&dev->device_lock);
+	if (bus_message_received) {
+		DBG("wake up dev->wait_recvd_msg\n");
+		wake_up_interruptible(&dev->wait_recvd_msg);
+		bus_message_received = false;
+	}
+	if ((complete_list.status != 0)
+	    || list_empty(&complete_list.mei_cb.cb_list))
+		return IRQ_HANDLED;
+
+
+	list_for_each_entry_safe(cb_pos, cb_next,
+			&complete_list.mei_cb.cb_list, cb_list) {
+		file_ext = (struct mei_file_private *)cb_pos->file_private;
+		list_del(&cb_pos->cb_list);
+		if (file_ext != NULL) {
+			if (file_ext != &dev->iamthif_file_ext) {
+				DBG("completing call back.\n");
+				_mei_cmpl(file_ext, cb_pos);
+				cb_pos = NULL;
+			} else if (file_ext == &dev->iamthif_file_ext) {
+				_mei_cmpl_iamthif(dev, cb_pos);
+			}
+		}
+	}
+	return IRQ_HANDLED;
+}
+
+


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

