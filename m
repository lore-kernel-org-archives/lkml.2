Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab1HSX2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:28:15 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:36458 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946Ab1HSX2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:28:12 -0400
Date: Sat, 20 Aug 2011 02:28:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/4] usb: gadget: replace "is_dualspeed" with
 "max_speed"
Message-ID: <20110819232805.GC13317@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313791722.git.mina86@mina86.com>
 <accba3196fa1fe04f6110b350c03488acb785abe.1313791722.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <accba3196fa1fe04f6110b350c03488acb785abe.1313791722.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Aug 20, 2011 at 12:33:00AM +0200, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> This commit replaces usb_gadget's is_dualspeed field with
> a max_speed field.
>=20
> This change is made so that one will be able to check at
> run-time if given gadget supports super speed.

IMHO the logic is inverted here. It should start from the function
drivers. They should say which USB speeds they support, that would go up
to composite layer and composite would call e.g.
usb_gadget_set_speed(gadget, maximum_speed);

that function will set gadget->maximum_speed and call into the UDC
driver which would write maximum_speed into its internal registers, thus
preventing the core from working at speeds unsupported by the gadget
driver.

All of this should happen before we even connect to the host, so first
all UDCs should have their conversion to udc-core finished and start
using udc_start()/udc_stop(). The driver I just sent [1] illustrates
what udc_start()/udc_stop() should do.

[1] http://marc.info/?l=3Dlinux-usb&m=3D131376669022473&w=3D2

<snip>

> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index e1ecdbc..25058b4 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -371,14 +371,28 @@ static ssize_t usb_udc_softconn_store(struct device=
 *dev,
>  }
>  static DEVICE_ATTR(soft_connect, S_IWUSR, NULL, usb_udc_softconn_store);
> =20
> -static ssize_t usb_udc_speed_show(struct device *dev,
> +#define USB_UDC_SPEED_ATTR(name)					\
> +ssize_t usb_udc_##name##_show(struct device *dev,			\
> +		struct device_attribute *attr, char *buf)		\
> +{									\
> +	struct usb_udc *udc =3D container_of(dev, struct usb_udc, dev);	\
> +	return snprintf(buf, PAGE_SIZE, "%s\n",				\
> +			usb_device_speed_name(udc->gadget->name));	\
> +}									\
> +static DEVICE_ATTR(name, S_IRUSR, usb_udc_##name##_show, NULL)
> +
> +static USB_UDC_SPEED_ATTR(speed);

how about "current_speed" ?

> +static USB_UDC_SPEED_ATTR(max_speed);

in this case, humans will be reading sysfs, so maximum_speed will look
nicer, IMHO.

> +/* Provide "is_dualspeed" for backward compatibility. */
> +static ssize_t usb_udc_is_dualspeed_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
> -	struct usb_udc		*udc =3D container_of(dev, struct usb_udc, dev);
> -	return snprintf(buf, PAGE_SIZE, "%s\n",
> -			usb_device_speed_name(udc->gadget->speed));
> +	struct usb_udc *udc =3D container_of(dev, struct usb_udc, dev);
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			gadget_is_dualspeed(udc->gadget));
>  }
> -static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);
> +static DEVICE_ATTR(is_dualspeed, S_IRUSR, usb_udc_is_dualspeed_show, NUL=
L);

maybe deprecate this one on feature-removal-schedule ??

--=20
balbi

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTvGFAAoJEAv8Txj19kN1LgsH/1cOdRuYLD9Zjn8FKuEhce3A
p7P9Ja0NHZumMWpsoX6Id1+U8y1Y0UcN7ScrRgV+YRBxVB2rh55MrempNfpdv0RX
RvaKCH+/37fAj3DHmeD3ofy6M6CjQPmxPOPnp+FFSAZe7o5JMzmJJoZR+g5Ripp3
2ikDsYTR9E9apY8ynIn3O8lpJwNMIlYYh/lxFkOyiTDyjefCXrUfQtim6FXXBzJA
6f9dEn7bkznUOhw+esuSguQTkTrGGu87Sj2u0x6AC6q1TS8r9RSR2k5Qcsh4RES1
O1F6CvDEvJUcXq17vnuevt3wHTFZnPEWfEO+CjQGkxFVYd21cAZ21KlVIgAH1sE=
=ixsm
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
