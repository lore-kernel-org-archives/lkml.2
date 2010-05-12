Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab0ELPvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:51:11 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38912 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448Ab0ELPvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:51:09 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 3/9] vfs: Add name to file handle conversion support
Date: Wed, 12 May 2010 21:20:38 +0530
Message-Id: <1273679444-14903-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1.78.g212f0
In-Reply-To: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/open.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 74e5cd9..9a34b81 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,8 @@
 #include <linux/falloc.h>
 #include <linux/fs_struct.h>
 #include <linux/ima.h>
+#include <linux/exportfs.h>
+#include <linux/mnt_namespace.h>
 
 #include "internal.h"
 
@@ -1206,3 +1208,110 @@ int nonseekable_open(struct inode *inode, struct file *filp)
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
+	struct vfsmount *mnt;
+	struct super_block *sb;
+	struct uuid this_fs_id;
+	struct file_handle f_handle;
+	struct file_handle *handle = NULL;
+
+	sb = path->mnt->mnt_sb;
+	if (!sb->s_op->get_fsid) {
+		retval = -EOPNOTSUPP;
+		goto err_out;
+	}
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
+		retval = sb->s_op->get_fsid(sb, &this_fs_id);
+		if (!retval) {
+			/*
+			 * Now verify whether we get the same vfsmount
+			 * if we lookup with uuid. In case we end up having
+			 * same uuid for the multiple file systems. When doing
+			 * uuid based lookup we would return the first one.So
+			 * with name_to_handle if we don't find the same
+			 * vfsmount with lookup return EOPNOTSUPP
+			 */
+			mnt = fs_get_vfsmount(current, &this_fs_id);
+			if (mnt != path->mnt) {
+				retval = -EOPNOTSUPP;
+				mntput(mnt);
+				goto err_free_out;
+			}
+			mntput(mnt);
+			memcpy(handle->fsid.uuid,
+				this_fs_id.uuid,
+				sizeof(handle->fsid.uuid));
+		} else {
+			retval = -EOPNOTSUPP;
+			goto err_free_out;
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
+err_free_out:
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
+	if ((flag & ~AT_SYMLINK_NOFOLLOW) != 0)
+		goto err_out;
+
+	follow = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
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
-- 
1.7.1.78.g212f0

