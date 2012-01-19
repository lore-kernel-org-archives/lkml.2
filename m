Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2ASIw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 03:52:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab2ASIw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 03:52:27 -0500
Message-ID: <4F17D95E.7070403@redhat.com>
Date: Thu, 19 Jan 2012 08:50:38 +0000
From: Niels de Vos <ndevos@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel@vger.kernel.org, Niels de Vos <ndevos@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>
Subject: [PATCH] block: Invalidate the cache for a parent block-device if
 blkdev_issue_flush() was called for a partition
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executing a BLKFLSBUF-ioctl on a partition flushes the caches for that
partition but reading data through the parent device will still return
the old cached data.

The cache for the block-device is not synced if the block-device is kept
open (due to a mounted partition, for example). Only when all users for
the disk have exited, the cache for the disk is made consistent again.

Calling invalidate_bdev() on the parent block-device in case
blkdev_issue_flush() was called for a partition fixes this.

The problem can be worked around by forcing the caches to be flushed
with either
	# blockdev --flushbufs ${dev_disk}
or
	# echo 3 > /proc/sys/vm/drop_caches

CC: Bryn M. Reeves <bmr@redhat.com>
Signed-off-by: Niels de Vos <ndevos@redhat.com>
---
 block/blk-flush.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 720ad60..e876f8e 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -448,6 +448,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 
 	if (!bio_flagged(bio, BIO_UPTODATE))
 		ret = -EIO;
+	else if (bdev != bdev->bd_contains)
+		/* invalidate parent block_device */
+		invalidate_bdev(bdev->bd_contains);
 
 	bio_put(bio);
 	return ret;
-- 
1.7.6.5

