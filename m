Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab0L1Rci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:32:38 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:47220 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab0L1R3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:29:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=F78qY9SBlPZhSOA5mgiIKcRIZNGzqIGDhZ31lADqgfoO8WaWrkYXgVsT2EOWo5vNfL
         xmbSqFc6YxW4sXqXNusXWisrOWsl5X17aKCKPAg0e+o5VbdkhsSFnt5ZzV+HAugq/QWI
         bvRWyN+Fs0nmerQJ+VaRWTdtOQ2BVdZ7P/zW8=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/16] block: don't implicitly trigger event check on disk_unblock_events()
Date: Tue, 28 Dec 2010 18:28:57 +0100
Message-Id: <1293557352-10592-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, disk_unblock_events() implicitly kick event check if the
block count reaches zero.  This behavior is not described in the
comment and hinders with future changes.  Make the unblocker
explicitly check events by calling disk_check_events() as necessary.

This patch doesn't cause any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 block/genhd.c  |    2 +-
 fs/block_dev.c |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5465a82..a1d41dc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1492,7 +1492,7 @@ void disk_block_events(struct gendisk *disk)
 void disk_unblock_events(struct gendisk *disk)
 {
 	if (disk->ev)
-		__disk_unblock_events(disk, true);
+		__disk_unblock_events(disk, false);
 }
 
 /**
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6017389..c620628 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1377,6 +1377,7 @@ int blkdev_put(struct block_device *bdev, fmode_t mode)
 			bd_unlink_disk_holder(bdev);
 			if (bdev->bd_write_holder) {
 				disk_unblock_events(bdev->bd_disk);
+				disk_check_events(bdev->bd_disk);
 				bdev->bd_write_holder = false;
 			} else
 				disk_check_events(bdev->bd_disk);
-- 
1.7.1

