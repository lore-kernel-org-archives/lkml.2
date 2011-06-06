Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab1FFE0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:26:25 -0400
Received: from smtp-out.google.com ([74.125.121.67]:22204 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1FFE0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=UdlIkT8cv/fCcLLgxa8XM+oRydsOVHA5oKKLO6xUV+kmjK7iW5dMU3Vp1KkR5shCaw
         80GgVbxGSCboIU+cJjcA==
Date: Sun, 5 Jun 2011 21:26:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 3/14] tmpfs: take control of its truncate_range
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052124590.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
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

Slightly redefine the ->truncate_range interface: let it now be called
between the unmap_mapping_range()s, with the filesystem responsible for
doing the truncate_inode_pages_range() from it - just as the filesystem
is nowadays responsible for doing that from its ->setattr.

Let's rename shmem_notify_change() to shmem_setattr().  Instead of
calling the generic truncate_setsize(), bring that code in so we can
call shmem_truncate_range() - which will later be updated to perform
its own variant of truncate_inode_pages_range().

Remove the punch_hole unmap_mapping_range() from shmem_truncate_range():
now that the COW's unmap_mapping_range() comes after ->truncate_range,
there is no need to call it a third time.

Export shmem_truncate_range() and add it to the list in shmem_fs.h,
so that i915_gem_object_truncate() can call it explicitly in future;
get this patch in first, then update drm/i915 once this is available
(until then, i915 will just be doing the truncate_inode_pages() twice).

Though introduced five years ago, no other filesystem is implementing
->truncate_range, and its only other user is madvise(,,MADV_REMOVE):
we expect to convert it to fallocate(,FALLOC_FL_PUNCH_HOLE,,) shortly,
whereupon ->truncate_range can be removed from inode_operations -
shmem_truncate_range() will help i915 across that transition too.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
---

 include/linux/shmem_fs.h |    1 
 mm/shmem.c               |   51 +++++++++++++++++++++----------------
 mm/truncate.c            |    4 +-
 3 files changed, 32 insertions(+), 24 deletions(-)

--- linux.orig/mm/shmem.c	2011-06-05 17:16:33.369740944 -0700
+++ linux/mm/shmem.c	2011-06-05 17:44:02.293916853 -0700
@@ -539,7 +539,7 @@ static void shmem_free_pages(struct list
 	} while (next);
 }
 
-static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
+void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long idx;
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
@@ -766,22 +760,23 @@ done2:
 		shmem_free_pages(pages_to_free.next);
 	}
 }
+EXPORT_SYMBOL_GPL(shmem_truncate_range);
 
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
@@ -810,12 +805,19 @@ static int shmem_notify_change(struct de
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
@@ -832,7 +834,6 @@ static void shmem_evict_inode(struct ino
 	struct shmem_xattr *xattr, *nxattr;
 
 	if (inode->i_mapping->a_ops == &shmem_aops) {
-		truncate_inode_pages(inode->i_mapping, 0);
 		shmem_unacct_size(info->flags, inode->i_size);
 		inode->i_size = 0;
 		shmem_truncate_range(inode, 0, (loff_t)-1);
@@ -2706,7 +2707,7 @@ static const struct file_operations shme
 };
 
 static const struct inode_operations shmem_inode_operations = {
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.truncate_range	= shmem_truncate_range,
 #ifdef CONFIG_TMPFS_XATTR
 	.setxattr	= shmem_setxattr,
@@ -2739,7 +2740,7 @@ static const struct inode_operations shm
 	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
@@ -2752,7 +2753,7 @@ static const struct inode_operations shm
 	.removexattr	= shmem_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
-	.setattr	= shmem_notify_change,
+	.setattr	= shmem_setattr,
 	.check_acl	= generic_check_acl,
 #endif
 };
@@ -2908,6 +2909,12 @@ int shmem_lock(struct file *file, int lo
 	return 0;
 }
 
+void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
+{
+	truncate_inode_pages_range(inode->i_mapping, start, end);
+}
+EXPORT_SYMBOL_GPL(shmem_truncate_range);
+
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
 /**
  * mem_cgroup_get_shmem_target - find a page or entry assigned to the shmem file
--- linux.orig/mm/truncate.c	2011-06-05 17:16:33.369740944 -0700
+++ linux/mm/truncate.c	2011-06-05 17:42:31.341466507 -0700
@@ -619,9 +619,9 @@ int vmtruncate_range(struct inode *inode
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
 
--- linux.orig/include/linux/shmem_fs.h	2011-06-05 17:38:03.000000000 -0700
+++ linux/include/linux/shmem_fs.h	2011-06-05 17:50:02.783702754 -0700
@@ -61,6 +61,7 @@ extern struct file *shmem_file_setup(con
 					loff_t size, unsigned long flags);
 extern int shmem_zero_setup(struct vm_area_struct *);
 extern int shmem_lock(struct file *file, int lock, struct user_struct *user);
+extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 extern int shmem_unuse(swp_entry_t entry, struct page *page);
 extern void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
 					struct page **pagep, swp_entry_t *ent);
