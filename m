Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966330Ab2EPInz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:43:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52126 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966046Ab2EPInt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:43:49 -0400
Date: Wed, 16 May 2012 18:43:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sangsu Park <sangsu4u.park@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>
Subject: linux-next: manual merge of the gpio tree with the s5p tree
Message-Id: <20120516184336.7263947e582bb2013f351682@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_18_43_36_+1000_U1BaO3bdgRRi./If"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_18_43_36_+1000_U1BaO3bdgRRi./If
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the gpio tree got a conflict in
drivers/gpio/gpio-samsung.c between commit ef04afd5451b ("ARM: EXYNOS:
add GPC4 bank instance") from the s5p tree and commit fd454997d687
("gpio: samsung: refactor gpiolib init for exynos4/5") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-samsung.c
index f88bb9f,5d49aff..0000000
--- a/drivers/gpio/gpio-samsung.c
+++ b/drivers/gpio/gpio-samsung.c
@@@ -2722,6 -2714,219 +2722,222 @@@ static __init void exynos_gpiolib_attac
  }
  #endif /* defined(CONFIG_ARCH_EXYNOS) && defined(CONFIG_OF) */
 =20
+ static __init void exynos4_gpiolib_init(void)
+ {
+ #ifdef CONFIG_CPU_EXYNOS4210
+ 	struct samsung_gpio_chip *chip;
+ 	int i, nr_chips;
+ 	void __iomem *gpio_base1, *gpio_base2, *gpio_base3;
+ 	int group =3D 0;
+ 	void __iomem *gpx_base;
+=20
+ 	/* gpio part1 */
+ 	gpio_base1 =3D ioremap(EXYNOS4_PA_GPIO1, SZ_4K);
+ 	if (gpio_base1 =3D=3D NULL) {
+ 		pr_err("unable to ioremap for gpio_base1\n");
+ 		goto err_ioremap1;
+ 	}
+=20
+ 	chip =3D exynos4_gpios_1;
+ 	nr_chips =3D ARRAY_SIZE(exynos4_gpios_1);
+=20
+ 	for (i =3D 0; i < nr_chips; i++, chip++) {
+ 		if (!chip->config) {
+ 			chip->config =3D &exynos_gpio_cfg;
+ 			chip->group =3D group++;
+ 		}
+ 		exynos_gpiolib_attach_ofnode(chip,
+ 				EXYNOS4_PA_GPIO1, i * 0x20);
+ 	}
+ 	samsung_gpiolib_add_4bit_chips(exynos4_gpios_1,
+ 				       nr_chips, gpio_base1);
+=20
+ 	/* gpio part2 */
+ 	gpio_base2 =3D ioremap(EXYNOS4_PA_GPIO2, SZ_4K);
+ 	if (gpio_base2 =3D=3D NULL) {
+ 		pr_err("unable to ioremap for gpio_base2\n");
+ 		goto err_ioremap2;
+ 	}
+=20
+ 	/* need to set base address for gpx */
+ 	chip =3D &exynos4_gpios_2[16];
+ 	gpx_base =3D gpio_base2 + 0xC00;
+ 	for (i =3D 0; i < 4; i++, chip++, gpx_base +=3D 0x20)
+ 		chip->base =3D gpx_base;
+=20
+ 	chip =3D exynos4_gpios_2;
+ 	nr_chips =3D ARRAY_SIZE(exynos4_gpios_2);
+=20
+ 	for (i =3D 0; i < nr_chips; i++, chip++) {
+ 		if (!chip->config) {
+ 			chip->config =3D &exynos_gpio_cfg;
+ 			chip->group =3D group++;
+ 		}
+ 		exynos_gpiolib_attach_ofnode(chip,
+ 				EXYNOS4_PA_GPIO2, i * 0x20);
+ 	}
+ 	samsung_gpiolib_add_4bit_chips(exynos4_gpios_2,
+ 				       nr_chips, gpio_base2);
+=20
+ 	/* gpio part3 */
+ 	gpio_base3 =3D ioremap(EXYNOS4_PA_GPIO3, SZ_256);
+ 	if (gpio_base3 =3D=3D NULL) {
+ 		pr_err("unable to ioremap for gpio_base3\n");
+ 		goto err_ioremap3;
+ 	}
+=20
+ 	chip =3D exynos4_gpios_3;
+ 	nr_chips =3D ARRAY_SIZE(exynos4_gpios_3);
+=20
+ 	for (i =3D 0; i < nr_chips; i++, chip++) {
+ 		if (!chip->config) {
+ 			chip->config =3D &exynos_gpio_cfg;
+ 			chip->group =3D group++;
+ 		}
+ 		exynos_gpiolib_attach_ofnode(chip,
+ 				EXYNOS4_PA_GPIO3, i * 0x20);
+ 	}
+ 	samsung_gpiolib_add_4bit_chips(exynos4_gpios_3,
+ 				       nr_chips, gpio_base3);
+=20
+ #if defined(CONFIG_CPU_EXYNOS4210) && defined(CONFIG_S5P_GPIO_INT)
+ 	s5p_register_gpioint_bank(IRQ_GPIO_XA, 0, IRQ_GPIO1_NR_GROUPS);
+ 	s5p_register_gpioint_bank(IRQ_GPIO_XB, IRQ_GPIO1_NR_GROUPS, IRQ_GPIO2_NR=
_GROUPS);
+ #endif
+=20
+ 	return;
+=20
+ err_ioremap3:
+ 	iounmap(gpio_base2);
+ err_ioremap2:
+ 	iounmap(gpio_base1);
+ err_ioremap1:
+ 	return;
+ #endif	/* CONFIG_CPU_EXYNOS4210 */
+ }
+=20
+ static __init void exynos5_gpiolib_init(void)
+ {
+ #ifdef CONFIG_SOC_EXYNOS5250
+ 	struct samsung_gpio_chip *chip;
+ 	int i, nr_chips;
+ 	void __iomem *gpio_base1, *gpio_base2, *gpio_base3, *gpio_base4;
+ 	int group =3D 0;
+ 	void __iomem *gpx_base;
+=20
+ 	/* gpio part1 */
+ 	gpio_base1 =3D ioremap(EXYNOS5_PA_GPIO1, SZ_4K);
+ 	if (gpio_base1 =3D=3D NULL) {
+ 		pr_err("unable to ioremap for gpio_base1\n");
+ 		goto err_ioremap1;
+ 	}
+=20
++	/* need to set base address for gpc4 */
++	exynos5_gpios_1[11].base =3D gpio_base1 + 0x2E0;
++
+ 	/* need to set base address for gpx */
 -	chip =3D &exynos5_gpios_1[20];
++	chip =3D &exynos5_gpios_1[21];
+ 	gpx_base =3D gpio_base1 + 0xC00;
+ 	for (i =3D 0; i < 4; i++, chip++, gpx_base +=3D 0x20)
+ 		chip->base =3D gpx_base;
+=20
+ 	chip =3D exynos5_gpios_1;
+ 	nr_chips =3D ARRAY_SIZE(exynos5_gpios_1);
+=20
+ 	for (i =3D 0; i < nr_chips; i++, chip++) {
+ 		if (!chip->config) {
+ 			chip->config =3D &exynos_gpio_cfg;
+ 			chip->group =3D group++;
+ 		}
+ 		exynos_gpiolib_attach_ofnode(chip,
+ 				EXYNOS5_PA_GPIO1, i * 0x20);
+ 	}
+ 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_1,
+ 				       nr_chips, gpio_base1);
+=20
+ 	/* gpio part2 */
+ 	gpio_base2 =3D ioremap(EXYNOS5_PA_GPIO2, SZ_4K);
+ 	if (gpio_base2 =3D=3D NULL) {
+ 		pr_err("unable to ioremap for gpio_base2\n");
+ 		goto err_ioremap2;
+ 	}
+=20
+ 	chip =3D exynos5_gpios_2;
+ 	nr_chips =3D ARRAY_SIZE(exynos5_gpios_2);
+=20
+ 	for (i =3D 0; i < nr_chips; i++, chip++) {
+ 		if (!chip->config) {
+ 			chip->config =3D &exynos_gpio_cfg;
+ 			chip->group =3D group++;
+ 		}
+ 		exynos_gpiolib_attach_ofnode(chip,
+ 				EXYNOS5_PA_GPIO2, i * 0x20);
+ 	}
+ 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_2,
+ 				       nr_chips, gpio_base2);
+=20
+ 	/* gpio part3 */
+ 	gpio_base3 =3D ioremap(EXYNOS5_PA_GPIO3, SZ_4K);
+ 	if (gpio_base3 =3D=3D NULL) {
+ 		pr_err("unable to ioremap for gpio_base3\n");
+ 		goto err_ioremap3;
+ 	}
+=20
+ 	/* need to set base address for gpv */
+ 	exynos5_gpios_3[0].base =3D gpio_base3;
+ 	exynos5_gpios_3[1].base =3D gpio_base3 + 0x20;
+ 	exynos5_gpios_3[2].base =3D gpio_base3 + 0x60;
+ 	exynos5_gpios_3[3].base =3D gpio_base3 + 0x80;
+ 	exynos5_gpios_3[4].base =3D gpio_base3 + 0xC0;
+=20
+ 	chip =3D exynos5_gpios_3;
+ 	nr_chips =3D ARRAY_SIZE(exynos5_gpios_3);
+=20
+ 	for (i =3D 0; i < nr_chips; i++, chip++) {
+ 		if (!chip->config) {
+ 			chip->config =3D &exynos_gpio_cfg;
+ 			chip->group =3D group++;
+ 		}
+ 		exynos_gpiolib_attach_ofnode(chip,
+ 				EXYNOS5_PA_GPIO3, i * 0x20);
+ 	}
+ 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_3,
+ 				       nr_chips, gpio_base3);
+=20
+ 	/* gpio part4 */
+ 	gpio_base4 =3D ioremap(EXYNOS5_PA_GPIO4, SZ_4K);
+ 	if (gpio_base4 =3D=3D NULL) {
+ 		pr_err("unable to ioremap for gpio_base4\n");
+ 		goto err_ioremap4;
+ 	}
+=20
+ 	chip =3D exynos5_gpios_4;
+ 	nr_chips =3D ARRAY_SIZE(exynos5_gpios_4);
+=20
+ 	for (i =3D 0; i < nr_chips; i++, chip++) {
+ 		if (!chip->config) {
+ 			chip->config =3D &exynos_gpio_cfg;
+ 			chip->group =3D group++;
+ 		}
+ 		exynos_gpiolib_attach_ofnode(chip,
+ 				EXYNOS5_PA_GPIO4, i * 0x20);
+ 	}
+ 	samsung_gpiolib_add_4bit_chips(exynos5_gpios_4,
+ 				       nr_chips, gpio_base4);
+ 	return;
+=20
+ err_ioremap4:
+ 	iounmap(gpio_base3);
+ err_ioremap3:
+ 	iounmap(gpio_base2);
+ err_ioremap2:
+ 	iounmap(gpio_base1);
+ err_ioremap1:
+ 	return;
+=20
+ #endif	/* CONFIG_SOC_EXYNOS5250 */
+ }
+=20
  /* TODO: cleanup soc_is_* */
  static __init int samsung_gpiolib_init(void)
  {

--Signature=_Wed__16_May_2012_18_43_36_+1000_U1BaO3bdgRRi./If
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs2i4AAoJEECxmPOUX5FE3+8QAIxCifqCmwRGsw09IS2RTpWx
OkI60pCRa42PgSiocPf+bFBU2o3IjH9LK65Vcsf0vlG3bjAwUqt8x5OO8kw79Bzo
ph5yw7B2DWIeCZu7ivKcSB7OaDw9KN4vc9Wke0HsMWMmphX/H7Epc6yd20MEtDi3
68Hk96O+Zc3u7noiRU41UyoInWls/+RKzGEbY+UBYje6Cbeg09Rgv5sGVQIVKIxf
qwyU5DavJtTiKmmTXwmq3lpSU3+5lJQ/og9o8qXZtpJs+m9pmavfUHl6o3LJyzko
SkdYzQOYsTw1vmMiOhft2996OI774QOLYr6JOG3+oRp5IVhoXSVbyzRPvQYdH0Mv
cgTrA3ngRHwcgoPW3OP66kECRbUKP29y/Fbzqp+E/ebLkpIsfpYPoBcAqs3u7v7p
MXbB5kAQeDZS3KOHRKa1PDu5B1gbzEoMvUH3IcQBXKG3bxdaTW10CArYXhqm0E4E
7EinqVZXtHw4Ie6sLx/VK2TD85t9E2VRarPiqZ+lg54AeumFweKewK6/fPrdmVTb
pbQhHA9n9JbVpoGNmw8jcERf4oz0+/EzpA/mTF1dsPp8Jz0ehOzWH2y0SRIBEVdI
RdlCyMTghQHThsn4ZRrhEUcQn1oAdOGuKuHsap/GFIAqv6BABgnvR7SVRnOUkzdM
0nsjcBaXIK+GTeF6ECDO
=SYRI
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_18_43_36_+1000_U1BaO3bdgRRi./If--
