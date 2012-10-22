Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2JVGej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 02:34:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2JVGei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 02:34:38 -0400
Date: Mon, 22 Oct 2012 08:34:23 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/3] PWM: vt8500: Update vt8500 PWM driver support
Message-ID: <20121022063423.GA17181@avionic-0098.mockup.avionic-design.de>
References: <1350643135-13197-1-git-send-email-linux@prisktech.co.nz>
 <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <1350643135-13197-2-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:evjGSZarDDVTvECId//TIJ00PNHD4ZnGs9takKBbiAR
 ozqhFx1mvmxXEwhFxDaFcPiRuwuSYjIUQxAR8WSYCZC0wrFEW0
 ctXrMJb3tPF4oEzFa8NtLmsc3dXkFr9tpGJl4R2aHEgvai0rRP
 /UPGh3QJ2u4NzCEwC+5VOp+yr7PASPEdg1qeLnplbvb3JZq1tb
 BdXRpVEW4Evi8psNdRnFbK9HtwQRLBYozxZM0fMDxfFER78Fnc
 N0HV5rd/LiZ7tOPwfALhXwCFoQGH8zHEOuNcJXhG3LeM/iVv4k
 2PIFOBnw+KhPQ2JxNfa60WSrh5HxOGs8ksZTNv8HduUa9pSibb
 BD19T4npy0wy+EXt29IUqI/78LtBKvuBS+700piEPVHRcIQDYR
 QfEa4oKON3DZc5czvbdYAlNg4atLzlGBvdrVtouA3mb2bakMsz
 k7391
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 19, 2012 at 11:38:54PM +1300, Tony Prisk wrote:
> This patch updates pwm-vt8500.c to support devicetree probing and
> make use of the common clock subsystem.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>  drivers/pwm/pwm-vt8500.c |   79 ++++++++++++++++++++++++++++++----------=
------
>  1 file changed, 51 insertions(+), 28 deletions(-)

On the whole, this looks like a great cleanup. A few minor issues
inline.

I should start with the subject: please keep lowercase pwm: as the
prefix for consistency. Uppercase PWM is used to refer to PWM devices in
prose.

Also I'd rather see the clock subsystem changes and device tree changes
in separate patches, but since both are rather intertwined I won't force
the issue.

> diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
> index ad14389..c2a71ee 100644
> --- a/drivers/pwm/pwm-vt8500.c
> +++ b/drivers/pwm/pwm-vt8500.c
> @@ -1,7 +1,8 @@
>  /*
>   * drivers/pwm/pwm-vt8500.c
>   *
> - *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
> + * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
> + * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
>   *
>   * This software is licensed under the terms of the GNU General Public
>   * License version 2, as published by the Free Software Foundation, and
> @@ -21,14 +22,24 @@
>  #include <linux/io.h>
>  #include <linux/pwm.h>
>  #include <linux/delay.h>
> +#include <linux/clk.h>
> =20
>  #include <asm/div64.h>
> =20
> -#define VT8500_NR_PWMS 4
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_address.h>
> +
> +/*
> + * SoC architecture allocates register space for 4 PWMs but only
> + * 2 are currently implemented.
> + */
> +#define VT8500_NR_PWMS	2
> =20
>  struct vt8500_chip {
>  	struct pwm_chip chip;
>  	void __iomem *base;
> +	struct clk *clk;
>  };
> =20
>  #define to_vt8500_chip(chip)	container_of(chip, struct vt8500_chip, chip)
> @@ -52,7 +63,7 @@ static int vt8500_pwm_config(struct pwm_chip *chip, str=
uct pwm_device *pwm,
>  	unsigned long long c;
>  	unsigned long period_cycles, prescale, pv, dc;
> =20
> -	c =3D 25000000/2; /* wild guess --- need to implement clocks */
> +	c =3D clk_get_rate(vt8500->clk);
>  	c =3D c * period_ns;
>  	do_div(c, 1000000000);
>  	period_cycles =3D c;
> @@ -107,12 +118,22 @@ static struct pwm_ops vt8500_pwm_ops =3D {
>  	.owner =3D THIS_MODULE,
>  };
> =20
> -static int __devinit pwm_probe(struct platform_device *pdev)
> +static const struct of_device_id vt8500_pwm_dt_ids[] =3D {
> +	{ .compatible =3D "via,vt8500-pwm", },
> +	{ /* Sentinel */ }
> +};
> +
> +static int __devinit vt8500_pwm_probe(struct platform_device *pdev)

Since you're changing this line anyway, maybe you should drop __devinit
(and __devexit for the .remove() callback). HOTPLUG is always enabled
nowadays and will go away eventually, in which case these will need to
be removed anyway.

>  {
>  	struct vt8500_chip *chip;
> -	struct resource *r;
> +	struct device_node *np =3D pdev->dev.of_node;
>  	int ret;
> =20
> +	if (!np) {
> +		dev_err(&pdev->dev, "invalid devicetree node\n");
> +		return -EINVAL;
> +	}
> +

This effectively makes DT support mandatory. Shouldn't you be adding a
"depends on OF" into the Kconfig section in that case?

>  	chip =3D devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
>  	if (chip =3D=3D NULL) {
>  		dev_err(&pdev->dev, "failed to allocate memory\n");
> @@ -123,26 +144,32 @@ static int __devinit pwm_probe(struct platform_devi=
ce *pdev)
>  	chip->chip.ops =3D &vt8500_pwm_ops;
>  	chip->chip.base =3D -1;
>  	chip->chip.npwm =3D VT8500_NR_PWMS;
> +	chip->clk =3D of_clk_get(np, 0);

I thought this was supposed to work transparently across OF and !OF
configurations by using just clk_get() or devm_clk_get()? I guess that
if the driver depends on OF, then this would be moot, but we should
probably stick to the standard usage anyway.

Furthermore, of_clk_get() doesn't seem to be managed, so you'd need to
add explicit clk_put() in the error cleanup paths. One more argument in
favour of using devm_clk_get() instead.

> -	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (r =3D=3D NULL) {
> -		dev_err(&pdev->dev, "no memory resource defined\n");
> -		return -ENODEV;
> +	if (!chip->clk) {
> +		dev_err(&pdev->dev, "clock source not specified\n");
> +		return -EINVAL;
>  	}
> =20
> -	chip->base =3D devm_request_and_ioremap(&pdev->dev, r);
> -	if (chip->base =3D=3D NULL)
> +	chip->base =3D of_iomap(np, 0);

No need to change this. It should work with the standard calls as well.

> +	if (!chip->base) {
> +		dev_err(&pdev->dev, "memory resource not available\n");
>  		return -EADDRNOTAVAIL;
> +	}
> +
> +	clk_prepare_enable(chip->clk);

Why does the clock need to be enabled here? Shouldn't it be postponed to
the last possible moment to save power?

> =20
>  	ret =3D pwmchip_add(&chip->chip);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add pwmchip\n");
>  		return ret;
> +	}
> =20
>  	platform_set_drvdata(pdev, chip);
>  	return ret;
>  }
> =20
> -static int __devexit pwm_remove(struct platform_device *pdev)
> +static int __devexit vt8500_pwm_remove(struct platform_device *pdev)
>  {
>  	struct vt8500_chip *chip;
> =20
> @@ -150,28 +177,24 @@ static int __devexit pwm_remove(struct platform_dev=
ice *pdev)
>  	if (chip =3D=3D NULL)
>  		return -ENODEV;
> =20
> +	clk_disable_unprepare(chip->clk);
> +

Again, shouldn't it be more efficient power-wise to disable this as soon
as the last PWM device is disabled?

>  	return pwmchip_remove(&chip->chip);
>  }
> =20
> -static struct platform_driver pwm_driver =3D {
> +static struct platform_driver vt8500_pwm_driver =3D {
> +	.probe		=3D vt8500_pwm_probe,
> +	.remove		=3D __devexit_p(vt8500_pwm_remove),

__devexit_p can also be removed.

>  	.driver		=3D {
>  		.name	=3D "vt8500-pwm",
>  		.owner	=3D THIS_MODULE,
> +		.of_match_table =3D vt8500_pwm_dt_ids,
>  	},
> -	.probe		=3D pwm_probe,
> -	.remove		=3D __devexit_p(pwm_remove),
>  };
> =20
> -static int __init pwm_init(void)
> -{
> -	return platform_driver_register(&pwm_driver);
> -}
> -arch_initcall(pwm_init);
> -
> -static void __exit pwm_exit(void)
> -{
> -	platform_driver_unregister(&pwm_driver);
> -}
> -module_exit(pwm_exit);
> +module_platform_driver(vt8500_pwm_driver);
> =20
> -MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("VT8500 PWM Driver");
> +MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
> +MODULE_LICENSE("GPL v2");

IANAL, but I think you need the approval of all authors of this code
before changing the license. But I see that the file header actually
says that this code is GPL v2, so maybe this change could be considered
a bugfix. =3D)

> +MODULE_DEVICE_TABLE(of, vt8500_pwm_dt_ids);

I think it is customary to put this right after the device table
definition.

> --=20
> 1.7.9.5
>=20
>=20
>=20

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhOjvAAoJEN0jrNd/PrOho84P/RlupJFT5roynAjGxV2LAxUq
C5yPG58p6S/MmFWHm5nm2dR08k7xQl8RKAnYYSFruRi89YOrsJx/zNAbHMAfdm0y
IrUDNDGx2vaqguaWefJdkKIF8lpij4VVSVLc2EQtbqhQBvRY92ULI6aguOoP9+Be
6OsbjmhZIkSQjBCMZ9hvDhacxKv/RtXLsW14mGRGvc7TPIKnOCUGy7ILKE0CBfe+
AOu2mP7YwuytmHNV9MGtD7nD6a+W/Ezj78PA0fqKOsaAffwQvO22sWGMt2euINGY
07d6sRMPyvQ8kE5VM27q2yMouaqhxGvBHjuJ221XqZXZVqUPBmcMQnNNeOMvHHOf
5Cnkdx1fd57dQ0i+yyrKXpHVaSOqSNpfg/tqwDpcSq7f6i8b71WvcBJVxYROgo7k
STI0PhjuIrURhKpJZEwqA6pajs6CqxserkUtuV49Ic4DrsfD6dod/3Evx/k3YDJz
nrtxD6wBMC8SnatH5S2oadp3vppEwvfSKQFGLCb+9Wp5sGZJdmhlUuxl3Fq2NgWN
Se54A7HxxRPzzwo4XSfLfGvfSG0yuP6vxJMH0B0CcdaFYoMBB92jH1WcB5igiB6g
zjsnrOFClQVDyDQ5vwc1wYjx1OM80qFnuGgMF6FV+RVddbd/1xiQK5nBsXK/7/JJ
HNYLGNSroEYGVz70dSj1
=zpvu
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
