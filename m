Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab2IXE4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 00:56:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2IXE4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 00:56:52 -0400
Date: Mon, 24 Sep 2012 14:56:39 +1000
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@fusionio.com>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: makes bio_split support bio without data
Message-ID: <20120924145639.3b65fd8b@notabene.brown>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PQqSxr94QA3Yu5xg9G1x+r1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PQqSxr94QA3Yu5xg9G1x+r1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Jens,
 this patch has been sitting in my -next tree for a little while and I was
 hoping for it to go in for the next merge window.
 It simply allows bio_split() to be used on bios without a payload, such as
 'discard'.
 Are you happy with it going in though my 'md' tree, or would you rather ta=
ke
 it though your 'block' tree?

Thanks,
NeilBrown


From: Shaohua Li <shli@fusionio.com>
Date: Thu, 20 Sep 2012 09:36:03 +1000
Subject: [PATCH] block: makes bio_split support bio without data

discard bio hasn't data attached. We hit a BUG_ON with such bio. This makes
bio_split works for such bio.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/bio.c b/fs/bio.c
index 71072ab..dbb7a6c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1501,7 +1501,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_=
sectors)
 	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_sector + first_sectors);
=20
-	BUG_ON(bi->bi_vcnt !=3D 1);
+	BUG_ON(bi->bi_vcnt !=3D 1 && bi->bi_vcnt !=3D 0);
 	BUG_ON(bi->bi_idx !=3D 0);
 	atomic_set(&bp->cnt, 3);
 	bp->error =3D 0;
@@ -1511,17 +1511,19 @@ struct bio_pair *bio_split(struct bio *bi, int firs=
t_sectors)
 	bp->bio2.bi_size -=3D first_sectors << 9;
 	bp->bio1.bi_size =3D first_sectors << 9;
=20
-	bp->bv1 =3D bi->bi_io_vec[0];
-	bp->bv2 =3D bi->bi_io_vec[0];
-	bp->bv2.bv_offset +=3D first_sectors << 9;
-	bp->bv2.bv_len -=3D first_sectors << 9;
-	bp->bv1.bv_len =3D first_sectors << 9;
+	if (bi->bi_vcnt !=3D 0) {
+		bp->bv1 =3D bi->bi_io_vec[0];
+		bp->bv2 =3D bi->bi_io_vec[0];
+		bp->bv2.bv_offset +=3D first_sectors << 9;
+		bp->bv2.bv_len -=3D first_sectors << 9;
+		bp->bv1.bv_len =3D first_sectors << 9;
=20
-	bp->bio1.bi_io_vec =3D &bp->bv1;
-	bp->bio2.bi_io_vec =3D &bp->bv2;
+		bp->bio1.bi_io_vec =3D &bp->bv1;
+		bp->bio2.bi_io_vec =3D &bp->bv2;
=20
-	bp->bio1.bi_max_vecs =3D 1;
-	bp->bio2.bi_max_vecs =3D 1;
+		bp->bio1.bi_max_vecs =3D 1;
+		bp->bio2.bi_max_vecs =3D 1;
+	}
=20
 	bp->bio1.bi_end_io =3D bio_pair_end_1;
 	bp->bio2.bi_end_io =3D bio_pair_end_2;

--Sig_/PQqSxr94QA3Yu5xg9G1x+r1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUF/oCDnsnt1WYoG5AQKO2w//WWjJn+wabWsS6FDc3yNNW+a5RvpcNWNN
PCwjb9e4ZH/RLPVnpGrKLncRGkkjvCxuxKrKg45bw6VkhF5DYUhuGj4wwQaKSufp
H9WZCBVX9YUAfejHiu4sv7ElVIMU1XZupAO40OXrR6Cq6jrBuMr6GjSw1Gobq/QY
g536hYDlK663+VkHKpUOyQxHhJTm1V2pLloVGMdZ7WiquD4EhiE4RHz5wnIMdY4I
T/oWimPqrIu+pRjVM9bZdmR3B2yJ09RMcdrp2pEjKy4m7R3EqctGHVCR+qCp5Ewv
a+re/a1GQwJmCHnVPYClRlzzItVPOOOsobqXnfajYRBMC8h4o7rSgR1tbtipp+Or
QTU3afH+GAdSZ5G0N6fxtXBRPx7DWmEx+WmXOn8Up224EimbuVYF3ECE/LIu9dkm
/sYpzCTBZPNiX8ZqWJakqBRNft1TNjrDmQonHvrqYcjo30XAd1YLv/bWIdINsjpQ
o+dfgVTeW1JSItFy7FYG6CyTyYIM15Laf2sgO/S1OhsX+CZFtn6VHL66IynvowhB
9BMEgZKGHHudDDFxd8uzBwEVySw/OjFlYZoT/nbkQqHw3fkCfhOH3TmTOb+9ffwL
e/mga836nBk2xJ90i5IHA89r1KlH4d92pN5dRHANnOnZ4tTEOsAi2LekZT9ei8hU
Gp3shSYoyt0=
=RoZ6
-----END PGP SIGNATURE-----

--Sig_/PQqSxr94QA3Yu5xg9G1x+r1--
