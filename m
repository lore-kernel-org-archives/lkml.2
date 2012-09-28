Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555Ab2I1FMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 01:12:13 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54013 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab2I1FML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 01:12:11 -0400
MIME-Version: 1.0
In-Reply-To: <1348798739-2950-1-git-send-email-aroundight77@gmail.com>
References: <1348798739-2950-1-git-send-email-aroundight77@gmail.com>
Date: Fri, 28 Sep 2012 07:12:09 +0200
Message-ID: <CAN+gG=G6V_O5W6DCuByAmymeLSvyOtDbsaHTZOqbNgNKu+m6cQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] hid:Fix problem on GeneralTouch multi-touchscreen
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: GeneralTouch <aroundight77@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, yxhma <yxhma@163.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 4:18 AM, GeneralTouch <aroundight77@gmail.com> wrote:
> From: Xianhan Yu <aroundight77@gmail.com>
>
> Fix the touch-up no response problem on GeneralTouch twofingers touchscreen and modify the driver for new GeneralTouch PWT touchscreen.
>
> Signed-off-by: Xianhan Yu <aroundight77@gmail.com>

Hi,

Thank you for re-submitting the patch. It's cleaner now.

I have a few questions, but generally speaking, the patch is good in
its current form.

Jiri: I know that I have not been as reactive as I used to, but I'm
ending my contract in my current lab now, and I've been pretty busy.
Please don't put me in the grave, I'm still the maintainer of
hid-multitouch.... ;-)


> ---
>  drivers/hid/hid-ids.h        |    1 +
>  drivers/hid/hid-multitouch.c |   20 ++++++++++++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 1dcb76f..a6d5890 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -305,6 +305,7 @@
>
>  #define USB_VENDOR_ID_GENERAL_TOUCH    0x0dfc
>  #define USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS 0x0003
> +#define USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS 0x0100
>
>  #define USB_VENDOR_ID_GLAB             0x06c2
>  #define USB_DEVICE_ID_4_PHIDGETSERVO_30        0x0038
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 59c8b5c..7aece16 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -115,6 +115,8 @@ struct mt_device {
>  #define MT_CLS_EGALAX_SERIAL                   0x0104
>  #define MT_CLS_TOPSEED                         0x0105
>  #define MT_CLS_PANASONIC                       0x0106
> +#define MT_CLS_GENERALTOUCH_TWOFINGERS         0x0107
> +#define MT_CLS_GENERALTOUCH_PWT_TENFINGERS     0x0108
>
>  #define MT_DEFAULT_MAXCONTACT  10
>
> @@ -215,7 +217,18 @@ static struct mt_class mt_classes[] = {
>         { .name = MT_CLS_PANASONIC,
>                 .quirks = MT_QUIRK_NOT_SEEN_MEANS_UP,
>                 .maxcontacts = 4 },
> -
> +       { .name = MT_CLS_GENERALTOUCH_TWOFINGERS,
> +               .quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
> +                       MT_QUIRK_VALID_IS_INRANGE |
> +                       MT_QUIRK_SLOT_IS_CONTACTNUMBER,
> +               .maxcontacts = 2
> +       },

At first, I was a little bit surprised because
MT_QUIRK_NOT_SEEN_MEANS_UP and MT_QUIRK_VALID_IS_INRANGE were not
supposed to be used together. Anyway, if it's smoothly working with
your device, then I'm not against: the code shows that they won't
interfere.

> +       { .name = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,

This is more worrying me. Apparently the 0x0100 device is win8
compliant. Does'nt it work out of the box with MT_CLS_DEFAULT?

> +               .quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
> +                       MT_QUIRK_SLOT_IS_CONTACTNUMBER,
> +               .maxcontacts = 10

Do you really need to set the contact number of your device? Doing so
will force you to create a new class if you have a device with a
different maximum contact count.

I'm asking because I'd rather not having this field set on most of the MT_CLS_*.
However, if it's needed, (because you need to set it into the
associated feature), them I will be fine with it. But I would
appreciate to get the report descriptor of this particular device.

So, if you judge that those two device-specific classes are absolutely
needed (after all, you have the device in your hands), you have my
reviewed-by:
Reviewed-by Benjamin Tissoires <benjamin.tissoires@gmail.com>

Thanks,
Benjamin


> +       },
> +
>         { }
>  };
>
> @@ -893,9 +906,12 @@ static const struct hid_device_id mt_devices[] = {
>                         USB_DEVICE_ID_ELO_TS2515) },
>
>         /* GeneralTouch panel */
> -       { .driver_data = MT_CLS_DUAL_INRANGE_CONTACTNUMBER,
> +       { .driver_data = MT_CLS_GENERALTOUCH_TWOFINGERS,
>                 MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
>                         USB_DEVICE_ID_GENERAL_TOUCH_WIN7_TWOFINGERS) },
> +       { .driver_data = MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
> +               MT_USB_DEVICE(USB_VENDOR_ID_GENERAL_TOUCH,
> +                       USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS) },
>
>         /* Gametel game controller */
>         { .driver_data = MT_CLS_DEFAULT,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
