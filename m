Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2JOUQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:16:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab2JOUKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:10:35 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de
Subject: [PATCH v2 05/26] block: Add bio_end()
Date: Mon, 15 Oct 2012 13:09:08 -0700
Message-Id: <1350331769-14856-35-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a little convenience macro - main reason to add it now is preparing
for immutable bio vecs, it'll reduce the size of the patch that puts
bi_sector/bi_size/bi_idx into a struct bvec_iter.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c              |  2 +-
 block/cfq-iosched.c           |  7 ++-----
 block/deadline-iosched.c      |  2 +-
 drivers/block/drbd/drbd_req.c |  2 +-
 drivers/block/pktcdvd.c       |  6 +++---
 drivers/md/dm-stripe.c        |  2 +-
 drivers/md/dm-verity.c        |  2 +-
 drivers/md/faulty.c           |  6 ++----
 drivers/md/linear.c           |  3 +--
 drivers/md/raid1.c            |  4 ++--
 drivers/md/raid5.c            | 14 +++++++-------
 drivers/s390/block/dcssblk.c  |  3 +--
 fs/btrfs/extent_io.c          |  3 +--
 fs/gfs2/lops.c                |  2 +-
 include/linux/bio.h           |  1 +
 15 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 55c833c9..97511cb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1557,7 +1557,7 @@ static void handle_bad_sector(struct bio *bio)
 	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
 			bdevname(bio->bi_bdev, b),
 			bio->bi_rw,
-			(unsigned long long)bio->bi_sector + bio_sectors(bio),
+			(unsigned long long)bio_end(bio),
 			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
 
 	set_bit(BIO_EOF, &bio->bi_flags);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fb52df9..8eae0f3 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1883,11 +1883,8 @@ cfq_find_rq_fmerge(struct cfq_data *cfqd, struct bio *bio)
 		return NULL;
 
 	cfqq = cic_to_cfqq(cic, cfq_bio_sync(bio));
-	if (cfqq) {
-		sector_t sector = bio->bi_sector + bio_sectors(bio);
-
-		return elv_rb_find(&cfqq->sort_list, sector);
-	}
+	if (cfqq)
+		return elv_rb_find(&cfqq->sort_list, bio_end(bio));
 
 	return NULL;
 }
diff --git a/block/deadline-iosched.c b/block/deadline-iosched.c
index 599b12e..a3b4df9 100644
--- a/block/deadline-iosched.c
+++ b/block/deadline-iosched.c
@@ -132,7 +132,7 @@ deadline_merge(struct request_queue *q, struct request **req, struct bio *bio)
 	 * check for front merge
 	 */
 	if (dd->front_merges) {
-		sector_t sector = bio->bi_sector + bio_sectors(bio);
+		sector_t sector = bio_end(bio);
 
 		__rq = elv_rb_find(&dd->sort_list[bio_data_dir(bio)], sector);
 		if (__rq) {
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 01b2ac6..af69a96 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1144,7 +1144,7 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	/* to make some things easier, force alignment of requests within the
 	 * granularity of our hash tables */
 	s_enr = bio->bi_sector >> HT_SHIFT;
-	e_enr = bio->bi_size ? (bio->bi_sector+(bio->bi_size>>9)-1) >> HT_SHIFT : s_enr;
+	e_enr = (bio_end(bio) - 1) >> HT_SHIFT;
 
 	if (likely(s_enr == e_enr)) {
 		do {
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 2e7de7a..8df3216 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -901,7 +901,7 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
 			pd->iosched.successive_reads += bio->bi_size >> 10;
 		else {
 			pd->iosched.successive_reads = 0;
-			pd->iosched.last_write = bio->bi_sector + bio_sectors(bio);
+			pd->iosched.last_write = bio_end(bio);
 		}
 		if (pd->iosched.successive_reads >= HI_SPEED_SWITCH) {
 			if (pd->read_speed == pd->write_speed) {
@@ -2454,7 +2454,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	zone = ZONE(bio->bi_sector, pd);
 	VPRINTK("pkt_make_request: start = %6llx stop = %6llx\n",
 		(unsigned long long)bio->bi_sector,
-		(unsigned long long)(bio->bi_sector + bio_sectors(bio)));
+		(unsigned long long)bio_end(bio));
 
 	/* Check if we have to split the bio */
 	{
@@ -2462,7 +2462,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		sector_t last_zone;
 		int first_sectors;
 
-		last_zone = ZONE(bio->bi_sector + bio_sectors(bio) - 1, pd);
+		last_zone = ZONE(bio_end(bio) - 1, pd);
 		if (last_zone != zone) {
 			BUG_ON(last_zone != zone + pd->settings.size);
 			first_sectors = last_zone - bio->bi_sector;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a087bf2..047dd08 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -257,7 +257,7 @@ static int stripe_map_discard(struct stripe_c *sc, struct bio *bio,
 	sector_t begin, end;
 
 	stripe_map_range_sector(sc, bio->bi_sector, target_stripe, &begin);
-	stripe_map_range_sector(sc, bio->bi_sector + bio_sectors(bio),
+	stripe_map_range_sector(sc, bio_end(bio),
 				target_stripe, &end);
 	if (begin < end) {
 		bio->bi_bdev = sc->stripe[target_stripe].dev->bdev;
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index 254d192..18ef6c5 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -477,7 +477,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio,
 		return -EIO;
 	}
 
-	if ((bio->bi_sector + bio_sectors(bio)) >>
+	if (bio_end(bio) >>
 	    (v->data_dev_block_bits - SECTOR_SHIFT) > v->data_blocks) {
 		DMERR_LIMIT("io out of range");
 		return -EIO;
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 45135f6..a4d0ebd 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -185,8 +185,7 @@ static void make_request(struct mddev *mddev, struct bio *bio)
 			return;
 		}
 
-		if (check_sector(conf, bio->bi_sector, bio->bi_sector+(bio->bi_size>>9),
-				 WRITE))
+		if (check_sector(conf, bio->bi_sector, bio_end(bio), WRITE))
 			failit = 1;
 		if (check_mode(conf, WritePersistent)) {
 			add_sector(conf, bio->bi_sector, WritePersistent);
@@ -196,8 +195,7 @@ static void make_request(struct mddev *mddev, struct bio *bio)
 			failit = 1;
 	} else {
 		/* read request */
-		if (check_sector(conf, bio->bi_sector, bio->bi_sector + (bio->bi_size>>9),
-				 READ))
+		if (check_sector(conf, bio->bi_sector, bio_end(bio), READ))
 			failit = 1;
 		if (check_mode(conf, ReadTransient))
 			failit = 1;
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index fa211d8..3fc843c 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -304,8 +304,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 		bio_io_error(bio);
 		return;
 	}
-	if (unlikely(bio->bi_sector + (bio->bi_size >> 9) >
-		     tmp_dev->end_sector)) {
+	if (unlikely(bio_end(bio) > tmp_dev->end_sector)) {
 		/* This bio crosses a device boundary, so we have to
 		 * split it.
 		 */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 611b5f7..a242578 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1010,7 +1010,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	md_write_start(mddev, bio); /* wait on superblock update early */
 
 	if (bio_data_dir(bio) == WRITE &&
-	    bio->bi_sector + bio->bi_size/512 > mddev->suspend_lo &&
+	    bio_end(bio) > mddev->suspend_lo &&
 	    bio->bi_sector < mddev->suspend_hi) {
 		/* As the suspend_* range is controlled by
 		 * userspace, we want an interruptible
@@ -1021,7 +1021,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 			flush_signals(current);
 			prepare_to_wait(&conf->wait_barrier,
 					&w, TASK_INTERRUPTIBLE);
-			if (bio->bi_sector + bio->bi_size/512 <= mddev->suspend_lo ||
+			if (bio_end(bio) <= mddev->suspend_lo ||
 			    bio->bi_sector >= mddev->suspend_hi)
 				break;
 			schedule();
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index adda94d..7b36e2a 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2377,11 +2377,11 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 	} else
 		bip = &sh->dev[dd_idx].toread;
 	while (*bip && (*bip)->bi_sector < bi->bi_sector) {
-		if ((*bip)->bi_sector + ((*bip)->bi_size >> 9) > bi->bi_sector)
+		if (bio_end(*bip) > bi->bi_sector)
 			goto overlap;
 		bip = & (*bip)->bi_next;
 	}
-	if (*bip && (*bip)->bi_sector < bi->bi_sector + ((bi->bi_size)>>9))
+	if (*bip && (*bip)->bi_sector < bio_end(bi))
 		goto overlap;
 
 	BUG_ON(*bip && bi->bi_next && (*bip) != bi->bi_next);
@@ -2397,8 +2397,8 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx, in
 		     sector < sh->dev[dd_idx].sector + STRIPE_SECTORS &&
 			     bi && bi->bi_sector <= sector;
 		     bi = r5_next_bio(bi, sh->dev[dd_idx].sector)) {
-			if (bi->bi_sector + (bi->bi_size>>9) >= sector)
-				sector = bi->bi_sector + (bi->bi_size>>9);
+			if (bio_end(bi) >= sector)
+				sector = bio_end(bi);
 		}
 		if (sector >= sh->dev[dd_idx].sector + STRIPE_SECTORS)
 			set_bit(R5_OVERWRITE, &sh->dev[dd_idx].flags);
@@ -3908,7 +3908,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 						    0,
 						    &dd_idx, NULL);
 
-	end_sector = align_bi->bi_sector + (align_bi->bi_size >> 9);
+	end_sector = bio_end(align_bi);
 	rcu_read_lock();
 	rdev = rcu_dereference(conf->disks[dd_idx].replacement);
 	if (!rdev || test_bit(Faulty, &rdev->flags) ||
@@ -4090,7 +4090,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 		return;
 
 	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
-	last_sector = bi->bi_sector + (bi->bi_size>>9);
+	last_sector = bio_end(bi);
 	bi->bi_next = NULL;
 	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
 
@@ -4553,7 +4553,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	logical_sector = raid_bio->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
 	sector = raid5_compute_sector(conf, logical_sector,
 				      0, &dd_idx, NULL);
-	last_sector = raid_bio->bi_sector + (raid_bio->bi_size>>9);
+	last_sector = bio_end(raid_bio);
 
 	for (; logical_sector < last_sector;
 	     logical_sector += STRIPE_SECTORS,
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index a5a55da..52f88b7 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -832,8 +832,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	if ((bio->bi_sector & 7) != 0 || (bio->bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
 		goto fail;
-	if (((bio->bi_size >> 9) + bio->bi_sector)
-			> get_capacity(bio->bi_bdev->bd_disk)) {
+	if (bio_end(bio) > get_capacity(bio->bi_bdev->bd_disk)) {
 		/* Request beyond end of DCSS segment. */
 		goto fail;
 	}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4c87847..435274a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2480,8 +2480,7 @@ static int submit_extent_page(int rw, struct extent_io_tree *tree,
 		if (old_compressed)
 			contig = bio->bi_sector == sector;
 		else
-			contig = bio->bi_sector + (bio->bi_size >> 9) ==
-				sector;
+			contig = bio_end(bio) == sector;
 
 		if (prev_bio_flags != bio_flags || !contig ||
 		    merge_bio(tree, page, offset, page_size, bio, bio_flags) ||
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 8ff95a2..fc28f99 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -300,7 +300,7 @@ static struct bio *gfs2_log_get_bio(struct gfs2_sbd *sdp, u64 blkno)
 	u64 nblk;
 
 	if (bio) {
-		nblk = bio->bi_sector + bio_sectors(bio);
+		nblk = bio_end(bio);
 		nblk >>= sdp->sd_fsb2bb_shift;
 		if (blkno == nblk)
 			return bio;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 6763cdf..92bff0e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -67,6 +67,7 @@
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
+#define bio_end(bio)		((bio)->bi_sector + bio_sectors(bio))
 
 static inline unsigned int bio_cur_bytes(struct bio *bio)
 {
-- 
1.7.12

