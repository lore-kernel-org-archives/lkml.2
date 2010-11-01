Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0KAQRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:17:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:46863 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534Ab0KAQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 12:17:03 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org,
        petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        aelder@sgi.com, dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        neilb@suse.de, leochen@broadcom.com, sbranden@broadcom.com,
        chris.mason@oracle.com, swhiteho@redhat.com, shaggy@linux.vnet.ibm.com,
        joern@logfs.org, konishi.ryusuke@lab.ntt.co.jp,
        reiserfs-devel@vger.kernel.org, viro@zeniv.linux.org.uk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] block: reorganize claim/release implementation
Date: Mon,  1 Nov 2010 17:15:29 +0100
Message-Id: <1288628129-12811-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Nov 2010 16:15:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With claim/release rolled into blkdev_get/put(), there's no reason to
keep bd_abort/finish_claim(), __bd_claim() and bd_release() as
separate functions.  It only makes the code difficult to follow.
Collapse them into blkdev_get/put().  This will ease future changes
around claim/release.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/block_dev.c |  127 +++++++++++++++++++++-----------------------------------
 1 files changed, 48 insertions(+), 79 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index fc48912..269bfbb 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -772,79 +772,6 @@ static struct block_device *bd_start_claiming(struct block_device *bdev,
 	}
 }
 
-/* releases bdev_lock */
-static void __bd_abort_claiming(struct block_device *whole, void *holder)
-{
-	BUG_ON(whole->bd_claiming != holder);
-	whole->bd_claiming = NULL;
-	wake_up_bit(&whole->bd_claiming, 0);
-
-	spin_unlock(&bdev_lock);
-	bdput(whole);
-}
-
-/**
- * bd_abort_claiming - abort claiming a block device
- * @whole: whole block device returned by bd_start_claiming()
- * @holder: holder trying to claim @bdev
- *
- * Abort a claiming block started by bd_start_claiming().  Note that
- * @whole is not the block device to be claimed but the whole device
- * returned by bd_start_claiming().
- *
- * CONTEXT:
- * Grabs and releases bdev_lock.
- */
-static void bd_abort_claiming(struct block_device *whole, void *holder)
-{
-	spin_lock(&bdev_lock);
-	__bd_abort_claiming(whole, holder);		/* releases bdev_lock */
-}
-
-/* increment holders when we have a legitimate claim. requires bdev_lock */
-static void __bd_claim(struct block_device *bdev, struct block_device *whole,
-					void *holder)
-{
-	/* note that for a whole device bd_holders
-	 * will be incremented twice, and bd_holder will
-	 * be set to bd_may_claim before being set to holder
-	 */
-	whole->bd_holders++;
-	whole->bd_holder = bd_may_claim;
-	bdev->bd_holders++;
-	bdev->bd_holder = holder;
-}
-
-/**
- * bd_finish_claiming - finish claiming a block device
- * @bdev: block device of interest (passed to bd_start_claiming())
- * @whole: whole block device returned by bd_start_claiming()
- * @holder: holder trying to claim @bdev
- *
- * Finish a claiming block started by bd_start_claiming().
- *
- * CONTEXT:
- * Grabs and releases bdev_lock.
- */
-static void bd_finish_claiming(struct block_device *bdev,
-				struct block_device *whole, void *holder)
-{
-	spin_lock(&bdev_lock);
-	BUG_ON(!bd_may_claim(bdev, whole, holder));
-	__bd_claim(bdev, whole, holder);
-	__bd_abort_claiming(whole, holder); /* not actually an abort */
-}
-
-static void bd_release(struct block_device *bdev)
-{
-	spin_lock(&bdev_lock);
-	if (!--bdev->bd_contains->bd_holders)
-		bdev->bd_contains->bd_holder = NULL;
-	if (!--bdev->bd_holders)
-		bdev->bd_holder = NULL;
-	spin_unlock(&bdev_lock);
-}
-
 #ifdef CONFIG_SYSFS
 static int add_symlink(struct kobject *from, struct kobject *to)
 {
@@ -1223,10 +1150,30 @@ int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder)
 	res = __blkdev_get(bdev, mode, 0);
 
 	if (whole) {
-		if (res == 0)
-			bd_finish_claiming(bdev, whole, holder);
-		else
-			bd_abort_claiming(whole, holder);
+		/* finish claiming */
+		spin_lock(&bdev_lock);
+
+		if (res == 0) {
+			BUG_ON(!bd_may_claim(bdev, whole, holder));
+			/*
+			 * Note that for a whole device bd_holders
+			 * will be incremented twice, and bd_holder
+			 * will be set to bd_may_claim before being
+			 * set to holder
+			 */
+			whole->bd_holders++;
+			whole->bd_holder = bd_may_claim;
+			bdev->bd_holders++;
+			bdev->bd_holder = holder;
+		}
+
+		/* tell others that we're done */
+		BUG_ON(whole->bd_claiming != holder);
+		whole->bd_claiming = NULL;
+		wake_up_bit(&whole->bd_claiming, 0);
+
+		spin_unlock(&bdev_lock);
+		bdput(whole);
 	}
 
 	return res;
@@ -1272,6 +1219,7 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		bdev->bd_part_count--;
 
 	if (!--bdev->bd_openers) {
+		WARN_ON_ONCE(bdev->bd_holders);
 		sync_blockdev(bdev);
 		kill_bdev(bdev);
 	}
@@ -1303,10 +1251,31 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 int blkdev_put(struct block_device *bdev, fmode_t mode)
 {
 	if (mode & FMODE_EXCL) {
+		bool bdev_free;
+
+		/*
+		 * Release a claim on the device.  The holder fields
+		 * are protected with bdev_lock.  bd_mutex is to
+		 * synchronize disk_holder unlinking.
+		 */
 		mutex_lock(&bdev->bd_mutex);
-		bd_release(bdev);
-		if (!bdev->bd_holders)
+		spin_lock(&bdev_lock);
+
+		WARN_ON_ONCE(--bdev->bd_holders < 0);
+		WARN_ON_ONCE(--bdev->bd_contains->bd_holders < 0);
+
+		/* bd_contains might point to self, check in a separate step */
+		if ((bdev_free = !bdev->bd_holders))
+			bdev->bd_holder = NULL;
+		if (!bdev->bd_contains->bd_holders)
+			bdev->bd_contains->bd_holder = NULL;
+
+		spin_unlock(&bdev_lock);
+
+		/* if this was the last claim, holder link should go too */
+		if (bdev_free)
 			bd_unlink_disk_holder(bdev);
+
 		mutex_unlock(&bdev->bd_mutex);
 	}
 	return __blkdev_put(bdev, mode, 0);
-- 
1.7.1

