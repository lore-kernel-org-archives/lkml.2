Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab2CMInB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:43:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58911 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2CMIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:42:58 -0400
Date: Tue, 13 Mar 2012 19:42:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120313194243.4b330327115d48b34bc556c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Mar_2012_19_42_43_+1100_FlCr39PFBk5c25Rg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Mar_2012_19_42_43_+1100_FlCr39PFBk5c25Rg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-vexpress/ct-ca9x4.c between commit e9f07fbc5f5b ("ARM:
plat-versatile: convert to twd_local_timer_register() interface") from
the arm tree and commit 98ed4ceb93ba ("ARM: vexpress: Get rid of
MMIO_P2V") from the arm-soc tree.

I fixed it up (I think - see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-vexpress/ct-ca9x4.c
index b391538,73791f0..0000000
--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ b/arch/arm/mach-vexpress/ct-ca9x4.c
@@@ -54,44 -42,17 +42,28 @@@ static struct map_desc ct_ca9x4_io_desc
  static void __init ct_ca9x4_map_io(void)
  {
  	iotable_init(ct_ca9x4_io_desc, ARRAY_SIZE(ct_ca9x4_io_desc));
 -#ifdef CONFIG_LOCAL_TIMERS
 -	twd_base =3D ioremap(A9_MPCORE_TWD, SZ_32);
 -#endif
  }
 =20
 +#ifdef CONFIG_HAVE_ARM_TWD
 +static DEFINE_TWD_LOCAL_TIMER(twd_local_timer, A9_MPCORE_TWD, IRQ_LOCALTI=
MER);
 +
 +static void __init ca9x4_twd_init(void)
 +{
 +	int err =3D twd_local_timer_register(&twd_local_timer);
 +	if (err)
 +		pr_err("twd_local_timer_register failed %d\n", err);
 +}
 +#else
 +#define ca9x4_twd_init()	do {} while(0)
 +#endif
 +
  static void __init ct_ca9x4_init_irq(void)
  {
- 	gic_init(0, 29, MMIO_P2V(A9_MPCORE_GIC_DIST),
- 		 MMIO_P2V(A9_MPCORE_GIC_CPU));
+ 	gic_init(0, 29, ioremap(A9_MPCORE_GIC_DIST, SZ_4K),
+ 		 ioremap(A9_MPCORE_GIC_CPU, SZ_256));
 +	ca9x4_twd_init();
  }
 =20
- #if 0
- static void __init ct_ca9x4_timer_init(void)
- {
- 	writel(0, MMIO_P2V(CT_CA9X4_TIMER0) + TIMER_CTRL);
- 	writel(0, MMIO_P2V(CT_CA9X4_TIMER1) + TIMER_CTRL);
-=20
- 	sp804_clocksource_init(MMIO_P2V(CT_CA9X4_TIMER1), "ct-timer1");
- 	sp804_clockevents_init(MMIO_P2V(CT_CA9X4_TIMER0), IRQ_CT_CA9X4_TIMER0,
- 		"ct-timer0");
- }
-=20
- static struct sys_timer ct_ca9x4_timer =3D {
- 	.init	=3D ct_ca9x4_timer_init,
- };
- #endif
-=20
  static void ct_ca9x4_clcd_enable(struct clcd_fb *fb)
  {
  	v2m_cfg_write(SYS_CFG_MUXFPGA | SYS_CFG_SITE_DB1, 0);

--Signature=_Tue__13_Mar_2012_19_42_43_+1100_FlCr39PFBk5c25Rg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPXwiDAAoJEECxmPOUX5FE5u0QAJxFk4u8WZXF3sZrq5JyvWr0
lIRAcC/+smEobyPtcsykd3vse0a1A1KmD6ob32DurNxexiGh4Qs9hHGFXaZvK0/Y
aNdivAunfA4B3eZWHe8EJBP/vm4LLIaNVeoU8zLXOLbIBrmTossI52b36wY/981N
W9+Ot8a00AD1avUftGk0gy7R3ZFayw4RSvoCLgaxtAfAOmQZenrW7G63bt0z5lWb
yy4E6IjX51U+BPQnjgDpCQM8bcy+/aLwAe3Hk9o5NIAtkKXzoj9NuYcBKt0zXdek
cXRTTbc9+eySCVUun34mx/xF2X6rfhFa42enfz1wSFGA3cJW2QR8t0x1xK66iEFt
Qo5ZSomdeAVNPcemdtUHyrZLfdEpDHlTycW5cnmCguTIs4CCnhzn3giGlqVOOXaT
35SGXlgzQFSSrAH7reTsCVEzPeE9FjUrOMFfBDKh04HaFOqXrXXaiC/wY1BX1zQs
oxuJrsEV5JIZFoVSqoTjovMUm5NTvPXbReZmgQoishfj8jyhH2DBdR2aGFZ3qbNb
6fT9OWadaSKV00aj1J+AJApUfb758Uk2UGjlqUFtD53iIIdYav9nYjN5/mxi+d3V
ld777jnURsoikJU0l3Cxn1v8PoQfaFcTE0TCKrnmwp8sOnmo715gJczs6oN2eOU3
QTbqjB1tGiWDhEdRi+oX
=3I2R
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Mar_2012_19_42_43_+1100_FlCr39PFBk5c25Rg--
