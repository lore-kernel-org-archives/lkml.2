Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0L1RcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 12:32:14 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:47220 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0L1R3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 12:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=eILIYBs3B9kZ1VSgzx37l+cqj5iTfPGhuhzIXtyUAc05YQl2+dM2Y3HMb0sppilFbd
         u0snnoVlTKKayoAhz2NqFe/patYIlXR9q63NSs48nM7lOiuMzbhG/206PCo7nlzoRRjr
         8AakzGT+sA/JkLyi7rc47hbLHRd+noX3iNt2s=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
        hch@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/16] block: don't check events while open is in progress
Date: Tue, 28 Dec 2010 18:28:59 +0100
Message-Id: <1293557352-10592-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293557352-10592-1-git-send-email-tj@kernel.org>
References: <1293557352-10592-1-git-send-email-tj@kernel.org>
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
index 58026da..f6390fd 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1016,6 +1016,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!disk)
 		goto out;
 
+	disk_block_events(disk);
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
 	if (!bdev->bd_openers) {
 		bdev->bd_disk = disk;
@@ -1041,6 +1042,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					put_disk(disk);
 					bdev->bd_disk = NULL;
 					mutex_unlock(&bdev->bd_mutex);
+					disk_unblock_events(disk);
 					goto restart;
 				}
 				if (ret)
@@ -1094,6 +1096,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	if (for_part)
 		bdev->bd_part_count++;
 	mutex_unlock(&bdev->bd_mutex);
+	disk_unblock_events(disk);
 	return 0;
 
  out_clear:
@@ -1106,6 +1109,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	bdev->bd_contains = NULL;
  out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
+	disk_unblock_events(disk);
  out:
 	if (disk)
 		module_put(disk->fops->owner);
-- 
1.7.1

