Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab2DQRkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:40:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51917 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755424Ab2DQRkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:40:41 -0400
Date: Tue, 17 Apr 2012 19:40:29 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 3/3] i2c-s3c2410: Add HDMIPHY quirk for S3C2440
Message-ID: <20120417174029.GC22406@pengutronix.de>
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-4-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <1332357113-2973-4-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 21, 2012 at 08:11:53PM +0100, Karol Lewandowski wrote:
> This patch adds support for s3c2440 I2C bus controller dedicated HDMIPHY =
device on
> Exynos4 platform. Some quirks are introduced due to differences between H=
DMIPHY
> and other I2C controllers on Exynos4.  These differences are:
> - no GPIOs, HDMIPHY is inside the SoC and the controller is connected
>   internally
> - due to unknown reason (probably HW bug in HDMIPHY and/or the controller=
) a
>   transfer fails to finish. The controller hangs after sending the last b=
yte,
>   the workaround for this bug is resetting the controller after each tran=
sfer
>=20
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/i2c/samsung-i2c.txt        |   11 +++++-
>  drivers/i2c/busses/i2c-s3c2410.c                   |   35 ++++++++++++++=
++++++
>  2 files changed, 44 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt b/Docu=
mentation/devicetree/bindings/i2c/samsung-i2c.txt
> index 38832c7..c6670f9 100644
> --- a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
> +++ b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
> @@ -10,14 +10,21 @@ Required properties:
>      region.
>    - interrupts: interrupt number to the cpu.
>    - samsung,i2c-sda-delay: Delay (in ns) applied to data line (SDA) edge=
s.
> -  - gpios: The order of the gpios should be the following: <SDA, SCL>.
> -    The gpio specifier depends on the gpio controller.
> =20
>  Optional properties:
> +  - gpios: The order of the gpios should be the following: <SDA, SCL>.
> +    The gpio specifier depends on the gpio controller. Required in all c=
ases
> +    except when "samsung,i2c-no-gpio" is also specified.
> +  - samsung,i2c-no-gpio: input/output lines of the controller are
> +    permanently wired to the respective client, there are no gpio
> +    lines that need to be configured to enable this controller

Can't we just skip this property...


>    - samsung,i2c-slave-addr: Slave address in multi-master enviroment. If=
 not
>      specified, default value is 0.
>    - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If not
>      specified, the default value in Hz is 100000.
> +  - samsung,i2c-quirk-hdmiphy: Quirk for HDMI PHY block found on
> +    Exynos4 platform - reduce timeout and reset controller after each
> +    transfer

=2E.. and this one, if we declare a new compatible-entry for exynos4?

> =20
>  Example:
> =20
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3=
c2410.c
> index f7b6a14..e50f523 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -50,6 +50,8 @@ static const struct of_device_id s3c24xx_i2c_match[];
> =20
>  /* Treat S3C2410 as baseline hardware, anything else is supported via qu=
irks */
>  #define QUIRK_S3C2440		(1 << 0)
> +#define QUIRK_HDMIPHY		(1 << 1)
> +#define QUIRK_NO_GPIO		(1 << 2)
> =20
>  /* i2c controller state */
>  enum s3c24xx_i2c_state {
> @@ -469,6 +471,13 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c=
 *i2c)
>  	unsigned long iicstat;
>  	int timeout =3D 400;
> =20
> +	/* the timeout for HDMIPHY is reduced to 10 ms because
> +	 * the hangup is expected to happen, so waiting 400 ms
> +	 * causes only unnecessary system hangup
> +	 */
> +	if (i2c->quirks & QUIRK_HDMIPHY)
> +		timeout =3D 10;
> +
>  	while (timeout-- > 0) {
>  		iicstat =3D readl(i2c->regs + S3C2410_IICSTAT);
> =20
> @@ -478,6 +487,15 @@ static int s3c24xx_i2c_set_master(struct s3c24xx_i2c=
 *i2c)
>  		msleep(1);
>  	}
> =20
> +	/* hang-up of bus dedicated for HDMIPHY occurred, resetting */
> +	if (i2c->quirks & QUIRK_HDMIPHY) {
> +		writel(0, i2c->regs + S3C2410_IICCON);
> +		writel(0, i2c->regs + S3C2410_IICSTAT);
> +		writel(0, i2c->regs + S3C2410_IICDS);
> +
> +		return 0;
> +	}
> +
>  	return -ETIMEDOUT;
>  }
> =20
> @@ -759,6 +777,9 @@ static int s3c24xx_i2c_parse_dt_gpio(struct s3c24xx_i=
2c *i2c)
>  {
>  	int idx, gpio, ret;
> =20
> +	if (i2c->quirks & QUIRK_NO_GPIO)
> +		return 0;
> +
>  	for (idx =3D 0; idx < 2; idx++) {
>  		gpio =3D of_get_gpio(i2c->dev->of_node, idx);
>  		if (!gpio_is_valid(gpio)) {
> @@ -783,6 +804,10 @@ free_gpio:
>  static void s3c24xx_i2c_dt_gpio_free(struct s3c24xx_i2c *i2c)
>  {
>  	unsigned int idx;
> +
> +	if (i2c->quirks & QUIRK_NO_GPIO)
> +		return;
> +
>  	for (idx =3D 0; idx < 2; idx++)
>  		gpio_free(i2c->gpios[idx]);
>  }
> @@ -859,6 +884,13 @@ s3c24xx_i2c_parse_dt(struct device_node *np, struct =
s3c24xx_i2c *i2c)
>  		return;
> =20
>  	pdata->bus_num =3D -1; /* i2c bus number is dynamically assigned */
> +
> +	if (of_get_property(np, "samsung,i2c-quirk-hdmiphy", NULL))
> +		i2c->quirks |=3D QUIRK_HDMIPHY;
> +
> +	if (of_get_property(np, "samsung,i2c-no-gpio", NULL))
> +		i2c->quirks |=3D QUIRK_NO_GPIO;
> +
>  	of_property_read_u32(np, "samsung,i2c-sda-delay", &pdata->sda_delay);
>  	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata->slave_addr);
>  	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
> @@ -1116,6 +1148,9 @@ static struct platform_device_id s3c24xx_driver_ids=
[] =3D {
>  	}, {
>  		.name		=3D "s3c2440-i2c",
>  		.driver_data	=3D QUIRK_S3C2440,
> +	}, {
> +		.name		=3D "s3c2440-hdmiphy-i2c",
> +		.driver_data	=3D QUIRK_S3C2440 | QUIRK_HDMIPHY | QUIRK_NO_GPIO,
>  	}, { },
>  };
>  MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
> --=20
> 1.7.9
>=20

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+Nqw0ACgkQD27XaX1/VRsQcQCgosUZWbOhjZ+Ais3cjWmCjVg/
yJUAn2K4tQDV1z4iKS3q31W+7pnE3Hv0
=Rou/
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
