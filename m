Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab1KCFCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 01:02:19 -0400
Received: from mfb02-md.ns.itscom.net ([175.177.155.110]:57721 "EHLO
	mfb02-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1KCFCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 01:02:18 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: hooanon05@yahoo.co.jp, viro@zeniv.linux.org.uk, hch@infradead.org,
        jwboyer@gmail.com, wli@holomorphy.com
Subject: [RFC 2/2] hugetlbfs: implement f_op->{pre,post}_mmap()
Date: Thu,  3 Nov 2011 13:53:55 +0900
Message-Id: <1320296035-8744-3-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fix the AB-BA deadlock problem between mm->mmap_sem and
inode->i_mutex.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/hugetlbfs/inode.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7aafeb8..f044d54 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -76,6 +76,21 @@ static void huge_pagevec_release(struct pagevec *pvec)
 	pagevec_reinit(pvec);
 }
 
+static int hugetlbfs_file_pre_mmap(struct file *file, unsigned long prot,
+				   unsigned long flag)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	mutex_lock(&inode->i_mutex);
+	return 0;
+}
+
+static void hugetlbfs_file_post_mmap(struct file *file, unsigned long prot,
+				     unsigned long flag)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	mutex_unlock(&inode->i_mutex);
+}
+
 static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -99,7 +114,6 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	vma_len = (loff_t)(vma->vm_end - vma->vm_start);
 
-	mutex_lock(&inode->i_mutex);
 	file_accessed(file);
 
 	ret = -ENOMEM;
@@ -116,8 +130,6 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_flags & VM_WRITE && inode->i_size < len)
 		inode->i_size = len;
 out:
-	mutex_unlock(&inode->i_mutex);
-
 	return ret;
 }
 
@@ -693,7 +705,9 @@ static void init_once(void *foo)
 
 const struct file_operations hugetlbfs_file_operations = {
 	.read			= hugetlbfs_read,
+	.pre_mmap		= hugetlbfs_file_pre_mmap,
 	.mmap			= hugetlbfs_file_mmap,
+	.post_mmap		= hugetlbfs_file_post_mmap,
 	.fsync			= noop_fsync,
 	.get_unmapped_area	= hugetlb_get_unmapped_area,
 	.llseek		= default_llseek,
-- 
1.7.2.5

