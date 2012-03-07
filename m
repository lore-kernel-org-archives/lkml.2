Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab2CGVZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:25:37 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65496 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab2CGVX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:23:29 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 19/25] vfs: remove nameidata argument from vfs_create
Date: Wed,  7 Mar 2012 22:22:36 +0100
Message-Id: <1331155362-11132-20-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

All callers of vfs_create() pass a NULL nameidata.  So this argument can be
removed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cachefiles/namei.c |    2 +-
 fs/ecryptfs/inode.c   |    2 +-
 fs/namei.c            |    5 ++---
 fs/nfsd/vfs.c         |    4 ++--
 include/linux/fs.h    |    2 +-
 ipc/mqueue.c          |    2 +-
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index a0358c2..faa933f 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -567,7 +567,7 @@ lookup_again:
 			if (ret < 0)
 				goto create_error;
 			start = jiffies;
-			ret = vfs_create(dir->d_inode, next, S_IFREG, NULL);
+			ret = vfs_create(dir->d_inode, next, S_IFREG);
 			cachefiles_hist(cachefiles_create_histogram, start);
 			if (ret < 0)
 				goto create_error;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index ab35b11..b6d0d69 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -173,7 +173,7 @@ ecryptfs_do_create(struct inode *directory_inode,
 		inode = ERR_CAST(lower_dir_dentry);
 		goto out;
 	}
-	rc = vfs_create(lower_dir_dentry->d_inode, lower_dentry, mode, NULL);
+	rc = vfs_create(lower_dir_dentry->d_inode, lower_dentry, mode);
 	if (rc) {
 		printk(KERN_ERR "%s: Failure to create dentry in lower fs; "
 		       "rc = [%d]\n", __func__, rc);
diff --git a/fs/namei.c b/fs/namei.c
index b991aa0..fadc95c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2101,8 +2101,7 @@ out_err:
 	return ERR_PTR(error);
 }
 
-int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
-	       struct nameidata *nd)
+int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct file *res;
 	unsigned open_flag = O_RDONLY|O_CREAT|O_EXCL;
@@ -2856,7 +2855,7 @@ SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 		goto out_drop_write;
 	switch (mode & S_IFMT) {
 		case 0: case S_IFREG:
-			error = vfs_create(path.dentry->d_inode,dentry,mode,NULL);
+			error = vfs_create(path.dentry->d_inode, dentry, mode);
 			break;
 		case S_IFCHR: case S_IFBLK:
 			error = vfs_mknod(path.dentry->d_inode,dentry,mode,
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index edf6d3e..26470ad 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1321,7 +1321,7 @@ nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	err = 0;
 	switch (type) {
 	case S_IFREG:
-		host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+		host_err = vfs_create(dirp, dchild, iap->ia_mode);
 		if (!host_err)
 			nfsd_check_ignore_resizing(iap);
 		break;
@@ -1484,7 +1484,7 @@ do_nfsd_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		goto out;
 	}
 
-	host_err = vfs_create(dirp, dchild, iap->ia_mode, NULL);
+	host_err = vfs_create(dirp, dchild, iap->ia_mode);
 	if (host_err < 0) {
 		fh_drop_write(fhp);
 		goto out_nfserr;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index af291bb..23268f4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1534,7 +1534,7 @@ extern void unlock_super(struct super_block *);
 /*
  * VFS helper functions..
  */
-extern int vfs_create(struct inode *, struct dentry *, umode_t, struct nameidata *);
+extern int vfs_create(struct inode *, struct dentry *, umode_t);
 extern int vfs_mkdir(struct inode *, struct dentry *, umode_t);
 extern int vfs_mknod(struct inode *, struct dentry *, umode_t, dev_t);
 extern int vfs_symlink(struct inode *, struct dentry *, const char *);
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 86ee272..b31b495 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -634,7 +634,7 @@ static struct file *do_create(struct ipc_namespace *ipc_ns, struct dentry *dir,
 	ret = mnt_want_write(ipc_ns->mq_mnt);
 	if (ret)
 		goto out;
-	ret = vfs_create(dir->d_inode, dentry, mode, NULL);
+	ret = vfs_create(dir->d_inode, dentry, mode);
 	dentry->d_fsdata = NULL;
 	if (ret)
 		goto out_drop_write;
-- 
1.7.7

