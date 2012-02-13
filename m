Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab2BMFUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:20:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60724 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2BMFUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:20:16 -0500
Date: Mon, 13 Feb 2012 16:20:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the kmap_atomic tree with the staging
 tree
Message-Id: <20120213162008.a9a3092bec076bcf0f05c261@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_16_20_08_+1100_YN8dig8SxCozZCrA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_16_20_08_+1100_YN8dig8SxCozZCrA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
drivers/staging/zram/zram_drv.c between commit fd1a30dea194 ("staging:
zram: replace xvmalloc with zsmalloc") from the staging tree and commit
ea81cfe7d7fb ("zram: remove the second argument of k[un]map_atomic()")
from the kmap_atomic tree.

I fixed it up (see below) and can carry the fix as necessary.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/zram/zram_drv.c
index 5833156,1cf68ad..0000000
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@@ -188,12 -195,12 +188,12 @@@ static void handle_uncompressed_page(st
  	struct page *page =3D bvec->bv_page;
  	unsigned char *user_mem, *cmem;
 =20
- 	user_mem =3D kmap_atomic(page, KM_USER0);
- 	cmem =3D kmap_atomic(zram->table[index].handle, KM_USER1);
+ 	user_mem =3D kmap_atomic(page);
 -	cmem =3D kmap_atomic(zram->table[index].page);
++	cmem =3D kmap_atomic(zram->table[index].handle);
 =20
  	memcpy(user_mem + bvec->bv_offset, cmem + offset, bvec->bv_len);
- 	kunmap_atomic(cmem, KM_USER1);
- 	kunmap_atomic(user_mem, KM_USER0);
+ 	kunmap_atomic(cmem);
+ 	kunmap_atomic(user_mem);
 =20
  	flush_dcache_page(page);
  }
@@@ -259,8 -267,8 +259,8 @@@ static int zram_bvec_read(struct zram *
  		kfree(uncmem);
  	}
 =20
 -	kunmap_atomic(cmem);
 +	zs_unmap_object(zram->mem_pool, zram->table[index].handle);
- 	kunmap_atomic(user_mem, KM_USER0);
+ 	kunmap_atomic(user_mem);
 =20
  	/* Should NEVER happen. Return bio error if it does. */
  	if (unlikely(ret !=3D LZO_E_OK)) {
@@@ -399,9 -407,8 +399,9 @@@ static int zram_bvec_write(struct zram=20
  		store_offset =3D 0;
  		zram_set_flag(zram, index, ZRAM_UNCOMPRESSED);
  		zram_stat_inc(&zram->stats.pages_expand);
 -		zram->table[index].page =3D page_store;
 +		handle =3D page_store;
- 		src =3D kmap_atomic(page, KM_USER0);
- 		cmem =3D kmap_atomic(page_store, KM_USER1);
+ 		src =3D kmap_atomic(page);
++		cmem =3D kmap_atomic(page_store);
  		goto memstore;
  	}
 =20
@@@ -426,15 -438,9 +426,15 @@@ memstore
 =20
  	memcpy(cmem, src, clen);
 =20
 -	kunmap_atomic(cmem);
 -	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED)))
 +	if (unlikely(zram_test_flag(zram, index, ZRAM_UNCOMPRESSED))) {
- 		kunmap_atomic(cmem, KM_USER1);
- 		kunmap_atomic(src, KM_USER0);
++		kunmap_atomic(cmem);
+ 		kunmap_atomic(src);
 +	} else {
 +		zs_unmap_object(zram->mem_pool, handle);
 +	}
 +
 +	zram->table[index].handle =3D handle;
 +	zram->table[index].size =3D clen;
 =20
  	/* Update stats */
  	zram_stat64_add(zram, &zram->stats.compr_size, clen);

--Signature=_Mon__13_Feb_2012_16_20_08_+1100_YN8dig8SxCozZCrA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOJ2IAAoJEECxmPOUX5FEBrAP/35bRv8jirOk61bx5XWFcwuG
4IWSz+Z1fHbRlVYd9o77MgP5DDOxyTGkTYJcuJa+MigLMbpjN1kQAgQ6wG23T7ov
dziW38JJXHgWdbxn35AEVwUOk38GqUSu/hI7JguHdEOn4mXQK+6H7D2dl3o1s+7i
00RsPUKaU3Qjh01/JyeZC352ada3iWzQG+TfCmBm8YI7aVPRDwBkKOC6MC8sxsns
XO7PjhCf9eNfcnTpfZrlM9FS+dqdNZfQe4CUnS4IRYvZov/23bamOGig6Q84Dn+B
x1nSz2I+BNrtjkusOZwrWbTmvjniKfHem0KmQQZpDDJ1c3akJPQF10l7wG/JJH54
zZ7dXGS+bF1Jftvacm4b+XPAnjnVi650LgTPApGW9HbhZri54KyM+RCqED6VFoXv
f5XqluRGECTFwsYkaUjzUObNzyDt4ayf71W87iHl0A0qp1ZtgCu26jMFgTcsBIFt
idcWfBvmQsZ5Zyn/6wuvNkR9U5X0Y2oNuc5Lcg7X1sJlyJAmrbKZ4p72fWVCoSO6
vKATwkP4wGnG9TS3ez2UwXeMwlY45DzZWhi4XVacQsbnphonqh74Q8kSilEa/Ybk
6m9k9VeBJZReIdjJayJ2sfT7CHNmxIvYQaO5ZjkA8q16mk9RvyhZ9VpDR5j9uRbs
cvsTeNP+iLcs9DsXwP2O
=HmRg
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_16_20_08_+1100_YN8dig8SxCozZCrA--
