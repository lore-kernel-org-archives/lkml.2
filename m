Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759331Ab1EBOSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:18:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758655Ab1EBOSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:18:42 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH 3/3] blkdev: honor discard_granularity in blkdev_issue_discard()
Date: Mon,  2 May 2011 16:17:21 +0200
Message-Id: <1304345841-20063-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Jeff Moyer pointed out we do not honor discard granularity while
submitting REQ_DISCARD bios of size smaller than max_discard_sectors.
That fact might have unwanted consequences of device ignoring the
request, or even worse if device firmware is buggy.

This commit changes the behaviour so all discard bios smaller than
max_discard_sectors are aligned properly wrt discard_granularity.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
CC: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-lib.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d7a98d3..4019036 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -46,7 +46,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
-	unsigned int max_discard_sectors;
+	unsigned int max_discard_sectors, disc_sects;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -57,16 +57,14 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
+	disc_sects = q->limits.discard_granularity >> 9;
 	/*
 	 * Ensure that max_discard_sectors is of the proper
 	 * granularity
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
-	if (q->limits.discard_granularity) {
-		unsigned int disc_sects = q->limits.discard_granularity >> 9;
-
+	if (q->limits.discard_granularity)
 		max_discard_sectors &= ~(disc_sects - 1);
-	}
 
 	if (flags & BLKDEV_DISCARD_SECURE) {
 		if (!blk_queue_secdiscard(q))
@@ -95,7 +93,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			nr_sects -= max_discard_sectors;
 			sector += max_discard_sectors;
 		} else {
-			bio->bi_size = nr_sects << 9;
+			bio->bi_size = ((nr_sects & ~(disc_sects - 1)) << 9);
 			nr_sects = 0;
 		}
 
-- 
1.7.4.4

