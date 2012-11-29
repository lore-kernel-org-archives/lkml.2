Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751179Ab2K2FZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:25:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39733 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab2K2FZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:25:25 -0500
Date: Thu, 29 Nov 2012 16:25:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: linux-next: manual merge of the pwm tree with the driver-core tree
Message-Id: <20121129162514.98c3ba48441171c486742ef1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_16_25_14_+1100_dEaBrS0BwnM+TrUH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_16_25_14_+1100_dEaBrS0BwnM+TrUH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
drivers/pwm/pwm-tiecap.c between commit 3e9fe83d278c ("pwm: remove use of
__devinit") from the driver-core tree and commit 333b08ee8c6e ("pwm:
tiecap: Add device-tree binding") from the pwm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pwm/pwm-tiecap.c
index 87c091b,b4f9d47..0000000
--- a/drivers/pwm/pwm-tiecap.c
+++ b/drivers/pwm/pwm-tiecap.c
@@@ -184,7 -188,13 +188,13 @@@ static const struct pwm_ops ecap_pwm_op
  	.owner		=3D THIS_MODULE,
  };
 =20
+ static const struct of_device_id ecap_of_match[] =3D {
+ 	{ .compatible	=3D "ti,am33xx-ecap" },
+ 	{},
+ };
+ MODULE_DEVICE_TABLE(of, ecap_of_match);
+=20
 -static int __devinit ecap_pwm_probe(struct platform_device *pdev)
 +static int ecap_pwm_probe(struct platform_device *pdev)
  {
  	int ret;
  	struct resource *r;
@@@ -231,11 -249,29 +249,29 @@@
  	}
 =20
  	pm_runtime_enable(&pdev->dev);
+ 	pm_runtime_get_sync(&pdev->dev);
+=20
+ 	status =3D pwmss_submodule_state_change(pdev->dev.parent,
+ 			PWMSS_ECAPCLK_EN);
+ 	if (!(status & PWMSS_ECAPCLK_EN_ACK)) {
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
 -static int __devexit ecap_pwm_remove(struct platform_device *pdev)
 +static int ecap_pwm_remove(struct platform_device *pdev)
  {
  	struct ecap_pwm_chip *pc =3D platform_get_drvdata(pdev);
 =20
@@@ -246,10 -290,12 +290,12 @@@
 =20
  static struct platform_driver ecap_pwm_driver =3D {
  	.driver =3D {
- 		.name =3D "ecap",
+ 		.name	=3D "ecap",
+ 		.owner	=3D THIS_MODULE,
+ 		.of_match_table =3D ecap_of_match,
  	},
  	.probe =3D ecap_pwm_probe,
 -	.remove =3D __devexit_p(ecap_pwm_remove),
 +	.remove =3D ecap_pwm_remove,
  };
 =20
  module_platform_driver(ecap_pwm_driver);

--Signature=_Thu__29_Nov_2012_16_25_14_+1100_dEaBrS0BwnM+TrUH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtvG6AAoJEECxmPOUX5FEtDEP/31JLD0UhpvgIHtiVRTMdxTA
vI3iDhR7UA2a4o5LOydlR3i+A1z15eFZkIZ4E/CNhVJLzavRSmKj+SwpU6NAQ5pQ
Uu943tSHzzehFfUpPmP73DSoMjdT54acIfq80s6I/JC0CJYMbqWk606WdcgnYS+j
RBVEvCRaSXcphCoY6MUdaTguHo/uWKIqieOTS3oKDZGeGDgFBHcpYtjwHyzjCzjZ
kOlkjeYqGoYCnL5/ycpuA2fTNcU0iL8ruDT9PDKbBtxvzbCBBYv75oC1kB/d1RcN
OhZk1Hix7aUyDh7SD+ZJw3mmdI9MuEXzYXkFmfzBuqi/fOw71SavaXnELUZaaJSS
/yUq6jQ0QQTVd5bVB1GQCK+rivoCExNeZb3wP4qOmJ9ncXtyIMn7GQ96mfcVjTGH
BIoeCIQUS3BoVI0va7XPfD8OiMfy8duadiNPrw+MUbOBfg7ycv1M2vpRM9Hj+Yrr
I/kIBz4mC42fZs4SPogsX4rq9KMhUqZVSWiQZLMEKjEowK7jO0KdTbROmYqSazM6
JnQsnG6hdeErdvOx3PoyYr90k3PCqckxbHHqBLc/HAPZb5ieZ6QeET3CrmusaPzd
s5umeWbAzK9uTcBWA4LVmqD+DnpXGGMpJeZ9eI64gu0E91/Qx9WRiTpgaB0+dG8q
KU5jhAp8/jp2mQObNY6d
=9ZHd
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_16_25_14_+1100_dEaBrS0BwnM+TrUH--
