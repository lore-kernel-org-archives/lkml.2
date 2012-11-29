Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab2K2EQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:16:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36408 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2K2EQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:16:01 -0500
Date: Thu, 29 Nov 2012 15:15:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: manual merge of the driver-core tree with the battery
 tree
Message-Id: <20121129151558.ecd7213462b330bc792870d7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_15_58_+1100_CGqgw3Fg/tkEdY8y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_15_58_+1100_CGqgw3Fg/tkEdY8y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/power/abx500_chargalg.c between commit a12810ab9fcf ("ab8500: Add
devicetree support for chargalg") from the battery tree and commit
c8afa6406e60 ("power: remove use of __devinit") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/abx500_chargalg.c
index dcdc439,19f2541..0000000
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@@ -1799,37 -1800,15 +1799,37 @@@ static int abx500_chargalg_remove(struc
  	return 0;
  }
 =20
 +static char *supply_interface[] =3D {
 +	"ab8500_fg",
 +};
 +
- static int __devinit abx500_chargalg_probe(struct platform_device *pdev)
+ static int abx500_chargalg_probe(struct platform_device *pdev)
  {
 -	struct abx500_bm_plat_data *plat_data;
 +	struct device_node *np =3D pdev->dev.of_node;
 +	struct abx500_chargalg *di;
  	int ret =3D 0;
 =20
 -	struct abx500_chargalg *di =3D
 -		kzalloc(sizeof(struct abx500_chargalg), GFP_KERNEL);
 -	if (!di)
 +	di =3D devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
 +	if (!di) {
 +		dev_err(&pdev->dev, "%s no mem for ab8500_chargalg\n", __func__);
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
 +			dev_err(&pdev->dev, "missing dt node for ab8500_chargalg\n");
 +			return -EINVAL;
 +		}
 +	} else {
 +		dev_info(&pdev->dev, "falling back to legacy platform data\n");
 +	}
 =20
  	/* get device struct */
  	di->dev =3D &pdev->dev;
@@@ -1905,14 -1888,12 +1905,14 @@@ free_chargalg_wq
  	return ret;
  }
 =20
 +static const struct of_device_id ab8500_chargalg_match[] =3D {
 +	{ .compatible =3D "stericsson,ab8500-chargalg", },
 +	{ },
 +};
 +
  static struct platform_driver abx500_chargalg_driver =3D {
  	.probe =3D abx500_chargalg_probe,
- 	.remove =3D __devexit_p(abx500_chargalg_remove),
+ 	.remove =3D abx500_chargalg_remove,
  	.suspend =3D abx500_chargalg_suspend,
  	.resume =3D abx500_chargalg_resume,
  	.driver =3D {

--Signature=_Thu__29_Nov_2012_15_15_58_+1100_CGqgw3Fg/tkEdY8y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuF+AAoJEECxmPOUX5FEXBIP/094Zz/BU0AjyRKQ+kkrmqpr
cjrg3DWTi1QnGy2oB953REdax3kINcMEjFRnrOgucXTaIxbD80V1GUyxjJ3TTJqX
5WwLGPJIQFAupyTv1zrt4sam+p2wvPz7xUkwHA19W2vLfFWqNuwmI2igsd4TLzkj
VWXObv+XkhuPF2VIwrgADzjX8brb9kBxxU/FzEZ4KJZE6lOZNJtYRu1VrWZ9Kj6d
8D9XnVTP1Ch2oSYBWOHx7omuOjtZvUmfSV5KyrNYz8O0k15dkRZ2wORZ7oD1O4ky
iWWetnSJoCxWpBjvwJm6RNUM3fZPis+HB/l7lVcWmTZ7eiKkJix56ZQRGpS/1qeD
MfBq3IG0fEzgj69V+G9fNx4D+8rwLfz8+E+LtIUCyDQSA98Tsiz/fP4DYAvMuyBA
rOd0eoAzr36Z5nqwOOKdCaeLaNNQ8W5O0/kHjAzrxXi67sTAAke4O2m/WZzyssQU
hgflRLg9XTqNbYPal/CNX83ziZitOJ0ybZVH+a+yWhO59Cni/+XZZUt13d2SKuSc
icg6kz1Zg4cMsNzpccJ4rwEP7k6XIPdYEOBVpmEN29ViOCt3DtniFdEjEM+ACweF
/nveVjcjJsrB3SC261L3GUVmERZcGhvQjJo3myIAaXu4XHJftEf7jafIxB1CGbMK
8XBSV+OialFYDsL17pMk
=DSqe
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_15_58_+1100_CGqgw3Fg/tkEdY8y--
