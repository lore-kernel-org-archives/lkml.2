Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1EVW0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:26:03 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab1EVW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:26:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=phheQrLcKA5mbg14ei+4D0i4KVd9X3Ao1+RtKsmRMF0KAiDggqCCB70YmmKnALSLWN
         msoxpUwaJ7X+2UOHCUoA==
Date: Sun, 22 May 2011 15:25:31 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Adding an ugliness in __read_cache_page()?
Message-ID: <alpine.LSU.2.00.1105221518180.17400@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, Christoph,

Could you bear a patch something like the one below?

I have a series aimed at 2.6.41 to remove mm/shmem.c's peculiar radix
tree of swap entries, using slots in the file's standard radix_tree
instead - prompted in part by https://lkml.org/lkml/2011/1/22/110

In isolating the occurrence of swap entries in radix_trees, it becomes
convenient to remove shmem's ->readpage at last, giving it instead its
own ->splice_read.

But drivers/gpu/drm i915 and ttm are using read_cache_page_gfp() or
read_mapping_page() on tmpfs: on objects created by shmem_file_setup().

Nothing else uses read_cache_page_gfp().  I cannot find anything else
using read_mapping_page() on tmpfs, but wonder if something might be
out there.  Stacked filesystems appear not to go that way nowadays.

Would it be better to make i915 and ttm call shmem_read_cache_page()
directly?  Perhaps removing the then unused read_cache_page_gfp(), or
perhaps not: may still be needed for i915 and ttm on tiny !SHMEM ramfs.

I find both ways ugly, but no nice alternative: introducing a new method
when the known callers are already tied to tmpfs/ramfs seems over the top.

Thanks,
Hugh

---

 include/linux/mm.h |    1 +
 mm/filemap.c       |   13 +++++++++++++
 mm/shmem.c         |   26 +++++++++++++++-----------
 3 files changed, 29 insertions(+), 11 deletions(-)

--- 2.6.39/include/linux/mm.h	2011-05-18 21:06:34.000000000 -0700
+++ linux/include/linux/mm.h	2011-05-22 11:50:49.332431949 -0700
@@ -873,6 +873,7 @@ extern void __show_free_areas(unsigned i
 int shmem_lock(struct file *file, int lock, struct user_struct *user);
 struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags);
 int shmem_zero_setup(struct vm_area_struct *);
+struct page *shmem_read_cache_page(struct address_space *, pgoff_t, gfp_t);
 
 #ifndef CONFIG_MMU
 extern unsigned long shmem_get_unmapped_area(struct file *file,
--- 2.6.39/mm/filemap.c	2011-05-18 21:06:34.000000000 -0700
+++ linux/mm/filemap.c	2011-05-22 11:50:49.332431949 -0700
@@ -1762,6 +1762,19 @@ static struct page *__read_cache_page(st
 {
 	struct page *page;
 	int err;
+
+#ifdef CONFIG_TMPFS
+	/*
+	 * The ->readpage() interface does not suit tmpfs at all, since it
+	 * may have pages in swapcache, and needs to find those for itself;
+	 * but gpu/drm/i915 and gpu/drm/ttm need it to support this function.
+	 */
+	if (!filler) {
+		BUG_ON(!mapping_cap_swap_backed(mapping));
+		return shmem_read_cache_page(mapping, index, gfp);
+	}
+#endif
+
 repeat:
 	page = find_get_page(mapping, index);
 	if (!page) {
--- 2.6.39/mm/shmem.c	2011-05-18 21:06:34.000000000 -0700
+++ linux/mm/shmem.c	2011-05-22 11:50:49.332431949 -0700
@@ -1652,17 +1652,22 @@ static struct inode *shmem_get_inode(str
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_symlink_inline_operations;
 
-/*
- * Normally tmpfs avoids the use of shmem_readpage and shmem_write_begin;
- * but providing them allows a tmpfs file to be used for splice, sendfile, and
- * below the loop driver, in the generic fashion that many filesystems support.
- */
-static int shmem_readpage(struct file *file, struct page *page)
+struct page *
+shmem_read_cache_page(struct address_space *mapping, pgoff_t index, gfp_t gfp)
 {
-	struct inode *inode = page->mapping->host;
-	int error = shmem_getpage(inode, page->index, &page, SGP_CACHE, NULL);
-	unlock_page(page);
-	return error;
+	struct page *page;
+	int error;
+
+	/*
+	 * Not shown: addition of gfp arg to shmem_getpage(), passed down here.
+	 * Not shown: addition of shmem_file_splice_read() avoiding ->readpage.
+	 */
+	error = shmem_getpage(mapping->host, index, &page, SGP_CACHE, NULL);
+	if (error)
+		page = ERR_PTR(error);
+	else
+		unlock_page(page);
+	return page;
 }
 
 static int
@@ -2475,7 +2480,6 @@ static const struct address_space_operat
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
-	.readpage	= shmem_readpage,
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
 #endif
