Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2HXHFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:05:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58985 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab2HXHFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:05:42 -0400
Date: Fri, 24 Aug 2012 00:05:08 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH v6 13/13] block: Only clone bio vecs that are in use
Message-ID: <20120824070508.GE11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-14-git-send-email-koverstreet@google.com>
 <20120822211045.GN19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822211045.GN19212@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 02:10:45PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Wed, Aug 22, 2012 at 10:04:10AM -0700, Kent Overstreet wrote:
> > bcache creates large bios internally, and then splits them according to
> > the device requirements before it sends them down. If a lower level
> > device tries to clone the bio, and the original bio had more than
> > BIO_MAX_PAGES, the clone will fail unecessarily.
> > 
> > We can fix this by only cloning the bio vecs that are actually in use.
> 
> I'm pretty sure I sound like a broken record by now, but
> 
> * How was this tested?
> 
> * What are the implications and possible dangers?

I've said all that on list, but I gather what you really wanted was to
have it all in the patch description. Will do.

Though actually, this patch by itself is pretty innocuous. It's my bio
splitting code that actually depends on the fields of struct bio
(bi_idx) being used consistently.

Anyways, tell me if the description below is better.

> > @@ -463,10 +468,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
> >  	bio->bi_sector = bio_src->bi_sector;
> >  	bio->bi_bdev = bio_src->bi_bdev;
> >  	bio->bi_flags |= 1 << BIO_CLONED;
> > +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
> 
> For the n'th time, explain please.

Argh, I could've sworn I dropped that part.


commit 0edda563aef9432b45f0c6a50f52590b92594560
Author: Kent Overstreet <koverstreet@google.com>
Date:   Thu Aug 23 23:26:38 2012 -0700

    block: Only clone bio vecs that are in use
    
    bcache creates large bios internally, and then splits them according to
    the device requirements before it sends them down. If a lower level
    device tries to clone the bio, and the original bio had more than
    BIO_MAX_PAGES, the clone will fail unecessarily.
    
    We can fix this by only cloning the bio vecs that are actually in use -
    as for as the block layer is concerned the new bio is still equivalent
    to the old bio.
    
    This code should in general be safe as long as all the block layer code
    uses bi_idx, bi_vcnt consistently; since bios are cloned by code that
    doesn't own the original bio there's little room for issues caused by
    code playing games with the original bio's bi_io_vec. One perhaps
    imagine code depending the clone and original bio's io vecs lining up a
    certain way, but auditing and testing haven't turned up anything.
    
    Testing: This code has been in the bcache tree for quite awhile, and has
    been tested with various md layers and dm targets (including strange
    things like multipath).
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>
    CC: Jens Axboe <axboe@kernel.dk>
    CC: Alasdair Kergon <agk@redhat.com>
    CC: Sage Weil <sage@inktank.com>

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 63e5852..5c3457f 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -734,7 +734,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
 	}
 
 	while (old_chain && (total < len)) {
-		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
+		tmp = bio_kmalloc(gfpmask, bio_segments(old_chain));
 		if (!tmp)
 			goto err_out;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a3c38b9..3aeb108 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1080,11 +1080,10 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 {
 	struct bio *clone;
 
-	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
+	clone = bio_alloc_bioset(GFP_NOIO, bv_count, bs);
 	__bio_clone(clone, bio);
 	clone->bi_sector = sector;
-	clone->bi_idx = idx;
-	clone->bi_vcnt = idx + bv_count;
+	clone->bi_vcnt = bv_count;
 	clone->bi_size = to_bytes(len);
 	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
 
diff --git a/fs/bio.c b/fs/bio.c
index 895e2a6..cd80710 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -467,11 +467,16 @@ EXPORT_SYMBOL(bio_phys_segments);
  *	Clone a &bio. Caller will own the returned bio, but not
  *	the actual data it points to. Reference count of returned
  * 	bio will be one.
+ *
+ *	We don't clone the entire bvec, just the part from bi_idx to b_vcnt
+ *	(i.e. what the bio currently points to, so the new bio is still
+ *	equivalent to the old bio).
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		bio_src->bi_max_vecs * sizeof(struct bio_vec));
+	memcpy(bio->bi_io_vec,
+	       bio_iovec(bio_src),
+	       bio_segments(bio_src) * sizeof(struct bio_vec));
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
@@ -481,9 +486,8 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
 	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_vcnt = bio_src->bi_vcnt;
+	bio->bi_vcnt = bio_segments(bio_src);
 	bio->bi_size = bio_src->bi_size;
-	bio->bi_idx = bio_src->bi_idx;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -500,7 +504,7 @@ struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 {
 	struct bio *b;
 
-	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
+	b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);
 	if (!b)
 		return NULL;
 
