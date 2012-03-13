Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab2CMIWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:22:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39397 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033Ab2CMIV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:21:56 -0400
Date: Tue, 13 Mar 2012 19:21:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120313192137.613a8bd8888c07597cba6307@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_19_21_37_+1100_GYgQcG.JggurhSBa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_19_21_37_+1100_GYgQcG.JggurhSBa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-omap1/board-ams-delta.c between commit ddba6c7f7ec6
("OMAP1: pass LCD config with omapfb_set_lcd_config()") from the
omap_dss2 tree and commits 2e3ee9f45b3c ("ARM: OMAP1: Move most of
plat/io.h into local iomap.h") and several others from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap1/board-ams-delta.c
index e0e8245,7dd3099..0000000
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@@ -18,9 -19,12 +19,13 @@@
  #include <linux/interrupt.h>
  #include <linux/leds.h>
  #include <linux/platform_device.h>
+ #include <linux/regulator/consumer.h>
+ #include <linux/regulator/fixed.h>
+ #include <linux/regulator/machine.h>
  #include <linux/serial_8250.h>
  #include <linux/export.h>
 +#include <linux/omapfb.h>
+ #include <linux/io.h>
 =20
  #include <media/soc_camera.h>
 =20
@@@ -170,6 -165,151 +166,147 @@@ static struct omap_usb_config ams_delta
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
+ static struct resource latch1_resources[] =3D {
+ 	[0] =3D {
+ 		.name	=3D "dat",
+ 		.start	=3D LATCH1_PHYS,
+ 		.end	=3D LATCH1_PHYS + (LATCH1_NGPIO - 1) / 8,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ };
+=20
+ static struct bgpio_pdata latch1_pdata =3D {
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
+ static struct resource latch2_resources[] =3D {
+ 	[0] =3D {
+ 		.name	=3D "dat",
+ 		.start	=3D LATCH2_PHYS,
+ 		.end	=3D LATCH2_PHYS + (AMS_DELTA_LATCH2_NGPIO - 1) / 8,
+ 		.flags	=3D IORESOURCE_MEM,
+ 	},
+ };
+=20
+ static struct bgpio_pdata latch2_pdata =3D {
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
+ static const struct gpio latch_gpios[] __initconst =3D {
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
+ static struct regulator_consumer_supply modem_nreset_consumers[] =3D {
+ 	REGULATOR_SUPPLY("RESET#", "serial8250.1"),
+ 	REGULATOR_SUPPLY("POR", "cx20442-codec"),
+ };
+=20
+ static struct regulator_init_data modem_nreset_data =3D {
+ 	.constraints		=3D {
+ 		.valid_ops_mask		=3D REGULATOR_CHANGE_STATUS,
+ 		.boot_on		=3D 1,
+ 	},
+ 	.num_consumer_supplies	=3D ARRAY_SIZE(modem_nreset_consumers),
+ 	.consumer_supplies	=3D modem_nreset_consumers,
+ };
+=20
+ static struct fixed_voltage_config modem_nreset_config =3D {
+ 	.supply_name		=3D "modem_nreset",
+ 	.microvolts		=3D 3300000,
+ 	.gpio			=3D AMS_DELTA_GPIO_PIN_MODEM_NRESET,
+ 	.startup_delay		=3D 25000,
+ 	.enable_high		=3D 1,
+ 	.enabled_at_boot	=3D 1,
+ 	.init_data		=3D &modem_nreset_data,
+ };
+=20
+ static struct platform_device modem_nreset_device =3D {
+ 	.name	=3D "reg-fixed-voltage",
+ 	.id	=3D -1,
+ 	.dev	=3D {
+ 		.platform_data	=3D &modem_nreset_config,
+ 	},
+ };
+=20
+ struct modem_private_data {
+ 	struct regulator *regulator;
+ };
+=20
+ static struct modem_private_data modem_priv;
+=20
+ void ams_delta_latch_write(int base, int ngpio, u16 mask, u16 value)
+ {
+ 	int bit =3D 0;
+ 	u16 bitpos =3D 1 << bit;
+=20
+ 	for (; bit < ngpio; bit++, bitpos =3D bitpos << 1) {
+ 		if (!(mask & bitpos))
+ 			continue;
+ 		else
+ 			gpio_set_value(base + bit, (value & bitpos) !=3D 0);
+ 	}
+ }
+ EXPORT_SYMBOL(ams_delta_latch_write);
+=20
  static struct resource ams_delta_nand_resources[] =3D {
  	[0] =3D {
  		.start	=3D OMAP1_MPUIO_BASE,
@@@ -316,14 -496,28 +491,30 @@@ static void __init ams_delta_init(void
  	ams_delta_init_fiq();
 =20
  	omap_writew(omap_readw(ARM_RSTCT1) | 0x0004, ARM_RSTCT1);
 +
 +	omapfb_set_lcd_config(&ams_delta_lcd_config);
  }
 =20
+ static void modem_pm(struct uart_port *port, unsigned int state, unsigned=
 old)
+ {
+ 	struct modem_private_data *priv =3D port->private_data;
+=20
+ 	if (IS_ERR(priv->regulator))
+ 		return;
+=20
+ 	if (state =3D=3D old)
+ 		return;
+=20
+ 	if (state =3D=3D 0)
+ 		regulator_enable(priv->regulator);
+ 	else if (old =3D=3D 0)
+ 		regulator_disable(priv->regulator);
+ }
+=20
  static struct plat_serial8250_port ams_delta_modem_ports[] =3D {
  	{
- 		.membase	=3D IOMEM(AMS_DELTA_MODEM_VIRT),
- 		.mapbase	=3D AMS_DELTA_MODEM_PHYS,
+ 		.membase	=3D IOMEM(MODEM_VIRT),
+ 		.mapbase	=3D MODEM_PHYS,
  		.irq		=3D -EINVAL, /* changed later */
  		.flags		=3D UPF_BOOT_AUTOCONF,
  		.irqflags	=3D IRQF_TRIGGER_RISING,

--Signature=_Tue__13_Mar_2012_19_21_37_+1100_GYgQcG.JggurhSBa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXwORAAoJEECxmPOUX5FEUrYP/2rzSGbucXX5nMIGckdSo1cK
jmCv6dJazo7aiAlZ98auX5NDIzj/P8MksQLImXF3yojbDbqWIyQjbYwzAX5HaXYg
l2WUWwSddVpOk5YdEfezh49vxB+mc2vHIyYONA7GTgRk/PtzHftgZwklkR8c0YfH
yVC4WXDYdrCIPqxmT3OqRlDlA8dESZTU+R1AZqp4wm+Sd3XmNAbGe/UHxbv00M7w
GXcpYkuON3K2KWArIPdko49cUIWdiTZ7U9ExsVl1Zd35kv+D8mmmExgvoMW4hCuG
n/dXwaKJavpN8DNj5iupPYsuuM6ZU8OxEsQHlFPswQeRHT2zj6eXm/nXZMQ1K/AU
+BU/SDnhjzrjh4kZMjS3klE3JLdXjbn6IeEi7SdBTXmKhmaKyrjc7xKsWgNpX4Zo
i9QSHPgsunhaVZ/6XyOqx07HxkFjQdnF9bXekODhMbNZM1kYKdHIIpjLnJgQsz1C
Kn4ABYpy4A0UIWct5MUxPath6bFVlFYqt8XgAE1CGJ07mO0bC32kKPIpc6aRI8/j
iJTNmuQ3X2GDKjnE3HRBGM9fF0YCyQ4qMCIhidxQY/SryBgKgz90VJx6lKbe3spO
Nm2JtZoYsWXwcZWXzMiSTgfJ0lL/kGZbCsasA/J5gmvSCp/AgvnUEPe8Svd9azTN
iIIW0qm+GNwr+2kuPhdG
=9vK6
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_19_21_37_+1100_GYgQcG.JggurhSBa--
