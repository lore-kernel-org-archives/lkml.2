Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1A2TI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:08:56 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46735 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1A2TIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:08:38 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V26 02/16] vfs: Add name to file handle conversion support
Date: Sun, 30 Jan 2011 00:38:05 +0530
Message-Id: <1296328099-23263-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The syscall also return mount id which can be used
to lookup file system specific information such as uuid
in /proc/<pid>/mountinfo

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/open.c                |  128 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/exportfs.h |    3 +
 include/linux/fs.h       |    7 +++
 include/linux/syscalls.h |    5 ++-
 kernel/sys_ni.c          |    3 +
 5 files changed, 145 insertions(+), 1 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index e52389e..d12723a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -30,6 +30,7 @@
 #include <linux/fs_struct.h>
 #include <linux/ima.h>
 #include <linux/dnotify.h>
+#include <linux/exportfs.h>
 
 #include "internal.h"
 
@@ -1047,3 +1048,130 @@ int nonseekable_open(struct inode *inode, struct file *filp)
 }
 
 EXPORT_SYMBOL(nonseekable_open);
+
+#ifdef CONFIG_EXPORTFS
+static long do_sys_name_to_handle(struct path *path,
+				  struct file_handle __user *ufh,
+				  int __user *mnt_id)
+{
+	long retval;
+	struct file_handle f_handle;
+	int handle_dwords, handle_bytes;
+	struct file_handle *handle = NULL;
+
+	if (copy_from_user(&f_handle, ufh, sizeof(struct file_handle))) {
+		retval = -EFAULT;
+		goto err_out;
+	}
+	if (f_handle.handle_bytes > MAX_HANDLE_SZ) {
+		retval = -EINVAL;
+		goto err_out;
+	}
+	handle = kmalloc(sizeof(struct file_handle) + f_handle.handle_bytes,
+			 GFP_KERNEL);
+	if (!handle) {
+		retval = -ENOMEM;
+		goto err_out;
+	}
+
+	/* convert handle size to  multiple of sizeof(u32) */
+	handle_dwords = f_handle.handle_bytes >> 2;
+
+	/* we ask for a non connected handle */
+	retval = exportfs_encode_fh(path->dentry,
+				    (struct fid *)handle->f_handle,
+				    &handle_dwords,  0);
+	handle->handle_type = retval;
+	/* convert handle size to bytes */
+	handle_bytes = handle_dwords * sizeof(u32);
+	handle->handle_bytes = handle_bytes;
+	if ((handle->handle_bytes > f_handle.handle_bytes) ||
+	    (retval == 255) || (retval == -ENOSPC)) {
+		/* As per old exportfs_encode_fh documentation
+		 * we could return ENOSPC to indicate overflow
+		 * But file system returned 255 always. So handle
+		 * both the values
+		 */
+		/*
+		 * set the handle size to zero so we copy only
+		 * non variable part of the file_handle
+		 */
+		handle_bytes = 0;
+		retval = -EOVERFLOW;
+	} else
+		retval = 0;
+	/* copy the mount id */
+	if (copy_to_user(mnt_id, &path->mnt->mnt_id, sizeof(*mnt_id))) {
+		retval = -EFAULT;
+		goto err_free_out;
+	}
+	if (copy_to_user(ufh, handle,
+			 sizeof(struct file_handle) + handle_bytes))
+		retval = -EFAULT;
+err_free_out:
+	kfree(handle);
+err_out:
+	return retval;
+}
+
+/**
+ * sys_name_to_handle_at: convert name to handle
+ * @dfd: directory relative to which name is interpreted if not absolute
+ * @name: name that should be converted to handle.
+ * @handle: resulting file handle
+ * @mnt_id: mount id of the file system containing the file
+ * @flag: flag value to indicate whether to follow symlink or not
+ *
+ * @handle->handle_size indicate the space available to store the
+ * variable part of the file handle in bytes. If there is not
+ * enough space, the field is updated to return the minimum
+ * value required.
+ */
+SYSCALL_DEFINE5(name_to_handle_at, int, dfd, const char __user *, name,
+		struct file_handle __user *, handle, int __user*, mnt_id,
+		int, flag)
+{
+
+	int follow;
+	int fput_needed;
+	long ret = -EINVAL;
+	struct path path, *pp;
+	struct file *file = NULL;
+
+	if ((flag & ~AT_SYMLINK_FOLLOW) != 0)
+		goto err_out;
+
+	if (name == NULL && dfd != AT_FDCWD) {
+		file = fget_light(dfd, &fput_needed);
+		if (file) {
+			pp = &file->f_path;
+			ret = 0;
+		} else
+			ret = -EBADF;
+	} else {
+		follow = (flag & AT_SYMLINK_FOLLOW) ? LOOKUP_FOLLOW : 0;
+		ret = user_path_at(dfd, name, follow, &path);
+		pp = &path;
+	}
+	if (ret)
+		goto err_out;
+	/*
+	 * We need t make sure wether the file system
+	 * support decoding of the file handle
+	 */
+	if (!pp->mnt->mnt_sb->s_export_op ||
+	    !pp->mnt->mnt_sb->s_export_op->fh_to_dentry) {
+		ret = -EOPNOTSUPP;
+		goto out_path;
+	}
+	ret = do_sys_name_to_handle(pp, handle, mnt_id);
+
+out_path:
+	if (file)
+		fput_light(file, fput_needed);
+	else
+		path_put(&path);
+err_out:
+	return ret;
+}
+#endif
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index 65afdfd..33a42f2 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -8,6 +8,9 @@ struct inode;
 struct super_block;
 struct vfsmount;
 
+/* limit the handle size to NFSv4 handle size now */
+#define MAX_HANDLE_SZ 128
+
 /*
  * The fileid_type identifies how the file within the filesystem is encoded.
  * In theory this is freely set and parsed by the filesystem, but we try to
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 32b38cd..9fbb0e9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -977,6 +977,13 @@ struct file {
 #endif
 };
 
+struct file_handle {
+	__u32 handle_bytes;
+	int handle_type;
+	/* file identifier */
+	unsigned char f_handle[0];
+};
+
 #define get_file(x)	atomic_long_inc(&(x)->f_count)
 #define fput_atomic(x)	atomic_long_add_unless(&(x)->f_count, -1, 1)
 #define file_count(x)	atomic_long_read(&(x)->f_count)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 18cd068..e1ef441 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -62,6 +62,7 @@ struct robust_list_head;
 struct getcpu_cache;
 struct old_linux_dirent;
 struct perf_event_attr;
+struct file_handle;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -830,5 +831,7 @@ asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
 			unsigned long prot, unsigned long flags,
 			unsigned long fd, unsigned long pgoff);
 asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
-
+asmlinkage long sys_name_to_handle_at(int dfd, const char __user *name,
+				      struct file_handle __user *handle,
+				      int __user *mnt_id, int flag);
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c782fe9..4e01343 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -186,3 +186,6 @@ cond_syscall(sys_perf_event_open);
 /* fanotify! */
 cond_syscall(sys_fanotify_init);
 cond_syscall(sys_fanotify_mark);
+
+/* open by handle */
+cond_syscall(sys_name_to_handle_at);
-- 
1.7.1

