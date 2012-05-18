Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965850Ab2ERMbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:31:32 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:41189 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab2ERMba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:31:30 -0400
X-ASG-Debug-ID: 1337344288-0421b53bcc1f400001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FB64108.1070909@fusionio.com>
Date: Fri, 18 May 2012 14:31:04 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block fixes for 3.4 final
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] block fixes for 3.4 final
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1337344288
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.97303
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few small, but important fixes. Most of them are marked
for stable as we..

- Fix failure to release a semaphore on error path in mtip32xx.
- Fix crashable condition in bio_get_nr_vecs().
- Don't mark end-of-disk buffers as mapped, limit it to
  i_size.
- Fix for build problem with CONFIG_BLOCK=n on arm at least.
- Fix for a buffer overlow on UUID partition printing.
- Trivial removal of unused variables in dac960.

Please pull!


  git://git.kernel.dk/linux-block.git for-linus

----------------------------------------------------------------
Asai Thambi S P (1):
      mtip32xx: release the semaphore on an error path

Bernd Schubert (1):
      bio allocation failure due to bio_get_nr_vecs()

Jeff Moyer (1):
      block: don't mark buffers beyond end of disk as mapped

Jesper Juhl (1):
      dac960: Remove unused variables from DAC960_CreateProcEntries()

Russell King (1):
      Fix blkdev.h build errors when BLOCK=n

Tejun Heo (1):
      block: fix buffer overflow when printing partition UUIDs

 block/genhd.c                     |   10 ++++++----
 drivers/block/DAC960.c            |   23 ++++++++++-------------
 drivers/block/mtip32xx/mtip32xx.c |    4 +++-
 fs/bio.c                          |    7 ++++++-
 fs/block_dev.c                    |    6 +++---
 fs/buffer.c                       |    4 +++-
 include/linux/blkdev.h            |    3 ++-
 include/linux/fs.h                |    1 +
 include/linux/genhd.h             |    6 ------
 9 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index df9816e..9cf5583 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -743,7 +743,7 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
-		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
+		char uuid_buf[PARTITION_META_INFO_UUIDLTH * 2 + 5];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -762,14 +762,16 @@ void __init printk_all_partitions(void)
 		while ((part = disk_part_iter_next(&piter))) {
 			bool is_part0 = part == &disk->part0;
 
-			uuid[0] = 0;
+			uuid_buf[0] = '\0';
 			if (part->info)
-				part_unpack_uuid(part->info->uuid, uuid);
+				snprintf(uuid_buf, sizeof(uuid_buf), "%pU",
+					 part->info->uuid);
 
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf), uuid);
+			       disk_name(disk, part->partno, name_buf),
+			       uuid_buf);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 8db9089..9a13e88 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6580,24 +6580,21 @@ static const struct file_operations dac960_user_command_proc_fops = {
 
 static void DAC960_CreateProcEntries(DAC960_Controller_T *Controller)
 {
-	struct proc_dir_entry *StatusProcEntry;
 	struct proc_dir_entry *ControllerProcEntry;
-	struct proc_dir_entry *UserCommandProcEntry;
 
 	if (DAC960_ProcDirectoryEntry == NULL) {
-  		DAC960_ProcDirectoryEntry = proc_mkdir("rd", NULL);
-  		StatusProcEntry = proc_create("status", 0,
-					   DAC960_ProcDirectoryEntry,
-					   &dac960_proc_fops);
+		DAC960_ProcDirectoryEntry = proc_mkdir("rd", NULL);
+		proc_create("status", 0, DAC960_ProcDirectoryEntry,
+			    &dac960_proc_fops);
 	}
 
-      sprintf(Controller->ControllerName, "c%d", Controller->ControllerNumber);
-      ControllerProcEntry = proc_mkdir(Controller->ControllerName,
-				       DAC960_ProcDirectoryEntry);
-      proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
-      proc_create_data("current_status", 0, ControllerProcEntry, &dac960_current_status_proc_fops, Controller);
-      UserCommandProcEntry = proc_create_data("user_command", S_IWUSR | S_IRUSR, ControllerProcEntry, &dac960_user_command_proc_fops, Controller);
-      Controller->ControllerProcEntry = ControllerProcEntry;
+	sprintf(Controller->ControllerName, "c%d", Controller->ControllerNumber);
+	ControllerProcEntry = proc_mkdir(Controller->ControllerName,
+					 DAC960_ProcDirectoryEntry);
+	proc_create_data("initial_status", 0, ControllerProcEntry, &dac960_initial_status_proc_fops, Controller);
+	proc_create_data("current_status", 0, ControllerProcEntry, &dac960_current_status_proc_fops, Controller);
+	proc_create_data("user_command", S_IWUSR | S_IRUSR, ControllerProcEntry, &dac960_user_command_proc_fops, Controller);
+	Controller->ControllerProcEntry = ControllerProcEntry;
 }
 
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 00f9fc9..304000c 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2510,8 +2510,10 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
 		up(&dd->port->cmd_slot);
 		return NULL;
 	}
-	if (unlikely(*tag < 0))
+	if (unlikely(*tag < 0)) {
+		up(&dd->port->cmd_slot);
 		return NULL;
+	}
 
 	return dd->port->commands[*tag].sg;
 }
diff --git a/fs/bio.c b/fs/bio.c
index e453924..84da885 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -505,9 +505,14 @@ EXPORT_SYMBOL(bio_clone);
 int bio_get_nr_vecs(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	return min_t(unsigned,
+	int nr_pages;
+
+	nr_pages = min_t(unsigned,
 		     queue_max_segments(q),
 		     queue_max_sectors(q) / (PAGE_SIZE >> 9) + 1);
+
+	return min_t(unsigned, nr_pages, BIO_MAX_PAGES);
+
 }
 EXPORT_SYMBOL(bio_get_nr_vecs);
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index e08f6a20..ba11c30 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -70,7 +70,7 @@ static void bdev_inode_switch_bdi(struct inode *inode,
 	spin_unlock(&dst->wb.list_lock);
 }
 
-static sector_t max_block(struct block_device *bdev)
+sector_t blkdev_max_block(struct block_device *bdev)
 {
 	sector_t retval = ~((sector_t)0);
 	loff_t sz = i_size_read(bdev->bd_inode);
@@ -163,7 +163,7 @@ static int
 blkdev_get_block(struct inode *inode, sector_t iblock,
 		struct buffer_head *bh, int create)
 {
-	if (iblock >= max_block(I_BDEV(inode))) {
+	if (iblock >= blkdev_max_block(I_BDEV(inode))) {
 		if (create)
 			return -EIO;
 
@@ -185,7 +185,7 @@ static int
 blkdev_get_blocks(struct inode *inode, sector_t iblock,
 		struct buffer_head *bh, int create)
 {
-	sector_t end_block = max_block(I_BDEV(inode));
+	sector_t end_block = blkdev_max_block(I_BDEV(inode));
 	unsigned long max_blocks = bh->b_size >> inode->i_blkbits;
 
 	if ((iblock + max_blocks) > end_block) {
diff --git a/fs/buffer.c b/fs/buffer.c
index 351e18e..ad5938c 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -921,6 +921,7 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 	struct buffer_head *head = page_buffers(page);
 	struct buffer_head *bh = head;
 	int uptodate = PageUptodate(page);
+	sector_t end_block = blkdev_max_block(I_BDEV(bdev->bd_inode));
 
 	do {
 		if (!buffer_mapped(bh)) {
@@ -929,7 +930,8 @@ init_page_buffers(struct page *page, struct block_device *bdev,
 			bh->b_blocknr = block;
 			if (uptodate)
 				set_buffer_uptodate(bh);
-			set_buffer_mapped(bh);
+			if (block < end_block)
+				set_buffer_mapped(bh);
 		}
 		block++;
 		bh = bh->b_this_page;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2aa2466..4d4ac24 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1,9 +1,10 @@
 #ifndef _LINUX_BLKDEV_H
 #define _LINUX_BLKDEV_H
 
+#include <linux/sched.h>
+
 #ifdef CONFIG_BLOCK
 
-#include <linux/sched.h>
 #include <linux/major.h>
 #include <linux/genhd.h>
 #include <linux/list.h>
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8de6755..25c40b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2051,6 +2051,7 @@ extern void unregister_blkdev(unsigned int, const char *);
 extern struct block_device *bdget(dev_t);
 extern struct block_device *bdgrab(struct block_device *bdev);
 extern void bd_set_size(struct block_device *, loff_t size);
+extern sector_t blkdev_max_block(struct block_device *bdev);
 extern void bd_forget(struct inode *inode);
 extern void bdput(struct block_device *);
 extern void invalidate_bdev(struct block_device *);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e61d319..017a7fb 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -222,12 +222,6 @@ static inline void part_pack_uuid(const u8 *uuid_str, u8 *to)
 	}
 }
 
-static inline char *part_unpack_uuid(const u8 *uuid, char *out)
-{
-	sprintf(out, "%pU", uuid);
-	return out;
-}
-
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)

-- 
Jens Axboe

