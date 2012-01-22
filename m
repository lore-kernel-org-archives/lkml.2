Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2AVUqZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 15:46:25 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38327 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2AVUqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 15:46:23 -0500
From: Oliver Neukum <oliver@neukum.org>
To: ondra.havel@gmail.com
Subject: Re: [PATCH] input: Hanvon Art Master I and Rollick tablet support (USB)
Date: Sun, 22 Jan 2012 21:48:12 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <alpine.LRH.2.00.1201222100130.6825@linux.fjfi.cvut.cz>
In-Reply-To: <alpine.LRH.2.00.1201222100130.6825@linux.fjfi.cvut.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201222148.13247.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 22. Januar 2012, 21:07:49 schrieb ondra.havel@gmail.com:

> +static void hanvon_irq(struct urb *urb)
> +{
> +	struct hanvon *hanvon = urb->context;
> +	unsigned char *data = hanvon->data;
> +	struct input_dev *dev = hanvon->dev;
> +	int retval;
> +
> +	switch (urb->status) {
> +		case 0:
> +			/* success */
> +			break;
> +		case -ECONNRESET:
> +		case -ENOENT:
> +		case -ESHUTDOWN:
> +			/* this urb is terminated, clean up */
> +			dbg("%s - urb shutting down with status: %d", __func__, urb->status);
> +			return;
> +		default:
> +			dbg("%s - nonzero urb status received: %d", __func__, urb->status);
> +			goto exit;
> +	}
> +
> +	switch(data[0]) {
> +		case 0x01:	/* button press */
> +			if(data[1]==0x55)	/* left side */
> +				report_buttons(hanvon,lbuttons,data[2]);
> +
> +			if(data[3]==0xaa)	/* right side (am1107, am1209) */
> +				report_buttons(hanvon,rbuttons,data[4]);
> +			break;
> +		case 0x02:	/* position change */
> +			if((data[1] & 0xf0) != 0) {
> +				input_report_abs(dev, ABS_X, get_unaligned_be16(&data[2]));
> +				input_report_abs(dev, ABS_Y, get_unaligned_be16(&data[4]));

Why unaligned?

> +				input_report_abs(dev, ABS_TILT_X, data[7] & 0x3f);
> +				input_report_abs(dev, ABS_TILT_Y, data[8]);
> +				input_report_abs(dev, ABS_PRESSURE, get_unaligned_be16(&data[6])>>6);
> +			}
> +
> +		input_report_key(dev, BTN_LEFT, data[1] & 0x1);
> +		input_report_key(dev, BTN_RIGHT, data[1] & 0x2);		/* stylus button pressed (right click) */
> +		input_report_key(dev, lbuttons[0], data[1] & 0x20);
> +		break;
> +	}
> +
> +	input_sync(dev);
> +
> +exit:
> +	retval = usb_submit_urb (urb, GFP_ATOMIC);
> +	if (retval)
> +		err("%s - usb_submit_urb failed with result %d", __func__, retval);
> +}

[..]
> +static int hanvon_probe(struct usb_interface *intf, const struct usb_device_id *id)
> +{
> +	struct usb_device *dev = interface_to_usbdev(intf);
> +	struct usb_endpoint_descriptor *endpoint;
> +	struct hanvon *hanvon;
> +	struct input_dev *input_dev;
> +	int error = -ENOMEM, i;
> +
> +	hanvon = kzalloc(sizeof(struct hanvon), GFP_KERNEL);
> +	input_dev = input_allocate_device();
> +	if (!hanvon || !input_dev)
> +		goto fail1;
> +
> +	hanvon->data = (unsigned char *)usb_alloc_coherent(dev, USB_AM_PACKET_LEN, GFP_KERNEL, &hanvon->data_dma);
> +	if (!hanvon->data)
> +		goto fail1;
> +
> +	hanvon->irq = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!hanvon->irq)
> +		goto fail2;
> +
> +	hanvon->usbdev = dev;
> +	hanvon->dev = input_dev;
> +
> +	usb_make_path(dev, hanvon->phys, sizeof(hanvon->phys));
> +	strlcat(hanvon->phys, "/input0", sizeof(hanvon->phys));
> +
> +	input_dev->name = "Hanvon Artmaster I tablet";
> +	input_dev->phys = hanvon->phys;
> +	usb_to_input_id(dev, &input_dev->id);
> +	input_dev->dev.parent = &intf->dev;
> +
> +	input_set_drvdata(input_dev, hanvon);
> +
> +	input_dev->open = hanvon_open;
> +	input_dev->close = hanvon_close;
> +
> +	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS) | BIT_MASK(EV_REL);
> +	input_dev->keybit[BIT_WORD(BTN_DIGI)] |= BIT_MASK(BTN_TOOL_PEN) | BIT_MASK(BTN_TOUCH);
> +	input_dev->keybit[BIT_WORD(BTN_LEFT)] |= BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);
> +	for(i=0;i<sizeof(lbuttons)/sizeof(lbuttons[0]);i++)
> +		__set_bit(lbuttons[i], input_dev->keybit);
> +	for(i=0;i<sizeof(rbuttons)/sizeof(rbuttons[0]);i++)
> +		__set_bit(rbuttons[i], input_dev->keybit);
> +
> +	input_set_abs_params(input_dev, ABS_X, 0, AM_MAX_ABS_X, 4, 0);
> +	input_set_abs_params(input_dev, ABS_Y, 0, AM_MAX_ABS_Y, 4, 0);
> +	input_set_abs_params(input_dev, ABS_TILT_X, 0, AM_MAX_TILT_X, 0, 0);
> +	input_set_abs_params(input_dev, ABS_TILT_Y, 0, AM_MAX_TILT_Y, 0, 0);
> +	input_set_abs_params(input_dev, ABS_PRESSURE, 0, AM_MAX_PRESSURE, 0, 0);
> +	input_set_capability(input_dev, EV_REL, REL_WHEEL);
> +
> +	endpoint = &intf->cur_altsetting->endpoint[0].desc;
> +
> +	usb_fill_int_urb(hanvon->irq, dev,
> +			 usb_rcvintpipe(dev, endpoint->bEndpointAddress),
> +			 hanvon->data, USB_AM_PACKET_LEN,
> +			 hanvon_irq, hanvon, endpoint->bInterval);
> +	hanvon->irq->transfer_dma = hanvon->data_dma;
> +	hanvon->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	error = input_register_device(hanvon->dev);
> +	if (error)
> +		goto fail3;
> +
> +	usb_set_intfdata(intf, hanvon);
> +	return 0;
> +
> +fail3:	usb_free_urb(hanvon->irq);
> +fail2:	usb_free_coherent(dev, USB_AM_PACKET_LEN, hanvon->data, hanvon->data_dma);
> +fail1:	input_free_device(input_dev);
> +	kfree(hanvon);
> +	return error;
> +}
> +
> +static void hanvon_disconnect(struct usb_interface *intf)
> +{
> +	struct hanvon *hanvon = usb_get_intfdata(intf);
> +
> +	usb_set_intfdata(intf, NULL);
> +	if (hanvon) {

How can it be NULL?

> +		usb_kill_urb(hanvon->irq);

Here you race with open()

> +		input_unregister_device(hanvon->dev);
> +		usb_free_urb(hanvon->irq);
> +		usb_free_coherent(interface_to_usbdev(intf), USB_AM_PACKET_LEN, hanvon->data, hanvon->data_dma);
> +		kfree(hanvon);
> +	}
> +}

	Regards
		Oliver
