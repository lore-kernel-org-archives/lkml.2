Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2K2EUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:20:14 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47409 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2K2EUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:20:12 -0500
Date: Thu, 29 Nov 2012 15:20:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Qing Xu <qingx@marvell.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: linux-next: manual merge of the driver-core tree with the battery
 tree
Message-Id: <20121129152008.5a74394e46746fa83e70b8ff@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_20_08_+1100_Fo1CjAd7Rr1WWsEf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_20_08_+1100_Fo1CjAd7Rr1WWsEf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/power/max8925_power.c between commit eba3b670a916
("max8925_power: Add support for device-tree initialization") from the
battery tree and commit c8afa6406e60 ("power: remove use of __devinit")
from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/power/max8925_power.c
index b5a3ccb,1a075f1..0000000
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@@ -427,55 -426,7 +427,55 @@@ static int max8925_deinit_charger(struc
  	return 0;
  }
 =20
 +#ifdef CONFIG_OF
 +static struct max8925_power_pdata *
 +max8925_power_dt_init(struct platform_device *pdev)
 +{
 +	struct device_node *nproot =3D pdev->dev.parent->of_node;
 +	struct device_node *np;
 +	int batt_detect;
 +	int topoff_threshold;
 +	int fast_charge;
 +	int no_temp_support;
 +	int no_insert_detect;
 +	struct max8925_power_pdata *pdata;
 +
 +	if (!nproot)
 +		return pdev->dev.platform_data;
 +
 +	np =3D of_find_node_by_name(nproot, "charger");
 +	if (!np) {
 +		dev_err(&pdev->dev, "failed to find charger node\n");
 +		return NULL;
 +	}
 +
 +	pdata =3D devm_kzalloc(&pdev->dev,
 +			sizeof(struct max8925_power_pdata),
 +			GFP_KERNEL);
 +
 +	of_property_read_u32(np, "topoff-threshold", &topoff_threshold);
 +	of_property_read_u32(np, "batt-detect", &batt_detect);
 +	of_property_read_u32(np, "fast-charge", &fast_charge);
 +	of_property_read_u32(np, "no-insert-detect", &no_insert_detect);
 +	of_property_read_u32(np, "no-temp-support", &no_temp_support);
 +
 +	pdata->batt_detect =3D batt_detect;
 +	pdata->fast_charge =3D fast_charge;
 +	pdata->topoff_threshold =3D topoff_threshold;
 +	pdata->no_insert_detect =3D no_insert_detect;
 +	pdata->no_temp_support =3D no_temp_support;
 +
 +	return pdata;
 +}
 +#else
 +static struct max8925_power_pdata *
 +max8925_power_dt_init(struct platform_device *pdev)
 +{
 +	return pdev->dev.platform_data;
 +}
 +#endif
 +
- static __devinit int max8925_power_probe(struct platform_device *pdev)
+ static int max8925_power_probe(struct platform_device *pdev)
  {
  	struct max8925_chip *chip =3D dev_get_drvdata(pdev->dev.parent);
  	struct max8925_power_pdata *pdata =3D NULL;

--Signature=_Thu__29_Nov_2012_15_20_08_+1100_Fo1CjAd7Rr1WWsEf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuJ4AAoJEECxmPOUX5FEBC8P/1s38Pofor6mgwk8NQiXg2/G
vrQ+KYl3lK9fWxUVqSo7SVLVBWBWd1nCtBYXQqOBXl5vL7IPXQp6hyVtVKJ8OIY+
/L6DZWZRzZK3BZLV0J5eOb2RlvLMFofPiZXSmFpkIL+h1CIE9lraa9awMlB0Ph1l
IpsK15ODzSfpqruRo6IihxyFKyzVnIC+s21rCwhK6PQF1z6afx/1JoZtb4UGOM+K
SMBLhmdEPb44k4AxuMHlMSdJLrMEZyurjYvEGYQP5UcJm6xKZ8vXJGeVPvxQrxk5
A5lZcCzgAsjBvCobXsKgVqErDeZOBb0/c1JVyRggPvXANXZkt2bKR5+zELEVjou6
i7Nqjis/Xkh0B/mP2aE5HYzzrQCMuSGFGdy1ocOc5BaZQQWmDZHHIl9EVqgVwoLF
vw8K3vq9Rr0iA6ai0VUJIP4LjfSZRDZ5F2C0G8bOrpPIroUhcew8W0zLehgJt30k
U0TwUabuiH75an6SMb9nuuulWXyrdlfkPtVZzzBfDiMzdSZsj/QSuHJ/LO7vcvUE
AFlyf3r2wDrVgJjOfutjQcquJAu6K3oB4l8mjGpg0h9yBQSHIvJuj+m6SsHYPGxQ
73mcD13REtk4AS+M9z73FSkH8GcLTwsKmJsFwc6DZ8TM29q99UcN2ZV+GzmSxcvW
IvfKgs+grzckDW0TRhRS
=aPxK
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_20_08_+1100_Fo1CjAd7Rr1WWsEf--
