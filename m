Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1CVK4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 06:56:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:55878 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab1CVKzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 06:55:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,224,1299484800"; 
   d="scan'208";a="722819995"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, david@woodhou.se,
        Oren Weil <oren.jer.weil@intel.com>
Subject: [PATCH 4/7] char/mei: MEI driver init flow.
Date: Tue, 22 Mar 2011 12:51:29 +0200
Message-Id: <1300791092-14319-5-git-send-email-oren.jer.weil@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Init driver list and queue, MEI Hardware reset flow,
init of driver specific host client.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Itzhak Tzeel-Krupp <itzhak.tzeel-krupp@intel.com>
Signed-off-by: Oren Weil <oren.jer.weil@intel.com>
---
 drivers/char/mei/init.c |  834 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 834 insertions(+), 0 deletions(-)
 create mode 100644 drivers/char/mei/init.c

diff --git a/drivers/char/mei/init.c b/drivers/char/mei/init.c
new file mode 100644
index 0000000..4d9bc55
--- /dev/null
+++ b/drivers/char/mei/init.c
@@ -0,0 +1,834 @@
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
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/moduleparam.h>
+
+#include "hw.h"
+#include "interface.h"
+#include "mei.h"
+
+/*
+ * MEI Watchdog Module Parameters
+ */
+static int watchdog_timeout = AMT_WD_VALUE;
+module_param(watchdog_timeout, int, 0);
+MODULE_PARM_DESC(watchdog_timeout,
+		"Intel(R) AMT Watchdog timeout value in seconds. (default="
+					__MODULE_STRING(AMT_WD_VALUE)
+					", disable=0)");
+
+const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
+const u8 mei_stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
+
+const u8 mei_wd_state_independence_msg[3][4] = {
+	{0x05, 0x02, 0x51, 0x10},
+	{0x05, 0x02, 0x52, 0x10},
+	{0x07, 0x02, 0x01, 0x10}
+};
+
+/* UUIDs for AMT F/W clients */
+const uuid_le mei_wd_guid = UUID_LE(0x05B79A6F, 0x4628, 0x4D7F, 0x89,
+						0x9D, 0xA9, 0x15, 0x14, 0xCB,
+						0x32, 0xAB);
+
+const uuid_le mei_amthi_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d, 0xac,
+						0xa8, 0x46, 0xe0, 0xff, 0x65,
+						0x81, 0x4c);
+
+/**
+ * mei_initialize_list - Sets up a queue list.
+ *
+ * @list: An instance of our list structure
+ * @dev: the device structure
+ */
+void mei_initialize_list(struct io_mei_list *list,
+			  struct mei_device *dev)
+{
+	/* initialize our queue list */
+	INIT_LIST_HEAD(&list->mei_cb.cb_list);
+	list->status = 0;
+	list->device_extension = dev;
+}
+
+/**
+ * mei_flush_queues - flushes queue lists belonging to file_ext.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ */
+void mei_flush_queues(struct mei_device *dev,
+		       struct mei_file_private *file_ext)
+{
+	int i;
+
+	if (!dev || !file_ext)
+		return;
+
+	for (i = 0; i < MEI_IO_LISTS_NUMBER; i++) {
+		dev_dbg(&dev->pdev->dev, "remove list entry belonging to file_ext\n");
+		mei_flush_list(dev->io_list_array[i], file_ext);
+	}
+}
+
+
+/**
+ * mei_flush_list - removes list entry belonging to file_ext.
+ *
+ * @list:  An instance of our list structure
+ * @file_ext: private data of the file object
+ */
+void mei_flush_list(struct io_mei_list *list,
+		struct mei_file_private *file_ext)
+{
+	struct mei_file_private *file_ext_tmp;
+	struct mei_cb_private *priv_cb_pos = NULL;
+	struct mei_cb_private *priv_cb_next = NULL;
+
+	if (!list || !file_ext)
+		return;
+
+	if (list->status != 0)
+		return;
+
+	if (list_empty(&list->mei_cb.cb_list))
+		return;
+
+	list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				 &list->mei_cb.cb_list, cb_list) {
+		if (priv_cb_pos) {
+			file_ext_tmp = (struct mei_file_private *)
+				priv_cb_pos->file_private;
+			if (file_ext_tmp &&
+			    mei_fe_same_id(file_ext, file_ext_tmp))
+				list_del(&priv_cb_pos->cb_list);
+		}
+	}
+}
+
+/**
+ * mei_reset_iamthif_params - initializes mei device iamthif
+ *
+ * @dev: the device structure
+ */
+static void mei_reset_iamthif_params(struct mei_device *dev)
+{
+	/* reset iamthif parameters. */
+	dev->iamthif_current_cb = NULL;
+	dev->iamthif_msg_buf_size = 0;
+	dev->iamthif_msg_buf_index = 0;
+	dev->iamthif_canceled = 0;
+	dev->iamthif_file_ext.file = NULL;
+	dev->iamthif_ioctl = 0;
+	dev->iamthif_state = MEI_IAMTHIF_IDLE;
+	dev->iamthif_timer = 0;
+}
+
+/**
+ * init_mei_device - allocates and initializes the mei device structure
+ *
+ * @pdev: The pci device structure
+ *
+ * returns The mei_device_device pointer on success, NULL on failure.
+ */
+struct mei_device *init_mei_device(struct pci_dev *pdev)
+{
+	int i;
+	struct mei_device *dev;
+
+	dev = kzalloc(sizeof(struct mei_device), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	/* setup our list array */
+	dev->io_list_array[0] = &dev->read_list;
+	dev->io_list_array[1] = &dev->write_list;
+	dev->io_list_array[2] = &dev->write_waiting_list;
+	dev->io_list_array[3] = &dev->ctrl_wr_list;
+	dev->io_list_array[4] = &dev->ctrl_rd_list;
+	dev->io_list_array[5] = &dev->amthi_cmd_list;
+	dev->io_list_array[6] = &dev->amthi_read_complete_list;
+	INIT_LIST_HEAD(&dev->file_list);
+	INIT_LIST_HEAD(&dev->wd_file_ext.link);
+	INIT_LIST_HEAD(&dev->iamthif_file_ext.link);
+	mutex_init(&dev->device_lock);
+	init_waitqueue_head(&dev->wait_recvd_msg);
+	init_waitqueue_head(&dev->wait_stop_wd);
+	dev->mei_state = MEI_INITIALIZING;
+	dev->iamthif_state = MEI_IAMTHIF_IDLE;
+	for (i = 0; i < MEI_IO_LISTS_NUMBER; i++)
+		mei_initialize_list(dev->io_list_array[i], dev);
+	dev->pdev = pdev;
+	return dev;
+}
+
+/**
+ * mei_hw_init - initializes host and fw to start work.
+ *
+ * @dev: the device structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_hw_init(struct mei_device *dev)
+{
+	int err = 0;
+
+	dev->host_hw_state = mei_hcsr_read(dev);
+	dev->me_hw_state = mei_mecsr_read(dev);
+	dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, mestate = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+
+	/* acknowledge interrupt and stop interupts */
+	if ((dev->host_hw_state & H_IS) == H_IS)
+		mei_reg_write(dev, H_CSR, dev->host_hw_state);
+
+	dev->recvd_msg = 0;
+	dev_dbg(&dev->pdev->dev, "reset in start the mei device.\n");
+
+	mei_reset(dev, 1);
+
+	dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+
+	/* wait for ME to turn on ME_RDY */
+	if (!dev->recvd_msg)
+		err = wait_event_interruptible_timeout(dev->wait_recvd_msg,
+			dev->recvd_msg, MEI_INTEROP_TIMEOUT);
+
+	if (!err && !dev->recvd_msg) {
+		dev->mei_state = MEI_DISABLED;
+		dev_dbg(&dev->pdev->dev,
+				"wait_event_interruptible_timeout failed"
+				"on wait for ME to turn on ME_RDY.\n");
+		return -ENODEV;
+	} else {
+		if (!(((dev->host_hw_state & H_RDY) == H_RDY) &&
+		      ((dev->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA))) {
+			dev->mei_state = MEI_DISABLED;
+			dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+			    dev->host_hw_state,
+			    dev->me_hw_state);
+
+			if (!(dev->host_hw_state & H_RDY) != H_RDY)
+				dev_dbg(&dev->pdev->dev, "host turn off H_RDY.\n");
+
+			if (!(dev->me_hw_state & ME_RDY_HRA) != ME_RDY_HRA)
+				dev_dbg(&dev->pdev->dev, "ME turn off ME_RDY.\n");
+
+			printk(KERN_ERR
+			       "mei: link layer initialization failed.\n");
+			return -ENODEV;
+		}
+	}
+	if (dev->version.major_version != HBM_MAJOR_VERSION ||
+	    dev->version.minor_version != HBM_MINOR_VERSION) {
+		dev_dbg(&dev->pdev->dev, "MEI start failed.\n");
+		return -ENODEV;
+	}
+	dev->recvd_msg = 0;
+	dev_dbg(&dev->pdev->dev, "host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+	dev_dbg(&dev->pdev->dev, "ME turn on ME_RDY and host turn on H_RDY.\n");
+	dev_dbg(&dev->pdev->dev, "link layer has been established.\n");
+	dev_dbg(&dev->pdev->dev, "MEI  start success.\n");
+	return 0;
+}
+
+/**
+ * mei_hw_reset - resets fw via mei csr register.
+ *
+ * @dev: the device structure
+ * @interrupts_enabled: if interrupt should be enabled after reset.
+ */
+static void mei_hw_reset(struct mei_device *dev, int interrupts_enabled)
+{
+	dev->host_hw_state |= (H_RST | H_IG);
+
+	if (interrupts_enabled)
+		mei_enable_interrupts(dev);
+	else
+		mei_disable_interrupts(dev);
+}
+
+/**
+ * mei_reset - resets host and fw.
+ *
+ * @dev: the device structure
+ * @interrupts_enabled: if interrupt should be enabled after reset.
+ */
+void mei_reset(struct mei_device *dev, int interrupts_enabled)
+{
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+	struct mei_cb_private *priv_cb_pos = NULL;
+	struct mei_cb_private *priv_cb_next = NULL;
+	bool unexpected;
+
+	if (dev->mei_state == MEI_RECOVERING_FROM_RESET) {
+		dev->need_reset = 1;
+		return;
+	}
+
+	unexpected = (dev->mei_state != MEI_INITIALIZING &&
+			dev->mei_state != MEI_DISABLED &&
+			dev->mei_state != MEI_POWER_DOWN &&
+			dev->mei_state != MEI_POWER_UP);
+
+	dev->host_hw_state = mei_hcsr_read(dev);
+
+	dev_dbg(&dev->pdev->dev, "before reset host_hw_state = 0x%08x.\n",
+	    dev->host_hw_state);
+
+	mei_hw_reset(dev, interrupts_enabled);
+
+	dev->host_hw_state &= ~H_RST;
+	dev->host_hw_state |= H_IG;
+
+	mei_hcsr_set(dev);
+
+	dev_dbg(&dev->pdev->dev, "currently saved host_hw_state = 0x%08x.\n",
+	    dev->host_hw_state);
+
+	dev->need_reset = 0;
+
+	if (dev->mei_state != MEI_INITIALIZING) {
+		if (dev->mei_state != MEI_DISABLED &&
+		    dev->mei_state != MEI_POWER_DOWN)
+			dev->mei_state = MEI_RESETING;
+
+		list_for_each_entry_safe(file_pos,
+				file_next, &dev->file_list, link) {
+			file_pos->state = MEI_FILE_DISCONNECTED;
+			file_pos->mei_flow_ctrl_creds = 0;
+			file_pos->read_cb = NULL;
+			file_pos->timer_count = 0;
+		}
+		/* remove entry if already in list */
+		dev_dbg(&dev->pdev->dev, "list del iamthif and wd file list.\n");
+		mei_remove_client_from_file_list(dev,
+				dev->wd_file_ext.host_client_id);
+
+		mei_remove_client_from_file_list(dev,
+				dev->iamthif_file_ext.host_client_id);
+
+		mei_reset_iamthif_params(dev);
+		dev->wd_due_counter = 0;
+		dev->extra_write_index = 0;
+	}
+
+	dev->num_mei_me_clients = 0;
+	dev->rd_msg_hdr = 0;
+	dev->stop = 0;
+	dev->wd_pending = 0;
+
+	/* update the state of the registers after reset */
+	dev->host_hw_state = mei_hcsr_read(dev);
+	dev->me_hw_state = mei_mecsr_read(dev);
+
+	dev_dbg(&dev->pdev->dev, "after reset host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
+	    dev->host_hw_state, dev->me_hw_state);
+
+	if (unexpected)
+		dev_warn(&dev->pdev->dev, "unexpected reset.\n");
+
+	/* Wake up all readings so they can be interrupted */
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if (waitqueue_active(&file_pos->rx_wait)) {
+			dev_dbg(&dev->pdev->dev, "Waking up client!\n");
+			wake_up_interruptible(&file_pos->rx_wait);
+		}
+	}
+	/* remove all waiting requests */
+	if (dev->write_list.status == 0 &&
+		!list_empty(&dev->write_list.mei_cb.cb_list)) {
+		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				&dev->write_list.mei_cb.cb_list, cb_list) {
+			if (priv_cb_pos) {
+				list_del(&priv_cb_pos->cb_list);
+				mei_free_cb_private(priv_cb_pos);
+				priv_cb_pos = NULL;
+			}
+		}
+	}
+}
+
+
+
+/**
+ * host_start_message - mei host sends start message.
+ *
+ * @dev: the device structure
+ *
+ * returns none.
+ */
+void host_start_message(struct mei_device *dev)
+{
+	struct mei_msg_hdr *mei_hdr;
+	struct hbm_host_version_request *host_start_req;
+
+	/* host start message */
+	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	mei_hdr->host_addr = 0;
+	mei_hdr->me_addr = 0;
+	mei_hdr->length = sizeof(struct hbm_host_version_request);
+	mei_hdr->msg_complete = 1;
+	mei_hdr->reserved = 0;
+
+	host_start_req =
+	    (struct hbm_host_version_request *) &dev->wr_msg_buf[1];
+	memset(host_start_req, 0, sizeof(struct hbm_host_version_request));
+	host_start_req->cmd.cmd = HOST_START_REQ_CMD;
+	host_start_req->host_version.major_version = HBM_MAJOR_VERSION;
+	host_start_req->host_version.minor_version = HBM_MINOR_VERSION;
+	dev->recvd_msg = 0;
+	if (!mei_write_message(dev, mei_hdr,
+				       (unsigned char *) (host_start_req),
+				       mei_hdr->length)) {
+		dev_dbg(&dev->pdev->dev, "write send version message to FW fail.\n");
+		dev->mei_state = MEI_RESETING;
+		mei_reset(dev, 1);
+	}
+	dev->init_clients_state = MEI_START_MESSAGE;
+	dev->init_clients_timer = INIT_CLIENTS_TIMEOUT;
+	return ;
+}
+
+/**
+ * host_enum_clients_message - host sends enumeration client request message.
+ *
+ * @dev: the device structure
+ *
+ * returns none.
+ */
+void host_enum_clients_message(struct mei_device *dev)
+{
+	struct mei_msg_hdr *mei_hdr;
+	struct hbm_host_enum_request *host_enum_req;
+	mei_hdr = (struct mei_msg_hdr *) &dev->wr_msg_buf[0];
+	/* enumerate clients */
+	mei_hdr->host_addr = 0;
+	mei_hdr->me_addr = 0;
+	mei_hdr->length = sizeof(struct hbm_host_enum_request);
+	mei_hdr->msg_complete = 1;
+	mei_hdr->reserved = 0;
+
+	host_enum_req = (struct hbm_host_enum_request *) &dev->wr_msg_buf[1];
+	memset(host_enum_req, 0, sizeof(struct hbm_host_enum_request));
+	host_enum_req->cmd.cmd = HOST_ENUM_REQ_CMD;
+	if (!mei_write_message(dev, mei_hdr,
+			       (unsigned char *) (host_enum_req),
+				mei_hdr->length)) {
+		dev->mei_state = MEI_RESETING;
+		dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
+		mei_reset(dev, 1);
+	}
+	dev->init_clients_state = MEI_ENUM_CLIENTS_MESSAGE;
+	dev->init_clients_timer = INIT_CLIENTS_TIMEOUT;
+	return ;
+}
+
+
+/**
+ * allocate_me_clients_storage - allocates storage for me clients
+ *
+ * @dev: the device structure
+ *
+ * returns none.
+ */
+void allocate_me_clients_storage(struct mei_device *dev)
+{
+	struct mei_me_client *clients;
+	int b;
+
+	/* count how many ME clients we have */
+	for_each_set_bit(b, dev->me_clients_map, MEI_CLIENTS_MAX)
+		dev->num_mei_me_clients++;
+
+	if (dev->num_mei_me_clients <= 0)
+		return ;
+
+
+	if (dev->me_clients != NULL) {
+		kfree(dev->me_clients);
+		dev->me_clients = NULL;
+	}
+	dev_dbg(&dev->pdev->dev, "memory allocation for ME clients size=%lx.\n",
+		dev->num_mei_me_clients * sizeof(struct mei_me_client));
+	/* allocate storage for ME clients representation */
+	clients = kcalloc(dev->num_mei_me_clients,
+			sizeof(struct mei_me_client), GFP_KERNEL);
+	if (!clients) {
+		dev_dbg(&dev->pdev->dev, "memory allocation for ME clients failed.\n");
+		dev->mei_state = MEI_RESETING;
+		mei_reset(dev, 1);
+		return ;
+	}
+	dev->me_clients = clients;
+	return ;
+}
+/**
+ * host_client_properties - reads properties for client
+ *
+ * @dev: the device structure
+ *
+ * returns none.
+ */
+void host_client_properties(struct mei_device *dev)
+{
+	struct mei_msg_hdr *mei_header;
+	struct hbm_props_request *host_cli_req;
+	int b;
+	u8 client_num = dev->me_client_presentation_num;
+
+	b = dev->me_client_index;
+	b = find_next_bit(dev->me_clients_map, MEI_CLIENTS_MAX, b);
+	if (b < MEI_CLIENTS_MAX) {
+		dev->me_clients[client_num].client_id = b;
+		dev->me_clients[client_num].mei_flow_ctrl_creds = 0;
+		mei_header = (struct mei_msg_hdr *)&dev->wr_msg_buf[0];
+		mei_header->host_addr = 0;
+		mei_header->me_addr = 0;
+		mei_header->length = sizeof(struct hbm_props_request);
+		mei_header->msg_complete = 1;
+		mei_header->reserved = 0;
+
+		host_cli_req = (struct hbm_props_request *)&dev->wr_msg_buf[1];
+
+		memset(host_cli_req, 0, sizeof(struct hbm_props_request));
+
+		host_cli_req->cmd.cmd = HOST_CLIENT_PROPERTIES_REQ_CMD;
+		host_cli_req->address = b;
+
+		if (!mei_write_message(dev, mei_header,
+				(unsigned char *)host_cli_req,
+				mei_header->length)) {
+			dev->mei_state = MEI_RESETING;
+			dev_dbg(&dev->pdev->dev, "write send enumeration request message to FW fail.\n");
+			mei_reset(dev, 1);
+			return;
+		}
+
+		dev->init_clients_timer = INIT_CLIENTS_TIMEOUT;
+		dev->me_client_index = b;
+		return;
+	}
+
+
+	/*
+	 * Clear Map for indicating now ME clients
+	 * with associated host client
+	 */
+	bitmap_zero(dev->host_clients_map, MEI_CLIENTS_MAX);
+	dev->write_hang = -1;
+	dev->open_handle_count = 0;
+	bitmap_set(dev->host_clients_map, 0, 3);
+	dev->mei_state = MEI_ENABLED;
+
+	host_init_wd(dev);
+	return;
+}
+
+/**
+ * mei_init_file_private - initializes private file structure.
+ *
+ * @priv: private file structure to be initialized
+ * @file: the file structure
+ */
+static void mei_init_file_private(struct mei_file_private *priv,
+				   struct file *file)
+{
+	memset(priv, 0, sizeof(struct mei_file_private));
+	init_waitqueue_head(&priv->wait);
+	init_waitqueue_head(&priv->rx_wait);
+	init_waitqueue_head(&priv->tx_wait);
+	INIT_LIST_HEAD(&priv->link);
+	priv->reading_state = MEI_IDLE;
+	priv->writing_state = MEI_IDLE;
+}
+
+int mei_find_me_client_index(const struct mei_device *dev,
+							uuid_le cuuid)
+{
+	int i, res = -1;
+
+	for (i = 0; i < dev->num_mei_me_clients; ++i)
+		if (uuid_le_cmp(cuuid,
+				dev->me_clients[i].props.protocol_name) == 0) {
+			res = i;
+			break;
+		}
+
+	return res;
+}
+
+
+/**
+ * mei_find_me_client_update_filext - searches for ME client guid
+ *                       sets client_id in mei_file_private if found
+ * @dev: the device structure
+ * @priv: private file structure to set client_id in
+ * @cguid: searched guid of ME client
+ * @client_id: id of host client to be set in file private structure
+ *
+ * returns ME client index
+ */
+static u8 mei_find_me_client_update_filext(struct mei_device *dev,
+				struct mei_file_private *priv,
+				const uuid_le *cguid, u8 client_id)
+{
+	int i;
+
+	if (!dev || !priv || !cguid)
+		return 0;
+
+	/* check for valid client id */
+	i = mei_find_me_client_index(dev, *cguid);
+	if (i >= 0) {
+		priv->me_client_id = dev->me_clients[i].client_id;
+		priv->state = MEI_FILE_CONNECTING;
+		priv->host_client_id = client_id;
+
+		list_add_tail(&priv->link, &dev->file_list);
+		return (u8)i;
+	}
+
+	return 0;
+}
+
+/**
+ * host_init_wd - mei initialization wd.
+ *
+ * @dev: the device structure
+ */
+void host_init_wd(struct mei_device *dev)
+{
+	mei_init_file_private(&dev->wd_file_ext, NULL);
+
+	/* look for WD client and connect to it */
+	dev->wd_file_ext.state = MEI_FILE_DISCONNECTED;
+	dev->wd_timeout = 0;
+
+	if (watchdog_timeout > 0) {
+		/* AMT mode */
+		dev->wd_timeout = watchdog_timeout;
+		dev_dbg(&dev->pdev->dev,
+				"dev->wd_timeout=%d.\n", dev->wd_timeout);
+		memcpy(dev->wd_data, mei_start_wd_params, MEI_WD_PARAMS_SIZE);
+		memcpy(dev->wd_data + MEI_WD_PARAMS_SIZE,
+			   &dev->wd_timeout, sizeof(u16));
+
+		/* find ME WD client */
+		mei_find_me_client_update_filext(dev, &dev->wd_file_ext,
+					&mei_wd_guid, MEI_WD_HOST_CLIENT_ID);
+
+		dev_dbg(&dev->pdev->dev, "check wd_file_ext\n");
+		if (MEI_FILE_CONNECTING == dev->wd_file_ext.state) {
+			if (!mei_connect(dev, &dev->wd_file_ext)) {
+				dev_dbg(&dev->pdev->dev, "Failed to connect to WD client\n");
+				dev->wd_file_ext.state = MEI_FILE_DISCONNECTED;
+				dev->wd_file_ext.host_client_id = 0;
+				host_init_iamthif(dev) ;
+			} else {
+				dev->wd_file_ext.timer_count = CONNECT_TIMEOUT;
+			}
+		} else {
+			dev_dbg(&dev->pdev->dev, "Failed to find WD client\n");
+			host_init_iamthif(dev) ;
+		}
+	} else {
+		dev->wd_bypass = 1;
+		dev_dbg(&dev->pdev->dev, "WD requested to be disabled\n");
+		host_init_iamthif(dev) ;
+	}
+}
+
+
+/**
+ * host_init_iamthif - mei initialization iamthif client.
+ *
+ * @dev: the device structure
+ *
+ */
+void host_init_iamthif(struct mei_device *dev)
+{
+	u8 i;
+	unsigned char *msg_buf;
+
+	mei_init_file_private(&dev->iamthif_file_ext, NULL);
+	dev->iamthif_file_ext.state = MEI_FILE_DISCONNECTED;
+
+	/* find ME amthi client */
+	i = mei_find_me_client_update_filext(dev, &dev->iamthif_file_ext,
+			    &mei_amthi_guid, MEI_IAMTHIF_HOST_CLIENT_ID);
+	if (dev->iamthif_file_ext.state != MEI_FILE_CONNECTING) {
+		dev_dbg(&dev->pdev->dev, "failed to find iamthif client.\n");
+		return;
+	}
+
+	/* Do not render the system unusable when iamthif_mtu is not equal to
+	the value received from ME.
+	Assign iamthif_mtu to the value received from ME in order to solve the
+	hardware macro incompatibility. */
+
+	dev_dbg(&dev->pdev->dev, "[DEFAULT] IAMTHIF = %d\n", dev->iamthif_mtu);
+	dev->iamthif_mtu = dev->me_clients[i].props.max_msg_length;
+	dev_dbg(&dev->pdev->dev,
+			"IAMTHIF = %d\n",
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
+	if (!mei_connect(dev, &dev->iamthif_file_ext)) {
+		dev_dbg(&dev->pdev->dev, "Failed to connect to AMTHI client\n");
+		dev->iamthif_file_ext.state = MEI_FILE_DISCONNECTED;
+		dev->iamthif_file_ext.host_client_id = 0;
+	} else {
+		dev->iamthif_file_ext.timer_count = CONNECT_TIMEOUT;
+	}
+}
+
+/**
+ * mei_alloc_file_private - allocates a private file structure and sets it up.
+ * @file: the file structure
+ *
+ * returns  The allocated file or NULL on failure
+ */
+struct mei_file_private *mei_alloc_file_private(struct file *file)
+{
+	struct mei_file_private *priv;
+
+	priv = kmalloc(sizeof(struct mei_file_private), GFP_KERNEL);
+	if (!priv)
+		return NULL;
+
+	mei_init_file_private(priv, file);
+
+	return priv;
+}
+
+
+
+/**
+ * mei_disconnect_host_client - sends disconnect message to fw from host client.
+ *
+ * @dev: the device structure
+ * @file_ext: private data of the file object
+ *
+ * Locking: called under "dev->device_lock" lock
+ *
+ * returns 0 on success, <0 on failure.
+ */
+int mei_disconnect_host_client(struct mei_device *dev,
+				struct mei_file_private *file_ext)
+{
+	int rets, err;
+	long timeout = 15;	/* 15 seconds */
+	struct mei_cb_private *priv_cb;
+
+	if (!dev || !file_ext)
+		return -ENODEV;
+
+	if (file_ext->state != MEI_FILE_DISCONNECTING)
+		return 0;
+
+	priv_cb = kzalloc(sizeof(struct mei_cb_private), GFP_KERNEL);
+	if (!priv_cb)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&priv_cb->cb_list);
+	priv_cb->file_private = file_ext;
+	priv_cb->major_file_operations = MEI_CLOSE;
+	if (dev->mei_host_buffer_is_empty) {
+		dev->mei_host_buffer_is_empty = 0;
+		if (mei_disconnect(dev, file_ext)) {
+			mdelay(10); /* Wait for hardware disconnection ready */
+			list_add_tail(&priv_cb->cb_list,
+				&dev->ctrl_rd_list.mei_cb.cb_list);
+		} else {
+			rets = -ENODEV;
+			dev_dbg(&dev->pdev->dev, "failed to call mei_disconnect.\n");
+			goto free;
+		}
+	} else {
+		dev_dbg(&dev->pdev->dev, "add disconnect cb to control write list\n");
+		list_add_tail(&priv_cb->cb_list,
+				&dev->ctrl_wr_list.mei_cb.cb_list);
+	}
+	mutex_unlock(&dev->device_lock);
+
+	err = wait_event_timeout(dev->wait_recvd_msg,
+		 (MEI_FILE_DISCONNECTED == file_ext->state),
+		 timeout * HZ);
+
+	mutex_lock(&dev->device_lock);
+	if (MEI_FILE_DISCONNECTED == file_ext->state) {
+		rets = 0;
+		dev_dbg(&dev->pdev->dev, "successfully disconnected from FW client.\n");
+	} else {
+		rets = -ENODEV;
+		if (MEI_FILE_DISCONNECTED != file_ext->state)
+			dev_dbg(&dev->pdev->dev, "wrong status client disconnect.\n");
+
+		if (err)
+			dev_dbg(&dev->pdev->dev,
+					"wait failed disconnect err=%08x\n",
+					err);
+
+		dev_dbg(&dev->pdev->dev, "failed to disconnect from FW client.\n");
+	}
+
+	mei_flush_list(&dev->ctrl_rd_list, file_ext);
+	mei_flush_list(&dev->ctrl_wr_list, file_ext);
+free:
+	mei_free_cb_private(priv_cb);
+	return rets;
+}
+
+/**
+ * mei_remove_client_from_file_list -
+ *	removes file private data from device file list
+ *
+ * @dev: the device structure
+ * @host_client_id: host client id to be removed
+ */
+void mei_remove_client_from_file_list(struct mei_device *dev,
+				       u8 host_client_id)
+{
+	struct mei_file_private *file_pos = NULL;
+	struct mei_file_private *file_next = NULL;
+	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
+		if (host_client_id == file_pos->host_client_id) {
+			dev_dbg(&dev->pdev->dev, "remove host client = %d, ME client = %d\n",
+					file_pos->host_client_id,
+					file_pos->me_client_id);
+			list_del_init(&file_pos->link);
+			break;
+		}
+	}
+}
-- 
1.7.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

