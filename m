Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2COGKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:10:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44116 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab2COGKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:10:04 -0400
Date: Thu, 15 Mar 2012 17:09:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: linux-next: manual merge of the kmap_atomic tree with the md tree
Message-Id: <20120315170943.378ed2719af547d5b4419e6f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_17_09_43_+1100_EB+O9LecOUAXFvow"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_17_09_43_+1100_EB+O9LecOUAXFvow
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
drivers/md/bitmap.c between commit 83a191d7b09d ("md/bitmap: remove some
pointless locking") from the md tree and commit 63716d51774d ("md: remove
the second argument of k[un]map_atomic()") from the kmap_atomic tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/md/bitmap.c
index cf5863c,045e086..0000000
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@@ -426,9 -451,13 +426,9 @@@ void bitmap_update_sb(struct bitmap *bi
  		return;
  	if (bitmap->mddev->bitmap_info.external)
  		return;
 -	spin_lock_irqsave(&bitmap->lock, flags);
 -	if (!bitmap->sb_page) { /* no superblock */
 -		spin_unlock_irqrestore(&bitmap->lock, flags);
 +	if (!bitmap->sb_page) /* no superblock */
  		return;
- 	sb =3D kmap_atomic(bitmap->sb_page, KM_USER0);
 -	}
 -	spin_unlock_irqrestore(&bitmap->lock, flags);
+ 	sb =3D kmap_atomic(bitmap->sb_page);
  	sb->events =3D cpu_to_le64(bitmap->mddev->events);
  	if (bitmap->mddev->events < bitmap->events_cleared)
  		/* rocking back to read-only */
@@@ -653,11 -680,16 +653,11 @@@ static int bitmap_mask_state(struct bit
  			     enum bitmap_mask_op op)
  {
  	bitmap_super_t *sb;
 -	unsigned long flags;
  	int old;
 =20
 -	spin_lock_irqsave(&bitmap->lock, flags);
 -	if (!bitmap->sb_page) { /* can't set the state */
 -		spin_unlock_irqrestore(&bitmap->lock, flags);
 +	if (!bitmap->sb_page) /* can't set the state */
  		return 0;
- 	sb =3D kmap_atomic(bitmap->sb_page, KM_USER0);
 -	}
 -	spin_unlock_irqrestore(&bitmap->lock, flags);
+ 	sb =3D kmap_atomic(bitmap->sb_page);
  	old =3D le32_to_cpu(sb->state) & bits;
  	switch (op) {
  	case MASK_SET:
@@@ -1034,13 -1066,13 +1034,13 @@@ static int bitmap_init_from_disk(struc
  			b =3D test_bit(bit, paddr);
  		else
  			b =3D test_bit_le(bit, paddr);
- 		kunmap_atomic(paddr, KM_USER0);
+ 		kunmap_atomic(paddr);
  		if (b) {
  			/* if the disk bit is set, set the memory bit */
 -			int needed =3D ((sector_t)(i+1) << (CHUNK_BLOCK_SHIFT(bitmap))
 +			int needed =3D ((sector_t)(i+1) << bitmap->chunkshift
  				      >=3D start);
  			bitmap_set_memory_bits(bitmap,
 -					       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
 +					       (sector_t)i << bitmap->chunkshift,
  					       needed);
  			bit_cnt++;
  		}

--Signature=_Thu__15_Mar_2012_17_09_43_+1100_EB+O9LecOUAXFvow
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYYenAAoJEECxmPOUX5FEsNMP/2XIW/Vg2YJRVgQarOht4Cb8
eXCzMT8r7d4ZKx0fdbG5JWPPF//3mfGNLWTmvna3qJUP5YVcDD+0KewVs/aZfNvG
WZJkqeNo96GH40wo2lT5YF356PAx5CU884LIHIGZKMWfHBQ3sMiReRtQ6gJR8YJ/
yuy7Q/F0xKR5cu2g6IZlMU+sZvXhg/e5VMJGKggtbOIfpXgMSkQ/E3pyu7ITL9AY
TFlpcA0RTdn2en4D5lX457vZ8VPr2b8VagBLhxDo39HVoHMZUjqjrJzVatv+nqrG
yRN+Z8iOIifOBG2xXtx69FgA7DkCHsEGhP/BqWQ0xLXgoYHscl5g1MO4piDlCuTf
WJ8OQHQumAGZpZy0OSdNhzU3D3ygw4kLItwYE6oBMR1rr9oMxc2uC7l8OlFby575
TA9/NM821FwLtOUTQOoyKda4MUJSREXG7P7uyWY2NXoRuFX6CWMb4ktrF52l60vJ
wM6HtQCwTcb2YeaX5ik1sF9cL+mtlQ2YFmeH0xTzgRzMYFxsvxSlcfTHxGtKQffd
W0YN0HdPeHLpGKfYAIiK4taWxRvwBfDfXlV8hMX1sS/njQABojWJKEhzj8Nf6sf4
i7cqWX9Rd40a8oW2Rck6/gsgXsI5KrO2THqFnaRXLid6GFK/xiGOy6NBi13iWiOH
dp01osvEa6TYjJMw3znH
=7fWM
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_17_09_43_+1100_EB+O9LecOUAXFvow--
