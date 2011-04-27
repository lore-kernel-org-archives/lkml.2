Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1D0KaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:30:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:23595 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1D0KaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:30:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,273,1301900400"; 
   d="scan'208";a="739084195"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 1/8] staging/mei: PCI device and char driver support.
Date: Wed, 27 Apr 2011 13:27:30 +0300
Message-Id: <1303900057-21694-2-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
References: <1303900057-21694-1-git-send-email-oren.jer.weil@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

contains module entries and PCI driver and char device
definitions (using file_operations, pci_driver structs).

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/staging/mei/iorw.c        |  595 ++++++++++++++++
 drivers/staging/mei/main.c        | 1340 +++++++++++++++++++++++++++++++++++++
 drivers/staging/mei/mei.h         |  148 ++++
 drivers/staging/mei/mei_version.h |   31 +
 4 files changed, 2114 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/mei/iorw.c
 create mode 100644 drivers/staging/mei/main.c
 create mode 100644 drivers/staging/mei/mei.h
 create mode 100644 drivers/staging/mei/mei_version.h

diff --git a/drivers/staging/mei/iorw.c b/drivers/staging/mei/iorw.c
new file mode 100644
index 0000000..cd76a5b
--- /dev/null
+++ b/drivers/staging/mei/iorw.c
@@ -0,0 +1,595 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
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
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/aio.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/list.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+#include <linux/uuid.h>
+#include <linux/jiffies.h>
+
+#include "hw.h"
+#include "mei.h"
+#include "interface.h"
+#include "mei_version.h"
+
+
+
+/**
+ * mei_ioctl_connect_client - the connect to fw client IOCTL function
+ *
+ * @dev: the device structure
+ * @data: IOCTL connect data, input and output parameters
+ * @file: private data of the file object
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_ioctl_connect_client(struct file *file,
+			struct mei_connect_client_data *data)
+{
+	struct mei_device *dev;
+	struct mei_cl_cb *priv_cb;
+	struct mei_client *client;
+	struct mei_cl *file_ext;
+	struct mei_cl *file_pos = NULL;
+	struct mei_cl *file_next = NULL;
+	long timeout = CONNECT_TIMEOUT;
+	int i;
+	int err;
+	int rets;
+
+	file_ext = file->private_data;
+	if (WARN_ON(!file_ext || !file_ext->dev))
+		return -ENODEV;
+
+	dev = file_ext->dev;
+
+	dev_dbg(&dev->pdev->dev, "mei_ioctl_connect_client() Entry\n");
+
+
+	/* buffered ioctl cb */
+	priv_cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	if (!priv_cb) {
+		rets = -ENOMEM;
+		goto end;
+	}
+	INIT_LIST_HEAD(&priv_cb->cb_list);
+
+	priv_cb->major_file_operations = MEI_IOCTL;
+
+	if (dev->mei_state != MEI_ENABLED) {
+		rets = -ENODEV;
+		goto end;
+	}
+	if (file_ext->state != MEI_FILE_INITIALIZING &&
+	    file_ext->state != MEI_FILE_DISCONNECTED) {
+		rets = -EBUSY;
+		goto end;
+	}
+
+	/* find ME client we're trying to connect to */
+	i = mei_find_me_client_index(dev, data->in_client_uuid);
+	if (i >= 0 && !dev->me_clients[i].props.fixed_address) {
+		file_ext->me_client_id = dev->me_clients[i].client_id;
+		file_ext->state = MEI_FILE_CONNECTING;
+	}
+
+	dev_dbg(&dev->pdev->dev, "Connect to FW Client ID = %d\n",
+			file_ext->me_client_id);
+	dev_dbg(&dev->pdev->dev, "FW Client - Protocol Version = %d\n",
+			dev->me_clients[i].props.protocol_version);
+	dev_dbg(&dev->pdev->dev, "FW Client - Max Msg Len = %d\n",
+			dev->me_clients[i].props.max_msg_length);
+
+	/* if we're connecting to amthi client so we will use the exist
+	 * connection
+	 */
+	if (uuid_le_cmp(data->in_client_uuid, mei_amthi_guid) == 0) {
+		dev_dbg(&dev->pdev->dev, "FW Client is amthi\n");
+		if (dev->iamthif_file_ext.state != MEI_FILE_CONNECTED) {
+			rets = -ENODEV;
+			goto end;
+		}
+		clear_bit(file_ext->host_client_id, dev->host_clients_map);
+		list_for_each_entry_safe(file_pos, file_next,
+					 &dev->file_list, link) {
+			if (mei_fe_same_id(file_ext, file_pos)) {
+				dev_dbg(&dev->pdev->dev,
+					"remove file private data node host"
+				    " client = %d, ME client = %d.\n",
+				    file_pos->host_client_id,
+				    file_pos->me_client_id);
+				list_del(&file_pos->link);
+			}
+
+		}
+		dev_dbg(&dev->pdev->dev, "free file private data memory.\n");
+		kfree(file_ext);
+
+		file_ext = NULL;
+		file->private_data = &dev->iamthif_file_ext;
+
+		client = &data->out_client_properties;
+		client->max_msg_length =
+			dev->me_clients[i].props.max_msg_length;
+		client->protocol_version =
+			dev->me_clients[i].props.protocol_version;
+		rets = dev->iamthif_file_ext.status;
+
+		goto end;
+	}
+
+	if (file_ext->state != MEI_FILE_CONNECTING) {
+		rets = -ENODEV;
+		goto end;
+	}
+
+
+	/* prepare the output buffer */
+	client = &data->out_client_properties;
+	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
+	client->protocol_version = dev->me_clients[i].props.protocol_version;
+	dev_dbg(&dev->pdev->dev, "Can connect?\n");
+	if (dev->mei_host_buffer_is_empty
+	    && !mei_other_client_is_connecting(dev, file_ext)) {
+		dev_dbg(&dev->pdev->dev, "Sending Connect Message\n");
+		dev->mei_host_buffer_is_empty = 0;
+		if (!mei_connect(dev, file_ext)) {
+			dev_dbg(&dev->pdev->dev, "Sending connect message - failed\n");
+			rets = -ENODEV;
+			goto end;
+		} else {
+			dev_dbg(&dev->pdev->dev, "Sending connect message - succeeded\n");
+			file_ext->timer_count = MEI_CONNECT_TIMEOUT;
+			priv_cb->file_private = file_ext;
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->ctrl_rd_list.mei_cb.
+				      cb_list);
+		}
+
+
+	} else {
+		dev_dbg(&dev->pdev->dev, "Queuing the connect request due to device busy\n");
+		priv_cb->file_private = file_ext;
+		dev_dbg(&dev->pdev->dev, "add connect cb to control write list.\n");
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->ctrl_wr_list.mei_cb.cb_list);
+	}
+	mutex_unlock(&dev->device_lock);
+	err = wait_event_timeout(dev->wait_recvd_msg,
+			(MEI_FILE_CONNECTED == file_ext->state ||
+			 MEI_FILE_DISCONNECTED == file_ext->state),
+			timeout * HZ);
+
+	mutex_lock(&dev->device_lock);
+	if (MEI_FILE_CONNECTED == file_ext->state) {
+		dev_dbg(&dev->pdev->dev, "successfully connected to FW client.\n");
+		rets = file_ext->status;
+		goto end;
+	} else {
+		dev_dbg(&dev->pdev->dev, "failed to connect to FW client.file_ext->state = %d.\n",
+		    file_ext->state);
+		if (!err) {
+			dev_dbg(&dev->pdev->dev,
+				"wait_event_interruptible_timeout failed on client"
+				" connect message fw response message.\n");
+		}
+		rets = -EFAULT;
+
+		mei_flush_list(&dev->ctrl_rd_list, file_ext);
+		mei_flush_list(&dev->ctrl_wr_list, file_ext);
+		goto end;
+	}
+	rets = 0;
+end:
+	dev_dbg(&dev->pdev->dev, "free connect cb memory.");
+	kfree(priv_cb);
+	return rets;
+}
+
+/**
+ * find_amthi_read_list_entry - finds a amthilist entry for current file
+ *
+ * @dev: the device structure
+ * @file: pointer to file object
+ *
+ * returns   returned a list entry on success, NULL on failure.
+ */
+struct mei_cl_cb *find_amthi_read_list_entry(
+		struct mei_device *dev,
+		struct file *file)
+{
+	struct mei_cl *file_ext_temp;
+	struct mei_cl_cb *priv_cb_pos = NULL;
+	struct mei_cl_cb *priv_cb_next = NULL;
+
+	if (!dev->amthi_read_complete_list.status &&
+	    !list_empty(&dev->amthi_read_complete_list.mei_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+		    &dev->amthi_read_complete_list.mei_cb.cb_list, cb_list) {
+			file_ext_temp = (struct mei_cl *)
+					priv_cb_pos->file_private;
+			if (file_ext_temp &&
+			    file_ext_temp == &dev->iamthif_file_ext &&
+			    priv_cb_pos->file_object == file)
+				return priv_cb_pos;
+		}
+	}
+	return NULL;
+}
+
+/**
+ * amthi_read - read data from AMTHI client
+ *
+ * @dev: the device structure
+ * @if_num:  minor number
+ * @file: pointer to file object
+ * @*ubuf: pointer to user data in user space
+ * @length: data length to read
+ * @offset: data read offset
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * returns
+ *  returned data length on success,
+ *  zero if no data to read,
+ *  negative on failure.
+ */
+int amthi_read(struct mei_device *dev, struct file *file,
+	      char __user *ubuf, size_t length, loff_t *offset)
+{
+	int rets;
+	int wait_ret;
+	struct mei_cl_cb *priv_cb = NULL;
+	struct mei_cl *file_ext = file->private_data;
+	unsigned long timeout;
+	int i;
+
+	/* Only Posible if we are in timeout */
+	if (!file_ext || file_ext != &dev->iamthif_file_ext) {
+		dev_dbg(&dev->pdev->dev, "bad file ext.\n");
+		return -ETIMEDOUT;
+	}
+
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    dev->iamthif_file_ext.me_client_id)
+			break;
+	}
+
+	if (i == dev->num_mei_me_clients) {
+		dev_dbg(&dev->pdev->dev, "amthi client not found.\n");
+		return -ENODEV;
+	}
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+
+	dev_dbg(&dev->pdev->dev, "checking amthi data\n");
+	priv_cb = find_amthi_read_list_entry(dev, file);
+
+	/* Check for if we can block or not*/
+	if (priv_cb == NULL && file->f_flags & O_NONBLOCK)
+		return -EAGAIN;
+
+
+	dev_dbg(&dev->pdev->dev, "waiting for amthi data\n");
+	while (priv_cb == NULL) {
+		/* unlock the Mutex */
+		mutex_unlock(&dev->device_lock);
+
+		wait_ret = wait_event_interruptible(dev->iamthif_file_ext.wait,
+			(priv_cb = find_amthi_read_list_entry(dev, file)));
+
+		if (wait_ret)
+			return -ERESTARTSYS;
+
+		dev_dbg(&dev->pdev->dev, "woke up from sleep\n");
+
+		/* Locking again the Mutex */
+		mutex_lock(&dev->device_lock);
+	}
+
+
+	dev_dbg(&dev->pdev->dev, "Got amthi data\n");
+	dev->iamthif_timer = 0;
+
+	if (priv_cb) {
+		timeout = priv_cb->read_time +
+					msecs_to_jiffies(IAMTHIF_READ_TIMER);
+		dev_dbg(&dev->pdev->dev, "amthi timeout = %lud\n",
+				timeout);
+
+		if  (time_after(jiffies, timeout)) {
+			dev_dbg(&dev->pdev->dev, "amthi Time out\n");
+			/* 15 sec for the message has expired */
+			list_del(&priv_cb->cb_list);
+			rets = -ETIMEDOUT;
+			goto free;
+		}
+	}
+	/* if the whole message will fit remove it from the list */
+	if (priv_cb->information >= *offset &&
+	    length >= (priv_cb->information - *offset))
+		list_del(&priv_cb->cb_list);
+	else if (priv_cb->information > 0 && priv_cb->information <= *offset) {
+		/* end of the message has been reached */
+		list_del(&priv_cb->cb_list);
+		rets = 0;
+		goto free;
+	}
+		/* else means that not full buffer will be read and do not
+		 * remove message from deletion list
+		 */
+
+	dev_dbg(&dev->pdev->dev, "amthi priv_cb->response_buffer size - %d\n",
+	    priv_cb->response_buffer.size);
+	dev_dbg(&dev->pdev->dev, "amthi priv_cb->information - %lu\n",
+	    priv_cb->information);
+
+	/* length is being turncated to PAGE_SIZE, however,
+	 * the information may be longer */
+	length = min_t(size_t, length, (priv_cb->information - *offset));
+
+	if (copy_to_user(ubuf,
+			 priv_cb->response_buffer.data + *offset,
+			 length))
+		rets = -EFAULT;
+	else {
+		rets = length;
+		if ((*offset + length) < priv_cb->information) {
+			*offset += length;
+			goto out;
+		}
+	}
+free:
+	dev_dbg(&dev->pdev->dev, "free amthi cb memory.\n");
+	*offset = 0;
+	mei_free_cb_private(priv_cb);
+out:
+	return rets;
+}
+
+/**
+ * mei_start_read - the start read client message function.
+ *
+ * @dev: the device structure
+ * @if_num:  minor number
+ * @file_ext: private data of the file object
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_start_read(struct mei_device *dev, struct mei_cl *file_ext)
+{
+	struct mei_cl_cb *priv_cb;
+	int rets = 0;
+	int i;
+
+	if (file_ext->state != MEI_FILE_CONNECTED)
+		return -ENODEV;
+
+	if (dev->mei_state != MEI_ENABLED)
+		return -ENODEV;
+
+	dev_dbg(&dev->pdev->dev, "check if read is pending.\n");
+	if (file_ext->read_pending || file_ext->read_cb) {
+		dev_dbg(&dev->pdev->dev, "read is pending.\n");
+		return -EBUSY;
+	}
+
+	priv_cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	if (!priv_cb)
+		return -ENOMEM;
+
+	dev_dbg(&dev->pdev->dev, "allocation call back successful. host client = %d, ME client = %d\n",
+		file_ext->host_client_id, file_ext->me_client_id);
+
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (dev->me_clients[i].client_id == file_ext->me_client_id)
+			break;
+
+	}
+
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if (i == dev->num_mei_me_clients) {
+		rets = -ENODEV;
+		goto unlock;
+	}
+
+	priv_cb->response_buffer.size = dev->me_clients[i].props.max_msg_length;
+	priv_cb->response_buffer.data =
+	    kmalloc(priv_cb->response_buffer.size, GFP_KERNEL);
+	if (!priv_cb->response_buffer.data) {
+		rets = -ENOMEM;
+		goto unlock;
+	}
+	dev_dbg(&dev->pdev->dev, "allocation call back data success.\n");
+	priv_cb->major_file_operations = MEI_READ;
+	/* make sure information is zero before we start */
+	priv_cb->information = 0;
+	priv_cb->file_private = (void *) file_ext;
+	file_ext->read_cb = priv_cb;
+	if (dev->mei_host_buffer_is_empty) {
+		dev->mei_host_buffer_is_empty = 0;
+		if (!mei_send_flow_control(dev, file_ext)) {
+			rets = -ENODEV;
+			goto unlock;
+		} else {
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->read_list.mei_cb.cb_list);
+		}
+	} else {
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->ctrl_wr_list.mei_cb.cb_list);
+	}
+	return rets;
+unlock:
+	mei_free_cb_private(priv_cb);
+	return rets;
+}
+
+/**
+ * amthi_write - write iamthif data to amthi client
+ *
+ * @dev: the device structure
+ * @priv_cb: mei call back struct
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int amthi_write(struct mei_device *dev,
+	       struct mei_cl_cb *priv_cb)
+{
+	struct mei_msg_hdr mei_hdr;
+
+	if (!dev || !priv_cb)
+		return -ENODEV;
+
+	dev_dbg(&dev->pdev->dev, "write data to amthi client.\n");
+
+	dev->iamthif_state = MEI_IAMTHIF_WRITING;
+	dev->iamthif_current_cb = priv_cb;
+	dev->iamthif_file_object = priv_cb->file_object;
+	dev->iamthif_canceled = 0;
+	dev->iamthif_ioctl = 1;
+	dev->iamthif_msg_buf_size = priv_cb->request_buffer.size;
+	memcpy(dev->iamthif_msg_buf, priv_cb->request_buffer.data,
+	    priv_cb->request_buffer.size);
+
+	if (mei_flow_ctrl_creds(dev, &dev->iamthif_file_ext) &&
+	    dev->mei_host_buffer_is_empty) {
+		dev->mei_host_buffer_is_empty = 0;
+		if (priv_cb->request_buffer.size >
+			(((dev->host_hw_state & H_CBD) >> 24) * sizeof(u32))
+				-sizeof(struct mei_msg_hdr)) {
+			mei_hdr.length =
+			    (((dev->host_hw_state & H_CBD) >> 24) *
+			    sizeof(u32)) - sizeof(struct mei_msg_hdr);
+			mei_hdr.msg_complete = 0;
+		} else {
+			mei_hdr.length = priv_cb->request_buffer.size;
+			mei_hdr.msg_complete = 1;
+		}
+
+		mei_hdr.host_addr = dev->iamthif_file_ext.host_client_id;
+		mei_hdr.me_addr = dev->iamthif_file_ext.me_client_id;
+		mei_hdr.reserved = 0;
+		dev->iamthif_msg_buf_index += mei_hdr.length;
+		if (!mei_write_message(dev, &mei_hdr,
+					(unsigned char *)(dev->iamthif_msg_buf),
+					mei_hdr.length))
+			return -ENODEV;
+
+		if (mei_hdr.msg_complete) {
+			mei_flow_ctrl_reduce(dev, &dev->iamthif_file_ext);
+			dev->iamthif_flow_control_pending = 1;
+			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
+			dev_dbg(&dev->pdev->dev, "add amthi cb to write waiting list\n");
+			dev->iamthif_current_cb = priv_cb;
+			dev->iamthif_file_object = priv_cb->file_object;
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->write_waiting_list.mei_cb.cb_list);
+		} else {
+			dev_dbg(&dev->pdev->dev, "message does not complete, "
+					"so add amthi cb to write list.\n");
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->write_list.mei_cb.cb_list);
+		}
+	} else {
+		if (!(dev->mei_host_buffer_is_empty))
+			dev_dbg(&dev->pdev->dev, "host buffer is not empty");
+
+		dev_dbg(&dev->pdev->dev, "No flow control credentials, "
+				"so add iamthif cb to write list.\n");
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->write_list.mei_cb.cb_list);
+	}
+	return 0;
+}
+
+/**
+ * iamthif_ioctl_send_msg - send cmd data to amthi client
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+void run_next_iamthif_cmd(struct mei_device *dev)
+{
+	struct mei_cl *file_ext_tmp;
+	struct mei_cl_cb *priv_cb_pos = NULL;
+	struct mei_cl_cb *priv_cb_next = NULL;
+	int status;
+
+	if (!dev)
+		return;
+
+	dev->iamthif_msg_buf_size = 0;
+	dev->iamthif_msg_buf_index = 0;
+	dev->iamthif_canceled = 0;
+	dev->iamthif_ioctl = 1;
+	dev->iamthif_state = MEI_IAMTHIF_IDLE;
+	dev->iamthif_timer = 0;
+	dev->iamthif_file_object = NULL;
+
+	if (dev->amthi_cmd_list.status == 0 &&
+	    !list_empty(&dev->amthi_cmd_list.mei_cb.cb_list)) {
+		dev_dbg(&dev->pdev->dev, "complete amthi cmd_list cb.\n");
+
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+		    &dev->amthi_cmd_list.mei_cb.cb_list, cb_list) {
+			list_del(&priv_cb_pos->cb_list);
+			file_ext_tmp = (struct mei_cl *)
+					priv_cb_pos->file_private;
+
+			if (file_ext_tmp &&
+			    file_ext_tmp == &dev->iamthif_file_ext) {
+				status = amthi_write(dev, priv_cb_pos);
+				if (status) {
+					dev_dbg(&dev->pdev->dev,
+						"amthi write failed status = %d\n",
+							status);
+					return;
+				}
+				break;
+			}
+		}
+	}
+}
+
+/**
+ * mei_free_cb_private - free mei_cb_private related memory
+ *
+ * @priv_cb: mei callback struct
+ */
+void mei_free_cb_private(struct mei_cl_cb *priv_cb)
+{
+	if (priv_cb == NULL)
+		return;
+
+	kfree(priv_cb->request_buffer.data);
+	kfree(priv_cb->response_buffer.data);
+	kfree(priv_cb);
+}
diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
new file mode 100644
index 0000000..b63157d
--- /dev/null
+++ b/drivers/staging/mei/main.c
@@ -0,0 +1,1340 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
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
+ */
+
+
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/aio.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/version.h>
+#include <linux/sched.h>
+#include <linux/uuid.h>
+#include <linux/compat.h>
+#include <linux/jiffies.h>
+
+#include "mei.h"
+#include "interface.h"
+#include "mei_version.h"
+
+
+#define MEI_READ_TIMEOUT 45
+#define MEI_DRIVER_NAME	"mei"
+#define MEI_DEV_NAME "mei"
+
+/*
+ *  mei driver strings
+ */
+static char mei_driver_name[] = MEI_DRIVER_NAME;
+static const char mei_driver_string[] = "Intel(R) Management Engine Interface";
+static const char mei_driver_version[] = MEI_DRIVER_VERSION;
+
+/* mei char device for registration */
+static struct cdev mei_cdev;
+
+/* major number for device */
+static int mei_major;
+/* The device pointer */
+/* Currently this driver works as long as there is only a single AMT device. */
+static struct pci_dev *mei_device;
+
+static struct class *mei_class;
+
+
+/* mei_pci_tbl - PCI Device ID Table */
+static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GM965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GME965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q35)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82G33)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q33)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82X38)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_3200)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_6)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_7)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_8)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_9)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_10)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_4)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_4)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_CPT_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PBG_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_3)},
+
+	/* required last entry */
+	{0, }
+};
+
+MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
+
+static DEFINE_MUTEX(mei_mutex);
+
+/**
+ * mei_probe - Device Initialization Routine
+ *
+ * @pdev: PCI device structure
+ * @ent: entry in kcs_pci_tbl
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int __devinit mei_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct mei_device *dev;
+	int err;
+
+	mutex_lock(&mei_mutex);
+	if (mei_device) {
+		err = -EEXIST;
+		goto end;
+	}
+	/* enable pci dev */
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "mei: Failed to enable pci device.\n");
+		goto end;
+	}
+	/* set PCI host mastering  */
+	pci_set_master(pdev);
+	/* pci request regions for mei driver */
+	err = pci_request_regions(pdev, mei_driver_name);
+	if (err) {
+		printk(KERN_ERR "mei: Failed to get pci regions.\n");
+		goto disable_device;
+	}
+	/* allocates and initializes the mei dev structure */
+	dev = init_mei_device(pdev);
+	if (!dev) {
+		err = -ENOMEM;
+		goto release_regions;
+	}
+	/* mapping  IO device memory */
+	dev->mem_addr = pci_iomap(pdev, 0, 0);
+	if (!dev->mem_addr) {
+		printk(KERN_ERR "mei: mapping I/O device memory failure.\n");
+		err = -ENOMEM;
+		goto free_device;
+	}
+	/* request and enable interrupt   */
+	err = request_threaded_irq(pdev->irq,
+			mei_interrupt_quick_handler,
+			mei_interrupt_thread_handler,
+			IRQF_SHARED, mei_driver_name, dev);
+	if (err) {
+		printk(KERN_ERR "mei: request_threaded_irq failure. irq = %d\n",
+		       pdev->irq);
+		goto unmap_memory;
+	}
+	INIT_DELAYED_WORK(&dev->wd_work, mei_wd_timer);
+	if (mei_hw_init(dev)) {
+		printk(KERN_ERR "mei: Init hw failure.\n");
+		err = -ENODEV;
+		goto release_irq;
+	}
+	mei_device = pdev;
+	pci_set_drvdata(pdev, dev);
+	schedule_delayed_work(&dev->wd_work, HZ);
+
+	mutex_unlock(&mei_mutex);
+
+	pr_debug("mei: Driver initialization successful.\n");
+
+	return 0;
+
+release_irq:
+	/* disable interrupts */
+	dev->host_hw_state = mei_hcsr_read(dev);
+	mei_disable_interrupts(dev);
+	flush_scheduled_work();
+	free_irq(pdev->irq, dev);
+unmap_memory:
+	iounmap(dev->mem_addr);
+free_device:
+	kfree(dev);
+release_regions:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+end:
+	mutex_unlock(&mei_mutex);
+	printk(KERN_ERR "mei: Driver initialization failed.\n");
+	return err;
+}
+
+/**
+ * mei_remove - Device Removal Routine
+ *
+ * @pdev: PCI device structure
+ *
+ * mei_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ */
+static void __devexit mei_remove(struct pci_dev *pdev)
+{
+	struct mei_device *dev;
+
+	if (mei_device != pdev)
+		return;
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return;
+
+	mutex_lock(&dev->device_lock);
+
+	mei_wd_stop(dev, false);
+
+	mei_device = NULL;
+
+	if (dev->iamthif_file_ext.state == MEI_FILE_CONNECTED) {
+		dev->iamthif_file_ext.state = MEI_FILE_DISCONNECTING;
+		mei_disconnect_host_client(dev, &dev->iamthif_file_ext);
+	}
+	if (dev->wd_cl.state == MEI_FILE_CONNECTED) {
+		dev->wd_cl.state = MEI_FILE_DISCONNECTING;
+		mei_disconnect_host_client(dev, &dev->wd_cl);
+	}
+
+	/* remove entry if already in list */
+	dev_dbg(&pdev->dev, "list del iamthif and wd file list.\n");
+	mei_remove_client_from_file_list(dev, dev->wd_cl.
+					  host_client_id);
+	mei_remove_client_from_file_list(dev,
+			dev->iamthif_file_ext.host_client_id);
+
+	dev->iamthif_current_cb = NULL;
+	dev->num_mei_me_clients = 0;
+
+	mutex_unlock(&dev->device_lock);
+
+	flush_scheduled_work();
+
+	/* disable interrupts */
+	mei_disable_interrupts(dev);
+
+	free_irq(pdev->irq, dev);
+	pci_set_drvdata(pdev, NULL);
+
+	if (dev->mem_addr)
+		iounmap(dev->mem_addr);
+
+	kfree(dev);
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+/**
+ * mei_clear_list - removes all callbacks associated with file
+ *		from mei_cb_list
+ *
+ * @dev: device structure.
+ * @file: file structure
+ * @mei_cb_list: callbacks list
+ *
+ * mei_clear_list is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * returns true if callback removed from the list, false otherwise
+ */
+static bool mei_clear_list(struct mei_device *dev,
+		struct file *file, struct list_head *mei_cb_list)
+{
+	struct mei_cl_cb *priv_cb_pos = NULL;
+	struct mei_cl_cb *priv_cb_next = NULL;
+	struct file *file_temp;
+	bool removed = false;
+
+	/* list all list member */
+	list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				 mei_cb_list, cb_list) {
+		file_temp = (struct file *)priv_cb_pos->file_object;
+		/* check if list member associated with a file */
+		if (file_temp == file) {
+			/* remove member from the list */
+			list_del(&priv_cb_pos->cb_list);
+			/* check if cb equal to current iamthif cb */
+			if (dev->iamthif_current_cb == priv_cb_pos) {
+				dev->iamthif_current_cb = NULL;
+				/* send flow control to iamthif client */
+				mei_send_flow_control(dev,
+						       &dev->iamthif_file_ext);
+			}
+			/* free all allocated buffers */
+			mei_free_cb_private(priv_cb_pos);
+			priv_cb_pos = NULL;
+			removed = true;
+		}
+	}
+	return removed;
+}
+
+/**
+ * mei_clear_lists - removes all callbacks associated with file
+ *
+ * @dev: device structure
+ * @file: file structure
+ *
+ * mei_clear_lists is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * returns true if callback removed from the list, false otherwise
+ */
+static bool mei_clear_lists(struct mei_device *dev, struct file *file)
+{
+	bool removed = false;
+
+	/* remove callbacks associated with a file */
+	mei_clear_list(dev, file, &dev->amthi_cmd_list.mei_cb.cb_list);
+	if (mei_clear_list(dev, file,
+			    &dev->amthi_read_complete_list.mei_cb.cb_list))
+		removed = true;
+
+	mei_clear_list(dev, file, &dev->ctrl_rd_list.mei_cb.cb_list);
+
+	if (mei_clear_list(dev, file, &dev->ctrl_wr_list.mei_cb.cb_list))
+		removed = true;
+
+	if (mei_clear_list(dev, file,
+			    &dev->write_waiting_list.mei_cb.cb_list))
+		removed = true;
+
+	if (mei_clear_list(dev, file, &dev->write_list.mei_cb.cb_list))
+		removed = true;
+
+	/* check if iamthif_current_cb not NULL */
+	if (dev->iamthif_current_cb && !removed) {
+		/* check file and iamthif current cb association */
+		if (dev->iamthif_current_cb->file_object == file) {
+			/* remove cb */
+			mei_free_cb_private(dev->iamthif_current_cb);
+			dev->iamthif_current_cb = NULL;
+			removed = true;
+		}
+	}
+	return removed;
+}
+/**
+ * find_read_list_entry - find read list entry
+ *
+ * @dev: device structure
+ * @file: pointer to file structure
+ *
+ * returns cb on success, NULL on error
+ */
+static struct mei_cl_cb *find_read_list_entry(
+		struct mei_device *dev,
+		struct mei_cl *file_ext)
+{
+	struct mei_cl_cb *priv_cb_pos = NULL;
+	struct mei_cl_cb *priv_cb_next = NULL;
+	struct mei_cl *file_ext_list_temp;
+
+	if (!dev->read_list.status &&
+	    !list_empty(&dev->read_list.mei_cb.cb_list)) {
+
+		dev_dbg(&dev->pdev->dev, "remove read_list CB\n");
+		list_for_each_entry_safe(priv_cb_pos,
+				priv_cb_next,
+				&dev->read_list.mei_cb.cb_list, cb_list) {
+
+			file_ext_list_temp = (struct mei_cl *)
+				priv_cb_pos->file_private;
+
+			if (file_ext_list_temp &&
+			    mei_fe_same_id(file_ext, file_ext_list_temp))
+				return priv_cb_pos;
+
+		}
+	}
+	return NULL;
+}
+
+/**
+ * mei_open - the open function
+ *
+ * @inode: pointer to inode structure
+ * @file: pointer to file structure
+ *
+ * returns 0 on success, <0 on error
+ */
+static int mei_open(struct inode *inode, struct file *file)
+{
+	struct mei_cl *file_ext;
+	int if_num = iminor(inode), err;
+	struct mei_device *dev;
+
+	err = -ENODEV;
+	if (!mei_device)
+		goto out;
+
+	dev = pci_get_drvdata(mei_device);
+	if (if_num != MEI_MINOR_NUMBER || !dev)
+		goto out;
+
+	mutex_lock(&dev->device_lock);
+	err = -ENOMEM;
+	file_ext = mei_alloc_file_private(dev);
+	if (!file_ext)
+		goto out;
+
+	err = -ENODEV;
+	if (dev->mei_state != MEI_ENABLED) {
+		dev_dbg(&dev->pdev->dev, "mei_state != MEI_ENABLED  mei_state= %d\n",
+		    dev->mei_state);
+		goto out_unlock;
+	}
+	err = -EMFILE;
+	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT)
+		goto out_unlock;
+
+	file_ext->host_client_id = find_first_zero_bit(dev->host_clients_map,
+							MEI_CLIENTS_MAX);
+	if (file_ext->host_client_id > MEI_CLIENTS_MAX)
+		goto out_unlock;
+
+	dev_dbg(&dev->pdev->dev, "client_id = %d\n", file_ext->host_client_id);
+
+	dev->open_handle_count++;
+	list_add_tail(&file_ext->link, &dev->file_list);
+
+	set_bit(file_ext->host_client_id, dev->host_clients_map);
+	file_ext->state = MEI_FILE_INITIALIZING;
+	file_ext->sm_state = 0;
+
+	file->private_data = file_ext;
+	mutex_unlock(&dev->device_lock);
+
+	return 0;
+
+out_unlock:
+	mutex_unlock(&dev->device_lock);
+	kfree(file_ext);
+out:
+	return err;
+}
+
+/**
+ * mei_release - the release function
+ *
+ * @inode: pointer to inode structure
+ * @file: pointer to file structure
+ *
+ * returns 0 on success, <0 on error
+ */
+static int mei_release(struct inode *inode, struct file *file)
+{
+	struct mei_cl *file_ext = file->private_data;
+	struct mei_cl_cb *priv_cb;
+	struct mei_device *dev;
+	int rets = 0;
+
+	if (WARN_ON(!file_ext || !file_ext->dev))
+		return -ENODEV;
+
+	dev = file_ext->dev;
+
+	mutex_lock(&dev->device_lock);
+	if (file_ext != &dev->iamthif_file_ext) {
+		if (file_ext->state == MEI_FILE_CONNECTED) {
+			file_ext->state = MEI_FILE_DISCONNECTING;
+			dev_dbg(&dev->pdev->dev,
+				"disconnecting client host client = %d, "
+			    "ME client = %d\n",
+			    file_ext->host_client_id,
+			    file_ext->me_client_id);
+			rets = mei_disconnect_host_client(dev, file_ext);
+		}
+		mei_flush_queues(dev, file_ext);
+		dev_dbg(&dev->pdev->dev, "remove client host client = %d, ME client = %d\n",
+		    file_ext->host_client_id,
+		    file_ext->me_client_id);
+
+		if (dev->open_handle_count > 0) {
+			clear_bit(file_ext->host_client_id,
+				  dev->host_clients_map);
+			dev->open_handle_count--;
+		}
+		mei_remove_client_from_file_list(dev, file_ext->host_client_id);
+
+		/* free read cb */
+		priv_cb = NULL;
+		if (file_ext->read_cb) {
+			priv_cb = find_read_list_entry(dev, file_ext);
+			/* Remove entry from read list */
+			if (priv_cb)
+				list_del(&priv_cb->cb_list);
+
+			priv_cb = file_ext->read_cb;
+			file_ext->read_cb = NULL;
+		}
+
+		file->private_data = NULL;
+
+		if (priv_cb) {
+			mei_free_cb_private(priv_cb);
+			priv_cb = NULL;
+		}
+
+		kfree(file_ext);
+	} else {
+		if (dev->open_handle_count > 0)
+			dev->open_handle_count--;
+
+		if (dev->iamthif_file_object == file &&
+		    dev->iamthif_state != MEI_IAMTHIF_IDLE) {
+
+			dev_dbg(&dev->pdev->dev, "amthi canceled iamthif state %d\n",
+			    dev->iamthif_state);
+			dev->iamthif_canceled = 1;
+			if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE) {
+				dev_dbg(&dev->pdev->dev, "run next amthi iamthif cb\n");
+				run_next_iamthif_cmd(dev);
+			}
+		}
+
+		if (mei_clear_lists(dev, file))
+			dev->iamthif_state = MEI_IAMTHIF_IDLE;
+
+	}
+	mutex_unlock(&dev->device_lock);
+	return rets;
+}
+
+
+/**
+ * mei_read - the read function.
+ *
+ * @file: pointer to file structure
+ * @ubuf: pointer to user buffer
+ * @length: buffer length
+ * @offset: data offset in buffer
+ *
+ * returns >=0 data length on success , <0 on error
+ */
+static ssize_t mei_read(struct file *file, char __user *ubuf,
+			 size_t length, loff_t *offset)
+{
+	struct mei_cl *file_ext = file->private_data;
+	struct mei_cl_cb *priv_cb_pos = NULL;
+	struct mei_cl_cb *priv_cb = NULL;
+	struct mei_device *dev;
+	int i;
+	int rets;
+	int err;
+
+
+	if (WARN_ON(!file_ext || !file_ext->dev))
+		return -ENODEV;
+
+	dev = file_ext->dev;
+
+	mutex_lock(&dev->device_lock);
+	if (dev->mei_state != MEI_ENABLED) {
+		rets = -ENODEV;
+		goto out;
+	}
+
+	if ((file_ext->sm_state & MEI_WD_STATE_INDEPENDENCE_MSG_SENT) == 0) {
+		/* Do not allow to read watchdog client */
+		i = mei_find_me_client_index(dev, mei_wd_guid);
+		if (i >= 0) {
+			struct mei_me_client *me_client = &dev->me_clients[i];
+
+			if (file_ext->me_client_id == me_client->client_id) {
+				rets = -EBADF;
+				goto out;
+			}
+		}
+	} else {
+		file_ext->sm_state &= ~MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
+	}
+
+	if (file_ext == &dev->iamthif_file_ext) {
+		rets = amthi_read(dev, file, ubuf, length, offset);
+		goto out;
+	}
+
+	if (file_ext->read_cb && file_ext->read_cb->information > *offset) {
+		priv_cb = file_ext->read_cb;
+		goto copy_buffer;
+	} else if (file_ext->read_cb && file_ext->read_cb->information > 0 &&
+		   file_ext->read_cb->information <= *offset) {
+		priv_cb = file_ext->read_cb;
+		rets = 0;
+		goto free;
+	} else if ((!file_ext->read_cb || !file_ext->read_cb->information) &&
+		    *offset > 0) {
+		/*Offset needs to be cleaned for contingous reads*/
+		*offset = 0;
+		rets = 0;
+		goto out;
+	}
+
+	err = mei_start_read(dev, file_ext);
+	if (err && err != -EBUSY) {
+		dev_dbg(&dev->pdev->dev,
+			"mei start read failure with status = %d\n", err);
+		rets = err;
+		goto out;
+	}
+
+	if (MEI_READ_COMPLETE != file_ext->reading_state &&
+			!waitqueue_active(&file_ext->rx_wait)) {
+		if (file->f_flags & O_NONBLOCK) {
+			rets = -EAGAIN;
+			goto out;
+		}
+
+		mutex_unlock(&dev->device_lock);
+
+		if (wait_event_interruptible(file_ext->rx_wait,
+			(MEI_READ_COMPLETE == file_ext->reading_state ||
+			 MEI_FILE_INITIALIZING == file_ext->state ||
+			 MEI_FILE_DISCONNECTED == file_ext->state ||
+			 MEI_FILE_DISCONNECTING == file_ext->state))) {
+			if (signal_pending(current))
+				return -EINTR;
+			return -ERESTARTSYS;
+		}
+
+		mutex_lock(&dev->device_lock);
+		if (MEI_FILE_INITIALIZING == file_ext->state ||
+		    MEI_FILE_DISCONNECTED == file_ext->state ||
+		    MEI_FILE_DISCONNECTING == file_ext->state) {
+			rets = -EBUSY;
+			goto out;
+		}
+	}
+
+	priv_cb = file_ext->read_cb;
+
+	if (!priv_cb) {
+		rets = -ENODEV;
+		goto out;
+	}
+	if (file_ext->reading_state != MEI_READ_COMPLETE) {
+		rets = 0;
+		goto out;
+	}
+	/* now copy the data to user space */
+copy_buffer:
+	dev_dbg(&dev->pdev->dev, "priv_cb->response_buffer size - %d\n",
+	    priv_cb->response_buffer.size);
+	dev_dbg(&dev->pdev->dev, "priv_cb->information - %lu\n",
+	    priv_cb->information);
+	if (length == 0 || ubuf == NULL || *offset > priv_cb->information) {
+		rets = -EMSGSIZE;
+		goto free;
+	}
+
+	/* length is being turncated to PAGE_SIZE, however, */
+	/* information size may be longer */
+	length = min_t(size_t, length, (priv_cb->information - *offset));
+
+	if (copy_to_user(ubuf,
+			 priv_cb->response_buffer.data + *offset,
+			 length)) {
+		rets = -EFAULT;
+		goto free;
+	}
+
+	rets = length;
+	*offset += length;
+	if ((unsigned long)*offset < priv_cb->information)
+		goto out;
+
+free:
+	priv_cb_pos = find_read_list_entry(dev, file_ext);
+	/* Remove entry from read list */
+	if (priv_cb_pos)
+		list_del(&priv_cb_pos->cb_list);
+	mei_free_cb_private(priv_cb);
+	file_ext->reading_state = MEI_IDLE;
+	file_ext->read_cb = NULL;
+	file_ext->read_pending = 0;
+out:
+	dev_dbg(&dev->pdev->dev, "end mei read rets= %d\n", rets);
+	mutex_unlock(&dev->device_lock);
+	return rets;
+}
+
+/**
+ * mei_write - the write function.
+ *
+ * @file: pointer to file structure
+ * @ubuf: pointer to user buffer
+ * @length: buffer length
+ * @offset: data offset in buffer
+ *
+ * returns >=0 data length on success , <0 on error
+ */
+static ssize_t mei_write(struct file *file, const char __user *ubuf,
+			  size_t length, loff_t *offset)
+{
+	struct mei_cl *file_ext = file->private_data;
+	struct mei_cl_cb *priv_write_cb = NULL;
+	struct mei_msg_hdr mei_hdr;
+	struct mei_device *dev;
+	unsigned long timeout = 0;
+	int rets;
+	int i;
+
+	if (WARN_ON(!file_ext || !file_ext->dev))
+		return -ENODEV;
+
+	dev = file_ext->dev;
+
+	mutex_lock(&dev->device_lock);
+
+	if (dev->mei_state != MEI_ENABLED) {
+		mutex_unlock(&dev->device_lock);
+		return -ENODEV;
+	}
+
+	if (file_ext == &dev->iamthif_file_ext) {
+		priv_write_cb = find_amthi_read_list_entry(dev, file);
+
+		if (priv_write_cb) {
+			timeout = priv_write_cb->read_time +
+					msecs_to_jiffies(IAMTHIF_READ_TIMER);
+
+			if (time_after(jiffies, timeout) ||
+				 file_ext->reading_state == MEI_READ_COMPLETE) {
+					*offset = 0;
+					list_del(&priv_write_cb->cb_list);
+					mei_free_cb_private(priv_write_cb);
+					priv_write_cb = NULL;
+			}
+		}
+	}
+
+	/* free entry used in read */
+	if (file_ext->reading_state == MEI_READ_COMPLETE) {
+		*offset = 0;
+		priv_write_cb = find_read_list_entry(dev, file_ext);
+		if (priv_write_cb) {
+			list_del(&priv_write_cb->cb_list);
+			mei_free_cb_private(priv_write_cb);
+			priv_write_cb = NULL;
+			file_ext->reading_state = MEI_IDLE;
+			file_ext->read_cb = NULL;
+			file_ext->read_pending = 0;
+		}
+	} else if (file_ext->reading_state == MEI_IDLE &&
+		   !file_ext->read_pending)
+		*offset = 0;
+
+
+	priv_write_cb = kzalloc(sizeof(struct mei_cl_cb), GFP_KERNEL);
+	if (!priv_write_cb) {
+		mutex_unlock(&dev->device_lock);
+		return -ENOMEM;
+	}
+
+	priv_write_cb->file_object = file;
+	priv_write_cb->file_private = file_ext;
+	priv_write_cb->request_buffer.data = kmalloc(length, GFP_KERNEL);
+	rets = -ENOMEM;
+	if (!priv_write_cb->request_buffer.data)
+		goto unlock_dev;
+
+	dev_dbg(&dev->pdev->dev, "length =%d\n", (int) length);
+
+	rets = -EFAULT;
+	if (copy_from_user(priv_write_cb->request_buffer.data, ubuf, length))
+		goto unlock_dev;
+
+	file_ext->sm_state = 0;
+	if (length == 4 &&
+	    ((memcmp(mei_wd_state_independence_msg[0],
+				 priv_write_cb->request_buffer.data, 4) == 0) ||
+	     (memcmp(mei_wd_state_independence_msg[1],
+				 priv_write_cb->request_buffer.data, 4) == 0) ||
+	     (memcmp(mei_wd_state_independence_msg[2],
+				 priv_write_cb->request_buffer.data, 4) == 0)))
+		file_ext->sm_state |= MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
+
+	INIT_LIST_HEAD(&priv_write_cb->cb_list);
+	if (file_ext == &dev->iamthif_file_ext) {
+		priv_write_cb->response_buffer.data =
+		    kmalloc(dev->iamthif_mtu, GFP_KERNEL);
+		if (!priv_write_cb->response_buffer.data) {
+			rets = -ENOMEM;
+			goto unlock_dev;
+		}
+		if (dev->mei_state != MEI_ENABLED) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		}
+		for (i = 0; i < dev->num_mei_me_clients; i++) {
+			if (dev->me_clients[i].client_id ==
+				dev->iamthif_file_ext.me_client_id)
+				break;
+		}
+
+		BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+		if (i == dev->num_mei_me_clients ||
+		    (dev->me_clients[i].client_id !=
+		      dev->iamthif_file_ext.me_client_id)) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		} else if (length > dev->me_clients[i].props.max_msg_length ||
+			   length <= 0) {
+			rets = -EMSGSIZE;
+			goto unlock_dev;
+		}
+
+		priv_write_cb->response_buffer.size = dev->iamthif_mtu;
+		priv_write_cb->major_file_operations = MEI_IOCTL;
+		priv_write_cb->information = 0;
+		priv_write_cb->request_buffer.size = length;
+		if (dev->iamthif_file_ext.state != MEI_FILE_CONNECTED) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		}
+
+		if (!list_empty(&dev->amthi_cmd_list.mei_cb.cb_list) ||
+				dev->iamthif_state != MEI_IAMTHIF_IDLE) {
+			dev_dbg(&dev->pdev->dev, "amthi_state = %d\n",
+					(int) dev->iamthif_state);
+			dev_dbg(&dev->pdev->dev, "add amthi cb to amthi cmd waiting list\n");
+			list_add_tail(&priv_write_cb->cb_list,
+					&dev->amthi_cmd_list.mei_cb.cb_list);
+			rets = length;
+		} else {
+			dev_dbg(&dev->pdev->dev, "call amthi write\n");
+			rets = amthi_write(dev, priv_write_cb);
+
+			if (rets) {
+				dev_dbg(&dev->pdev->dev, "amthi write failed with status = %d\n",
+				    rets);
+				goto unlock_dev;
+			}
+			rets = length;
+		}
+		mutex_unlock(&dev->device_lock);
+		return rets;
+	}
+
+	priv_write_cb->major_file_operations = MEI_WRITE;
+	/* make sure information is zero before we start */
+
+	priv_write_cb->information = 0;
+	priv_write_cb->request_buffer.size = length;
+
+	dev_dbg(&dev->pdev->dev, "host client = %d, ME client = %d\n",
+	    file_ext->host_client_id, file_ext->me_client_id);
+	if (file_ext->state != MEI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		dev_dbg(&dev->pdev->dev, "host client = %d,  is not connected to ME client = %d",
+		    file_ext->host_client_id,
+		    file_ext->me_client_id);
+		goto unlock_dev;
+	}
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    file_ext->me_client_id)
+			break;
+	}
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if (i == dev->num_mei_me_clients) {
+		rets = -ENODEV;
+		goto unlock_dev;
+	}
+	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
+		rets = -EINVAL;
+		goto unlock_dev;
+	}
+	priv_write_cb->file_private = file_ext;
+
+	if (mei_flow_ctrl_creds(dev, file_ext) &&
+		dev->mei_host_buffer_is_empty) {
+		dev->mei_host_buffer_is_empty = 0;
+		if (length > ((((dev->host_hw_state & H_CBD) >> 24) *
+			sizeof(u32)) - sizeof(struct mei_msg_hdr))) {
+
+			mei_hdr.length =
+				(((dev->host_hw_state & H_CBD) >> 24) *
+				sizeof(u32)) -
+				sizeof(struct mei_msg_hdr);
+			mei_hdr.msg_complete = 0;
+		} else {
+			mei_hdr.length = length;
+			mei_hdr.msg_complete = 1;
+		}
+		mei_hdr.host_addr = file_ext->host_client_id;
+		mei_hdr.me_addr = file_ext->me_client_id;
+		mei_hdr.reserved = 0;
+		dev_dbg(&dev->pdev->dev, "call mei_write_message header=%08x.\n",
+		    *((u32 *) &mei_hdr));
+		if (!mei_write_message(dev, &mei_hdr,
+			(unsigned char *) (priv_write_cb->request_buffer.data),
+			mei_hdr.length)) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		}
+		file_ext->writing_state = MEI_WRITING;
+		priv_write_cb->information = mei_hdr.length;
+		if (mei_hdr.msg_complete) {
+			mei_flow_ctrl_reduce(dev, file_ext);
+			list_add_tail(&priv_write_cb->cb_list,
+				      &dev->write_waiting_list.mei_cb.cb_list);
+		} else {
+			list_add_tail(&priv_write_cb->cb_list,
+				      &dev->write_list.mei_cb.cb_list);
+		}
+
+	} else {
+
+		priv_write_cb->information = 0;
+		file_ext->writing_state = MEI_WRITING;
+		list_add_tail(&priv_write_cb->cb_list,
+			      &dev->write_list.mei_cb.cb_list);
+	}
+	mutex_unlock(&dev->device_lock);
+	return length;
+
+unlock_dev:
+	mutex_unlock(&dev->device_lock);
+	mei_free_cb_private(priv_write_cb);
+	return rets;
+}
+
+
+/**
+ * mei_ioctl - the IOCTL function
+ *
+ * @file: pointer to file structure
+ * @cmd: ioctl command
+ * @data: pointer to mei message structure
+ *
+ * returns 0 on success , <0 on error
+ */
+static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
+{
+	struct mei_device *dev;
+	struct mei_cl *file_ext = file->private_data;
+	struct mei_connect_client_data *connect_data = NULL;
+	int rets;
+
+	if (cmd != IOCTL_MEI_CONNECT_CLIENT)
+		return -EINVAL;
+
+	if (WARN_ON(!file_ext || !file_ext->dev))
+		return -ENODEV;
+
+	dev = file_ext->dev;
+
+	dev_dbg(&dev->pdev->dev, "IOCTL cmd = 0x%x", cmd);
+
+	mutex_lock(&dev->device_lock);
+	if (dev->mei_state != MEI_ENABLED) {
+		rets = -ENODEV;
+		goto out;
+	}
+
+	dev_dbg(&dev->pdev->dev, ": IOCTL_MEI_CONNECT_CLIENT.\n");
+
+	connect_data = kzalloc(sizeof(struct mei_connect_client_data),
+							GFP_KERNEL);
+	if (!connect_data) {
+		rets = -ENOMEM;
+		goto out;
+	}
+	dev_dbg(&dev->pdev->dev, "copy connect data from user\n");
+	if (copy_from_user(connect_data, (char __user *)data,
+				sizeof(struct mei_connect_client_data))) {
+		dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
+		rets = -EFAULT;
+		goto out;
+	}
+	rets = mei_ioctl_connect_client(file, connect_data);
+
+	/* if all is ok, copying the data back to user. */
+	if (rets)
+		goto out;
+
+	dev_dbg(&dev->pdev->dev, "copy connect data to user\n");
+	if (copy_to_user((char __user *)data, connect_data,
+				sizeof(struct mei_connect_client_data))) {
+		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
+		rets = -EFAULT;
+		goto out;
+	}
+
+out:
+	kfree(connect_data);
+	mutex_unlock(&dev->device_lock);
+	return rets;
+}
+
+/**
+ * mei_compat_ioctl - the compat IOCTL function
+ *
+ * @file: pointer to file structure
+ * @cmd: ioctl command
+ * @data: pointer to mei message structure
+ *
+ * returns 0 on success , <0 on error
+ */
+#ifdef CONFIG_COMPAT
+static long mei_compat_ioctl(struct file *file,
+		      unsigned int cmd, unsigned long data)
+{
+	return mei_ioctl(file, cmd, (unsigned long)compat_ptr(data));
+}
+#endif
+
+
+/**
+ * mei_poll - the poll function
+ *
+ * @file: pointer to file structure
+ * @wait: pointer to poll_table structure
+ *
+ * returns poll mask
+ */
+static unsigned int mei_poll(struct file *file, poll_table *wait)
+{
+	struct mei_cl *file_ext = file->private_data;
+	struct mei_device *dev;
+	unsigned int mask = 0;
+
+	if (WARN_ON(!file_ext || !file_ext->dev))
+		return mask;
+
+	dev = file_ext->dev;
+
+	mutex_lock(&dev->device_lock);
+
+	if (dev->mei_state != MEI_ENABLED)
+		goto out;
+
+
+	if (file_ext == &dev->iamthif_file_ext) {
+		mutex_unlock(&dev->device_lock);
+		poll_wait(file, &dev->iamthif_file_ext.wait, wait);
+		mutex_lock(&dev->device_lock);
+		if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE &&
+			dev->iamthif_file_object == file) {
+			mask |= (POLLIN | POLLRDNORM);
+			dev_dbg(&dev->pdev->dev, "run next amthi cb\n");
+			run_next_iamthif_cmd(dev);
+		}
+		goto out;
+	}
+
+	mutex_unlock(&dev->device_lock);
+	poll_wait(file, &file_ext->tx_wait, wait);
+	mutex_lock(&dev->device_lock);
+	if (MEI_WRITE_COMPLETE == file_ext->writing_state)
+		mask |= (POLLIN | POLLRDNORM);
+
+out:
+	mutex_unlock(&dev->device_lock);
+	return mask;
+}
+
+#ifdef CONFIG_PM
+static int mei_pci_suspend(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct mei_device *dev = pci_get_drvdata(pdev);
+	int err;
+
+	if (!dev)
+		return -ENODEV;
+	mutex_lock(&dev->device_lock);
+	/* Stop watchdog if exists */
+	err = mei_wd_stop(dev, true);
+	/* Set new mei state */
+	if (dev->mei_state == MEI_ENABLED ||
+	    dev->mei_state == MEI_RECOVERING_FROM_RESET) {
+		dev->mei_state = MEI_POWER_DOWN;
+		mei_reset(dev, 0);
+	}
+	mutex_unlock(&dev->device_lock);
+
+	free_irq(pdev->irq, dev);
+
+
+	return err;
+}
+
+static int mei_pci_resume(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct mei_device *dev;
+	int err;
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return -ENODEV;
+
+	/* request and enable interrupt   */
+	err = request_threaded_irq(pdev->irq,
+			mei_interrupt_quick_handler,
+			mei_interrupt_thread_handler,
+			IRQF_SHARED, mei_driver_name, dev);
+	if (err) {
+		printk(KERN_ERR "mei: Request_irq failure. irq = %d\n",
+		       pdev->irq);
+		return err;
+	}
+
+	mutex_lock(&dev->device_lock);
+	dev->mei_state = MEI_POWER_UP;
+	mei_reset(dev, 1);
+	mutex_unlock(&dev->device_lock);
+
+	/* Start watchdog if stopped in suspend */
+	if (dev->wd_timeout) {
+		mei_wd_start_setup(dev);
+		dev->wd_due_counter = 1;
+		schedule_delayed_work(&dev->wd_work, HZ);
+	}
+	return err;
+}
+static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
+#define MEI_PM_OPS	(&mei_pm_ops)
+#else
+#define MIE_PM_OPS	NULL
+#endif /* CONFIG_PM */
+/*
+ *  PCI driver structure
+ */
+static struct pci_driver mei_driver = {
+	.name = mei_driver_name,
+	.id_table = mei_pci_tbl,
+	.probe = mei_probe,
+	.remove = __devexit_p(mei_remove),
+	.shutdown = __devexit_p(mei_remove),
+	.driver.pm = MEI_PM_OPS,
+};
+
+/*
+ * file operations structure will be used for mei char device.
+ */
+static const struct file_operations mei_fops = {
+	.owner = THIS_MODULE,
+	.read = mei_read,
+	.unlocked_ioctl = mei_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = mei_compat_ioctl,
+#endif
+	.open = mei_open,
+	.release = mei_release,
+	.write = mei_write,
+	.poll = mei_poll,
+};
+
+/**
+ * mei_registration_cdev - sets up the cdev structure for mei device.
+ *
+ * @dev: char device struct
+ * @hminor: minor number for registration char device
+ * @fops: file operations structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_registration_cdev(struct cdev *dev, int hminor,
+				  const struct file_operations *fops)
+{
+	int ret, devno = MKDEV(mei_major, hminor);
+
+	cdev_init(dev, fops);
+	dev->owner = THIS_MODULE;
+	ret = cdev_add(dev, devno, 1);
+	/* Fail gracefully if need be */
+	if (ret)
+		printk(KERN_ERR "mei: Error %d registering mei device %d\n",
+		       ret, hminor);
+	return ret;
+}
+
+/**
+ * mei_register_cdev - registers mei char device
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_register_cdev(void)
+{
+	int ret;
+	dev_t dev;
+
+	/* registration of char devices */
+	ret = alloc_chrdev_region(&dev, MEI_MINORS_BASE, MEI_MINORS_COUNT,
+				  MEI_DRIVER_NAME);
+	if (ret) {
+		printk(KERN_ERR "mei: Error allocating char device region.\n");
+		return ret;
+	}
+
+	mei_major = MAJOR(dev);
+
+	ret = mei_registration_cdev(&mei_cdev, MEI_MINOR_NUMBER,
+				     &mei_fops);
+	if (ret)
+		unregister_chrdev_region(MKDEV(mei_major, MEI_MINORS_BASE),
+					 MEI_MINORS_COUNT);
+
+	return ret;
+}
+
+/**
+ * mei_unregister_cdev - unregisters mei char device
+ */
+static void mei_unregister_cdev(void)
+{
+	cdev_del(&mei_cdev);
+	unregister_chrdev_region(MKDEV(mei_major, MEI_MINORS_BASE),
+				 MEI_MINORS_COUNT);
+}
+
+/**
+ * mei_sysfs_device_create - adds device entry to sysfs
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_sysfs_device_create(void)
+{
+	struct class *class;
+	void *tmphdev;
+	int err;
+
+	class = class_create(THIS_MODULE, MEI_DRIVER_NAME);
+	if (IS_ERR(class)) {
+		err = PTR_ERR(class);
+		printk(KERN_ERR "mei: Error creating mei class.\n");
+		goto err_out;
+	}
+
+	tmphdev = device_create(class, NULL, mei_cdev.dev, NULL,
+					MEI_DEV_NAME);
+	if (IS_ERR(tmphdev)) {
+		err = PTR_ERR(tmphdev);
+		goto err_destroy;
+	}
+
+	mei_class = class;
+	return 0;
+
+err_destroy:
+	class_destroy(class);
+err_out:
+	return err;
+}
+
+/**
+ * mei_sysfs_device_remove - unregisters the device entry on sysfs
+ */
+static void mei_sysfs_device_remove(void)
+{
+	if (IS_ERR_OR_NULL(mei_class))
+		return;
+
+	device_destroy(mei_class, mei_cdev.dev);
+	class_destroy(mei_class);
+}
+
+/**
+ * mei_init_module - Driver Registration Routine
+ *
+ * mei_init_module is the first routine called when the driver is
+ * loaded. All it does is to register with the PCI subsystem.
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int __init mei_init_module(void)
+{
+	int ret;
+
+	pr_debug("mei: %s - version %s\n",
+		mei_driver_string, mei_driver_version);
+	/* init pci module */
+	ret = pci_register_driver(&mei_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "mei: Error registering driver.\n");
+		goto end;
+	}
+
+	ret = mei_register_cdev();
+	if (ret)
+		goto unregister_pci;
+
+	ret = mei_sysfs_device_create();
+	if (ret)
+		goto unregister_cdev;
+
+	return ret;
+
+unregister_cdev:
+	mei_unregister_cdev();
+unregister_pci:
+	pci_unregister_driver(&mei_driver);
+end:
+	return ret;
+}
+
+module_init(mei_init_module);
+
+/**
+ * mei_exit_module - Driver Exit Cleanup Routine
+ *
+ * mei_exit_module is called just before the driver is removed
+ * from memory.
+ */
+static void __exit mei_exit_module(void)
+{
+	pci_unregister_driver(&mei_driver);
+	mei_sysfs_device_remove();
+	mei_unregister_cdev();
+
+	pr_debug("mei: Driver unloaded successfully.\n");
+}
+
+module_exit(mei_exit_module);
+
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(MEI_DRIVER_VERSION);
diff --git a/drivers/staging/mei/mei.h b/drivers/staging/mei/mei.h
new file mode 100644
index 0000000..d570b80
--- /dev/null
+++ b/drivers/staging/mei/mei.h
@@ -0,0 +1,148 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
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
+ */
+
+
+#ifndef _MEI_H_
+#define _MEI_H_
+
+#include <linux/mei.h>
+#include <linux/interrupt.h>
+#include "hw.h"
+
+
+#define CONNECT_TIMEOUT        15	/* HPS definition */
+#define INIT_CLIENTS_TIMEOUT   15	/* HPS definition */
+
+extern const uuid_le mei_amthi_guid;
+extern const uuid_le mei_wd_guid;
+extern const u8 mei_wd_state_independence_msg[3][4];
+
+/*
+ * mei device ID
+ */
+#define    MEI_DEV_ID_82946GZ	0x2974  /* 82946GZ/GL */
+#define    MEI_DEV_ID_82G35	0x2984  /* 82G35 Express */
+#define    MEI_DEV_ID_82Q965	0x2994  /* 82Q963/Q965 */
+#define    MEI_DEV_ID_82G965	0x29A4  /* 82P965/G965 */
+
+#define    MEI_DEV_ID_82GM965	0x2A04  /* Mobile PM965/GM965 */
+#define    MEI_DEV_ID_82GME965	0x2A14  /* Mobile GME965/GLE960 */
+
+#define    MEI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
+#define    MEI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
+#define    MEI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
+#define    MEI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
+#define    MEI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
+
+#define    MEI_DEV_ID_ICH9_6	0x28B4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_7	0x28C4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_8	0x28D4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_9    0x28E4  /* Bearlake */
+#define    MEI_DEV_ID_ICH9_10	0x28F4  /* Bearlake */
+
+#define    MEI_DEV_ID_ICH9M_1	0x2A44  /* Cantiga */
+#define    MEI_DEV_ID_ICH9M_2	0x2A54  /* Cantiga */
+#define    MEI_DEV_ID_ICH9M_3	0x2A64  /* Cantiga */
+#define    MEI_DEV_ID_ICH9M_4	0x2A74  /* Cantiga */
+
+#define    MEI_DEV_ID_ICH10_1	0x2E04  /* Eaglelake */
+#define    MEI_DEV_ID_ICH10_2	0x2E14  /* Eaglelake */
+#define    MEI_DEV_ID_ICH10_3	0x2E24  /* Eaglelake */
+#define    MEI_DEV_ID_ICH10_4	0x2E34  /* Eaglelake */
+
+#define    MEI_DEV_ID_IBXPK_1	0x3B64  /* Calpella */
+#define    MEI_DEV_ID_IBXPK_2	0x3B65  /* Calpella */
+
+#define    MEI_DEV_ID_CPT_1	0x1C3A    /* Cougerpoint */
+#define    MEI_DEV_ID_PBG_1	0x1D3A    /* PBG */
+
+#define    MEI_DEV_ID_PPT_1	0x1E3A    /* Pantherpoint PPT */
+#define    MEI_DEV_ID_PPT_2	0x1CBA    /* Pantherpoint PPT */
+#define    MEI_DEV_ID_PPT_3	0x1DBA    /* Pantherpoint PPT */
+
+
+/*
+ * mei init function prototypes
+ */
+struct mei_device *init_mei_device(struct pci_dev *pdev);
+void mei_reset(struct mei_device *dev, int interrupts);
+int mei_hw_init(struct mei_device *dev);
+int mei_task_initialize_clients(void *data);
+int mei_initialize_clients(struct mei_device *dev);
+struct mei_cl *mei_alloc_file_private(struct mei_device *dev);
+int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *file_ext);
+void mei_initialize_list(struct mei_io_list *list,
+			  struct mei_device *dev);
+void mei_flush_list(struct mei_io_list *list, struct mei_cl *file_ext);
+void mei_flush_queues(struct mei_device *dev, struct mei_cl *file_ext);
+
+void mei_remove_client_from_file_list(struct mei_device *dev,
+				       u8 host_client_id);
+void host_start_message(struct mei_device *dev);
+void host_enum_clients_message(struct mei_device *dev);
+void allocate_me_clients_storage(struct mei_device *dev);
+void host_client_properties(struct mei_device *dev);
+void host_init_iamthif(struct mei_device *dev);
+void mei_init_file_private(struct mei_cl *priv, struct mei_device *dev);
+
+u8 mei_find_me_client_update_filext(struct mei_device *dev,
+				struct mei_cl *priv,
+				const uuid_le *cguid, u8 client_id);
+/*
+ *  interrupt functions prototype
+ */
+irqreturn_t mei_interrupt_quick_handler(int irq, void *dev_id);
+irqreturn_t  mei_interrupt_thread_handler(int irq, void *dev_id);
+void mei_wd_timer(struct work_struct *work);
+
+/*
+ *  input output function prototype
+ */
+int mei_ioctl_connect_client(struct file *file,
+			struct mei_connect_client_data *data);
+
+int mei_start_read(struct mei_device *dev, struct mei_cl *file_ext);
+
+int amthi_write(struct mei_device *dev, struct mei_cl_cb *priv_cb);
+
+int amthi_read(struct mei_device *dev, struct file *file,
+	      char __user *ubuf, size_t length, loff_t *offset);
+
+struct mei_cl_cb *find_amthi_read_list_entry(struct mei_device *dev,
+						struct file *file);
+
+void run_next_iamthif_cmd(struct mei_device *dev);
+
+void mei_free_cb_private(struct mei_cl_cb *priv_cb);
+
+int mei_find_me_client_index(const struct mei_device *dev, uuid_le cuuid);
+
+
+/**
+ * mei_fe_same_id - tells if file private data have same id
+ *
+ * @fe1: private data of 1. file object
+ * @fe2: private data of 2. file object
+ *
+ * returns !=0 - if ids are the same, 0 - if differ.
+ */
+static inline int mei_fe_same_id(const struct mei_cl *fe1,
+				  const struct mei_cl *fe2)
+{
+	return ((fe1->host_client_id == fe2->host_client_id) &&
+		(fe1->me_client_id == fe2->me_client_id));
+}
+#endif /* _MEI_H_ */
diff --git a/drivers/staging/mei/mei_version.h b/drivers/staging/mei/mei_version.h
new file mode 100644
index 0000000..075bad8
--- /dev/null
+++ b/drivers/staging/mei/mei_version.h
@@ -0,0 +1,31 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
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
+ */
+
+
+#ifndef MEI_VERSION_H
+#define MEI_VERSION_H
+
+#define MAJOR_VERSION		7
+#define MINOR_VERSION		1
+#define QUICK_FIX_NUMBER	20
+#define VER_BUILD		1
+
+#define MEI_DRV_VER1 __stringify(MAJOR_VERSION) "." __stringify(MINOR_VERSION)
+#define MEI_DRV_VER2 __stringify(QUICK_FIX_NUMBER) "." __stringify(VER_BUILD)
+
+#define MEI_DRIVER_VERSION	MEI_DRV_VER1 "." MEI_DRV_VER2
+
+#endif
-- 
1.7.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

