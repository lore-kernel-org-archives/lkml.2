Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1JJFuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 01:50:19 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:54122 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751164Ab1JJFuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 01:50:17 -0400
Date: Mon, 10 Oct 2011 08:50:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sshtylyov@ru.mvista.com
Subject: Re: [PATCH v3] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111010055010.GC31653@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <1318059850-3336-1-git-send-email-schwarzkopf@sensortherm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Content-Disposition: inline
In-Reply-To: <1318059850-3336-1-git-send-email-schwarzkopf@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 08, 2011 at 09:44:10AM +0200, Klaus Schwarzkopf wrote:
> This driver provides two functions in one configuration:
> a mass storage, and a CDC ACM (serial port) link.
> Heavily based on multi.c and cdc2.c
>=20
> Signed-off-by: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
> ---
>  drivers/usb/gadget/Kconfig  |   10 ++
>  drivers/usb/gadget/Makefile |    2 +
>  drivers/usb/gadget/acm_ms.c |  255 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 267 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/gadget/acm_ms.c
>=20
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 5a084b9..cebefa6 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -846,6 +846,16 @@ config USB_G_NOKIA
>  	  It's only really useful for N900 hardware. If you're building
>  	  a kernel for N900, say Y or M here. If unsure, say N.
> =20
> +config USB_G_ACM_MS
> +	tristate "CDC Composite Device (ACM and mass storage)"
> +	depends on BLOCK
> +	help
> +	  This driver provides two functions in one configuration:
> +	  a mass storage, and a CDC ACM (serial port) link.
> +
> +	  Say "y" to link the driver statically, or "m" to build a
> +	  dynamically linked module called "g_acm_ms".
> +
>  config USB_G_MULTI
>  	tristate "Multifunction Composite Gadget (EXPERIMENTAL)"
>  	depends on BLOCK && NET
> diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
> index 9ba725a..8a4e824 100644
> --- a/drivers/usb/gadget/Makefile
> +++ b/drivers/usb/gadget/Makefile
> @@ -51,6 +51,7 @@ g_dbgp-y			:=3D dbgp.o
>  g_nokia-y			:=3D nokia.o
>  g_webcam-y			:=3D webcam.o
>  g_ncm-y				:=3D ncm.o
> +g_acm_ms-y			:=3D acm_ms.o
> =20
>  obj-$(CONFIG_USB_ZERO)		+=3D g_zero.o
>  obj-$(CONFIG_USB_AUDIO)		+=3D g_audio.o
> @@ -69,3 +70,4 @@ obj-$(CONFIG_USB_G_MULTI)	+=3D g_multi.o
>  obj-$(CONFIG_USB_G_NOKIA)	+=3D g_nokia.o
>  obj-$(CONFIG_USB_G_WEBCAM)	+=3D g_webcam.o
>  obj-$(CONFIG_USB_G_NCM)		+=3D g_ncm.o
> +obj-$(CONFIG_USB_G_ACM_MS)	+=3D g_acm_ms.o
> diff --git a/drivers/usb/gadget/acm_ms.c b/drivers/usb/gadget/acm_ms.c
> new file mode 100644
> index 0000000..28280c4
> --- /dev/null
> +++ b/drivers/usb/gadget/acm_ms.c
> @@ -0,0 +1,255 @@
> +/*
> + * cdc2.c -- CDC Composite driver, with ACM and mass storage support

this is not cdc2.c

> + * Copyright (C) 2008 David Brownell
> + * Copyright (C) 2008 Nokia Corporation
> + * Author: David Brownell
> + * Modified: Klaus Schwarzkopf
> + *
> + * Heavily based on multi.c and cdc2.c
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/utsname.h>
> +
> +#include "u_serial.h"
> +
> +#define DRIVER_DESC		"CDC Composite Gadget (ACM + MS)"
> +#define DRIVER_VERSION		"2011/10/07"
> +
> +/*----------------------------------------------------------------------=
---*/
> +
> +/*
> + * DO NOT REUSE THESE IDs with a protocol-incompatible driver!!  Ever!!
> + * Instead:  allocate your own, using normal USB-IF procedures.
> + */
> +#define CDC_VENDOR_NUM	0x1d6b	/* Linux Foundation */
> +#define CDC_PRODUCT_NUM	0x0106	/* CDC Composite: ACM + MS*/
> +
> +/*----------------------------------------------------------------------=
---*/
> +
> +/*
> + * Kbuild is not very cooperative with respect to linking separately
> + * compiled library objects into one module.  So for now we won't use
> + * separate compilation ... ensuring init/exit sections work to shrink
> + * the runtime footprint, and giving us at least some parts of what
> + * a "gcc --combine ... part1.c part2.c part3.c ... " build would.
> + */
> +
> +#include "composite.c"
> +#include "usbstring.c"
> +#include "config.c"
> +#include "epautoconf.c"
> +#include "u_serial.c"
> +#include "f_acm.c"
> +#include "f_mass_storage.c"
> +
> +/*----------------------------------------------------------------------=
---*/
> +
> +static struct usb_device_descriptor device_desc =3D {
> +	.bLength =3D		sizeof device_desc,
> +	.bDescriptorType =3D	USB_DT_DEVICE,
> +
> +	.bcdUSB =3D		cpu_to_le16(0x0200),
> +
> +	.bDeviceClass =3D		USB_CLASS_COMM,
> +	.bDeviceSubClass =3D	0,
> +	.bDeviceProtocol =3D	0,
> +	/* .bMaxPacketSize0 =3D f(hardware) */
> +
> +	/* Vendor and product id can be overridden by module parameters.  */
> +	.idVendor =3D		cpu_to_le16(CDC_VENDOR_NUM),
> +	.idProduct =3D		cpu_to_le16(CDC_PRODUCT_NUM),
> +	/* .bcdDevice =3D f(hardware) */
> +	/* .iManufacturer =3D DYNAMIC */
> +	/* .iProduct =3D DYNAMIC */
> +	/* NO SERIAL NUMBER */
> +	.bNumConfigurations =3D	1,

bNumConfigurations should be dynamic. And I guess composite.c is already
handling that for free.

> +};
> +
> +static struct usb_otg_descriptor otg_descriptor =3D {
> +	.bLength =3D		sizeof otg_descriptor,
> +	.bDescriptorType =3D	USB_DT_OTG,
> +
> +	/*
> +	 * REVISIT SRP-only hardware is possible, although
> +	 * it would not be called "OTG" ...
> +	 */
> +	.bmAttributes =3D		USB_OTG_SRP | USB_OTG_HNP,
> +};
> +
> +static const struct usb_descriptor_header *otg_desc[] =3D {
> +	(struct usb_descriptor_header *) &otg_descriptor,
> +	NULL,
> +};
> +
> +
> +/* string IDs are assigned dynamically */
> +
> +#define STRING_MANUFACTURER_IDX		0
> +#define STRING_PRODUCT_IDX		1
> +
> +static char manufacturer[50];
> +
> +static struct usb_string strings_dev[] =3D {
> +	[STRING_MANUFACTURER_IDX].s =3D manufacturer,
> +	[STRING_PRODUCT_IDX].s =3D DRIVER_DESC,
> +	{  } /* end of list */
> +};
> +
> +static struct usb_gadget_strings stringtab_dev =3D {
> +	.language	=3D 0x0409,	/* en-us */
> +	.strings	=3D strings_dev,
> +};
> +
> +static struct usb_gadget_strings *dev_strings[] =3D {
> +	&stringtab_dev,
> +	NULL,
> +};
> +
> +/****************************** Configurations *************************=
*****/
> +
> +static struct fsg_module_parameters fsg_mod_data =3D { .stall =3D 1 };
> +FSG_MODULE_PARAMETERS(/* no prefix */, fsg_mod_data);
> +
> +static struct fsg_common fsg_common;
> +
> +/*----------------------------------------------------------------------=
---*/
> +
> +/*
> + * We _always_ have both CDC ACM and mass storage functions.
> + */
> +static int __init cdc_do_config(struct usb_configuration *c)
> +{
> +	int	status;
> +
> +	if (gadget_is_otg(c->cdev->gadget)) {
> +		c->descriptors =3D otg_desc;
> +		c->bmAttributes |=3D USB_CONFIG_ATT_WAKEUP;
> +	}
> +
> +
> +	status =3D acm_bind_config(c, 0);
> +	if (status < 0)
> +		return status;
> +
> +	status =3D fsg_bind_config(c->cdev, c, &fsg_common);
> +	if (status < 0)
> +		return status;
> +
> +	return 0;
> +}
> +
> +static struct usb_configuration cdc_config_driver =3D {
> +	.label			=3D DRIVER_DESC,
> +	.bConfigurationValue	=3D 1,
> +	/* .iConfiguration =3D DYNAMIC */
> +	.bmAttributes		=3D USB_CONFIG_ATT_SELFPOWER,
> +};
> +
> +/*----------------------------------------------------------------------=
---*/
> +
> +static int __init cdc_bind(struct usb_composite_dev *cdev)
> +{
> +	int			gcnum;
> +	struct usb_gadget	*gadget =3D cdev->gadget;
> +	int			status;
> +	void			*retp;
> +
> +	/* set up serial link layer */
> +	status =3D gserial_setup(cdev->gadget, 1);
> +	if (status < 0)
> +		return status;
> +
> +	/* set up mass storage function */
> +	retp =3D fsg_common_from_params(&fsg_common, cdev, &fsg_mod_data);
> +	if (IS_ERR(retp)) {
> +		status =3D PTR_ERR(retp);
> +		goto fail0;
> +	}
> +
> +	/* set bcdDevice */
> +	gcnum =3D usb_gadget_controller_number(gadget);
> +	if (gcnum >=3D 0) {
> +		device_desc.bcdDevice =3D cpu_to_le16(0x0300 | gcnum);
> +	} else {
> +		WARNING(cdev, "controller '%s' not recognized; trying %s\n",
> +				gadget->name,
> +				cdc_config_driver.label);
> +		device_desc.bcdDevice =3D
> +			cpu_to_le16(0x0300 | 0x0099);
> +	}
> +
> +	/*
> +	 * Allocate string descriptor numbers ... note that string
> +	 * contents can be overridden by the composite_dev glue.
> +	 */
> +
> +	/* device descriptor strings: manufacturer, product */
> +	snprintf(manufacturer, sizeof manufacturer, "%s %s with %s",
> +		init_utsname()->sysname, init_utsname()->release,
> +		gadget->name);
> +	status =3D usb_string_id(cdev);
> +	if (status < 0)
> +		goto fail1;
> +	strings_dev[STRING_MANUFACTURER_IDX].id =3D status;
> +	device_desc.iManufacturer =3D status;
> +
> +	status =3D usb_string_id(cdev);
> +	if (status < 0)
> +		goto fail1;
> +	strings_dev[STRING_PRODUCT_IDX].id =3D status;
> +	device_desc.iProduct =3D status;
> +
> +	/* register our configuration */
> +	status =3D usb_add_config(cdev, &cdc_config_driver, cdc_do_config);
> +	if (status < 0)
> +		goto fail1;
> +
> +	dev_info(&gadget->dev, "%s, version: " DRIVER_VERSION "\n",
> +			DRIVER_DESC);
> +	fsg_common_put(&fsg_common);
> +	return 0;
> +
> +	/* error recovery */
> +fail1:
> +	fsg_common_put(&fsg_common);
> +fail0:
> +	gserial_cleanup();
> +	return status;
> +}
> +
> +static int __exit cdc_unbind(struct usb_composite_dev *cdev)
> +{
> +	gserial_cleanup();

shouldn't you call fsg_common_put() ??

> +	return 0;
> +}
> +
> +static struct usb_composite_driver cdc_driver =3D {
> +	.name		=3D "g_acm_ms",
> +	.dev		=3D &device_desc,
> +	.strings	=3D dev_strings,
> +	.unbind		=3D __exit_p(cdc_unbind),
> +};
> +
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_AUTHOR("Klaus Schwarzkopf");

add email as well:

MODULE_AUTHOR("Klaus Schwarzkopf <schwarzkopf@sensortherm.de>")

> +MODULE_LICENSE("GPL");

should this be GPL v2 instead ?

> +
> +static int __init init(void)
> +{
> +	return usb_composite_probe(&cdc_driver, cdc_bind);

please run a sed script changing cdc_ to acm_ms_, or something similar,
at least.

--=20
balbi

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkoeSAAoJEAv8Txj19kN1ckcIAJV3bQTlibQC/c5b1r0nxS4Y
pE3vYoiLfIBJR3eXnQnygGR6bNXusT81aHwySHZnXFVexcYv59XoocTpBU5MCpbb
0239/pauUW0RCbKiZy09X+HwQOIqofZnNsFEry/0uv0rPvcManJ/RWrmusrUyi4K
GPclKCXlNPTMHrjTlpYPy9hnbgzUYnpZkOpj1xt6qwBnTO8pzC4J3h7HPEQ8lh9d
EufDHMcvlpkB+Jc5asdsjVXDmqPSqseaDGObvo/5BWg6n94hQJhZ7uyUhFrdmWn0
8GemrOY7fV8xBrchzsU5Zmu7F27VIEmoosa8Wqk0KK+KHqkMABeXc8qNkWgjhXM=
=F46r
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
