Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051Ab0JVSZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:51 -0400
Received: from kroah.org ([198.145.64.141]:37833 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758975Ab0JVSZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 21/31] sysfs: only access bin file vm_ops with the active lock
Date: Fri, 22 Oct 2010 11:25:06 -0700
Message-Id: <1287771916-15016-21-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

bb->vm_ops is a cached copy of the vm_ops of the underlying
sysfs bin file, which means that after sysfs_bin_remove_file
completes it is only longer valid to deference bb->vm_ops.

So move all of the tests of bb->vm_ops inside of where
we hold the sysfs active lock.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |   42 ++++++++++++++++++++++++++----------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index d31d7b7..a475983 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -179,13 +179,14 @@ static void bin_vma_open(struct vm_area_struct *vma)
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 
-	if (!bb->vm_ops || !bb->vm_ops->open)
+	if (!bb->vm_ops)
 		return;
 
 	if (!sysfs_get_active(attr_sd))
 		return;
 
-	bb->vm_ops->open(vma);
+	if (bb->vm_ops->open)
+		bb->vm_ops->open(vma);
 
 	sysfs_put_active(attr_sd);
 }
@@ -197,13 +198,15 @@ static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->fault)
+	if (!bb->vm_ops)
 		return VM_FAULT_SIGBUS;
 
 	if (!sysfs_get_active(attr_sd))
 		return VM_FAULT_SIGBUS;
 
-	ret = bb->vm_ops->fault(vma, vmf);
+	ret = VM_FAULT_SIGBUS;
+	if (bb->vm_ops->fault)
+		ret = bb->vm_ops->fault(vma, vmf);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -219,13 +222,12 @@ static int bin_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (!bb->vm_ops)
 		return VM_FAULT_SIGBUS;
 
-	if (!bb->vm_ops->page_mkwrite)
-		return 0;
-
 	if (!sysfs_get_active(attr_sd))
 		return VM_FAULT_SIGBUS;
 
-	ret = bb->vm_ops->page_mkwrite(vma, vmf);
+	ret = 0;
+	if (bb->vm_ops->page_mkwrite)
+		ret = bb->vm_ops->page_mkwrite(vma, vmf);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -239,13 +241,15 @@ static int bin_access(struct vm_area_struct *vma, unsigned long addr,
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->access)
+	if (!bb->vm_ops)
 		return -EINVAL;
 
 	if (!sysfs_get_active(attr_sd))
 		return -EINVAL;
 
-	ret = bb->vm_ops->access(vma, addr, buf, len, write);
+	ret = -EINVAL;
+	if (bb->vm_ops->access)
+		ret = bb->vm_ops->access(vma, addr, buf, len, write);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -259,13 +263,15 @@ static int bin_set_policy(struct vm_area_struct *vma, struct mempolicy *new)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->set_policy)
+	if (!bb->vm_ops)
 		return 0;
 
 	if (!sysfs_get_active(attr_sd))
 		return -EINVAL;
 
-	ret = bb->vm_ops->set_policy(vma, new);
+	ret = 0;
+	if (bb->vm_ops->set_policy)
+		ret = bb->vm_ops->set_policy(vma, new);
 
 	sysfs_put_active(attr_sd);
 	return ret;
@@ -279,13 +285,15 @@ static struct mempolicy *bin_get_policy(struct vm_area_struct *vma,
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct mempolicy *pol;
 
-	if (!bb->vm_ops || !bb->vm_ops->get_policy)
+	if (!bb->vm_ops)
 		return vma->vm_policy;
 
 	if (!sysfs_get_active(attr_sd))
 		return vma->vm_policy;
 
-	pol = bb->vm_ops->get_policy(vma, addr);
+	pol = vma->vm_policy;
+	if (bb->vm_ops->get_policy)
+		pol = bb->vm_ops->get_policy(vma, addr);
 
 	sysfs_put_active(attr_sd);
 	return pol;
@@ -299,13 +307,15 @@ static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	int ret;
 
-	if (!bb->vm_ops || !bb->vm_ops->migrate)
+	if (!bb->vm_ops)
 		return 0;
 
 	if (!sysfs_get_active(attr_sd))
 		return 0;
 
-	ret = bb->vm_ops->migrate(vma, from, to, flags);
+	ret = 0;
+	if (bb->vm_ops->migrate)
+		ret = bb->vm_ops->migrate(vma, from, to, flags);
 
 	sysfs_put_active(attr_sd);
 	return ret;
-- 
1.7.2

