Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2F3SoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 14:44:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2F3SoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 14:44:06 -0400
Date: Sat, 30 Jun 2012 20:43:52 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/4] pwm: Convert pwm-imx to use devm_* APIs
Message-ID: <20120630184352.GF23990@avionic-0098.adnet.avionic-design.de>
References: <1340976628.4752.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <1340976628.4752.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:D/L/fm6IGlqxZOPF1XNHUL6N4/V1ECI3upJNUjmusyK
 6ZmmLeamZ8lgFx+qn23wUJswLy8kSdThzvJEiQ03Gppxz2ffGl
 DlJbsFTEHzP4yhBTEK4pNBfpe4QXDEMtPfRqMUox3GEKYSxsHQ
 y+FgmABCH7MFl+/ZA8PwLy3hLGAfdEezA+Lx8o8EqzJSt1EIkB
 mJE7Tn7RpfazrapV3dclJraDv2SUcu+z7SNtRPpyMDRSZMwuxi
 RfmH5Gd1uumcBeSx5NADF7vKlobXRFLWxHmfE3K+Jw/QYX/Tzj
 DxW1zMfEQXbImx+rZIoyYaX0qIxWj7T+bZ6iM7wqp1+yLZh48k
 eZ9vW2iPQ27gKXUi+o1N1fNSjXaTDV59ADSJv5BeEmphHInqWI
 +/qYUEQAx9TGk8z7AMu2pUQvdHRU3kHLJG2Tp5GV2h/UEluTlF
 rPZA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 09:30:28PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/pwm/pwm-imx.c |   55 +++++++++----------------------------------=
------
>  1 file changed, 10 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
[...]
> @@ -182,46 +180,24 @@ static int __devinit imx_pwm_probe(struct platform_=
device *pdev)
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
> -	imx->mmio_base =3D ioremap(r->start, resource_size(r));
> -	if (imx->mmio_base =3D=3D NULL) {
> -		dev_err(&pdev->dev, "failed to ioremap() registers\n");
> -		ret =3D -ENODEV;
> -		goto err_free_mem;
> -	}
> +	imx->mmio_base =3D devm_request_and_ioremap(&pdev->dev, r);
> +	if (imx->mmio_base =3D=3D NULL)
> +		return -ENODEV;

The documentation says that the standard error code for failure here is
EADDRNOTAVAIL.

> @@ -229,18 +205,7 @@ static int __devexit imx_pwm_remove(struct platform_=
device *pdev)
>  		return -ENODEV;
> =20
>  	ret =3D pwmchip_remove(&imx->chip);
> -	if (ret)
> -		return ret;
> -
> -	iounmap(imx->mmio_base);
> -
> -	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	release_mem_region(r->start, resource_size(r));
> -
> -	clk_put(imx->clk);
> -
> -	kfree(imx);
> -	return 0;
> +	return ret;

I think you can just "return pwmchip_remove(...);", no need to store the
result in ret.

Thierry

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP70joAAoJEN0jrNd/PrOhs5gQAMHNSV9znRUsGZ54ZOlUHU97
zfy8Yoc/P29HwjeEE3Iu68Lj2n/Om6Hdsh8gGzHhJxbot4+sB0VVtnUxsmptPD6+
K4yWQ9wuhbiqDK0mlyg7h3K6mvUpN48Rq5xpfczoaMwNgEI/PbpiVXSH6IzpSGW+
th4bWN56f2ngl3hmYSjq3dt/gIDL2wIv1LfH+S+kWRYvM0U8YvbPBjj7FKuK/cTP
OHSpIE6Ggkd8Fq7BW1RvPgV3r9gsqy2MvVpkB4/tYocBpDnyxHZv7R5xsKJrJ0yB
fXBJ0dtWb4oJK58l/mJOoOyXqfl8W5pnols3iW6TcXylSMK86CXbuFZmR+ozH9fh
O+xwSYyV+bMmnK5mNQ0isHsymW4LwWeGYwssBnegsXlWOgLgthw9CjoWAMusbITc
/VwlNvXBicYNL4F180e0uLnIL0GRewRJPExGv98N6+HfX6UGeKDkYP+5hKMw7Dg1
H+ZXfrpUPHlCMlrAYaGII9niJ+Lbe2JHdPq/cIrBtuXXWjPoNq8yCKNbokbeue2W
uPC+BaFxLz+3IDMah7H46yWJbrozuwXTntbLHjY6Jj/Rbs6cK8hH+VFssU+Vqv71
sCaaF1dtMED8OpFYlJKVNvNkDSCuYbHESNJLv3Qf0vsmD0g4iEBYV5aCZyQyHUtz
rgrAvNsyp+Dshpowc8tA
=kLtT
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
