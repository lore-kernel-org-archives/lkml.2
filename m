Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936092Ab2KATSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 15:18:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:38876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935150Ab2KATRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 15:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,695,1344236400"; 
   d="scan'208";a="241495285"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, alan@linux.intel.com, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/6] mei: extract AMTHI functions into the amthif.c file
Date: Thu,  1 Nov 2012 21:17:15 +0200
Message-Id: <1351797438-26345-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
References: <1351797438-26345-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move AMT Host Interface functions into the new amthif.c file.
All functions has now common prefix: mei_amthif_

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/Makefile    |    1 +
 drivers/misc/mei/amthif.c    |  572 ++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/mei/init.c      |   73 +------
 drivers/misc/mei/interrupt.c |  218 +---------------
 drivers/misc/mei/iorw.c      |  266 --------------------
 drivers/misc/mei/main.c      |   10 +-
 drivers/misc/mei/mei_dev.h   |   29 ++-
 7 files changed, 613 insertions(+), 556 deletions(-)
 create mode 100644 drivers/misc/mei/amthif.c

diff --git a/drivers/misc/mei/Makefile b/drivers/misc/mei/Makefile
index 57168db..0017842 100644
--- a/drivers/misc/mei/Makefile
+++ b/drivers/misc/mei/Makefile
@@ -8,4 +8,5 @@ mei-objs += interrupt.o
 mei-objs += interface.o
 mei-objs += iorw.o
 mei-objs += main.o
+mei-objs += amthif.o
 mei-objs += wd.o
diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
new file mode 100644
index 0000000..392203d
--- /dev/null
+++ b/drivers/misc/mei/amthif.c
@@ -0,0 +1,572 @@
+/*
+ *
+ * Intel Management Engine Interface (Intel MEI) Linux driver
+ * Copyright (c) 2003-2012, Intel Corporation.
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
+#include <linux/uaccess.h>
+
+
+#include "mei_dev.h"
+#include "hw.h"
+#include <linux/mei.h>
+#include "interface.h"
+
+const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
+						0xa8, 0x46, 0xe0, 0xff, 0x65,
+						0x81, 0x4c);
+
+/**
+ * mei_amthif_reset_params - initializes mei device iamthif
+ *
+ * @dev: the device structure
+ */
+void mei_amthif_reset_params(struct mei_device *dev)
+{
+	/* reset iamthif parameters. */
+	dev->iamthif_current_cb = NULL;
+	dev->iamthif_msg_buf_size = 0;
+	dev->iamthif_msg_buf_index = 0;
+	dev->iamthif_canceled = false;
+	dev->iamthif_ioctl = false;
+	dev->iamthif_state = MEI_IAMTHIF_IDLE;
+	dev->iamthif_timer = 0;
+}
+
+/**
+ * mei_amthif_host_init_ - mei initialization amthif client.
+ *
+ * @dev: the device structure
+ *
+ */
+void mei_amthif_host_init(struct mei_device *dev)
+{
+	int i;
+	unsigned char *msg_buf;
+
+	mei_cl_init(&dev->iamthif_cl, dev);
+	dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
+
+	/* find ME amthi client */
+	i = mei_me_cl_update_filext(dev, &dev->iamthif_cl,
+			    &mei_amthi_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
+	if (i < 0) {
+		dev_dbg(&dev->pdev->dev, "failed to find iamthif client.\n");
+		return;
+	}
+
+	/* Assign iamthif_mtu to the value received from ME  */
+
+	dev->iamthif_mtu = dev->me_clients[i].props.max_msg_length;
+	dev_dbg(&dev->pdev->dev, "IAMTHIF_MTU = %d\n",
+			dev->me_clients[i].props.max_msg_length);
+
+	kfree(dev->iamthif_msg_buf);
+	dev->iamthif_msg_buf = NULL;
+
+	/* allocate storage for ME message buffer */
+	msg_buf = kcalloc(dev->iamthif_mtu,
+			sizeof(unsigned char), GFP_KERNEL);
+	if (!msg_buf) {
+		dev_dbg(&dev->pdev->dev, "memory allocation for ME message buffer failed.\n");
+		return;
+	}
+
+	dev->iamthif_msg_buf = msg_buf;
+
+	if (mei_connect(dev, &dev->iamthif_cl)) {
+		dev_dbg(&dev->pdev->dev, "Failed to connect to AMTHI client\n");
+		dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
+		dev->iamthif_cl.host_client_id = 0;
+	} else {
+		dev->iamthif_cl.timer_count = MEI_CONNECT_TIMEOUT;
+	}
+}
+
+/**
+ * mei_amthif_find_read_list_entry - finds a amthilist entry for current file
+ *
+ * @dev: the device structure
+ * @file: pointer to file object
+ *
+ * returns   returned a list entry on success, NULL on failure.
+ */
+struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
+						struct file *file)
+{
+	struct mei_cl *cl_temp;
+	struct mei_cl_cb *pos = NULL;
+	struct mei_cl_cb *next = NULL;
+
+	list_for_each_entry_safe(pos, next,
+	    &dev->amthi_read_complete_list.list, list) {
+		cl_temp = (struct mei_cl *)pos->file_private;
+		if (cl_temp && cl_temp == &dev->iamthif_cl &&
+			pos->file_object == file)
+			return pos;
+	}
+	return NULL;
+}
+
+
+/**
+ * mei_amthif_read - read data from AMTHIF client
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
+int mei_amthif_read(struct mei_device *dev, struct file *file,
+	       char __user *ubuf, size_t length, loff_t *offset)
+{
+	int rets;
+	int wait_ret;
+	struct mei_cl_cb *cb = NULL;
+	struct mei_cl *cl = file->private_data;
+	unsigned long timeout;
+	int i;
+
+	/* Only Posible if we are in timeout */
+	if (!cl || cl != &dev->iamthif_cl) {
+		dev_dbg(&dev->pdev->dev, "bad file ext.\n");
+		return -ETIMEDOUT;
+	}
+
+	i = mei_me_cl_by_id(dev, dev->iamthif_cl.me_client_id);
+
+	if (i < 0) {
+		dev_dbg(&dev->pdev->dev, "amthi client not found.\n");
+		return -ENODEV;
+	}
+	dev_dbg(&dev->pdev->dev, "checking amthi data\n");
+	cb = mei_amthif_find_read_list_entry(dev, file);
+
+	/* Check for if we can block or not*/
+	if (cb == NULL && file->f_flags & O_NONBLOCK)
+		return -EAGAIN;
+
+
+	dev_dbg(&dev->pdev->dev, "waiting for amthi data\n");
+	while (cb == NULL) {
+		/* unlock the Mutex */
+		mutex_unlock(&dev->device_lock);
+
+		wait_ret = wait_event_interruptible(dev->iamthif_cl.wait,
+			(cb = mei_amthif_find_read_list_entry(dev, file)));
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
+	if (cb) {
+		timeout = cb->read_time +
+			mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
+		dev_dbg(&dev->pdev->dev, "amthi timeout = %lud\n",
+				timeout);
+
+		if  (time_after(jiffies, timeout)) {
+			dev_dbg(&dev->pdev->dev, "amthi Time out\n");
+			/* 15 sec for the message has expired */
+			list_del(&cb->list);
+			rets = -ETIMEDOUT;
+			goto free;
+		}
+	}
+	/* if the whole message will fit remove it from the list */
+	if (cb->buf_idx >= *offset && length >= (cb->buf_idx - *offset))
+		list_del(&cb->list);
+	else if (cb->buf_idx > 0 && cb->buf_idx <= *offset) {
+		/* end of the message has been reached */
+		list_del(&cb->list);
+		rets = 0;
+		goto free;
+	}
+		/* else means that not full buffer will be read and do not
+		 * remove message from deletion list
+		 */
+
+	dev_dbg(&dev->pdev->dev, "amthi cb->response_buffer size - %d\n",
+	    cb->response_buffer.size);
+	dev_dbg(&dev->pdev->dev, "amthi cb->buf_idx - %lu\n", cb->buf_idx);
+
+	/* length is being turncated to PAGE_SIZE, however,
+	 * the buf_idx may point beyond */
+	length = min_t(size_t, length, (cb->buf_idx - *offset));
+
+	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length))
+		rets = -EFAULT;
+	else {
+		rets = length;
+		if ((*offset + length) < cb->buf_idx) {
+			*offset += length;
+			goto out;
+		}
+	}
+free:
+	dev_dbg(&dev->pdev->dev, "free amthi cb memory.\n");
+	*offset = 0;
+	mei_io_cb_free(cb);
+out:
+	return rets;
+}
+
+/**
+ * mei_amthif_write - write amthif data to amthif client
+ *
+ * @dev: the device structure
+ * @cb: mei call back struct
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *cb)
+{
+	struct mei_msg_hdr mei_hdr;
+	int ret;
+
+	if (!dev || !cb)
+		return -ENODEV;
+
+	dev_dbg(&dev->pdev->dev, "write data to amthi client.\n");
+
+	dev->iamthif_state = MEI_IAMTHIF_WRITING;
+	dev->iamthif_current_cb = cb;
+	dev->iamthif_file_object = cb->file_object;
+	dev->iamthif_canceled = false;
+	dev->iamthif_ioctl = true;
+	dev->iamthif_msg_buf_size = cb->request_buffer.size;
+	memcpy(dev->iamthif_msg_buf, cb->request_buffer.data,
+	       cb->request_buffer.size);
+
+	ret = mei_flow_ctrl_creds(dev, &dev->iamthif_cl);
+	if (ret < 0)
+		return ret;
+
+	if (ret && dev->mei_host_buffer_is_empty) {
+		ret = 0;
+		dev->mei_host_buffer_is_empty = false;
+		if (cb->request_buffer.size > mei_hbuf_max_data(dev)) {
+			mei_hdr.length = mei_hbuf_max_data(dev);
+			mei_hdr.msg_complete = 0;
+		} else {
+			mei_hdr.length = cb->request_buffer.size;
+			mei_hdr.msg_complete = 1;
+		}
+
+		mei_hdr.host_addr = dev->iamthif_cl.host_client_id;
+		mei_hdr.me_addr = dev->iamthif_cl.me_client_id;
+		mei_hdr.reserved = 0;
+		dev->iamthif_msg_buf_index += mei_hdr.length;
+		if (mei_write_message(dev, &mei_hdr,
+					(unsigned char *)(dev->iamthif_msg_buf),
+					mei_hdr.length))
+			return -ENODEV;
+
+		if (mei_hdr.msg_complete) {
+			if (mei_flow_ctrl_reduce(dev, &dev->iamthif_cl))
+				return -ENODEV;
+			dev->iamthif_flow_control_pending = true;
+			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
+			dev_dbg(&dev->pdev->dev, "add amthi cb to write waiting list\n");
+			dev->iamthif_current_cb = cb;
+			dev->iamthif_file_object = cb->file_object;
+			list_add_tail(&cb->list, &dev->write_waiting_list.list);
+		} else {
+			dev_dbg(&dev->pdev->dev, "message does not complete, so add amthi cb to write list.\n");
+			list_add_tail(&cb->list, &dev->write_list.list);
+		}
+	} else {
+		if (!(dev->mei_host_buffer_is_empty))
+			dev_dbg(&dev->pdev->dev, "host buffer is not empty");
+
+		dev_dbg(&dev->pdev->dev, "No flow control credentials, so add iamthif cb to write list.\n");
+		list_add_tail(&cb->list, &dev->write_list.list);
+	}
+	return 0;
+}
+
+/**
+ * mei_amthif_run_next_cmd
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+void mei_amthif_run_next_cmd(struct mei_device *dev)
+{
+	struct mei_cl *cl_tmp;
+	struct mei_cl_cb *pos = NULL;
+	struct mei_cl_cb *next = NULL;
+	int status;
+
+	if (!dev)
+		return;
+
+	dev->iamthif_msg_buf_size = 0;
+	dev->iamthif_msg_buf_index = 0;
+	dev->iamthif_canceled = false;
+	dev->iamthif_ioctl = true;
+	dev->iamthif_state = MEI_IAMTHIF_IDLE;
+	dev->iamthif_timer = 0;
+	dev->iamthif_file_object = NULL;
+
+	dev_dbg(&dev->pdev->dev, "complete amthi cmd_list cb.\n");
+
+	list_for_each_entry_safe(pos, next, &dev->amthi_cmd_list.list, list) {
+		list_del(&pos->list);
+		cl_tmp = (struct mei_cl *)pos->file_private;
+
+		if (cl_tmp && cl_tmp == &dev->iamthif_cl) {
+			status = mei_amthif_write(dev, pos);
+			if (status) {
+				dev_dbg(&dev->pdev->dev,
+					"amthi write failed status = %d\n",
+						status);
+				return;
+			}
+			break;
+		}
+	}
+}
+
+/**
+ * mei_amthif_irq_process_completed - processes completed iamthif operation.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ * @cb_pos: callback block.
+ * @cl: private data of the file object.
+ * @cmpl_list: complete list.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+int mei_amthif_irq_process_completed(struct mei_device *dev, s32 *slots,
+			struct mei_cl_cb *cb_pos,
+			struct mei_cl *cl,
+			struct mei_cl_cb *cmpl_list)
+{
+	struct mei_msg_hdr *mei_hdr;
+
+	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
+			dev->iamthif_msg_buf_size -
+			dev->iamthif_msg_buf_index)) {
+		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+		mei_hdr->host_addr = cl->host_client_id;
+		mei_hdr->me_addr = cl->me_client_id;
+		mei_hdr->length = dev->iamthif_msg_buf_size -
+			dev->iamthif_msg_buf_index;
+		mei_hdr->msg_complete = 1;
+		mei_hdr->reserved = 0;
+
+		*slots -= mei_data2slots(mei_hdr->length);
+
+		if (mei_write_message(dev, mei_hdr,
+					(dev->iamthif_msg_buf +
+					dev->iamthif_msg_buf_index),
+					mei_hdr->length)) {
+			dev->iamthif_state = MEI_IAMTHIF_IDLE;
+			cl->status = -ENODEV;
+			list_del(&cb_pos->list);
+			return -ENODEV;
+		} else {
+			if (mei_flow_ctrl_reduce(dev, cl))
+				return -ENODEV;
+			dev->iamthif_msg_buf_index += mei_hdr->length;
+			cb_pos->buf_idx = dev->iamthif_msg_buf_index;
+			cl->status = 0;
+			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
+			dev->iamthif_flow_control_pending = true;
+			/* save iamthif cb sent to amthi client */
+			dev->iamthif_current_cb = cb_pos;
+			list_move_tail(&cb_pos->list,
+					&dev->write_waiting_list.list);
+
+		}
+	} else if (*slots == dev->hbuf_depth) {
+		/* buffer is still empty */
+		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+		mei_hdr->host_addr = cl->host_client_id;
+		mei_hdr->me_addr = cl->me_client_id;
+		mei_hdr->length =
+			(*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
+		mei_hdr->msg_complete = 0;
+		mei_hdr->reserved = 0;
+
+		*slots -= mei_data2slots(mei_hdr->length);
+
+		if (mei_write_message(dev, mei_hdr,
+					(dev->iamthif_msg_buf +
+					dev->iamthif_msg_buf_index),
+					mei_hdr->length)) {
+			cl->status = -ENODEV;
+			list_del(&cb_pos->list);
+		} else {
+			dev->iamthif_msg_buf_index += mei_hdr->length;
+		}
+		return -EMSGSIZE;
+	} else {
+		return -EBADMSG;
+	}
+
+	return 0;
+}
+
+/**
+ * mei_amthif_irq_read_message - read routine after ISR to
+ *			handle the read amthi message
+ *
+ * @complete_list: An instance of our list structure
+ * @dev: the device structure
+ * @mei_hdr: header of amthi message
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
+		struct mei_device *dev, struct mei_msg_hdr *mei_hdr)
+{
+	struct mei_cl *cl;
+	struct mei_cl_cb *cb;
+	unsigned char *buffer;
+
+	BUG_ON(mei_hdr->me_addr != dev->iamthif_cl.me_client_id);
+	BUG_ON(dev->iamthif_state != MEI_IAMTHIF_READING);
+
+	buffer = dev->iamthif_msg_buf + dev->iamthif_msg_buf_index;
+	BUG_ON(dev->iamthif_mtu < dev->iamthif_msg_buf_index + mei_hdr->length);
+
+	mei_read_slots(dev, buffer, mei_hdr->length);
+
+	dev->iamthif_msg_buf_index += mei_hdr->length;
+
+	if (!mei_hdr->msg_complete)
+		return 0;
+
+	dev_dbg(&dev->pdev->dev,
+			"amthi_message_buffer_index =%d\n",
+			mei_hdr->length);
+
+	dev_dbg(&dev->pdev->dev, "completed amthi read.\n ");
+	if (!dev->iamthif_current_cb)
+		return -ENODEV;
+
+	cb = dev->iamthif_current_cb;
+	dev->iamthif_current_cb = NULL;
+
+	cl = (struct mei_cl *)cb->file_private;
+	if (!cl)
+		return -ENODEV;
+
+	dev->iamthif_stall_timer = 0;
+	cb->buf_idx = dev->iamthif_msg_buf_index;
+	cb->read_time = jiffies;
+	if (dev->iamthif_ioctl && cl == &dev->iamthif_cl) {
+		/* found the iamthif cb */
+		dev_dbg(&dev->pdev->dev, "complete the amthi read cb.\n ");
+		dev_dbg(&dev->pdev->dev, "add the amthi read cb to complete.\n ");
+		list_add_tail(&cb->list, &complete_list->list);
+	}
+	return 0;
+}
+
+/**
+ * mei_amthif_irq_read - prepares to read amthif data.
+ *
+ * @dev: the device structure.
+ * @slots: free slots.
+ *
+ * returns 0, OK; otherwise, error.
+ */
+int mei_amthif_irq_read(struct mei_device *dev, s32 *slots)
+{
+
+	if (((*slots) * sizeof(u32)) < (sizeof(struct mei_msg_hdr)
+			+ sizeof(struct hbm_flow_control))) {
+		return -EMSGSIZE;
+	}
+	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
+	if (mei_send_flow_control(dev, &dev->iamthif_cl)) {
+		dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
+		return -EIO;
+	}
+
+	dev_dbg(&dev->pdev->dev, "iamthif flow control success\n");
+	dev->iamthif_state = MEI_IAMTHIF_READING;
+	dev->iamthif_flow_control_pending = false;
+	dev->iamthif_msg_buf_index = 0;
+	dev->iamthif_msg_buf_size = 0;
+	dev->iamthif_stall_timer = MEI_IAMTHIF_STALL_TIMER;
+	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
+	return 0;
+}
+
+/**
+ * mei_amthif_complete - complete amthif callback.
+ *
+ * @dev: the device structure.
+ * @cb_pos: callback block.
+ */
+void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb)
+{
+	if (dev->iamthif_canceled != 1) {
+		dev->iamthif_state = MEI_IAMTHIF_READ_COMPLETE;
+		dev->iamthif_stall_timer = 0;
+		memcpy(cb->response_buffer.data,
+				dev->iamthif_msg_buf,
+				dev->iamthif_msg_buf_index);
+		list_add_tail(&cb->list, &dev->amthi_read_complete_list.list);
+		dev_dbg(&dev->pdev->dev, "amthi read completed\n");
+		dev->iamthif_timer = jiffies;
+		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
+				dev->iamthif_timer);
+	} else {
+		mei_amthif_run_next_cmd(dev);
+	}
+
+	dev_dbg(&dev->pdev->dev, "completing amthi call back.\n");
+	wake_up_interruptible(&dev->iamthif_cl.wait);
+}
+
+
diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index e6951ec..4a8eb92 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -43,10 +43,6 @@ const char *mei_dev_state_str(int state)
 }
 
 
-const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
-						0xa8, 0x46, 0xe0, 0xff, 0x65,
-						0x81, 0x4c);
-
 /**
  * mei_io_list_flush - removes list entry belonging to cl.
  *
@@ -92,23 +88,6 @@ int mei_cl_flush_queues(struct mei_cl *cl)
 
 
 /**
- * mei_reset_iamthif_params - initializes mei device iamthif
- *
- * @dev: the device structure
- */
-static void mei_reset_iamthif_params(struct mei_device *dev)
-{
-	/* reset iamthif parameters. */
-	dev->iamthif_current_cb = NULL;
-	dev->iamthif_msg_buf_size = 0;
-	dev->iamthif_msg_buf_index = 0;
-	dev->iamthif_canceled = false;
-	dev->iamthif_ioctl = false;
-	dev->iamthif_state = MEI_IAMTHIF_IDLE;
-	dev->iamthif_timer = 0;
-}
-
-/**
  * init_mei_device - allocates and initializes the mei device structure
  *
  * @pdev: The pci device structure
@@ -313,7 +292,7 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		mei_remove_client_from_file_list(dev,
 				dev->iamthif_cl.host_client_id);
 
-		mei_reset_iamthif_params(dev);
+		mei_amthif_reset_params(dev);
 		dev->extra_write_index = 0;
 	}
 
@@ -577,56 +556,6 @@ int mei_me_cl_update_filext(struct mei_device *dev, struct mei_cl *cl,
 }
 
 /**
- * host_init_iamthif - mei initialization iamthif client.
- *
- * @dev: the device structure
- *
- */
-void mei_host_init_iamthif(struct mei_device *dev)
-{
-	int i;
-	unsigned char *msg_buf;
-
-	mei_cl_init(&dev->iamthif_cl, dev);
-	dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
-
-	/* find ME amthi client */
-	i = mei_me_cl_update_filext(dev, &dev->iamthif_cl,
-			    &mei_amthi_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
-	if (i < 0) {
-		dev_dbg(&dev->pdev->dev, "failed to find iamthif client.\n");
-		return;
-	}
-
-	/* Assign iamthif_mtu to the value received from ME  */
-
-	dev->iamthif_mtu = dev->me_clients[i].props.max_msg_length;
-	dev_dbg(&dev->pdev->dev, "IAMTHIF_MTU = %d\n",
-			dev->me_clients[i].props.max_msg_length);
-
-	kfree(dev->iamthif_msg_buf);
-	dev->iamthif_msg_buf = NULL;
-
-	/* allocate storage for ME message buffer */
-	msg_buf = kcalloc(dev->iamthif_mtu,
-			sizeof(unsigned char), GFP_KERNEL);
-	if (!msg_buf) {
-		dev_dbg(&dev->pdev->dev, "memory allocation for ME message buffer failed.\n");
-		return;
-	}
-
-	dev->iamthif_msg_buf = msg_buf;
-
-	if (mei_connect(dev, &dev->iamthif_cl)) {
-		dev_dbg(&dev->pdev->dev, "Failed to connect to AMTHI client\n");
-		dev->iamthif_cl.state = MEI_FILE_DISCONNECTED;
-		dev->iamthif_cl.host_client_id = 0;
-	} else {
-		dev->iamthif_cl.timer_count = MEI_CONNECT_TIMEOUT;
-	}
-}
-
-/**
  * mei_alloc_file_private - allocates a private file structure and sets it up.
  * @file: the file structure
  *
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 248f581..62f8b65 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -74,92 +74,6 @@ static void _mei_cmpl(struct mei_cl *cl, struct mei_cl_cb *cb_pos)
 }
 
 /**
- * _mei_cmpl_iamthif - processes completed iamthif operation.
- *
- * @dev: the device structure.
- * @cb_pos: callback block.
- */
-static void _mei_cmpl_iamthif(struct mei_device *dev, struct mei_cl_cb *cb_pos)
-{
-	if (dev->iamthif_canceled != 1) {
-		dev->iamthif_state = MEI_IAMTHIF_READ_COMPLETE;
-		dev->iamthif_stall_timer = 0;
-		memcpy(cb_pos->response_buffer.data,
-				dev->iamthif_msg_buf,
-				dev->iamthif_msg_buf_index);
-		list_add_tail(&cb_pos->list, &dev->amthi_read_complete_list.list);
-		dev_dbg(&dev->pdev->dev, "amthi read completed\n");
-		dev->iamthif_timer = jiffies;
-		dev_dbg(&dev->pdev->dev, "dev->iamthif_timer = %ld\n",
-				dev->iamthif_timer);
-	} else {
-		mei_run_next_iamthif_cmd(dev);
-	}
-
-	dev_dbg(&dev->pdev->dev, "completing amthi call back.\n");
-	wake_up_interruptible(&dev->iamthif_cl.wait);
-}
-
-
-/**
- * mei_irq_thread_read_amthi_message - bottom half read routine after ISR to
- * handle the read amthi message data processing.
- *
- * @complete_list: An instance of our list structure
- * @dev: the device structure
- * @mei_hdr: header of amthi message
- *
- * returns 0 on success, <0 on failure.
- */
-static int mei_irq_thread_read_amthi_message(struct mei_cl_cb *complete_list,
-		struct mei_device *dev,
-		struct mei_msg_hdr *mei_hdr)
-{
-	struct mei_cl *cl;
-	struct mei_cl_cb *cb;
-	unsigned char *buffer;
-
-	BUG_ON(mei_hdr->me_addr != dev->iamthif_cl.me_client_id);
-	BUG_ON(dev->iamthif_state != MEI_IAMTHIF_READING);
-
-	buffer = dev->iamthif_msg_buf + dev->iamthif_msg_buf_index;
-	BUG_ON(dev->iamthif_mtu < dev->iamthif_msg_buf_index + mei_hdr->length);
-
-	mei_read_slots(dev, buffer, mei_hdr->length);
-
-	dev->iamthif_msg_buf_index += mei_hdr->length;
-
-	if (!mei_hdr->msg_complete)
-		return 0;
-
-	dev_dbg(&dev->pdev->dev,
-			"amthi_message_buffer_index =%d\n",
-			mei_hdr->length);
-
-	dev_dbg(&dev->pdev->dev, "completed amthi read.\n ");
-	if (!dev->iamthif_current_cb)
-		return -ENODEV;
-
-	cb = dev->iamthif_current_cb;
-	dev->iamthif_current_cb = NULL;
-
-	cl = (struct mei_cl *)cb->file_private;
-	if (!cl)
-		return -ENODEV;
-
-	dev->iamthif_stall_timer = 0;
-	cb->buf_idx = dev->iamthif_msg_buf_index;
-	cb->read_time = jiffies;
-	if (dev->iamthif_ioctl && cl == &dev->iamthif_cl) {
-		/* found the iamthif cb */
-		dev_dbg(&dev->pdev->dev, "complete the amthi read cb.\n ");
-		dev_dbg(&dev->pdev->dev, "add the amthi read cb to complete.\n ");
-		list_add_tail(&cb->list, &complete_list->list);
-	}
-	return 0;
-}
-
-/**
  * _mei_irq_thread_state_ok - checks if mei header matches file private data
  *
  * @cl: private data of the file object
@@ -244,37 +158,6 @@ quit:
 }
 
 /**
- * _mei_irq_thread_iamthif_read - prepares to read iamthif data.
- *
- * @dev: the device structure.
- * @slots: free slots.
- *
- * returns 0, OK; otherwise, error.
- */
-static int _mei_irq_thread_iamthif_read(struct mei_device *dev, s32 *slots)
-{
-
-	if (((*slots) * sizeof(u32)) < (sizeof(struct mei_msg_hdr)
-			+ sizeof(struct hbm_flow_control))) {
-		return -EMSGSIZE;
-	}
-	*slots -= mei_data2slots(sizeof(struct hbm_flow_control));
-	if (mei_send_flow_control(dev, &dev->iamthif_cl)) {
-		dev_dbg(&dev->pdev->dev, "iamthif flow control failed\n");
-		return -EIO;
-	}
-
-	dev_dbg(&dev->pdev->dev, "iamthif flow control success\n");
-	dev->iamthif_state = MEI_IAMTHIF_READING;
-	dev->iamthif_flow_control_pending = false;
-	dev->iamthif_msg_buf_index = 0;
-	dev->iamthif_msg_buf_size = 0;
-	dev->iamthif_stall_timer = MEI_IAMTHIF_STALL_TIMER;
-	dev->mei_host_buffer_is_empty = mei_hbuf_is_empty(dev);
-	return 0;
-}
-
-/**
  * _mei_irq_thread_close - processes close related operation.
  *
  * @dev: the device structure.
@@ -370,7 +253,7 @@ static void mei_client_connect_response(struct mei_device *dev,
 		mei_watchdog_register(dev);
 
 		/* next step in the state maching */
-		mei_host_init_iamthif(dev);
+		mei_amthif_host_init(dev);
 		return;
 	}
 
@@ -728,7 +611,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 					 * will be received
 					 */
 					if (mei_wd_host_init(dev))
-						mei_host_init_iamthif(dev);
+						mei_amthif_host_init(dev);
 				}
 
 			} else {
@@ -964,87 +847,6 @@ static int _mei_irq_thread_cmpl(struct mei_device *dev,	s32 *slots,
 }
 
 /**
- * _mei_irq_thread_cmpl_iamthif - processes completed iamthif operation.
- *
- * @dev: the device structure.
- * @slots: free slots.
- * @cb_pos: callback block.
- * @cl: private data of the file object.
- * @cmpl_list: complete list.
- *
- * returns 0, OK; otherwise, error.
- */
-static int _mei_irq_thread_cmpl_iamthif(struct mei_device *dev, s32 *slots,
-			struct mei_cl_cb *cb_pos,
-			struct mei_cl *cl,
-			struct mei_cl_cb *cmpl_list)
-{
-	struct mei_msg_hdr *mei_hdr;
-
-	if ((*slots * sizeof(u32)) >= (sizeof(struct mei_msg_hdr) +
-			dev->iamthif_msg_buf_size -
-			dev->iamthif_msg_buf_index)) {
-		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-		mei_hdr->host_addr = cl->host_client_id;
-		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length = dev->iamthif_msg_buf_size -
-			dev->iamthif_msg_buf_index;
-		mei_hdr->msg_complete = 1;
-		mei_hdr->reserved = 0;
-
-		*slots -= mei_data2slots(mei_hdr->length);
-
-		if (mei_write_message(dev, mei_hdr,
-					(dev->iamthif_msg_buf +
-					dev->iamthif_msg_buf_index),
-					mei_hdr->length)) {
-			dev->iamthif_state = MEI_IAMTHIF_IDLE;
-			cl->status = -ENODEV;
-			list_del(&cb_pos->list);
-			return -ENODEV;
-		} else {
-			if (mei_flow_ctrl_reduce(dev, cl))
-				return -ENODEV;
-			dev->iamthif_msg_buf_index += mei_hdr->length;
-			cb_pos->buf_idx = dev->iamthif_msg_buf_index;
-			cl->status = 0;
-			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
-			dev->iamthif_flow_control_pending = true;
-			/* save iamthif cb sent to amthi client */
-			dev->iamthif_current_cb = cb_pos;
-			list_move_tail(&cb_pos->list, &dev->write_waiting_list.list);
-
-		}
-	} else if (*slots == dev->hbuf_depth) {
-		/* buffer is still empty */
-		mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
-		mei_hdr->host_addr = cl->host_client_id;
-		mei_hdr->me_addr = cl->me_client_id;
-		mei_hdr->length =
-			(*slots * sizeof(u32)) - sizeof(struct mei_msg_hdr);
-		mei_hdr->msg_complete = 0;
-		mei_hdr->reserved = 0;
-
-		*slots -= mei_data2slots(mei_hdr->length);
-
-		if (mei_write_message(dev, mei_hdr,
-					(dev->iamthif_msg_buf +
-					dev->iamthif_msg_buf_index),
-					mei_hdr->length)) {
-			cl->status = -ENODEV;
-			list_del(&cb_pos->list);
-		} else {
-			dev->iamthif_msg_buf_index += mei_hdr->length;
-		}
-		return -EMSGSIZE;
-	} else {
-		return -EBADMSG;
-	}
-
-	return 0;
-}
-
-/**
  * mei_irq_thread_read_handler - bottom half read routine after ISR to
  * handle the read processing.
  *
@@ -1117,8 +919,8 @@ static int mei_irq_thread_read_handler(struct mei_cl_cb *cmpl_list,
 		dev_dbg(&dev->pdev->dev, "call mei_irq_thread_read_iamthif_message.\n");
 		dev_dbg(&dev->pdev->dev, "mei_hdr->length =%d\n",
 				mei_hdr->length);
-		ret = mei_irq_thread_read_amthi_message(cmpl_list,
-							dev, mei_hdr);
+
+		ret = mei_amthif_irq_read_message(cmpl_list, dev, mei_hdr);
 		if (ret)
 			goto end;
 
@@ -1195,7 +997,7 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 		if (cl == &dev->iamthif_cl) {
 			dev_dbg(&dev->pdev->dev, "check iamthif flow control.\n");
 			if (dev->iamthif_flow_control_pending) {
-				ret = _mei_irq_thread_iamthif_read(dev, slots);
+				ret = mei_amthif_irq_read(dev, slots);
 				if (ret)
 					return ret;
 			}
@@ -1300,8 +1102,8 @@ static int mei_irq_thread_write_handler(struct mei_cl_cb *cmpl_list,
 					cl->host_client_id);
 				continue;
 			}
-			ret = _mei_irq_thread_cmpl_iamthif(dev, slots, pos,
-						cl, cmpl_list);
+			ret = mei_amthif_irq_process_completed(dev, slots, pos,
+								cl, cmpl_list);
 			if (ret)
 				return ret;
 
@@ -1372,7 +1174,7 @@ void mei_timer(struct work_struct *work)
 			dev->iamthif_current_cb = NULL;
 
 			dev->iamthif_file_object = NULL;
-			mei_run_next_iamthif_cmd(dev);
+			mei_amthif_run_next_cmd(dev);
 		}
 	}
 
@@ -1409,7 +1211,7 @@ void mei_timer(struct work_struct *work)
 			dev->iamthif_file_object->private_data = NULL;
 			dev->iamthif_file_object = NULL;
 			dev->iamthif_timer = 0;
-			mei_run_next_iamthif_cmd(dev);
+			mei_amthif_run_next_cmd(dev);
 
 		}
 	}
@@ -1524,7 +1326,7 @@ end:
 				_mei_cmpl(cl, cb_pos);
 				cb_pos = NULL;
 			} else if (cl == &dev->iamthif_cl) {
-				_mei_cmpl_iamthif(dev, cb_pos);
+				mei_amthif_complete(dev, cb_pos);
 			}
 		}
 	}
diff --git a/drivers/misc/mei/iorw.c b/drivers/misc/mei/iorw.c
index 8026cbf..a1d9ba1 100644
--- a/drivers/misc/mei/iorw.c
+++ b/drivers/misc/mei/iorw.c
@@ -320,152 +320,6 @@ end:
 }
 
 /**
- * find_amthi_read_list_entry - finds a amthilist entry for current file
- *
- * @dev: the device structure
- * @file: pointer to file object
- *
- * returns   returned a list entry on success, NULL on failure.
- */
-struct mei_cl_cb *find_amthi_read_list_entry(
-		struct mei_device *dev,
-		struct file *file)
-{
-	struct mei_cl *cl_temp;
-	struct mei_cl_cb *pos = NULL;
-	struct mei_cl_cb *next = NULL;
-
-	list_for_each_entry_safe(pos, next,
-	    &dev->amthi_read_complete_list.list, list) {
-		cl_temp = (struct mei_cl *)pos->file_private;
-		if (cl_temp && cl_temp == &dev->iamthif_cl &&
-			pos->file_object == file)
-			return pos;
-	}
-	return NULL;
-}
-
-/**
- * amthi_read - read data from AMTHI client
- *
- * @dev: the device structure
- * @if_num:  minor number
- * @file: pointer to file object
- * @*ubuf: pointer to user data in user space
- * @length: data length to read
- * @offset: data read offset
- *
- * Locking: called under "dev->device_lock" lock
- *
- * returns
- *  returned data length on success,
- *  zero if no data to read,
- *  negative on failure.
- */
-int amthi_read(struct mei_device *dev, struct file *file,
-	       char __user *ubuf, size_t length, loff_t *offset)
-{
-	int rets;
-	int wait_ret;
-	struct mei_cl_cb *cb = NULL;
-	struct mei_cl *cl = file->private_data;
-	unsigned long timeout;
-	int i;
-
-	/* Only Posible if we are in timeout */
-	if (!cl || cl != &dev->iamthif_cl) {
-		dev_dbg(&dev->pdev->dev, "bad file ext.\n");
-		return -ETIMEDOUT;
-	}
-
-	i = mei_me_cl_by_id(dev, dev->iamthif_cl.me_client_id);
-
-	if (i < 0) {
-		dev_dbg(&dev->pdev->dev, "amthi client not found.\n");
-		return -ENODEV;
-	}
-	dev_dbg(&dev->pdev->dev, "checking amthi data\n");
-	cb = find_amthi_read_list_entry(dev, file);
-
-	/* Check for if we can block or not*/
-	if (cb == NULL && file->f_flags & O_NONBLOCK)
-		return -EAGAIN;
-
-
-	dev_dbg(&dev->pdev->dev, "waiting for amthi data\n");
-	while (cb == NULL) {
-		/* unlock the Mutex */
-		mutex_unlock(&dev->device_lock);
-
-		wait_ret = wait_event_interruptible(dev->iamthif_cl.wait,
-			(cb = find_amthi_read_list_entry(dev, file)));
-
-		if (wait_ret)
-			return -ERESTARTSYS;
-
-		dev_dbg(&dev->pdev->dev, "woke up from sleep\n");
-
-		/* Locking again the Mutex */
-		mutex_lock(&dev->device_lock);
-	}
-
-
-	dev_dbg(&dev->pdev->dev, "Got amthi data\n");
-	dev->iamthif_timer = 0;
-
-	if (cb) {
-		timeout = cb->read_time +
-			mei_secs_to_jiffies(MEI_IAMTHIF_READ_TIMER);
-		dev_dbg(&dev->pdev->dev, "amthi timeout = %lud\n",
-				timeout);
-
-		if  (time_after(jiffies, timeout)) {
-			dev_dbg(&dev->pdev->dev, "amthi Time out\n");
-			/* 15 sec for the message has expired */
-			list_del(&cb->list);
-			rets = -ETIMEDOUT;
-			goto free;
-		}
-	}
-	/* if the whole message will fit remove it from the list */
-	if (cb->buf_idx >= *offset && length >= (cb->buf_idx - *offset))
-		list_del(&cb->list);
-	else if (cb->buf_idx > 0 && cb->buf_idx <= *offset) {
-		/* end of the message has been reached */
-		list_del(&cb->list);
-		rets = 0;
-		goto free;
-	}
-		/* else means that not full buffer will be read and do not
-		 * remove message from deletion list
-		 */
-
-	dev_dbg(&dev->pdev->dev, "amthi cb->response_buffer size - %d\n",
-	    cb->response_buffer.size);
-	dev_dbg(&dev->pdev->dev, "amthi cb->buf_idx - %lu\n", cb->buf_idx);
-
-	/* length is being turncated to PAGE_SIZE, however,
-	 * the buf_idx may point beyond */
-	length = min_t(size_t, length, (cb->buf_idx - *offset));
-
-	if (copy_to_user(ubuf, cb->response_buffer.data + *offset, length))
-		rets = -EFAULT;
-	else {
-		rets = length;
-		if ((*offset + length) < cb->buf_idx) {
-			*offset += length;
-			goto out;
-		}
-	}
-free:
-	dev_dbg(&dev->pdev->dev, "free amthi cb memory.\n");
-	*offset = 0;
-	mei_io_cb_free(cb);
-out:
-	return rets;
-}
-
-/**
  * mei_start_read - the start read client message function.
  *
  * @dev: the device structure
@@ -524,123 +378,3 @@ err:
 	return rets;
 }
 
-/**
- * amthi_write - write iamthif data to amthi client
- *
- * @dev: the device structure
- * @cb: mei call back struct
- *
- * returns 0 on success, <0 on failure.
- */
-int amthi_write(struct mei_device *dev, struct mei_cl_cb *cb)
-{
-	struct mei_msg_hdr mei_hdr;
-	int ret;
-
-	if (!dev || !cb)
-		return -ENODEV;
-
-	dev_dbg(&dev->pdev->dev, "write data to amthi client.\n");
-
-	dev->iamthif_state = MEI_IAMTHIF_WRITING;
-	dev->iamthif_current_cb = cb;
-	dev->iamthif_file_object = cb->file_object;
-	dev->iamthif_canceled = false;
-	dev->iamthif_ioctl = true;
-	dev->iamthif_msg_buf_size = cb->request_buffer.size;
-	memcpy(dev->iamthif_msg_buf, cb->request_buffer.data,
-	       cb->request_buffer.size);
-
-	ret = mei_flow_ctrl_creds(dev, &dev->iamthif_cl);
-	if (ret < 0)
-		return ret;
-
-	if (ret && dev->mei_host_buffer_is_empty) {
-		ret = 0;
-		dev->mei_host_buffer_is_empty = false;
-		if (cb->request_buffer.size > mei_hbuf_max_data(dev)) {
-			mei_hdr.length = mei_hbuf_max_data(dev);
-			mei_hdr.msg_complete = 0;
-		} else {
-			mei_hdr.length = cb->request_buffer.size;
-			mei_hdr.msg_complete = 1;
-		}
-
-		mei_hdr.host_addr = dev->iamthif_cl.host_client_id;
-		mei_hdr.me_addr = dev->iamthif_cl.me_client_id;
-		mei_hdr.reserved = 0;
-		dev->iamthif_msg_buf_index += mei_hdr.length;
-		if (mei_write_message(dev, &mei_hdr,
-					(unsigned char *)(dev->iamthif_msg_buf),
-					mei_hdr.length))
-			return -ENODEV;
-
-		if (mei_hdr.msg_complete) {
-			if (mei_flow_ctrl_reduce(dev, &dev->iamthif_cl))
-				return -ENODEV;
-			dev->iamthif_flow_control_pending = true;
-			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
-			dev_dbg(&dev->pdev->dev, "add amthi cb to write waiting list\n");
-			dev->iamthif_current_cb = cb;
-			dev->iamthif_file_object = cb->file_object;
-			list_add_tail(&cb->list, &dev->write_waiting_list.list);
-		} else {
-			dev_dbg(&dev->pdev->dev, "message does not complete, "
-					"so add amthi cb to write list.\n");
-			list_add_tail(&cb->list, &dev->write_list.list);
-		}
-	} else {
-		if (!(dev->mei_host_buffer_is_empty))
-			dev_dbg(&dev->pdev->dev, "host buffer is not empty");
-
-		dev_dbg(&dev->pdev->dev, "No flow control credentials, "
-				"so add iamthif cb to write list.\n");
-		list_add_tail(&cb->list, &dev->write_list.list);
-	}
-	return 0;
-}
-
-/**
- * iamthif_ioctl_send_msg - send cmd data to amthi client
- *
- * @dev: the device structure
- *
- * returns 0 on success, <0 on failure.
- */
-void mei_run_next_iamthif_cmd(struct mei_device *dev)
-{
-	struct mei_cl *cl_tmp;
-	struct mei_cl_cb *pos = NULL;
-	struct mei_cl_cb *next = NULL;
-	int status;
-
-	if (!dev)
-		return;
-
-	dev->iamthif_msg_buf_size = 0;
-	dev->iamthif_msg_buf_index = 0;
-	dev->iamthif_canceled = false;
-	dev->iamthif_ioctl = true;
-	dev->iamthif_state = MEI_IAMTHIF_IDLE;
-	dev->iamthif_timer = 0;
-	dev->iamthif_file_object = NULL;
-
-	dev_dbg(&dev->pdev->dev, "complete amthi cmd_list cb.\n");
-
-	list_for_each_entry_safe(pos, next, &dev->amthi_cmd_list.list, list) {
-		list_del(&pos->list);
-		cl_tmp = (struct mei_cl *)pos->file_private;
-
-		if (cl_tmp && cl_tmp == &dev->iamthif_cl) {
-			status = amthi_write(dev, pos);
-			if (status) {
-				dev_dbg(&dev->pdev->dev,
-					"amthi write failed status = %d\n",
-						status);
-				return;
-			}
-			break;
-		}
-	}
-}
-
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 659727a..f69e085 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -349,7 +349,7 @@ static int mei_release(struct inode *inode, struct file *file)
 			dev->iamthif_canceled = true;
 			if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE) {
 				dev_dbg(&dev->pdev->dev, "run next amthi iamthif cb\n");
-				mei_run_next_iamthif_cmd(dev);
+				mei_amthif_run_next_cmd(dev);
 			}
 		}
 
@@ -410,7 +410,7 @@ static ssize_t mei_read(struct file *file, char __user *ubuf,
 	}
 
 	if (cl == &dev->iamthif_cl) {
-		rets = amthi_read(dev, file, ubuf, length, offset);
+		rets = mei_amthif_read(dev, file, ubuf, length, offset);
 		goto out;
 	}
 
@@ -563,7 +563,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		goto err;
 	}
 	if (cl == &dev->iamthif_cl) {
-		write_cb = find_amthi_read_list_entry(dev, file);
+		write_cb = mei_amthif_find_read_list_entry(dev, file);
 
 		if (write_cb) {
 			timeout = write_cb->read_time +
@@ -636,7 +636,7 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 			list_add_tail(&write_cb->list, &dev->amthi_cmd_list.list);
 		} else {
 			dev_dbg(&dev->pdev->dev, "call amthi write\n");
-			rets = amthi_write(dev, write_cb);
+			rets = mei_amthif_write(dev, write_cb);
 
 			if (rets) {
 				dev_err(&dev->pdev->dev, "amthi write failed with status = %d\n",
@@ -823,7 +823,7 @@ static unsigned int mei_poll(struct file *file, poll_table *wait)
 			dev->iamthif_file_object == file) {
 			mask |= (POLLIN | POLLRDNORM);
 			dev_dbg(&dev->pdev->dev, "run next amthi cb\n");
-			mei_run_next_iamthif_cmd(dev);
+			mei_amthif_run_next_cmd(dev);
 		}
 		goto out;
 	}
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 32c951a..57a5a4e 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -286,7 +286,6 @@ int mei_task_initialize_clients(void *data);
 int mei_initialize_clients(struct mei_device *dev);
 int mei_disconnect_host_client(struct mei_device *dev, struct mei_cl *cl);
 void mei_remove_client_from_file_list(struct mei_device *dev, u8 host_client_id);
-void mei_host_init_iamthif(struct mei_device *dev);
 void mei_allocate_me_clients_storage(struct mei_device *dev);
 
 
@@ -362,17 +361,37 @@ int mei_ioctl_connect_client(struct file *file,
 
 int mei_start_read(struct mei_device *dev, struct mei_cl *cl);
 
-int amthi_write(struct mei_device *dev, struct mei_cl_cb *priv_cb);
 
-int amthi_read(struct mei_device *dev, struct file *file,
+/*
+ * AMTHIF - AMT Host Interface Functions
+ */
+void mei_amthif_reset_params(struct mei_device *dev);
+
+void mei_amthif_host_init(struct mei_device *dev);
+
+int mei_amthif_write(struct mei_device *dev, struct mei_cl_cb *priv_cb);
+
+int mei_amthif_read(struct mei_device *dev, struct file *file,
 	      char __user *ubuf, size_t length, loff_t *offset);
 
-struct mei_cl_cb *find_amthi_read_list_entry(struct mei_device *dev,
+struct mei_cl_cb *mei_amthif_find_read_list_entry(struct mei_device *dev,
 						struct file *file);
 
-void mei_run_next_iamthif_cmd(struct mei_device *dev);
+void mei_amthif_run_next_cmd(struct mei_device *dev);
+
+
+int mei_amthif_read_message(struct mei_cl_cb *complete_list,
+		struct mei_device *dev, struct mei_msg_hdr *mei_hdr);
 
+int mei_amthif_irq_process_completed(struct mei_device *dev, s32 *slots,
+			struct mei_cl_cb *cb_pos,
+			struct mei_cl *cl,
+			struct mei_cl_cb *cmpl_list);
 
+void mei_amthif_complete(struct mei_device *dev, struct mei_cl_cb *cb);
+int mei_amthif_irq_read_message(struct mei_cl_cb *complete_list,
+		struct mei_device *dev, struct mei_msg_hdr *mei_hdr);
+int mei_amthif_irq_read(struct mei_device *dev, s32 *slots);
 
 /*
  * Register Access Function
-- 
1.7.4.4

