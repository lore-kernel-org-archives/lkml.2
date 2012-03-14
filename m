Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761264Ab2CNRMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:12:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35944 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761237Ab2CNRMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:12:43 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] block: tweak rounding of max_discard_sectors
Date: Wed, 14 Mar 2012 18:12:27 +0100
Message-Id: <1331745148-24885-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
References: <1331745148-24885-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly a preparation for the next patch.

In principle this fixes an infinite loop if max_discard_sectors < granularity,
but that really shouldn't happen.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-lib.c    |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2b461b4..d4bb160 100644
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
@@ -53,18 +54,18 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
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
1.7.7.6


