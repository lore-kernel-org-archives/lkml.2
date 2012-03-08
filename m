Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab2CHFvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:51:31 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37533 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2CHFv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:51:28 -0500
Date: Thu, 8 Mar 2012 16:51:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120308165116.d400947f35e40a923e9c6ad0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_16_51_16_+1100_CrEm+_emwTAwSeus"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_16_51_16_+1100_CrEm+_emwTAwSeus
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap1/board-ams-delta.c between commit ddba6c7f7ec6
("OMAP1: pass LCD config with omapfb_set_lcd_config()") from the
omap_dss2 tree and commits 5ca6180fa6d7 ("ARM: OMAP1: ams-delta:
supersede custom led device by leds-gpio") and 2e3ee9f45b3c ("ARM: OMAP1:
Move most of plat/io.h into local iomap.h") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap1/board-ams-delta.c
index e0e8245,c847597..0000000
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@@ -20,7 -21,7 +21,8 @@@
  #include <linux/platform_device.h>
  #include <linux/serial_8250.h>
  #include <linux/export.h>
 +#include <linux/omapfb.h>
+ #include <linux/io.h>
 =20
  #include <media/soc_camera.h>
 =20
@@@ -170,6 -162,117 +163,113 @@@ static struct omap_usb_config ams_delta
  	.pins[0]	=3D 2,
  };
 =20
 -static struct omap_board_config_kernel ams_delta_config[] __initdata =3D {
 -	{ OMAP_TAG_LCD,		&ams_delta_lcd_config },
 -};
 -
+ #define LATCH1_GPIO_BASE	232
+ #define LATCH1_NGPIO		8
+=20
+ static struct resource latch1_resources[] __initconst =3D {
+ 	[0] =3D {
+ 		.name	=3D "dat",
+ 		.start	=3D LATCH1_PHYS,
+ 		.end	=3D LATCH1_PHYS + (LATCH1_NGPIO - 1) / 8,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ };
+=20
+ static struct bgpio_pdata latch1_pdata __initconst =3D {
+ 	.base	=3D LATCH1_GPIO_BASE,
+ 	.ngpio	=3D LATCH1_NGPIO,
+ };
+=20
+ static struct platform_device latch1_gpio_device =3D {
+ 	.name		=3D "basic-mmio-gpio",
+ 	.id		=3D 0,
+ 	.resource	=3D latch1_resources,
+ 	.num_resources	=3D ARRAY_SIZE(latch1_resources),
+ 	.dev		=3D {
+ 		.platform_data	=3D &latch1_pdata,
+ 	},
+ };
+=20
+ static struct resource latch2_resources[] __initconst =3D {
+ 	[0] =3D {
+ 		.name	=3D "dat",
+ 		.start	=3D LATCH2_PHYS,
+ 		.end	=3D LATCH2_PHYS + (AMS_DELTA_LATCH2_NGPIO - 1) / 8,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ };
+=20
+ static struct bgpio_pdata latch2_pdata __initconst =3D {
+ 	.base	=3D AMS_DELTA_LATCH2_GPIO_BASE,
+ 	.ngpio	=3D AMS_DELTA_LATCH2_NGPIO,
+ };
+=20
+ static struct platform_device latch2_gpio_device =3D {
+ 	.name		=3D "basic-mmio-gpio",
+ 	.id		=3D 1,
+ 	.resource	=3D latch2_resources,
+ 	.num_resources	=3D ARRAY_SIZE(latch2_resources),
+ 	.dev		=3D {
+ 		.platform_data	=3D &latch2_pdata,
+ 	},
+ };
+=20
+ static struct gpio latch_gpios[] __initconst =3D {
+ 	{
+ 		.gpio	=3D LATCH1_GPIO_BASE + 6,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "dockit1",
+ 	},
+ 	{
+ 		.gpio	=3D LATCH1_GPIO_BASE + 7,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "dockit2",
+ 	},
+ 	{
+ 		.gpio	=3D AMS_DELTA_GPIO_PIN_SCARD_RSTIN,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "scard_rstin",
+ 	},
+ 	{
+ 		.gpio	=3D AMS_DELTA_GPIO_PIN_SCARD_CMDVCC,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "scard_cmdvcc",
+ 	},
+ 	{
+ 		.gpio	=3D AMS_DELTA_GPIO_PIN_MODEM_NRESET,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "modem_nreset",
+ 	},
+ 	{
+ 		.gpio	=3D AMS_DELTA_GPIO_PIN_MODEM_CODEC,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "modem_codec",
+ 	},
+ 	{
+ 		.gpio	=3D AMS_DELTA_LATCH2_GPIO_BASE + 14,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "hookflash1",
+ 	},
+ 	{
+ 		.gpio	=3D AMS_DELTA_LATCH2_GPIO_BASE + 15,
+ 		.flags	=3D GPIOF_OUT_INIT_LOW,
+ 		.label	=3D "hookflash2",
+ 	},
+ };
+=20
+ void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
+ {
+ 	int bit =3D 0;
+ 	u16 bitpos =3D 1 << bit;
+=20
+ 	for (; bit < ngpio; bit++, bitpos =3D bitpos << 1) {
+ 		if (!(mask & bitpos))
+ 			continue;
+ 		gpio_set_value(base + bit, (value & bitpos) !=3D 0);
+ 	}
+ }
+ EXPORT_SYMBOL(ams_delta_latch_write);
+=20
  static struct resource ams_delta_nand_resources[] =3D {
  	[0] =3D {
  		.start	=3D OMAP1_MPUIO_BASE,

--Signature=_Thu__8_Mar_2012_16_51_16_+1100_CrEm+_emwTAwSeus
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWEjUAAoJEECxmPOUX5FEVcAQAI1w2+dYENTtncxmKot/evcZ
0mjVrM4P4C4wkXr9hfm4Zb9A6Ts0GpUPQozd0e5pnu9pIwFY8qgurQHzjTu4UqCv
uwKnf3rVZ1JRFR/he2874tltWJPcW8/fWT1FHnW/j71aDGhfk3sNBGLaczg0Txm1
1zHYaoZxAyD3SZidvWPieQ9B/6RaAv73Y2LhJ75rWopv9s5vo2PKFy8LtqzEqx7i
jwGmNi7HJImGdWDC5uIyWDwhDdCXxs+HGkX0ygaLNBXmhMp821an+Btcgg9ghwUP
niC058zoVE/rSM/Ct7rdCnH8gWKds+WhpHO9a3Voqfjb7MexOLle6/exky30dBdk
XAy4rtcq44T9/4vxQtQyS2me63fBrg6ihbQvgRiOCnA7JPC3z/lqNju97lM4pFXl
hWZRotfHozDYUMyZ3IxUMfj4K+r/O7u/xY0rba0gy2kuLc88th6vVmqicRsCDhRP
Q29DFixYUfcnjjEBjDwVfGpDg22IxfSZ9VyS81F8JBDSaC+vWrTYNBxOcmcL/Q5Z
yAa8q4izfKNsDDNd25nm1nj2+4C5NzhPrP6DZQjvS4N6po8qavzNI0eU802DyfsZ
tdBB2VsCY+156TRgegMU4wju5amSxTDa5Q7M571iVbv//wZJ+Gjz8D3eGs71s/ZR
hpcgpjvJjCj3L8BVOFeC
=dwnc
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_16_51_16_+1100_CrEm+_emwTAwSeus--
