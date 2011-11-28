Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab1K1Hr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:47:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab1K1Hr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:47:57 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: [UPDATED PATCH 17/62] md: remove the second argument of k[un]map_atomic()
Date: Mon, 28 Nov 2011 15:47:40 +0800
Message-Id: <1322466460-10628-1-git-send-email-amwang@redhat.com>
In-Reply-To: <20111127170013.20d180a9@notabene.brown>
References: <20111127170013.20d180a9@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update: Separate md and dm code correctly.

Acked-by: NeilBrown <neilb@suse.de>
Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/md/bitmap.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 7878712..4062823 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -457,7 +457,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
 		return;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared)
 		/* rocking back to read-only */
@@ -467,7 +467,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
 	/* Just in case these have been changed via sysfs: */
 	sb->daemon_sleep = cpu_to_le32(bitmap->mddev->bitmap_info.daemon_sleep/HZ);
 	sb->write_behind = cpu_to_le32(bitmap->mddev->bitmap_info.max_write_behind);
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic(sb);
 	write_page(bitmap, bitmap->sb_page, 1);
 }
 
@@ -478,7 +478,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
 
 	if (!bitmap || !bitmap->sb_page)
 		return;
-	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
 	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
 	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
@@ -497,7 +497,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
 	printk(KERN_DEBUG "     sync size: %llu KB\n",
 			(unsigned long long)le64_to_cpu(sb->sync_size)/2);
 	printk(KERN_DEBUG "max write behind: %d\n", le32_to_cpu(sb->write_behind));
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic(sb);
 }
 
 /*
@@ -525,7 +525,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	}
 	bitmap->sb_page->index = 0;
 
-	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page);
 
 	sb->magic = cpu_to_le32(BITMAP_MAGIC);
 	sb->version = cpu_to_le32(BITMAP_MAJOR_HI);
@@ -533,7 +533,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	chunksize = bitmap->mddev->bitmap_info.chunksize;
 	BUG_ON(!chunksize);
 	if (!is_power_of_2(chunksize)) {
-		kunmap_atomic(sb, KM_USER0);
+		kunmap_atomic(sb);
 		printk(KERN_ERR "bitmap chunksize not a power of 2\n");
 		return -EINVAL;
 	}
@@ -571,7 +571,7 @@ static int bitmap_new_disk_sb(struct bitmap *bitmap)
 	bitmap->flags |= BITMAP_HOSTENDIAN;
 	sb->version = cpu_to_le32(BITMAP_MAJOR_HOSTENDIAN);
 
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic(sb);
 
 	return 0;
 }
@@ -603,7 +603,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		return err;
 	}
 
-	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page);
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
@@ -664,7 +664,7 @@ success:
 		bitmap->events_cleared = bitmap->mddev->events;
 	err = 0;
 out:
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic(sb);
 	if (err)
 		bitmap_print_sb(bitmap);
 	return err;
@@ -689,7 +689,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 		return 0;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page);
 	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {
 	case MASK_SET:
@@ -703,7 +703,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 	default:
 		BUG();
 	}
-	kunmap_atomic(sb, KM_USER0);
+	kunmap_atomic(sb);
 	return old;
 }
 
@@ -881,12 +881,12 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	bit = file_page_offset(bitmap, chunk);
 
 	/* set the bit */
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	if (bitmap->flags & BITMAP_HOSTENDIAN)
 		set_bit(bit, kaddr);
 	else
 		__set_bit_le(bit, kaddr);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 	pr_debug("set file bit %lu page %lu\n", bit, page->index);
 	/* record page number so it gets flushed to disk when unplug occurs */
 	set_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
@@ -1050,10 +1050,10 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 				 * if bitmap is out of date, dirty the
 				 * whole page and write it out
 				 */
-				paddr = kmap_atomic(page, KM_USER0);
+				paddr = kmap_atomic(page);
 				memset(paddr + offset, 0xff,
 				       PAGE_SIZE - offset);
-				kunmap_atomic(paddr, KM_USER0);
+				kunmap_atomic(paddr);
 				write_page(bitmap, page, 1);
 
 				ret = -EIO;
@@ -1061,12 +1061,12 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 					goto err;
 			}
 		}
-		paddr = kmap_atomic(page, KM_USER0);
+		paddr = kmap_atomic(page);
 		if (bitmap->flags & BITMAP_HOSTENDIAN)
 			b = test_bit(bit, paddr);
 		else
 			b = test_bit_le(bit, paddr);
-		kunmap_atomic(paddr, KM_USER0);
+		kunmap_atomic(paddr);
 		if (b) {
 			/* if the disk bit is set, set the memory bit */
 			int needed = ((sector_t)(i+1) << (CHUNK_BLOCK_SHIFT(bitmap))
@@ -1207,10 +1207,10 @@ void bitmap_daemon_work(struct mddev *mddev)
 			    bitmap->mddev->bitmap_info.external == 0) {
 				bitmap_super_t *sb;
 				bitmap->need_sync = 0;
-				sb = kmap_atomic(bitmap->sb_page, KM_USER0);
+				sb = kmap_atomic(bitmap->sb_page);
 				sb->events_cleared =
 					cpu_to_le64(bitmap->events_cleared);
-				kunmap_atomic(sb, KM_USER0);
+				kunmap_atomic(sb);
 				write_page(bitmap, bitmap->sb_page, 1);
 			}
 			spin_lock_irqsave(&bitmap->lock, flags);
@@ -1233,7 +1233,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 						  -1);
 
 				/* clear the bit */
-				paddr = kmap_atomic(page, KM_USER0);
+				paddr = kmap_atomic(page);
 				if (bitmap->flags & BITMAP_HOSTENDIAN)
 					clear_bit(file_page_offset(bitmap, j),
 						  paddr);
@@ -1242,7 +1242,7 @@ void bitmap_daemon_work(struct mddev *mddev)
 						file_page_offset(bitmap,
 								 j),
 						paddr);
-				kunmap_atomic(paddr, KM_USER0);
+				kunmap_atomic(paddr);
 			} else if (*bmc <= 2) {
 				*bmc = 1; /* maybe clear the bit next time */
 				set_page_attr(bitmap, page, BITMAP_PAGE_PENDING);
-- 
1.7.4.4

