Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886Ab2K2FDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:03:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43983 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab2K2FDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:03:19 -0500
Date: Thu, 29 Nov 2012 16:03:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        Simon Guinot <simon.guinot@sequanux.org>
Subject: linux-next: manual merge of the arm-soc tree with the driver-core
 tree
Message-Id: <20121129160309.7dc352f433d39f1bde0018a8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_16_03_09_+1100_vCsDlNNwIoU=b9AY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_16_03_09_+1100_vCsDlNNwIoU=b9AY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/leds/leds-ns2.c between commit 98ea1ea20cb7 ("leds: remove use of
__devinit") from the driver-core tree and commit 72052fcc1026 ("leds:
leds-ns2: add device tree binding") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/leds/leds-ns2.c
index bc6a0db,d64cc22..0000000
--- a/drivers/leds/leds-ns2.c
+++ b/drivers/leds/leds-ns2.c
@@@ -247,9 -260,67 +248,65 @@@ static void delete_ns2_led(struct ns2_l
  {
  	device_remove_file(led_dat->cdev.dev, &dev_attr_sata);
  	led_classdev_unregister(&led_dat->cdev);
 -	gpio_free(led_dat->cmd);
 -	gpio_free(led_dat->slow);
  }
 =20
+ #ifdef CONFIG_OF_GPIO
+ /*
+  * Translate OpenFirmware node properties into platform_data.
+  */
 -static int __devinit
++static int
+ ns2_leds_get_of_pdata(struct device *dev, struct ns2_led_platform_data *p=
data)
+ {
+ 	struct device_node *np =3D dev->of_node;
+ 	struct device_node *child;
+ 	struct ns2_led *leds;
+ 	int num_leds =3D 0;
+ 	int i =3D 0;
+=20
+ 	num_leds =3D of_get_child_count(np);
+ 	if (!num_leds)
+ 		return -ENODEV;
+=20
+ 	leds =3D devm_kzalloc(dev, num_leds * sizeof(struct ns2_led),
+ 			    GFP_KERNEL);
+ 	if (!leds)
+ 		return -ENOMEM;
+=20
+ 	for_each_child_of_node(np, child) {
+ 		const char *string;
+ 		int ret;
+=20
+ 		ret =3D of_get_named_gpio(child, "cmd-gpio", 0);
+ 		if (ret < 0)
+ 			return ret;
+ 		leds[i].cmd =3D ret;
+ 		ret =3D of_get_named_gpio(child, "slow-gpio", 0);
+ 		if (ret < 0)
+ 			return ret;
+ 		leds[i].slow =3D ret;
+ 		ret =3D of_property_read_string(child, "label", &string);
+ 		leds[i].name =3D (ret =3D=3D 0) ? string : child->name;
+ 		ret =3D of_property_read_string(child, "linux,default-trigger",
+ 					      &string);
+ 		if (ret =3D=3D 0)
+ 			leds[i].default_trigger =3D string;
+=20
+ 		i++;
+ 	}
+=20
+ 	pdata->leds =3D leds;
+ 	pdata->num_leds =3D num_leds;
+=20
+ 	return 0;
+ }
+=20
+ static const struct of_device_id of_ns2_leds_match[] =3D {
+ 	{ .compatible =3D "lacie,ns2-leds", },
+ 	{},
+ };
+ #endif /* CONFIG_OF_GPIO */
+=20
 -static int __devinit ns2_led_probe(struct platform_device *pdev)
 +static int ns2_led_probe(struct platform_device *pdev)
  {
  	struct ns2_led_platform_data *pdata =3D pdev->dev.platform_data;
  	struct ns2_led_data *leds_data;
@@@ -296,10 -381,11 +367,11 @@@ static int ns2_led_remove(struct platfo
 =20
  static struct platform_driver ns2_led_driver =3D {
  	.probe		=3D ns2_led_probe,
 -	.remove		=3D __devexit_p(ns2_led_remove),
 +	.remove		=3D ns2_led_remove,
  	.driver		=3D {
- 		.name	=3D "leds-ns2",
- 		.owner	=3D THIS_MODULE,
+ 		.name		=3D "leds-ns2",
+ 		.owner		=3D THIS_MODULE,
+ 		.of_match_table	=3D of_match_ptr(of_ns2_leds_match),
  	},
  };
 =20

--Signature=_Thu__29_Nov_2012_16_03_09_+1100_vCsDlNNwIoU=b9AY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuyNAAoJEECxmPOUX5FEBgEP/iYHT/Gv8NGNUcsGxwXfYHNv
KJsC2Dz77PhQfwz0RbFWlcZaqfeX/f59+7l/Rp1eaL2eKMt7VhhouUtpzlp9B2F3
Rei4v/drrTNHB2t1bplbHKgOifSPgnrsdg7j7x5FYUKzYifvY7MtTeSq38cGKjyi
zd51fXDKfigbz1tmGSX5wzlvzscSNNui3k6xfG6irKSV5iAbVQmSphU2EHlYAsVS
qMGm9eXXT9VMY7KfqGrRm9ogQvAt+YyxKibJ5znslSmf6xSQ06xiIJLyEogFbJlP
/nhGQEs7O7e6E6pWMlbb4tzg4BYm03IzWlD5s8s1radXfk67JV1u1fma9GYfM9bK
CHI+y2hpcjdd2HBjjSxjEsg0O12EIRAEi5XwftToZxGvRbvPHLfjh0mlOHsGYOOK
TzMzDqZvdcvve/TP3q3voEeXAaqDIzIMzo5ig0TJDO4iZjsWQwMlx2XEcVo7apX9
RwxZaUqFcoqmhkKHYe+tco4jWjGd+1fnPLplKaSnQzFsPnRMHRF4fVBt8zZw90ZM
Yv/fBN0s2NGWcHis1wdoms3/ZuWOwOzM4EXm0naJOaL7cuAaXGrdBV90clYuVxFL
S8iStTdRITWu0w9IyAybhbI0BJsLWiGdAxVEzwQuL5qtlLsE0RIKkArHOIpU0OWz
6vtqYrRz5DvF4pACrpCV
=Z3/D
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_16_03_09_+1100_vCsDlNNwIoU=b9AY--
