Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab0KAQRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 12:17:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:46865 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab0KAQRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 3/5] block: simplify holder symlink handling
Date: Mon,  1 Nov 2010 17:15:27 +0100
Message-Id: <1288628129-12811-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Nov 2010 16:15:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code to manage symlinks in /sys/block/*/{holders|slaves} are overly
complex with multiple holder considerations, redundant extra
references to all involved kobjects, unused generic kobject holder
support and unnecessary mixup with bd_claim/release functionalities.

Strip it down to what's necessary (single gendisk holder) and make it
use a separate interface.  This is a step for cleaning up
bd_claim/release.  This patch makes dm-table slightly more complex but
it will be simplified again with further changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-table.c |   23 +++-
 drivers/md/md.c       |    4 +-
 fs/block_dev.c        |  322 +++++++------------------------------------------
 include/linux/fs.h    |   16 ++-
 4 files changed, 74 insertions(+), 291 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 90267f8..2c876ff 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -328,12 +328,22 @@ static int open_dev(struct dm_dev_internal *d, dev_t dev,
 	bdev = open_by_devnum(dev, d->dm_dev.mode);
 	if (IS_ERR(bdev))
 		return PTR_ERR(bdev);
-	r = bd_claim_by_disk(bdev, _claim_ptr, dm_disk(md));
-	if (r)
+
+	r = bd_claim(bdev, _claim_ptr);
+	if (r) {
 		blkdev_put(bdev, d->dm_dev.mode);
-	else
-		d->dm_dev.bdev = bdev;
-	return r;
+		return r;
+	}
+
+	r = bd_link_disk_holder(bdev, dm_disk(md));
+	if (r) {
+		bd_release(bdev);
+		blkdev_put(bdev, d->dm_dev.mode);
+		return r;
+	}
+
+	d->dm_dev.bdev = bdev;
+	return 0;
 }
 
 /*
@@ -344,7 +354,8 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
 	if (!d->dm_dev.bdev)
 		return;
 
-	bd_release_from_disk(d->dm_dev.bdev, dm_disk(md));
+	bd_unlink_disk_holder(d->dm_dev.bdev);
+	bd_release(d->dm_dev.bdev);
 	blkdev_put(d->dm_dev.bdev, d->dm_dev.mode);
 	d->dm_dev.bdev = NULL;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e957f3..c47644f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1880,7 +1880,7 @@ static int bind_rdev_to_array(mdk_rdev_t * rdev, mddev_t * mddev)
 	rdev->sysfs_state = sysfs_get_dirent_safe(rdev->kobj.sd, "state");
 
 	list_add_rcu(&rdev->same_set, &mddev->disks);
-	bd_claim_by_disk(rdev->bdev, rdev->bdev->bd_holder, mddev->gendisk);
+	bd_link_disk_holder(rdev->bdev, mddev->gendisk);
 
 	/* May as well allow recovery to be retried once */
 	mddev->recovery_disabled = 0;
@@ -1907,7 +1907,7 @@ static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 		MD_BUG();
 		return;
 	}
-	bd_release_from_disk(rdev->bdev, rdev->mddev->gendisk);
+	bd_unlink_disk_holder(rdev->bdev);
 	list_del_rcu(&rdev->same_set);
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 06e8ff1..9329068 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -426,9 +426,6 @@ static void init_once(void *foo)
 	mutex_init(&bdev->bd_mutex);
 	INIT_LIST_HEAD(&bdev->bd_inodes);
 	INIT_LIST_HEAD(&bdev->bd_list);
-#ifdef CONFIG_SYSFS
-	INIT_LIST_HEAD(&bdev->bd_holder_list);
-#endif
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
 	mutex_init(&bdev->bd_fsfreeze_mutex);
@@ -881,314 +878,83 @@ void bd_release(struct block_device *bdev)
 EXPORT_SYMBOL(bd_release);
 
 #ifdef CONFIG_SYSFS
-/*
- * Functions for bd_claim_by_kobject / bd_release_from_kobject
- *
- *     If a kobject is passed to bd_claim_by_kobject()
- *     and the kobject has a parent directory,
- *     following symlinks are created:
- *        o from the kobject to the claimed bdev
- *        o from "holders" directory of the bdev to the parent of the kobject
- *     bd_release_from_kobject() removes these symlinks.
- *
- *     Example:
- *        If /dev/dm-0 maps to /dev/sda, kobject corresponding to
- *        /sys/block/dm-0/slaves is passed to bd_claim_by_kobject(), then:
- *           /sys/block/dm-0/slaves/sda --> /sys/block/sda
- *           /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
- */
-
 static int add_symlink(struct kobject *from, struct kobject *to)
 {
-	if (!from || !to)
-		return 0;
 	return sysfs_create_link(from, to, kobject_name(to));
 }
 
 static void del_symlink(struct kobject *from, struct kobject *to)
 {
-	if (!from || !to)
-		return;
 	sysfs_remove_link(from, kobject_name(to));
 }
 
-/*
- * 'struct bd_holder' contains pointers to kobjects symlinked by
- * bd_claim_by_kobject.
- * It's connected to bd_holder_list which is protected by bdev->bd_sem.
- */
-struct bd_holder {
-	struct list_head list;	/* chain of holders of the bdev */
-	int count;		/* references from the holder */
-	struct kobject *sdir;	/* holder object, e.g. "/block/dm-0/slaves" */
-	struct kobject *hdev;	/* e.g. "/block/dm-0" */
-	struct kobject *hdir;	/* e.g. "/block/sda/holders" */
-	struct kobject *sdev;	/* e.g. "/block/sda" */
-};
-
-/*
- * Get references of related kobjects at once.
- * Returns 1 on success. 0 on failure.
- *
- * Should call bd_holder_release_dirs() after successful use.
- */
-static int bd_holder_grab_dirs(struct block_device *bdev,
-			struct bd_holder *bo)
-{
-	if (!bdev || !bo)
-		return 0;
-
-	bo->sdir = kobject_get(bo->sdir);
-	if (!bo->sdir)
-		return 0;
-
-	bo->hdev = kobject_get(bo->sdir->parent);
-	if (!bo->hdev)
-		goto fail_put_sdir;
-
-	bo->sdev = kobject_get(&part_to_dev(bdev->bd_part)->kobj);
-	if (!bo->sdev)
-		goto fail_put_hdev;
-
-	bo->hdir = kobject_get(bdev->bd_part->holder_dir);
-	if (!bo->hdir)
-		goto fail_put_sdev;
-
-	return 1;
-
-fail_put_sdev:
-	kobject_put(bo->sdev);
-fail_put_hdev:
-	kobject_put(bo->hdev);
-fail_put_sdir:
-	kobject_put(bo->sdir);
-
-	return 0;
-}
-
-/* Put references of related kobjects at once. */
-static void bd_holder_release_dirs(struct bd_holder *bo)
-{
-	kobject_put(bo->hdir);
-	kobject_put(bo->sdev);
-	kobject_put(bo->hdev);
-	kobject_put(bo->sdir);
-}
-
-static struct bd_holder *alloc_bd_holder(struct kobject *kobj)
-{
-	struct bd_holder *bo;
-
-	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
-	if (!bo)
-		return NULL;
-
-	bo->count = 1;
-	bo->sdir = kobj;
-
-	return bo;
-}
-
-static void free_bd_holder(struct bd_holder *bo)
-{
-	kfree(bo);
-}
-
 /**
- * find_bd_holder - find matching struct bd_holder from the block device
+ * bd_link_disk_holder - create symlinks between holding disk and slave bdev
+ * @bdev: the claimed slave bdev
+ * @disk: the holding disk
  *
- * @bdev:	struct block device to be searched
- * @bo:		target struct bd_holder
+ * This functions creates the following sysfs symlinks.
  *
- * Returns matching entry with @bo in @bdev->bd_holder_list.
- * If found, increment the reference count and return the pointer.
- * If not found, returns NULL.
- */
-static struct bd_holder *find_bd_holder(struct block_device *bdev,
-					struct bd_holder *bo)
-{
-	struct bd_holder *tmp;
-
-	list_for_each_entry(tmp, &bdev->bd_holder_list, list)
-		if (tmp->sdir == bo->sdir) {
-			tmp->count++;
-			return tmp;
-		}
-
-	return NULL;
-}
-
-/**
- * add_bd_holder - create sysfs symlinks for bd_claim() relationship
+ * - from "slaves" directory of the holder @disk to the claimed @bdev
+ * - from "holders" directory of the @bdev to the holder @disk
  *
- * @bdev:	block device to be bd_claimed
- * @bo:		preallocated and initialized by alloc_bd_holder()
+ * For example, if /dev/dm-0 maps to /dev/sda and disk for dm-0 is
+ * passed to bd_link_disk_holder(), then:
  *
- * Add @bo to @bdev->bd_holder_list, create symlinks.
+ *   /sys/block/dm-0/slaves/sda --> /sys/block/sda
+ *   /sys/block/sda/holders/dm-0 --> /sys/block/dm-0
  *
- * Returns 0 if symlinks are created.
- * Returns -ve if something fails.
- */
-static int add_bd_holder(struct block_device *bdev, struct bd_holder *bo)
-{
-	int err;
-
-	if (!bo)
-		return -EINVAL;
-
-	if (!bd_holder_grab_dirs(bdev, bo))
-		return -EBUSY;
-
-	err = add_symlink(bo->sdir, bo->sdev);
-	if (err)
-		return err;
-
-	err = add_symlink(bo->hdir, bo->hdev);
-	if (err) {
-		del_symlink(bo->sdir, bo->sdev);
-		return err;
-	}
-
-	list_add_tail(&bo->list, &bdev->bd_holder_list);
-	return 0;
-}
-
-/**
- * del_bd_holder - delete sysfs symlinks for bd_claim() relationship
- *
- * @bdev:	block device to be bd_claimed
- * @kobj:	holder's kobject
- *
- * If there is matching entry with @kobj in @bdev->bd_holder_list
- * and no other bd_claim() from the same kobject,
- * remove the struct bd_holder from the list, delete symlinks for it.
- *
- * Returns a pointer to the struct bd_holder when it's removed from the list
- * and ready to be freed.
- * Returns NULL if matching claim isn't found or there is other bd_claim()
- * by the same kobject.
- */
-static struct bd_holder *del_bd_holder(struct block_device *bdev,
-					struct kobject *kobj)
-{
-	struct bd_holder *bo;
-
-	list_for_each_entry(bo, &bdev->bd_holder_list, list) {
-		if (bo->sdir == kobj) {
-			bo->count--;
-			BUG_ON(bo->count < 0);
-			if (!bo->count) {
-				list_del(&bo->list);
-				del_symlink(bo->sdir, bo->sdev);
-				del_symlink(bo->hdir, bo->hdev);
-				bd_holder_release_dirs(bo);
-				return bo;
-			}
-			break;
-		}
-	}
-
-	return NULL;
-}
-
-/**
- * bd_claim_by_kobject - bd_claim() with additional kobject signature
- *
- * @bdev:	block device to be claimed
- * @holder:	holder's signature
- * @kobj:	holder's kobject
+ * The caller must have claimed @bdev before calling this function and
+ * ensure that both @bdev and @disk are valid during the creation and
+ * lifetime of these symlinks.
  *
- * Do bd_claim() and if it succeeds, create sysfs symlinks between
- * the bdev and the holder's kobject.
- * Use bd_release_from_kobject() when relesing the claimed bdev.
+ * CONTEXT:
+ * Might sleep.
  *
- * Returns 0 on success. (same as bd_claim())
- * Returns errno on failure.
+ * RETURNS:
+ * 0 on success, -errno on failure.
  */
-static int bd_claim_by_kobject(struct block_device *bdev, void *holder,
-				struct kobject *kobj)
+int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
-	int err;
-	struct bd_holder *bo, *found;
-
-	if (!kobj)
-		return -EINVAL;
-
-	bo = alloc_bd_holder(kobj);
-	if (!bo)
-		return -ENOMEM;
+	int ret = 0;
 
 	mutex_lock(&bdev->bd_mutex);
 
-	err = bd_claim(bdev, holder);
-	if (err)
-		goto fail;
+	WARN_ON_ONCE(!bdev->bd_holder || bdev->bd_holder_disk);
 
-	found = find_bd_holder(bdev, bo);
-	if (found)
-		goto fail;
+	/* FIXME: remove the following once add_disk() handles errors */
+	if (WARN_ON(!disk->slave_dir || !bdev->bd_part->holder_dir))
+		goto out_unlock;
 
-	err = add_bd_holder(bdev, bo);
-	if (err)
-		bd_release(bdev);
-	else
-		bo = NULL;
-fail:
-	mutex_unlock(&bdev->bd_mutex);
-	free_bd_holder(bo);
-	return err;
-}
+	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+	if (ret)
+		goto out_unlock;
 
-/**
- * bd_release_from_kobject - bd_release() with additional kobject signature
- *
- * @bdev:	block device to be released
- * @kobj:	holder's kobject
- *
- * Do bd_release() and remove sysfs symlinks created by bd_claim_by_kobject().
- */
-static void bd_release_from_kobject(struct block_device *bdev,
-					struct kobject *kobj)
-{
-	if (!kobj)
-		return;
+	ret = add_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
+	if (ret) {
+		del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+		goto out_unlock;
+	}
 
-	mutex_lock(&bdev->bd_mutex);
-	bd_release(bdev);
-	free_bd_holder(del_bd_holder(bdev, kobj));
+	bdev->bd_holder_disk = disk;
+out_unlock:
 	mutex_unlock(&bdev->bd_mutex);
+	return ret;
 }
+EXPORT_SYMBOL_GPL(bd_link_disk_holder);
 
-/**
- * bd_claim_by_disk - wrapper function for bd_claim_by_kobject()
- *
- * @bdev:	block device to be claimed
- * @holder:	holder's signature
- * @disk:	holder's gendisk
- *
- * Call bd_claim_by_kobject() with getting @disk->slave_dir.
- */
-int bd_claim_by_disk(struct block_device *bdev, void *holder,
-			struct gendisk *disk)
+void bd_unlink_disk_holder(struct block_device *bdev)
 {
-	return bd_claim_by_kobject(bdev, holder, kobject_get(disk->slave_dir));
-}
-EXPORT_SYMBOL_GPL(bd_claim_by_disk);
+	struct gendisk *disk = bdev->bd_holder_disk;
 
-/**
- * bd_release_from_disk - wrapper function for bd_release_from_kobject()
- *
- * @bdev:	block device to be claimed
- * @disk:	holder's gendisk
- *
- * Call bd_release_from_kobject() and put @disk->slave_dir.
- */
-void bd_release_from_disk(struct block_device *bdev, struct gendisk *disk)
-{
-	bd_release_from_kobject(bdev, disk->slave_dir);
-	kobject_put(disk->slave_dir);
+	bdev->bd_holder_disk = NULL;
+	if (!disk)
+		return;
+
+	del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+	del_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
 }
-EXPORT_SYMBOL_GPL(bd_release_from_disk);
+EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1eb2939..b361848 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -663,7 +663,7 @@ struct block_device {
 	void *			bd_holder;
 	int			bd_holders;
 #ifdef CONFIG_SYSFS
-	struct list_head	bd_holder_list;
+	struct gendisk *	bd_holder_disk;	/* for sysfs slave linkng */
 #endif
 	struct block_device *	bd_contains;
 	unsigned		bd_block_size;
@@ -2043,11 +2043,17 @@ extern int blkdev_put(struct block_device *, fmode_t);
 extern int bd_claim(struct block_device *, void *);
 extern void bd_release(struct block_device *);
 #ifdef CONFIG_SYSFS
-extern int bd_claim_by_disk(struct block_device *, void *, struct gendisk *);
-extern void bd_release_from_disk(struct block_device *, struct gendisk *);
+extern int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk);
+extern void bd_unlink_disk_holder(struct block_device *bdev);
 #else
-#define bd_claim_by_disk(bdev, holder, disk)	bd_claim(bdev, holder)
-#define bd_release_from_disk(bdev, disk)	bd_release(bdev)
+static inline int bd_link_disk_holder(struct block_device *bdev,
+				      struct gendisk *disk)
+{
+	return 0;
+}
+static inline void bd_unlink_disk_holder(struct block_device *bdev)
+{
+}
 #endif
 #endif
 
-- 
1.7.1

