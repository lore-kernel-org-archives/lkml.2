Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab1HaGWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 02:22:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab1HaGWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 02:22:23 -0400
Date: Wed, 31 Aug 2011 16:22:11 +1000
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: md related oops triggered in bdev_inode_switch_bdi
Message-ID: <20110831162211.2a1fe3fb@notabene.brown>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christoph et. al.,

 My testing recently triggered an oops in bdi_lock_two called from
 bdev_inode_switch_bdi.
 The bdi and the request_queue that contains it had been freed.

 This happens with md which can free the md device and request queue
 immediately after last close.

 It seems that this is caused by your patch f758eeabeb96f8.
 Prior to that the 'old' bdi was never dereferenced in
 bdev_inode_switch_bdi.  Now it is.

 I think we can fix that by simply moving the call to bdev_inode_switch_bdi
 before the call to ->release as in the patch below.

 Do you see any problem with this patch?

Thanks,
NeilBrown


>From bcc5851cbb6876c97cce214feddd0ec092f7d71c Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 31 Aug 2011 15:37:22 +1000
Subject: [PATCH] Avoid dereferencing a 'request_queue' after last close.

On the last close of an 'md' device which as been stopped, the device
is destroyed and in particular the request_queue is freed.  The free
is done in a separate thread so it might happen a short time later.

__blkdev_put calls bdev_inode_switch_bdi *after* ->release has been
called.

Since commit f758eeabeb96f878c860e8f110f94ec8820822a9
bdev_inode_switch_bdi will dereference the 'old' bdi, which lives
inside a request_queue, to get a spin lock.  This causes the last
close on an md device to sometime take a spin_lock which lives in
freed memory - which results in an oops.

So move the called to bdev_inode_switch_bdi before the call to
->release.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: stable@kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/fs/block_dev.c b/fs/block_dev.c
index ff77262..d8a753f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1430,6 +1430,12 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		sync_blockdev(bdev);
 		kill_bdev(bdev);
 	}
+	if (!bdev->bd_openers)
+		/* ->release can cause the old bdi to disappear,
+		 * so must switch it out first
+		 */
+		bdev_inode_switch_bdi(bdev->bd_inode,
+					&default_backing_dev_info);
 	if (bdev->bd_contains == bdev) {
 		if (disk->fops->release)
 			ret = disk->fops->release(disk, mode);
@@ -1442,8 +1448,6 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
-		bdev_inode_switch_bdi(bdev->bd_inode,
-					&default_backing_dev_info);
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
