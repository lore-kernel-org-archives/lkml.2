Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425Ab2LDGNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 01:13:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46886 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab2LDGNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 01:13:23 -0500
Date: Tue, 4 Dec 2012 17:13:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Ma <boyu.mt@taobao.com>, Joel Becker <jlbec@evilplan.org>
Subject: linux-next: build failure after merge of the final tree (ext4 tree
 related)
Message-Id: <20121204171313.119c931c616ff2a782ab1bac@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Dec_2012_17_13_13_+1100_814qxPzSysC9YZaE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Dec_2012_17_13_13_+1100_814qxPzSysC9YZaE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

fs/ocfs2/built-in.o: In function `.walk_page_buffers':
(.text+0x2c104): multiple definition of `.walk_page_buffers'
fs/ext4/built-in.o:(.text+0x10c1c): first defined here
fs/ocfs2/built-in.o: In function `walk_page_buffers':
(.opd+0x1020): multiple definition of `walk_page_buffers'
fs/ext4/built-in.o:(.opd+0xa68): first defined here

Caused by commit c99dcc3889f5 ("ext4: add normal write support for inline
data") from the ext4 tree.  Who would have thought that a generic name
like that would clash? ;-(

Grep is your friend ...

I have added this patch for today (ocfs2 might like to apply something
similar):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 4 Dec 2012 17:06:30 +1100
Subject: [PATCH] ext4: use a less generic version of the name walk_page_buf=
fers

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/ext4/ext4.h   |    2 +-
 fs/ext4/inline.c |    2 +-
 fs/ext4/inode.c  |   20 ++++++++++----------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9e30958..b1a169a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2057,7 +2057,7 @@ int ext4_get_block(struct inode *inode, sector_t iblo=
ck,
 				struct buffer_head *bh_result, int create);
 int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
 			   struct buffer_head *bh, int create);
-int walk_page_buffers(handle_t *handle,
+int ext4_walk_page_buffers(handle_t *handle,
 			     struct buffer_head *head,
 			     unsigned from,
 			     unsigned to,
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 811457e..1fe0cc4 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -583,7 +583,7 @@ retry:
 		ret =3D __block_write_begin(page, from, to, ext4_get_block);
=20
 	if (!ret && ext4_should_journal_data(inode)) {
-		ret =3D walk_page_buffers(handle, page_buffers(page),
+		ret =3D ext4_walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
 	}
=20
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f92bd69..1a190e0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -770,7 +770,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct=
 inode *inode,
 	return NULL;
 }
=20
-int walk_page_buffers(handle_t *handle,
+int ext4_walk_page_buffers(handle_t *handle,
 			     struct buffer_head *head,
 			     unsigned from,
 			     unsigned to,
@@ -911,7 +911,7 @@ retry:
 		ret =3D __block_write_begin(page, pos, len, ext4_get_block);
=20
 	if (!ret && ext4_should_journal_data(inode)) {
-		ret =3D walk_page_buffers(handle, page_buffers(page),
+		ret =3D ext4_walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
 	}
=20
@@ -1133,7 +1133,7 @@ static int ext4_journalled_write_end(struct file *fil=
e,
 			page_zero_new_buffers(page, from+copied, to);
 		}
=20
-		ret =3D walk_page_buffers(handle, page_buffers(page), from,
+		ret =3D ext4_walk_page_buffers(handle, page_buffers(page), from,
 					to, &partial, write_end_fn);
 		if (!partial)
 			SetPageUptodate(page);
@@ -1942,7 +1942,7 @@ static int __ext4_journalled_writepage(struct page *p=
age,
 	} else {
 		page_bufs =3D page_buffers(page);
 		BUG_ON(!page_bufs);
-		walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+		ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
 	}
 	/* As soon as we unlock the page, it can go away, but we have
 	 * references to buffers so we are safe */
@@ -1962,10 +1962,10 @@ static int __ext4_journalled_writepage(struct page =
*page,
 		err =3D ext4_handle_dirty_metadata(handle, inode, inode_bh);
=20
 	} else {
-		ret =3D walk_page_buffers(handle, page_bufs, 0, len, NULL,
+		ret =3D ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
 					do_journal_get_write_access);
=20
-		err =3D walk_page_buffers(handle, page_bufs, 0, len, NULL,
+		err =3D ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL,
 					write_end_fn);
 	}
=20
@@ -1977,7 +1977,7 @@ static int __ext4_journalled_writepage(struct page *p=
age,
 		ret =3D err;
=20
 	if (!ext4_has_inline_data(inode))
-		walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
+		ext4_walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 out:
 	brelse(inode_bh);
@@ -2057,7 +2057,7 @@ static int ext4_writepage(struct page *page,
 		commit_write =3D 1;
 	}
 	page_bufs =3D page_buffers(page);
-	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
 			      ext4_bh_delay_or_unwritten)) {
 		/*
 		 * We don't want to do block allocation, so redirty
@@ -4888,7 +4888,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, str=
uct vm_fault *vmf)
 	 * journal_start/journal_stop which can block and take a long time
 	 */
 	if (page_has_buffers(page)) {
-		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+		if (!ext4_walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
 					ext4_bh_unmapped)) {
 			/* Wait so that we don't change page under IO */
 			wait_on_page_writeback(page);
@@ -4910,7 +4910,7 @@ retry_alloc:
 	}
 	ret =3D __block_page_mkwrite(vma, vmf, get_block);
 	if (!ret && ext4_should_journal_data(inode)) {
-		if (walk_page_buffers(handle, page_buffers(page), 0,
+		if (ext4_walk_page_buffers(handle, page_buffers(page), 0,
 			  PAGE_CACHE_SIZE, NULL, do_journal_get_write_access)) {
 			unlock_page(page);
 			ret =3D VM_FAULT_SIGBUS;
--=20
1.7.10.280.gaa39

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Dec_2012_17_13_13_+1100_814qxPzSysC9YZaE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQvZR5AAoJEECxmPOUX5FE1g0P/1Du0f2YOxiLWsBI9unwDDVq
Pr3/veq4p/vXITDDr/23gRrB3NvPonWi882GXx+6T+kw3mvM9UJaqVyBOmDwvKBe
+vW7SRw1MhRUfnV1x8thDfq7wAYCseA7SK0U2vC8bwD54vLx4dqbSYLomjv4yda9
mZHebwcSBn7oJvEW2pbPc+QRQ/zOaB6mBPo4WZ/00IoZTRJaRnVrwC/2KaVUPKxy
DclhMs31XhAMH0i/KV2cQ106xVfI/iJhZkw4KwQpM+tNx7yswho45A+nn0clGrk9
5bfQhSubr428T4DJD9DCuge9aO/IL+1/J0UZNSlkUw4+DaPuE2QuacF8XaPqXrwT
iiHUXP7wZjaLV2P045FC6H6ZZM4UTMnqC3F6yzwppJnSJlUohnw1l2hE1wYnyims
oWX+r/l0bDX4UC7CBcAsC3+GZrvl8Qf3PbIzXmg2Pr9J4EkI1YohKZC6A40nXuvv
3q4iUW759iLUn/PyCm9qp3BvePnWTVAWmN6gqoIdU5Erg26JLhXPVtjsPXZKZU9n
iQWDNsp6dzZ7UdBBtzop68pGwYU9Z65/ykfvCoH7So/j4pJuCqHaSJfZo/uZtCKd
0vupulr5f8gSzg6UHJHNY+BkgvLLHEF6b1+vFaoYqo6b88Ams7XeKi/ped+FPFnT
440KmaBh0xiIl7T72wFc
=LLL5
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Dec_2012_17_13_13_+1100_814qxPzSysC9YZaE--
