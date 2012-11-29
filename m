Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2K2Gqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:46:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:64241 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2K2Gqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:46:44 -0500
Date: Thu, 29 Nov 2012 07:46:34 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: Re: linux-next: manual merge of the pwm tree with the driver-core
 tree
Message-ID: <20121129064634.GC28582@avionic-0098.adnet.avionic-design.de>
References: <20121129162730.57ed3756a11ceb2f93f08cdd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hYooF8G/hrfVAmum"
Content-Disposition: inline
In-Reply-To: <20121129162730.57ed3756a11ceb2f93f08cdd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:oECZht5pkFVfK9cT0kmJ5vBlRj8q6ppfIsuC8sWBZPF
 mT2AOM/HJQZ5e+RizHsF5438QtEUYmDWzPIeHysEDwh1wuiXF3
 I+gaKdPiZ1ec7/P2UuSvVzQoAp5WZEQ/x7CUEvboOojr876YUC
 14uM8iQz5aNvwGU8xkyFfR+/UWPtQEhdVngupA6JaBAi+fV1rm
 6qEImROoaIGhcEoSLFULNkIIGZP6dTtyDtS7YICQQHtwb/ledK
 Cu53VwlJDXvsfbNWV0R7CoVKp0Q66jknBGe8zp7kHJYYFeh+wP
 GlfXKgmdzOnChUPbtuBvit4Sh5SwB3VqoUb5A4sDt2zHPEYhSK
 Z+acDpq+sJxYfrSATmds+SH8rLgNtzq6XHxTMZAHDqU3FVE1Gm
 F/nJCE4jgj+v4Wb25Hbid8rPGu9kFPOs16MKPQ+RRM9SOefg69
 Dqf2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hYooF8G/hrfVAmum
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 04:27:30PM +1100, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> Today's linux-next merge of the pwm tree got a conflict in
> drivers/pwm/pwm-tiehrpwm.c between commit 3e9fe83d278c ("pwm: remove use
> of __devinit") from the driver-core tree and commit 53ad9e8d3703 ("pwm:
> tiehrpwm: Add device-tree binding") from the pwm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Also looking good, thanks.

Thierry

> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/pwm/pwm-tiehrpwm.c
> index 9ffd389,542d5f3..0000000
> --- a/drivers/pwm/pwm-tiehrpwm.c
> +++ b/drivers/pwm/pwm-tiehrpwm.c
> @@@ -392,7 -403,13 +403,13 @@@ static const struct pwm_ops ehrpwm_pwm_
>   	.owner		=3D THIS_MODULE,
>   };
>  =20
> + static const struct of_device_id ehrpwm_of_match[] =3D {
> + 	{ .compatible	=3D "ti,am33xx-ehrpwm" },
> + 	{},
> + };
> + MODULE_DEVICE_TABLE(of, ehrpwm_of_match);
> +=20
>  -static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
>  +static int ehrpwm_pwm_probe(struct platform_device *pdev)
>   {
>   	int ret;
>   	struct resource *r;
> @@@ -439,11 -471,29 +471,29 @@@
>   	}
>  =20
>   	pm_runtime_enable(&pdev->dev);
> + 	pm_runtime_get_sync(&pdev->dev);
> +=20
> + 	status =3D pwmss_submodule_state_change(pdev->dev.parent,
> + 			PWMSS_EPWMCLK_EN);
> + 	if (!(status & PWMSS_EPWMCLK_EN_ACK)) {
> + 		dev_err(&pdev->dev, "PWMSS config space clock enable failed\n");
> + 		ret =3D -EINVAL;
> + 		goto pwmss_clk_failure;
> + 	}
> +=20
> + 	pm_runtime_put_sync(&pdev->dev);
> +=20
>   	platform_set_drvdata(pdev, pc);
>   	return 0;
> +=20
> + pwmss_clk_failure:
> + 	pm_runtime_put_sync(&pdev->dev);
> + 	pm_runtime_disable(&pdev->dev);
> + 	pwmchip_remove(&pc->chip);
> + 	return ret;
>   }
>  =20
>  -static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
>  +static int ehrpwm_pwm_remove(struct platform_device *pdev)
>   {
>   	struct ehrpwm_pwm_chip *pc =3D platform_get_drvdata(pdev);
>  =20
> @@@ -454,10 -512,12 +512,12 @@@
>  =20
>   static struct platform_driver ehrpwm_pwm_driver =3D {
>   	.driver =3D {
> - 		.name =3D "ehrpwm",
> + 		.name	=3D "ehrpwm",
> + 		.owner	=3D THIS_MODULE,
> + 		.of_match_table =3D ehrpwm_of_match,
>   	},
>   	.probe =3D ehrpwm_pwm_probe,
>  -	.remove =3D __devexit_p(ehrpwm_pwm_remove),
>  +	.remove =3D ehrpwm_pwm_remove,
>   };
>  =20
>   module_platform_driver(ehrpwm_pwm_driver);



--hYooF8G/hrfVAmum
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtwTKAAoJEN0jrNd/PrOhThMP/00RMZYy1Qy33bPE8L6ftDtu
zUOD4D4FoHLeCT0O6Zpf8yj9QvwT04133vYoOj1z3vtPdjjGkxr3Fo0Eb+hiKQAF
jpohlXFjHjQZIq4+Rkv2YWK7T/JMzAc2K4NBUd5oqvbFGg7jbSFyJ8HSgkOQyXDH
DrDPB+eYWXNYJhlUegObBhGTRd+2CGdo8vOL0ya8udR9QRT5F7/Kh/48KL03KGSa
fXLST1EwkFOlaHxcFFnaXuacEbKsg/uqS5UljQrjgxC5mk3gqvw4d89f9qoi+gsx
TyBQO1YCNelkq1Q/taLQxGVjKkb2HnGIzhLy2CahhoW3o484fHVuQIrTF/8aX0H6
pvsE/4o10QAvZq5CfPvrySW7rEKtBtLiVYyX0Jfh//b02Z1K6XOLb0P5vKiLiLkj
nR2eIJMKGwR4xRLvboiLiUraEauO0RY52crAKWvy5cc3HlgjG3sSPhoY16v4V1To
h2jQ1AIRkKMy8bo9t8OROukzG1WNynvwymUxhgzDiga08kcWsXyu2sVrLbeIhyEx
Ybs+JIjmj2slMDAixtxQB7z4SqUPs+RYkx+5G+JE5gCRN91cDfOhJPCegRPefgQO
LV6mtgJmQ3GKv7J7XwsxYuTbrTYUfY5Dsb+XBDOgbYa/pO8OqWG2YDJUBeWB2Mja
wGajThIMo5IA4oexsao3
=Cfr+
-----END PGP SIGNATURE-----

--hYooF8G/hrfVAmum--
