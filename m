Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab3AJNDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 08:03:03 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38850 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847Ab3AJNDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 08:03:00 -0500
Date: Thu, 10 Jan 2013 15:02:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH RFC] usb: dwc3: Remove dwc3 dependency on gadget.
Message-ID: <20130110130238.GW28920@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1356357513-8892-1-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s8wpp40TDz0KNMmP"
Content-Disposition: inline
In-Reply-To: <1356357513-8892-1-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--s8wpp40TDz0KNMmP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 24, 2012 at 07:28:33PM +0530, Vivek Gautam wrote:
> DWC3 controller curretly depends on CONFIG_USB and CONFIG_USB_GADGET.
> Some hardware may like to use only host feature on dwc3.
> So, removing the dependency of USB_DWC3 on USB_GADGET
> and further modulating the dwc3 core to enable gadget features
> only with USB_GADGET.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> CC: Doug Anderson <dianders@chromium.org>

right, right... Eventually we need to do it, but you're only making
gadget side optional. Host side should be optional too, but then you
need to make sure we don't build dwc3 without gadget and host.

Maybe make a mode selection for Host-only, Peripheral-only, Dual-Role
Device ??

More comments below...

> diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
> index f6a6e07..b70dcf1 100644
> --- a/drivers/usb/dwc3/Kconfig
> +++ b/drivers/usb/dwc3/Kconfig
> @@ -1,7 +1,7 @@
>  config USB_DWC3
>  	tristate "DesignWare USB3 DRD Core Support"
> -	depends on (USB && USB_GADGET)
> -	select USB_OTG_UTILS
> +	depends on USB
> +	select USB_OTG_UTILS if USB_GADGET

we want USB_OTG_UTILS also on host-only builds because host side,
eventually, will have to learn how to control its PHYs.

>  	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
>  	help
>  	  Say Y or M here if your system has a Dual Role SuperSpeed
> diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
> index 4502648..8f469cb 100644
> --- a/drivers/usb/dwc3/Makefile
> +++ b/drivers/usb/dwc3/Makefile
> @@ -5,7 +5,7 @@ obj-$(CONFIG_USB_DWC3)			+=3D dwc3.o
> =20
>  dwc3-y					:=3D core.o
>  dwc3-y					+=3D host.o
> -dwc3-y					+=3D gadget.o ep0.o
> +obj-$(CONFIG_USB_GADGET)               +=3D gadget.o ep0.o

this is wrong. CONFIG_USB_GADGET is tristate, so this should be:

ifneq($(CONFIG_USB_GADGET),)
 dwc3-y	+=3D gadget.o ep0.o
endif

or something similar

> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index 4999563..4dc7ef2 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -865,7 +865,14 @@ int dwc3_gadget_resize_tx_fifos(struct dwc3 *dwc);
>  int dwc3_host_init(struct dwc3 *dwc);
>  void dwc3_host_exit(struct dwc3 *dwc);
> =20
> +#ifdef CONFIG_USB_GADGET

not taking into account module builds.

>  int dwc3_gadget_init(struct dwc3 *dwc);
>  void dwc3_gadget_exit(struct dwc3 *dwc);
> +#else
> +static inline int dwc3_gadget_init(struct dwc3 *dwc)
> +{ return -EINVAL; }
> +static inline void dwc3_gadget_exit(struct dwc3 *dwc)
> +{ }
> +#endif
> =20
>  #endif /* __DRIVERS_USB_DWC3_CORE_H */
> diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
> index d4a30f1..553bbaa 100644
> --- a/drivers/usb/dwc3/debugfs.c
> +++ b/drivers/usb/dwc3/debugfs.c
> @@ -535,7 +535,8 @@ static ssize_t dwc3_testmode_write(struct file *file,
>  		testmode =3D 0;
> =20
>  	spin_lock_irqsave(&dwc->lock, flags);
> -	dwc3_gadget_set_test_mode(dwc, testmode);
> +	if (dwc3_gadget_set_test_mode(dwc, testmode))
> +		dev_dbg(dwc->dev, "host: Invalid request\n");
>  	spin_unlock_irqrestore(&dwc->lock, flags);
> =20
>  	return count;

wrong, if you don't have gadget mode, you just don't create this file.

> @@ -638,7 +639,8 @@ static ssize_t dwc3_link_state_write(struct file *fil=
e,
>  		return -EINVAL;
> =20
>  	spin_lock_irqsave(&dwc->lock, flags);
> -	dwc3_gadget_set_link_state(dwc, state);
> +	if (dwc3_gadget_set_link_state(dwc, state))
> +		dev_dbg(dwc->dev, "host: Invalid request\n");

likewise.

>  	spin_unlock_irqrestore(&dwc->lock, flags);
> =20
>  	return count;
> diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
> index 99e6d72..28e82db 100644
> --- a/drivers/usb/dwc3/gadget.h
> +++ b/drivers/usb/dwc3/gadget.h
> @@ -105,8 +105,16 @@ static inline void dwc3_gadget_move_request_queued(s=
truct dwc3_request *req)
>  void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
>  		int status);
> =20
> +#ifdef CONFIG_USB_GADGET

not taking into account CONFIG_USB_GADGET=3Dm

--=20
balbi

--s8wpp40TDz0KNMmP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7rvuAAoJEIaOsuA1yqREZNkP/RdtmCVaoboZuzhdp+azDkZd
Lq16ns47ZP4tUuFT2ph7nXyu7ALfQCkRbWxRdDEuCiVqfRRU3GziZVhiEr0YKZgc
LNFiRIvQOZkC7WPxKiIcZm2S9prSz/Ko+OCfLkrUPiYGGiLDL1bgSJoCLnbhuWWe
Qc7oTBcEVG1XpUApZ5pPksMC5KC2YagYeXBndvpRB9Gz1lT0nwJ9kKgTtoYnGlEU
LYpafmj3B4mwX7HBXg5F1pVgYlnlDOXdppKOeQeO1jghEwL/XiRq3o03QstrAS2k
fJKjeX+cpbtJJG8PbZHCEobtv1VkDKgKzj7S/pVDghcIZ7YR0gupS3LULAuRdWXy
JLOqacbJ+cKlm+Ee6ZRxizb2EZoh2Zv0RBD5qrnWmS5tHEfkQMQ7sU3eF2fdMDrN
aCBHCqdbjOZcWrYOJb/DJd+SYWXMCpmgSOQzroMuVqZecpoOrNaP8wVra11DTd5g
UjoVPiOBL+uT7jtbPQZzx9XLCwmZ59VTGQqvxbMENGs4Q4W0yg5SvpFlovZUSAoz
RzqKh1kEPP8+88lkRekcqRX1e1KkHHiHRTzOKKZxLtz4qkEMVmmjye9YVV7seiNJ
S69xJl2rs5PV7pK8B1ow+8VbFUvCu7b/4b3SVZ989+vtNzyB24hRgvTUWeCBx5ZZ
rNikz5VT892CWdhNFy3D
=iU80
-----END PGP SIGNATURE-----

--s8wpp40TDz0KNMmP--
