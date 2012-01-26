Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2AZNfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:35:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258Ab2AZNfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:35:11 -0500
From: Niels de Vos <ndevos@redhat.com>
To: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Mikulas Patocka <mpatocka@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Niels de Vos <ndevos@redhat.com>, "Bryn M. Reeves" <bmr@redhat.com>
Subject: [PATCH v3] fs: Invalidate the cache for a parent block-device if fsync() is called for a partition
Date: Thu, 26 Jan 2012 13:33:22 +0000
Message-Id: <1327584802-14298-1-git-send-email-ndevos@redhat.com>
In-Reply-To: <4F213E1A.4060808@redhat.com>
References: <4F213E1A.4060808@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executing an fsync() on a file-descriptor of a partition flushes the
caches for that partition by calling blkdev_fsync(). However, it seems
that reading data through the parent device will still return the old
cached data.

The problem can be worked around by forcing the caches to be flushed
with either
	# blockdev --flushbufs ${dev_disk}
or
	# echo 3 > /proc/sys/vm/drop_caches

One of the use-cases that shows this problem:
1) create two or more partitions on a device
   - use fdisk to create /dev/sdb1 and /dev/sdb2
2) format and mount one of the partition
   - mkfs -t ext3 /dev/sdb1
3) read through the main device to have something in the cache
   - read /dev/sdb with dd or use something like "parted /dev/sdb print"
4) now write something to /dev/sdb2, format the partition for example
   - mkfs -t ext3 /dev/sdb2
5) read the blocks where sdb2 starts, through /dev/sdb
   - use dd or do again a "parted /dev/sdb print"

The cache for the block-device is not synced if the block-device is kept
open (due to a mounted partition, for example). Only when all users for
the disk have exited, the cache for the disk is made consistent again.

Without this patch, calling "blockdev --flushbufs" or dropping the
caches, the result in 5) is the same as in 3). Reading the same area
through /dev/sdb2 shows the inconsistancy between the two caches.

CC: Bryn M. Reeves <bmr@redhat.com>
Acked-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Niels de Vos <ndevos@redhat.com>

---
v3:
- Correct commit message, no need to mention blkdev_issue_flush().

- Include a use-case for giving a clearer understaning of the problem
  that is being addressed.

- Include received Acked-by and Reviewed-by, only the commit message
  changed in this v3.

v2:
- Do not call invalidate_bdev() from blkdev_issue_flush() and prevent
  performance degration with journalled filesystems.

  Suggested was to call invalidate_bdev() in fsync_bdev(), but this is
  not in the call-path of mkfs.ext3 and similar tools. Hence the issue
  persists.

- Correct phrasing a little, changing ioctl-BLKFLSBUF is not required.

- This issue also occurs when doing an ioctl-BLKFLSBUF on a partition.
  Reading the whole disk will still return cached data. If this is an
  issue, it will need a seperate patch.
---
 fs/block_dev.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0e575d1..433c4de 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -424,6 +424,10 @@ int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 	if (error == -EOPNOTSUPP)
 		error = 0;
 
+	/* invalidate parent block_device */
+	if (!error && bdev != bdev->bd_contains)
+		invalidate_bdev(bdev->bd_contains);
+
 	return error;
 }
 EXPORT_SYMBOL(blkdev_fsync);
-- 
1.7.6.5

