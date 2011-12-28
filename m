Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074Ab1L1Bsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 20:48:45 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50660 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1L1Bso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 20:48:44 -0500
Date: Wed, 28 Dec 2011 12:48:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        =?UTF-8?B?IkrDtnJuIEVuZ2VsIg==?= <joern@logfs.org>
Subject: linux-next: manual merge of the l2-mtd tree with the logfs tree
Message-Id: <20111228124833.80c36e5660fdd9fe0c8481ba@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_12_48_33_+1100_oUI0VuHxxxlLvn9h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_12_48_33_+1100_oUI0VuHxxxlLvn9h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
fs/logfs/dev_mtd.c between commit d1cc3ad397f2 ("Logfs: Allow NULL
block_isbad() methods") from the  tree and commit 22aed0c2578c ("mtd:
introduce mtd_block_isbad interface") from the l2-mtd tree.

I fixed it up (see below) and can carry the fix as necessary.  I am a
little worried that the block_isbad member of struct mtd_info may be
hidden in the future and so break the NULL checks here.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/logfs/dev_mtd.c
index d054d7e,136c736..0000000
--- a/fs/logfs/dev_mtd.c
+++ b/fs/logfs/dev_mtd.c
@@@ -147,16 -150,17 +150,16 @@@ static struct page *logfs_mtd_find_firs
  {
  	struct logfs_super *super =3D logfs_super(sb);
  	struct address_space *mapping =3D super->s_mapping_inode->i_mapping;
- 	filler_t *filler =3D mtd_readpage;
+ 	filler_t *filler =3D logfs_mtd_readpage;
  	struct mtd_info *mtd =3D super->s_mtd;
 =20
 -	if (!mtd->block_isbad)
 -		return NULL;
 -
  	*ofs =3D 0;
 -	while (mtd_block_isbad(mtd, *ofs)) {
 -		*ofs +=3D mtd->erasesize;
 -		if (*ofs >=3D mtd->size)
 -			return NULL;
 +	if (mtd->block_isbad) {
- 		while (mtd->block_isbad(mtd, *ofs)) {
++		while (mtd_block_isbad(mtd, *ofs)) {
 +			*ofs +=3D mtd->erasesize;
 +			if (*ofs >=3D mtd->size)
 +				return NULL;
 +		}
  	}
  	BUG_ON(*ofs & ~PAGE_MASK);
  	return read_cache_page(mapping, *ofs >> PAGE_SHIFT, filler, sb);
@@@ -166,16 -170,17 +169,16 @@@ static struct page *logfs_mtd_find_last
  {
  	struct logfs_super *super =3D logfs_super(sb);
  	struct address_space *mapping =3D super->s_mapping_inode->i_mapping;
- 	filler_t *filler =3D mtd_readpage;
+ 	filler_t *filler =3D logfs_mtd_readpage;
  	struct mtd_info *mtd =3D super->s_mtd;
 =20
 -	if (!mtd->block_isbad)
 -		return NULL;
 -
  	*ofs =3D mtd->size - mtd->erasesize;
 -	while (mtd_block_isbad(mtd, *ofs)) {
 -		*ofs -=3D mtd->erasesize;
 -		if (*ofs <=3D 0)
 -			return NULL;
 +	if (mtd->block_isbad) {
- 		while (mtd->block_isbad(mtd, *ofs)) {
++		while (mtd_block_isbad(mtd, *ofs)) {
 +			*ofs -=3D mtd->erasesize;
 +			if (*ofs <=3D 0)
 +				return NULL;
 +		}
  	}
  	*ofs =3D *ofs + mtd->erasesize - 0x1000;
  	BUG_ON(*ofs & ~PAGE_MASK);

--Signature=_Wed__28_Dec_2011_12_48_33_+1100_oUI0VuHxxxlLvn9h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+nVxAAoJEECxmPOUX5FE3zQQAJJMb3q5MnBpFisb7yGeyhkb
+gr3s3TMH+PCA95bjaAq93/Fc1Brwp6AFD64ekRlN+9RtCo3O912qwWsmVE90jmv
Kp/1vRNpr/7FoRWD/K0haOWi5AqY+TZgyCNXEu2DJHC2kNKMxtSFx7ciXQPNqNlg
4DBMbFZTogPlj2TDiZTrgwK6HqMxD+/oC/A86yOJ4YwcI5IiD+c5pcrGFKpsnClI
T24jgiVy2bqslg2iLzKdjLdr/jRxECXTRMvEdQyFQhaIhKstc7rgZS5Y9jrJ3ZQI
UHGS78rqu1EFQM1QT6E+thJoZPQw8HhvLzYaFjibuq99EUOgW72ZckbUncpRtDJa
zJkJunHqKCkWBftVL43yjok3VP5tJWcxY3rQ99RYWM9/kqHq1m0Ea8RsgbqdbHR7
3iqnZ0i8eC/OMI3v+2gdbezQ66N1fwMJgJGvtqIy6f4SeJzamvF6EafmP61Zj/78
umq6k/BNqSWNLWnClqrC2M1RbD57+fQMt1nh1+9UT9iqa5F6dTPiTv7aO4NSvONt
hQExfO8T5gzttuBe08r0gvPTqx5VaxviEmYoHV5N2icOYRysmPratW6lADYYgGf5
Sh5NoPOUyhR+1OAsmt+WOc/voJwosilULMz2UebqbIDfOAx47q8buK+UPOmipJ/+
GI8j8dp3a84ciDZd5RO/
=GxV8
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_12_48_33_+1100_oUI0VuHxxxlLvn9h--
