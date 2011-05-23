Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1EWHGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 03:06:09 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:49643 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab1EWHGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 03:06:07 -0400
Date: Mon, 23 May 2011 10:05:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110523070556.GJ3095@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306132882-9668-1-git-send-email-tlinder@codeaurora.org>
 <1306132882-9668-8-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mFHiwr52TKrxpkjc"
Content-Disposition: inline
In-Reply-To: <1306132882-9668-8-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mFHiwr52TKrxpkjc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 23, 2011 at 09:41:16AM +0300, Tatyana Brokhman wrote:
> This patch adds SS support to the dummy hcd module. It may be used to test
> SS device when no (SS) HW is available.
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> This patch adds support for a SS hub in the dummy_hcd module. Thus, when
> dummy_hcd enabled it will register 2 root hubs (SS and HS).
> A new module parameter was added to simulate a SuperSpeed connection.
> When a new device is connected it will enumerate via the HS hub by defaul=
t.
> In order to simulate SuperSpeed connection set the is_super_speed module
> parameter to true.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>=20
> ---
>  drivers/usb/gadget/dummy_hcd.c |  540 ++++++++++++++++++++++++++++++++++=
+-----
>  1 files changed, 483 insertions(+), 57 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hc=
d.c
> index bf7981d..c2731d3 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -70,6 +70,15 @@ MODULE_DESCRIPTION (DRIVER_DESC);
>  MODULE_AUTHOR ("David Brownell");
>  MODULE_LICENSE ("GPL");
> =20
> +struct dummy_hcd_module_parameters {
> +	bool is_super_speed;
> +};
> +
> +static struct dummy_hcd_module_parameters mod_data =3D {
> +	.is_super_speed =3D false
> +};
> +module_param_named(is_super_speed, mod_data.is_super_speed, bool, S_IRUG=
O);
> +MODULE_PARM_DESC(is_super_speed, "true to simulate SuperSpeed connection=
");

you shouldn't need this. You should always enable SuperSpeed for this
driver.

>  /*----------------------------------------------------------------------=
---*/
> =20
>  /* gadget side driver data structres */
> @@ -188,6 +197,7 @@ struct dummy {
>  	 * MASTER/HOST side support
>  	 */
>  	struct dummy_hcd		*hs_hcd;
> +	struct dummy_hcd		*ss_hcd;
>  };
> =20
>  static inline struct dummy_hcd *hcd_to_dummy_hcd(struct usb_hcd *hcd)
> @@ -218,7 +228,10 @@ static inline struct dummy *ep_to_dummy (struct dumm=
y_ep *ep)
>  static inline struct dummy_hcd *gadget_to_dummy_hcd(struct usb_gadget *g=
adget)
>  {
>  	struct dummy *dum =3D container_of(gadget, struct dummy, gadget);
> -	return dum->hs_hcd;
> +	if (dum->gadget.speed =3D=3D USB_SPEED_SUPER)
> +		return dum->ss_hcd;
> +	else
> +		return dum->hs_hcd;
>  }
> =20
>  static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
> @@ -266,10 +279,88 @@ stop_activity (struct dummy *dum)
>  	/* driver now does any non-usb quiescing necessary */
>  }
> =20
> +/**
> + * set_ss_link_state() - Sets the current state of the SuperSpeed link
> + * @dum_hcd: pointer to the dummy_hcd structure to update the link
> + *     state for
> + *
> + * This function updates the port_status according to the link
> + * state. The old status is saved befor updating.
> + * Note: this function should be called only for SuperSpeed
> + * master and the caller must hold the lock.
> + */
> +static void
> +set_ss_link_state(struct dummy_hcd *dum_hcd)

a significant part of this function is similar to the USB2.0 version
set_link_state(), so it's better to phase out the similar parts to an
internal function and use that on both set_*_link_state(). Add something
like:

__set_link_state_by_speed(struct dummy_hcd *dum_hcd, enum
	usb_device_speed speed);

then do all the similar parts there copying for speed, then just call
that function on both set_ss_link_state() and set_link_state().

> +{
> +	struct dummy *dum =3D dum_hcd->dum;

add a blank line here

> +	if (dum->gadget.speed < USB_SPEED_SUPER)

this assumes USB_SPEED_SUPER has an assigned value bigger than the
others which might not be true if someone changes the order of the
enumeration. So it's better to use:

if (dum->gadget.speed !=3D USB_SPEED_SUPER)

> +		return;
> +	dum_hcd->active =3D 0;
> +	if ((dum_hcd->port_status & USB_SS_PORT_STAT_POWER) =3D=3D 0)
> +		dum_hcd->port_status =3D 0;

if one branch has {} all of them should have :-) You can fix it while
re-factoring this code.

> +	/* UDC suspend must cause a disconnect */
> +	else if (!dum->pullup || dum->udc_suspended) {
> +		dum_hcd->port_status &=3D ~(USB_PORT_STAT_CONNECTION |
> +					USB_PORT_STAT_ENABLE);
> +		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) !=3D 0)
> +			dum_hcd->port_status |=3D
> +					(USB_PORT_STAT_C_CONNECTION << 16);
> +	} else {
> +		/* device is connected and not suspended */
> +		dum_hcd->port_status |=3D (USB_PORT_STAT_CONNECTION |
> +				     USB_PORT_STAT_SPEED_5GBPS) ;
> +		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) =3D=3D 0)
> +			dum_hcd->port_status |=3D
> +				(USB_PORT_STAT_C_CONNECTION << 16);
> +		if ((dum_hcd->port_status & USB_PORT_STAT_ENABLE) =3D=3D 1 &&
> +		    (dum_hcd->port_status & USB_SS_PORT_LS_U0) =3D=3D 1 &&
> +		    dum_hcd->rh_state !=3D DUMMY_RH_SUSPENDED)
> +			dum_hcd->active =3D 1;
> +	}
> +
> +

only one blank line :-)

> +	if ((dum_hcd->port_status & USB_PORT_STAT_ENABLE) =3D=3D 0 ||
> +	     dum_hcd->active)
> +		dum_hcd->resuming =3D 0;
> +
> +	/* if !connected or reset */
> +	if ((dum_hcd->port_status & USB_PORT_STAT_CONNECTION) =3D=3D 0 ||
> +			(dum_hcd->port_status & USB_PORT_STAT_RESET) !=3D 0) {
> +		/*
> +		 * We're connected and not reseted (reset occured now),

'reseted' isn't proper spelling :-)

> +		 * and driver attached - disconnect!
> +		 */
> +		if ((dum_hcd->old_status & USB_PORT_STAT_CONNECTION) !=3D 0 &&
> +		    (dum_hcd->old_status & USB_PORT_STAT_RESET) =3D=3D 0 &&
> +		    dum->driver) {
> +			stop_activity(dum);
> +			spin_unlock(&dum->lock);
> +			dum->driver->disconnect(&dum->gadget);
> +			spin_lock(&dum->lock);
> +		}
> +	} else if (dum_hcd->active !=3D dum_hcd->old_active) {
> +		if (dum_hcd->old_active && dum->driver->suspend) {
> +			spin_unlock(&dum->lock);
> +			dum->driver->suspend(&dum->gadget);
> +			spin_lock(&dum->lock);
> +		} else if (!dum_hcd->old_active &&  dum->driver->resume) {
> +			spin_unlock(&dum->lock);
> +			dum->driver->resume(&dum->gadget);
> +			spin_lock(&dum->lock);
> +		}
> +	}
> +
> +	dum_hcd->old_status =3D dum_hcd->port_status;
> +	dum_hcd->old_active =3D dum_hcd->active;
> +}
> +
>  /* caller must hold lock */
>  static void set_link_state(struct dummy_hcd *dum_hcd)
>  {
>  	struct dummy *dum =3D dum_hcd->dum;

add a blank line here.

> @@ -1371,6 +1577,10 @@ static void dummy_timer(unsigned long _dum_hcd)
>  	case USB_SPEED_HIGH:
>  		total =3D 512/*bytes*/ * 13/*packets*/ * 8/*uframes*/;
>  		break;
> +	case USB_SPEED_SUPER:
> +		/* Bus speed is 500000 bytes/ms, so use a little less */

isn't it 500000 bits/ms ?

--=20
balbi

--mFHiwr52TKrxpkjc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN2gdUAAoJEAv8Txj19kN1jckH+wXGsDuyvZBIjzalUcfvB0IB
THBnQDNlLPIib0ea/456cUd8uHH3Cm13jAeN5gHxUJwDAhgPy4nhnncPhWm1P7oq
9jfinwKRNi+0pkMloZXBP4pz+Kpjkfv41YNTZivuVnhJUAD4ZUJ2AOE5hxuuczlY
lg2LAMz+yRSel0A005sANKbCqI2/3XV8Hq6iryJsRGez3xHGJX+7AyosN9SlEiCb
9Sm3CAqs+Ae/rcPNEYQA2zZ4QIoOdjxnr7L9JSUph1pP0Beqw3vt9OtzkBvvk67R
v9QU798V25+PhPbjONa5QwsiPQXhYHhhnQfu7k7W9DU39JW3YQfCT+YeO5dmrVI=
=IQFN
-----END PGP SIGNATURE-----

--mFHiwr52TKrxpkjc--
