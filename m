Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab0LQLZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 06:25:49 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:48271 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab0LQLZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 06:25:47 -0500
From: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
To: Pavan Savoy <pavan_savoy@sify.com>, Vitaly Wool <vitalywool@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>,
        Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Subject: [PATCH 01/11] mfd: Add support for CG2900 controller framework
Date: Fri, 17 Dec 2010 12:22:47 +0100
Message-ID: <1292584967-28332-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the ST-Ericsson CG2900
framework. The CG2900 is a chip supporting GPS,
Bluetooth, and FM radio.
This patch adds support for registering transports
and chip drivers and also functionality to map a
transport to a certain chip driver.

Signed-off-by: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
---
 drivers/mfd/Kconfig              |    8 +
 drivers/mfd/Makefile             |    2 +
 drivers/mfd/cg2900/Makefile      |    7 +
 drivers/mfd/cg2900/cg2900_core.c |  711 ++++++++++++++++++++++++++++++++++++++
 drivers/mfd/cg2900/cg2900_core.h |   51 +++
 include/linux/mfd/cg2900.h       |  287 +++++++++++++++
 6 files changed, 1066 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/cg2900/Makefile
 create mode 100644 drivers/mfd/cg2900/cg2900_core.c
 create mode 100644 drivers/mfd/cg2900/cg2900_core.h
 create mode 100644 include/linux/mfd/cg2900.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 3a1493b..7c833f9 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -262,6 +262,14 @@ config MFD_TC6393XB
 	help
 	  Support for Toshiba Mobile IO Controller TC6393XB
 
+config MFD_CG2900
+	tristate "Support ST-Ericsson CG2900 main structure"
+	depends on NET
+	help
+	  Support for ST-Ericsson CG2900 Connectivity Combo controller main structure.
+	  Supports multiple functionalities muxed over a Bluetooth HCI H:4 interface.
+	  CG2900 support Bluetooth, FM radio, and GPS.
+
 config PMIC_DA903X
 	bool "Dialog Semiconductor DA9030/DA9034 PMIC Support"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index f54b365..462a6c0 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -57,6 +57,8 @@ obj-$(CONFIG_MCP_UCB1200)	+= ucb1x00-assabet.o
 endif
 obj-$(CONFIG_UCB1400_CORE)	+= ucb1400_core.o
 
+obj-y				+= cg2900/
+
 obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
diff --git a/drivers/mfd/cg2900/Makefile b/drivers/mfd/cg2900/Makefile
new file mode 100644
index 0000000..a736101
--- /dev/null
+++ b/drivers/mfd/cg2900/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for ST-Ericsson CG2900 connectivity combo controller
+#
+
+obj-$(CONFIG_MFD_CG2900)	+= cg2900_core.o
+export-objs			:= cg2900_core.o
+
diff --git a/drivers/mfd/cg2900/cg2900_core.c b/drivers/mfd/cg2900/cg2900_core.c
new file mode 100644
index 0000000..2df3889
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_core.c
@@ -0,0 +1,711 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+#define NAME					"cg2900_core"
+#define pr_fmt(fmt)				NAME ": " fmt "\n"
+
+#include <asm/byteorder.h>
+#include <linux/firmware.h>
+#include <linux/fs.h>
+#include <linux/gfp.h>
+#include <linux/init.h>
+#include <linux/jiffies.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/skbuff.h>
+#include <linux/stat.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+#include <linux/mfd/cg2900.h>
+#include <linux/mfd/core.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci.h>
+
+#include "cg2900_core.h"
+
+/* Device names */
+#define CG2900_CDEV_NAME		"cg2900_core_test"
+#define CG2900_CLASS_NAME		"cg2900_class"
+#define CG2900_DEVICE_NAME		"cg2900_driver"
+#define CORE_WQ_NAME			"cg2900_core_wq"
+
+#define LOGGER_DIRECTION_TX		0
+#define LOGGER_DIRECTION_RX		1
+
+/*
+ * Timeout values
+ */
+#define CHIP_READY_TIMEOUT		(100)	/* ms */
+#define REVISION_READOUT_TIMEOUT	(500)	/* ms */
+
+/**
+ * enum boot_state - BOOT-state for CG2900 Core.
+ * @BOOT_RESET:					HCI Reset has been sent.
+ * @BOOT_READ_LOCAL_VERSION_INFORMATION:	ReadLocalVersionInformation
+ *						command has been sent.
+ * @BOOT_READY:					CG2900 Core boot is ready.
+ * @BOOT_FAILED:				CG2900 Core boot failed.
+ */
+enum boot_state {
+	BOOT_RESET,
+	BOOT_READ_LOCAL_VERSION_INFORMATION,
+	BOOT_READY,
+	BOOT_FAILED
+};
+
+/**
+ * struct chip_handler_item - Structure to store chip handler cb.
+ * @list:	list_head struct.
+ * @cb:		Chip handler callback struct.
+ */
+struct chip_handler_item {
+	struct list_head		list;
+	struct cg2900_id_callbacks	cb;
+};
+
+/**
+ * struct core_info - Main info structure for CG2900 Core.
+ * @boot_state:		Current BOOT-state of CG2900 Core.
+ * @wq:			CG2900 Core workqueue.
+ * @chip_dev:		Device structure for chip driver.
+ * @work:		Work structure.
+ */
+struct core_info {
+	enum boot_state			boot_state;
+	struct workqueue_struct		*wq;
+	struct cg2900_chip_dev		*chip_dev;
+	struct work_struct		work;
+};
+
+/**
+ * struct main_info - Main info structure for CG2900 Core.
+ * @dev:		Device structure for STE Connectivity driver.
+ * @man_mutex:		Management mutex.
+ * @chip_handlers:	List of the register handlers for different chips.
+ * @wq:			Wait queue.
+ */
+struct main_info {
+	struct device		*dev;
+	struct mutex		man_mutex;
+	struct list_head	chip_handlers;
+	wait_queue_head_t	wq;
+};
+
+/* core_info - Main information object for CG2900 Core. */
+static struct main_info *main_info;
+
+/* Module parameters */
+u8 bd_address[] = {0x00, 0xBE, 0xAD, 0xDE, 0x80, 0x00};
+EXPORT_SYMBOL_GPL(bd_address);
+int bd_addr_count = BT_BDADDR_SIZE;
+
+static int sleep_timeout_ms = 10000;
+
+/**
+ * send_bt_cmd() - Copy and send sk_buffer with no assigned user.
+ * @dev:	Current chip to transmit to.
+ * @data:	Data to send.
+ * @length:	Length in bytes of data.
+ *
+ * The send_bt_cmd() function allocate sk_buffer, copy supplied
+ * data to it, and send the sk_buffer to controller.
+ */
+void send_bt_cmd(struct cg2900_chip_dev *dev, void *data, int length)
+{
+	struct sk_buff *skb;
+	int err;
+
+	skb = alloc_skb(length + HCI_H4_SIZE, GFP_KERNEL);
+	if (!skb) {
+		dev_err(dev->dev, "send_bt_cmd: Couldn't alloc sk_buff with "
+			"length %d\n", length);
+		return;
+	}
+
+	skb_reserve(skb, HCI_H4_SIZE);
+	memcpy(skb_put(skb, length), data, length);
+	skb_push(skb, HCI_H4_SIZE);
+	skb->data[0] = HCI_BT_CMD_H4_CHANNEL;
+
+	err = dev->t_cb.write(dev, skb);
+	if (err) {
+		dev_err(dev->dev, "send_bt_cmd: Transport write failed (%d)\n",
+			err);
+		kfree_skb(skb);
+	}
+}
+
+/**
+ * handle_reset_cmd_complete_evt() - Handle a received HCI Command Complete event for a Reset command.
+ * @dev:	Current device.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_reset_cmd_complete_evt(struct cg2900_chip_dev *dev, u8 *data)
+{
+	bool pkt_handled = false;
+	u8 status = data[0];
+	struct hci_command_hdr cmd;
+	struct core_info *info = dev->prv_data;
+
+	dev_dbg(dev->dev, "Received Reset complete event with status 0x%X\n",
+		status);
+
+	if (info->boot_state == BOOT_RESET) {
+		/* Transmit HCI Read Local Version Information command */
+		dev_dbg(dev->dev, "New boot_state: "
+			"BOOT_READ_LOCAL_VERSION_INFORMATION\n");
+		info->boot_state = BOOT_READ_LOCAL_VERSION_INFORMATION;
+		cmd.opcode = cpu_to_le16(HCI_OP_READ_LOCAL_VERSION);
+		cmd.plen = 0; /* No parameters for HCI reset */
+		send_bt_cmd(dev, &cmd, sizeof(cmd));
+
+		pkt_handled = true;
+	}
+
+	return pkt_handled;
+}
+
+/**
+ * handle_read_local_version_info_cmd_complete_evt() - Handle a received HCI Command Complete event for a ReadLocalVersionInformation command.
+ * @dev:	Current device.
+ * @data:	Pointer to received HCI data packet.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool
+handle_read_local_version_info_cmd_complete_evt(struct cg2900_chip_dev *dev,
+						u8 *data)
+{
+	struct hci_rp_read_local_version *evt;
+	struct core_info *info = dev->prv_data;
+
+	/* Check we're in the right state */
+	if (info->boot_state != BOOT_READ_LOCAL_VERSION_INFORMATION)
+		return false;
+
+	/* We got an answer for our HCI command. Extract data */
+	evt = (struct hci_rp_read_local_version *)data;
+
+	/* We will handle the packet */
+	if (HCI_BT_ERROR_NO_ERROR != evt->status) {
+		dev_err(dev->dev, "Received Read Local Version Information "
+			"with status 0x%X\n", evt->status);
+		dev_dbg(dev->dev, "New boot_state: BOOT_FAILED\n");
+		info->boot_state = BOOT_FAILED;
+		wake_up_interruptible_all(&main_info->wq);
+		return true;
+	}
+
+	/* The command worked. Store the data */
+	dev->chip.hci_version = evt->hci_ver;
+	dev->chip.hci_revision = le16_to_cpu(evt->hci_rev);
+	dev->chip.lmp_pal_version = evt->lmp_ver;
+	dev->chip.manufacturer = le16_to_cpu(evt->manufacturer);
+	dev->chip.hci_sub_version = le16_to_cpu(evt->lmp_subver);
+	dev_info(dev->dev, "Received Read Local Version Information with:\n"
+		 "\thci_version:  0x%02X\n"
+		 "\thci_revision: 0x%04X\n"
+		 "\tlmp_pal_version: 0x%02X\n"
+		 "\tmanufacturer: 0x%04X\n"
+		 "\thci_sub_version: 0x%04X\n",
+		 dev->chip.hci_version, dev->chip.hci_revision,
+		 dev->chip.lmp_pal_version, dev->chip.manufacturer,
+		 dev->chip.hci_sub_version);
+
+	dev_dbg(dev->dev, "New boot_state: BOOT_READY\n");
+	info->boot_state = BOOT_READY;
+	wake_up_interruptible_all(&main_info->wq);
+
+	return true;
+}
+
+/**
+ * handle_rx_data_bt_evt() - Check if data should be handled in CG2900 Core.
+ * @dev:	Current chip
+ * @skb:	Data packet
+ *
+ * The handle_rx_data_bt_evt() function checks if received data should be
+ * handled in CG2900 Core. If so handle it correctly.
+ * Received data is always HCI BT Event.
+ *
+ * Returns:
+ *   True,  if packet was handled internally,
+ *   False, otherwise.
+ */
+static bool handle_rx_data_bt_evt(struct cg2900_chip_dev *dev,
+				  struct sk_buff *skb)
+{
+	bool pkt_handled = false;
+	u8 *data = &skb->data[CG2900_SKB_RESERVE];
+	struct hci_event_hdr *evt;
+	struct hci_ev_cmd_complete *cmd_complete;
+	u16 op_code;
+
+	evt = (struct hci_event_hdr *)data;
+
+	/* First check the event code */
+	if (HCI_EV_CMD_COMPLETE != evt->evt)
+		return false;
+
+	data += sizeof(*evt);
+	cmd_complete = (struct hci_ev_cmd_complete *)data;
+
+	op_code = le16_to_cpu(cmd_complete->opcode);
+
+	dev_dbg(dev->dev, "Received Command Complete: op_code = 0x%04X\n",
+		op_code);
+	data += sizeof(*cmd_complete); /* Move to first byte after OCF */
+
+	if (op_code == HCI_OP_RESET)
+		pkt_handled = handle_reset_cmd_complete_evt(dev, data);
+	else if (op_code == HCI_OP_READ_LOCAL_VERSION)
+		pkt_handled = handle_read_local_version_info_cmd_complete_evt
+					(dev, data);
+
+	if (pkt_handled)
+		kfree_skb(skb);
+
+	return pkt_handled;
+}
+
+static void cg2900_data_from_chip(struct cg2900_chip_dev *dev,
+				  struct sk_buff *skb)
+{
+	u8 h4_channel;
+
+	dev_dbg(dev->dev, "cg2900_data_from_chip\n");
+
+	if (!skb) {
+		dev_err(dev->dev, "No data supplied\n");
+		return;
+	}
+
+	h4_channel = skb->data[0];
+
+	/*
+	 * First check if this is the response for something
+	 * we have sent internally.
+	 */
+	if (HCI_BT_EVT_H4_CHANNEL == h4_channel &&
+	    handle_rx_data_bt_evt(dev, skb)) {
+		dev_dbg(dev->dev, "Received packet handled internally\n");
+	} else {
+		dev_err(dev->dev,
+			"cg2900_data_from_chip: Received unexpected packet\n");
+		kfree_skb(skb);
+	}
+}
+
+/**
+ * work_hw_registered() - Called when the interface to HW has been established.
+ * @work:	Reference to work data.
+ *
+ * Since there now is a transport identify the connected chip and decide which
+ * chip handler to use.
+ */
+static void work_hw_registered(struct work_struct *work)
+{
+	struct hci_command_hdr cmd;
+	struct cg2900_chip_dev *dev;
+	struct core_info *info;
+	bool chip_handled = false;
+	struct list_head *cursor;
+	struct chip_handler_item *tmp;
+
+	dev_dbg(main_info->dev, "work_hw_registered\n");
+
+	if (!work) {
+		dev_err(main_info->dev, "work_hw_registered: work == NULL\n");
+		return;
+	}
+
+	info = container_of(work, struct core_info, work);
+	dev = info->chip_dev;
+
+	/*
+	 * This might look strange, but we need to read out
+	 * the revision info in order to be able to shutdown the chip properly.
+	 */
+	if (dev->t_cb.set_chip_power)
+		dev->t_cb.set_chip_power(dev, true);
+
+	/* Wait 100ms before continuing to be sure that the chip is ready */
+	schedule_timeout_interruptible(msecs_to_jiffies(CHIP_READY_TIMEOUT));
+
+	/* Set our function to receive data from chip */
+	dev->c_cb.data_from_chip = cg2900_data_from_chip;
+
+	/*
+	 * Transmit HCI reset command to ensure the chip is using
+	 * the correct transport
+	 */
+	dev_dbg(dev->dev, "New boot_state: BOOT_RESET\n");
+	info->boot_state = BOOT_RESET;
+	cmd.opcode = cpu_to_le16(HCI_OP_RESET);
+	cmd.plen = 0; /* No parameters for HCI reset */
+	send_bt_cmd(dev, &cmd, sizeof(cmd));
+
+	dev_dbg(dev->dev,
+		"Wait up to 500 milliseconds for revision to be read\n");
+	wait_event_interruptible_timeout(main_info->wq,
+		(BOOT_READY == info->boot_state ||
+		 BOOT_FAILED == info->boot_state),
+		msecs_to_jiffies(REVISION_READOUT_TIMEOUT));
+
+	if (BOOT_READY != info->boot_state) {
+		dev_err(dev->dev,
+			"Could not read out revision from the chip\n");
+		return;
+	}
+
+	dev->c_cb.data_from_chip = NULL;
+
+	mutex_lock(&main_info->man_mutex);
+	list_for_each(cursor, &main_info->chip_handlers) {
+		tmp = list_entry(cursor, struct chip_handler_item, list);
+		chip_handled = tmp->cb.check_chip_support(dev);
+		if (chip_handled) {
+			dev_info(dev->dev, "Chip handler found\n");
+			break;
+		}
+	}
+	mutex_unlock(&main_info->man_mutex);
+
+	if (!chip_handled)
+		dev_info(dev->dev, "No chip handler found\n");
+}
+
+/**
+ * cg2900_register_chip_driver() - Register a chip handler.
+ * @cb:	Callbacks to call when chip is connected.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ */
+int cg2900_register_chip_driver(struct cg2900_id_callbacks *cb)
+{
+	struct chip_handler_item *item;
+
+	dev_dbg(main_info->dev, "cg2900_register_chip_driver\n");
+
+	if (!cb) {
+		dev_err(main_info->dev, "NULL supplied as cb\n");
+		return -EINVAL;
+	}
+
+	item = kzalloc(sizeof(*item), GFP_KERNEL);
+	if (!item) {
+		dev_err(main_info->dev,
+			"cg2900_register_chip_driver: "
+			"Failed to alloc memory\n");
+		return -ENOMEM;
+	}
+
+	memcpy(&item->cb, cb, sizeof(cb));
+	mutex_lock(&main_info->man_mutex);
+	list_add_tail(&item->list, &main_info->chip_handlers);
+	mutex_unlock(&main_info->man_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cg2900_register_chip_driver);
+
+/**
+ * cg2900_deregister_chip_driver() - Deregister a chip handler.
+ * @cb:	Callbacks to call when chip is connected.
+ */
+void cg2900_deregister_chip_driver(struct cg2900_id_callbacks *cb)
+{
+	struct chip_handler_item *tmp;
+	struct list_head *cursor, *next;
+
+	dev_dbg(main_info->dev, "cg2900_deregister_chip_driver\n");
+
+	if (!cb) {
+		dev_err(main_info->dev, "NULL supplied as cb\n");
+		return;
+	}
+	mutex_lock(&main_info->man_mutex);
+	list_for_each_safe(cursor, next, &main_info->chip_handlers) {
+		tmp = list_entry(cursor, struct chip_handler_item, list);
+		if (tmp->cb.check_chip_support == cb->check_chip_support) {
+			list_del(cursor);
+			kfree(tmp);
+			break;
+		}
+	}
+	mutex_unlock(&main_info->man_mutex);
+}
+EXPORT_SYMBOL_GPL(cg2900_deregister_chip_driver);
+
+/**
+ * cg2900_register_trans_driver() - Register a transport driver.
+ * @dev:	Transport device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ *   -EACCES if work can't be queued.
+ */
+int cg2900_register_trans_driver(struct cg2900_chip_dev *dev)
+{
+	int err;
+	struct cg2900_platform_data *pf_data;
+	struct core_info *info;
+
+	BUG_ON(!main_info);
+
+	if (!dev || !dev->dev) {
+		dev_err(main_info->dev, "cg2900_register_trans_driver: "
+			"Received NULL pointer\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(dev->dev, "cg2900_register_trans_driver\n");
+
+	if (!dev->t_cb.write) {
+		dev_err(dev->dev, "cg2900_register_trans_driver: Write function"
+			" missing\n");
+		return -EINVAL;
+	}
+
+	pf_data = dev_get_platdata(dev->dev);
+	if (!pf_data) {
+		dev_err(dev->dev, "cg2900_register_trans_driver: Missing "
+			"platform data\n");
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		dev_err(dev->dev, "Couldn't allocate info\n");
+		return -ENOMEM;
+	}
+
+	if (pf_data->init) {
+		err = pf_data->init(dev);
+		if (err) {
+			dev_err(dev->dev, "Platform init failed (%d)\n", err);
+			goto error_handling;
+		}
+	}
+
+	info->chip_dev = dev;
+	dev->prv_data = info;
+
+	info->wq = create_singlethread_workqueue(CORE_WQ_NAME);
+	if (!info->wq) {
+		dev_err(dev->dev, "Could not create workqueue\n");
+		err = -ENOMEM;
+		goto error_handling_exit;
+	}
+
+	dev_info(dev->dev, "Transport connected\n");
+
+	INIT_WORK(&info->work, work_hw_registered);
+	if (!queue_work(info->wq, &info->work)) {
+		dev_err(dev->dev, "Failed to queue work_hw_registered because "
+			"it's already in the queue\n");
+		err = -EACCES;
+		goto error_handling_wq;
+	}
+
+	return 0;
+
+error_handling_wq:
+	destroy_workqueue(info->wq);
+error_handling_exit:
+	if (pf_data->exit)
+		pf_data->exit(dev);
+error_handling:
+	kfree(info);
+	return err;
+}
+EXPORT_SYMBOL_GPL(cg2900_register_trans_driver);
+
+/**
+ * cg2900_deregister_trans_driver() - Deregister a transport driver.
+ * @dev:	Transport device.
+ *
+ * Returns:
+ *   0 if there is no error.
+ *   -EINVAL if NULL is supplied as @cb.
+ *   -ENOMEM if allocation fails or work queue can't be created.
+ */
+int cg2900_deregister_trans_driver(struct cg2900_chip_dev *dev)
+{
+	struct cg2900_platform_data *pf_data;
+	struct core_info *info = dev->prv_data;
+
+	BUG_ON(!main_info);
+
+	dev_dbg(dev->dev, "cg2900_deregister_trans_driver\n");
+
+	if (dev->c_cb.chip_removed)
+		dev->c_cb.chip_removed(dev);
+
+	destroy_workqueue(info->wq);
+
+	dev->prv_data = NULL;
+	kfree(info);
+
+	dev_info(dev->dev, "Transport disconnected\n");
+
+	pf_data = dev_get_platdata(dev->dev);
+	if (!pf_data) {
+		dev_err(dev->dev, "Missing platform data\n");
+		return -EINVAL;
+	}
+
+	if (pf_data->exit)
+		pf_data->exit(dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cg2900_deregister_trans_driver);
+
+/**
+ * cg2900_get_sleep_timeout() - Return sleep timeout in jiffies.
+ *
+ * Returns:
+ *   Sleep timeout in jiffies. 0 means that sleep timeout shall not be used.
+ */
+unsigned long cg2900_get_sleep_timeout(void)
+{
+	if (!sleep_timeout_ms)
+		return 0;
+
+	return msecs_to_jiffies(sleep_timeout_ms);
+}
+EXPORT_SYMBOL_GPL(cg2900_get_sleep_timeout);
+
+/**
+ * cg2900_probe() - Initialize module.
+ *
+ * @pdev:	Platform device.
+ *
+ * This function initialize the transport and CG2900 Core, then
+ * register to the transport framework.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM for failed alloc or structure creation.
+ */
+static int __devinit cg2900_probe(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "cg2900_probe\n");
+
+	main_info = kzalloc(sizeof(*main_info), GFP_KERNEL);
+	if (!main_info) {
+		dev_err(&pdev->dev, "Couldn't allocate main_info\n");
+		return -ENOMEM;
+	}
+
+	main_info->dev = &pdev->dev;
+	mutex_init(&main_info->man_mutex);
+	INIT_LIST_HEAD(&main_info->chip_handlers);
+	init_waitqueue_head(&main_info->wq);
+
+	dev_info(&pdev->dev, "CG2900 Core driver started\n");
+
+	return 0;
+}
+
+/**
+ * cg2900_remove() - Remove module.
+ *
+ * @pdev:	Platform device.
+ *
+ * Returns:
+ *   0 if success.
+ *   -ENOMEM if core_info does not exist.
+ *   -EINVAL if platform data does not exist in the device.
+ */
+static int __devexit cg2900_remove(struct platform_device *pdev)
+{
+	dev_dbg(&pdev->dev, "cg2900_remove\n");
+
+	kfree(main_info);
+	main_info = NULL;
+
+	dev_info(&pdev->dev, "CG2900 Core driver removed\n");
+
+	return 0;
+}
+
+static struct platform_driver cg2900_driver = {
+	.driver = {
+		.name	= "cg2900",
+		.owner	= THIS_MODULE,
+	},
+	.probe	= cg2900_probe,
+	.remove	= __devexit_p(cg2900_remove),
+};
+
+/**
+ * cg2900_init() - Initialize module.
+ *
+ * Registers platform driver.
+ */
+static int __init cg2900_init(void)
+{
+	pr_debug("cg2900_init");
+	return platform_driver_register(&cg2900_driver);
+}
+
+/**
+ * cg2900_exit() - Remove module.
+ *
+ * Unregisters platform driver.
+ */
+static void __exit cg2900_exit(void)
+{
+	pr_debug("cg2900_exit");
+	platform_driver_unregister(&cg2900_driver);
+}
+
+module_init(cg2900_init);
+module_exit(cg2900_exit);
+
+module_param(sleep_timeout_ms, int, S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(sleep_timeout_ms,
+		 "Sleep timeout for data transmissions:\n"
+		 "\t0 = disable <default>\n"
+		 "\t>0 = sleep timeout in milliseconds");
+
+module_param_array(bd_address, byte, &bd_addr_count,
+		   S_IRUGO | S_IWUSR | S_IWGRP);
+MODULE_PARM_DESC(bd_address,
+		 "Bluetooth Device address. "
+		 "Default 0x00 0x80 0xDE 0xAD 0xBE 0xEF. "
+		 "Enter as comma separated value.");
+
+MODULE_AUTHOR("Par-Gunnar Hjalmdahl ST-Ericsson");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Linux Bluetooth HCI H:4 CG2900 Connectivity Device Driver");
diff --git a/drivers/mfd/cg2900/cg2900_core.h b/drivers/mfd/cg2900/cg2900_core.h
new file mode 100644
index 0000000..bdd951a
--- /dev/null
+++ b/drivers/mfd/cg2900/cg2900_core.h
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 GPS/BT/FM controller.
+ */
+
+#ifndef _CG2900_CORE_H_
+#define _CG2900_CORE_H_
+
+#include <linux/device.h>
+#include <linux/skbuff.h>
+
+/* Reserve 1 byte for the HCI H:4 header */
+#define HCI_H4_SIZE				1
+#define CG2900_SKB_RESERVE			HCI_H4_SIZE
+
+/* Number of bytes to reserve at start of sk_buffer when receiving packet */
+#define RX_SKB_RESERVE				8
+
+#define BT_BDADDR_SIZE				6
+
+/* Standardized Bluetooth H:4 channels */
+#define HCI_BT_CMD_H4_CHANNEL			0x01
+#define HCI_BT_ACL_H4_CHANNEL			0x02
+#define HCI_BT_SCO_H4_CHANNEL			0x03
+#define HCI_BT_EVT_H4_CHANNEL			0x04
+
+/* Default H4 channels which may change depending on connected controller */
+#define HCI_FM_RADIO_H4_CHANNEL			0x08
+#define HCI_GNSS_H4_CHANNEL			0x09
+
+/* Bluetooth error codes */
+#define HCI_BT_ERROR_NO_ERROR			0x00
+
+/* Bluetooth lengths */
+#define HCI_BT_SEND_FILE_MAX_CHUNK_SIZE		254
+
+#define LOGGER_DIRECTION_TX			0
+#define LOGGER_DIRECTION_RX			1
+
+/* module_param declared in cg2900_core.c */
+extern u8 bd_address[BT_BDADDR_SIZE];
+
+#endif /* _CG2900_CORE_H_ */
diff --git a/include/linux/mfd/cg2900.h b/include/linux/mfd/cg2900.h
new file mode 100644
index 0000000..21f683d
--- /dev/null
+++ b/include/linux/mfd/cg2900.h
@@ -0,0 +1,287 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ * Authors:
+ * Par-Gunnar Hjalmdahl (par-gunnar.p.hjalmdahl@stericsson.com) for ST-Ericsson.
+ * Henrik Possung (henrik.possung@stericsson.com) for ST-Ericsson.
+ * Josef Kindberg (josef.kindberg@stericsson.com) for ST-Ericsson.
+ * Dariusz Szymszak (dariusz.xd.szymczak@stericsson.com) for ST-Ericsson.
+ * Kjell Andersson (kjell.k.andersson@stericsson.com) for ST-Ericsson.
+ * License terms:  GNU General Public License (GPL), version 2
+ *
+ * Linux Bluetooth HCI H:4 Driver for ST-Ericsson CG2900 connectivity
+ * controller.
+ */
+
+#ifndef _CG2900_H_
+#define _CG2900_H_
+
+#include <linux/types.h>
+
+/* Perform reset. No parameters used */
+#define CG2900_CHAR_DEV_IOCTL_RESET		_IOW('U', 210, int)
+/* Check for reset */
+#define CG2900_CHAR_DEV_IOCTL_CHECK4RESET	_IOR('U', 212, int)
+/* Retrieve revision info */
+#define CG2900_CHAR_DEV_IOCTL_GET_REVISION	_IOR('U', 213, \
+						     struct cg2900_rev_data)
+
+#define CG2900_CHAR_DEV_IOCTL_EVENT_IDLE	0
+#define CG2900_CHAR_DEV_IOCTL_EVENT_RESET	1
+
+/**
+ * struct cg2900_rev_data - Contains revision data for the local controller.
+ * @revision:		Revision of the controller, e.g. to indicate that it is
+ *			a CG2900 controller.
+ * @sub_version:	Subversion of the controller, e.g. to indicate a certain
+ *			tape-out of the controller.
+ *
+ * The values to match retrieved values to each controller may be retrieved from
+ * the manufacturer.
+ */
+struct cg2900_rev_data {
+	int revision;
+	int sub_version;
+};
+
+#ifdef __KERNEL__
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/skbuff.h>
+
+/**
+ * struct cg2900_chip_rev_info - Chip info structure.
+ * @manufacturer:	Chip manufacturer.
+ * @hci_version:	Bluetooth version supported over HCI.
+ * @hci_revision:	Chip revision, i.e. which chip is this.
+ * @lmp_pal_version:	Bluetooth version supported over air.
+ * @hci_sub_version:	Chip sub-version, i.e. which tape-out is this.
+ *
+ * Note that these values match the Bluetooth Assigned Numbers,
+ * see http://www.bluetooth.org/
+ */
+struct cg2900_chip_rev_info {
+	u16	manufacturer;
+	u8	hci_version;
+	u16	hci_revision;
+	u8	lmp_pal_version;
+	u16	hci_sub_version;
+};
+
+struct cg2900_chip_dev;
+
+/**
+ * struct cg2900_id_callbacks - Chip handler identification callbacks.
+ * @check_chip_support:	Called when chip is connected. If chip is supported by
+ *			driver, return true and fill in @callbacks in @dev.
+ *
+ * Note that the callback may be NULL. It must always be NULL checked before
+ * calling.
+ */
+struct cg2900_id_callbacks {
+	bool (*check_chip_support)(struct cg2900_chip_dev *dev);
+};
+
+/**
+ * struct cg2900_chip_callbacks - Callback functions registered by chip handler.
+ * @data_from_chip:	Called when data shall be transmitted to user.
+ * @chip_removed:	Called when chip is removed.
+ *
+ * Note that some callbacks may be NULL. They must always be NULL checked before
+ * calling.
+ */
+struct cg2900_chip_callbacks {
+	void (*data_from_chip)(struct cg2900_chip_dev *dev,
+			       struct sk_buff *skb);
+	void (*chip_removed)(struct cg2900_chip_dev *dev);
+};
+
+/**
+ * struct cg2900_trans_callbacks - Callback functions registered by transport.
+ * @open:		CG2900 Core needs a transport.
+ * @close:		CG2900 Core does not need a transport.
+ * @write:		CG2900 Core transmits to the chip.
+ * @set_chip_power:	CG2900 Core enables or disables the chip.
+ * @chip_startup_finished:	CG2900 Chip startup finished notification.
+ *
+ * Note that some callbacks may be NULL. They must always be NULL checked before
+ * calling.
+ */
+struct cg2900_trans_callbacks {
+	int (*open)(struct cg2900_chip_dev *dev);
+	int (*close)(struct cg2900_chip_dev *dev);
+	int (*write)(struct cg2900_chip_dev *dev, struct sk_buff *skb);
+	void (*set_chip_power)(struct cg2900_chip_dev *dev, bool chip_on);
+	void (*chip_startup_finished)(struct cg2900_chip_dev *dev);
+};
+
+/**
+ * struct cg2900_chip_dev - Chip handler info structure.
+ * @dev:	Device associated with this chip.
+ * @pdev:	Platform device associated with this chip.
+ * @chip:	Chip info such as manufacturer.
+ * @c_cb:	Callback structure for the chip handler.
+ * @t_cb:	Callback structure for the transport.
+ * @c_data:	Arbitrary data set by chip handler.
+ * @t_data:	Arbitrary data set by transport.
+ * @b_data:	Arbitrary data set by board handler.
+ * @prv_data:	Arbitrary data set by CG2900 Core.
+ */
+struct cg2900_chip_dev {
+	struct device			*dev;
+	struct platform_device		*pdev;
+	struct cg2900_chip_rev_info	chip;
+	struct cg2900_chip_callbacks	c_cb;
+	struct cg2900_trans_callbacks	t_cb;
+	void				*c_data;
+	void				*t_data;
+	void				*b_data;
+	void				*prv_data;
+};
+
+/**
+ * enum cg2900_gpio_pull_sleep - GPIO pull setting in sleep.
+ * @CG2900_NO_PULL:	Normal input in sleep (no pull up or down).
+ * @CG2900_PULL_UP:	Pull up in sleep.
+ * @CG2900_PULL_DN:	Pull down in sleep.
+ */
+enum cg2900_gpio_pull_sleep {
+	CG2900_NO_PULL,
+	CG2900_PULL_UP,
+	CG2900_PULL_DN
+};
+
+/**
+ * struct cg2900_platform_data - Contains platform data for CG2900.
+ * @init:		Callback called upon system start.
+ * @exit:		Callback called upon system shutdown.
+ * @enable_chip:	Callback called for enabling CG2900 chip.
+ * @disable_chip:	Callback called for disabling CG2900 chip.
+ * @get_power_switch_off_cmd:	Callback called to retrieve
+ *				HCI VS_Power_Switch_Off command (command
+ *				HCI requires platform specific GPIO data).
+ * @bus:		Transport used, see @include/net/bluetooth/hci.h.
+ * @gpio_sleep:		Array of GPIO sleep settings.
+ * @enable_uart:	Callback called when switching from UART GPIO to
+ *			UART HW.
+ * @disable_uart:	Callback called when switching from UART HW to
+ *			UART GPIO.
+ * @n_uart_gpios:	Number of UART GPIOs.
+ * @uart_enabled:	Array of size @n_uart_gpios with GPIO setting for
+ *			enabling UART HW (switching from GPIO mode).
+ * @uart_disabled:	Array of size @n_uart_gpios with GPIO setting for
+ *			disabling UART HW (switching to GPIO mode).
+ * @uart:		Platform data structure for UART transport.
+ *
+ * Any callback may be NULL if not needed.
+ */
+struct cg2900_platform_data {
+	int (*init)(struct cg2900_chip_dev *dev);
+	void (*exit)(struct cg2900_chip_dev *dev);
+	void (*enable_chip)(struct cg2900_chip_dev *dev);
+	void (*disable_chip)(struct cg2900_chip_dev *dev);
+	struct sk_buff* (*get_power_switch_off_cmd)(struct cg2900_chip_dev *dev,
+						    u16 *op_code);
+
+	__u8 bus;
+	enum cg2900_gpio_pull_sleep *gpio_sleep;
+
+	struct {
+		int (*enable_uart)(struct cg2900_chip_dev *dev);
+		int (*disable_uart)(struct cg2900_chip_dev *dev);
+		int n_uart_gpios;
+		unsigned long *uart_enabled;
+		unsigned long *uart_disabled;
+	} uart;
+};
+
+/**
+ * struct cg2900_user_data - Contains platform data for CG2900 user.
+ * @dev:		Current device. Set by CG2900 user upon probe.
+ * @opened:		True if channel is opened.
+ * @user_data:		Data set and used by CG2900 user.
+ * @private_data:	Data set and used by CG2900 driver.
+ * @h4_channel:		H4 channel. Set by CG2900 driver.
+ * @is_audio:		True if this channel is an audio channel. Set by CG2900
+ *			driver.
+ * @chip_independent:	True if this channel does not require chip to be
+ *			powered. Set by CG2900 driver.
+ * @bt_bus:		Transport used, see @include/net/bluetooth/hci.h.
+ * @char_dev_name:	Name to be used for character device.
+ * @channel_data:	Input data specific to current device.
+ * @open:		Open device channel. Set by CG2900 driver.
+ * @close:		Close device channel. Set by CG2900 driver.
+ * @reset:		Reset connectivity controller. Set by CG2900 driver.
+ * @alloc_skb:		Alloc sk_buffer. Set by CG2900 driver.
+ * @write:		Write to device channel. Set by CG2900 driver.
+ * @get_local_revision:	Get revision data of conncected chip. Set by CG2900
+ *			driver.
+ * @read_cb:		Callback function called when data is received on the
+ *			device channel. Set by CG2900 user. Mandatory.
+ * @reset_cb:		Callback function called when the connectivity
+ *			controller has been reset. Set by CG2900 user.
+ *
+ * Any callback may be NULL if not needed.
+ */
+struct cg2900_user_data {
+	struct device *dev;
+	bool opened;
+
+	void *user_data;
+	void *private_data;
+
+	int	h4_channel;
+	bool	is_audio;
+	bool	chip_independent;
+
+	union {
+		__u8 bt_bus;
+		char *char_dev_name;
+	} channel_data;
+
+	int (*open)(struct cg2900_user_data *user_data);
+	void (*close)(struct cg2900_user_data *user_data);
+	int (*reset)(struct cg2900_user_data *user_data);
+	struct sk_buff * (*alloc_skb)(unsigned int size, gfp_t priority);
+	int (*write)(struct cg2900_user_data *user_data, struct sk_buff *skb);
+	bool (*get_local_revision)(struct cg2900_user_data *user_data,
+				   struct cg2900_rev_data *rev_data);
+
+	void (*read_cb)(struct cg2900_user_data *user_data,
+			struct sk_buff *skb);
+	void (*reset_cb)(struct cg2900_user_data *user_data);
+};
+
+static inline void *cg2900_get_usr(struct cg2900_user_data *dev)
+{
+	if (dev)
+		return dev->user_data;
+	return NULL;
+}
+
+static inline void cg2900_set_usr(struct cg2900_user_data *dev, void *data)
+{
+	if (dev)
+		dev->user_data = data;
+}
+
+static inline void *cg2900_get_prv(struct cg2900_user_data *dev)
+{
+	if (dev)
+		return dev->private_data;
+	return NULL;
+}
+
+static inline void cg2900_set_prv(struct cg2900_user_data *dev, void *data)
+{
+	if (dev)
+		dev->private_data = data;
+}
+
+extern int cg2900_register_chip_driver(struct cg2900_id_callbacks *cb);
+extern void cg2900_deregister_chip_driver(struct cg2900_id_callbacks *cb);
+extern int cg2900_register_trans_driver(struct cg2900_chip_dev *dev);
+extern int cg2900_deregister_trans_driver(struct cg2900_chip_dev *dev);
+extern unsigned long cg2900_get_sleep_timeout(void);
+
+#endif /* __KERNEL__ */
+#endif /* _CG2900_H_ */
-- 
1.7.3.2

