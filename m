Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab1CIJOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:14:48 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49380 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab1CIJOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:14:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=RE4eJCEgbA2FutckcNW5DSaOx+FKE6qy+GC1iOgwwe4XbXu+lbxZ0/O7lqp1A6vNLy
         vaGMNK95wptteLUCNZKv6dSdJ60wc8SKzARFfgUM+B9etP9Lnt/MImT5mgXdk6a9gUT1
         yCNn3pJRgtRdiNPCcEc3EJ8OkSFOhPB/bJRPE=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/16] block: Don't implicitly trigger event check on disk_unblock_events()
Date: Wed,  9 Mar 2011 10:13:21 +0100
Message-Id: <1299662016-7721-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
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
index 3e2b57b..c91a2da 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1494,7 +1494,7 @@ void disk_block_events(struct gendisk *disk)
 void disk_unblock_events(struct gendisk *disk)
 {
 	if (disk->ev)
-		__disk_unblock_events(disk, true);
+		__disk_unblock_events(disk, false);
 }
 
 /**
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 8892870..fffdf86 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1446,6 +1446,7 @@ int blkdev_put(struct block_device *bdev, fmode_t mode)
 		if (bdev_free) {
 			if (bdev->bd_write_holder) {
 				disk_unblock_events(bdev->bd_disk);
+				disk_check_events(bdev->bd_disk);
 				bdev->bd_write_holder = false;
 			} else
 				disk_check_events(bdev->bd_disk);
-- 
1.7.1

