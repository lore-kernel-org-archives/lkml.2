Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab2IJXBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:01:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50548 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab2IJXBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:01:34 -0400
Date: Mon, 10 Sep 2012 16:01:30 -0700
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, device-mapper development <dm-devel@redhat.com>,
        david@fromorbit.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        bharrosh@panasas.com, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
 allocation by stacking drivers
Message-ID: <20120910230130.GB19739@google.com>
References: <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <20120910220910.GB7677@google.com>
 <20120910225057.GA10477@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910225057.GA10477@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 11:50:57PM +0100, Alasdair G Kergon wrote:
> On Mon, Sep 10, 2012 at 03:09:10PM -0700, Tejun Heo wrote:
> > On Mon, Sep 10, 2012 at 02:56:33PM -0700, Kent Overstreet wrote:
> > > commit df7e63cbffa3065fcc4ba2b9a93418d7c7312243
> > > Author: Kent Overstreet <koverstreet@google.com>
> > > Date:   Mon Sep 10 14:33:46 2012 -0700
> > > 
> > >     block: Avoid deadlocks with bio allocation by stacking drivers
> 
> > >     Note that this doesn't do anything for allocation from other mempools.
> 
> Note that dm has several cases of this, so this patch should not be used with
> dm yet.

That just means it won't affect dm one way or the other for those
allocations.

> Mikulas is studying those cases to see whether anything like this
> might be feasible/sensible or not.

I've got a patch that eliminates one of the per bio mempools in dm, and
I'll probably work on the rest after I finish off with immutable biovecs
- which is mostly done, just cleaning up/testing/pushing patches in now.


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
 
