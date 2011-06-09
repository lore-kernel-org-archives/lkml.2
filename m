Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab1FIWfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:35:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16973 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab1FIWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JA8SC+66MaMHKnwUw87uXazRhVt1UK8zZrm0ug0bOBSYvfGdBYk7t4M0T028LPWE0Z
         5gN86HdvUWwRHi40MeFA==
Date: Thu, 9 Jun 2011 15:35:42 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 4/7] tmpfs: remove_shmem_readpage
In-Reply-To: <alpine.LSU.2.00.1106091529060.2200@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106091534470.2200@sister.anvils>
References: <alpine.LSU.2.00.1106091529060.2200@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove that pernicious shmem_readpage() at last: the things we needed
it for (splice, loop, sendfile, i915 GEM) are now fully taken care of
by shmem_file_splice_read() and shmem_read_mapping_page_gfp().

This removal clears the way for a simpler shmem_getpage_gfp(), since
page is never passed in; but leave most of that cleanup until after.

sys_readahead() and sys_fadvise(POSIX_FADV_WILLNEED) will now EINVAL,
instead of unexpectedly trying to read ahead on tmpfs: if that proves
to be an issue for someone, then we can either arrange for them to
return success instead, or try to implement async readahead on tmpfs.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c |   40 ++++++----------------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

--- linux.orig/mm/shmem.c	2011-06-09 11:38:22.912896122 -0700
+++ linux/mm/shmem.c	2011-06-09 11:39:32.361240481 -0700
@@ -1246,7 +1246,7 @@ static int shmem_getpage_gfp(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
-	struct page *filepage = *pagep;
+	struct page *filepage;
 	struct page *swappage;
 	struct page *prealloc_page = NULL;
 	swp_entry_t *entry;
@@ -1255,18 +1255,8 @@ static int shmem_getpage_gfp(struct inod
 
 	if (idx >= SHMEM_MAX_INDEX)
 		return -EFBIG;
-
-	/*
-	 * Normally, filepage is NULL on entry, and either found
-	 * uptodate immediately, or allocated and zeroed, or read
-	 * in under swappage, which is then assigned to filepage.
-	 * But shmem_readpage (required for splice) passes in a locked
-	 * filepage, which may be found not uptodate by other callers
-	 * too, and may need to be copied from the swappage read in.
-	 */
 repeat:
-	if (!filepage)
-		filepage = find_lock_page(mapping, idx);
+	filepage = find_lock_page(mapping, idx);
 	if (filepage && PageUptodate(filepage))
 		goto done;
 	if (!filepage) {
@@ -1513,8 +1503,7 @@ nospace:
 	 * Perhaps the page was brought in from swap between find_lock_page
 	 * and taking info->lock?  We allow for that at add_to_page_cache_lru,
 	 * but must also avoid reporting a spurious ENOSPC while working on a
-	 * full tmpfs.  (When filepage has been passed in to shmem_getpage, it
-	 * is already in page cache, which prevents this race from occurring.)
+	 * full tmpfs.
 	 */
 	if (!filepage) {
 		struct page *page = find_get_page(mapping, idx);
@@ -1527,7 +1516,7 @@ nospace:
 	spin_unlock(&info->lock);
 	error = -ENOSPC;
 failed:
-	if (*pagep != filepage) {
+	if (filepage) {
 		unlock_page(filepage);
 		page_cache_release(filepage);
 	}
@@ -1673,19 +1662,6 @@ static struct inode *shmem_get_inode(str
 static const struct inode_operations shmem_symlink_inode_operations;
 static const struct inode_operations shmem_symlink_inline_operations;
 
-/*
- * Normally tmpfs avoids the use of shmem_readpage and shmem_write_begin;
- * but providing them allows a tmpfs file to be used for splice, sendfile, and
- * below the loop driver, in the generic fashion that many filesystems support.
- */
-static int shmem_readpage(struct file *file, struct page *page)
-{
-	struct inode *inode = page->mapping->host;
-	int error = shmem_getpage(inode, page->index, &page, SGP_CACHE, NULL);
-	unlock_page(page);
-	return error;
-}
-
 static int
 shmem_write_begin(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned flags,
@@ -1693,7 +1669,6 @@ shmem_write_begin(struct file *file, str
 {
 	struct inode *inode = mapping->host;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
-	*pagep = NULL;
 	return shmem_getpage(inode, index, pagep, SGP_WRITE, NULL);
 }
 
@@ -1893,7 +1868,6 @@ static ssize_t shmem_file_splice_read(st
 	error = 0;
 
 	while (spd.nr_pages < nr_pages) {
-		page = NULL;
 		error = shmem_getpage(inode, index, &page, SGP_CACHE, NULL);
 		if (error)
 			break;
@@ -1916,7 +1890,6 @@ static ssize_t shmem_file_splice_read(st
 		page = spd.pages[page_nr];
 
 		if (!PageUptodate(page) || page->mapping != mapping) {
-			page = NULL;
 			error = shmem_getpage(inode, index, &page,
 							SGP_CACHE, NULL);
 			if (error)
@@ -2125,7 +2098,7 @@ static int shmem_symlink(struct inode *d
 	int error;
 	int len;
 	struct inode *inode;
-	struct page *page = NULL;
+	struct page *page;
 	char *kaddr;
 	struct shmem_inode_info *info;
 
@@ -2803,7 +2776,6 @@ static const struct address_space_operat
 	.writepage	= shmem_writepage,
 	.set_page_dirty	= __set_page_dirty_no_writeback,
 #ifdef CONFIG_TMPFS
-	.readpage	= shmem_readpage,
 	.write_begin	= shmem_write_begin,
 	.write_end	= shmem_write_end,
 #endif
@@ -3175,7 +3147,7 @@ struct page *shmem_read_mapping_page_gfp
 {
 #ifdef CONFIG_SHMEM
 	struct inode *inode = mapping->host;
-	struct page *page = NULL;
+	struct page *page;
 	int error;
 
 	BUG_ON(mapping->a_ops != &shmem_aops);
