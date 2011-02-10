Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1BJJzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:55:17 -0500
Received: from mga14.intel.com ([143.182.124.37]:54736 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab1BJJzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:10 -0500
Message-Id: <849307$bgs44t@azsmga001.ch.intel.com>
Date: 10 Feb 2011 01:55:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="386797742"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 04/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/hw.h b/drivers/char/mei/hw.h
new file mode 100644
index 0000000..0f856ba
--- /dev/null
+++ b/drivers/char/mei/hw.h
@@ -0,0 +1,518 @@
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
+
+#ifndef _MEI_DATA_STRUCTURES_H_
+#define _MEI_DATA_STRUCTURES_H_
+
+#include <linux/mei.h>
+#include <linux/io.h>
+#include <linux/wait.h>
+
+/*
+ * error code definition
+ */
+#define     ESLOTS_OVERFLOW              1
+#define     ECORRUPTED_MESSAGE_HEADER    1000
+#define     ECOMPLETE_MESSAGE            1001
+
+#define     MEI_FC_MESSAGE_RESERVED_LENGTH           5
+
+/*
+ * Number of queue lists used by this driver
+ */
+#define MEI_IO_LISTS_NUMBER        7
+
+/*
+ * MEI HW Section
+ */
+
+/* MEI registers */
+/* H_CB_WW - Host Circular Buffer (CB) Write Window register */
+#define H_CB_WW    0
+/* H_CSR - Host Control Status register */
+#define H_CSR      4
+/* ME_CB_RW - ME Circular Buffer Read Window register (read only) */
+#define ME_CB_RW   8
+/* ME_CSR_HA - ME Control Status Host Access register (read only) */
+#define ME_CSR_HA  0xC
+
+
+/* register bits of H_CSR (Host Control Status register) */
+/* Host Circular Buffer Depth - maximum number of 32-bit entries in CB */
+#define H_CBD             0xFF000000
+/* Host Circular Buffer Write Pointer */
+#define H_CBWP            0x00FF0000
+/* Host Circular Buffer Read Pointer */
+#define H_CBRP            0x0000FF00
+/* Host Reset */
+#define H_RST             0x00000010
+/* Host Ready */
+#define H_RDY             0x00000008
+/* Host Interrupt Generate */
+#define H_IG              0x00000004
+/* Host Interrupt Status */
+#define H_IS              0x00000002
+/* Host Interrupt Enable */
+#define H_IE              0x00000001
+
+
+/* register bits of ME_CSR_HA (ME Control Status Host Access register) */
+/* ME CB (Circular Buffer) Depth HRA (Host Read Access) - host read only
+access to ME_CBD */
+#define ME_CBD_HRA        0xFF000000
+/* ME CB Write Pointer HRA - host read only access to ME_CBWP */
+#define ME_CBWP_HRA       0x00FF0000
+/* ME CB Read Pointer HRA - host read only access to ME_CBRP */
+#define ME_CBRP_HRA       0x0000FF00
+/* ME Reset HRA - host read only access to ME_RST */
+#define ME_RST_HRA        0x00000010
+/* ME Ready HRA - host read only access to ME_RDY */
+#define ME_RDY_HRA        0x00000008
+/* ME Interrupt Generate HRA - host read only access to ME_IG */
+#define ME_IG_HRA         0x00000004
+/* ME Interrupt Status HRA - host read only access to ME_IS */
+#define ME_IS_HRA         0x00000002
+/* ME Interrupt Enable HRA - host read only access to ME_IE */
+#define ME_IE_HRA         0x00000001
+
+#define MEI_MINORS_BASE	1
+#define MEI_MINORS_COUNT	1
+
+#define  MEI_MINOR_NUMBER	1
+#define  MEI_MAX_OPEN_HANDLE_COUNT	253
+
+/*
+ * debug kernel print macro define
+ */
+extern int mei_debug;
+
+#define DBG(format, arg...) do { \
+	if (mei_debug) \
+		printk(KERN_INFO "mei: %s: " format, __func__, ## arg); \
+} while (0)
+
+
+/*
+ * time to wait for MEI to become ready after init
+ */
+#define MEI_INTEROP_TIMEOUT    (HZ * 7)
+
+/*
+ * watch dog definition
+ */
+#define MEI_WATCHDOG_DATA_SIZE         16
+#define MEI_START_WD_DATA_SIZE         20
+#define MEI_WD_PARAMS_SIZE             4
+#define MEI_WD_STATE_INDEPENDENCE_MSG_SENT       (1 << 0)
+
+#define MEI_WD_HOST_CLIENT_ID          1
+#define MEI_IAMTHIF_HOST_CLIENT_ID     2
+
+
+/* File state */
+enum file_state {
+	MEI_FILE_INITIALIZING = 0,
+	MEI_FILE_CONNECTING,
+	MEI_FILE_CONNECTED,
+	MEI_FILE_DISCONNECTING,
+	MEI_FILE_DISCONNECTED
+};
+
+/* MEI device states */
+enum mei_states {
+	MEI_INITIALIZING = 0,
+	MEI_INIT_CLIENTS,
+	MEI_ENABLED,
+	MEI_RESETING,
+	MEI_DISABLED,
+	MEI_RECOVERING_FROM_RESET,
+	MEI_POWER_DOWN,
+	MEI_POWER_UP
+};
+
+/* init clients  states*/
+enum mei_init_clients_states {
+	MEI_START_MESSAGE = 0,
+	MEI_ENUM_CLIENTS_MESSAGE,
+	MEI_CLIENT_PROPERTIES_MESSAGE
+};
+
+enum iamthif_states {
+	MEI_IAMTHIF_IDLE,
+	MEI_IAMTHIF_WRITING,
+	MEI_IAMTHIF_FLOW_CONTROL,
+	MEI_IAMTHIF_READING,
+	MEI_IAMTHIF_READ_COMPLETE
+};
+
+enum mei_file_transaction_states {
+	MEI_IDLE,
+	MEI_WRITING,
+	MEI_WRITE_COMPLETE,
+	MEI_FLOW_CONTROL,
+	MEI_READING,
+	MEI_READ_COMPLETE
+};
+
+/* MEI CB */
+enum mei_cb_major_types {
+	MEI_READ = 0,
+	MEI_WRITE,
+	MEI_IOCTL,
+	MEI_OPEN,
+	MEI_CLOSE
+};
+
+
+#define MEI_CONNECT_TIMEOUT             3	/* at least 2 seconds */
+
+#define IAMTHIF_STALL_TIMER              12	/* seconds */
+#define IAMTHIF_READ_TIMER               15	/* seconds */
+
+struct mei_cb_private {
+	struct list_head cb_list;
+	enum mei_cb_major_types major_file_operations;
+	void *file_private;
+	struct mei_message_data request_buffer;
+	struct mei_message_data response_buffer;
+	unsigned long information;
+	unsigned long read_time;
+	struct file *file_object;
+};
+
+/* Private file struct */
+struct mei_file_private {
+	struct list_head link;
+	struct file *file;
+	enum file_state state;
+	wait_queue_head_t tx_wait;
+	wait_queue_head_t rx_wait;
+	wait_queue_head_t wait;
+	int read_pending;
+	int status;
+	/* ID of client connected */
+	u8 host_client_id;
+	u8 me_client_id;
+	u8 flow_ctrl_creds;
+	u8 timer_count;
+	enum mei_file_transaction_states reading_state;
+	enum mei_file_transaction_states writing_state;
+	int sm_state;
+	struct mei_cb_private *read_cb;
+};
+
+struct io_mei_list {
+	struct mei_cb_private mei_cb;
+	int status;
+	struct iamt_mei_device *device_extension;
+};
+
+/*
+ *  MEI BUS Interface Section
+ */
+struct mei_msg_hdr {
+	u32 me_addr:8;
+	u32 host_addr:8;
+	u32 length:9;
+	u32 reserved:6;
+	u32 msg_complete:1;
+} __packed;
+
+
+struct hbm_cmd {
+	u8 cmd:7;
+	u8 is_response:1;
+} __packed;
+
+
+struct mei_bus_message {
+	struct hbm_cmd cmd;
+	u8 command_specific_data[];
+} __packed;
+
+struct hbm_version {
+	u8 minor_version;
+	u8 major_version;
+} __packed;
+
+struct hbm_host_version_request {
+	struct hbm_cmd cmd;
+	u8 reserved;
+	struct hbm_version host_version;
+} __packed;
+
+struct hbm_host_version_response {
+	struct hbm_cmd cmd;
+	int host_version_supported;
+	struct hbm_version me_max_version;
+} __packed;
+
+struct hbm_host_stop_request {
+	struct hbm_cmd cmd;
+	u8 reason;
+	u8 reserved[2];
+} __packed;
+
+struct hbm_host_stop_response {
+	struct hbm_cmd cmd;
+	u8 reserved[3];
+} __packed;
+
+struct hbm_me_stop_request {
+	struct hbm_cmd cmd;
+	u8 reason;
+	u8 reserved[2];
+} __packed;
+
+struct hbm_host_enum_request {
+	struct hbm_cmd cmd;
+	u8 reserved[3];
+} __packed;
+
+struct hbm_host_enum_response {
+	struct hbm_cmd cmd;
+	u8 reserved[3];
+	u8 valid_addresses[32];
+} __packed;
+
+struct mei_client_properties {
+	struct guid protocol_name;
+	u8 protocol_version;
+	u8 max_number_of_connections;
+	u8 fixed_address;
+	u8 single_recv_buf;
+	u32 max_msg_length;
+} __packed;
+
+struct hbm_props_request {
+	struct hbm_cmd cmd;
+	u8 address;
+	u8 reserved[2];
+} __packed;
+
+
+struct hbm_props_response {
+	struct hbm_cmd cmd;
+	u8 address;
+	u8 status;
+	u8 reserved[1];
+	struct mei_client_properties client_properties;
+} __packed;
+
+struct hbm_client_connect_request {
+	struct hbm_cmd cmd;
+	u8 me_addr;
+	u8 host_addr;
+	u8 reserved;
+} __packed;
+
+struct hbm_client_connect_response {
+	struct hbm_cmd cmd;
+	u8 me_addr;
+	u8 host_addr;
+	u8 status;
+} __packed;
+
+struct hbm_client_disconnect_request {
+	struct hbm_cmd cmd;
+	u8 me_addr;
+	u8 host_addr;
+	u8 reserved[1];
+} __packed;
+
+struct hbm_flow_control {
+	struct hbm_cmd cmd;
+	u8 me_addr;
+	u8 host_addr;
+	u8 reserved[MEI_FC_MESSAGE_RESERVED_LENGTH];
+} __packed;
+
+struct mei_me_client {
+	struct mei_client_properties props;
+	u8 client_id;
+	u8 flow_ctrl_creds;
+} __packed;
+
+/* private device struct */
+struct iamt_mei_device {
+	struct pci_dev *pdev;	/* pointer to pci device struct */
+	/*
+	 * lists of queues
+	 */
+	 /* array of pointers to  aio lists */
+	struct io_mei_list *io_list_array[MEI_IO_LISTS_NUMBER];
+	struct io_mei_list read_list;	/* driver read queue */
+	struct io_mei_list write_list;	/* driver write queue */
+	struct io_mei_list write_waiting_list;	/* write waiting queue */
+	struct io_mei_list ctrl_wr_list;	/* managed write IOCTL list */
+	struct io_mei_list ctrl_rd_list;	/* managed read IOCTL list */
+	struct io_mei_list pthi_cmd_list;	/* PTHI list for cmd waiting */
+
+	/* driver managed PTHI list for reading completed pthi cmd data */
+	struct io_mei_list pthi_read_complete_list;
+	/*
+	 * list of files
+	 */
+	struct list_head file_list;
+	/*
+	 * memory of device
+	 */
+	unsigned int mem_base;
+	unsigned int mem_length;
+	void __iomem *mem_addr;
+	/*
+	 * lock for the device
+	 */
+	struct mutex device_lock; /* device lock */
+	int recvd_msg;
+	struct delayed_work wd_work;	/* watch dog deleye work */
+	/*
+	 * hw states of host and fw(ME)
+	 */
+	u32 host_hw_state;
+	u32 me_hw_state;
+	/*
+	 * waiting queue for receive message from FW
+	 */
+	wait_queue_head_t wait_recvd_msg;
+	wait_queue_head_t wait_stop_wd;
+
+      /*
+	 * mei device  states
+	 */
+	enum mei_states mei_state;
+	enum  mei_init_clients_states  init_clients_state;
+	 u16               init_clients_timer;
+	int stop;
+
+	u32 extra_write_index;
+	u32 rd_msg_buf[128];	/* used for control messages */
+	u32 wr_msg_buf[128];	/* used for control messages */
+	u32 ext_msg_buf[8];	/* for control responses */
+	u32 rd_msg_hdr;
+
+	struct hbm_version version;
+
+	int host_buffer_is_empty;
+	struct mei_file_private wd_file_ext;
+	struct mei_me_client *me_clients; /* Note: memory has to be allocated */
+	u8 mei_me_clients[32];	/* list of existing clients */
+	u8 num_mei_me_clients;
+	u8 me_client_presentation_num ;
+	u8 me_client_index  ;
+	u8 mei_host_clients[32];	/* list of existing clients */
+	u8 current_host_client_id;
+
+	int wd_pending;
+	int wd_stopped;
+	u16 wd_timeout;	/* seconds ((wd_data[1] << 8) + wd_data[0]) */
+	unsigned char wd_data[MEI_START_WD_DATA_SIZE];
+
+
+	u16 wd_due_counter;
+	int asf_mode;
+	int wd_bypass;	/* if 1, don't refresh watchdog ME client */
+
+	struct file *iamthif_file_object;
+	struct mei_file_private iamthif_file_ext;
+	int iamthif_ioctl;
+	int iamthif_canceled;
+	int iamthif_mtu;
+	u32 iamthif_timer;
+	u32 iamthif_stall_timer;
+	unsigned char *iamthif_msg_buf; /* Note: memory has to be allocated */
+	u32 iamthif_msg_buf_size;
+	u32 iamthif_msg_buf_index;
+	int iamthif_flow_control_pending;
+	enum iamthif_states iamthif_state;
+
+	struct mei_cb_private *iamthif_current_cb;
+	u8 write_hang;
+	int need_reset;
+	long open_handle_count;
+
+};
+
+/**
+ * read_mei_register - Reads a byte from the mei device
+ *
+ * @dev: the device structure
+ * @offset: offset from which to read the data
+ *
+ * returns the byte read.
+ */
+static inline u32 read_mei_register(struct iamt_mei_device *dev,
+					unsigned long offset)
+{
+	return readl(dev->mem_addr + offset);
+}
+
+/**
+ * write_mei_register - Writes 4 bytes to the mei device
+ *
+ * @dev: the device structure
+ * @offset: offset from which to write the data
+ * @value: the byte to write
+ */
+static inline void write_mei_register(struct iamt_mei_device *dev,
+					unsigned long offset,  u32 value)
+{
+	writel(value, dev->mem_addr + offset);
+}
+
+/**
+ * get_host_hw_state - Reads a byte from the mei H_CSR register
+ *
+ * @dev: the device structure
+ *
+ * returns the byte read.
+ */
+static inline u32 get_host_hw_state(struct iamt_mei_device *dev)
+{
+	return read_mei_register(dev, H_CSR);
+}
+
+/**
+ * get_me_hw_state - Reads a byte from the mei ME_CSR_HA register
+ *
+ * @dev: the device structure
+ *
+ * returns the byte read.
+ */
+static inline u32 get_me_hw_state(struct iamt_mei_device *dev)
+{
+	return read_mei_register(dev, ME_CSR_HA);
+}
+
+/**
+ * get_me_cb_rw - Reads a byte from the mei ME_CB_RW register
+ *
+ * @dev: the device structure
+ *
+ * returns the byte read.
+ */
+static inline u32 get_me_cb_rw(struct iamt_mei_device *dev)
+{
+	return read_mei_register(dev, ME_CB_RW);
+}
+
+#endif /* _MEI_DATA_STRUCTURES_H_ */


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

