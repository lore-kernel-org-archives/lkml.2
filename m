Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab2ADIYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 03:24:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab2ADIYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 03:24:14 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Jan Steinhoff <mail@jan-steinhoff.de>
Subject: Re: [PATCH] input: Synaptics USB device driver
Date: Wed, 4 Jan 2012 09:25:59 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Alessandro Rubini <rubini@cvml.unipv.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120103194033.779cb829@greyhound>
In-Reply-To: <20120103194033.779cb829@greyhound>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201040926.00117.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Januar 2012, 19:40:33 schrieb Jan Steinhoff:
> From: Jan Steinhoff <mail@jan-steinhoff.de>
> 
> This patch adds a driver for Synaptics USB touchpad or pointing stick
> devices. These USB devices emulate an USB mouse by default, so one can
> also use the usbhid driver. However, in combination with special user
> space drivers this kernel driver allows one to customize the behaviour
> of the device.

Hi,

thank you for this driver. There are a few issues which I have commented on
in the text.

	Regards
			Oliver

[..]
> +	input_report_abs(idev, ABS_PRESSURE, pressure);
> +
> +	input_report_key(idev, BTN_LEFT, data[1] & 0x04);
> +	input_report_key(idev, BTN_RIGHT, data[1] & 0x01);
> +	input_report_key(idev, BTN_MIDDLE, data[1] & 0x02);
> +	if (synusb->has_display)
> +		input_report_key(idev, btn_middle ? BTN_MIDDLE : BTN_MISC,
> +				 data[1] & 0x08);
> +
> +	input_sync(idev);
> +resubmit:
> +	res = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (res)

You are racing with disconnect, suspend and pre_reset. This may lead
to a spurious error message. The correct check is (res && res != -EPERM)

[..]
> +
> +/*
> + * initialization of usb data structures
> + */
> +
> +static int synusb_setup_iurb(struct synusb *synusb,
> +			     struct usb_endpoint_descriptor *endpoint)
> +{
> +	char *buf;
> +
> +	if (endpoint->wMaxPacketSize < 8)
> +		return 0;

How could this happen?

> +	if (synusb->iurb) {
> +		synusb_warn(synusb, "Found more than one possible "
> +				    "int in endpoint");
> +		return 0;
> +	}
> +	synusb->iurb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (synusb->iurb == NULL)
> +		return -ENOMEM;
> +	buf = usb_alloc_coherent(synusb->udev, 8, GFP_ATOMIC,

No need for an atomic allocation here.

> +				 &synusb->iurb->transfer_dma);
> +	if (buf == NULL)
> +		return -ENOMEM;
> +	usb_fill_int_urb(synusb->iurb, synusb->udev,
> +			 usb_rcvintpipe(synusb->udev,
> +					endpoint->bEndpointAddress),
> +			 buf, 8, synusb_input_callback,
> +			 synusb, endpoint->bInterval);
> +	synusb->iurb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +	return 0;
> +}
> +
> +static inline int synusb_match_endpoint(struct usb_endpoint_descriptor *ep)
> +{
> +	if (((ep->bEndpointAddress & USB_DIR_IN) == USB_DIR_IN) &&
> +	    ((ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
> +			== USB_ENDPOINT_XFER_INT))

We have macros for such checks. Please use them.

> +		return 0;
> +
> +	return -ENODEV;
> +}
> +

[..]
> +static void synusb_disconnect(struct usb_interface *interface)
> +{
> +	struct synusb *synusb;
> +
> +	synusb = usb_get_intfdata(interface);
> +	usb_set_intfdata(interface, NULL);
> +
> +	cancel_delayed_work_sync(&synusb->isubmit);
> +
> +	usb_kill_urb(synusb->iurb);

Code duplication. If you define draw_down(), use it.

> +	input_unregister_device(synusb->idev);
> +	synusb->idev = NULL;
> +
> +	kref_put(&synusb->kref, synusb_delete);
> +
> +	dev_info(&interface->dev, "Synaptics device disconnected\n");
> +}
> +
> +
> +/*
> + * suspend code
> + */
> +
> +static void synusb_draw_down(struct synusb *synusb)
> +{
> +	cancel_delayed_work_sync(&synusb->isubmit);
> +	usb_kill_urb(synusb->iurb);
> +}
> +
> +static int synusb_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct synusb *synusb = usb_get_intfdata(intf);
> +
> +	if (synusb == NULL)
> +		return 0;

How can this happen?

> +
> +	synusb_draw_down(synusb);
> +
> +	return 0;
> +}
> +
> +static int synusb_resume(struct usb_interface *intf)
> +{
> +	struct synusb *synusb = usb_get_intfdata(intf);
> +	int res;
> +
> +	res = usb_submit_urb(synusb->iurb, GFP_ATOMIC);

GFP_NOIO

> +	if (res)
> +		synusb_err(synusb, "submit int in urb failed during resume "
> +				   "with result %d", res);
> +
> +	return res;
> +}
> +
> +static int synusb_pre_reset(struct usb_interface *intf)
> +{
> +	struct synusb *synusb = usb_get_intfdata(intf);
> +
> +	synusb_draw_down(synusb);
> +
> +	return 0;
> +}
> +
> +static int synusb_post_reset(struct usb_interface *intf)
> +{
> +	struct synusb *synusb = usb_get_intfdata(intf);
> +	int res;
> +
> +	res = usb_submit_urb(synusb->iurb, GFP_ATOMIC);

GFP_NOIO

> +	if (res)
> +		synusb_err(synusb, "submit int in urb failed in during "
> +				   "post_reset with result %d", res);
> +
> +	return res;
> +}
> +
> +static int synusb_reset_resume(struct usb_interface *intf)
> +{
> +	struct synusb *synusb = usb_get_intfdata(intf);
> +	int res;
> +
> +	res = usb_submit_urb(synusb->iurb, GFP_ATOMIC);

GFP_NOIO

> +	if (res)
> +		synusb_err(synusb, "submit int in urb failed during "
> +				   "reset-resume with result %d", res);
> +
> +	return res;
> +}
> +
> +/* the id table is filled via sysfs, so usbhid is always the default driver */
> +static struct usb_device_id synusb_idtable[] = { { } };
> +MODULE_DEVICE_TABLE(usb, synusb_idtable);
> +
> +static struct usb_driver synusb_driver = {
> +	.name =		"synaptics_usb",
> +	.probe =	synusb_probe,
> +	.disconnect =	synusb_disconnect,
> +	.id_table =	synusb_idtable,
> +	.suspend =	synusb_suspend,
> +	.resume =	synusb_resume,
> +	.pre_reset =	synusb_pre_reset,
> +	.post_reset =	synusb_post_reset,
> +	.reset_resume = synusb_reset_resume,
> +	.supports_autosuspend = 1,

Yet you do not manage the busy state. Do you really want to play
ping-pong with the power state?
