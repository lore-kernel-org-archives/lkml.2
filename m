Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab1KKJXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:23:12 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:49978 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086Ab1KKJXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:23:07 -0500
Date: Fri, 11 Nov 2011 11:23:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: peiyong feng <peiyong.feng.kernel@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add name match for UDC and gadget driver. Only for
 g_ether Signed-off-by: peiyong feng <peiyong.feng.kernel@gmail.com>
Message-ID: <20111111092259.GC19090@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1320992229-13155-1-git-send-email-peiyong.feng.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
Content-Disposition: inline
In-Reply-To: <1320992229-13155-1-git-send-email-peiyong.feng.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

(a bit of top-posting before commenting on your patch)

this is truly badly formatted. Read Documentation/CodingStyle,
Documentation/SubmittingPatches, and Documentation/SubmitChecklist

On Fri, Nov 11, 2011 at 02:17:09PM +0800, peiyong feng wrote:
> ---
>  drivers/usb/gadget/composite.c |    1 +
>  drivers/usb/gadget/ether.c     |    1 +
>  drivers/usb/gadget/udc-core.c  |   15 +++++++++++++++
>  include/linux/usb/composite.h  |    2 ++
>  include/linux/usb/gadget.h     |    1 +
>  5 files changed, 20 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composit=
e.c
> index f71b078..c1d2507 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -1583,6 +1583,7 @@ int usb_composite_probe(struct usb_composite_driver=
 *driver,
>  	if (!driver->iProduct)
>  		driver->iProduct =3D driver->name;
>  	composite_driver.function =3D  (char *) driver->name;
> +	composite_driver.name    =3D driver->name_udc;
>  	composite_driver.driver.name =3D driver->name;
>  	composite_driver.speed =3D min((u8)composite_driver.speed,
>  				     (u8)driver->max_speed);
> diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
> index 0cd764d..320b9e2 100644
> --- a/drivers/usb/gadget/ether.c
> +++ b/drivers/usb/gadget/ether.c
> @@ -390,6 +390,7 @@ static int __exit eth_unbind(struct usb_composite_dev=
 *cdev)
> =20
>  static struct usb_composite_driver eth_driver =3D {
>  	.name		=3D "g_ether",
> +	.name_udc	=3D CONFIG_UDC_NAME,
>  	.dev		=3D &device_desc,
>  	.strings	=3D dev_strings,
>  	.max_speed	=3D USB_SPEED_SUPER,
> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index 022baec..9a23620 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -37,6 +37,7 @@
>   * to hold information about udc driver and gadget together.
>   */
>  struct usb_udc {
> +	char *name;
>  	struct usb_gadget_driver	*driver;
>  	struct usb_gadget		*gadget;
>  	struct device			dev;
> @@ -144,6 +145,13 @@ static void usb_udc_release(struct device *dev)
>  }
> =20
>  static const struct attribute_group *usb_udc_attr_groups[];
> +/*set the name of udc*/
> +static void usb_udc_set_name(struct usb_udc *udc,char *name)
> +{
> +	char *tmp =3D kzalloc(strlen(name)+1);
> +	strcpy(tmp,name);
> +	usb_udc->name =3D tmp;
> +}
>  /**
>   * usb_add_gadget_udc - adds a new gadget to the udc class driver list
>   * @parent: the parent device to this udc. Usually the controller
> @@ -162,6 +170,7 @@ int usb_add_gadget_udc(struct device *parent, struct =
usb_gadget *gadget)
>  		goto err1;
> =20
>  	device_initialize(&udc->dev);
> +	usb_udc_set_name(udc,gadget.name);
>  	udc->dev.release =3D usb_udc_release;
>  	udc->dev.class =3D udc_class;
>  	udc->dev.groups =3D usb_udc_attr_groups;
> @@ -269,6 +278,12 @@ int usb_gadget_probe_driver(struct usb_gadget_driver=
 *driver,
>  		return -EINVAL;
> =20
>  	mutex_lock(&udc_lock);
> +	/*First we get the specific udc*/
> +	list_for_each_entry(udc, &udc_list, list) {
> +		if (strcmp(udc->name,driver->name)=3D=3D0)
> +			goto found;
> +	}
> +	/*We take the first one that unused*/
>  	list_for_each_entry(udc, &udc_list, list) {
>  		/* For now we take the first one */
>  		if (!udc->driver)
> diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
> index a316fba..029c26d 100644
> --- a/include/linux/usb/composite.h
> +++ b/include/linux/usb/composite.h
> @@ -245,6 +245,7 @@ int usb_add_config(struct usb_composite_dev *,
>  /**
>   * struct usb_composite_driver - groups configurations into a gadget
>   * @name: For diagnostics, identifies the driver.
> + * @name_udc: which UDC this driver attach.
>   * @iProduct: Used as iProduct override if @dev->iProduct is not set.
>   *	If NULL value of @name is taken.
>   * @iManufacturer: Used as iManufacturer override if @dev->iManufacturer=
 is
> @@ -278,6 +279,7 @@ int usb_add_config(struct usb_composite_dev *,
>   */
>  struct usb_composite_driver {
>  	const char				*name;
> +	const char 				*name_udc;
>  	const char				*iProduct;
>  	const char				*iManufacturer;
>  	const struct usb_device_descriptor	*dev;
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 1d3a675..e92083f 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -824,6 +824,7 @@ static inline int usb_gadget_disconnect(struct usb_ga=
dget *gadget)
>   */
>  struct usb_gadget_driver {
>  	char			*function;
> +	char 			*name;
>  	enum usb_device_speed	speed;
>  	void			(*unbind)(struct usb_gadget *);
>  	int			(*setup)(struct usb_gadget *,

I truly don't see the point of this patch. You cannot mandate to which
UDC the driver will attach to. In most situations, it will attach to the
only available UDC, if you have a board with more then one peripheral
port, then we need a better way of doing this. Something which won't
affect anybody else.

$SUBJECT can't be applied, sorry.

--=20
balbi

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOvOlzAAoJEIaOsuA1yqRE3AoP/RKEOiUh7w9Vvnnm/tJ+mkkj
n4BBaHWLznZvvUoXBtueU/7gVFBvkcJFF5Ak87Bru+g2Z2j9/Ir2PXc/S03PBUcR
r3TGO7hybmFdi8fvFih4PjRr9BrPfKwrEf2Ma4TNCniM0LOeMd90s+IIGVUXOLpU
Zi2JLX4DTShJUlJ5/kNhdKbR0faG4sGkdHOhxVBzGP0Gf36nGRf+BKcbYUTuKGBh
tuMVkV3t4WnLCUmUfwvw+EarktQGvA5IFvWhZ0W0NXwGNKp7+/BSXMsqr0EyA76G
GWao81HvSNEPfxdD9B/mRFHE0lGSKcsPVIyXim72xfyzKVR8FLeUwogjUnXjhKrL
E++2ywSeEroCwJeiQIv8ll6yWxECo7ObWCJ83Uy7Is7HZbLZV49Se90pRWRyN6+4
LXjlcy56G7SigzbQPWwoE0OScw+I82TIwm9XF15cGNJihrimLjNTLSbWbuVd7ErV
Q7XNXfrQA4GM45aSHf05t0DKzfK/kwLBhMENKupeogjZW8jsyzhWNAlQVlqlwJe1
HrEhyamdd20h/wno7ZZGAJt7oaAlzG53vNmbEyNwoKO9qHo2PRueSmA733j4T9Ov
C92lew/CV60F4YJka5eCoyWPxKmVuVFK1S/ZGqe03Tki17fD7VRUhnlexij/hVhZ
z6GcnY+XBIdfgnMgfjy4
=ZV/b
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
