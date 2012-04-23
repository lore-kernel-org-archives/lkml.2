Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2DWSUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:20:49 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60973 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974Ab2DWSUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:20:48 -0400
Date: Mon, 23 Apr 2012 20:20:33 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: m.szyprowski@samsung.com, ben-linux@fluff.org, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] i2c-s3c2410: Rework device type handling
Message-ID: <20120423182033.GB2767@pengutronix.de>
References: <1335198241-19344-1-git-send-email-k.lewandowsk@samsung.com>
 <1335198241-19344-2-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <1335198241-19344-2-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 23, 2012 at 06:24:00PM +0200, Karol Lewandowski wrote:
> Reorganize driver a bit to better handle device tree-based systems:
>=20
>  - move machine type to driver's private structure instead of
>    quering platform device variants in runtime
>=20
>  - replace s3c24xx_i2c_type enum with unsigned int that holds
>    bitmask with revision-specific quirks
>=20
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c |   75 +++++++++++++++++---------------=
------
>  1 file changed, 34 insertions(+), 41 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3=
c2410.c
> index 85e3664..23736ff 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -44,8 +44,10 @@
>  #include <plat/regs-iic.h>
>  #include <plat/iic.h>
> =20
> -/* i2c controller state */
> +/* Treat S3C2410 as baseline hardware, anything else is supported via qu=
irks */
> +#define QUIRK_S3C2440		(1 << 0)
> =20
> +/* i2c controller state */
>  enum s3c24xx_i2c_state {
>  	STATE_IDLE,
>  	STATE_START,
> @@ -54,14 +56,10 @@ enum s3c24xx_i2c_state {
>  	STATE_STOP
>  };
> =20
> -enum s3c24xx_i2c_type {
> -	TYPE_S3C2410,
> -	TYPE_S3C2440,
> -};
> -
>  struct s3c24xx_i2c {
>  	spinlock_t		lock;
>  	wait_queue_head_t	wait;
> +	unsigned int            quirks;
>  	unsigned int		suspended:1;
> =20
>  	struct i2c_msg		*msg;
> @@ -88,26 +86,40 @@ struct s3c24xx_i2c {
>  #endif
>  };
> =20
> -/* default platform data removed, dev should always carry data. */
> +static struct platform_device_id s3c24xx_driver_ids[] =3D {
> +	{
> +		.name		=3D "s3c2410-i2c",
> +		.driver_data	=3D 0,
> +	}, {
> +		.name		=3D "s3c2440-i2c",
> +		.driver_data	=3D QUIRK_S3C2440,
> +	}, { },
> +};
> +MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
> +
> +#ifdef CONFIG_OF
> +static const struct of_device_id s3c24xx_i2c_match[] =3D {
> +	{ .compatible =3D "samsung,s3c2410-i2c", .data =3D (void *)0 },
> +	{ .compatible =3D "samsung,s3c2440-i2c", .data =3D (void *)QUIRK_S3C244=
0 },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, s3c24xx_i2c_match);
> +#endif
> =20
> -/* s3c24xx_i2c_is2440()
> +/* s3c24xx_get_device_quirks
>   *
> - * return true is this is an s3c2440
> + * Get controller type either from device tree or platform device varian=
t.
>  */
> =20
> -static inline int s3c24xx_i2c_is2440(struct s3c24xx_i2c *i2c)
> +static inline unsigned int s3c24xx_get_device_quirks(struct platform_dev=
ice *pdev)
>  {
> -	struct platform_device *pdev =3D to_platform_device(i2c->dev);
> -	enum s3c24xx_i2c_type type;
> -
> -#ifdef CONFIG_OF
> -	if (i2c->dev->of_node)
> -		return of_device_is_compatible(i2c->dev->of_node,
> -				"samsung,s3c2440-i2c");
> -#endif
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match =3D of_match_node(&s3c24xx_i2c_match, pdev->dev.of_node);

I'd appreciate a comment explaining why match can't be NULL here (as to
my understanding, it can't). Or just check for it, but this way it looks
a bit fishy and people (hopefully ;)) will ask about it.

> +		return (unsigned int)match->data;
> +	}
> =20
> -	type =3D platform_get_device_id(pdev)->driver_data;
> -	return type =3D=3D TYPE_S3C2440;
> +	return platform_get_device_id(pdev)->driver_data;
>  }
> =20
>  /* s3c24xx_i2c_master_complete
> @@ -676,7 +688,7 @@ static int s3c24xx_i2c_clockrate(struct s3c24xx_i2c *=
i2c, unsigned int *got)
> =20
>  	writel(iiccon, i2c->regs + S3C2410_IICCON);
> =20
> -	if (s3c24xx_i2c_is2440(i2c)) {
> +	if (i2c->quirks & QUIRK_S3C2440) {
>  		unsigned long sda_delay;
> =20
>  		if (pdata->sda_delay) {
> @@ -906,6 +918,7 @@ static int s3c24xx_i2c_probe(struct platform_device *=
pdev)
>  		goto err_noclk;
>  	}
> =20
> +	i2c->quirks =3D s3c24xx_get_device_quirks(pdev);
>  	if (pdata)
>  		memcpy(i2c->pdata, pdata, sizeof(*pdata));
>  	else
> @@ -1110,26 +1123,6 @@ static const struct dev_pm_ops s3c24xx_i2c_dev_pm_=
ops =3D {
> =20
>  /* device driver for platform bus bits */
> =20
> -static struct platform_device_id s3c24xx_driver_ids[] =3D {
> -	{
> -		.name		=3D "s3c2410-i2c",
> -		.driver_data	=3D TYPE_S3C2410,
> -	}, {
> -		.name		=3D "s3c2440-i2c",
> -		.driver_data	=3D TYPE_S3C2440,
> -	}, { },
> -};
> -MODULE_DEVICE_TABLE(platform, s3c24xx_driver_ids);
> -
> -#ifdef CONFIG_OF
> -static const struct of_device_id s3c24xx_i2c_match[] =3D {
> -	{ .compatible =3D "samsung,s3c2410-i2c" },
> -	{ .compatible =3D "samsung,s3c2440-i2c" },
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, s3c24xx_i2c_match);
> -#endif
> -
>  static struct platform_driver s3c24xx_i2c_driver =3D {
>  	.probe		=3D s3c24xx_i2c_probe,
>  	.remove		=3D s3c24xx_i2c_remove,

Rest is looking good, second patch, too.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--5/uDoXvLw7AC5HRs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VnXEACgkQD27XaX1/VRvu7wCeJw0RQLM2K411oS1ZUovYgHOy
J+wAnRYJcozv8W83GhehalFocONFUU0d
=ZwSd
-----END PGP SIGNATURE-----

--5/uDoXvLw7AC5HRs--
