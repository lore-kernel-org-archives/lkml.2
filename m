Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab1JNLGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:06:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44325 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab1JNLF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:05:29 -0400
Message-Id: <20111014110511.292400983@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 Oct 2011 15:04:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Vagin <avagin@parallels.com>, Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/5] fs: Add do_close helper
References: <20111014110416.552685686@openvz.org>
Content-Disposition: inline; filename=fs-add-do-close
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to close file descriptors right from inside
kernel space do_close() helper is added.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 fs/open.c          |   32 ++++++++++++++++++++------------
 include/linux/fs.h |    1 +
 2 files changed, 21 insertions(+), 12 deletions(-)

Index: linux-2.6.git/fs/open.c
===================================================================
--- linux-2.6.git.orig/fs/open.c
+++ linux-2.6.git/fs/open.c
@@ -1056,17 +1056,11 @@ int filp_close(struct file *filp, fl_own
 
 EXPORT_SYMBOL(filp_close);
 
-/*
- * Careful here! We test whether the file pointer is NULL before
- * releasing the fd. This ensures that one clone task can't release
- * an fd while another clone is opening it.
- */
-SYSCALL_DEFINE1(close, unsigned int, fd)
+int do_close(unsigned int fd)
 {
 	struct file * filp;
 	struct files_struct *files = current->files;
 	struct fdtable *fdt;
-	int retval;
 
 	spin_lock(&files->file_lock);
 	fdt = files_fdtable(files);
@@ -1079,7 +1073,25 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
 	FD_CLR(fd, fdt->close_on_exec);
 	__put_unused_fd(files, fd);
 	spin_unlock(&files->file_lock);
-	retval = filp_close(filp, files);
+
+	return filp_close(filp, files);
+
+out_unlock:
+	spin_unlock(&files->file_lock);
+	return -EBADF;
+}
+EXPORT_SYMBOL_GPL(do_close);
+
+/*
+ * Careful here! We test whether the file pointer is NULL before
+ * releasing the fd. This ensures that one clone task can't release
+ * an fd while another clone is opening it.
+ */
+SYSCALL_DEFINE1(close, unsigned int, fd)
+{
+	int retval;
+
+	retval = do_close(fd);
 
 	/* can't restart close syscall because file table entry was cleared */
 	if (unlikely(retval == -ERESTARTSYS ||
@@ -1089,10 +1101,6 @@ SYSCALL_DEFINE1(close, unsigned int, fd)
 		retval = -EINTR;
 
 	return retval;
-
-out_unlock:
-	spin_unlock(&files->file_lock);
-	return -EBADF;
 }
 EXPORT_SYMBOL(sys_close);
 
Index: linux-2.6.git/include/linux/fs.h
===================================================================
--- linux-2.6.git.orig/include/linux/fs.h
+++ linux-2.6.git/include/linux/fs.h
@@ -2025,6 +2025,7 @@ extern struct file *file_open_root(struc
 extern struct file * dentry_open(struct dentry *, struct vfsmount *, int,
 				 const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
+extern int do_close(unsigned int fd);
 extern char * getname(const char __user *);
 
 /* fs/ioctl.c */

