Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab2HIL1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:27:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47445 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2HIL1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:27:36 -0400
MIME-Version: 1.0
In-Reply-To: <1344504164-2337-1-git-send-email-scott.liu@emc.com.tw>
References: <1344504164-2337-1-git-send-email-scott.liu@emc.com.tw>
Date: Thu, 9 Aug 2012 13:27:35 +0200
Message-ID: <CAN+gG=EP3doQMKmPMC9WVsBuQL+W88ri5qfk0-nb_FdvpKikeQ@mail.gmail.com>
Subject: Re: [patch v2 1/1] HID:hid-multitouch: Add ELAN prouction request
 when resume
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Scott Liu <scott.liu@emc.com.tw>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        eleghost@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott,

we are getting closer. Just a few nitpicks:

On Thu, Aug 9, 2012 at 11:22 AM, Scott Liu <scott.liu@emc.com.tw> wrote:
> Some of ELAN's production need to with set_idle commmand when reusme.

reusme -> resume

>
> Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
> ---
>  drivers/hid/hid-ids.h        |    3 +++
>  drivers/hid/hid-multitouch.c |   20 ++++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 41c34f2..a4d810c 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -829,4 +829,7 @@
>  #define USB_VENDOR_ID_PRIMAX   0x0461
>  #define USB_DEVICE_ID_PRIMAX_KEYBOARD  0x4e05
>
> +#define USB_VENDOR_ID_ELAN  0x04f3
> +#define USB_DEVICE_ID_ELAN_MOCCA    0x000a
> +

We try to keep the list alphabetically sorted. So it should go just
before USB_VENDOR_ID_ELECOM.

Also, the device you sent to me has the PID 0x0732 and is behaving the
same way (need to call the mt_reset command).
Is 0x000a a mistake or do all of your product behave like this?
If it's the latter, then we may purely remove the PID test.

Jiri, any ideas?

>  #endif
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 59c8b5c..b06b7d3 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -767,6 +767,25 @@ static int mt_reset_resume(struct hid_device *hdev)
>         mt_set_input_mode(hdev);
>         return 0;
>  }
> +
> +static int mt_resume(struct hid_device *hdev)
> +{
> +       if (hdev->vendor == USB_VENDOR_ID_ELAN &&
> +               hdev->product == USB_DEVICE_ID_ELAN_MOCCA) {
> +
> +               struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
> +               struct usb_host_interface *interface = intf->cur_altsetting;
> +               struct usb_device *dev = hid_to_usb_dev(hdev);
> +
> +               usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> +                                               HID_REQ_SET_IDLE, USB_TYPE_CLASS | USB_RECIP_INTERFACE,

As we are on it, this line is more than 80 characters. Tabs are 8
characters length.

> +                                               0, interface->desc.bInterfaceNumber,
> +                                               NULL, 0, USB_CTRL_SET_TIMEOUT);
> +    }

spaces instead of tabs.

> +
> +    return 0;

idem, spaces instead of tabs.

Anyway, I really appreciate your efforts Scott.

Cheers,
Benjamin


> +}
> +
>  #endif
>
>  static void mt_remove(struct hid_device *hdev)
> @@ -1092,6 +1111,7 @@ static struct hid_driver mt_driver = {
>         .event = mt_event,
>  #ifdef CONFIG_PM
>         .reset_resume = mt_reset_resume,
> +       .resume = mt_resume,
>  #endif
>  };
>
> --
> 1.7.9.5
>
