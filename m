Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab2CAUqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 15:46:00 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38142 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932484Ab2CAUp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 15:45:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.152.114.133 as permitted sender) smtp.mail=balbi@ti.com
Date: Thu, 1 Mar 2012 22:45:54 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120301204553.GA21841@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1330006564-13290-1-git-send-email-mporter@ti.com>
 <87wr74gis6.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <87wr74gis6.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 01, 2012 at 12:36:57PM -0800, Kevin Hilman wrote:
> Matt Porter <mporter@ti.com> writes:
>=20
> > This fixes smsc911x support on platforms using gpmc_smsc911x_init().
> >
> > Commit c7e963f6888816 (net/smsc911x: Add regulator support) added
> > the requirement that platforms provide vdd33a and vddvario supplies.
> >
> > Signed-off-by: Matt Porter <mporter@ti.com>
>=20
> [...]
>=20
> >  /*
> >   * Initialize smsc911x device connected to the GPMC. Note that we
> >   * assume that pin multiplexing is done in the board-*.c file,
> > @@ -55,6 +101,12 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x=
_platform_data *board_data)
> > =20
> >  	gpmc_cfg =3D board_data;
> > =20
> > +	ret =3D platform_device_register(&gpmc_smsc911x_regulator);
> > +	if (ret < 0) {
> > +		pr_err("Unable to register smsc911x regulators: %d\n", ret);
> > +		return;
> > +	}
> > +
>=20
> Boards that have more than one instance of the smsc911x (OMAP3/Overo)
> barf here because of trying to register the same device twice.
>=20
> We need something like the patch below to make Overo boot again.
>=20
> Kevin
>=20
>=20
>=20
> From 4114dea2fb897ab75d05eaa943d29454034fc025 Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@ti.com>
> Date: Thu, 1 Mar 2012 12:30:42 -0800
> Subject: [PATCH] ARM: OMAP2+: gpmc-smsc911x: only register regulators once
>=20
> commit e4b0b2cbbb (ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
> regulators) added regulators which are registered during
> gpmc_smsc911x_init().  However, some platforms (OMAP3/Overo) have more
> than one instance of the SMSC911x and result in attempting to register
> the same regulator more than once which causes a panic().  Fix this by
> tracking the regulator registration ensuring only a single device is
> registered.
>=20
> Cc: Matt Porter <mporter@ti.com>
> Signed-off-by: Kevin Hilman <khilman@ti.com>
> ---
>  arch/arm/mach-omap2/gpmc-smsc911x.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/gpmc-smsc911x.c b/arch/arm/mach-omap2/gp=
mc-smsc911x.c
> index bbb870c..95e6c7d 100644
> --- a/arch/arm/mach-omap2/gpmc-smsc911x.c
> +++ b/arch/arm/mach-omap2/gpmc-smsc911x.c
> @@ -88,6 +88,8 @@ static struct platform_device gpmc_smsc911x_regulator =
=3D {
>  	},
>  };
> =20
> +static bool regulator_registered;
> +
>  /*
>   * Initialize smsc911x device connected to the GPMC. Note that we
>   * assume that pin multiplexing is done in the board-*.c file,
> @@ -101,10 +103,14 @@ void __init gpmc_smsc911x_init(struct omap_smsc911x=
_platform_data *board_data)
> =20
>  	gpmc_cfg =3D board_data;
> =20
> -	ret =3D platform_device_register(&gpmc_smsc911x_regulator);
> -	if (ret < 0) {
> -		pr_err("Unable to register smsc911x regulators: %d\n", ret);
> -		return;
> +	if (!regulator_registered) {
> +		ret =3D platform_device_register(&gpmc_smsc911x_regulator);
> +		if (ret < 0) {
> +			pr_err("Unable to register smsc911x regulators: %d\n",
> +			       ret);
> +			return;
> +		}
> +		regulator_registered =3D true;

Wow, this is quite a hack. Is the regulator part of the SMSC911x device
or is it outside ? If it's outside the SMSC91xx (which I believe it is)
there should be a regulator driver instead of this hack. For boards
which don't provide such a regulator (and tie the supply pin to some
constant voltage source) there should be a constant regulator supplying
the pin. But this patch is quite hacky.

--=20
balbi

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT+ABAAoJEIaOsuA1yqREO38P/RSh3ehjJLVrXX8b30KzkIs2
VGI0JYogM2KuuOoj4NcPZ2nqrNZo3yMIa0USzQPEOm+DgzT2FpUNAeRq3+txIPDy
MDV6jH2x++BZjizxrus6OpfkprO3P9t51glA9wQk8oG11rjwQzPNled5by7eXqZi
9gPacKc2oLlmxImvhuBNLniYpsESsN2WLIPJfQ+c9kbkHDKqt+edAZKg5WJN5BES
l0Fueo4WlkDvt5faf0tiXxLrrpi7+Hi9100FcFn/ko6sJDzUZAu/lXLfN0PJRH1i
MKFjiAXiE3E3s+hLI1V7lVBWSrQVXq23aVnH29HBlSslJA8Evc5gQcClHjpis2tJ
7zTL2W5K6n4JZ/24LbJOK88tKGhfd8nwb3GRuq7dAl/wmNRG5uz83ztoIb5nX1mw
HYfZWDszB0102lsn60V9TpvTtoDGLl4/9+fMKd7RuX6OYuKsc434OJ7JvN2qPhFl
1UR2pmHonwUKiQyLjTrN+37hvvmHUOdUsSUOyD3y1OcbSd8vuuU+k7adOEY/oSBL
2wLrUy0pRKJuQ96JINmDYP9PMQcDqfXyDDZLTOO0ECYnfqeRcsnQtpsVvn1wLrk/
ucE+c7Q3kZdX+8hNl5vhiy+LRG4lOGbo3yazZdhpDP22gn033huLIhq3zsClAcaG
kKGmR8KfxkcNDy0L9X/R
=ucXR
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
