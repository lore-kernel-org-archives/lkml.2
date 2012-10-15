Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2JOUYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:24:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56987 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2JOUJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:09:51 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 06/24] block: Change bio_split() to respect the current value of bi_idx
Date: Mon, 15 Oct 2012 13:08:40 -0700
Message-Id: <1350331769-14856-7-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current code bio_split() won't be seeing partially completed bios
so this doesn't change any behaviour, but this makes the code a bit
clearer as to what bio_split() actually requires.

The immediate purpose of the patch is removing unnecessary bi_idx
references, but the end goal is to allow partial completed bios to be
submitted, which along with immutable biovecs enables effecient bio
splitting.

Some of the callers were (double) checking that bios could be split, so
update their checks too.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Lars Ellenberg <drbd-dev@lists.linbit.com>
CC: Neil Brown <neilb@suse.de>
CC: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/block/drbd/drbd_req.c | 6 +++---
 drivers/md/raid0.c            | 3 +--
 drivers/md/raid10.c           | 3 +--
 fs/bio-integrity.c            | 4 ++--
 fs/bio.c                      | 7 +++----
 5 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 47f55db..382ada7 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1155,11 +1155,11 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 
 	/* can this bio be split generically?
 	 * Maybe add our own split-arbitrary-bios function. */
-	if (bio->bi_vcnt != 1 || bio->bi_idx != 0 || bio->bi_size > DRBD_MAX_BIO_SIZE) {
+	if (bio_segments(bio) != 1 || bio->bi_size > DRBD_MAX_BIO_SIZE) {
 		/* rather error out here than BUG in bio_split */
 		dev_err(DEV, "bio would need to, but cannot, be split: "
-		    "(vcnt=%u,idx=%u,size=%u,sector=%llu)\n",
-		    bio->bi_vcnt, bio->bi_idx, bio->bi_size,
+		    "(segments=%u,size=%u,sector=%llu)\n",
+		    bio_segments(bio), bio->bi_size,
 		    (unsigned long long)bio->bi_sector);
 		bio_endio(bio, -EINVAL);
 	} else {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 89016cb..769b3cb 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -510,8 +510,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		sector_t sector = bio->bi_sector;
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
+		if (bio_segments(bio) != 1)
 			goto bad_map;
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9715aaf..bbd08f5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1081,8 +1081,7 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 			 || conf->prev.near_copies < conf->prev.raid_disks))) {
 		struct bio_pair *bp;
 		/* Sanity check -- queue functions should prevent this happening */
-		if (bio->bi_vcnt != 1 ||
-		    bio->bi_idx != 0)
+		if (bio_segments(bio) != 1)
 			goto bad_map;
 		/* This is a one page bio that upper layers
 		 * refuse to split for us, so we need to split it.
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 8c4c604..ca7b02d 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -661,8 +661,8 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
 	bp->bio1.bi_integrity = &bp->bip1;
 	bp->bio2.bi_integrity = &bp->bip2;
 
-	bp->iv1 = bip->bip_vec[0];
-	bp->iv2 = bip->bip_vec[0];
+	bp->iv1 = bip->bip_vec[bip->bip_idx];
+	bp->iv2 = bip->bip_vec[bip->bip_idx];
 
 	bp->bip1.bip_vec = &bp->iv1;
 	bp->bip2.bip_vec = &bp->iv2;
diff --git a/fs/bio.c b/fs/bio.c
index dc3452e..4ae3382 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1616,8 +1616,7 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_sector + first_sectors);
 
-	BUG_ON(bi->bi_vcnt != 1 && bi->bi_vcnt != 0);
-	BUG_ON(bi->bi_idx != 0);
+	BUG_ON(bio_segments(bi) > 1);
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
 	bp->bio1 = *bi;
@@ -1627,8 +1626,8 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 	bp->bio1.bi_size = first_sectors << 9;
 
 	if (bi->bi_vcnt != 0) {
-		bp->bv1 = bi->bi_io_vec[0];
-		bp->bv2 = bi->bi_io_vec[0];
+		bp->bv1 = *bio_iovec(bi);
+		bp->bv2 = *bio_iovec(bi);
 
 		if (bio_is_rw(bi)) {
 			bp->bv2.bv_offset += first_sectors << 9;
-- 
1.7.12

