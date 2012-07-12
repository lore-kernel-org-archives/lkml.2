Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab2GLNMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:12:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47942 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931Ab2GLNMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:12:46 -0400
Date: Thu, 12 Jul 2012 15:12:31 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120712131231.GH2194@pengutronix.de>
References: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uu2n37VG4rOBDVuR"
Content-Disposition: inline
In-Reply-To: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Uu2n37VG4rOBDVuR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I fixed it up (I think - see below) and can carry the fix as necessary.
> Please check this and talk to each other ...

I also noticed the bindings today [1]. They came in via a seperate
patch (suboptimal) which has no ack by a devicetree maintainer which I'd
really like to see here, because the bindings look suspicious to me.
They look like they mostly export register settings which is usually
questionable since we might want to abstract bindings so they can be
useful for a number of drivers.

Arnd, since you committed the patches, can you please comment? I'd
prefer to drop this DT conversion for now, otherwise we might have to
support this possibly rushed bindings forever? LinusW, what do you
think?

Thanks,

   Wolfram

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/next/linux-next.git;a=3Dcom=
mitdiff;h=3D87a174f3d7cea1b9c7596911c39616768f441629

>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/i2c/busses/i2c-nomadik.c
> index e6b93f3,5471303..0000000
> --- a/drivers/i2c/busses/i2c-nomadik.c
> +++ b/drivers/i2c/busses/i2c-nomadik.c
> @@@ -24,8 -23,10 +24,9 @@@
>   #include <linux/io.h>
>   #include <linux/regulator/consumer.h>
>   #include <linux/pm_runtime.h>
>  +#include <linux/platform_data/i2c-nomadik.h>
> + #include <linux/of.h>
>  =20
>  -#include <plat/i2c.h>
>  -
>   #define DRIVER_NAME "nmk-i2c"
>  =20
>   /* I2C Controller register offsets */
> @@@ -911,23 -896,93 +908,94 @@@ static const struct i2c_algorithm nmk_i
>   	.functionality	=3D nmk_i2c_functionality
>   };
>  =20
> + static struct nmk_i2c_controller u8500_i2c =3D {
> + 	/*
> + 	 * Slave data setup time; 250ns, 100ns, and 10ns, which
> + 	 * is 14, 6 and 2 respectively for a 48Mhz i2c clock.
> + 	 */
> + 	.slsu           =3D 0xe,
> + 	.tft            =3D 1,      /* Tx FIFO threshold */
> + 	.rft            =3D 8,      /* Rx FIFO threshold */
> + 	.clk_freq       =3D 400000, /* std. mode operation */
> + 	.timeout        =3D 200,    /* Slave response timeout(ms) */
> + 	.sm             =3D I2C_FREQ_MODE_FAST,
> + };
> +=20
> + static int __devinit
> + nmk_i2c_of_probe(struct device_node *np, struct nmk_i2c_controller *pda=
ta)
> + {
> + 	of_property_read_u32(np, "clock-frequency", (u32*)&pdata->clk_freq);
> + 	if (!pdata->clk_freq) {
> + 		pr_warn("%s: Clock frequency not found\n", np->full_name);
> + 		return -EINVAL;
> + 	}
> +=20
> + 	of_property_read_u32(np, "stericsson,slsu", (u32*)&pdata->slsu);
> + 	if (!pdata->slsu) {
> + 		pr_warn("%s: Data line delay not found\n", np->full_name);
> + 		return -EINVAL;
> + 	}
> +=20
> + 	of_property_read_u32(np, "stericsson,tft", (u32*)&pdata->tft);
> + 	if (!pdata->tft) {
> + 		pr_warn("%s: Tx FIFO threshold not found\n", np->full_name);
> + 		return -EINVAL;
> + 	}
> +=20
> + 	of_property_read_u32(np, "stericsson,rft", (u32*)&pdata->rft);
> + 	if (!pdata->rft) {
> + 		pr_warn("%s: Rx FIFO threshold not found\n", np->full_name);
> + 		return -EINVAL;
> + 	}
> +=20
> + 	of_property_read_u32(np, "stericsson,timeout", (u32*)&pdata->timeout);
> + 	if (!pdata->timeout) {
> + 		pr_warn("%s: Timeout not found\n", np->full_name);
> + 		return -EINVAL;
> + 	}
> +=20
> + 	/*
> + 	 * This driver only supports fast and standard frequency
> + 	 * modes. If anything else is requested fall-back to standard.
> + 	 */
> + 	if (of_get_property(np, "stericsson,i2c_freq_mode_fast", NULL))
> + 		pdata->sm =3D I2C_FREQ_MODE_FAST;
> + 	else
> + 		pdata->sm =3D I2C_FREQ_MODE_STANDARD;
> +=20
> + 	return 0;
> + }
> +=20
>  -static int __devinit nmk_i2c_probe(struct platform_device *pdev)
>  +static atomic_t adapter_id =3D ATOMIC_INIT(0);
>  +
>  +static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id=
 *id)
>   {
>   	int ret =3D 0;
> - 	struct nmk_i2c_controller *pdata =3D
> - 			adev->dev.platform_data;
>  -	struct resource *res;
>  -	struct nmk_i2c_controller *pdata =3D pdev->dev.platform_data;
>  -	struct device_node *np =3D pdev->dev.of_node;
> ++	struct nmk_i2c_controller *pdata =3D adev->dev.platform_data;
> ++	struct device_node *np =3D adev->dev.of_node;
>   	struct nmk_i2c_dev	*dev;
>   	struct i2c_adapter *adap;
>  =20
> - 	if (!pdata) {
> - 		dev_warn(&adev->dev, "no platform data\n");
> - 		return -ENODEV;
> + 	if (np) {
> + 		if (!pdata) {
>  -			pdata =3D devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> ++			pdata =3D devm_kzalloc(&adev->dev, sizeof(*pdata), GFP_KERNEL);
> + 			if (!pdata) {
> + 				ret =3D -ENOMEM;
> + 				goto err_no_mem;
> + 			}
> + 		}
> + 		ret =3D nmk_i2c_of_probe(np, pdata);
> + 		if (ret)
> + 			kfree(pdata);
>   	}
> +=20
> + 	if (!pdata)
> + 		/* No i2c configuration found, using the default. */
> + 		pdata =3D &u8500_i2c;
> +=20
>   	dev =3D kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
>   	if (!dev) {
>  -		dev_err(&pdev->dev, "cannot allocate memory\n");
>  +		dev_err(&adev->dev, "cannot allocate memory\n");
>   		ret =3D -ENOMEM;
>   		goto err_no_mem;
>   	}
> @@@ -969,12 -1037,12 +1037,11 @@@
>   	adap->owner	=3D THIS_MODULE;
>   	adap->class	=3D I2C_CLASS_HWMON | I2C_CLASS_SPD;
>   	adap->algo	=3D &nmk_i2c_algo;
> - 	adap->timeout	=3D pdata->timeout ? msecs_to_jiffies(pdata->timeout) :
> - 		msecs_to_jiffies(20000);
> + 	adap->timeout	=3D msecs_to_jiffies(pdata->timeout);
>  +	adap->nr =3D atomic_read(&adapter_id);
>   	snprintf(adap->name, sizeof(adap->name),
>  -		 "Nomadik I2C%d at %lx", pdev->id, (unsigned long)res->start);
>  -
>  -	/* fetch the controller id */
>  -	adap->nr	=3D pdev->id;
>  +		 "Nomadik I2C%d at %pR", adap->nr, &adev->res);
>  +	atomic_inc(&adapter_id);
>  =20
>   	/* fetch the controller configuration from machine */
>   	dev->cfg.clk_freq =3D pdata->clk_freq;
> @@@ -1040,29 -1110,20 +1107,35 @@@ static int nmk_i2c_remove(struct amba_d
>   	return 0;
>   }
>  =20
>  +static struct amba_id nmk_i2c_ids[] =3D {
>  +	{
>  +		.id	=3D 0x00180024,
>  +		.mask	=3D 0x00ffffff,
>  +	},
>  +	{
>  +		.id	=3D 0x00380024,
>  +		.mask	=3D 0x00ffffff,
>  +	},
>  +	{},
>  +};
>  +
>  +MODULE_DEVICE_TABLE(amba, nmk_i2c_ids);
>  +
> + static const struct of_device_id nmk_gpio_match[] =3D {
> + 	{ .compatible =3D "st,nomadik-i2c", },
> + 	{},
> + };
> +=20
>  -static struct platform_driver nmk_i2c_driver =3D {
>  -	.driver =3D {
>  +static struct amba_driver nmk_i2c_driver =3D {
>  +	.drv =3D {
>   		.owner =3D THIS_MODULE,
>   		.name =3D DRIVER_NAME,
>   		.pm =3D &nmk_i2c_pm,
> + 		.of_match_table =3D nmk_gpio_match,
>   	},
>  +	.id_table =3D nmk_i2c_ids,
>   	.probe =3D nmk_i2c_probe,
>  -	.remove =3D __devexit_p(nmk_i2c_remove),
>  +	.remove =3D nmk_i2c_remove,
>   };
>  =20
>   static int __init nmk_i2c_init(void)



--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Uu2n37VG4rOBDVuR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/+zT8ACgkQD27XaX1/VRs3vQCeLXwApR2wCJ97gypkPnujdZQH
EBwAn3bYckGhFhEWsgJQkGFcapLn5IDw
=PYXp
-----END PGP SIGNATURE-----

--Uu2n37VG4rOBDVuR--
