Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab0CaUda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 16:33:30 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:37861 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab0CaUd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 16:33:28 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "L. Alberto =?utf-8?q?Gim=C3=A9nez?=" <agimenez@sysvalve.es>
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
Date: Wed, 31 Mar 2010 22:33:26 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, linville@tuxdriver.com, j.dumon@option.com,
       steve.glendinning@smsc.com, davem@davemloft.net, gregkh@suse.de,
       dgiagio@gmail.com, dborca@yahoo.com
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <1270064527-8485-1-git-send-email-agimenez@sysvalve.es>
In-Reply-To: <1270064527-8485-1-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201003312233.26130.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. März 2010 21:42:07 schrieb L. Alberto Giménez:

Hi,

a few comments below.

	Regards
		Oliver

> +
> +static struct usb_device_id ipheth_table[] = {
> +	{ USB_DEVICE(USB_VENDOR_APPLE, USB_PRODUCT_IPHETH) },
> +	{ USB_DEVICE(USB_VENDOR_APPLE, USB_PRODUCT_IPHETH_3G) },
> +	{ USB_DEVICE(USB_VENDOR_APPLE, USB_PRODUCT_IPHETH_3GS) },

Please use the macros specifying the interface.

> +	{ }
> +};
> +MODULE_DEVICE_TABLE(usb, ipheth_table);


> +static void ipheth_unlink_urbs(struct ipheth_device *dev)

The naming might be misleading.

> +{
> +	usb_kill_urb(dev->tx_urb);
> +	usb_kill_urb(dev->rx_urb);
> +}

> +
> +static void ipheth_sndbulk_callback(struct urb *urb)
> +{
> +	struct ipheth_device *dev;
> +
> +	dev = urb->context;
> +	if (dev == NULL)
> +		return;
> +
> +	if (urb->status != 0 &&
> +	    urb->status != -ENOENT &&
> +	    urb->status != -ECONNRESET &&
> +	    urb->status != -ESHUTDOWN)
> +		err("%s: urb status: %d", __func__, urb->status);
> +
> +	netif_wake_queue(dev->net);
> +	dev_kfree_skb_irq(dev->tx_skb);

Race condition. You must free the skb before you wake the queue.

> +}

> +
> +static int ipheth_open(struct net_device *net)
> +{
> +	struct ipheth_device *dev = netdev_priv(net);
> +	struct usb_device *udev = dev->udev;
> +	int retval = 0;
> +
> +	usb_set_interface(udev, IPHETH_INTFNUM, IPHETH_ALT_INTFNUM);
> +	usb_clear_halt(udev, usb_rcvbulkpipe(udev, dev->bulk_in));
> +	usb_clear_halt(udev, usb_sndbulkpipe(udev, dev->bulk_out));

Is this really needed? If so, please add a comment.

> +
> +	retval = ipheth_carrier_set(dev);
> +	if (retval)
> +		goto error;
> +
> +	retval = ipheth_rx_submit(dev, GFP_KERNEL);
> +	if (retval)
> +		goto error;
> +
> +	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);

Does it make sense to start rx while you have no carrier?

> +	netif_start_queue(net);
> +error:
> +	return retval;
> +}

> +static int ipheth_tx(struct sk_buff *skb, struct net_device *net)
> +{
> +	struct ipheth_device *dev = netdev_priv(net);
> +	struct usb_device *udev = dev->udev;
> +	int retval;
> +
> +	/* Paranoid */
> +	if (skb->len > IPHETH_BUF_SIZE) {
> +		err("%s: skb too large: %d bytes", __func__, skb->len);
> +		dev->stats.tx_dropped++;
> +		dev_kfree_skb_irq(skb);
> +		goto exit;
> +	}
> +
> +	memset(dev->tx_buf, 0, IPHETH_BUF_SIZE);
> +	memcpy(dev->tx_buf, skb->data, skb->len);

a bit wasteful

> +static int ipheth_probe(struct usb_interface *intf,
> +			 const struct usb_device_id *id)
> +{
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	struct usb_host_interface *hintf;
> +	struct usb_endpoint_descriptor *endp;
> +	struct ipheth_device *dev;
> +	struct net_device *netdev;
> +	int i;
> +	int retval;
> +
> +	/* Ensure we are probing the right interface */
> +	if (intf->cur_altsetting->desc.bInterfaceClass != IPHETH_USBINTF_CLASS ||
> +	    intf->cur_altsetting->desc.bInterfaceSubClass != IPHETH_USBINTF_SUBCLASS)
> +		return -ENODEV;

Please use the correct macro to specify the interface you are interested in

> +static void ipheth_disconnect(struct usb_interface *intf)
> +{
> +	struct ipheth_device *dev;
> +
> +	dev = usb_get_intfdata(intf);
> +	if (dev != NULL) {

is this check needed?

> +static struct usb_driver ipheth_driver = {
> +	.name =		"ipheth",
> +	.probe =	ipheth_probe,
> +	.disconnect =	ipheth_disconnect,
> +	.id_table =	ipheth_table,
> +	.supports_autosuspend = 0,

redundant
