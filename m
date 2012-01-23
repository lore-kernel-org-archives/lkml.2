Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab2AWKkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 05:40:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab2AWKks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 05:40:48 -0500
From: Niels de Vos <ndevos@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niels de Vos <ndevos@redhat.com>,
        "Bryn M. Reeves" <bmr@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH v2] fs: Invalidate the cache for a parent block-device if fsync() is called for a partition
Date: Mon, 23 Jan 2012 10:38:29 +0000
Message-Id: <1327315109-7740-1-git-send-email-ndevos@redhat.com>
In-Reply-To: <4F19356E.3020708@redhat.com>
References: <4F19356E.3020708@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Executing an fsync() on a file-descriptor of a partition flushes the
caches for that partition by calling blkdev_issue_flush(). However, it
seems that reading data through the parent device will still return the
old cached data.

The cache for the block-device is not synced if the block-device is kept
open (due to a mounted partition, for example). Only when all users for
the disk have exited, the cache for the disk is made consistent again.

Calling invalidate_bdev() on the parent block-device in case
blkdev_fsync() was called for a partition, fixes this.

The problem can be worked around by forcing the caches to be flushed
with either
	# blockdev --flushbufs ${dev_disk}
or
	# echo 3 > /proc/sys/vm/drop_caches

CC: Bryn M. Reeves <bmr@redhat.com>
CC: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Niels de Vos <ndevos@redhat.com>

---
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

