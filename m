Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab2JJBPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:15:01 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45017 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab2JJBOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:14:49 -0400
Date: Wed, 10 Oct 2012 12:14:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20121010121437.4aa0979f4f680f16439e4955@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Oct_2012_12_14_37_+1100_BdUHvRyLD.8UUAyE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Oct_2012_12_14_37_+1100_BdUHvRyLD.8UUAyE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/block_dev.c: In function 'set_blocksize':
fs/block_dev.c:135:2: error: implicit declaration of function 'prio_tree_em=
pty' [-Werror=3Dimplicit-function-declaration]

Caused by commit b87570f5d349 ("Fix a crash when block device is read and
block size is changed at the same time") interacting with commit
147e615f83c2 ("prio_tree: remove") which is now in Linus' tree.

I have added the following merge fix patch for today (this is a mash of
tow fix patches that used to be in Andrew's tree):

From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs/block_dev.c:set_blocksize(): use mapping_mapped()

... instead of open-coding it.

Suggested-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

diff -puN fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped fs/=
block_dev.c
--- a/fs/block_dev.c~fs-block_devc-set_blocksize-use-mapping_mapped
+++ a/fs/block_dev.c
@@ -132,8 +132,7 @@ int set_blocksize(struct block_device *b
 	/* Check that the block device is not memory mapped */
 	mapping =3D bdev->bd_inode->i_mapping;
 	mutex_lock(&mapping->i_mmap_mutex);
-	if (!prio_tree_empty(&mapping->i_mmap) ||
-	    !list_empty(&mapping->i_mmap_nonlinear)) {
+	if (mapping_mapped(mapping)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
 		percpu_up_write(&bdev->bd_block_size_semaphore);
 		return -EBUSY;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Oct_2012_12_14_37_+1100_BdUHvRyLD.8UUAyE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQdMv9AAoJEECxmPOUX5FEvLYQAINj7W7rjbJyiumZjrISu73x
CreSTpfo+xZZpvdSlOiSy+5u1tmT7byQfalFynRG0kBVtn7CRxbzKDghRkscR+sM
m1+Mlg7mB96gDFULoXZwbEO/XVpDbKrJcFAuA8sNDpqZ+3kY+41q8T+idJ++EvBI
Yir1tIDQ6ZBbWMQ3n7nk408dIewjteEIFEE7NaE+cLah2Ew+TO7hiOR5WHM9GD5r
+siKa+u7Mv6xw5bj4ohtfNgYQKK85qpR6ZEIIdRhWuuE90Ou6sBjldf8LFw6L444
gjVlR50Z+ZCtLN69bvl9P7H12DYkMtv+fhPAnZ6MgdaD7CFOLYjqCd4EO1Nyzri0
5AYxc5O23PJxsjnOhv/qdmiwbOF4XTLqd6xm+ll7rRsqagecl0Znq/guRuJFoX1h
idNiD4OIGRK36jFiR87yRGd/pz9TvSDUw1tWsC7oYsX1RyXz4cHbQfwX87tJz1LW
Ab3seLQ6T0R0RuF6NMQYQykWr/qbGpP7vtzHc7KQZzmLiPUS8rzhfBIltLm+4T6t
M9QIzk7n7zddY70BQdzLiwnYXRKXqZfmxX0RqOKo5geuNS4fYad+GBzESJksAahG
OTUEBAcQd8Y7Xk7K3YoiP18K/H4axchKp3lyE6jsA24/Tns0tboFUEQEb4/N744o
8eADdUdkPwmFAimSaLfZ
=WaAV
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Oct_2012_12_14_37_+1100_BdUHvRyLD.8UUAyE--
