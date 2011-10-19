Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1JSE0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:26:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44380 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab1JSE0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:26:32 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Cc: ctalbott@google.com, ni@google.com, Tejun Heo <tj@kernel.org>,
        stable@kernel.org
Subject: [PATCH 01/10] block: make gendisk hold a reference to its queue
Date: Tue, 18 Oct 2011 21:26:15 -0700
Message-Id: <1318998384-22525-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1318998384-22525-1-git-send-email-tj@kernel.org>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following command sequence triggers an oops.

# mount /dev/sdb1 /mnt
# echo 1 > /sys/class/scsi_device/0\:0\:1\:0/device/delete
# umount /mnt

 general protection fault: 0000 [#1] PREEMPT SMP
 CPU 2
 Modules linked in:

 Pid: 791, comm: umount Not tainted 3.1.0-rc3-work+ #8 Bochs Bochs
 RIP: 0010:[<ffffffff810d0879>]  [<ffffffff810d0879>] __lock_acquire+0x389/0x1d60
...
 Call Trace:
  [<ffffffff810d2845>] lock_acquire+0x95/0x140
  [<ffffffff81aed87b>] _raw_spin_lock+0x3b/0x50
  [<ffffffff811573bc>] bdi_lock_two+0x5c/0x70
  [<ffffffff811c2f6c>] bdev_inode_switch_bdi+0x4c/0xf0
  [<ffffffff811c3fcb>] __blkdev_put+0x11b/0x1d0
  [<ffffffff811c4010>] __blkdev_put+0x160/0x1d0
  [<ffffffff811c40df>] blkdev_put+0x5f/0x190
  [<ffffffff8118f18d>] kill_block_super+0x4d/0x80
  [<ffffffff8118f4a5>] deactivate_locked_super+0x45/0x70
  [<ffffffff8119003a>] deactivate_super+0x4a/0x70
  [<ffffffff811ac4ad>] mntput_no_expire+0xed/0x130
  [<ffffffff811acf2e>] sys_umount+0x7e/0x3a0
  [<ffffffff81aeeeab>] system_call_fastpath+0x16/0x1b

This is because bdev holds on to disk but disk doesn't pin the
associated queue.  If a SCSI device is removed while the device is
still open, the sdev puts the base reference to the queue on release.
When the bdev is finally released, the associated queue is already
gone along with the bdi and bdev_inode_switch_bdi() ends up
dereferencing already freed bdi.

Even if it were not for this bug, disk not holding onto the associated
queue is very unusual and error-prone.

Fix it by making add_disk() take an extra reference to its queue and
put it on disk_release() and ensuring that disk and its fops owner are
put in that order after all accesses to the disk and queue are
complete.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: stable@kernel.org
---
 block/genhd.c  |    8 ++++++++
 fs/block_dev.c |   13 ++++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3a3bccb..02e9fca 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -611,6 +611,12 @@ void add_disk(struct gendisk *disk)
 	register_disk(disk);
 	blk_register_queue(disk);
 
+	/*
+	 * Take an extra ref on queue which will be put on disk_release()
+	 * so that it sticks around as long as @disk is there.
+	 */
+	WARN_ON_ONCE(blk_get_queue(disk->queue));
+
 	retval = sysfs_create_link(&disk_to_dev(disk)->kobj, &bdi->dev->kobj,
 				   "bdi");
 	WARN_ON(retval);
@@ -1095,6 +1101,8 @@ static void disk_release(struct device *dev)
 	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
 	free_part_info(&disk->part0);
+	if (disk->queue)
+		blk_put_queue(disk->queue);
 	kfree(disk);
 }
 struct class block_class = {
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0bed0d4..53bb05e 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1085,6 +1085,7 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part);
 static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 {
 	struct gendisk *disk;
+	struct module *owner;
 	int ret;
 	int partno;
 	int perm = 0;
@@ -1110,6 +1111,7 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	disk = get_gendisk(bdev->bd_dev, &partno);
 	if (!disk)
 		goto out;
+	owner = disk->fops->owner;
 
 	disk_block_events(disk);
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
@@ -1137,8 +1139,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 					bdev->bd_disk = NULL;
 					mutex_unlock(&bdev->bd_mutex);
 					disk_unblock_events(disk);
-					module_put(disk->fops->owner);
 					put_disk(disk);
+					module_put(owner);
 					goto restart;
 				}
 			}
@@ -1194,8 +1196,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 				goto out_unlock_bdev;
 		}
 		/* only one opener holds refs to the module and disk */
-		module_put(disk->fops->owner);
 		put_disk(disk);
+		module_put(owner);
 	}
 	bdev->bd_openers++;
 	if (for_part)
@@ -1215,8 +1217,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
  out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
 	disk_unblock_events(disk);
-	module_put(disk->fops->owner);
 	put_disk(disk);
+	module_put(owner);
  out:
 	bdput(bdev);
 
@@ -1437,8 +1439,6 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	if (!bdev->bd_openers) {
 		struct module *owner = disk->fops->owner;
 
-		put_disk(disk);
-		module_put(owner);
 		disk_put_part(bdev->bd_part);
 		bdev->bd_part = NULL;
 		bdev->bd_disk = NULL;
@@ -1447,6 +1447,9 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 		if (bdev != bdev->bd_contains)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
+
+		put_disk(disk);
+		module_put(owner);
 	}
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
-- 
1.7.3.1

