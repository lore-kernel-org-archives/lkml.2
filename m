Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab0ERMCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 08:02:16 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44288 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0ERMA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 08:00:29 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V9 2/9] vfs: Add name to file handle conversion support
Date: Tue, 18 May 2010 17:30:08 +0530
Message-Id: <1274184015-19207-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1274184015-19207-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274184015-19207-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new superblock field unsigned char s_uuid[16]
to store UUID mapping for the file system. The s_uuid[16] is used to
identify the file system apart of file_handle

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/exportfs/expfs.c |    2 +-
 fs/open.c           |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h  |   15 +++++++++
 3 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index cfee0f0..d103c31 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -352,7 +352,7 @@ int exportfs_encode_fh(struct dentry *dentry, struct fid *fid, int *max_len,
 	const struct export_operations *nop = dentry->d_sb->s_export_op;
 	int error;
 
-	if (nop->encode_fh)
+	if (nop && nop->encode_fh)
 		error = nop->encode_fh(dentry, fid->raw, max_len, connectable);
 	else
 		error = export_encode_fh(dentry, fid, max_len, connectable);
diff --git a/fs/open.c b/fs/open.c
index 74e5cd9..51aa494 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,7 @@
 #include <linux/falloc.h>
 #include <linux/fs_struct.h>
 #include <linux/ima.h>
+#include <linux/exportfs.h>
 
 #include "internal.h"
 
@@ -1206,3 +1207,84 @@ int nonseekable_open(struct inode *inode, struct file *filp)
 }
 
 EXPORT_SYMBOL(nonseekable_open);
+
+/* limit the handle size to some value */
+#define MAX_HANDLE_SZ 4096
+static long do_sys_name_to_handle(struct path *path,
+			struct file_handle __user *ufh)
+{
+	int retval;
+	int handle_size;
+	struct super_block *sb;
+	struct file_handle f_handle;
+	struct file_handle *handle = NULL;
+
+	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
+		retval = -EFAULT;
+		goto err_out;
+	}
+	if (f_handle.handle_size > MAX_HANDLE_SZ) {
+		retval = -EINVAL;
+		goto err_out;
+	}
+	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_size,
+			GFP_KERNEL);
+	if (!handle) {
+		retval = -ENOMEM;
+		goto err_out;
+	}
+	handle_size = f_handle.handle_size;
+
+	/* we ask for a non connected handle */
+	retval = exportfs_encode_fh(path->dentry,
+				(struct fid *)handle->f_handle,
+				&handle_size,  0);
+	/* convert handle size to bytes */
+	handle_size *= sizeof(u32);
+	handle->handle_type = retval;
+	handle->handle_size = handle_size;
+	if (handle_size <= f_handle.handle_size) {
+		/* get the uuid */
+		sb = path->mnt->mnt_sb;
+		memcpy(handle->fsid.uuid,
+			sb->s_uuid,
+			sizeof(handle->fsid.uuid));
+		retval = 0;
+	} else {
+		/*
+		 * set the handle_size to zero so we copy only
+		 * non variable part of the file_handle
+		 */
+		handle_size = 0;
+		retval = -EOVERFLOW;
+	}
+	if (copy_to_user(ufh, handle,
+				sizeof(struct file_handle) + handle_size))
+		retval = -EFAULT;
+
+	kfree(handle);
+err_out:
+	return retval;
+}
+
+SYSCALL_DEFINE4(name_to_handle_at, int, dfd, const char __user *, name,
+		struct file_handle __user *, handle, int, flag)
+{
+	int follow;
+	long ret = -EINVAL;
+	struct path path;
+
+	if ((flag & ~AT_SYMLINK_FOLLOW) != 0)
+		goto err_out;
+
+	follow = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
+	ret = user_path_at(dfd, name, follow, &path);
+	if (ret)
+		goto err_out;
+	ret = do_sys_name_to_handle(&path, handle);
+	path_put(&path);
+err_out:
+	/* avoid REGPARM breakage on x86: */
+	asmlinkage_protect(4, ret, dfd, name, handle, flag);
+	return ret;
+}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 44f35ae..961392c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -948,6 +948,20 @@ struct file {
 	unsigned long f_mnt_write_state;
 #endif
 };
+
+struct uuid {
+	unsigned char uuid[16];
+};
+
+struct file_handle {
+	int handle_size;
+	int handle_type;
+	/* File system identifier */
+	struct uuid fsid;
+	/* file identifier */
+	unsigned char f_handle[0];
+};
+
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
 #define file_list_unlock() spin_unlock(&files_lock);
@@ -1358,6 +1372,7 @@ struct super_block {
 	wait_queue_head_t	s_wait_unfrozen;
 
 	char s_id[32];				/* Informational name */
+	unsigned char s_uuid[16];		/* UUID */
 
 	void 			*s_fs_info;	/* Filesystem private info */
 	fmode_t			s_mode;
-- 
1.7.1.78.g212f0

