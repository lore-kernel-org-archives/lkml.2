Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1A2TJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:09:23 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:58544 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab1A2TJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:09:20 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V26 12/16] vfs: Add O_PATH open flag
Date: Sun, 30 Jan 2011 00:38:15 +0530
Message-Id: <1296328099-23263-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296328099-23263-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This flag can be used to get a descriptor that is used only
for fetching file attributes. We can get a O_PATH descriptor for even symlink.
A attempt to do any file system operation like read/write/lseek/ioctl will all
fail with EBADF

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/fcntl.c                  |    4 +-
 fs/file_table.c             |   60 +++++++++++++++++++++++++++++++++++++++++++
 fs/namei.c                  |   38 +++++++++++++++++++++++----
 fs/open.c                   |   16 +++++++++--
 include/asm-generic/fcntl.h |    4 +++
 include/linux/file.h        |    2 +
 6 files changed, 113 insertions(+), 11 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index ecc8b39..ba4b564 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -808,14 +808,14 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(18 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(19 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		FMODE_EXEC
+		FMODE_EXEC	| O_PATH
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/fs/file_table.c b/fs/file_table.c
index c3e89ad..67b2668 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -284,11 +284,39 @@ struct file *fget(unsigned int fd)
 	}
 	rcu_read_unlock();
 
+	if (file && (file->f_flags & O_PATH)) {
+		/*
+		 * O_PATH descriptor need to use
+		 * fget_light_lenient() variant
+		 */
+		fput(file);
+		file = NULL;
+	}
 	return file;
 }
 
 EXPORT_SYMBOL(fget);
 
+struct file *fget_lenient(unsigned int fd)
+{
+	struct file *file;
+	struct files_struct *files = current->files;
+
+	rcu_read_lock();
+	file = fcheck_files(files, fd);
+	if (file) {
+		if (!atomic_long_inc_not_zero(&file->f_count)) {
+			/* File object ref couldn't be taken */
+			rcu_read_unlock();
+			return NULL;
+		}
+	}
+	rcu_read_unlock();
+
+	return file;
+}
+EXPORT_SYMBOL(fget_lenient);
+
 /*
  * Lightweight file lookup - no refcnt increment if fd table isn't shared.
  *
@@ -326,6 +354,38 @@ struct file *fget_light(unsigned int fd, int *fput_needed)
 		rcu_read_unlock();
 	}
 
+	if (file && (file->f_flags & O_PATH)) {
+		/*
+		 * O_PATH descriptor need to use
+		 * fget_light_lenient() variant
+		 */
+		if (*fput_needed)
+			fput(file);
+		file = NULL;
+	}
+	return file;
+}
+
+struct file *fget_light_lenient(unsigned int fd, int *fput_needed)
+{
+	struct file *file;
+	struct files_struct *files = current->files;
+
+	*fput_needed = 0;
+	if (atomic_read(&files->count) == 1) {
+		file = fcheck_files(files, fd);
+	} else {
+		rcu_read_lock();
+		file = fcheck_files(files, fd);
+		if (file) {
+			if (atomic_long_inc_not_zero(&file->f_count))
+				*fput_needed = 1;
+			else
+				/* Didn't get the reference, someone's freed */
+				file = NULL;
+		}
+		rcu_read_unlock();
+	}
 	return file;
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index a8346fa..b9a500c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2115,6 +2115,9 @@ int may_open(struct path *path, int acc_mode, int flag)
 	if (!inode)
 		return -ENOENT;
 
+	if (!(acc_mode & MAY_OPEN))
+		return 0;
+
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFLNK:
 		return -ELOOP;
@@ -2404,8 +2407,10 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	if (!path->dentry->d_inode)
 		goto exit_dput;
 
-	if (path->dentry->d_inode->i_op->follow_link)
-		return NULL;
+	/* We allow open on symlinks with O_PATH flag */
+	if ((open_flag & (O_PATH | O_NOFOLLOW)) != (O_PATH | O_NOFOLLOW))
+		if (path->dentry->d_inode->i_op->follow_link)
+			return NULL;
 
 	path_to_nameidata(path, nd);
 	nd->inode = path->dentry->d_inode;
@@ -2444,6 +2449,14 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	int flag = open_to_namei_flags(open_flag);
 	int flags;
 
+	/*
+	 * If we have O_PATH in the open flag. Then we
+	 * cannot have anything other than the below set of flags
+	 */
+	if ((open_flag & O_PATH) &&
+	    (open_flag & ~(O_DIRECTORY|O_NOFOLLOW|O_PATH)))
+		return ERR_PTR(-EINVAL);
+
 	if (!(open_flag & O_CREAT))
 		mode = 0;
 
@@ -2459,7 +2472,7 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	if (open_flag & __O_SYNC)
 		open_flag |= O_DSYNC;
 
-	if (!acc_mode)
+	if (!acc_mode && !(open_flag & O_PATH))
 		acc_mode = MAY_OPEN | ACC_MODE(open_flag);
 
 	/* O_TRUNC implies we need access checks for write permissions */
@@ -2499,7 +2512,10 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	if (unlikely(error))
 		goto out_filp;
 	error = -ELOOP;
-	if (!(nd.flags & LOOKUP_FOLLOW)) {
+	/*
+	 * With allow open on symlinks with O_PATH flag.
+	 */
+	if (!(nd.flags & LOOKUP_FOLLOW) && !(open_flag & O_PATH)) {
 		if (nd.inode->i_op->follow_link)
 			goto out_path;
 	}
@@ -2708,10 +2724,19 @@ long do_handle_open(int mountdirfd,
 		    struct file_handle __user *ufh, int open_flag)
 {
 	long retval = 0;
-	int fd, acc_mode;
+	int fd, acc_mode = 0;
 	struct path path;
 	struct file *filp;
 
+	/*
+	 * If we have O_PATH in the open flag. Then we
+	 * cannot have anything other than the below set of flags
+	 */
+	if ((open_flag & O_PATH) &&
+	    (open_flag & ~(O_DIRECTORY|O_PATH))) {
+		retval = -EINVAL;
+		goto out_err;
+	}
 	/* can't use O_CREATE with open_by_handle */
 	if (open_flag & O_CREAT) {
 		retval = -EINVAL;
@@ -2739,7 +2764,8 @@ long do_handle_open(int mountdirfd,
 	if (open_flag & __O_SYNC)
 		open_flag |= O_DSYNC;
 
-	acc_mode = MAY_OPEN | ACC_MODE(open_flag);
+	if (!(open_flag & O_PATH))
+		acc_mode = MAY_OPEN | ACC_MODE(open_flag);
 
 	/* O_TRUNC implies we need access checks for write permissions */
 	if (open_flag & O_TRUNC)
diff --git a/fs/open.c b/fs/open.c
index 1ec2623..7dbde0f 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -657,6 +657,9 @@ static inline int __get_file_write_access(struct inode *inode,
 	return error;
 }
 
+/* empty file_operations to be used for O_PATH descriptor */
+static const struct file_operations o_path_file_operations = {};
+
 struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 			   struct file *f,
 			   int (*open)(struct inode *, struct file *),
@@ -665,8 +668,9 @@ struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	struct inode *inode;
 	int error;
 
-	f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
-				FMODE_PREAD | FMODE_PWRITE;
+	if (!(f->f_flags & O_PATH))
+		f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
+			    FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
 		error = __get_file_write_access(inode, mnt);
@@ -680,8 +684,14 @@ struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	f->f_path.dentry = dentry;
 	f->f_path.mnt = mnt;
 	f->f_pos = 0;
-	f->f_op = fops_get(inode->i_fop);
 	file_sb_list_add(f, inode->i_sb);
+	/* For O_PATH open we just return without opening the file */
+	if (f->f_flags & O_PATH) {
+		f->f_op = &o_path_file_operations;
+		return f;
+	}
+	f->f_op = fops_get(inode->i_fop);
+
 
 	error = security_dentry_open(f, cred);
 	if (error)
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 0fc16e3..84793c7 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -80,6 +80,10 @@
 #define O_SYNC		(__O_SYNC|O_DSYNC)
 #endif
 
+#ifndef O_PATH
+#define O_PATH		010000000
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
diff --git a/include/linux/file.h b/include/linux/file.h
index e85baeb..e21b733 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -29,6 +29,8 @@ static inline void fput_light(struct file *file, int fput_needed)
 
 extern struct file *fget(unsigned int fd);
 extern struct file *fget_light(unsigned int fd, int *fput_needed);
+extern struct file *fget_lenient(unsigned int fd);
+extern struct file *fget_light_lenient(unsigned int fd, int *fput_needed);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern void put_filp(struct file *);
 extern int alloc_fd(unsigned start, unsigned flags);
-- 
1.7.1

