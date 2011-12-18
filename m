Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab1LRX4H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:56:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:46636 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1LRXzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:55:51 -0500
Date: Mon, 19 Dec 2011 10:55:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>, Russell King <rmk@arm.linux.org.uk>,
        Richard Zhao <richard.zhao@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111219105548.d30839e148800b38bc93d001@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Dec_2011_10_55_48_+1100_sN0kNfrDQCdScJvE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Dec_2011_10_55_48_+1100_sN0kNfrDQCdScJvE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-imx/mach-imx6q.c between commit 1237f0f6ecf6 ("ARM: 7198/1:
arm/imx6: add restart support for imx6q") from the arm tree and commit
477fce49aef4 ("arm/imx6q-sabrelite: add enet phy ksz9021rn fixup") from
the arm-soc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mach-imx6q.c
index 05b49bb,bee6334..0000000
--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@@ -16,9 -14,10 +16,11 @@@
  #include <linux/irq.h>
  #include <linux/irqdomain.h>
  #include <linux/of.h>
 +#include <linux/of_address.h>
  #include <linux/of_irq.h>
  #include <linux/of_platform.h>
+ #include <linux/phy.h>
+ #include <linux/micrel_phy.h>
  #include <asm/hardware/cache-l2x0.h>
  #include <asm/hardware/gic.h>
  #include <asm/mach/arch.h>
@@@ -26,38 -25,27 +28,57 @@@
  #include <mach/common.h>
  #include <mach/hardware.h>
 =20
 +void imx6q_restart(char mode, const char *cmd)
 +{
 +	struct device_node *np;
 +	void __iomem *wdog_base;
 +
 +	np =3D of_find_compatible_node(NULL, NULL, "fsl,imx6q-wdt");
 +	wdog_base =3D of_iomap(np, 0);
 +	if (!wdog_base)
 +		goto soft;
 +
 +	imx_src_prepare_restart();
 +
 +	/* enable wdog */
 +	writew_relaxed(1 << 2, wdog_base);
 +	/* write twice to ensure the request will not get ignored */
 +	writew_relaxed(1 << 2, wdog_base);
 +
 +	/* wait for reset to assert ... */
 +	mdelay(500);
 +
 +	pr_err("Watchdog reset failed to assert reset\n");
 +
 +	/* delay to allow the serial port to show the message */
 +	mdelay(50);
 +
 +soft:
 +	/* we'll take a jump through zero as a poor second */
 +	soft_restart(0);
 +}
 +
+ /* For imx6q sabrelite board: set KSZ9021RN RGMII pad skew */
+ static int ksz9021rn_phy_fixup(struct phy_device *phydev)
+ {
+ 	/* min rx data delay */
+ 	phy_write(phydev, 0x0b, 0x8105);
+ 	phy_write(phydev, 0x0c, 0x0000);
+=20
+ 	/* max rx/tx clock delay, min rx/tx control delay */
+ 	phy_write(phydev, 0x0b, 0x8104);
+ 	phy_write(phydev, 0x0c, 0xf0f0);
+ 	phy_write(phydev, 0x0b, 0x104);
+=20
+ 	return 0;
+ }
+=20
  static void __init imx6q_init_machine(void)
  {
+ 	if (of_machine_is_compatible("fsl,imx6q-sabrelite"))
+ 		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
+ 					   ksz9021rn_phy_fixup);
+=20
  	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 =20
  	imx6q_pm_init();

--Signature=_Mon__19_Dec_2011_10_55_48_+1100_sN0kNfrDQCdScJvE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7n2EAAoJEECxmPOUX5FEq2MP/2K5YOnlT/PCvTdYRKv+ICkX
CBFG0Q/f7AIQA2ABwolhUNVToujXb/m9dt6yzkdhsuD5juRuGjYeo0CTqwI2UARY
s5QVg8R5aNBxmAUABelUfc2WASLJ4RsQwI33p0K2Alofl7Eg47GlINu095y9z53y
OJW36SPG3PCSnsvg9qmUxB5Xm8AWEbIQEX65OeumW/zr94nsVtUyPkyc9ZejXIkP
S8BupJGLtGdYtVhMEs+hUGZZOZOZTMFqMhvL5TOGBLGKXRIGzwsv36cKmbYQHqFD
MmHAtY+f6sZuWdbCRWY5Do1DNAhO7+NuJgubfisI5cu2+JoEvkLdbfisN/TYY9Cu
OQ1xD1btm+lAuQoqDTZ3zQBGp2lPcBffdcFGFxCBE9CC0RaFCce9OTqh3ov+mpS3
8G19Eb6Wk9pv2x/JAllSA1Aln0fHP4vppa9qarQyeqUPUqJ/v23PfTrf6Veq1a+5
vGZd/sho3Lb40lj3WrcNeJnAXqukOQu+lJPRH2qfmimUkV4U5kcKVqdHjmzB5OZ5
bV4SS/FgTBjYpeCcahaOLkTfjsFl1Ft71+yC/oTvinSdfZVcGjCASPQe/MjsbCd9
vaDhxQqaqkrdJVD9sXnyRAOC3MiMx/KddLoG84OfLa6Zjm72VO2KiVgp9mqm02D1
OW37PhtTUyAhD66JL/OB
=A+u2
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Dec_2011_10_55_48_+1100_sN0kNfrDQCdScJvE--
