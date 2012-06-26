Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2FZP1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:27:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757853Ab2FZP1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:27:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc: tj@kernel.org, hch@infradead.org, jmoyer@redhat.com, vgoyal@redhat.com,
        dm-devel@redhat.com
Subject: [RFC PATCH] block: all callers should check blkdev_issue_flush's return
Date: Tue, 26 Jun 2012 11:27:25 -0400
Message-Id: <1340724445-3314-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is concerning that a FLUSH may fail but the blkdev_issue_flush
callers assume it will always succeed.

Each blkdev_issue_flush caller should come to terms with the reality
that a FLUSH may fail -- the file_operations' .fsync methods in
particular.  nilfs2 is the only filesystem that checks
blkdev_issue_flush's return.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ba43f40..76d6e48 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -968,7 +968,7 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 
 #define BLKDEV_DISCARD_SECURE  0x01    /* secure discard */
 
-extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
+extern int __must_check blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-- 
1.7.1

