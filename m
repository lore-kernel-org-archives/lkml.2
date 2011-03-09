Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab1CIJOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63889 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab1CIJOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HhoR0ydJ8Ok4GRUDkcGEGtFNZkfPsfsDMFuq4pHlIiTE/ljcA/VahhKAPPsph/Cr+h
         Z7JXz7umBmTYudXWxBCY7ZcL5SIciyBTw9xz8IUqaPKw8RrJxuIXMaVwD6L7/AZGAtj6
         Ah9NGRj+lNviTJQPIx2qyj3FWjtk2Muuin6Wc=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/16] block: Don't check events while open is in progress
Date: Wed,  9 Mar 2011 10:13:23 +0100
Message-Id: <1299662016-7721-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all block drivers clear events immediately after reporting.  Some
do so in ->revalidate_disk() or other steps during ->open().  There is
a slim chance event poll may happen between the clearing event check
from check_disk_change() and the actual clearing of the events which
would result in spurious events.

Block event checks while block device open is in progress.  There is
no need to kick explicit event check afterwards as events are always
checked during open.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 fs/block_dev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7dd2c65..b69cc0b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1087,6 +1087,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!disk)
 		goto out;
 
+	disk_block_events(disk);
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
@@ -1112,6 +1113,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					put_disk(disk);
 					bdev->bd_disk = NULL;
 					mutex_unlock(&bdev->bd_mutex);
+					disk_unblock_events(disk);
 					goto restart;
 				}
 				if (ret)
@@ -1165,6 +1167,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	if (for_part)
 		bdev->bd_part_count++;
 	mutex_unlock(&bdev->bd_mutex);
+	disk_unblock_events(disk);
 	return 0;
 
  out_clear:
@@ -1177,6 +1180,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	bdev->bd_contains = NULL;
  out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
+	disk_unblock_events(disk);
  out:
 	if (disk)
 		module_put(disk->fops->owner);
-- 
1.7.1

