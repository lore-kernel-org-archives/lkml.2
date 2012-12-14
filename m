Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab2LNDPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 22:15:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51167 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621Ab2LNDPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 22:15:44 -0500
Date: Fri, 14 Dec 2012 11:15:36 +0800
From: Shaohua Li <shli@kernel.org>
To: axboe@kernel.dk
Cc: neilb@suse.de, linux-kernel@vger.kernel.org
Subject: [patch 1/2]block: discard granularity might not be power of 2
Message-ID: <20121214031536.GA30345@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In MD raid case, discard granularity might not be power of 2, for example, a
4-disk raid5 has 3*chunk_size discard granularity. Correct the calculation for
such cases.

Reported-by: Neil Brown <neilb@suse.de>
Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-lib.c        |   23 +++++++++++++----------
 block/blk-settings.c   |    6 +++---
 include/linux/blkdev.h |    7 ++++---
 3 files changed, 20 insertions(+), 16 deletions(-)

Index: linux/block/blk-lib.c
===================================================================
--- linux.orig/block/blk-lib.c	2012-10-15 10:01:52.763544641 +0800
+++ linux/block/blk-lib.c	2012-12-14 08:56:24.539932760 +0800
@@ -43,8 +43,8 @@ int blkdev_issue_discard(struct block_de
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
-	unsigned int max_discard_sectors;
-	unsigned int granularity, alignment, mask;
+	sector_t max_discard_sectors;
+	sector_t granularity, alignment;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -57,15 +57,16 @@ int blkdev_issue_discard(struct block_de
 
 	/* Zero-sector (unknown) and one-sector granularities are the same.  */
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
-	mask = granularity - 1;
-	alignment = (bdev_discard_alignment(bdev) >> 9) & mask;
+	alignment = bdev_discard_alignment(bdev) >> 9;
+	alignment = sector_div(alignment, granularity);
 
 	/*
 	 * Ensure that max_discard_sectors is of the proper
 	 * granularity, so that requests stay aligned after a split.
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	max_discard_sectors = round_down(max_discard_sectors, granularity);
+	sector_div(max_discard_sectors, granularity);
+	max_discard_sectors *= granularity;
 	if (unlikely(!max_discard_sectors)) {
 		/* Avoid infinite loop below. Being cautious never hurts. */
 		return -EOPNOTSUPP;
@@ -83,7 +84,7 @@ int blkdev_issue_discard(struct block_de
 
 	while (nr_sects) {
 		unsigned int req_sects;
-		sector_t end_sect;
+		sector_t end_sect, tmp;
 
 		bio = bio_alloc(gfp_mask, 1);
 		if (!bio) {
@@ -98,10 +99,12 @@ int blkdev_issue_discard(struct block_de
 		 * misaligned, stop the discard at the previous aligned sector.
 		 */
 		end_sect = sector + req_sects;
-		if (req_sects < nr_sects && (end_sect & mask) != alignment) {
-			end_sect =
-				round_down(end_sect - alignment, granularity)
-				+ alignment;
+		tmp = end_sect;
+		if (req_sects < nr_sects &&
+		    sector_div(tmp, granularity) != alignment) {
+			end_sect = end_sect - alignment;
+			sector_div(end_sect, granularity);
+			end_sect = end_sect * granularity + alignment;
 			req_sects = end_sect - sector;
 		}
 
Index: linux/block/blk-settings.c
===================================================================
--- linux.orig/block/blk-settings.c	2012-10-15 10:01:52.763544641 +0800
+++ linux/block/blk-settings.c	2012-12-14 09:53:18.493013557 +0800
@@ -611,7 +611,7 @@ int blk_stack_limits(struct queue_limits
 			bottom = b->discard_granularity + alignment;
 
 			/* Verify that top and bottom intervals line up */
-			if (max(top, bottom) & (min(top, bottom) - 1))
+			if ((max(top, bottom) % min(top, bottom)) != 0)
 				t->discard_misaligned = 1;
 		}
 
@@ -619,8 +619,8 @@ int blk_stack_limits(struct queue_limits
 						      b->max_discard_sectors);
 		t->discard_granularity = max(t->discard_granularity,
 					     b->discard_granularity);
-		t->discard_alignment = lcm(t->discard_alignment, alignment) &
-			(t->discard_granularity - 1);
+		t->discard_alignment = lcm(t->discard_alignment, alignment) %
+			t->discard_granularity;
 	}
 
 	return ret;
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2012-10-15 10:01:52.999541673 +0800
+++ linux/include/linux/blkdev.h	2012-12-13 14:26:25.469877308 +0800
@@ -1180,13 +1180,14 @@ static inline int queue_discard_alignmen
 
 static inline int queue_limit_discard_alignment(struct queue_limits *lim, sector_t sector)
 {
-	unsigned int alignment = (sector << 9) & (lim->discard_granularity - 1);
+	sector_t alignment = sector << 9;
+	alignment = sector_div(alignment, lim->discard_granularity);
 
 	if (!lim->max_discard_sectors)
 		return 0;
 
-	return (lim->discard_granularity + lim->discard_alignment - alignment)
-		& (lim->discard_granularity - 1);
+	alignment = lim->discard_granularity + lim->discard_alignment - alignment;
+	return sector_div(alignment, lim->discard_granularity);
 }
 
 static inline int bdev_discard_alignment(struct block_device *bdev)
