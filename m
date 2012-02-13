Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751084Ab2BMFPr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:15:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45146 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2BMFPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:15:45 -0500
Date: Mon, 13 Feb 2012 16:15:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the kmap_atomic tree with the staging
 tree
Message-Id: <20120213161537.3cf109d3f9c4c577f8fcb789@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_16_15_37_+1100_mf5F4fl04_uQgKHx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_16_15_37_+1100_mf5F4fl04_uQgKHx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
drivers/staging/zcache/zcache-main.c between commit a49aeb1de585
("staging: zcache: replace xvmalloc with zsmalloc") (and mayb others)
from the staging tree and commit 1edbcaee3bbe ("zcache: remove the second
argument of k [un]map_atomic()") from the kmap_atomic tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/zcache/zcache-main.c
index ccfa854,f0843e8a..0000000
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@@ -455,14 -421,13 +455,14 @@@ static int zbud_decompress(struct page=20
  	}
  	ASSERT_SENTINEL(zh, ZBH);
  	BUG_ON(zh->size =3D=3D 0 || zh->size > zbud_max_buddy_size());
- 	to_va =3D kmap_atomic(page, KM_USER0);
+ 	to_va =3D kmap_atomic(page);
  	size =3D zh->size;
  	from_va =3D zbud_data(zh, size);
 -	ret =3D lzo1x_decompress_safe(from_va, size, to_va, &out_len);
 -	BUG_ON(ret !=3D LZO_E_OK);
 +	ret =3D zcache_comp_op(ZCACHE_COMPOP_DECOMPRESS, from_va, size,
 +				to_va, &out_len);
 +	BUG_ON(ret);
  	BUG_ON(out_len !=3D PAGE_SIZE);
- 	kunmap_atomic(to_va, KM_USER0);
+ 	kunmap_atomic(to_va);
  out:
  	spin_unlock(&zbpg->lock);
  	return ret;
@@@ -745,22 -708,21 +745,22 @@@ static void zv_free(struct zs_pool *poo
  	local_irq_restore(flags);
  }
 =20
 -static void zv_decompress(struct page *page, struct zv_hdr *zv)
 +static void zv_decompress(struct page *page, void *handle)
  {
 -	size_t clen =3D PAGE_SIZE;
 +	unsigned int clen =3D PAGE_SIZE;
  	char *to_va;
 -	unsigned size;
  	int ret;
 +	struct zv_hdr *zv;
 =20
 +	zv =3D zs_map_object(zcache_host.zspool, handle);
 +	BUG_ON(zv->size =3D=3D 0);
  	ASSERT_SENTINEL(zv, ZVH);
- 	to_va =3D kmap_atomic(page, KM_USER0);
 -	size =3D xv_get_object_size(zv) - sizeof(*zv);
 -	BUG_ON(size =3D=3D 0);
+ 	to_va =3D kmap_atomic(page);
 -	ret =3D lzo1x_decompress_safe((char *)zv + sizeof(*zv),
 -					size, to_va, &clen);
 +	ret =3D zcache_comp_op(ZCACHE_COMPOP_DECOMPRESS, (char *)zv + sizeof(*zv=
),
 +				zv->size, to_va, &clen);
- 	kunmap_atomic(to_va, KM_USER0);
+ 	kunmap_atomic(to_va);
 -	BUG_ON(ret !=3D LZO_E_OK);
 +	zs_unmap_object(zcache_host.zspool, handle);
 +	BUG_ON(ret);
  	BUG_ON(clen !=3D PAGE_SIZE);
  }
 =20
@@@ -1333,16 -1297,15 +1333,16 @@@ static int zcache_compress(struct page=20
  	char *from_va;
 =20
  	BUG_ON(!irqs_disabled());
 -	if (unlikely(dmem =3D=3D NULL || wmem =3D=3D NULL))
 -		goto out;  /* no buffer, so can't compress */
 +	if (unlikely(dmem =3D=3D NULL))
 +		goto out;  /* no buffer or no compressor so can't compress */
 +	*out_len =3D PAGE_SIZE << ZCACHE_DSTMEM_ORDER;
- 	from_va =3D kmap_atomic(from, KM_USER0);
+ 	from_va =3D kmap_atomic(from);
  	mb();
 -	ret =3D lzo1x_1_compress(from_va, PAGE_SIZE, dmem, out_len, wmem);
 -	BUG_ON(ret !=3D LZO_E_OK);
 +	ret =3D zcache_comp_op(ZCACHE_COMPOP_COMPRESS, from_va, PAGE_SIZE, dmem,
 +				(unsigned int *)out_len);
 +	BUG_ON(ret);
  	*out_va =3D dmem;
- 	kunmap_atomic(from_va, KM_USER0);
+ 	kunmap_atomic(from_va);
  	ret =3D 1;
  out:
  	return ret;

--Signature=_Mon__13_Feb_2012_16_15_37_+1100_mf5F4fl04_uQgKHx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOJx5AAoJEECxmPOUX5FEEM0P/jhyA8+GOus1owYq2AB0LLcz
bBL0VlGpofOUbRTC+4/YBQ7T2Hed9hB7WqT3MEnR9N55VLMNVBF2ESb1EbzPjPdw
nEHnvPh7f4ndlNfRYbnuyV2cDKUQewkyMsP2jwNiSQV9M6xsCGVouUJv6/5ok3I5
AXQnRsEngKQ1kPqUE1N4mIbdIttzloc0fS6HbiChRj7XNillY80Oytr8yYJX0+TI
nGkZ/p5zHQZyWdsOH3SNhTNG/zZB32HkycrdkTCjhqvQ+4Um7NzZlNP131J2ik8g
j14DxEhhcBXOAsYJPq6p7wG3T20OXhixHcMnM1JehJF1bTWqv2H3VczIw9j7tpvw
HxsRBJZOjhrvm7V3ZXHuSplLPMk0xbmeJLrX3cK2hixb1j3raenUTFm4vEem/fU0
AcBxnApBG6SMKaDmCDe407mpy59F1SAB5MeHwKzcUbdAjql3MWcm1GpJNX2lqeyH
EjtmCU/jQzlWe+So7mw1Mv/QnrWiIDqXfscx0P9p3e15kskrq/Qxp1UCk8tSQYrA
BvAXsJ0wGTSfFJV6ThFqO8CHu52iwn7+D6h+QYQDkvVDLHqZBTPVhDSGA2/m8wxZ
rQvlYh+7450oLRM90kCp9hpabl0P4UnOvcCg5hP8n5KoJG7RW1Z++Hzf9mKxyG+P
IzDvX9Ew7MRc/or0V6ag
=0THF
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_16_15_37_+1100_mf5F4fl04_uQgKHx--
