Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab1JFMIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 08:08:39 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:35905 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab1JFMIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 08:08:38 -0400
Date: Thu, 6 Oct 2011 15:08:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111006120830.GN1714@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uMPAU7A2Er6+wvsD"
Content-Disposition: inline
In-Reply-To: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uMPAU7A2Er6+wvsD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

a few style issues below.

On Thu, Sep 08, 2011 at 08:24:47PM +0200, Klaus Schwarzkopf wrote:
> This driver provides two functions in one configuration:
> a mass storage, and a CDC ACM (serial port) link.
> Heavily based on multi.c and cdc2.c
>=20
> Signed-off-by: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
> ---
>  drivers/usb/gadget/Kconfig  |   10 ++
>  drivers/usb/gadget/Makefile |    2 +
>  drivers/usb/gadget/acm_ms.c |  269 +++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/usb/gadget.h  |    1 +
>  4 files changed, 282 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/gadget/acm_ms.c
>=20
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 029e288..2592ba7 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -959,6 +959,16 @@ config USB_G_NOKIA
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
> index 4fe92b1..3876d8c 100644
> --- a/drivers/usb/gadget/Makefile
> +++ b/drivers/usb/gadget/Makefile
> @@ -49,6 +49,7 @@ g_dbgp-y			:=3D dbgp.o
>  g_nokia-y			:=3D nokia.o
>  g_webcam-y			:=3D webcam.o
>  g_ncm-y				:=3D ncm.o
> +g_acm_ms-y			:=3D acm_ms.o
> =20
>  obj-$(CONFIG_USB_ZERO)		+=3D g_zero.o
>  obj-$(CONFIG_USB_AUDIO)		+=3D g_audio.o
> @@ -67,3 +68,4 @@ obj-$(CONFIG_USB_G_MULTI)	+=3D g_multi.o
>  obj-$(CONFIG_USB_G_NOKIA)	+=3D g_nokia.o
>  obj-$(CONFIG_USB_G_WEBCAM)	+=3D g_webcam.o
>  obj-$(CONFIG_USB_G_NCM)		+=3D g_ncm.o
> +obj-$(CONFIG_USB_G_ACM_MS)	+=3D g_acm_ms.o
> diff --git a/drivers/usb/gadget/acm_ms.c b/drivers/usb/gadget/acm_ms.c
> new file mode 100644
> index 0000000..64d0f79
> --- /dev/null
> +++ b/drivers/usb/gadget/acm_ms.c
> @@ -0,0 +1,269 @@
> +/*
> + * cdc2.c -- CDC Composite driver, with ACM and mass storage support
> + *
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
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 =
 USA

this paragraph is useless.

> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/utsname.h>
> +
> +#include "u_serial.h"
> +
> +

one blank line only.

> +#define DRIVER_DESC		"CDC Composite Gadget (ACM + MS)"
> +#define DRIVER_VERSION		"2011/09/08"
> +
> +/*----------------------------------------------------------------------=
---*/
> +
> +/* DO NOT REUSE THESE IDs with a protocol-incompatible driver!!  Ever!!
> + * Instead:  allocate your own, using normal USB-IF procedures.
> + */

wrong comment style.

> +#define CDC_VENDOR_NUM	0x1d6b	/* Linux Foundation */
> +#define CDC_PRODUCT_NUM	0x0106	/* CDC Composite: ACM + MS*/

did you ask Greg for this ?

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

why not ? If someone wants to make a product out of this, they will need
a serial number.

> +	.bNumConfigurations =3D	1,
> +};
> +
> +static struct usb_otg_descriptor otg_descriptor =3D {
> +	.bLength =3D		sizeof otg_descriptor,
> +	.bDescriptorType =3D	USB_DT_OTG,
> +
> +	/* REVISIT SRP-only hardware is possible, although
> +	 * it would not be called "OTG" ...
> +	 */

comment style is wrong.

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
> + * We _always_ have both CDC ECM and CDC ACM functions.
> + */

comment doesn't match code.

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
> +
> +
> +	/* set up serial link layer */
> +	status =3D gserial_setup(cdev->gadget, 1);
> +	if (status < 0)
> +		return status;
> +
> +	/* set up mass storage function */
> +	{
> +		void *retp;
> +		retp =3D fsg_common_from_params(&fsg_common, cdev, &fsg_mod_data);
> +		if (IS_ERR(retp)) {
> +			status =3D PTR_ERR(retp);
> +			goto fail0;
> +		}
> +	}

you can define void *retp with the other local variables and remove the
braces.

> +	gcnum =3D usb_gadget_controller_number(gadget);
> +	if (gcnum >=3D 0)
> +		device_desc.bcdDevice =3D cpu_to_le16(0x0300 | gcnum);
> +	else {
> +		/* We assume that can_support_ecm() tells the truth;
> +		 * but if the controller isn't recognized at all then
> +		 * that assumption is a bit more likely to be wrong.
> +		 */
> +		WARNING(cdev, "controller '%s' not recognized; trying %s\n",
> +				gadget->name,
> +				cdc_config_driver.label);
> +		device_desc.bcdDevice =3D
> +			cpu_to_le16(0x0300 | 0x0099);
> +	}
> +
> +

one blank line only. Also, put braces on both branches.

> +	/* Allocate string descriptor numbers ... note that string
> +	 * contents can be overridden by the composite_dev glue.
> +	 */

wrong comment style

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
> +
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
> +MODULE_LICENSE("GPL");
> +
> +static int __init init(void)
> +{
> +	return usb_composite_probe(&cdc_driver, cdc_bind);
> +}
> +module_init(init);
> +
> +static void __exit cleanup(void)
> +{
> +	usb_composite_unregister(&cdc_driver);
> +}
> +module_exit(cleanup);
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index dd1571d..f623f3d 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -15,6 +15,7 @@
>  #ifndef __LINUX_USB_GADGET_H
>  #define __LINUX_USB_GADGET_H
> =20
> +#include <linux/device.h>

this is not part of $SUBJECT

--=20
balbi

--uMPAU7A2Er6+wvsD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOjZo+AAoJEAv8Txj19kN1ESUH/jiMjumGOMq7DaZ9vc2WxJyE
o0C7v2b+yXNPnCxt3SdSmp0ecGpcPF6E62bH5mBjDP3Yulu/01zto1NtDw7mQUAI
2tiiBDyl4t4IQA2PqjZwYM6M5o4anMkJBm7Dcgd6la/yWD4F+qB83vKpun/g1ncV
IOJWaOFRanphJvMjlAzauqaAfA3BR3Z5ScVyJEqE/WZ2RiaEdnTlm9cf9hjY/wNk
RPvNqu8uALO9jk1K1+IfhC0IgmqHOCGco0lIfPUqI95RpTRteBH0JlH47sSzIRMK
AsyUcLYTLPJVnNzyBHr6TLMAgY1CAbs2xATiwWnmOsC8X8eNpbCtTyY4UVS1xz8=
=FEnK
-----END PGP SIGNATURE-----

--uMPAU7A2Er6+wvsD--
