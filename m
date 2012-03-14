Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277Ab2CNRMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:12:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61849 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761238Ab2CNRMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:12:46 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] block: split discard into aligned requests
Date: Wed, 14 Mar 2012 18:12:28 +0100
Message-Id: <1331745148-24885-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
References: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a disk has a relatively large discard_granularity or small
max_discard_sectors, discards are not split with optimal alignment.
In the limit case of discard_granularity == max_discard_sectors, all
requests might be aligned incorrectly, so in fact you might end up
with no discarded logical blocks at all.

One example that helps showing how the patch works is with
discard_granularity == 64, max_discard_sectors == 128.  A request that is
submitted for 256 sectors 2..257 will be split in two: 2..129, 130..257.
However, only 2 aligned blocks out of 3 are included in the request;
128..191 may be left intact and not discarded.  With this patch, the
first request will be truncated to ensure good alignment of what's left,
and the split will be 2..127, 128..255, 256..257.  discard_alignment is
also taken into account.

At most one extra request will be introduced, because the first request
will be reduced by at most granularity-1 sectors, and granularity
must be less than max_discard_sectors.  Subsequent requests will run
on round_down(max_discard_sectors, granularity) sectors, as in the
current code.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-lib.c |   32 ++++++++++++++++++++++----------
 1 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d4bb160..837ce96 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -44,7 +44,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors;
-	unsigned int granularity;
+	unsigned int granularity, alignment, mask;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -57,10 +57,12 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
+	mask = granularity - 1;
+	alignment = (q->limits.discard_alignment >> 9) & mask;
 
 	/*
 	 * Ensure that max_discard_sectors is of the proper
-	 * granularity
+	 * granularity, so that requests stay aligned after a split.
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 	max_discard_sectors = round_down(max_discard_sectors, granularity);
@@ -80,25 +82,35 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	bb.wait = &wait;
 
 	while (nr_sects) {
+		unsigned int req_sects;
+		sector_t end_sect;
+
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio) {
 			ret = -ENOMEM;
 			break;
 		}
 
+		req_sects = min_t(sector_t, nr_sects, max_discard_sectors);
+
+		/*
+		 * If splitting a request, and the next starting sector would be
+		 * misaligned, stop the discard at the previous aligned sector.
+		 */
+		end_sect = sector + req_sects;
+		if (req_sects < nr_sects && (end_sect & mask) != alignment) {
+			end_sect = round_down(end_sect - alignment, granularity) + alignment;
+			req_sects = end_sect - sector;
+		}
+
 		bio->bi_sector = sector;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
 		bio->bi_private = &bb;
 
-		if (nr_sects > max_discard_sectors) {
-			bio->bi_size = max_discard_sectors << 9;
-			nr_sects -= max_discard_sectors;
-			sector += max_discard_sectors;
-		} else {
-			bio->bi_size = nr_sects << 9;
-			nr_sects = 0;
-		}
+		bio->bi_size = req_sects << 9;
+		nr_sects -= req_sects;
+		sector = end_sect;
 
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
-- 
1.7.7.6

