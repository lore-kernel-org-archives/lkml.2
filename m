Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2DWV1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:27:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35444 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719Ab2DWV1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:27:06 -0400
Date: Mon, 23 Apr 2012 18:26:59 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/6] hid: Create a generic device group
Message-ID: <20120423212659.GD18564@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <1335175627-2270-5-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335175627-2270-5-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

* Henrik Rydberg <rydberg@euromail.se> [2012-04-23 12:07:05 +0200]:

> Devices that do not have a special driver are handled by the generic
> driver. This patch does the same thing using device groups; Instead of
> forcing a particular driver, the appropriate driver is picked up by
> udev. As a consequence, one can now move a device from generic to
> specific handling by a simple rebind. By adding a new device id to the
> generic driver, the same thing can be done in reverse.
> 
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/hid/hid-core.c        |    9 +--------
>  drivers/hid/usbhid/hid-core.c |    2 +-
>  include/linux/hid.h           |   12 ++++++------
>  net/bluetooth/hidp/core.c     |    2 +-
>  4 files changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 20daee5..cb5a103 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1800,14 +1800,7 @@ static int hid_bus_match(struct device *dev, struct device_driver *drv)
>  		!strncmp(hdrv->name, "hid-multitouch", 14))
>  		return 1;
>  
> -	if (!hid_match_device(hdev, hdrv))
> -		return 0;
> -
> -	/* generic wants all that don't have specialized driver */
> -	if (!strncmp(hdrv->name, "generic-", 8) && !hid_ignore_special_drivers)
> -		return !hid_match_id(hdev, hid_have_special_driver);
> -
> -	return 1;
> +	return hid_match_device(hdev, hdrv) != NULL;
>  }
>  
>  static int hid_device_probe(struct device *dev)
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 5bf91db..9abf718 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -1505,7 +1505,7 @@ static struct usb_driver hid_driver = {
>  };
>  
>  static const struct hid_device_id hid_usb_table[] = {
> -	{ HID_USB_DEVICE(HID_ANY_ID, HID_ANY_ID) },
> +	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC, HID_ANY_ID, HID_ANY_ID) },
>  	{ }
>  };
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index f45d33d..dd694fb 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -586,12 +586,12 @@ struct hid_descriptor {
>  	struct hid_class_descriptor desc[1];
>  } __attribute__ ((packed));
>  
> -#define HID_DEVICE(b, ven, prod) \
> -	.bus = (b), \
> -	.vendor = (ven), .product = (prod)
> -
> -#define HID_USB_DEVICE(ven, prod)	HID_DEVICE(BUS_USB, ven, prod)
> -#define HID_BLUETOOTH_DEVICE(ven, prod)	HID_DEVICE(BUS_BLUETOOTH, ven, prod)
> +#define HID_DEVICE(b, g, ven, prod)					\
> +	.bus = (b), .group = (g), .vendor = (ven), .product = (prod)
> +#define HID_USB_DEVICE(ven, prod)				\
> +	.bus = BUS_USB, .vendor = (ven), .product = (prod)
> +#define HID_BLUETOOTH_DEVICE(ven, prod)					\
> +	.bus = BUS_BLUETOOTH, .vendor = (ven), .product = (prod)

It seems we don't use this macro anywhere else, why did you keep it?

	Gustavo
