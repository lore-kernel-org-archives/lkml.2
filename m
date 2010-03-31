Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab0CaTmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 15:42:14 -0400
Received: from 152.Red-88-2-254.staticIP.rima-tde.net ([88.2.254.152]:53951
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756585Ab0CaTmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 15:42:12 -0400
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org, oliver@neukum.org,
       linville@tuxdriver.com, j.dumon@option.com, steve.glendinning@smsc.com,
       davem@davemloft.net, gregkh@suse.de, dgiagio@gmail.com,
       dborca@yahoo.com
Subject: [PATCHv3] drivers/net/usb: Add new driver ipheth
Date: Wed, 31 Mar 2010 21:42:07 +0200
Message-Id: <1270064527-8485-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Diego Giagio <diego@giagio.com>

Add new driver to use tethering with an iPhone device.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/net/usb/Kconfig  |   12 +
 drivers/net/usb/Makefile |    1 +
 drivers/net/usb/ipheth.c |  573 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 586 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/usb/ipheth.c

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index ba56ce4..63be4ca 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -385,4 +385,16 @@ config USB_CDC_PHONET
 	  cellular modem, as found on most Nokia handsets with the
 	  "PC suite" USB profile.
 
+config USB_IPHETH
+	tristate "Apple iPhone USB Ethernet driver"
+	default n
+	---help---
+	  Module used to share Internet connection (tethering) from your
+	  iPhone (Original, 3G and 3GS) to your system.
+	  Note that you need userspace libraries and programs that are needed
+	  to pair your device with your system and that understand the iPhone
+	  protocol.
+
+	  For more information: http://giagio.com/wiki/moin.cgi/iPhoneEthernetDriver
+
 endmenu
diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 82ea629..edb09c0 100644
--- a/drivers/net/usb/Makefile
+++ b/drivers/net/usb/Makefile
@@ -23,4 +23,5 @@ obj-$(CONFIG_USB_NET_MCS7830)	+= mcs7830.o
 obj-$(CONFIG_USB_USBNET)	+= usbnet.o
 obj-$(CONFIG_USB_NET_INT51X1)	+= int51x1.o
 obj-$(CONFIG_USB_CDC_PHONET)	+= cdc-phonet.o
+obj-$(CONFIG_USB_IPHETH)	+= ipheth.o
 
diff --git a/drivers/net/usb/ipheth.c b/drivers/net/usb/ipheth.c
new file mode 100644
index 0000000..3f93da1
--- /dev/null
+++ b/drivers/net/usb/ipheth.c
@@ -0,0 +1,573 @@
+/*
+ * ipheth.c - Apple iPhone USB Ethernet driver
+ *
+ * Copyright (c) 2009 Diego Giagio <diego@giagio.com>
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ * 2. Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in the
+ *    documentation and/or other materials provided with the distribution.
+ * 3. Neither the name of GIAGIO.COM nor the names of its contributors
+ *    may be used to endorse or promote products derived from this software
+ *    without specific prior written permission.
+ *
+ * Alternatively, provided that this notice is retained in full, this
+ * software may be distributed under the terms of the GNU General
+ * Public License ("GPL") version 2, in which case the provisions of the
+ * GPL apply INSTEAD OF those given above.
+ *
+ * The provided data structures and external interfaces from this code
+ * are not restricted to be used by modules with a GPL compatible license.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
+ * DAMAGE.
+ *
+ *
+ * Attention: iPhone device must be paired, otherwise it won't respond to our
+ * driver. For more info: http://giagio.com/wiki/moin.cgi/iPhoneEthernetDriver
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/ethtool.h>
+#include <linux/uaccess.h>
+#include <linux/usb.h>
+#include <linux/workqueue.h>
+
+#define USB_VENDOR_APPLE        0x05ac
+#define USB_PRODUCT_IPHETH     0x1290
+#define USB_PRODUCT_IPHETH_3G   0x1292
+#define USB_PRODUCT_IPHETH_3GS  0x1294
+
+#define IPHETH_USBINTF_CLASS    255
+#define IPHETH_USBINTF_SUBCLASS 253
+
+#define IPHETH_BUF_SIZE         1516
+#define IPHETH_TX_TIMEOUT       (5 * HZ)
+
+#define IPHETH_INTFNUM          2
+#define IPHETH_ALT_INTFNUM      1
+
+#define IPHETH_CTRL_ENDP        0x00
+#define IPHETH_CTRL_BUF_SIZE	0x40
+#define IPHETH_CTRL_TIMEOUT     (5 * HZ)
+
+#define IPHETH_CMD_GET_MACADDR   0x00
+#define IPHETH_CMD_CARRIER_CHECK 0x45
+
+#define IPHETH_CARRIER_CHECK_TIMEOUT (1 * HZ)
+#define IPHETH_CARRIER_ON       0x04
+
+static struct usb_device_id ipheth_table[] = {
+	{ USB_DEVICE(USB_VENDOR_APPLE, USB_PRODUCT_IPHETH) },
+	{ USB_DEVICE(USB_VENDOR_APPLE, USB_PRODUCT_IPHETH_3G) },
+	{ USB_DEVICE(USB_VENDOR_APPLE, USB_PRODUCT_IPHETH_3GS) },
+	{ }
+};
+MODULE_DEVICE_TABLE(usb, ipheth_table);
+
+struct ipheth_device {
+	struct usb_device *udev;
+	struct usb_interface *intf;
+	struct net_device *net;
+	struct net_device_stats stats;
+	struct sk_buff *tx_skb;
+	struct urb *tx_urb;
+	struct urb *rx_urb;
+	unsigned char *tx_buf;
+	unsigned char *rx_buf;
+	unsigned char *ctrl_buf;
+	__u8 bulk_in;
+	__u8 bulk_out;
+	struct delayed_work carrier_work;
+};
+
+static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags);
+
+static int ipheth_alloc_urbs(struct ipheth_device *iphone)
+{
+	struct urb *tx_urb = NULL;
+	struct urb *rx_urb = NULL;
+	u8 *tx_buf = NULL;
+	u8 *rx_buf = NULL;
+
+	tx_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (tx_urb == NULL)
+		goto error;
+
+	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (rx_urb == NULL)
+		goto error;
+
+	tx_buf = usb_buffer_alloc(iphone->udev,
+				  IPHETH_BUF_SIZE,
+				  GFP_KERNEL,
+				  &tx_urb->transfer_dma);
+	if (tx_buf == NULL)
+		goto error;
+
+	rx_buf = usb_buffer_alloc(iphone->udev,
+				  IPHETH_BUF_SIZE,
+				  GFP_KERNEL,
+				  &rx_urb->transfer_dma);
+	if (rx_buf == NULL)
+		goto error;
+
+
+	iphone->tx_urb = tx_urb;
+	iphone->rx_urb = rx_urb;
+	iphone->tx_buf = tx_buf;
+	iphone->rx_buf = rx_buf;
+	return 0;
+
+error:
+	usb_buffer_free(iphone->udev, IPHETH_BUF_SIZE, rx_buf,
+			rx_urb->transfer_dma);
+	usb_buffer_free(iphone->udev, IPHETH_BUF_SIZE, tx_buf,
+			tx_urb->transfer_dma);
+	usb_free_urb(rx_urb);
+	usb_free_urb(tx_urb);
+	return -ENOMEM;
+}
+
+static void ipheth_free_urbs(struct ipheth_device *iphone)
+{
+	usb_buffer_free(iphone->udev, IPHETH_BUF_SIZE, iphone->rx_buf,
+			iphone->rx_urb->transfer_dma);
+	usb_buffer_free(iphone->udev, IPHETH_BUF_SIZE, iphone->tx_buf,
+			iphone->tx_urb->transfer_dma);
+	usb_free_urb(iphone->rx_urb);
+	usb_free_urb(iphone->tx_urb);
+}
+
+static void ipheth_unlink_urbs(struct ipheth_device *dev)
+{
+	usb_kill_urb(dev->tx_urb);
+	usb_kill_urb(dev->rx_urb);
+}
+
+static void ipheth_rcvbulk_callback(struct urb *urb)
+{
+	struct ipheth_device *dev;
+	struct sk_buff *skb;
+	int status;
+	char *buf;
+	int len;
+
+	dev = urb->context;
+	if (dev == NULL)
+		return;
+
+	status = urb->status;
+	switch (status) {
+	case -ENOENT:
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+		return;
+	case 0:
+		break;
+	default:
+		err("%s: urb status: %d", __func__, urb->status);
+		return;
+	}
+
+	len = urb->actual_length;
+	buf = urb->transfer_buffer;
+
+	skb = dev_alloc_skb(NET_IP_ALIGN + len);
+	if (!skb) {
+		err("%s: dev_alloc_skb: -ENOMEM", __func__);
+		dev->stats.rx_dropped++;
+		return;
+	}
+
+	skb_reserve(skb, NET_IP_ALIGN);
+	memcpy(skb_put(skb, len), buf + NET_IP_ALIGN, len - NET_IP_ALIGN);
+	skb->dev = dev->net;
+	skb->protocol = eth_type_trans(skb, dev->net);
+
+	dev->stats.rx_packets++;
+	dev->stats.rx_bytes += len;
+
+	netif_rx(skb);
+	ipheth_rx_submit(dev, GFP_ATOMIC);
+}
+
+static void ipheth_sndbulk_callback(struct urb *urb)
+{
+	struct ipheth_device *dev;
+
+	dev = urb->context;
+	if (dev == NULL)
+		return;
+
+	if (urb->status != 0 &&
+	    urb->status != -ENOENT &&
+	    urb->status != -ECONNRESET &&
+	    urb->status != -ESHUTDOWN)
+		err("%s: urb status: %d", __func__, urb->status);
+
+	netif_wake_queue(dev->net);
+	dev_kfree_skb_irq(dev->tx_skb);
+}
+
+static int ipheth_carrier_set(struct ipheth_device *dev)
+{
+	struct usb_device *udev = dev->udev;
+	int retval;
+
+	retval = usb_control_msg(udev, usb_rcvctrlpipe(udev, IPHETH_CTRL_ENDP),
+					IPHETH_CMD_CARRIER_CHECK, /* request */
+					0xc0, /* request type */
+					0x00, /* value */
+					0x02, /* index */
+					dev->ctrl_buf, IPHETH_CTRL_BUF_SIZE,
+					IPHETH_CTRL_TIMEOUT);
+	if (retval < 0) {
+		err("%s: usb_control_msg: %d", __func__, retval);
+		return retval;
+	}
+
+	if (dev->ctrl_buf[0] == IPHETH_CARRIER_ON)
+		netif_carrier_on(dev->net);
+	else
+		netif_carrier_off(dev->net);
+
+	return 0;
+}
+
+static void ipheth_carrier_check_work(struct work_struct *work)
+{
+	struct ipheth_device *dev = container_of(work, struct ipheth_device,
+						 carrier_work.work);
+
+	ipheth_carrier_set(dev);
+	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);
+}
+
+static int ipheth_get_macaddr(struct ipheth_device *dev)
+{
+	struct usb_device *udev = dev->udev;
+	struct net_device *net = dev->net;
+	int retval;
+
+	retval = usb_control_msg(udev,
+				 usb_rcvctrlpipe(udev, IPHETH_CTRL_ENDP),
+				 IPHETH_CMD_GET_MACADDR, /* request */
+				 0xc0, /* request type */
+				 0x00, /* value */
+				 0x02, /* index */
+				 dev->ctrl_buf,
+				 IPHETH_CTRL_BUF_SIZE,
+				 IPHETH_CTRL_TIMEOUT);
+	if (retval < 0) {
+		err("%s: usb_control_msg: %d", __func__, retval);
+	} else if (retval < ETH_ALEN) {
+		err("%s: usb_control_msg: short packet: %d bytes",
+						__func__, retval);
+		retval = -EINVAL;
+	} else {
+		memcpy(net->dev_addr, dev->ctrl_buf, ETH_ALEN);
+		retval = 0;
+	}
+
+	return retval;
+}
+
+static int ipheth_rx_submit(struct ipheth_device *dev, gfp_t mem_flags)
+{
+	struct usb_device *udev = dev->udev;
+	int retval;
+
+	usb_fill_bulk_urb(dev->rx_urb, udev,
+			  usb_rcvbulkpipe(udev, dev->bulk_in),
+			  dev->rx_buf, IPHETH_BUF_SIZE,
+			  ipheth_rcvbulk_callback,
+			  dev);
+	dev->rx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	retval = usb_submit_urb(dev->rx_urb, mem_flags);
+	if (retval)
+		err("%s: usb_submit_urb: %d", __func__, retval);
+
+	return retval;
+}
+
+static int ipheth_open(struct net_device *net)
+{
+	struct ipheth_device *dev = netdev_priv(net);
+	struct usb_device *udev = dev->udev;
+	int retval = 0;
+
+	usb_set_interface(udev, IPHETH_INTFNUM, IPHETH_ALT_INTFNUM);
+	usb_clear_halt(udev, usb_rcvbulkpipe(udev, dev->bulk_in));
+	usb_clear_halt(udev, usb_sndbulkpipe(udev, dev->bulk_out));
+
+	retval = ipheth_carrier_set(dev);
+	if (retval)
+		goto error;
+
+	retval = ipheth_rx_submit(dev, GFP_KERNEL);
+	if (retval)
+		goto error;
+
+	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);
+	netif_start_queue(net);
+error:
+	return retval;
+}
+
+static int ipheth_close(struct net_device *net)
+{
+	struct ipheth_device *dev = netdev_priv(net);
+
+	cancel_delayed_work_sync(&dev->carrier_work);
+	netif_stop_queue(net);
+	return 0;
+}
+
+static int ipheth_tx(struct sk_buff *skb, struct net_device *net)
+{
+	struct ipheth_device *dev = netdev_priv(net);
+	struct usb_device *udev = dev->udev;
+	int retval;
+
+	/* Paranoid */
+	if (skb->len > IPHETH_BUF_SIZE) {
+		err("%s: skb too large: %d bytes", __func__, skb->len);
+		dev->stats.tx_dropped++;
+		dev_kfree_skb_irq(skb);
+		goto exit;
+	}
+
+	memset(dev->tx_buf, 0, IPHETH_BUF_SIZE);
+	memcpy(dev->tx_buf, skb->data, skb->len);
+
+	usb_fill_bulk_urb(dev->tx_urb, udev,
+			  usb_sndbulkpipe(udev, dev->bulk_out),
+			  dev->tx_buf, IPHETH_BUF_SIZE,
+			  ipheth_sndbulk_callback,
+			  dev);
+	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	retval = usb_submit_urb(dev->tx_urb, GFP_ATOMIC);
+	if (retval) {
+		err("%s: usb_submit_urb: %d", __func__, retval);
+		dev->stats.tx_errors++;
+		dev_kfree_skb_irq(skb);
+	} else {
+		net->trans_start = jiffies;
+		dev->tx_skb = skb;
+
+		dev->stats.tx_packets++;
+		dev->stats.tx_bytes += skb->len;
+		netif_stop_queue(net);
+	}
+exit:
+	return NETDEV_TX_OK;
+}
+
+static void ipheth_tx_timeout(struct net_device *net)
+{
+	struct ipheth_device *dev = netdev_priv(net);
+
+	err("%s: TX timeout", __func__);
+	dev->stats.tx_errors++;
+	usb_unlink_urb(dev->tx_urb);
+}
+
+static struct net_device_stats *ipheth_stats(struct net_device *net)
+{
+	struct ipheth_device *dev = netdev_priv(net);
+	return &dev->stats;
+}
+
+static u32 ipheth_ethtool_op_get_link(struct net_device *net)
+{
+	struct ipheth_device *dev = netdev_priv(net);
+	return netif_carrier_ok(dev->net);
+}
+
+static struct ethtool_ops ops = {
+	.get_link = ipheth_ethtool_op_get_link
+};
+
+#ifdef HAVE_NET_DEVICE_OPS
+static const struct net_device_ops ipheth_netdev_ops = {
+       .ndo_open = &ipheth_open,
+       .ndo_stop = &ipheth_close,
+       .ndo_start_xmit = &ipheth_tx,
+       .ndo_tx_timeout = &ipheth_tx_timeout,
+       .ndo_get_stats = &ipheth_stats,
+};
+#endif
+
+static int ipheth_probe(struct usb_interface *intf,
+			 const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct usb_host_interface *hintf;
+	struct usb_endpoint_descriptor *endp;
+	struct ipheth_device *dev;
+	struct net_device *netdev;
+	int i;
+	int retval;
+
+	/* Ensure we are probing the right interface */
+	if (intf->cur_altsetting->desc.bInterfaceClass != IPHETH_USBINTF_CLASS ||
+	    intf->cur_altsetting->desc.bInterfaceSubClass != IPHETH_USBINTF_SUBCLASS)
+		return -ENODEV;
+
+	netdev = alloc_etherdev(sizeof(struct ipheth_device));
+	if (!netdev)
+		return -ENOMEM;
+
+#ifdef HAVE_NET_DEVICE_OPS
+	netdev->netdev_ops = &ipheth_netdev_ops;
+#else /* CONFIG_COMPAT_NET_DEV_OPS */
+	netdev->open = &ipheth_open;
+	netdev->stop = &ipheth_close;
+	netdev->hard_start_xmit = &ipheth_tx;
+	netdev->tx_timeout = &ipheth_tx_timeout;
+	netdev->get_stats = &ipheth_stats;
+#endif
+	netdev->watchdog_timeo = IPHETH_TX_TIMEOUT;
+
+	dev = netdev_priv(netdev);
+	dev->udev = udev;
+	dev->net = netdev;
+	dev->intf = intf;
+
+	/* Set up endpoints */
+	hintf = usb_altnum_to_altsetting(intf, IPHETH_ALT_INTFNUM);
+	if (hintf == NULL) {
+		retval = -ENODEV;
+		err("Unable to find alternate settings interface");
+		goto err_endpoints;
+	}
+
+	for (i = 0; i < hintf->desc.bNumEndpoints; i++) {
+		endp = &hintf->endpoint[i].desc;
+		if (usb_endpoint_is_bulk_in(endp))
+			dev->bulk_in = endp->bEndpointAddress;
+		else if (usb_endpoint_is_bulk_out(endp))
+			dev->bulk_out = endp->bEndpointAddress;
+	}
+	if (!(dev->bulk_in && dev->bulk_out)) {
+		retval = -ENODEV;
+		err("Unable to find endpoints");
+		goto err_endpoints;
+	}
+
+	dev->ctrl_buf = kmalloc(IPHETH_CTRL_BUF_SIZE, GFP_KERNEL);
+	if (dev->ctrl_buf == NULL) {
+		retval = -ENOMEM;
+		goto err_alloc_ctrl_buf;
+	}
+
+	retval = ipheth_get_macaddr(dev);
+	if (retval)
+		goto err_get_macaddr;
+
+	INIT_DELAYED_WORK(&dev->carrier_work, ipheth_carrier_check_work);
+
+	retval = ipheth_alloc_urbs(dev);
+	if (retval) {
+		err("error allocating urbs: %d", retval);
+		goto err_alloc_urbs;
+	}
+
+	usb_set_intfdata(intf, dev);
+
+	SET_NETDEV_DEV(netdev, &intf->dev);
+	SET_ETHTOOL_OPS(netdev, &ops);
+
+	retval = register_netdev(netdev);
+	if (retval) {
+		err("error registering netdev: %d", retval);
+		retval = -EIO;
+		goto err_register_netdev;
+	}
+
+	dev_info(&intf->dev, "Apple iPhone USB Ethernet device attached\n");
+	return 0;
+
+err_register_netdev:
+	ipheth_free_urbs(dev);
+err_alloc_urbs:
+err_get_macaddr:
+err_alloc_ctrl_buf:
+	kfree(dev->ctrl_buf);
+err_endpoints:
+	free_netdev(netdev);
+	return retval;
+}
+
+static void ipheth_disconnect(struct usb_interface *intf)
+{
+	struct ipheth_device *dev;
+
+	dev = usb_get_intfdata(intf);
+	if (dev != NULL) {
+		unregister_netdev(dev->net);
+		ipheth_unlink_urbs(dev);
+		ipheth_free_urbs(dev);
+		kfree(dev->ctrl_buf);
+		free_netdev(dev->net);
+	}
+	usb_set_intfdata(intf, NULL);
+	dev_info(&intf->dev, "Apple iPhone USB Ethernet now disconnected\n");
+}
+
+static struct usb_driver ipheth_driver = {
+	.name =		"ipheth",
+	.probe =	ipheth_probe,
+	.disconnect =	ipheth_disconnect,
+	.id_table =	ipheth_table,
+	.supports_autosuspend = 0,
+};
+
+static int __init ipheth_init(void)
+{
+	int retval;
+
+	retval = usb_register(&ipheth_driver);
+	if (retval) {
+		err("usb_register failed: %d", retval);
+		return retval;
+	}
+	return 0;
+}
+
+static void __exit ipheth_exit(void)
+{
+	usb_deregister(&ipheth_driver);
+}
+
+module_init(ipheth_init);
+module_exit(ipheth_exit);
+
+MODULE_AUTHOR("Diego Giagio <diego@giagio.com>");
+MODULE_DESCRIPTION("Apple iPhone USB Ethernet driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
1.7.0

