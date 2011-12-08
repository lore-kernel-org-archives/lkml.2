Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1LHABU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 19:01:20 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51549 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1LHABT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 19:01:19 -0500
Date: Thu, 8 Dec 2011 11:00:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-lpae tree with the arm tree
Message-Id: <20111208110059.1d88730db9358e079949b89c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Dec_2011_11_00_59_+1100_BBhR3wDf_ZUBoeTB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Dec_2011_11_00_59_+1100_BBhR3wDf_ZUBoeTB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

Today's linux-next merge of the arm-lpae tree got a conflict in
arch/arm/mm/idmap.c between commits 8903826d0cd9 ("ARM: idmap: populate
identity map pgd at init time using .init.text") and 4e8ee7de227e ("ARM:
SMP: use idmap_pgd for mapping MMU enable during secondary booting") from
the arm tree and commit 1932aa1edc86 ("ARM: LPAE: Add identity mapping
support for the 3-level page table format") from the arm-lpae tree.

I tried to fix it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mm/idmap.c
index 660f1bc,267db72..0000000
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@@ -1,13 -1,34 +1,38 @@@
  #include <linux/kernel.h>
 =20
  #include <asm/cputype.h>
 +#include <asm/idmap.h>
  #include <asm/pgalloc.h>
  #include <asm/pgtable.h>
 +#include <asm/sections.h>
 +
 +pgd_t *idmap_pgd;
 =20
+ #ifdef CONFIG_ARM_LPAE
+ static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long e=
nd,
+ 	unsigned long prot)
+ {
+ 	pmd_t *pmd;
+ 	unsigned long next;
+=20
+ 	if (pud_none_or_clear_bad(pud) || (pud_val(*pud) & L_PGD_SWAPPER)) {
+ 		pmd =3D pmd_alloc_one(&init_mm, addr);
+ 		if (!pmd) {
+ 			pr_warning("Failed to allocate identity pmd.\n");
+ 			return;
+ 		}
+ 		pud_populate(&init_mm, pud, pmd);
+ 		pmd +=3D pmd_index(addr);
+ 	} else
+ 		pmd =3D pmd_offset(pud, addr);
+=20
+ 	do {
+ 		next =3D pmd_addr_end(addr, end);
+ 		*pmd =3D __pmd((addr & PMD_MASK) | prot);
+ 		flush_pmd_entry(pmd);
+ 	} while (pmd++, addr =3D next, addr !=3D end);
+ }
+ #else	/* !CONFIG_ARM_LPAE */
  static void idmap_add_pmd(pud_t *pud, unsigned long addr, unsigned long e=
nd,
  	unsigned long prot)
  {

--Signature=_Thu__8_Dec_2011_11_00_59_+1100_BBhR3wDf_ZUBoeTB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3/47AAoJEECxmPOUX5FEOREP/jrw/rlK85UdifJzEPy0UbtC
MnS2eD193EA1M6Rw9GSVG9vRhok7SnVArf1Gz0W9en1XK9LKJqYzI8rmWUFkVGgL
Xcd0G8NGXJkXeUFbA7bMKXgajrUIm3vjdYnHyeqCLCEr1My9170547EGXemNlpQ+
kAoxUvgW3k1JfrAgoETOrPMJzQDNl13s3hqGX9rfckcRzDJ+ue/A6E9oQFB0VqtT
I6o8xzGLT4C2622buXT4maDy/PPfcesorYNvFNnMqEFdBqtKv6sTZlWuder1ViFt
pHE9BaeYWLpXXyWC6tpaMG/hScRdzqcqmNcBPfwhyUrSy9KJjLzq0ttD2xjez7t/
qx8pEIFhtZBnkKZJGtpn/IYLRRmZbIj27kv4w1hrT9xT+zLk+j2cOSHb770sts7Y
kuoVIYGrz4w2g609Cehg6hSMjMfsbFAdMWQlCGbfLPNt0IWqsngbXIdRcvUCrnFp
KdZkWiw8toAo98wGoqN7rCrL1Aerhum1/G/xT2Lbconr3pJfifoITvESx/U4gPBk
ByNdN/wbw1Y/Cb+iC4+bXS7R9Rlz0L8Z9qDYoLiua0QY3LdcERHrXGVKxCC2r2lO
QpwtWRZHUOmH3PNyhyZCefesDhP3DcyIv//pxgdAujeeafdGS40KNrnN+aTFcgL4
wWurKJcdiGTYXOFQ0EbH
=olmj
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Dec_2011_11_00_59_+1100_BBhR3wDf_ZUBoeTB--
