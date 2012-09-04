Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793Ab2IDTwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:52:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63177 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab2IDTwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:52:01 -0400
Date: Tue, 4 Sep 2012 12:51:56 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tj@kernel.org,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] dm: Use bioset's front_pad for dm_target_io
Message-ID: <20120904195156.GE25236@google.com>
References: <1346175456-1572-10-git-send-email-koverstreet@google.com>
 <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
 <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 03:26:19PM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 3 Sep 2012, Kent Overstreet wrote:
> 
> > On Mon, Sep 03, 2012 at 04:41:37PM -0400, Mikulas Patocka wrote:
> > > ... or another possibility - start a timer when something is put to 
> > > current->bio_list and use that timer to pop entries off current->bio_list 
> > > and submit them to a workqueue. The timer can be cpu-local so only 
> > > interrupt masking is required to synchronize against the timer.
> > > 
> > > This would normally run just like the current kernel and in case of 
> > > deadlock, the timer would kick in and resolve the deadlock.
> > 
> > Ugh. That's a _terrible_ idea.
> > 
> > Remember the old plugging code? You ever have to debug performance
> > issues caused by it?
> 
> Yes, I do remember it (and I fixed one bug that resulted in missed unplug 
> and degraded performance).
> 
> But currently, deadlocks due to exhausted mempools and bios being stalled 
> in current->bio_list don't happen (or do happen below so rarely that they 
> aren't reported).
> 
> If we add a timer, it will turn a deadlock into an i/o delay, but it can't 
> make things any worse.

This is all true. I'm not arguing your solution wouldn't _work_... I'd
try and give some real reasoning for my objections but it'll take me
awhile to figure out how to coherently explain it and I'm very sleep
deprived.

> Currently, dm targets allocate request-specific data from target-specific 
> mempool. mempools are in dm-crypt, dm-delay, dm-mirror, dm-snapshot, 
> dm-thin, dm-verity. You can change it to allocate request-specific data 
> with the bio.

I wrote a patch for dm_target_io last night. I think I know an easy way
to go about converting the rest but it'll probably have to wait until
I'm further along with my immutable bvec stuff.

Completely untested patch below:


commit 8754349145edfc791450d3ad54c19f0f3715c86c
Author: Kent Overstreet <koverstreet@google.com>
Date:   Tue Sep 4 06:17:56 2012 -0700

    dm: Use bioset's front_pad for dm_target_io

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f2eb730..3cf39b0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -71,6 +71,7 @@ struct dm_target_io {
 	struct dm_io *io;
 	struct dm_target *ti;
 	union map_info info;
+	struct bio clone;
 };
 
 /*
@@ -174,7 +175,7 @@ struct mapped_device {
 	 * io objects are allocated from here.
 	 */
 	mempool_t *io_pool;
-	mempool_t *tio_pool;
+	mempool_t *rq_tio_pool;
 
 	struct bio_set *bs;
 
@@ -214,15 +215,8 @@ struct dm_md_mempools {
 
 #define MIN_IOS 256
 static struct kmem_cache *_io_cache;
-static struct kmem_cache *_tio_cache;
 static struct kmem_cache *_rq_tio_cache;
 
-/*
- * Unused now, and needs to be deleted. But since io_pool is overloaded and it's
- * still used for _io_cache, I'm leaving this for a later cleanup
- */
-static struct kmem_cache *_rq_bio_info_cache;
-
 static int __init local_init(void)
 {
 	int r = -ENOMEM;
@@ -232,22 +226,13 @@ static int __init local_init(void)
 	if (!_io_cache)
 		return r;
 
-	/* allocate a slab for the target ios */
-	_tio_cache = KMEM_CACHE(dm_target_io, 0);
-	if (!_tio_cache)
-		goto out_free_io_cache;
-
 	_rq_tio_cache = KMEM_CACHE(dm_rq_target_io, 0);
 	if (!_rq_tio_cache)
-		goto out_free_tio_cache;
-
-	_rq_bio_info_cache = KMEM_CACHE(dm_rq_clone_bio_info, 0);
-	if (!_rq_bio_info_cache)
-		goto out_free_rq_tio_cache;
+		goto out_free_io_cache;
 
 	r = dm_uevent_init();
 	if (r)
-		goto out_free_rq_bio_info_cache;
+		goto out_free_rq_tio_cache;
 
 	_major = major;
 	r = register_blkdev(_major, _name);
@@ -261,12 +246,8 @@ static int __init local_init(void)
 
 out_uevent_exit:
 	dm_uevent_exit();
-out_free_rq_bio_info_cache:
-	kmem_cache_destroy(_rq_bio_info_cache);
 out_free_rq_tio_cache:
 	kmem_cache_destroy(_rq_tio_cache);
-out_free_tio_cache:
-	kmem_cache_destroy(_tio_cache);
 out_free_io_cache:
 	kmem_cache_destroy(_io_cache);
 
@@ -275,9 +256,7 @@ out_free_io_cache:
 
 static void local_exit(void)
 {
-	kmem_cache_destroy(_rq_bio_info_cache);
 	kmem_cache_destroy(_rq_tio_cache);
-	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
 	dm_uevent_exit();
@@ -461,20 +440,15 @@ static void free_io(struct mapped_device *md, struct dm_io *io)
 	mempool_free(io, md->io_pool);
 }
 
-static void free_tio(struct mapped_device *md, struct dm_target_io *tio)
-{
-	mempool_free(tio, md->tio_pool);
-}
-
 static struct dm_rq_target_io *alloc_rq_tio(struct mapped_device *md,
 					    gfp_t gfp_mask)
 {
-	return mempool_alloc(md->tio_pool, gfp_mask);
+	return mempool_alloc(md->rq_tio_pool, gfp_mask);
 }
 
 static void free_rq_tio(struct dm_rq_target_io *tio)
 {
-	mempool_free(tio, tio->md->tio_pool);
+	mempool_free(tio, tio->md->rq_tio_pool);
 }
 
 static int md_in_flight(struct mapped_device *md)
@@ -658,7 +632,6 @@ static void clone_endio(struct bio *bio, int error)
 	int r = 0;
 	struct dm_target_io *tio = bio->bi_private;
 	struct dm_io *io = tio->io;
-	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
 	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
@@ -681,7 +654,6 @@ static void clone_endio(struct bio *bio, int error)
 		}
 	}
 
-	free_tio(md, tio);
 	bio_put(bio);
 	dec_pending(io, error);
 }
@@ -998,13 +970,16 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
-static void __map_bio(struct dm_target *ti, struct bio *clone,
-		      struct dm_target_io *tio)
+static void __map_bio(struct dm_io *io, struct dm_target *ti, struct bio *clone)
 {
+	struct dm_target_io *tio = container_of(clone, struct dm_target_io, clone);
 	int r;
 	sector_t sector;
 	struct mapped_device *md;
 
+	tio->io = io;
+	tio->ti = ti;
+
 	clone->bi_end_io = clone_endio;
 	clone->bi_private = tio;
 
@@ -1028,7 +1003,6 @@ static void __map_bio(struct dm_target *ti, struct bio *clone,
 		md = tio->io->md;
 		dec_pending(tio->io, r);
 		bio_put(clone);
-		free_tio(md, tio);
 	} else if (r) {
 		DMWARN("unimplemented target map return value: %d", r);
 		BUG();
@@ -1104,26 +1078,18 @@ static struct bio *clone_bio(struct bio *bio, sector_t sector,
 	return clone;
 }
 
-static struct dm_target_io *alloc_tio(struct clone_info *ci,
-				      struct dm_target *ti)
+static void init_tio(struct bio *bio)
 {
-	struct dm_target_io *tio = mempool_alloc(ci->md->tio_pool, GFP_NOIO);
-
-	tio->io = ci->io;
-	tio->ti = ti;
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	memset(&tio->info, 0, sizeof(tio->info));
-
-	return tio;
 }
 
 static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 				   unsigned request_nr, sector_t len)
 {
-	struct dm_target_io *tio = alloc_tio(ci, ti);
+	struct dm_target_io *tio;
 	struct bio *clone;
 
-	tio->info.target_request_nr = request_nr;
-
 	/*
 	 * Discard requests require the bio's inline iovecs be initialized.
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
@@ -1136,7 +1102,10 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 		clone->bi_size = to_bytes(len);
 	}
 
-	__map_bio(ti, clone, tio);
+	tio = container_of(clone, struct dm_target_io, clone);
+	tio->info.target_request_nr = request_nr;
+
+	__map_bio(ci->io, ti, clone);
 }
 
 static void __issue_target_requests(struct clone_info *ci, struct dm_target *ti,
@@ -1166,13 +1135,13 @@ static int __clone_and_map_empty_flush(struct clone_info *ci)
 static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 {
 	struct bio *clone, *bio = ci->bio;
-	struct dm_target_io *tio;
 
-	tio = alloc_tio(ci, ti);
 	clone = clone_bio(bio, ci->sector, ci->idx,
 			  bio->bi_vcnt - ci->idx, ci->sector_count,
 			  ci->md->bs);
-	__map_bio(ti, clone, tio);
+
+	init_tio(clone);
+	__map_bio(ci->io, ti, clone);
 	ci->sector_count = 0;
 }
 
@@ -1213,7 +1182,6 @@ static int __clone_and_map(struct clone_info *ci)
 	struct bio *clone, *bio = ci->bio;
 	struct dm_target *ti;
 	sector_t len = 0, max;
-	struct dm_target_io *tio;
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD))
 		return __clone_and_map_discard(ci);
@@ -1250,10 +1218,11 @@ static int __clone_and_map(struct clone_info *ci)
 			len += bv_len;
 		}
 
-		tio = alloc_tio(ci, ti);
 		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
 				  ci->md->bs);
-		__map_bio(ti, clone, tio);
+
+		init_tio(clone);
+		__map_bio(ci->io, ti, clone);
 
 		ci->sector += len;
 		ci->sector_count -= len;
@@ -1278,12 +1247,12 @@ static int __clone_and_map(struct clone_info *ci)
 
 			len = min(remaining, max);
 
-			tio = alloc_tio(ci, ti);
 			clone = split_bvec(bio, ci->sector, ci->idx,
 					   bv->bv_offset + offset, len,
 					   ci->md->bs);
 
-			__map_bio(ti, clone, tio);
+			init_tio(clone);
+			__map_bio(ci->io, ti, clone);
 
 			ci->sector += len;
 			ci->sector_count -= len;
@@ -1911,8 +1880,8 @@ static void free_dev(struct mapped_device *md)
 	unlock_fs(md);
 	bdput(md->bdev);
 	destroy_workqueue(md->wq);
-	if (md->tio_pool)
-		mempool_destroy(md->tio_pool);
+	if (md->rq_tio_pool)
+		mempool_destroy(md->rq_tio_pool);
 	if (md->io_pool)
 		mempool_destroy(md->io_pool);
 	if (md->bs)
@@ -1935,16 +1904,16 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p;
 
-	if (md->io_pool && md->tio_pool && md->bs)
+	if ((md->io_pool || md->rq_tio_pool) && md->bs)
 		/* the md already has necessary mempools */
 		goto out;
 
 	p = dm_table_get_md_mempools(t);
-	BUG_ON(!p || md->io_pool || md->tio_pool || md->bs);
+	BUG_ON(!p || md->io_pool || md->rq_tio_pool || md->bs);
 
 	md->io_pool = p->io_pool;
 	p->io_pool = NULL;
-	md->tio_pool = p->tio_pool;
+	md->rq_tio_pool = p->tio_pool;
 	p->tio_pool = NULL;
 	md->bs = p->bs;
 	p->bs = NULL;
@@ -2693,40 +2662,29 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity)
 	if (!pools)
 		return NULL;
 
-	pools->io_pool = (type == DM_TYPE_BIO_BASED) ?
-			 mempool_create_slab_pool(MIN_IOS, _io_cache) :
-			 mempool_create_slab_pool(MIN_IOS, _rq_bio_info_cache);
+	if (type == DM_TYPE_BIO_BASED)
+		pools->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
 	if (!pools->io_pool)
-		goto free_pools_and_out;
+		goto err;
 
-	pools->tio_pool = (type == DM_TYPE_BIO_BASED) ?
-			  mempool_create_slab_pool(MIN_IOS, _tio_cache) :
-			  mempool_create_slab_pool(MIN_IOS, _rq_tio_cache);
+	if (type == DM_TYPE_REQUEST_BASED)
+		pools->tio_pool =
+			mempool_create_slab_pool(MIN_IOS, _rq_tio_cache);
 	if (!pools->tio_pool)
-		goto free_io_pool_and_out;
+		goto err;
 
 	pools->bs = bioset_create(pool_size,
-				  offsetof(struct dm_rq_clone_bio_info, clone));
+				  max(offsetof(struct dm_target_io, clone),
+				      offsetof(struct dm_rq_clone_bio_info, clone)));
 	if (!pools->bs)
-		goto free_tio_pool_and_out;
+		goto err;
 
 	if (integrity && bioset_integrity_create(pools->bs, pool_size))
-		goto free_bioset_and_out;
+		goto err;
 
 	return pools;
-
-free_bioset_and_out:
-	bioset_free(pools->bs);
-
-free_tio_pool_and_out:
-	mempool_destroy(pools->tio_pool);
-
-free_io_pool_and_out:
-	mempool_destroy(pools->io_pool);
-
-free_pools_and_out:
-	kfree(pools);
-
+err:
+	dm_free_md_mempools(pools);
 	return NULL;
 }
 
