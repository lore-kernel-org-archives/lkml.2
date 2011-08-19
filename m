Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab1HSXPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:15:07 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43684 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756244Ab1HSXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:15:05 -0400
Date: Sat, 20 Aug 2011 02:15:00 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/4] usb: Provide usb_device_speed_name() function
Message-ID: <20110819231459.GB13317@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1313791722.git.mina86@mina86.com>
 <7e9435f5e8c2e9d6363d79de79f81b4f259e230c.1313791722.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <7e9435f5e8c2e9d6363d79de79f81b4f259e230c.1313791722.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Aug 20, 2011 at 12:32:59AM +0200, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> In a few places kernel wants to print a human-readable USB
> device speed name (eg. "high") instead of a raw number
> (eg. 3).  Usually a switch is introduced in those places
> leading to code repetition.  To mitigate this issue, this
> commit introduces usb_device_speed_name() function, which
> returns a human-readable name of provided speed.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> ---
>  drivers/usb/Makefile          |    3 +++
>  drivers/usb/common.c          |   24 ++++++++++++++++++++++++
>  drivers/usb/gadget/udc-core.c |   19 ++-----------------
>  include/linux/usb/ch9.h       |    8 ++++++++
>  4 files changed, 37 insertions(+), 17 deletions(-)
>  create mode 100644 drivers/usb/common.c
>=20
> diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> index 30ddf8d..a3167cc 100644
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -51,3 +51,6 @@ obj-$(CONFIG_USB_MUSB_HDRC)	+=3D musb/
>  obj-$(CONFIG_USB_RENESAS_USBHS)	+=3D renesas_usbhs/
>  obj-$(CONFIG_USB_OTG_UTILS)	+=3D otg/
>  obj-$(CONFIG_USB_GADGET)	+=3D gadget/
> +
> +obj-$(CONFIG_USB)		+=3D common.o
> +obj-$(CONFIG_USB_GADGET)	+=3D common.o
> diff --git a/drivers/usb/common.c b/drivers/usb/common.c
> new file mode 100644
> index 0000000..e9d7141
> --- /dev/null
> +++ b/drivers/usb/common.c
> @@ -0,0 +1,24 @@
> +/*
> + * Provides code common for host and device side USB.
> + */
> +
> +#include <linux/kernel.h>  /* for ARRAY_SIZE() */
> +#include <linux/module.h>  /* for EXPORT_SYMBOL_GPL() */
> +#include <linux/usb/ch9.h>
> +
> +const char *usb_device_speed_name(enum usb_device_speed speed)

somehow usb_speed_string() sounds better to me.

> +{
> +	static const char *const names[] =3D {
> +		"UNKNOWN",
> +		"low-speed",
> +		"full-speed",
> +		"high-speed",
> +		"wireless",
> +		"super-speed",
> +	};
> +
> +	if (speed < 0 || speed >=3D ARRAY_SIZE(names))
> +		speed =3D USB_SPEED_UNKNOWN;

I generally dislike depending on a particular ordering of enumerations.
While's it's highly unlikely that anyone will change that, if someone
does change, then it'll take a long time to actually find the bug on the
print here :-)

I woud rather use a switch in this case.

> diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
> index 05ba472..e1ecdbc 100644
> --- a/drivers/usb/gadget/udc-core.c
> +++ b/drivers/usb/gadget/udc-core.c
> @@ -375,23 +375,8 @@ static ssize_t usb_udc_speed_show(struct device *dev,
>  		struct device_attribute *attr, char *buf)
>  {
>  	struct usb_udc		*udc =3D container_of(dev, struct usb_udc, dev);
> -	struct usb_gadget	*gadget =3D udc->gadget;
> -
> -	switch (gadget->speed) {
> -	case USB_SPEED_LOW:
> -		return snprintf(buf, PAGE_SIZE, "low-speed\n");
> -	case USB_SPEED_FULL:
> -		return snprintf(buf, PAGE_SIZE, "full-speed\n");
> -	case USB_SPEED_HIGH:
> -		return snprintf(buf, PAGE_SIZE, "high-speed\n");
> -	case USB_SPEED_WIRELESS:
> -		return snprintf(buf, PAGE_SIZE, "wireless\n");
> -	case USB_SPEED_SUPER:
> -		return snprintf(buf, PAGE_SIZE, "super-speed\n");
> -	case USB_SPEED_UNKNOWN:	/* FALLTHROUGH */
> -	default:
> -		return snprintf(buf, PAGE_SIZE, "UNKNOWN\n");
> -	}
> +	return snprintf(buf, PAGE_SIZE, "%s\n",
> +			usb_device_speed_name(udc->gadget->speed));
>  }
>  static DEVICE_ATTR(speed, S_IRUSR, usb_udc_speed_show, NULL);

you said 'several locations', but there's only one ? No other driver is
using something similar ?

--=20
balbi

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTu5zAAoJEAv8Txj19kN17WcH/AiddtWjlc18DOmjeSE03i+W
a0PteZf7DlFW+d/J/jo/I0vGAjzgPFJrZDiDmLFrR8bBIgbUBPr3dttfjOwxddKp
/zOr72yZFLYf4wMttPcIVOaI3Tw06oLJ4NfGfhpNIcfxUSlJVJ9zjLxN+fDOKiGm
XrjhlbX8G7WSC8ddR+ZH4egug8vH3htxOG1jad+IbfXBVVQqk/kMZSLluW7u7UVH
ogOis+YBykPddh3gFw7abLDXYDPNzn6aISS4do4bP8jtMZh/ziDUlPcuLRuHvREe
3tKmgF4UTlWqJDd6C4UoxPZulGaCFRDe/yBW/eqrrUl7oK6pW72oajJXDgNXkJE=
=x3cs
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
