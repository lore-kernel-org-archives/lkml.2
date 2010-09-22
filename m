Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0IVHtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 03:49:10 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57545 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab0IVHtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 03:49:09 -0400
Message-ID: <4C99B4F3.6070403@fusionio.com>
Date: Wed, 22 Sep 2010 09:49:07 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 2.6.36-rc5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small batch of fixes. Two important fixes, correcting a bug in the
unified request/bio command flags causing blk_rq_map_kern() to
flag writes incorrectly, and the oops in CFQ with cgroups and a usb key.
The small 3-patch series from Jan fixes a long standing regression
dating back to 2.6.32.

Please pull.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Benny Halevy (1):
      block: fix blk_rq_map_kern bio direction flag

Dan Carpenter (1):
      cciss: freeing uninitialized data on error path

Jan Kara (3):
      bdi: Initialize noop_backing_dev_info properly
      char: Mark /dev/zero and /dev/kmem as not capable of writeback
      bdi: Fix warnings in __mark_inode_dirty for /dev/zero and friends

Vivek Goyal (1):
      cfq-iosched: fix a kernel OOPs when usb key is inserted

 block/blk-map.c       |    2 +-
 block/cfq-iosched.c   |   16 +++++++++++++---
 drivers/block/cciss.c |    2 +-
 drivers/char/mem.c    |    3 ++-
 fs/char_dev.c         |    4 +++-
 fs/fs-writeback.c     |   23 +++++++++++++++++++++--
 mm/backing-dev.c      |    2 ++
 7 files changed, 43 insertions(+), 9 deletions(-)


diff --git a/block/blk-map.c b/block/blk-map.c
index c65d759..ade0a08 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -307,7 +307,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		return PTR_ERR(bio);
 
 	if (rq_data_dir(rq) == WRITE)
-		bio->bi_rw |= (1 << REQ_WRITE);
+		bio->bi_rw |= REQ_WRITE;
 
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index f65c6f0..9eba291 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1019,10 +1019,20 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	 */
 	atomic_set(&cfqg->ref, 1);
 
-	/* Add group onto cgroup list */
-	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
-	cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+	/*
+	 * Add group onto cgroup list. It might happen that bdi->dev is
+	 * not initiliazed yet. Initialize this new group without major
+	 * and minor info and this info will be filled in once a new thread
+	 * comes for IO. See code above.
+	 */
+	if (bdi->dev) {
+		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
+		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
 					MKDEV(major, minor));
+	} else
+		cfq_blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
+					0);
+
 	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
 
 	/* Add group on cfqd list */
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6124c2f..5e4fadc 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4792,7 +4792,7 @@ static int __devinit cciss_init_one(struct pci_dev *pdev,
 clean4:
 	kfree(h->cmd_pool_bits);
 	/* Free up sg elements */
-	for (k = 0; k < h->nr_cmds; k++)
+	for (k-- ; k >= 0; k--)
 		kfree(h->scatter_list[k]);
 	kfree(h->scatter_list);
 	cciss_free_sg_chain_blocks(h->cmd_sg_list, h->nr_cmds);
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a398ecd..1f528fa 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -788,10 +788,11 @@ static const struct file_operations zero_fops = {
 /*
  * capabilities for /dev/zero
  * - permits private mappings, "copies" are taken of the source of zeros
+ * - no writeback happens
  */
 static struct backing_dev_info zero_bdi = {
 	.name		= "char/mem",
-	.capabilities	= BDI_CAP_MAP_COPY,
+	.capabilities	= BDI_CAP_MAP_COPY | BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 
 static const struct file_operations full_fops = {
diff --git a/fs/char_dev.c b/fs/char_dev.c
index f80a4f2..143d393 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -40,7 +40,9 @@ struct backing_dev_info directly_mappable_cdev_bdi = {
 #endif
 		/* permit direct mmap, for read, write or exec */
 		BDI_CAP_MAP_DIRECT |
-		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP),
+		BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP |
+		/* no writeback happens */
+		BDI_CAP_NO_ACCT_AND_WRITEBACK),
 };
 
 static struct kobj_map *cdev_map;
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 81e086d..5581122 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -52,8 +52,6 @@ struct wb_writeback_work {
 #define CREATE_TRACE_POINTS
 #include <trace/events/writeback.h>
 
-#define inode_to_bdi(inode)	((inode)->i_mapping->backing_dev_info)
-
 /*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
@@ -71,6 +69,27 @@ int writeback_in_progress(struct backing_dev_info *bdi)
 	return test_bit(BDI_writeback_running, &bdi->state);
 }
 
+static inline struct backing_dev_info *inode_to_bdi(struct inode *inode)
+{
+	struct super_block *sb = inode->i_sb;
+	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+
+	/*
+	 * For inodes on standard filesystems, we use superblock's bdi. For
+	 * inodes on virtual filesystems, we want to use inode mapping's bdi
+	 * because they can possibly point to something useful (think about
+	 * block_dev filesystem).
+	 */
+	if (sb->s_bdi && sb->s_bdi != &noop_backing_dev_info) {
+		/* Some device inodes could play dirty tricks. Catch them... */
+		WARN(bdi != sb->s_bdi && bdi_cap_writeback_dirty(bdi),
+			"Dirtiable inode bdi %s != sb bdi %s\n",
+			bdi->name, sb->s_bdi->name);
+		return sb->s_bdi;
+	}
+	return bdi;
+}
+
 static void bdi_queue_work(struct backing_dev_info *bdi,
 		struct wb_writeback_work *work)
 {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index c2bf86f..65d4204 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -30,6 +30,7 @@ EXPORT_SYMBOL_GPL(default_backing_dev_info);
 
 struct backing_dev_info noop_backing_dev_info = {
 	.name		= "noop",
+	.capabilities	= BDI_CAP_NO_ACCT_AND_WRITEBACK,
 };
 EXPORT_SYMBOL_GPL(noop_backing_dev_info);
 
@@ -243,6 +244,7 @@ static int __init default_bdi_init(void)
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
 		bdi_register(&default_backing_dev_info, NULL, "default");
+	err = bdi_init(&noop_backing_dev_info);
 
 	return err;
 }
-- 
Jens Axboe

