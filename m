Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab0JKPUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 11:20:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40566 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab0JKPUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 11:20:30 -0400
From: pavan_savoy@ti.com
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] Bluetooth: TI_ST bluetooth driver
Date: Mon, 11 Oct 2010 12:33:23 -0400
Message-Id: <1286814803-6740-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

Gustavo, Marcel,

I have taken care of most of the comments which you provided.
Couple of them like usage of goto's, I didn't handle since
I am not doing much error handling repeatedly there.

I have also removed the 2 states like _REGISTERED, _RUNNING which
were not required and the flags associated with it.
I have taken care of other style comments.

Please review and provide your comments,

-- patch description --

This is the bluetooth protocol driver for the TI WiLink7 chipsets.
Texas Instrument's WiLink chipsets combine wireless technologies
like BT, FM, GPS and WLAN onto a single chip.

This Bluetooth driver works on top of the TI_ST shared transport
line discipline driver which also allows other drivers like
FM V4L2 and GPS character driver to make use of the same UART interface.

Kconfig and Makefile modifications to enable the Bluetooth
driver for Texas Instrument's WiLink 7 chipset.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/bluetooth/Kconfig    |   10 +
 drivers/bluetooth/Makefile   |    1 +
 drivers/bluetooth/btwilink.c |  455 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 466 insertions(+), 0 deletions(-)
 create mode 100644 drivers/bluetooth/btwilink.c

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 02deef4..e0d67dd 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -219,4 +219,14 @@ config BT_ATH3K
 	  Say Y here to compile support for "Atheros firmware download driver"
 	  into the kernel or say M to compile it as module (ath3k).
 
+config BT_WILINK
+	tristate "BlueZ bluetooth driver for TI ST"
+	depends on TI_ST
+	help
+	  This enables the Bluetooth driver for Texas Instrument's BT/FM/GPS
+	  combo devices. This makes use of shared transport line discipline
+	  core driver to communicate with the BT core of the combo chip.
+
+	  Say Y here to compile support for Texas Instrument's WiLink7 driver
+	  into the kernel or say M to compile it as module.
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index 71bdf13..5351b62 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -28,3 +28,4 @@ hci_uart-$(CONFIG_BT_HCIUART_BCSP)	+= hci_bcsp.o
 hci_uart-$(CONFIG_BT_HCIUART_LL)	+= hci_ll.o
 hci_uart-$(CONFIG_BT_HCIUART_ATH3K)	+= hci_ath.o
 hci_uart-objs				:= $(hci_uart-y)
+obj-$(CONFIG_BT_WILINK)			:= btwilink.o
diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
new file mode 100644
index 0000000..e0bde79
--- /dev/null
+++ b/drivers/bluetooth/btwilink.c
@@ -0,0 +1,455 @@
+/*
+ *  Texas Instrument's Bluetooth Driver For Shared Transport.
+ *
+ *  Bluetooth Driver acts as interface between HCI CORE and
+ *  TI Shared Transport Layer.
+ *
+ *  Copyright (C) 2009-2010 Texas Instruments
+ *  Author: Raja Mani <raja_mani@ti.com>
+ *	Pavan Savoy <pavan_savoy@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/platform_device.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+#include <linux/ti_wilink_st.h>
+
+/* Bluetooth Driver Version */
+#define VERSION               "1.0"
+
+/* Defines number of seconds to wait for reg completion
+ * callback getting called from ST (in case,registration
+ * with ST returns PENDING status)
+ */
+#define BT_REGISTER_TIMEOUT   6000	/* 6 sec */
+
+/**
+ * struct ti_st - BT driver operation structure
+ * @hdev: hci device pointer which binds to bt driver
+ * @flags: used locally,to maintain various BT driver status
+ * @streg_cbdata: to hold ST registration callback status
+ * @st_write: write function pointer of ST driver
+ * @wait_for_btdrv_reg_completion - completion sync between ti_st_open
+ *	and ti_st_registration_completion_cb.
+ */
+struct ti_st {
+	struct hci_dev *hdev;
+	char streg_cbdata;
+	long (*st_write) (struct sk_buff *);
+	struct completion wait_for_btdrv_reg_completion;
+};
+
+static int reset;
+
+/* Increments HCI counters based on pocket ID (cmd,acl,sco) */
+static inline void ti_st_tx_complete(struct ti_st *hst, int pkt_type)
+{
+	struct hci_dev *hdev;
+	hdev = hst->hdev;
+
+	/* Update HCI stat counters */
+	switch (pkt_type) {
+	case HCI_COMMAND_PKT:
+		hdev->stat.cmd_tx++;
+		break;
+
+	case HCI_ACLDATA_PKT:
+		hdev->stat.acl_tx++;
+		break;
+
+	case HCI_SCODATA_PKT:
+		hdev->stat.sco_tx++;
+		break;
+	}
+}
+
+/* ------- Interfaces to Shared Transport ------ */
+
+/* Called by ST layer to indicate protocol registration completion
+ * status.ti_st_open() function will wait for signal from this
+ * API when st_register() function returns ST_PENDING.
+ */
+static void st_registration_completion_cb(void *priv_data, char data)
+{
+	struct ti_st *lhst = (struct ti_st *)priv_data;
+	/* ti_st_open() function needs value of 'data' to know
+	 * the registration status(success/fail),So have a back
+	 * up of it.
+	 */
+	lhst->streg_cbdata = data;
+
+	/* Got a feedback from ST for BT driver registration
+	 * request.Wackup ti_st_open() function to continue
+	 * it's open operation.
+	 */
+	complete(&lhst->wait_for_btdrv_reg_completion);
+}
+
+/* Called by Shared Transport layer when receive data is
+ * available */
+static long st_receive(void *priv_data, struct sk_buff *skb)
+{
+	int err;
+	struct ti_st *lhst = (struct ti_st *)priv_data;
+
+	if (skb == NULL) {
+		BT_ERR("Invalid SKB received from ST");
+		return -EFAULT;
+	}
+
+	if (!lhst) {
+		kfree_skb(skb);
+		BT_ERR("Invalid ti_st memory,freeing SKB");
+		return -EFAULT;
+	}
+
+	skb->dev = (struct net_device *)lhst->hdev;
+	/* Forward skb to HCI CORE layer */
+	err = hci_recv_frame(skb);
+	if (err) {
+		kfree_skb(skb);
+		BT_ERR("Unable to push skb to HCI CORE(%d),freeing SKB",
+				err);
+		return err;
+	}
+
+	lhst->hdev->stat.byte_rx += skb->len;
+	return 0;
+}
+
+/* ------- Interfaces to HCI layer ------ */
+
+/* Called from HCI core to initialize the device */
+static int ti_st_open(struct hci_dev *hdev)
+{
+	static struct st_proto_s ti_st_proto;
+	unsigned long timeleft;
+	struct ti_st *hst;
+	int err;
+	err = 0;
+
+	BT_DBG("%s %p", hdev->name, hdev);
+	hst = hdev->driver_data;
+
+	/* Populate BT driver info required by ST */
+	memset(&ti_st_proto, 0, sizeof(ti_st_proto));
+
+	/* BT driver ID */
+	ti_st_proto.type = ST_BT;
+
+	/* Receive function which called from ST */
+	ti_st_proto.recv = st_receive;
+
+	/* Callback to be called when registration is pending */
+	ti_st_proto.reg_complete_cb = st_registration_completion_cb;
+
+	/* send in the hst to be received at registration complete callback
+	 * and during st's receive
+	 */
+	ti_st_proto.priv_data = hst;
+
+	/* Register with ST layer */
+	err = st_register(&ti_st_proto);
+	if (err == -EINPROGRESS) {
+		/* Prepare wait-for-completion handler data structures.
+		 * Needed to syncronize this and st_registration_completion_cb()
+		 * functions.
+		 */
+		init_completion(&hst->wait_for_btdrv_reg_completion);
+
+		/* Reset ST registration callback status flag , this value
+		 * will be updated in ti_st_registration_completion_cb()
+		 * function whenever it called from ST driver.
+		 */
+		hst->streg_cbdata = -EINPROGRESS;
+
+		/* ST is busy with other protocol registration(may be busy with
+		 * firmware download).So,Wait till the registration callback
+		 * (passed as a argument to st_register() function) getting
+		 * called from ST.
+		 */
+		BT_DBG(" %s waiting for reg completion signal from ST",
+				__func__);
+
+		timeleft =
+			wait_for_completion_timeout
+			(&hst->wait_for_btdrv_reg_completion,
+			 msecs_to_jiffies(BT_REGISTER_TIMEOUT));
+		if (!timeleft) {
+			BT_ERR("Timeout(%d sec),didn't get reg"
+					"completion signal from ST",
+					BT_REGISTER_TIMEOUT / 1000);
+			return -ETIMEDOUT;
+		}
+
+		/* Is ST registration callback called with ERROR value? */
+		if (hst->streg_cbdata != 0) {
+			BT_ERR("ST reg completion CB called with invalid"
+					"status %d", hst->streg_cbdata);
+			return -EAGAIN;
+		}
+		err = 0;
+	} else if (err == -1) {
+		BT_ERR("st_register failed %d", err);
+		return -EAGAIN;
+	}
+
+	/* Do we have proper ST write function? */
+	if (ti_st_proto.write != NULL) {
+		/* We need this pointer for sending any Bluetooth pkts */
+		hst->st_write = ti_st_proto.write;
+	} else {
+		BT_ERR("failed to get ST write func pointer");
+
+		/* Undo registration with ST */
+		err = st_unregister(ST_BT);
+		if (err < 0)
+			BT_ERR("st_unregister failed %d", err);
+
+		hst->st_write = NULL;
+		return -EAGAIN;
+	}
+
+	/* Registration with ST layer is completed successfully,
+	 * now chip is ready to accept commands from HCI CORE.
+	 * Mark HCI Device flag as RUNNING
+	 */
+	set_bit(HCI_RUNNING, &hdev->flags);
+	return err;
+}
+
+/* Close device */
+static int ti_st_close(struct hci_dev *hdev)
+{
+	int err = 0;
+	struct ti_st *hst;
+
+	hst = hdev->driver_data;
+
+	/* Clear HCI device RUNNING flag */
+	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
+		BT_ERR("HCI not RUNNING?");
+
+	/* continue to unregister from transport */
+	err = st_unregister(ST_BT);
+	if (err != 0) {
+		hst->st_write = NULL;
+		BT_ERR("st_unregister failed %d", err);
+		return -EBUSY;
+	}
+
+	hst->st_write = NULL;
+	return err;
+}
+
+/* Called from HCI CORE , Sends frames to Shared Transport */
+static int ti_st_send_frame(struct sk_buff *skb)
+{
+	struct hci_dev *hdev;
+	struct ti_st *hst;
+	long len;
+
+	if (skb == NULL) {
+		BT_ERR("Invalid skb received from HCI CORE");
+		return -ENOMEM;
+	}
+
+	hdev = (struct hci_dev *)skb->dev;
+	if (!hdev) {
+		BT_ERR("SKB received for invalid HCI Device (hdev=NULL)");
+		return -ENODEV;
+	}
+
+	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
+		BT_ERR("Device is not running");
+		return -EBUSY;
+	}
+
+	hst = (struct ti_st *)hdev->driver_data;
+
+	/* Prepend skb with frame type */
+	memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);
+
+	BT_DBG(" %s: type %d len %d", hdev->name, bt_cb(skb)->pkt_type,
+			skb->len);
+
+	/* Insert skb to shared transport layer's transmit queue.
+	 * Freeing skb memory is taken care in shared transport layer,
+	 * so don't free skb memory here.
+	 */
+	if (!hst->st_write) {
+		kfree_skb(skb);
+		BT_ERR(" Can't write to ST, st_write null?");
+		return -EAGAIN;
+	}
+
+	len = hst->st_write(skb);
+	if (len < 0) {
+		kfree_skb(skb);
+		BT_ERR(" ST write failed (%ld)", len);
+		return -EAGAIN;
+	}
+
+	/* ST accepted our skb. So, Go ahead and do rest */
+	hdev->stat.byte_tx += len;
+	ti_st_tx_complete(hst, bt_cb(skb)->pkt_type);
+
+	return 0;
+}
+
+static void ti_st_destruct(struct hci_dev *hdev)
+{
+	if (!hdev) {
+		BT_ERR("Destruct called with invalid HCI Device"
+				"(hdev=NULL)");
+		return;
+	}
+
+	BT_DBG("%s", hdev->name);
+
+	/* free ti_st memory */
+	if (hdev->driver_data != NULL)
+		kfree(hdev->driver_data);
+
+	return;
+}
+
+/* Creates new HCI device */
+static int ti_st_register_dev(struct ti_st *hst)
+{
+	struct hci_dev *hdev;
+
+	/* Initialize and register HCI device */
+	hdev = hci_alloc_dev();
+	if (!hdev) {
+		BT_ERR("Can't allocate HCI device");
+		return -ENOMEM;
+	}
+	BT_DBG(" HCI device allocated. hdev= %p", hdev);
+
+	hst->hdev = hdev;
+	hdev->bus = HCI_UART;
+	hdev->driver_data = hst;
+	hdev->open = ti_st_open;
+	hdev->close = ti_st_close;
+	hdev->flush = NULL;
+	hdev->send = ti_st_send_frame;
+	hdev->destruct = ti_st_destruct;
+	hdev->owner = THIS_MODULE;
+
+	if (reset)
+		set_bit(HCI_QUIRK_NO_RESET, &hdev->quirks);
+
+	if (hci_register_dev(hdev) < 0) {
+		BT_ERR("Can't register HCI device");
+		hci_free_dev(hdev);
+		return -ENODEV;
+	}
+
+	BT_DBG(" HCI device registered. hdev= %p", hdev);
+	return 0;
+}
+
+
+static int bt_ti_probe(struct platform_device *pdev)
+{
+	int err;
+	static struct ti_st *hst;
+	err = 0;
+
+	BT_DBG(" Bluetooth Driver Version %s", VERSION);
+
+	/* Allocate local resource memory */
+	hst = kzalloc(sizeof(struct ti_st), GFP_KERNEL);
+	if (!hst) {
+		BT_ERR("Can't allocate control structure");
+		return -ENFILE;
+	}
+
+	/* Expose "hciX" device to user space */
+	err = ti_st_register_dev(hst);
+	if (err) {
+		/* Release local resource memory */
+		kfree(hst);
+
+		BT_ERR("Unable to expose hci0 device(%d)", err);
+		return err;
+	}
+
+	dev_set_drvdata(&pdev->dev, hst);
+	return err;
+}
+
+static int bt_ti_remove(struct platform_device *pdev)
+{
+	struct ti_st *hst;
+
+	hst = dev_get_drvdata(&pdev->dev);
+	/* Deallocate local resource's memory  */
+	if (hst) {
+		struct hci_dev *hdev = hst->hdev;
+		if (hdev == NULL) {
+			BT_ERR("Invalid hdev memory");
+			kfree(hst);
+		} else {
+			ti_st_close(hdev);
+			hci_unregister_dev(hdev);
+			/* Free HCI device memory */
+			hci_free_dev(hdev);
+		}
+	}
+	return 0;
+}
+
+static struct platform_driver bt_ti_driver = {
+	.probe = bt_ti_probe,
+	.remove = bt_ti_remove,
+	.driver = {
+		.name = "ti_st_bluetooth",
+		.owner = THIS_MODULE,
+	},
+};
+
+/* ------- Module Init/Exit interfaces ------ */
+static int __init bt_drv_init(void)
+{
+	long ret = 0;
+	ret = platform_driver_register(&bt_ti_driver);
+	if (ret != 0) {
+		BT_ERR("bt_ti platform drv registration failed");
+		return -1;
+	}
+	return 0;
+}
+
+static void __exit bt_drv_exit(void)
+{
+	platform_driver_unregister(&bt_ti_driver);
+}
+
+module_init(bt_drv_init);
+module_exit(bt_drv_exit);
+
+/* ------ Module Info ------ */
+
+module_param(reset, bool, 0644);
+MODULE_PARM_DESC(reset, "Send HCI reset command on initialization");
+MODULE_AUTHOR("Raja Mani <raja_mani@ti.com>");
+MODULE_DESCRIPTION("Bluetooth Driver for TI Shared Transport" VERSION);
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL");
-- 
1.6.5

