Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030233Ab2AEXnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:43:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030189Ab2AEXnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:43:24 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/11] block: abstract disk iteration into disk_iter
Date: Thu,  5 Jan 2012 15:42:48 -0800
Message-Id: <1325806974-23486-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325806974-23486-1-git-send-email-tj@kernel.org>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using class_dev_iter directly, abstract disk iteration into
disk_iter and helpers which are exported.  This simplifies the callers
a bit and allows external users to iterate over disks.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   98 +++++++++++++++++++++++++++++++++----------------
 include/linux/genhd.h |   10 ++++-
 2 files changed, 75 insertions(+), 33 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 02e9fca..aa13775 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -41,6 +41,47 @@ static void disk_del_events(struct gendisk *disk);
 static void disk_release_events(struct gendisk *disk);
 
 /**
+ * disk_iter_init - initialize disk iterator
+ * @diter: iterator to initialize
+ *
+ * Initialize @diter so that it iterates over all disks
+ */
+void disk_iter_init(struct disk_iter *diter)
+{
+	class_dev_iter_init(&diter->cdev_iter, &block_class, NULL, &disk_type);
+}
+EXPORT_SYMBOL_GPL(disk_iter_init);
+
+/**
+ * disk_iter_next - proceed iterator to the next disk and return it
+ * @diter: iterator to proceed
+ *
+ * Proceed @diter to the next disk and return it.
+ */
+struct gendisk *disk_iter_next(struct disk_iter *diter)
+{
+	struct device *dev;
+
+	dev = class_dev_iter_next(&diter->cdev_iter);
+	if (dev)
+		return dev_to_disk(dev);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(disk_iter_next);
+
+/**
+ * disk_iter_exit - finish up disk iteration
+ * @diter: iter to exit
+ *
+ * Called when iteration is over.  Cleans up @diter.
+ */
+void disk_iter_exit(struct disk_iter *diter)
+{
+	class_dev_iter_exit(&diter->cdev_iter);
+}
+EXPORT_SYMBOL_GPL(disk_iter_exit);
+
+/**
  * disk_get_part - get partition
  * @disk: disk to look partition from
  * @partno: partition number
@@ -731,12 +772,11 @@ EXPORT_SYMBOL(bdget_disk);
  */
 void __init printk_all_partitions(void)
 {
-	struct class_dev_iter iter;
-	struct device *dev;
+	struct disk_iter diter;
+	struct gendisk *disk;
 
-	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
-	while ((dev = class_dev_iter_next(&iter))) {
-		struct gendisk *disk = dev_to_disk(dev);
+	disk_iter_init(&diter);
+	while ((disk = disk_iter_next(&diter))) {
 		struct disk_part_iter piter;
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
@@ -780,7 +820,7 @@ void __init printk_all_partitions(void)
 		}
 		disk_part_iter_exit(&piter);
 	}
-	class_dev_iter_exit(&iter);
+	disk_iter_exit(&diter);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -788,44 +828,38 @@ void __init printk_all_partitions(void)
 static void *disk_seqf_start(struct seq_file *seqf, loff_t *pos)
 {
 	loff_t skip = *pos;
-	struct class_dev_iter *iter;
-	struct device *dev;
+	struct disk_iter *diter;
+	struct gendisk *disk;
 
-	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
-	if (!iter)
+	diter = kmalloc(sizeof(*diter), GFP_KERNEL);
+	if (!diter)
 		return ERR_PTR(-ENOMEM);
 
-	seqf->private = iter;
-	class_dev_iter_init(iter, &block_class, NULL, &disk_type);
+	seqf->private = diter;
+	disk_iter_init(diter);
 	do {
-		dev = class_dev_iter_next(iter);
-		if (!dev)
+		disk = disk_iter_next(diter);
+		if (!disk)
 			return NULL;
 	} while (skip--);
 
-	return dev_to_disk(dev);
+	return disk;
 }
 
 static void *disk_seqf_next(struct seq_file *seqf, void *v, loff_t *pos)
 {
-	struct device *dev;
-
 	(*pos)++;
-	dev = class_dev_iter_next(seqf->private);
-	if (dev)
-		return dev_to_disk(dev);
-
-	return NULL;
+	return disk_iter_next(seqf->private);
 }
 
 static void disk_seqf_stop(struct seq_file *seqf, void *v)
 {
-	struct class_dev_iter *iter = seqf->private;
+	struct disk_iter *diter = seqf->private;
 
 	/* stop is called even after start failed :-( */
-	if (iter) {
-		class_dev_iter_exit(iter);
-		kfree(iter);
+	if (diter) {
+		disk_iter_exit(diter);
+		kfree(diter);
 	}
 }
 
@@ -1207,12 +1241,12 @@ module_init(proc_genhd_init);
 dev_t blk_lookup_devt(const char *name, int partno)
 {
 	dev_t devt = MKDEV(0, 0);
-	struct class_dev_iter iter;
-	struct device *dev;
+	struct disk_iter diter;
+	struct gendisk *disk;
 
-	class_dev_iter_init(&iter, &block_class, NULL, &disk_type);
-	while ((dev = class_dev_iter_next(&iter))) {
-		struct gendisk *disk = dev_to_disk(dev);
+	disk_iter_init(&diter);
+	while ((disk = disk_iter_next(&diter))) {
+		struct device *dev = disk_to_dev(disk);
 		struct hd_struct *part;
 
 		if (strcmp(dev_name(dev), name))
@@ -1234,7 +1268,7 @@ dev_t blk_lookup_devt(const char *name, int partno)
 		}
 		disk_put_part(part);
 	}
-	class_dev_iter_exit(&iter);
+	disk_iter_exit(&diter);
 	return devt;
 }
 EXPORT_SYMBOL(blk_lookup_devt);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6d18f35..aefa6ba 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -260,8 +260,16 @@ static inline void disk_put_part(struct hd_struct *part)
 }
 
 /*
- * Smarter partition iterator without context limits.
+ * Smarter disk and partition iterators without context limits.
  */
+struct disk_iter {
+	struct class_dev_iter	cdev_iter;
+};
+
+extern void disk_iter_init(struct disk_iter *diter);
+extern struct gendisk *disk_iter_next(struct disk_iter *diter);
+extern void disk_iter_exit(struct disk_iter *diter);
+
 #define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
 #define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
-- 
1.7.3.1

