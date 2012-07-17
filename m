Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab2GQCT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:19:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39865 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab2GQCTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:19:54 -0400
Date: Tue, 17 Jul 2012 12:19:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Axel Lin <axel.lin@gmail.com>
Subject: linux-next: manual merge of the regulator tree with the mfd tree
Message-Id: <20120717121943.a8266271ec4f5635954d5fda@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Jul_2012_12_19_43_+1000_fTNrCckXhd9Lgfk2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Jul_2012_12_19_43_+1000_fTNrCckXhd9Lgfk2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the regulator tree got a conflicts in
drivers/regulator/s5m8767.c between commit 63063bfbffe9 ("mfd: Modify
samsung mfd driver for common api") from the mfd tree and commits
3fe3a182adfe ("regulator: Remove s5m8767a buck initialization"),
df2643cfa4ad ("regulator: Replace set_voltage with set_voltage_sel"),
c848bc8538cd ("regulator: s5m8767a: Support AP watchdog reset
operation"), 1af142c6f984 ("regulator: Modify ramp_delay value for
s5m8767a"), e2eb169b1bc2 ("regulator: s5m8767: Convert to
regulator_list_voltage_linear") from the regulator tree.

I fixed it all up (I think - see below) and can carry the fixes as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/regulator/s5m8767.c
index aeea91b,102287f..0000000
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@@ -431,14 -407,8 +407,8 @@@ static int s5m8767_set_voltage_sel(stru
  		if (ret)
  			return ret;
 =20
- 		sec_reg_read(s5m8767->iodev, reg, &val);
- 		val =3D (val & ~mask) | sel;
-=20
- 		ret =3D sec_reg_write(s5m8767->iodev, reg, val);
 -		return s5m_reg_update(s5m8767->iodev, reg, selector, mask);
++		return sec_reg_update(s5m8767->iodev, reg, selector, mask);
  	}
-=20
- 	*selector =3D sel;
- 	return ret;
  }
 =20
  static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
@@@ -579,6 -567,27 +567,27 @@@ static __devinit int s5m8767_pmic_probe
  	s5m8767->buck4_ramp =3D pdata->buck4_ramp_enable;
  	s5m8767->opmode =3D pdata->opmode;
 =20
+ 	buck_init =3D s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
+ 						pdata->buck2_init,
+ 						pdata->buck2_init +
+ 						buck_voltage_val2.step);
+=20
 -	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS2, buck_init);
++	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK2DVS2, buck_init);
+=20
+ 	buck_init =3D s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
+ 						pdata->buck3_init,
+ 						pdata->buck3_init +
+ 						buck_voltage_val2.step);
+=20
 -	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS2, buck_init);
++	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK3DVS2, buck_init);
+=20
+ 	buck_init =3D s5m8767_convert_voltage_to_sel(&buck_voltage_val2,
+ 						pdata->buck4_init,
+ 						pdata->buck4_init +
+ 						buck_voltage_val2.step);
+=20
 -	s5m_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS2, buck_init);
++	sec_reg_write(s5m8767->iodev, S5M8767_REG_BUCK4DVS2, buck_init);
+=20
  	for (i =3D 0; i < 8; i++) {
  		if (s5m8767->buck2_gpiodvs) {
  			s5m8767->buck2_vol[i] =3D
@@@ -608,48 -617,70 +617,70 @@@
  		}
  	}
 =20
- 	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
- 		pdata->buck4_gpiodvs) {
- 		if (gpio_is_valid(pdata->buck_gpios[0]) &&
- 			gpio_is_valid(pdata->buck_gpios[1]) &&
- 			gpio_is_valid(pdata->buck_gpios[2])) {
- 			ret =3D gpio_request(pdata->buck_gpios[0],
- 						"S5M8767 SET1");
- 			if (ret =3D=3D -EBUSY)
- 				dev_warn(&pdev->dev, "Duplicated gpio request for SET1\n");
-=20
- 			ret =3D gpio_request(pdata->buck_gpios[1],
- 					   "S5M8767 SET2");
- 			if (ret =3D=3D -EBUSY)
- 				dev_warn(&pdev->dev, "Duplicated gpio request for SET2\n");
-=20
- 			ret =3D gpio_request(pdata->buck_gpios[2],
- 					   "S5M8767 SET3");
- 			if (ret =3D=3D -EBUSY)
- 				dev_warn(&pdev->dev, "Duplicated gpio request for SET3\n");
- 			/* SET1 GPIO */
- 			gpio_direction_output(pdata->buck_gpios[0],
- 					(s5m8767->buck_gpioindex >> 2) & 0x1);
- 			/* SET2 GPIO */
- 			gpio_direction_output(pdata->buck_gpios[1],
- 					(s5m8767->buck_gpioindex >> 1) & 0x1);
- 			/* SET3 GPIO */
- 			gpio_direction_output(pdata->buck_gpios[2],
- 					(s5m8767->buck_gpioindex >> 0) & 0x1);
- 			ret =3D 0;
- 		} else {
- 			dev_err(&pdev->dev, "GPIO NOT VALID\n");
- 			ret =3D -EINVAL;
+ 	if (gpio_is_valid(pdata->buck_gpios[0]) &&
+ 		gpio_is_valid(pdata->buck_gpios[1]) &&
+ 		gpio_is_valid(pdata->buck_gpios[2])) {
+ 		ret =3D devm_gpio_request(&pdev->dev, pdata->buck_gpios[0],
+ 					"S5M8767 SET1");
+ 		if (ret)
  			return ret;
- 		}
+=20
+ 		ret =3D devm_gpio_request(&pdev->dev, pdata->buck_gpios[1],
+ 					"S5M8767 SET2");
+ 		if (ret)
+ 			return ret;
+=20
+ 		ret =3D devm_gpio_request(&pdev->dev, pdata->buck_gpios[2],
+ 					"S5M8767 SET3");
+ 		if (ret)
+ 			return ret;
+=20
+ 		/* SET1 GPIO */
+ 		gpio_direction_output(pdata->buck_gpios[0],
+ 				(s5m8767->buck_gpioindex >> 2) & 0x1);
+ 		/* SET2 GPIO */
+ 		gpio_direction_output(pdata->buck_gpios[1],
+ 				(s5m8767->buck_gpioindex >> 1) & 0x1);
+ 		/* SET3 GPIO */
+ 		gpio_direction_output(pdata->buck_gpios[2],
+ 				(s5m8767->buck_gpioindex >> 0) & 0x1);
+ 	} else {
+ 		dev_err(&pdev->dev, "GPIO NOT VALID\n");
+ 		ret =3D -EINVAL;
+ 		return ret;
  	}
 =20
- 	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
- 			(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
- 	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
- 			(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
- 	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
- 			(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1), 1 << 1);
+ 	ret =3D devm_gpio_request(&pdev->dev, pdata->buck_ds[0], "S5M8767 DS2");
+ 	if (ret)
+ 		return ret;
+=20
+ 	ret =3D devm_gpio_request(&pdev->dev, pdata->buck_ds[1], "S5M8767 DS3");
+ 	if (ret)
+ 		return ret;
+=20
+ 	ret =3D devm_gpio_request(&pdev->dev, pdata->buck_ds[2], "S5M8767 DS4");
+ 	if (ret)
+ 		return ret;
+=20
+ 	/* DS2 GPIO */
+ 	gpio_direction_output(pdata->buck_ds[0], 0x0);
+ 	/* DS3 GPIO */
+ 	gpio_direction_output(pdata->buck_ds[1], 0x0);
+ 	/* DS4 GPIO */
+ 	gpio_direction_output(pdata->buck_ds[2], 0x0);
+=20
+ 	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
+ 	   pdata->buck4_gpiodvs) {
 -		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
++		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL,
+ 				(pdata->buck2_gpiodvs) ? (1 << 1) : (0 << 1),
+ 				1 << 1);
 -		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
++		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL,
+ 				(pdata->buck3_gpiodvs) ? (1 << 1) : (0 << 1),
+ 				1 << 1);
 -		s5m_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
++		sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL,
+ 				(pdata->buck4_gpiodvs) ? (1 << 1) : (0 << 1),
+ 				1 << 1);
+ 	}
 =20
  	/* Initialize GPIO DVS registers */
  	for (i =3D 0; i < 8; i++) {
@@@ -668,28 -699,29 +699,29 @@@
  					   s5m8767->buck4_vol[i]);
  		}
  	}
- 	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK2CTRL, 0x78, 0xff);
- 	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK3CTRL, 0x58, 0xff);
- 	sec_reg_update(s5m8767->iodev, S5M8767_REG_BUCK4CTRL, 0x78, 0xff);
 =20
  	if (s5m8767->buck2_ramp)
 -		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
 +		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x08, 0x08);
 =20
  	if (s5m8767->buck3_ramp)
 -		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x04, 0x04);
 +		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x04, 0x04);
 =20
  	if (s5m8767->buck4_ramp)
 -		s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x02, 0x02);
 +		sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP, 0x02, 0x02);
 =20
  	if (s5m8767->buck2_ramp || s5m8767->buck3_ramp
  		|| s5m8767->buck4_ramp) {
  		switch (s5m8767->ramp_delay) {
- 		case 15:
+ 		case 5:
 -			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 +			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
- 					0xc0, 0xf0);
+ 					0x40, 0xf0);
+ 			break;
+ 		case 10:
 -			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
++			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
+ 					0x90, 0xf0);
  			break;
  		case 25:
 -			s5m_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
 +			sec_reg_update(s5m8767->iodev, S5M8767_REG_DVSRAMP,
  					0xd0, 0xf0);
  			break;
  		case 50:

--Signature=_Tue__17_Jul_2012_12_19_43_+1000_fTNrCckXhd9Lgfk2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQBMu/AAoJEECxmPOUX5FE5xYP/RFPQoLeQ/8a4nLCs+3w6Ti6
yfjV3bIP13lZzuOsw4nXSjnTllQLW0n5o/pE5h02BtJ0RXCMq0tMTAtG/EfXUpcb
wu9Yt/m1WgIaKSHnosX2AAVmRFjwBuwWOHDgp5SQAI4QIsRhGplceABBDn+3Hyg0
gQP7BsyWvBcDp63G1ma9YEibnwmFQ8PHQsWaiWorbXnsdVqztCJqf6b8x2c5zJ1f
PBE1r/eb0AJ7fXsDEMYlH2Lug5gPYwHRaK8rWc/kuUTQmmwKpSiJbc3KfkPpj9Ay
cj7rzcYJQUf5ae/JsXPcW7zhYMdmx1+GxUMLfPD1uUxFZvYnxDkgPcEuNcNEeooV
jcwNFs3GmKs/+v3NIPA3xPAl/oqf0W9HwVs1nS+xE81DM5ezNGOsRBf0K39U4sQb
odh2T4zP7YfWIcbcDw3KwyrVok6ItMUjw4aDoQIi9oSpnCZWlAD1XOr/1k6P72wU
rxCnyQxMEs26ka4LggQpYv+72W3XiZa8sS88Vc9a476V1cRrMllVpFjNd+PLe1Bx
KiyQZ4UNxsKP4qr8xnnqQODBCNtf9O6AHkDbD9lw49TzgUJ6SISV3zJzmyjraCDC
dLdtqyDCePs76hn8HpwpMctdvQDB0rPzYiDH4MtaAe4w/AVgYkhQ4Lo7+1TBHDt+
nDqiDldngH963RNpQbgs
=onYU
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Jul_2012_12_19_43_+1000_fTNrCckXhd9Lgfk2--
