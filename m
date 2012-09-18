Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428Ab2IRC0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 22:26:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43209 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2IRC0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 22:26:16 -0400
Date: Tue, 18 Sep 2012 12:26:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the sound-asoc tree with the v4l-dvb
 tree
Message-Id: <20120918122604.be2d46aa6616f308f756ef4d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Sep_2012_12_26_04_+1000_KW6bjVagwGAobpUN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Sep_2012_12_26_04_+1000_KW6bjVagwGAobpUN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
arch/arm/mach-imx/mach-imx27_visstrim_m10.c between commit b6c14dc29757
("[media] Visstrim M10: Add support for Coda") from the v4l-dvb tree and
commit d41789b2660e ("ASoC: mx27vis: retrieve gpio numbers from
platform_data") from the sound-asoc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/mach-imx27_visstrim_m10.c
index 821d6aa,5627229..0000000
--- a/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
+++ b/arch/arm/mach-imx/mach-imx27_visstrim_m10.c
@@@ -32,6 -32,8 +32,7 @@@
  #include <linux/delay.h>
  #include <linux/dma-mapping.h>
  #include <linux/leds.h>
 -#include <linux/memblock.h>
+ #include <linux/platform_data/asoc-mx27vis.h>
  #include <media/soc_camera.h>
  #include <sound/tlv320aic32x4.h>
  #include <asm/mach-types.h>
@@@ -403,47 -436,14 +434,55 @@@ static const struct imx_ssi_platform_da
  	.flags			=3D IMX_SSI_DMA | IMX_SSI_SYN,
  };
 =20
 +/* coda */
 +
 +static void __init visstrim_coda_init(void)
 +{
 +	struct platform_device *pdev;
 +	int dma;
 +
 +	pdev =3D imx27_add_coda();
 +	dma =3D dma_declare_coherent_memory(&pdev->dev,
 +					  mx2_camera_base + MX2_CAMERA_BUF_SIZE,
 +					  mx2_camera_base + MX2_CAMERA_BUF_SIZE,
 +					  MX2_CAMERA_BUF_SIZE,
 +					  DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
 +	if (!(dma & DMA_MEMORY_MAP))
 +		return;
 +}
 +
 +/* DMA deinterlace */
 +static struct platform_device visstrim_deinterlace =3D {
 +	.name =3D "m2m-deinterlace",
 +	.id =3D 0,
 +};
 +
 +static void __init visstrim_deinterlace_init(void)
 +{
 +	int ret =3D -ENOMEM;
 +	struct platform_device *pdev =3D &visstrim_deinterlace;
 +	int dma;
 +
 +	ret =3D platform_device_register(pdev);
 +
 +	dma =3D dma_declare_coherent_memory(&pdev->dev,
 +					  mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
 +					  mx2_camera_base + 2 * MX2_CAMERA_BUF_SIZE,
 +					  MX2_CAMERA_BUF_SIZE,
 +					  DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE);
 +	if (!(dma & DMA_MEMORY_MAP))
 +		return;
 +}
 +
 +
+ /* Audio */
+ static const struct snd_mx27vis_platform_data snd_mx27vis_pdata __initcon=
st =3D {
+ 	.amp_gain0_gpio =3D AMP_GAIN_0,
+ 	.amp_gain1_gpio =3D AMP_GAIN_1,
+ 	.amp_mutel_gpio =3D AMP_MUTE_SDL,
+ 	.amp_muter_gpio =3D AMP_MUTE_SDR,
+ };
+=20
  static void __init visstrim_m10_revision(void)
  {
  	int exp_version =3D 0;

--Signature=_Tue__18_Sep_2012_12_26_04_+1000_KW6bjVagwGAobpUN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQV9u8AAoJEECxmPOUX5FEceQP/0l3OZzf6MJT2Y0Pv2vKELuQ
bvic1nIU5zhnDeFs9TzENIsXHQZ0gpJ8AOPKhflJSDSCoJF10lMclUuTn/fNuROG
r4eYEmeUHW61tPkT05guyCxXcWjE9yfZBFcK4/BZlN8h3LXYhV/XWqhFitxV+byn
k+40SU8pfgwzC8nNgP2kvmtwE7N2aGVLmQE3vmJasrdc3kKguAhDnASq1naSL+Ak
NHoTSPpIdZMpv8gozfMp05k4I9sHIqNeJBjYGzkT7YNI1Msfkve3s9cTkHGQKpC7
E/LaP8rRLlshqhy8VfNg+SzqejviJQzT9G1GEOZ2Hgk3vya0P27fUf+32Lp6gS2f
FChX5NXJQ3Lhc0sGa71unIhhOaaU293K+IeROH+YFRFhSZiuPIwkTmQUxdHIMEe9
1l9gBVM5YuklvD+2gB/gKnWk1zHhSuZHuk/ZVA2WaaRt8t/bngtgFZoalpYHY//a
POezaZyBk2kZI+ZTY5HzZ0ERPb+K4NqiMvel+ZSItpvJFWGyxXxewLzKHTSuP5xn
ETDCYmUHW+zhV19J4SBcBIamFqMFIO2J5wX53M20RYADqENxJ9nbNltMYrB/DG61
UlpFTLS4iGDMgv7c9iTBmgTEuPBob1pdjv7wSSnQBUHIFBwpQfRkmLSsFJ1uwgPG
S0flfsTvhZ8kvEb/ikN/
=c0Yq
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Sep_2012_12_26_04_+1000_KW6bjVagwGAobpUN--
