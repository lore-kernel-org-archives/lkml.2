Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab2DWGt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:49:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45070 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab2DWGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:49:56 -0400
Date: Mon, 23 Apr 2012 16:49:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: manual merge of the akpm tree with the dma-mapping tree
Message-Id: <20120423164953.1095c9ccbf81a33641947cd3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_16_49_53_+1000_R++im79mKf=ya8VK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Apr_2012_16_49_53_+1000_R++im79mKf=ya8VK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the scsi-post-merge tree got a conflict in
mm/page_alloc.c between commit ac77c4123661 ("mm: trigger page reclaim in
alloc_contig_range() to stabilise watermarks") from the dma-mapping tree
and commit "mm: add extra free kbytes tunable" from the akpm tree.

Just context changes.  I fixed it up (I think - see below) and can carry
the fixes as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/page_alloc.c
index 0e1c6f5,decfbf0..0000000
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@@ -5032,9 -4988,17 +5044,10 @@@ static void setup_per_zone_lowmem_reser
  	calculate_totalreserve_pages();
  }
 =20
 -/**
 - * setup_per_zone_wmarks - called when min_free_kbytes changes
 - * or when memory is hot-{added|removed}
 - *
 - * Ensures that the watermark[min,low,high] values for each zone are set
 - * correctly with respect to min_free_kbytes.
 - */
 -void setup_per_zone_wmarks(void)
 +static void __setup_per_zone_wmarks(void)
  {
  	unsigned long pages_min =3D min_free_kbytes >> (PAGE_SHIFT - 10);
+ 	unsigned long pages_low =3D extra_free_kbytes >> (PAGE_SHIFT - 10);
  	unsigned long lowmem_pages =3D 0;
  	struct zone *zone;
  	unsigned long flags;
@@@ -5074,16 -5041,13 +5090,18 @@@
  			 * If it's a lowmem zone, reserve a number of pages
  			 * proportionate to the zone's size.
  			 */
- 			zone->watermark[WMARK_MIN] =3D tmp;
+ 			zone->watermark[WMARK_MIN] =3D min;
  		}
 =20
- 		zone->watermark[WMARK_LOW]  =3D min_wmark_pages(zone) + (tmp >> 2);
- 		zone->watermark[WMARK_HIGH] =3D min_wmark_pages(zone) + (tmp >> 1);
+ 		zone->watermark[WMARK_LOW]  =3D min_wmark_pages(zone) +
+ 					low + (min >> 2);
+ 		zone->watermark[WMARK_HIGH] =3D min_wmark_pages(zone) +
+ 					low + (min >> 1);
 +
 +		zone->watermark[WMARK_MIN] +=3D cma_wmark_pages(zone);
 +		zone->watermark[WMARK_LOW] +=3D cma_wmark_pages(zone);
 +		zone->watermark[WMARK_HIGH] +=3D cma_wmark_pages(zone);
 +
  		setup_zone_migrate_reserve(zone);
  		spin_unlock_irqrestore(&zone->lock, flags);
  	}

--Signature=_Mon__23_Apr_2012_16_49_53_+1000_R++im79mKf=ya8VK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlPuRAAoJEECxmPOUX5FEv+MP/RDO8mShnCOLuWfno36ABkeC
3Je63jxi3cTopGiuswf3aKhuZt2/WrDdnBOdOiYRquuWsJvSIjC/8qO7JO2xfjJE
1Vthj6vsPFk4buWjUwMWmyzwgmF3yyM+tzdR3ShDOLxllYVi6BsXYwI1OBHV5NcV
2zwIE5SIw19sqHCsQsxEv0Zr/X6R7AjWkYgKCrnCL6kWml6/vXU+kEcj1FSf36bs
Ug9CNhG6EN6Igt+oTMozjqxaK/UW/O6qy82ncSoiHpo2FHdzyVbE2t2iPRIRzPZ9
tOgKu2k0tMP8zMynJhKsP4WfNY/xg85F6C7depzF5qCrkAzJd4msqlSrPJhay8AL
/Feu7QiC9S3xikzGGxrCV9U8egroigIqEoyprL1wXgthxKpBkpTkujDYnKNXR/kA
goFE41MIsUVqJkI4nlvBs/n+Od+ImS6Zs/LFz8GgJ7NbIr+B5mq4VoeJMzPGkwQk
b0b6dfGrIwloSfa0s54iUzbwYrSF76qO6ZU5ReWjCw4Cx4Uo7WDCNKi1YKrG+lgD
ntKGw8NWkQh0GYEZ6ionQiEYfo7JfarkOrKjvk2OtDggtR+StmZIXyIhry9HL2Z0
Q0LZJNesw248+W72PV6xYXkNstEUhkjkgYBftQ30srmWArjZss589Hy4yp2OD8Av
Eo1W/1XaLOx9ORYdquYO
=dBZu
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_16_49_53_+1000_R++im79mKf=ya8VK--
