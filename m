Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2LTXKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:10:54 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:33080 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2LTXKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:10:35 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 2/4] mm: Update file times when inodes are written after mmaped writes
Date: Thu, 20 Dec 2012 15:10:10 -0800
Message-Id: <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <cover.1356043686.git.luto@amacapital.net>
References: <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
 <cover.1356043686.git.luto@amacapital.net>
In-Reply-To: <cover.1356043686.git.luto@amacapital.net>
References: <cover.1356043686.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The onus is currently on filesystems to call file_update_time
somewhere in the page_mkwrite path.  This is unfortunate for three
reasons:

1. page_mkwrite on a locked page should be fast.  ext4, for example,
   often sleeps while dirtying inodes.

2. The current behavior is surprising -- the timestamp resulting from
   an mmaped write will be before the write, not after.  This contradicts
   the mmap(2) manpage, which says:

     The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
     MAP_SHARED  will  be  updated  after  a write to the mapped region, and
     before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
     occurs.

3. (An ulterior motive) I'd like to use hardware dirty tracking for
   shared, locked, writable mappings (instead of page faults).  Moving
   important work out of the page_mkwrite path is an important first step.

The next patch will remove the now-unnecessary file_update_time calls.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/inode.c              | 37 +++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |  1 +
 include/linux/pagemap.h |  3 +++
 mm/memory.c             |  2 +-
 mm/mmap.c               |  4 ++++
 mm/page-writeback.c     | 30 ++++++++++++++++++++++++++++--
 6 files changed, 74 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 64999f1..d881d0b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1688,6 +1688,43 @@ int file_update_time(struct file *file)
 }
 EXPORT_SYMBOL(file_update_time);
 
+/**
+ *	inode_update_time_writable	-	update mtime and ctime time
+ *	@inode: inode accessed
+ *
+ *	This is like file_update_time, but it assumes the mnt is writable
+ *	and takes an inode parameter instead.
+ */
+
+int inode_update_time_writable(struct inode *inode)
+{
+	struct timespec now;
+	int sync_it = 0;
+	int ret;
+
+	/* First try to exhaust all avenues to not sync */
+	if (IS_NOCMTIME(inode))
+		return 0;
+
+	now = current_fs_time(inode->i_sb);
+	if (!timespec_equal(&inode->i_mtime, &now))
+		sync_it = S_MTIME;
+
+	if (!timespec_equal(&inode->i_ctime, &now))
+		sync_it |= S_CTIME;
+
+	if (IS_I_VERSION(inode))
+		sync_it |= S_VERSION;
+
+	if (!sync_it)
+		return 0;
+
+	ret = update_time(inode, &now, sync_it);
+
+	return ret;
+}
+EXPORT_SYMBOL(inode_update_time_writable);
+
 int inode_needs_sync(struct inode *inode)
 {
 	if (IS_SYNC(inode))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 75fe9a1..c95f9fa 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2554,6 +2554,7 @@ extern int inode_newsize_ok(const struct inode *, loff_t offset);
 extern void setattr_copy(struct inode *inode, const struct iattr *attr);
 
 extern int file_update_time(struct file *file);
+extern int inode_update_time_writable(struct inode *inode);
 
 extern int generic_show_options(struct seq_file *m, struct dentry *root);
 extern void save_mount_options(struct super_block *sb, char *options);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e42c762..a038ed9 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -24,6 +24,7 @@ enum mapping_flags {
 	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
 	AS_MM_ALL_LOCKS	= __GFP_BITS_SHIFT + 2,	/* under mm_take_all_locks() */
 	AS_UNEVICTABLE	= __GFP_BITS_SHIFT + 3,	/* e.g., ramdisk, SHM_LOCK */
+	AS_CMTIME	= __GFP_BITS_SHIFT + 4, /* written via pte */
 };
 
 static inline void mapping_set_error(struct address_space *mapping, int error)
@@ -68,6 +69,8 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
 				(__force unsigned long)mask;
 }
 
+extern void mapping_flush_cmtime(struct address_space *mapping);
+
 /*
  * The page cache can done in larger chunks than
  * one page, because it allows for more efficient
diff --git a/mm/memory.c b/mm/memory.c
index 221fc9f..086b901 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1160,7 +1160,7 @@ again:
 				rss[MM_ANONPAGES]--;
 			else {
 				if (pte_dirty(ptent))
-					set_page_dirty(page);
+					set_page_dirty_from_pte(page);
 				if (pte_young(ptent) &&
 				    likely(!VM_SequentialReadHint(vma)))
 					mark_page_accessed(page);
diff --git a/mm/mmap.c b/mm/mmap.c
index 3913262..60301dc 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -223,6 +223,10 @@ static struct vm_area_struct *remove_vma(struct vm_area_struct *vma)
 	struct vm_area_struct *next = vma->vm_next;
 
 	might_sleep();
+
+	if (vma->vm_file)
+		mapping_flush_cmtime(vma->vm_file->f_mapping);
+
 	if (vma->vm_ops && vma->vm_ops->close)
 		vma->vm_ops->close(vma);
 	if (vma->vm_file)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index cdea11a..8cbb7fb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1910,6 +1910,13 @@ int do_writepages(struct address_space *mapping, struct writeback_control *wbc)
 		ret = mapping->a_ops->writepages(mapping, wbc);
 	else
 		ret = generic_writepages(mapping, wbc);
+
+	/*
+	 * This is after writepages because the AS_CMTIME bit won't
+	 * bet set until writepages is called.
+	 */
+	mapping_flush_cmtime(mapping);
+
 	return ret;
 }
 
@@ -2117,8 +2124,17 @@ EXPORT_SYMBOL(set_page_dirty);
  */
 int set_page_dirty_from_pte(struct page *page)
 {
-	/* Doesn't do anything interesting yet. */
-	return set_page_dirty(page);
+	int ret = set_page_dirty(page);
+
+	/*
+	 * We may be out of memory and/or have various locks held, so
+	 * there isn't much we can do in here.
+	 */
+	struct address_space *mapping = page_mapping(page);
+	if (mapping)
+		set_bit(AS_CMTIME, &mapping->flags);
+
+	return ret;
 }
 
 /*
@@ -2287,3 +2303,13 @@ int mapping_tagged(struct address_space *mapping, int tag)
 	return radix_tree_tagged(&mapping->page_tree, tag);
 }
 EXPORT_SYMBOL(mapping_tagged);
+
+/*
+ * Call from any context from which inode_update_time_writable would be okay
+ * to flush deferred cmtime changes.
+ */
+void mapping_flush_cmtime(struct address_space *mapping)
+{
+	if (test_and_clear_bit(AS_CMTIME, &mapping->flags))
+		inode_update_time_writable(mapping->host);
+}
-- 
1.7.11.7

