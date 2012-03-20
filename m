Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183Ab2CTD2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:28:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33754 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2CTD2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:28:21 -0400
Date: Tue, 20 Mar 2012 14:28:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suzuki Poulose <suzuki@in.ibm.com>, tony@bakeyournoodle.com,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the pci tree (actually
 powerpc tree related)
Message-Id: <20120320142808.dbc31fedf291bb3cc8cdecaa@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Mar_2012_14_28_08_+1100_FnJYFwK0dpcQ69xV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Mar_2012_14_28_08_+1100_FnJYFwK0dpcQ69xV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

After merging the pci tree, today's linux-next build (powerpc ppc64_defconf=
ig)
failed like this:

powerpc64-linux-ld: section .text loaded at [0000000000e00000,0000000000e07=
21b] overlaps section .kernel:dtb loaded at [0000000000e00000,0000000000e00=
66f]

I have applied this patch for today (thanks to Tony Breeds and David
Gibson):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 20 Mar 2012 14:13:51 +1100
Subject: [PATCH] powerpc: do not adjust the load address for ps3

Commit c55aef0e5bc6 "powerpc/boot: Change the load address for the wrapper
to fit the kernel" adjusted the laod address if the uncompressed kernel
was too large.  Ps3 does not compress the kernel and uses a different
linker script, so do not adjust the load address in that case.

fixes this build error:

powerpc64-linux-ld: section .text loaded at [0000000000e00000,0000000000e07=
21b] overlaps section .kernel:dtb loaded at [0000000000e00000,0000000000e00=
66f]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/boot/wrapper |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index f090e6d..6761c74 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -144,6 +144,7 @@ tmp=3D$tmpdir/zImage.$$.o
 ksection=3D.kernel:vmlinux.strip
 isection=3D.kernel:initrd
 link_address=3D'0x400000'
+make_space=3Dy
=20
 case "$platform" in
 pseries)
@@ -210,6 +211,7 @@ ps3)
     ksection=3D.kernel:vmlinux.bin
     isection=3D.kernel:initrd
     link_address=3D''
+    make_space=3Dn
     pie=3D
     ;;
 ep88xc|ep405|ep8248e)
@@ -278,17 +280,19 @@ else
     rm -f $vmz.$$
 fi
=20
-# Round the size to next higher MB limit
-round_size=3D$(((strip_size + 0xfffff) & 0xfff00000))
+if [ "$make_space" =3D "y" ]; then
+	# Round the size to next higher MB limit
+	round_size=3D$(((strip_size + 0xfffff) & 0xfff00000))
=20
-round_size=3D0x$(printf "%x" $round_size)
-link_addr=3D$(printf "%d" $link_address)
+	round_size=3D0x$(printf "%x" $round_size)
+	link_addr=3D$(printf "%d" $link_address)
=20
-if [ $link_addr -lt $strip_size ]; then
-    echo "INFO: Uncompressed kernel (size 0x$(printf "%x\n" $strip_size))"=
 \
-		"overlaps the address of the wrapper($link_address)"
-    echo "INFO: Fixing the link_address of wrapper to ($round_size)"
-    link_address=3D$round_size
+	if [ $link_addr -lt $strip_size ]; then
+	    echo "INFO: Uncompressed kernel (size 0x$(printf "%x\n" $strip_size))=
" \
+			"overlaps the address of the wrapper($link_address)"
+	    echo "INFO: Fixing the link_address of wrapper to ($round_size)"
+	    link_address=3D$round_size
+	fi
 fi
=20
 vmz=3D"$vmz$gzip"
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Mar_2012_14_28_08_+1100_FnJYFwK0dpcQ69xV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZ/lIAAoJEECxmPOUX5FEhksP/RV7htc5S61w9acxVSFNmNJg
J1a5QYZqQJg5QmC7EjrKGXomMmW63EQ4om9qC4g/vVbthKH1N72S3VlJAi50IJVH
3KOQtCVKE3D/2QUeYBh5ZixTsOgDKqsddmbIdqgT6SmjAWjFflNaJxtV+geYhce3
F4LLCU5k+wBCDgOzf5e7zaWLvwp1n/m+4lTcW6TIW0Hvaxep/JLrj3ApJ75Du7E1
T5vulllPpMDUm9G5qIAGS4fgSfzjnily0qCbZHX3J+gm4VOHH3KpQLvA65IAw7ti
eUG///w4JhFjoST4dKh+iURaA63lQYUTssBjqEJOfs1RI/6NBuz0CQLUrtAyRPVX
WOSBDpPWl8VtnCYTym4Fec/+IdyWKZL1mkb5XHLyg0I829mOKru6yffQjmkkNmV1
9htpExEYe9gr3H83WefHrGVcpSzCZwBxT8JUTUPQ93H8Iv9t8TLgYcryzWhfOPyR
m426OCm4oAwb6Mzsr+a7sZGQ7i4jwnG4DM3RqXrZ7OI+/VA+LfwP9BJ3+7EkgkDL
4Yh7cocWZn7ARJOkpVBMaNpb04VFAPMGGdFooXPwNUXerSUm2wsUOtRTS0kZLPKu
AIIg7aFarx0crVsM4DmVjw3Lvy4oP5iuUB8CUd35xUb1tSZ0y2BZTvQ0uLkTVptN
tcsIsTepiBP6Z22YVy2u
=T6EO
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Mar_2012_14_28_08_+1100_FnJYFwK0dpcQ69xV--
