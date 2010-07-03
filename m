Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab0GCVsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 17:48:14 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53686 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0GCVrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 17:47:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/6] block: remove BKL from BLKROSET and BLKFLSBUF
Date: Sat,  3 Jul 2010 23:47:18 +0200
Message-Id: <1278193640-24223-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278193640-24223-1-git-send-email-arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18/L5K+AmfJKdfge60hznUjhC+SPfNhoMgtCWD
 D7wQFHIVL86M6OyiY527dGcqIc4yZRfEW2IOl2IMpPJhvrqPl2
 MzTlZLKtNnUXPeMIK4P4g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We only call the functions set_device_ro(),
invalidate_bdev(), sync_filesystem() and sync_blockdev()
while holding the BKL in these commands. All
of these are also done in other code paths without
the BKL, which leads me to the conclusion that
the BKL is not needed here either.

The reason we hold it here is that it was originally
pushed down into the ioctl function from vfs_ioctl.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/ioctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 9d91e83..60f477c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -197,10 +197,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (ret != -EINVAL && ret != -ENOTTY)
 			return ret;
 
-		lock_kernel();
 		fsync_bdev(bdev);
 		invalidate_bdev(bdev);
-		unlock_kernel();
 		return 0;
 
 	case BLKROSET:
@@ -212,9 +210,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			return -EACCES;
 		if (get_user(n, (int __user *)(arg)))
 			return -EFAULT;
-		lock_kernel();
 		set_device_ro(bdev, n);
-		unlock_kernel();
 		return 0;
 
 	case BLKDISCARD: {
-- 
1.7.1

