Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab2JOUY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:24:26 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38591 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab2JOUJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:09:50 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com, "Ed L. Cashin" <ecashin@coraid.com>,
        Nick Piggin <npiggin@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Jim Paris <jim@jtan.com>, Geoff Levand <geoff@infradead.org>,
        Alasdair Kergon <agk@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v4 05/24] block: Use bio_sectors() more consistently
Date: Mon, 15 Oct 2012 13:08:39 -0700
Message-Id: <1350331769-14856-6-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bunch of places in the code weren't using it where they could be -
this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
into a struct bvec_iter.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: "Ed L. Cashin" <ecashin@coraid.com>
CC: Nick Piggin <npiggin@kernel.dk>
CC: Jiri Kosina <jkosina@suse.cz>
CC: Jim Paris <jim@jtan.com>
CC: Geoff Levand <geoff@infradead.org>
CC: Alasdair Kergon <agk@redhat.com>
CC: dm-devel@redhat.com
CC: Neil Brown <neilb@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/block/aoe/aoecmd.c   |  2 +-
 drivers/block/pktcdvd.c      |  2 +-
 drivers/md/dm-raid1.c        |  2 +-
 drivers/md/raid0.c           |  6 +++---
 drivers/md/raid1.c           | 17 ++++++++---------
 drivers/md/raid10.c          | 24 +++++++++++-------------
 drivers/md/raid5.c           |  8 ++++----
 include/trace/events/block.h | 10 +++++-----
 8 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index de0435e..2b52ebc 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -720,7 +720,7 @@ gettgt(struct aoedev *d, char *addr)
 static inline void
 diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector)
 {
-	unsigned long n_sect = bio->bi_size >> 9;
+	unsigned long n_sect = bio_sectors(bio);
 	const int rw = bio_data_dir(bio);
 	struct hd_struct *part;
 	int cpu;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 26938e8..2c27744 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2433,7 +2433,7 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		cloned_bio->bi_bdev = pd->bdev;
 		cloned_bio->bi_private = psd;
 		cloned_bio->bi_end_io = pkt_end_io_read_cloned;
-		pd->stats.secs_r += bio->bi_size >> 9;
+		pd->stats.secs_r += bio_sectors(bio);
 		pkt_queue_bio(pd, cloned_bio);
 		return;
 	}
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index bc5ddba8..3dac2de 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -457,7 +457,7 @@ static void map_region(struct dm_io_region *io, struct mirror *m,
 {
 	io->bdev = m->dev->bdev;
 	io->sector = map_sector(m, bio);
-	io->count = bio->bi_size >> 9;
+	io->count = bio_sectors(bio);
 }
 
 static void hold_bio(struct mirror_set *ms, struct bio *bio)
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index a9e4fa9..89016cb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -485,11 +485,11 @@ static inline int is_io_in_chunk_boundary(struct mddev *mddev,
 {
 	if (likely(is_power_of_2(chunk_sects))) {
 		return chunk_sects >= ((bio->bi_sector & (chunk_sects-1))
-					+ (bio->bi_size >> 9));
+					+ bio_sectors(bio));
 	} else{
 		sector_t sector = bio->bi_sector;
 		return chunk_sects >= (sector_div(sector, chunk_sects)
-						+ (bio->bi_size >> 9));
+						+ bio_sectors(bio));
 	}
 }
 
@@ -543,7 +543,7 @@ bad_map:
 	printk("md/raid0:%s: make_request bug: can't convert block across chunks"
 	       " or bigger than %dk %llu %d\n",
 	       mdname(mddev), chunk_sects / 2,
-	       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
+	       (unsigned long long)bio->bi_sector, bio_sectors(bio) / 2);
 
 	bio_io_error(bio);
 	return;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 32eab5b..deff0cd 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -267,7 +267,7 @@ static void raid_end_bio_io(struct r1bio *r1_bio)
 			 (bio_data_dir(bio) == WRITE) ? "write" : "read",
 			 (unsigned long long) bio->bi_sector,
 			 (unsigned long long) bio->bi_sector +
-			 (bio->bi_size >> 9) - 1);
+			 bio_sectors(bio) - 1);
 
 		call_bio_endio(r1_bio);
 	}
@@ -458,7 +458,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 					 " %llu-%llu\n",
 					 (unsigned long long) mbio->bi_sector,
 					 (unsigned long long) mbio->bi_sector +
-					 (mbio->bi_size >> 9) - 1);
+					 bio_sectors(mbio) - 1);
 				call_bio_endio(r1_bio);
 			}
 		}
@@ -1041,7 +1041,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 	r1_bio->master_bio = bio;
-	r1_bio->sectors = bio->bi_size >> 9;
+	r1_bio->sectors = bio_sectors(bio);
 	r1_bio->state = 0;
 	r1_bio->mddev = mddev;
 	r1_bio->sector = bio->bi_sector;
@@ -1119,7 +1119,7 @@ read_again:
 			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 			r1_bio->master_bio = bio;
-			r1_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+			r1_bio->sectors = bio_sectors(bio) - sectors_handled;
 			r1_bio->state = 0;
 			r1_bio->mddev = mddev;
 			r1_bio->sector = bio->bi_sector + sectors_handled;
@@ -1320,14 +1320,14 @@ read_again:
 	/* Mustn't call r1_bio_write_done before this next test,
 	 * as it could result in the bio being freed.
 	 */
-	if (sectors_handled < (bio->bi_size >> 9)) {
+	if (sectors_handled < bio_sectors(bio)) {
 		r1_bio_write_done(r1_bio);
 		/* We need another r1_bio.  It has already been counted
 		 * in bio->bi_phys_segments
 		 */
 		r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 		r1_bio->master_bio = bio;
-		r1_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+		r1_bio->sectors = bio_sectors(bio) - sectors_handled;
 		r1_bio->state = 0;
 		r1_bio->mddev = mddev;
 		r1_bio->sector = bio->bi_sector + sectors_handled;
@@ -1936,7 +1936,7 @@ static void sync_request_write(struct mddev *mddev, struct r1bio *r1_bio)
 		wbio->bi_rw = WRITE;
 		wbio->bi_end_io = end_sync_write;
 		atomic_inc(&r1_bio->remaining);
-		md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[i].rdev->bdev, bio_sectors(wbio));
 
 		generic_make_request(wbio);
 	}
@@ -2272,8 +2272,7 @@ read_more:
 			r1_bio = mempool_alloc(conf->r1bio_pool, GFP_NOIO);
 
 			r1_bio->master_bio = mbio;
-			r1_bio->sectors = (mbio->bi_size >> 9)
-					  - sectors_handled;
+			r1_bio->sectors = bio_sectors(mbio) - sectors_handled;
 			r1_bio->state = 0;
 			set_bit(R1BIO_ReadError, &r1_bio->state);
 			r1_bio->mddev = mddev;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1c2eb38..9715aaf 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1075,7 +1075,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	/* If this request crosses a chunk boundary, we need to
 	 * split it.  This will only happen for 1 PAGE (or less) requests.
 	 */
-	if (unlikely((bio->bi_sector & chunk_mask) + (bio->bi_size >> 9)
+	if (unlikely((bio->bi_sector & chunk_mask) + bio_sectors(bio)
 		     > chunk_sects
 		     && (conf->geo.near_copies < conf->geo.raid_disks
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
@@ -1115,7 +1115,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	bad_map:
 		printk("md/raid10:%s: make_request bug: can't convert block across chunks"
 		       " or bigger than %dk %llu %d\n", mdname(mddev), chunk_sects/2,
-		       (unsigned long long)bio->bi_sector, bio->bi_size >> 10);
+		       (unsigned long long)bio->bi_sector, bio_sectors(bio) / 2);
 
 		bio_io_error(bio);
 		return;
@@ -1130,7 +1130,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	 */
 	wait_barrier(conf);
 
-	sectors = bio->bi_size >> 9;
+	sectors = bio_sectors(bio);
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
 	    bio->bi_sector < conf->reshape_progress &&
 	    bio->bi_sector + sectors > conf->reshape_progress) {
@@ -1232,8 +1232,7 @@ read_again:
 			r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 			r10_bio->master_bio = bio;
-			r10_bio->sectors = ((bio->bi_size >> 9)
-					    - sectors_handled);
+			r10_bio->sectors = bio_sectors(bio) - sectors_handled;
 			r10_bio->state = 0;
 			r10_bio->mddev = mddev;
 			r10_bio->sector = bio->bi_sector + sectors_handled;
@@ -1455,7 +1454,7 @@ retry_write:
 	 * after checking if we need to go around again.
 	 */
 
-	if (sectors_handled < (bio->bi_size >> 9)) {
+	if (sectors_handled < bio_sectors(bio)) {
 		one_write_done(r10_bio);
 		/* We need another r10_bio.  It has already been counted
 		 * in bio->bi_phys_segments.
@@ -1463,7 +1462,7 @@ retry_write:
 		r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
 		r10_bio->master_bio = bio;
-		r10_bio->sectors = (bio->bi_size >> 9) - sectors_handled;
+		r10_bio->sectors = bio_sectors(bio) - sectors_handled;
 
 		r10_bio->mddev = mddev;
 		r10_bio->sector = bio->bi_sector + sectors_handled;
@@ -1984,7 +1983,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		atomic_inc(&r10_bio->remaining);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, tbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(tbio));
 
 		tbio->bi_sector += conf->mirrors[d].rdev->data_offset;
 		tbio->bi_bdev = conf->mirrors[d].rdev->bdev;
@@ -2009,7 +2008,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 		d = r10_bio->devs[i].devnum;
 		atomic_inc(&r10_bio->remaining);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     tbio->bi_size >> 9);
+			     bio_sectors(tbio));
 		generic_make_request(tbio);
 	}
 
@@ -2135,13 +2134,13 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	wbio2 = r10_bio->devs[1].repl_bio;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-		md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
+		md_sync_acct(conf->mirrors[d].rdev->bdev, bio_sectors(wbio));
 		generic_make_request(wbio);
 	}
 	if (wbio2 && wbio2->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
-			     wbio2->bi_size >> 9);
+			     bio_sectors(wbio2));
 		generic_make_request(wbio2);
 	}
 }
@@ -2571,8 +2570,7 @@ read_more:
 		r10_bio = mempool_alloc(conf->r10bio_pool,
 					GFP_NOIO);
 		r10_bio->master_bio = mbio;
-		r10_bio->sectors = (mbio->bi_size >> 9)
-			- sectors_handled;
+		r10_bio->sectors = bio_sectors(mbio) - sectors_handled;
 		r10_bio->state = 0;
 		set_bit(R10BIO_ReadError,
 			&r10_bio->state);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 45a632c..cbfc424 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -88,7 +88,7 @@ static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
  */
 static inline struct bio *r5_next_bio(struct bio *bio, sector_t sector)
 {
-	int sectors = bio->bi_size >> 9;
+	int sectors = bio_sectors(bio);
 	if (bio->bi_sector + sectors < sector + STRIPE_SECTORS)
 		return bio->bi_next;
 	else
@@ -3771,7 +3771,7 @@ static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
 {
 	sector_t sector = bio->bi_sector + get_start_sect(bio->bi_bdev);
 	unsigned int chunk_sectors = mddev->chunk_sectors;
-	unsigned int bio_sectors = bio->bi_size >> 9;
+	unsigned int bio_sectors = bio_sectors(bio);
 
 	if (mddev->new_chunk_sectors < mddev->chunk_sectors)
 		chunk_sectors = mddev->new_chunk_sectors;
@@ -3861,7 +3861,7 @@ static int bio_fits_rdev(struct bio *bi)
 {
 	struct request_queue *q = bdev_get_queue(bi->bi_bdev);
 
-	if ((bi->bi_size>>9) > queue_max_sectors(q))
+	if (bio_sectors(bi) > queue_max_sectors(q))
 		return 0;
 	blk_recount_segments(q, bi);
 	if (bi->bi_phys_segments > queue_max_segments(q))
@@ -3931,7 +3931,7 @@ static int chunk_aligned_read(struct mddev *mddev, struct bio * raid_bio)
 		align_bi->bi_flags &= ~(1 << BIO_SEG_VALID);
 
 		if (!bio_fits_rdev(align_bi) ||
-		    is_badblock(rdev, align_bi->bi_sector, align_bi->bi_size>>9,
+		    is_badblock(rdev, align_bi->bi_sector, bio_sectors(align_bi),
 				&first_bad, &bad_sectors)) {
 			/* too big in some way, or has a known bad block */
 			bio_put(align_bi);
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 05c5e61..3c210ac 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -193,7 +193,7 @@ TRACE_EVENT(block_bio_bounce,
 		__entry->dev		= bio->bi_bdev ?
 					  bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -230,7 +230,7 @@ TRACE_EVENT(block_bio_complete,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		__entry->error		= error;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 	),
@@ -258,7 +258,7 @@ DECLARE_EVENT_CLASS(block_bio,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
 	),
@@ -330,7 +330,7 @@ DECLARE_EVENT_CLASS(block_get_rq,
 	TP_fast_assign(
 		__entry->dev		= bio ? bio->bi_bdev->bd_dev : 0;
 		__entry->sector		= bio ? bio->bi_sector : 0;
-		__entry->nr_sector	= bio ? bio->bi_size >> 9 : 0;
+		__entry->nr_sector	= bio ? bio_sectors(bio) : 0;
 		blk_fill_rwbs(__entry->rwbs,
 			      bio ? bio->bi_rw : 0, __entry->nr_sector);
 		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);
@@ -506,7 +506,7 @@ TRACE_EVENT(block_bio_remap,
 	TP_fast_assign(
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
-		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->nr_sector	= bio_sectors(bio);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
-- 
1.7.12

