Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab2CIDkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 22:40:10 -0500
Received: from ozlabs.org ([203.10.76.45]:45271 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754040Ab2CIDkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 22:40:06 -0500
Date: Fri, 9 Mar 2012 14:25:41 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hughd@google.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        Andrew Barry <abarry@cray.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
Message-ID: <20120309032541.GO10735@truffala.fritz.box>
Mail-Followup-To: David Gibson <david@gibson.dropbear.id.au>,
	Andrew Morton <akpm@linux-foundation.org>, hughd@google.com,
	paulus@samba.org, linux-kernel@vger.kernel.org,
	Andrew Barry <abarry@cray.com>, Mel Gorman <mgorman@suse.de>,
	Minchan Kim <minchan.kim@gmail.com>,
	Hillf Danton <dhillf@gmail.com>
References: <1331095694-27780-1-git-send-email-david@gibson.dropbear.id.au>
 <1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au>
 <20120307162720.6e9ef6ef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307162720.6e9ef6ef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 04:27:20PM -0800, Andrew Morton wrote:
> On Wed,  7 Mar 2012 15:48:14 +1100
> David Gibson <david@gibson.dropbear.id.au> wrote:
> 
> > hugetlbfs_{get,put}_quota() are badly named.  They don't interact with the
> > general quota handling code, and they don't much resemble its behaviour.
> > Rather than being about maintaining limits on on-disk block usage by
> > particular users, they are instead about maintaining limits on in-memory
> > page usage (including anonymous MAP_PRIVATE copied-on-write pages)
> > associated with a particular hugetlbfs filesystem instance.
> > 
> > Worse, they work by having callbacks to the hugetlbfs filesystem code from
> > the low-level page handling code, in particular from free_huge_page().
> > This is a layering violation of itself, but more importantly, if the kernel
> > does a get_user_pages() on hugepages (which can happen from KVM amongst
> > others), then the free_huge_page() can be delayed until after the
> > associated inode has already been freed.  If an unmount occurs at the
> > wrong time, even the hugetlbfs superblock where the "quota" limits are
> > stored may have been freed.
> > 
> > Andrew Barry proposed a patch to fix this by having hugepages, instead of
> > storing a pointer to their address_space and reaching the superblock from
> > there, had the hugepages store pointers directly to the superblock, bumping
> > the reference count as appropriate to avoid it being freed.  Andrew Morton
> > rejected that version, however, on the grounds that it made the existing
> > layering violation worse.
> > 
> > This is a reworked version of Andrew's patch, which removes the extra, and
> > some of the existing, layering violation.  It works by introducing the
> > concept of a hugepage "subpool" at the lower hugepage mm layer - that is
> > a finite logical pool of hugepages to allocate from.  hugetlbfs now creates
> > a subpool for each filesystem instance with a page limit set, and a pointer
> > to the subpool gets added to each allocated hugepage, instead of the
> > address_space pointer used now.  The subpool has its own lifetime and is
> > only freed once all pages in it _and_ all other references to it (i.e.
> > superblocks) are gone.
> > 
> > subpools are optional - a NULL subpool pointer is taken by the code to mean
> > that no subpool limits are in effect.
> > 
> > Previous discussion of this bug found in:  "Fix refcounting in hugetlbfs
> > quota handling.". See:  https://lkml.org/lkml/2011/8/11/28 or
> > http://marc.info/?l=linux-mm&m=126928970510627&w=1
> > 
> > v2: Fixed a bug spotted by Hillf Danton, and removed the extra parameter to
> > alloc_huge_page() - since it already takes the vma, it is not necessary.
> 
> Looks good - thanks for doing this.
> 
> Some comments, nothing serious:

Cleanup patch addressing these comments below.  I've done this as a
diff applied on top of the original patch.

>From 756a0901a21cce59cc82d0727f6463c3f71eecbf Mon Sep 17 00:00:00 2001
From: David Gibson <david@gibson.dropbear.id.au>
Date: Thu, 8 Mar 2012 13:09:57 +1100
Subject: [PATCH] Cleanups for "hugepages: Fix use after free bug in 'quota'
 handling"

This patch makes some cleanups to an earlier patch of mine fixing a
use after free bug in the hugetlbfs "quota" handling (actually
per-filesystem page limits, not related to normal use of quotas).

These cleanups and extra documentation were mostly suggested by Andrew
Morton.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 fs/hugetlbfs/inode.c    |    3 +-
 include/linux/hugetlb.h |   16 +++++++++--
 mm/hugetlb.c            |   69 +++++++++++++++++++++++++++-------------------
 3 files changed, 54 insertions(+), 34 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 74c6ba2..536672a 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -910,8 +910,7 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_root = root;
 	return 0;
 out_free:
-	if (sbinfo->spool)
-		kfree(sbinfo->spool);
+	kfree(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index cf01817..8fdb595 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -14,13 +14,23 @@ struct user_struct;
 #include <linux/shm.h>
 #include <asm/tlbflush.h>
 
+/*
+ * A hugepage subpool represents a notional finite bucket of
+ * hugepages.  They're used by the hugetlbfs code to implement
+ * per-filesystem-instance limits on hugepage usage.
+ */
 struct hugepage_subpool {
 	spinlock_t lock;
-	long count;
-	long max_hpages, used_hpages;
+	/* Total number of hugepages in the subpool */
+	unsigned long max_hpages;
+	/* Number of currently allocated hugepages in the subpool */
+	unsigned long used_hpages;
+	/* Reference count of anything else keeping the subpool in existence */
+	/* (e.g. hugetlbfs superblocks) */
+	unsigned refcount;
 };
 
-struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
+struct hugepage_subpool *hugepage_new_subpool(unsigned long nr_blocks);
 void hugepage_put_subpool(struct hugepage_subpool *spool);
 
 int PageHuge(struct page *page);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 36b38b3a..aa6316b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -53,19 +53,22 @@ static unsigned long __initdata default_hstate_size;
  */
 static DEFINE_SPINLOCK(hugetlb_lock);
 
-static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
+static inline void unlock_and_release_subpool(struct hugepage_subpool *spool)
 {
-	bool free = (spool->count == 0) && (spool->used_hpages == 0);
+	bool free = (spool->refcount == 0) && (spool->used_hpages == 0);
 
 	spin_unlock(&spool->lock);
 
-	/* If no pages are used, and no other handles to the subpool
-	 * remain, free the subpool the subpool remain */
+	/*
+	 * If there are no pages left still in the subpool, _and_
+	 * there are no other references to it, we can free the
+	 * subpool.
+	 */
 	if (free)
 		kfree(spool);
 }
 
-struct hugepage_subpool *hugepage_new_subpool(long nr_blocks)
+struct hugepage_subpool *hugepage_new_subpool(unsigned long nr_blocks)
 {
 	struct hugepage_subpool *spool;
 
@@ -74,7 +77,7 @@ struct hugepage_subpool *hugepage_new_subpool(long nr_blocks)
 		return NULL;
 
 	spin_lock_init(&spool->lock);
-	spool->count = 1;
+	spool->refcount = 1;
 	spool->max_hpages = nr_blocks;
 	spool->used_hpages = 0;
 
@@ -84,13 +87,17 @@ struct hugepage_subpool *hugepage_new_subpool(long nr_blocks)
 void hugepage_put_subpool(struct hugepage_subpool *spool)
 {
 	spin_lock(&spool->lock);
-	BUG_ON(!spool->count);
-	spool->count--;
-	unlock_or_release_subpool(spool);
+	BUG_ON(!spool->refcount);
+	spool->refcount--;
+	unlock_and_release_subpool(spool);
 }
 
-static int hugepage_subpool_get_pages(struct hugepage_subpool *spool,
-				      long delta)
+/*
+ * Allocate some pages from a subpool, or fail if there aren't enough
+ * pages left
+ */
+static int hugepage_subpool_alloc_pages(struct hugepage_subpool *spool,
+					unsigned long delta)
 {
 	int ret = 0;
 
@@ -98,27 +105,31 @@ static int hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 		return 0;
 
 	spin_lock(&spool->lock);
-	if ((spool->used_hpages + delta) <= spool->max_hpages) {
+	if ((spool->used_hpages + delta) <= spool->max_hpages)
 		spool->used_hpages += delta;
-	} else {
+	else
 		ret = -ENOMEM;
-	}
 	spin_unlock(&spool->lock);
 
 	return ret;
 }
 
-static void hugepage_subpool_put_pages(struct hugepage_subpool *spool,
-				       long delta)
+/*
+ * Release some pages back to a subpool
+ */
+static void hugepage_subpool_release_pages(struct hugepage_subpool *spool,
+					   unsigned long delta)
 {
 	if (!spool)
 		return;
 
 	spin_lock(&spool->lock);
 	spool->used_hpages -= delta;
-	/* If hugetlbfs_put_super couldn't free spool due to
-	* an outstanding quota reference, free it now. */
-	unlock_or_release_subpool(spool);
+	/*
+	 * If hugetlbfs_put_super couldn't free the subpool due to
+	 * pages remaining allocated from it, free it now.
+	 */
+	unlock_and_release_subpool(spool);
 }
 
 static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
@@ -611,9 +622,9 @@ static void free_huge_page(struct page *page)
 	 */
 	struct hstate *h = page_hstate(page);
 	int nid = page_to_nid(page);
-	struct hugepage_subpool *spool =
-		(struct hugepage_subpool *)page_private(page);
+	struct hugepage_subpool *spool;
 
+	spool =	(struct hugepage_subpool *)page_private(page);
 	set_page_private(page, 0);
 	page->mapping = NULL;
 	BUG_ON(page_count(page));
@@ -629,7 +640,7 @@ static void free_huge_page(struct page *page)
 		enqueue_huge_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
-	hugepage_subpool_put_pages(spool, 1);
+	hugepage_subpool_release_pages(spool, 1);
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -1114,7 +1125,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	if (chg < 0)
 		return ERR_PTR(-VM_FAULT_OOM);
 	if (chg)
-		if (hugepage_subpool_get_pages(spool, chg))
+		if (hugepage_subpool_alloc_pages(spool, chg))
 			return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	spin_lock(&hugetlb_lock);
@@ -1124,7 +1135,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
-			hugepage_subpool_put_pages(spool, chg);
+			hugepage_subpool_release_pages(spool, chg);
 			return ERR_PTR(-VM_FAULT_SIGBUS);
 		}
 	}
@@ -2166,7 +2177,7 @@ static void hugetlb_vm_op_close(struct vm_area_struct *vma)
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
-			hugepage_subpool_put_pages(spool, reserve);
+			hugepage_subpool_release_pages(spool, reserve);
 		}
 	}
 }
@@ -2395,7 +2406,7 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
 	 */
 	address = address & huge_page_mask(h);
 	pgoff = vma_hugecache_offset(h, vma, address);
-	mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
+	mapping = vma->vm_file->f_mapping;
 
 	/*
 	 * Take the mapping lock for the duration of the table walk. As
@@ -2981,7 +2992,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 		return chg;
 
 	/* There must be enough pages in the subpool for the mapping */
-	if (hugepage_subpool_get_pages(spool, chg))
+	if (hugepage_subpool_alloc_pages(spool, chg))
 		return -ENOSPC;
 
 	/*
@@ -2990,7 +3001,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 	 */
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
-		hugepage_subpool_put_pages(spool, chg);
+		hugepage_subpool_release_pages(spool, chg);
 		return ret;
 	}
 
@@ -3020,7 +3031,7 @@ void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
 
-	hugepage_subpool_put_pages(spool, (chg - freed));
+	hugepage_subpool_release_pages(spool, (chg - freed));
 	hugetlb_acct_memory(h, -(chg - freed));
 }
 
-- 
1.7.9.1



-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
