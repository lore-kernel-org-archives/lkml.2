Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab1BJJ5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:57:13 -0500
Received: from mga01.intel.com ([192.55.52.88]:8967 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755827Ab1BJJzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:14 -0500
Message-Id: <b7da2f$qd3nfe@fmsmga001.fm.intel.com>
Date: 10 Feb 2011 01:55:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="886169077"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 06/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/interface.c b/drivers/char/mei/interface.c
new file mode 100644
index 0000000..23bcd7e
--- /dev/null
+++ b/drivers/char/mei/interface.c
@@ -0,0 +1,478 @@
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
+#include "mei.h"
+#include "interface.h"
+
+
+
+/**
+ * mei_set_csr_register - writes H_CSR register to the mei device,
+ * and ignores the H_IS bit for it is write-one-to-zero.
+ *
+ * @dev: the device structure
+ */
+void mei_set_csr_register(struct iamt_mei_device *dev)
+{
+	if ((dev->host_hw_state & H_IS) == H_IS)
+		dev->host_hw_state &= ~H_IS;
+	write_mei_register(dev, H_CSR, dev->host_hw_state);
+	dev->host_hw_state = get_host_hw_state(dev);
+}
+
+/**
+ * mei_csr_enable_interrupts - enables mei device interrupts
+ *
+ * @dev: the device structure
+ */
+void mei_csr_enable_interrupts(struct iamt_mei_device *dev)
+{
+	dev->host_hw_state |= H_IE;
+	mei_set_csr_register(dev);
+}
+
+/**
+ * mei_csr_disable_interrupts - disables mei device interrupts
+ *
+ * @dev: the device structure
+ */
+void mei_csr_disable_interrupts(struct iamt_mei_device *dev)
+{
+	dev->host_hw_state &= ~H_IE;
+	mei_set_csr_register(dev);
+}
+
+/**
+ * mei_csr_clear_his - clears H_IS bit in H_CSR
+ *
+ * @dev: the device structure
+ */
+void mei_csr_clear_his(struct iamt_mei_device *dev)
+{
+	write_mei_register(dev, H_CSR, dev->host_hw_state);
+	dev->host_hw_state = get_host_hw_state(dev);
+}
+
+/**
+ * _host_get_filled_slots - gets number of device filled buffer slots
+ *
+ * @device: the device structure
+ *
+ * returns number of filled slots
+ */
+static unsigned char _host_get_filled_slots(const struct iamt_mei_device *dev)
+{
+	char read_ptr, write_ptr;
+
+	read_ptr = (char) ((dev->host_hw_state & H_CBRP) >> 8);
+	write_ptr = (char) ((dev->host_hw_state & H_CBWP) >> 16);
+
+	return (unsigned char) (write_ptr - read_ptr);
+}
+
+/**
+ * host_buffer_is_empty - checks if host buffer is empty.
+ *
+ * @dev: the device structure
+ *
+ * returns 1 if empty, 0 - otherwise.
+ */
+int host_buffer_is_empty(struct iamt_mei_device *dev)
+{
+	unsigned char filled_slots;
+
+	dev->host_hw_state = get_host_hw_state(dev);
+	filled_slots = _host_get_filled_slots(dev);
+
+	if (filled_slots == 0)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * count_empty_write_slots - counts write empty slots.
+ *
+ * @dev: the device structure
+ *
+ * returns -1(ESLOTS_OVERFLOW) if overflow, otherwise empty slots count
+ */
+s32 count_empty_write_slots(struct iamt_mei_device *dev)
+{
+	unsigned char buffer_depth, filled_slots, empty_slots;
+
+	dev->host_hw_state = get_host_hw_state(dev);
+	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
+	filled_slots = _host_get_filled_slots(dev);
+	empty_slots = buffer_depth - filled_slots;
+
+	if (filled_slots > buffer_depth) {
+		/* overflow */
+		return -ESLOTS_OVERFLOW;
+	}
+
+	return (s32) empty_slots;
+}
+
+/**
+ * mei_write_message - writes a message to mei device.
+ *
+ * @dev: the device structure
+ * @mei_hdr: header of message
+ * @write_buffer: message buffer will be written
+ * @write_length: message size will be written
+ *
+ * returns 1 if success, 0 - otherwise.
+ */
+int mei_write_message(struct iamt_mei_device *dev,
+			     struct mei_msg_hdr *header,
+			     unsigned char *write_buffer,
+			     unsigned long write_length)
+{
+	u32 temp_msg = 0;
+	unsigned long bytes_written = 0;
+	unsigned char buffer_depth, filled_slots, empty_slots;
+	unsigned long dw_to_write;
+
+	dev->host_hw_state = get_host_hw_state(dev);
+	DBG("host_hw_state = 0x%08x.\n", dev->host_hw_state);
+	DBG("mei_write_message header=%08x.\n", *((u32 *) header));
+	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
+	filled_slots = _host_get_filled_slots(dev);
+	empty_slots = buffer_depth - filled_slots;
+	DBG("filled = %hu, empty = %hu.\n", filled_slots, empty_slots);
+
+	dw_to_write = ((write_length + 3) / 4);
+
+	if (dw_to_write > empty_slots)
+		return 0;
+
+	write_mei_register(dev, H_CB_WW, *((u32 *) header));
+
+	while (write_length >= 4) {
+		write_mei_register(dev, H_CB_WW,
+				*(u32 *) (write_buffer + bytes_written));
+		bytes_written += 4;
+		write_length -= 4;
+	}
+
+	if (write_length > 0) {
+		memcpy(&temp_msg, &write_buffer[bytes_written], write_length);
+		write_mei_register(dev, H_CB_WW, temp_msg);
+	}
+
+	dev->host_hw_state |= H_IG;
+	mei_set_csr_register(dev);
+	dev->me_hw_state = get_me_hw_state(dev);
+	if ((dev->me_hw_state & ME_RDY_HRA) != ME_RDY_HRA)
+		return 0;
+
+	dev->write_hang = 0;
+	return 1;
+}
+
+/**
+ * count_full_read_slots - counts read full slots.
+ *
+ * @dev: the device structure
+ *
+ * returns -1(ESLOTS_OVERFLOW) if overflow, otherwise filled slots count
+ */
+s32 count_full_read_slots(struct iamt_mei_device *dev)
+{
+	char read_ptr, write_ptr;
+	unsigned char buffer_depth, filled_slots;
+
+	dev->me_hw_state = get_me_hw_state(dev);
+	buffer_depth = (unsigned char)((dev->me_hw_state & ME_CBD_HRA) >> 24);
+	read_ptr = (char) ((dev->me_hw_state & ME_CBRP_HRA) >> 8);
+	write_ptr = (char) ((dev->me_hw_state & ME_CBWP_HRA) >> 16);
+	filled_slots = (unsigned char) (write_ptr - read_ptr);
+
+	if (filled_slots > buffer_depth) {
+		/* overflow */
+		return -ESLOTS_OVERFLOW;
+	}
+
+	DBG("filled_slots =%08x\n", filled_slots);
+	return (s32) filled_slots;
+}
+
+/**
+ * mei_read_slots - reads a message from mei device.
+ *
+ * @dev: the device structure
+ * @buffer: message buffer will be written
+ * @buffer_length: message size will be read
+ */
+void mei_read_slots(struct iamt_mei_device *dev,
+		     unsigned char *buffer, unsigned long buffer_length)
+{
+	u32 i = 0;
+	unsigned char temp_buf[sizeof(u32)];
+
+	while (buffer_length >= sizeof(u32)) {
+		((u32 *) buffer)[i] = get_me_cb_rw(dev);
+		DBG("buffer[%d]= %d\n", i, ((u32 *) buffer)[i]);
+		i++;
+		buffer_length -= sizeof(u32);
+	}
+
+	if (buffer_length > 0) {
+		*((u32 *) &temp_buf) = get_me_cb_rw(dev);
+		memcpy(&buffer[i * 4], temp_buf, buffer_length);
+	}
+
+	dev->host_hw_state |= H_IG;
+	mei_set_csr_register(dev);
+}
+
+/**
+ * flow_ctrl_creds - checks flow_control credentials.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ *
+ * returns 1 if flow_ctrl_creds >0, 0 - otherwise.
+ */
+int flow_ctrl_creds(struct iamt_mei_device *dev,
+				   struct mei_file_private *file_ext)
+{
+	u8 i;
+
+	if (!dev->num_mei_me_clients)
+		return 0;
+
+	if (file_ext == NULL)
+		return 0;
+
+	if (file_ext->flow_ctrl_creds > 0)
+		return 1;
+
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (dev->me_clients[i].client_id == file_ext->me_client_id) {
+			if (dev->me_clients[i].flow_ctrl_creds > 0) {
+				BUG_ON(dev->me_clients[i].props.single_recv_buf
+					 == 0);
+				return 1;
+			}
+			return 0;
+		}
+	}
+	BUG();
+	return 0;
+}
+
+/**
+ * flow_ctrl_reduce - reduces flow_control.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ */
+void flow_ctrl_reduce(struct iamt_mei_device *dev,
+			 struct mei_file_private *file_ext)
+{
+	u8 i;
+
+	if (!dev->num_mei_me_clients)
+		return;
+
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (dev->me_clients[i].client_id == file_ext->me_client_id) {
+			if (dev->me_clients[i].props.single_recv_buf != 0) {
+				BUG_ON(dev->me_clients[i].flow_ctrl_creds <= 0);
+				dev->me_clients[i].flow_ctrl_creds--;
+			} else {
+				BUG_ON(file_ext->flow_ctrl_creds <= 0);
+				file_ext->flow_ctrl_creds--;
+			}
+			return;
+		}
+	}
+	BUG();
+}
+
+/**
+ * mei_send_flow_control - sends flow control to fw.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ *
+ * returns 1 if success, 0 - otherwise.
+ */
+int mei_send_flow_control(struct iamt_mei_device *dev,
+				 struct mei_file_private *file_ext)
+{
+	struct mei_msg_hdr *mei_hdr;
+	struct hbm_flow_control *mei_flow_control;
+
+	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	mei_hdr->host_addr = 0;
+	mei_hdr->me_addr = 0;
+	mei_hdr->length = sizeof(struct hbm_flow_control);
+	mei_hdr->msg_complete = 1;
+	mei_hdr->reserved = 0;
+
+	mei_flow_control = (struct hbm_flow_control *) &dev->wr_msg_buf[1];
+	memset(mei_flow_control, 0, sizeof(mei_flow_control));
+	mei_flow_control->host_addr = file_ext->host_client_id;
+	mei_flow_control->me_addr = file_ext->me_client_id;
+	mei_flow_control->cmd.cmd = MEI_FLOW_CONTROL_CMD;
+	memset(mei_flow_control->reserved, 0,
+			sizeof(mei_flow_control->reserved));
+	DBG("sending flow control host client = %d, me client = %d\n",
+	    file_ext->host_client_id, file_ext->me_client_id);
+	if (!mei_write_message(dev, mei_hdr,
+				(unsigned char *) mei_flow_control,
+				sizeof(struct hbm_flow_control)))
+		return 0;
+
+	return 1;
+
+}
+
+/**
+ * other_client_is_connecting - checks if other
+ *    client with the same client id is connected.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ *
+ * returns 1 if other client is connected, 0 - otherwise.
+ */
+int other_client_is_connecting(struct iamt_mei_device *dev,
+		struct mei_file_private *file_ext)
+{
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if ((file_pos->state == MEI_FILE_CONNECTING)
+			&& (file_pos != file_ext)
+			&& file_ext->me_client_id == file_pos->me_client_id)
+			return 1;
+
+	}
+	return 0;
+}
+
+/**
+ * mei_send_wd - sends watch dog message to fw.
+ *
+ * @dev: the device structure
+ *
+ * returns 1 if success, 0 - otherwise.
+ */
+int mei_send_wd(struct iamt_mei_device *dev)
+{
+	struct mei_msg_hdr *mei_hdr;
+
+	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	mei_hdr->host_addr = dev->wd_file_ext.host_client_id;
+	mei_hdr->me_addr = dev->wd_file_ext.me_client_id;
+	mei_hdr->msg_complete = 1;
+	mei_hdr->reserved = 0;
+
+	if (!memcmp(dev->wd_data, mei_start_wd_params, MEI_WD_PARAMS_SIZE)) {
+		mei_hdr->length = MEI_START_WD_DATA_SIZE;
+	} else {
+		BUG_ON(memcmp(dev->wd_data, mei_stop_wd_params,
+			MEI_WD_PARAMS_SIZE));
+		mei_hdr->length = MEI_WD_PARAMS_SIZE;
+	}
+
+	if (!mei_write_message(dev, mei_hdr, dev->wd_data, mei_hdr->length))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * mei_disconnect - sends disconnect message to fw.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ *
+ * returns 1 if success, 0 - otherwise.
+ */
+int mei_disconnect(struct iamt_mei_device *dev,
+			  struct mei_file_private *file_ext)
+{
+	struct mei_msg_hdr *mei_hdr;
+	struct hbm_client_disconnect_request *mei_cli_disconnect;
+
+	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	mei_hdr->host_addr = 0;
+	mei_hdr->me_addr = 0;
+	mei_hdr->length = sizeof(struct hbm_client_disconnect_request);
+	mei_hdr->msg_complete = 1;
+	mei_hdr->reserved = 0;
+
+	mei_cli_disconnect =
+	    (struct hbm_client_disconnect_request *) &dev->wr_msg_buf[1];
+	memset(mei_cli_disconnect, 0, sizeof(mei_cli_disconnect));
+	mei_cli_disconnect->host_addr = file_ext->host_client_id;
+	mei_cli_disconnect->me_addr = file_ext->me_client_id;
+	mei_cli_disconnect->cmd.cmd = CLIENT_DISCONNECT_REQ_CMD;
+	mei_cli_disconnect->reserved[0] = 0;
+
+	if (!mei_write_message(dev, mei_hdr,
+				(unsigned char *) mei_cli_disconnect,
+				sizeof(struct hbm_client_disconnect_request)))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * mei_connect - sends connect message to fw.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ *
+ * returns 1 if success, 0 - otherwise.
+ */
+int mei_connect(struct iamt_mei_device *dev,
+		       struct mei_file_private *file_ext)
+{
+	struct mei_msg_hdr *mei_hdr;
+	struct hbm_client_connect_request *mei_cli_connect;
+
+	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	mei_hdr->host_addr = 0;
+	mei_hdr->me_addr = 0;
+	mei_hdr->length = sizeof(struct hbm_client_connect_request);
+	mei_hdr->msg_complete = 1;
+	mei_hdr->reserved = 0;
+
+	mei_cli_connect =
+	    (struct hbm_client_connect_request *) &dev->wr_msg_buf[1];
+	mei_cli_connect->host_addr = file_ext->host_client_id;
+	mei_cli_connect->me_addr = file_ext->me_client_id;
+	mei_cli_connect->cmd.cmd = CLIENT_CONNECT_REQ_CMD;
+	mei_cli_connect->reserved = 0;
+
+	if (!mei_write_message(dev, mei_hdr,
+				(unsigned char *) mei_cli_connect,
+				sizeof(struct hbm_client_connect_request)))
+		return 0;
+
+	return 1;
+}


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

