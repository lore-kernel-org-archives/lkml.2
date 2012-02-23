Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2BWJ2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:28:24 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:45444 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2BWJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:28:22 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Josh Boyer <jboyer@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hugetlbfs lockdep spew revisited.
In-Reply-To: <20120217002726.GL23916@ZenIV.linux.org.uk>
References: <20120217000856.GA13112@redhat.com> <20120217002726.GL23916@ZenIV.linux.org.uk>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 23 Feb 2012 14:57:41 +0530
Message-ID: <87obspzype.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12022309-2000-0000-0000-000006827166
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Feb 2012 00:27:26 +0000, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, Feb 16, 2012 at 07:08:57PM -0500, Dave Jones wrote:
> > Remember this ? https://lkml.org/lkml/2011/4/15/272
> > Josh took a stab at fixing it in e096d0c7e2e4e5893792db865dd065ac73cf1f00,
> > but it seems to still be there.
> 
> > the existing dependency chain (in reverse order) is:
> 
> [snip]
> 
> ... and as bloody usual, that mentioning of readdir in the output is a
> red herring; the real problem (and yes, it *is* deadlock-prone) is not
> with getdents(2) that cannot happen on anything that could be mmaped;
> it's with hugetlbfs_read() (i.e. read(2)) that very definitely *can*.
> 
> This is *not* a misannotation and not a false positive; this is a real,
> honest deadlock.
> Thread A:
> 	read() on hugetlbfs
> 	hugetlbfs_read() called
> 	i_mutex grabbed
> 	hugetlbfs_read_actor() called
> 	__copy_to_user() called
> 	page fault is triggered
> Thread B, sharing address space with A:
> 	mmap() the same file
> 	->mmap_sem is grabbed on task_B->mm->mmap_sem
> 	hugetlbfs_file_mmap() is called
> 	attempt to grab ->i_mutex and block waiting for A to give it up
> Thread A:
> 	pagefault handled blocked on attempt to grab task_A->mm->mmap_sem,
> which happens to be the same thing as task_B->mm->mmap_sem.  Block waiting
> for B to give it up.
> 
> Deadlock.

How about the below patch ? If this is ok, I can send this as a separate
mail. I am still not sure about dropping inode->i_mutex in mmap as that
will mean we cannot update i_size in mmap and that will break userspace ?

commit 8fb2df40cabd99dc4f39f7fd26ba1d4db885cb5e
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Wed Feb 22 10:18:51 2012 +0530

    hugetlbfs: Add new rw_semaphore for truncate/read race
    
    Drop using inode->i_mutex from read, since that can result in deadlock with
    mmap. Ideally we can extend the patch to make sure we don't increase i_size
    in mmap. But that will break userspace, because application will have to now
    use truncate(2) to increase i_size in hugetlbfs.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 2680578..cd33685 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -238,8 +238,9 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 	unsigned long end_index;
 	loff_t isize;
 	ssize_t retval = 0;
+	struct hugetlbfs_inode_info *hinfo = HUGETLBFS_I(inode);
 
-	mutex_lock(&inode->i_mutex);
+	down_read(&hinfo->truncate_sem);
 
 	/* validate length */
 	if (len == 0)
@@ -309,7 +310,7 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 	}
 out:
 	*ppos = ((loff_t)index << huge_page_shift(h)) + offset;
-	mutex_unlock(&inode->i_mutex);
+	up_read(&hinfo->truncate_sem);
 	return retval;
 }
 
@@ -408,16 +409,19 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	pgoff_t pgoff;
 	struct address_space *mapping = inode->i_mapping;
 	struct hstate *h = hstate_inode(inode);
+	struct hugetlbfs_inode_info *hinfo = HUGETLBFS_I(inode);
 
 	BUG_ON(offset & ~huge_page_mask(h));
 	pgoff = offset >> PAGE_SHIFT;
 
+	down_write(&hinfo->truncate_sem);
 	i_size_write(inode, offset);
 	mutex_lock(&mapping->i_mmap_mutex);
 	if (!prio_tree_empty(&mapping->i_mmap))
 		hugetlb_vmtruncate_list(&mapping->i_mmap, pgoff);
 	mutex_unlock(&mapping->i_mmap_mutex);
 	truncate_hugepages(inode, offset);
+	up_write(&hinfo->truncate_sem);
 	return 0;
 }
 
@@ -695,9 +699,10 @@ static const struct address_space_operations hugetlbfs_aops = {
 
 static void init_once(void *foo)
 {
-	struct hugetlbfs_inode_info *ei = (struct hugetlbfs_inode_info *)foo;
+	struct hugetlbfs_inode_info *hinfo = (struct hugetlbfs_inode_info *)foo;
 
-	inode_init_once(&ei->vfs_inode);
+	init_rwsem(&hinfo->truncate_sem);
+	inode_init_once(&hinfo->vfs_inode);
 }
 
 const struct file_operations hugetlbfs_file_operations = {
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 226f488..57fb788 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -155,6 +155,7 @@ struct hugetlbfs_sb_info {
 
 struct hugetlbfs_inode_info {
 	struct shared_policy policy;
+	struct rw_semaphore truncate_sem;
 	struct inode vfs_inode;
 };
 

