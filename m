Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2EGCL4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 22:11:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34405 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2EGCLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 22:11:54 -0400
Date: Mon, 7 May 2012 12:11:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Westin <andreas.westin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the crypto tree with Linus' tree
Message-Id: <20120507121137.bdfc96ed31649040506d9c75@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_12_11_37_+1000_0P9qPhL_gw8aFca6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_12_11_37_+1000_0P9qPhL_gw8aFca6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

Today's linux-next merge of the crypto tree got conflicts in
arch/arm/mach-ux500/board-mop500.c and arch/arm/mach-ux500/board-u5500.c
between commit b024a0c80435 ("ARM: ux500: move top level platform devices
in sysfs to /sys/devices/socX") from Linus' tree and commit 3ba812f4d0be
("mach-ux500: crypto - core support for CRYP/HASH module") from the
crypto tree.

Just context changes.  I fixed them up (see below) and can carry the
fixes as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-ux500/board-mop500.c
index 77d03c1,4e9bcd6..0000000
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@@ -595,13 -627,19 +635,19 @@@ static struct amba_pl011_data uart2_pla
  #endif
  };
 =20
 -static void __init mop500_uart_init(void)
 +static void __init mop500_uart_init(struct device *parent)
  {
 -	db8500_add_uart0(&uart0_plat);
 -	db8500_add_uart1(&uart1_plat);
 -	db8500_add_uart2(&uart2_plat);
 +	db8500_add_uart0(parent, &uart0_plat);
 +	db8500_add_uart1(parent, &uart1_plat);
 +	db8500_add_uart2(parent, &uart2_plat);
  }
 =20
+ static void __init u8500_cryp1_hash1_init(void)
+ {
+ 	db8500_add_cryp1(&u8500_cryp1_platform_data);
+ 	db8500_add_hash1(&u8500_hash1_platform_data);
+ }
+=20
  static struct platform_device *snowball_platform_devs[] __initdata =3D {
  	&snowball_led_dev,
  	&snowball_key_dev,
@@@ -621,10 -657,8 +667,12 @@@ static void __init mop500_init_machine(
 =20
  	mop500_pins_init();
 =20
+ 	u8500_cryp1_hash1_init();
+=20
 +	/* FIXME: parent of ab8500 should be prcmu */
 +	for (i =3D 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 +		mop500_platform_devs[i]->dev.parent =3D parent;
 +
  	platform_add_devices(mop500_platform_devs,
  			ARRAY_SIZE(mop500_platform_devs));
 =20
diff --cc arch/arm/mach-ux500/board-u5500.c
index 0ff4be7,865aaf8..0000000
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@@ -135,19 -182,13 +182,20 @@@ static void __init u5500_uart_init(stru
 =20
  static void __init u5500_init_machine(void)
  {
 -	u5500_init_devices();
 +	struct device *parent =3D NULL;
 +	int i;
 +
 +	parent =3D u5500_init_devices();
  	nmk_config_pins(u5500_pins, ARRAY_SIZE(u5500_pins));
 -	u5500_i2c_init();
 -	u5500_sdi_init();
 -	u5500_uart_init();
 +
 +	u5500_i2c_init(parent);
 +	u5500_sdi_init(parent);
 +	u5500_uart_init(parent);
+ 	u5500_cryp1_hash1_init();
 =20
 +	for (i =3D 0; i < ARRAY_SIZE(u5500_platform_devices); i++)
 +		u5500_platform_devices[i]->dev.parent =3D parent;
 +
  	platform_add_devices(u5500_platform_devices,
  		ARRAY_SIZE(u5500_platform_devices));
  }

--Signature=_Mon__7_May_2012_12_11_37_+1000_0P9qPhL_gw8aFca6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPpy9ZAAoJEECxmPOUX5FEcLoP/RNzJhUgZAuaNCvrrORAVYJo
FX8rnNw/cnXj6Xm1bSCA8JzFC6FhI2pGWx+a89hbTjjKdLUkc6X5OW/jVY/IGeeK
8SvbOXwPF9UoTIuF3hbB0EcmEwKguXAI8MJpaWQ+Z3q+JePfvbyn1bCSQ+pN5hb/
+Tg9pszwov+A13/4VxN9e7h25coozG/v6pKB+3NXiQ26lUOw9WEYIMoTfjIU8R/k
Tbc+xbmTtd4Bof3WKoz7jVhOiJeKtqCIskgXBBJtfdtdLfCC9U3c+2LQZ7v/wZJ5
Qrb1rY6A6Y9p3yp+rDP3AWiL/G3gb6XfihaJDmVegCi9VdIFTU7eLS/T1jCnkLBn
QtxHVAiMAO0tpWcUMKy9qALgfxpKfCoHtuwnQ1QuIqHqX8MlIItW9jIWcCcNtuGf
LkGpD2+f9bF6bbd12cVuLCFRa6nvWyx3sKNKlK3sX2+3Hlj1+DGI3ZgjCi7hu5jP
szEANQ+BXNdqe05KjYbbc4KCLtEDKj+asADoxGyHEZNjKxoT3ymR6B1roAez1tO5
pLWL67vrplmTfWws1Mmp1NY7J8Fpzv1fs2PrNQh7jD+MvT/GUcn0jQT1SOHNTKJ4
zGqyD2CqA81XFjsP5el826JIASDEckpu4nWqYRPNohmfPDX1QrJ93T/GyhNz8j3d
25oo+t+hHx/KzcyBZ+ey
=LKBg
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_12_11_37_+1000_0P9qPhL_gw8aFca6--
