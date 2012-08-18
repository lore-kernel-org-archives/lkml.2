Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2HRMrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:47:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42499 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2HRMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:47:11 -0400
Date: Sat, 18 Aug 2012 14:47:03 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        olof@lixom.net
Subject: Re: [PATCH REBASE 1/2] i2c: tegra: I2_M_NOSTART functionality not
 supported in Tegra20
Message-ID: <20120818124703.GC12839@pengutronix.de>
References: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Content-Disposition: inline
In-Reply-To: <1345230155-4252-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 12:32:34AM +0530, Laxman Dewangan wrote:
> Tegra20 i2c controller does not support the continue transfer
> which implements the I2C_M_NOSTART functionality of i2c
> protocol mangling.
> Removing the I2C_M_NOSTART functionality for Tegra20.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> This is rebased on linux-next-20120816.
>=20
>  drivers/i2c/busses/i2c-tegra.c |   73 +++++++++++++++++++++++++++++++---=
-----
>  1 files changed, 58 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegr=
a.c
> index 7149625..554f713 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -27,6 +27,7 @@
>  #include <linux/slab.h>
>  #include <linux/i2c-tegra.h>
>  #include <linux/of_i2c.h>
> +#include <linux/of_device.h>
>  #include <linux/module.h>
> =20
>  #include <asm/unaligned.h>
> @@ -114,6 +115,15 @@ enum msg_end_type {
>  };
> =20
>  /**
> + * struct tegra_i2c_hw_feature : Different HW support on Tegra
> + * @has_continue_xfer_support: Continue transfer supports.
> + */
> +
> +struct tegra_i2c_hw_feature {
> +	bool has_continue_xfer_support;
> +};
> +
> +/**
>   * struct tegra_i2c_dev	- per device i2c context
>   * @dev: device reference for power management
>   * @adapter: core i2c layer adapter information
> @@ -148,6 +158,7 @@ struct tegra_i2c_dev {
>  	int msg_read;
>  	unsigned long bus_clk_rate;
>  	bool is_suspended;
> +	bool has_continue_xfer_support;

I wonder if it makes sense to carry a pointer here to the
tegra_i2c_hw_feature in use instead of copying all entries by hand,
since they might get more and more.

>  };
> =20
>  static void dvc_writel(struct tegra_i2c_dev *i2c_dev, u32 val, unsigned =
long reg)
> @@ -563,7 +574,17 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, =
struct i2c_msg msgs[],
>  	if (i2c_dev->is_suspended)
>  		return -EBUSY;
> =20
> -	clk_prepare_enable(i2c_dev->div_clk);
> +	/* Support I2C_M_NOSTART only if HW support continue xfer. */
> +	for (i =3D 0; i < num - 1; i++) {
> +		if ((msgs[i + 1].flags & I2C_M_NOSTART) &&
> +			!i2c_dev->has_continue_xfer_support) {
> +			dev_err(i2c_dev->dev,
> +				"mesg %d have illegal flag\n", i + 1);
> +			return -EINVAL;
> +		}
> +	}

Drivers are requested to explicitly check for features of the I2C bus
(like M_NOSTART) before using them, so I'd skip this extra check.

> +
> +	clk_prepare_enable(i2c_dev->clk);

=46rom a glimpse, this change looks unrelated at least. Even wrong, no?

>  	for (i =3D 0; i < num; i++) {
>  		enum msg_end_type end_type =3D MSG_END_STOP;
>  		if (i < (num - 1)) {
> @@ -582,8 +603,13 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, =
struct i2c_msg msgs[],
> =20
>  static u32 tegra_i2c_func(struct i2c_adapter *adap)
>  {
> -	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
> -		I2C_FUNC_PROTOCOL_MANGLING | I2C_FUNC_NOSTART;
> +	struct tegra_i2c_dev *i2c_dev =3D i2c_get_adapdata(adap);
> +	u32 ret =3D I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_10BIT_ADDR |
> +				I2C_FUNC_PROTOCOL_MANGLING;
> +
> +	if (i2c_dev->has_continue_xfer_support)
> +		ret |=3D I2C_FUNC_NOSTART;
> +	return ret;
>  }
> =20
>  static const struct i2c_algorithm tegra_i2c_algo =3D {
> @@ -591,6 +617,25 @@ static const struct i2c_algorithm tegra_i2c_algo =3D=
 {
>  	.functionality	=3D tegra_i2c_func,
>  };
> =20
> +static struct tegra_i2c_hw_feature tegra20_i2c_hw =3D {
> +	.has_continue_xfer_support =3D false,
> +};
> +
> +static struct tegra_i2c_hw_feature tegra30_i2c_hw =3D {
> +	.has_continue_xfer_support =3D true,
> +};
> +
> +#if defined(CONFIG_OF)
> +/* Match table for of_platform binding */
> +static const struct of_device_id tegra_i2c_of_match[] __devinitconst =3D=
 {
> +	{ .compatible =3D "nvidia,tegra30-i2c", .data =3D &tegra30_i2c_hw, },
> +	{ .compatible =3D "nvidia,tegra20-i2c", .data =3D &tegra20_i2c_hw, },
> +	{ .compatible =3D "nvidia,tegra20-i2c-dvc", .data =3D &tegra20_i2c_hw, =
},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
> +#endif
> +
>  static int __devinit tegra_i2c_probe(struct platform_device *pdev)
>  {
>  	struct tegra_i2c_dev *i2c_dev;
> @@ -600,6 +645,7 @@ static int __devinit tegra_i2c_probe(struct platform_=
device *pdev)
>  	struct clk *fast_clk;
>  	const unsigned int *prop;
>  	void __iomem *base;
> +	const struct tegra_i2c_hw_feature *hw =3D &tegra20_i2c_hw;
>  	int irq;
>  	int ret =3D 0;
> =20
> @@ -659,11 +705,18 @@ static int __devinit tegra_i2c_probe(struct platfor=
m_device *pdev)
>  			i2c_dev->bus_clk_rate =3D be32_to_cpup(prop);
>  	}
> =20
> -	if (pdev->dev.of_node)
> +	if (pdev->dev.of_node) {
> +		const struct of_device_id *match;
> +		match =3D of_match_device(of_match_ptr(tegra_i2c_of_match),
> +						&pdev->dev);
> +		hw =3D match->data;
>  		i2c_dev->is_dvc =3D of_device_is_compatible(pdev->dev.of_node,
>  						"nvidia,tegra20-i2c-dvc");
> -	else if (pdev->id =3D=3D 3)
> +	} else if (pdev->id =3D=3D 3) {
>  		i2c_dev->is_dvc =3D 1;
> +	}
> +
> +	i2c_dev->has_continue_xfer_support =3D hw->has_continue_xfer_support;
>  	init_completion(&i2c_dev->msg_complete);
> =20
>  	platform_set_drvdata(pdev, i2c_dev);
> @@ -751,16 +804,6 @@ static SIMPLE_DEV_PM_OPS(tegra_i2c_pm, tegra_i2c_sus=
pend, tegra_i2c_resume);
>  #define TEGRA_I2C_PM	NULL
>  #endif
> =20
> -#if defined(CONFIG_OF)
> -/* Match table for of_platform binding */
> -static const struct of_device_id tegra_i2c_of_match[] __devinitconst =3D=
 {
> -	{ .compatible =3D "nvidia,tegra20-i2c", },
> -	{ .compatible =3D "nvidia,tegra20-i2c-dvc", },
> -	{},
> -};
> -MODULE_DEVICE_TABLE(of, tegra_i2c_of_match);
> -#endif
> -
>  static struct platform_driver tegra_i2c_driver =3D {
>  	.probe   =3D tegra_i2c_probe,
>  	.remove  =3D __devexit_p(tegra_i2c_remove),

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAvjscACgkQD27XaX1/VRuY+wCgmYVUA7mcn2s1StwrgBxdJamz
MZAAnAwswKquG3wXGEjAuooJQoDtphnO
=/zvv
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
