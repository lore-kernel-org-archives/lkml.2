Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab1FFEi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:38:27 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1FFEiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=E2wJ/7HccXtehttXUR4PFQzYfoMj3eo9OgvchXTWDV+KHzDzp+o0OoMkTu2QotaVVY
         wcFa3GLpmZ1CpgQfC8eg==
Date: Sun, 5 Jun 2011 21:38:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 11/14] mm: tidy vmtruncate_range and related functions
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052137110.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use consistent variable names in truncate_pagecache(), truncate_setsize(),
vmtruncate() and vmtruncate_range().

unmap_mapping_range() and vmtruncate_range() have mismatched interfaces:
don't change either, but make the vmtruncates more precise about what
they expect unmap_mapping_range() to do.

vmtruncate_range() is currently called only with page-aligned start and
end+1: can handle unaligned start, but unaligned end+1 would hit BUG_ON
in truncate_inode_pages_range() (lacks partial clearing of the end page).

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/truncate.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- linux.orig/mm/truncate.c	2011-06-05 17:42:31.341466507 -0700
+++ linux/mm/truncate.c	2011-06-05 19:19:52.254430023 -0700
@@ -526,8 +526,8 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
 /**
  * truncate_pagecache - unmap and remove pagecache that has been truncated
  * @inode: inode
- * @old: old file offset
- * @new: new file offset
+ * @oldsize: old file size
+ * @newsize: new file size
  *
  * inode's new i_size must already be written before truncate_pagecache
  * is called.
@@ -539,9 +539,10 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  * situations such as writepage being called for a page that has already
  * had its underlying blocks deallocated.
  */
-void truncate_pagecache(struct inode *inode, loff_t old, loff_t new)
+void truncate_pagecache(struct inode *inode, loff_t oldsize, loff_t newsize)
 {
 	struct address_space *mapping = inode->i_mapping;
+	loff_t holebegin = round_up(newsize, PAGE_SIZE);
 
 	/*
 	 * unmap_mapping_range is called twice, first simply for
@@ -552,9 +553,9 @@ void truncate_pagecache(struct inode *in
 	 * truncate_inode_pages finishes, hence the second
 	 * unmap_mapping_range call must be made for correctness.
 	 */
-	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
-	truncate_inode_pages(mapping, new);
-	unmap_mapping_range(mapping, new + PAGE_SIZE - 1, 0, 1);
+	unmap_mapping_range(mapping, holebegin, 0, 1);
+	truncate_inode_pages(mapping, newsize);
+	unmap_mapping_range(mapping, holebegin, 0, 1);
 }
 EXPORT_SYMBOL(truncate_pagecache);
 
@@ -584,29 +585,31 @@ EXPORT_SYMBOL(truncate_setsize);
 /**
  * vmtruncate - unmap mappings "freed" by truncate() syscall
  * @inode: inode of the file used
- * @offset: file offset to start truncating
+ * @newsize: file offset to start truncating
  *
  * This function is deprecated and truncate_setsize or truncate_pagecache
  * should be used instead, together with filesystem specific block truncation.
  */
-int vmtruncate(struct inode *inode, loff_t offset)
+int vmtruncate(struct inode *inode, loff_t newsize)
 {
 	int error;
 
-	error = inode_newsize_ok(inode, offset);
+	error = inode_newsize_ok(inode, newsize);
 	if (error)
 		return error;
 
-	truncate_setsize(inode, offset);
+	truncate_setsize(inode, newsize);
 	if (inode->i_op->truncate)
 		inode->i_op->truncate(inode);
 	return 0;
 }
 EXPORT_SYMBOL(vmtruncate);
 
-int vmtruncate_range(struct inode *inode, loff_t offset, loff_t end)
+int vmtruncate_range(struct inode *inode, loff_t lstart, loff_t lend)
 {
 	struct address_space *mapping = inode->i_mapping;
+	loff_t holebegin = round_up(lstart, PAGE_SIZE);
+	loff_t holelen = 1 + lend - holebegin;
 
 	/*
 	 * If the underlying filesystem is not going to provide
@@ -618,10 +621,10 @@ int vmtruncate_range(struct inode *inode
 
 	mutex_lock(&inode->i_mutex);
 	down_write(&inode->i_alloc_sem);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	inode->i_op->truncate_range(inode, offset, end);
+	unmap_mapping_range(mapping, holebegin, holelen, 1);
+	inode->i_op->truncate_range(inode, lstart, lend);
 	/* unmap again to remove racily COWed private pages */
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
+	unmap_mapping_range(mapping, holebegin, holelen, 1);
 	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);
 
