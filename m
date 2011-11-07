Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1KGJrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 04:47:09 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:47075 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab1KGJrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 04:47:08 -0500
Date: Mon, 7 Nov 2011 11:47:02 +0200
From: Felipe Balbi <balbi@ti.com>
To: Nikolaus Voss <n.voss@weinmann.de>
Cc: 'linux-i2c@vger.kernel.org', 'linux-arm-kernel@lists.infradead.org',
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Message-ID: <20111107094701.GF4265@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 07, 2011 at 10:27:52AM +0100, Nikolaus Voss wrote:
> From a05fa963f819dabf985ec0d76c769b2cf4894ccf Mon Sep 17 00:00:00 2001
> From: Nikolaus Voss <n.voss@weinmann.de>
> Date: Thu, 27 Oct 2011 11:12:55 +0200
> Subject: [PATCH 1/6] drivers/i2c/busses/i2c-at91.c: fix brokeness
>=20
> This patch contains the following fixes:
> 1. Support for multiple interfaces (there are usually two of them).
> 2. Remove busy waiting in favour of interrupt driven io.
> 3. No repeated start (Sr) was possible. This implementation supports one
>    repeated start condition which is enough for most real-world applicati=
ons
>    including all SMBus transfer types.
>=20
> Tested on Atmel G45 with BQ20Z80 battery SMBus client.
>=20
> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>

IMHO, you should split this patch into three or more smaller patches.
You're doing lots of different things in one commit and it'll be a pain
to bisect should this cause any issues to anyone.

> ---
> V2: No killed tabs, patch should apply now.
>=20
>  drivers/i2c/busses/Kconfig    |   11 +-
>  drivers/i2c/busses/i2c-at91.c |  415 +++++++++++++++++++++++++++--------=
------
>  2 files changed, 278 insertions(+), 148 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 646068e..c4b6bdc 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -286,18 +286,15 @@ comment "I2C system bus drivers (mostly embedded / =
system-on-chip)"
>=20
>  config I2C_AT91
>  	tristate "Atmel AT91 I2C Two-Wire interface (TWI)"
> -	depends on ARCH_AT91 && EXPERIMENTAL && BROKEN
> +	depends on ARCH_AT91 && EXPERIMENTAL
>  	help
>  	  This supports the use of the I2C interface on Atmel AT91
>  	  processors.
>=20
> -	  This driver is BROKEN because the controller which it uses
> -	  will easily trigger RX overrun and TX underrun errors.  Using
> -	  low I2C clock rates may partially work around those issues
> -	  on some systems.  Another serious problem is that there is no
> -	  documented way to issue repeated START conditions, as needed
> +	  A serious problem is that there is no documented way to issue
> +	  repeated START conditions for more than two messages, as needed
>  	  to support combined I2C messages.  Use the i2c-gpio driver
> -	  unless your system can cope with those limitations.
> +	  unless your system can cope with this limitation.
>=20
>  config I2C_AU1550
>  	tristate "Au1550/Au1200 SMBus interface"
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 305c075..a2c38ff 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -1,6 +1,10 @@
> -/*
> +/* -*- linux-c -*-

you shouldn't add this editor hooks to linux source files.

> @@ -279,33 +400,45 @@ static int __devexit at91_i2c_remove(struct platfor=
m_device *pdev)
>=20
>  /* NOTE: could save a few mA by keeping clock off outside of at91_xfer..=
=2E */
>=20
> -static int at91_i2c_suspend(struct platform_device *pdev, pm_message_t m=
esg)
> +static int at91_i2c_suspend(struct device *dev)
>  {
> -	clk_disable(twi_clk);
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct at91_i2c_dev *i2c_dev =3D platform_get_drvdata(pdev);
> +
> +	clk_disable(i2c_dev->clk);
> +
>  	return 0;
>  }
>=20
> -static int at91_i2c_resume(struct platform_device *pdev)
> +static int at91_i2c_resume(struct device *dev)
>  {
> -	return clk_enable(twi_clk);
> +	struct platform_device *pdev =3D to_platform_device(dev);
> +	struct at91_i2c_dev *i2c_dev =3D platform_get_drvdata(pdev);

dev_get_drvdata(dev) will do the same of two above lines. You don't need
to fetch the platform_device...

> @@ -322,6 +455,6 @@ static void __exit at91_i2c_exit(void)
>  module_init(at91_i2c_init);
>  module_exit(at91_i2c_exit);
>=20
> -MODULE_AUTHOR("Rick Bronson");
> +MODULE_AUTHOR("Nikolaus Voss");

wow... are you sure ? Rick will always be the original author, no ?

--=20
balbi

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOt6kVAAoJEIaOsuA1yqRE0HQP/0gzJmmEujpZpuKthcrT0Qn/
iAr5mbWA0E8wKkFwJL2q8nb0HYq4s/cOb97at7YR6raWuS2XdmyF7VMRgSONHJEp
q3NcJ39ctxCGGrcqnlQ3EmB+05D+ay2L4vxUGahNmTI9TYlPaBnxAam47hncWfmX
PrHOLgIHHvRICkdRRcRmBujjqGwDPwNSmq6I8RliW4e/+KHS2GRhB8qWZ4SIuQCT
TbNPjE63Gx/WUznrZi4SB2QPRKr82UMhyFGW80537bmQ44/fmlGEaqowXUIEXU6I
0jKGHl77OwxYAzjVmSAwsp8Y05d3S6J4RriqgKEVrRbKF7rmRKDw/yzYRiWP9ZBp
NPd7qztVPxzRnBY5bE1IS79DnxQDF50MB3jTECFb7T1xBz9F+UcVCaj5oD5CKfFY
eI2maYSocK+cm/ZMH00gILGV0PVaHhOe6QSQtDh98/xaEOgYOT9M1F+7G60JiOKP
TNDynCweyBimhyEDU5m4hv/bTAjQReG6VDxH0xUF6iJyhKXgnbpJgLqdH+aFMMt8
fsb3kSo76cL1BoEI56Fco6ekp+Q3Rc58fShQmcdNrfwmlJoygd9SCexvu9CzIP3d
eoOYY4OjvzRxhGIfuguM895QJQv8oy+ebfJz+qC+Kp7C0JYy9I+o5GZc4DNMPv9o
7/WNeERJalLWA+xMGRNo
=pEku
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
