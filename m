Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0GIDT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab0GIDT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:19:56 -0400
Message-ID: <4C3694A5.6080103@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:16:53 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>
CC: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 04/11] blkiocg async: block_commit_write not to record
 process info
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a mmap(2)'d page is written back, which means the page doesn't
have buffer_head, ext4 prepares buffer_heads and calls
block_commit_write() from ext4_writepage().
This results to call mark_buffer_dirty() and the page's dirty flag
is set.  In this case, current process marking page dirty is (almost)
flush kernel thread, so the original info of a process which dirtied
this page is lost.

To prevent this issue, this patch introduces
block_commit_write_noiotrack() which is same as block_commit_write()
but runs through a code path not to record current process info.

The portion calling block_commit_write() in ext4 will be modified
in the following patch.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 fs/buffer.c                 |   70 ++++++++++++++++++++++++++++++++-----------
 include/linux/buffer_head.h |    2 +
 2 files changed, 54 insertions(+), 18 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c418fdf..61ebf94 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -660,15 +660,17 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  *
  * If warn is true, then emit a warning if the page is not uptodate and has
  * not been truncated.
+ * If track is true, dirtying process info is recorded for iotrack.
  */
 static void __set_page_dirty(struct page *page,
-		struct address_space *mapping, int warn)
+		struct address_space *mapping, int warn, int track)
 {
 	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
 		account_page_dirtied(page, mapping);
-		blk_iotrack_reset_owner_pagedirty(page, current->mm);
+		if (track)
+			blk_iotrack_reset_owner_pagedirty(page, current->mm);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 	}
@@ -723,7 +725,7 @@ int __set_page_dirty_buffers(struct page *page)
 	spin_unlock(&mapping->private_lock);
 
 	if (newly_dirty)
-		__set_page_dirty(page, mapping, 1);
+		__set_page_dirty(page, mapping, 1, 1);
 	return newly_dirty;
 }
 EXPORT_SYMBOL(__set_page_dirty_buffers);
@@ -1137,18 +1139,11 @@ __getblk_slow(struct block_device *bdev, sector_t block, int size)
  */
 
 /**
- * mark_buffer_dirty - mark a buffer_head as needing writeout
+ * __mark_buffer_dirty - helper function for mark_buffer_dirty*
  * @bh: the buffer_head to mark dirty
- *
- * mark_buffer_dirty() will set the dirty bit against the buffer, then set its
- * backing page dirty, then tag the page as dirty in its address_space's radix
- * tree and then attach the address_space's inode to its superblock's dirty
- * inode list.
- *
- * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
- * mapping->tree_lock and the global inode_lock.
+ * @track: if true, dirtying process info will be recorded for iotrack
  */
-void mark_buffer_dirty(struct buffer_head *bh)
+static void __mark_buffer_dirty(struct buffer_head *bh, int track)
 {
 	WARN_ON_ONCE(!buffer_uptodate(bh));
 
@@ -1169,12 +1164,40 @@ void mark_buffer_dirty(struct buffer_head *bh)
 		if (!TestSetPageDirty(page)) {
 			struct address_space *mapping = page_mapping(page);
 			if (mapping)
-				__set_page_dirty(page, mapping, 0);
+				__set_page_dirty(page, mapping, 0, track);
 		}
 	}
 }
+
+/**
+ * mark_buffer_dirty - mark a buffer_head as needing writeout
+ * @bh: the buffer_head to mark dirty
+ *
+ * mark_buffer_dirty() will set the dirty bit against the buffer, then set its
+ * backing page dirty, then tag the page as dirty in its address_space's radix
+ * tree and then attach the address_space's inode to its superblock's dirty
+ * inode list.
+ *
+ * mark_buffer_dirty() is atomic.  It takes bh->b_page->mapping->private_lock,
+ * mapping->tree_lock and the global inode_lock.
+ */
+void mark_buffer_dirty(struct buffer_head *bh)
+{
+	__mark_buffer_dirty(bh, 1);
+}
 EXPORT_SYMBOL(mark_buffer_dirty);
 
+/**
+ * mark_buffer_dirty_noiotrack
+ * - same as mark_buffer_dirty but doesn't record dirtying process info
+ * @bh: the buffer_head to mark dirty
+ */
+void mark_buffer_dirty_noiotrack(struct buffer_head *bh)
+{
+	__mark_buffer_dirty(bh, 0);
+}
+EXPORT_SYMBOL(mark_buffer_dirty_noiotrack);
+
 /*
  * Decrement a buffer_head's reference count.  If all buffers against a page
  * have zero reference count, are clean and unlocked, and if the page is clean
@@ -1916,7 +1939,7 @@ static int __block_prepare_write(struct inode *inode, struct page *page,
 }
 
 static int __block_commit_write(struct inode *inode, struct page *page,
-		unsigned from, unsigned to)
+		unsigned from, unsigned to, int track)
 {
 	unsigned block_start, block_end;
 	int partial = 0;
@@ -1934,7 +1957,10 @@ static int __block_commit_write(struct inode *inode, struct page *page,
 				partial = 1;
 		} else {
 			set_buffer_uptodate(bh);
-			mark_buffer_dirty(bh);
+			if (track)
+				mark_buffer_dirty(bh);
+			else
+				mark_buffer_dirty_noiotrack(bh);
 		}
 		clear_buffer_new(bh);
 	}
@@ -2067,7 +2093,7 @@ int block_write_end(struct file *file, struct address_space *mapping,
 	flush_dcache_page(page);
 
 	/* This could be a short (even 0-length) commit */
-	__block_commit_write(inode, page, start, start+copied);
+	__block_commit_write(inode, page, start, start+copied, 1);
 
 	return copied;
 }
@@ -2414,11 +2440,19 @@ EXPORT_SYMBOL(block_prepare_write);
 int block_commit_write(struct page *page, unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	__block_commit_write(inode,page,from,to);
+	__block_commit_write(inode, page, from, to, 1);
 	return 0;
 }
 EXPORT_SYMBOL(block_commit_write);
 
+int block_commit_write_noiotrack(struct page *page, unsigned from, unsigned to)
+{
+	struct inode *inode = page->mapping->host;
+	__block_commit_write(inode, page, from, to, 0);
+	return 0;
+}
+EXPORT_SYMBOL(block_commit_write_noiotrack);
+
 /*
  * block_page_mkwrite() is not allowed to change the file size as it gets
  * called from a page fault handler when a page is first dirtied. Hence we must
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 1b9ba19..9d7e0b0 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -145,6 +145,7 @@ BUFFER_FNS(Unwritten, unwritten)
  */
 
 void mark_buffer_dirty(struct buffer_head *bh);
+void mark_buffer_dirty_noiotrack(struct buffer_head *bh);
 void init_buffer(struct buffer_head *, bh_end_io_t *, void *);
 void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset);
@@ -225,6 +226,7 @@ int cont_write_begin(struct file *, struct address_space *, loff_t,
 			get_block_t *, loff_t *);
 int generic_cont_expand_simple(struct inode *inode, loff_t size);
 int block_commit_write(struct page *page, unsigned from, unsigned to);
+int block_commit_write_noiotrack(struct page *page, unsigned from, unsigned to);
 int block_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 				get_block_t get_block);
 void block_sync_page(struct page *);
-- 
1.6.2.5
