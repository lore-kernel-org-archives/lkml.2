Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab2GMNmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 09:42:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2GMNmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:42:02 -0400
Message-ID: <5000259D.9020303@canonical.com>
Date: Fri, 13 Jul 2012 15:41:49 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
CC: WANG Cong <xiyou.wangcong@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: x86/mm: Limit 2/4M size calculation to x86_32
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig74C41FD055F843AD9FA06986"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig74C41FD055F843AD9FA06986
Content-Type: multipart/mixed;
 boundary="------------090409070604020400040501"

This is a multi-part message in MIME format.
--------------090409070604020400040501
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

I was bisecting a problem on 64bit where any attempt to cause a crash ker=
nel to
boot would hang. The bisect ended up on commit 722bc6b (x86/mm: Fix the s=
ize
calculation of mapping tables) and somehow, looking at the calling functi=
on and
the ranges printed on boot, I think the calculations should only be done =
in the
32bit case.

On 64bit:
[    0.000000] init_memory_mapping: [mem 0x00000000-0x77e87fff]
[    0.000000]  [mem 0x00000000-0x77dfffff] page 2M
[    0.000000]  [mem 0x77e00000-0x77e87fff] page 4k

Attached patch would fix this if you agree with it. Thanks.

-Stefan


=46rom 6b679d1af20656929c0e829f29eed60b0a86a74f Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Fri, 13 Jul 2012 15:16:33 +0200
Subject: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32

commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)
did modify the extra space calculation for mapping tables in order
to make up for the first 2/4M memory range using 4K pages.
However this setup is only used when compiling for 32bit. On 64bit
there is only the trailing area of 4K pages (which is already added).

The code was already adapted once for things went wrong on a 8TB
machine (bd2753b x86/mm: Only add extra pages count for the first memory
range during pre-allocation early page table space), but it looks a bit
like it currently would overdo things for 64bit.
I only noticed while bisecting for the reason I could not make a crash
kernel boot (which ended up on this patch).

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..636bbfd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -60,10 +60,11 @@ static void __init find_early_table_space(struct map_=
range
*mr, unsigned long en
                extra =3D end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
                extra +=3D PMD_SIZE;
-#endif
+
                /* The first 2/4M doesn't use large pages. */
                if (mr->start < PMD_SIZE)
                        extra +=3D mr->end - mr->start;
+#endif

                ptes =3D (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
        } else
--=20
1.7.9.5

--------------090409070604020400040501
Content-Type: text/x-diff;
 name="0001-x86-mm-Limit-2-4M-size-calculation-to-x86_32.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-x86-mm-Limit-2-4M-size-calculation-to-x86_32.patch"

=46rom 6b679d1af20656929c0e829f29eed60b0a86a74f Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Fri, 13 Jul 2012 15:16:33 +0200
Subject: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32

commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)
did modify the extra space calculation for mapping tables in order
to make up for the first 2/4M memory range using 4K pages.
However this setup is only used when compiling for 32bit. On 64bit
there is only the trailing area of 4K pages (which is already added).

The code was already adapted once for things went wrong on a 8TB
machine (bd2753b x86/mm: Only add extra pages count for the first memory
range during pre-allocation early page table space), but it looks a bit
like it currently would overdo things for 64bit.
I only noticed while bisecting for the reason I could not make a crash
kernel boot (which ended up on this patch).

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
---
 arch/x86/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index bc4e9d8..636bbfd 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -60,10 +60,11 @@ static void __init find_early_table_space(struct map_=
range *mr, unsigned long en
 		extra =3D end - ((end>>PMD_SHIFT) << PMD_SHIFT);
 #ifdef CONFIG_X86_32
 		extra +=3D PMD_SIZE;
-#endif
+
 		/* The first 2/4M doesn't use large pages. */
 		if (mr->start < PMD_SIZE)
 			extra +=3D mr->end - mr->start;
+#endif
=20
 		ptes =3D (extra + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	} else
--=20
1.7.9.5


--------------090409070604020400040501--

--------------enig74C41FD055F843AD9FA06986
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJQACWmAAoJEOhnXe7L7s6jla4P/jwUD3b1CgtMW973NnD0/fEC
E86sp80gOMfD/pGx9VAot0w5bv9xRakyYQPBwD4XvVEYPNnp1ZKhsyhlcuawUqfJ
XKVPqA+KmGimLeEK+N8w4W7QgNaRSJqRkRPiwt+pLtiwEsRQs9CjKexeeg6JKVRa
O9usCaPR76HBBrmwyB3n/IHR4x7xFtfeAzNATCyDakSUCjLSSi0z8Go2W+DuWrFr
mcRHBVRC9va4m+oK07mO+KTYipQwX0bhKejTXUqEwB3kLmBDPjbBVcV016n+zs7a
+38+Vmz7Ufmtw1SsJ+SrCldoOl6EtoHoYpNy7y9xgbKFiXLM2KpThxPZMDnU+seV
j7tjqLfxEvNEgNGzQFb08m1wlrLqUmEKiR2upH3XopAA1k5rxs5krboMe2oB4Z4S
NbppusJ2R9UjEWkMXVbD0eR1H5KWTMMAbIZDdsowI2yGmrHD07Ty+YddpK+M2pOw
ePMifBlFqvtkiUCxczvsiMbXCHyCBdVzbjLGbQDg5bF5df8DIzFJtcqzuDHSh2ol
5+CY5gZcCq4dseHxxlN3ulmt36Fz5yTwIekHeuSireMzdlv+fIr3Y/NOdg/wGTSj
X4QIiDAlM/+G4WtZZiDqdz7RvYbCCOHBEEHpx0Wx2Sw5oiyctjz88AYGC8P5QXi2
IDTFsK0/tO1mL0iSufrd
=H4sG
-----END PGP SIGNATURE-----

--------------enig74C41FD055F843AD9FA06986--
