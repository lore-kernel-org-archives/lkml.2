Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab1KAIQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 04:16:16 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47100 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1KAIQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 04:16:14 -0400
Date: Tue, 1 Nov 2011 19:16:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Ma <boyu.mt@taobao.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20111101191602.bb64237e8ab87671d3964ca9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_19_16_02_+1100_ZYtQiD8_.hz2cykh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_19_16_02_+1100_ZYtQiD8_.hz2cykh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/direct-io.c between commit eb28be2b4c0a ("direct-io: separate fields
only used in the submission path from struct dio") from Linus' tree and
commit "fs/direct-io.c: salcuate fs_count correctly in get_more_blocks()"
from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/direct-io.c
index d740ab6,b05f24e..0000000
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@@ -575,14 -564,13 +575,13 @@@ static inline int dio_bio_reap(struct d
   * buffer_mapped().  However the direct-io code will only process holes o=
ne
   * block at a time - it will repeatedly call get_block() as it walks the =
hole.
   */
 -static int get_more_blocks(struct dio *dio)
 +static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 +			   struct buffer_head *map_bh)
  {
  	int ret;
 -	struct buffer_head *map_bh =3D &dio->map_bh;
  	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
+ 	sector_t fs_endblk;	/* Into file, in filesystem-sized blocks */
  	unsigned long fs_count;	/* Number of filesystem-sized blocks */
- 	unsigned long dio_count;/* Number of dio_block-sized blocks */
- 	unsigned long blkmask;
  	int create;
 =20
  	/*
@@@ -591,13 -579,10 +590,10 @@@
  	 */
  	ret =3D dio->page_errors;
  	if (ret =3D=3D 0) {
 -		BUG_ON(dio->block_in_file >=3D dio->final_block_in_request);
 -		fs_startblk =3D dio->block_in_file >> dio->blkfactor;
 -		fs_endblk =3D (dio->final_block_in_request - 1) >> dio->blkfactor;
 +		BUG_ON(sdio->block_in_file >=3D sdio->final_block_in_request);
 +		fs_startblk =3D sdio->block_in_file >> sdio->blkfactor;
- 		dio_count =3D sdio->final_block_in_request - sdio->block_in_file;
- 		fs_count =3D dio_count >> sdio->blkfactor;
- 		blkmask =3D (1 << sdio->blkfactor) - 1;
- 		if (dio_count & blkmask)=09
- 			fs_count++;
++		fs_endblk =3D (sdio->final_block_in_request - 1) >> sdio->blkfactor;
+ 		fs_count =3D fs_endblk - fs_startblk + 1;
 =20
  		map_bh->b_state =3D 0;
  		map_bh->b_size =3D fs_count << dio->inode->i_blkbits;

--Signature=_Tue__1_Nov_2011_19_16_02_+1100_ZYtQiD8_.hz2cykh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr6rCAAoJEECxmPOUX5FE8xMP/1UGsktqrQ3z9xEmqfLy2/GN
eY4qACetBXaOub6A3gnL2p32YV9Uen4rrjT1WxF9YrMeOHQVIpqbkEAOU12AfOBE
H9dpxBt4qannNPed3agiZYpimMKZDbV/QLthWnhBezeWxG7CmbBwAetG8J2qeVIO
uzvVbFcK5sxMEQnedZWUimr7Z+KI31kWGewnIzyA6DFfSRMi5IZq3adK8AN+yFIJ
UTFTiU+uxggjnUT8+VeHPfrP3hEGy9rQHYODjsEmyZU3iNO0t2l7oPzY2wkUQlIp
ftgLse1/QAkCZyBhxtMCNUF9zcIlcnHb0Y9/rNVCIhJTIlnP8c3kkBrNKI/bf0mO
VFCe8mZ+5vtdq3ZSGugEKhP+FlOtaizxf9UyCgzcWZIe8olTdLDt5bHmEi9l816v
WNGwrh9St6DLgzuDO9HLDvLiDRqT+Ty6lu+71gl1IGYp3XmMnC7yyWMgGnCwXwIG
agdpm7O194DlRh694nvSc9mmUYA5mHHejzQJCS9LiX+8d6zHkh2wJV8B01h4BAbg
N1z8Ny62Fn+TPReTgFHxczw1fVYu81K+Joikvm+cl/mgtLIdwsDmbvbHO7d6YA65
G5UCY915yDlPokeHhRy/HG2qYdUv4y+gUC2jwMKDohVaNORo0TRZQg0Iuu6bxDaz
XXsItQMGWLlAFRE2LU2B
=AGUA
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_19_16_02_+1100_ZYtQiD8_.hz2cykh--
