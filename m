Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2GYXPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 19:15:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47634 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab2GYXPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 19:15:20 -0400
Date: Wed, 25 Jul 2012 16:15:15 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk, agk@redhat.com,
        neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v4 05/12] block: Kill bi_destructor
Message-ID: <20120725231515.GC8673@moria.home.lan>
References: <1343160689-12378-1-git-send-email-koverstreet@google.com>
 <1343160689-12378-6-git-send-email-koverstreet@google.com>
 <500FDB0D.4070605@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500FDB0D.4070605@panasas.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 02:39:57PM +0300, Boaz Harrosh wrote:
> On 07/24/2012 11:11 PM, Kent Overstreet wrote:
> 
> > Now that we've got generic code for freeing bios allocated from bio
> > pools, this isn't needed anymore.
> > 
> > This also changes the semantics of bio_free() a bit - it now also frees
> > bios allocated by bio_kmalloc(). It's also no longer exported, as
> > without bi_destructor there should be no need for it to be called
> > anywhere else.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> <snip>
> 
> > diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> > index be65582..9338d0602 100644
> > --- a/drivers/target/target_core_iblock.c
> > +++ b/drivers/target/target_core_iblock.c
> > @@ -467,15 +467,7 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
> >  	}
> >  
> >  	bio->bi_bdev = ib_dev->ibd_bd;
> > -<<<<<<< HEAD
> >  	bio->bi_private = cmd;
> > -	bio->bi_destructor = iblock_bio_destructor;
> > -||||||| merged common ancestors
> > -	bio->bi_private = task;
> > -	bio->bi_destructor = iblock_bio_destructor;
> > -=======
> > -	bio->bi_private = task;
> > ->>>>>>> block: Generalized bio pool freeing
> >  	bio->bi_end_io = &iblock_bio_done;
> >  	bio->bi_sector = lba;
> >  	return bio;
> 
> 
> Merge conflict allmodconfig compilation please?
> 
> > diff --git a/fs/bio.c b/fs/bio.c
> > index 252e253..a301071 100644
> > --- a/fs/bio.c
> > +++ b/fs/bio.c
> > @@ -56,6 +56,9 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
> >   */
> >  struct bio_set *fs_bio_set;
> >  
> > +/* Only used as a sentinal value */
> > +static struct bio_set bio_kmalloc_pool;
> > +
> 
> 
> Id rather if you use a define like:
> #define BIO_KMALLOC_POOL ((void *)~0)
> 
> So any code access actually crashes in the bug case where
> this leaks out. (And there is no actual unused storage allocated)

I kind of prefer having a sentinal value that can't be used for anything
else, but it doesn't really matter if there's only ever going to be one
sentinal value.

> BTW I like this reuse of the bi_pool member as a flag as well.

Yeah me too, this way bi_pool always tells you how to free the bio.

diff --git a/fs/bio.c b/fs/bio.c
index c7f3442..ebc7309 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -56,6 +56,8 @@ static struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly = {
  */
 struct bio_set *fs_bio_set;
 
+#define BIO_KMALLOC_POOL ((void *) ~0)
+
 /*
  * Our slab pool management
  */
@@ -232,10 +234,21 @@ fallback:
 	return bvl;
 }
 
-void bio_free(struct bio *bio, struct bio_set *bs)
+void bio_free(struct bio *bio)
 {
+	struct bio_set *bs = bio->bi_pool;
 	void *p;
 
+	BUG_ON(!bs);
+
+	if (bs == BIO_KMALLOC_POOL) {
+		/* Bio was allocated by bio_kmalloc() */
+		if (bio_integrity(bio))
+			bio_integrity_free(bio, fs_bio_set);
+		kfree(bio);
+		return;
+	}
+
 	if (bio_has_allocated_vec(bio))
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
@@ -346,13 +359,6 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 EXPORT_SYMBOL(bio_alloc);
 
-static void bio_kmalloc_destructor(struct bio *bio)
-{
-	if (bio_integrity(bio))
-		bio_integrity_free(bio, fs_bio_set);
-	kfree(bio);
-}
-
 /**
  * bio_kmalloc - allocate a bio for I/O using kmalloc()
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -379,7 +385,7 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bio->bi_inline_vecs;
-	bio->bi_destructor = bio_kmalloc_destructor;
+	bio->bi_pool = BIO_KMALLOC_POOL;
 
 	return bio;
 }
@@ -417,12 +423,7 @@ void bio_put(struct bio *bio)
 	 */
 	if (atomic_dec_and_test(&bio->bi_cnt)) {
 		bio_disassociate_task(bio);
-		bio->bi_next = NULL;
-
-		if (bio->bi_pool)
-			bio_free(bio, bio->bi_pool);
-		else
-			bio->bi_destructor(bio);
+		bio_free(bio);
 	}
 }
 EXPORT_SYMBOL(bio_put);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index ba60319..393c87e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -216,7 +216,7 @@ extern struct bio *bio_alloc(gfp_t, unsigned int);
 extern struct bio *bio_kmalloc(gfp_t, unsigned int);
 extern struct bio *bio_alloc_bioset(gfp_t, int, struct bio_set *);
 extern void bio_put(struct bio *);
-extern void bio_free(struct bio *, struct bio_set *);
+extern void bio_free(struct bio *);
 
 extern void bio_endio(struct bio *, int);
 struct request_queue;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 769799f..4bd8685 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -84,11 +84,8 @@ struct bio {
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
 
-	/* If bi_pool is non NULL, bi_destructor is not called */
 	struct bio_set		*bi_pool;
 
-	bio_destructor_t	*bi_destructor;	/* destructor */
-
 	/*
 	 * We can inline a number of vecs at the end of the bio, to avoid
 	 * double allocations for a small number of bio_vecs. This member
