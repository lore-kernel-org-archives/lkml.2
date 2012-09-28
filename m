Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab2I1Gak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 02:30:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38280 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012Ab2I1Gaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 02:30:39 -0400
Date: Fri, 28 Sep 2012 16:30:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20120928163029.19d304240b796e2c7a7d633b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__28_Sep_2012_16_30_29_+1000_QY_CxtL1Cyn+EpeC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Sep_2012_16_30_29_+1000_QY_CxtL1Cyn+EpeC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/block_dev.c: In function 'set_blocksize':
fs/block_dev.c:135:2: error: implicit declaration of function 'prio_tree_em=
pty' [-Werror=3Dimplicit-function-declaration]

Caused by commit b87570f5d349 ("Fix a crash when block device is read and
block size is changed at the same time") from the block tree interacting
with commit "prio_tree: remove" from the akpm tree.

I added the following merge fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 28 Sep 2012 16:21:10 +1000
Subject: [PATCH] prio_tree: fix fs/block_dev.c for removal of prio_tree

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/block_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 246a81e..165b01f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -27,6 +27,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/cleancache.h>
+#include <linux/rbtree.h>
 #include <asm/uaccess.h>
 #include "internal.h"
=20
@@ -132,7 +133,7 @@ int set_blocksize(struct block_device *bdev, int size)
 	/* Check that the block device is not memory mapped */
 	mapping =3D bdev->bd_inode->i_mapping;
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!prio_tree_empty(&mapping->i_mmap) ||
+	if (!RB_EMPTY_ROOT(&mapping->i_mmap) ||
 	    !list_empty(&mapping->i_mmap_nonlinear)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
 		percpu_up_write(&bdev->bd_block_size_semaphore);
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__28_Sep_2012_16_30_29_+1000_QY_CxtL1Cyn+EpeC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQZUQGAAoJEECxmPOUX5FEr4YP/2vSQINHRf0+e73LkXpGDMh5
oq/kyNbxd5YkQw5/2gJtDMgMOvhYAnyaryTeC1IiFwiTYLIjsbigOJJDn1YS9xsL
RF7sQolkI3vWE48xNu6uaxaXa62vsAPFqVbOBeyD6671LHQ+rf7qG7HVg9HFlUJN
59/gcGrvHp55BHDUFTCy0/Bcv6kz9jXdi+RftbhXY4ewnUedau1cTRIsHvQQEtLy
94bj3iYNpzkTaKplFHToHEZhFs55c+WNt8MO2t2776ct0bsamNcajcZlr91xp3Bg
zo+zQcQ/lfbJUXdIg5XZP87/LkEuVZvqHMexrM6xEXCo/inQvosKiw8SYrlRartL
ujrC4OQ525y/hdpcaveVt44gSftkiNVwP3c9KzG5OmKRNI38YjpaVPcOBgoUJSZu
Y7FNzUPeCpwIbPYMMwV7aJi6AfadZsLoz37tR/zfdLdxFvUTROuiYVg8bLH+jUsF
ZvOEBP0fkvrsQ8cPEaMSNgunQLs8VjrML585yD2Mmk7ENPHKbzb158S+4yX2RAan
uQ7BeqO6PC/UnG6r6nKJjvFRe6gMUPGTnwNAXjZXv2R97s+xa+7i98KgsfZGzT5+
VHwAIwg7VAKhncj1c4Rde30UVJ8eyviho8WPBHQ69xr/dhmvcxaKnjXk0fyL7LAZ
SZkLKyj5Szm1krX4siz+
=oZxx
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Sep_2012_16_30_29_+1000_QY_CxtL1Cyn+EpeC--
