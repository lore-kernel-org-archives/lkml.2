Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab2ADJyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:54:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab2ADJye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:54:34 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] input: Synaptics USB device driver
Date: Wed, 4 Jan 2012 10:56:20 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Jan Steinhoff <mail@jan-steinhoff.de>,
        Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120103194033.779cb829@greyhound> <201201041020.41795.oneukum@suse.de> <20120104094103.GA29069@core.coreip.homeip.net>
In-Reply-To: <20120104094103.GA29069@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201041056.20226.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 4. Januar 2012, 10:41:03 schrieb Dmitry Torokhov:


> +static void synusb_irq(struct urb *urb)
> +{
> +	struct synusb *synusb = urb->context;
> +	int error;
> +
> +	/* Check our status in case we need to bail out early. */
> +	switch (urb->status) {
> +	case 0:
> +		usb_mark_last_busy(synusb->udev);
> +		break;
> +
> +	case -EOVERFLOW:
> +		dev_err(&synusb->intf->dev,
> +			"%s: OVERFLOW with data length %d, actual length is %d\n",
> +			__func__, SYNUSB_RECV_SIZE, urb->actual_length);

Do you really want to fall through here?

> +
> +	/* Device went away so don't keep trying to read from it. */
> +	case -ECONNRESET:
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +		return;
> +
> +	default:
> +		goto resubmit;
> +		break;
> +	}
> +
> +	if (synusb->flags & SYNUSB_STICK)
> +		synusb_report_stick(synusb);
> +	else
> +		synusb_report_touchpad(synusb);
> +
> +resubmit:
> +	error = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (error && error != -EPERM)
> +		dev_err(&synusb->intf->dev,
> +			"%s - usb_submit_urb failed with result: %d",
> +			__func__, error);
> +}
> +

[..]
> +static int synusb_open(struct input_dev *dev)
> +{
> +	struct synusb *synusb = input_get_drvdata(dev);
> +	int retval = 0;
> +
> +	dev_err(&synusb->intf->dev, "%s\n", __func__);
> +
> +	if (usb_autopm_get_interface(synusb->intf) < 0)
> +		return -EIO;
> +
> +	if (usb_submit_urb(synusb->urb, GFP_KERNEL)) {
> +		dev_err(&synusb->intf->dev,
> +			"%s - usb_submit_urb failed", __func__);
> +		retval = -EIO;
> +		goto out;
> +	}
> +
> +	synusb->intf->needs_remote_wakeup = 1;
> +
> +out:
> +	usb_autopm_put_interface(synusb->intf);
> +	dev_err(&synusb->intf->dev, "%s done: %d\n", __func__, retval);
> +	return retval;
> +}
> +
> +static void synusb_close(struct input_dev *dev)
> +{
> +	struct synusb *synusb = input_get_drvdata(dev);
> +	int autopm_error;
> +
> +	autopm_error = usb_autopm_get_interface(synusb->intf);
> +
> +	usb_kill_urb(synusb->urb);
> +	synusb->intf->needs_remote_wakeup = 0;
> +
> +	if (!autopm_error)
> +		usb_autopm_put_interface(synusb->intf);
> +}
> +
> +static int synusb_probe(struct usb_interface *intf,
> +			const struct usb_device_id *id)
> +{
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	struct usb_endpoint_descriptor *ep;
> +	struct synusb *synusb;
> +	struct input_dev *input_dev;
> +	unsigned int intf_num = intf->cur_altsetting->desc.bInterfaceNumber;
> +	unsigned int altsetting = min(intf->num_altsetting, 1U);
> +	int error;
> +
> +	error = usb_set_interface(udev, intf_num, altsetting);
> +	if (error) {
> +		dev_err(&udev->dev,
> +			"Can not set alternate setting to %i, error: %i",
> +			altsetting, error);
> +		return error;
> +	}
> +
> +	ep = synusb_get_in_endpoint(intf->cur_altsetting);
> +	if (!ep)
> +		return -ENODEV;
> +
> +	synusb = kzalloc(sizeof(*synusb), GFP_KERNEL);
> +	input_dev = input_allocate_device();
> +	if (!synusb || !input_dev) {
> +		error = -ENOMEM;
> +		goto err_free_mem;
> +	}
> +
> +	synusb->udev = udev;
> +	synusb->intf = intf;
> +	synusb->input = input_dev;
> +
> +	synusb->flags = id->driver_info;
> +	if (test_bit(SYNUSB_STICK, &synusb->flags) &&
> +	    test_bit(SYNUSB_STICK, &synusb->flags)) {

??? Voodoo ???

> +		/*
> +		 * This is a combo device, we need to leave only proper
> +		 * capability, depending on the interface.
> +		 */
> +		clear_bit(intf_num == 1 ? SYNUSB_TOUCHPAD : SYNUSB_STICK,
> +			  &synusb->flags);
> +	}
> +
> +	synusb->urb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!synusb->urb) {
> +		error = -ENOMEM;
> +		goto err_free_mem;
> +	}
> +
> +	synusb->data = usb_alloc_coherent(udev, SYNUSB_RECV_SIZE, GFP_KERNEL,
> +					  &synusb->urb->transfer_dma);
> +	if (!synusb->data) {
> +		error = -ENOMEM;
> +		goto err_free_urb;
> +	}
> +
> +	usb_fill_int_urb(synusb->urb, udev,
> +			 usb_rcvintpipe(udev, ep->bEndpointAddress),
> +			 synusb->data, SYNUSB_RECV_SIZE,
> +			 synusb_irq, synusb,
> +			 ep->bInterval);
> +	synusb->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;

According to the comment in the original driver you must submit the URB.
Are you sure not doing so is save?

> +
> +	if (udev->manufacturer)
> +		strlcpy(synusb->name, udev->manufacturer,
> +			sizeof(synusb->name));
> +
> +	if (udev->product) {
> +		if (udev->manufacturer)
> +			strlcat(synusb->name, " ", sizeof(synusb->name));
> +		strlcat(synusb->name, udev->product, sizeof(synusb->name));
> +	}
> +
> +	if (!strlen(synusb->name))
> +		snprintf(synusb->name, sizeof(synusb->name),
> +			 "USB Synaptics Device %04x:%04x",
> +			 le16_to_cpu(udev->descriptor.idVendor),
> +			 le16_to_cpu(udev->descriptor.idProduct));
> +
> +	if (synusb->flags & SYNUSB_STICK)
> +		strlcat(synusb->name, " (Stick) ", sizeof(synusb->name));
> +
> +	usb_make_path(udev, synusb->phys, sizeof(synusb->phys));
> +	strlcat(synusb->phys, "/input0", sizeof(synusb->phys));
> +
> +	input_dev->name = synusb->name; // synusb_get_name(synusb);
> +	input_dev->phys = synusb->phys;
> +	usb_to_input_id(udev, &input_dev->id);
> +	input_dev->dev.parent = &synusb->intf->dev;
> +
> +	input_dev->open = synusb_open;
> +	input_dev->close = synusb_close;
> +
> +	input_set_drvdata(input_dev, synusb);
> +
> +	__set_bit(EV_ABS, input_dev->evbit);
> +	__set_bit(EV_KEY, input_dev->evbit);
> +
> +	if (synusb->flags & SYNUSB_STICK) {
> +		__set_bit(EV_REL, input_dev->evbit);
> +		__set_bit(REL_X, input_dev->relbit);
> +		__set_bit(REL_Y, input_dev->relbit);
> +		input_set_abs_params(input_dev, ABS_PRESSURE, 0, 127, 0, 0);
> +	} else {
> +		input_set_abs_params(input_dev, ABS_X, xmin, xmax, 0, 0);
> +		input_set_abs_params(input_dev, ABS_Y, ymin, ymax, 0, 0);
> +		input_set_abs_params(input_dev, ABS_PRESSURE, 0, 255, 0, 0);
> +		input_set_abs_params(input_dev, ABS_TOOL_WIDTH, 0, 15, 0, 0);
> +		__set_bit(BTN_TOUCH, input_dev->keybit);
> +		__set_bit(BTN_TOOL_FINGER, input_dev->keybit);
> +		__set_bit(BTN_TOOL_DOUBLETAP, input_dev->keybit);
> +		__set_bit(BTN_TOOL_TRIPLETAP, input_dev->keybit);
> +	}
> +
> +	__set_bit(BTN_LEFT, input_dev->keybit);
> +	__set_bit(BTN_RIGHT, input_dev->keybit);
> +	__set_bit(BTN_MIDDLE, input_dev->keybit);
> +	if (synusb->flags & SYNUSB_AUXDISPLAY)
> +		__set_bit(BTN_MISC, input_dev->keybit);
> +
> +	error = input_register_device(input_dev);
> +	if (error) {
> +		dev_err(&udev->dev, "Failed to register input device, error %d\n",
> +			error);
> +		goto err_free_dma;
> +	}
> +
> +	usb_set_intfdata(intf, synusb);
> +	return 0;
> +
> +err_free_dma:
> +	usb_free_coherent(udev, SYNUSB_RECV_SIZE, synusb->data,
> +			  synusb->urb->transfer_dma);
> +err_free_urb:
> +	usb_free_urb(synusb->urb);
> +err_free_mem:
> +	input_free_device(input_dev);
> +	kfree(synusb);
> +
> +	return error;
> +}
> +

[..]
> +static struct usb_driver synusb_driver = {
> +	.name		= "synaptics_usb",
> +	.probe		= synusb_probe,
> +	.disconnect	= synusb_disconnect,
> +	.id_table	= synusb_idtable,
> +	.suspend	= synusb_suspend,
> +	.resume		= synusb_resume,
> +	.reset_resume	= synusb_reset_resume,

You've killed the support for reset. That is not cool.

> +	.supports_autosuspend = 1,
> +};

	Regards
		Oliver
