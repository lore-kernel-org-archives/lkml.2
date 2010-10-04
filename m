Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405Ab0JDTQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 15:16:47 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35483 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab0JDTQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 15:16:45 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Bastien Nocera <hadess@hadess.net>
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
Date: Mon, 4 Oct 2010 21:17:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-input" <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1285844276.26405.26.camel@cookie.hadess.net>
In-Reply-To: <1285844276.26405.26.camel@cookie.hadess.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010042117.41786.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 30. September 2010, 12:57:55 schrieb Bastien Nocera:

> +static int get_key(int data)
> +{
> +	switch (data) {
> +	case 0x02:
> +	case 0x03:
> +		/* menu */
> +		return 1;
> +	case 0x04:
> +	case 0x05:
> +		/* >" */
> +		return 2;
> +	case 0x06:
> +	case 0x07:
> +		/* >> */
> +		return 3;
> +	case 0x08:
> +	case 0x09:
> +		/* << */
> +		return 4;
> +	case 0x0a:
> +	case 0x0b:
> +		/* + */
> +		return 5;
> +	case 0x0c:
> +	case 0x0d:
> +		/* - */
> +		return 6;
> +	case 0x5c:
> +		/* Middle button, on newer remotes,
> +		 * part of a 2 packet-command */
> +		return -7;
> +	default:
> +		return -1;
> +	}

Is this really better than a table lookup?


> +
> +static void new_data(struct appleir *appleir, u8 *data, int len)
> +{
> +	static const u8 keydown[] = { 0x25, 0x87, 0xee };
> +	static const u8 keyrepeat[] = { 0x26, };
> +	static const u8 flatbattery[] = { 0x25, 0x87, 0xe0 };
> +
> +	if (debug)
> +		dump_packet(appleir, "received", data, len);
> +
> +	if (len != 5)
> +		return;
> +
> +	if (!memcmp(data, keydown, sizeof(keydown))) {
> +		int index;
> +
> +		/* If we already have a key down, take it up before marking
> +		   this one down */
> +		if (appleir->current_key)
> +			key_up(appleir, appleir->current_key);

This races with the timer. You can end up with a key reported up twice.

> +		/* Handle dual packet commands */
> +		if (appleir->prev_key_idx > 0)
> +			index = appleir->prev_key_idx;
> +		else
> +			index = get_key(data[4]);
> +
> +		if (index > 0) {
> +			appleir->current_key = appleir->keymap[index];
> +
> +			key_down(appleir, appleir->current_key);
> +			/* Remote doesn't do key up, either pull them up, in the test
> +			   above, or here set a timer which pulls them up after 1/8 s */
> +			mod_timer(&appleir->key_up_timer, jiffies + HZ / 8);
> +			appleir->prev_key_idx = 0;
> +			return;
> +		} else if (index == -7) {
> +			/* Remember key for next packet */
> +			appleir->prev_key_idx = 0 - index;
> +			return;
> +		}
> +	}


> +static int appleir_open(struct input_dev *dev)
> +{
> +	struct appleir *appleir = input_get_drvdata(dev);
> +	struct usb_interface *intf = usb_ifnum_to_if(appleir->usbdev, 0);
> +	int r;
> +
> +	r = usb_autopm_get_interface(intf);
> +	if (r) {
> +		dev_err(&intf->dev,
> +			"%s(): usb_autopm_get_interface() = %d\n", __func__, r);
> +		return r;
> +	}
> +
> +	mutex_lock(&appleir_mutex);
> +
> +	if (usb_submit_urb(appleir->urb, GFP_ATOMIC)) {

No need for ATOMIC

> +		r = -EIO;
> +		goto fail;
> +	}
> +
> +	appleir->flags |= APPLEIR_OPENED;
> +
> +	mutex_unlock(&appleir_mutex);
> +
> +	usb_autopm_put_interface(intf);

This does not enable remote wakeup. Why? Looks like a bug.

> +	return 0;
> +fail:
> +	mutex_unlock(&appleir_mutex);
> +	usb_autopm_put_interface(intf);
> +	return r;
> +}
> +
> +static void appleir_close(struct input_dev *dev)
> +{
> +	struct appleir *appleir = input_get_drvdata(dev);
> +
> +	mutex_lock(&appleir_mutex);
> +
> +	if (!(appleir->flags & APPLEIR_SUSPENDED)) {
> +		usb_kill_urb(appleir->urb);
> +		del_timer_sync(&appleir->key_up_timer);

You can close with a key unreleased.

> +	}
> +
> +	appleir->flags &= ~APPLEIR_OPENED;
> +
> +	mutex_unlock(&appleir_mutex);
> +}
> +


> +static int appleir_suspend(struct usb_interface *interface,
> +			   pm_message_t message)
> +{
> +	struct appleir *appleir = usb_get_intfdata(interface);
> +
> +	mutex_lock(&appleir_mutex);
> +	if (appleir->flags & APPLEIR_OPENED)

Why bother checking?

> +		usb_kill_urb(appleir->urb);

If the system goes to sleep you'd better report a pressed key
as released here and kill the timer.
> +
> +	appleir->flags |= APPLEIR_SUSPENDED;
> +
> +	mutex_unlock(&appleir_mutex);
> +
> +	return 0;
> +}
> +
> +static int appleir_resume(struct usb_interface *interface)
> +{
> +	struct appleir *appleir;
> +	int r = 0;
> +
> +	appleir = usb_get_intfdata(interface);
> +
> +	mutex_lock(&appleir_mutex);
> +	if (appleir->flags & APPLEIR_OPENED) {
> +		struct usb_endpoint_descriptor *endpoint;
> +
> +		endpoint = &interface->cur_altsetting->endpoint[0].desc;
> +		usb_fill_int_urb(appleir->urb, appleir->usbdev,
> +				 usb_rcvintpipe(appleir->usbdev, endpoint->bEndpointAddress),
> +				 appleir->data, 8,
> +				 appleir_urb, appleir, endpoint->bInterval);
> +		appleir->urb->transfer_dma = appleir->dma_buf;
> +		appleir->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +		/* And reset the USB device */
> +		if (usb_submit_urb(appleir->urb, GFP_ATOMIC))

GFP_NOIO is sufficient.

> +static struct usb_driver appleir_driver = {
> +	.name                 = "appleir",
> +	.probe                = appleir_probe,
> +	.disconnect           = appleir_disconnect,
> +	.suspend              = appleir_suspend,
> +	.resume               = appleir_resume,
> +	.reset_resume         = appleir_resume,
> +	.id_table             = appleir_ids,

If you want runtime power management you need to define
supports_autosuspend.

	Regards
		Oliver
