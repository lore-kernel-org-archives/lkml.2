Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2K2ELp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:11:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60512 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754548Ab2K2ELn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:11:43 -0500
Date: Thu, 29 Nov 2012 15:11:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        "Rajanikanth H.V" <rajanikanth.hv@stericsson.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: manual merge of the driver-core tree with the battery
 tree
Message-Id: <20121129151142.320443bcfadad110dcc88722@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_11_42_+1100_uj_aBrJBFda/1+1z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_11_42_+1100_uj_aBrJBFda/1+1z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/power/ab8500_charger.c between commit 4aef72dbb2e8 ("ab8500: Add
devicetree support for charger") from the battery tree and commit
c8afa6406e60 ("power: remove use of __devinit") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/ab8500_charger.c
index dddc947,7ecb8ab..0000000
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@@ -2532,41 -2531,20 +2532,41 @@@ static int ab8500_charger_remove(struc
  	return 0;
  }
 =20
 +static char *supply_interface[] =3D {
 +	"ab8500_chargalg",
 +	"ab8500_fg",
 +	"ab8500_btemp",
 +};
 +
- static int __devinit ab8500_charger_probe(struct platform_device *pdev)
+ static int ab8500_charger_probe(struct platform_device *pdev)
  {
 -	int irq, i, charger_status, ret =3D 0;
 -	struct abx500_bm_plat_data *plat_data =3D pdev->dev.platform_data;
 +	struct device_node *np =3D pdev->dev.of_node;
  	struct ab8500_charger *di;
 +	int irq, i, charger_status, ret =3D 0;
 =20
 -	if (!plat_data) {
 -		dev_err(&pdev->dev, "No platform data\n");
 -		return -EINVAL;
 -	}
 -
 -	di =3D kzalloc(sizeof(*di), GFP_KERNEL);
 -	if (!di)
 +	di =3D devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
 +	if (!di) {
 +		dev_err(&pdev->dev, "%s no mem for ab8500_charger\n", __func__);
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
 +			di->autopower_cfg =3D of_property_read_bool(np, "autopower_cfg");
 +		} else {
 +			dev_err(&pdev->dev, "missing dt node for ab8500_charger\n");
 +			return -EINVAL;
 +		}
 +	} else {
 +		dev_info(&pdev->dev, "falling back to legacy platform data\n");
 +		di->autopower_cfg =3D false;
 +	}
 =20
  	/* get parent data */
  	di->dev =3D &pdev->dev;
@@@ -2765,14 -2760,12 +2765,14 @@@ free_charger_wq
  	return ret;
  }
 =20
 +static const struct of_device_id ab8500_charger_match[] =3D {
 +	{ .compatible =3D "stericsson,ab8500-charger", },
 +	{ },
 +};
 +
  static struct platform_driver ab8500_charger_driver =3D {
  	.probe =3D ab8500_charger_probe,
- 	.remove =3D __devexit_p(ab8500_charger_remove),
+ 	.remove =3D ab8500_charger_remove,
  	.suspend =3D ab8500_charger_suspend,
  	.resume =3D ab8500_charger_resume,
  	.driver =3D {

--Signature=_Thu__29_Nov_2012_15_11_42_+1100_uj_aBrJBFda/1+1z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuB+AAoJEECxmPOUX5FE2RwP/j5z9cd245unn8bacGdSDd/X
v28qqNq8x2VPBXKgqD2N6gyLGDti9Vud470VARcIGDLaLptMqCOFoVTYyO3e7QBQ
zR0V6DzuiYc+dZyYWQldwAdVaMk6O90oNLDIZBNVXeX5vZmN1qUmeeewRBz5zGz2
u3NC27aIYiVhr0O/kGGATMidhPkwGXIVdgr0YjGCx2oiR6aKyya/UqkShGlEyBhs
RjBBdHJbyc8zSd+9CA9O6tQt9LfUE8WW58UaNVzmxBzLD0QxaJaTi2WcMVaoSaz2
4uIc+5q/42BW6ZnIijzxRCTmlr7jj4rgo0XeRhwJ9p+0S5mpBrDbF68dMrwYSmsy
MQHyb91vYXJ1Cp9w2gI2hFmjzAckSfFhBtjvpXVYZHaCwkN4yGceKP4BAQTu5ryH
xdI0SBztw8sBrXN5n1UsudeHtfRYXvL+fyAfLHRWDj+FLm0SXHuWoqYxJmjpg+Tc
jn5p1hA1pciKo6ntRgrwvqFYO3aTNTmDzPRcxYpfNWEhncunB0eToEwSNKNQc/Xh
SiUALxEPf/XFPll5rqcOmgNNO/Osnpr4G5e/Ex/IrKlmZnFyWyCZi5eRTVgScv2A
SkmymH7KVQHw7RtjEuC3qbeiHbOb/1tD1s2wlAsBN67ccFtEFNdGUQEAwwmGFh0+
mwUp8mvGileJd0iCRwBz
=qnpW
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_11_42_+1100_uj_aBrJBFda/1+1z--
