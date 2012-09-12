Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2ILWcL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab2ILWcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:32:08 -0400
Date: Wed, 12 Sep 2012 18:31:53 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Kent Overstreet <koverstreet@google.com>
cc: "Alasdair G. Kergon" <agk@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2] dm: Use bioset's front_pad for dm_target_io
In-Reply-To: <20120911195029.GJ19739@google.com>
Message-ID: <Pine.LNX.4.64.1209121831110.21106@file.rdu.redhat.com>
References: <20120829165006.GB20312@google.com> <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com> <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan> <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan> <Pine.LNX.4.64.1209041509160.22689@file.rdu.redhat.com>
 <20120904195156.GE25236@google.com> <Pine.LNX.4.64.1209111349210.23947@file.rdu.redhat.com>
 <20120911195029.GJ19739@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Sep 2012, Kent Overstreet wrote:

> On Tue, Sep 11, 2012 at 03:28:57PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Tue, 4 Sep 2012, Kent Overstreet wrote:
> > 
> > > On Tue, Sep 04, 2012 at 03:26:19PM -0400, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Mon, 3 Sep 2012, Kent Overstreet wrote:
> > > > 
> > > > > On Mon, Sep 03, 2012 at 04:41:37PM -0400, Mikulas Patocka wrote:
> > > > > > ... or another possibility - start a timer when something is put to 
> > > > > > current->bio_list and use that timer to pop entries off current->bio_list 
> > > > > > and submit them to a workqueue. The timer can be cpu-local so only 
> > > > > > interrupt masking is required to synchronize against the timer.
> > > > > > 
> > > > > > This would normally run just like the current kernel and in case of 
> > > > > > deadlock, the timer would kick in and resolve the deadlock.
> > > > > 
> > > > > Ugh. That's a _terrible_ idea.
> > > > > 
> > > > > Remember the old plugging code? You ever have to debug performance
> > > > > issues caused by it?
> > > > 
> > > > Yes, I do remember it (and I fixed one bug that resulted in missed unplug 
> > > > and degraded performance).
> > > > 
> > > > But currently, deadlocks due to exhausted mempools and bios being stalled 
> > > > in current->bio_list don't happen (or do happen below so rarely that they 
> > > > aren't reported).
> > > > 
> > > > If we add a timer, it will turn a deadlock into an i/o delay, but it can't 
> > > > make things any worse.
> > > 
> > > This is all true. I'm not arguing your solution wouldn't _work_... I'd
> > > try and give some real reasoning for my objections but it'll take me
> > > awhile to figure out how to coherently explain it and I'm very sleep
> > > deprived.
> > > 
> > > > Currently, dm targets allocate request-specific data from target-specific 
> > > > mempool. mempools are in dm-crypt, dm-delay, dm-mirror, dm-snapshot, 
> > > > dm-thin, dm-verity. You can change it to allocate request-specific data 
> > > > with the bio.
> > > 
> > > I wrote a patch for dm_target_io last night. I think I know an easy way
> > > to go about converting the rest but it'll probably have to wait until
> > > I'm further along with my immutable bvec stuff.
> > > 
> > > Completely untested patch below:
> > 
> > The patch didn't work (it has random allocation failures and crashes when 
> > the device is closed). The patch also contains some unrelated changes.
> > 
> > I created this patch that does the same thing.
> 
> Cool! Thanks for finishing this.
> 
> I like your approach with rolling the bio allocation into alloc_tio() -
> it solves a problem I was having with the front_pad not being zeroed -
> but it does prevent the use of bio_clone_bioset(), which is going to
> cause minor issues with my immutable bvec work.
> 
> Perhaps bio_alloc_bioset() should just be changed to zero the front_pad,
> that'd probably be useful elsewhere anyways.
> 
> You might want to rebase onto Jens' tree, it has my patches that get rid
> of bi_destructor and the front_pad conversion for request based dm:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next

This is the patch based on this tree.

Mikulas

---

Use front pad to allocate dm_target_io

dm_target_io was previously allocated from a mempool. For each
dm_target_io, there is exactly one bio allocated from a bioset.

This patch merges these two allocations into one allocating: we create a
bioset with front_pad equal to the size of dm_target_io - so that every
bio allocated from the bioset has sizeof(struct dm_target_io) bytes
before it. We allocate a bio and use the bytes before the bio as
dm_target_io.

This idea was introdiced by Kent Overstreet <koverstreet@google.com>

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   80 ++++++++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 42 deletions(-)

Index: linux-block-copy/drivers/md/dm.c
===================================================================
--- linux-block-copy.orig/drivers/md/dm.c	2012-09-12 21:04:34.000000000 +0200
+++ linux-block-copy/drivers/md/dm.c	2012-09-12 21:07:09.000000000 +0200
@@ -71,6 +71,7 @@ struct dm_target_io {
 	struct dm_io *io;
 	struct dm_target *ti;
 	union map_info info;
+	struct bio clone;
 };
 
 /*
@@ -474,7 +475,7 @@ static void free_io(struct mapped_device
 
 static void free_tio(struct mapped_device *md, struct dm_target_io *tio)
 {
-	mempool_free(tio, md->tio_pool);
+	bio_put(&tio->clone);
 }
 
 static struct dm_rq_target_io *alloc_rq_tio(struct mapped_device *md,
@@ -711,7 +712,6 @@ static void clone_endio(struct bio *bio,
 	}
 
 	free_tio(md, tio);
-	bio_put(bio);
 	dec_pending(io, error);
 }
 
@@ -1027,12 +1027,12 @@ int dm_set_target_max_io_len(struct dm_t
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
-static void __map_bio(struct dm_target *ti, struct bio *clone,
-		      struct dm_target_io *tio)
+static void __map_bio(struct dm_target *ti, struct dm_target_io *tio)
 {
 	int r;
 	sector_t sector;
 	struct mapped_device *md;
+	struct bio *clone = &tio->clone;
 
 	clone->bi_end_io = clone_endio;
 	clone->bi_private = tio;
@@ -1056,7 +1056,6 @@ static void __map_bio(struct dm_target *
 		/* error the io and bail out, or requeue it if needed */
 		md = tio->io->md;
 		dec_pending(tio->io, r);
-		bio_put(clone);
 		free_tio(md, tio);
 	} else if (r) {
 		DMWARN("unimplemented target map return value: %d", r);
@@ -1077,14 +1076,13 @@ struct clone_info {
 /*
  * Creates a little bio that just does part of a bvec.
  */
-static struct bio *split_bvec(struct bio *bio, sector_t sector,
-			      unsigned short idx, unsigned int offset,
-			      unsigned int len, struct bio_set *bs)
+static void split_bvec(struct dm_target_io *tio, struct bio *bio,
+		       sector_t sector, unsigned short idx, unsigned int offset,
+		       unsigned int len, struct bio_set *bs)
 {
-	struct bio *clone;
+	struct bio *clone = &tio->clone;
 	struct bio_vec *bv = bio->bi_io_vec + idx;
 
-	clone = bio_alloc_bioset(GFP_NOIO, 1, bs);
 	*clone->bi_io_vec = *bv;
 
 	clone->bi_sector = sector;
@@ -1101,20 +1099,18 @@ static struct bio *split_bvec(struct bio
 		bio_integrity_trim(clone,
 				   bio_sector_offset(bio, idx, offset), len);
 	}
-
-	return clone;
 }
 
 /*
  * Creates a bio that consists of range of complete bvecs.
  */
-static struct bio *clone_bio(struct bio *bio, sector_t sector,
-			     unsigned short idx, unsigned short bv_count,
-			     unsigned int len, struct bio_set *bs)
+static void clone_bio(struct dm_target_io *tio, struct bio *bio,
+		      sector_t sector, unsigned short idx,
+		      unsigned short bv_count, unsigned int len,
+		      struct bio_set *bs)
 {
-	struct bio *clone;
+	struct bio *clone = &tio->clone;
 
-	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
 	__bio_clone(clone, bio);
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
@@ -1129,14 +1125,16 @@ static struct bio *clone_bio(struct bio 
 			bio_integrity_trim(clone,
 					   bio_sector_offset(bio, idx, 0), len);
 	}
-
-	return clone;
 }
 
 static struct dm_target_io *alloc_tio(struct clone_info *ci,
-				      struct dm_target *ti)
+				      struct dm_target *ti, int nr_iovecs)
 {
-	struct dm_target_io *tio = mempool_alloc(ci->md->tio_pool, GFP_NOIO);
+	struct dm_target_io *tio;
+	struct bio *clone;
+
+	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, ci->md->bs);
+	tio = container_of(clone, struct dm_target_io, clone);
 
 	tio->io = ci->io;
 	tio->ti = ti;
@@ -1148,8 +1146,8 @@ static struct dm_target_io *alloc_tio(st
 static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 				   unsigned request_nr, sector_t len)
 {
-	struct dm_target_io *tio = alloc_tio(ci, ti);
-	struct bio *clone;
+	struct dm_target_io *tio = alloc_tio(ci, ti, ci->bio->bi_max_vecs);
+	struct bio *clone = &tio->clone;
 
 	tio->info.target_request_nr = request_nr;
 
@@ -1158,14 +1156,13 @@ static void __issue_target_request(struc
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
-	clone = bio_clone_bioset(ci->bio, GFP_NOIO, ci->md->bs);
 
 	if (len) {
 		clone->bi_sector = ci->sector;
 		clone->bi_size = to_bytes(len);
 	}
 
-	__map_bio(ti, clone, tio);
+	__map_bio(ti, tio);
 }
 
 static void __issue_target_requests(struct clone_info *ci, struct dm_target *ti,
@@ -1194,14 +1191,13 @@ static int __clone_and_map_empty_flush(s
  */
 static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 {
-	struct bio *clone, *bio = ci->bio;
+	struct bio *bio = ci->bio;
 	struct dm_target_io *tio;
 
-	tio = alloc_tio(ci, ti);
-	clone = clone_bio(bio, ci->sector, ci->idx,
-			  bio->bi_vcnt - ci->idx, ci->sector_count,
-			  ci->md->bs);
-	__map_bio(ti, clone, tio);
+	tio = alloc_tio(ci, ti, bio->bi_max_vecs);
+	clone_bio(tio, bio, ci->sector, ci->idx, bio->bi_vcnt - ci->idx,
+		  ci->sector_count, ci->md->bs);
+	__map_bio(ti, tio);
 	ci->sector_count = 0;
 }
 
@@ -1239,7 +1235,7 @@ static int __clone_and_map_discard(struc
 
 static int __clone_and_map(struct clone_info *ci)
 {
-	struct bio *clone, *bio = ci->bio;
+	struct bio *bio = ci->bio;
 	struct dm_target *ti;
 	sector_t len = 0, max;
 	struct dm_target_io *tio;
@@ -1279,10 +1275,10 @@ static int __clone_and_map(struct clone_
 			len += bv_len;
 		}
 
-		tio = alloc_tio(ci, ti);
-		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
-				  ci->md->bs);
-		__map_bio(ti, clone, tio);
+		tio = alloc_tio(ci, ti, bio->bi_max_vecs);
+		clone_bio(tio, bio, ci->sector, ci->idx, i - ci->idx, len,
+			  ci->md->bs);
+		__map_bio(ti, tio);
 
 		ci->sector += len;
 		ci->sector_count -= len;
@@ -1307,12 +1303,11 @@ static int __clone_and_map(struct clone_
 
 			len = min(remaining, max);
 
-			tio = alloc_tio(ci, ti);
-			clone = split_bvec(bio, ci->sector, ci->idx,
-					   bv->bv_offset + offset, len,
-					   ci->md->bs);
+			tio = alloc_tio(ci, ti, 1);
+			split_bvec(tio, bio, ci->sector, ci->idx,
+				   bv->bv_offset + offset, len, ci->md->bs);
 
-			__map_bio(ti, clone, tio);
+			__map_bio(ti, tio);
 
 			ci->sector += len;
 			ci->sector_count -= len;
@@ -2733,7 +2728,8 @@ struct dm_md_mempools *dm_alloc_md_mempo
 		goto free_io_pool_and_out;
 
 	pools->bs = (type == DM_TYPE_BIO_BASED) ?
-		bioset_create(pool_size, 0) :
+		bioset_create(pool_size,
+			      offsetof(struct dm_target_io, clone)) :
 		bioset_create(pool_size,
 			      offsetof(struct dm_rq_clone_bio_info, clone));
 	if (!pools->bs)
