Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab1LUSdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:33:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50389 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1LUSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:30:43 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, mszeredi@suse.cz
Subject: [PATCH 1/9] vfs: pass struct path to __dentry_open()
Date: Wed, 21 Dec 2011 19:29:40 +0100
Message-Id: <1324492188-3481-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
References: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Make __dentry_open() take a struct path instead of separate vfsmount and dentry
arguments.

Change semantics as well, so that __dentry_open() acquires a reference to path
instead of transferring it to the open file.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/open.c |   48 ++++++++++++++++++++++--------------------------
 1 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 77becc0..ceab906 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -644,24 +644,24 @@ static inline int __get_file_write_access(struct inode *inode,
 	return error;
 }
 
-static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
-					struct file *f,
-					int (*open)(struct inode *, struct file *),
-					const struct cred *cred)
+static struct file *__dentry_open(struct path *path, struct file *f,
+				  int (*open)(struct inode *, struct file *),
+				  const struct cred *cred)
 {
 	static const struct file_operations empty_fops = {};
 	struct inode *inode;
 	int error;
 
+	path_get(path);
 	f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
 				FMODE_PREAD | FMODE_PWRITE;
 
 	if (unlikely(f->f_flags & O_PATH))
 		f->f_mode = FMODE_PATH;
 
-	inode = dentry->d_inode;
+	inode = path->dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = __get_file_write_access(inode, mnt);
+		error = __get_file_write_access(inode, path->mnt);
 		if (error)
 			goto cleanup_file;
 		if (!special_file(inode->i_mode))
@@ -669,8 +669,7 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	}
 
 	f->f_mapping = inode->i_mapping;
-	f->f_path.dentry = dentry;
-	f->f_path.mnt = mnt;
+	f->f_path = *path;
 	f->f_pos = 0;
 	file_sb_list_add(f, inode->i_sb);
 
@@ -727,7 +726,7 @@ cleanup_all:
 			 * here, so just reset the state.
 			 */
 			file_reset_write(f);
-			mnt_drop_write(mnt);
+			mnt_drop_write(path->mnt);
 		}
 	}
 	file_sb_list_del(f);
@@ -735,8 +734,7 @@ cleanup_all:
 	f->f_path.mnt = NULL;
 cleanup_file:
 	put_filp(f);
-	dput(dentry);
-	mntput(mnt);
+	path_put(path);
 	return ERR_PTR(error);
 }
 
@@ -762,14 +760,14 @@ cleanup_file:
 struct file *lookup_instantiate_filp(struct nameidata *nd, struct dentry *dentry,
 		int (*open)(struct inode *, struct file *))
 {
+	struct path path = { .dentry = dentry, .mnt = nd->path.mnt };
 	const struct cred *cred = current_cred();
 
 	if (IS_ERR(nd->intent.open.file))
 		goto out;
 	if (IS_ERR(dentry))
 		goto out_err;
-	nd->intent.open.file = __dentry_open(dget(dentry), mntget(nd->path.mnt),
-					     nd->intent.open.file,
+	nd->intent.open.file = __dentry_open(&path, nd->intent.open.file,
 					     open, cred);
 out:
 	return nd->intent.open.file;
@@ -797,11 +795,9 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 	nd->intent.open.file = NULL;
 
 	/* Has the filesystem initialised the file for us? */
-	if (filp->f_path.dentry == NULL) {
-		path_get(&nd->path);
-		filp = __dentry_open(nd->path.dentry, nd->path.mnt, filp,
-				     NULL, cred);
-	}
+	if (filp->f_path.dentry == NULL)
+		filp = __dentry_open(&nd->path, filp, NULL, cred);
+
 	return filp;
 }
 
@@ -812,24 +808,24 @@ struct file *nameidata_to_filp(struct nameidata *nd)
 struct file *dentry_open(struct dentry *dentry, struct vfsmount *mnt, int flags,
 			 const struct cred *cred)
 {
-	int error;
 	struct file *f;
+	struct file *ret;
+	struct path path = { .dentry = dentry, .mnt = mnt };
 
 	validate_creds(cred);
 
 	/* We must always pass in a valid mount pointer. */
 	BUG_ON(!mnt);
 
-	error = -ENFILE;
+	ret = ERR_PTR(-ENFILE);
 	f = get_empty_filp();
-	if (f == NULL) {
-		dput(dentry);
-		mntput(mnt);
-		return ERR_PTR(error);
+	if (f != NULL) {
+		f->f_flags = flags;
+		ret = __dentry_open(&path, f, NULL, cred);
 	}
+	path_put(&path);
 
-	f->f_flags = flags;
-	return __dentry_open(dentry, mnt, f, NULL, cred);
+	return ret;
 }
 EXPORT_SYMBOL(dentry_open);
 
-- 
1.7.7

