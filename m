Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2ISMAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 08:00:12 -0400
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:52785 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755863Ab2ISMAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 08:00:06 -0400
Date: Wed, 19 Sep 2012 14:55:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Moiz Sonasath <m-sonasath@ti.com>
Subject: Re: [PATCH 3/4] usb: phy: omap-usb3: Decrease the number of
 transitions to recovery
Message-ID: <20120919115518.GH3772@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
 <1348054229-27362-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OfrWf2Fun5Ae4m0Y"
Content-Disposition: inline
In-Reply-To: <1348054229-27362-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OfrWf2Fun5Ae4m0Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 05:00:28PM +0530, Kishon Vijay Abraham I wrote:
> Power-cycling the PHY (partially) decreases the number of transitions to
> "Recovery" state. Hence changed the power up sequence to a partial
> power-up before a full power-up of the PHY.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Moiz Sonasath <m-sonasath@ti.com>

this can be amended to patch 1. Why would you introduce a driver with a
known problem ? ;-)

> ---
>  drivers/usb/phy/omap-usb3.c  |   43 ++++++++++++++++++++++++++++++++++++=
------
>  include/linux/usb/omap_usb.h |    1 +
>  2 files changed, 38 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/usb/phy/omap-usb3.c b/drivers/usb/phy/omap-usb3.c
> index 26402d5..fb3c5e6 100644
> --- a/drivers/usb/phy/omap-usb3.c
> +++ b/drivers/usb/phy/omap-usb3.c
> @@ -35,13 +35,15 @@ static struct usb_dpll_params omap_usb3_dpll_params[N=
UM_SYS_CLKS] =3D {
>  };
> =20
>  /**
> - * omap5_usb_phy_power - power on/off the serializer using control module
> + * omap5_usb_phy_partial_powerup - power on the serializer using control=
 module
>   * @phy: struct omap_usb *
> - * @on: 0 to off and 1 to on based on powering on or off the PHY
>   *
> - * omap_usb3 can call this API to power on or off the PHY.
> + * After the dwc3 module is disabled and enabled again the synchronizati=
on
> + * between dwc3 and phy goes bad and the device does not get enumerated
> + * in superspeed mode. After some trials it was found powering up TX and
> + * part of RX PHY helped to solve the issue.
>   */
> -static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
> +static int omap5_usb_phy_partial_powerup(struct omap_usb *phy)
>  {
>  	u32 val;
>  	unsigned long rate;
> @@ -58,10 +60,32 @@ static int omap5_usb_phy_power(struct omap_usb *phy, =
bool on)
> =20
>  	val =3D readl(phy->control_dev);
> =20
> +	val &=3D ~(USB_PWRCTL_CLK_CMD_MASK | USB_PWRCTL_CLK_FREQ_MASK);
> +	val |=3D (USB3_PHY_PARTIAL_RX_POWERON | USB3_PHY_TX_RX_POWERON)
> +		<< USB_PWRCTL_CLK_CMD_SHIFT;
> +	val |=3D rate << USB_PWRCTL_CLK_FREQ_SHIFT;
> +
> +	writel(val, phy->control_dev);
> +
> +	return 0;
> +}
> +
> +/**
> + * omap5_usb_phy_power - power on/off the serializer using control module
> + * @phy: struct omap_usb *
> + * @on: 0 to off and 1 to on based on powering on or off the PHY
> + *
> + * omap_usb3 can call this API to power on or off the PHY.
> + */
> +static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
> +{
> +	u32 val;
> +
> +	val =3D readl(phy->control_dev);
> +
>  	if (on) {
> -		val &=3D ~(USB_PWRCTL_CLK_CMD_MASK | USB_PWRCTL_CLK_FREQ_MASK);
> +		val &=3D ~USB_PWRCTL_CLK_CMD_MASK;
>  		val |=3D USB3_PHY_TX_RX_POWERON << USB_PWRCTL_CLK_CMD_SHIFT;
> -		val |=3D rate << USB_PWRCTL_CLK_FREQ_SHIFT;
>  	} else {
>  		val &=3D ~USB_PWRCTL_CLK_CMD_MASK;
>  		val |=3D USB3_PHY_TX_RX_POWEROFF << USB_PWRCTL_CLK_CMD_SHIFT;
> @@ -207,6 +231,13 @@ static int omap_usb3_init(struct usb_phy *x)
>  	struct omap_usb	*phy =3D phy_to_omapusb(x);
> =20
>  	omap_usb_dpll_lock(phy);
> +	omap5_usb_phy_partial_powerup(phy);
> +	/*
> +	 * Give enough time for the PHY to partially power-up before
> +	 * powering it up completely. delay value suggested by the HW
> +	 * team.
> +	 */
> +	mdelay(100);

why 100 ms ? Has this been measured ? Again, 100 ms is a loooooong time.
Soon enough user will be waiting for a bit over a second to see that
after connecting usb cable, there's activity. We don't want user to
notice that kind of thing ;-)

--=20
balbi

--OfrWf2Fun5Ae4m0Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWbKmAAoJEIaOsuA1yqREztcQAJ4r2cZV1/xQcz65WeE8bV7m
UuKadpo5CrpdR2DESbjPD3vfD5nFQ9k/EToRLwypiC4aA4nFzai9oHrFk3eSfJLf
hEhgz2q+J8Mcd+wWzkH19P+OlV/IGaeRQczUMVNXYo5XZtuKiTycrgVTA51fb5mE
f4MwrNi1YQ+ZHrYuB+SdYKXG0yjlLzGrFLEnGmiv9RV1k8Jwkbxh3XGvCGeqRGdv
c6mPdYwkISZXOIW5etXYu7d443VEnDmnvsbci4lfidd1kbuxMxqAIR+25ACthTwj
Berrr28OERULcQh9KyTHv0fCOiNK0QFmTrmzZcp6Jk/y7empNnv4tgzcLhy747T8
y4oRTvDbnPpSbvdl9Ad7s/FdTWWGL9u/IhTxmzGtH49xhctoGQscdaOSZRBSQ1sV
0jOxNmX75J4LYanFOOwPujabKLPuJKm0XM+agh7868eoexuREl2mYxBrBMCey0IB
M5n2jMBCmtdBZl5ay7LpUvEVEEnuqDS2leCVcW8nDdNAjST+Gz0rZs1d6nS9ZWVU
AMeQUWkzommX+JqOPpfml/pdDmq1abI6oyZI0ORk+5j47HYupWk/uiZxiKWeiMSm
OjBNgc4AewFxthK1trUxTsoj/LPx4Ro9Wumfaipyo8b9R8BAiUcUUFsv3j89d5xx
EkOcUb/8f6p6mdnTDkqF
=DSJ2
-----END PGP SIGNATURE-----

--OfrWf2Fun5Ae4m0Y--
