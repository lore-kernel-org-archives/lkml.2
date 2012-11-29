Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab2K2F1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:27:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53546 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2K2F1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:27:33 -0500
Date: Thu, 29 Nov 2012 16:27:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: linux-next: manual merge of the pwm tree with the driver-core tree
Message-Id: <20121129162730.57ed3756a11ceb2f93f08cdd@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_16_27_30_+1100_WIT+4.wA/WaQa+8z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_16_27_30_+1100_WIT+4.wA/WaQa+8z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
drivers/pwm/pwm-tiehrpwm.c between commit 3e9fe83d278c ("pwm: remove use
of __devinit") from the driver-core tree and commit 53ad9e8d3703 ("pwm:
tiehrpwm: Add device-tree binding") from the pwm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pwm/pwm-tiehrpwm.c
index 9ffd389,542d5f3..0000000
--- a/drivers/pwm/pwm-tiehrpwm.c
+++ b/drivers/pwm/pwm-tiehrpwm.c
@@@ -392,7 -403,13 +403,13 @@@ static const struct pwm_ops ehrpwm_pwm_
  	.owner		=3D THIS_MODULE,
  };
 =20
+ static const struct of_device_id ehrpwm_of_match[] =3D {
+ 	{ .compatible	=3D "ti,am33xx-ehrpwm" },
+ 	{},
+ };
+ MODULE_DEVICE_TABLE(of, ehrpwm_of_match);
+=20
 -static int __devinit ehrpwm_pwm_probe(struct platform_device *pdev)
 +static int ehrpwm_pwm_probe(struct platform_device *pdev)
  {
  	int ret;
  	struct resource *r;
@@@ -439,11 -471,29 +471,29 @@@
  	}
 =20
  	pm_runtime_enable(&pdev->dev);
+ 	pm_runtime_get_sync(&pdev->dev);
+=20
+ 	status =3D pwmss_submodule_state_change(pdev->dev.parent,
+ 			PWMSS_EPWMCLK_EN);
+ 	if (!(status & PWMSS_EPWMCLK_EN_ACK)) {
+ 		dev_err(&pdev->dev, "PWMSS config space clock enable failed\n");
+ 		ret =3D -EINVAL;
+ 		goto pwmss_clk_failure;
+ 	}
+=20
+ 	pm_runtime_put_sync(&pdev->dev);
+=20
  	platform_set_drvdata(pdev, pc);
  	return 0;
+=20
+ pwmss_clk_failure:
+ 	pm_runtime_put_sync(&pdev->dev);
+ 	pm_runtime_disable(&pdev->dev);
+ 	pwmchip_remove(&pc->chip);
+ 	return ret;
  }
 =20
 -static int __devexit ehrpwm_pwm_remove(struct platform_device *pdev)
 +static int ehrpwm_pwm_remove(struct platform_device *pdev)
  {
  	struct ehrpwm_pwm_chip *pc =3D platform_get_drvdata(pdev);
 =20
@@@ -454,10 -512,12 +512,12 @@@
 =20
  static struct platform_driver ehrpwm_pwm_driver =3D {
  	.driver =3D {
- 		.name =3D "ehrpwm",
+ 		.name	=3D "ehrpwm",
+ 		.owner	=3D THIS_MODULE,
+ 		.of_match_table =3D ehrpwm_of_match,
  	},
  	.probe =3D ehrpwm_pwm_probe,
 -	.remove =3D __devexit_p(ehrpwm_pwm_remove),
 +	.remove =3D ehrpwm_pwm_remove,
  };
 =20
  module_platform_driver(ehrpwm_pwm_driver);

--Signature=_Thu__29_Nov_2012_16_27_30_+1100_WIT+4.wA/WaQa+8z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtvJCAAoJEECxmPOUX5FEllEP/jPVK0aRheF+uGiktIhqmkD7
sHqbZGIzfHbubkDJR/YiRaB2RBBndc/I2H5VbrZ8exIcEfahxf0J5jVv2t8Iz0ZF
Fi8CTuswxNweeEa5G0FtTJx/OEyaVSYk8X52YnDirKag7ufl/ChNYubmkFqZKr7N
jeM8AOP6beMzVGp4s5g9TV4yOHONpxINa4IVQhIeaa17jU59HOUS+g74uPEVseGT
jQJ8y3GobmUXsiMffpBar3P071VrxGytYhvzUWnoObB9UxzE70Ep2ve9Ti6POEj8
Muk3qkHcVdOFJF+R14umfHX55H+7udzrNsjnjyUYMAix08QpXD4IzEeH14SzXIiS
VOie706sUHha3M9Tp3epqiBxKWUfbrEvA2BTzekHN/6RWKxxIXyZXznH8++aaq9b
HJkzs5C4lBl0Yq4Zu0zv2K7hUTTWBh7bh1VRMD2SfPTkDOqwNC+egRjdkrBxe41w
sWs2jvlZ4HNW+KU4Fr77v+8lFAA9PvTWW5KPfQZZeToh3NSjN2DGmkdXFMjA4ys3
3i1z2xCH348v6AwHg+aX/cEmmNhigyO7Aktmd+0hHKCfTOqUSFHF2zW4FcFx5vXZ
NEVqCJ/Ab7HCBCvVTPHGs/QK39EcexNglfUf1WmRLlpppavTEDfyEKl2HwnRavxx
Lmmv8/5l+ZoC0OZoxzuN
=CFeb
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_16_27_30_+1100_WIT+4.wA/WaQa+8z--
