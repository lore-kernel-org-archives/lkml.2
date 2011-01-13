Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab1AMRVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:21:41 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65362 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab1AMRVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bSNRV1rnnrxGMmPKrSZBiudFQQik/nYT65jTK5IPi7ken6b0OyhMnXNIKxkLw8RJqe
         Q8rFEbyFj5CVxsXkuyWGBiRQjtBA46q2vkS29qw/2f+CeuhDD9EQEpweI/4u2iLIjLMA
         5UresR0xJf0DWc18nVfZVZ8w+v19B5x/VI7bE=
Date: Thu, 13 Jan 2011 18:21:33 +0100
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Milan Broz <mbroz@redhat.com>, Valdis.Kletnieks@vt.edu,
        Alexander Viro <viro@zeniv.linux.org.uk>, Neil Brown <neilb@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] block: restore multiple bd_link_disk_holder() support
Message-ID: <20110113172133.GE14096@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2E6129.8000700@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e09b457b (block: simplify holder symlink handling) incorrectly
assumed that there is only one holder at maximum.  dm may use multiple
holders.  Remove the single holder assumption and automatic removal of
the link.  Let the callers explicitly remove them.  This change makes
it even more alien from the rest of the block layer.

While at it, note that this facility should not be used by anyone else
than the current ones.  Sysfs symlinks shouldn't be abused like this
and the whole thing doesn't belong in the block layer at all.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Milan Broz <mbroz@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
Milan, Jun, can you guys please verify this works correctly for the
multi holder dm case?  Thank you.

 drivers/md/dm-table.c |    1 +
 drivers/md/md.c       |    1 +
 fs/block_dev.c        |   28 +++++++++++++++-------------
 include/linux/fs.h    |    9 ++++++---
 4 files changed, 23 insertions(+), 16 deletions(-)

Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -663,9 +663,6 @@ struct block_device {
 	void *			bd_holder;
 	int			bd_holders;
 	bool			bd_write_holder;
-#ifdef CONFIG_SYSFS
-	struct gendisk *	bd_holder_disk;	/* for sysfs slave linkng */
-#endif
 	struct block_device *	bd_contains;
 	unsigned		bd_block_size;
 	struct hd_struct *	bd_part;
@@ -2045,12 +2042,18 @@ extern struct block_device *blkdev_get_b
 extern int blkdev_put(struct block_device *bdev, fmode_t mode);
 #ifdef CONFIG_SYSFS
 extern int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
+extern void bd_unlink_disk_holder(struct block_device *bdev,
+				  struct gendisk *disk);
 #else
 static inline int bd_link_disk_holder(struct block_device *bdev,
 				      struct gendisk *disk)
 {
 	return 0;
 }
+static inline void bd_unlink_disk_holder(struct block_device *bdev,
+					 struct gendisk *disk)
+{
+}
 #endif
 #endif
 
Index: work/drivers/md/dm-table.c
===================================================================
--- work.orig/drivers/md/dm-table.c
+++ work/drivers/md/dm-table.c
@@ -347,6 +347,7 @@ static void close_dev(struct dm_dev_inte
 	if (!d->dm_dev.bdev)
 		return;
 
+	bd_unlink_disk_holder(d->dm_dev.bdev, dm_disk(md));
 	blkdev_put(d->dm_dev.bdev, d->dm_dev.mode | FMODE_EXCL);
 	d->dm_dev.bdev = NULL;
 }
Index: work/drivers/md/md.c
===================================================================
--- work.orig/drivers/md/md.c
+++ work/drivers/md/md.c
@@ -1907,6 +1907,7 @@ static void unbind_rdev_from_array(mdk_r
 		MD_BUG();
 		return;
 	}
+	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
Index: work/fs/block_dev.c
===================================================================
--- work.orig/fs/block_dev.c
+++ work/fs/block_dev.c
@@ -788,6 +788,8 @@ static void del_symlink(struct kobject *
  * @bdev: the claimed slave bdev
  * @disk: the holding disk
  *
+ * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
+ *
  * This functions creates the following sysfs symlinks.
  *
  * - from "slaves" directory of the holder @disk to the claimed @bdev
@@ -815,7 +817,7 @@ int bd_link_disk_holder(struct block_dev
 
 	mutex_lock(&bdev->bd_mutex);
 
-	WARN_ON_ONCE(!bdev->bd_holder || bdev->bd_holder_disk);
+	WARN_ON_ONCE(!bdev->bd_holder);
 
 	/* FIXME: remove the following once add_disk() handles errors */
 	if (WARN_ON(!disk->slave_dir || !bdev->bd_part->holder_dir))
@@ -831,27 +833,28 @@ int bd_link_disk_holder(struct block_dev
 		goto out_unlock;
 	}
 
-	bdev->bd_holder_disk = disk;
 out_unlock:
 	mutex_unlock(&bdev->bd_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(bd_link_disk_holder);
 
-static void bd_unlink_disk_holder(struct block_device *bdev)
+/**
+ * bd_unlink_disk_holder - destroy symlinks created by bd_link_disk_holder()
+ * @bdev: the calimed slave bdev
+ * @disk: the holding disk
+ *
+ * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
+ *
+ * CONTEXT:
+ * Might sleep.
+ */
+void bd_unlink_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
-	struct gendisk *disk = bdev->bd_holder_disk;
-
-	bdev->bd_holder_disk = NULL;
-	if (!disk)
-		return;
-
 	del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
 	del_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
 }
-#else
-static inline void bd_unlink_disk_holder(struct block_device *bdev)
-{ }
+EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
 /**
@@ -1374,7 +1377,6 @@ int blkdev_put(struct block_device *bdev
 		 * unblock evpoll if it was a write holder.
 		 */
 		if (bdev_free) {
-			bd_unlink_disk_holder(bdev);
 			if (bdev->bd_write_holder) {
 				disk_unblock_events(bdev->bd_disk);
 				bdev->bd_write_holder = false;
