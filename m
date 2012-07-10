Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab2GJGlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:41:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60637 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2GJGlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:41:46 -0400
Date: Tue, 10 Jul 2012 16:41:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Alessandro Rubini <rubini@gnudd.com>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the i2c-embedded
 tree
Message-Id: <20120710164130.f38e4d1673f925ddb13914c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Jul_2012_16_41_30_+1000_iLkGXiVK.X/yEs6G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jul_2012_16_41_30_+1000_iLkGXiVK.X/yEs6G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/i2c/busses/i2c-nomadik.c between commit af97bace2cca
("i2c-nomadik: move header to <linux/platform_data/i2c-nomadik.h>") from
the i2c-embedded tree and commits 32e42c687e0a ("ARM: ux500: Remove
unused i2c platform_data initialisation code") and 8214fd238a66 ("i2c:
Add Device Tree support to the Nomadik I2C driver") from the arm-soc tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
Please check this and talk to each other ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/i2c/busses/i2c-nomadik.c
index e6b93f3,5471303..0000000
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@@ -24,8 -23,10 +24,9 @@@
  #include <linux/io.h>
  #include <linux/regulator/consumer.h>
  #include <linux/pm_runtime.h>
 +#include <linux/platform_data/i2c-nomadik.h>
+ #include <linux/of.h>
 =20
 -#include <plat/i2c.h>
 -
  #define DRIVER_NAME "nmk-i2c"
 =20
  /* I2C Controller register offsets */
@@@ -911,23 -896,93 +908,94 @@@ static const struct i2c_algorithm nmk_i
  	.functionality	=3D nmk_i2c_functionality
  };
 =20
+ static struct nmk_i2c_controller u8500_i2c =3D {
+ 	/*
+ 	 * Slave data setup time; 250ns, 100ns, and 10ns, which
+ 	 * is 14, 6 and 2 respectively for a 48Mhz i2c clock.
+ 	 */
+ 	.slsu           =3D 0xe,
+ 	.tft            =3D 1,      /* Tx FIFO threshold */
+ 	.rft            =3D 8,      /* Rx FIFO threshold */
+ 	.clk_freq       =3D 400000, /* std. mode operation */
+ 	.timeout        =3D 200,    /* Slave response timeout(ms) */
+ 	.sm             =3D I2C_FREQ_MODE_FAST,
+ };
+=20
+ static int __devinit
+ nmk_i2c_of_probe(struct device_node *np, struct nmk_i2c_controller *pdata)
+ {
+ 	of_property_read_u32(np, "clock-frequency", (u32*)&pdata->clk_freq);
+ 	if (!pdata->clk_freq) {
+ 		pr_warn("%s: Clock frequency not found\n", np->full_name);
+ 		return -EINVAL;
+ 	}
+=20
+ 	of_property_read_u32(np, "stericsson,slsu", (u32*)&pdata->slsu);
+ 	if (!pdata->slsu) {
+ 		pr_warn("%s: Data line delay not found\n", np->full_name);
+ 		return -EINVAL;
+ 	}
+=20
+ 	of_property_read_u32(np, "stericsson,tft", (u32*)&pdata->tft);
+ 	if (!pdata->tft) {
+ 		pr_warn("%s: Tx FIFO threshold not found\n", np->full_name);
+ 		return -EINVAL;
+ 	}
+=20
+ 	of_property_read_u32(np, "stericsson,rft", (u32*)&pdata->rft);
+ 	if (!pdata->rft) {
+ 		pr_warn("%s: Rx FIFO threshold not found\n", np->full_name);
+ 		return -EINVAL;
+ 	}
+=20
+ 	of_property_read_u32(np, "stericsson,timeout", (u32*)&pdata->timeout);
+ 	if (!pdata->timeout) {
+ 		pr_warn("%s: Timeout not found\n", np->full_name);
+ 		return -EINVAL;
+ 	}
+=20
+ 	/*
+ 	 * This driver only supports fast and standard frequency
+ 	 * modes. If anything else is requested fall-back to standard.
+ 	 */
+ 	if (of_get_property(np, "stericsson,i2c_freq_mode_fast", NULL))
+ 		pdata->sm =3D I2C_FREQ_MODE_FAST;
+ 	else
+ 		pdata->sm =3D I2C_FREQ_MODE_STANDARD;
+=20
+ 	return 0;
+ }
+=20
 -static int __devinit nmk_i2c_probe(struct platform_device *pdev)
 +static atomic_t adapter_id =3D ATOMIC_INIT(0);
 +
 +static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *=
id)
  {
  	int ret =3D 0;
- 	struct nmk_i2c_controller *pdata =3D
- 			adev->dev.platform_data;
 -	struct resource *res;
 -	struct nmk_i2c_controller *pdata =3D pdev->dev.platform_data;
 -	struct device_node *np =3D pdev->dev.of_node;
++	struct nmk_i2c_controller *pdata =3D adev->dev.platform_data;
++	struct device_node *np =3D adev->dev.of_node;
  	struct nmk_i2c_dev	*dev;
  	struct i2c_adapter *adap;
 =20
- 	if (!pdata) {
- 		dev_warn(&adev->dev, "no platform data\n");
- 		return -ENODEV;
+ 	if (np) {
+ 		if (!pdata) {
 -			pdata =3D devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
++			pdata =3D devm_kzalloc(&adev->dev, sizeof(*pdata), GFP_KERNEL);
+ 			if (!pdata) {
+ 				ret =3D -ENOMEM;
+ 				goto err_no_mem;
+ 			}
+ 		}
+ 		ret =3D nmk_i2c_of_probe(np, pdata);
+ 		if (ret)
+ 			kfree(pdata);
  	}
+=20
+ 	if (!pdata)
+ 		/* No i2c configuration found, using the default. */
+ 		pdata =3D &u8500_i2c;
+=20
  	dev =3D kzalloc(sizeof(struct nmk_i2c_dev), GFP_KERNEL);
  	if (!dev) {
 -		dev_err(&pdev->dev, "cannot allocate memory\n");
 +		dev_err(&adev->dev, "cannot allocate memory\n");
  		ret =3D -ENOMEM;
  		goto err_no_mem;
  	}
@@@ -969,12 -1037,12 +1037,11 @@@
  	adap->owner	=3D THIS_MODULE;
  	adap->class	=3D I2C_CLASS_HWMON | I2C_CLASS_SPD;
  	adap->algo	=3D &nmk_i2c_algo;
- 	adap->timeout	=3D pdata->timeout ? msecs_to_jiffies(pdata->timeout) :
- 		msecs_to_jiffies(20000);
+ 	adap->timeout	=3D msecs_to_jiffies(pdata->timeout);
 +	adap->nr =3D atomic_read(&adapter_id);
  	snprintf(adap->name, sizeof(adap->name),
 -		 "Nomadik I2C%d at %lx", pdev->id, (unsigned long)res->start);
 -
 -	/* fetch the controller id */
 -	adap->nr	=3D pdev->id;
 +		 "Nomadik I2C%d at %pR", adap->nr, &adev->res);
 +	atomic_inc(&adapter_id);
 =20
  	/* fetch the controller configuration from machine */
  	dev->cfg.clk_freq =3D pdata->clk_freq;
@@@ -1040,29 -1110,20 +1107,35 @@@ static int nmk_i2c_remove(struct amba_d
  	return 0;
  }
 =20
 +static struct amba_id nmk_i2c_ids[] =3D {
 +	{
 +		.id	=3D 0x00180024,
 +		.mask	=3D 0x00ffffff,
 +	},
 +	{
 +		.id	=3D 0x00380024,
 +		.mask	=3D 0x00ffffff,
 +	},
 +	{},
 +};
 +
 +MODULE_DEVICE_TABLE(amba, nmk_i2c_ids);
 +
+ static const struct of_device_id nmk_gpio_match[] =3D {
+ 	{ .compatible =3D "st,nomadik-i2c", },
+ 	{},
+ };
+=20
 -static struct platform_driver nmk_i2c_driver =3D {
 -	.driver =3D {
 +static struct amba_driver nmk_i2c_driver =3D {
 +	.drv =3D {
  		.owner =3D THIS_MODULE,
  		.name =3D DRIVER_NAME,
  		.pm =3D &nmk_i2c_pm,
+ 		.of_match_table =3D nmk_gpio_match,
  	},
 +	.id_table =3D nmk_i2c_ids,
  	.probe =3D nmk_i2c_probe,
 -	.remove =3D __devexit_p(nmk_i2c_remove),
 +	.remove =3D nmk_i2c_remove,
  };
 =20
  static int __init nmk_i2c_init(void)

--Signature=_Tue__10_Jul_2012_16_41_30_+1000_iLkGXiVK.X/yEs6G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+86aAAoJEECxmPOUX5FEMRcP/jjz/YTjDvWGvGeVnGUOReTt
I9ftW7KeNRUMJv9+0WAa3Xdsu6KX/qO1WupEwPJ6fe7FxD9J2bYKcPOJlPOPxAod
Njf5MKqdXhCAxZtETR/Cf6LgD0DQZL5N9yh4uZtnvEeBHt2GmcQi+6xPOqB9syuh
dWY7QTMLYYQtmgIqvp0n7mNc7mrsRi0I5iR0XcZChD1Y7GJuGQ/1Q5Op7bUWALmT
FdzZV04puur6hT0QPHNbcK8wqhFYmZCHQ5zbbNwGpHAUfZJB57dPhkfcc9Yhuxrg
abiQWr/WY52xD9WFDLLfNSJgP/zYu5m4qBMfOl20Xd3XbRu3oT4xZzekjZa9WrIN
WMDIRNXMpXU9V009pZtRSpxWO9451xEYqK/h/3agyIzVurzeHTwilp1mldrntLRr
G+lXBUsBCNW45ME7+3J32gAZgKyusJUCOJBGpDbZQ6xKfmRHupjc7p2NaBg9LM7k
F1ayngkHZOwrmRks5qbjSBXbpyBFo7mXwzT+zPz+K44nMKA0EV8/45+704pnd6Gd
boJFeVp3/8H7bZnfoH3wEqRf+bBfsT6BWyiDsamh9t0GvPVfzR/TXplwGoLp/UFH
soXjV6CtV1BxCl83F3uSjgM10fkk5oWjg4vK04acwGZtkwWugH4eJ9aqA7ARN90J
mkRn83i/LR/dfrSBQ+up
=/DiN
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jul_2012_16_41_30_+1000_iLkGXiVK.X/yEs6G--
