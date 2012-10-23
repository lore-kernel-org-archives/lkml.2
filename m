Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2JWWOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:14:37 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57262 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2JWWOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:14:35 -0400
Date: Wed, 24 Oct 2012 00:14:19 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] pwm: vt8500: Update vt8500 PWM driver support
Message-ID: <20121023221419.GA8501@avionic-0098.mockup.avionic-design.de>
References: <20121022084000.GB29790@avionic-0098.mockup.avionic-design.de>
 <1350929425-17516-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <1350929425-17516-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:B8h4h/jK2Ayx1MbBrdw5vgL+4sSunxr4Xa8p6BD0RrH
 11IfhjNNwzZjwbiDHTrjxoaW7K52swGNoGgFEdsaaWUe1ctNw1
 fZzoOtOqaqogE50Q0OAkZtJyczxcatJvckH2xPSakPIm3V1ptM
 1rl2zlzVPRJVzPBCM59a+e7VZxWXdv/RnSpog7NlTf+c55RGgy
 6lh//WkrJG9dRMSwbINIC0PnzY2MFik2kes7PGPGOvBN3wXZhY
 GALuW51mPdaD9ojZusdFN7DB4WWoyAT0lI30cNCgqAOQpzYfBB
 vh4ZcdN10zkFkKzWSC1IgluyWUXrq6QvscY2S9QWfucuG+WZkk
 XhxgyfQn+hwA/gWEm+LviBioIuOYM6q2EbiaI0EDQ7DRZZ+liN
 5qMcfSaYnA11pVHfi1I0hiiJ00dpydyUtU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 23, 2012 at 07:10:24AM +1300, Tony Prisk wrote:
[...]
> @@ -87,6 +98,11 @@ static int vt8500_pwm_enable(struct pwm_chip *chip, st=
ruct pwm_device *pwm)
>  {
>  	struct vt8500_chip *vt8500 =3D to_vt8500_chip(chip);
> =20
> +	if (!clk_enable(vt8500->clk)) {
> +		dev_err(chip->dev, "failed to enable clock\n");
> +		return -EBUSY;
> +	};
> +

I don't think that works. The clock API returns 0 on success and a
negative error code on failure. So this should rather be something like:

	err =3D clk_enable(vt8500->clk);
	if (err < 0) {
		dev_err(chip->dev, "failed to enable clock: %d\n", err);
		return err;
	}

> @@ -123,6 +153,12 @@ static int __devinit pwm_probe(struct platform_devic=
e *pdev)
>  	chip->chip.ops =3D &vt8500_pwm_ops;
>  	chip->chip.base =3D -1;
>  	chip->chip.npwm =3D VT8500_NR_PWMS;
> +	chip->clk =3D devm_clk_get(&pdev->dev, NULL);
> +

The blank line should go above the call to devm_clk_get().

> +	if (IS_ERR_OR_NULL(chip->clk)) {
> +		dev_err(&pdev->dev, "clock source not specified\n");
> +		return PTR_ERR(chip->clk);
> +	}
[...]
> +	if (!clk_prepare(chip->clk)) {
> +		dev_err(&pdev->dev, "failed to prepare clock\n");
> +		return -EBUSY;
> +	}
> +

Same comment here. I wonder how this code can work, since if the clock
is properly prepared, then it will return 0, and the above will return
-EBUSY.

>  	ret =3D pwmchip_add(&chip->chip);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add pwmchip\n");

Error messages can be considered prose, so this should be: "failed to
add PWM chip".

Thierry

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhxa7AAoJEN0jrNd/PrOhJAMQALLHYDTzGYbBMFzZBcqkAniQ
JIHL0OArj+w3jYOdGfFcFpsEV4S4WOfuYJLtqFlEvCfB4SekSQmVLBzosP7OJZGJ
fVuPvbiisrIENOAcA/+GJmS2Qqa7Vq9s/6xWN4IpyRtDgVBCpEbfF6KfEvTV7SnF
DR4VABtEcJGoYcI1ENy7KJQNRVeqF3Akzz2446Wa/2Yo0ybSz6ONFaxAU6T0pGFB
Ja1YuECbOhgLqDXamUmSlUrqOBpmYoryfCZCTQS5GlwRIe5RtHz9bENFQf0TrAut
f1B983K7Ndfs2GIKEIvghi5Ax9e4vUTEjmXB5/q02019vv6485tYnI2xyFaeUHz7
IMvUZ75MZcFfOig0eFXGcJkX2rIjQC2GQqz+qaFIbJKnmiJiER9shna9YjbVGroo
Qrra8xW/Ndhb+pVhJka8nAeQ43hMK4M9dfMIl7+2f+FMEsQwW0uj6UrujKG1+ptQ
nza3edzALK18qg5GZRvsRtCXRl8tBRn2OtpNTKnKZ5bCEtEDQJjDUgmb7aro1D41
kmzxUipGKB0FHXQ8sDUkVI7X4ngKcWjSVObIxBeHv3io4DhYALAPcOb0zttGNqUQ
yzDNctp6whRSAPc38YRp6QchXFHsyD3k2HUhcjc/1vKFp/6391H0ig+bcyJ4OIjr
5Vcvubr+cq8G9zmWQh+y
=KaBc
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
