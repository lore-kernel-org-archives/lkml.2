Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab0GOJuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:50:19 -0400
Received: from ppsw-31.csi.cam.ac.uk ([131.111.8.131]:51406 "EHLO
	ppsw-31.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932924Ab0GOJuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:50:16 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4C3ED9C4.5080800@jic23.retrosnub.co.uk>
Date: Thu, 15 Jul 2010 10:49:56 +0100
From: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100709 Thunderbird/3.1
MIME-Version: 1.0
To: x0r <x0r@dv-life.ru>
CC: linux-kernel@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dtor@mail.ru>, Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] hid: ACRUX game controller force feedback support
References: <4C3E7850.2010802@dv-life.ru>
In-Reply-To: <4C3E7850.2010802@dv-life.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing linux-input and Dmitry.

Please check MAINTAINERS before sending out patches.
On 07/15/10 03:54, x0r wrote:
> Adds force feedback support for ACRUX USB game controllers.
> These devices are mass produced in China and distributed under several vendors.
> 
> Signed-off-by: Sergei Kolzun<x0r@dv-life.ru>
> 
> --- /dev/null
> +++ b/drivers/hid/hid-axff.c
> @@ -0,0 +1,168 @@
> +/*
> + * Force feedback support for ACRUX game controllers
> + *
> + * From what I have gathered, these devices are mass produced in China and are
> + * distributed under several vendors. They often share the same design as
> + * the original Xbox 360 controller.
> + *
> + * 1a34:0802 "ACRUX USB GAMEPAD 8116"
> + *  - tested with a EXEQ EQ-PCU-02090 game controller.
> + *
> + * Copyright (c) 2010 Sergei Kolzun<x0r@dv-life.ru>
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
> + */
> +
> +#include<linux/input.h>
> +#include<linux/slab.h>
> +#include<linux/usb.h>
> +#include<linux/hid.h>
> +
> +#include "hid-ids.h"
> +
> +#ifdef CONFIG_ACRUX_FF
> +#include "usbhid/usbhid.h"
> +
> +struct axff_device {
> +    struct hid_report *report;
> +};
> +
> +static int axff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
> +{
> +    struct hid_device *hid = input_get_drvdata(dev);
> +    struct axff_device *axff = data;
> +    int left, right;
> +
> +    left = effect->u.rumble.strong_magnitude;
> +    right = effect->u.rumble.weak_magnitude;
> +
> +    dbg_hid("called with 0x%04x 0x%04x", left, right);
> +
> +    left = left * 0xff / 0xffff;
> +    right = right * 0xff / 0xffff;
> +
> +    axff->report->field[0]->value[0] = left;
> +    axff->report->field[1]->value[0] = right;
> +    axff->report->field[2]->value[0] = left;
> +    axff->report->field[3]->value[0] = right;
> +    dbg_hid("running with 0x%02x 0x%02x", left, right);
> +    usbhid_submit_report(hid, axff->report, USB_DIR_OUT);
> +
> +    return 0;
> +}
> +
> +static int axff_init(struct hid_device *hid)
> +{
> +    struct axff_device *axff;
> +    struct hid_report *report;
> +    struct hid_input *hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
> +    struct list_head *report_list =&hid->report_enum[HID_OUTPUT_REPORT].report_list;
> +    struct input_dev *dev = hidinput->input;
> +    int error;
> +
> +    if (list_empty(report_list)) {
> +        dev_err(&hid->dev, "no output reports found\n");
> +        return -ENODEV;
> +    }
> +
> +    report = list_first_entry(report_list, struct hid_report, list);
> +
> +    if (report->maxfield<  4) {
> +        dev_err(&hid->dev, "no fields in the report: %d\n", report->maxfield);
> +        return -ENODEV;
> +    }
> +
> +    axff = kzalloc(sizeof(struct axff_device), GFP_KERNEL);
> +    if (!axff)
> +        return -ENOMEM;
> +
> +    set_bit(FF_RUMBLE, dev->ffbit);
> +
> +    error = input_ff_create_memless(dev, axff, axff_play);
> +    if (error) {
> +        kfree(axff);
> +        return error;
> +    }
> +
> +    axff->report = report;
> +    axff->report->field[0]->value[0] = 0x00;
> +    axff->report->field[1]->value[0] = 0x00;
> +    axff->report->field[2]->value[0] = 0x00;
> +    axff->report->field[3]->value[0] = 0x00;
> +    usbhid_submit_report(hid, axff->report, USB_DIR_OUT);
> +
> +    dev_info(&hid->dev, "Force Feedback for ACRUX game controllers by Sergei Kolzun<x0r@dv-life.ru>\n");
> +
> +    return 0;
> +}
> +#else
> +static inline int axff_init(struct hid_device *hid)
> +{
> +    return 0;
> +}
> +#endif
> +
> +static int ax_probe(struct hid_device *hdev, const struct hid_device_id *id)
> +{
> +    int ret;
> +
> +    dev_dbg(&hdev->dev, "ACRUX HID hardware probe...");
> +
> +    ret = hid_parse(hdev);
> +    if (ret) {
> +        dev_err(&hdev->dev, "parse failed\n");
> +        goto err;
> +    }
> +
> +    ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&  ~HID_CONNECT_FF);
> +    if (ret) {
> +        dev_err(&hdev->dev, "hw start failed\n");
> +        goto err;
> +    }
> +
> +    axff_init(hdev);
> +
> +    return 0;
> +err:
> +    return ret;
> +}
> +
> +static const struct hid_device_id ax_devices[] = {
> +    { HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802),  },
> +    { }
> +};
> +MODULE_DEVICE_TABLE(hid, ax_devices);
> +
> +static struct hid_driver ax_driver = {
> +    .name = "acrux",
> +    .id_table = ax_devices,
> +    .probe = ax_probe,
> +};
> +
> +static int __init ax_init(void)
> +{
> +    return hid_register_driver(&ax_driver);
> +}
> +
> +static void __exit ax_exit(void)
> +{
> +    hid_unregister_driver(&ax_driver);
> +}
> +
> +module_init(ax_init);
> +module_exit(ax_exit);
> +MODULE_LICENSE("GPL");
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1248,6 +1248,7 @@
>      { HID_USB_DEVICE(USB_VENDOR_ID_3M, USB_DEVICE_ID_3M1968) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_WCP32PU) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_A4TECH, USB_DEVICE_ID_A4TECH_X5_005D) },
> +    { HID_USB_DEVICE(USB_VENDOR_ID_ACRUX, 0x0802) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ATV_IRCONTROL) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL4) },
>      { HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MIGHTYMOUSE) },
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -33,6 +33,8 @@
>  #define USB_DEVICE_ID_ACECAD_FLAIR    0x0004
>  #define USB_DEVICE_ID_ACECAD_302    0x0008
> 
> +#define USB_VENDOR_ID_ACRUX        0x1a34
> +
>  #define USB_VENDOR_ID_ADS_TECH         0x06e1
>  #define USB_DEVICE_ID_ADS_TECH_RADIO_SI470X    0xa155
> 
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -68,6 +68,21 @@
>      ---help---
>      Support for A4 tech X5 and WOP-35 / Trust 450L mice.
> 
> +config HID_ACRUX
> +    tristate "ACRUX support" if EMBEDDED
> +    depends on USB_HID
> +    default !EMBEDDED
> +    ---help---
> +    Say Y here if you have ACRUX game controllers.
> +
> +config ACRUX_FF
> +    bool "ACRUX force feedback support"
> +    depends on HID_ACRUX
> +    select INPUT_FF_MEMLESS
> +    ---help---
> +    Say Y here if you want to enable force feedback support for ACRUX
> +    game controllers.
> +
>  config HID_APPLE
>      tristate "Apple" if EMBEDDED
>      depends on (USB_HID || BT_HIDP)
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -24,6 +24,7 @@
> 
>  obj-$(CONFIG_HID_3M_PCT)    += hid-3m-pct.o
>  obj-$(CONFIG_HID_A4TECH)    += hid-a4tech.o
> +obj-$(CONFIG_HID_ACRUX)        += hid-axff.o
>  obj-$(CONFIG_HID_APPLE)        += hid-apple.o
>  obj-$(CONFIG_HID_BELKIN)    += hid-belkin.o
>  obj-$(CONFIG_HID_CHERRY)    += hid-cherry.o
> 
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

