Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab2K2ENk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:13:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41377 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2K2ENj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:13:39 -0500
Date: Thu, 29 Nov 2012 15:13:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: manual merge of the driver-core tree with the battery
 tree
Message-Id: <20121129151336.fe662cf31face2b1a73f96df@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_13_36_+1100_FPX8OOapcoWTSjua"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_13_36_+1100_FPX8OOapcoWTSjua
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/power/ab8500_fg.c between commit e0f1abeba5c2 ("ab8500: Add
devicetree support for fuelgauge") from the battery tree and commit
c8afa6406e60 ("power: remove use of __devinit") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/ab8500_fg.c
index ed62ef7,331dc43..0000000
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@@ -2440,39 -2442,21 +2440,39 @@@ static struct ab8500_fg_interrupts ab85
  	{"CCEOC", ab8500_fg_cc_data_end_handler},
  };
 =20
 +static char *supply_interface[] =3D {
 +	"ab8500_chargalg",
 +	"ab8500_usb",
 +};
 +
- static int __devinit ab8500_fg_probe(struct platform_device *pdev)
+ static int ab8500_fg_probe(struct platform_device *pdev)
  {
 +	struct device_node *np =3D pdev->dev.of_node;
 +	struct ab8500_fg *di;
  	int i, irq;
  	int ret =3D 0;
 -	struct abx500_bm_plat_data *plat_data =3D pdev->dev.platform_data;
 -	struct ab8500_fg *di;
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
 +		dev_err(&pdev->dev, "%s no mem for ab8500_fg\n", __func__);
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
 +			dev_err(&pdev->dev, "missing dt node for ab8500_fg\n");
 +			return -EINVAL;
 +		}
 +	} else {
 +		dev_info(&pdev->dev, "falling back to legacy platform data\n");
 +	}
 =20
  	mutex_init(&di->cc_lock);
 =20
@@@ -2608,14 -2609,12 +2608,14 @@@ free_inst_curr_wq
  	return ret;
  }
 =20
 +static const struct of_device_id ab8500_fg_match[] =3D {
 +	{ .compatible =3D "stericsson,ab8500-fg", },
 +	{ },
 +};
 +
  static struct platform_driver ab8500_fg_driver =3D {
  	.probe =3D ab8500_fg_probe,
- 	.remove =3D __devexit_p(ab8500_fg_remove),
+ 	.remove =3D ab8500_fg_remove,
  	.suspend =3D ab8500_fg_suspend,
  	.resume =3D ab8500_fg_resume,
  	.driver =3D {

--Signature=_Thu__29_Nov_2012_15_13_36_+1100_FPX8OOapcoWTSjua
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuDwAAoJEECxmPOUX5FEVIgQAJia7Zvu7pVMOHTAus1W5gPj
F1WzPdrbWzoS/gm27zfl79HIR74hhVjD9m6vAcwjj3zyP3F6htVerajyqN9nwEzH
7jm54rWiBTo0juNDD/p2cGuvBIkiRBLjU9YY0kuJzbFU1GQ2b2pBEStwu965LR3g
AtXt31ppVbRdEf6v0oQQWRwqm17xODVLSKDBDihjn3SSmAgIL5Dy9h6Bkr+tvbUH
5wfMzQd1nM3WcA5Ukg6L/tzW7NTsFllzRxyTTktZcWJgQ/PC968E2ORDMpdrHSVb
cm8mybEoNaBVKqWneARr9Ye6PLp0Kc1C6JiD/BjacjAoKIWH7Yqg0qs0vjSXCQLj
/eosNV45MnLVBt52IFz63vzRIQD6KhnSncVpJg01Xc0mBuHCOS//eLvtM8vdSyJf
fYGO8VJvaw+pTGi0QxJ/Zk8eg/CrjS5vHmxrPkTYhaiZhuLiTmHEflQGWCt6/dYJ
WRe0yCQ7pvgB1OLhAPRhG7ryPuPn2ehhDiDmQM5aD6AbBStxgxoG42SIdxuXIjof
f0I+xBIypOdGnpC3s8chRQD0UMy9QnxCqeUzktfuIzb3yIJhV4vmBm5ffvzpK19D
TuO+5nnkvvYnXJy2DanM2Mcilwkp+Zs8GK5CTcxWsKgLaN0MmdIFd1hmbeFR6ovY
TPxC1O7TR8uZVFhrKl0K
=4T9v
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_13_36_+1100_FPX8OOapcoWTSjua--
