Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556Ab2K2EJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:09:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37551 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab2K2EJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:09:37 -0500
Date: Thu, 29 Nov 2012 15:09:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: manual merge of the driver-core tree with the battery
 tree
Message-Id: <20121129150933.6c47da49d1bae2cbf94f94da@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_09_33_+1100_mpR3cWLvqHn1zU=h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_09_33_+1100_mpR3cWLvqHn1zU=h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/power/ab8500_btemp.c between commit bd9e8ab2d58d ("ab8500: Add
devicetree support for btemp") from the battery tree and commit
c8afa6406e60 ("power: remove use of __devinit") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/ab8500_btemp.c
index 8135542,989b099..0000000
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@@ -959,39 -960,21 +959,39 @@@ static int ab8500_btemp_remove(struct p
  	return 0;
  }
 =20
 +static char *supply_interface[] =3D {
 +	"ab8500_chargalg",
 +	"ab8500_fg",
 +};
 +
- static int __devinit ab8500_btemp_probe(struct platform_device *pdev)
+ static int ab8500_btemp_probe(struct platform_device *pdev)
  {
 +	struct device_node *np =3D pdev->dev.of_node;
 +	struct ab8500_btemp *di;
  	int irq, i, ret =3D 0;
  	u8 val;
 -	struct abx500_bm_plat_data *plat_data =3D pdev->dev.platform_data;
 -	struct ab8500_btemp *di;
 -
 -	if (!plat_data) {
 -		dev_err(&pdev->dev, "No platform data\n");
 -		return -EINVAL;
 -	}
 =20
 -	di =3D kzalloc(sizeof(*di), GFP_KERNEL);
 -	if (!di)
 +	di =3D devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
 +	if (!di) {
 +		dev_err(&pdev->dev, "%s no mem for ab8500_btemp\n", __func__);
  		return -ENOMEM;
 +	}
 +	di->bat =3D pdev->mfd_cell->platform_data;
 +	if (!di->bat) {
 +		if (np) {
 +			ret =3D bmdevs_of_probe(&pdev->dev, np, &di->bat);
 +			if (ret) {
 +				dev_err(&pdev->dev,
 +					"failed to get battery information\n");
 +				return ret;
 +			}
 +		} else {
 +			dev_err(&pdev->dev, "missing dt node for ab8500_btemp\n");
 +			return -EINVAL;
 +		}
 +	} else {
 +		dev_info(&pdev->dev, "falling back to legacy platform data\n");
 +	}
 =20
  	/* get parent data */
  	di->dev =3D &pdev->dev;
@@@ -1096,14 -1096,12 +1096,14 @@@ free_btemp_wq
  	return ret;
  }
 =20
 +static const struct of_device_id ab8500_btemp_match[] =3D {
 +	{ .compatible =3D "stericsson,ab8500-btemp", },
 +	{ },
 +};
 +
  static struct platform_driver ab8500_btemp_driver =3D {
  	.probe =3D ab8500_btemp_probe,
- 	.remove =3D __devexit_p(ab8500_btemp_remove),
+ 	.remove =3D ab8500_btemp_remove,
  	.suspend =3D ab8500_btemp_suspend,
  	.resume =3D ab8500_btemp_resume,
  	.driver =3D {

--Signature=_Thu__29_Nov_2012_15_09_33_+1100_mpR3cWLvqHn1zU=h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtt/9AAoJEECxmPOUX5FE8rwP/1scBl5lvN9Qznj5k/8GrMFV
Jb/JdA/HTqOypOSU8gBvnMx8g2a8c7sPZSOrGH7lmT5vOg7gkBOSXLBszcJuYRkA
6ErdnMPplAo53h8zkAQE3zElPIBTGTcykzW9WZ8WS+YblxBsOwlxQL8y30Eh9TBo
V9TU/Fqrh4soNviVStJ18f7jwgO6c66YzPWGTO2onXASAsV5WwWLkJJF2SiST7oO
kWa9wpONL45GppYbTeP0VnQx1FrPEUt5ePHL1kdKYMISxoAPXbhZPlpHF3huaYZs
M7Yk0xY+698B1L/kR5vKrCC0J4ELWTSJdZo6TX4VetBn89tyaiUU9eLkZGmIqyDZ
EGU/yEgKUsrHpJ/wyJ10CZNjIUo4TZ2oXiG2q4feecco01mRxqOQzQvpG0bjWQh0
8bNM1bMERDlvaM2JX68NHzkLLUOXLg1h97jmhFXaThhZ7MKGXcQYXKEkO5+NzNvB
Pafod+gBaX53mjTZMWUkyzMbyf4EZ6C+nL+KDiUpx8fm5yX0nP0drX6A5f7AH4IZ
Ywo3VJCGFur/ejnMf39DblKHra3DRJsGKqfScYlLLItAqwLjzb7FCg/zGOTCXf+0
8FB1lCj+uog3p/2vPvQghgiR8RD9ZNycXYp3SMS8hKbfqg/D8Agk7dsi+zk2mots
OiTJgoZNbJBYpumKrcMf
=KMFn
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_09_33_+1100_mpR3cWLvqHn1zU=h--
