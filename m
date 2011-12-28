Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750863Ab1L1FGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 00:06:13 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:54086 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab1L1FGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 00:06:10 -0500
Date: Wed, 28 Dec 2011 16:05:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the driver-core tree with the s5p tree
Message-Id: <20111228160559.778fb178a9e9a8d938dc98b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_16_05_59_+1100_l4nMClGxi0_ANyye"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_16_05_59_+1100_l4nMClGxi0_ANyye
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
arch/arm/mach-s3c2440/clock.c between commit 0cfb26e1fb9d ("ARM: SAMSUNG:
register uart clocks to clock lookup list") from the s5p tree and commit
4a858cfc9af8 ("arm: convert sysdev_class to a regular subsystem") from
the driver-core tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c2440/clock.c
index c9879af,d895759..0000000
--- a/arch/arm/mach-s3c2440/clock.c
+++ b/arch/arm/mach-s3c2440/clock.c
@@@ -110,47 -107,7 +109,47 @@@ static struct clk s3c2440_clk_ac97 =3D=20
  	.ctrlbit	=3D S3C2440_CLKCON_CAMERA,
  };
 =20
 +static unsigned long  s3c2440_fclk_n_getrate(struct clk *clk)
 +{
 +	unsigned long ucon0, ucon1, ucon2, divisor;
 +
 +	/* the fun of calculating the uart divisors on the s3c2440 */
 +	ucon0 =3D __raw_readl(S3C24XX_VA_UART0 + S3C2410_UCON);
 +	ucon1 =3D __raw_readl(S3C24XX_VA_UART1 + S3C2410_UCON);
 +	ucon2 =3D __raw_readl(S3C24XX_VA_UART2 + S3C2410_UCON);
 +
 +	ucon0 &=3D S3C2440_UCON0_DIVMASK;
 +	ucon1 &=3D S3C2440_UCON1_DIVMASK;
 +	ucon2 &=3D S3C2440_UCON2_DIVMASK;
 +
 +	if (ucon0 !=3D 0)
 +		divisor =3D (ucon0 >> S3C2440_UCON_DIVSHIFT) + 6;
 +	else if (ucon1 !=3D 0)
 +		divisor =3D (ucon1 >> S3C2440_UCON_DIVSHIFT) + 21;
 +	else if (ucon2 !=3D 0)
 +		divisor =3D (ucon2 >> S3C2440_UCON_DIVSHIFT) + 36;
 +	else
 +		/* manual calims 44, seems to be 9 */
 +		divisor =3D 9;
 +
 +	return clk_get_rate(clk->parent) / divisor;
 +}
 +
 +static struct clk s3c2440_clk_fclk_n =3D {
 +	.name		=3D "fclk_n",
 +	.parent		=3D &clk_f,
 +	.ops		=3D &(struct clk_ops) {
 +		.get_rate	=3D s3c2440_fclk_n_getrate,
 +	},
 +};
 +
 +static struct clk_lookup s3c2440_clk_lookup[] =3D {
 +	CLKDEV_INIT(NULL, "clk_uart_baud1", &s3c24xx_uclk),
 +	CLKDEV_INIT(NULL, "clk_uart_baud2", &clk_p),
 +	CLKDEV_INIT(NULL, "clk_uart_baud3", &s3c2440_clk_fclk_n),
 +};
 +
- static int s3c2440_clk_add(struct sys_device *sysdev)
+ static int s3c2440_clk_add(struct device *dev)
  {
  	struct clk *clock_upll;
  	struct clk *clock_h;

--Signature=_Wed__28_Dec_2011_16_05_59_+1100_l4nMClGxi0_ANyye
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+qO3AAoJEECxmPOUX5FE6Q8P/19U7Fw+Uvn5fSZex1rlrwOF
fnCoVMXhpzMsRWkrChJ7OAVz1YcpBRIVYbCMdjroOG2uAyDdxUQV9bpfwCK8Oc8L
wZcnMDMdpd8aAXVryTDjSP0PfzaQjs+gpTs6lWd2KpCKiTtB8SQuax6LXNz0a0BM
b45wvhlgjMAg/kbJVrbK3lT6FmiZDOKRNEpYZVfsa2xpGvnAJshYemns7qU+2E2H
z5aBJyGjJXgPKXhPsxai9CgeKXS0D104vMRU0pYxeVTTjkbQjMHYsDwkRWWw+FLs
qzvrAoLAe0w+WdLF+dy++Pw98k8ZmNODPsnd9VkP5C4zkNeO829KcFXSC2o9en69
jjusAY80y4iKkLYxwYyUcCRqZh6wy0OojPfaUOSc+cLF/GJOrgLgy0GosZ3b0JYs
4HCYUg0fvAogt86MOqKlz1nSuV8598KBU1fFR9gsPFzKghHk9Dx2qIWVPOW8oUeK
JbijyXuAE118kUszvfRbKU8K1Sr5EI2vqa5E/fNC78eh54Q+gAW3lmJkc9allDaw
8r0msmo1eXNFmaceGD0TtfYaqDjGrsXMc47yj2plulm3yr26C25aNb3/enrAWtVQ
MKPkYYM7lT7ccZk1pIidv+SI7qWaLXESBMKvtVffSpE1IQGybUrwrIyBmCEjIfvE
065d/oguRG+SNqfBiBcJ
=jvdc
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_16_05_59_+1100_l4nMClGxi0_ANyye--
