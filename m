Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030209Ab1EWUW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:22:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:60188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222Ab1EWUW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:22:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LbvtYwapTKimyciuGGc1Dmpo93HgVrD9titNVwxAnZ2KYe7HexLnorma0XbHdHyxSL
         Bpoc8Utg/VnMU/aARJYQ==
Date: Mon, 23 May 2011 13:22:26 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Hugh Dickins <hughd@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Consistency of loops in mm/truncate.c?
In-Reply-To: <alpine.LSU.2.00.1105221526020.17400@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105231317290.24523@sister.anvils>
References: <alpine.LSU.2.00.1105221526020.17400@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 May 2011, Hugh Dickins wrote:

> Andrew,
> 
> I have a series aimed at 2.6.41 to remove mm/shmem.c's peculiar radix
> tree of swap entries, using slots in the file's standard radix_tree
> instead - prompted in part by https://lkml.org/lkml/2011/1/22/110
> 
> There's a patch to give shmem its own truncation loop, handling pages
> and swap entries in the same pass.  For that I want to start from a
> copy of truncate_inode_page_range(), but notice some discrepancies
> between the different loops in mm/truncate.c, so want to standardize
> them first before copying.
> 
> The advancement of index is hard to follow: we rely upon page->index
> of an unlocked page persisting, yet we're ashamed of doing so, sometimes
> reading it again once locked.  invalidate_mapping_pages() apologizes for
> this, but I think we should now just document that page->index is not
> modified until the page is freed.
> 
> invalidate_inode_pages2_range() has two sophistications not seen
> elsewhere, which 7afadfdc says were folded in by akpm (along with
> a page->index one):
> 
> - Don't look up more pages than we're going to use:
>   seems a good thing for me to fold into truncate_inode_pages_range()
>   and invalidate_mapping_pages() too.
> 
> - Check for the cursor wrapping at the end of the mapping:
>   but with
> 
> #if BITS_PER_LONG==32
> #define MAX_LFS_FILESIZE (((u64)PAGE_CACHE_SIZE << (BITS_PER_LONG-1))-1) 
> #elif BITS_PER_LONG==64
> #define MAX_LFS_FILESIZE 0x7fffffffffffffffUL
> #endif
> 
>   I don't see how page->index + 1 would ever be 0, even if one or
>   other of those "-1"s went away; so may I delete the "wrapped" case?
> 
> Thanks,
> Hugh

Sorry, I have pasky's history in my git tree, and the commit I referred
to there comes from shortly before the git epoch.  Here is that commit:

commit 7afadfdc750969c3fd7128c4f03678232118d155
Author: Zach Brown <zach.brown@oracle.com>
Date:   Fri Mar 4 17:26:38 2005 -0800

    [PATCH] invalidate range of pages after direct IO write
    
    Presently we invalidate all of a file's pages when writing to any part of
    that file with direct-IO.
    
    After a direct IO write only invalidate the pages that the write intersected.
    invalidate_inode_pages2_range(mapping, pgoff start, pgoff end) is added and
    called from generic_file_direct_IO().
    
    While we're in there, invalidate_inode_pages2() was calling
    unmap_mapping_range() with the wrong convention in the single page case.
    It was providing the byte offset of the final page rather than the length
    of the hole being unmapped.  This is also fixed.
    
    This was lightly tested with a 10k op fsx run with O_DIRECT on a 16MB file
    in ext3 on a junky old IDE drive.  Totaling vmstat columns of blocks read
    and written during the runs shows that read traffic drops significantly.
    The run time seems to have gone down a little.
    
    Two runs before the patch gave the following user/real/sys times and total
    blocks in and out:
    
    0m28.029s 0m20.093s 0m3.166s 16673 125107
    0m27.949s 0m20.068s 0m3.227s 18426 126094
    
    and after the patch:
    
    0m26.775s 0m19.996s 0m3.060s 3505 124982
    0m26.856s 0m19.935s 0m3.052s 3505 125279
    
    akpm:
    
    - Don't look up more pages than we're going to use
    
    - Don't test page->index until we've locked the page
    
    - Check for the cursor wrapping at the end of the mapping.
    
    Signed-off-by: Zach Brown <zach.brown@oracle.com>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 30cb440..dec8127 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1353,6 +1353,8 @@ static inline void invalidate_remote_inode(struct inode *inode)
 		invalidate_inode_pages(inode->i_mapping);
 }
 extern int invalidate_inode_pages2(struct address_space *mapping);
+extern int invalidate_inode_pages2_range(struct address_space *mapping,
+					 pgoff_t start, pgoff_t end);
 extern int write_inode_now(struct inode *, int);
 extern int filemap_fdatawrite(struct address_space *);
 extern int filemap_flush(struct address_space *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 4f2fb2c..11e372e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2283,7 +2283,10 @@ generic_file_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		retval = mapping->a_ops->direct_IO(rw, iocb, iov,
 						offset, nr_segs);
 		if (rw == WRITE && mapping->nrpages) {
-			int err = invalidate_inode_pages2(mapping);
+			pgoff_t end = (offset + iov_length(iov, nr_segs) - 1)
+				      >> PAGE_CACHE_SHIFT;
+			int err = invalidate_inode_pages2_range(mapping,
+					offset >> PAGE_CACHE_SHIFT, end);
 			if (err)
 				retval = err;
 		}
diff --git a/mm/truncate.c b/mm/truncate.c
index 9645008..f1fa4bb 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -241,54 +241,62 @@ unsigned long invalidate_inode_pages(struct address_space *mapping)
 EXPORT_SYMBOL(invalidate_inode_pages);
 
 /**
- * invalidate_inode_pages2 - remove all pages from an address_space
+ * invalidate_inode_pages2_range - remove range of pages from an address_space
  * @mapping - the address_space
+ * @start: the page offset 'from' which to invalidate
+ * @end: the page offset 'to' which to invalidate (inclusive)
  *
  * Any pages which are found to be mapped into pagetables are unmapped prior to
  * invalidation.
  *
  * Returns -EIO if any pages could not be invalidated.
  */
-int invalidate_inode_pages2(struct address_space *mapping)
+int invalidate_inode_pages2_range(struct address_space *mapping,
+				  pgoff_t start, pgoff_t end)
 {
 	struct pagevec pvec;
-	pgoff_t next = 0;
+	pgoff_t next;
 	int i;
 	int ret = 0;
-	int did_full_unmap = 0;
+	int did_range_unmap = 0;
+	int wrapped = 0;
 
 	pagevec_init(&pvec, 0);
-	while (!ret && pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+	next = start;
+	while (next <= end && !ret && !wrapped &&
+		pagevec_lookup(&pvec, mapping, next,
+			min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1)) {
 		for (i = 0; !ret && i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 			int was_dirty;
 
 			lock_page(page);
-			if (page->mapping != mapping) {	/* truncate race? */
+			if (page->mapping != mapping || page->index > end) {
 				unlock_page(page);
 				continue;
 			}
 			wait_on_page_writeback(page);
 			next = page->index + 1;
+			if (next == 0)
+				wrapped = 1;
 			while (page_mapped(page)) {
-				if (!did_full_unmap) {
+				if (!did_range_unmap) {
 					/*
 					 * Zap the rest of the file in one hit.
-					 * FIXME: invalidate_inode_pages2()
-					 * should take start/end offsets.
 					 */
 					unmap_mapping_range(mapping,
-						page->index << PAGE_CACHE_SHIFT,
-					  	-1, 0);
-					did_full_unmap = 1;
+					    page->index << PAGE_CACHE_SHIFT,
+					    (end - page->index + 1)
+							<< PAGE_CACHE_SHIFT,
+					    0);
+					did_range_unmap = 1;
 				} else {
 					/*
 					 * Just zap this page
 					 */
 					unmap_mapping_range(mapping,
 					  page->index << PAGE_CACHE_SHIFT,
-					  (page->index << PAGE_CACHE_SHIFT)+1,
-					  0);
+					  PAGE_CACHE_SIZE, 0);
 				}
 			}
 			was_dirty = test_clear_page_dirty(page);
@@ -304,4 +312,19 @@ int invalidate_inode_pages2(struct address_space *mapping)
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
+
+/**
+ * invalidate_inode_pages2 - remove all pages from an address_space
+ * @mapping - the address_space
+ *
+ * Any pages which are found to be mapped into pagetables are unmapped prior to
+ * invalidation.
+ *
+ * Returns -EIO if any pages could not be invalidated.
+ */
+int invalidate_inode_pages2(struct address_space *mapping)
+{
+	return invalidate_inode_pages2_range(mapping, 0, -1);
+}
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2);
