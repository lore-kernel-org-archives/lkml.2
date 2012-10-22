Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2JVIkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:40:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2JVIkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:40:13 -0400
Date: Mon, 22 Oct 2012 10:40:00 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] pwm: vt8500: Update vt8500 PWM driver support
Message-ID: <20121022084000.GB29790@avionic-0098.mockup.avionic-design.de>
References: <20121022080414.GB4931@avionic-0098.mockup.avionic-design.de>
 <1350893615-14723-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <1350893615-14723-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:kONdZk8jjrh6+x1op/LEO4mPxX5QdTMwPiDI6twRJ4Q
 PawU/ClL4HsLT/r0zQOHgEjDHOzf1FnxmnDvJ2+RC3tQnYlSPl
 RZcN5TUVfUZMuJBtVJaYbd2EEehTiu/TRLyOqaBBMSBSP4iKYb
 cCYZyHv/ZhuIs2xanALg3RQni/kCLU87ZslkrKdpsxrHoN21xO
 24RSwRGKgoSLpEsfBmlFUUmCbnN8vgajEA36HLW+McWkNPfmkz
 P3RMz8q/BTqMdRGZydt91yiQHBJoEn1Smjnswpc4oXLiMKrFkQ
 o3w41eoUzjsfEba+733rYeF9s+i6sFoFRyQdLTMKvtFRDNn2Er
 CfhkPTYdLPbmFv00nYStq5gVmJgVKN3vgToJHtzT0hu0Vs4ejm
 fjQsmupJbAcQQPG1ybqVMZmFvA+DyxJjzE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 09:13:35PM +1300, Tony Prisk wrote:
> This patch updates pwm-vt8500.c to support devicetree probing and
> make use of the common clock subsystem.
>=20
> A binding document describing the PWM controller found on
> arch-vt8500 is also included.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2 changes:
> Merged binding doc patch with main code patch
> Fixes as requested by Thierry Reding.
>=20
>  .../devicetree/bindings/pwm/vt8500-pwm.txt         |   17 ++++
>  drivers/pwm/pwm-vt8500.c                           |   87 ++++++++++++++=
+-----
>  2 files changed, 82 insertions(+), 22 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pwm/vt8500-pwm.txt

Looking better... just a few minor comments.

> diff --git a/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt b/Docum=
entation/devicetree/bindings/pwm/vt8500-pwm.txt
> new file mode 100644
> index 0000000..bcc6367
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/vt8500-pwm.txt
> @@ -0,0 +1,17 @@
> +VIA/Wondermedia VT8500/WM8xxx series SoC PWM controller
> +
> +Required properties:
> +- compatible: should be "via,vt8500-pwm"
> +- reg: physical base address and length of the controller's registers
> +- #pwm-cells: should be 2.  The first cell specifies the per-chip index
> +  of the PWM to use and the second cell is the period in nanoseconds.
> +- clocks: phandle to the PWM source clock
> +
> +Example:
> +
> +pwm1: pwm@d8220000 {
> +	#pwm-cells =3D <2>;
> +	compatible =3D "via,vt8500-pwm";
> +	reg =3D <0xd8220000 0x1000>;
> +	clocks =3D <&clkpwm>;
> +};
> diff --git a/drivers/pwm/pwm-vt8500.c b/drivers/pwm/pwm-vt8500.c
> index ad14389..36fef69 100644
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
> @@ -21,14 +22,25 @@
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
> +	int enable_cnt;

You don't need to keep a reference count yourself. The clock framework
does that for you.

> @@ -87,6 +99,11 @@ static int vt8500_pwm_enable(struct pwm_chip *chip, st=
ruct pwm_device *pwm)
>  {
>  	struct vt8500_chip *vt8500 =3D to_vt8500_chip(chip);
> =20
> +	if (vt8500->enable_cnt =3D=3D 0)
> +		clk_enable(vt8500->clk);
> +
> +	vt8500->enable_cnt++;
> +

Again, reference counting isn't needed. But you should be checking for
the return value of clk_enable().

>  	pwm_busy_wait(vt8500->base + 0x40 + pwm->hwpwm, (1 << 0));
>  	writel(5, vt8500->base + (pwm->hwpwm << 4));
>  	return 0;
> @@ -98,6 +115,11 @@ static void vt8500_pwm_disable(struct pwm_chip *chip,=
 struct pwm_device *pwm)
> =20
>  	pwm_busy_wait(vt8500->base + 0x40 + pwm->hwpwm, (1 << 0));
>  	writel(0, vt8500->base + (pwm->hwpwm << 4));
> +
> +	vt8500->enable_cnt--;
> +
> +	if (vt8500->enable_cnt =3D=3D 0)
> +		clk_disable(vt8500->clk);

Just clk_disable() will be enough.

> @@ -107,12 +129,25 @@ static struct pwm_ops vt8500_pwm_ops =3D {
>  	.owner =3D THIS_MODULE,
>  };
> =20
> -static int __devinit pwm_probe(struct platform_device *pdev)
> +static const struct of_device_id vt8500_pwm_dt_ids[] =3D {
> +	{ .compatible =3D "via,vt8500-pwm", },
> +	{ /* Sentinel */ }
> +};
> +
> +MODULE_DEVICE_TABLE(of, vt8500_pwm_dt_ids);

I've more often seen this without a blank line between. But if you
prefer this for readability or whatever reasons feel free to keep it as
is.

> +
> +static int vt8500_pwm_probe(struct platform_device *pdev)
>  {
>  	struct vt8500_chip *chip;
>  	struct resource *r;
> +	struct device_node *np =3D pdev->dev.of_node;
>  	int ret;
> =20
> +	if (!np) {
> +		dev_err(&pdev->dev, "invalid devicetree node\n");
> +		return -EINVAL;
> +	}
> +
>  	chip =3D devm_kzalloc(&pdev->dev, sizeof(*chip), GFP_KERNEL);
>  	if (chip =3D=3D NULL) {
>  		dev_err(&pdev->dev, "failed to allocate memory\n");
> @@ -123,6 +158,13 @@ static int __devinit pwm_probe(struct platform_devic=
e *pdev)
>  	chip->chip.ops =3D &vt8500_pwm_ops;
>  	chip->chip.base =3D -1;
>  	chip->chip.npwm =3D VT8500_NR_PWMS;
> +	chip->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	chip->enable_cnt =3D 0;
> +
> +	if (!chip->clk) {

The proper way to check this is with IS_ERR_OR_NULL(clk) and return
PTR_ERR(clk) in case of failure.

> +		dev_err(&pdev->dev, "clock source not specified\n");
> +		return -EINVAL;
> +	}
> =20
>  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (r =3D=3D NULL) {
> @@ -131,18 +173,24 @@ static int __devinit pwm_probe(struct platform_devi=
ce *pdev)
>  	}
> =20
>  	chip->base =3D devm_request_and_ioremap(&pdev->dev, r);
> -	if (chip->base =3D=3D NULL)
> +	if (!chip->base) {
> +		dev_err(&pdev->dev, "memory resource not available\n");

devm_request_and_ioremap() already outputs an error message in case of
failure, so no need to repeat it here.

>  		return -EADDRNOTAVAIL;
> +	}
> +
> +	clk_prepare(chip->clk);

clk_prepare() can fail, so you should check for errors.

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
> +static int vt8500_pwm_remove(struct platform_device *pdev)
>  {
>  	struct vt8500_chip *chip;
> =20
> @@ -150,28 +198,23 @@ static int __devexit pwm_remove(struct platform_dev=
ice *pdev)
>  	if (chip =3D=3D NULL)
>  		return -ENODEV;
> =20
> +	clk_unprepare(chip->clk);
> +
>  	return pwmchip_remove(&chip->chip);
>  }
> =20
> -static struct platform_driver pwm_driver =3D {
> +static struct platform_driver vt8500_pwm_driver =3D {
> +	.probe		=3D vt8500_pwm_probe,
> +	.remove		=3D vt8500_pwm_remove,
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

Similar to my comment regarding the MODULE_DEVICE_TABLE() macro, I've
seen this usually without a blank line. But again that's mostly bike-
shedding and I'm find taking the patch with the blank line left in.

Thierry

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhQZgAAoJEN0jrNd/PrOhU6kQAJkmiDXQ9mOIvfndJQATtKAO
c98a/qTsk0np5PeafNLnrVUO+LqDi6pwYmhxZHN95NbeX8tej+46r55eSaQYOcz+
3Mwjgc9voU43haAoNOSAsOgPIHMYdjs+nR/cCdhPF3hXQKixU8LywW4ZUF1n44Wf
2A/pvBfSw5ZMaCIuOzHOXneRGlND1QIu7MijPw9M9BxzY3pMfJ7ONwNyKD1FfNQg
hD2Z0kEVF35PGChz/AXUAcaRmPxL2LuJu9GseRNmQ3S9JNyFaqtQYiAG8yB2tbwk
dXxVeNy09atpE1XV2+e51od2L4VGPcRWC7XzW182fEEHk8VjhcXDnVqC77R/9Ptz
5O1dqYlXrX85dAM5e+xttx9FLBLxjhTizgkdX1e2VV7UnQXKPC6SckcTDLgCIkSn
jDLse8EdlHWfms8e1yAupAHFzOwAT6tW3eroBgV/a/A/z8x3BOwrIES7HJJg/krr
XaJSf6M5TjXKhcvqTEe/IYCDA/P28an84QAqD4bbDW+UCHIB+etHqmuLv4bDFm7J
DShkfVbr76WXaOB1DKqPccEHyyPlQ0Dq8mpwbYNXQep6PmwOwEVfLpWZEelPRQHS
ts4mK3GZcFZyWmsYDwVh7dlk6Wu7N2QF9/XiL3XTKOiQtZ8fGB0tVI2xqkPmmgkc
bqaVGIJb74tDUl2rVmEg
=uw/u
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
