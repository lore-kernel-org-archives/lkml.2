Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab2EDPhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:37:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:42521 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2EDPhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:37:41 -0400
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lauri Leukkunen <lauri.leukkunen@nokia.com>,
        Tony Lindgren <tony@atomide.com>, Sebastian Reichel <sre@debian.org>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Ameya Palande <ameya.palande@nokia.com>
Subject: rx51: support for lis3lv02d accelerometer
Date: Fri, 04 May 2012 17:37:34 +0200
Message-ID: <1621273.5PNGJFOirm@pali>
User-Agent: KMail/4.8.2 (Linux/3.2.0-24-generic; KDE/4.8.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1381415.pOROhEfptV"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1381415.pOROhEfptV
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi!

Upstream linux kernel has already driver for lis3lv02d accelerometer
in drivers/misc/lis3lv02d. So now can be added also platform support
for nokia rx51. Patch exists for long time in meego obs repository:
https://build.pub.meego.com/package/view_file?file=3Dlinux-2.6-omap-rx5=
1-Platform-support-for-lis3lv02d-acceleromet.patch&package=3Dkernel-ada=
ptation-n900&project=3DCE%3AAdaptation%3AN900

It is possible to include this patch to upstream kernel?


diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/ma=
ch-omap2/board-rx51-peripherals.c
index d87ee06..a49801f 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -44,6 +44,7 @@
 #include <linux/leds-lp5523.h>
=20
 #include <../drivers/staging/iio/light/tsl2563.h>
+#include <linux/lis3lv02d.h>
=20
 #include "mux.h"
 #include "hsmmc.h"
@@ -63,6 +64,9 @@
 #define RX51_TSC2005_RESET_GPIO         104
 #define RX51_TSC2005_IRQ_GPIO           100
=20
+#define LIS302_IRQ1_GPIO 181
+#define LIS302_IRQ2_GPIO 180  /* Not yet in use */
+
 /* list all spi devices here */
 enum {
 =09RX51_SPI_WL1251,
@@ -73,6 +77,77 @@ enum {
 static struct wl12xx_platform_data wl1251_pdata;
 static struct tsc2005_platform_data tsc2005_pdata;
=20
+#if defined(CONFIG_SENSORS_LIS3_I2C) || defined(CONFIG_SENSORS_LIS3_I2=
C_MODULE)
+static int lis302_setup(void)
+{
+=09int err;
+=09int irq1 =3D LIS302_IRQ1_GPIO;
+=09int irq2 =3D LIS302_IRQ2_GPIO;
+
+=09/* gpio for interrupt pin 1 */
+=09err =3D gpio_request(irq1, "lis3lv02dl_irq1");
+=09if (err) {
+=09=09printk(KERN_ERR "lis3lv02dl: gpio request failed\n");
+=09=09goto out;
+=09}
+
+=09/* gpio for interrupt pin 2 */
+=09err =3D gpio_request(irq2, "lis3lv02dl_irq2");
+=09if (err) {
+=09=09gpio_free(irq1);
+=09=09printk(KERN_ERR "lis3lv02dl: gpio request failed\n");
+=09=09goto out;
+=09}
+
+=09gpio_direction_input(irq1);
+=09gpio_direction_input(irq2);
+
+out:
+=09return err;
+}
+
+static int lis302_release(void)
+{
+=09gpio_free(LIS302_IRQ1_GPIO);
+=09gpio_free(LIS302_IRQ2_GPIO);
+
+        return 0;
+}
+
+static struct lis3lv02d_platform_data rx51_lis3lv02d_data =3D {
+=09.click_flags    =3D LIS3_CLICK_SINGLE_X | LIS3_CLICK_SINGLE_Y |
+=09=09=09  LIS3_CLICK_SINGLE_Z,
+=09/* Limits are 0.5g * value */
+=09.click_thresh_x =3D 8,
+=09.click_thresh_y =3D 8,
+=09.click_thresh_z =3D 10,
+=09/* Click must be longer than time limit */
+=09.click_time_limit =3D 9,
+=09/* Kind of debounce filter */
+=09.click_latency    =3D 50,
+
+=09/* Limits for all axis. millig-value / 18 to get HW values */
+=09.wakeup_flags =3D LIS3_WAKEUP_X_HI | LIS3_WAKEUP_Y_HI,
+=09.wakeup_thresh =3D 800 / 18,
+=09.wakeup_flags2 =3D LIS3_WAKEUP_Z_HI ,
+=09.wakeup_thresh2 =3D 900 / 18,
+
+=09.hipass_ctrl =3D LIS3_HIPASS1_DISABLE | LIS3_HIPASS2_DISABLE,
+
+=09/* Interrupt line 2 for click detection, line 1 for thresholds */
+=09.irq_cfg =3D LIS3_IRQ2_CLICK | LIS3_IRQ1_FF_WU_12,
+
+=09.axis_x =3D LIS3_DEV_X,
+=09.axis_y =3D LIS3_INV_DEV_Y,
+=09.axis_z =3D LIS3_INV_DEV_Z,
+=09.setup_resources =3D lis302_setup,
+=09.release_resources =3D lis302_release,
+=09.st_min_limits =3D {-32, 3, 3},
+=09.st_max_limits =3D {-3, 32, 32},
+=09.irq2 =3D OMAP_GPIO_IRQ(LIS302_IRQ2_GPIO),
+};
+#endif
+
 #if defined(CONFIG_SENSORS_TSL2563) || defined(CONFIG_SENSORS_TSL2563_=
MODULE)
 static struct tsl2563_platform_data rx51_tsl2563_platform_data =3D {
 =09.cover_comp_gain =3D 16,
@@ -950,6 +1025,16 @@ static struct i2c_board_info __initdata rx51_peri=
pherals_i2c_board_info_2[] =3D {
 =09}
 };
=20
+static struct i2c_board_info __initdata rx51_peripherals_i2c_board_inf=
o_3[] =3D {
+#if defined(CONFIG_SENSORS_LIS3_I2C) || defined(CONFIG_SENSORS_LIS3_I2=
C_MODULE)
+=09{
+=09=09I2C_BOARD_INFO("lis3lv02d", 0x1d),
+=09=09.platform_data =3D &rx51_lis3lv02d_data,
+=09=09.irq =3D OMAP_GPIO_IRQ(LIS302_IRQ1_GPIO),
+=09},
+#endif
+};
+
 static int __init rx51_i2c_init(void)
 {
 =09if ((system_rev >=3D SYSTEM_REV_S_USES_VAUX3 && system_rev < 0x100)=
 ||
@@ -971,7 +1056,8 @@ static int __init rx51_i2c_init(void)
 =09omap_pmic_init(1, 2200, "twl5030", INT_34XX_SYS_NIRQ, &rx51_twldata=
);
 =09omap_register_i2c_bus(2, 100, rx51_peripherals_i2c_board_info_2,
 =09=09=09      ARRAY_SIZE(rx51_peripherals_i2c_board_info_2));
-=09omap_register_i2c_bus(3, 400, NULL, 0);
+=09omap_register_i2c_bus(3, 400, rx51_peripherals_i2c_board_info_3,
+=09=09=09      ARRAY_SIZE(rx51_peripherals_i2c_board_info_3));
 =09return 0;
 }
=20


--=20
Pali Roh=C3=A1r
pali.rohar@gmail.com
--nextPart1381415.pOROhEfptV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk+j974ACgkQi/DJPQPkQ1KAEwCbB6Uu6HUVm08djJyjaPXkw0gp
RkoAnRQ9C/jYEMPXB2/gB1uHDfg+Hd73
=US1P
-----END PGP SIGNATURE-----

--nextPart1381415.pOROhEfptV--

