Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754Ab2HXKb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 06:31:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44009 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042Ab2HXKbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 06:31:23 -0400
Date: Fri, 24 Aug 2012 03:30:49 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>, Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Message-ID: <20120824103049.GG11977@moria.home.lan>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-12-git-send-email-koverstreet@google.com>
 <20120822210410.GL19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822210410.GL19212@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 02:04:10PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Wed, Aug 22, 2012 at 10:04:08AM -0700, Kent Overstreet wrote:
> > This changes bio_pair_split() to use the new bio_split() underneath,
> > which gets rid of the single page bio limitation. The various callers
> > are fixed up for the slightly different struct bio_pair, and to remove
> > the unnecessary checks.
> 
> This changes an existing API both in its interface and behavior and
> there's no detailed explanation on how it's changed and what are the
> implications.

Well, there were only two changes that affected the users: The single
page restriction is gone, and the bio1 and bio2 members became split and
orig, due to the new implementation.

I did note the first in the patch description, I'll also note the
second.

> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index 1f5b483..63e5852 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -751,14 +751,13 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
> >  
> >  			/* split the bio. We'll release it either in the next
> >  			   call, or it will have to be released outside */
> > -			bp = bio_pair_split(old_chain,
> > -					    (len - total) / SECTOR_SIZE);
> > +			bp = bio_pair_split(old_chain, (len - total) / SECTOR_SIZE);
> 
> Probably belongs to the previous patch which renamed bio_split() to
> bio_pair_split()? 

Yeah.

> Another thing is, is this renaming really
> necessary?  If you did,
> 
> 	* s/bio_split()/bio_pair_split().
> 
> 	* introduce better and prettier bio_split() which has
>           different semantics.
> 
> 	* replace bio_pair_split() users with bio_split().
> 
> the renaming would have made sense, but you renamed an existing API,
> intrudced a new one and then changed the renamed old API.  Doesn't
> make too much sense to me.

What you describe is almost exactly what I did, minus step 3.

IMO, bio_pair_split() should probably be deprecated because of the
shared mempool issue (which is fixable) and because chaining is
dangerous with arbitrary splitting and generally not what users want.

But converting the existing users over to the new bio_split() would be
very nontrivial, and without that we'd have two different
implementations of bio splitting in the kernel. So under the
circumstances, making the old bio_split() a wrapper around the new one
makes sense, IMO.

We can deprecate bio_pair_split() and remove existing usage one at a
time later.

> 
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 0f31ec4..9fa07c7 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1080,15 +1080,9 @@ static void make_request(struct mddev *mddev, struct bio * bio)
> >  		     && (conf->geo.near_copies < conf->geo.raid_disks
> >  			 || conf->prev.near_copies < conf->prev.raid_disks))) {
> >  		struct bio_pair *bp;
> > -		/* Sanity check -- queue functions should prevent this happening */
> > -		if (bio->bi_vcnt != 1 ||
> > -		    bio->bi_idx != 0)
> > -			goto bad_map;
> > -		/* This is a one page bio that upper layers
> > -		 * refuse to split for us, so we need to split it.
> > -		 */
> > +
> >  		bp = bio_pair_split(bio,
> > -				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
> > +				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
> 
> I suppose this one too belongs to the previous rename patch?

Yeah, I'll move it.

> 
> > --- a/fs/bio-integrity.c
> > +++ b/fs/bio-integrity.c
> > @@ -681,50 +681,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
> >  EXPORT_SYMBOL(bio_integrity_trim);
> >  
> >  /**
> > - * bio_integrity_split - Split integrity metadata
> > - * @bio:	Protected bio
> > - * @bp:		Resulting bio_pair
> > - * @sectors:	Offset
> > - *
> > - * Description: Splits an integrity page into a bio_pair.
> > - */
> > -void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
> > -{
> > -	struct blk_integrity *bi;
> > -	struct bio_integrity_payload *bip = bio->bi_integrity;
> > -	unsigned int nr_sectors;
> > -
> > -	if (bio_integrity(bio) == 0)
> > -		return;
> > -
> > -	bi = bdev_get_integrity(bio->bi_bdev);
> > -	BUG_ON(bi == NULL);
> > -	BUG_ON(bip->bip_vcnt != 1);
> > -
> > -	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
> > -
> > -	bp->bio1.bi_integrity = &bp->bip1;
> > -	bp->bio2.bi_integrity = &bp->bip2;
> > -
> > -	bp->iv1 = bip->bip_vec[0];
> > -	bp->iv2 = bip->bip_vec[0];
> > -
> > -	bp->bip1.bip_vec[0] = bp->iv1;
> > -	bp->bip2.bip_vec[0] = bp->iv2;
> > -
> > -	bp->iv1.bv_len = sectors * bi->tuple_size;
> > -	bp->iv2.bv_offset += sectors * bi->tuple_size;
> > -	bp->iv2.bv_len -= sectors * bi->tuple_size;
> > -
> > -	bp->bip1.bip_sector = bio->bi_integrity->bip_sector;
> > -	bp->bip2.bip_sector = bio->bi_integrity->bip_sector + nr_sectors;
> > -
> > -	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
> > -	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
> > -}
> > -EXPORT_SYMBOL(bio_integrity_split);
> 
> I complained about this in the last posting and in the previous patch.
> Please respond.  Martin, are you okay with these integrity changes?

I did respond. I said more before, but in short the old
bio_integrity_split() only worked for single page bios, and thus wasn't
useful even as a starting point.

What my bio_split() does with the integrity is actually basically what
dm does (that's the only other place bio_integrity_trim()) is used).

Sometimes I'm not sure if you read all my emails...

> 
> > -static void bio_pair_end_1(struct bio *bi, int err)
> > +static void bio_pair_end(struct bio *bio, int error)
> >  {
> > -	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
> > +	struct bio_pair *bp = bio->bi_private;
> >  
> > -	if (err)
> > -		bp->error = err;
> > -
> > -	bio_pair_release(bp);
> > -}
> > -
> > -static void bio_pair_end_2(struct bio *bi, int err)
> > -{
> > -	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
> > -
> > -	if (err)
> > -		bp->error = err;
> > +	if (error)
> > +		clear_bit(BIO_UPTODATE, &bp->orig->bi_flags);
> >  
> >  	bio_pair_release(bp);
> >  }
> 
> Why is losing error value okay here?

I suppose there's no good reason to and the old code passed it up.
Fixing that.

> 
> > @@ -1856,8 +1846,7 @@ static int __init init_bio(void)
> >  	if (bioset_integrity_create(fs_bio_set, BIO_POOL_SIZE))
> >  		panic("bio: can't create integrity pool\n");
> >  
> > -	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
> > -						     sizeof(struct bio_pair));
> > +	bio_split_pool = bioset_create(BIO_POOL_SIZE, offsetof(struct bio_pair, split));
> >  	if (!bio_split_pool)
> >  		panic("bio: can't create split pool\n");
> 
> It would be nice to mention that using this from stacking drivers is
> inherently broken.  This is something which has been broken before
> this patch but still.  bio_split*() should always require separate
> biosets.

Yeah. I'll make a note of it. Fixing it is going to have to come later -
but as I mentioned earlier I'd prefer to just get rid of it.

Shouldn't be _that_ hard to get rid of it, just that is going to have to
be its own patch series.

> > diff --git a/include/linux/bio.h b/include/linux/bio.h
> > index 1c3bb47..3ad3540 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -192,14 +192,13 @@ struct bio_integrity_payload {
> >   *   in bio2.bi_private
> >   */
> >  struct bio_pair {
> > -	struct bio			bio1, bio2;
> > -	struct bio_vec			bv1, bv2;
> > -#if defined(CONFIG_BLK_DEV_INTEGRITY)
> > -	struct bio_integrity_payload	bip1, bip2;
> > -	struct bio_vec			iv1, iv2;
> > -#endif
> > -	atomic_t			cnt;
> > -	int				error;
> > +	atomic_t		cnt;
> > +
> > +	bio_end_io_t		*bi_end_io;
> > +	void			*bi_private;
> > +
> > +	struct bio		*orig;
> > +	struct bio		split;
> >  };
> 
> So, this is struct is allocated as frontpad, which is a pretty unusual
> thing to do.  Please explain and emphasize that ->split should come
> last. 

Will do.

> Also, given that it's a pair split, it would be nice to somehow
> indicate that ->split is the earlier half.  Before this change it was
> pretty clear with ->bio1/2.

Fixed the comment to indicate that too.


commit 5db0562e43099d06ed9488e7ae6bf0a0cc6ef5da
Author: Kent Overstreet <koverstreet@google.com>
Date:   Fri Aug 24 03:27:24 2012 -0700

    block: Rework bio_pair_split()
    
    This changes bio_pair_split() to use the new bio_split() underneath.
    
    This has two user visible changes: First, it's not restricted to single
    page bios anymore. Secondly, where before callers used bio1 and bio2 in
    struct bio_pair, now they use split and orig - this being a result of
    the new implementation.
    
    bio_integrity_split() is removed, as the old bio_pair_split() was the
    only user; the new bio_split() uses bio_integrity_clone/trim much like
    the dm code does.
    
    v5: Move extern declaration to proper patch, per Boaz
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>
    CC: Jens Axboe <axboe@kernel.dk>
    CC: NeilBrown <neilb@suse.de>
    CC: Lars Ellenberg <lars.ellenberg@linbit.com>
    CC: Peter Osterlund <petero2@telia.com>
    CC: Sage Weil <sage@inktank.com>
    CC: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index fbb0471..7d3e662 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1122,18 +1122,6 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 		do {
 			inc_ap_bio(mdev, 1);
 		} while (drbd_make_request_common(mdev, bio, start_time));
-		return;
-	}
-
-	/* can this bio be split generically?
-	 * Maybe add our own split-arbitrary-bios function. */
-	if (bio->bi_vcnt != 1 || bio->bi_idx != 0 || bio->bi_size > DRBD_MAX_BIO_SIZE) {
-		/* rather error out here than BUG in bio_split */
-		dev_err(DEV, "bio would need to, but cannot, be split: "
-		    "(vcnt=%u,idx=%u,size=%u,sector=%llu)\n",
-		    bio->bi_vcnt, bio->bi_idx, bio->bi_size,
-		    (unsigned long long)bio->bi_sector);
-		bio_endio(bio, -EINVAL);
 	} else {
 		/* This bio crosses some boundary, so we have to split it. */
 		struct bio_pair *bp;
@@ -1160,10 +1148,10 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 
 		D_ASSERT(e_enr == s_enr + 1);
 
-		while (drbd_make_request_common(mdev, &bp->bio1, start_time))
+		while (drbd_make_request_common(mdev, &bp->split, start_time))
 			inc_ap_bio(mdev, 1);
 
-		while (drbd_make_request_common(mdev, &bp->bio2, start_time))
+		while (drbd_make_request_common(mdev, bio, start_time))
 			inc_ap_bio(mdev, 1);
 
 		dec_ap_bio(mdev);
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 310d699..66e2fe5 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2468,8 +2468,8 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 			first_sectors = last_zone - bio->bi_sector;
 			bp = bio_pair_split(bio, first_sectors);
 			BUG_ON(!bp);
-			pkt_make_request(q, &bp->bio1);
-			pkt_make_request(q, &bp->bio2);
+			pkt_make_request(q, &bp->split);
+			pkt_make_request(q, bio);
 			bio_pair_release(bp);
 			return;
 		}
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index b4d106e..63e5852 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -755,9 +755,9 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
 			if (!bp)
 				goto err_out;
 
-			__bio_clone(tmp, &bp->bio1);
+			__bio_clone(tmp, &bp->split);
 
-			*next = &bp->bio2;
+			*next = bp->orig;
 		} else {
 			__bio_clone(tmp, old_chain);
 			*next = old_chain->bi_next;
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index e860cb9..7c6cafd 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -316,8 +316,8 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 
 		bp = bio_pair_split(bio, end_sector - bio->bi_sector);
 
-		linear_make_request(mddev, &bp->bio1);
-		linear_make_request(mddev, &bp->bio2);
+		linear_make_request(mddev, &bp->split);
+		linear_make_request(mddev, bio);
 		bio_pair_release(bp);
 		return;
 	}
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c89c8aa..3469adf 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -520,9 +520,9 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 							   (chunk_sects-1)));
 		else
 			bp = bio_pair_split(bio, chunk_sects -
-					    sector_div(sector, chunk_sects));
-		raid0_make_request(mddev, &bp->bio1);
-		raid0_make_request(mddev, &bp->bio2);
+				       sector_div(sector, chunk_sects));
+		raid0_make_request(mddev, &bp->split);
+		raid0_make_request(mddev, bio);
 		bio_pair_release(bp);
 		return;
 	}
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b770f3e..9fa07c7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1080,13 +1080,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		     && (conf->geo.near_copies < conf->geo.raid_disks
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
 		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
+
 		bp = bio_pair_split(bio,
 				    chunk_sects - (bio->bi_sector & (chunk_sects - 1)));
 
@@ -1102,8 +1096,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		conf->nr_waiting++;
 		spin_unlock_irq(&conf->resync_lock);
 
-		make_request(mddev, &bp->bio1);
-		make_request(mddev, &bp->bio2);
+		make_request(mddev, &bp->split);
+		make_request(mddev, bio);
 
 		spin_lock_irq(&conf->resync_lock);
 		conf->nr_waiting--;
@@ -1112,13 +1106,6 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 
 		bio_pair_release(bp);
 		return;
-	bad_map:
-		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
-		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
-		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
-
-		bio_io_error(bio);
-		return;
 	}
 
 	md_write_start(mddev, bio);
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 35ee3d4..08a9e12c 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -681,50 +681,6 @@ void bio_integrity_trim(struct bio *bio, unsigned int offset,
 EXPORT_SYMBOL(bio_integrity_trim);
 
 /**
- * bio_integrity_split - Split integrity metadata
- * @bio:	Protected bio
- * @bp:		Resulting bio_pair
- * @sectors:	Offset
- *
- * Description: Splits an integrity page into a bio_pair.
- */
-void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
-{
-	struct blk_integrity *bi;
-	struct bio_integrity_payload *bip = bio->bi_integrity;
-	unsigned int nr_sectors;
-
-	if (bio_integrity(bio) == 0)
-		return;
-
-	bi = bdev_get_integrity(bio->bi_bdev);
-	BUG_ON(bi == NULL);
-	BUG_ON(bip->bip_vcnt != 1);
-
-	nr_sectors = bio_integrity_hw_sectors(bi, sectors);
-
-	bp->bio1.bi_integrity = &bp->bip1;
-	bp->bio2.bi_integrity = &bp->bip2;
-
-	bp->iv1 = bip->bip_vec[0];
-	bp->iv2 = bip->bip_vec[0];
-
-	bp->bip1.bip_vec[0] = bp->iv1;
-	bp->bip2.bip_vec[0] = bp->iv2;
-
-	bp->iv1.bv_len = sectors * bi->tuple_size;
-	bp->iv2.bv_offset += sectors * bi->tuple_size;
-	bp->iv2.bv_len -= sectors * bi->tuple_size;
-
-	bp->bip1.bip_sector = bio->bi_integrity->bip_sector;
-	bp->bip2.bip_sector = bio->bi_integrity->bip_sector + nr_sectors;
-
-	bp->bip1.bip_vcnt = bp->bip2.bip_vcnt = 1;
-	bp->bip1.bip_idx = bp->bip2.bip_idx = 0;
-}
-EXPORT_SYMBOL(bio_integrity_split);
-
-/**
  * bio_integrity_clone - Callback for cloning bios with integrity metadata
  * @bio:	New bio
  * @bio_src:	Original bio
diff --git a/fs/bio.c b/fs/bio.c
index 0f76172..bff9a8e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -37,7 +37,7 @@
  */
 #define BIO_INLINE_VECS		4
 
-static mempool_t *bio_split_pool __read_mostly;
+static struct bio_set *bio_split_pool __read_mostly;
 
 /*
  * if you change this list, also change bvec_alloc or things will
@@ -1478,30 +1478,27 @@ void bio_endio(struct bio *bio, int error)
 }
 EXPORT_SYMBOL(bio_endio);
 
+/**
+ * bio_pair_release - drop refcount on a bio_pair
+ *
+ * This is called by bio_pair_split's endio function, and also must be called by
+ * the caller of bio_pair_split().
+ */
 void bio_pair_release(struct bio_pair *bp)
 {
 	if (atomic_dec_and_test(&bp->cnt)) {
-		struct bio *master = bp->bio1.bi_private;
+		bp->orig->bi_end_io = bp->bi_end_io;
+		bp->orig->bi_private = bp->bi_private;
 
-		bio_endio(master, bp->error);
-		mempool_free(bp, bp->bio2.bi_private);
+		bio_endio(bp->orig, bp->error);
+		bio_put(&bp->split);
 	}
 }
 EXPORT_SYMBOL(bio_pair_release);
 
-static void bio_pair_end_1(struct bio *bi, int err)
-{
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio1);
-
-	if (err)
-		bp->error = err;
-
-	bio_pair_release(bp);
-}
-
-static void bio_pair_end_2(struct bio *bi, int err)
+static void bio_pair_endio(struct bio *bio, int err)
 {
-	struct bio_pair *bp = container_of(bi, struct bio_pair, bio2);
+	struct bio_pair *bp = bio->bi_private;
 
 	if (err)
 		bp->error = err;
@@ -1509,49 +1506,46 @@ static void bio_pair_end_2(struct bio *bi, int err)
 	bio_pair_release(bp);
 }
 
-/*
- * split a bio - only worry about a bio with a single page in its iovec
+/**
+ * bio_pair_split - split a bio, and chain the completions
+ * @bio:	bio to split
+ * @sectors:	number of sectors to split from the front of @bio
+ *
+ * This wraps bio_split(), and puts the split and the original bio in a struct
+ * bio_pair. It also hooks into the completions so the original bio will be
+ * completed once both splits have been completed.
+ *
+ * The caller will own a refcount on the returned bio_pair, which must be
+ * dropped with bio_pair_release().
+ *
+ * Note: this interface is not safe and could cause deadlocks when used with
+ * stacked virtual block devices - to be correct it should allow the caller to
+ * pass in a bio_set to use. It shouldn't be used to split a bio more than once
+ * either, for that use bio_split().
  */
-struct bio_pair *bio_pair_split(struct bio *bi, int first_sectors)
+struct bio_pair *bio_pair_split(struct bio *bio, int sectors)
 {
-	struct bio_pair *bp = mempool_alloc(bio_split_pool, GFP_NOIO);
+	struct bio_pair *bp;
+	struct bio *split;
 
-	if (!bp)
-		return bp;
+	split = bio_split(bio, sectors, GFP_NOIO, bio_split_pool);
+	if (!split)
+		return NULL;
 
-	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
-				bi->bi_sector + first_sectors);
+	bp = container_of(split, struct bio_pair, split);
 
-	BUG_ON(bi->bi_vcnt != 1);
-	BUG_ON(bi->bi_idx != 0);
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
-	bp->bio1 = *bi;
-	bp->bio2 = *bi;
-	bp->bio2.bi_sector += first_sectors;
-	bp->bio2.bi_size -= first_sectors << 9;
-	bp->bio1.bi_size = first_sectors << 9;
-
-	bp->bv1 = bi->bi_io_vec[0];
-	bp->bv2 = bi->bi_io_vec[0];
-	bp->bv2.bv_offset += first_sectors << 9;
-	bp->bv2.bv_len -= first_sectors << 9;
-	bp->bv1.bv_len = first_sectors << 9;
-
-	bp->bio1.bi_io_vec = &bp->bv1;
-	bp->bio2.bi_io_vec = &bp->bv2;
-
-	bp->bio1.bi_max_vecs = 1;
-	bp->bio2.bi_max_vecs = 1;
+	bp->orig = bio;
 
-	bp->bio1.bi_end_io = bio_pair_end_1;
-	bp->bio2.bi_end_io = bio_pair_end_2;
+	bp->bi_end_io = bio->bi_end_io;
+	bp->bi_private = bio->bi_private;
 
-	bp->bio1.bi_private = bi;
-	bp->bio2.bi_private = bio_split_pool;
+	bio->bi_private = bp;
+	bio->bi_end_io = bio_pair_endio;
 
-	if (bio_integrity(bi))
-		bio_integrity_split(bi, bp, first_sectors);
+	split->bi_private = bp;
+	split->bi_end_io = bio_pair_endio;
 
 	return bp;
 }
@@ -1874,8 +1868,7 @@ static int __init init_bio(void)
 	if (bioset_integrity_create(fs_bio_set, BIO_POOL_SIZE))
 		panic("bio: can't create integrity pool\n");
 
-	bio_split_pool = mempool_create_kmalloc_pool(BIO_SPLIT_ENTRIES,
-						     sizeof(struct bio_pair));
+	bio_split_pool = bioset_create(BIO_POOL_SIZE, offsetof(struct bio_pair, split));
 	if (!bio_split_pool)
 		panic("bio: can't create split pool\n");
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3afef0b..090ce10 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -182,24 +182,23 @@ struct bio_integrity_payload {
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
 /*
- * A bio_pair is used when we need to split a bio.
- * This can only happen for a bio that refers to just one
- * page of data, and in the unusual situation when the
- * page crosses a chunk/device boundary
- *
- * The address of the master bio is stored in bio1.bi_private
- * The address of the pool the pair was allocated from is stored
- *   in bio2.bi_private
+ * A bio_pair is used for splitting a bio and chaining the completions. split is
+ * the first half of the split, representing first_sectors from the original
+ * bio; orig is updated to represent the second half.
  */
 struct bio_pair {
-	struct bio			bio1, bio2;
-	struct bio_vec			bv1, bv2;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	struct bio_integrity_payload	bip1, bip2;
-	struct bio_vec			iv1, iv2;
-#endif
+	bio_end_io_t			*bi_end_io;
+	void				*bi_private;
+
 	atomic_t			cnt;
 	int				error;
+
+	struct bio			*orig;
+	/*
+	 * Since this struct is allocated using the front_pad option of struct
+	 * bio_set, split must come last.
+	 */
+	struct bio			split;
 };
 
 extern struct bio *bio_split(struct bio *bio, int sectors,
@@ -554,7 +553,6 @@ extern int bio_integrity_prep(struct bio *);
 extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
-extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
 extern int bioset_integrity_create(struct bio_set *, int);
 extern void bioset_integrity_free(struct bio_set *);
@@ -598,12 +596,6 @@ static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 	return 0;
 }
 
-static inline void bio_integrity_split(struct bio *bio, struct bio_pair *bp,
-				       int sectors)
-{
-	return;
-}
-
 static inline void bio_integrity_advance(struct bio *bio,
 					 unsigned int bytes_done)
 {
