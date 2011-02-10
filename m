Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab1BJJz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:55:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:42719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756006Ab1BJJzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:24 -0500
Message-Id: <b7da2f$qd3ngg@fmsmga001.fm.intel.com>
Date: 10 Feb 2011 01:55:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="886169114"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 09/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/iorw.c b/drivers/char/mei/iorw.c
new file mode 100644
index 0000000..289b6e4
--- /dev/null
+++ b/drivers/char/mei/iorw.c
@@ -0,0 +1,822 @@
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
+
+#include "hw.h"
+#include "mei.h"
+#include "interface.h"
+#include "mei_version.h"
+
+
+
+/**
+ * mei_ioctl_get_version - the get driver version IOCTL function
+ *
+ * @dev: the device structure
+ * @if_num:  minor number
+ * @*u_msg: pointer to user data struct in user space
+ * @k_msg: data in kernel on the stack
+ * @file_ext: private data of the file object
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_ioctl_get_version(struct iamt_mei_device *dev, int if_num,
+			   struct mei_message_data __user *u_msg,
+			   struct mei_message_data k_msg,
+			   struct mei_file_private *file_ext)
+{
+	struct mei_driver_version *version;
+	struct mei_message_data res_msg;
+	int rets;
+
+	if ((if_num != MEI_MINOR_NUMBER) || (!dev)
+	    || (!file_ext))
+		return -ENODEV;
+
+	if (k_msg.size < (sizeof(struct mei_driver_version) -2)) {
+		DBG("user buffer less than mei_driver_version.\n");
+		return -EMSGSIZE;
+	}
+
+	res_msg.data = kmalloc(sizeof(struct mei_driver_version), GFP_KERNEL);
+	if (!res_msg.data) {
+		DBG("failed allocation response buffer size = %d.\n",
+		    (int) sizeof(struct mei_driver_version));
+		return -ENOMEM;
+	}
+
+	version = (struct mei_driver_version *) res_msg.data;
+	version->major = MAJOR_VERSION;
+	version->minor = MINOR_VERSION;
+	version->hotfix = QUICK_FIX_NUMBER;
+	version->build = VER_BUILD;
+	res_msg.size = sizeof(struct mei_driver_version);
+	if (k_msg.size < sizeof(struct mei_driver_version))
+		res_msg.size -= 2;
+
+	rets = file_ext->status;
+	/* now copy the data to user space */
+	if (copy_to_user((void __user *)k_msg.data,
+			 res_msg.data,
+			 res_msg.size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+	if (put_user(res_msg.size, &u_msg->size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+end:
+	kfree(res_msg.data);
+	return rets;
+}
+
+/**
+ * mei_ioctl_connect_client - the connect to fw client IOCTL function
+ *
+ * @dev: the device structure
+ * @if_num:  minor number
+ * @*u_msg: pointer to user data struct in user space
+ * @k_msg: data in kernel on the stack
+ * @file_ext: private data of the file object
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_ioctl_connect_client(struct iamt_mei_device *dev, int if_num,
+			      struct mei_message_data __user *u_msg,
+			      struct mei_message_data k_msg,
+			      struct file *file)
+{
+	struct mei_message_data req_msg, res_msg;
+	struct mei_cb_private *priv_cb = NULL;
+	struct mei_client *client;
+	struct mei_file_private *file_ext;
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+	long timeout = 15;	/* 15 second */
+	u8 i;
+	int err = 0;
+	int rets;
+
+	if ((if_num != MEI_MINOR_NUMBER) || (!dev) || (!file))
+		return -ENODEV;
+
+	file_ext = file->private_data;
+	if (!file_ext)
+		return -ENODEV;
+
+	if (k_msg.size != sizeof(struct guid)) {
+		DBG("user buffer size is not equal to size of struct "
+				"guid(16).\n");
+		return -EMSGSIZE;
+	}
+
+	if (!k_msg.data)
+		return -EIO;
+
+	req_msg.data = kmalloc(sizeof(struct guid), GFP_KERNEL);
+	res_msg.data = kmalloc(sizeof(struct mei_client), GFP_KERNEL);
+
+	if (!res_msg.data) {
+		DBG("failed allocation response buffer size = %d.\n",
+		    (int) sizeof(struct mei_client));
+		kfree(req_msg.data);
+		return -ENOMEM;
+	}
+	if (!req_msg.data) {
+		DBG("failed allocation request buffer size = %d.\n",
+		    (int) sizeof(struct guid));
+		kfree(res_msg.data);
+		return -ENOMEM;
+	}
+	req_msg.size = sizeof(struct guid);
+	res_msg.size = sizeof(struct mei_client);
+
+	/* copy the message to kernel space -
+	 * use a pointer already copied into kernel space
+	 */
+	if (copy_from_user(req_msg.data,
+			   (void __user *)k_msg.data,
+			   k_msg.size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+	/* buffered ioctl cb */
+	priv_cb = kzalloc(sizeof(struct mei_cb_private), GFP_KERNEL);
+	if (!priv_cb) {
+		rets = -ENOMEM;
+		goto end;
+	}
+	INIT_LIST_HEAD(&priv_cb->cb_list);
+	priv_cb->response_buffer.data = res_msg.data;
+	priv_cb->response_buffer.size = res_msg.size;
+	priv_cb->request_buffer.data = req_msg.data;
+	priv_cb->request_buffer.size = req_msg.size;
+	priv_cb->major_file_operations = MEI_IOCTL;
+	if (dev->mei_state != MEI_ENABLED) {
+		rets = -ENODEV;
+		goto end;
+	}
+	if ((file_ext->state != MEI_FILE_INITIALIZING) &&
+	    (file_ext->state != MEI_FILE_DISCONNECTED)) {
+		rets = -EBUSY;
+		goto end;
+	}
+
+	/* find ME client we're trying to connect to */
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (memcmp((struct guid *)req_msg.data,
+			    &dev->me_clients[i].props.protocol_name,
+			    sizeof(struct guid)) == 0) {
+			if (dev->me_clients[i].props.fixed_address == 0) {
+				file_ext->me_client_id =
+				    dev->me_clients[i].client_id;
+				file_ext->state = MEI_FILE_CONNECTING;
+			}
+			break;
+		}
+	}
+	/* if we're connecting to PTHI client so we will use the exist
+	 * connection
+	 */
+	if (memcmp((struct guid *)req_msg.data, &mei_pthi_guid,
+				sizeof(struct guid)) == 0) {
+		if (dev->iamthif_file_ext.state != MEI_FILE_CONNECTED) {
+			rets = -ENODEV;
+			goto end;
+		}
+		dev->mei_host_clients[file_ext->host_client_id / 8] &=
+			~(1 << (file_ext->host_client_id % 8));
+		list_for_each_entry_safe(file_pos,
+		    file_next, &dev->file_list, link) {
+			if (mei_fe_same_id(file_ext, file_pos)) {
+				DBG("remove file private data node host"
+				    " client = %d, ME client = %d.\n",
+				    file_pos->host_client_id,
+				    file_pos->me_client_id);
+				list_del(&file_pos->link);
+			}
+
+		}
+		DBG("free file private data memory.\n");
+		kfree(file_ext);
+		file_ext = NULL;
+		file->private_data = &dev->iamthif_file_ext;
+		client = (struct mei_client *) res_msg.data;
+		client->max_msg_length =
+			dev->me_clients[i].props.max_msg_length;
+		client->protocol_version =
+			dev->me_clients[i].props.protocol_version;
+		rets = dev->iamthif_file_ext.status;
+
+		/* now copy the data to user space */
+		if (copy_to_user((void __user *)k_msg.data,
+					res_msg.data, res_msg.size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		if (put_user(res_msg.size, &u_msg->size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		goto end;
+	}
+	if (file_ext->state != MEI_FILE_CONNECTING) {
+		rets = -ENODEV;
+		goto end;
+	}
+	/* prepare the output buffer */
+	client = (struct mei_client *) res_msg.data;
+	client->max_msg_length = dev->me_clients[i].props.max_msg_length;
+	client->protocol_version = dev->me_clients[i].props.protocol_version;
+	if (dev->host_buffer_is_empty
+	    && !other_client_is_connecting(dev, file_ext)) {
+		dev->host_buffer_is_empty = 0;
+		if (!mei_connect(dev, file_ext)) {
+			rets = -ENODEV;
+			goto end;
+		} else {
+			file_ext->timer_count = MEI_CONNECT_TIMEOUT;
+			priv_cb->file_private = file_ext;
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->ctrl_rd_list.mei_cb.
+				      cb_list);
+		}
+
+
+	} else {
+		priv_cb->file_private = file_ext;
+		DBG("add connect cb to control write list.\n");
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->ctrl_wr_list.mei_cb.cb_list);
+	}
+	mutex_unlock(&dev->device_lock);
+	err = wait_event_timeout(dev->wait_recvd_msg,
+			(MEI_FILE_CONNECTED == file_ext->state
+			 || MEI_FILE_DISCONNECTED == file_ext->state),
+			timeout * HZ);
+
+	mutex_lock(&dev->device_lock);
+	if (MEI_FILE_CONNECTED == file_ext->state) {
+		DBG("successfully connected to FW client.\n");
+		rets = file_ext->status;
+		/* now copy the data to user space */
+		if (copy_to_user((void __user *)k_msg.data,
+					res_msg.data, res_msg.size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		if (put_user(res_msg.size, &u_msg->size)) {
+			rets = -EFAULT;
+			goto end;
+		}
+		goto end;
+	} else {
+		DBG("failed to connect to FW client.file_ext->state = %d.\n",
+		    file_ext->state);
+		if (!err) {
+			DBG("wait_event_interruptible_timeout failed on client"
+			    " connect message fw response message.\n");
+		}
+		rets = -EFAULT;
+
+		if (priv_cb) {
+			mei_flush_list(&dev->ctrl_rd_list, file_ext);
+			mei_flush_list(&dev->ctrl_wr_list, file_ext);
+		}
+		goto end;
+	}
+	rets = 0;
+end:
+	DBG("free connect cb memory.");
+	kfree(req_msg.data);
+	kfree(res_msg.data);
+	kfree(priv_cb);
+	return rets;
+}
+
+/**
+ * mei_ioctl_wd - the wd IOCTL function
+ *
+ * @dev: the device structure
+ * @if_num:  minor number
+ * @k_msg: data in kernel on the stack
+ * @file_ext: private data of the file object
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_ioctl_wd(struct iamt_mei_device *dev, int if_num,
+		  struct mei_message_data k_msg,
+		  struct mei_file_private *file_ext)
+{
+	struct mei_message_data req_msg;	/* in kernel on the stack */
+	int rets;
+
+	if (if_num != MEI_MINOR_NUMBER)
+		return -ENODEV;
+
+	if (k_msg.size != MEI_WATCHDOG_DATA_SIZE) {
+		DBG("user buffer has invalid size.\n");
+		return -EMSGSIZE;
+	}
+	req_msg.data = kmalloc(MEI_WATCHDOG_DATA_SIZE, GFP_KERNEL);
+	if (!req_msg.data) {
+		DBG("failed allocation request buffer size = %d.\n",
+		    MEI_WATCHDOG_DATA_SIZE);
+		rets = -ENOMEM;
+		goto end;
+	}
+	req_msg.size = MEI_WATCHDOG_DATA_SIZE;
+
+	/* copy the message to kernel space - use a pointer already
+	 * copied into kernel space
+	 */
+	if (copy_from_user(req_msg.data,
+			   (void __user *)k_msg.data, req_msg.size)) {
+		rets = -EFAULT;
+		goto end;
+	}
+
+	if (dev->mei_state != MEI_ENABLED) {
+		rets = -ENODEV;
+		goto end;
+	}
+
+	if (dev->wd_file_ext.state != MEI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		goto end;
+	}
+
+	if (!dev->asf_mode) {
+		rets = -EIO;
+		goto end;
+	}
+
+	memcpy(&dev->wd_data[MEI_WD_PARAMS_SIZE], req_msg.data,
+	       MEI_WATCHDOG_DATA_SIZE);
+
+	dev->wd_timeout = (req_msg.data[1] << 8) + req_msg.data[0];
+	dev->wd_pending = 0;
+	dev->wd_due_counter = 1;	/* next timer */
+	if (dev->wd_timeout == 0) {
+		memcpy(dev->wd_data, mei_stop_wd_params,
+		       MEI_WD_PARAMS_SIZE);
+	} else {
+		memcpy(dev->wd_data, mei_start_wd_params,
+		       MEI_WD_PARAMS_SIZE);
+		schedule_delayed_work(&dev->wd_work, HZ);
+	}
+	rets = 0;
+end:
+	kfree(req_msg.data);
+	return rets;
+}
+
+
+/**
+ * mei_ioctl_bypass_wd - the bypass_wd IOCTL function
+ *
+ * @dev: the device structure
+ * @if_num:  minor number
+ * @k_msg: data in kernel on the stack
+ * @file_ext: private data of the file object
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_ioctl_bypass_wd(struct iamt_mei_device *dev, int if_num,
+		  struct mei_message_data k_msg,
+		  struct mei_file_private *file_ext)
+{
+	u8 flag = 0;
+
+	if (if_num != MEI_MINOR_NUMBER)
+		return -ENODEV;
+
+	if (k_msg.size < 1) {
+		DBG("user buffer less than 1.\n");
+		return -EMSGSIZE;
+	}
+
+	if (copy_from_user(&flag, (void __user *)k_msg.data, 1))
+		return -EFAULT;
+
+
+	flag = flag ? (1) : (0);
+	dev->wd_bypass = flag;
+	return 0;
+}
+
+/**
+ * find_pthi_read_list_entry - finds a PTHIlist entry for current file
+ *
+ * @dev: the device structure
+ * @file: pointer to file object
+ *
+ * returns   returned a list entry on success, NULL on failure.
+ */
+struct mei_cb_private *find_pthi_read_list_entry(
+		struct iamt_mei_device *dev,
+		struct file *file)
+{
+	struct mei_file_private *file_ext_temp;
+	struct mei_cb_private *priv_cb_pos = NULL;
+	struct mei_cb_private *priv_cb_next = NULL;
+
+	if ((dev->pthi_read_complete_list.status == 0) &&
+	    !list_empty(&dev->pthi_read_complete_list.mei_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+		    &dev->pthi_read_complete_list.mei_cb.cb_list, cb_list) {
+			file_ext_temp = (struct mei_file_private *)
+					priv_cb_pos->file_private;
+			if ((file_ext_temp != NULL) &&
+			    (file_ext_temp == &dev->iamthif_file_ext) &&
+			    (priv_cb_pos->file_object == file))
+				return priv_cb_pos;
+		}
+	}
+	return NULL;
+}
+
+/**
+ * pthi_read - read data from pthi client
+ *
+ * @dev: the device structure
+ * @if_num:  minor number
+ * @file: pointer to file object
+ * @*ubuf: pointer to user data in user space
+ * @length: data length to read
+ * @offset: data read offset
+ *
+ * returns
+ *  returned data length on success,
+ *  zero if no data to read,
+ *  negative on failure.
+ */
+int pthi_read(struct iamt_mei_device *dev, int if_num, struct file *file,
+	      char __user *ubuf, size_t length, loff_t *offset)
+{
+	int rets = 0;
+	int waitRet = 0;
+	struct mei_cb_private *priv_cb = NULL;
+	struct mei_file_private *file_ext = file->private_data;
+	u8 i;
+	unsigned long currtime = 0;
+
+	if ((if_num != MEI_MINOR_NUMBER) || (!dev))
+		return -ENODEV;
+
+	if ((file_ext == NULL) || (file_ext != &dev->iamthif_file_ext))
+		return -ENODEV;
+
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    dev->iamthif_file_ext.me_client_id)
+			break;
+	}
+
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if ((i == dev->num_mei_me_clients)
+	    || (dev->me_clients[i].client_id !=
+		dev->iamthif_file_ext.me_client_id)) {
+		DBG("PTHI client not found.\n");
+		return -ENODEV;
+	}
+
+	DBG("checking pthi data\n");
+	priv_cb = find_pthi_read_list_entry(dev, file);
+
+	/* Check for if we can block or not*/
+	if (priv_cb == NULL && file->f_flags & O_NONBLOCK)
+		return -EAGAIN;
+
+
+	DBG("waiting for pthi data\n");
+	while (priv_cb == NULL) {
+		/* unlock the Mutex */
+		mutex_unlock(&dev->device_lock);
+
+		waitRet = wait_event_interruptible(dev->iamthif_file_ext.wait,
+			(priv_cb = find_pthi_read_list_entry(dev, file)));
+
+		if (waitRet)
+			return -ERESTARTSYS;
+
+		DBG("woke up from sleep\n");
+
+		/* Locking again the Mutex */
+		mutex_lock(&dev->device_lock);
+	}
+
+	currtime = get_seconds();
+	DBG("Got PTHI data\n");
+	DBG("PTHI command time = %lud\n", currtime - priv_cb->read_time);
+
+	if (priv_cb &&
+	    (currtime - priv_cb->read_time > IAMTHIF_READ_TIMER)) {
+
+		DBG("PTHI Time out\n");
+		/* 15 sec for the message has expired */
+		list_del(&priv_cb->cb_list);
+		rets = -ETIMEDOUT;
+		goto free;
+	}
+	/* if the whole message will fit remove it from the list */
+	if ((priv_cb->information >= *offset)  &&
+	    (length >= (priv_cb->information - *offset)))
+		list_del(&priv_cb->cb_list);
+	else if ((priv_cb->information > 0) &&
+	    (priv_cb->information <= *offset)) {
+		/* end of the message has been reached */
+		list_del(&priv_cb->cb_list);
+		rets = 0;
+		goto free;
+	}
+		/* else means that not full buffer will be read and do not
+		 * remove message from deletion list
+		 */
+
+	DBG("pthi priv_cb->response_buffer size - %d\n",
+	    priv_cb->response_buffer.size);
+	DBG("pthi priv_cb->information - %lu\n",
+	    priv_cb->information);
+
+	/* length is being turncated to PAGE_SIZE, however,
+	 * the information may be longer */
+	length = length < (priv_cb->information - *offset) ?
+			length : (priv_cb->information - *offset);
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
+	DBG("free pthi cb memory.\n");
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
+int mei_start_read(struct iamt_mei_device *dev, int if_num,
+		    struct mei_file_private *file_ext)
+{
+	struct mei_cb_private *priv_cb;
+	int rets = 0;
+	u8 i;
+
+	if ((if_num != MEI_MINOR_NUMBER) || (!dev) || (!file_ext)) {
+		DBG("received wrong function input param.\n");
+		return -ENODEV;
+	}
+
+	if (file_ext->state != MEI_FILE_CONNECTED)
+		return -ENODEV;
+
+	if (dev->mei_state != MEI_ENABLED)
+		return -ENODEV;
+
+	DBG("check if read is pending.\n");
+	if ((file_ext->read_pending) || (file_ext->read_cb != NULL)) {
+		DBG("read is pending.\n");
+		return -EBUSY;
+	}
+
+	priv_cb = kzalloc(sizeof(struct mei_cb_private), GFP_KERNEL);
+	if (!priv_cb)
+		return -ENOMEM;
+
+	DBG("allocation call back successh host client = %d, ME client = %d\n",
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
+	DBG("allocation call back data success.\n");
+	priv_cb->major_file_operations = MEI_READ;
+	/* make sure information is zero before we start */
+	priv_cb->information = 0;
+	priv_cb->file_private = (void *) file_ext;
+	file_ext->read_cb = priv_cb;
+	if (dev->host_buffer_is_empty) {
+		dev->host_buffer_is_empty = 0;
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
+ * pthi_write - write iamthif data to pthi client
+ *
+ * @dev: the device structure
+ * @priv_cb: mei call back struct
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int pthi_write(struct iamt_mei_device *dev,
+	       struct mei_cb_private *priv_cb)
+{
+	struct mei_msg_hdr mei_hdr;
+
+	if ((!dev) || (!priv_cb))
+		return -ENODEV;
+
+	DBG("write data to pthi client.\n");
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
+	if (flow_ctrl_creds(dev, &dev->iamthif_file_ext) &&
+	    dev->host_buffer_is_empty) {
+		dev->host_buffer_is_empty = 0;
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
+			flow_ctrl_reduce(dev, &dev->iamthif_file_ext);
+			dev->iamthif_flow_control_pending = 1;
+			dev->iamthif_state = MEI_IAMTHIF_FLOW_CONTROL;
+			DBG("add pthi cb to write waiting list\n");
+			dev->iamthif_current_cb = priv_cb;
+			dev->iamthif_file_object = priv_cb->file_object;
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->write_waiting_list.mei_cb.cb_list);
+		} else {
+			DBG("message does not complete, "
+					"so add pthi cb to write list.\n");
+			list_add_tail(&priv_cb->cb_list,
+				      &dev->write_list.mei_cb.cb_list);
+		}
+	} else {
+		if (!(dev->host_buffer_is_empty))
+			DBG("host buffer is not empty");
+
+		DBG("No flow control credentials, "
+				"so add iamthif cb to write list.\n");
+		list_add_tail(&priv_cb->cb_list,
+			      &dev->write_list.mei_cb.cb_list);
+	}
+	return 0;
+}
+
+/**
+ * iamthif_ioctl_send_msg - send cmd data to pthi client
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+void run_next_iamthif_cmd(struct iamt_mei_device *dev)
+{
+	struct mei_file_private *file_ext_tmp;
+	struct mei_cb_private *priv_cb_pos = NULL;
+	struct mei_cb_private *priv_cb_next = NULL;
+	int status = 0;
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
+	if (dev->pthi_cmd_list.status == 0 &&
+	    !list_empty(&dev->pthi_cmd_list.mei_cb.cb_list)) {
+		DBG("complete pthi cmd_list cb.\n");
+
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+		    &dev->pthi_cmd_list.mei_cb.cb_list, cb_list) {
+			list_del(&priv_cb_pos->cb_list);
+			file_ext_tmp = (struct mei_file_private *)
+					priv_cb_pos->file_private;
+
+			if ((file_ext_tmp != NULL) &&
+			    (file_ext_tmp == &dev->iamthif_file_ext)) {
+				status = pthi_write(dev, priv_cb_pos);
+				if (status != 0) {
+					DBG("pthi write failed status = %d\n",
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
+void mei_free_cb_private(struct mei_cb_private *priv_cb)
+{
+	if (priv_cb == NULL)
+		return;
+
+	kfree(priv_cb->request_buffer.data);
+	kfree(priv_cb->response_buffer.data);
+	kfree(priv_cb);
+}


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

