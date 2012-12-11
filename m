Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2LKENW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 23:13:22 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47892 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2LKENU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 23:13:20 -0500
Date: Tue, 11 Dec 2012 15:13:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Bill Pemberton <wfp5p@virginia.edu>,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the gpio-lw tree with the driver-core
 tree
Message-Id: <20121211151310.04fcd54a9412f5d60f08367f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Dec_2012_15_13_10_+1100_jatQlAFnf1PiN2P."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Dec_2012_15_13_10_+1100_jatQlAFnf1PiN2P.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio-lw tree got a conflict in
drivers/gpio/gpio-stmpe.c between commit 3836309d9346 ("gpio: remove use
of __devinit") from the driver-core tree and commit fc13d5a5b17c ("gpio:
Provide the STMPE GPIO driver with its own IRQ Domain") from the gpio-lw
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpio-stmpe.c
index 6411600,3e1d398..0000000
--- a/drivers/gpio/gpio-stmpe.c
+++ b/drivers/gpio/gpio-stmpe.c
@@@ -288,21 -292,37 +292,37 @@@ int stmpe_gpio_irq_map(struct irq_domai
  	return 0;
  }
 =20
- static void stmpe_gpio_irq_remove(struct stmpe_gpio *stmpe_gpio)
+ void stmpe_gpio_irq_unmap(struct irq_domain *d, unsigned int virq)
  {
- 	int base =3D stmpe_gpio->irq_base;
- 	int irq;
-=20
- 	for (irq =3D base; irq < base + stmpe_gpio->chip.ngpio; irq++) {
  #ifdef CONFIG_ARM
- 		set_irq_flags(irq, 0);
+ 	set_irq_flags(virq, 0);
  #endif
- 		irq_set_chip_and_handler(irq, NULL, NULL);
- 		irq_set_chip_data(irq, NULL);
+ 	irq_set_chip_and_handler(virq, NULL, NULL);
+ 	irq_set_chip_data(virq, NULL);
+ }
+=20
+ static const struct irq_domain_ops stmpe_gpio_irq_simple_ops =3D {
+ 	.unmap =3D stmpe_gpio_irq_unmap,
+ 	.map =3D stmpe_gpio_irq_map,
+ 	.xlate =3D irq_domain_xlate_twocell,
+ };
+=20
 -static int __devinit stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
++static int stmpe_gpio_irq_init(struct stmpe_gpio *stmpe_gpio)
+ {
+ 	int base =3D stmpe_gpio->irq_base;
+=20
+ 	stmpe_gpio->domain =3D irq_domain_add_simple(NULL,
+ 				stmpe_gpio->chip.ngpio, base,
+ 				&stmpe_gpio_irq_simple_ops, stmpe_gpio);
+ 	if (!stmpe_gpio->domain) {
+ 		dev_err(stmpe_gpio->dev, "failed to create irqdomain\n");
+ 		return -ENOSYS;
  	}
+=20
+ 	return 0;
  }
 =20
 -static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 +static int stmpe_gpio_probe(struct platform_device *pdev)
  {
  	struct stmpe *stmpe =3D dev_get_drvdata(pdev->dev.parent);
  	struct device_node *np =3D pdev->dev.of_node;

--Signature=_Tue__11_Dec_2012_15_13_10_+1100_jatQlAFnf1PiN2P.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxrLWAAoJEECxmPOUX5FEV8MQAJzxFkhhPTxwDoUIB0PLYI1K
wNIyYXcJY36suvyWnmwNrfTMystSlbYJ2FQkWgzH+qjENjr41WxI/EpCdOGyQYkB
iAaJNq3UhKdrSYHyBnBvIJH/9BMR+qnrTBYOpyOwZH+T455ZokxPzASkfCxyT7qr
ZlPXvsp/eVwamNNe2yiuSqWolbVdXRiD4rNHeYOTWI0ivd7/D5j2dIn7JWVzIfin
mAmKfmJo6JkkLaoMnCafTxXtDt5wfiWCB5Ehc3KbFx3xanGul5U5sUVzY23iU7Xq
CnJCBo0lSoRQPWYw7x/fFQM7jg61FopKW2BJ7OX0tNKH03M2rzQYeTF6Ts6gbON2
H++gc4sTtvWmBmd5W0l7dC3hin2qBtx0e8GTIitvVScX/J1To4b5l80XCSHp0bQw
AdILXv9+0TtP/1zAjuD0dLGKxvmWAzFEgEAvtxBPezE8B/6OOpcsfdStkDFfcnRa
/R2O/gc5q8PHaSmosVRH6N7f2RogCMuVU4VCi7rpi+45K7kT0pWMgqG9JaSQ5/AH
fGWLTEAhtr8otVyY8xtO7FN+tChwTSqtC4+05TV8ceiITNe5vmfEJp0cA4/FOP/M
ZhkOXwEfVeWZZHIR0fpqo7RR6QPaww5dsz5fVF8skcDdvtwF2IlmbPSoG9CzFpj6
nC1ZRxuC4ar/D5CvUzYP
=a+4k
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Dec_2012_15_13_10_+1100_jatQlAFnf1PiN2P.--
