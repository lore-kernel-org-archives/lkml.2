Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1IUGM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:12:29 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:52319 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab1IUGM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:12:27 -0400
Date: Wed, 21 Sep 2011 09:12:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] bio: change some signed vars to unsigned
Message-ID: <20110921061206.GA4999@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4E798045.0168:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a cleanup patch to silence a static checker warning.

The problem is that we cap "nr_iovecs" so it can't be larger than
"UIO_MAXIOV" but we don't check for negative values.  It turns out
this is prevented at other layers, but logically it doesn't make
sense to have negative nr_iovecs so making it unsigned is nicer.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/bio.c b/fs/bio.c
index 9bfade8..93e7143 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -338,7 +338,7 @@ static void bio_fs_destructor(struct bio *bio)
  *	RETURNS:
  *	Pointer to new bio on success, NULL on failure.
  */
-struct bio *bio_alloc(gfp_t gfp_mask, int nr_iovecs)
+struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
 	struct bio *bio = bio_alloc_bioset(gfp_mask, nr_iovecs, fs_bio_set);
 
@@ -366,7 +366,7 @@ static void bio_kmalloc_destructor(struct bio *bio)
  *   %__GFP_WAIT, the allocation is guaranteed to succeed.
  *
  **/
-struct bio *bio_kmalloc(gfp_t gfp_mask, int nr_iovecs)
+struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 {
 	struct bio *bio;
 
@@ -697,7 +697,8 @@ static void bio_free_map_data(struct bio_map_data *bmd)
 	kfree(bmd);
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs, int iov_count,
+static struct bio_map_data *bio_alloc_map_data(int nr_segs,
+					       unsigned int iov_count,
 					       gfp_t gfp_mask)
 {
 	struct bio_map_data *bmd;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ce33e68..09867ad 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -211,8 +211,8 @@ extern void bio_pair_release(struct bio_pair *dbio);
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 
-extern struct bio *bio_alloc(gfp_t, int);
-extern struct bio *bio_kmalloc(gfp_t, int);
+extern struct bio *bio_alloc(gfp_t, unsigned int);
+extern struct bio *bio_kmalloc(gfp_t, unsigned int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
 extern void bio_free(struct bio *, struct bio_set *);
