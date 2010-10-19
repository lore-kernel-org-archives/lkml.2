Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab0JSUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:53:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab0JSUxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:53:44 -0400
From: pavan_savoy@ti.com
To: padovan@profusion.mobi, marcel@holtmann.org
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v4] Bluetooth: btwilink driver
Date: Tue, 19 Oct 2010 18:06:15 -0400
Message-Id: <1287525975-17187-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

v4 comments

module init now returns what platform_driver_register returns.
type casting of void* private data has been removed

v3 comments

Lizardo,
I have taken care of most of the comments you had.
Have re-wrote some of the code commenting you've mentioned.
Thanks for the comments,

Marcel, Gustavo, & list,
Please review this version of patch.

The other few like -EPERM for platform driver registration is to keep
it similar to other drivers, type casting is maintained just to feel safe
and have style similar to other drivers.
BT_WILINK in Kconfig is similar to BT_MRVL.
I hope those aren't too critical.

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
 drivers/bluetooth/btwilink.c |  411 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 422 insertions(+), 0 deletions(-)
 create mode 100644 drivers/bluetooth/btwilink.c

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 02deef4..8e0de9a 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -219,4 +219,14 @@ config BT_ATH3K
 	  Say Y here to compile support for "Atheros firmware download driver"
 	  into the kernel or say M to compile it as module (ath3k).
 
+config BT_WILINK
+	tristate "Texas Instruments WiLink7 driver"
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
index 71bdf13..f4460f4 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_BT_HCIBTSDIO)	+= btsdio.o
 obj-$(CONFIG_BT_ATH3K)		+= ath3k.o
 obj-$(CONFIG_BT_MRVL)		+= btmrvl.o
 obj-$(CONFIG_BT_MRVL_SDIO)	+= btmrvl_sdio.o
+obj-$(CONFIG_BT_WILINK)		+= btwilink.o
 
 btmrvl-y			:= btmrvl_main.o
 btmrvl-$(CONFIG_DEBUG_FS)	+= btmrvl_debugfs.o
diff --git a/drivers/bluetooth/btwilink.c b/drivers/bluetooth/btwilink.c
new file mode 100644
index 0000000..218efd6
--- /dev/null
+++ b/drivers/bluetooth/btwilink.c
@@ -0,0 +1,411 @@
+/*
+ *  Texas Instrument's Bluetooth Driver For Shared Transport.
+ *
+ *  Bluetooth Driver acts as interface between HCI core and
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
+/* Number of seconds to wait for registration completion
+ * when ST returns PENDING status.
+ */
+#define BT_REGISTER_TIMEOUT   6000	/* 6 sec */
+
+/**
+ * struct ti_st - driver operation structure
+ * @hdev: hci device pointer which binds to bt driver
+ * @reg_status: ST registration callback status
+ * @st_write: write function provided by the ST driver
+ *	to be used by the driver during send_frame.
+ * @wait_reg_completion - completion sync between ti_st_open
+ *	and ti_st_registration_completion_cb.
+ */
+struct ti_st {
+	struct hci_dev *hdev;
+	char reg_status;
+	long (*st_write) (struct sk_buff *);
+	struct completion wait_reg_completion;
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
+	struct ti_st *lhst = priv_data;
+
+	/* Save registration status for use in ti_st_open() */
+	lhst->reg_status = data;
+	/* complete the wait in ti_st_open() */
+	complete(&lhst->wait_reg_completion);
+}
+
+/* Called by Shared Transport layer when receive data is
+ * available */
+static long st_receive(void *priv_data, struct sk_buff *skb)
+{
+	int err;
+	struct ti_st *lhst = priv_data;
+
+	if (!skb)
+		return -EFAULT;
+
+	if (!lhst) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+
+	skb->dev = (struct net_device *)lhst->hdev;
+
+	/* Forward skb to HCI core layer */
+	err = hci_recv_frame(skb);
+	if (err) {
+		kfree_skb(skb);
+		BT_ERR("Unable to push skb to HCI core(%d)", err);
+		return err;
+	}
+
+	lhst->hdev->stat.byte_rx += skb->len;
+
+	return 0;
+}
+
+/* ------- Interfaces to HCI layer ------ */
+/* protocol structure registered with shared transport */
+static struct st_proto_s ti_st_proto = {
+	.type = ST_BT,
+	.recv = st_receive,
+	.reg_complete_cb = st_registration_completion_cb,
+	.priv_data = NULL,
+};
+
+/* Called from HCI core to initialize the device */
+static int ti_st_open(struct hci_dev *hdev)
+{
+	unsigned long timeleft;
+	struct ti_st *hst;
+	int err;
+
+	BT_DBG("%s %p", hdev->name, hdev);
+
+	/* provide contexts for callbacks from ST */
+	hst = hdev->driver_data;
+	ti_st_proto.priv_data = hst;
+
+	err = st_register(&ti_st_proto);
+	if (err == -EINPROGRESS) {
+		/* Prepare wait-for-completion handler data structures.
+		 * Needed to synchronize this and
+		 * st_registration_completion_cb() functions.
+		 */
+		init_completion(&hst->wait_reg_completion);
+
+		/* Reset ST registration callback status flag , this value
+		 * will be updated in ti_st_registration_completion_cb()
+		 * function whenever it called from ST driver.
+		 */
+		hst->reg_status = -EINPROGRESS;
+
+		/* ST is busy with either protocol registration or firmware
+		 * download. Wait until the registration callback is called
+		 */
+		BT_DBG(" waiting for registration completion signal from ST");
+
+		timeleft = wait_for_completion_timeout
+			(&hst->wait_reg_completion,
+			 msecs_to_jiffies(BT_REGISTER_TIMEOUT));
+		if (!timeleft) {
+			BT_ERR("Timeout(%d sec),didn't get reg "
+					"completion signal from ST",
+					BT_REGISTER_TIMEOUT / 1000);
+			return -ETIMEDOUT;
+		}
+
+		/* Is ST registration callback called with ERROR status? */
+		if (hst->reg_status != 0) {
+			BT_ERR("ST registration completed with invalid "
+					"status %d", hst->reg_status);
+			return -EAGAIN;
+		}
+		err = 0;
+	} else if (err == -EPERM) {
+		BT_ERR("st_register failed %d", err);
+		return err;
+	}
+
+	hst->st_write = ti_st_proto.write;
+	if (!hst->st_write) {
+		BT_ERR("undefined ST write function");
+
+		/* Undo registration with ST */
+		err = st_unregister(ST_BT);
+		if (err)
+			BT_ERR("st_unregister() failed with error %d", err);
+
+		hst->st_write = NULL;
+		return err;
+	}
+
+	/* Registration with ST layer is successful,
+	 * hardware is ready to accept commands from HCI core.
+	 */
+	set_bit(HCI_RUNNING, &hdev->flags);
+
+	return err;
+}
+
+/* Close device */
+static int ti_st_close(struct hci_dev *hdev)
+{
+	int err;
+	struct ti_st *hst = hdev->driver_data;
+
+	/* continue to unregister from transport */
+	err = st_unregister(ST_BT);
+	if (err)
+		BT_ERR("st_unregister() failed with error %d", err);
+
+	hst->st_write = NULL;
+
+	return err;
+}
+
+static int ti_st_send_frame(struct sk_buff *skb)
+{
+	struct hci_dev *hdev;
+	struct ti_st *hst;
+	long len;
+
+	if (!skb)
+		return -ENOMEM;
+
+	hdev = (struct hci_dev *)skb->dev;
+	if (!hdev)
+		return -ENODEV;
+
+	if (!test_bit(HCI_RUNNING, &hdev->flags))
+		return -EBUSY;
+
+	hst = hdev->driver_data;
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
+		BT_ERR(" Could not write to ST (st_write is NULL)");
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
+	if (!hdev)
+		return;
+
+	BT_DBG("%s", hdev->name);
+
+	/* free ti_st memory */
+	kfree(hdev->driver_data);
+
+	return;
+}
+
+/* Creates new HCI device */
+static int ti_st_register_dev(struct ti_st *hst)
+{
+	int err;
+	struct hci_dev *hdev;
+
+	/* Initialize and register HCI device */
+	hdev = hci_alloc_dev();
+	if (!hdev)
+		return -ENOMEM;
+
+	BT_DBG("hdev %p", hdev);
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
+	err = hci_register_dev(hdev);
+	if (err < 0) {
+		BT_ERR("Can't register HCI device error %d", err);
+		hci_free_dev(hdev);
+		return err;
+	}
+
+	BT_DBG(" HCI device registered (hdev %p)", hdev);
+	return 0;
+}
+
+
+static int bt_ti_probe(struct platform_device *pdev)
+{
+	int err;
+	static struct ti_st *hst;
+
+	BT_DBG(" Bluetooth Driver Version %s", VERSION);
+
+	hst = kzalloc(sizeof(struct ti_st), GFP_KERNEL);
+	if (!hst)
+		return -ENOMEM;
+
+	/* Expose "hciX" device to user space */
+	err = ti_st_register_dev(hst);
+	if (err) {
+		kfree(hst);
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
+	struct hci_dev *hdev;
+
+	hst = dev_get_drvdata(&pdev->dev);
+
+	if (!hst)
+		return -EFAULT;
+
+	/* Deallocate local resource's memory  */
+	hdev = hst->hdev;
+
+	if (!hdev) {
+		BT_ERR("Invalid hdev memory");
+		kfree(hst);
+		return -EFAULT;
+	}
+
+	ti_st_close(hdev);
+	hci_unregister_dev(hdev);
+	/* Free HCI device memory */
+	hci_free_dev(hdev);
+
+	return 0;
+}
+
+static struct platform_driver btwilink_driver = {
+	.probe = bt_ti_probe,
+	.remove = bt_ti_remove,
+	.driver = {
+		.name = "btwilink",
+		.owner = THIS_MODULE,
+	},
+};
+
+/* ------- Module Init/Exit interfaces ------ */
+static int __init bt_drv_init(void)
+{
+	long ret;
+
+	ret = platform_driver_register(&btwilink_driver);
+	if (ret != 0) {
+		BT_ERR("btwilink platform driver registration failed");
+		return ret;
+	}
+	return 0;
+}
+
+static void __exit bt_drv_exit(void)
+{
+	platform_driver_unregister(&btwilink_driver);
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

