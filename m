Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1KNF0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:26:49 -0500
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:39886 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab1KNF0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:26:48 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Nov 2011 00:26:48 EST
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [RFC 0/2] locking order of mm->mmap_sem and various FS
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jwboyer@gmail.com,
        wli@holomorphy.com
In-Reply-To: <20111103074855.GA6993@infradead.org>
References: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp> <20111103074855.GA6993@infradead.org>
Date: Mon, 14 Nov 2011 14:18:44 +0900
Message-ID: <12490.1321247924@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig:
> While a few filesystems abuse i_mutex it only has two clear defined
> meanings:
>
>  - protect the namespace topology (only on directories)
>  - protect writes against each other and truncate.
>
> The hugetlb use falls under neither category and should be switched
> to an internal lock.  It seems like that look should in fact be taken
> inside hugetlb_reserve_pages, as that is the only thing that appears
> to need any protection.

Sorry my late reply. I am just busy.
I have no objection about switching another lock.
But we may need to consider about truncate(2) too.

- hugetlbfs_file_mmap() updates i_size (single-direction. eg. grow
  only).
- hugetlbfs_read() refers i_size (only once).
- hugetlbfs_setattr() updates i_size too (both directions are possible).

If we do these (below), then the race betwee mmap(2) and read(2) will be
fixed.
- remove i_mutex from hugetlbfs_file_mmap().
- use i_size_read() and i_size_write() in hugetlbfs_file_mmap().

Since hugetlbfs_read() acquires i_mutex, read/truncate race will not
happen, but the mmap/truncate race may happen by removing i_mutex from
hugetlbfs_file_mmap() (above).
To address this race, I'd also suggest these (below).
- introduce a new mutex in struct hugetlbfs_inode_info.
- acquire it in hugetlbfs_file_mmap().
- protect i_size and truncate_hugepages() in hugetlb_vmtruncate() by the
  new mutex too.

Honestly speaking I am not sure yet whether it is necessary to protect
truncate_hugepages() in hugetlb_vmtruncate().
Would you review this patch?

By the way, who is maintaining hugetlbfs currently?
My previous mails to "William Irwin <wli@holomorphy.com>" were bounced.

J. R. Okajima

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 0be5a78..cc7db2d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -99,12 +99,12 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
 
-	mutex_lock(&inode->i_mutex);
 	file_accessed(file);
 
 	ret = -ENOMEM;
 	len = vma_len + ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 
+	mutex_lock(&HUGETLBFS_I(inode)->mtx);
 	if (hugetlb_reserve_pages(inode,
 				vma->vm_pgoff >> huge_page_order(h),
 				len >> huge_page_shift(h), vma,
@@ -113,10 +113,10 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	ret = 0;
 	hugetlb_prefault_arch_hook(vma->vm_mm);
-	if (vma->vm_flags & VM_WRITE && inode->i_size < len)
-		inode->i_size = len;
+	if (vma->vm_flags & VM_WRITE && i_size_read(inode) < len)
+		i_size_write(inode, len);
 out:
-	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&HUGETLBFS_I(inode)->mtx);
 
 	return ret;
 }
@@ -411,12 +411,12 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
+	mutex_lock(&HUGETLBFS_I(inode)->mtx);
 	i_size_write(inode, offset);
-	mutex_lock(&mapping->i_mmap_mutex);
 	if (!prio_tree_empty(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
-	mutex_unlock(&mapping->i_mmap_mutex);
 	truncate_hugepages(inode, offset);
+	mutex_unlock(&HUGETLBFS_I(inode)->mtx);
 	return 0;
 }
 
@@ -673,6 +673,7 @@ static void hugetlbfs_i_callback(struct rcu_head *head)
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
+	mutex_destroy(&HUGETLBFS_I(inode)->mtx);
 	mpol_free_shared_policy(&HUGETLBFS_I(inode)->policy);
 	call_rcu(&inode->i_rcu, hugetlbfs_i_callback);
 }
@@ -689,6 +690,7 @@ static void init_once(void *foo)
 {
 	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
 
+	mutex_init(&ei->mtx);
 	inode_init_once(&ei->vfs_inode);
 }
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 19644e0..32a336b 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -153,6 +153,7 @@ struct hugetlbfs_sb_info {
 
 
 struct hugetlbfs_inode_info {
+	struct mutex mtx;
 	struct shared_policy policy;
 	struct inode vfs_inode;
 };
