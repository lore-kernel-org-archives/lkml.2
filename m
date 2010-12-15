Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750858Ab0LOFE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 00:04:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47130 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab0LOFE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 00:04:57 -0500
Date: Wed, 15 Dec 2010 16:04:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Reiser <jreiser@BitWagon.com>, Wu Zhangjin <wuzhangjin@gmail.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: ftrace/MIPS related x86_64 build failure on in Linus' tree
Message-Id: <20101215160440.bafbe38c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Dec_2010_16_04_40_+1100_4JSF4A6+jLeVEwKB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Dec_2010_16_04_40_+1100_4JSF4A6+jLeVEwKB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Since October 31 our x86_64 allmodconfig builds have been failing like this:

/opt/crosstool/gcc-4.4.3-nolibc/x86_64-linux/bin/x86_64-linux-ld: arch/x86/=
ia32/sys_ia32.o: bad reloc symbol index (0x1000000 >=3D 0x6b) for offset 0x=
808080 in section `__mcount_loc'
arch/x86/ia32/sys_ia32.o: could not read symbols: Bad value

and many similar
(http://fandango2.ozlabs.ibm.com/kisskb/buildresult/3423985/).  I finally
got around to bisecting it and it comes down to this commit:

a2d49358ba9bc93204dc001d5568c5bdb299b77d is the first bad commit
commit a2d49358ba9bc93204dc001d5568c5bdb299b77d
Author: John Reiser <jreiser@BitWagon.com>
Date:   Wed Oct 27 18:59:07 2010 +0800

    ftrace/MIPS: Add MIPS64 support for C version of recordmcount
   =20
    MIPS64 has 'weird' Elf64_Rel.r_info[1,2], which must be used instead of
    the generic Elf64_Rel.r_info, otherwise, the C version of recordmcount
    will not work for "segmentation fault".
   =20
    Usage of "union mips_r_info" and the functions MIPS64_r_sym() and
    MIPS64_r_info() written by Maciej W. Rozycki <macro@linux-mips.org>
   =20
    ----
    [1] http://techpubs.sgi.com/library/manuals/4000/007-4658-001/pdf/007-4=
658-001.pdf
    [2] arch/mips/include/asm/module.h
   =20
    Tested-by: Wu Zhangjin <wuzhangjin@gmail.com>
    Signed-off-by: John Reiser <jreiser@BitWagon.com>
    Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
    LKML-Reference: <AANLkTinwXjLAYACUfhLYaocHD_vBbiErLN3NjwN8JqSy@mail.gma=
il.com>
    LKML-Reference: <910dc2d5ae1ed042df4f96815fe4a433078d1c2a.1288176026.gi=
t.wuzhangjin@gmail.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

:040000 040000 c208c976b8bd3eb28791d0e96dcb24967586fbb0 28da1214674ed267e0c=
4aa249379504bc8b20216 M	scripts

This seems to be tool chain specific.  We are using a PowerPC hosted
x86_64 cross compiler:

x86_64-linux-gcc (GCC) 4.4.3
GNU ld (GNU Binutils) 2.20

[It does *not* fail for our x86_64 hosted x86_64 compiler:

x86_64-linux-gcc (GCC) 4.4.4
GNU ld (GNU Binutils) 2.20
]

I tried reverting that commit (and the next commit
412910cd046c1f14f0fba9c0aec401d47e57dcd1 "ftrace/MIPS: Add module support
for C version of recordmcount" because of conflicts) and the build of
Linus' current tree now succeeds with the above toolchain,

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Dec_2010_16_04_40_+1100_4JSF4A6+jLeVEwKB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNCExoAAoJEDMEi1NhKgbsUx0H/AjYUNWHptNr8AS5zq2e+0xr
iRgQPTpXK43PBrWLFg0BEXIGN8n5Ybl8T2Sj+GfRIz1Xp6eQl0Htxt6d3K75sGrv
CzL3t742UswDA/5xOG9pvuAhVN3mMrFO7YOJ53xSsitlY4NqLVNiBf2m/G5IvrT8
0ct9e91X3775Xpbui6zPGTAJK7qi1BfYmuZgOYHKyzVV9ACavSlDDUTEwQVpsKZP
valCRkrqeXYd+7FcyS+cKv5aZ1JfGmOVf/UNVV/uIOfVRyDd7ZV9/L8peTHo8hMV
NHSsnoKJxwxQ+jq4LcZvfV0CzAqlI64LNbDo4v5haoBkEWPYjrx49BP5HgqlaqA=
=3XzQ
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Dec_2010_16_04_40_+1100_4JSF4A6+jLeVEwKB--
