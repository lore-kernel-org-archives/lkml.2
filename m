Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3AIC63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 21:58:29 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56648 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3AIC61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 21:58:27 -0500
Date: Wed, 9 Jan 2013 13:58:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Will Deacon <will.deacon@arm.com>, Joseph Lo <josephl@nvidia.com>
Subject: linux-next: manual merge of the tegra tree with the  tree
Message-Id: <20130109135816.2d65e46e24391fb56a09fd76@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Jan_2013_13_58_16_+1100_ojUUvToXxb0g=+9e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Jan_2013_13_58_16_+1100_ojUUvToXxb0g=+9e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/headsmp.S between commit bc4f1bdabc89 ("ARM:
coresight: common definition for (OS) Lock Access Register key value")
from the arm-perf tree and commit 2a3eb5bc45bd ("ARM: tegra: make device
can run on UP") from the tegra tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/headsmp.S
index b154213,fd473f2..0000000
--- a/arch/arm/mach-tegra/headsmp.S
+++ b/arch/arm/mach-tegra/headsmp.S
@@@ -1,67 -1,9 +1,11 @@@
  #include <linux/linkage.h>
  #include <linux/init.h>
 =20
- #include <asm/cache.h>
- #include <asm/asm-offsets.h>
- #include <asm/hardware/cache-l2x0.h>
 +#include <asm/hardware/coresight.h>
 +
- #include "flowctrl.h"
- #include "iomap.h"
- #include "reset.h"
  #include "sleep.h"
 =20
- #define APB_MISC_GP_HIDREV	0x804
- #define PMC_SCRATCH41	0x140
-=20
- #define RESET_DATA(x)	((TEGRA_RESET_##x)*4)
-=20
          .section ".text.head", "ax"
- 	__CPUINIT
-=20
- /*
-  * Tegra specific entry point for secondary CPUs.
-  *   The secondary kernel init calls v7_flush_dcache_all before it enables
-  *   the L1; however, the L1 comes out of reset in an undefined state, so
-  *   the clean + invalidate performed by v7_flush_dcache_all causes a bun=
ch
-  *   of cache lines with uninitialized data and uninitialized tags to get
-  *   written out to memory, which does really unpleasant things to the ma=
in
-  *   processor.  We fix this by performing an invalidate, rather than a
-  *   clean + invalidate, before jumping into the kernel.
-  */
- ENTRY(v7_invalidate_l1)
-         mov     r0, #0
-         mcr     p15, 2, r0, c0, c0, 0
-         mrc     p15, 1, r0, c0, c0, 0
-=20
-         ldr     r1, =3D0x7fff
-         and     r2, r1, r0, lsr #13
-=20
-         ldr     r1, =3D0x3ff
-=20
-         and     r3, r1, r0, lsr #3  @ NumWays - 1
-         add     r2, r2, #1          @ NumSets
-=20
-         and     r0, r0, #0x7
-         add     r0, r0, #4          @ SetShift
-=20
-         clz     r1, r3              @ WayShift
-         add     r4, r3, #1          @ NumWays
- 1:      sub     r2, r2, #1          @ NumSets--
-         mov     r3, r4              @ Temp =3D NumWays
- 2:      subs    r3, r3, #1          @ Temp--
-         mov     r5, r3, lsl r1
-         mov     r6, r2, lsl r0
-         orr     r5, r5, r6          @ Reg =3D (Temp<<WayShift)|(NumSets<<=
SetShift)
-         mcr     p15, 0, r5, c7, c6, 2
-         bgt     2b
-         cmp     r2, #0
-         bgt     1b
-         dsb
-         isb
-         mov     pc, lr
- ENDPROC(v7_invalidate_l1)
-=20
 =20
  ENTRY(tegra_secondary_startup)
          bl      v7_invalidate_l1

--Signature=_Wed__9_Jan_2013_13_58_16_+1100_ojUUvToXxb0g=+9e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ7NzIAAoJEECxmPOUX5FE2zUP/1Wv5K0lb3DvHEXn9OerqxCf
lIogzCldzLc+pfOCOo5oVNm8pw0ZEyld99ZLULgtomH5eYEvPJ+VcZMqp+CCGnOz
/XIeVR4k8iAKQOcW8N2fBXV2slTjCllYTsFft18CGX3fwRpmlfY0Cj1qM81xG+tU
9Q+vPTkMXHCBFj3W0+siLIKKD5p2kny1t4pKr+FPWLJyuKauYJJKwN4A+qNULhcH
TnDemucLaQieRjgaThdnfD/Asp6JQUKKmfTvTmO5ppL+Rt5PqjhY1E85ob3lG+q0
0ncoq1rjXykxIRmbzqiOkb+XqeKshaRlwEIM85WK/3POT+akH0+Pm3+XVVcuXJNQ
pY5At3wWvxDSSO3EJC2FsnE6Qges6xM7La9IsuXtPQHToxkPMbguPDD+pXel6a3g
5/uTSt+cFErPzD+507HbOBeY1tfbH7ULIVSLwXxuQObewRNWwhevCghzN3TceS4n
o0+TwQ4kJcmaEVjgVp/wscXi++sXnvPOumNX59q84A2wvfaCPyuQHYCW+QNZC7HT
q82oQh+1651pXIJ95TNHMs9/xs+Si3fDFlOCXEAip40lSgef4FXP/KWyJYzf91t7
eX9qcFb2RX8N2ciirULtEmel8zHrNPMinyjKVKD/MQV7v0K+TwWlCqBe/gJgIFXx
1QudWlpzvivLKM9aiTmi
=Hm+f
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Jan_2013_13_58_16_+1100_ojUUvToXxb0g=+9e--
