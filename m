Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab1HKGlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 02:41:07 -0400
Received: from ozlabs.org ([203.10.76.45]:60490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1HKGlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 02:41:04 -0400
Date: Thu, 11 Aug 2011 16:40:59 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@web.de>, qemu-devel@nongnu.org, agraf@suse.de,
        kvm <kvm@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        linux-kernel@vger.kernel.org
Subject: Fix refcounting in hugetlbfs quota handling
Message-ID: <20110811064059.GU6342@yookeroo.fritz.box>
Mail-Followup-To: Linus Torvalds <torvalds@osdl.org>,
	Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
	Jan Kiszka <jan.kiszka@web.de>, qemu-devel@nongnu.org,
	agraf@suse.de, kvm <kvm@vger.kernel.org>,
	Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please apply

hugetlbfs tracks the current usage of hugepages per hugetlbfs
mountpoint.  To correctly track this when hugepages are released, it
must find the right hugetlbfs super_block from the struct page
available in free_huge_page().

It does this by storing a pointer to the hugepage's struct
address_space in the page_private data.  The hugetlb_{get,put}_quota
functions go from this mapping to the inode and thence to the
super_block.

However, this usage is buggy, because nothing ensures that the
address_space is not freed before all the hugepages that belonged to
it are.  In practice that will usually be the case, but if extra page
references have been taken by e.g. drivers or kvm doing
get_user_pages() then the file, inode and address space may be
destroyed before all the pages.

In addition, the quota functions use the mapping only to get the inode
then the super_block.  However, most of the callers already have the
inode anyway and have to get the mapping from there.

This patch, therefore, stores a pointer to the inode instead of the
address_space in the page private data for hugepages.  More
importantly it correctly adjusts the reference count on the inodes
when they're added to the page private data.  This ensures that the
inode (and therefore the super block) will not be freed before we use
it from free_huge_page.

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Index: working-2.6/fs/hugetlbfs/inode.c
===================================================================
--- working-2.6.orig/fs/hugetlbfs/inode.c	2011-08-10 16:45:47.864758406 +1000
+++ working-2.6/fs/hugetlbfs/inode.c	2011-08-10 17:22:21.899638039 +1000
@@ -874,10 +874,10 @@ out_free:
 	return -ENOMEM;
 }
 
-int hugetlb_get_quota(struct address_space *mapping, long delta)
+int hugetlb_get_quota(struct inode *inode, long delta)
 {
 	int ret = 0;
-	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
+	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(inode->i_sb);
 
 	if (sbinfo->free_blocks > -1) {
 		spin_lock(&sbinfo->stat_lock);
@@ -891,9 +891,9 @@ int hugetlb_get_quota(struct address_spa
 	return ret;
 }
 
-void hugetlb_put_quota(struct address_space *mapping, long delta)
+void hugetlb_put_quota(struct inode *inode, long delta)
 {
-	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
+	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(inode->i_sb);
 
 	if (sbinfo->free_blocks > -1) {
 		spin_lock(&sbinfo->stat_lock);
Index: working-2.6/include/linux/hugetlb.h
===================================================================
--- working-2.6.orig/include/linux/hugetlb.h	2011-08-10 16:58:27.952527484 +1000
+++ working-2.6/include/linux/hugetlb.h	2011-08-10 17:22:08.723572707 +1000
@@ -171,8 +171,8 @@ extern const struct file_operations huge
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags);
-int hugetlb_get_quota(struct address_space *mapping, long delta);
-void hugetlb_put_quota(struct address_space *mapping, long delta);
+int hugetlb_get_quota(struct inode *inode, long delta);
+void hugetlb_put_quota(struct inode *inode, long delta);
 
 static inline int is_file_hugepages(struct file *file)
 {
Index: working-2.6/mm/hugetlb.c
===================================================================
--- working-2.6.orig/mm/hugetlb.c	2011-08-10 16:44:12.212284092 +1000
+++ working-2.6/mm/hugetlb.c	2011-08-10 17:21:49.603477888 +1000
@@ -533,10 +533,12 @@ static void free_huge_page(struct page *
 	 */
 	struct hstate *h = page_hstate(page);
 	int nid = page_to_nid(page);
-	struct address_space *mapping;
+	struct inode *inode;
 
-	mapping = (struct address_space *) page_private(page);
+	inode = (struct inode *) page_private(page);
 	set_page_private(page, 0);
+	iput(inode);
+
 	page->mapping = NULL;
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
@@ -551,8 +553,8 @@ static void free_huge_page(struct page *
 		enqueue_huge_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
-	if (mapping)
-		hugetlb_put_quota(mapping, 1);
+	if (inode)
+		hugetlb_put_quota(inode, 1);
 }
 
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -1035,7 +1037,7 @@ static struct page *alloc_huge_page(stru
 	if (chg < 0)
 		return ERR_PTR(-VM_FAULT_OOM);
 	if (chg)
-		if (hugetlb_get_quota(inode->i_mapping, chg))
+		if (hugetlb_get_quota(inode, chg))
 			return ERR_PTR(-VM_FAULT_SIGBUS);
 
 	spin_lock(&hugetlb_lock);
@@ -1045,12 +1047,12 @@ static struct page *alloc_huge_page(stru
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
-			hugetlb_put_quota(inode->i_mapping, chg);
+			hugetlb_put_quota(inode, chg);
 			return ERR_PTR(-VM_FAULT_SIGBUS);
 		}
 	}
 
-	set_page_private(page, (unsigned long) mapping);
+	set_page_private(page, (unsigned long) igrab(inode));
 
 	vma_commit_reservation(h, vma, addr);
 
@@ -2086,7 +2088,8 @@ static void hugetlb_vm_op_close(struct v
 
 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
-			hugetlb_put_quota(vma->vm_file->f_mapping, reserve);
+			hugetlb_put_quota(vma->vm_file->f_mapping->host,
+					  reserve);
 		}
 	}
 }
@@ -2884,7 +2887,7 @@ int hugetlb_reserve_pages(struct inode *
 		return chg;
 
 	/* There must be enough filesystem quota for the mapping */
-	if (hugetlb_get_quota(inode->i_mapping, chg))
+	if (hugetlb_get_quota(inode, chg))
 		return -ENOSPC;
 
 	/*
@@ -2893,7 +2896,7 @@ int hugetlb_reserve_pages(struct inode *
 	 */
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
-		hugetlb_put_quota(inode->i_mapping, chg);
+		hugetlb_put_quota(inode, chg);
 		return ret;
 	}
 
@@ -2922,7 +2925,7 @@ void hugetlb_unreserve_pages(struct inod
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
 
-	hugetlb_put_quota(inode->i_mapping, (chg - freed));
+	hugetlb_put_quota(inode, (chg - freed));
 	hugetlb_acct_memory(h, -(chg - freed));
 }
 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
