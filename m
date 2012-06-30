Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2F3Ti3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 15:38:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2F3Ti2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 15:38:28 -0400
Date: Sat, 30 Jun 2012 21:38:18 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH 2/4] pwm: Convert pwm-pxa to use devm_* APIs
Message-ID: <20120630193818.GG23990@avionic-0098.adnet.avionic-design.de>
References: <1340976628.4752.0.camel@phoenix>
 <1340976682.4752.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hcut4fGOf7Kh6EdG"
Content-Disposition: inline
In-Reply-To: <1340976682.4752.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:4rZOQEq76gapbHMXbYuj+dtJAFj7lOq7vCHFs9AEqJR
 twtY2B5MaAvhm0FzrcT/qux4ez5b7GJABWNFc6DuA9blJblFMC
 t0usWg4Cp6kWG5/LRe1xuq21Df+0B9wga5rWwfdrgqAldcGbge
 yc6DxPfrWOx7PUx290p5yysF5fZNU37kIhSIJxnjLDTFX60Q9g
 ugF0MYqoQj8RpRXCMS696vZwrUEEPn0NTl0D8ffvn+H2Gxx/jB
 PdlEUGCQDaPDM6LQVFOPKSR69eDeNWBwlgoKx50nQZpIVSeXMm
 ypaVt+2XmPg7CxauCt8SwrcZfFkYcITRVOXJEuce+FWmv8ohxI
 05ewFnAhtz09YJLRx3kvGMwDUOi0fHp/8WOpvSdgxiyriBEzch
 YDxgEw4G7HB6mE1gsoq12uiZnPGADbPeOI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hcut4fGOf7Kh6EdG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 09:31:22PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-pxa.c |   49 ++++++++++---------------------------------=
------
>  1 file changed, 10 insertions(+), 39 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
> index d5c6ce5..1cf0597 100644
> --- a/drivers/pwm/pwm-pxa.c
> +++ b/drivers/pwm/pwm-pxa.c
> @@ -1,5 +1,5 @@
>  /*
> - * linux/arch/arm/mach-pxa/pwm.c
> + * drivers/pwm/pwm-pxa.c
>   *
>   * simple driver for PWM (Pulse Width Modulator) controller
>   *
> @@ -145,17 +145,16 @@ static int __devinit pwm_probe(struct platform_devi=
ce *pdev)
>  	struct resource *r;
>  	int ret =3D 0;
> =20
> -	pwm =3D kzalloc(sizeof(*pwm), GFP_KERNEL);
> +	pwm =3D devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
>  	if (pwm =3D=3D NULL) {
>  		dev_err(&pdev->dev, "failed to allocate memory\n");
>  		return -ENOMEM;
>  	}
> =20
> -	pwm->clk =3D clk_get(&pdev->dev, NULL);
> -	if (IS_ERR(pwm->clk)) {
> -		ret =3D PTR_ERR(pwm->clk);
> -		goto err_free;
> -	}
> +	pwm->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(pwm->clk))
> +		return PTR_ERR(pwm->clk);
> +
>  	pwm->clk_enabled =3D 0;
> =20
>  	pwm->chip.dev =3D &pdev->dev;
> @@ -166,23 +165,12 @@ static int __devinit pwm_probe(struct platform_devi=
ce *pdev)
>  	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (r =3D=3D NULL) {
>  		dev_err(&pdev->dev, "no memory resource defined\n");
> -		ret =3D -ENODEV;
> -		goto err_free_clk;
> -	}
> -
> -	r =3D request_mem_region(r->start, resource_size(r), pdev->name);
> -	if (r =3D=3D NULL) {
> -		dev_err(&pdev->dev, "failed to request memory resource\n");
> -		ret =3D -EBUSY;
> -		goto err_free_clk;
> +		return -ENODEV;
>  	}
> =20
> -	pwm->mmio_base =3D ioremap(r->start, resource_size(r));
> -	if (pwm->mmio_base =3D=3D NULL) {
> -		dev_err(&pdev->dev, "failed to ioremap() registers\n");
> -		ret =3D -ENODEV;
> -		goto err_free_mem;
> -	}
> +	pwm->mmio_base =3D devm_request_and_ioremap(&pdev->dev, r);
> +	if (pwm->mmio_base =3D=3D NULL)
> +		return -ENODEV;

Same comment as for the first patch.

>  	ret =3D pwmchip_add(&pwm->chip);
>  	if (ret < 0) {
> @@ -192,34 +180,17 @@ static int __devinit pwm_probe(struct platform_devi=
ce *pdev)
> =20
>  	platform_set_drvdata(pdev, pwm);
>  	return 0;
> -
> -err_free_mem:
> -	release_mem_region(r->start, resource_size(r));
> -err_free_clk:
> -	clk_put(pwm->clk);
> -err_free:
> -	kfree(pwm);
> -	return ret;
>  }
> =20
>  static int __devexit pwm_remove(struct platform_device *pdev)
>  {
>  	struct pxa_pwm_chip *chip;
> -	struct resource *r;
> =20
>  	chip =3D platform_get_drvdata(pdev);
>  	if (chip =3D=3D NULL)
>  		return -ENODEV;
> =20
>  	pwmchip_remove(&chip->chip);
> -
> -	iounmap(chip->mmio_base);
> -
> -	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(r->start, resource_size(r));
> -
> -	clk_put(chip->clk);
> -	kfree(chip);
>  	return 0;

This should probably also be "return pwmchip_remove(...);". But that's
an unrelated change so I'll do that in a separate commit.

Thierry

--hcut4fGOf7Kh6EdG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP71WqAAoJEN0jrNd/PrOheYgQALs55PqctaXS8r0/SU6k32rq
mCA9fQIxeyoOaimt66+Bn3E9lDMTsSotR5c08NcoxoaBVtf+Erje96+G694TgU/c
smEW5or/o0XcFomA6bcHO4gKQnuAHj8BZKxCxSFe62rMgibd3zGOOnEb1NKXvEmq
HHjU0XdNZz5lADFcSC2iVgNY+7LAf17GFRuroJDsIfxGFpBNh20Etrw4yLmZyBwa
97zGtPYLB+emR6N8d6/PG09GK1OfhLVgzOCe2xl40M7+1OXrL84Ye+bM+pMO4IB7
K7ei0dZ2I3AXKwcYgo6ALiDZWAr9svTqsd1KKUyFg6lEDgw9fYj7QEjgAJTDUWJb
1w/lu3OoMYfbSitXQmKeHgMQe4iBdsYI9WPK6LCDteTFvbCEt1nVICL/0xhJtPm+
8XwNivu0iHZQXtKx3zGs+Owt4N2np2t7o+Y/JZTVj5LO5fz+1417Gz1WrR0MmoIv
pt2ZVl5DrFZbmJi1dhSWugYjU48u33i6/W0MlAvRQdE7SrkI5phFiWi3XmHFajiP
1tH7LubTWMR1OzbLEbSrI1smaBE/znwj/MfrX+asp7ib1OlUv79NhiHhmo6oIv2L
Z0oDdv8PUL5W3iKtmOSxQzvfFvrp7UTLAMHUKGlaihraJhRf8yaAMbF9KS5T0nAi
uYh3oKuWPu3Xrl355s2h
=2tYu
-----END PGP SIGNATURE-----

--hcut4fGOf7Kh6EdG--
