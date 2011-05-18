Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab1ERKtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:49:04 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:53232 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756924Ab1ERKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:49:02 -0400
Date: Wed, 18 May 2011 13:48:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com
Subject: Re: [RESEND][PATCH 5/5] arm: omap: usb: global Suspend and resume
 support of ehci and ohci
Message-ID: <20110518104849.GC13908@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305538755-21112-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <1305538755-21112-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 16, 2011 at 03:09:15PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> The global suspend and resume functions for usbhs core driver
> are implemented.These routine are called when the global suspend
> and resume occurs. Before calling these functions, the
> bus suspend and resume of ehci and ohci drivers are called
> from runtime pm.
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |  103 +++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 103 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index bd63429..e1bc3b5 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -146,6 +146,10 @@
>  #define is_ehci_hsic_mode(x)	(x =3D=3D OMAP_EHCI_PORT_MODE_HSIC)
> =20
> =20
> +/* USBHS state bits */
> +#define OMAP_USBHS_INIT		0
> +#define OMAP_USBHS_SUSPEND	4
> +
>  struct usbhs_hcd_omap {
>  	struct clk			*xclk60mhsp1_ck;
>  	struct clk			*xclk60mhsp2_ck;
> @@ -165,6 +169,7 @@ struct usbhs_hcd_omap {
>  	u32				usbhs_rev;
>  	spinlock_t			lock;
>  	int				count;
> +	unsigned long			state;
>  };
>  /*----------------------------------------------------------------------=
---*/
> =20
> @@ -807,6 +812,8 @@ static int usbhs_enable(struct device *dev)
>  				(pdata->ehci_data->reset_gpio_port[1], 1);
>  	}
> =20
> +	set_bit(OMAP_USBHS_INIT, &omap->state);
> +
>  end_count:
>  	omap->count++;
>  	spin_unlock_irqrestore(&omap->lock, flags);
> @@ -895,6 +902,7 @@ static void usbhs_disable(struct device *dev)
>  	}
> =20
>  	pm_runtime_put_sync(dev);
> +	clear_bit(OMAP_USBHS_INIT, &omap->state);
> =20
>  	/* The gpio_free migh sleep; so unlock the spinlock */
>  	spin_unlock_irqrestore(&omap->lock, flags);
> @@ -924,10 +932,105 @@ void omap_usbhs_disable(struct device *dev)
>  }
>  EXPORT_SYMBOL_GPL(omap_usbhs_disable);
> =20
> +#ifdef	CONFIG_PM
> +
> +static int usbhs_resume(struct device *dev)
> +{
> +	struct usbhs_hcd_omap		*omap =3D dev_get_drvdata(dev);
> +	struct usbhs_omap_platform_data	*pdata =3D &omap->platdata;
> +	unsigned long			flags =3D 0;
> +
> +	dev_dbg(dev, "Resuming TI HSUSB Controller\n");
> +
> +	if (!pdata) {
> +		dev_dbg(dev, "missing platform_data\n");
> +		return  -ENODEV;
> +	}
> +
> +	spin_lock_irqsave(&omap->lock, flags);
> +
> +	if (!test_bit(OMAP_USBHS_INIT, &omap->state) ||
> +		!test_bit(OMAP_USBHS_SUSPEND, &omap->state))
> +			goto end_resume;
> +
> +	pm_runtime_get_sync(dev);
> +
> +	if (is_omap_usbhs_rev2(omap)) {
> +		if (is_ehci_tll_mode(pdata->port_mode[0])) {
> +			clk_enable(omap->usbhost_p1_fck);
> +			clk_enable(omap->usbtll_p1_fck);
> +		}
> +		if (is_ehci_tll_mode(pdata->port_mode[1])) {
> +			clk_enable(omap->usbhost_p2_fck);
> +			clk_enable(omap->usbtll_p2_fck);
> +		}
> +		clk_enable(omap->utmi_p1_fck);
> +		clk_enable(omap->utmi_p2_fck);
> +	}
> +	clear_bit(OMAP_USBHS_SUSPEND, &omap->state);
> +
> +end_resume:
> +	spin_unlock_irqrestore(&omap->lock, flags);
> +	return 0;
> +}
> +
> +
> +static int usbhs_suspend(struct device *dev)
> +{
> +	struct usbhs_hcd_omap		*omap =3D dev_get_drvdata(dev);
> +	struct usbhs_omap_platform_data	*pdata =3D &omap->platdata;
> +	unsigned long			flags =3D 0;
> +
> +	dev_dbg(dev, "Suspending TI HSUSB Controller\n");
> +
> +	if (!pdata) {
> +		dev_dbg(dev, "missing platform_data\n");
> +		return  -ENODEV;
> +	}
> +
> +	spin_lock_irqsave(&omap->lock, flags);
> +
> +	if (!test_bit(OMAP_USBHS_INIT, &omap->state) ||
> +		test_bit(OMAP_USBHS_SUSPEND, &omap->state))
> +			goto end_suspend;
> +
> +	if (is_omap_usbhs_rev2(omap)) {
> +		if (is_ehci_tll_mode(pdata->port_mode[0])) {
> +			clk_disable(omap->usbhost_p1_fck);
> +			clk_disable(omap->usbtll_p1_fck);
> +		}
> +		if (is_ehci_tll_mode(pdata->port_mode[1])) {
> +			clk_disable(omap->usbhost_p2_fck);
> +			clk_disable(omap->usbtll_p2_fck);
> +		}
> +		clk_disable(omap->utmi_p2_fck);
> +		clk_disable(omap->utmi_p1_fck);
> +	}
> +
> +	set_bit(OMAP_USBHS_SUSPEND, &omap->state);
> +	pm_runtime_put_sync(dev);
> +
> +end_suspend:
> +	spin_unlock_irqrestore(&omap->lock, flags);
> +	return 0;
> +}
> +
> +

one blank line only :-) (nitpicking, I know)

--=20
balbi

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN06QRAAoJEAv8Txj19kN1bXsIAKoZ6DZONJFXfoY4KletYODZ
gqypHc9ZO7B/X3cVkF/wujiC9jqgqgRYg5b7YKun5vuiD1LYYHX62bu6yvhwOpq9
HHsvU9aB9OyrQ0YLUDI/PV1DXWTFXDAMIx3FHPwRGbV5v2lOzBWhudm2zXv6e9ci
OJEYl5MtHXS2vFxkpVLfBf2uiDtRU32VnTUezPBxpR5r1MDL5xT3SgPkp9AcAcKl
MI46UZuo1pfk6dr0RnT8riHDxUePUglJmAog90qO1SIgSOSIW447kf6UvZaCA0WA
P/NFHxFFnHmNg74rtNatuJ8btHT5zvf3ru3Nh81r+ciOCyFGJO1+u4TRik4EDHM=
=hX49
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
