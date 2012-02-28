Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424Ab2B1Qkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:40:46 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:36506 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813Ab2B1Qko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:40:44 -0500
From: Autif Khan <autifk@gmail.com>
To: gregkh@linuxfoundation.org, rusty@rustcorp.com.au, jhovold@gmail.com,
        stern@rowland.harvard.edu, mchehab@redhat.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Autif Khan <autifk@gmail.com>
Subject: [PATCH 2/3] drivers: net: usb: sierra_net - upgrade to 3.2
Date: Tue, 28 Feb 2012 11:40:30 -0500
Message-Id: <1330447230-5811-1-git-send-email-autifk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver was upgraded from 2.0 to 3.2
source of the driver at the time of this change:
http://www.sierrawireless.com/resources/support/drivers/linux/v3.2_1740_kernel-3.0.directIP.tar

The driver compiles (monolithic and module)
I have not tested it on any device

Signed-off-by: Autif Khan <autifk@gmail.com>
---
 drivers/net/usb/sierra_net.c |  205 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 168 insertions(+), 37 deletions(-)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index b59cf20..f6057d9 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -1,7 +1,7 @@
 /*
  * USB-to-WWAN Driver for Sierra Wireless modems
  *
- * Copyright (C) 2008, 2009, 2010 Paxton Smith, Matthew Safar, Rory Filer
+ * Copyright (C) 2008 - 2011 Paxton Smith, Matthew Safar, Rory Filer
  *                          <linux@sierrawireless.com>
  *
  * Portions of this based on the cdc_ether driver by David Brownell (2003-2005)
@@ -25,13 +25,17 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#define DRIVER_VERSION "v.2.0"
+#define DRIVER_VERSION "v.3.2"
 #define DRIVER_AUTHOR "Paxton Smith, Matthew Safar, Rory Filer"
 #define DRIVER_DESC "USB-to-WWAN Driver for Sierra Wireless modems"
 static const char driver_name[] = "sierra_net";
 
 /* if defined debug messages enabled */
 /*#define	DEBUG*/
+/* more debug messages */
+/*#define	VERBOSE*/
+/* Uncomment to force power level set to auto when attaching a device */
+/*#define POWER_LEVEL_AUTO*/
 
 #include <linux/module.h>
 #include <linux/etherdevice.h>
@@ -48,6 +52,7 @@ static const char driver_name[] = "sierra_net";
 
 #define SWI_USB_REQUEST_GET_FW_ATTR	0x06
 #define SWI_GET_FW_ATTR_MASK		0x08
+#define SWI_GET_FW_ATTR_APM			0x2
 
 /* atomic counter partially included in MAC address to make sure 2 devices
  * do not end up with the same MAC - concept breaks in case of > 255 ifaces
@@ -68,6 +73,11 @@ static	atomic_t iface_counter = ATOMIC_INIT(0);
  */
 #define SIERRA_NET_USBCTL_BUF_LEN	1024
 
+/* The SIERRA_NET_RX_URB_SZ defines the receive urb size
+ * for optimal throughput.
+ */
+#define SIERRA_NET_RX_URB_SZ		1540
+
 /* list of interface numbers - used for constructing interface lists */
 struct sierra_net_iface_info {
 	const u32 infolen;	/* number of interface numbers on list */
@@ -139,6 +149,7 @@ struct param {
 #define SIERRA_NET_SESSION_IDLE       0x00
 /* LSI Link types */
 #define SIERRA_NET_AS_LINK_TYPE_IPv4  0x00
+#define SIERRA_NET_AS_LINK_TYPE_IPv6  0x02
 
 struct lsi_umts {
 	u8 protocol;
@@ -200,10 +211,11 @@ static inline void sierra_net_set_private(struct usbnet *dev,
 	dev->data[0] = (unsigned long)priv;
 }
 
-/* is packet IPv4 */
+/* is packet IP */
 static inline int is_ip(struct sk_buff *skb)
 {
-	return skb->protocol == cpu_to_be16(ETH_P_IP);
+	return ((skb->protocol == cpu_to_be16(ETH_P_IP)) ||
+			(skb->protocol == cpu_to_be16(ETH_P_IPV6)));
 }
 
 /*
@@ -312,6 +324,24 @@ static void build_hip(u8 *buf, const u16 payloadlen,
 /*----------------------------------------------------------------------------*
  *                              END HIP                                       *
  *----------------------------------------------------------------------------*/
+/* This should come out before going to kernel.org */
+static void sierra_net_printk_buf(u8 *buf, u16 len)
+{
+#ifdef VERBOSE
+	u16 i;
+	u16 k;
+
+	for (i = k = 0; i < len / 4; i++, k += 4) {
+		printk(KERN_DEBUG "%02x%02x%02x%02x ",
+			buf[k+0], buf[k+1], buf[k+2], buf[k+3]);
+	}
+
+	for (; k < len;  k++)
+		printk(KERN_DEBUG "%02x", buf[k]);
+
+	printk("\n");
+#endif
+}
 
 static int sierra_net_send_cmd(struct usbnet *dev,
 		u8 *cmd, int cmdlen, const char * cmd_name)
@@ -319,10 +349,12 @@ static int sierra_net_send_cmd(struct usbnet *dev,
 	struct sierra_net_data *priv = sierra_net_get_private(dev);
 	int  status;
 
+	usb_autopm_get_interface(dev->intf);
 	status = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 			USB_CDC_SEND_ENCAPSULATED_COMMAND,
 			USB_DIR_OUT|USB_TYPE_CLASS|USB_RECIP_INTERFACE,	0,
 			priv->ifnum, cmd, cmdlen, USB_CTRL_SET_TIMEOUT);
+	usb_autopm_put_interface(dev->intf);
 
 	if (status != cmdlen && status != -ENODEV)
 		netdev_err(dev->net, "Submit %s failed %d\n", cmd_name, status);
@@ -339,8 +371,17 @@ static int sierra_net_send_sync(struct usbnet *dev)
 
 	status = sierra_net_send_cmd(dev, priv->sync_msg,
 			sizeof(priv->sync_msg), "SYNC");
+    return status;
+}
 
-	return status;
+static void sierra_net_send_shutdown(struct usbnet *dev)
+{
+	struct sierra_net_data *priv = sierra_net_get_private(dev);
+
+	dev_dbg(&dev->udev->dev, "%s", __func__);
+
+	sierra_net_send_cmd(dev, priv->shdwn_msg,
+			sizeof(priv->shdwn_msg), "Shutdown");
 }
 
 static void sierra_net_set_ctx_index(struct sierra_net_data *priv, u8 ctx_ix)
@@ -354,7 +395,7 @@ static void sierra_net_set_ctx_index(struct sierra_net_data *priv, u8 ctx_ix)
 
 static inline int sierra_net_is_valid_addrlen(u8 len)
 {
-	return len == sizeof(struct in_addr);
+	return (len == sizeof(struct in_addr));
 }
 
 static int sierra_net_parse_lsi(struct usbnet *dev, char *data, int datalen)
@@ -383,10 +424,11 @@ static int sierra_net_parse_lsi(struct usbnet *dev, char *data, int datalen)
 	}
 
 	/* Validate the link type */
-	if (lsi->link_type != SIERRA_NET_AS_LINK_TYPE_IPv4) {
-		netdev_err(dev->net, "Link type unsupported: 0x%02x\n",
+	if ((lsi->link_type != SIERRA_NET_AS_LINK_TYPE_IPv4) &&
+		(lsi->link_type != SIERRA_NET_AS_LINK_TYPE_IPv6)) {
+		netdev_err(dev->net, "Link unavailable: 0x%02x",
 			lsi->link_type);
-		return -1;
+		return 0;
 	}
 
 	/* Validate the coverage */
@@ -474,13 +516,15 @@ static void sierra_net_kevent(struct work_struct *work)
 			return;
 		}
 		ifnum = priv->ifnum;
+		usb_autopm_get_interface(dev->intf);
 		len = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 				USB_CDC_GET_ENCAPSULATED_RESPONSE,
 				USB_DIR_IN|USB_TYPE_CLASS|USB_RECIP_INTERFACE,
 				0, ifnum, buf, SIERRA_NET_USBCTL_BUF_LEN,
 				USB_CTRL_SET_TIMEOUT);
+		usb_autopm_put_interface(dev->intf);
 
-		if (len < 0) {
+		if (unlikely(len < 0)) {
 			netdev_err(dev->net,
 				"usb_control_msg failed, status %d\n", len);
 		} else {
@@ -488,6 +532,7 @@ static void sierra_net_kevent(struct work_struct *work)
 
 			dev_dbg(&dev->udev->dev, "%s: Received status message,"
 				" %04x bytes", __func__, len);
+			sierra_net_printk_buf(buf, len);
 
 			err = parse_hip(buf, len, &hh);
 			if (err) {
@@ -534,7 +579,10 @@ static void sierra_net_kevent(struct work_struct *work)
 					"extmsgid 0x%04x\n", hh.extmsgid.word);
 				break;
 			case SIERRA_NET_HIP_RCGI:
-				/* Ignored */
+				/* Ignored. It is a firmware
+				 * workaround to solve a  Windows driver bug and
+				 * may be removed in the future. 
+				 */
 				break;
 			default:
 				netdev_err(dev->net, "Unrecognized HIP msg, "
@@ -561,7 +609,10 @@ static void sierra_net_defer_kevent(struct usbnet *dev, int work)
 	struct sierra_net_data *priv = sierra_net_get_private(dev);
 
 	set_bit(work, &priv->kevent_flags);
-	schedule_work(&priv->sierra_net_kevent);
+	if (!schedule_work(&priv->sierra_net_kevent))
+		dev_dbg(&dev->udev->dev, "sierra_net_kevent %d may have been dropped", work);
+	else
+		dev_dbg(&dev->udev->dev, "sierra_net_kevent %d scheduled", work);
 }
 
 /*
@@ -581,6 +632,7 @@ static void sierra_net_status(struct usbnet *dev, struct urb *urb)
 	struct usb_cdc_notification *event;
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
+	sierra_net_printk_buf(urb->transfer_buffer, urb->actual_length);
 
 	if (urb->actual_length < sizeof *event)
 		return;
@@ -618,7 +670,7 @@ static u32 sierra_net_get_link(struct net_device *net)
 	return sierra_net_get_private(dev)->link_up && netif_running(net);
 }
 
-static const struct ethtool_ops sierra_net_ethtool_ops = {
+static struct ethtool_ops sierra_net_ethtool_ops = {
 	.get_drvinfo = sierra_net_get_drvinfo,
 	.get_link = sierra_net_get_link,
 	.get_msglevel = usbnet_get_msglevel,
@@ -661,6 +713,7 @@ static int sierra_net_get_fw_attr(struct usbnet *dev, u16 *datap)
 	if (!attrdata)
 		return -ENOMEM;
 
+	usb_autopm_get_interface(dev->intf);
 	result = usb_control_msg(
 			dev->udev,
 			usb_rcvctrlpipe(dev->udev, 0),
@@ -672,6 +725,7 @@ static int sierra_net_get_fw_attr(struct usbnet *dev, u16 *datap)
 			attrdata,	/* char *data */
 			sizeof(*attrdata),		/* __u16 size */
 			USB_CTRL_SET_TIMEOUT);	/* int timeout */
+	usb_autopm_put_interface(dev->intf);
 
 	if (result < 0) {
 		kfree(attrdata);
@@ -684,6 +738,12 @@ static int sierra_net_get_fw_attr(struct usbnet *dev, u16 *datap)
 	return result;
 }
 
+static int sierra_net_manage_power(struct usbnet *dev, int on)
+{
+	dev->intf->needs_remote_wakeup = on;
+	return 0;
+}
+
 /*
  * collects the bulk endpoints, the status endpoint.
  */
@@ -735,6 +795,10 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	priv->usbnet = dev;
 	priv->ifnum = ifacenum;
+	/* override change_mtu with our own routine - need to bound check */
+	/* replace structure to our own structure where we have our own
+	 *  routine - need to bound check
+	 */
 	dev->net->netdev_ops = &sierra_net_device_ops;
 
 	/* change MAC addr to include, ifacenum, and to be unique */
@@ -761,6 +825,7 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* Set up the netdev */
 	dev->net->flags |= IFF_NOARP;
+	dev->net->flags |= IFF_MULTICAST;
 	dev->net->ethtool_ops = &sierra_net_ethtool_ops;
 	netif_carrier_off(dev->net);
 
@@ -773,11 +838,23 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* Only need to do this once */
 	init_timer(&priv->sync_timer);
-
 	/* verify fw attributes */
 	status = sierra_net_get_fw_attr(dev, &fwattr);
-	dev_dbg(&dev->udev->dev, "Fw attr: %x\n", fwattr);
-
+	dev_dbg(&dev->udev->dev, "Fw attr: %x\n", fwattr); 
+	if (status == sizeof(fwattr) && (fwattr & SWI_GET_FW_ATTR_APM)) {
+/******************************************************************************* 
+ * If you want the default /sys/bus/usb/devices/.../.../power/level to be forced
+ * to auto, the following needs to be compiled in.
+ */ 
+#ifdef POWER_LEVEL_AUTO
+		/* make power level default be 'auto' */
+		dev_dbg(&dev->udev->dev, "Enabling APM");
+		usb_enable_autosuspend(dev->udev);
+#endif
+	} else {
+		dev_info(&intf->dev, "Disabling APM - not supported");
+		usb_disable_autosuspend(dev->udev);
+	}
 	/* test whether firmware supports DHCP */
 	if (!(status == sizeof(fwattr) && (fwattr & SWI_GET_FW_ATTR_MASK))) {
 		/* found incompatible firmware version */
@@ -789,33 +866,45 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 	/* prepare sync message from template */
 	memcpy(priv->sync_msg, sync_tmplate, sizeof(priv->sync_msg));
 
+	return 0;
+}
+
+static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
+{
+	struct sierra_net_data *priv = sierra_net_get_private(dev);
+
+	dev_dbg(&dev->udev->dev, "%s", __func__);
+
+	sierra_net_set_private(dev, NULL);
+
+	kfree(priv);
+}
+
+static int sierra_net_open(struct usbnet *dev)
+{
+	dev_dbg(&dev->udev->dev, "%s", __func__);
+
 	/* initiate the sync sequence */
 	sierra_net_dosync(dev);
 
 	return 0;
 }
 
-static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
+static int sierra_net_stop(struct usbnet *dev)
 {
-	int status;
 	struct sierra_net_data *priv = sierra_net_get_private(dev);
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
-	/* kill the timer and work */
+	/* Kill the timer then flush the work queue */
 	del_timer_sync(&priv->sync_timer);
+
 	cancel_work_sync(&priv->sierra_net_kevent);
 
 	/* tell modem we are going away */
-	status = sierra_net_send_cmd(dev, priv->shdwn_msg,
-			sizeof(priv->shdwn_msg), "Shutdown");
-	if (status < 0)
-		netdev_err(dev->net,
-			"usb_control_msg failed, status %d\n", status);
-
-	sierra_net_set_private(dev, NULL);
+	sierra_net_send_shutdown(dev);
 
-	kfree(priv);
+	return 0;
 }
 
 static struct sk_buff *sierra_net_skb_clone(struct usbnet *dev,
@@ -847,9 +936,13 @@ static int sierra_net_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	int err;
 	struct hip_hdr  hh;
 	struct sk_buff *new_skb;
+	struct ethhdr *eth;
+	struct iphdr *ip;
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
+	sierra_net_printk_buf(skb->data, skb->len);
+
 	/* could contain multiple packets */
 	while (likely(skb->len)) {
 		err = parse_hip(skb->data, skb->len, &hh);
@@ -879,6 +972,12 @@ static int sierra_net_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		memcpy(skb->data, sierra_net_get_private(dev)->ethr_hdr_tmpl,
 			ETH_HLEN);
 
+		ip = (struct iphdr *)((char *)skb->data + ETH_HLEN);
+		if(ip->version == 6) {
+			eth = (struct ethhdr *)skb->data;
+			eth->h_proto = cpu_to_be16(ETH_P_IPV6);
+		}
+
 		/* Last packet in batch handled by usbnet */
 		if (hh.payload_len.word == skb->len)
 			return 1;
@@ -900,9 +999,6 @@ struct sk_buff *sierra_net_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	u16 len;
 	bool need_tail;
 
-	BUILD_BUG_ON(FIELD_SIZEOF(struct usbnet, data)
-				< sizeof(struct cdc_state));
-
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 	if (priv->link_up && check_ethip_packet(skb, dev) && is_ip(skb)) {
 		/* enough head room as is? */
@@ -926,6 +1022,8 @@ struct sk_buff *sierra_net_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 				}
 			}
 			build_hip(skb->data, len, priv);
+
+            sierra_net_printk_buf(skb->data, skb->len);
 			return skb;
 		} else {
 			/*
@@ -945,16 +1043,24 @@ struct sk_buff *sierra_net_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	return NULL;
 }
 
+static int sierra_net_reset_resume(struct usb_interface *intf)
+{
+	struct usbnet	*dev = usb_get_intfdata(intf);
+	netdev_err(dev->net, "%s\n", __func__);
+	return usbnet_resume(intf);
+}
+
 static const u8 sierra_net_ifnum_list[] = { 7, 10, 11 };
-static const struct sierra_net_info_data sierra_net_info_data_68A3 = {
-	.rx_urb_size = 8 * 1024,
+static const struct sierra_net_info_data sierra_net_info_data_direct_ip = {
+	/* .rx_urb_size = 8 * 1024, */
+	.rx_urb_size = SIERRA_NET_RX_URB_SZ,
 	.whitelist = {
 		.infolen = ARRAY_SIZE(sierra_net_ifnum_list),
 		.ifaceinfo = sierra_net_ifnum_list
 	}
 };
 
-static const struct driver_info sierra_net_info_68A3 = {
+static const struct driver_info sierra_net_info_direct_ip = {
 	.description = "Sierra Wireless USB-to-WWAN Modem",
 	.flags = FLAG_WWAN | FLAG_SEND_ZLP,
 	.bind = sierra_net_bind,
@@ -962,12 +1068,21 @@ static const struct driver_info sierra_net_info_68A3 = {
 	.status = sierra_net_status,
 	.rx_fixup = sierra_net_rx_fixup,
 	.tx_fixup = sierra_net_tx_fixup,
-	.data = (unsigned long)&sierra_net_info_data_68A3,
+	.manage_power = sierra_net_manage_power,
+	.stop = sierra_net_stop,
+	.check_connect = sierra_net_open,
+	.data = (unsigned long)&sierra_net_info_data_direct_ip,
 };
 
 static const struct usb_device_id products[] = {
-	{USB_DEVICE(0x1199, 0x68A3), /* Sierra Wireless USB-to-WWAN modem */
-	.driver_info = (unsigned long) &sierra_net_info_68A3},
+	{USB_DEVICE(0x1199, 0x68A3), /* Sierra Wireless Direct IP modem */
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0xF3D, 0x68A3), /* AT&T Direct IP modem */
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0x1199, 0x68AA), /* Sierra Wireless Direct IP LTE modem */
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
+	{USB_DEVICE(0xF3D, 0x68AA), /* AT&T Direct IP LTE modem */
+	.driver_info = (unsigned long) &sierra_net_info_direct_ip},
 
 	{}, /* last item */
 };
@@ -981,10 +1096,26 @@ static struct usb_driver sierra_net_driver = {
 	.disconnect = usbnet_disconnect,
 	.suspend = usbnet_suspend,
 	.resume = usbnet_resume,
+	.reset_resume = sierra_net_reset_resume,
 	.no_dynamic_id = 1,
+	.supports_autosuspend = 1,
 };
 
-module_usb_driver(sierra_net_driver);
+static int __init sierra_net_init(void)
+{
+	BUILD_BUG_ON(FIELD_SIZEOF(struct usbnet, data)
+				< sizeof(struct cdc_state));
+
+	return usb_register(&sierra_net_driver);
+}
+
+static void __exit sierra_net_exit(void)
+{
+	usb_deregister(&sierra_net_driver);
+}
+
+module_exit(sierra_net_exit);
+module_init(sierra_net_init);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-- 
1.7.5.4

