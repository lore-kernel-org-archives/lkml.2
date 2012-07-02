Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab2GBNUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:20:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45358 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab2GBNUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:20:35 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: snitzer@redhat.com, david@fromorbit.com, dm-devel@redhat.com,
        xfs@oss.sgi.com, hch@lst.de, martin.petersen@oracle.com,
        axboe@kernel.dk
Subject: [PATCH v2 2/3] block: reorganize rounding of max_discard_sectors
Date: Mon,  2 Jul 2012 15:20:24 +0200
Message-Id: <1341235225-27551-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly a preparation for the next patch.

In principle this fixes an infinite loop if max_discard_sectors < granularity,
but that really shouldn't happen.

Cc: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-lib.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..16b06f6 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -44,6 +44,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors;
+	unsigned int granularity;
 	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
@@ -54,18 +55,18 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!blk_queue_discard(q))
 		return -EOPNOTSUPP;
 
+	/* Zero-sector (unknown) and one-sector granularities are the same.  */
+	granularity = max(q->limits.discard_granularity >> 9, 1U);
+
 	/*
 	 * Ensure that max_discard_sectors is of the proper
 	 * granularity
 	 */
 	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	max_discard_sectors = round_down(max_discard_sectors, granularity);
 	if (unlikely(!max_discard_sectors)) {
 		/* Avoid infinite loop below. Being cautious never hurts. */
 		return -EOPNOTSUPP;
-	} else if (q->limits.discard_granularity) {
-		unsigned int disc_sects = q->limits.discard_granularity >> 9;
-
-		max_discard_sectors &= ~(disc_sects - 1);
 	}
 
 	if (flags & BLKDEV_DISCARD_SECURE) {
-- 
1.7.1


