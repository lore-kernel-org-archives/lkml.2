Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab2JaSng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:43:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51798 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2JaSnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:43:35 -0400
Date: Wed, 31 Oct 2012 20:37:30 +0200
From: Felipe Balbi <balbi@ti.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sameo@linux.intel.com>
Subject: Re: [PATCH v2 2/4] mfd: introduce retu-mfd driver
Message-ID: <20121031183730.GD28100@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351706626-32186-1-git-send-email-aaro.koskinen@iki.fi>
 <1351706626-32186-3-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HWvPVVuAAfuRc6SZ"
Content-Disposition: inline
In-Reply-To: <1351706626-32186-3-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HWvPVVuAAfuRc6SZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 08:03:44PM +0200, Aaro Koskinen wrote:
> Retu is a multi-function device found on Nokia Internet Tablets
> implementing at least watchdog, RTC, headset detection and power button
> functionality.
>=20
> This patch implements minimum functionality providing register access,
> IRQ handling and power off functions.
>=20
> Cc: sameo@linux.intel.com
> Acked-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---
>  drivers/mfd/Kconfig      |    9 ++
>  drivers/mfd/Makefile     |    1 +
>  drivers/mfd/retu-mfd.c   |  264 ++++++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/mfd/retu.h |   22 ++++
>  4 files changed, 296 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/retu-mfd.c
>  create mode 100644 include/linux/mfd/retu.h
>=20
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index acab3ef..7528c5e 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -1044,6 +1044,15 @@ config MFD_PALMAS
>  	  If you say yes here you get support for the Palmas
>  	  series of PMIC chips from Texas Instruments.
> =20
> +config MFD_RETU
> +	tristate "Support for Retu multi-function device"
> +	select MFD_CORE
> +	depends on I2C
> +	select REGMAP_IRQ
> +	help
> +	  Retu is a multi-function device found on Nokia Internet Tablets
> +	  (770, N800 and N810).
> +
>  endmenu
>  endif
> =20
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index d8ccb63..ad7879f 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -138,3 +138,4 @@ obj-$(CONFIG_MFD_RC5T583)	+=3D rc5t583.o rc5t583-irq.o
>  obj-$(CONFIG_MFD_SEC_CORE)	+=3D sec-core.o sec-irq.o
>  obj-$(CONFIG_MFD_SYSCON)	+=3D syscon.o
>  obj-$(CONFIG_MFD_LM3533)	+=3D lm3533-core.o lm3533-ctrlbank.o
> +obj-$(CONFIG_MFD_RETU)		+=3D retu-mfd.o
> diff --git a/drivers/mfd/retu-mfd.c b/drivers/mfd/retu-mfd.c
> new file mode 100644
> index 0000000..8f81566
> --- /dev/null
> +++ b/drivers/mfd/retu-mfd.c
> @@ -0,0 +1,264 @@
> +/*
> + * Retu MFD driver
> + *
> + * Copyright (C) 2004, 2005 Nokia Corporation
> + *
> + * Based on code written by Juha Yrj=F6l=E4, David Weinehall and Mikko Y=
linen.
> + * Rewritten by Aaro Koskinen.
> + *
> + * This file is subject to the terms and conditions of the GNU General
> + * Public License. See the file "COPYING" in the main directory of this
> + * archive for more details.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/i2c.h>
> +#include <linux/irq.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/mutex.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/retu.h>
> +#include <linux/interrupt.h>
> +#include <linux/moduleparam.h>
> +
> +/* Registers */
> +#define RETU_REG_ASICR		0x00		/* ASIC ID and revision */
> +#define RETU_REG_ASICR_VILMA	(1 << 7)	/* Bit indicating Vilma */
> +#define RETU_REG_IDR		0x01		/* Interrupt ID */
> +#define RETU_REG_IMR		0x02		/* Interrupt mask */
> +
> +/* Interrupt sources */
> +#define RETU_INT_PWR		0		/* Power button */
> +
> +struct retu_dev {
> +	struct regmap			*regmap;
> +	struct device			*dev;
> +	struct mutex			mutex;
> +	struct regmap_irq_chip_data	*irq_data;
> +};
> +
> +static struct resource retu_pwrbutton_res[] =3D {
> +	{
> +		.name	=3D "retu-pwrbutton",
> +		.start	=3D RETU_INT_PWR,
> +		.end	=3D RETU_INT_PWR,
> +		.flags	=3D IORESOURCE_IRQ,
> +	},
> +};
> +
> +static struct mfd_cell retu_devs[] =3D {
> +	{
> +		.name		=3D "retu-wdt"
> +	},
> +	{
> +		.name		=3D "retu-pwrbutton",
> +		.resources	=3D &retu_pwrbutton_res[0],

=2Eresources =3D retu_powerbutton_res, ??

--=20
balbi

--HWvPVVuAAfuRc6SZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkW/qAAoJEIaOsuA1yqREq4sQAI6VtseCjiAccLuUbup5Usmz
1E0z9FYATcFCSQNdGYC7iD2EcCSy+GReV8cdJfoJMZY3zopiPndfgJBlKfSLKE5A
TNWqgscQwNeKOSHzOWeTwok3NAYmX0QsONtwIiVbnjkb08ilMF6DSDA2sF4RZUqN
XD+lqMV2uxoAtXzU5proLO4EwEvWE+e+oqaMcxaEI/Wofs7IKF/F5UjHFH7tY1my
1T+g//6J3etWcLuJgFbtIbg15u9QvsfQFbop9PrAZDdxUzJn1HZjP6anAwFYEd7P
LYGc35McJM95uM4EYfRKjCiaZHNIZrfr3XTwJteMf+GO676fBSsXaOt6ewAQlvOL
pp/vLo7vBhi1cJ4BymXJHt1Jt3FOeAqn1BDpZ8GVhQFcAJofqfsZnG9di/VlBwtT
6dTQSAfmoWtNH5BcbZh26T9fe7Asr/rH7+EK3XSsnpXOQ99Gqza2eNhYM3fPTzv3
GtjifVPX0tl2kUS6ESnQBg1BTwclFW0PLklWDw8eAm+YVcBMqVIGBP5ubukZbDyb
JlZvif5Z9e7OKJqXLe3Yw3OkIdQxGRflxyKbQ3Pp3bOumUfpCHCEVRWaysLvunYj
yGmAB5OFd13C3/UGybgxPsUR/n6/2MO2t/C9b/pIolg4XaJWQNH4yWivwe/auZxQ
hjh44e2gr6ayhvIpeoOX
=taPR
-----END PGP SIGNATURE-----

--HWvPVVuAAfuRc6SZ--
