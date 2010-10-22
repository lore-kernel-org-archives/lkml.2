Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959Ab0JVS1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:27:48 -0400
Received: from kroah.org ([198.145.64.141]:37832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758970Ab0JVSZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:39 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/31] sysfs: Fail bin file mmap if vma close is implemented.
Date: Fri, 22 Oct 2010 11:25:05 -0700
Message-Id: <1287771916-15016-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@aristanetworks.com>

It is not reasonably possible to wrap vma->close().  To correctly
wrap close would imply calling close on any vmas that remain when
sysfs_remove_bin_file is called.  Finding the proper lists walking
them getting the locking right etc, requires deep knowledge of the
mm subsystem and as such would require assistence from the mm
subsystem to implement.  That assistence does not currently exist.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c |   26 ++++++++------------------
 1 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 4e321f7..d31d7b7 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -190,23 +190,6 @@ static void bin_vma_open(struct vm_area_struct *vma)
 	sysfs_put_active(attr_sd);
 }
 
-static void bin_vma_close(struct vm_area_struct *vma)
-{
-	struct file *file = vma->vm_file;
-	struct bin_buffer *bb = file->private_data;
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-
-	if (!bb->vm_ops || !bb->vm_ops->close)
-		return;
-
-	if (!sysfs_get_active(attr_sd))
-		return;
-
-	bb->vm_ops->close(vma);
-
-	sysfs_put_active(attr_sd);
-}
-
 static int bin_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
@@ -331,7 +314,6 @@ static int bin_migrate(struct vm_area_struct *vma, const nodemask_t *from,
 
 static const struct vm_operations_struct bin_vm_ops = {
 	.open		= bin_vma_open,
-	.close		= bin_vma_close,
 	.fault		= bin_fault,
 	.page_mkwrite	= bin_page_mkwrite,
 	.access		= bin_access,
@@ -377,6 +359,14 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	if (bb->mmapped && bb->vm_ops != vma->vm_ops)
 		goto out_put;
 
+	/*
+	 * It is not possible to successfully wrap close.
+	 * So error if someone is trying to use close.
+	 */
+	rc = -EINVAL;
+	if (vma->vm_ops && vma->vm_ops->close)
+		goto out_put;
+
 	rc = 0;
 	bb->mmapped = 1;
 	bb->vm_ops = vma->vm_ops;
-- 
1.7.2

