Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab2DIAIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 20:08:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44864 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab2DIAIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 20:08:30 -0400
Date: Mon, 9 Apr 2012 02:08:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Franco Catrin <fcatrin@gmail.com>
Subject: Re: [PATCH] Aureal Remote Control Device Driver
In-Reply-To: <1333141707-16069-1-git-send-email-jrbenito@benito.qsl.br>
Message-ID: <alpine.LNX.2.00.1204090207090.24006@pobox.suse.cz>
References: <1333141707-16069-1-git-send-email-jrbenito@benito.qsl.br>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Josenivaldo Benito Junior wrote:

> From: "Josenivaldo Benito Junior" <jrbenito@benito.qsl.br>
> 
> Devices like Aureal Cy se W-01RN USB_V3.1 and some derived hardware
> have a bogus HID Report Descriptor. According to that report descriptor,
> the maximum logical value for key events is 1 and not 101 (101 keys).
> 
> This quirk fixes this wrong Report Descriptor and is basically the same found
> in hid-elecom.c.
> 
> Original driver can be found at: https://gitorious.org/hid-aureal-kernel-module
> 
> Signed-off-by: Josenivaldo Benito Junior <jrbenito@benito.qsl.br>
> Signed-off-by: Franco Catrin <fcatrin@gmail.com>
> ---
>  drivers/hid/Kconfig      |    6 +++++
>  drivers/hid/Makefile     |    1 +
>  drivers/hid/hid-aureal.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/hid/hid-ids.h    |    3 ++
>  4 files changed, 64 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hid/hid-aureal.c
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 4ecc256..03e2281 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -92,6 +92,12 @@ config HID_APPLE
>  	Say Y here if you want support for keyboards of	Apple iBooks, PowerBooks,
>  	MacBooks, MacBook Pros and Apple Aluminum.
>  
> +config HID_AUREAL
> +	tristate "Aureal"
> +	depends on USB_HID
> +	---help---
> +	Support for Aureal Cy se W-01RN Remote Controller and other Aureal derived remotes.
> +
>  config HID_BELKIN
>  	tristate "Belkin Flip KVM and Wireless keyboard" if EXPERT
>  	depends on USB_HID
> diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
> index 22f1d16..5363f17 100644
> --- a/drivers/hid/Makefile
> +++ b/drivers/hid/Makefile
> @@ -36,6 +36,7 @@ endif
>  obj-$(CONFIG_HID_A4TECH)	+= hid-a4tech.o
>  obj-$(CONFIG_HID_ACRUX)		+= hid-axff.o
>  obj-$(CONFIG_HID_APPLE)		+= hid-apple.o
> +obj-$(CONFIG_HID_AUREAL)        += hid-aureal.o
>  obj-$(CONFIG_HID_BELKIN)	+= hid-belkin.o
>  obj-$(CONFIG_HID_CHERRY)	+= hid-cherry.o
>  obj-$(CONFIG_HID_CHICONY)	+= hid-chicony.o
> diff --git a/drivers/hid/hid-aureal.c b/drivers/hid/hid-aureal.c
> new file mode 100644
> index 0000000..9fb676b
> --- /dev/null
> +++ b/drivers/hid/hid-aureal.c
> @@ -0,0 +1,54 @@
> +/*
> + *  HID driver for Aureal Cy se W-01RN USB_V3.1 devices
> + *
> + *  Copyright (c) 2010 Franco Catrin <fcatrin@gmail.com>
> + *  Copyright (c) 2010 Ben Cropley <bcropley@internode.on.net>
> + *
> + *  Based on HID sunplus driver by
> + *  Copyright (c) 1999 Andreas Gal
> + *  Copyright (c) 2000-2005 Vojtech Pavlik <vojtech@suse.cz>
> + *  Copyright (c) 2005 Michael Haboustak <mike-@cinci.rr.com> for Concept2, Inc
> + *  Copyright (c) 2006-2007 Jiri Kosina
> + *  Copyright (c) 2007 Paul Walmsley
> + *  Copyright (c) 2008 Jiri Slaby
> + */
> +#include <linux/device.h>
> +#include <linux/hid.h>
> +#include <linux/module.h>
> +
> +#include "hid-ids.h"
> +
> +static __u8 *aureal_report_fixup(struct hid_device *hdev, __u8 *rdesc,
> +		unsigned int *rsize)
> +{
> +	if (*rsize >= 54 && rdesc[52] == 0x25 && rdesc[53] == 0x01) {
> +		dev_info(&hdev->dev, "fixing Aureal Cy se W-01RN USB_V3.1 report descriptor. Keyboard Logical Maximum = 101\n");

This is probably putting a too much information into dmesg. Could you 
please drop the part with the 'Keyboard Logical Maximum ...'?

> +		rdesc[53] = 0x65;
> +	} return rdesc;
> +}
> +
> +static const struct hid_device_id aureal_devices[] = {
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_AUREAL, USB_DEVICE_ID_AUREAL_W01RN) },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(hid, aureal_devices);
> +
> +static struct hid_driver aureal_driver = {
> +	.name = "aureal",
> +	.id_table = aureal_devices,
> +	.report_fixup = aureal_report_fixup,
> +};
> +
> +static int __init aureal_init(void)
> +{
> +	return hid_register_driver(&aureal_driver);
> +}
> +
> +static void __exit aureal_exit(void)
> +{
> +	hid_unregister_driver(&aureal_driver);
> +}
> +
> +module_init(aureal_init);
> +module_exit(aureal_exit);
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 2b67e84..720c9e7 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -154,6 +154,9 @@
>  #define USB_DEVICE_ID_ATMEL_MULTITOUCH	0x211c
>  #define USB_DEVICE_ID_ATMEL_MXT_DIGITIZER	0x2118
>  
> +#define USB_VENDOR_ID_AUREAL		0x0755
> +#define USB_DEVICE_ID_AUREAL_W01RN	0x2626
> +
>  #define USB_VENDOR_ID_AVERMEDIA		0x07ca
>  #define USB_DEVICE_ID_AVER_FM_MR800	0xb800

You don't seem to be adding appropriate entry to 
hid_have_special_driver[].

-- 
Jiri Kosina
SUSE Labs
