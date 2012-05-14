Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab2ENXjC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 19:39:02 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36946 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab2ENXjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 19:39:00 -0400
Message-ID: <4FB1978E.4020904@gmail.com>
Date: Tue, 15 May 2012 01:38:54 +0200
From: =?UTF-8?B?VmxhZGltaXIgJ8+GLWNvZGVyL3BoY29kZXInIFNlcmJpbmVua28=?= 
	<phcoder@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH V2] Fix minixfs size check
References: <4FAFBBC7.9020101@gmail.com> <20120514221948.GV5353@quack.suse.cz> <4FB18850.8090704@gmail.com> <20120514230240.GZ5353@quack.suse.cz>
In-Reply-To: <20120514230240.GZ5353@quack.suse.cz>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig6FC13098D43C26F8870FC0B6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6FC13098D43C26F8870FC0B6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


>   Oh, right. Then your patch should be OK, just it's enough to cast one=
 of
> the arguments to u64.

I know. I just consider it clearer and less risk to lose it in the future=
=2E
Moreover it avoids thinking of how much is really needed

> And BTW looking at minix, it should also set
> s_maxbytes to s_max_size. Otherwise it will be always limited by
> MAX_NON_LFS which is 2^31-1.


Patch here:

 minixfs file size check is buggy and it doesn't allow
 creating a block which can't be fully filled

Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
---
 fs/minix/inode.c    |    1 +
 fs/minix/itree_v1.c |    3 ++-
 fs/minix/itree_v2.c |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index fcb05d2..133bb02 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -227,6 +227,7 @@ static int minix_fill_super(struct super_block *s, vo=
id *data, int silent)
 	} else
 		goto out_no_fs;
=20
+	s->s_maxbytes =3D sbi->s_max_size;
 	/*
 	 * Allocate the buffer map to keep the superblock small.
 	 */
diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 282e15a..4f8f8b2 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -29,7 +29,8 @@ static int block_to_path(struct inode * inode, long blo=
ck, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
 			block, bdevname(inode->i_sb->s_bdev, b));
-	} else if (block >=3D (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {=

+	} else if ((u64) block * (u64) BLOCK_SIZE
+		   >=3D minix_sb(inode->i_sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index 13487ad..4a9a19d 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -32,7 +32,8 @@ static int block_to_path(struct inode * inode, long blo=
ck, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
 			block, bdevname(sb->s_bdev, b));
-	} else if (block >=3D (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksiz=
e)) {
+	} else if ((u64) block * (u64) sb->s_blocksize
+		   >=3D minix_sb(inode->i_sb)->s_max_size) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %s\n",


--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


--------------enig6FC13098D43C26F8870FC0B6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iF4EAREKAAYFAk+xl44ACgkQNak7dOguQgmbdAEAoXH/qaQ3lgdS6nFnmaARx/GH
WGWpbP07lNYFUx8nH1YBAJCO0MTkN0KBb64ctMVzq2qxrMMhAJnxdW2fw7xnrrvq
=HAjI
-----END PGP SIGNATURE-----

--------------enig6FC13098D43C26F8870FC0B6--
