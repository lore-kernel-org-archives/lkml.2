Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab2JPDun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 23:50:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41679 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab2JPDul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 23:50:41 -0400
Date: Tue, 16 Oct 2012 14:50:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20121016145029.d726d08c7f18668e3cd64a0a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__16_Oct_2012_14_50_29_+1100_KAK1i2DfbLN6Dd_A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Oct_2012_14_50_29_+1100_KAK1i2DfbLN6Dd_A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/kernel/head_64.o: In function `sys64_execve':
(.text+0x1f58): relocation truncated to fit: R_SPARC_WDISP19 against symbol=
 `sys_execve' defined in .text section in fs/built-in.o
arch/sparc/kernel/head_64.o: In function `sys32_execve':
(.text+0x1f64): relocation truncated to fit: R_SPARC_WDISP19 against symbol=
 `compat_sys_execve' defined in .text section in fs/built-in.o

Probably caused by commit 3223f8aab885 ("sparc64: convert to generic
execve") and following from the signal tree.

I have added this patch you suggested on IRC:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 16 Oct 2012 14:43:51 +1100
Subject: [PATCH] sparc: fixup for conversion to generic execve

Fixes these errors:

arch/sparc/kernel/head_64.o: In function `sys64_execve':
(.text+0x1f58): relocation truncated to fit: R_SPARC_WDISP19 against symbol=
 `sys_execve' defined in .text section in fs/built-in.o
arch/sparc/kernel/head_64.o: In function `sys32_execve':
(.text+0x1f64): relocation truncated to fit: R_SPARC_WDISP19 against symbol=
 `compat_sys_execve' defined in .text section in fs/built-in.o

Dictated-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/kernel/syscalls.S |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/sparc/kernel/syscalls.S b/arch/sparc/kernel/syscalls.S
index 4bae096..f667cdf 100644
--- a/arch/sparc/kernel/syscalls.S
+++ b/arch/sparc/kernel/syscalls.S
@@ -2,15 +2,19 @@
 	 * environment settings are the same as the calling processes.
 	 */
 sys64_execve:
-	ba,pt	%xcc,sys_execve
-	 flushw
+	flushw
+	mov	%o7, %l5
+	call	sys_execve
+	 mov	%l5, %o7
=20
 #ifdef CONFIG_COMPAT
 sunos_execv:
 	mov	%g0, %o2
 sys32_execve:
-	ba,pt	%xcc,compat_sys_execve
-	 flushw
+	flushw
+	mov	%o7, %l5
+	call	compat_sys_execve
+	 mov	%l5, %o7
 #endif
=20
 	.align	32
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Oct_2012_14_50_29_+1100_KAK1i2DfbLN6Dd_A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQfNmFAAoJEECxmPOUX5FE2QMP/1tCLAxrzHwVA+u4g1JXcaTP
giYKwSP1ZGxUD+ieY1+VPhIAO+lxNN1QiYPmaiDVSf4Kd+MP10VDOA5/Kqzw6ECf
JNbpIBmS8VQ+5r0DcoO8d5ZBHzhk/MV6RZQ60lpJ4GsUTbYIdqinXj8QTHqVaDM6
r3+GTt3hznsfx9pZWV2MTvLVKCwxWFlck4f+Ckp+gjJLTYyr7UalUmTGMhfSEGUy
DH2KSkX7ke5G7CsI65IRU5g5oQqPO3ma+whcsKx8pP7q9xQmaQ3GRAu+Dv2qnWCy
5IeWJq9C9+IXIjKW3he9DXGg6oCqVkk2kRDRs/Np0Ymf6aY0Sa5YC1PI4DyCqHUE
VyWOyS+27f9GoYo9PD7xDj+1sfeBEN/QqJO9Z0ps4jVo3gpIxNpVbCSR3jcNxnup
+dLOHNg3fJmOcUy6wmjM5um98EJ/6op2Z+ICP4MwwcWzs5+Uap2miB6H8uCyYIpp
HLmkQnj2sbRULNM+O7Y/q/2/iidI6pwy/Sb4jz+2gZ5R/5IheT3q8KH1yXNde75b
jNW2V42O5JItv2723jIlBTUFSnWaXx5u0LVXU4Ic8kLCbQwJY73L66rtsbqMSnpl
a8/xrth1gTk5njpv8p/SXAnOXHuCqd/9/952WnxzBPCDDYoaJ/XTUw3EVSJm0DKT
y3Yrjl1SZGa4thzjHTHe
=v0FS
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Oct_2012_14_50_29_+1100_KAK1i2DfbLN6Dd_A--
