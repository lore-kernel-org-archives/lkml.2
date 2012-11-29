Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2K2GqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:46:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54966 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab2K2GqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:46:05 -0500
Date: Thu, 29 Nov 2012 07:45:54 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: Re: linux-next: manual merge of the pwm tree with the driver-core
 tree
Message-ID: <20121129064554.GB28582@avionic-0098.adnet.avionic-design.de>
References: <20121129162514.98c3ba48441171c486742ef1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20121129162514.98c3ba48441171c486742ef1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7KBB18WI4ecCbLtbr76xhQ5+qR2+lYgUFU/aLweDQdb
 GPWkaHNNaOft/k5gEUPIgG/oeJ0bcmCGBMKO4jTW/CiLO4cfgJ
 hhayaY6DrD52sncNWiVVGQI0ruVCopyGZekbTTjKmrIuvMrAY9
 ANwwN+8wvRh6lWaRI8PVm4syM+al8DPRVorP/mizhcgH59pHxF
 AzfU1jZF/Vl34+bl5hR0JtaGJDTHQw+k8QKTP+FJ4Ypx32tpxi
 xRVbn1TtQlL6JCUJnwhrjjonrTnwPLb07M9PF036MPrTsJwvlW
 RT9WjmA0QPrnjN+r60MRFTE/3GfUzcI0hA/q/Ng8RgBymJuNZf
 FySnRic9kRR/ryHg1SAjwqWk1/LdYyk25Qdp4M66PdbigWR+PB
 DVN3CYR6av/IwxJR9rjAazJF+XnMgkdPRg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2012 at 04:25:14PM +1100, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> Today's linux-next merge of the pwm tree got a conflict in
> drivers/pwm/pwm-tiecap.c between commit 3e9fe83d278c ("pwm: remove use of
> __devinit") from the driver-core tree and commit 333b08ee8c6e ("pwm:
> tiecap: Add device-tree binding") from the pwm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good to me, thanks Stephen.

Thierry

>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc drivers/pwm/pwm-tiecap.c
> index 87c091b,b4f9d47..0000000
> --- a/drivers/pwm/pwm-tiecap.c
> +++ b/drivers/pwm/pwm-tiecap.c
> @@@ -184,7 -188,13 +188,13 @@@ static const struct pwm_ops ecap_pwm_op
>   	.owner		=3D THIS_MODULE,
>   };
>  =20
> + static const struct of_device_id ecap_of_match[] =3D {
> + 	{ .compatible	=3D "ti,am33xx-ecap" },
> + 	{},
> + };
> + MODULE_DEVICE_TABLE(of, ecap_of_match);
> +=20
>  -static int __devinit ecap_pwm_probe(struct platform_device *pdev)
>  +static int ecap_pwm_probe(struct platform_device *pdev)
>   {
>   	int ret;
>   	struct resource *r;
> @@@ -231,11 -249,29 +249,29 @@@
>   	}
>  =20
>   	pm_runtime_enable(&pdev->dev);
> + 	pm_runtime_get_sync(&pdev->dev);
> +=20
> + 	status =3D pwmss_submodule_state_change(pdev->dev.parent,
> + 			PWMSS_ECAPCLK_EN);
> + 	if (!(status & PWMSS_ECAPCLK_EN_ACK)) {
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
>  -static int __devexit ecap_pwm_remove(struct platform_device *pdev)
>  +static int ecap_pwm_remove(struct platform_device *pdev)
>   {
>   	struct ecap_pwm_chip *pc =3D platform_get_drvdata(pdev);
>  =20
> @@@ -246,10 -290,12 +290,12 @@@
>  =20
>   static struct platform_driver ecap_pwm_driver =3D {
>   	.driver =3D {
> - 		.name =3D "ecap",
> + 		.name	=3D "ecap",
> + 		.owner	=3D THIS_MODULE,
> + 		.of_match_table =3D ecap_of_match,
>   	},
>   	.probe =3D ecap_pwm_probe,
>  -	.remove =3D __devexit_p(ecap_pwm_remove),
>  +	.remove =3D ecap_pwm_remove,
>   };
>  =20
>   module_platform_driver(ecap_pwm_driver);



--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtwSiAAoJEN0jrNd/PrOhic4P/iVds2f9k8noQpehc+h3OhZ6
LV9cOrS5UPzQxeuslOiTvWdZF6kNgBhFPATo1LKgD1N/W8y1g7d8s/sRGhCQwQ4Q
9EaggDBk73tuG/njOPVDpvCSGTsCDrEoctjCngcfa+OMZSH67rPmXkzNczb+Adeh
ftBQymaXhXaXYWtiyhd5EKma5IkDdw3wlmFCH+K7bzrHT3cRzCA+RRc/CL/+0DdS
bRfAmasq+9GQC1BmNm5KGAI8Wq/47b3x+pEHJVMu7E4QXm6HDCElFlW+Qc1uSIe5
M5M23/BXi/gpplj4R/7Kxi8+rFqVmM1Sq1CgiivoxtLN+ZaEwE3uvHIiyJvnjw1A
zSFn43herEKr5Ylc2Lcqwdb/qTR3Wn6+ff8GNqSDyNiopWdhNawFXyqxZf60IfvF
9Ucixbiq0y7Yo2JPGe0wtTGf0TikdyZ6ainRPLUe5BKevUKM2KrRwi78nxzG3Wek
lH5IuXMF9G884BuLmCvQwHOhKuMqGEe3RciPZ/+6CyUvQbCTuA2JRoXHmej7wmLP
zeEg6CRqSeGNv1d6er2D0PvDALGE2P9PtNNVlaBhunfQRMxWCyq2yb5FDUEx4ne8
mtyShVmOKEiqHiGZJupeuNpY75vJKez6JwSgHGrVEpt/vlI3wG02LgK9mbdca0ZU
wrfiv5rS7xX091GfarcV
=AaTA
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
