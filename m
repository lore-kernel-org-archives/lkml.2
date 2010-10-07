Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab0JGReW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 13:34:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56726 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab0JGReU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 13:34:20 -0400
From: pavan_savoy@ti.com
To: linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 1/2] drivers:bluetooth: TI_ST bluetooth driver
Date: Thu,  7 Oct 2010 14:47:16 -0400
Message-Id: <1286477237-7526-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1286477237-7526-1-git-send-email-pavan_savoy@ti.com>
References: <1286477237-7526-1-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

This is the bluetooth protocol driver for the TI WiLink7 chipsets.
Texas Instrument's WiLink chipsets combine wireless technologies
like BT, FM, GPS and WLAN onto a single chip.

This Bluetooth driver works on top of the TI_ST shared transport
line discipline driver which also allows other drivers like
FM V4L2 and GPS character driver to make use of the same UART interface.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/bluetooth/bt_ti.c |  489 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 489 insertions(+), 0 deletions(-)
 create mode 100644 drivers/bluetooth/bt_ti.c

diff --git a/drivers/bluetooth/bt_ti.c b/drivers/bluetooth/bt_ti.c
new file mode 100644
index 0000000..dffbb56
--- /dev/null
+++ b/drivers/bluetooth/bt_ti.c
@@ -0,0 +1,489 @@
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
+/* BT driver's local status */
+#define BT_DRV_RUNNING        0
+#define BT_ST_REGISTERED      1
+
+/**
+ * struct hci_st - BT driver operation structure
+ * @hdev: hci device pointer which binds to bt driver
+ * @flags: used locally,to maintain various BT driver status
+ * @streg_cbdata: to hold ST registration callback status
+ * @st_write: write function pointer of ST driver
+ * @wait_for_btdrv_reg_completion - completion sync between hci_st_open
+ *	and hci_st_registration_completion_cb.
+ */
+struct hci_st {
+	struct hci_dev *hdev;
+	unsigned long flags;
+	char streg_cbdata;
+	long (*st_write) (struct sk_buff *);
+	struct completion wait_for_btdrv_reg_completion;
+};
+
+static int reset;
+
+/* Increments HCI counters based on pocket ID (cmd,acl,sco) */
+static inline void hci_st_tx_complete(struct hci_st *hst, int pkt_type)
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
+		hdev->stat.cmd_tx++;
+		break;
+	}
+}
+
+/* ------- Interfaces to Shared Transport ------ */
+
+/* Called by ST layer to indicate protocol registration completion
+ * status.hci_st_open() function will wait for signal from this
+ * API when st_register() function returns ST_PENDING.
+ */
+static void hci_st_registration_completion_cb(void *priv_data, char data)
+{
+	struct hci_st *lhst = (struct hci_st *)priv_data;
+	/* hci_st_open() function needs value of 'data' to know
+	 * the registration status(success/fail),So have a back
+	 * up of it.
+	 */
+	lhst->streg_cbdata = data;
+
+	/* Got a feedback from ST for BT driver registration
+	 * request.Wackup hci_st_open() function to continue
+	 * it's open operation.
+	 */
+	complete(&lhst->wait_for_btdrv_reg_completion);
+}
+
+/* Called by Shared Transport layer when receive data is
+ * available */
+static long hci_st_receive(void *priv_data, struct sk_buff *skb)
+{
+	int err;
+	int len;
+	struct hci_st *lhst = (struct hci_st *)priv_data;
+
+	err = 0;
+	len = 0;
+
+	if (skb == NULL) {
+		BT_ERR("Invalid SKB received from ST");
+		return -EFAULT;
+	}
+	if (!lhst) {
+		kfree_skb(skb);
+		BT_ERR("Invalid hci_st memory,freeing SKB");
+		return -EFAULT;
+	}
+	if (!test_bit(BT_DRV_RUNNING, &lhst->flags)) {
+		kfree_skb(skb);
+		BT_ERR("Device is not running,freeing SKB");
+		return -EINVAL;
+	}
+
+	len = skb->len;
+	skb->dev = (struct net_device *)lhst->hdev;
+
+	/* Forward skb to HCI CORE layer */
+	err = hci_recv_frame(skb);
+	if (err) {
+		kfree_skb(skb);
+		BT_ERR("Unable to push skb to HCI CORE(%d),freeing SKB",
+				err);
+		return err;
+	}
+	lhst->hdev->stat.byte_rx += len;
+
+	return 0;
+}
+
+/* ------- Interfaces to HCI layer ------ */
+
+/* Called from HCI core to initialize the device */
+static int hci_st_open(struct hci_dev *hdev)
+{
+	static struct st_proto_s hci_st_proto;
+	unsigned long timeleft;
+	struct hci_st *hst;
+	int err;
+	err = 0;
+
+	BT_DBG("%s %p", hdev->name, hdev);
+	hst = hdev->driver_data;
+
+	/* Populate BT driver info required by ST */
+	memset(&hci_st_proto, 0, sizeof(hci_st_proto));
+
+	/* BT driver ID */
+	hci_st_proto.type = ST_BT;
+
+	/* Receive function which called from ST */
+	hci_st_proto.recv = hci_st_receive;
+
+	/* Packet match function may used in future */
+	hci_st_proto.match_packet = NULL;
+
+	/* Callback to be called when registration is pending */
+	hci_st_proto.reg_complete_cb = hci_st_registration_completion_cb;
+
+	/* This is write function pointer of ST. BT driver will make use of this
+	 * for sending any packets to chip. ST will assign and give to us, so
+	 * make it as NULL */
+	hci_st_proto.write = NULL;
+
+	/* send in the hst to be received at registration complete callback
+	 * and during st's receive
+	 */
+	hci_st_proto.priv_data = hst;
+
+	/* Register with ST layer */
+	err = st_register(&hci_st_proto);
+	if (err == -EINPROGRESS) {
+		/* Prepare wait-for-completion handler data structures.
+		 * Needed to syncronize this and st_registration_completion_cb()
+		 * functions.
+		 */
+		init_completion(&hst->wait_for_btdrv_reg_completion);
+
+		/* Reset ST registration callback status flag , this value
+		 * will be updated in hci_st_registration_completion_cb()
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
+	if (hci_st_proto.write != NULL) {
+		/* We need this pointer for sending any Bluetooth pkts */
+		hst->st_write = hci_st_proto.write;
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
+
+	/* Registration with ST successful */
+	set_bit(BT_ST_REGISTERED, &hst->flags);
+
+	return err;
+}
+
+/* Close device */
+static int hci_st_close(struct hci_dev *hdev)
+{
+	int err;
+	struct hci_st *hst;
+	err = 0;
+
+	hst = hdev->driver_data;
+	/* Unregister from ST layer */
+	if (test_and_clear_bit(BT_ST_REGISTERED, &hst->flags)) {
+		err = st_unregister(ST_BT);
+		if (err != 0) {
+			BT_ERR("st_unregister failed %d", err);
+			return -EBUSY;
+		}
+	}
+
+	hst->st_write = NULL;
+
+	/* ST layer would have moved chip to inactive state.
+	 * So,clear HCI device RUNNING flag.
+	 */
+	if (!test_and_clear_bit(HCI_RUNNING, &hdev->flags))
+		return 0;
+
+	return err;
+}
+
+/* Called from HCI CORE , Sends frames to Shared Transport */
+static int hci_st_send_frame(struct sk_buff *skb)
+{
+	struct hci_dev *hdev;
+	struct hci_st *hst;
+	long len;
+
+	if (skb == NULL) {
+		BT_ERR("Invalid skb received from HCI CORE");
+		return -ENOMEM;
+	}
+	hdev = (struct hci_dev *)skb->dev;
+	if (!hdev) {
+		BT_ERR("SKB received for invalid HCI Device (hdev=NULL)");
+		return -ENODEV;
+	}
+	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
+		BT_ERR("Device is not running");
+		return -EBUSY;
+	}
+
+	hst = (struct hci_st *)hdev->driver_data;
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
+	len = hst->st_write(skb);
+	if (len < 0) {
+		/* Something went wrong in st write , free skb memory */
+		kfree_skb(skb);
+		BT_ERR(" ST write failed (%ld)", len);
+		return -EAGAIN;
+	}
+
+	/* ST accepted our skb. So, Go ahead and do rest */
+	hdev->stat.byte_tx += len;
+	hci_st_tx_complete(hst, bt_cb(skb)->pkt_type);
+
+	return 0;
+}
+
+static void hci_st_destruct(struct hci_dev *hdev)
+{
+	if (!hdev) {
+		BT_ERR("Destruct called with invalid HCI Device"
+				"(hdev=NULL)");
+		return;
+	}
+
+	BT_DBG("%s", hdev->name);
+
+	/* free hci_st memory */
+	if (hdev->driver_data != NULL)
+		kfree(hdev->driver_data);
+
+	return;
+}
+
+/* Creates new HCI device */
+static int hci_st_register_dev(struct hci_st *hst)
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
+	hdev->open = hci_st_open;
+	hdev->close = hci_st_close;
+	hdev->flush = NULL;
+	hdev->send = hci_st_send_frame;
+	hdev->destruct = hci_st_destruct;
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
+	static struct hci_st *hst;
+	err = 0;
+
+	BT_DBG(" Bluetooth Driver Version %s", VERSION);
+
+	/* Allocate local resource memory */
+	hst = kzalloc(sizeof(struct hci_st), GFP_KERNEL);
+	if (!hst) {
+		BT_ERR("Can't allocate control structure");
+		return -ENFILE;
+	}
+
+	/* Expose "hciX" device to user space */
+	err = hci_st_register_dev(hst);
+	if (err) {
+		/* Release local resource memory */
+		kfree(hst);
+
+		BT_ERR("Unable to expose hci0 device(%d)", err);
+		return err;
+	}
+	set_bit(BT_DRV_RUNNING, &hst->flags);
+	dev_set_drvdata(&pdev->dev, hst);
+	return err;
+}
+
+static int bt_ti_remove(struct platform_device *pdev)
+{
+	struct hci_st *hst;
+
+	hst = dev_get_drvdata(&pdev->dev);
+	/* Deallocate local resource's memory  */
+	if (hst) {
+		struct hci_dev *hdev = hst->hdev;
+		if (hdev == NULL) {
+			BT_ERR("Invalid hdev memory");
+			kfree(hst);
+		} else {
+			hci_st_close(hdev);
+			if (test_and_clear_bit(BT_DRV_RUNNING, &hst->flags)) {
+				/* Remove HCI device (hciX) created
+				 * in module init.
+				 */
+				hci_unregister_dev(hdev);
+				/* Free HCI device memory */
+				hci_free_dev(hdev);
+			}
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

