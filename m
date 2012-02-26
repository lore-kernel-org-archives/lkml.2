Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2BZSUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 13:20:31 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59690 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2BZSUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 13:20:30 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        hughd@google.com
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] hugetlbfs: Add new rw_semaphore to fix truncate/read race
Date: Sun, 26 Feb 2012 23:49:58 +0530
Message-Id: <1330280398-27956-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9
x-cbid: 12022618-5816-0000-0000-0000017487F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Drop using inode->i_mutex from read, since that can result in deadlock with
mmap. Ideally we can extend the patch to make sure we don't increase i_size
in mmap. But that will break userspace, because application will have to now
use truncate(2) to increase i_size in hugetlbfs.

AFAIU i_mutex was added in hugetlbfs_read as per
http://lkml.indiana.edu/hypermail/linux/kernel/0707.2/3066.html

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/hugetlbfs/inode.c    |   13 +++++++++----
 include/linux/hugetlb.h |    1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1e85a7a..3d541dd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -237,8 +237,9 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 	unsigned long end_index;
 	loff_t isize;
 	ssize_t retval = 0;
+	struct hugetlbfs_inode_info *hinfo = HUGETLBFS_I(inode);
 
-	mutex_lock(&inode->i_mutex);
+	down_read(&hinfo->truncate_sem);
 
 	/* validate length */
 	if (len == 0)
@@ -308,7 +309,7 @@ static ssize_t hugetlbfs_read(struct file *filp, char __user *buf,
 	}
 out:
 	*ppos = ((loff_t)index << huge_page_shift(h)) + offset;
-	mutex_unlock(&inode->i_mutex);
+	up_read(&hinfo->truncate_sem);
 	return retval;
 }
 
@@ -407,16 +408,19 @@ static int hugetlb_vmtruncate(struct inode *inode, loff_t offset)
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
 
@@ -694,9 +698,10 @@ static const struct address_space_operations hugetlbfs_aops = {
 
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
index 8aef867..6d8469a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -150,6 +150,7 @@ struct hugetlbfs_sb_info {
 
 struct hugetlbfs_inode_info {
 	struct shared_policy policy;
+	struct rw_semaphore truncate_sem;
 	struct inode vfs_inode;
 };
 
-- 
1.7.9

