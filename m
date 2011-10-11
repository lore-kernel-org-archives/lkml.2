Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1JKEnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 00:43:24 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41629 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JKEnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 00:43:23 -0400
Date: Tue, 11 Oct 2011 15:43:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        Misael Lopez Cruz <misael.lopez@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>
Subject: linux-next: manual merge of the sound tree with the arm-soc tree
Message-Id: <20111011154304.f7fefc4f7f86b4b10348578c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_15_43_04_+1100_FX=7aUQFssi/xrcp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_15_43_04_+1100_FX=7aUQFssi/xrcp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
arch/arm/plat-omap/devices.c between commit 40246e0003f0 ("ARM: OMAP:
mcbsp: Move out omap_mcbsp_register_board_cfg from plat-omap/devices")
from the arm-soc tree and commit d231f5cbac9e ("OMAP: McPDM: Convert
McPDM device to omap_device") from the sound tree.

Just overlapping removals.  I fixed it up (see below) and can carry the
fix as necessary.

Mark, Liam:  That sound tree commit has a few Signed-off-by lines with no
email addresses.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-omap/devices.c
index acd132c,40eca9b..0000000
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@@ -24,44 -24,56 +24,11 @@@
  #include <plat/tc.h>
  #include <plat/board.h>
  #include <plat/mmc.h>
 -#include <mach/gpio.h>
  #include <plat/menelaus.h>
 -#include <plat/mcbsp.h>
  #include <plat/omap44xx.h>
 =20
- #if defined(CONFIG_SND_OMAP_SOC_MCPDM) || \
- 		defined(CONFIG_SND_OMAP_SOC_MCPDM_MODULE)
-=20
- static struct resource mcpdm_resources[] =3D {
- 	{
- 		.name		=3D "mcpdm_mem",
- 		.start		=3D OMAP44XX_MCPDM_BASE,
- 		.end		=3D OMAP44XX_MCPDM_BASE + SZ_4K,
- 		.flags		=3D IORESOURCE_MEM,
- 	},
- 	{
- 		.name		=3D "mcpdm_irq",
- 		.start		=3D OMAP44XX_IRQ_MCPDM,
- 		.end		=3D OMAP44XX_IRQ_MCPDM,
- 		.flags		=3D IORESOURCE_IRQ,
- 	},
- };
-=20
- static struct platform_device omap_mcpdm_device =3D {
- 	.name		=3D "omap-mcpdm",
- 	.id		=3D -1,
- 	.num_resources	=3D ARRAY_SIZE(mcpdm_resources),
- 	.resource	=3D mcpdm_resources,
- };
-=20
- static void omap_init_mcpdm(void)
- {
- 	(void) platform_device_register(&omap_mcpdm_device);
- }
- #else
- static inline void omap_init_mcpdm(void) {}
- #endif
-=20
  /*-----------------------------------------------------------------------=
--*/
 =20
 -#if defined(CONFIG_OMAP_MCBSP) || defined(CONFIG_OMAP_MCBSP_MODULE)
 -
 -static struct platform_device **omap_mcbsp_devices;
 -
 -void omap_mcbsp_register_board_cfg(struct resource *res, int res_count,
 -			struct omap_mcbsp_platform_data *config, int size)
 -{
 -	int i;
 -
 -	omap_mcbsp_devices =3D kzalloc(size * sizeof(struct platform_device *),
 -				     GFP_KERNEL);
 -	if (!omap_mcbsp_devices) {
 -		printk(KERN_ERR "Could not register McBSP devices\n");
 -		return;
 -	}
 -
 -	for (i =3D 0; i < size; i++) {
 -		struct platform_device *new_mcbsp;
 -		int ret;
 -
 -		new_mcbsp =3D platform_device_alloc("omap-mcbsp", i + 1);
 -		if (!new_mcbsp)
 -			continue;
 -		platform_device_add_resources(new_mcbsp, &res[i * res_count],
 -					res_count);
 -		new_mcbsp->dev.platform_data =3D &config[i];
 -		ret =3D platform_device_add(new_mcbsp);
 -		if (ret) {
 -			platform_device_put(new_mcbsp);
 -			continue;
 -		}
 -		omap_mcbsp_devices[i] =3D new_mcbsp;
 -	}
 -}
 -
 -#else
 -void omap_mcbsp_register_board_cfg(struct resource *res, int res_count,
 -			struct omap_mcbsp_platform_data *config, int size)
 -{  }
 -#endif
 -
 -/*-----------------------------------------------------------------------=
--*/
 -
  #if defined(CONFIG_MMC_OMAP) || defined(CONFIG_MMC_OMAP_MODULE) || \
  	defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
 =20

--Signature=_Tue__11_Oct_2011_15_43_04_+1100_FX=7aUQFssi/xrcp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk8lYAAoJEECxmPOUX5FETc8P/j8Zt28T0PJZjZZ5MGVUp5va
urnTqS7VxG6bRCq7wmQpnGVtO7AwzclXIgpCh5T0kVCVRm0nVWAbh2hBT5gSwV2l
T9FN45Z+SAyqbSfrOuxGde7zk0yYevSVi7/K0WOv70kO6lPby9P8ZQQbz+zzTRMh
td6qPrAMz0EakUz68PkMBGmRhm7pOd0AnQLdAiDC92/BRtF4cIuids404PM033xm
25ek1hNjFschRH7mXInd8gfMC8ykoSAaf9w3taSKLELxys0vtZOoJeJeoces3Qfp
I3dsEOt8RvnQwtl/6QZRdquS735h9jN15+vzpFJSVulwPfZnSY9jAl19M2hengD0
2k8G2m2+XrnbCl/93AU08RVcrnRBADuvLP6zeDf26MqsbMmTI+bsuQWxNv0rPjLz
l62Em9JqFCTEJtXxNWDQhP2GZykX4OdD6ywu+WvYdQrFMgiqkAzy2CkDuVB1e3v/
aHf1Nbvs3FOyiJnBnpqaRzrJQexNZa+LG91FYcJJeUVkhry9cmo/bdfhHuWTq3+n
Ldtow+scyM2gE8tN91HchwSRhr8Ms7zBVR7lsWyvre1DOu8jtPrfO7mPMdp/gkbR
w829NjhUc61R3eH6IbZL1v89x/YDif5cqJ7cxsQLBecwre19p7XtAX/GLIVxamOg
y2gfcchTvtciD2FOpmep
=lHKP
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_15_43_04_+1100_FX=7aUQFssi/xrcp--
