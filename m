Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1EaAjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:39:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10775 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388Ab1EaAjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=cphHXqhclpzq5pAyPe7u0/MP26MO4BlsECAJm56Ltc2JyY9fx8K3B2Db1GjGSnpWm+
         qkim2p/6vahFEJJQPi1A==
Date: Mon, 30 May 2011 17:39:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/14] tmpfs: take control of its truncate_range
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301737040.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35's new truncate convention gave tmpfs the opportunity to control
its file truncation, no longer enforced from outside by vmtruncate().
We shall want to build upon that, to handle pagecache and swap together.

Slightly redefine the ->truncate_range interface, so far implemented
only by tmpfs to support madvise(,,MADV_REMOVE).  Let it now be called
between the unmap_mapping_range()s, with the filesystem responsible for
doing the truncate_inode_pages_range() from it - just as the filesystem
is nowadays responsible for doing that from its ->setattr.

Let's rename shmem_notify_change() to shmem_setattr().  Instead of
calling the generic truncate_setsize(), bring that code in so we can
call shmem_truncate_range() - which will later be updated to perform
its own variant of truncate_inode_pages_range().

Remove the punch_hole unmap_mapping_range() from shmem_truncate_range():
now that the COW's unmap_mapping_range() comes after ->truncate_range,
there's no need to call it a third time.

Note that drivers/gpu/drm/i915/i915_gem.c i915_gem_object_truncate()
calls the tmpfs ->truncate_range directly: update that in a separate
patch later, for now just let it duplicate the truncate_inode_pages().
Because i915 handles unmap_mapping_range() itself at a different stage,
we have chosen not to bundle that into ->truncate_range.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
I notice that ext4 is now joining ocfs2 and xfs in supporting fallocate
FALLOC_FL_PUNCH_HOLE: perhaps they should support truncate_range, and
tmpfs should support fallocate?  But worry about that another time...

 mm/shmem.c    |   42 +++++++++++++++++++++---------------------
 mm/truncate.c |    4 ++--
 2 files changed, 23 insertions(+), 23 deletions(-)

--- linux.orig/mm/shmem.c	2011-05-30 13:56:10.000000000 -0700
+++ linux/mm/shmem.c	2011-05-30 14:13:03.569821995 -0700
@@ -562,6 +562,8 @@ static void shmem_truncate_range(struct
 	spinlock_t *punch_lock;
 	unsigned long upper_limit;
 
+	truncate_inode_pages_range(inode->i_mapping, start, end);
+
 	inode->i_ctime = inode->i_mtime = CURRENT_TIME;
 	idx = (start + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (idx >= info->next_index)
@@ -738,16 +740,8 @@ done2:
 		 * lowered next_index.  Also, though shmem_getpage checks
 		 * i_size before adding to cache, no recheck after: so fix the
 		 * narrow window there too.
-		 *
-		 * Recalling truncate_inode_pages_range and unmap_mapping_range
-		 * every time for punch_hole (which never got a chance to clear
-		 * SHMEM_PAGEIN at the start of vmtruncate_range) is expensive,
-		 * yet hardly ever necessary: try to optimize them out later.
 		 */
 		truncate_inode_pages_range(inode->i_mapping, start, end);
-		if (punch_hole)
-			unmap_mapping_range(inode->i_mapping, start,
-							end - start, 1);
 	}
 
 	spin_lock(&info->lock);
@@ -767,21 +761,21 @@ done2:
 	}
 }
 
-static int shmem_notify_change(struct dentry *dentry, struct iattr *attr)
+static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode *inode = dentry->d_inode;
-	loff_t newsize = attr->ia_size;
 	int error;
 
 	error = inode_change_ok(inode, attr);
 	if (error)
 		return error;
 
-	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)
-					&& newsize != inode->i_size) {
+	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
+		loff_t oldsize = inode->i_size;
+		loff_t newsize = attr->ia_size;
 		struct page *page = NULL;
 
-		if (newsize < inode->i_size) {
+		if (newsize < oldsize) {
 			/*
 			 * If truncating down to a partial page, then
 			 * if that page is already allocated, hold it
@@ -810,12 +804,19 @@ static int shmem_notify_change(struct de
 				spin_unlock(&info->lock);
 			}
 		}
-
-		/* XXX(truncate): truncate_setsize should be called last */
-		truncate_setsize(inode, newsize);
+		if (newsize != oldsize) {
+			i_size_write(inode, newsize);
+			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
+		}
+		if (newsize < oldsize) {
+			loff_t holebegin = round_up(newsize, PAGE_SIZE);
+			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
+			shmem_truncate_range(inode, newsize, (loff_t)-1);
+			/* unmap again to remove racily COWed private pages */
+			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
+		}
 		if (page)
 			page_cache_release(page);
-		shmem_truncate_range(inode, newsize, (loff_t)-1);
 	}
 
 	setattr_copy(inode, attr);
@@ -832,7 +833,6 @@ static void shmem_evict_inode(struct ino
 	struct shmem_xattr *xattr, *nxattr;
 
 	if (inode->i_mapping->a_ops == &shmem_aops) {
-		truncate_inode_pages(inode->i_mapping, 0);
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
 		shmem_truncate_range(inode, 0, (loff_t)-1);
@@ -2706,7 +2706,7 @@ static const struct file_operations shme
 };
 
 static const struct inode_operations shmem_inode_operations = {
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.truncate_range	= shmem_truncate_range,
 #ifdef CONFIG_TMPFS_XATTR
 	.setxattr	= shmem_setxattr,
@@ -2739,7 +2739,7 @@ static const struct inode_operations shm
 	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
@@ -2752,7 +2752,7 @@ static const struct inode_operations shm
 	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
--- linux.orig/mm/truncate.c	2011-05-30 14:09:52.000000000 -0700
+++ linux/mm/truncate.c	2011-05-30 14:15:29.814546645 -0700
@@ -621,9 +621,9 @@ int vmtruncate_range(struct inode *inode
 	mutex_lock(&inode->i_mutex);
 	down_write(&inode->i_alloc_sem);
 	unmap_mapping_range(mapping, offset, (end - offset), 1);
-	truncate_inode_pages_range(mapping, offset, end);
-	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	inode->i_op->truncate_range(inode, offset, end);
+	/* unmap again to remove racily COWed private pages */
+	unmap_mapping_range(mapping, offset, (end - offset), 1);
 	up_write(&inode->i_alloc_sem);
 	mutex_unlock(&inode->i_mutex);
 
