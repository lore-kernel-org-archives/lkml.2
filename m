Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab2DTFe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 01:34:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56214 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DTFe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 01:34:57 -0400
Date: Fri, 20 Apr 2012 15:34:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (md tree
 related)
Message-Id: <20120420153448.2257c33126add9118757791a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Apr_2012_15_34_48_+1000_Z9j4NruFnl86Xk9F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Apr_2012_15_34_48_+1000_Z9j4NruFnl86Xk9F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

drivers/built-in.o: In function `bitmap_resize':
(.text+0x202b76): undefined reference to `__udivdi3'
drivers/built-in.o: In function `bitmap_resize':
(.text+0x202bac): undefined reference to `__udivdi3'

Caused by commit 6c5cb1922cca ("md/bitmap: add bitmap_resize function to
allow bitmap resizing").

I also get these warnings:

drivers/md/bitmap.c: In function 'bitmap_resize':
drivers/md/bitmap.c:1878:11: warning: comparison of distinct pointer types =
lacks a cast [enabled by default]
drivers/md/bitmap.c:1887:11: warning: passing argument 3 of 'bitmap_get_cou=
nter' from incompatible pointer type [enabled by default]
drivers/md/bitmap.c:1225:26: note: expected 'sector_t *' but argument is of=
 type 'long int *'
drivers/md/bitmap.c:1892:12: warning: passing argument 3 of 'bitmap_get_cou=
nter' from incompatible pointer type [enabled by default]
drivers/md/bitmap.c:1225:26: note: expected 'sector_t *' but argument is of=
 type 'long int *'
drivers/md/bitmap.c:1920:8: warning: passing argument 3 of 'bitmap_get_coun=
ter' from incompatible pointer type [enabled by default]
drivers/md/bitmap.c:1225:26: note: expected 'sector_t *' but argument is of=
 type 'long int *'

I applied the patch below for the link failure, but the above warnings
should be addressed as well.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 20 Apr 2012 15:26:52 +1000
Subject: [PATCH] md/bitmap: use DIV_ROUND_UP_SECTOR_T

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/bitmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 47d5c8d..a780407 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1828,15 +1828,15 @@ int bitmap_resize(struct bitmap *bitmap, sector_t b=
locks,
 		do {
 			/* 'chunkshift' is shift from block size to chunk size */
 			chunkshift++;
-			chunks =3D DIV_ROUND_UP(blocks, 1 << chunkshift);
-			bytes =3D DIV_ROUND_UP(chunks, 8);
+			chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
+			bytes =3D DIV_ROUND_UP_SECTOR_T(chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
 				bytes +=3D sizeof(bitmap_super_t);
 		} while (bytes > (space << 9));
 	} else
 		chunkshift =3D ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
=20
-	chunks =3D DIV_ROUND_UP(blocks, 1 << chunkshift);
+	chunks =3D DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
 	memset(&store, 0, sizeof(store));
 	if (bitmap->mddev->bitmap_info.offset || bitmap->mddev->bitmap_info.file)
 		ret =3D bitmap_storage_alloc(&store, chunks,
@@ -1844,7 +1844,7 @@ int bitmap_resize(struct bitmap *bitmap, sector_t blo=
cks,
 	if (ret)
 		goto err;
=20
-	pages =3D DIV_ROUND_UP(chunks, PAGE_COUNTER_RATIO);
+	pages =3D DIV_ROUND_UP_SECTOR_T(chunks, PAGE_COUNTER_RATIO);
=20
 	new_bp =3D kzalloc(pages * sizeof(*new_bp), GFP_KERNEL);
 	ret =3D -ENOMEM;
--=20
1.7.10.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_Apr_2012_15_34_48_+1000_Z9j4NruFnl86Xk9F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPkPV4AAoJEECxmPOUX5FEP/gQAKCCdrscCuzWGlviNltzfAMk
2zihhbuIYwccPsD76o/IkJyammDpX2vPiWcg0VXHBzMbAxK7qWq1HXDGyaWFOrVr
8Pe7NYkznoZ8BXiiaFjkgrrT+J7m4g85rhnHTjJ56e7BYaJ5fXmL0UUH6D/OSTbu
CkKUWQTthikDl8sPayWkc+r2PckaAdZruCkl73oJt4gORh3sbEI1byJyr9C3Lsh2
DB23lmK+4UWM1+IAlg4tM5pnOBr73IdWbj6YTxio8u/JVSbDUi5sh+sCooFSq45F
I9NsbDBNMnGVX/XWdlnP7o8u3Lqj0fkcMPR0sShn/tXtihGnl0OR1PMFbdHFop1Q
8ZMdSisPYswUjF4GOmZuwBdF1USFdj+PYBaByF5PsV7r/uSoWCNtK3PrHztnzNmA
w+fW17KhZd82pKy1r2G12WHx54P+yjZVbK9gh/scYcBVtqTVTJMAsCcOJFxiIF68
wfJzb5KWFd/kAAhUSObBbJXgQL73xYz5GFusfE6690cFDqhsYfbtkb5BRMgGhW5k
q7ZUWzxVWfM9U5AnsYogDhhPEiCyPYMwxCdLHFhex7g6NTiSMIqlteRm5yTGQVNa
D++PuHwmcB6K2JamDPJIwB4/uYMd5573AxWUelxbQLWc5fxzQvK6m86Vjjrs/pdC
8kNZtJNjU7jNY8mF47Ad
=9r/m
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Apr_2012_15_34_48_+1000_Z9j4NruFnl86Xk9F--
