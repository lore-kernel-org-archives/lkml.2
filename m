Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136Ab2EYU1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:27:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53253 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739Ab2EYU0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:26:30 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: [PATCH v3 15/16] md: Kill merge_bvec_fn()s
Date: Fri, 25 May 2012 13:25:38 -0700
Message-Id: <1337977539-16977-16-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.9.3.327.g2980b
In-Reply-To: <1337977539-16977-1-git-send-email-koverstreet@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/linear.c |   46 ------------------------------
 drivers/md/raid0.c  |   62 +----------------------------------------
 drivers/md/raid1.c  |   34 -----------------------
 drivers/md/raid10.c |   77 +--------------------------------------------------
 4 files changed, 2 insertions(+), 217 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 7c6cafd..86e5405 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -52,51 +52,6 @@ static inline struct dev_info *which_dev(struct mddev *mddev, sector_t sector)
 	return conf->disks + lo;
 }
 
-/**
- *	linear_mergeable_bvec -- tell bio layer if two requests can be merged
- *	@q: request queue
- *	@bvm: properties of new bio
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can take at this offset
- */
-static int linear_mergeable_bvec(struct request_queue *q,
-				 struct bvec_merge_data *bvm,
-				 struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct dev_info *dev0;
-	unsigned long maxsectors, bio_sectors = bvm->bi_size >> 9;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	int maxbytes = biovec->bv_len;
-	struct request_queue *subq;
-
-	rcu_read_lock();
-	dev0 = which_dev(mddev, sector);
-	maxsectors = dev0->end_sector - sector;
-	subq = bdev_get_queue(dev0->rdev->bdev);
-	if (subq->merge_bvec_fn) {
-		bvm->bi_bdev = dev0->rdev->bdev;
-		bvm->bi_sector -= dev0->end_sector - dev0->rdev->sectors;
-		maxbytes = min(maxbytes, subq->merge_bvec_fn(subq, bvm,
-							     biovec));
-	}
-	rcu_read_unlock();
-
-	if (maxsectors < bio_sectors)
-		maxsectors = 0;
-	else
-		maxsectors -= bio_sectors;
-
-	if (maxsectors <= (PAGE_SIZE >> 9 ) && bio_sectors == 0)
-		return maxbytes;
-
-	if (maxsectors > (maxbytes >> 9))
-		return maxbytes;
-	else
-		return maxsectors << 9;
-}
-
 static int linear_congested(void *data, int bits)
 {
 	struct mddev *mddev = data;
@@ -209,7 +164,6 @@ static int linear_run (struct mddev *mddev)
 	mddev->private = conf;
 	md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
 
-	blk_queue_merge_bvec(mddev->queue, linear_mergeable_bvec);
 	mddev->queue->backing_dev_info.congested_fn = linear_congested;
 	mddev->queue->backing_dev_info.congested_data = mddev;
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 3469adf..5d463ef 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -340,59 +340,6 @@ static struct md_rdev *map_sector(struct mddev *mddev, struct strip_zone *zone,
 			     + sector_div(sector, zone->nb_dev)];
 }
 
-/**
- *	raid0_mergeable_bvec -- tell bio layer if two requests can be merged
- *	@q: request queue
- *	@bvm: properties of new bio
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can accept at this offset
- */
-static int raid0_mergeable_bvec(struct request_queue *q,
-				struct bvec_merge_data *bvm,
-				struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct r0conf *conf = mddev->private;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	sector_t sector_offset = sector;
-	int max;
-	unsigned int chunk_sectors = mddev->chunk_sectors;
-	unsigned int bio_sectors = bvm->bi_size >> 9;
-	struct strip_zone *zone;
-	struct md_rdev *rdev;
-	struct request_queue *subq;
-
-	if (is_power_of_2(chunk_sectors))
-		max =  (chunk_sectors - ((sector & (chunk_sectors-1))
-						+ bio_sectors)) << 9;
-	else
-		max =  (chunk_sectors - (sector_div(sector, chunk_sectors)
-						+ bio_sectors)) << 9;
-	if (max < 0)
-		max = 0; /* bio_add cannot handle a negative return */
-	if (max <= biovec->bv_len && bio_sectors == 0)
-		return biovec->bv_len;
-	if (max < biovec->bv_len)
-		/* too small already, no need to check further */
-		return max;
-	if (!conf->has_merge_bvec)
-		return max;
-
-	/* May need to check subordinate device */
-	sector = sector_offset;
-	zone = find_zone(mddev->private, &sector_offset);
-	rdev = map_sector(mddev, zone, sector, &sector_offset);
-	subq = bdev_get_queue(rdev->bdev);
-	if (subq->merge_bvec_fn) {
-		bvm->bi_bdev = rdev->bdev;
-		bvm->bi_sector = sector_offset + zone->dev_start +
-			rdev->data_offset;
-		return min(max, subq->merge_bvec_fn(subq, bvm, biovec));
-	} else
-		return max;
-}
-
 static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks)
 {
 	sector_t array_sectors = 0;
@@ -454,7 +401,6 @@ static int raid0_run(struct mddev *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-	blk_queue_merge_bvec(mddev->queue, raid0_mergeable_bvec);
 	dump_zones(mddev);
 
 	ret = md_integrity_register(mddev);
@@ -508,13 +454,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 	if (unlikely(!is_io_in_chunk_boundary(mddev, chunk_sects, bio))) {
 		sector_t sector = bio->bi_sector;
 		struct bio_pair *bp;
-		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
-			goto bad_map;
-		/* This is a one page bio that upper layers
-		 * refuse to split for us, so we need to split it.
-		 */
+
 		if (likely(is_power_of_2(chunk_sects)))
 			bp = bio_pair_split(bio, chunk_sects - (sector &
 							   (chunk_sects-1)));
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 15dd59b..78f9dcd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -615,39 +615,6 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	return best_disk;
 }
 
-static int raid1_mergeable_bvec(struct request_queue *q,
-				struct bvec_merge_data *bvm,
-				struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct r1conf *conf = mddev->private;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	int max = biovec->bv_len;
-
-	if (mddev->merge_check_needed) {
-		int disk;
-		rcu_read_lock();
-		for (disk = 0; disk < conf->raid_disks * 2; disk++) {
-			struct md_rdev *rdev = rcu_dereference(
-				conf->mirrors[disk].rdev);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = sector +
-						rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
-			}
-		}
-		rcu_read_unlock();
-	}
-	return max;
-
-}
-
 int md_raid1_congested(struct mddev *mddev, int bits)
 {
 	struct r1conf *conf = mddev->private;
@@ -2705,7 +2672,6 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		mddev->queue->backing_dev_info.congested_fn = raid1_congested;
 		mddev->queue->backing_dev_info.congested_data = mddev;
-		blk_queue_merge_bvec(mddev->queue, raid1_mergeable_bvec);
 	}
 
 	ret =  md_integrity_register(mddev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0062326..a6f14e7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -579,77 +579,6 @@ static sector_t raid10_find_virt(struct r10conf *conf, sector_t sector, int dev)
 	return (vchunk << conf->chunk_shift) + offset;
 }
 
-/**
- *	raid10_mergeable_bvec -- tell bio layer if a two requests can be merged
- *	@q: request queue
- *	@bvm: properties of new bio
- *	@biovec: the request that could be merged to it.
- *
- *	Return amount of bytes we can accept at this offset
- *	This requires checking for end-of-chunk if near_copies != raid_disks,
- *	and for subordinate merge_bvec_fns if merge_check_needed.
- */
-static int raid10_mergeable_bvec(struct request_queue *q,
-				 struct bvec_merge_data *bvm,
-				 struct bio_vec *biovec)
-{
-	struct mddev *mddev = q->queuedata;
-	struct r10conf *conf = mddev->private;
-	sector_t sector = bvm->bi_sector + get_start_sect(bvm->bi_bdev);
-	int max;
-	unsigned int chunk_sectors = mddev->chunk_sectors;
-	unsigned int bio_sectors = bvm->bi_size >> 9;
-
-	if (conf->near_copies < conf->raid_disks) {
-		max = (chunk_sectors - ((sector & (chunk_sectors - 1))
-					+ bio_sectors)) << 9;
-		if (max < 0)
-			/* bio_add cannot handle a negative return */
-			max = 0;
-		if (max <= biovec->bv_len && bio_sectors == 0)
-			return biovec->bv_len;
-	} else
-		max = biovec->bv_len;
-
-	if (mddev->merge_check_needed) {
-		struct r10bio r10_bio;
-		int s;
-		r10_bio.sector = sector;
-		raid10_find_phys(conf, &r10_bio);
-		rcu_read_lock();
-		for (s = 0; s < conf->copies; s++) {
-			int disk = r10_bio.devs[s].devnum;
-			struct md_rdev *rdev = rcu_dereference(
-				conf->mirrors[disk].rdev);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio.devs[s].addr
-						+ rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
-			}
-			rdev = rcu_dereference(conf->mirrors[disk].replacement);
-			if (rdev && !test_bit(Faulty, &rdev->flags)) {
-				struct request_queue *q =
-					bdev_get_queue(rdev->bdev);
-				if (q->merge_bvec_fn) {
-					bvm->bi_sector = r10_bio.devs[s].addr
-						+ rdev->data_offset;
-					bvm->bi_bdev = rdev->bdev;
-					max = min(max, q->merge_bvec_fn(
-							  q, bvm, biovec));
-				}
-			}
-		}
-		rcu_read_unlock();
-	}
-	return max;
-}
-
 /*
  * This routine returns the disk from which the requested read should
  * be done. There is a per-array 'next expected sequential IO' sector
@@ -994,9 +923,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 		return;
 	}
 
-	/* If this request crosses a chunk boundary, we need to
-	 * split it.  This will only happen for 1 PAGE (or less) requests.
-	 */
+	/* If this request crosses a chunk boundary, we need to split it. */
 	if (unlikely( (bio->bi_sector & conf->chunk_mask) + (bio->bi_size >> 9)
 		      > chunk_sects &&
 		    conf->near_copies < conf->raid_disks)) {
@@ -3380,8 +3307,6 @@ static int run(struct mddev *mddev)
 			mddev->queue->backing_dev_info.ra_pages = 2* stripe;
 	}
 
-	blk_queue_merge_bvec(mddev->queue, raid10_mergeable_bvec);
-
 	if (md_integrity_register(mddev))
 		goto out_free_conf;
 
-- 
1.7.9.3.327.g2980b

