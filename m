Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005Ab2ENIkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:40:05 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43539 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab2ENIkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:40:03 -0400
Date: Mon, 14 May 2012 18:39:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120514183947.58e82b8bff52d7f0476dfc11@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_18_39_47_+1000_QhRxi1Ann3NOKXNu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_18_39_47_+1000_QhRxi1Ann3NOKXNu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-omap/counter_32k.c between commit bd0493eaaf5c ("ARM:
7413/1: move read_{boot,persistent}_clock to the architecture level")
from the arm tree and commit 1fe97c8f6a1d ("ARM: OMAP: Make OMAP
clocksource source selection using kernel param") from the arm-soc tree.

I attempted to fix it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-omap/counter_32k.c
index 44ae077,b2f634b..0000000
--- a/arch/arm/plat-omap/counter_32k.c
+++ b/arch/arm/plat-omap/counter_32k.c
@@@ -69,55 -69,40 +70,41 @@@ static void omap_read_persistent_clock(
  	*ts =3D *tsp;
  }
 =20
- int __init omap_init_clocksource_32k(void)
+ /**
+  * omap_init_clocksource_32k - setup and register counter 32k as a
+  * kernel clocksource
+  * @pbase: base addr of counter_32k module
+  * @size: size of counter_32k to map
+  *
+  * Returns 0 upon success or negative error code upon failure.
+  *
+  */
+ int __init omap_init_clocksource_32k(void __iomem *vbase)
  {
- 	static char err[] __initdata =3D KERN_ERR
- 			"%s: can't register clocksource!\n";
-=20
- 	if (cpu_is_omap16xx() || cpu_class_is_omap2()) {
- 		u32 pbase;
- 		unsigned long size =3D SZ_4K;
- 		void __iomem *base;
- 		struct clk *sync_32k_ick;
-=20
- 		if (cpu_is_omap16xx()) {
- 			pbase =3D OMAP16XX_TIMER_32K_SYNCHRONIZED;
- 			size =3D SZ_1K;
- 		} else if (cpu_is_omap2420())
- 			pbase =3D OMAP2420_32KSYNCT_BASE + 0x10;
- 		else if (cpu_is_omap2430())
- 			pbase =3D OMAP2430_32KSYNCT_BASE + 0x10;
- 		else if (cpu_is_omap34xx())
- 			pbase =3D OMAP3430_32KSYNCT_BASE + 0x10;
- 		else if (cpu_is_omap44xx())
- 			pbase =3D OMAP4430_32KSYNCT_BASE + 0x10;
- 		else
- 			return -ENODEV;
-=20
- 		/* For this to work we must have a static mapping in io.c for this area=
 */
- 		base =3D ioremap(pbase, size);
- 		if (!base)
- 			return -ENODEV;
-=20
- 		sync_32k_ick =3D clk_get(NULL, "omap_32ksync_ick");
- 		if (!IS_ERR(sync_32k_ick))
- 			clk_enable(sync_32k_ick);
-=20
- 		timer_32k_base =3D base;
-=20
- 		/*
- 		 * 120000 rough estimate from the calculations in
- 		 * __clocksource_updatefreq_scale.
- 		 */
- 		clocks_calc_mult_shift(&persistent_mult, &persistent_shift,
- 				32768, NSEC_PER_SEC, 120000);
-=20
- 		if (clocksource_mmio_init(base, "32k_counter", 32768, 250, 32,
- 					  clocksource_mmio_readl_up))
- 			printk(err, "32k_counter");
-=20
- 		setup_sched_clock(omap_32k_read_sched_clock, 32, 32768);
- 		register_persistent_clock(NULL, omap_read_persistent_clock);
+ 	int ret;
+=20
+ 	/*
+ 	 * 32k sync Counter register offset is at 0x10
+ 	 */
+ 	sync32k_cnt_reg =3D vbase + OMAP2_32KSYNCNT_CR_OFF;
+=20
+ 	/*
+ 	 * 120000 rough estimate from the calculations in
+ 	 * __clocksource_updatefreq_scale.
+ 	 */
+ 	clocks_calc_mult_shift(&persistent_mult, &persistent_shift,
+ 			32768, NSEC_PER_SEC, 120000);
+=20
+ 	ret =3D clocksource_mmio_init(sync32k_cnt_reg, "32k_counter", 32768,
+ 				250, 32, clocksource_mmio_readl_up);
+ 	if (ret) {
+ 		pr_err("32k_counter: can't register clocksource\n");
+ 		return ret;
  	}
+=20
+ 	setup_sched_clock(omap_32k_read_sched_clock, 32, 32768);
++	register_persistent_clock(NULL, omap_read_persistent_clock);
+ 	pr_info("OMAP clocksource: 32k_counter at 32768 Hz\n");
+=20
  	return 0;
  }

--Signature=_Mon__14_May_2012_18_39_47_+1000_QhRxi1Ann3NOKXNu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsMTTAAoJEECxmPOUX5FEdQ8QAKMTp1BjLxJzaqOgxLahY0z9
Fj/+KcdHp2Ay6UkN/uVmIg09L1tNE5sES5Im851NwiDPr66AD4NwMk5MjjcCoIU7
ASseJidSODaK4oV+gOiT9pWoSVOoUANuC4nbSGplq4GmyIYmPgwkGkgPBRFBpkzf
yE7v7A+6YitEL1pQIKLLIHaUrftfGgJh4qGlQMpi8gfRgeMuCLjO3HP6ekQgerC8
sIrlfQb3senXEPSZpVJqcuNLH8Uk608PSDwgjcvdQyO6EQVLjVTbgQhZpt9wastH
zQAOU4tRsrD/+H0Fn5FAqzaHZUwxwIkW3pJmGisXRixS7uJKDgjrgviZcQ3YT2dK
26Ka8eOUiJTa5JgvQcZDsrTUgXhh+32y7Eotr5ncv1xNbtGb4NLCMOoLqbg9ZJXz
Mb/p2zSYemR/+K8zkQH2NBKO1tMAMpYBRAVMhU575bLnePkzSWkiSBiOU++6iH9O
zigZh/CQtg58ZRtdw7rUoU6UYMo7qrFug4eiaeRjoEgR5gHxaWcC4qpNextEka+T
vSg1Nn6evbZLy/UItfeHsY/Oo6vxDm3B36kP5f98utsRWH3bCAhwM/hOJievPvRq
pXJuEKGvIo18hZPrRZz35mERJ5LYDQkWzghRjUyjTUSxRd6XJ7yKO6YfF2jI48J/
1W1XcFtqf7GFH+Ry/NE5
=kSxt
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_18_39_47_+1000_QhRxi1Ann3NOKXNu--
