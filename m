Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab0H3O4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:56:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60956 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0H3O4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z8TsHsSphHXTusElRymXIavBfa42rdLIH9TBxUVp37ka/NUuFP65zx6dANViiCvxKU
         Z/Z1l0Jqwcqw5nPAaNMwaPOvnUZ6JKu8hLe/cJvvRmVG8JhpImx43Z1DqAOWLFszgF5T
         /BU6s05jJX0IPbJWancG079a1XfGQhT2Qj/Og=
Date: Mon, 30 Aug 2010 07:55:59 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Xing Wei <weixing@hanwang.com.cn>
Cc: jkosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] input: Add support for Hanwang tablet
Message-ID: <20100830145559.GA7705@core.coreip.homeip.net>
References: <201008301903259846570@hanwang.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008301903259846570@hanwang.com.cn>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Xing,

On Mon, Aug 30, 2010 at 07:03:26PM +0800, Xing Wei wrote:
> From: Xing Wei  <weixing@hanwang.com.cn>
> 
> Add support for Art Master III tablet of BeiJing HanwangTechnology Co, Ltd.
> 
> Signed-off-by: Xing Wei <weixing@hanwang.com.cn>
> 
> ---
> 
> Thanks for jiri's advice,and I'll seriously consider and learn to use git.
> This patch got several warnings("line over 80 characters").
> This is our first time to submit the patch for linux and I really appreciate the comment and advice.
> 

Very mice and clean driver, just a couple of comments below:

> 
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/hid/hid-core.c devel/linux-2.6.35.3/drivers/hid/hid-core.c
> --- linux-2.6.35.3-vanilla/drivers/hid/hid-core.c	2010-08-21 02:55:55.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/hid/hid-core.c	2010-08-25 18:02:15.942574998 +0800
> @@ -1759,6 +1759,11 @@ static bool hid_ignore(struct hid_device
>  		    hdev->product <= USB_DEVICE_ID_SOUNDGRAPH_IMON_LAST)
>  			return true;
>  		break;
> +	case USB_VENDOR_ID_HANWANG:
> +		if (hdev->product >= USB_DEVICE_ID_HANWANG_TABLET_FIRST &&
> +		    hdev->product <= USB_DEVICE_ID_HANWANG_TABLET_LAST)
> +			return true;
> +		break;
>  	}
>  
>  	if (hdev->type == HID_TYPE_USBMOUSE &&
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/hid/hid-ids.h devel/linux-2.6.35.3/drivers/hid/hid-ids.h
> --- linux-2.6.35.3-vanilla/drivers/hid/hid-ids.h	2010-08-21 02:55:55.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/hid/hid-ids.h	2010-08-25 18:00:21.416574999 +0800
> @@ -526,5 +526,8 @@
>  #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
>  #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
>  
> +#define USB_VENDOR_ID_HANWANG		0x0b57
> +#define USB_DEVICE_ID_HANWANG_TABLET_FIRST	0x5000
> +#define USB_DEVICE_ID_HANWANG_TABLET_LAST	0x8fff
>  
>  #endif
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/input/tablet/hanwang.c devel/linux-2.6.35.3/drivers/input/tablet/hanwang.c
> --- linux-2.6.35.3-vanilla/drivers/input/tablet/hanwang.c	1970-01-01 08:00:00.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/input/tablet/hanwang.c	2010-08-30 18:48:08.052906001 +0800
> @@ -0,0 +1,350 @@
> +/*
> + *  USB Hanwang tablet support
> + *
> + *  Copyright (c) 2010 Xing Wei <weixing@hanwang.com.cn>
> + *
> + */
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/usb/input.h>
> +
> +#define DRIVER_VERSION  "v0.1"
> +#define DRIVER_AUTHOR   "Xing Wei <weixing@hanwang.com.cn>"
> +#define DRIVER_DESC     "USB Hanwang tablet driver"
> +#define DRIVER_LICENSE  "GPL"
> +
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE(DRIVER_LICENSE);
> +
> +#define USB_VENDOR_ID_HANWANG		0x0b57
> +#define HANWANG_TABLET_INT_CLASS	0x0003
> +#define HANWANG_TABLET_INT_SUB_CLASS	0x0001
> +#define HANWANG_TABLET_INT_PROTOCOL	0x0002
> +
> +#define ART_MASTERIII_PKGLEN_MAX	10
> +
> +/* match vendor and interface info  */
> +#define HANWANG_TABLET_DEVICE(vend, cl, sc, pr) \
> +	.match_flags = USB_DEVICE_ID_MATCH_VENDOR \
> +		| USB_DEVICE_ID_MATCH_INT_INFO, \
> +	.idVendor = (vend), \
> +	.bInterfaceClass = (cl), \
> +	.bInterfaceSubClass = (sc), \
> +	.bInterfaceProtocol = (pr)
> +
> +struct hanwang_state{

Doesn't checkpatch script complain about nissing space before the
opening curly bracket?

> +	unsigned int tool_style;
> +	unsigned int tool_state;
> +};
> +struct hanwang{
> +	char name[64];
> +	unsigned char *data;
> +	dma_addr_t data_dma;
> +	struct input_dev *dev;
> +	struct usb_device *usbdev;
> +	struct urb *irq;
> +	struct hanwang_features *features;

This should probably be const.

> +	struct hanwang_state hws;
> +	char phys[32];
> +};
> +
> +struct hanwang_features{
> +	unsigned short pid;
> +	int pkg_len;
> +	char *name;
> +	int max_x;
> +	int max_y;
> +	int max_tilt_x;
> +	int max_tilt_y;
> +	int max_pressure;
> +	int max_distance;
> +};
> +
> +
> +struct hanwang_features hanwang_features_arr[] = {

This should probably be static const as well.

> +	{0x8528, ART_MASTERIII_PKGLEN_MAX, "Hanwang Art Master III 0906",
> +	0x5757, 0x3692, 0x3f, 0x7f, 2048, 0xff},
> +	{0x8529, ART_MASTERIII_PKGLEN_MAX, "Hanwang Art Master III 0604",
> +	0x3d84, 0x2672, 0x3f, 0x7f, 2048, 0xff},
> +	{0x852a, ART_MASTERIII_PKGLEN_MAX, "Hanwang Art Master III 1308",
> +	0x7f00, 0x4f60, 0x3f, 0x7f, 2048, 0xff},
> +};
> +
> +static const int hw_eventtypes[] = {
> +	EV_KEY, EV_ABS,
> +};
> +
> +static const int hw_absevents[] = {
> +	ABS_X, ABS_Y, ABS_TILT_X, ABS_TILT_Y, ABS_WHEEL,
> +	ABS_PRESSURE, ABS_DISTANCE
> +};
> +
> +static const int hw_btnevents[] = {
> +	BTN_STYLUS, BTN_STYLUS2, BTN_TOOL_PEN, BTN_TOOL_RUBBER,
> +	BTN_TOOL_MOUSE, BTN_0, BTN_1, BTN_2, BTN_3, BTN_4,
> +	BTN_5, BTN_6, BTN_7, BTN_8
> +};
> +
> +static struct usb_device_id hanwang_ids[] = {
> +	{HANWANG_TABLET_DEVICE(USB_VENDOR_ID_HANWANG, HANWANG_TABLET_INT_CLASS,
> +		HANWANG_TABLET_INT_SUB_CLASS, HANWANG_TABLET_INT_PROTOCOL)},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(usb, hanwang_ids);
> +
> +static int hanwang_open(struct input_dev *dev)
> +{
> +	struct hanwang *hanwang = input_get_drvdata(dev);
> +
> +	hanwang->irq->dev = hanwang->usbdev;
> +	if (usb_submit_urb(hanwang->irq, GFP_KERNEL))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static void hanwang_close(struct input_dev *dev)
> +{
> +	struct hanwang *hanwang = input_get_drvdata(dev);
> +
> +	usb_kill_urb(hanwang->irq);
> +}
> +
> +static void hanwang_irq(struct urb *urb)
> +{
> +
> +	struct hanwang *hanwang = urb->context;
> +	unsigned char *data = hanwang->data;
> +	struct input_dev *dev = hanwang->dev;
> +	struct hanwang_state *phws = &hanwang->hws;
> +	int retval;
> +
> +	switch (urb->status) {
> +	case 0:
> +		/* success */;
> +		break;
> +	case -ECONNRESET:
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +		/* this urb is terminated, clean up */
> +		err("%s - urb shutting down with status: %d", __func__, urb->status);

Consider using dev_err() and friends.

> +		return;
> +	default:
> +		err("%s - nonzero urb status received: %d", __func__, urb->status);
> +		goto exit;
> +	}
> +
> +	/* data packet */
> +	if (data[0] == 0x02) {
> +		/* tool prox out */
> +		if (data[1] == 0x80) {
> +			input_report_key(dev, phws->tool_style, 0);
> +		} else if (data[1] == 0xc2) {	/* first time tool prox in */
> +			switch (data[3] & 0xf0) {
> +			case 0x20:
> +				phws->tool_style = BTN_TOOL_PEN;
> +				input_report_key(dev, BTN_TOOL_PEN, 1);
> +				break;
> +			case 0xa0:
> +				phws->tool_style = BTN_TOOL_RUBBER;
> +				input_report_key(dev, BTN_TOOL_RUBBER, 1);
> +				break;
> +			default:
> +				dbg("unknown tablet tool %02x ", data[0]);
> +				break;
> +			}
> +		} else {	/* tool data packet */
> +			input_report_abs(dev, ABS_X, (data[2] << 8) | data[3]);
> +			input_report_abs(dev, ABS_Y, (data[4] << 8) | data[5]);
> +			input_report_abs(dev, ABS_PRESSURE, (data[6] << 3) | ((data[7] & 0xc0) >> 5) | (data[1] & 0x01));
> +			input_report_abs(dev, ABS_TILT_X, data[7] & 0x3f);
> +			input_report_abs(dev, ABS_TILT_Y, data[8] & 0x7f);
> +			input_report_key(dev, BTN_STYLUS, (data[1] & 0x02) >> 1);
> +			input_report_key(dev, BTN_STYLUS2, (data[1] & 0x04) >> 2);
> +		}
> +	} else if (data[0] == 0x0c) {	/* roll wheel */
> +		if (data[1]) {
> +			input_report_abs(dev, ABS_WHEEL, data[1]);
> +		}
> +		input_report_key(dev, BTN_0, data[2]);
> +		input_report_key(dev, BTN_1, data[3] & 0x01);
> +		input_report_key(dev, BTN_2, data[3] & 0x02);
> +		input_report_key(dev, BTN_3, data[3] & 0x04);
> +		input_report_key(dev, BTN_4, data[3] & 0x08);
> +		input_report_key(dev, BTN_5, data[3] & 0x10);
> +		input_report_key(dev, BTN_6, data[3] & 0x20);
> +		input_report_key(dev, BTN_7, data[3] & 0x30);
> +		input_report_key(dev, BTN_8, data[3] & 0x40);
> +	} else {
> +		err("error packet  %02x ", data[0]);
> +	}
> +
> +	input_sync(dev);
> +
> +exit:
> +	retval = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (retval)
> +		printk(KERN_INFO "%s - usb_submit_urb failed with result %d",
> +		     __func__, retval);
> +}
> +
> +static int hanwang_get_features(struct usb_device *dev , struct hanwang *hanwang)

bool?

> +{
> +	int i, total_features;
> +
> +	total_features = sizeof(hanwang_features_arr) / sizeof(struct hanwang_features);

ARRAY_SIZE();

> +	for (i = 0; i < total_features; i++) {
> +		if (le16_to_cpu(dev->descriptor.idProduct) == hanwang_features_arr[i].pid) {
> +			hanwang->features = &hanwang_features_arr[i];
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static int hanwang_probe(struct usb_interface *intf, const struct usb_device_id *id)
> +{
> +	struct usb_device *dev = interface_to_usbdev(intf);
> +	struct usb_endpoint_descriptor *endpoint;
> +	struct hanwang *hanwang;
> +	struct input_dev *input_dev;
> +	int error = -ENOMEM;
> +	int i;
> +
> +	hanwang = kzalloc(sizeof(struct hanwang), GFP_KERNEL);
> +	input_dev = input_allocate_device();
> +	if (!hanwang || !input_dev)
> +		goto fail1;
> +
> +	if (!hanwang_get_features(dev, hanwang)) {
> +		err("hanwang device not be supported now");
> +		goto fail1;
> +	}
> +
> +	hanwang->data = usb_alloc_coherent(dev, hanwang->features->pkg_len, GFP_KERNEL, &hanwang->data_dma);
> +	if (!hanwang->data)
> +		goto fail1;
> +
> +	hanwang->irq = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!hanwang->irq)
> +		goto fail2;
> +
> +	hanwang->usbdev = dev;
> +	hanwang->dev = input_dev;
> +
> +	usb_make_path(dev, hanwang->phys, sizeof(hanwang->phys));
> +	strlcat(hanwang->phys, "/input0", sizeof(hanwang->phys));
> +
> +	strlcpy(hanwang->name, hanwang->features->name, sizeof(hanwang->name));
> +	input_dev->name = hanwang->name;
> +	input_dev->phys = hanwang->phys;
> +	usb_to_input_id(dev, &input_dev->id);
> +	input_dev->dev.parent = &intf->dev;
> +
> +	input_set_drvdata(input_dev, hanwang);
> +
> +	input_dev->open = hanwang_open;
> +	input_dev->close = hanwang_close;
> +
> +	for (i = 0; i < ARRAY_SIZE(hw_eventtypes); ++i)
> +		__set_bit(hw_eventtypes[i], input_dev->evbit);
> +
> +	for (i = 0; i < ARRAY_SIZE(hw_absevents); ++i)
> +		__set_bit(hw_absevents[i], input_dev->absbit);
> +
> +	for (i = 0; i < ARRAY_SIZE(hw_btnevents); ++i)
> +		__set_bit(hw_btnevents[i], input_dev->keybit);
> +
> +	input_set_abs_params(input_dev, ABS_X, 0, hanwang->features->max_x, 4, 0);
> +	input_set_abs_params(input_dev, ABS_Y, 0, hanwang->features->max_y, 4, 0);
> +	input_set_abs_params(input_dev, ABS_TILT_X, 0, hanwang->features->max_tilt_x, 0, 0);
> +	input_set_abs_params(input_dev, ABS_TILT_Y, 0, hanwang->features->max_tilt_y, 0, 0);
> +	input_set_abs_params(input_dev, ABS_PRESSURE, 0, hanwang->features->max_pressure, 0, 0);
> +	input_set_abs_params(input_dev, ABS_DISTANCE, 0, hanwang->features->max_distance, 0, 0);
> +
> +	endpoint = &intf->cur_altsetting->endpoint[0].desc;
> +	usb_fill_int_urb(hanwang->irq, dev,
> +			usb_rcvintpipe(dev, endpoint->bEndpointAddress),
> +			hanwang->data, hanwang->features->pkg_len,
> +			hanwang_irq, hanwang, endpoint->bInterval);
> +	hanwang->irq->transfer_dma = hanwang->data_dma;
> +	hanwang->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	error = input_register_device(hanwang->dev);
> +	if (error)
> +		goto fail3;
> +
> +	usb_set_intfdata(intf, hanwang);
> +
> +	return 0;
> +
> + fail3:	usb_free_urb(hanwang->irq);
> + fail2:	usb_free_coherent(dev, hanwang->features->pkg_len, hanwang->data, hanwang->data_dma);
> + fail1:	input_free_device(input_dev);
> +	kfree(hanwang);
> +	return error;
> +
> +}
> +
> +static void hanwang_disconnect(struct usb_interface *intf)
> +{
> +	struct hanwang *hanwang = usb_get_intfdata(intf);
> +
> +	usb_set_intfdata(intf, NULL);
> +	if (hanwang) {
> +		usb_kill_urb(hanwang->irq);
> +		input_unregister_device(hanwang->dev);
> +		usb_free_urb(hanwang->irq);
> +		usb_free_coherent(interface_to_usbdev(intf), hanwang->features->pkg_len,
> +					hanwang->data, hanwang->data_dma);
> +		kfree(hanwang);
> +	}
> +}
> +
> +static struct usb_driver hanwang_driver = {
> +	.name =		"hanwang",
> +	.probe =	hanwang_probe,
> +	.disconnect =	hanwang_disconnect,
> +	.id_table =	hanwang_ids,
> +};
> +
> +static int __init hanwang_init(void)
> +{
> +	int result = usb_register(&hanwang_driver);
> +	if (result == 0)
> +		printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ":"
> +		     DRIVER_DESC "\n");

I'd rather see this banner go - boot is noisy enough as it is...

> +	return result;
> +}
> +
> +static void __exit hanwang_exit(void)
> +{
> +	usb_deregister(&hanwang_driver);
> +}
> +
> +module_init(hanwang_init);
> +module_exit(hanwang_exit);
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/input/tablet/Kconfig devel/linux-2.6.35.3/drivers/input/tablet/Kconfig
> --- linux-2.6.35.3-vanilla/drivers/input/tablet/Kconfig	2010-08-21 02:55:55.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/input/tablet/Kconfig	2010-08-30 16:09:11.601568992 +0800
> @@ -75,4 +75,17 @@ config TABLET_USB_WACOM
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called wacom.
>  
> +config TABLET_USB_HANWANG
> +	tristate "Hanwang Art Master III tablet support (USB)"
> +	depends on USB_ARCH_HAS_HCD
> +	select USB
> +	help
> +	  Say Y here if you want to use the USB version of the Hanwang Art
> +	  Master III tablet.  Make sure to say Y to "Mouse support"
> +	  (CONFIG_INPUT_MOUSEDEV) and/or "Event interface support"
> +	  (CONFIG_INPUT_EVDEV) as well.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called hanwang.
> +
>  endif
> diff -uprN -X linux-2.6.35.3-vanilla/Documentation/dontdiff linux-2.6.35.3-vanilla/drivers/input/tablet/Makefile devel/linux-2.6.35.3/drivers/input/tablet/Makefile
> --- linux-2.6.35.3-vanilla/drivers/input/tablet/Makefile	2010-08-21 02:55:55.000000000 +0800
> +++ devel/linux-2.6.35.3/drivers/input/tablet/Makefile	2010-08-30 14:06:24.827403978 +0800
> @@ -10,3 +10,4 @@ obj-$(CONFIG_TABLET_USB_AIPTEK)	+= aipte
>  obj-$(CONFIG_TABLET_USB_GTCO)	+= gtco.o
>  obj-$(CONFIG_TABLET_USB_KBTAB)	+= kbtab.o
>  obj-$(CONFIG_TABLET_USB_WACOM)	+= wacom.o
> +obj-$(CONFIG_TABLET_USB_HANWANG) += hanwang.o
> 

Please keep the Makefile and Kconfig  sorted alphabetically.

Thanks.

-- 
Dmitry
