Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab1KVCCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:02:16 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:35687 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1KVCCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:02:15 -0500
Date: Tue, 22 Nov 2011 13:01:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111122130159.ba1426acb6e340c6f906d9b5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Nov_2011_13_01_59_+1100__.sNxPwnDpO9xNGQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Nov_2011_13_01_59_+1100__.sNxPwnDpO9xNGQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-exynos/cpu.c between commit db0d4db22a78 ("ARM: gic: allow
GIC to support non-banked setups") from the  tree and commit fae3f1696b33
("ARM: EXYNOS: Enable conversion of GIC dt irq specifier to linux virq")
from the s5p tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/cpu.c
index 6e34485,8e09f34..0000000
--- a/arch/arm/mach-exynos/cpu.c
+++ b/arch/arm/mach-exynos/cpu.c
@@@ -206,6 -231,24 +230,13 @@@ void __init exynos4_init_clocks(int xta
  	exynos4_setup_clocks();
  }
 =20
 -static void exynos4_gic_irq_fix_base(struct irq_data *d)
 -{
 -	struct gic_chip_data *gic_data =3D irq_data_get_irq_chip_data(d);
 -
 -	gic_data->cpu_base =3D S5P_VA_GIC_CPU +
 -			    (gic_bank_offset * smp_processor_id());
 -
 -	gic_data->dist_base =3D S5P_VA_GIC_DIST +
 -			    (gic_bank_offset * smp_processor_id());
 -}
 -
+ #ifdef CONFIG_OF
+ static const struct of_device_id exynos4_dt_irq_match[] =3D {
+ 	{ .compatible =3D "arm,cortex-a9-gic", .data =3D gic_of_init, },
+ 	{},
+ };
+ #endif
+=20
  void __init exynos4_init_irq(void)
  {
  	int irq;
@@@ -213,8 -255,17 +244,13 @@@
 =20
  	gic_bank_offset =3D soc_is_exynos4412() ? 0x4000 : 0x8000;
 =20
- 	gic_init_bases(0, IRQ_PPI(0), S5P_VA_GIC_DIST, S5P_VA_GIC_CPU, gic_bank_=
offset);
+ 	if (!of_have_populated_dt())
 -		gic_init(0, IRQ_PPI(0), S5P_VA_GIC_DIST, S5P_VA_GIC_CPU);
++		gic_init_bases(0, IRQ_PPI(0), S5P_VA_GIC_DIST, S5P_VA_GIC_CPU, gic_bank=
_offset);
+ #ifdef CONFIG_OF
+ 	else
+ 		of_irq_init(exynos4_dt_irq_match);
+ #endif
 =20
 -	gic_arch_extn.irq_eoi =3D exynos4_gic_irq_fix_base;
 -	gic_arch_extn.irq_unmask =3D exynos4_gic_irq_fix_base;
 -	gic_arch_extn.irq_mask =3D exynos4_gic_irq_fix_base;
 -
  	for (irq =3D 0; irq < MAX_COMBINER_NR; irq++) {
 =20
  		combiner_init(irq, (void __iomem *)S5P_VA_COMBINER(irq),

--Signature=_Tue__22_Nov_2011_13_01_59_+1100__.sNxPwnDpO9xNGQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOywKXAAoJEECxmPOUX5FE7ocP/iP4lYn4GyQTCT+1pShHHZJV
HFo/EpSeKxBoBAGfQ6B+FpRtF6QGFifAfAcWtcVUZYP1uYrMB7IG8jCGDWOtq0Wa
K1aSUSyK1BJyNL5E9lyvFt3zl+T5ErzAvGGpUf1val5wU5O/dlyMdf00Ww3tK+BA
s4SYlo6Rb7RY+GyD8JtXrvw9cui5Q+r53Iki9HU/K+q1COTMqis7udOxJ/QT0Q1X
9j75MtUtyepu0XjB9+r4im6TLQ6DUvNDxrzgi7ZUS9G5c+rtONgc8jHJDJlYcbqi
7L0tC6ziNCYwzhrJwFCYzGchYx6/4opCowWz7IU8LZKAYC3FA2J+vRNdyir7nqVw
KRfCHrTeZZpSiPJgaI0puN5zROhH40e7mAwN62sNducJEq2ynMnYu1hlz26t1qDi
ig9O5XBQsG4dpf/8pWo2AAKX6XesCXsUvwTU0dmZNbnaLnhdQ2m9ZLhkKxYVmhvX
FJBEU3knQDK6NdjHjqxMzrqvY+rJLJy1RMJJoYx/jrVBZ3qngJIaVFeZvfqRj5cT
soTxiBEmljL7ZLhJquLviJxNOTMbPy3M+u2R7MPHP11C7bUJ8qdXC/gqcuYq8RgF
HCXOI97PAOaEnpkayULLw5SFyiUAwK6zvgo9WZJ0ti7dhU/g2pim5NMKAS617xcT
/3Ys/6WPaApkae7/n8sR
=R1YZ
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Nov_2011_13_01_59_+1100__.sNxPwnDpO9xNGQ--
