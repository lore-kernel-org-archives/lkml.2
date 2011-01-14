Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794Ab1ANQh4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:37:56 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61133 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1ANQht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:37:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LuUu+emWW4RDvyZkj0A1HCn4Bw8fIUShs9GQ5fu8vxo7W6EbxI9aySR6Ilkczo8pOk
         7E1Dw7v/Mt8UtqGxP/CxPUp8fzB5HH0mamd9jLz8pgQqOtYydqGMXaEx9z4eA525FDpc
         vkaLnmvdU6KgId9fHMVYsmekOEGyWE2gX3aK8=
Date: Fri, 14 Jan 2011 17:10:43 +0100
From: Tejun Heo <tj@kernel.org>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Milan Broz <mbroz@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Valdis.Kletnieks@vt.edu, Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH UPDATED] block: restore multiple bd_link_disk_holder()
 support
Message-ID: <20110114161043.GB978@htj.dyndns.org>
References: <16069.1294853673@localhost>
 <4D2E4611.90002@redhat.com>
 <4D2E6129.8000700@ce.jp.nec.com>
 <20110113172133.GE14096@htj.dyndns.org>
 <4D2F4799.5030901@redhat.com>
 <4D2FFBED.6010406@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2FFBED.6010406@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e09b457b (block: simplify holder symlink handling) incorrectly
assumed that there is only one link at maximum.  dm may use multiple
links and expects block layer to track reference count for each link,
which is different from and unrelated to the exclusive device holder
identified by @holder when the device is opened.

Remove the single holder assumption and automatic removal of the link
and revive the per-link reference count tracking.  The code
essentially behaves the same as before commit e09b457b sans the
unnecessary kobject reference count dancing.

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
Thanks for the test commands.  They were very helpful.  Can you please
test this one?

Thanks.

 drivers/md/dm-table.c |    1 
 drivers/md/md.c       |    1 
 fs/block_dev.c        |   93 ++++++++++++++++++++++++++++++++++++++++----------
 include/linux/fs.h    |    8 +++-
 4 files changed, 84 insertions(+), 19 deletions(-)

Index: work/include/linux/fs.h
===================================================================
--- work.orig/include/linux/fs.h
+++ work/include/linux/fs.h
@@ -664,7 +664,7 @@ struct block_device {
 	int			bd_holders;
 	bool			bd_write_holder;
 #ifdef CONFIG_SYSFS
-	struct gendisk *	bd_holder_disk;	/* for sysfs slave linkng */
+	struct list_head	bd_holder_disks;
 #endif
 	struct block_device *	bd_contains;
 	unsigned		bd_block_size;
@@ -2045,12 +2045,18 @@ extern struct block_device *blkdev_get_b
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
@@ -426,6 +426,9 @@ static void init_once(void *foo)
 	mutex_init(&bdev->bd_mutex);
 	INIT_LIST_HEAD(&bdev->bd_inodes);
 	INIT_LIST_HEAD(&bdev->bd_list);
+#ifdef CONFIG_SYSFS
+	INIT_LIST_HEAD(&bdev->bd_holder_disks);
+#endif
 	inode_init_once(&ei->vfs_inode);
 	/* Initialize mutex for freeze. */
 	mutex_init(&bdev->bd_fsfreeze_mutex);
@@ -773,6 +776,23 @@ static struct block_device *bd_start_cla
 }
 
 #ifdef CONFIG_SYSFS
+struct bd_holder_disk {
+	struct list_head	list;
+	struct gendisk		*disk;
+	int			refcnt;
+};
+
+static struct bd_holder_disk *bd_find_holder_disk(struct block_device *bdev,
+						  struct gendisk *disk)
+{
+	struct bd_holder_disk *holder;
+
+	list_for_each_entry(holder, &bdev->bd_holder_disks, list)
+		if (holder->disk == disk)
+			return holder;
+	return NULL;
+}
+
 static int add_symlink(struct kobject *from, struct kobject *to)
 {
 	return sysfs_create_link(from, to, kobject_name(to));
@@ -788,6 +808,8 @@ static void del_symlink(struct kobject *
  * @bdev: the claimed slave bdev
  * @disk: the holding disk
  *
+ * DON'T USE THIS UNLESS YOU'RE ALREADY USING IT.
+ *
  * This functions creates the following sysfs symlinks.
  *
  * - from "slaves" directory of the holder @disk to the claimed @bdev
@@ -811,47 +833,83 @@ static void del_symlink(struct kobject *
  */
 int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 {
+	struct bd_holder_disk *holder;
 	int ret = 0;
 
 	mutex_lock(&bdev->bd_mutex);
 
-	WARN_ON_ONCE(!bdev->bd_holder || bdev->bd_holder_disk);
+	WARN_ON_ONCE(!bdev->bd_holder);
 
 	/* FIXME: remove the following once add_disk() handles errors */
 	if (WARN_ON(!disk->slave_dir || !bdev->bd_part->holder_dir))
 		goto out_unlock;
 
-	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
-	if (ret)
+	holder = bd_find_holder_disk(bdev, disk);
+	if (holder) {
+		holder->refcnt++;
 		goto out_unlock;
+	}
 
-	ret = add_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
-	if (ret) {
-		del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+	holder = kzalloc(sizeof(*holder), GFP_KERNEL);
+	if (!holder) {
+		ret = -ENOMEM;
 		goto out_unlock;
 	}
 
-	bdev->bd_holder_disk = disk;
+	INIT_LIST_HEAD(&holder->list);
+	holder->disk = disk;
+	holder->refcnt = 1;
+
+	ret = add_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+	if (ret)
+		goto out_free;
+
+	ret = add_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
+	if (ret)
+		goto out_del;
+
+	list_add(&holder->list, &bdev->bd_holder_disks);
+	goto out_unlock;
+
+out_del:
+	del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+out_free:
+	kfree(holder);
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
+	struct bd_holder_disk *holder;
 
-	bdev->bd_holder_disk = NULL;
-	if (!disk)
-		return;
+	mutex_lock(&bdev->bd_mutex);
 
-	del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
-	del_symlink(bdev->bd_part->holder_dir, &disk_to_dev(disk)->kobj);
+	holder = bd_find_holder_disk(bdev, disk);
+
+	if (!WARN_ON_ONCE(holder == NULL) && !--holder->refcnt) {
+		del_symlink(disk->slave_dir, &part_to_dev(bdev->bd_part)->kobj);
+		del_symlink(bdev->bd_part->holder_dir,
+			    &disk_to_dev(disk)->kobj);
+		list_del_init(&holder->list);
+		kfree(holder);
+	}
+
+	mutex_unlock(&bdev->bd_mutex);
 }
-#else
-static inline void bd_unlink_disk_holder(struct block_device *bdev)
-{ }
+EXPORT_SYMBOL_GPL(bd_unlink_disk_holder);
 #endif
 
 /**
@@ -1374,7 +1432,6 @@ int blkdev_put(struct block_device *bdev
 		 * unblock evpoll if it was a write holder.
 		 */
 		if (bdev_free) {
-			bd_unlink_disk_holder(bdev);
 			if (bdev->bd_write_holder) {
 				disk_unblock_events(bdev->bd_disk);
 				bdev->bd_write_holder = false;
