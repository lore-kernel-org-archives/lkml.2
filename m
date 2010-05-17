Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0EQFgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 01:36:06 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:45025 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0EQFeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 01:34:06 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V8 2/9] vfs: Add name to file handle conversion support
Date: Mon, 17 May 2010 11:03:45 +0530
Message-Id: <1274074432-29695-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1274074432-29695-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new superblock operations get_fsid that returns the
UUID mapping for the file system. The UUID returned is used to
identify the file system apart of file_handle


Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/open.c          |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   15 +++++++++
 2 files changed, 101 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 74e5cd9..f63550b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,7 @@
 #include <linux/falloc.h>
 #include <linux/fs_struct.h>
 #include <linux/ima.h>
+#include <linux/exportfs.h>
 
 #include "internal.h"
 
@@ -1206,3 +1207,88 @@ int nonseekable_open(struct inode *inode, struct file *filp)
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
+	struct uuid this_fs_id;
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
+	handle = kzalloc(sizeof(struct file_handle) + f_handle.handle_size,
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
+		if (sb->s_op->get_fsid) {
+			retval = sb->s_op->get_fsid(sb, &this_fs_id);
+			if (!retval)
+				memcpy(handle->fsid.uuid,
+					this_fs_id.uuid,
+					sizeof(handle->fsid.uuid));
+		}
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
index 44f35ae..055734c 100644
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
@@ -1580,6 +1594,7 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	int (*get_fsid)(struct super_block *, struct uuid *);
 };
 
 /*
-- 
1.7.1.78.g212f0

